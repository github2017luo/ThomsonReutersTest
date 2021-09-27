/******************************************************************************************
* Class         : OmniCallToOLCByEmail
* @description  : test
* @param        : NA
* @return       : NA
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
    public without sharing class OmniCallToOLCByEmail{
    
/******************************************************************************************
* Method Name   : showOnlineContacts
* @param        : accountId
* @return       : LIST <contactsWrapper>
* @description  : fetch online contacts from OLC
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
    @AuraEnabled(cacheable=true)
    /**
    * @description getOLCDetailsByEmail
    * @param  emailId
    * @return response
    */
    public static OmniCallToOLCByEmailResponseWrapper  getOLCDetailsByEmail(string emailId){
        
        OmniCallToOLCByEmailResponseWrapper response = null;
        
        
        HTTPResponse  res = getOnlineContactsResFromOLC(emailId);
        
        System.debug(LoggingLevel.DEBUG, '@@Response: '+res.getstatusCode());
        if(res.getstatusCode() == 200 && res.getbody() != null){
        
            //response = (OmniCallToOLCByEmailResponseWrapper) System.JSON.deserialize(res.getBody(), OmniCallToOLCByEmailResponseWrapper.class);
            response = OmniCallToOLCByEmailResponseWrapper.parse(res.getBody());
            System.debug(LoggingLevel.DEBUG, '@@Response: '+response );
        }
        return response; 
    }

    /******************************************************************************************
    * Method Name   : getOnlineContactsResFromOLC
    * @param        : accountId
    * @return       : HTTPResponse
    * @description  : fetch online contacts from OLC
    * Created Date  : 07-May-2021
    * Author        : TCS Developer 
    * ****************************************************************************************/
    
    /**
     * @description getOnlineContactsResFromOLC
     * @param emailId
     * @return res
    */
    @testVisible  private static HTTPResponse getOnlineContactsResFromOLC(string emailId){
        
        HTTPResponse res;
        
        WebServiceSettings__c getEntitlementURL = AppUtil.getWebServiceSettings('OmniGenericEntitlementService');
        
        HttpRequest  req = gethttpRequestForContacts(emailId, getEntitlementURL);
        
        System.debug(LoggingLevel.DEBUG, '@@Reqeust: '+req.getBody());
        Http http = new Http();
        
        Long dt1Long = DateTime.now().getTime();
        
        System.debug(LoggingLevel.DEBUG, '@@sending request start time OLC: '+system.now());
        
        res = http.send(req);
        
        Long dt2Long = DateTime.now().getTime();
        Long milliseconds = dt2Long - dt1Long;
        Long seconds = milliseconds / 1000;
        System.debug(LoggingLevel.DEBUG, '@@got response end OLC: '+system.now());
        System.debug(LoggingLevel.DEBUG, '@@milliseconds: '+milliseconds +'  : seconds:  '+seconds);
        
        return res;
    }
    
/******************************************************************************************
* Method Name   : gethttpRequestForContacts
* @param        : accountId,getEntitlementURL
* @return       : HttpRequest
* @description  : To prepare httpRequest
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
    /**
   * @description gethttpRequestForContacts
   * @param emailId
   * @param getEntitlementURL
   * @return req
   */
    @testVisible
    private static HttpRequest gethttpRequestForContacts(string emailId, WebServiceSettings__c getEntitlementURL){
        
        
        blob headerValue = Blob.valueOf(getEntitlementURL.Username__c + ':' + getEntitlementURL.Password__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        OmniCallToOLCByEmailRequestWrapper reqBody = new OmniCallToOLCByEmailRequestWrapper();
        reqBody.emailAddress = emailId;
        reqBody.ESIHeader =new  OmniCallToOLCByEmailRequestWrapper.ESIHeader(Label.ODT_ESI_App_userID);
        reqBody.account =new  OmniCallToOLCByEmailRequestWrapper.Account(null);
        reqBody.OnlineContactFilter =new  OmniCallToOLCByEmailRequestWrapper.OnlineContactFilter('true','true');
        
        String reqBodyOLC= JSON.serialize(reqBody);
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(getEntitlementURL.Endpoint__c);
        req.setHeader(Label.CalloutHeader, authorizationHeader);
        req.setBody(reqBodyOLC);
        
        //req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(120000);
         
        
        return req;
    }
 

}