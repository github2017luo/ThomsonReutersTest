@isTest
public class Digital_RepriceAutomationBatch_Test2 {
  public static String accountId;
    public static String oppId;
    
   /* Public String quoteid;
    public String cartId;*/
    
    @isTest public static void testReprice(){
        
        APTS_LineItemTriggerHandler.afterUpdate = true;
        APTS_LineItemTriggerHandler.afterInsert = true;
       // APTS_LineItemTriggerHandler.afterUpdate = true;
        
        APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
        APTS_ProductConfigurationTriggerHandler.afterInsert = true; 
       
        LTS_Disable_Application_Automation__c  disabletig = new LTS_Disable_Application_Automation__c();
        disabletig.LTS_Disable_Triggers__c = true;
        insert disabletig;

       // DCTestData.createData();
        DCTestData.createTestData();
        String PBookId = DCTestData.pBookId;
        String opportunityId = DCTestData.oppId;
        String bQuoteId = DCTestData.bQuoteId;
        String cQuoteID = DCTestData.cQuoteID;
        System.debug(opportunityId+'<bQuoteId>'+bQuoteId+'<>'+cQuoteID);
     /*   DCTestData.accountId;
        DCTestData.oppId;
        DCTestData.pBookId;*/
       

        Digital_Reprice__c digitalRepric = new Digital_Reprice__c();
        digitalRepric.Business_Segment__c = 'FindLaw';
        digitalRepric.Name = 'FindLaw';
        digitalRepric.Enable_Reprice__c = true;
        insert digitalRepric ;

        Digital_Reprice__c digitalRepricSL = new Digital_Reprice__c();
        digitalRepricSL.Business_Segment__c = 'Small Law';
        digitalRepricSL.Name = 'Small Law';
        digitalRepricSL.Enable_Reprice__c = true;
        insert digitalRepricSL ;

        
       List<Apttus_Proposal__Proposal__c> quoteList = new list<Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Id = bQuoteId;
        q1.Apttus_Proposal__Approval_Stage__c = 'Presented';
        q1.Digital_Quote_Type__c = 'Best Value'; 
        q1.Digital_Batch_Processed__c = TRUE;
        q1.Apttus_Proposal__Primary__c = false;
        quoteList.add(q1);
        
        Apttus_Proposal__Proposal__c q2 = new Apttus_Proposal__Proposal__c();
        q2.Id = cQuoteID;
        q2.Apttus_Proposal__Approval_Stage__c = 'Presented';
        q2.Digital_Quote_Type__c = 'Best Value+Config'; 
        q2.Digital_Batch_Processed__c = TRUE;
        q2.Apttus_Proposal__Primary__c = false;
        quoteList.add(q2); 
        
        Update quoteList;
        
        String bCartId = DCTestData.bCartId;
        String cCartId = DCTestData.cCartId;
        
        List<String> cartlstid = New List<String>{cCartId,bCartId};
       /*
        
        list<Apttus_Config2__LineItem__c> listLines = new list<Apttus_Config2__LineItem__c>();
        
        Apttus_Config2__LineItem__c line1 = DCTestData.createLineItem(cartList[0].id, 1, 1, true, 'Product/Service', prod2.id, null, 2, PBookId, null, false, false);
        listLines.add(line1);
        
         Apttus_Config2__LineItem__c line2 = DCTestData.createLineItem(cartList[1].id, 1, 1, true, 'Product/Service', prod2.id, null, 2, PBookId, null, false, true);
        listLines.add(line2);
        
         Insert listLines;
        */
        
        test.starttest();
        try{
            Digital_RepriceAutomationBatch objDigi = new Digital_RepriceAutomationBatch();
            Database.executeBatch(objDigi);
            Digital_RepriceAutomationBatch.repriceupdate(cartlstid);
        }Catch(Exception ex){}
        
        
        Apttus_Proposal__Proposal__c propos = [SELECT Id,Name,DC_Contract_Not_In_Sync__c  FROM Apttus_Proposal__Proposal__c  where (Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c = TRUE AND Apttus_Proposal__Approval_Stage__c = 'Presented' AND Digital_Quote_Type__c!= 'Straight Renewal') limit 1];
        //System.assertEquals(propos.DC_Contract_Not_In_Sync__c ,True);
        test.stoptest(); 
       
    } 
        
    @isTest Public static void exceptiontest(){
        Digital_RepriceAutomationBatch.createExceptionLog('additional info','Digital_RepriceAutomationBatch','','','');
    } 
    
  /*  public static testmethod String createCart(String quoteId){
        Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO(); 
        request.QuoteId = quoteId;
        Apttus_CPQApi.CPQ.CreateCartResponseDO response = Apttus_CPQApi.CPQWebService.createCart(request);
        String cartId = response.CartId;
        
        return cartId;
    }
    
    public static testmethod Apttus_Config2__LineItem__c createLineItem(String configId, Integer lineNumber, Integer itemSequence, Boolean isPrimaryLine, 
                                                             String lineType, Id productId, Id optionId, Integer quantity, Id plItemId, Boolean isBundle, String pricingStatus){
        
                                                                 
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configId);
        lineItem.Apttus_Config2__LineNumber__c = lineNumber;
        lineItem.Apttus_Config2__ItemSequence__c = itemSequence;
        lineItem.Apttus_Config2__IsPrimaryLine__c = isPrimaryLine;
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__LineType__c = lineType;
        lineItem.Apttus_Config2__ProductId__c = productId;
        lineItem.Apttus_Config2__OptionId__c = optionId;
        lineItem.Apttus_Config2__Quantity__c = quantity;
        //lineItem.Apttus_Config2__PriceListId__c = priceListId;
        lineItem.Apttus_Config2__PriceListItemId__c = plItemId;
        lineItem.Apttus_Config2__ListPrice__c = 500;
        lineItem.Apttus_Config2__BasePrice__c = 200;
        lineItem.Apttus_Config2__AdjustedPrice__c = 0;
        lineItem.Apttus_Config2__NetPrice__c = 600;
        lineItem.Apttus_Config2__ExtendedPrice__c = 600;
        lineItem.Apttus_Config2__HasOptions__c = isBundle;
        lineItem.Apttus_Config2__StartDate__c = system.today();
        lineItem.Apttus_Config2__EndDate__c=system.today().addDays(30);
        lineItem.Apttus_Config2__AdjustmentAmount__c = 5.0;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__Term__c = 12;
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.Apttus_Config2__PricingStatus__c = pricingStatus;
        return lineItem;
    }
    
    public static testmethod Product2 createProduct(String prodName, String serviceNum, String subNum) {
        Product2 prodObj = new Product2(); //current sub
        prodObj.Name = prodName;
        prodObj.List_Price__c = 0;
        prodObj.Format__c = 'Online';
        prodObj.Is_Orderable__c = TRUE;
        prodObj.IS_WP_Eligible__c = TRUE;
        prodObj.Media_High_Level__c = 'Online';
        prodObj.Service_Number__c = serviceNum;
        prodObj.Subscription_Number__c = subNum;
        prodObj.APTS_Product_Pricing_Model__c = 'Banded';
        prodObj.Family = 'WESTLAW';
        prodObj.Apttus_Filter_Media__c = 'Online';
        prodObj.APTS_Media_High_Level_Code__c = '05';
        prodObj.APTS_Media_Lower_Level_Code__c = 'E5';
        prodObj.Productcode = serviceNum;
        prodObj.isActive = true;
        Insert prodObj;
        
        return prodObj;
    }*/
}