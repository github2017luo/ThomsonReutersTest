/********************************************************************************
Class Name : DCPDBCategory 
@description : This code is used in Validate CRUD Permissions
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                 Description
09-07-2021                      Dinesh            DCP-2214 | Initial Creation
26-07-2021                   Vishnu Santhosh      DCP-2870 | Added 'testWestProflexScenario' test method
26-07-2021                   Sudhanshu Upadhayay  DCP-3943 | Added 'testResponseWithBundleProductsFeatures' test method
*********************************************************************************/ 

@isTest
public class DCPDBCategory_test {
    
    @isTest
    static void testPositiveResponse(){
        DCPTestDataFactory.disableApplicationAutomation();
        UnitTest.createTestData();
        
        Product2 testProd =UnitTest.getProductInstance();
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
       
        Apttus_Config2__LineItem__c lineItem = (Apttus_Config2__LineItem__c)sobjectDataMap.get('Apttus_Config2__LineItem__c');
        lineItem.Apttus_Config2__ConfigurationId__c = cart.Id;
        lineItem.Apttus_Config2__LineStatus__c = 'New';
        lineItem.Apttus_Config2__ProductId__c = testProd.Id;
        insert lineItem;       
        
        Digital_Product_Plans__c dpPlan = new Digital_Product_Plans__c();
        dpPlan.Product__c = testProd.Id; 
        dpPlan.Material_Number__c = '12345';
        dpPlan.Subscription_Number__c = '4646464';
        dpPlan.Material_Description__c = 'Test Desc'; 
        dpPlan.SLF_Help_Text__c = 'Test Help Text';
        dpPlan.Additional_Help_Text__c = 'Test Addnl Help Text';
        dpPlan.SLF_Jurisdiction__c = 'Test jurisdiction';
        dpPlan.DB_Category__c = 'Best Value';
        dpPlan.DB_Category_Sort_Order__c = 1;
        dpPlan.DB_Group__c = 'Test';
        dpPlan.DB_Group_Sort_Order__c = 1;
        insert dpPlan;
        
        RestRequest request = new RestRequest();
        request.requestUri = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/digital/renewal/planCompare?' + 'oppId=' + testOpp1.Id + '&ssdId=' + ssd.Id;
        request.httpMethod = 'GET';
        request.addParameter('oppId', testOpp1.Id);
        request.addParameter('ssdId', ssd.Id);
        RestContext.request = request;
 
        DCPPlanCompareResponse res = DCPPlanCompareService.getRenewal();
        System.assertEquals(res.code, 200,'sucess');
    }
        
   @isTest
    static void testNegativeResponse(){
        DCPTestDataFactory.disableApplicationAutomation();
        UnitTest.createTestData();
        
        Product2 testProd =UnitTest.getProductInstance();
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
       
        Apttus_Config2__LineItem__c lineItem = (Apttus_Config2__LineItem__c)sobjectDataMap.get('Apttus_Config2__LineItem__c');
        lineItem.Apttus_Config2__ConfigurationId__c = cart.Id;
        lineItem.Apttus_Config2__LineStatus__c = 'New';
        lineItem.Apttus_Config2__ProductId__c = testProd.Id;
        insert lineItem;       
        
        Digital_Product_Plans__c dpPlan = new Digital_Product_Plans__c();
        dpPlan.Product__c = testProd.Id; 
        dpPlan.Material_Number__c = '12345';
        dpPlan.Subscription_Number__c = '4646464';
        dpPlan.Material_Description__c = 'Test Desc'; 
        dpPlan.SLF_Help_Text__c = 'Test Help Text';
        dpPlan.Additional_Help_Text__c = 'Test Addnl Help Text';
        dpPlan.SLF_Jurisdiction__c = 'Test jurisdiction';
        dpPlan.DB_Category__c = 'Best Value';
        dpPlan.DB_Category_Sort_Order__c = 1;
        dpPlan.DB_Group__c = 'Test';
        dpPlan.DB_Group_Sort_Order__c = 1;
        insert dpPlan;
        
        RestRequest request = new RestRequest();
        request.requestUri = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/digital/renewal/planCompare?' + 'oppId=' + testOpp1.Id + '&ssdId=' + ssd.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
 
        DCPPlanCompareResponse res = DCPPlanCompareService.getRenewal();
        System.assertEquals(res.code, 400,'fail');
    }

