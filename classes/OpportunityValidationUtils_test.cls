/*
======================================================================================================================
TEST CLASS NAME: OpportunityValidationUtils_test
======================================================================================================================
PURPOSE: Validates the functionality provided by the OpportunityValidationUtils class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1

======================================================================================================================
*/

@isTest (seealldata=false)  // As part of  s2e Optimisation project making seeAllData as false [Rajashree]
private class OpportunityValidationUtils_test
{
Public static testMethod Void testMethod1(){
       UnitTest.createTestData();   //  As part of  s2e Optimisation project adding test data [Rajashree]   
        Id p1 = [SELECT Id From Profile Where Name = 'System Administrator' LIMIT 1].Id;
        
        User testuser = new User(alias = 'newUser1', email='user1@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p1, employeenumber='0143564',
        timezonesidkey='America/Los_Angeles', username='user.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'LLEY');   
        insert testuser;

        System.RunAs(testuser){
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
         
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = false;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Expiration_Date__c = Date.Today().adddays(370);
        testopp1.Expected_Revenue_Date__c = date.today();
        insert testOpp1;
     
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp1);
        OpportunityValidationUtils OptVal = new OpportunityValidationUtils(sc);
    
        OptVal.Validatesub();
        testopp1.Expiration_Date__c = Date.Today();
        testopp1.Expected_Revenue_Date__c = date.today().adddays(370);
        update testOpp1;
        ApexPages.StandardController sc1 = new ApexPages.StandardController(testOpp1);
        OpportunityValidationUtils OptVal1 = new OpportunityValidationUtils(sc1);
         OptVal1.Validatesub();
    }
        
}
Public static testMethod Void testMethod2(){
       UnitTest.createTestData();  //  As part of  s2e Optimisation project adding test data [Rajashree]   
        
        Id p1 = [SELECT Id From Profile Where Name = 'System Administrator' LIMIT 1].Id;
        
        User testuser = new User(alias = 'newUser1', email='user1@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p1, employeenumber='0143564',
        timezonesidkey='America/Los_Angeles', username='user.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'BEJE');   
        insert testuser;
     
        System.RunAs(testuser){
         Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
   
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = false;
       
        testopp1.Expected_Revenue_Date__c = date.valueOf('2016-10-02');
        testopp1.Expiration_Date__c = date.valueOf('2016-12-01');
        
        insert testOpp1;
            
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp1);
        OpportunityValidationUtils OptVal = new OpportunityValidationUtils(sc);
        
        OptVal.Validatesub();
        
        }        
}
Public static testMethod Void testMethod3(){
       UnitTest.createTestData();   //  As part of  s2e Optimisation project adding test data [Rajashree]   
        
        Id p1 = [SELECT Id From Profile Where Name = 'System Administrator' LIMIT 1].Id;
        
        User testuser = new User(alias = 'newUser1', email='user1@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p1, employeenumber='0143564',
        timezonesidkey='America/Los_Angeles', username='user.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'LLEY');   
        insert testuser;
        
        System.RunAs(testuser){
            
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;
         
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Renewal_Flag__c = false;
        testOpp1.Selling_Organization__c = 'LRA';
        testopp1.Expected_Revenue_Date__c = date.valueOf('2016-10-01');
        testopp1.Expiration_Date__c = date.valueOf('2016-12-31');
        
        insert testOpp1;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testOpp1);
        OpportunityValidationUtils OptVal = new OpportunityValidationUtils(sc);
                    
        OptVal.Validatesub();
             
    }
}
   
}