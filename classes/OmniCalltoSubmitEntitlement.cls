/******************************************************************************************
* Class         : DPS-21463 - OmniCalltoSubmitEntitlement
* @description  : Submit Entitlement /Create Trial
* @param        : NA
* @return       : NA
* Created Date  : JUN-2021
* Author        : TCS Developer 
* ****************************************************************************************/
public without sharing class OmniCalltoSubmitEntitlement{
    
  /**
  * @description callToSubmitEntitlement
  * @param triaId
  * @param emailIds
  * @param productCodes
  * @return isSuccess
  */
   public static Boolean callToSubmitEntitlement(Id trialId,  List<Id> trialContIds, List<Id> trialPrdIds){    
       Boolean isSuccess =false;
       String reqJSONBody = OmniSubmitEntitlRequestJSON.submitEntitlement(trialId, trialContIds, trialPrdIds); 
       System.debug('reqJSONBody: '+reqJSONBody);
       HttpRequest request = createHttpRequest(reqJSONBody);
       
       Http http = new Http();
       HttpResponse response = http.send(request);
       System.debug('respBody: '+response.getBody());
       if(response.getStatusCode() == 200){
            isSuccess= true;
       }
      return isSuccess;
   }
   
   /**
  * @description createHttpRequest
  * @param reqJSONBody
  * @return request
  */
   @testVisible
   private static HttpRequest createHttpRequest(String reqJSONBody){
   
       WebServiceSettings__c getonePassServices = AppUtil.getWebServiceSettings('OmniSubmitEntitlementBoomiService');
       
       String accessToken= OmniBoomiTokenGeneration.getAuthToken();
       
       HttpRequest request = new HttpRequest();
       String grantType = 'client_credentials';
       String contentType= 'application/x-www-form-urlencoded';
       
       request.setEndpoint(getonePassServices.Endpoint__c);
       
       request.setMethod('POST');
       request.setTimeout(120000);  
       request.setBody(reqJSONBody);
         
       request.setHeader(Label.CalloutHeader,'Bearer '+accessToken);
       request.setHeader('Content-Type', contentType);
       request.setHeader('grant_type', grantType);
       request.setHeader('Content-Length','0');
       
       return request;
   }
}