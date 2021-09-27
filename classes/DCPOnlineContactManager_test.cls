/********************************************************************************
Class Name : DCPOnlineContactManager_test 
@description : This code is used in online contacts manage
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                 Description
19-07-2021                      Dinesh            DCP-2598 | Initial Creation
*********************************************************************************/ 
@isTest
public class DCPOnlineContactManager_test {

    @isTest
    static void testCreateOnlineContacts(){
        DCPTestDataFactory.disableApplicationAutomation();
        UnitTest.createTestData();
        
        Product2 testProd =UnitTest.getProductInstance();
        testProd.Apttus_Config2__ConfigurationType__c = 'Bundle';
        insert testProd;        
        //Standard PricebookEntry
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;        
        //Account data
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;        
        //Contact data
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'Testcontact';
        testcontact.FirstName = 'Testcontact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;    
       
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        ssd.Account_Name__c = testAcc.Id;
        ssd.name= 'test';
        ssd.Source_System_Name__c='test';
        insert ssd;
        //Opportunity data: set1(standard pricebook)
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Name = 'Test Opp1';
        testOpp1.Key_Contact__c = testcontact.Id;
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.currencyIsoCode = 'USD';
        testOpp1.Pricebook2Id = testEntry.Pricebook2Id;
        testOpp1.Sales_Org__c = 'TSL';
        testOpp1.Renewal_Date__c = system.today().addDays(180);
        testOpp1.Source_System_Detail__c = ssd.Id;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
        
        Map<String, SObject> sObjectDataMap = DCPTestDataFactory.declareSObjectData();
        
        Apttus_Proposal__Proposal__c proposal = (Apttus_Proposal__Proposal__c)sobjectDataMap.get('Apttus_Proposal__Proposal__c');
        proposal.Apttus_Proposal__Opportunity__c = testOpp1.Id;
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c cart = (Apttus_Config2__ProductConfiguration__c)sobjectDataMap.get('Apttus_Config2__ProductConfiguration__c');
        cart.Apttus_QPConfig__Proposald__c = proposal.Id;
        insert cart;
       
        Apttus_Proposal__Proposal_Line_Item__c lineItem = (Apttus_Proposal__Proposal_Line_Item__c)sobjectDataMap.get('Apttus_Proposal__Proposal_Line_Item__c');
        lineItem.Apttus_Proposal__Proposal__c = proposal.Id;
        lineItem.APTS_Service_Number_Override__c = 'test';
        lineItem.Apttus_Proposal__Product__c = testProd.Id;
        insert lineItem;
        
        RestRequest request = new RestRequest();
        request.requestURI = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/digital/onlinecontacts/';
        request.httpMethod = 'POST';
        //request.requestBody = '{"updateDetails" : {"quoteId": "1234","materialNumber": "2345","onlineContacts": [{"contactId": "12345", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123456", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123477", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}],"productDetails": [{"productId": "18DigitProductId", "productQuantity": 3}, {"productId": "18DigitProductId", "productQuantity": 2}],"operationType": "delete"}}';
        RestContext.request = request;
        
        String body = '{"quoteId": "' + proposal.Id +'","materialNumber": "2345","onlineContacts": [{"contactId": "12345", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123456", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123477", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}],"productDetails": [{"productId": "'+ testProd.Id + '", "productQuantity": 3}],"operationType": "create"}';
 
        DCPServiceResponse res = DCPOnlineContactManager.addOnlineContacts((DCPOnlineContactManager.OLCRequest)JSON.deserialize(body, DCPOnlineContactManager.OLCRequest.class));
        System.assertEquals(res.code, 200,'sucess');
    }
    
    @isTest
    static void testCreateOnlineContactsNegative(){        
        
        String body = '{"quoteId": "","materialNumber": "2345","onlineContacts": [{"contactId": "12345", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123456", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123477", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}],"productDetails":null,"operationType": "create"}';
 
        DCPServiceResponse res = DCPOnlineContactManager.addOnlineContacts((DCPOnlineContactManager.OLCRequest)JSON.deserialize(body, DCPOnlineContactManager.OLCRequest.class));
        System.assertEquals(res.code, 400,'Fail');
    }
    
    @isTest
    static void testCreateOnlineContactsNoPayload(){        
        DCPServiceResponse res = DCPOnlineContactManager.addOnlineContacts(null);
        System.assertEquals(res.code, 400,'Fail');
    }
    
    @isTest
    static void testCreateOnlineContactsOperationTypeNull(){        
        
        String body = '{"quoteId": "","materialNumber": "2345","onlineContacts": [{"contactId": "12345", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123456", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123477", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}],"productDetails":null,"operationType": ""}';
 
        DCPServiceResponse res = DCPOnlineContactManager.addOnlineContacts((DCPOnlineContactManager.OLCRequest)JSON.deserialize(body, DCPOnlineContactManager.OLCRequest.class));
        System.assertEquals(res.code, 400,'Fail');
    }
    
