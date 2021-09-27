@istest(seeAllData=false)
public with sharing class ODTDG_ProcessBuilderTest {


/********************************************************************************************************
*  @description method1: this is the test method to check ODTDG Trial Lead Update process builder 
*********************************************************************************************************/
    public static testmethod void method1() {
    
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore'; 
        acc.billingstate= 'AK';
        acc.BillingpostalCode='21204';
        insert acc;
        
        ent_Trial__c trc= new ent_Trial__c();
        trc.account__c = acc.id;
        trc.Trial_Start_Date__c  =system.today();
        trc.Trial_End_Date__c = system.today();
        trc.External_Account_Number__c = '4332938';
        trc.External_Account_Number_Source__c = 'SAP';
        insert trc;
        
        list<Trial_Contact__c> trialContacts = new list<Trial_Contact__c>();
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'mallik.rao2@mailinator.com';
        trlCon.Trials__c = trc.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlcon.Name= 'Test Name';
        trlcon.External_Contact_Number_Source__c= 'SAP';
        trlCon.Primary__c=true;
        trialContacts.add(trlCon);
/*
        Trial_Contact__c trlCon1 = new Trial_Contact__c();
        trlCon1.Email__c = 'get2arpit@me.com';
        trlCon1.Trials__c = trl.id;
        trlCon1.name = 'test';
        trlCon1.Status__c  = 'Draft';
        trlCon1.First_Name__c = 'Fname';
        trlCon1.Last_Name__c = 'lname';
        trlcon1.Name= 'Test Name';
        trlcon1.External_Contact_Number_Source__c= 'OLC';
        trlCon.Primary__c=false;
        trialContacts.add(trlCon1);
*/
        insert trialContacts;
        
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '42514196';
        prd.Product_Offering__c='Westlaw Edge';
        prd.free_trial__c = 'Digital';
        insert prd;
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trc.id;
        trprd.Name= 'Test Name';
        insert trprd;
        
        Product_Relationship__c p1 = new Product_Relationship__c();
        p1.Product_to__c = prd.Id;
        p1.Product_from__c = prd.Id;
        p1.Segment__c = 'In-house counsel';
        p1.Relationship_Link_Type__c ='best';
        p1.Relationship_Type__c = 'plan to plan';
        insert p1;
        
        Trial_Contact__c contact = [SELECT Id, Lead__c FROM Trial_Contact__c WHERE ID = :trlCon.id];
        System.debug(LoggingLevel.INFO,'contact before..... '+contact);

        ent_Trial__c trial = [SELECT Id, Lead__c FROM ent_Trial__c WHERE ID = :trc.id];
        System.debug(LoggingLevel.INFO,'trials before.... '+trial);

        
// Eloqua Updates the lead
        Lead l = new lead();
        l.FirstName='test11';
        l.LastName='test12';
        l.Company='xyzz';
        insert l;

        trlCon.Lead__c=l.ID;
        update trlCon;


        ent_Trial__c trialnew = [SELECT Id, Lead__c FROM ent_Trial__c WHERE ID = :trc.id];
        System.debug(LoggingLevel.INFO,'trials after.... '+trialnew);

        Trial_Contact__c contactnew = [SELECT Id, Lead__c FROM Trial_Contact__c WHERE ID = :trlCon.ID];
        System.debug(LoggingLevel.INFO,'contact after.... '+contactnew);

        System.assertEquals(trialnew.Lead__c,contactnew.Lead__c,'Lead Not Updated');

    }

}