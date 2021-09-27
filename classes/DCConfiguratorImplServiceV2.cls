/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-06-14   Navleen Kaur            DLT-9760 - Update Opportunities for stage / record type changes and GLI Account / Contact / lookup field changes
 * 2018-07-02   Brenda Shields          DLT-10717 - Remove obsolete items - removing call to update Product Xref records - DCConfiguratorUtil.updateDBCategories
 * 2018-11-19   Divija Salla            DLT-13464- [Tech Story] -All. Streamline all Max users for landing page and add on page
 * 2018-12-17   Divija Salla            DLT-13779 - Create an API to get Configurator plan details
 * 2018-12-04   Benjamin Her            DLT-13780 - Code Scan fixes
 * 2019-02-15   Navleen Kaur            DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 2019-04-03   Benjamin Her            DLT-15965 - Null exception handling for getReferenceJurisdiction() class
 * 2019-06-12   Bishanka Dassarma       DLT-16783 - [Tech Story] [Code Scan] - Fix code scan CRITICAL issues in this DCConfiguratorImplServiceV2
 * 2019-06-25   Benjamin Her            DLT-16925 - [Tech Story] [Code Scan] - Fix code scan MINOR issues
 * 2020-08-14   Benjamin Her            DLT-20588 - Implement MLF support
 * ==================================================================================================================================   
 */
