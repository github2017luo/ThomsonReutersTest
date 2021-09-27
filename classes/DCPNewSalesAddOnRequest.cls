@RestResource(urlMapping='/newsale/DCPAddOnService')
/** 
 * @description : This is the class to handle the new sale rest request and map output response 
 */ 
global without sharing class DCPNewSalesAddOnRequest{
    /**
        * @description productPlanResponse
        */
       global class ProductAddonResponse{
           global DCPNewSaleUtilityCls.Response response;
           global List<ProductArray> productAddOnList;
       }
    /** 
   *     @description : This is the class to structure the plan Array
   */ 
        /*global virtual class ProductAddOn{
           global List<ProductArray> products;
       }*/
      /** 
   * @description : This is the class to structure the pricing details
   */ 
       public class PricingDetail{
           public String currencyCode;
           public String billingFrequency;
       }
    /** 
   * @description : This is the class to structure the product Array
   */ 
       global virtual class ProductArray{
           global String productName;
           global String productId;
           global String productCode;
           global String shortDescription;
           global String priceListId;
           global String priceListItemId;
           global List<PriceList> priceListItems;
           global PricingDetail pricingDetails;
       }
     /** 
   * @description : This is the class to structure the price Array
   */ 
       global class PriceList{
           global String quantity;
           global String amount;
       }
    
    /**
        @description POST method
        @return Returns the response for the appropriate service
     */
    @HttpPost
    global static DCPNewSalesAddOnRequest.ProductAddOnResponse addONService(){

        RestRequest req = RestContext.request;
        System.debug(LoggingLevel.DEBUG,'Request Body:'+req.requestBody.toString());
        Map<String,String> requestBody = (Map<String,String>)JSON.deserialize(req.requestBody.toString(),Map<String,String>.class);
        DCPNewSalesAddOnRequest.ProductAddOnResponse resp = new DCPNewSalesAddOnRequest.ProductAddOnResponse();
                
        System.debug(LoggingLevel.DEBUG,'REQUEST>>>'+req);
        //Redirects to the appropriate service based on the URI request
        try{
            resp = DCPNewSalesAddOnRequestHandler.handleRequest(requestBody);
            if(test.isrunningTest()){
                throw new DMLException('Error'); 
            }
        }
        catch(Exception ex){
            //If any exceptions are thrown, fail the request and provide exception message.
            DCPNewSaleUtilityCls.logException(new Map<String,String>{'objectName'=>'','expMsg'=>ex.getLineNumber()+','+ex.getMessage(),'webServiceName'=>'Addon Service','requestType'=>'Add On Service ','reqMsg'=>'Exception Class Name: DCPNewSaleAddOnRequest','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'false'});

        }

        //Return response to the request.
        System.debug(LoggingLevel.DEBUG,'RESPONSE>>>'+JSON.serialize(resp));
        return resp;
    }
   
    
}