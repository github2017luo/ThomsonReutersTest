/******************************************************************************************
* Class         : OmniCallToOLCFetchOnlineContacts
* @description  : test
* @param        : NA
* @return       : NA
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
    public without sharing class OmniCallToOLCFetchOnlineContacts{
    
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
    * @description showOnlineContacts
    * @param  accountID
    * @return contasTodisplay
    */
    public static List<TrialContactWrapper> showOnlineContacts(string accountID){
        
        HTTPResponse  res = getOnlineContactsResFromOLC(accountID);
        LIST < OmniContactsWrapper.contactsWrapper > contasTodisplay = new LIST < OmniContactsWrapper.contactsWrapper >();
        OmniEsiResponseWrapper esiResp = OmniCallToOLCFetchOnlineContactsHelper.responseDeserialize(res);
        if (esiResp.onlineContact != null) {
            contasTodisplay = processingResponse(esiResp,accountID);
        }
        
        //contactsWrapper  store to TrialContactWrapper List as need to show on LWC UI and return it
        
        List<TrialContactWrapper> onlineContactWrapList = getTrialOnlineContactWrapList(contasTodisplay);
        
        return onlineContactWrapList; 
    }

    
    /**
    * @description showOnlineContacts
    * @param  contasTodisplay
    * @return contasTodisplay
    */
    @testVisible
    private static List<TrialContactWrapper> getTrialOnlineContactWrapList(LIST < OmniContactsWrapper.contactsWrapper > contasTodisplay){
    
        List<TrialContactWrapper> onlineContactWrapList = new List<TrialContactWrapper>();
        
        if(contasTodisplay != null && !contasTodisplay.isEmpty()){
            
            for(OmniContactsWrapper.contactsWrapper  cont : contasTodisplay)
            {
                TrialContactWrapper contactWrap = new TrialContactWrapper();
                
                contactWrap.contactId = null; 
                contactWrap.email = cont.emailId; 
                contactWrap.firstName = cont.firstName; 
                contactWrap.lastName = cont.lastName; 
                contactWrap.onlineContact = true; 
                contactWrap.isPrimaySelectedFromUI = false;
                contactWrap.oLCStatus = cont.oLCStatus;
                contactWrap.fullName = cont.firstName+' '+cont.lastName;
                
                if(contactWrap!= null && contactWrap.email != null ){
                    onlineContactWrapList.add(contactWrap);
                }
            }
        }
        return onlineContactWrapList;
    }

/******************************************************************************************
* Method Name   : processingResponse
* @description  : fetch online contacts from OLC
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/  
/**
 * @description processingResponse
 * @param esiresp
 * @param accountID
 * @return contasTodisplay
 */      
  @testVisible private static list<OmniContactsWrapper.contactsWrapper> processingResponse(OmniEsiResponseWrapper esiresp, string accountID){
             LIST < OmniContactsWrapper.contactsWrapper > contasTodisplay = new LIST < OmniContactsWrapper.contactsWrapper >();
             
            for (OmniEsiResponseWrapper.onlineContact olcon: esiresp.onlineContact) {
                try {
                    OmniCallToOLCFetchOnlineContactsHelper.displayContactsWrapper der;
                    if (olcon.entitlements != null ) {
                        der = OmniCallToOLCFetchOnlineContactsHelper.preparingDisplayItems(accountID,olcon); 
                    }  

                    if (der.registeredWithOLC != null && der.registeredWithOLC==true) {
                        OmniCallToOLCFetchOnlineContactsHelper.displayContactsWrapper postDer =  OmniCallToOLCFetchOnlineContactsHelper.filteringDisplayingItemds(der,olcon);
                        
                        contasTodisplay.add(new OmniContactsWrapper.contactsWrapper(postDer));
                        
                    }
                        //DLT-12962 : END
                    
                } catch (exception e) {
                    //system.debug('Exception While parsing OLC contact and skipping only that contact' + e);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, +e.getMessage()));
                }
            }
            return contasTodisplay;
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
     * @description LapsedReqWrapper
     * @param accountID
     * @return res
    */
    @testVisible  private static HTTPResponse getOnlineContactsResFromOLC(string accountID){
        
        HTTPResponse res;
        
        WebServiceSettings__c getEntitlementURL = AppUtil.getWebServiceSettings('OmniGenericEntitlementService');
        
        HttpRequest  req = gethttpRequestForContacts(accountID, getEntitlementURL);
        
        System.debug(LoggingLevel.WARN,'@@Reqeust: '+req.getBody());
        Http http = new Http();
        res = http.send(req);
        System.debug(LoggingLevel.WARN,'@@Response: '+res.getBody());
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
   * @param accountID
   * @param getEntitlementURL
   * @return req
   */
    @testVisible
    private static HttpRequest gethttpRequestForContacts(string accountID, WebServiceSettings__c getEntitlementURL){
        
        
        blob headerValue = Blob.valueOf(getEntitlementURL.Username__c + ':' + getEntitlementURL.Password__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        OmniCallToOLCFetchOnlineContactsWrapper.ESIHeaderCls esih = new OmniCallToOLCFetchOnlineContactsWrapper.ESIHeaderCls(Label.ODT_ESI_App_userID);
        OmniCallToOLCFetchOnlineContactsWrapper.accountCls acch = new OmniCallToOLCFetchOnlineContactsWrapper.accountCls(accountID);
        OmniCallToOLCFetchOnlineContactsWrapper.callInviteCol callhcol = new OmniCallToOLCFetchOnlineContactsWrapper.callInviteCol(esih, acch);
        
        String esibodyInviteCollBody = JSON.serialize(callhcol);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(getEntitlementURL.Endpoint__c);
        req.setHeader(Label.CalloutHeader, authorizationHeader);
        req.setBody(esibodyInviteCollBody);
        
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(120000);
        
        return req;
    }
 

}