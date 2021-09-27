/* Class: DCPNewSalesAddOnUtility
* Purpose: A utility class to gather plan infomration from a store
* Created: 7/29/2021
**/
/**
* @description A utility class to gather plan infomration from a store
*/
public with sharing class DCPNewSalesAddOnUtility {
    //Add-on change
    public static string segment;
    public static string brand;
  
    /********************************************************************************************************
*  @description  getAddOnDetails - This is the main method to handle the product detail add on request  
*  @return Map<String,Product2>  : this is a return statement and having return result as failure or success  
*  @param sourceProdCode - expected the request parameters for parent/base product
*  @param brand - brand information
*********************************************************************************************************/
 
  public static Map<String,Product2> getAddOnDetails(String sourceProdCode,string brand){
    
        String validSellableStatus = Static_Values__c.getValues('NewSaleSellableFlag').Value__c;
        List<String> sellableValuesList = new List<String>();
        sellableValuesList = validSellableStatus.split(',');
            //Add-on changes - Storename
          String storeName = brand + ' ' +segment;
          Map<String,Product2> productMap = new  Map<String,Product2>();
          if (Schema.sObjectType.APTSECOM_Product_Recommendation__c.isQueryable()){
          LIst<APTSECOM_Product_Recommendation__c> recommendationList = new List<APTSECOM_Product_Recommendation__c>();
            recommendationList = [SELECT APTSECOM_Product__c,Plan__c,Plan__r.Name,APTSECOM_Product__r.Free_Trial__c,
                                  APTSECOM_Product__r.productcode,APTSECOM_Product__r.Name,APTSECOM_Product__r.format__c,APTSECOM_Product__r.DC_Long_Description__c,APTSECOM_Product__r.DC_Short_Description__c,APTSECOM_Product__r.Apttus_Config2__ConfigurationType__c,APTSECOM_Product__r.Apttus_Filter_Jurisdiction__c,APTSECOM_Product__r.LCRM_Product_Type__c,APTSECOM_Product__r.APTS_Product_Pricing_Model__c,APTSECOM_Product__r.CPD_Sellable_Description__c,APTSECOM_Product__r.Product_Offering__c
                                  FROM APTSECOM_Product_Recommendation__c
                                  WHERE APTSECOM_Source_Product__r.ProductCode=:sourceProdCode and APTSECOM_Source_Product__r.CPD_Sellable_Description__c IN:sellableValuesList and APTSECOM_Store__r.name=:storeName];
           
             List<String> productList = new List<String>();
            //Add-on change
            for(APTSECOM_Product_Recommendation__c  recommObject : recommendationList){
                productList.add(recommObject.APTSECOM_Product__c);
                Product2 prod = new Product2(Id = recommObject.APTSECOM_Product__c,
                                productcode = recommObject.APTSECOM_Product__r.productcode,
                                Name = recommObject.APTSECOM_Product__r.Name,
                                format__c = recommObject.APTSECOM_Product__r.format__c,
                                DC_Long_Description__c = recommObject.APTSECOM_Product__r.DC_Long_Description__c,
                                DC_Short_Description__c = recommObject.APTSECOM_Product__r.DC_Short_Description__c,
                                Apttus_Config2__ConfigurationType__c = recommObject.APTSECOM_Product__r.Apttus_Config2__ConfigurationType__c,
                                Apttus_Filter_Jurisdiction__c = recommObject.APTSECOM_Product__r.Apttus_Filter_Jurisdiction__c,
                                LCRM_Product_Type__c = recommObject.APTSECOM_Product__r.LCRM_Product_Type__c,
                                APTS_Product_Pricing_Model__c = recommObject.APTSECOM_Product__r.APTS_Product_Pricing_Model__c,
                                CPD_Sellable_Description__c = recommObject.APTSECOM_Product__r.CPD_Sellable_Description__c,
                                Product_Offering__c = recommObject.APTSECOM_Product__r.Product_Offering__c);
                productMap.put(prod.productcode,prod);
            }
           
            /*String query = 'Select id,productcode,Name,format__c,DC_Long_Description__c,DC_Short_Description__c,Apttus_Config2__ConfigurationType__c,Apttus_Filter_Jurisdiction__c,LCRM_Product_Type__c,APTS_Product_Pricing_Model__c,CPD_Sellable_Description__c,Product_Offering__c FROM Product2 WHERE Id IN: productList';
            for(product2 prod: database.query(query)){
                 productMap.put(prod.productcode,prod);
            }*/
        }
           
           return productMap;
            
     }
   /********************************************************************************************************
*  @description  mapCustomMetadata - This is the main method to handle the product detail request  
*  @return map<String,Object>  : this is a return statement and having return results
*  @param prodMap - expected the request parameters 
*  @param prodMetaDataMap - product Map
*********************************************************************************************************/
    public static map<string,UEStoreUSLPlan__mdt> mapCustomMetadata(Map<String,product2> prodMap,map<string,UEStoreUSLPlan__mdt> prodMetaDataMap){
        if(!prodMetaDataMap.isEmpty() && !prodMap.isEmpty()){
            for(String prodCode:prodMap.Keyset()){
                prodMetaDataMap.put(prodCode,null);
            }
        }
        return prodMetaDataMap;
    }

  /********************************************************************************************************
*  @description  getPricingDetails - This is the main method to handle the Pricing Detail response 
*  @return list<DCPProductRequestDeclaration.PricingDetail>  : this is a return statement and having list of PricingDetail
*  @param priceMap - expected the pricing parameters 
*********************************************************************************************************/   
    
    public static list<DCPProductRequestDeclaration.PricingDetail> getPricingDetails(List<Apttus_Config2__PriceMatrixEntry__c> priceMap){
        list<DCPProductRequestDeclaration.PricingDetail> priceDetailLists = new list<DCPProductRequestDeclaration.PricingDetail>();
      
        if(!priceMap.isEmpty() && priceMap.size()>0){
            
            DCPProductRequestDeclaration.PricingDetail pd = new DCPProductRequestDeclaration.PricingDetail();
            pd.currencyCode = priceMap[0].Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.CurrencyIsoCode;
            pd.billingFrequency = priceMap[0].Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__Frequency__c;
            pd.brand = priceMap[0].Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__r.Product_Offering__c;
            priceDetailLists.add(pd);
            
        }
     
        return priceDetailLists;
    }
    
     /********************************************************************************************************
*  @description  formCustomMetadataQueryCondition - Query condition creator for PPP 
*  @return queryCondition  : query condition string
*  @param inputRequestMap - hold input parameters 
*********************************************************************************************************/
     public static String formCustomMetadataQueryCondition(Map<String,String> inputRequestMap){
     
        String segment = inputRequestMap.get('segment');
        String brand = inputRequestMap.get('brand');
        String contentType = inputRequestMap.get('contentType');
        String queryCondition = 'Select MasterLabel,DeveloperName,Best_Plan__c,Better_Plan__c,Good_Plan__c,Other_Best_Plan__c,Other_Better_Plan__c,Jurisdiction__c,Segment__c,Sub_Segment__c,Brand__c,Content_Type__c from UEStoreUSLPlan__mdt where Segment__c =:segment and Brand__c =:brand';
        if (segment == 'Law Firm' && brand == 'Practical Law' && contentType != null ){
            queryCondition = queryCondition + ' and Content_Type__c=:contentType';
        }
        else if(inputRequestMap.containsKey('jurisdiction') && inputRequestMap.get('jurisdiction')!= null){
            return queryCondition;
        }
        return queryCondition;
    }
    
    /********************************************************************************************************
*  @description  bringWhereConditionForPlan - Query condition creator for PPP 
*  @return whereCondition  : query condition string
*  @param inputRequestMap - hold input parameters 
*********************************************************************************************************/
    public static String bringWhereConditionForPlan(Map<String,String> inputRequestMap){    
        String segment = inputRequestMap.get('segment');
        String brand = inputRequestMap.get('brand');
        String serviceModule;
        serviceModule = inputRequestMap.get('serviceModule');
        String contentType;
        contentType = inputRequestMap.get('contentType');
        String whereCondition = ' where Brand__c =:brand and Segment__c =:segment and Service_Module__c=:serviceModule';
        if(brand == 'Practical Law' && segment == 'Law Firm'){
            whereCondition += ' and Content_Type__c = :contentType and jurisdiction__c =:jurisdiction and Service_Module__c=:serviceModule';
        }else{
            whereCondition += ' and jurisdiction__c =:jurisdiction and Service_Module__c=:serviceModule';      
        }
        return whereCondition;
    }
    
    /********************************************************************************************************
*  @description  getJurisdictionForCor p- Query condition creator for PPP 
*  @return inputRequestMap : updated input parameters 
*  @param inputRequestMap : hold input parameters 
*  @param requestBody - expected the request parameters 
*********************************************************************************************************/
    public static Map<String,String> getJurisdictionForCorp(Map<String,String> inputRequestMap,Map<String,String> requestBody){   
        
        if(inputRequestMap.get('segment')=='Corporation' ) {
            inputRequestMap.put('jurisdiction','General');
        }
        else if(inputRequestMap.get('segment')=='Law Firm' && inputRequestMap.get('brand')=='Practical Law') {
            inputRequestMap.put('jurisdiction','General');
        }
        else if(inputRequestMap.get('segment')=='Government' && inputRequestMap.get('brand')=='Practical Law'){
            inputRequestMap.put('jurisdiction','National/Federal');
        }
        else {
            inputRequestMap.put('jurisdiction',requestBody.get('jurisdiction'));
        }
        return inputRequestMap;
    }
 /********************************************************************************************************
*  @description  processProduct - This is the main method to handle the product info
*  @return DCPProductRequestDeclaration.ProductArray  : this is a return statement and having product array
*  @param prod as product
*  @param priceMatrixMap - priceMatrix Array
*  @param planMdt - map of string, MDT

*************************************************************************************/
    public static DCPProductRequestDeclaration.ProductArray processProduct(product2 prod,Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> priceMatrixMap,Map<String,UEStoreUSLPlan__mdt> planMdt){
        DCPProductRequestDeclaration.ProductArray prodDetail = new DCPProductRequestDeclaration.ProductArray();
        prodDetail = DCPPlanProductPricingSevice.productMap(prod,planMdt);
        List<Apttus_Config2__PriceMatrixEntry__c> priceMap = new List<Apttus_Config2__PriceMatrixEntry__c>(priceMatrixMap.get(prod.productCode));
        try{
        prodDetail.priceListItemId = priceMap[0].Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c;
        prodDetail.priceListId = priceMap[0].Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceListId__c;
        prodDetail.pricingDetails =  DCPNewSalesAddOnUtility.getPricingDetails(priceMap);//  {priceMap[0].Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.CurrencyIsoCode,priceMap[0].Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__Frequency__c};
        prodDetail.priceMatrix = DCPNewSalesAddOnUtility.getPriceMatrix(prod.Id,priceMap);
        }    
        catch(exception ex){
            DCPProductRequestDeclaration.ProductPlanResponse resp;
             resp = new DCPProductRequestDeclaration.ProductPlanResponse();
              resp.response = DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.successStatusOne,DCPNewSaleUtilityCls.detailsNotFound,DCPNewSaleUtilityCls.successStatus);
            
        }
    return prodDetail;
        
    }
    /********************************************************************************************************
*  @description  processplanMDT - This is the main method to handle the plan MDT
*  @return Map<String,UEStoreUSLPlan__mdt>  : this is a return statement and having processplanMDT
*  @param jurisdiction as state
*  @param segment - segment
*  @param inputRequestMap - map of string

*********************************************************************************************************/
    public static Map<String,UEStoreUSLPlan__mdt> processplanMDT(string jurisdiction,string segment,Map<String,String>inputRequestMap){
        Map<String,UEStoreUSLPlan__mdt> planMDT = new Map<String,UEStoreUSLPlan__mdt>();
        if(String.isNotBlank(jurisdiction)&&String.isNotBlank(segment)){
           planMdt = DCPPlanProductPricingSevice.getPlanId(inputRequestMap);
        }
  return planMDT;
    }


    /********************************************************************************************************
*  @description  getPriceMatrix - This is the main method to handle the price Matrix response 
*  @return list<DCPProductRequestHandler.PriceList>  : this is a return statement and having list of price Matrix
*  @param productId as product Id
*  @param priceMap - expected the pricing parameters 

*********************************************************************************************************/
    
    public static list<DCPNewSalesYoYUtil.PriceMatrix> getPriceMatrix(Id productId, List<Apttus_Config2__PriceMatrixEntry__c> priceMap){
        list<DCPNewSalesYoYUtil.PriceMatrix> priceMatrixEntryList = new list<DCPNewSalesYoYUtil.PriceMatrix>();
        Boolean isSuccess = false;
        system.debug(loggingLevel.INFO,'Success:'+isSuccess);
        if(!priceMap.isEmpty() && priceMap.size()>0){
            for(Apttus_Config2__PriceMatrixEntry__c entry:priceMap){
                DCPProductRequestHandler.preparePriceData(productId,entry,priceMatrixEntryList);
            }
        }
        return priceMatrixEntryList;
    }
    
}