    @isTest
    static void testDeleteOnlineContactsPositive(){
        DCPTestDataFactory.disableApplicationAutomation();
        UnitTest.createTestData();
        
        Product2 testProd =UnitTest.getProductInstance();
        testProd.Apttus_Config2__ConfigurationType__c = 'Bundle';
        insert testProd;        
        //Standard PricebookEntry
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;        
        //Account data
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;        
        //Contact data
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'Testcontact';
        testcontact.FirstName = 'Testcontact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;    
       
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        ssd.Account_Name__c = testAcc.Id;
        ssd.name= 'test';
        ssd.Source_System_Name__c='test';
        insert ssd;
        //Opportunity data: set1(standard pricebook)
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Name = 'Test Opp1';
        testOpp1.Key_Contact__c = testcontact.Id;
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.currencyIsoCode = 'USD';
        testOpp1.Pricebook2Id = testEntry.Pricebook2Id;
        testOpp1.Sales_Org__c = 'TSL';
        testOpp1.Renewal_Date__c = system.today().addDays(180);
        testOpp1.Source_System_Detail__c = ssd.Id;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
        
        Map<String, SObject> sObjectDataMap = DCPTestDataFactory.declareSObjectData();
        
        Apttus_Proposal__Proposal__c proposal = (Apttus_Proposal__Proposal__c)sobjectDataMap.get('Apttus_Proposal__Proposal__c');
        proposal.Apttus_Proposal__Opportunity__c = testOpp1.Id;
        insert proposal;
        
        Online_Contacts__c olc = new Online_Contacts__c();
        olc.First_Name__c = 'Test';
        olc.Last_Name__c = 'LastName';
        olc.Email__c = 'test@test.com';
        olc.ContactID__c = '12345';
        olc.QuoteId__c = proposal.Id;
        insert olc;
        
        
        RestRequest request = new RestRequest();
        request.requestURI = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/digital/onlinecontacts/';
        request.httpMethod = 'POST';
        //request.requestBody = '{"updateDetails" : {"quoteId": "1234","materialNumber": "2345","onlineContacts": [{"contactId": "12345", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123456", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123477", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}],"productDetails": [{"productId": "18DigitProductId", "productQuantity": 3}, {"productId": "18DigitProductId", "productQuantity": 2}],"operationType": "delete"}}';
        RestContext.request = request;
        
        String body = '{"quoteId": "' + proposal.Id +'","materialNumber": "2345","onlineContacts": [{"contactId": "12345", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123456", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}, {"contactId": "123477", "firstName": "Test", "lastName": "Test Last", "email" : "test@test.com", "onlineContactTypeDescription": "Test Desc"}],"productDetails": [{"productId": "18DigitProductId", "productQuantity": 3}, {"productId": "18DigitProductId", "productQuantity": 2}],"operationType": "delete"}';
 
        DCPServiceResponse res = DCPOnlineContactManager.addOnlineContacts((DCPOnlineContactManager.OLCRequest)JSON.deserialize(body, DCPOnlineContactManager.OLCRequest.class));
        System.assertEquals(res.code, 200,'sucess');
    }
    
    
    @isTest
    static void testDeleteOnlineContactsNegative(){
        
        String body = '{"quoteId": "1234","materialNumber": "2345","onlineContacts": [],"productDetails": [{"productId": "18DigitProductId", "productQuantity": 3}, {"productId": "18DigitProductId", "productQuantity": 2}],"operationType": "delete"}';
 
        DCPServiceResponse res = DCPOnlineContactManager.addOnlineContacts((DCPOnlineContactManager.OLCRequest)JSON.deserialize(body, DCPOnlineContactManager.OLCRequest.class));
        System.assertEquals(res.code, 400, 'Fail');
    }
    
    @isTest
    static void testGetOnlineContactsPositive(){
        DCPTestDataFactory.disableApplicationAutomation();
        UnitTest.createTestData();
        
        Product2 testProd =UnitTest.getProductInstance();
        testProd.Apttus_Config2__ConfigurationType__c = 'Bundle';
        insert testProd;        
        //Standard PricebookEntry
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;        
        //Account data
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;        
        //Contact data
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'Testcontact';
        testcontact.FirstName = 'Testcontact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;    
       
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        ssd.Account_Name__c = testAcc.Id;
        ssd.name= 'test';
        ssd.Source_System_Name__c='test';
        insert ssd;
        //Opportunity data: set1(standard pricebook)
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Name = 'Test Opp1';
        testOpp1.Key_Contact__c = testcontact.Id;
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.currencyIsoCode = 'USD';
        testOpp1.Pricebook2Id = testEntry.Pricebook2Id;
        testOpp1.Sales_Org__c = 'TSL';
        testOpp1.Renewal_Date__c = system.today().addDays(180);
        testOpp1.Source_System_Detail__c = ssd.Id;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
        
        Map<String, SObject> sObjectDataMap = DCPTestDataFactory.declareSObjectData();
        
        Apttus_Proposal__Proposal__c proposal = (Apttus_Proposal__Proposal__c)sobjectDataMap.get('Apttus_Proposal__Proposal__c');
        proposal.Apttus_Proposal__Opportunity__c = testOpp1.Id;
        insert proposal;
        
        Online_Contacts__c olc = new Online_Contacts__c();
        olc.First_Name__c = 'Test';
        olc.Last_Name__c = 'LastName';
        olc.Email__c = 'test@test.com';
        olc.ContactID__c = '12345';
        olc.QuoteId__c = proposal.Id;
        insert olc;
        
        
        RestRequest request = new RestRequest();
        request.requestURI = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/digital/onlinecontacts/';
        request.httpMethod = 'GET';
        request.addParameter('proposalid', proposal.Id);
        RestContext.request = request;
 
        DCPOnlineContactManager.OLCResponse res = DCPOnlineContactManager.getOnlinecontacts();
        System.assertEquals(res.code, 200,'success');
        System.assert(res.Data != null, 'Success');
    }
    
    @isTest
    static void testGetOnlineContactsNegative(){
        RestRequest request = new RestRequest();
        request.requestURI = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/digital/onlinecontacts/';
        request.httpMethod = 'GET';
        RestContext.request = request;
 
        DCPOnlineContactManager.OLCResponse res = DCPOnlineContactManager.getOnlinecontacts();
        System.assertEquals(res.code, 400,'Failure');
        System.assert(res.Data == null, 'Failure');
    }
}