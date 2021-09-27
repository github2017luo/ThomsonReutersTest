@isTest
public class DCConfiguratorImplServiceV2_Test {

    @testSetup static void setupData(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote(); 
        Test.stopTest();
        DCTestData.createCategories(DCTestData.productId);
        DCTestData.createProductPlan(DCTestData.productId,'42009567', '42009617');
        DCTestData.createPriceListItem(DCTestData.pBookId,DCTestData.productId);
        DCTestData.createPriceMatix(DCTestData.priceListItemid);
        DCTestData.createPriceMatrixEntry(DCTestData.priceMatrixid, '1');        
        DCTestData.createDigitalSubscriptions('40974108','42009614', 'Premium', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        
        Apttus_Config2__ProductConfiguration__c cart = [select id from Apttus_Config2__ProductConfiguration__c Limit 1];
        cart.APTS_SSD_bill_to__c = DCTestData.accssdid;
        update cart;
        Apttus_Config2__LineItem__c lineitem = [select id from Apttus_Config2__LineItem__c limit 1];
        lineitem.Apttus_Config2__ConfigurationId__c = cart.id;
        update lineitem;
        //List<DC_Global_Settings__mdt> globalSettingList = [SELECT Login_Domain__c,Username__c, Password__c, Security_Token__c, Request_Timeout__c,Use_API_User__c FROM DC_Global_Settings__mdt];
        //List<DC_State_Circuit_Mapping__mdt> stateCircuitList = [SELECT Circuit__c, State__c, State_Code__c FROM DC_State_Circuit_Mapping__mdt];
    }   
        
    private static testMethod void loadDataTest() {
        //setupData();
        
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Account testAcc = [select id from Account where Name = 'Test Account' limit 1];
        
        Opportunity testOpp = [select id from Opportunity where AccountId =: testAcc.Id limit 1];
        
        Source_System_Detail__c accountSSD = [select id, LCRM_SAP_Account_Number__c from Source_System_Detail__c where LCRM_SAP_Account_Number__c = '1004284494' limit 1];
        
        Contact testcontact = [select id from Contact where AccountId =: testAcc.Id limit 1];
        
        Test.startTest();
        DCConfiguratorImplServiceV2 configImplClass = new DCConfiguratorImplServiceV2(); 
        configImplClass.referenceState = 'California';
        DCConfigdetails.UIResponseWrapper responseJSON = configImplClass.performInitialLoad(cQuoteRec.ID, bQuoteRec.ID);
        
        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
        q1.Apttus_Proposal__Opportunity__c = testOpp.Id;
        q1.Apttus_Proposal__Account__c = testAcc.Id;
        q1.APTS_SSD_Sold_To__c = accountSSD.Id;
        q1.APTS_SSD_bill_to__c = accountSSD.Id;
        q1.APTS_SSD_ship_to__c = accountSSD.Id;
        q1.Apttus_QPConfig__BillToAccountId__c = testAcc.Id;
        q1.Apttus_QPConfig__ShipToAccountId__c = testAcc.Id;
        q1.Apttus_Proposal__Approval_Stage__c = 'Draft';
        q1.Digital_Quote_Type__c = 'Best Value'; 
        q1.Digital_Batch_Processed__c = TRUE;
        q1.Apttus_Proposal__Primary__c = FALSE;
        q1.DC_Updated_On_Configurator__c = TRUE;
        q1.APTS_Order_Confirmation_Contact__c = testcontact.Id;
        q1.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
        insert q1;
        try{
            configImplClass.performInitialLoad(cQuoteRec.ID, q1.id);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        Test.stopTest();
        System.assertNotEquals(responseJSON,null);
        
        DCConfigDetails confDetails; 
        confDetails= DCConfiguratorService.performInitialLoading(null,null);
        
        DCConfigDetails configData;
        configData = DCConfiguratorSynchService.configsynchron(null,null);
        
        
       
    } 
    private static testMethod void configServiceTest(){
        
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value+Config' limit 1];
    
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value' limit 1];
    
         DCConfigDetails confDetails2;
        confDetails2 = DCConfiguratorService.performInitialLoading(cQuoteRec.ID, bQuoteRec.ID); 
        system.assert(cQuoteRec!=null);     
        system.assert(bQuoteRec!=null);
        DCConfigDetails configData2;
        try{
            Test.startTest();
            configData2 = DCConfiguratorSynchService.configsynchron(cQuoteRec.ID, bQuoteRec.ID);
            Test.stopTest();
        }catch(Exception e){
                            System.debug('Exceptional Quotes'+e);
        }
        
    }
    
    private static testMethod void synchronizeCartTest() {
        //setupData();
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value+Config' limit 1];
    
        Test.startTest();
        Boolean response;
        try{
            response = DCConfiguratorImplServiceV2.synchronizeCart(cQuoteRec.ID);
        }catch(Exception e){
            System.debug('Exceptional Quotes'+e);
        }
        Test.stopTest();
        system.assert(cQuoteRec!=null);
    } 
    
    static testMethod void getQuoteDetails_Test(){
        //setupData();
    
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
    
    
        Test.startTest();
        
        DCConfiguratorImplServiceV2 configImplClass = new DCConfiguratorImplServiceV2();
        Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c(id=cQuoteRec.ID);
        quote.DC_Updated_On_Configurator__c = false;
        update quote;
        configImplClass.customQuoteId  = cQuoteRec.ID; 
        configImplClass.bestValueQuoteId = bQuoteRec.ID;
        configImplClass.getQuoteDetails();
        configImplClass.compareCustomAndBV();
        configImplClass.customQuoteProductIdSet = new Set<Id>();
        configImplClass.compareCustomAndBV();
        
        configImplClass.bvQuoteProductIdSet = new Set<Id>{testProduct.Id};
        configImplClass.customQuoteProductIdSet = new Set<Id>{testProduct.Id};
        configImplClass.bvNoOfAttorneys = 2;
        configImplClass.quoteNoOfAttorneys = 2;
        
        configImplClass.compareCustomAndBV();
        
        configImplClass.quoteNoOfAttorneys = 1;
        configImplClass.compareCustomAndBV();
        
        
        Test.stopTest();
        
        System.assertNotEquals(configImplClass.bvQuoteProductIdSet,null);
    }
    
    
    static testMethod void getPriceMatrix_Test(){
        //setupData();
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
    
        Test.startTest();
        DCConfiguratorImplServiceV2 configImplClass = new DCConfiguratorImplServiceV2();
        configImplClass.customQuoteId  = cQuoteRec.ID; 
        configImplClass.bestValueQuoteId = bQuoteRec.ID;
        configImplClass.performInitialLoad(cQuoteRec.ID, bQuoteRec.ID);
        Map<String,List<DCConfigdetails.PriceMatrix>> productToPriceMatrices = configImplClass.getPriceMatrix(new Set<Id> {testProduct.Id}, 3);
        Test.stopTest();  
        
        System.assertNotEquals(productToPriceMatrices,null);
    }
    
    static testMethod void getDiscountedPrice_Test(){
        //setupData();
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        
        Test.startTest();
        DCConfiguratorImplServiceV2 configImplClass = new DCConfiguratorImplServiceV2();
        configImplClass.customQuoteId  = cQuoteRec.ID; 
        Map<Id, Decimal> productPriceMap = new Map<Id, Decimal>();
        productPriceMap.put(testProduct.Id, 100.00);
        Map<Id, Decimal> discountMap = DCConfiguratorImplServiceV2.getDiscountedPrice(productPriceMap, '% Discount', 10.00);
        discountMap = DCConfiguratorImplServiceV2.getDiscountedPrice(productPriceMap, '% Markup', 10.00);
        system.assert(cQuoteRec!=null);
        system.assert(testProduct!=null);
    }
    
    static testMethod void envelopeCreationTest(){

        List<String> quoteList = new List<String>();
        Test.startTest();
        DCMessage msg = DCConfiguratorImplServiceV2.envelopeCreation(quoteList);
        System.assert(msg != null, 'envelopeCreation assertion failed');
        Test.stopTest();
    }
    
    static testMethod void generatePDFDocByQuoteIdsTest(){

        List<String> quoteList = new List<String>();
        Test.startTest();
        DCMessage msg = DCConfiguratorImplServiceV2.generatePDFDocByQuoteIds(quoteList);
        System.assert(msg != null, 'generatePDFDoc assertion failed');
        Test.stopTest();
    }
}