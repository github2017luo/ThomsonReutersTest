/* Class: DCP_CartPriceRequest
* Purpose: Cart Manipulation like Add, update, remove product from Cart, also it perform reprice over the cart
* Created: 19/05/2020
* Author: Kanishk
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-05-31   Kanishk       DCP-1671   Cart manipluation API Created
* 2021-06-15   Kanishk       DCP-2237   Fields of LineItemArray class added in request
* =============================================================================
*/

@RestResource(urlMapping='/newsale/DCPCartManipulationAPI/*')
/** 
 * @description : This is the class to create/update/remove/config products to Cart 
 */ 
global with sharing class DCP_CartPriceRequest{
 
 public static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
   

    /** 
    * @description : CartDetail class defined 
    */ 
    global class CartDetail {
       public string cartId;
       public string actionParams;
       public list<productDetail> productDetailList;
    }
    /** 
    * @description : ProductDetail class defined 
    */ 
    global class ProductDetail {
        public string productRequestType;
        public string lineItemId;
        global string priceListId;
        global string priceListItemId;
        global string lineNumber;
        global LineItemArray lineItemArray;
        public string productId;
        global string baseProduct;
        public string site;
        public string quantity;
        public string listPrice;
        public boolean hasAttribute;
        public list<attributeDetail> attributeDetailList;   
    }

     /**
     * @description : LineItemArray class defined 
     */ 
    global class LineItemArray{
        global string contractTerm;
        global string billingFrequency;
        global string adjustmentAmount;
        global string yoY1;  
        global string yoY2;
        global string segment;
    }
    /** 
    * @description : AttributeDetail class defined 
    */ 
    global class AttributeDetail {
        public string attributeName;
        public string attributeValue;
    }
    /** 
    * @description : CartResponse class defined 
    */ 
    global class CartResponse {
        public string statusCode;
        public string statusMsg;
        public string pricePending;
    }
    
/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @returns TRStoreResponse 
*  @description  processCart - This is the main method to start maniplate cart  
*  @return DCP_CartPriceRequest.cartResponse  : this is a return statement and having return result as failure or success  
*  @param cartItemDetails - expected the request parameters 
*********************************************************************************************************/
    @httppost
    global static DCP_CartPriceRequest.cartResponse processCart(DCP_CartPriceRequest.CartDetail cartItemDetails) {
        //system.debug('**TRStore** AddTocart Started:'+dt);
        RestRequest req = RestContext.request;
        RestResponse res =new RestResponse();
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;    
        DCP_CartPriceRequest.cartResponse cartResponse = new DCP_CartPriceRequest.cartResponse();
        
        Boolean hasError = false;
        string pricePending = 'false';
        
        try{
            if (cartItemDetails.cartId != null && cartItemDetails.actionParams == 'Cart') {
               hasError =  static_values__c.getValues('DCPCartRequestVersion').value__c =='v2'?DCPCartMultiProductRequest.updateCart(cartItemDetails):DCP_CartPriceRequest.updateCart(cartItemDetails);
              
            } else if (cartItemDetails.cartId != null && cartItemDetails.actionParams == 'Reprice') {
                   pricePending = doPriceCart(cartItemDetails);
            } else{
                hasError = true;
            }
            if(!hasError  &&  pricePending !='Reprice Exception'){
                cartResponse.statusMsg=TRStoreConstants.SUCCESS_STATUS;
                cartResponse.statusCode=TRStoreConstants.SUCCESS_CODE;
            }else{
                cartResponse.statusMsg=TRStoreConstants.FAILURESTATUS;
                cartResponse.statusCode=TRStoreConstants.ERROR_CODE;
            }
            cartResponse.pricePending = pricePending;
        }catch(exception e){
            //system.debug(LoggingLevel.INFO, 'Exception FetchDetails......'+e);
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Server Side Cart Sync Up Issue','reqMsg'=>'Exception Class Name: DCP_CartPriceRequest','module'=>'UEStore','recId'=>cartItemDetails.cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
        }
        //system.debug('**TRStore** AddTocart call Stopped:'+(system.now().getTime()-dt.getTime())+' ms');
        return cartResponse;
    }

/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  updateCart - This is the followup method to maniplate cart, here only we have maniplated the cart  
*  @return Boolean  : this is a return statement and having service is success or not 
*  @param cartItemDetails - expected the request parameters 
*********************************************************************************************************/

    private static boolean updateCart(DCP_CartPriceRequest.CartDetail cartItemDetails){
        boolean hasError = false;
        DCP_CartPriceRequest.LineItemClass lineCls = new DCP_CartPriceRequest.LineItemClass();
        if (!(cartItemDetails.productDetailList == null || cartItemDetails.productDetailList.isEmpty())) {
            for (DCP_CartPriceRequest.ProductDetail pd : cartItemDetails.productDetailList) {
                lineCls = DCP_CartPriceRequest.doPickCart(cartItemDetails,pd);
                }
         }
                
        if (!lineCls.linestoUpdate.isEmpty() ){
          Database.update(lineCls.linestoUpdate,true);
        }
        
        hasError = (lineCls.hasError);
        return hasError;
    }
   

    
/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  doPickCart - This is the a method to manipulation cart   
*  @return  DCP_CartPriceRequest.LineItemClass  : this is a return statement and having return service 
*  @param cartItemDetails - expected the cart lineitems 
*  @param pd - expected the cart lineitems 
*********************************************************************************************************/ 
    private static DCP_CartPriceRequest.LineItemClass doPickCart(DCP_CartPriceRequest.CartDetail cartItemDetails,DCP_CartPriceRequest.ProductDetail pd){
        DCP_CartPriceRequest.LineItemClass lineCls = new DCP_CartPriceRequest.LineItemClass();
        List<Apttus_Config2__LineItem__c> linestoUpdate = new List<Apttus_Config2__LineItem__c>();
        Boolean hasError = false;
        if (String.isNotBlank(pd.productRequestType) && String.isNotBlank(pd.lineItemId) && (pd.productRequestType=='Update' || pd.productRequestType=='Remove' || pd.productRequestType=='Add' || pd.productRequestType=='Undo' )) {
            Map<String, Apttus_Config2__LineItem__c> alllineitems = DCP_CartPriceRequestHelperOne.getLineItems(cartItemDetails.cartId,pd.lineItemId);
            String cartId = cartItemDetails.cartId;
               if (alllineitems != null && alllineitems.containsKey(pd.lineItemId)) {
                    linestoUpdate = DCP_CartPriceRequestHelperOne.doLineItemManipulation(pd,alllineitems,cartId);
               }else{
                   hasError = true;
               }
                       
           } else{
                   //hasError = addProducts(cartItemDetails);
                   hasError = true;
               }
               lineCls.linestoUpdate = linestoUpdate;
               lineCls.hasError = hasError;
               return lineCls;
    }

/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to manipulate cart and expected cartdetail 
*  @description  LineItemClass - This is the wrapper class which is having lineitems and has error boolean  
*********************************************************************************************************/
    public class LineItemClass{
        public List<Apttus_Config2__LineItem__c> linestoUpdate;
        public boolean hasError;
        /** 
        * @description : Constructor Defined
        */
        public lineItemClass(){
            linestoUpdate = new List<Apttus_Config2__LineItem__c>();
            hasError = false;
        }
    }


/************************************************************************************************************
   *  doPriceCart: Method to do reprice after removing all quantity
   * This method is to call reprice
   ************************************************************************************************************/
/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  doPriceCart - This is the a method to reprice cart 
*  @return string   : this is a return statement after maniplate line items 
*  @param cartItem - expected DCP_CartPriceRequest.cartDetail for reprice cart 
*********************************************************************************************************/ 
    
    private Static String doPriceCart(DCP_CartPriceRequest.cartDetail cartItem){
        List<Apttus_Config2__LineItem__c> linestoDel = new List<Apttus_Config2__LineItem__c>();
        String pricePending ='false';
        if(cartItem.cartId != null){
        Map<String, Apttus_Config2__LineItem__c> alllineitems = DCP_CartPriceRequestHelperOne.getLineItems(cartItem.cartId,null);
                    for(Apttus_Config2__LineItem__c li: alllineitems.values()){
                        if(li.mark_removed__c) {
                            linestoDel.add(li);
                        }
                    }
            if(linestoDel!=null && linestoDel.size()>0){
                Database.delete(linestoDel,true);
            }
            try{            
                pricePending = repriceCart(cartItem.cartId);
            }catch(Exception e){
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Reprice Issue','reqMsg'=>'Exception Class Name: DCP_CartPriceRequest','module'=>'UEStore','recId'=>cartItem.cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
                pricePending = 'Reprice Exception';
            }
        }
        return pricePending;
    }
    

/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  repriceCart - This is a main method to reprice cart 
*  @return string   : this is a return statement after maniplate line items 
*  @param cartId - expected cart id for reprice cart 
*********************************************************************************************************/   
  private static String repriceCart(String cartId) {

    String isPending;
    Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
    objUpdatePriceRequestDO.CartId = cartId;
    Apttus_CpqApi.CPQ.UpdatePriceResponseDO result;
    try {
      result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
      isPending = string.valueOf(result.IsPricePending);
    } catch (Exception e) {
        if(cartId!=null){
              Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Reprice Issue','reqMsg'=>'Exception Class Name: DCP_CartPriceRequest','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
              TRStore_ErrorHandler.logException(errorHandlerMap);
        }
        isPending = 'Reprice Exception';
    }
     
   return isPending;
  }
    
}