@isTest
public class DCPRenewalProposal_Test{
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
        
        Apttus_Config2__ProductConfiguration__c cart = (Apttus_Config2__ProductConfiguration__c)objectToDataMap.get('Apttus_Config2__ProductConfiguration__c');
        cart.Apttus_Config2__Status__c = 'Finalized';
        cart.Apttus_QPConfig__Proposald__c = prop.id;
        cart.Apttus_Config2__BusinessObjectId__c = 'Proposal';
        cart.APTS_SSD_bill_to__c = ssd.id;
        cart.APTS_SSD_Ship_To__c = ssd.id;
        cart.Apttus_Config2__BillToAccountId__c = acc.Id;
        cart.Apttus_Config2__ShipToAccountId__c = acc.Id;
        cart.Apttus_Config2__AccountId__c = acc.Id;
        cart.Apttus_Config2__PriceListId__c = pricelist.id;
        insert cart;
        
        Product2 prod = (Product2)objectToDataMap.get('Product2'); 
        insert prod;
        
        Apttus_Config2__PriceListItem__c priceListItem = (Apttus_Config2__PriceListItem__c)objectToDataMap.get('Apttus_Config2__PriceListItem__c');
        priceListItem.Apttus_Config2__PriceListId__c = pricelist.id;
        priceListItem.Apttus_Config2__ProductId__c = prod.id;
        insert priceListItem;

        Apttus_Config2__LineItem__c lineItem = (Apttus_Config2__LineItem__c)objectToDataMap.get('Apttus_Config2__LineItem__c');
        lineItem.Apttus_Config2__ConfigurationId__c = cart.id;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ProductId__c = prod.id;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem.Apttus_Config2__PriceListItemId__c = priceListItem.id;
        insert lineItem;
    }

    @isTest
    public static void getProposalTest(){
        List<Apttus_Proposal__Proposal__c> propList;
        List<Apttus_Config2__ProductConfiguration__c> cartList;
        Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap = new Map<String,Apttus_Config2__ProductConfiguration__c>();
        Opportunity opp = [SELECT id, Renewal_Date__c FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c WHERE Name = 'ABC' LIMIT 1];
        
        propList = DCPProposal.getPresentedProposal(opp.Id,ssd.Id);
        cartList = DCPCart.getFinalizeCartFromProposal(propList);
        
        DCPRenewalSetting.getRenewalSetting();
        
        for(Apttus_Config2__ProductConfiguration__c cart : cartList){
            proposalIDToCartMap.put(cart.Apttus_QPConfig__Proposald__c, cart);
        }
        
        Test.startTest();
        List<DCPRenewalProposalWrapper> proposalData = DCPRenewalProposal.getProposalDetails(propList,proposalIDToCartMap, opp);
        System.assert(proposalData != null, 'No proposal data returned');
        Test.stopTest();
    }    
    
    @isTest
    public static void getFindlawProposalTest(){
        List<Apttus_Proposal__Proposal__c> propList;
        List<Apttus_Config2__ProductConfiguration__c> cartList;
        Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap = new Map<String,Apttus_Config2__ProductConfiguration__c>();
        Opportunity opp = [SELECT id, Renewal_Date__c FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c WHERE Name = 'ABC' LIMIT 1];
        
        APTS_Attribute_Value_Combination__c productDetail = new APTS_Attribute_Value_Combination__c();
        insert productDetail;
        
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c();
        asset.Apttus_Config2__Quantity__c = 1;
        asset.Apttus_Config2__Description__c = '';
        asset.Apttus_Config2__NetPrice__c = 100;
        asset.Apttus_Config2__AssetStatus__c = 'Activated';
        asset.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        insert asset;

        List<Apttus_Config2__LineItem__c> lineItemList = [SELECT id, APTS_Combination_Key__c FROM Apttus_Config2__LineItem__c LIMIT 100];
        for(Apttus_Config2__LineItem__c lineItem : lineItemList){
            lineItem.APTS_Combination_Key__c = productDetail.id;
            lineItem.Apttus_Config2__AssetLineItemId__c = asset.id;
        }
        update lineItemList;

        propList = DCPProposal.getPresentedProposal(opp.Id,ssd.Id);
        for(Apttus_Proposal__Proposal__c prop : propList){
            prop.APTS_Approval_Segment__c = 'FindLaw';
            prop.APTS_Proposal_Business_Unit__c = 'FindLaw';
        }
        update propList;

        cartList = DCPCart.getFinalizeCartFromProposal(propList);
        
        DCPRenewalSetting.getRenewalSetting();
        
        for(Apttus_Config2__ProductConfiguration__c cart : cartList){
            proposalIDToCartMap.put(cart.Apttus_QPConfig__Proposald__c, cart);
        }
        
        Test.startTest();
        List<DCPRenewalProposalWrapper> proposalData = DCPRenewalProposal.getProposalDetails(propList,proposalIDToCartMap, opp);
        System.assert(proposalData != null, 'No proposal data returned');
        Test.stopTest();
    }
}