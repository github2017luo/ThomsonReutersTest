@isTest
global class ProviewEntitlementCallOutTest{
     static testmethod void testSendRequest1()
    {
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        //assConSize acs = new assConSize();        
        Account testAcc1 = new Account();
        testAcc1 = UnitTest.getAccountInstance();
        //testAcc.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
        testAcc1.SAPAccountNumber__c = '1004879124';       
        insert testAcc1;
        Contact testcontact1= UnitTest.getContactInstance(testAcc1.Id);
        testcontact1.LastName = 'testContact';
        testcontact1.FirstName = 'testContact';
        testcontact1.AccountId = testAcc1.Id;
        testcontact1.email = 'testfirst.testlast@thomson.com';
        testcontact1.SAP_Contact_ID__c = null;
        system.assertEquals(testcontact1.email == 'testfirst.testlast@thomson.com', true);
        insert testcontact1;
        Opportunity testOpp11 = new Opportunity();
        testOpp11 = UnitTest.getOpportunityInstance(testAcc1.Id);
        testOpp11.StageName = '75%';
        //testOpp1.RecordTypeId = orecordType1;
        insert testOpp11;
        List<Opportunitylineitem> lstOppLineItem = new List<Opportunitylineitem>();
        Product2 testProd1 =UnitTest.getProductInstance();
        testProd1.ProductCode = '456789';
        testProd1.Entitlement_Oneshot__c = true;
        insert testProd1;
        
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;
        OpportunityProductDetail__c opd1 = new OpportunityProductDetail__c(Opportunity__c=testOpp11.id, Product__c=testProd1.id);
        insert opd1;
        Opportunity_Product_Detail_Contact__c opdc11 = new Opportunity_Product_Detail_Contact__c(Product_Detail__c = opd1.id, Email__c = testcontact1.email);
        insert opdc11;
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        OpportunityLineItem testLineItem3 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        lstOppLineItem.add(testLineItem1); 
        lstOppLineItem.add(testLineItem2); 
        lstOppLineItem.add(testLineItem3);
        insert lstOppLineItem;
        
        Quote Q2 = New Quote();
        Q2.OpportunityId = Testopp11.id;
        Q2.Pricebook2Id = Test.getStandardPricebookId();
        Q2.Name = 'Test Quote';
        Q2.Primary_Quote__c = true;
        Q2.Entitlement_Path__c = 'Post Order';
        Q2.Status = 'Order Completed';
        Q2.Sold_To_Contact__c = testcontact1.id;
        Q2.Create_Token_for_Unused_Product_Quantity__c = 'Single Use Token';
        insert Q2;
        
        Quote quo = [select quotenumber from Quote where id=: Q2.Id Limit 1];
        //System.debug('&quoteno&'+[select id,quotenumber from Quote where id=: Q2.Id]); 
        WebServiceSettings__c webservc = new WebServiceSettings__c();
        webservc.Name = 'ProviewManageEntitlement';
        webservc.Active__c = true;
        webservc.Endpoint__c = 'abc';
        webservc.Password__c = '1235';
        webservc.Timeout__c = 100;
        webservc.Username__c = 'abc';
        webservc.Service_Unavailable_Message__c = 'abc111';
        INSERT webservc;      
        
        KeyValueListStore__c oKeyValue = new KeyValueListStore__c();
        oKeyValue.name = 'ProviewRequestApplicationId';       
        oKeyValue.TextValue__c = 'SF06';
        INSERT oKeyValue;
        
        KeyValueListStore__c oKeyValue1 = new KeyValueListStore__c();
        oKeyValue1.name = 'BigRuleCconfigGroup';       
        oKeyValue1.TextValue__c = 'LLEY';
        INSERT oKeyValue1;
        
        IXOSCodeMap__c csContactFields=new IXOSCodeMap__c();
        csContactFields.Name='WEST';//Static record 1 of custom setting
        csContactFields.Company_Code__c='0010';
        csContactFields.Dist_Chan_Code__c='W';
        csContactFields.Division_Code__c='W';
        csContactFields.Sales_Org_Code__c='West';
        insert csContactFields;
        
        //Test.setMock(HttpCalloutMock.class, new MockProviewEntitlementCallOutTest());
        Test.startTest();
        ProviewEntitlementCallOut.SendRequest(Q2.id);
        Q2.Create_Token_for_Unused_Product_Quantity__c = 'Multi Use Token';
        update Q2;
        ProviewEntitlementCallOut.SendRequest(Q2.id);
        Test.stopTest(); 
        //Test.setMock(HttpCalloutMock.class, new MockProviewEntitlementCallOutTest()); 
        Restrequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/proviewpostback';
        req.httpMethod='Post';
String s = '{"onlineContact" : [ {"firstName" : "HARMAN","lastName" : "CHAURASIA","email" : "rajashree.behera@thomsonreuters.com","sourceId" : "SF06","account" : {"companyId" : "LLEY" },"entitlements" : [ {"tokenDetails" : [ {"tokenNumber" : "dMwIMe6qzvewpFtt","description" : "'+Quo.Quotenumber+'_1005004610","url" : "http://redemptionservice.com/redeem/dMwIMe6qzvewpFtt"} ],"subscriptions" : [ {"materialNumber" : [ {"materialNumber" :"000000000042044448"} ]} ] } ],"Notification" : {"statusCode" : "\'Success\'","statusDescription" : "\'Token Created\'"}}, { "contactId" : "0016079445","firstName" : "PV","lastName" : "test","email" : "saumya.ranjan@thomsonreuters.com","sourceId" : "SF06","account" : {"companyId" : "LLEY"},"entitlements" : [ {"tokenDetails" : [ {"tokenNumber" : "m7sPOpE9UVxqGLkA","description" : "'+Quo.Quotenumber+'_1005004610","url" : "http://redemptionservice.com/redeem/m7sPOpE9UVxqGLkA"} ],"subscriptions" : [{"materialNumber" : [ {"materialNumber" : "000000000042044448"} ]} ]} ],"Notification" : {"statusCode" : "\'Success\'","statusDescription" : "\'Token Created\'"}},{"sourceId" : "SF06",    "account" : {"companyId" : "LLEY"},"entitlements": [{"tokenDetails" : [ {"tokenNumber" : "sVn2WEu02Ws9D9cG","description" : "'+Quo.Quotenumber+'_1005004610","url" : "https://token.proviewsites.qa.int.thomsonreuters.com?token=sVn2WEu02Ws9D9cG"}],"resources" : [{"resourceId" : [ "LALEY/2015/41815291/V1" ],"feature" : [ "READ" ],"endDate" : "9999-12-31"}, { "resourceId" : ["LALEY/2015/41815292/V1" ],"feature" : [ "READ" ],"endDate" : "9999-12-31"}],      "subscriptions":[{"materialNumber" :[{"materialNumber" : "42020175","classificationValue" : "3","quantity" : "1"} ]}]}],"Notification" : {      "statusCode" : "\'Success\'","statusDescription" : "\'Token Created\'"}}],"Notification" : {"statusCode" : "Success","statusDescription" : "Token has been created OR Resources has been added successfully"}}';
        req.requestBody=Blob.valueOf(s);
        Restcontext.request = req;
        Restcontext.response = res;
        proviewPostback.doPost(); 
    }
    @isTest static void testSendRequest2()
    {
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        //assConSize acs = new assConSize();        
        Account testAcc1 = new Account();
        testAcc1 = UnitTest.getAccountInstance();
        //testAcc.RecordTypeId = RecordtypeIds__c.getValues('Customer').recTypeId__c; 
        testAcc1.SAPAccountNumber__c = '1004879124';       
        insert testAcc1;
        Contact testcontact1= UnitTest.getContactInstance(testAcc1.Id);
        testcontact1.LastName = 'testContact';
        testcontact1.FirstName = 'testContact';
        testcontact1.AccountId = testAcc1.Id;
        testcontact1.email = 'testfirst.testlast@thomson.com';
        testcontact1.SAP_Contact_ID__c = null;
        system.assertEquals(testcontact1.email == 'testfirst.testlast@thomson.com', true);
        insert testcontact1;
        Opportunity testOpp11 = new Opportunity();
        testOpp11 = UnitTest.getOpportunityInstance(testAcc1.Id);
        testOpp11.StageName = '75%';
        //testOpp1.RecordTypeId = orecordType1;
        insert testOpp11;
        List<Opportunitylineitem> lstOppLineItem = new List<Opportunitylineitem>();
        Product2 testProd1 =UnitTest.getProductInstance();
        testProd1.ProductCode = '456789';
        testProd1.Entitlement_Oneshot__c = true;
        insert testProd1;
        
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;
        OpportunityProductDetail__c opd1 = new OpportunityProductDetail__c(Opportunity__c=testOpp11.id, Product__c=testProd1.id);
        insert opd1;
        Opportunity_Product_Detail_Contact__c opdc11 = new Opportunity_Product_Detail_Contact__c(Product_Detail__c = opd1.id, Email__c = testcontact1.email);
        insert opdc11;
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        OpportunityLineItem testLineItem2 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        OpportunityLineItem testLineItem3 = new OpportunityLineItem(opportunityId=testOpp11.id,PricebookEntryId=testEntry1.id,unitprice=100,Quantity=3, Revenue_Type__c ='Renewal');
        lstOppLineItem.add(testLineItem1); 
        lstOppLineItem.add(testLineItem2); 
        lstOppLineItem.add(testLineItem3);
        insert lstOppLineItem;
        
        Quote Q3 = New Quote();
        Q3.OpportunityId = Testopp11.id;
        Q3.Pricebook2Id = Test.getStandardPricebookId();
        Q3.Name = 'Test Quote';
        Q3.Primary_Quote__c = true;
        Q3.Entitlement_Path__c = 'Post Order';
        Q3.Status = 'Order Completed';
        Q3.Sold_To_Contact__c = testcontact1.id;
        Q3.Create_Token_for_Unused_Product_Quantity__c = 'Single Use Token Consolidated';
        insert Q3;
          
        WebServiceSettings__c webservc = new WebServiceSettings__c();
        webservc.Name = 'ProviewManageEntitlement';
        webservc.Active__c = true;
        webservc.Endpoint__c = 'abc';
        webservc.Password__c = '1235';
        webservc.Timeout__c = 100;
        webservc.Username__c = 'abc';
        webservc.Service_Unavailable_Message__c = 'abc111';
        INSERT webservc;      
        
        KeyValueListStore__c oKeyValue = new KeyValueListStore__c();
        oKeyValue.name = 'ProviewRequestApplicationId';       
        oKeyValue.TextValue__c = 'SF06';
        INSERT oKeyValue;
        
        KeyValueListStore__c oKeyValue1 = new KeyValueListStore__c();
        oKeyValue1.name = 'BigRuleCconfigGroup';       
        oKeyValue1.TextValue__c = 'LLEY';
        INSERT oKeyValue1;
        
        IXOSCodeMap__c csContactFields=new IXOSCodeMap__c();
        csContactFields.Name='WEST';//Static record 1 of custom setting
        csContactFields.Company_Code__c='0010';
        csContactFields.Dist_Chan_Code__c='W';
        csContactFields.Division_Code__c='W';
        csContactFields.Sales_Org_Code__c='West';
        insert csContactFields;
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockProviewEntitlementCallOutTest());
        ProviewEntitlementCallOut.SendRequest(Q3.id);
        
        Q3.Create_Token_for_Unused_Product_Quantity__c = 'Multi Use Token Consolidated';
        update Q3;
        //Test.setMock(HttpCalloutMock.class, new MockProviewEntitlementCallOutTest());
        ProviewEntitlementCallOut.SendRequest(Q3.id);
        Test.stopTest();
    }
}