Public with sharing class DCConfiguratorImplServiceV2 {
    @testvisible
    private String bestValueQuoteId;
    @testvisible
    private String customQuoteId;
    @testvisible
    private string referenceState { get; set;}
    @testvisible
    private string referenceCircuit { get; set;}
    @testvisible
    private String referenceStateCode {get;set;}
    @testvisible
    private String segment;
    @testvisible
    private set<Id> bvQuoteProductIdSet;
    @testvisible
    private set<Id> customQuoteProductIdSet;
    private map<Id, Id> bvQuoteProdIdLineItemIdMap; 
    private map<Id, Id> custQuoteProdIdLineItemIdMap;
    @testvisible
    private Set<Id> excludeCategories;
    @testvisible
    private Decimal bvNoOfAttorneys;
    @testvisible
    private Decimal quoteNoOfAttorneys;
    private Decimal defaultNoOfAttorneys;
    
    @testvisible
    private String bestValueAdjustmentType;
    @testvisible
    private Decimal bestValueAdjustmentAmount;
    
    private String accountId;
    private String priceListId;
    private String opportunityId;
    @testvisible
    private set<Id> selectionProductIdSet;
    private String customerPricingSegment;
    private Decimal adjustmentAmount;
    private String adjustmentType;
    
    private Decimal customQuotePrice;
    private Decimal bestValueQuotePrice;
    
    private String customQuoteContractTerm;
    private String bvQuoteContractTerm;
    
    private Map<Id,List<Apttus_Config2__ProductClassification__c>> categoryProdClassificationMap;
    
    //private Map<Id, Decimal> productPriceMap;    
    private Map<Id, Decimal> productDiscountedPriceMap;
    private Map<Id, Decimal> lineItemProductPriceMap;
    
    private String landingPageURL;
    //private String summaryPageURL;
    private Boolean updatedOnConfigurator;
    
    private static final String STR_CIRCUIT = 'Circuit';
    private static final String PRODUCT_PRICING_MODEL_BANDED = 'Banded';
    private static final String STR_DIMENSION1_NAME = 'Quantity';
    private static final List<String> LAW_FIRMS = System.Label.Digital_Law_Firm.split(',');
    
    private Map<String,List<DCConfigdetails.PriceMatrix>> productToPriceMatricesMap = new Map<String,List<DCConfigdetails.PriceMatrix>>();
    private String quoteType;
    private Integer customerCategory;
    private String segmentType; //DLT 9738 
    
    /*
    Performs All the processing. 
    * Queries Line Items for Quote Details
    * Gets Reference Jurisdiction
    * Gets Selection Products
    * Prepares and returns the UI Response
    */
    public DCConfigdetails.UIResponseWrapper performInitialLoad(String custQuoteId, String bvQuoteId) {
        try {
            customQuoteId  = custQuoteId; 
            bestValueQuoteId = bvQuoteId;
            
            getQuoteDetails();
           // compareCustomAndBV();
            getReferenceJurisdiction();
            getSelectionProducts();
        } catch (Exception ex) {
            //throw ex;
            system.debug('Exceptons '+ex.getMessage());
        }
        return prepareResponse();
    }
    
    /*
    Queries Line Items for both Custom and Best Value Quote.
    Prepares the required values to be used in subsequent methods for preparing the response.
    */
  public void getQuoteDetails() {
    //*** START :: Added by Rajan :: DLT-10232 - [Code Scan] Fix
    List<Apttus_Config2__LineItem__c> lineItemList;//DLT-11733
    if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){
                        lineItemList = [SELECT  Id, Apttus_Config2__PriceListId__c, Apttus_Config2__ProductId__c, Customer_Pricing_Segment__c, 
                                        Apttus_Config2__ProductId__r.Name, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,
                                        Apttus_Config2__Quantity__c,APTS_Contract_Term__c,APTS_Contract_Term_Number__c,Apttus_Config2__NetPrice__c,
                                        Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__ConfigurationId__r.APTS_New_Holdings__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_Offer__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.State__c, 
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.LCRM_APTS_Band_Number__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c,
                                        Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c
                                        FROM Apttus_Config2__LineItem__c                                                                       
                                        WHERE (Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :customQuoteId OR 
                                                Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :bestValueQuoteId) AND 
                                                Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = :Label.DC_CONFIG_STATUS_FINALIZED AND
                                                Apttus_Config2__LineStatus__c != :Label.DC_LINE_STATUS_CANCELLED];
        //*** END :: Added by Rajan :: DLT-10232 - [Code Scan] Fix
    }

        
        if((lineItemList != null) && (!lineItemList.isEmpty())) {
          //calls helper function to process details
            getQuoteDetailsHelper(lineItemList);
                 
        } else {
            String errorQuote = 'Best Value: ' + bestValueQuoteId + ', Best Value+Config: ' + customQuoteid; 
            throw new DCCustomException('No valid cart available for the specified Quote(s). [' + errorQuote + ']');
        } 
        
    }

  //getQuoteDetailsHelper() method
  //Process quote details
    Public void getQuoteDetailsHelper(List<Apttus_Config2__LineItem__c> lineItemList){
        //Set<Id> productIds = new Set<Id>();
        //Map<Id,Id> productQuoteLineItemsMap = new Map<Id,Id>();
        Boolean bestValueQuoteAvailable = false;
        Boolean customQuoteAvailable = false;
        bvQuoteProductIdSet = new  Set<Id>();
        customQuoteProductIdSet = new Set<Id>();
        bvQuoteProdIdLineItemIdMap = new Map<Id,Id>(); 
        custQuoteProdIdLineItemIdMap = new Map<Id,Id>();
        lineItemProductPriceMap = new Map<Id, Decimal>();
        
        //Loop through the line items and set properties to be used later in the code. For example,
        //Best Value Quote Price, Custom Quote Price, Custom Quote Contract Term, Quantity, Adjsutment Amount,
        //Ajdustment Type, Customer Pricing Segment, Initial Reference State (From Account), Default Quantity
        for (Apttus_Config2__LineItem__c lineItem : lineItemList) {
            getQuoteDetailsCommonDataHelper(lineItem);
            
            if(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c == bestValueQuoteId) {
                getQuoteDetailsBestValueHelper(lineItem);
                bestValueQuoteAvailable = true;
                
            } else {
                getQuoteDetailsConfigHelper(lineItem);
                customQuoteAvailable = true;
            }


        }  
        
        //Throw error if there was no line item for either of the two quotes
        //String errorQuote;
        if(!bestValueQuoteAvailable){
            //errorQuote = 'Best Value: ' + bestValueQuoteId;
            throw new DCCustomException('No valid cart available for the specified Quote(s). [Best Value: '+ bestValueQuoteId + ']');
        }
        if(!customQuoteAvailable){
            //errorquote = 'Best Value+Config: ' + customQuoteid;
            throw new DCCustomException('No valid cart available for the specified Quote(s). [Best Value+Config: ' + customQuoteid + ']');
        }             

    }//end of getQuoteDetailsHelper() method

  //getQuoteDetailsCommonDataHelper()
  //Process common data for Best and Config quote
    private void getQuoteDetailsCommonDataHelper(Apttus_Config2__LineItem__c lineItem){
         Product_Account_Detail__c subscription = new Product_Account_Detail__c();
        if(landingPageURL == null){ //DLT-11733
            landingPageURL = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_Offer__c;
        }
        if(opportunityId == null){ //DLT-11733
            opportunityId = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c;
        }
        if(Schema.sObjectType.Product_Account_Detail__c.isAccessible()){
            subscription = [SELECT ZP_Cust_Number__c,Digital_Firm__c FROM Product_Account_Detail__c 
                                     where ZP_Cust_Number__c = : lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c Limit 1];
        }
        system.debug('$$##subscription'+subscription );
        if(subscription.Digital_Firm__c!= null){
            segment = subscription.Digital_Firm__c;
        }
        else{
            segment = '';
        }

        system.debug('$$##segment '+segment );
        if(accountId == null) {
            //*** START :: Added by Rajan :: DLT-10232 - [Code Scan] Fix
            accountId = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c;
            //*** END :: Added by Rajan :: DLT-10232 - [Code Scan] Fix
            defaultNoOfAttorneys = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.LCRM_APTS_Band_Number__c;
        }
        
        if(priceListId == null) {
            priceListId = lineItem.Apttus_Config2__PriceListId__c;
        }
        if(customerCategory == null && lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c != null){ //DLT-11733
            customerCategory = Integer.valueOf(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c);
        }                
        if (referenceState == null) {
            String accountState = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.State__c;
            String accountStateCode = accountState;
            //Filters on State name
            for(DC_State_Circuit_Mapping__mdt stateCircuitMapping : [SELECT     State__c, State_Code__c
                                                                        FROM       DC_State_Circuit_Mapping__mdt
                                                                        WHERE      State__c = :accountState
                                                                        LIMIT 1]) {
                referenceState = stateCircuitMapping.State__c;
                referenceStateCode = stateCircuitMapping.State_Code__c;                                  
            }
            //Filters on State Code
            if(referenceState == null) {
                for(DC_State_Circuit_Mapping__mdt stateCircuitMapping : [SELECT     State__c, State_Code__c
                                                                            FROM       DC_State_Circuit_Mapping__mdt
                                                                            WHERE      State_Code__c = :accountState
                                                                            LIMIT 1]) {
                    referenceState = stateCircuitMapping.State__c;
                    referenceStateCode = stateCircuitMapping.State_Code__c;                                  
                }
            }
        } 
    }//end of getQuoteDetailsCommonDataHelper()
    
    //getQuoteDetailsBestValueHelper()
    //Process Best Value quote
     private void getQuoteDetailsBestValueHelper(Apttus_Config2__LineItem__c lineItem){
        bvQuoteProductIdSet.add(lineItem.Apttus_Config2__ProductId__c);
        bvQuoteProdIdLineItemIdMap.put(lineItem.Apttus_Config2__ProductId__c, lineItem.Id);     
        if(bestValueQuotePrice == null){ //DLT-11733
            bestValueQuotePrice = lineItem.Apttus_Config2__ConfigurationId__r.APTS_New_Holdings__c; 
        }
        if(bvQuoteContractTerm == null){ //DLT-11733
            bvQuoteContractTerm = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c; 
        }
        if(bvNoOfAttorneys == null){ //DLT-11733
            bvNoOfAttorneys = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c;
        }
        if(bestValueAdjustmentType == null){ //DLT-11733
            bestValueAdjustmentType = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c;
        }
        if(bestValueAdjustmentAmount == null){ //DLT-11733
            bestValueAdjustmentAmount = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c;
        }
     }//end of getQuoteDetailsBestValueHelper()
     
     //getQuoteDetailsConfigHelper()
     //Process Config quote
     private void getQuoteDetailsConfigHelper(Apttus_Config2__LineItem__c lineItem){
         Product_Account_Detail__c subscription = new Product_Account_Detail__c();
        customQuoteProductIdSet.add(lineItem.Apttus_Config2__ProductId__c);
        custQuoteProdIdLineItemIdMap.put(lineItem.Apttus_Config2__ProductId__c, lineItem.Id);
        //if(quoteNoOfAttorneys == null) quoteNoOfAttorneys = lineItem.Apttus_Config2__Quantity__c;
        if((quoteNoOfAttorneys == null) && (PRODUCT_PRICING_MODEL_BANDED.equalsIgnoreCase(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c)) && (lineItem.Apttus_Config2__Quantity__c != null)){ //DLT-11733
            quoteNoOfAttorneys = Integer.valueOf( lineItem.Apttus_Config2__Quantity__c);             
        }
        customerPricingSegment = lineItem.Customer_Pricing_Segment__c;
        adjustmentAmount = lineItem.Apttus_Config2__AdjustmentAmount__c;
        adjustmentType = lineItem.Apttus_Config2__AdjustmentType__c;
        lineItemProductPriceMap.put(lineItem.Apttus_Config2__ProductId__c, lineItem.Apttus_Config2__NetPrice__c);
        if(customQuotePrice == null){ //DLT-11733
            customQuotePrice = lineItem.Apttus_Config2__ConfigurationId__r.APTS_New_Holdings__c;
        }
        if(customQuotePrice != null){
            customQuotePrice = customQuotePrice.setScale(2);
        }
        if(quoteType == null && lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c != null){ //DLT-11733
            quoteType = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
        }
        if(customQuoteContractTerm == null){ //DLT-11733
            customQuoteContractTerm = lineItem.APTS_Contract_Term__c;
        }
        if(updatedOnConfigurator == null){ //DLT-11733
            updatedOnConfigurator = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DC_Updated_On_Configurator__c;
        }
       
        if(Schema.sObjectType.Product_Account_Detail__c.isAccessible()){
            subscription = [SELECT ZP_Cust_Number__c,Digital_Firm__c FROM Product_Account_Detail__c 
                                     where ZP_Cust_Number__c = : lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_bill_to__r.Source_System_Account_Number__c Limit 1];
        }
        system.debug('$$subscription '+subscription );
        if(segmentType == null && subscription.Digital_Firm__c != null){ //DLT-11733
            segmentType = subscription.Digital_Firm__c;
        }
        system.debug('$$segmentType '+segmentType );
     }//end of getQuoteDetailsConfigHelper() method
     
    /*
    Gets reference jurisdiction based on the reference product in the Best Value Quote (if any).
    Also gets reference circuit based on the reference state.
    */
    @testvisible
    private void getReferenceJurisdiction() {
        excludeCategories = new Set<id>();
    List<Apttus_Config2__ProductClassification__c> bvRefProdClassificationList; //DLT-11733
    if(Schema.sObjectType.Apttus_Config2__ProductClassification__c.isAccessible()){ //DLT-11733
      bvRefProdClassificationList = 
                [SELECT Apttus_Config2__ClassificationId__c,
                        Apttus_Config2__ProductId__c,
                        Apttus_Config2__ProductId__r.Apttus_Filter_Jurisdiction__c,
                        Category_Parent_Hierarchy__c,
                        DC_Product_Jurisdiction__c
                 FROM   Apttus_Config2__ProductClassification__c
                 WHERE  DC_Product_Jurisdiction__c != :Label.DC_JURISDICTION_NATIONAL_FEDERAL AND
                        Apttus_Config2__ProductId__c IN :bvQuoteProductIdSet 
                ];
         }       
        for(Apttus_Config2__ProductClassification__c prodClassification : bvRefProdClassificationList) {
            //DLT-15956 Check whether Jurisdiction field is blank to prevent null exception
            if(!String.isBlank(prodClassification.DC_Product_Jurisdiction__c) 
                && prodClassification.Category_Parent_Hierarchy__c.contains(Label.DC_JURISDICTION_REF_CATEGORY) 
                && !prodClassification.DC_Product_Jurisdiction__c.contains(STR_CIRCUIT)) {
                    
                referenceState = prodClassification.DC_Product_Jurisdiction__c;
             
            }
            if(prodClassification.DC_Product_Jurisdiction__c != Label.DC_JURISDICTION_NATIONAL_FEDERAL) {
                excludeCategories.add(prodClassification.Apttus_Config2__ClassificationId__c);
            }
        }
        List<DC_State_Circuit_Mapping__mdt> stCircuitMappingList; //DLT-11733
    if(Schema.sObjectType.DC_State_Circuit_Mapping__mdt.isQueryable()){ //DLT-11733
                      stCircuitMappingList = [SELECT     Circuit__c
                                                                     FROM       DC_State_Circuit_Mapping__mdt
                                                                     WHERE      State__c = :referenceState];
        }
        if((stCircuitMappingList != null) && (!stCircuitMappingList.isEmpty())) {
            referenceCircuit = stCircuitMappingList[0].Circuit__c;
        } else {
      if(Schema.sObjectType.DC_State_Circuit_Mapping__mdt.isQueryable()){ //DLT-11733
        for(DC_State_Circuit_Mapping__mdt stateCircuitMapping : [SELECT     Circuit__c
                                     FROM       DC_State_Circuit_Mapping__mdt
                                     WHERE      State_Code__c = :referenceStateCode]) {
          referenceCircuit = stateCircuitMapping.Circuit__c;                                  
        }
      }
        }
        
        System.debug('Reference State: ' + referenceState);
        System.debug('Exclude Categories: ' + excludeCategories);
    }
    
    /*
    Gets the Products to be shown on the Configurator screen
    */
    @testvisible
    private void getSelectionProducts() {
    List<Apttus_Config2__ProductClassification__c> prodClassificationSelectionList; //DLT-11733
    if(Schema.sObjectType.Apttus_Config2__ProductClassification__c.isAccessible()){ //DLT-11733
      prodClassificationSelectionList = 
                [Select Apttus_Config2__ClassificationId__c,
                        Apttus_Config2__ClassificationId__r.Name, 
                        Apttus_Config2__ProductId__c,
                        Apttus_Config2__ProductId__r.Apttus_Filter_Jurisdiction__c,
                        Apttus_Config2__ProductId__r.List_Price__c,
                        Apttus_Config2__ProductId__r.Name,
                        Apttus_Config2__ProductId__r.Description,
                        Apttus_Config2__Sequence__c,
                        DC_Product_Title__c,
                        DC_Product_Jurisdiction__c,
                        DC_Product_Description__c              
                 from Apttus_Config2__ProductClassification__c
                 where 
                    Apttus_Config2__ClassificationId__r.Apttus_Config2__PrimordialId__r.Name = :Label.DC_MAIN_CATEGORY_NAME
                 and ((DC_Product_Jurisdiction__c = :referenceState AND (NOT Apttus_Config2__ClassificationId__c IN :excludeCategories)) OR 
                        (DC_Product_Jurisdiction__c = :referenceCircuit AND (NOT Apttus_Config2__ClassificationId__c IN :excludeCategories)) OR 
                        DC_Product_Jurisdiction__c = :Label.DC_JURISDICTION_NATIONAL_FEDERAL OR
                        Apttus_Config2__ProductId__c IN :bvQuoteProductIdSet)                     
                    
                ];
        }
        categoryProdClassificationMap = new Map<Id,List<Apttus_Config2__ProductClassification__c>>(); 
        selectionProductIdSet = new Set<Id>();
        for (Apttus_Config2__ProductClassification__c prodClassification : prodClassificationSelectionList) {
            if (categoryProdClassificationMap.containsKey(prodClassification.Apttus_Config2__ClassificationId__c)) {
                List<Apttus_Config2__ProductClassification__c> prodClassificationList = categoryProdClassificationMap.get(prodClassification.Apttus_Config2__ClassificationId__c);
                prodClassificationList.add(prodClassification);
                categoryProdClassificationMap.put(prodClassification.Apttus_Config2__ClassificationId__c, prodClassificationList);
            }
            else {
                List<Apttus_Config2__ProductClassification__c> prodClassificationList = new List<Apttus_Config2__ProductClassification__c>();
                prodClassificationList.add(prodClassification);
                categoryProdClassificationMap.put(prodClassification.Apttus_Config2__ClassificationId__c, prodClassificationList);
            }
            selectionProductIdSet.add(prodClassification.Apttus_Config2__ProductId__c);
        }
        
    }
    
    /*
    Prepares the Wrapper Response
    */
    private DCConfigdetails.UIResponseWrapper prepareResponse() {
        Integer quantity;
        if(quoteNoOfAttorneys != null){
            quantity = quoteNoOfAttorneys.intValue();
        }
        else{
            quantity = 1;
        }
        Map<Id, Decimal> productPriceMap = getPrice(selectionProductIdSet, quantity, customerPricingSegment);
        productDiscountedPriceMap = getDiscountedPrice(productPriceMap, adjustmentType, adjustmentAmount);
        
        //Create Wrapper with top level details
        DCConfigdetails.UIResponseWrapper responseWrap = createResponseWrapper();
        
        productToPriceMatricesMap = getPriceMatrixV2(selectionProductIdSet, Integer.valueOf(responseWrap.maxNoOfAttorneys));
            
        //Create underlying cart details with sections and cart items
        responseWrap.cartDetails = createCartDetails();
        
        System.debug(JSON.serialize(responseWrap));
        return responseWrap;

    } 
    
    /*
    Create Wrapper with top level details of the response
    */
    private DCConfigdetails.UIResponseWrapper createResponseWrapper() {
        DCConfigdetails.UIResponseWrapper responseWrap = new DCConfigdetails.UIResponseWrapper();
        responseWrap.customQuoteId = customQuoteId;
        responseWrap.bestValueQuoteId = bestValueQuoteId;
        responseWrap.accountId = accountId;
        if(quoteNoOfAttorneys != null){
            responseWrap.noOfAttorneys = quoteNoOfAttorneys.intValue();
        }
        else{
            responseWrap.noOfAttorneys = 1;
        }
        if(defaultNoOfAttorneys != null){
            responseWrap.defaultNoOfAttorneys = defaultNoOfAttorneys.intValue();
        }
        else{
            responseWrap.defaultNoOfAttorneys = 1;
        }
        responseWrap.priceListId = priceListId;
        responseWrap.bestValueAdjustmentType = bestValueAdjustmentType;
        responseWrap.bestValueAdjustmentAmount = bestValueAdjustmentAmount;
       
        responseWrap.customQuotePrice = customQuotePrice;
        
        //Split price into dollars and cents
        if(customQuotePrice != null) {
            String cutomQPrice = String.valueOf(responseWrap.customQuotePrice);
            if(cutomQPrice.indexOf('.') > -1){
                responseWrap.cQPriceCentPart = cutomQPrice.right(cutomQPrice.length() - cutomQPrice.indexOf('.') - 1).left(2);
            }
            else{
                responseWrap.cQPriceCentPart = '00';
            }
            if(cutomQPrice.indexOf('.') > -1){
                responseWrap.cQPriceDollarPart = cutomQPrice.left(cutomQPrice.indexOf('.'));
            }
            else{
                responseWrap.cQPriceDollarPart = cutomQPrice;
            }
        } else {
            responseWrap.cQPriceCentPart = '00';
            responseWrap.cQPriceDollarPart = '0';
        }
        responseWrap.contractTermDetails = getContractTermWrapperList(customQuoteContractTerm, bvQuoteContractTerm,quoteType,customerCategory,segmentType);
        responseWrap.landingPageURL = landingPageURL;
        responseWrap.updatedOnConfigurator = updatedOnConfigurator; 
        
        //Get the contract term details from Global Settings (Custom metadata type)
        for (DC_Global_Settings__mdt globalSetting : [SELECT    
                                                                Page_Header_Text__c,
                                                                Page_Header_Title__c,
                                                                Summary_Page_URL__c
                                                       FROM     DC_Global_Settings__mdt
                                                       LIMIT    1]) {                            
            responseWrap.pageHeaderTitle = globalSetting.Page_Header_Title__c;                           
            responseWrap.pageHeaderText = globalSetting.Page_Header_Text__c;                           
            
            String tempAccountId;
            String tempOppId; 

            if(accountId != null){
                tempAccountId = accountId.left(15);
            }
            else{
                tempAccountId = ''.left(15);
            }
            if(opportunityId != null){
                tempOppId = opportunityId.left(15);
            }
            else{
                tempOppId = ''.left(15);
            }
            responseWrap.summaryPageURL = globalSetting.Summary_Page_URL__c + tempAccountId + tempOppId; 
        }
        Integer maxNoOfAttorneys = 0;
        //DLT-13464 Starts
        List<DC_Max_Users_or_Attorneys__mdt> globalSetting = new List<DC_Max_Users_or_Attorneys__mdt>();
        Map<String,DC_Max_Users_or_Attorneys__mdt> firmToMaxNoAttorneyMap = new Map<String,DC_Max_Users_or_Attorneys__mdt>();

        if(Schema.sObjectType.DC_Max_Users_or_Attorneys__mdt.isQueryable()){
            globalSetting = [SELECT Max_No_Of_Attorneys__c,Max_No_Of_Per_Seat_Users__c,Segment__c 
                            FROM DC_Max_Users_or_Attorneys__mdt
                            LIMIT 100];
        }//End If
        for(DC_Max_Users_or_Attorneys__mdt maxAttorney : globalSetting){
            firmToMaxNoAttorneyMap.put(maxAttorney.Segment__c, maxAttorney);
        }

        if(firmToMaxNoAttorneyMap.containsKey(segmentType)){
            maxNoOfAttorneys = Integer.valueOf(firmToMaxNoAttorneyMap.get(segmentType).Max_No_Of_Attorneys__c);
        }   

        responseWrap.maxNoOfAttorneys = maxNoOfAttorneys;

        return responseWrap;
    }
    
    /*
    Creates List of Sections using the categories under the Main Category "Digital Configurator"
    */
    private List<DCConfigdetails.Section> createCartDetails() {
    List<Apttus_Config2__ClassificationHierarchy__c> categoryList; //DLT-11733
    if(Schema.sObjectType.Apttus_Config2__ClassificationHierarchy__c.isAccessible()){ //DLT-11733
                            categoryList = [SELECT     Id, 
                                                                                    Name, 
                                                                                    DC_Is_Title_Visible__c, 
                                                                                    Apttus_Config2__Label__c, 
                                                                                    DC_Sequence_No__c, 
                                                                                    Apttus_Config2__ProductCount__c, 
                                                                                    Apttus_Config2__AncestorId__c,
                                                                                    Apttus_Config2__Level__c             
                                                                         FROM       Apttus_Config2__ClassificationHierarchy__c
                                                                         WHERE      Apttus_Config2__PrimordialId__r.Name = :Label.DC_MAIN_CATEGORY_NAME
                                                                         ORDER BY   Apttus_Config2__Level__c, DC_Sequence_No__c];
        }
        Map<Id, DCConfigdetails.Section> mapCatIdSection = new Map<Id, DCConfigdetails.Section>(); 
        //Set<Id> parentCategorySet = new Set<Id>();
        Set<Id> topLevelCategoryIdSet = new Set<Id>();
        
        //Loop and check top level categories 
        //Also add cart Items wherever there are products within a category
        for(Apttus_Config2__ClassificationHierarchy__c category : categoryList) {
            DCConfigdetails.Section section = createSectionForCategory(category);
            
            if(section.hasProducts) { 
                section.cartItems = createCartItemsForCategory(category.Id);
                Boolean containsBestValue = false;
                for(DCConfigdetails.CartItem cartItem : section.cartItems) {
                    if(cartItem.isBestValue == true) {
                        containsBestValue = true;
                        break;
                    }
                }
                section.containsBestValue = containsBestValue;
            }
            
            mapCatIdSection.put(category.Id, section);
            if(category.Apttus_Config2__Level__c == 1) {
                topLevelCategoryIdSet.add(category.Id);
            } 
        }
        
        //Associate Parent sections with child sections
        for(Apttus_Config2__ClassificationHierarchy__c category : categoryList) {
            if(!topLevelCategoryIdSet.contains(category.Id)) {
                DCConfigdetails.Section parentSection = mapCatIdSection.get(category.Apttus_Config2__AncestorId__c);
                if(parentSection != Null && parentSection.subSections == null){ //DLT-11733
          parentSection.subSections = new List<DCConfigdetails.Section>();
        }
                if(parentSection != Null && parentSection.subSections != null){ //DLT-11733
          parentSection.subSections.add(mapCatIdSection.get(category.Id));
        }
                mapCatIdSection.put(category.Apttus_Config2__AncestorId__c, parentSection);
            }
        }
        
        //Create hierarchy for the top level categories
        List<DCConfigdetails.Section> sectionList = new List<DCConfigdetails.Section>();
        for(Apttus_Config2__ClassificationHierarchy__c category : categoryList) {
            if(topLevelCategoryIdSet.contains(category.Id)) {
                sectionList.add(mapCatIdSection.get(category.Id));
            }
        }
        
        return sectionList;
    }
    
    /*
    Creates Section for the Category record passed as parameter
    */
    private DCConfigdetails.Section createSectionForCategory(Apttus_Config2__ClassificationHierarchy__c category) {
        DCConfigdetails.Section section = new DCConfigdetails.Section();
        if(category != null) {
            section.categoryId = category.Id;
            if(category.Apttus_Config2__Level__c != null){
                section.sectionLevel = category.Apttus_Config2__Level__c.intValue();
            }
            else{
                section.sectionLevel = null;
            }
            section.sectionTitle = category.Apttus_Config2__Label__c;
            section.isSectionTitleVisible = category.DC_Is_Title_Visible__c;
            section.isMultiSelect = false;
            if(category.DC_Sequence_No__c != null){
                section.sequenceNo = category.DC_Sequence_No__c.intValue();
            }
            else{
                section.sequenceNo = null;
            }
            if((category.Apttus_Config2__ProductCount__c != null) && (category.Apttus_Config2__ProductCount__c > 0)){
                section.hasProducts = true;
            }
            else{
                section.hasProducts = false;
            }
        }
        return section;
    }
    
    /*
    Creates List of Cart Items for the category passed as parameter.
    The Category passed to this method should have underlying Products.
    */
    private List<DCConfigdetails.CartItem> createCartItemsForCategory(Id categoryId) {
        List<DCConfigdetails.CartItem> cartItemsList = new List<DCConfigdetails.CartItem>();
                
        List<Apttus_Config2__ProductClassification__c> prodDetailsList;
        if (categoryProdClassificationMap.containsKey(categoryId)) {
            prodDetailsList = categoryProdClassificationMap.get(categoryId);
        }
        else {
            prodDetailsList = new List<Apttus_Config2__ProductClassification__c>();
        }
        
        Decimal bestValueSequence = 0;       
        for (Apttus_Config2__ProductClassification__c prodDetail : prodDetailsList) {
            if(bvQuoteProdIdLineItemIdMap.containsKey(prodDetail.Apttus_Config2__ProductId__c)) {
                bestValueSequence = prodDetail.Apttus_Config2__Sequence__c;
            }
        } 
        
        //Decimal selectedSeqNumber = 0;     
        for (Apttus_Config2__ProductClassification__c prodDetail : prodDetailsList) {
            if(bestValueSequence <= prodDetail.Apttus_Config2__Sequence__c) {
                DCConfigdetails.CartItem cartItem = new DCConfigdetails.CartItem();
               
                cartItem.productId = prodDetail.Apttus_Config2__ProductId__c;
                cartItem.quoteLineItemId = custQuoteProdIdLineItemIdMap.get(prodDetail.Apttus_Config2__ProductId__c);
                cartItem.sequenceNo = prodDetail.Apttus_Config2__Sequence__c;
                cartItem.isDisabled = false; 
                if (custQuoteProdIdLineItemIdMap.containsKey(prodDetail.Apttus_Config2__ProductId__c)) {                            
                    cartItem.isSelected = true; 
                    //selectedSeqNumber = cartItem.sequenceNo;
                }
                else {
                    cartItem.isSelected = false;
                }
                cartItem.matrices = productToPriceMatricesMap.get(prodDetail.Apttus_Config2__ProductId__c);
                cartItem.isBestValue = bvQuoteProdIdLineItemIdMap.containsKey(prodDetail.Apttus_Config2__ProductId__c) ? true : false;
                cartItem.title =  prodDetail.DC_Product_Title__c;
                cartItem.description = prodDetail.DC_Product_Description__c; 

                cartItem.price = productDiscountedPriceMap.get(prodDetail.Apttus_Config2__ProductId__c);

                if(cartItem.price != null) {
                    cartItem.price = cartItem.price.setScale(2);
                    String price = String.valueOf(cartItem.price);
                    if(price.indexOf('.') > -1){
                        cartItem.priceCentPart = price.right(price.length() - price.indexOf('.') - 1).left(2);
                        cartItem.priceDollarPart = price.left(price.indexOf('.'));
                    }
                    else{
                        cartItem.priceCentPart = '00';
                        cartItem.priceDollarPart = price;
                    }
                } 
                else {
                    cartItem.priceCentPart = '00';
                    cartItem.priceDollarPart = '0';                 
                } 
                
                cartItem.jurisdiction = prodDetail.DC_Product_Jurisdiction__c; 
                
                cartItemsList.add(cartItem);
            }
        } 
        
        return cartItemsList;
    }
    
    /*
    Queries and gets details from Custom Metatdata Type DC Contract Term based on Segment Corporate and Small law
    */
    public static List<DCConfigdetails.ContractTermWrapper> getContractTermWrapperList(String cQContractTerm, String bvQContractTerm,String quoteType,Integer customerCategory,String segmentType) {
        List<DCConfigdetails.ContractTermWrapper> contractTermWrapperList = new List<DCConfigdetails.ContractTermWrapper>();
        
        List<DC_Contract_Term_V2__mdt> contractTerms =new List<DC_Contract_Term_V2__mdt>(); //DLT-11733
        /*= [select Markup_Percentage__c,Sequence_No__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c From DC_Contract_Term_V2__mdt 
                                                         Where Customer_Category__c =: customerCategory 
                                                         and Quote_Type__c =: quoteType ORDER BY  Sequence_No__c ];
        if(customerCategory == null || contractTerms.isEmpty())
            contractTerms = [select Markup_Percentage__c,YoY_1_Renewal__c,Sequence_No__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c 
                             from DC_Contract_Term_V2__mdt 
                             where Default_Customer_Category__c = true 
                             and Quote_Type__c =: quoteType ORDER BY  Sequence_No__c ];*/
    
    //DLT-11733 to prevent SOQL Injection
    String strQuoteType =  String.escapeSingleQuotes(quoteType);
    String strSegmentType = String.escapeSingleQuotes(segmentType);        

    //DLT-11734 Ends
        String query ='select Markup_Percentage__c,Sequence_No__c,DC_Years_2_Plus_Adjustment__c, Contract_Term__c,Customer_Category__c,Segment__c,Default_Customer_Category__c from DC_Contract_Term_V2__mdt where Quote_Type__c =';
        query = query +'\''+ strQuoteType +'\' AND Segment__c=\''+strSegmentType ;
       
        if(customerCategory != null && customerCategory != 0){ //DLT-11733
            String strCustomerCategory = String.valueOf(customerCategory);     
            query = query + '\' AND Customer_Category__c ='+String.escapeSingleQuotes(strCustomerCategory);
        }else{
            query = query + '\' AND Default_Customer_Category__c = true' ;
        }    
        query=query + ' ORDER BY Sequence_No__c';
        system.debug('Query :' +query);
        contractTerms = Database.query(query);
        for (DC_Contract_Term_V2__mdt contractTermSetting : contractTerms ) {
        
            DCConfigdetails.ContractTermWrapper contractTerm = new DCConfigdetails.ContractTermWrapper();              
            contractTerm.term = contractTermSetting.Contract_Term__c;
            contractTerm.sequenceNo = contractTermSetting.Sequence_No__c.intValue();
            contractTerm.markupPercentage = contractTermSetting.Markup_Percentage__c;
            contractTerm.isSelected = cQContractTerm == contractTermSetting.Contract_Term__c ? true : false;
            contractTerm.isBestValue = bvQContractTerm == contractTermSetting.Contract_Term__c ? true : false;
            contractTermWrapperList.add(contractTerm);  
        }
        
        return contractTermWrapperList;
    }
    
    /*
    Prepares Pricing map for Products using the Product Matrix based on the Products, Quantity and Customer Pricing Segment
    passed as parameter.
    */
    public static Map<Id, Decimal> getPrice(Set<Id> productIdSet, Integer quantity, String customerPricingSegment) {

        String strQuantity;
        if(quantity == null){
            strQuantity = '0';
        }
        else{
            strQuantity = String.valueOf(quantity);
        }

        Map<Id, Decimal> productPriceMap = new Map<Id, Decimal>();
        for(Apttus_Config2__PriceMatrixEntry__c matrixEntry : [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, 
                                                                      Apttus_Config2__AdjustmentAmount__c, 
                                                                      Apttus_Config2__AdjustmentType__c 
                                                                FROM  Apttus_Config2__PriceMatrixEntry__c 
                                                                WHERE Apttus_Config2__Dimension1Value__c = :strQuantity AND 
                                                                      Apttus_Config2__Dimension2Value__c = :customerPricingSegment AND 
                                                                      Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c In :productIdSet]) {

            productPriceMap.put(matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, 
                                        matrixEntry.Apttus_Config2__AdjustmentAmount__c);

        }    
        
        return productPriceMap;    
        
    }
    
    public Map<String,List<DCConfigdetails.PriceMatrix>> getPriceMatrix(Set<Id> productIdSet, Integer maxNoOfAttorneys) {
        
        Set<String> attorneys = new Set<String>();
        for(Integer i=1; i<= maxNoOfAttorneys; i++){
            attorneys.add(String.valueOf(i));
        }
        
        Map<String,List<DCConfigdetails.PriceMatrix>> productToPriceMatrices = new Map<String,List<DCConfigdetails.PriceMatrix>>();
        
        for(Apttus_Config2__PriceMatrixEntry__c matrixEntry : [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, Apttus_Config2__Dimension1Value__c,
                                                                      Apttus_Config2__AdjustmentAmount__c, 
                                                                      Apttus_Config2__AdjustmentType__c 
                                                                FROM  Apttus_Config2__PriceMatrixEntry__c 
                                                                WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension1Id__r.name = :STR_DIMENSION1_NAME  
                                                                and Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c in :productIdSet 
                                                                and Apttus_Config2__Dimension1Value__c in :attorneys 
                                                                And Apttus_Config2__Dimension2Value__c =: customerPricingSegment ]) {
            DCConfigdetails.PriceMatrix matrix = new DCConfigdetails.PriceMatrix();
            matrix.ProductId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
            matrix.amount = matrixEntry.Apttus_Config2__AdjustmentAmount__c;
            matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension1Value__c);
            
            if(productToPriceMatrices.get(matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c) == null){ //DLT-11733
                productToPriceMatrices.put(matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c,new List<DCConfigdetails.PriceMatrix>());
      }
            productToPriceMatrices.get(matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c).add(matrix);
        }    
        
        return productToPriceMatrices;    
    }
    
    public Map<String,List<DCConfigdetails.PriceMatrix>> getPriceMatrixV2(Set<Id> productIdSet, Integer maxNoOfAttorneys) {
        Set<String> attorneys = new Set<String>();
        
        for(Integer i=1; i<= maxNoOfAttorneys; i++){
            attorneys.add(String.valueOf(i));
        }
        
        Map<String, List<DCConfigdetails.PriceMatrix>> productToPriceMatrices = new Map<String, List<DCConfigdetails.PriceMatrix>>();
        Map<String, Map<Integer, DCConfigdetails.PriceMatrix>> quantityPriceMatrixMap = new Map<String, Map<Integer, DCConfigdetails.PriceMatrix>>();
        for(Apttus_Config2__PriceMatrixEntry__c matrixEntry : [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, Apttus_Config2__Dimension1Value__c,
                                                               Apttus_Config2__AdjustmentAmount__c, 
                                                               Apttus_Config2__AdjustmentType__c 
                                                               FROM  Apttus_Config2__PriceMatrixEntry__c 
                                                               WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN :productIdSet 
                                                               AND Apttus_Config2__Dimension1Value__c in :attorneys  
                                                               AND Apttus_Config2__Dimension2Value__c =: customerPricingSegment]) {
            DCConfigdetails.PriceMatrix matrix = new DCConfigdetails.PriceMatrix();
            matrix.ProductId = matrixEntry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
            matrix.amount = matrixEntry.Apttus_Config2__AdjustmentAmount__c;
            matrix.quantity = Integer.valueOf(matrixEntry.Apttus_Config2__Dimension1Value__c);
            if(!quantityPriceMatrixMap.keySet().contains(matrix.ProductId)){ //DLT-11733
                quantityPriceMatrixMap.put(matrix.ProductId, new Map<Integer, DCConfigdetails.PriceMatrix>());
      }
            quantityPriceMatrixMap.get(matrix.ProductId).put(matrix.quantity, matrix); 
        }
        
        for(String prodId : quantityPriceMatrixMap.keySet()) {
            DCConfigdetails.PriceMatrix prevMatrix = null;
            for(Integer i=maxNoOfAttorneys; i >= 1; i--) {
                //prevMatrix = prevMatrix != null? prevMatrix : quantityPriceMatrixMap.get(prodId).get(i).clone();
                if(!quantityPriceMatrixMap.get(prodId).keySet().contains(i)) {
                    if(prevMatrix == null) {
                        prevMatrix = new DCConfigdetails.PriceMatrix();
                        prevMatrix.amount = 0;
                        prevMatrix.ProductId = prodId;
                    }
                    prevMatrix.quantity = i;
                    quantityPriceMatrixMap.get(prodId).put(i, prevMatrix.clone());            
                }
                prevMatrix = quantityPriceMatrixMap.get(prodId).get(i).clone();
            }
        }
        
        for(String prodId : quantityPriceMatrixMap.keySet()) {
            productToPriceMatrices.put(prodId, sortMap(quantityPriceMatrixMap.get(prodId), 'ASC').values());
        }
        
        System.debug(JSON.serialize(productToPriceMatrices));
        return productToPriceMatrices;     
    }  
    
    public Map<Integer, DCConfigdetails.PriceMatrix> sortMap (Map<Integer, DCConfigdetails.PriceMatrix> theMap, String theOrder) {
        //create the return map
        Map<Integer, DCConfigdetails.PriceMatrix> returnMap = new Map<Integer, DCConfigdetails.PriceMatrix>();
        //get the set of the keys of the map we want to sort
        Set<Integer> keySet = theMap.keySet();
        //create a list and add all the keys from the set to sort
        List<Integer> keyList = new List<Integer>();
        keyList.addAll(keySet);
        //sort the list ascending (predefined behaviour)
        keyList.sort();
        if (theOrder == 'DESC'){
            //iterate from the last to the first key over the ascending ordered key list
            for (Integer i = (keyList.size() - 1); i >= 0; i--){
                returnMap.put(keyList[i], theMap.get(keyList[i]));
      }
        }else{
            //iterate from the first to the last key over the ascending ordered key list
            for (Integer i = 0; i < keyList.size(); i++){
                returnMap.put(keyList[i], theMap.get(keyList[i]));
      }
    }
        //return the sorted map
        return returnMap;
    }

    /*
    Compares Best Value and Custom Quotes and updates Custom Quote field "Updated on Configurator" accordingly.
    */
    public void compareCustomAndBV() {
        if((bvQuoteProductIdSet != null) && (customQuoteProductIdSet != null)) {
            if(bvQuoteProductIdSet.equals(customQuoteProductIdSet) && (bvNoOfAttorneys == quoteNoOfAttorneys) && (customQuoteContractTerm == bvQuoteContractTerm) && (updatedOnConfigurator == true)) {
        List<Apttus_Proposal__Proposal__c> customQuoteList;
                if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){ //DLT-11733
                      customQuoteList = [SELECT    Id, DC_Updated_On_Configurator__c 
                                                                    FROM    Apttus_Proposal__Proposal__c
                                                                    WHERE   Id = :customQuoteId];
                
          if((customQuoteList != null) && (!customQuoteList.isEmpty())) {
            Apttus_Proposal__Proposal__c customQuote = customQuoteList[0];
            customQuote.DC_Updated_On_Configurator__c = false;
            if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
                Update customQuote;
            }
            updatedOnConfigurator = false;
          }
                }
            } else {
                if(((!bvQuoteProductIdSet.equals(customQuoteProductIdSet)) || (bvNoOfAttorneys != quoteNoOfAttorneys) || (customQuoteContractTerm != bvQuoteContractTerm)) && (updatedOnConfigurator == false)) {
          List<Apttus_Proposal__Proposal__c> customQuoteList;
          if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){ //DLT-11733
                          customQuoteList = [SELECT    Id, DC_Updated_On_Configurator__c 
                                                                        FROM    Apttus_Proposal__Proposal__c
                                                                        WHERE   Id = :customQuoteId];
                    
            if((customQuoteList != null) && (!customQuoteList.isEmpty())) {
              Apttus_Proposal__Proposal__c customQuote = customQuoteList[0];
              customQuote.DC_Updated_On_Configurator__c = true;
              if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
                Update customQuote;
              }
              updatedOnConfigurator = true;
            }
                    }
                }
                
            }
        }
        
    }
    
    /*
    Prepares the Map of Discounted price for Products and Price map passed as parameter
    using the adjustment Type and adjustment Amount.
    */
    public static Map<Id, Decimal> getDiscountedPrice(Map<Id, Decimal> productPriceMap, String adjustmentType, Decimal adjustmentAmount) {
        Map<Id, Decimal> productDiscountedPriceMap = new Map<Id, Decimal>();
        Decimal tempAdjustmentAmount;
        if(adjustmentAmount == null){
            tempAdjustmentAmount = 0.0;
        }
        else{
            tempAdjustmentAmount = adjustmentAmount;
        }
        for(Id productId : productPriceMap.keySet()) {
            Decimal adjustedPrice = productPriceMap.get(productId);
            
            //Check whether % discount is required or % markup
            if(adjustmentType == Label.DC_PERCENT_DISCOUNT) {
                adjustedPrice = adjustedPrice * ((100 - tempAdjustmentAmount)/100);
            } else {            
                if(adjustmentType == Label.DC_PERCENT_MARKUP) {
                    adjustedPrice = adjustedPrice * ((100 + tempAdjustmentAmount)/100);
                }
            }
            
            productDiscountedPriceMap.put(productId, adjustedPrice);
        }    
        
        return productDiscountedPriceMap;    
        
    }
    
    /*
    Synchronizes Line Items and amount between Cart and Quote. Queries for the Finalized Cart within the Quote
    and executes the API to synchronize the same.
    */
    public static Boolean synchronizeCart(Id quoteId) {
        List<DC_Global_Settings__mdt> globalSettingList;
        if(Schema.sObjectType.DC_Global_Settings__mdt.isQueryable()){  //DLT-11733
                        globalSettingList = [SELECT    Login_Domain__c,
                                                                               Username__c,
                                                                               Password__c,
                                                                               Security_Token__c,
                                                                               Request_Timeout__c,
                                                                               Use_API_User__c
                                                                       FROM    DC_Global_Settings__mdt
                                                                       LIMIT    1];
        }
        if((globalSettingList != null) && (!globalSettingList.isEmpty())) {
        
            if(globalSettingList[0].Use_API_User__c == false) {
                DCConfiguratorUtil.synchronizeCart(quoteId);
            } else {
                DCConfiguratorUtil.synchronizeCartAsAPIUser(quoteId, globalSettingList[0]);             
            }
        } else {
            DCConfiguratorUtil.synchronizeCart(quoteId);
        }
        // Digital Product Xref is now obsolete
        //DCConfiguratorUtil.updateDBCategories(quoteId);     
        
        return false;
    }

    public static DCMessage synchronizeCart(List<String> quoteIdList) {
        DCMessage response = new DCMessage();
    List<DC_Global_Settings__mdt> globalSettingList;
        if(Schema.sObjectType.DC_Global_Settings__mdt.isQueryable()){  //DLT-11733
                        globalSettingList = [SELECT    Login_Domain__c,
                                                                               Username__c,
                                                                               Password__c,
                                                                               Security_Token__c,
                                                                               Request_Timeout__c,
                                                                               Use_API_User__c
                                                                       FROM    DC_Global_Settings__mdt
                                                                       LIMIT    1];
    }
        String currentQuoteId = '';
        try{
            for(String quoteId : quoteIdList){
                currentQuoteId = quoteId + ' (synchronizeCartAsAPIUser)';    
                if((globalSettingList != null) && (!globalSettingList.isEmpty()) && globalSettingList[0].Use_API_User__c == true) {
                    DCConfiguratorUtil.synchronizeCartAsAPIUser(quoteId, globalSettingList[0]);             
                } else {
                    DCConfiguratorUtil.synchronizeCart(quoteId);
                }
            }
            // Digital Product Xref is now obsolete
            //for(String quoteId : quoteIdList) {   
            //    currentQuoteId = quoteId + ' (updateDBCategories)';             
            //    DCConfiguratorUtil.updateDBCategories(quoteId); 
            //}
            response.code = 200;
            response.severity = 'Success';
            return response;
        }catch(Exception ex){
            DCUtils.trackLog(ex,'DCConfiguratorImplServiceV2','synchronizeCart');
            response.code = 400;
            response.cause = currentQuoteId + ': ' +ex.getMessage();
            response.severity = 'Exception';
            return response;
        }  

    }
    public static DCMessage envelopeCreation(List<String> quoteIdList) {
        DCMessage response = new DCMessage();
        String currentQuoteId = '';
        try{
            for(String quoteId : quoteIdList){
                currentQuoteId = quoteId;
                 DigitalDocuSignUpdateDocument.envelopeCreation(quoteId);
            }
            response.code = 200;
            response.severity = 'Success';
            return response;
        }catch(Exception ex){
            DCUtils.trackLog(ex,'DCConfiguratorImplServiceV2','envelopeCreation');
            response.code = 400;
            response.cause = currentQuoteId + ': ' +ex.getMessage();
            response.severity = 'Exception';
            return response;
        }  
    }
    
    public static DCMessage generatePDFDocByQuoteIds(List<String> quoteIdList){
        DCMessage response = new DCMessage();
        String currentQuoteId = '';
        try{
            for(String quoteId : quoteIdList){
                currentQuoteId = quoteId;
                 DigitalDocuSignUpdateDocument.updateEnvelope(quoteId);
            }
            response.code = 200;
            response.severity = 'Success';
            return response;
        }catch(Exception ex){
            DCUtils.trackLog(ex,'DCConfiguratorImplServiceV2','generatePDFDocByQuoteIds');
            response.code = 400;
            response.cause = currentQuoteId + ': ' +ex.getMessage();
            response.severity = 'Exception';
            return response;
        }  
        
    }
 
}