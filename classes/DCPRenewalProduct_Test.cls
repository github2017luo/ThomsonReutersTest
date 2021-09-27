/********************************************************************************
Class Name : DCPRenewalProduct_Test 
@description : Test class for DCPRenewalProduct 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                          Developer                     Description
19-07-2021                  Vishnu Santhosh            DCP-2144 | Initial Creation
*********************************************************************************/ 
@isTest
public class DCPRenewalProduct_Test {
    
    @TestSetup
    static void makeData(){
        DCPTestDataFactory.disableApplicationAutomation();

        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        Account acc = (Account)objectToDataMap.get('Account');
        insert acc;
        
        Source_System_Detail__c ssd = (Source_System_Detail__c)objectToDataMap.get('Source_System_Detail__c');
        ssd.Account_Name__c = acc.id;
        insert ssd;
        
        Contact con = (Contact)objectToDataMap.get('Contact');
        con.AccountId = acc.id;
        insert con;
        
        PriceBook2 pricebook = (PriceBook2)objectToDataMap.get('PriceBook2');
        insert pricebook;
        
        Apttus_Config2__PriceList__c pricelist = (Apttus_Config2__PriceList__c)objectToDataMap.get('Apttus_Config2__PriceList__c');
        insert pricelist;

        Product2 prod = (Product2)objectToDataMap.get('Product2'); 
        prod.Name = 'westlaw edge';
        insert prod;
        
        Product2 prod2 = new Product2();
        prod2.Name = 'West Proflex';
        prod2.APTS_Product_Pricing_Model__c='Banded';
        insert prod2;

        Product2 prod3 = new Product2();
        prod3.Name = 'westlaw edge';
        prod3.APTS_Product_Pricing_Model__c='Banded';
        insert prod3;

        Apttus_Config2__PriceListItem__c priceListItem = (Apttus_Config2__PriceListItem__c)objectToDataMap.get('Apttus_Config2__PriceListItem__c');
        priceListItem.Apttus_Config2__PriceListId__c = pricelist.id;
        priceListItem.Apttus_Config2__ProductId__c = prod.id;
        insert priceListItem;
       
        Opportunity opp = (Opportunity)objectToDataMap.get('Opportunity');
        opp.StageName = 'Contacting';
        opp.Renewal_Date__c = system.today().addDays(180);
        opp.Pricebook2id = pricebook.id;
        opp.AccountId = acc.id;
        opp.Source_System_Detail__c = ssd.id;
        opp.Key_Contact__c = con.id;
        insert opp;
 
        Apttus_Proposal__Proposal__c prop = (Apttus_Proposal__Proposal__c)objectToDataMap.get('Apttus_Proposal__Proposal__c');
        prop.Apttus_Proposal__Primary__c = false;
        prop.Digital_Batch_Processed__c = true;
        prop.Digital_Quote_Automation__c = true;
        prop.Apttus_Proposal__Proposal_Name__c = 'Test Proposal';
        prop.Digital_Quote_Type__c = 'Straight Renewal';
        prop.Digital_Envelope_Created__c = false;    
        prop.Apttus_Proposal__Approval_Stage__c = 'Presented';
        prop.Apttus_Proposal__Opportunity__c = opp.id;
        prop.Apttus_Proposal__Account__c = acc.id;
        prop.APTS_SSD_bill_to__c = ssd.id;
        prop.APTS_SSD_ship_to__c = ssd.id;
        prop.Apttus_QPConfig__BillToAccountId__c = acc.id;
        prop.Apttus_QPConfig__ShipToAccountId__c = acc.id;
        prop.APTS_Order_Confirmation_Contact__c = con.id;
        prop.Apttus_QPConfig__PriceListId__c = pricelist.id;
        insert prop;

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
        proposalLineItem1.Apttus_Proposal__Product__c = prod3.Id;
        proposalLineItem1.Apttus_Proposal__Proposal__c = assetProposal.Id;
        insert proposalLineItem1;

        //Asset Line Item - West Proflex
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c();
        assetLineItem.Apttus_QPConfig__ProposalId__c=assetProposal.Id;
        assetLineItem.Name = 'West Proflex';
        insert assetLineItem;
        
        Apttus_Config2__ProductConfiguration__c cart = (Apttus_Config2__ProductConfiguration__c)objectToDataMap.get('Apttus_Config2__ProductConfiguration__c');
        cart.Apttus_Config2__Status__c = 'Finalized';
        cart.Name = 'West Proflex';
        cart.Apttus_QPConfig__Proposald__c = prop.id;
        cart.Apttus_Config2__BusinessObjectId__c = 'Proposal';
        cart.APTS_SSD_bill_to__c = ssd.id;
        cart.APTS_SSD_Ship_To__c = ssd.id;
        cart.Apttus_Config2__BillToAccountId__c = acc.Id;
        cart.Apttus_Config2__ShipToAccountId__c = acc.Id;
        cart.Apttus_Config2__AccountId__c = acc.Id;
        cart.Apttus_Config2__PriceListId__c = pricelist.id;
        insert cart;

        Apttus_Config2__LineItem__c lineItem = (Apttus_Config2__LineItem__c)objectToDataMap.get('Apttus_Config2__LineItem__c');
        lineItem.Apttus_Config2__ConfigurationId__c = cart.id;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ProductId__c = prod2.id;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem.Apttus_Config2__PriceListItemId__c = priceListItem.id;
        lineItem.Apttus_Config2__AssetLineItemId__c=assetLineItem.Id;
        insert lineItem;       
    }

    @isTest static void testSuccessfulScenario(){
        Apttus_Config2__ProductConfiguration__c cart = [SELECT id,APTS_Proposal_Business_Unit__c FROM Apttus_Config2__ProductConfiguration__c];
        Apttus_Proposal__Proposal__c proposal = [SELECT id, Digital_Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c='Test Proposal'];
        List<DCPRenewalProductWrapper> result = new List<DCPRenewalProductWrapper>();

        Test.startTest();
        result =  DCPRenewalProduct.getProductDetails(cart, proposal);
        Test.stopTest();
        System.assertEquals(false, result.isEmpty(),'The returned data from DCPRenewalProduct is not correct');
    }
}