/* Class: TRStoreProductPricingService 
* Purpose: Rest API Service to bring the JSON formatted Pricing related Apttus objects for products
* Created: 12/13/2019
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2019-12-13   Avudaiappan A     DLT-18812   Creating Pricing Object JSON  
* 2020-01-02   Avudaiappan A     DLT-19171   Added Abbtributes and Options Group
* 2020-10-21   Avudaiappan A     DUE-5665    Refactoring for PMD & Bundle Child Changes
* =============================================================================
*/
@RestResource(urlMapping='/GetProductDetails')
/** 
* @description : Fetches product and pricing details
*/ 
global without sharing class TRStoreProductPricingService {
    public static string version = Static_Values__c.getValues('PDPCurrentVersion').Value__c;
    public static string currentVersion = 'v1';
    global static string language = 'EN';
    
    @HttpGet
    /** 
    * @description : get product data
    */
    global static void getServiceResponse() {
        try{
            RestRequest request = RestContext.request;
            RestContext.response.addHeader('Content-Type', 'application/json');
            string jsonData;
            Map<String,String> jsonMap = new Map<String,String>();
            Map<String,String> staticValues = TRStoreProductPricingService.staticValues(request);
            language = (request.params.containsKey('lang'))? request.params.get('lang') : 'EN';
            
            if((String.isNotBlank(staticValues.get('prodCode')) && (String.isNotBlank(staticValues.get('origin')))) && ((staticValues.get('origin')).equalsIgnoreCase('UE'))){
                jsonData = TRStoreProductPricingService.getProductRequest(request,staticValues.get('priceListName'),staticValues.get('prodCode'));
                    
                if(String.isBlank(jsonData)){
                    getProductDetails(request);
                }
            }else{
                jsonMap = TRStore_GetPricingDetails.fieldMissingResponse();
                jsonData = (!jsonMap.isEmpty())?JSON.serialize(jsonMap):null;
                if(TRStoreProductPricingService.currentVersion == TRStoreProductPricingService.version){
                    RestContext.response.responseBody = Blob.valueOf('[{"BundleType":"Parent","ProductCode":"'+staticValues.get('prodCode')+'","ProductInformation":{"status":'+jsonData+'}}]');
                }else{
                RestContext.response.responseBody = Blob.valueOf('[{"status":'+jsonData+'}]');
            }
        }
            
        } catch(Exception ex){
            system.debug(loggingLevel.INFO,'Exception:'+ex);
        }
    }
  
    private static map<String,string> staticValues(RestRequest request){
        Map<String,String> reqValues = new Map<String,String>();
        reqValues.put('origin',request.Params.get('origin') <> null ? request.Params.get('origin') : null);
        reqValues.put('prodCode',request.Params.get('prodCode') <> null ?request.Params.get('prodCode'):null);
        string country = request.params.get('country');
        reqValues.put('priceListName',(string.isnotBlank(country) && country.equalsIgnoreCase('CA'))?Static_Values__c.getValues('TRStorePricelistCA').Value__c:Static_Values__c.getValues('PriceListName').Value__c);
        return reqValues;
    }
    
    /** 
    * @description : Fetch product request
    * @param request : request
    * @param priceListName : Price list name
    * @param prodCode : Product Code 
    * @return : Product request
    */ 
    public static string getProductRequest(RestRequest request, String priceListName, String prodCode){
        LIST<Product_Detail__c> productDetailJsons = new LIST<Product_Detail__c>();
        String jsonData;
                Map<String,String> childProductMap = new Map<String,String>();
                childProductMap = TRStoreProductPricingService.getChildFormats(prodCode);
                childProductMap.put('parent',prodCode);
                List<String> productCodesList = childProductMap.Values();
            String validSellableStatus = Static_Values__c.getValues('TransactSellableFlag').Value__c;
            List<String> sellableValuesList=validSellableStatus.split(',');
            if(Schema.sObjectType.Product_Detail__c.isAccessible()) {
                productDetailJsons = [Select Id, Product_Code__c, Price_List__c, Product__c, Product_Details__c, lastModifiedDate, 
                                        Product_Details_French__c FROM Product_Detail__c 
                                        WHERE 
                                        Price_List__r.Name =: priceListName 
                                        AND Product_Code__c IN: productCodesList 
                                        AND Product__r.CPD_Sellable_Description__c in :sellableValuesList];
            }
            Integer noOfHrs = (Static_Values__c.getAll().containsKey('TrstorePDPJsonSchedulehrs'))?Integer.valueOf(Static_Values__c.getAll().get('TrstorePDPJsonSchedulehrs').value__c):6; 
        if(!productDetailJsons.isempty()){
            try{
                if(productDetailJsons[0].lastModifiedDate >= system.now().addHours(noOfHrs*(-1))){
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        jsonData = TRStoreProductPricingService.processData(childProductMap.get('parent'),productDetailJsons,TRStoreProductPricingService.currentVersion);
                        RestContext.response.responseBody = Blob.valueOf(jsonData);
               }else{
                   // Record details has greater than specifies time so getting from latest json. 
                   getProductDetails(request);
               } 
            }catch(exception e){
                 
                getProductDetails(request);
                
            }
        }
        return jsonData;
    }

    /** 
    * @description : Process product data
    * @param prodCode : product code
    * @param productDetailJsons : Product JSON
    * @param cVersion : Class version
    * @return : Product data
    */ 
    public static string processData(String prodCode,LIST<Product_Detail__c> productDetailJsons, String cVersion){
        String jsonData;
        if(productDetailJsons!=null && (String.isNotBlank(TRStoreProductPricingService.version) && cVersion == TRStoreProductPricingService.version)){
            for(Product_Detail__c productDet:productDetailJsons){
                
              string recjson = processLanguageData(productDet); 

                if(productDet.product_code__c==prodCode){
                    jsonData =(String.isNotBlank(jsonData))?jsonData+',{"BundleType":"Parent","ProductCode":"'+productDet.product_code__c+'","ProductInformation":'+ recjson +'}':'[{"BundleType":"Parent","ProductCode":"'+productDet.product_code__c+'","ProductInformation":'+ recjson +'}';
                }else{
                    jsonData =(String.isNotBlank(jsonData))?jsonData+',{"BundleType":"Child","ProductCode":"'+productDet.product_code__c+'","ProductInformation":'+ recjson +'}':'[{"BundleType":"Child","ProductCode":"'+productDet.product_code__c+'","ProductInformation":'+ recjson +'}';
                }
            }
            
        } else{
            Product_Detail__c productDet = productDetailJsons[0];
            jsonData = processLanguageData(productDet); 
        }
        String resData = TRStoreProductPricingService.getFinalResponse(jsonData, TRStoreProductPricingService.currentVersion);
        return resData;
    }
    
    private static string processLanguageData(Product_Detail__c productDet){
        return ((language != 'EN' && productDet.Product_Details_French__c != null) ? productDet.Product_Details_French__c :  productDet.Product_Details__c);
    }
    
    /** 
    * @description : get product JSON
    * @param jsonData : product JSON
    * @param cVersion : class version
    * @return : product JSON string
    */
    public static string getFinalResponse(String jsonData,String cVersion){
         String resData = (String.isNotBlank(jsonData) && cVersion == TRStoreProductPricingService.version)?jsonData+']':jsonData;
        return resData;
    }

    /** 
    * @description : get product details
    * @param request : service request
    */
    global static void getProductDetails(RestRequest request){        
        try{            
            //RestRequest req = RestContext.request;
            string country = request.params.get('country');
            string prodCode = request.Params.get('prodCode');
            string priceListName = (string.isnotBlank(country) && country.equalsIgnoreCase('CA'))?Static_Values__c.getValues('TRStorePricelistCA').Value__c:Static_Values__c.getValues('PriceListName').Value__c;
            TRStoreProductPricingService.callProductService(priceListName, prodCode,TRStoreProductPricingService.currentVersion);
        }catch(Exception ex){
            system.debug(loggingLevel.INFO,'Exception:'+ex);
        }
    }
    
    /** 
    * @description : call to product service
    * @param priceListName : Price List Name
    * @param prodCode : Product Code
    * @param cVersion : Class Version
    */
    public static void callProductService(String priceListName,String prodCode, String cVersion){
        String pricelistId;
            if(Schema.sObjectType.Apttus_Config2__PriceList__c.isAccessible()){
                List<Apttus_Config2__PriceList__c> priceList = [Select Id from Apttus_Config2__PriceList__c where name = :priceListName];    
                pricelistId = priceList.isEmpty() ? '' : priceList[0].Id;
            } 
            TRStore_GetPricingDetails.ProductDetails details = new TRStore_GetPricingDetails.ProductDetails();
            String jsonData = (cVersion== TRStoreProductPricingService.version)?'[{"BundleType":"Parent","ProductCode":"'+prodCode+'","ProductInformation":'+details.getProductDetails(prodCode,pricelistId)+'}':details.getProductDetails(prodCode,pricelistId);
            system.debug(loggingLevel.INFO,'@@JSON String:1st...........'+jsonData); 
            
            Map<String,String> childProductMap = TRStoreProductPricingService.getChildFormats(prodCode);
            if(!childProductMap.isEmpty() && cVersion == TRStoreProductPricingService.version){
                for(String productCode:childProductMap.Values()){
                    jsonData = jsonData+',{"BundleType":"Child","ProductCode":"'+productCode+'","ProductInformation":'+details.getProductDetails(productCode,pricelistId)+'}';
                }   
            }
            String responseData = TRStoreProductPricingService.getFinalResponse(jsonData, TRStoreProductPricingService.currentVersion);
          system.debug(loggingLevel.INFO,'@@JSON String:...........'+jsonData); 
            RestContext.response.addHeader('Content-Type', 'application/json');
            try{ 
                RestContext.response.responseBody = Blob.valueOf(responseData);
            }catch(Exception e){
                system.debug(loggingLevel.INFO,'Exception:'+e);
            }
    }
    
    /** 
    * @description : get child formats
    * @param prodCode : product code
    * @return : child format map
    */
    public static map<string,string> getChildFormats(String prodCode){
        Map<String,String> childProductMap = new Map<String,String>();
        String query = 'SELECT Apttus_Config2__Value__c, Apttus_Config2__FeatureId__r.Name,Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name from Apttus_Config2__ProductFeatureValue__c WHERE (Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name = \'Formats\' and Apttus_Config2__ProductId__r.productcode = :prodCode)';
        for(Apttus_Config2__ProductFeatureValue__c pfv: Database.query(query)){
            childProductMap.put(pfv.Apttus_Config2__FeatureId__r.Name,pfv.Apttus_Config2__Value__c);
        }
        return childProductMap;
    }
}