/* Class: DCPNewSalesAddOnRequestHandler
* Purpose: A handler class to handle the request between request class and the business logic class
* Created: 9/3/2021
**/
/**
* @description A handler class to handle the addonrequest
*/
public with sharing class DCPNewSalesAddOnRequestHandler {

    public static Map<String,String> reqParamsMap;
    public Static DCPNewSalesAddOnRequest.ProductAddOnResponse resp;
    /********************************************************************************************************
    *  @description  handleRequest - This is the main method to handle the request  
    *  @return DCPNewSalesAddOnRequest.ProductPlanResponse  : this is a return statement and having return result as failure or success  
    *  @param requestBody - expected the request parameters 
    *********************************************************************************************************/
        
        public static DCPNewSalesAddOnRequest.ProductAddOnResponse handleRequest (Map<String,String> requestBody){
            resp = new DCPNewSalesAddOnRequest.ProductAddOnResponse();
            Map<String,product2> productMap = new Map<String,product2>();
            Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> priceMatrixMap = new Map<String,List<Apttus_Config2__PriceMatrixEntry__c>>();
            if((requestBody.containskey('segment') && !String.isBlank(requestBody.get('segment'))) && (requestBody.containskey('productCode') && !String.isBlank(requestBody.get('productCode')))){ 
                productMap = DCPNewSalesAddOnRequestHelper.getAddonProducts(requestBody);
            }else{
                resp.response =  DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.errorCode,DCPNewSaleUtilityCls.requiredFieldMissing,DCPNewSaleUtilityCls.failureStatus);
            }
    
            if(!productMap.isEmpty()){
                priceMatrixMap = DCPNewSalesAddOnRequestHelper.getPrice(productMap,requestBody.get('segment'));
                resp.response = DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.successCode,DCPNewSaleUtilityCls.detailsFound,DCPNewSaleUtilityCls.successStatus);
                resp = DCPNewSalesAddOnRequestHandler.getProductResponse(productMap,priceMatrixMap);
            }else{
                resp.response = DCPNewSaleUtilityCls.responseMethod(DCPNewSaleUtilityCls.successStatusOne,DCPNewSaleUtilityCls.detailsNotFound,DCPNewSaleUtilityCls.successStatus);
            }
            
            return resp;
        }
        
    /********************************************************************************************************
    *  @description  getProductResponse - This is the main method to handle the final response  
    *  @return DCPProductRequestDeclaration.ProductPlanResponse  : this is a return statement and having return result as failure or success  
    *  @param productMap - expected the product parameters 
    *  @param priceMatrixMap - expected the pricing parameters 
    *********************************************************************************************************/
        
        public static DCPNewSalesAddOnRequest.ProductAddOnResponse getProductResponse(Map<String,product2> productMap,Map<String,List<Apttus_Config2__PriceMatrixEntry__c>> priceMatrixMap){
            //DCPNewSalesAddOnRequest.ProductPlanResponse res = new DCPNewSalesAddOnRequest.ProductPlanResponse();
            DCPNewSalesAddOnRequest.ProductArray prodAddON;
            //DCPNewSalesAddOnRequest.ProductAddOn finalPlan = new DCPNewSalesAddOnRequest.ProductAddOn();
            List<DCPNewSalesAddOnRequest.ProductArray> prodAddONList = new List<DCPNewSalesAddOnRequest.ProductArray>(); 
            List<DCPNewSalesAddOnRequest.PriceList> priceList;
            DCPNewSalesAddOnRequest.PricingDetail otherDetails;
            Map<String,Apttus_Config2__PriceListItem__c> pliMap = new Map<String,Apttus_Config2__PriceListItem__c>();
            pliMap = DCPNewSalesAddOnRequestHelper.getPLIInfo(productMap);
            for(Product2 prod:productMap.values()){
                prodAddON = new DCPNewSalesAddOnRequest.ProductArray();
                otherDetails = new DCPNewSalesAddOnRequest.PricingDetail();
                
                
                priceList = new List<DCPNewSalesAddOnRequest.PriceList>();
                prodAddON = DCPNewSalesAddOnRequestHelper.getProducts(prod);
                priceList = DCPNewSalesAddOnRequestHelper.getPricing(prod,priceMatrixMap);
                if(pliMap!=null && pliMap.get(prod.productCode)!=null){
                    prodAddON.priceListId = pliMap.get(prod.productCode).Apttus_Config2__PriceListId__c;
                    prodAddON.priceListItemId = pliMap.get(prod.productCode).Id;
                    otherDetails.currencyCode = pliMap.get(prod.productCode).CurrencyIsoCode;
                    otherDetails.billingFrequency = pliMap.get(prod.productCode).Apttus_Config2__BillingFrequency__c;
                    prodAddON.pricingDetails = otherDetails;
                }
                prodAddON.priceListItems = (!priceList.isEmpty())?priceList:null;
                prodAddONList.add(prodAddON);           
            }
            resp.productAddOnList = prodAddONList;
            //resp.productDetails = finalPlan;
            return resp;
        }
    }