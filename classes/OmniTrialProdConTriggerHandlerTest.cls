@isTest
public class OmniTrialProdConTriggerHandlerTest {
    
    @testSetup static void setup() {
        Account acc = new Account();
        acc.name = 'test acc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
        acc.BU_Region__c = 'Canada';
        acc.Bu_Segment__c = 'Professional Tax';
        acc.Is_GLI__c = true;
        acc.hasActiveTrial__c = false;
        insert acc;
        
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = acc.Id;
        testOpportunity.Name = 'Unit Test Opportuntiy';
        testOpportunity.CloseDate = System.Today() + 5;
        testOpportunity.StageName = 'Prospect';
        
        
        lead ld = new lead();
        ld.LastName = 'Test';
        ld.FirstName = 'fNAME';        
        ld.Status = 'Contacting';
        ld.company='test';
        insert ld;  
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Opportunity__c = testOpportunity.id;
        trl.lead__c = ld.id;
        trl.Trial_Status__c = 'Accepted';
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        insert trl;
        
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlCon.Last_Name__c = 'NET_NEW';
        trlcon.Name= 'Test Name';
        insert trlCon;
        
       
        
        list<Product2> prds = new list<Product2>();
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '753987';
        prds.add(prd);
        
        Product2 prd1 = new Product2();
        prd1.DC_Product_Title__c = 'sample product';
        prd1.Name ='TEST';
        prd1.ProductCode = '753986';
        prds.add(prd1);
        
        insert prds;
        
        list<Trial_Product__c> trlProds =  new list<Trial_Product__c>();
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prds[0].id;
        trprd.Trial__C = trl.id;
        trlProds.add(trprd);
        
        Trial_Product__c trprd1 = new Trial_Product__c();
        trprd1.Product_Name__c = prds[1].id;
        trprd1.Trial__C = trl.id;
        trlProds.add(trprd1);
        
        insert trlProds;
        
        
        
        Trial_Product_Contact__c trlProCon1 = new Trial_Product_Contact__c();
        trlProCon1.Trials__c =trl.id;
        trlProCon1.Trial_Contact__c = trlCon.id;
        trlProCon1.Trial_Product__c = trlProds[0].id;
        trlProCon1.Entitlement_Status__c ='ERROR';
        trlProCon1.Entitlement_Status_Description__c ='Entitlement failed';
        insert trlProCon1;
        
        Trial_Product_Contact__c trlProCon2 = new Trial_Product_Contact__c();
        trlProCon2.Trials__c =trl.id;
        trlProCon2.Trial_Contact__c = trlCon.id;
        trlProCon2.Trial_Product__c = trlProds[1].id;
        trlProCon2.Entitlement_Status__c ='COMPLETE';
        trlProCon2.Entitlement_Status_Description__c ='User is entitled';
        insert trlProCon2;
        
        
        
    }
    
    
    @isTest
    public static void testMethod1(){ 
        Test.startTest();    
        Trial_Contact__c  trlconrec = [select id,Status__c from  Trial_Contact__c limit 1] ;        
        List<Trial_Product_Contact__c> trlProcon = [select id,Entitlement_Status__c,Entitlement_Status_Description__c from Trial_Product_Contact__c where Trial_Contact__r.id = :trlconrec.id limit 2]; 
        
        trlProcon[0].Entitlement_Status__c='ERROR';
        trlProcon[0].Entitlement_Status_Description__c='Entitlement failed';
        trlProcon[1].Entitlement_Status__c='ERROR';
        trlProcon[1].Entitlement_Status_Description__c='Entitlement failed';        
        update trlProcon;
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 1] ;        
        system.assertEquals('Entitlement Error', trlcon[0].Status__c,'SUCCESS');
        Test.stopTest();
    }
    
     @isTest
    public static void testMethod2(){ 
        Test.startTest();    
        Trial_Contact__c  trlconrec = [select id,Status__c from  Trial_Contact__c limit 1] ;        
        List<Trial_Product_Contact__c> trlProcon = [select id,Entitlement_Status__c,Entitlement_Status_Description__c from Trial_Product_Contact__c where Trial_Contact__r.id = :trlconrec.id limit 2]; 
        
        trlProcon[0].Entitlement_Status__c='COMPLETE';
        trlProcon[0].Entitlement_Status_Description__c='User is entitled';
        trlProcon[1].Entitlement_Status__c='COMPLETE';
        trlProcon[1].Entitlement_Status_Description__c='User is entitled';        
        update trlProcon; 
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 1] ;        
        system.assertNotEquals('New', trlcon[0].Status__c,'SUCCESS');
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod3(){ 
        Test.startTest();    
        Trial_Contact__c  trlconrec = [select id,Status__c from  Trial_Contact__c limit 1] ;        
        List<Trial_Product_Contact__c> trlProcon = [select id,Entitlement_Status__c,Entitlement_Status_Description__c from Trial_Product_Contact__c where Trial_Contact__r.id = :trlconrec.id limit 2]; 
        
        trlProcon[0].Entitlement_Status__c='COMPLETE';
        trlProcon[0].Entitlement_Status_Description__c='User access is ended';
        trlProcon[1].Entitlement_Status__c='COMPLETE';
        trlProcon[1].Entitlement_Status_Description__c='User access is ended';        
        update trlProcon;
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 1] ;
        system.assertNotEquals('Active', trlcon[0].Status__c,'SUCCESS');        
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod4(){ 
        Test.startTest();    
        Trial_Contact__c  trlconrec = [select id,Status__c from  Trial_Contact__c limit 1] ;        
        List<Trial_Product_Contact__c> trlProcon = [select id,Entitlement_Status__c,Entitlement_Status_Description__c from Trial_Product_Contact__c where Trial_Contact__r.id = :trlconrec.id limit 2]; 
        
        trlProcon[0].Entitlement_Status__c='COMPLETE';
        trlProcon[0].Entitlement_Status_Description__c='User access is extended';
        trlProcon[1].Entitlement_Status__c='COMPLETE';
        trlProcon[1].Entitlement_Status_Description__c='User access is extended';        
        update trlProcon;
        List<Trial_Contact__c> trlcon = [select id,Status__c,Trials__c from  Trial_Contact__c limit 1] ;
        system.assertNotEquals('Active', trlcon[0].Status__c,'SUCCESS');        
        Test.stopTest();
    }

    
}