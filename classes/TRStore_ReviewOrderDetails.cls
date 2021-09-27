/* Class: TRStore_ReviewOrderDetails
* Purpose: This service provides the product details/cart line items present on the review 
* order page to UI as part of UE-Transact
* Created: 5/29/2020
*  
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 5/29/2020    Ameeta           DUE-2947    Created 
* 10/29/2020   Ameeta          DUE-5750     Created
* =============================================================================
*/
@RestResource(urlMapping='/GetReviewOrderDetails/*')
global with sharing class TRStore_ReviewOrderDetails {
    
    @Httpget
    global static void getReviewOrderDetails(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        string cartId = req.params.get('cartId');
        String monthlyTotal = '0';
        List<Apttus_Config2__LineItem__c> cartLineItemList = new List<Apttus_Config2__LineItem__c>();
        Map<ID,Apttus_Config2__SummaryGroup__c> summaryGroupList = null;
                
        if(cartId != null){
            if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){
                cartLineItemList = [Select ID, Name,Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.Rollup_Net_Price__c, Apttus_Config2__LineType__c, Apttus_Config2__Quantity__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name, Apttus_Config2__ProductId__r.Stock__c, Apttus_Config2__NetPrice__c,
                                Apttus_Config2__BaseExtendedPrice__c, Apttus_Config2__BasePrice__c, Apttus_Config2__Term__c, Apttus_Config2__Frequency__c, Apttus_Config2__ChargeType__c, APTS_Format__c, Apttus_Config2__HasIncentives__c,Apttus_Config2__IncentiveCode__c,
                                Apttus_Config2__IncentiveAdjustmentAmount__c,Apttus_Config2__PriceType__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c =: cartId];
            }
            if(Schema.sObjectType.Apttus_Config2__SummaryGroup__c.isAccessible()){
                summaryGroupList = new Map<ID,Apttus_Config2__SummaryGroup__c>([Select ID,Name,Apttus_Config2__ConfigurationId__c,Apttus_Config2__NetPrice__c,Apttus_Config2__BaseExtendedPrice__c from Apttus_Config2__SummaryGroup__c where Apttus_Config2__ConfigurationId__c =: cartId AND Name=:'Total (Monthly)']);
            }
        }
        
        if(summaryGroupList != null && summaryGroupList.size() > 0){
            Apttus_Config2__SummaryGroup__c sg = summaryGroupList.values();
        	monthlyTotal = String.valueOf(sg.Apttus_Config2__NetPrice__c);
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        if(!cartLineItemList.isEmpty()){
            gen = mapJson(gen,cartLineItemList,monthlyTotal);
            
        }else{
            gen = TRStore_ReviewOrderDetails.errorResponse();
        }
        String jsonData = gen.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        try{ 
            RestContext.response.responseBody = Blob.valueOf(jsonData);
        }catch(Exception e){
            system.debug(LoggingLevel.Info,'Exception:'+e);
            TRStoreLeadprocess.logTRSException('ReviewOrderService Failed', string.valueof(e), 'ReviewOrderService', cartId, 'Product Configuration', 'Review Order', '', false);
        }
    }

    private Static JsonGenerator errorResponse(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject(); 
            gen.writeFieldName('status');
            gen.writeStartObject();
            gen.writeStringField('statusDesc ',TRStoreConstants.DETAILS_NOT_FOUND);
            gen.writeStringField('statusCode ',TRStoreConstants.DETAILS_NOT_FOUND_CODE);
            gen.writeStringField('status',TRStoreConstants.SUCCESS_STATUS);
            gen.writeEndObject();
            gen.writeEndObject();
            return gen;
    }

    private static string handleEmptyString(String source, String target){
        String returnString = source;
        if(String.isBlank(returnString) && String.isBlank(target)){
            returnString = TRStoreConstants.NOT_AVAILABLE;
        }else if(String.isBlank(returnString)){
            returnString = target;
        }
        return returnString;
    }

    public static JSONGenerator mapJson(JSONGenerator gen, List<Apttus_Config2__LineItem__c> cartLineItemList,String monthlyTotal){
        gen.writeStartObject();
            gen.writeFieldName('status');
            gen.writeStartObject();
            gen.writeStringField('statusDesc ',TRStoreConstants.DETAILS_FOUND);
            gen.writeStringField('statusCode ',TRStoreConstants.SUCCESS_CODE);
            gen.writeStringField('status',TRStoreConstants.SUCCESS_STATUS);
            gen.writeEndObject();
            gen.writeNumberField('Sub-Total', (cartLineItemList[0].Apttus_Config2__ConfigurationId__r.Rollup_Net_Price__c != null)?cartLineItemList[0].Apttus_Config2__ConfigurationId__r.Rollup_Net_Price__c:0);
            gen.writeStringField('MonthlyTotal', (String.isNotBlank(monthlyTotal))?monthlyTotal:'0');
            gen.writeFieldName('CartLineItems');
        	gen = mapLineItemjson(gen,cartLineItemList);
            gen.writeEndObject();
        return gen;    
    }
    
    public static JSONGenerator mapLineItemjson(JSONGenerator gen, List<Apttus_Config2__LineItem__c> cartLineItemList){
        gen.writeStartArray();
            for(Apttus_Config2__LineItem__c lineItem : cartLineItemList){
                gen.writeStartObject();
                gen.writeStringField('ProductName', TRStore_ReviewOrderDetails.handleEmptyString(lineItem.Apttus_Config2__ProductId__r.Name,TRStoreConstants.NOT_AVAILABLE));
                gen.writeStringField('Format', TRStore_ReviewOrderDetails.handleEmptyString(lineItem.APTS_Format__c,TRStoreConstants.NOT_AVAILABLE));
                gen.writeNumberField('PricingTerms', (lineItem.Apttus_Config2__Term__c != null)?lineItem.Apttus_Config2__Term__c:0);
                gen.writeStringField('PricingFrequency', TRStore_ReviewOrderDetails.handleEmptyString(lineItem.Apttus_Config2__Frequency__c,TRStoreConstants.NOT_AVAILABLE));
                gen.writeStringField('ChargeType', TRStore_ReviewOrderDetails.handleEmptyString(lineItem.Apttus_Config2__ChargeType__c,TRStoreConstants.NOT_AVAILABLE));
                gen.writeStringField('PriceType', TRStore_ReviewOrderDetails.handleEmptyString(lineItem.Apttus_Config2__PriceType__c,TRStoreConstants.NOT_AVAILABLE));
                gen.writeNumberField('Quantity', (lineItem.Apttus_Config2__Quantity__c != null)?lineItem.Apttus_Config2__Quantity__c:0);
                gen.writeStringField('Stock', TRStore_ReviewOrderDetails.handleEmptyString(lineItem.Apttus_Config2__ProductId__r.Stock__c,TRStoreConstants.NOT_AVAILABLE));
                gen.writeBooleanField('HasIncentives', lineItem.Apttus_Config2__HasIncentives__c);
                gen.writeNumberField('NetPrice', (lineItem.Apttus_Config2__NetPrice__c != null)?lineItem.Apttus_Config2__NetPrice__c:0);
                gen.writeStringField('IncentiveCode', TRStore_ReviewOrderDetails.handleEmptyString(lineItem.Apttus_Config2__IncentiveCode__c,TRStoreConstants.NOT_AVAILABLE));
                gen.writeNumberField('EstimatedPrice', (lineItem.Apttus_Config2__BaseExtendedPrice__c != null)?lineItem.Apttus_Config2__BaseExtendedPrice__c:0);
                gen.writeNumberField('AdjustmentAmount', (lineItem.Apttus_Config2__IncentiveAdjustmentAmount__c != null)?lineItem.Apttus_Config2__IncentiveAdjustmentAmount__c:0);
                
                gen.writeEndObject();
            }
            gen.writeEndArray();
		return gen;
    }
}