@isTest
public class DCPRenewalGetPricing_Test{
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

        Apttus_Config2__PriceMatrix__c priceMatrix = (Apttus_Config2__PriceMatrix__c)objectToDataMap.get('Apttus_Config2__PriceMatrix__c');
        priceMatrix.Apttus_Config2__PriceListItemId__c = priceListItem.id;
        insert priceMatrix;

        List<Apttus_Config2__PriceMatrixEntry__c> priceMatrixEntryList = new List<Apttus_Config2__PriceMatrixEntry__c>();
        Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry = (Apttus_Config2__PriceMatrixEntry__c)objectToDataMap.get('Apttus_Config2__PriceMatrixEntry__c');
        priceMatrixEntry.Apttus_Config2__PriceMatrixId__c = priceMatrix.id;
        priceMatrixEntryList.add(priceMatrixEntry);
        Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry2 = priceMatrixEntry.clone();
        priceMatrixEntry2.Apttus_Config2__Dimension1Value__c = '2'; //Quantity
        priceMatrixEntryList.add(priceMatrixEntry2);
        insert priceMatrixEntryList;

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
    public static void getPricingTest(){
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
        DCPRenewalPricingResponse.DCPPricingObject pricingdata = DCPRenewalGetPricing.getPricing(proposalIDToCartMap);
        System.assert(pricingdata != null, 'No proposal data returned');
        Test.stopTest();
    }
    @isTest
    public static void getPricingTestUpsell(){
        List<Apttus_Proposal__Proposal__c> propList;
        List<Apttus_Config2__ProductConfiguration__c> cartList;
        Map<String,Apttus_Config2__ProductConfiguration__c> proposalIDToCartMap = new Map<String,Apttus_Config2__ProductConfiguration__c>();
        Opportunity opp = [SELECT id, Renewal_Date__c FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c WHERE Name = 'ABC' LIMIT 1];
        
        propList = DCPProposal.getPresentedProposal(opp.Id,ssd.Id);
        propList[0].Digital_Quote_Type__c = 'Best Value';
        update propList;
        cartList = DCPCart.getFinalizeCartFromProposal(propList);
        
        DCPRenewalSetting.getRenewalSetting();
        
        for(Apttus_Config2__ProductConfiguration__c cart : cartList){
            proposalIDToCartMap.put(cart.Apttus_QPConfig__Proposald__c, cart);
        }
        
        Test.startTest();
        DCPRenewalPricingResponse.DCPPricingObject pricingdata = DCPRenewalGetPricing.getPricing(proposalIDToCartMap);
        System.assert(pricingdata != null, 'No proposal data returned');
        Test.stopTest();
    }
}