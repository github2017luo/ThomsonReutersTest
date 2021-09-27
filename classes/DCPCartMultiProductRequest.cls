/* Class: DCPCartMultiProductRequest
* Purpose: As a business logic layer for cart manipulation API calls
* Created: 07/22/2021
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-07-22   Avudaiappan A     DCP-3149   Creating a business logic class for cart manipulation API
* =============================================================================
*/
/********************************************************************************************************
    *  @description  DCPCartMultiProductRequest - Perform the business logic for Cart Manipulation functionality
*********************************************************************************************************/
  
public with sharing class DCPCartMultiProductRequest {
	public static List<Apttus_Config2__LineItem__c> linestoUpdate;
/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  updateCart - This is the followup method to maniplate cart, here only we have maniplated the cart  
*  @return Boolean  : this is a return statement and having service is success or not 
*  @param cartItemDetails - expected the request parameters 
*********************************************************************************************************/

    public static boolean updateCart(DCP_CartPriceRequest.CartDetail cartItemDetails){
        boolean hasError = false;
		linestoUpdate = new List<Apttus_Config2__LineItem__c>();
        DCP_CartPriceRequest.LineItemClass lineCls = new DCP_CartPriceRequest.LineItemClass();
		DCPCartMultiProductRequestHelper.callLineItemQueue();
        if (!(cartItemDetails.productDetailList == null || cartItemDetails.productDetailList.isEmpty())) {
            for (DCP_CartPriceRequest.ProductDetail pd : cartItemDetails.productDetailList) {
                lineCls = DCPCartMultiProductRequest.doPickCart(cartItemDetails,pd);
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
    public static DCP_CartPriceRequest.LineItemClass doPickCart(DCP_CartPriceRequest.CartDetail cartItemDetails,DCP_CartPriceRequest.ProductDetail pd){
        DCP_CartPriceRequest.LineItemClass lineCls = new DCP_CartPriceRequest.LineItemClass();
        
        Map<String, Apttus_Config2__LineItem__c> alllineitems;
        Boolean hasError = false;
        if (String.isNotBlank(pd.productRequestType) && String.isNotBlank(pd.lineItemId) && (pd.productRequestType=='Update' || pd.productRequestType=='Remove' || pd.productRequestType=='Add')){ 
            String cartId = cartItemDetails.cartId;
            alllineitems = DCPCartMultiProductRequestHelper.getLineItems(cartId,pd);
              if(alllineitems!=null && alllineitems.size()>0){ 
                   	linestoUpdate.addAll(new List<Apttus_Config2__LineItem__c>(DCPCartMultiProductRequestHelper.doLineItemManipulation(pd,alllineitems,cartId)));
               }else{
                   hasError = true;
               }
                       
           } else{
                   hasError = true;
               }
               lineCls.linestoUpdate = linestoUpdate;
               lineCls.hasError = hasError;
               return lineCls;
    }

    

}