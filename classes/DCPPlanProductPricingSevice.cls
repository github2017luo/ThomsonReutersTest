/* Class: DCPPlanProductPricingSevice
* Purpose: This class is for holding the business logic for product plan & pricing - DCPProductRequestHandler
* Created: 5/18/2021
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 05/18/2021    Avudaiappan A    DCP-1820     Created 
* =============================================================================
*/
/** 
* @description : This is the class to handle the product plan & product detail business logic
*/ 
public with sharing class DCPPlanProductPricingSevice {
    
    public static Set<Id> prodIdSet = new Set<Id>();
    /** 
* @description : Versioning for brand/ product offering value
*/ 
    public static String brandVersion {
        get{
            if(brandVersion == null){
                brandVersion = Static_Values__c.getValues('DCPNSBrandVersioning')<> null ? Static_Values__c.getValues('DCPNSBrandVersioning').Value__c : 'v1';
            }
            return brandVersion;
        }
        set;
    }   
    
    /********************************************************************************************************
*  @description  getPlanDetails - This is the main method to handle the product Array  
*  @return Map<String,product2>  : this is a return statement and having the product Array
*  @param productCodes - hold product Codes
*  @param inputRequestMap - hold input request params
*********************************************************************************************************/
    
    public static Map<String,product2> getPlanDetails(Map<string,UEStoreUSLPlan__mdt> productCodes, Map<String,String> inputRequestMap){
        Map<String,product2> productMap = new Map<String,product2>(); 
        set<string> prodCodes;
        prodCodes = productCodes.keyset();
        String segment;
        String brand;
        string contentType;
        String jurisdiction;
        segment = inputRequestMap.get('segment');
        brand = inputRequestMap.get('brand');
        contentType= inputRequestMap.get('contentType');
        jurisdiction = inputRequestMap.get('jurisdiction');
        String query;
        //String query1 = 'Select MasterLabel,DeveloperName,Best_Plan__c,Better_Plan__c,Good_Plan__c,Other_Best_Plan__c,Other_Better_Plan__c,Jurisdiction__c,Segment__c,Sub_Segment__c,Brand__c,Content_Type__c from UEStoreUSLPlan__mdt where Segment__c =:segment and Brand__c =:brand';
        //String query1 = 'Select MasterLabel,DeveloperName,Best_Plan__c,Better_Plan__c,Good_Plan__c,Other_Best_Plan__c,Other_Better_Plan__c,Jurisdiction__c,Segment__c,Sub_Segment__c,Brand__c,Content_Type__c from UEStoreUSLPlan__mdt';
        String query1 =  DCPNewSalesAddOnUtility.formCustomMetadataQueryCondition(inputRequestMap);
        List<UEStoreUSLPlan__mdt> planInfo = Database.Query(query1);
      
        if(!planInfo.isEmpty()) {
            String validSellableStatus = Static_Values__c.getValues('NewSaleSellableFlag').Value__c;
            List<String> sellableValuesList = new List<String>();
            sellableValuesList = validSellableStatus.split(',');
            
            if(brandVersion == 'v2'){
                system.debug(loggingLevel.INFO,'brandVersion v2 >>'+brandVersion);
                query ='Select id,productcode,Name,format__c,Free_Trial__c,DC_Long_Description__c,DC_Short_Description__c,Apttus_Config2__ConfigurationType__c,Apttus_Filter_Jurisdiction__c,LCRM_Product_Type__c,APTS_Product_Pricing_Model__c,CPD_Sellable_Description__c,Product_Offering__c,Plan_Title__c from product2 where productcode IN:prodCodes and CPD_Sellable_Description__c IN:sellableValuesList and Product_Offering__c =: brand'; 
                system.debug(loggingLevel.INFO,'query>>'+database.query(query));
            } 
            else {
                system.debug(loggingLevel.INFO,'brandVersion  >>'+brandVersion);
                query ='Select id,productcode,Name,format__c,Free_Trial__c,DC_Long_Description__c,DC_Short_Description__c,Apttus_Config2__ConfigurationType__c,Apttus_Filter_Jurisdiction__c,LCRM_Product_Type__c,APTS_Product_Pricing_Model__c,CPD_Sellable_Description__c,Product_Offering__c,Plan_Title__c from product2 where productcode IN:prodCodes and CPD_Sellable_Description__c IN:sellableValuesList'; 
                system.debug(loggingLevel.INFO,'query>>'+database.query(query));
            }
            
            
            if (database.query(query) != null) {
                for(product2 prod: database.query(query)){
                    productMap.put(prod.productcode,prod);
                    system.debug(loggingLevel.INFO,'BRAND>>'+prod.Product_Offering__c );
                    prodIdSet.add(prod.Id);
                }
            }
        }
        return productMap;
    }
    /********************************************************************************************************
*  @description  getProductFeature - This is the main method to handle the product feature Array  
*  @return Map<String,list<Product_Platform_Value__c>>  : this is a return statement and having the product feature Array
*  @param productCodes - expected the product parameters
*********************************************************************************************************/
    public static Map<String,list<Product_Platform_Value__c>> getProductFeature (Map<string,UEStoreUSLPlan__mdt> productCodes){
        Map<String,list<Product_Platform_Value__c>> productPlatformFeaturesMap = new Map<String,list<Product_Platform_Value__c>>();
        set<string> prodCodes = productCodes.keyset();
         String platformValueOrderBy;
         platformValueOrderBy = Static_Values__c.getValues('PlatformValueOrderBy').Value__c;
        system.debug(loggingLevel.INFO,'ProductCodes >>'+prodCodes);
        string query = 'Select id,Product__r.productCode,Product_Platform__r.Platform_Category__c,Product_Platform__r.Platform_Category_Feature__c,Product_Platform__r.Platform_Group__c, Product_Platform__r.Platform_Category_Benefit__c,Product_Platform__r.PlatformCategorySortOrder__c,Product_Platform__r.PlatformSortOrder__c from Product_Platform_Value__c where Product__r.ProductCode IN:prodCodes ' + platformValueOrderBy;
        for(Product_Platform_Value__c pfv: Database.Query(query)){
            String productId = pfv.Product__r.productCode;
            if(productPlatformFeaturesMap.containsKey(productId)) {
                List<Product_Platform_Value__c> pfvList = productPlatformFeaturesMap.get(productId);
                pfvList.add(pfv);
                productPlatformFeaturesMap.put(productId,pfvList);
            } else {
                productPlatformFeaturesMap.put(productId, new List<Product_Platform_Value__c> { pfv });
            }
        }
        return productPlatformFeaturesMap;
    }
    
    /********************************************************************************************************
*  @description  getPrice - This is the main method to handle the pricing Array  
*  @return Map<String,list<Apttus_Config2__PriceMatrixEntry__c>>  : this is a return statement and having the price matrix Array
*  @param productCodes - expected the product parameters 
*  @param segment - expected the segment parameters 
*********************************************************************************************************/
    
    public static Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> getPrice (Map<string,UEStoreUSLPlan__mdt> productCodes, String segment){
        Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> quantityPriceMatrixMap = new Map<String,List<Apttus_Config2__PriceMatrixEntry__c>>();
        Map<Decimal, Apttus_Config2__PriceMatrixEntry__c> mapPriceMatrixEntry;
        mapPriceMatrixEntry = new Map<Decimal, Apttus_Config2__PriceMatrixEntry__c>();
        Set<String> prodCodes =  productCodes.keyset();
        system.debug(loggingLevel.INFO,'ProductCodes >>'+prodCodes);
        Set < String > attorneys = new Set < String > ();
        for (Integer i = 1; i <= 25; i++) {
            attorneys.add(String.valueOf(i));
        }
        string query = 'SELECT Id,Apttus_Config2__Sequence__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceListId__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.CurrencyIsoCode,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__Frequency__c,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.productCode,Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.Product_Offering__c,Apttus_Config2__Dimension1Value__c, Apttus_Config2__Dimension2Value__c, Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c FROM Apttus_Config2__PriceMatrixEntry__c WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.productCode IN:prodCodes  AND Apttus_Config2__Dimension2Value__c =:segment AND Apttus_Config2__Dimension1Value__c IN:attorneys order by Id DESC ';
        Map<Decimal, Decimal> dim1SeqMap;
        dim1SeqMap = new Map<Decimal,Decimal>();
        
        
        for(Apttus_Config2__PriceMatrixEntry__c pme: Database.Query(query)){
        system.debug(loggingLevel.INFO,'pme>>'+pme);
        // if (pme!=null){
         system.debug(loggingLevel.INFO,'pme>>'+pme);
          String productId = pme.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.productCode;
            if(quantityPriceMatrixMap.containsKey(productId)) {
                List<Apttus_Config2__PriceMatrixEntry__c> pmeList = quantityPriceMatrixMap.get(productId);
                pmelist.add(pme);
                quantityPriceMatrixMap.put(productId,pmelist);
            } else {
                quantityPriceMatrixMap.put(productId, new List<Apttus_Config2__PriceMatrixEntry__c> { pme });
            }
        // }
        }
        Map<String, List<Apttus_Config2__PriceMatrixEntry__c>> mapMatrixEntry = getCorrectMatrixEntries(quantityPriceMatrixMap);
        if(!mapMatrixEntry.isEmpty()){
            system.debug(loggingLevel.INFO,'mapMatrixEntry>>'+mapMatrixEntry);
            return mapMatrixEntry;
        }else {
            system.debug(loggingLevel.INFO,'mapMatrixEntry>>'+mapMatrixEntry);
            return quantityPriceMatrixMap;
        }
        //return quantityPriceMatrixMap;
    }
    
    private static Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> getCorrectMatrixEntries(Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> quantityPriceMatrixMap){
       Map<String, List<Apttus_Config2__PriceMatrixEntry__c>> mapMatrixEntry = new Map<String, List<Apttus_Config2__PriceMatrixEntry__c>>();
        for(String prodId : quantityPriceMatrixMap.keySet()){
            List<Apttus_Config2__PriceMatrixEntry__c> pmList = quantityPriceMatrixMap.get(prodId);
            List<Apttus_Config2__PriceMatrixEntry__c> entryList;
            entryList = new List<Apttus_Config2__PriceMatrixEntry__c>();
            Map<Decimal, Decimal> dim1SeqMap;
            dim1SeqMap = new Map<Decimal,Decimal>();
            fetchCorrectEntries(prodId,pmList,mapMatrixEntry);            
        }
        return mapMatrixEntry;
    }
    
    private static void fetchCorrectEntries(String prodCode, List<Apttus_Config2__PriceMatrixEntry__c> pmList, Map<String, List<Apttus_Config2__PriceMatrixEntry__c>> mapMatrixEntry){
        Map<Decimal, Apttus_Config2__PriceMatrixEntry__c> mapPriceMatrixEntry = new Map<Decimal, Apttus_Config2__PriceMatrixEntry__c>();
        Map<Decimal, Decimal> dim1SeqMap = new Map<Decimal,Decimal>();
        for(Apttus_Config2__PriceMatrixEntry__c entry:pmList){
                Decimal key = Decimal.valueOf(entry.Apttus_Config2__Dimension1Value__c);
            Decimal value = entry.Apttus_Config2__Sequence__c;  
                
                if(dim1SeqMap.containsKey(key)){
                    if(dim1SeqMap.get(key) > value) {
                       dim1SeqMap.put(key,value);
                       mapPriceMatrixEntry.put(key, entry);
                    }
                }else{
                    dim1SeqMap.put(key,Value); 
                    mapPriceMatrixEntry.put(key, entry);
                }
                    
         }

    if(!mapPriceMatrixEntry.isEmpty()){
           mapMatrixEntry.put(prodCode,mapPriceMatrixEntry.values());
        }
    }
    
    /********************************************************************************************************
*  @description  getPlanId - This is the main method to handle the product info from custom metadata   
*  @return Map<String,UEStoreUSLPlan__mdt>  : this is a return statement and having the product & plan info
*  @param inputRequestMap - hold input request params
*********************************************************************************************************/
    
    public static Map<String,UEStoreUSLPlan__mdt> getPlanId(Map<String, String> inputRequestMap){
        String segment;
        String brand;
        string jurisdiction;
        string contentType;
        String serviceModule;
        serviceModule = inputRequestMap.get('serviceModule');
        segment = inputRequestMap.get('segment');
        brand = inputRequestMap.get('brand');
        jurisdiction= inputRequestMap.get('jurisdiction');
        contentType= inputRequestMap.get('contentType');
        //*****Practical Law Changes -- Start***/////
        /*String whereCondition = ' where Brand__c =:brand and Segment__c =:segment';
        if(brand == 'Practical Law' && segment == 'Law Firm'){
            whereCondition += ' and Content_Type__c = :contentType and jurisdiction__c =:jurisdiction';
        }else{
            whereCondition += ' and jurisdiction__c =:jurisdiction';      
        }*/
        String query = 'Select MasterLabel,DeveloperName,Best_Plan__c,Better_Plan__c,Good_Plan__c,Other_Best_Plan__c,Other_Better_Plan__c,Jurisdiction__c,Segment__c,Sub_Segment__c,Brand__c,Content_Type__c,Service_Module__c from UEStoreUSLPlan__mdt ' + DCPNewSalesAddOnUtility.bringWhereConditionForPlan(inputRequestMap);//+' '+ DCPNewSalesAddOnUtility.bringWhereConditionForPlan(inputRequestMap) +' limit 1';
        //*****Practical Law Changes -- End***/////
        List<UEStoreUSLPlan__mdt> planInfo = Database.Query(query);
        return DCPPlanProductPricingSevice.runPlanMDT(planInfo);
    }
    /********************************************************************************************************
*  @description  getPlanInfo - This is the main method to handle the product info from custom metadata   
*  @return Map<String,UEStoreUSLPlan__mdt>  : this is a return statement and having the product & plan info
*  @param segment - expected the segment parameters 
*  @param productCode - expected the productCode parameters
*********************************************************************************************************/
    
    public static Map<String,UEStoreUSLPlan__mdt> getPlanInfo(String segment, String productCode){
        String query = 'Select MasterLabel,DeveloperName,Best_Plan__c,Better_Plan__c,Good_Plan__c,Other_Best_Plan__c,Other_Better_Plan__c,Jurisdiction__c,Segment__c,Sub_Segment__c,Brand__c,Content_Type__c from UEStoreUSLPlan__mdt where Segment__c =:segment and Masterlabel =:productCode  limit 1';
        List<UEStoreUSLPlan__mdt> planInfo = Database.Query(query);
        return DCPPlanProductPricingSevice.runPlanMDT(planInfo);
    }
    /********************************************************************************************************
*  @description  runPlanMDT - This is the main method to handle the product info from custom metadata   
*  @return Map<String,UEStoreUSLPlan__mdt>  : this is a return statement and having the product & plan info
*  @param planInfo - expected the plan info array parameters 
*********************************************************************************************************/
    
    public static Map<String,UEStoreUSLPlan__mdt> runPlanMDT( List<UEStoreUSLPlan__mdt> planInfo){
        Map<String,UEStoreUSLPlan__mdt> getPlanMap = new Map<String,UEStoreUSLPlan__mdt>();
        if(!planInfo.isEmpty()){
            getPlanMap.put(planInfo[0].Best_Plan__c,planInfo[0]);
            getPlanMap.put(planInfo[0].Better_Plan__c,planInfo[0]);
            getPlanMap.put(planInfo[0].Good_Plan__c,planInfo[0]);
            getPlanMap.put(planInfo[0].Other_Better_Plan__c,planInfo[0]);
            getPlanMap.put(planInfo[0].Other_Best_Plan__c,planInfo[0]);
        }
        return getPlanMap;
    }
    
    /********************************************************************************************************
*  @description  processFeatures - This is the main method to handle the product platform features   
*  @return list<DCPProductRequestHandler.FeatureList>  : this is a return statement and having list of product platform features
*  @param prodFeatures - expected the product features parameters 
*  @param prodDetail - expected the product detail parameters 
*********************************************************************************************************/
    public static list<DCPProductRequestDeclaration.FeatureList> processFeatures (list<product_platform_value__c>prodFeatures,product2 prodDetail){
        list<DCPProductRequestDeclaration.FeatureList> featurelst = new list<DCPProductRequestDeclaration.FeatureList>();               
        integer i =1;
        for(product_platform_value__c pr: prodFeatures){
            DCPProductRequestDeclaration.FeatureList fr = new DCPProductRequestDeclaration.FeatureList();
            fr.platformCategory = pr.Product_Platform__r.Platform_Category__c;
            fr.platformCategoryBenefit = pr.Product_Platform__r.Platform_Category_Benefit__c;
            fr.platformCategoryFeature = pr.Product_Platform__r.Platform_Category_Feature__c;
            fr.platformCategorySortOrder = string.valueof(pr.Product_Platform__r.PlatformCategorySortOrder__c); 
            fr.platformGroup = pr.Product_Platform__r.Platform_Group__c;
            fr.platformGroupSortOrder = string.valueof(pr.Product_Platform__r.PlatformSortOrder__c);
            fr.productCode = prodDetail.productCode;
            featurelst.add(fr);
            i++;
        }
        return featurelst;
    }
    
    /********************************************************************************************************
*  @description  productMap - This is the main method to handle the product mapping
*  @return DCPProductRequestHandler.ProductArray  : this is a return statement and having product mapping detail
*  @param prod - expected the product  parameters 
*  @param planMdt - expected the product plan MDT parameters 
*********************************************************************************************************/
    public static DCPProductRequestDeclaration.ProductArray productMap(product2 prod,Map<String,UEStoreUSLPlan__mdt> planMdt){
        DCPProductRequestDeclaration.ProductArray prodDetail = new DCPProductRequestDeclaration.ProductArray();
        prodDetail.productName = prod.Name;
        prodDetail.productId = prod.Id;
        prodDetail.productCode = prod.productCode;
        prodDetail.freeTrial = DCPNewSaleUtilityCls.handleEmptyString(prod.Free_Trial__c, DCPNewSaleUtilityCls.notAvail);
        prodDetail.shortDescription = DCPNewSaleUtilityCls.handleEmptyString(prod.DC_Short_Description__c, DCPNewSaleUtilityCls.notAvail);
        //prodDetail.pricingModel = prod.APTS_Product_Pricing_Model__c;
        prodDetail.longDescription = DCPNewSaleUtilityCls.handleEmptyString(prod.DC_Long_Description__c, DCPNewSaleUtilityCls.notAvail);
        prodDetail.productType = DCPNewSaleUtilityCls.handleEmptyString(prod.LCRM_Product_Type__c, DCPNewSaleUtilityCls.notAvail);
        prodDetail.format =DCPNewSaleUtilityCls.handleEmptyString(prod.Format__c, DCPNewSaleUtilityCls.notAvail);
        if(planMdt!=null && planMdt.size()>0){
           prodDetail.planType = DCPPlanProductPricingSevice.planTypeMapping(prod,planMdt);
           if(prod.Plan_Title__c!=null){
               prodDetail.planName = prod.Plan_Title__c;
           }
           else {
               prodDetail.planName = prod.Name;
           }
        }
        
        return prodDetail;
    }
    
    
    /********************************************************************************************************
*  @description  planTypeMapping - This is the main method to handle the planType mapping
*  @return planType  : this is a return statement and having planType
*  @param prod - expected the product  parameters 
*  @param planMdt - expected the product plan MDT parameters 
*********************************************************************************************************/
     public static String planTypeMapping(product2 prod,Map<String,UEStoreUSLPlan__mdt> planMdt){
        String planType;
        if(planMdt.get(prod.productCode).good_plan__c == prod.productCode){
            planType = 'Good';
        }
        else if(planMdt.get(prod.productCode).better_plan__c == prod.productCode){
            planType = 'Better';
        }
        else if(planMdt.get(prod.productCode).best_plan__c == prod.productCode){
            planType = 'Best';
        }
        else if(planMdt.get(prod.productCode).other_better_plan__c == prod.productCode){
            planType = 'Other Better';
        }
        else if(planMdt.get(prod.productCode).other_best_plan__c == prod.productCode){
            planType = 'Other Best';
        }
        else{
            planType = 'Other';
        }
        return planType;
     }
}