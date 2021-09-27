/*============================================================================================
    Name                : ODTReactivateEntitlementService
    Description         : This class is developed as part of CXD-ODT project. 
    Created Date        : 11/02/2018
    Author              : CXD ODT team
    Modification History: 
    Date           Name                    Description
    11/23/2018     Rajan            Created[DLT-13476, DLT-13535]
    
===============================================================================================*/

public class ODTReactivateEntitlementService{
  
  // Code to reactivate Entitlement
    public static Boolean reactivateEntitlement(Trial__c trialObj){
        Boolean isReactivate = false;
        try{
            ReactivateEntitlementRequest reactEntRequest = ODTReactivateEntitlementService.getReactEntRequest(trialObj);
            String esiReactEntRequest = JSON.serialize(reactEntRequest);
            
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ODTReactivateEntitlementService');
            
            system.debug('esiReactEntRequest' + esiReactEntRequest);
                        
            HttpRequest request = new HttpRequest(); 
            request = ODTReactivateEntitlementService.callReactivateESIService(esiReactEntRequest, oWebServiceSettings);
            HTTPResponse response ;
            Http http = new Http();
            
            system.debug('esiReactEntRequest' + request);
         
            if(!test.isrunningtest()){
                response = http.send(request);
            }else{
                String responseJSON = '{"billingGroupNumber":"1004625067","billingGroupName":"TEST_SAMPLE_11","status":"Success","contactInformation":[{"contactTransactionId":"0000-8000-2282-1382","contactNumber":"0006140135","success":"true","entitlements":[{"applicationId":"COBALT","appUserId":"9995259385","appUserPassword":"LIR9F727755937","appUserGuid":"i0ace19a80000015b43cdf9998b1d46aa"}]},{"contactTransactionId":"0000-8000-2282-1382","contactNumber":"0006140134","success":"true","entitlements":[{"applicationId":"COBALT","appUserId":"9995259384","appUserPassword":"3HNX3505551144","appUserGuid":"i0acc051b0000015b43cc917101da841d"}]}]}';
                
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody(responseJSON);
                response.setStatusCode(200); 
            }
            system.debug('Response' + response.getBody());
            system.debug('response.getStatusCode()' + response.getStatusCode());
            if(response.getStatusCode()== 200){  
                ReactivateEntitlementResponse ESIReactEntRes = (ReactivateEntitlementResponse)JSON.deserialize(response.getBody(), ReactivateEntitlementResponse.class);
                Boolean isreqSuccess = false;
                system.debug('ESIReactEntRes' + ESIReactEntRes);  
                if(ESIReactEntRes != null && ESIReactEntRes.status != null && ESIReactEntRes.status.equalsIgnoreCase('Success')){
                    isreqSuccess = true;
                }
        system.debug('isreqSuccess' + isreqSuccess);
                if(isreqSuccess){
                    for(ReactivateEntitlementResponse.ContactInformation contact : ESIReactEntRes.contactInformation){
                      system.debug('contact' + contact);
            if(contact.success.equalsIgnoreCase('true')){
                          isReactivate = true;
                      }
                  }
                }
            }else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+response.getBody()));
      }
      system.debug('Final isReactivate value' + isReactivate);
        }catch(Exception ex){
            system.debug('Exception' + ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+ex.getMessage()));
        }
        return isReactivate;
          
    }
  
  public static ReactivateEntitlementRequest getReactEntRequest(Trial__c trialObj){
    try{
      if(trialObj != null){
        ReactivateEntitlementRequest reactEntRequest = new ReactivateEntitlementRequest();
        
        //Create ESI Header request
        ReactivateEntitlementRequest.ESIHeader ESIHeaderReq = new ReactivateEntitlementRequest.ESIHeader();
        ESIHeaderReq.applicationId = 'CXODT';
        ESIHeaderReq.companyId = trialObj.Source_System_Detail__r.LCRM_Sales_Org__c;
        ESIHeaderReq.transactionId = trialObj.Transaction_Id__c;
        reactEntRequest.ESIHeader = ESIHeaderReq;
        
        //Create OnlineContacts request for primary user
        List<ReactivateEntitlementRequest.OnlineContacts> OnlineContactsReqList = new List<ReactivateEntitlementRequest.OnlineContacts>();
        ReactivateEntitlementRequest.OnlineContacts OnlineContactsReq = new ReactivateEntitlementRequest.OnlineContacts();
        OnlineContactsReq.contactNumber = trialObj.Contact_id_SAP__c;
        //OnlineContactsReq.sourceId = trialObj.Trial_Source__c;
        OnlineContactsReq.sourceId = 'ODT TEMPLT';
        
        ReactivateEntitlementRequest.Account accountReq = new ReactivateEntitlementRequest.Account();
        accountReq.accountNumber = trialObj.ODT_SAP_Account_Number__c;
        OnlineContactsReq.account = accountReq;
        
        ReactivateEntitlementRequest.Entitlements entitlementsReq = new ReactivateEntitlementRequest.Entitlements();
        entitlementsReq.templateId = trialObj.Profile_ID__c;
        entitlementsReq.templateType = 'PROFILE ID';
                
        ReactivateEntitlementRequest.Subscriptions subscriptionsReq = new ReactivateEntitlementRequest.Subscriptions();
        subscriptionsReq.offerId = trialObj.Trial_Id__c;
        subscriptionsReq.dataOwner = 'ODT';
        subscriptionsReq.offerChannel = 'email';
        subscriptionsReq.trialAdjEndTimestamp = string.valueOf(trialObj.ODT_Trial_Extend_Date__c);
        
        entitlementsReq.subscriptions = subscriptionsReq;
        
        OnlineContactsReq.Entitlements = entitlementsReq;
        
        OnlineContactsReqList.add(OnlineContactsReq);
        
        if(trialObj.Invite_Colleagues__r != null && trialObj.Invite_Colleagues__r.size() > 0){
			List<ReactivateEntitlementRequest.OnlineContacts> invitedColList = getInvitedColleagues(trialObj);
			OnlineContactsReqList.addAll(invitedColList);
        }
        
        reactEntRequest.onlineContacts = OnlineContactsReqList;
        
        system.debug('final reactEntRequest' + reactEntRequest);
        return reactEntRequest;
      }
    }catch(Exception ex){
      system.debug('Exception' + ex);
      throw ex;
    }
    return null;
  }
  
  public static List<ReactivateEntitlementRequest.OnlineContacts> getInvitedColleagues(Trial__c trialObj){
    List<ReactivateEntitlementRequest.OnlineContacts> OnlineContactsReqList = new List<ReactivateEntitlementRequest.OnlineContacts>();
    for(Invite_Colleagues__c colleagues : trialObj.Invite_Colleagues__r){
      if(!colleagues.Primary_User__c){
        ReactivateEntitlementRequest.OnlineContacts OnlineContactsReq = new ReactivateEntitlementRequest.OnlineContacts();
        OnlineContactsReq.contactNumber = colleagues.SapContactId__c;
        //OnlineContactsReq.sourceId = trialObj.Trial_Source__c;
        OnlineContactsReq.sourceId = 'ODT TEMPLT';
        
        ReactivateEntitlementRequest.Account accountReq = new ReactivateEntitlementRequest.Account();
        accountReq.accountNumber = trialObj.ODT_SAP_Account_Number__c;
        OnlineContactsReq.account = accountReq;
        
        ReactivateEntitlementRequest.Entitlements entitlementsReq = new ReactivateEntitlementRequest.Entitlements();
        entitlementsReq.templateId = trialObj.Profile_ID__c;
        entitlementsReq.templateType = 'PROFILE ID';
                
        ReactivateEntitlementRequest.Subscriptions subscriptionsReq = new ReactivateEntitlementRequest.Subscriptions();
        subscriptionsReq.offerId = trialObj.Trial_Id__c;
        subscriptionsReq.dataOwner = 'ODT';
        subscriptionsReq.offerChannel = 'email';
        subscriptionsReq.trialAdjEndTimestamp = string.valueOf(trialObj.ODT_Trial_Extend_Date__c);
      
        entitlementsReq.subscriptions = subscriptionsReq;
        
        OnlineContactsReq.Entitlements = entitlementsReq;
        
        OnlineContactsReqList.add(OnlineContactsReq);
      }
    }
    return OnlineContactsReqList;
  }
  public static HttpRequest callReactivateESIService(string esiJsonReq, WebServiceSettings__c ws){

    String username = ws.Username__c;
    String password = ws.Password__c;

    blob  headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);

    HttpRequest req = new HttpRequest(); 
    req.setMethod('POST');
    req.setEndpoint(ws.Endpoint__c);
    req.setHeader('Authorization', authorizationHeader );
    req.setBody(esiJsonReq);

    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Accept', 'application/json');
    req.setTimeout(120000)  ;

    return req;
  }
}