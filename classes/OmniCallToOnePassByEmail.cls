/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-03-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-03-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
Public class OmniCallToOnePassByEmail{
     /**
   * @description callToOnePass
   * @param emailId
   * @return responseWrap
   */
    @AuraEnabled
    public static OmniOnePassResponseWrapper callToOnePass(String emailId){
        
        String companyId = 'WEST';
        
        Http http = new Http();
        
        HttpRequest request = createHttpRequest(emailId, companyId);
        
        OmniOnePassResponseWrapper responseWrap = null; 
         
        HttpResponse response = http.send(request);
        
        System.debug(LoggingLevel.DEBUG, '@@response.getBody(): '+response.getBody());
        
        if (response.getStatusCode() == 200) {
         
         System.debug(LoggingLevel.DEBUG, '@@response.getBody(): '+response.getBody());
         
         responseWrap = OmniOnePassResponseWrapper.parse(response.getBody());
         
         System.debug(LoggingLevel.DEBUG, '@@responseWrap: '+responseWrap);   
        }
        return responseWrap;
        
    }
    
     /**
   * @description createHttpRequest
   * @param emailId
   * @param companyId
   * @return request
   */
    //@testvisible
    public static HttpRequest createHttpRequest(String emailId, String companyId){
    
        WebServiceSettings__c getonePassServices = AppUtil.getWebServiceSettings('OmniOnePassToBoomi');
        
        String accessToken= OmniBoomiTokenGeneration.getAuthToken();
        
        HttpRequest request = new HttpRequest();
        String grantType = 'client_credentials';
        String contentType= 'application/x-www-form-urlencoded';
        String url =getonePassServices.Endpoint__c+'/companyId/'+companyId+'?emailAddress='+emailId;
        System.debug(LoggingLevel.DEBUG, 'url: '+url);
        request.setEndpoint(url);
        //request.setEndpoint('https://api-dev.thomsonreuters.com/boomi/omc/onlinecontacts/v1/GetOnlineContactsByEmail/companyId/WEST?emailAddress=FEBTest5.corp1.user1@mailinator.com');
        request.setMethod('GET');
        request.setTimeout(120000);    
        request.setHeader(Label.CalloutHeader,'Bearer '+accessToken);
        request.setHeader('Content-Type', contentType);
        request.setHeader('grant_type', grantType);
        request.setHeader('Content-Length','0');
        
        return request;
        
    }
}