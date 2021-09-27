@isTest(seeAllData=false)
public with sharing class ODTDG_RetrieveAddedUsersTest {


/********************************************************************************************************
*  @description method1: this is the test method to check ODTDG Retrieve added users
*********************************************************************************************************/
    @isTest
    static void method1() {
        
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
        trlCon.One_Pass_ID__c='A00001';
        trialContacts.add(trlCon);

        Trial_Contact__c trlCon1 = new Trial_Contact__c();
        trlCon1.Email__c = 'get2arpit@me.com';
        trlCon1.Trials__c = trc.id;
        trlCon1.name = 'test';
        trlCon1.Status__c  = 'Draft';
        trlCon1.First_Name__c = 'Fname';
        trlCon1.Last_Name__c = 'lname';
        trlcon1.Name= 'Test Name';
        trlcon1.External_Contact_Number_Source__c= 'OLC';
        trlCon1.Primary__c=false;
        trlCon1.One_Pass_ID__c='A00002';
        trialContacts.add(trlCon1);

        Trial_Contact__c trlCon2 = new Trial_Contact__c();
        trlCon2.Email__c = 'get2arpit2@me.com';
        trlCon2.Trials__c = trc.id;
        trlCon2.name = 'test2';
        trlCon2.Status__c  = 'Draft';
        trlCon2.First_Name__c = 'Fname2';
        trlCon2.Last_Name__c = 'lname2';
        trlcon2.Name= 'Test Name2';
        trlcon2.External_Contact_Number_Source__c= 'OLC';
        trlCon2.Primary__c=false;
        trlCon2.One_Pass_ID__c='A00003';
        trialContacts.add(trlCon2);

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

        Test.startTest();
        // Forming the request
        RestRequest primaryUser = new RestRequest();
        primaryUser.requestUri = '/services/apexrest/ODTDGCountryStates';
        primaryUser.addParameter('onePassId', 'A00001');
        //contactRequest.addParameter('productCode', '');
        primaryUser.httpMethod = 'GET';
        RestContext.request = primaryUser;

        // Testing the API
        List<ODTDG_RetrieveAddedUsers.UserDetails> res1 = ODTDG_RetrieveAddedUsers.retrieveUsersData(); 
        System.debug(LoggingLevel.INFO,'res1..... '+res1);       
        System.assert(res1 != null,'Value is Null');
       
        RestRequest inviteUser = new RestRequest();
        inviteUser.requestUri = '/services/apexrest/ODTDGCountryStates';
        inviteUser.addParameter('onePassId', 'A00002');
        //contactRequest.addParameter('productCode', '');
        inviteUser.httpMethod = 'GET';
        RestContext.request = inviteUser;

        // Testing the API
        List<ODTDG_RetrieveAddedUsers.UserDetails> res2 = ODTDG_RetrieveAddedUsers.retrieveUsersData(); 
        System.debug(LoggingLevel.INFO,'res2..... '+res2); 
        
        
        RestRequest inviteUser2 = new RestRequest();
        inviteUser2.requestUri = '/services/apexrest/ODTDGCountryStates';
        inviteUser2.addParameter('onePassId', 'A00003');
        //contactRequest.addParameter('productCode', '');
        inviteUser2.httpMethod = 'GET';
        RestContext.request = inviteUser2;

        // Testing the API
        List<ODTDG_RetrieveAddedUsers.UserDetails> res3 = ODTDG_RetrieveAddedUsers.retrieveUsersData(); 
        System.debug(LoggingLevel.INFO,'res3..... '+res3); 


        Test.stopTest();
                
        
    }
}