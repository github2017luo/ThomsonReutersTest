/* Class: TRStore_UpdateCartService
* Purpose: Rest API Service to update the Apttus cart in SFDC
* Created: 2020-11-05
* Author: Ameeta A
* 
* CHANGE HISTORY
* =============================================================================================================================
* Date         Name           JIRA        Description
* 2020-11-05   Ameeta A       DLT-21056   Updating Coupon code on cart 
* =============================================================================================================================
*/
@RestResource(urlMapping='/TRStoreCartUpdateAPI')
global with sharing class TRStore_UpdateCartService {
    
    global class TRStore_PromotionRequestClass
    {
        public String promoCode;
        public string cartId;
    }
    
    @HttpPost
     global static void updateCart (TRStore_UpdateCartService.TRStore_PromotionRequestClass cartReq){
        String cartReqJson;
        String cartId = cartReq.cartId;
        RestRequest req = RestContext.request;
        RestContext.request = req;
        RestContext.response.addHeader('Content-Type', 'application/json');
        if(String.isNotBlank(cartReq.promoCode) && String.isNotBlank(cartId)){
            cartReqJson = updateCartWithPromo(cartReq.promoCode,cartId);  
            
        }else{
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject(); 
                    gen.writeFieldName('status');
                    gen.writeStartObject();
                    gen.writeStringField('statusDesc ',TRStoreConstants.REQUIREDFIELDSMISSING);
                    gen.writeStringField('statusCode ',TRStoreConstants.ERROR_CODE);
                    gen.writeStringField('status',TRStoreConstants.FAILURESTATUS);
                    gen.writeEndObject();
                    gen.writeEndObject();
                    cartReqJson = gen.getAsString();  
        }
        System.debug('cartReqJson'+cartReqJson);
        try{
           RestContext.response.responseBody = Blob.valueOf(cartReqJson);  
        }catch(Exception e){
            system.debug(loggingLevel.INFO,'Exception:'+e);
            String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage(),'webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Manual/Auto Promotion','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>'','supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);
        }
        
    }
    
/********************************************************************************************************
* updateCartWithPromo: Method to update promocode in the server side cart 
*  @input promoCodeList,cartId @returns jsonResponse
*********************************************************************************************************/
    public static String updateCartWithPromo (String promoCode, String cartId){
         
        String cartReqJson;
        try{
            String query = 'select id,Apttus_Config2__CouponCodes__c from Apttus_Config2__ProductConfiguration__c where Id=:CartId limit 1';
            Apttus_Config2__ProductConfiguration__c pc = Database.Query(query);
            if(pc!=null){
                     if( String.isBlank(pc.Apttus_Config2__CouponCodes__c) || !String.valueOf(pc.Apttus_Config2__CouponCodes__c).contains(promoCode)){
                       pc.Apttus_Config2__CouponCodes__c = String.isNotBlank(pc.Apttus_Config2__CouponCodes__c)?pc.Apttus_Config2__CouponCodes__c+','+promoCode: promoCode;
                     }
                   
               Database.SaveResult sr = Database.update(pc,false);
               cartReqJson = mapResponseJson(sr);                              
            }
         }catch(Exception e){
            system.debug(loggingLevel.INFO,'Exception:'+e);
            String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage(),'webServiceName'=>'PromotionAPI','requestType'=>'Promotion Service: Promo Update on Cart','reqMsg'=>'Exception Class Name: TRStore_PromotionService','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);
        }
        return cartReqJson;
    }

/********************************************************************************************************
* mapResponseJson: Method to map response to JSON 
*  @input Database.SaveResult @returns jsonResponse
*********************************************************************************************************/    
    public static String mapResponseJson(Database.SaveResult sr){
        JSONGenerator gen = JSON.createGenerator(true);
        String cartReqJson;
        if(sr.isSuccess()){
                System.debug('Successfully updated cart. Cart ID: ' + sr.getId()); 
                gen.writeStartObject();
                gen.writeFieldName('status');
                    gen.writeStartObject();
                    gen.writeStringField('statusDesc ',TRStoreConstants.DETAILS_FOUND);
                    gen.writeStringField('statusCode ',TRStoreConstants.SUCCESS_CODE);
                    gen.writeStringField('status',TRStoreConstants.SUCCESS_STATUS);
                    gen.writeEndObject();
                    gen.writeEndObject();
                    cartReqJson = gen.getAsString(); 
               }else{
                gen.writeStartObject(); 
                    gen.writeFieldName('status');
                    gen.writeStartObject();
                    gen.writeStringField('statusDesc ',TRStoreConstants.REQUIREDFIELDSMISSING);
                    gen.writeStringField('statusCode ',TRStoreConstants.ERROR_CODE);
                    gen.writeStringField('status',TRStoreConstants.FAILURESTATUS);
                    gen.writeEndObject();
                    gen.writeEndObject();
                    cartReqJson = gen.getAsString();   
               }
        return cartReqJson;
    }
}