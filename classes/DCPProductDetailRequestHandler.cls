/* Class: DCPProductDetailRequestHandler
* Purpose: This class is for holding the business logic for product details service - DCPProductRequestHandler
* Created: 5/19/2021
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 05/19/2021    Avudaiappan A    DCP-1821     Created 
* =============================================================================
*/

/** 
 * @description : This is the class to handle the product detail request
 */ 
public class DCPProductDetailRequestHandler {
    //Add-on change
    public static string segment;
    public static string brand;
    
    /********************************************************************************************************
*  @description  handleRequest - This is the main method to handle the product detail request  
*  @return DCPProductRequestDeclaration.ProductPlanResponse  : this is a return statement and having return result as failure or success  
*  @param requestBody - expected the request parameters 
*********************************************************************************************************/
 
   public static DCPProductRequestDeclaration.ProductPlanResponse handleRequest (Map<String,String> requestBody){
        DCPProductRequestHandler.context = 'ProductDetail';
        Map<String,String> mapInputRequestPDP = new Map<String,String>();
        DCPProductRequestDeclaration.ProductPlanResponse resp = new DCPProductRequestDeclaration.ProductPlanResponse();
        Map<String,product2> productMap = new Map<String,product2>();
        if((requestBody.containskey('segment') && !String.isBlank(requestBody.get('segment')))){
           brand = requestBody.get('brand');
           segment = requestBody.get('segment');
           mapInputRequestPDP.put('brand',requestBody.get('brand'));
           mapInputRequestPDP.put('segment',requestBody.get('segment'));
           Map<String,UEStoreUSLPlan__mdt> planMDT = new Map<String,UEStoreUSLPlan__mdt>{String.ValueOf(requestBody.get('productCode'))=>null};
           String productCode;
           productCode = String.ValueOf(requestBody.get('productCode'));
           productMap =DCPProductDetailRequestHandler.checkProductVersion(productMap,String.ValueOf(requestBody.get('productCode')),String.ValueOf(requestBody.get('brand')));
                    planMDT.putAll(DCPNewSalesAddOnUtility.mapCustomMetadata(productMap,planMDT));
                    
                    productMap.putAll(DCPPlanProductPricingSevice.getPlanDetails(planMDT,mapInputRequestPDP));
            
                if(productMap.isEmpty()||productMap.get(String.ValueOf(requestBody.get('productCode')))==null){
                        resp.response = DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.successStatusOne,DCPNewSaleUtilityCls.detailsNotFound,DCPNewSaleUtilityCls.successStatus);
                } else{ 
                    
                    DCPProductRequestHandler.segment = segment;
                    DCPProductRequestHandler.brand = brand;
                    Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> priceMatrixMap = DCPPlanProductPricingSevice.getprice(planMDT,requestBody.get('segment'));
                    Map<String,list<Product_Platform_Value__c>> productFeaturesMap = DCPPlanProductPricingSevice.getProductFeature(planMDT);
                    resp = DCPProductRequestHandler.getResponse(productMap,priceMatrixMap,productFeaturesMap);
                    resp.planDetails.segment = segment;
                    resp.response = DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.successCode,DCPNewSaleUtilityCls.detailsFound,DCPNewSaleUtilityCls.successStatus);
                            
                }  
            
        }else{
            resp.response =  DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.errorCode,DCPNewSaleUtilityCls.requiredFieldMissing,DCPNewSaleUtilityCls.failureStatus);

        }
        return resp;
    }

    private static map<string,product2> checkProductVersion(map<string,product2> productMap, String prodCode,String brand){
        //Add-on change
        DCPNewSalesAddOnUtility.brand = brand;
        DCPNewSalesAddOnUtility.segment = segment;
        productMap = (Static_Values__c.getValues('DCPAddOnVersioningForPDP').Value__c=='v2')?DCPNewSalesAddOnUtility.getAddOnDetails(prodCode,brand):productMap;
        return productMap;
    }
    
}