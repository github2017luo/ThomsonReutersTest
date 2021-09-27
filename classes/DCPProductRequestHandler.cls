/* Class: DCPProductRequestHandler
* Purpose: This class is for holding the request params for product plan and product detail services
* Created: 5/13/2021
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 05/13/2021    Avudaiappan A    DCP-1820     Created 
* =============================================================================
*/
/** 
* @description : This is the class to handle the product plan request and map output response 
*/ 
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class DCPProductRequestHandler {
    /** 
* @description : This is the class to structure the response Array
*/ 
    static DCPNewSalesYoYUtil yoyUtil;
    static DCPNewSalesDataUtil.ContractTermPlanWrapper termWrapper;
    //SR property to store context
    public static string context;
    public static DCPProductRequestDeclaration.ProductPlan prodPlan ;
    public static List<DCPProductRequestDeclaration.ProductPlan> planLst ;
    public static list<DCPProductRequestDeclaration.ProductArray> prodRecList;
    public static list<DCPProductRequestDeclaration.ProductArray> prodDetails;
    public static  DCPProductRequestDeclaration.ProductRecommendation prodRec;
    
    public static string segment;
    public static string jurisdiction;
    public static string brand;
    public static string contentType;
    public static DCPProductRequestDeclaration.ProductPlanResponse resp;
    public static Map<String, String> inputRequestMap ;
    private static String serviceVersion {
        get{
            if(serviceVersion == null){
                serviceVersion = Static_Values__c.getValues('DCPNSVersion')<> null ? Static_Values__c.getValues('DCPNSVersion').Value__c : 'v1';
            }
            return serviceVersion;
        }
        set;
    }       
    
    /********************************************************************************************************
*  @description  handleRequest - This is the main method to handle the request  
*  @return DCPProductRequestDeclaration.ProductPlanResponse  : this is a return statement and having return result as failure or success  
*  @param requestBody - expected the request parameters 
*********************************************************************************************************/
    
    public static DCPProductRequestDeclaration.ProductPlanResponse handleRequest (Map<String,String> requestBody){
        resp = new DCPProductRequestDeclaration.ProductPlanResponse();
        boolean requiredParam = false;
        Map<String,UEStoreUSLPlan__mdt> getPlanMap = new Map<String,UEStoreUSLPlan__mdt>();
        inputRequestMap = new Map<String, String>();
        Map<String,product2> productMap = new Map<String,product2>();
        if((requestBody.containskey('segment') && !String.isBlank(requestBody.get('segment'))) && (requestBody.containskey('brand') && !String.isBlank(requestBody.get('brand')))){ 
            //jurisdiction = requestBody.get('jurisdiction');
             inputRequestMap.put('segment',requestBody.get('segment'));
            //inputRequestMap.put('jurisdiction',requestBody.get('jurisdiction'));
            inputRequestMap.put('brand',requestBody.get('brand'));
            inputRequestMap.put('contentType',requestBody.get('contentType'));
            segment = requestBody.get('segment');
            brand = requestBody.get('brand');
           /* if(inputRequestMap.get('segment')=='Corporation') {
                inputRequestMap.put('jurisdiction','General');
            }
            else {
                inputRequestMap.put('jurisdiction',requestBody.get('jurisdiction'));
            }*/
            inputRequestMap = DCPNewSalesAddOnUtility.getJurisdictionForCorp(inputRequestMap,requestBody);
            inputRequestMap.put('serviceModule','PPP');
            contentType=requestBody.get('contentType');
            //getPlanMap = DCPPlanProductPricingSevice.getPlanId(requestBody.get('segment'),requestBody.get('jurisdiction'),requestBody.get('brand'));
           getPlanMap = DCPPlanProductPricingSevice.getPlanId(inputRequestMap);
        }else{
            requiredParam = true;
        }
        productMap = DCPProductRequestHandler.getProduct(getPlanMap,inputRequestMap);
        
        if(!checkForException(productMap,requiredParam,resp)){
            Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> priceMatrixMap = DCPPlanProductPricingSevice.getprice(getPlanMap,requestBody.get('segment'));
            Map<String,list<Product_Platform_Value__c>> productFeaturesMap = DCPPlanProductPricingSevice.getProductFeature(getPlanMap);
            resp = DCPProductRequestHandler.getResponse(productMap,priceMatrixMap,productFeaturesMap);
            resp.planDetails.segment = requestBody.get('segment');
          // resp.planDetails.brand = requestBody.get('brand');
            resp.response = DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.successCode,DCPNewSaleUtilityCls.detailsFound,DCPNewSaleUtilityCls.successStatus);
        }
        
        return resp;
    }
    
    /********************************************************************************************************
*  @description  getTermWrapper - This method fetches New Sales Contract Terms 
*  @return DCPNewSalesDataUtil.ContractTermPlanWrapper  : Returns the mapping of plans and NSCT terms  
*  @param storeName 
*  @param segment and 
*  @param productIds set of productIds
*********************************************************************************************************/
    private static DCPNewSalesDataUtil.ContractTermPlanWrapper getTermWrapper(String storeName, String segment, Set<Id> productIds){
        DCPNewSalesYoYUtil.YoYRequestWrapper youWrap = new DCPNewSalesYoYUtil.YoYRequestWrapper();
        youWrap.productIds = productIds;
        youWrap.storeName = storeName +' '+segment;
        system.debug(loggingLevel.INFO,'storeName>>>'+ youWrap.storeName);
        youWrap.storeType = 'New Sales';
        youWrap.customerSegment = segment;
       
        DCPNewSalesStoreUtility.StoreWrapper storeData = DCPNewSalesStoreUtility.getStoreDetails(youWrap.StoreName, youWrap.customerSegment, youWrap.storeType);
        return DCPNewSalesPlanUtility.getContractPlans(storeData, DCPPlanProductPricingSevice.prodIdSet);    
    }
    
    /********************************************************************************************************
*  @description  checkForException - This is the main method to check exception
*  @return boolean
*  @param productMap - expected the product parameters 
*  @param requiredParam - expected the error parameters 
*  @param resp - expected the response parameters 
*********************************************************************************************************/
    public Static boolean checkForException(Map<String,product2> productMap,boolean requiredParam,DCPProductRequestDeclaration.ProductPlanResponse resp){
        Boolean exceptionOccurred = false;
        if(productMap.isEmpty()&&!requiredParam){
            resp.response = DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.successStatusOne,DCPNewSaleUtilityCls.detailsNotFound,DCPNewSaleUtilityCls.successStatus);
            exceptionOccurred = true;
        }else if(requiredParam){
            resp.response = DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.errorCode,DCPNewSaleUtilityCls.requiredFieldMissing,DCPNewSaleUtilityCls.failureStatus);
            exceptionOccurred=true;
        }
        return exceptionOccurred;
    }
    /********************************************************************************************************
*  @description  getProduct - This is the main method to handle the product
*  @return Map<String,product2>  : this is a return statement and having list of products
*  @param getPlanMap - expected the product parameters 
*  @param inputRequestMap - Input request parameters 
*********************************************************************************************************/
    public static Map<String,product2> getProduct(Map<String,UEStoreUSLPlan__mdt> getPlanMap, Map<String,String> inputRequestMap){
        Map<String,product2> productMap = new Map<String,product2>();
        if(!getPlanMap.isEmpty() && getPlanMap.size()>0){
            productMap = DCPPlanProductPricingSevice.getPlanDetails(getPlanMap,inputRequestMap);
        }
        return productMap;
    }
    /********************************************************************************************************
*  @description  getResponse - This is the main method to handle the response  
*  @return DCPProductRequestHandler.ProductPlanResponse  : this is a return statement and having return result as failure or success  
*  @param productMap - expected the product parameters 
*  @param priceMatrixMap - expected the pricing parameters 
*  @param productFeaturesMap - expected the product fetaures parameters 
*********************************************************************************************************/
    public  static DCPProductRequestDeclaration.ProductPlanResponse getResponse(Map<String,product2> productMap,Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> priceMatrixMap,Map<String,list<Product_Platform_Value__c>> productFeaturesMap){
        DCPProductRequestDeclaration.ProductPlanResponse resp = new DCPProductRequestDeclaration.ProductPlanResponse();
        if(serviceVersion == 'v2' || serviceVersion == 'v3'){
            yoyUtil = new DCPNewSalesYoYUtil();
            yoyUtil.serviceVersion = serviceVersion;
            yoyUtil.termWrapper = getTermWrapper(brand, segment, DCPPlanProductPricingSevice.prodIdSet);
            System.debug(LoggingLevel.ERROR, DCPNewSalesDataUtil.errorMessage);
        }
        if(!productMap.isEmpty()){            
            resp = DCPProductRequestHandler.getProductResponse(productMap,priceMatrixMap,productFeaturesMap);
        }
        return resp;
    }
    /********************************************************************************************************
*  @description  getProductResponse - This is the main method to handle the final response  
*  @return DCPProductRequestDeclaration.ProductPlanResponse  : this is a return statement and having return result as failure or success  
*  @param productMap - expected the product parameters 
*  @param priceMatrixMap - expected the pricing parameters 
*  @param productFeaturesMap - expected the product fetaures parameters 
*********************************************************************************************************/
    
    public static DCPProductRequestDeclaration.ProductPlanResponse getProductResponse(Map<String,product2> productMap,Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> priceMatrixMap,Map<String,list<Product_Platform_Value__c>> productFeaturesMap){
        DCPProductRequestDeclaration.ProductPlanResponse res = new DCPProductRequestDeclaration.ProductPlanResponse();
        Map<String,UEStoreUSLPlan__mdt> planMdt = new Map<String,UEStoreUSLPlan__mdt>();
        List<DCPProductRequestDeclaration.ProductPlan> planLst;
        planLst = new List<DCPProductRequestDeclaration.ProductPlan>();
        Boolean isDetailService = context == 'ProductDetail';
        //Add-on change
        prodRec = new DCPProductRequestDeclaration.ProductRecommendation();
        prodDetails = new list<DCPProductRequestDeclaration.ProductArray>();
        prodRecList = new list<DCPProductRequestDeclaration.ProductArray>();
        prodPlan = new DCPProductRequestDeclaration.ProductPlan();
        
        //prodPlan = planLst[0]; 
        
    planMDT = DCPNewSalesAddOnUtility.processplanMDT(jurisdiction,segment,inputRequestMap);        
        for(product2 prod: productMap.values()){
            if(jurisdiction==null){
                planMdt = DCPPlanProductPricingSevice.getPlanInfo(segment,'P'+String.ValueOf(prod.productCode));
            }
            DCPProductRequestDeclaration.ProductArray prodDetail = new DCPProductRequestDeclaration.ProductArray();
            if(prod!=null && !priceMatrixMap.isEmpty()){
        prodDetail = DCPNewSalesAddOnUtility.processProduct(prod,priceMatrixMap,planMDT);
                List<product_platform_value__c> prodFeatures = new List<product_platform_value__c>(productFeaturesMap.get(prod.productCode));
                if(!prodFeatures.isEmpty()){
                    prodDetail.features = DCPPlanProductPricingSevice.processFeatures(prodFeatures,prod);
                }
            }
            //Add-on change
            if(isDetailService){
              prodRec = DCPProductRequestHandler.getResponseData(planMDT,prodDetail);
            }else{
               prodDetails.add(prodDetail);
               prodPlan.products = prodDetails;
            }
        }
        res.planDetails = isDetailService ? prodRec : prodPlan;
        
        System.debug(loggingLevel.INFO,'productRes::'+res.planDetails);
        return res;
    }
    
    //Add-on change
    private static DCPProductRequestDeclaration.ProductRecommendation getResponseData(Map<String,UEStoreUSLPlan__mdt> planMDT,DCPProductRequestDeclaration.ProductArray prodDetail){
        if(!planMdt.isEmpty() || brand=='Practical Law'){
                prodDetails.add(prodDetail);
            }else{
                prodRecList.add(prodDetail);
            }
        if(!prodRecList.isEmpty()){
            //prodRec.productList = prodRecList;
            prodRec.productAddOnList = prodRecList;//prodRec;
        }
        prodRec.products = prodDetails;
        
        return prodRec;
    }

    /********************************************************************************************************
*  @description  preparePriceData - Internal method to get the price data after applying discounts and YoY if avaiable 
*  @param productId - productId
*  @param entry - price matrix entry record and 
*  @param priceMatrixEntryList - list of priceMatix
*********************************************************************************************************/
    public static void preparePriceData(Id productId, Apttus_Config2__PriceMatrixEntry__c entry, List<DCPNewSalesYoYUtil.PriceMatrix> priceMatrixEntryList){
        Boolean isSuccess = false;
        Boolean isYoYRequested = serviceVersion == 'v2' || serviceVersion == 'v3';
        isSuccess = isYoYRequested ? yoyUtil.getYoyMatrixData(productId,entry,priceMatrixEntryList) : false;
        if(!isSuccess){
            DCPNewSalesYoYUtil.PriceMatrix pl = new DCPNewSalesYoYUtil.PriceMatrix();
            pl.quantity = entry.Apttus_Config2__Dimension1Value__c;
            pl.amount = String.valueOf(entry.Apttus_Config2__AdjustmentAmount__c);
            priceMatrixEntryList.add(pl);
        }
        
    }
     
}