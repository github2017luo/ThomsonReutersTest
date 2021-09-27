/* Class: TRStore_CartPriceRequest
* Purpose: Cart Manipulation like Add, update, remove product from Cart, also it perform reprice over the cart
* Created: 19/05/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-05-19   Avudaiappan A     DUE-2299   Cart manipluation API Created
* 2020-06-22   Avudaiappan A     DUE-3631   Added lineItemNumber as an additional param
* 2020-07-10   Avudaiappan A     DUE-3883   Added TRStore Site/ site as a param
* 2020-07-24   Avudaiappan A     DUE-4074   Performance Improvement  & Delete part fix
* 2020-08-07   Avudaiappan A     DUE-4362   Removed Add call & In update call to update lineitem with product & create ProdAttr
* 2020-11-03   Avudaiappan A     DUE-6164   Code Refactor for PMD
* 2020-12-28   Avudaiappan A     DUE-7653   Added the changes for UNDO CART
* =============================================================================
*/

@RestResource(urlMapping='/TRStoreCartManipulationAPI/*')
/** 
 * @description : This is the class to create/update/remove/config products to Cart 
 */ 
global with sharing class TRStore_CartPriceRequest{
 
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
        public string productId;
        public string site;
        public string quantity;
        public string listPrice;
        public boolean hasAttribute;
        public list<attributeDetail> attributeDetailList;
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
*  TRStore_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @returns TRStoreResponse 
*  @description  processCart - This is the main method to start maniplate cart  
*  @return TRStore_CartPriceRequest.cartResponse  : this is a return statement and having return result as failure or success  
*  @param cartItemDetails - expected the request parameters 
*********************************************************************************************************/
    @httppost
    global static TRStore_CartPriceRequest.cartResponse processCart(TRStore_CartPriceRequest.CartDetail cartItemDetails) {
        //system.debug('**TRStore** AddTocart Started:'+dt);
        RestRequest req = RestContext.request;
        RestResponse res =new RestResponse();
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;    
        TRStore_CartPriceRequest.cartResponse cartResponse = new TRStore_CartPriceRequest.cartResponse();
        
        Boolean hasError = false;
        string pricePending = 'false';
        
        try{
            if(cartItemDetails.cartId != null && cartItemDetails.actionParams == 'Cart') {
               hasError = TRStore_CartPriceRequest.updateCart(cartItemDetails);
              
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
            if(cartItemDetails.cartId!=null){
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Server Side Cart Sync Up Issue','reqMsg'=>'Exception Class Name: TRStore_CartPriceRequest','module'=>'UEStore','recId'=>cartItemDetails.cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
            }
        }
        //system.debug('**TRStore** AddTocart call Stopped:'+(system.now().getTime()-dt.getTime())+' ms');
        return cartResponse;
    }

/********************************************************************************************************
*  TRStore_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  updateCart - This is the followup method to maniplate cart, here only we have maniplated the cart  
*  @return Boolean  : this is a return statement and having service is success or not 
*  @param cartItemDetails - expected the request parameters 
*********************************************************************************************************/

    private static boolean updateCart(TRStore_CartPriceRequest.CartDetail cartItemDetails){
        boolean hasError = false;
        TRStore_CartPriceRequest.LineItemClass lineCls = new TRStore_CartPriceRequest.LineItemClass();
        if (!(cartItemDetails.productDetailList == null || cartItemDetails.productDetailList.isEmpty())) {
            for (TRStore_CartPriceRequest.ProductDetail pd : cartItemDetails.productDetailList) {
                lineCls = TRStore_CartPriceRequest.doPickCart(cartItemDetails,pd);
                }
         }
         
        boolean has99ErrorBool = false; 
        if (!lineCls.linestoUpdate.isEmpty()){
         has99ErrorBool = TRStore_CartPriceRequestHelperOne.check99Qty(lineCls.linestoUpdate);
        }
        
        if (!lineCls.linestoUpdate.isEmpty() && !has99ErrorBool ){
          Database.update(lineCls.linestoUpdate,true);
        }
        
        hasError = (lineCls.hasError || has99ErrorBool);
        return hasError;
    }
   

    
/********************************************************************************************************
*  TRStore_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  doPickCart - This is the a method to manipulation cart   
*  @return  TRStore_CartPriceRequest.LineItemClass  : this is a return statement and having return service 
*  @param cartItemDetails - expected the cart lineitems 
*  @param pd - expected the cart lineitems 
*********************************************************************************************************/ 
    private static TRStore_CartPriceRequest.LineItemClass doPickCart(TRStore_CartPriceRequest.CartDetail cartItemDetails,TRStore_CartPriceRequest.ProductDetail pd){
        TRStore_CartPriceRequest.LineItemClass lineCls = new TRStore_CartPriceRequest.LineItemClass();
        List<Apttus_Config2__LineItem__c> linestoUpdate = new List<Apttus_Config2__LineItem__c>();
        Boolean hasError = false;
        if (String.isNotBlank(pd.productRequestType) && String.isNotBlank(pd.lineItemId) && (pd.productRequestType=='Update' || pd.productRequestType=='Remove' || pd.productRequestType=='Add' || pd.productRequestType=='Undo' )) {
            Map<String, Apttus_Config2__LineItem__c> alllineitems = TRStore_CartPriceRequestHelperOne.getLineItems(cartItemDetails.cartId,pd.lineItemId);
            String cartId = cartItemDetails.cartId;
               if (alllineitems != null && alllineitems.containsKey(pd.lineItemId)) {
                    linestoUpdate = TRStore_CartPriceRequestHelperOne.doLineItemManipulation(pd,alllineitems,cartId);
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
*  TRStore_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
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
*  TRStore_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  doPriceCart - This is the a method to reprice cart 
*  @return string   : this is a return statement after maniplate line items 
*  @param cartItem - expected TRStore_CartPriceRequest.cartDetail for reprice cart 
*********************************************************************************************************/ 
    
    private Static String doPriceCart(TRStore_CartPriceRequest.cartDetail cartItem){
        List<Apttus_Config2__LineItem__c> linestoDel = new List<Apttus_Config2__LineItem__c>();
        String pricePending ='false';
        if(cartItem.cartId != null){
        Map<String, Apttus_Config2__LineItem__c> alllineitems = TRStore_CartPriceRequestHelperOne.getLineItems(cartItem.cartId,null);
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
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Reprice Issue','reqMsg'=>'Exception Class Name: TRStore_CartPriceRequest','module'=>'UEStore','recId'=>cartItem.cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
                pricePending = 'Reprice Exception';
            }
        }
        return pricePending;
    }
    

/********************************************************************************************************
*  TRStore_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
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
              Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Reprice Issue','reqMsg'=>'Exception Class Name: TRStore_CartPriceRequest','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
              TRStore_ErrorHandler.logException(errorHandlerMap);
        }
        isPending = 'Reprice Exception';
    }
     
   return isPending;
  }
    
 
  


}