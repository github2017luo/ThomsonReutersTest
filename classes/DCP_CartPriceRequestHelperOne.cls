/** 
 * @description : This is the class to create/update/remove/config products to Cart 
 */ 
public with sharing class DCP_CartPriceRequestHelperOne{
    
    private static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
 
/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  doLineItemManipulation  - This is the a method to check type of request and process based on type 
*  @return List<Apttus_Config2__LineItem__c>  : this is a return statement after maniplate line items 
*  @param pd - expected product details 
*  @param alllineitems - map method for string and line items 
*  @param cartId - Cart id to maniplate the details 
*********************************************************************************************************/ 
    public Static List<Apttus_Config2__LineItem__c> doLineItemManipulation(DCP_CartPriceRequest.ProductDetail pd,Map<String, Apttus_Config2__LineItem__c> alllineitems, String cartId){
        Apttus_Config2__LineItem__c lineItem = alllineitems.get(pd.lineItemId);
        List<Apttus_Config2__LineItem__c> linestoUpdate = new List<Apttus_Config2__LineItem__c>();
        if (String.isNotBlank(pd.quantity) && pd.productrequestType == 'Add') 
        {
            linestoUpdate = DCP_CartPriceRequestHelperOne.doUpdateCart(lineItem,pd,cartId);
        }else if(pd.productrequestType == 'Remove'){
            lineItem.Mark_Removed__c = true;
            linestoUpdate.add(lineItem);
        }else if(String.isNotBlank(pd.quantity) && pd.productrequestType == 'Update') 
        {
            lineItem.Apttus_Config2__Quantity__c = Double.valueOf(pd.quantity);
            lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
            DCP_CartPriceRequest.LineItemArray lineDetails = pd.lineItemArray;
            lineItemContractDetails(lineItem, lineDetails);
            linestoUpdate.add(lineItem);
        }else if(pd.productrequestType == 'Undo'){
            lineItem.Mark_Removed__c = false;
            linestoUpdate.add(lineItem);
        }
        return linestoUpdate;
    }

    /********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  doUpdateCart - This is the a method to process single cart line item 
*  @return List<Apttus_Config2__LineItem__c>  : this is a return statement after maniplate line items 
*  @param lineItem - expected the line item 
*  @param pd - product details 
*  @param cartId - Cart id to maniplate the details 
*********************************************************************************************************/
    private Static List<Apttus_Config2__LineItem__c> doUpdateCart(Apttus_Config2__LineItem__c lineItem,DCP_CartPriceRequest.ProductDetail pd,String cartId){
        List<Apttus_Config2__LineItem__c> linestoUpdate = new List<Apttus_Config2__LineItem__c>();
            lineItem.Apttus_Config2__Quantity__c = Double.valueOf(pd.quantity);
            lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
            lineItem.Mark_Removed__c = false;
            lineItem.TRStore_Site__c = String.isNotBlank(pd.site)?pd.site:'';
            lineItem.Apttus_Config2__ListPrice__c = Double.valueOf(pd.listPrice);
            lineItem.Apttus_Config2__ProductId__c =  pd.productId;
            lineItem.Apttus_Config2__PriceListId__c = getCartInfo(cartId);
            DCP_CartPriceRequest.LineItemArray lineDetails = pd.lineItemArray;
            
            lineItemContractDetails(lineItem, lineDetails);
            if(pd.attributeDetailList!=null && pd.attributeDetailList.size()>0 && pd.hasAttribute){
                lineItem.Apttus_Config2__HasAttributes__c = true;
                Apttus_Config2__ProductAttributeValue__c prodAtr = new Apttus_Config2__ProductAttributeValue__c();  
                    for(DCP_CartPriceRequest.AttributeDetail att: pd.attributeDetailList){
                        if(att.attributeName != null && att.attributeValue != null){
                            prodAtr.put(att.attributeName,att.attributeValue);
                        }
                        prodAtr.Apttus_Config2__IsTransient__c = true;
                        prodAtr.Apttus_Config2__LineItemId__c  = lineItem.Id;
                    }
                if(prodAtr.Apttus_Config2__LineItemId__c !=null) {
                    Database.insert (prodAtr,true);
                }
            }
            
            linestoUpdate.add(lineItem);
            return linestoUpdate;
    }

    /******************************************************************************************************** 
    *  @description  lineItemContractDetails : method to map contract term and adjustment details on line items
    *  @param lineItem : Line item object
    *  @param lineDetails : holds contract term and adjustment details 
    *********************************************************************************************************/ 
    private static void lineItemContractDetails(Apttus_Config2__LineItem__c lineItem, DCP_CartPriceRequest.LineItemArray lineDetails){
        if(lineDetails!=null){
           lineItem.APTS_Contract_Term__c = lineDetails.contractTerm;
           lineItem.Apttus_Config2__BillingFrequency__c = String.isNotBlank(lineDetails.billingFrequency)?lineDetails.billingFrequency:'Monthly';
           lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
           lineItem.Apttus_Config2__AdjustmentAmount__c = (lineDetails.adjustmentAmount!=null && String.isNotBlank(lineDetails.adjustmentAmount))?Double.valueOf(lineDetails.adjustmentAmount):Double.valueOf('0.0');
           lineItem.APTS_Yr_1_Renewal_Adjustment__c = lineDetails.yoY1;
           lineItem.APTS_Years_2_Plus_Adjustment__c = lineDetails.yoY2;  
        }
    }
 
/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  getCartInfo - This is a method to get price list id
*  @return string   : this is a return statement for pricelist id 
*  @param cartId - cart id 
*********************************************************************************************************/   
  private static string getCartInfo(String cartId) {
    String priceListId;
    try {
           for(Apttus_Config2__ProductConfiguration__c pc : [select id,Apttus_Config2__PriceListId__c from Apttus_Config2__ProductConfiguration__c where Id = :cartId]){
                priceListId = pc.Apttus_Config2__PriceListId__c;
           }
        } 
      catch (Exception e) {
          if(cartId!=null){
              Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Server Side Cart Sync Up Issue','reqMsg'=>'Exception Class Name: DCP_CartPriceRequest','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
              TRStore_ErrorHandler.logException(errorHandlerMap);
          }
      }
      
     return priceListId; 
  }
   
   
/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  getLineItems - This is a method to query cart line items 
*  @return Map<String, Apttus_Config2__LineItem__c> : return map of line items records 
*  @param cartId - cart id 
*  @param lineId - line item id 
*********************************************************************************************************/  
   public static Map<String, Apttus_Config2__LineItem__c> getLineItems(string cartId, string lineId) {
        Map<String,Apttus_Config2__LineItem__c> lineItems = new Map<String,Apttus_Config2__LineItem__c>();
        try {
             String query = 'select id, Name, Apttus_Config2__Quantity__c,Mark_Removed__c, Apttus_Config2__ListPrice__c, Apttus_Config2__NetPrice__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__BasePrice__c, Apttus_Config2__NetUnitPrice__c, Apttus_Config2__ChargeType__c, Apttus_Config2__ConfigurationId__r.Apttus_config2__Status__c, Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =\''+String.escapeSingleQuotes(cartId)+'\'';
            if(String.isNotBlank(lineId)){
                //Double numb = Double.valueOf(lineNumber);
                query = query + ' and Id =\''+String.escapeSingleQuotes(lineId)+'\'';
            }
            for(Apttus_Config2__LineItem__c li : Database.query(query)){
                //lineItems.put(li.Apttus_Config2__ProductId__r.ProductCode,li);
                lineItems.put(li.id,li);
               }
        } catch (Exception e) {
            if(cartId!=null){
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Server Side Cart Sync Up Issue','reqMsg'=>'Exception Class Name: DCP_CartPriceRequest','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);
            }
        }
    return lineItems;
  }
    

}