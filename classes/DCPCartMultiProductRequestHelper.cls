/********************************************************************************************************
*  @description  DCPCartMultiProductRequestHelper - This helper class perform additional business logic for cart Manipulaiton API 
***************************************************************************************/
public with sharing class DCPCartMultiProductRequestHelper {
    
    private static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member



/********************************************************************************************************
*  @description  getLineItems - This is a method to query cart line items 
*  @return Map<String, Apttus_Config2__LineItem__c> : return map of line items records 
*  @param cartId - cart id 
*  @param pd - product Array
*********************************************************************************************************/  
public static Map<String, Apttus_Config2__LineItem__c> getLineItems(string cartId,DCP_CartPriceRequest.ProductDetail pd) {
    Map<String,Apttus_Config2__LineItem__c> lineItems = new Map<String,Apttus_Config2__LineItem__c>();
    List<Apttus_Config2__LineItem__c> lineItemlst = new List<Apttus_Config2__LineItem__c>();
    try {
        String query;
        List<UE_Proposal__c> oQList;
          if(pd.productRequestType == 'Add'){
           oQList  = new List<UE_Proposal__c>([Select lineitemId__c from UE_Proposal__c where type_of_line__c ='US Legal' and isLineActive__c=true limit 1]);
           query = DCPCartMultiProductRequestUtility.getLIfromUE(oQList,cartId,pd);     
        }else if(pd.productRequestType == 'Update' || pd.productRequestType == 'Remove'){
            query = 'select id,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Customer_Group__c, Name,FELineItemId__c,Apttus_Config2__BaseProductId__c, Apttus_Config2__Quantity__c,Apttus_Config2__ItemSequence__c,Mark_Removed__c, Apttus_Config2__ListPrice__c, Apttus_Config2__NetPrice__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__BasePrice__c, Apttus_Config2__NetUnitPrice__c, Apttus_Config2__ChargeType__c, Apttus_Config2__ConfigurationId__r.Apttus_config2__Status__c, Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c where  FELineItemId__c=\''+String.escapeSingleQuotes(pd.lineItemId)+'\'';
        }
        
         
        for(Apttus_Config2__LineItem__c li : Database.query(query)){
            li.Apttus_Config2__ConfigurationId__c = cartId;
            li.FELineItemId__c = pd.lineItemId;
            li.Apttus_Config2__LineNumber__c = Decimal.ValueOf(pd.lineNumber);
            li.Apttus_Config2__PrimaryLineNumber__c=  li.Apttus_Config2__LineNumber__c;
            li.Apttus_Config2__ItemSequence__c =  li.Apttus_Config2__LineNumber__c;
            lineItems.put(li.FELineItemId__c,li);
            lineItemlst.add(li);
            
        }
        DCPCartMultiProductRequestUtility.updateQuote(cartId,pd);
    } catch (Exception e) {
        if(cartId!=null){
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Server Side Cart Sync Up Issue','reqMsg'=>'Exception Class Name: DCP_CartPriceRequest','module'=>'UEStore','recId'=>cartId,'supportEmail'=>'','toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);
        }
    }
return lineItems;
}


 /********************************************************************************************************
*  @description  callLineItemQueue - This is a method to fire line item creation queuable job
**********************************************************************************/
 public static void callLineItemQueue(){
       List<UE_Proposal__c> oQList = new List<UE_Proposal__c>([Select lineitemId__c from UE_Proposal__c where type_of_line__c ='US Legal' and isLineActive__c=true limit 2000]);

    if((OQList!=null && oQlist.size() <= Integer.valueof(Static_Values__c.getValues('LineItemHalf').Value__c))){
        String[] status = new String[]{'Holding','Preparing','Processing','Queued'};
            List<AsyncApexJob> asyncJobList = new  List<AsyncApexJob>([select Id,ApexClass.Name,Status from AsyncApexJob where CreatedDate = TODAY and ApexClass.Name = 'TRStore_CreateProposalApexQueue' and (status IN:Status) WITH SECURITY_ENFORCED]);
        if(asyncJobList.size()==0){
            System.enqueueJob(new DCPCreateLineQueue());
        }
    }
}

/********************************************************************************************************
*  DCP_CartPriceRequest : This is the post method to maniplate cart and expected cartdetail 
*  @description  doLineItemManipulation  - This is the a method to check type of request and process based on type 
*  @return List<Apttus_Config2__LineItem__c>  : this is a return statement after maniplate line items 
*  @param pd - expected product details 
*  @param alllineitems - map method for string and line items 
*  @param cartId - Cart id to maniplate the details 
*********************************************************************************************************/ 
public Static List<Apttus_Config2__LineItem__c> doLineItemManipulation(DCP_CartPriceRequest.ProductDetail pd,Map<String, Apttus_Config2__LineItem__c> alllineitems, String cartId){
    Apttus_Config2__LineItem__c li = alllineitems.get(pd.lineItemId);
    List<Apttus_Config2__LineItem__c> linestoUpdate = new List<Apttus_Config2__LineItem__c>();
    if (String.isNotBlank(pd.quantity) && pd.productrequestType == 'Add') 
    {
        linestoUpdate = DCPCartMultiProductRequestHelper.doUpdateCart(li,pd,cartId);
    }else if(pd.productrequestType == 'Remove'){
            li.Mark_Removed__c = true;
            linestoUpdate.add(li);
    }else if(String.isNotBlank(pd.quantity) && pd.productrequestType == 'Update') 
    {
            li.Apttus_Config2__Quantity__c = Double.valueOf(pd.quantity);
            li.Apttus_Config2__PricingStatus__c = 'Pending';
            DCP_CartPriceRequest.LineItemArray lineDetails = pd.lineItemArray;
            lineItemContractDetails(li, lineDetails);
            linestoUpdate.add(li);
    }/*else if(pd.productrequestType == 'Undo'){
        lineItem.Mark_Removed__c = false;
        linestoUpdate.add(lineItem);
    }*/
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
        lineItem = DCPCartMultiProductRequestHelper.updateALine(lineItem,pd);
        lineItem.Apttus_Config2__PriceListId__c = getCartInfo(cartId);
        DCP_CartPriceRequest.LineItemArray lineDetails = pd.lineItemArray;
        
        lineItemContractDetails(lineItem, lineDetails);
        if(pd.attributeDetailList!=null && pd.attributeDetailList.size()>0 && pd.hasAttribute){
            system.debug(LoggingLevel.INFO,'Sample Attribute:');
            /*lineItem.Apttus_Config2__HasAttributes__c = true;
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
            }*/
        }
        
        linestoUpdate.add(lineItem);
        return linestoUpdate;
}

    private static Apttus_Config2__LineItem__c updateALine(Apttus_Config2__LineItem__c lineItem,DCP_CartPriceRequest.ProductDetail pd){
        lineItem.Apttus_Config2__Quantity__c = Double.valueOf(pd.quantity);
        lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
        lineItem.Mark_Removed__c = false;
        lineItem.TRStore_Site__c = String.isNotBlank(pd.site)?pd.site:'';
        lineItem.Apttus_Config2__ListPrice__c = String.isNotBlank(pd.listPrice)?Double.valueOf(pd.listPrice):0;
        lineItem.Apttus_Config2__ProductId__c =  pd.productId;
        lineItem.Apttus_Config2__BaseProductId__c = String.isNotBlank(pd.baseProduct)?pd.baseProduct:null;
        return lineItem;
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

}