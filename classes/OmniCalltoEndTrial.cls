/******************************************************************************************
* Class         : DPS-21106
* TestClass     : 
* @description  : Submit Entitlement /Create Trial
* @param        : NA
* @return       : NA
* Created Date  : July-2021
* Author        : TCS Developer 
* ****************************************************************************************/
public without sharing class OmniCalltoEndTrial{
    
  /**
  * @description callToEndTrail
  * @param trialId
  * @param endReason
  * @param requestType
  * @return isSuccess
  */
    @AuraEnabled
   public static Boolean callToEndTrail(Id trialId,  String endReason,string requestType){    //EndReason valriable name should changed 
       Boolean isSuccess =false;
       string reqJSONBody ;
       
       if(requestType == 'TRIAL_END'){
       reqJSONBody = OmniEndTrialRequestJSON.endTrialRequest(trialId,endReason,requestType); 

       }
       else if(requestType == 'TRIAL_EXTEND'){
         reqJSONBody = OmniEndTrialRequestJSON.extendTrialRequest(trialId,endReason,requestType);
         
       }
       System.debug(LoggingLevel.DEBUG,'reqJSONBody: '+reqJSONBody);
       HttpRequest  request = createHttpRequest(reqJSONBody);
       Http http = new Http();
       HttpResponse response = http.send(request);
         System.debug(LoggingLevel.DEBUG,'respBody: '+response.getBody());
     
       
       Set<Id> trialActiveContIds = OmniEndTrialRequestJSON.trialActiveContIds;
       
       if(response.getStatusCode() == 200 && requestType == 'TRIAL_END'){
           //Below method will update End trial details once ENd Trial is sumitted
            isSuccess = OmniEndTrialsController.updateEntTrialContAfterEndTrial(trialId,  trialActiveContIds,endReason);
            
       }
       else if(response.getStatusCode() == 200 && requestType == 'TRIAL_EXTEND'){
           //Below method will update End trial details once ENd Trial is sumitted
            isSuccess = OmniEndTrialsController.updateEntTrialContAfterExtTrial(trialId,trialActiveContIds,endReason);//Parameter Variable name should change
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