    //Testing West Proflex Scenario
    @isTest
    static void testWestProflexScenario(){

        Map<String, SObject> sObjectDataMap = DCPTestDataFactory.declareSObjectData();
        DCPTestDataFactory.disableApplicationAutomation();
        UnitTest.createTestData();
        
        Product2 westProflexProduct = (Product2)sObjectDataMap.get('Product2');
        westProflexProduct.Name = 'West Proflex';
        insert westProflexProduct;

        Product2 product3 = new Product2();
        product3.Name = 'Assoicated West Proflex Product';
        product3.APTS_Product_Pricing_Model__c='Banded';
        insert product3;

        //Standard PricebookEntry
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=westProflexProduct.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=westProflexProduct.id,unitprice=1,UseStandardPrice=false);
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
        
        
        Apttus_Proposal__Proposal__c proposal = (Apttus_Proposal__Proposal__c)sobjectDataMap.get('Apttus_Proposal__Proposal__c');
        proposal.Apttus_Proposal__Opportunity__c = testOpp1.Id;
        proposal.Digital_Quote_Type__c = 'Straight Renewal';

        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c cart = (Apttus_Config2__ProductConfiguration__c)sobjectDataMap.get('Apttus_Config2__ProductConfiguration__c');
        cart.Apttus_QPConfig__Proposald__c = proposal.Id;
        cart.Apttus_Config2__Status__c ='Finalized';
        insert cart;

         //Asset Proposal
        Apttus_Proposal__Proposal__c assetProposal = new Apttus_Proposal__Proposal__c();
        assetProposal.Apttus_Proposal__Proposal_Name__c = 'Asset Proposal';
        assetProposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
        assetProposal.Digital_Quote_Type__c = 'Best Value';
        assetProposal.Digital_Batch_Processed__c = TRUE;
        assetProposal.Apttus_Proposal__Primary__c = FALSE;
        assetProposal.DC_Updated_On_Configurator__c = TRUE;
        assetProposal.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
        assetProposal.APTS_Proposal_Business_Unit__c = 'SCS';
        assetProposal.APTS_Payment_Option__c = 'Bill to Account'; 
        insert assetProposal;
 
        //Asset Proposal Line Item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem1 = new Apttus_Proposal__Proposal_Line_Item__c();
        proposalLineItem1.Apttus_Proposal__Product__c = product3.Id;
        proposalLineItem1.Apttus_Proposal__Proposal__c = assetProposal.Id;
        insert proposalLineItem1;

        //Asset Line Item - West Proflex
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c();
        assetLineItem.Apttus_QPConfig__ProposalId__c=assetProposal.Id;
        assetLineItem.Name = 'West Proflex';
        insert assetLineItem; 
        
        //Cart Line Item
        Apttus_Config2__LineItem__c lineItem = (Apttus_Config2__LineItem__c)sobjectDataMap.get('Apttus_Config2__LineItem__c');
        lineItem.Apttus_Config2__ConfigurationId__c = cart.Id;
        lineItem.Apttus_Config2__LineStatus__c = 'New';
        lineItem.Apttus_Config2__ProductId__c = westProflexProduct.Id;
        lineItem.Apttus_Config2__AssetLineItemId__c=assetLineItem.Id;
        insert lineItem;  
        
        Digital_Product_Plans__c dpPlan = new Digital_Product_Plans__c();
        dpPlan.Product__c = product3.Id; 
        dpPlan.Material_Number__c = '12345';
        dpPlan.Subscription_Number__c = '4646464';
        dpPlan.Material_Description__c = 'Test Desc'; 
        dpPlan.SLF_Help_Text__c = 'Test Help Text';
        dpPlan.Additional_Help_Text__c = 'Test Addnl Help Text';
        dpPlan.SLF_Jurisdiction__c = 'Test jurisdiction';
        dpPlan.DB_Category__c = 'Best Value';
        dpPlan.DB_Category_Sort_Order__c = 1;
        dpPlan.DB_Group__c = 'Test';
        dpPlan.DB_Group_Sort_Order__c = 1;
        insert dpPlan;
        
        RestRequest request = new RestRequest();
        request.requestUri = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/digital/renewal/planCompare?' + 'oppId=' + testOpp1.Id + '&ssdId=' + ssd.Id;
        request.httpMethod = 'GET';
        request.addParameter('oppId', testOpp1.Id);
        request.addParameter('ssdId', ssd.Id);
        RestContext.request = request;
 
        DCPPlanCompareResponse res = DCPPlanCompareService.getRenewal();
        System.assertEquals(res.code, 200,'sucess');
    }
    
       @isTest
    static void testResponseWithBundleProductsFeatures(){
        DCPTestDataFactory.disableApplicationAutomation();
        UnitTest.createTestData();
        
        Product2 testProd =UnitTest.getProductInstance();        
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
         Product2 oProduct = new Product2();
        oProduct.Name = 'Unit Test Product';
        oProduct.isActive = true;
        oProduct.Apttus_Config2__ConfigurationType__c ='Bundle';
        insert oProduct;
        Apttus_Config2__ProductConfiguration__c cart = (Apttus_Config2__ProductConfiguration__c)sobjectDataMap.get('Apttus_Config2__ProductConfiguration__c');
        cart.Apttus_QPConfig__Proposald__c = proposal.Id;cart.Apttus_Config2__Status__c ='Finalized';
        
        insert cart;
       
        Apttus_Config2__LineItem__c lineItem = (Apttus_Config2__LineItem__c)sobjectDataMap.get('Apttus_Config2__LineItem__c');
        lineItem.Apttus_Config2__ConfigurationId__c = cart.Id;
        lineItem.Apttus_Config2__LineStatus__c = 'New';
        lineItem.Apttus_Config2__ProductId__c = oProduct.Id;
        insert lineItem; 
         Apttus_Config2__LineItem__c lineItems = (Apttus_Config2__LineItem__c)sobjectDataMap.get('Apttus_Config2__LineItem__c');
        lineItems.Apttus_Config2__ConfigurationId__c = cart.Id;
        lineItems.Apttus_Config2__LineStatus__c = 'Renewed';
        lineItems.Apttus_Config2__ProductId__c = oProduct.Id;
        lineItems.Id=null;
       // system.debug('lineItems'+lineItems.Id+lineItems);
        insert lineItems;
        
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem1 = new Apttus_Proposal__Proposal_Line_Item__c();
        proposalLineItem1.Apttus_Proposal__Product__c = oProduct.Id;
        proposalLineItem1.Apttus_Proposal__Proposal__c = proposal.Id;
        proposalLineItem1.APTS_Subscription_Number_Override__c = '42070926';
        insert proposalLineItem1;
        // system.debug('proposal line items list size'+proposalLineItemsList.size()); 
        Digital_Product_Plans__c dpPlan = new Digital_Product_Plans__c();
        dpPlan.Product__c = testProd.Id; 
        dpPlan.Material_Number__c = '42070926';
        dpPlan.Subscription_Number__c = '4646464';
        dpPlan.Material_Description__c = 'Test Desc'; 
        dpPlan.SLF_Help_Text__c = 'Test Help Text';
        dpPlan.Additional_Help_Text__c = 'Test Addnl Help Text';
        dpPlan.SLF_Jurisdiction__c = 'Test jurisdiction';
        dpPlan.DB_Category__c = 'Best Value';
        dpPlan.DB_Category_Sort_Order__c = 1;
        dpPlan.DB_Group__c = 'Test';
        dpPlan.DB_Group_Sort_Order__c = 1;
        insert dpPlan;
        
        RestRequest request = new RestRequest();
        request.requestUri = Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/digital/renewal/planCompare?' + 'oppId=' + testOpp1.Id + '&ssdId=' + ssd.Id;
        request.httpMethod = 'GET';
        request.addParameter('oppId', testOpp1.Id);
        request.addParameter('ssdId', ssd.Id);
        RestContext.request = request;
 
        DCPPlanCompareResponse res = DCPPlanCompareService.getRenewal();
        System.assertEquals(res.code, 200,'sucess');
    } 
    
    
    
    
}