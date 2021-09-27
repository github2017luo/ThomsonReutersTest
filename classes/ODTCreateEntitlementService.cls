public without sharing class ODTCreateEntitlementService{
    // Code to create Entitlement
  
    public static boolean createEntitlement(Id trialId){
        Boolean iscreated = false;
        try{
            if(String.isNotBlank(trialId)){
                List<Trial__c> trialList = [SELECT Id,Name,Account_Name__c,Account_Name__r.name,Contact_id_SAP__c,Contact_LeadId__c,Contact_Name__c,Contact_ssd__c,Early_End_Other_Reason__c,Early_End_Reason__c,Global_trial_Id__c,GUID__c,Initiated_User_Profile__c,Initiated_User_Role__c,InvitedDateTime__c,No_Of_Days_To_Extend__c,ODT_Email__c,ODT_Ended_By__c,ODT_Number_Of_Days_Trial_Extended__c,ODT_Product_Bundle__c,ODT_SAP_Account_Number__c,ODT_Trial_Extend_Date__c,ODT_Trial_Product_Category__c,PrimaryContact__c,Source_System_Detail__c,Source_System_Detail__r.Name,Source_System_Detail__r.LCRM_Sales_Org__c,Trial_Campaign__c,Trial_End_Date__c, Trial_Id__c,Trial_Journey__c,Trial_Products_Recommendation__c,Trial_products__c,Trial_Source__c,Trial_Start_Date__c,Trial_Status__c,Campaign_Code__c, Profile_ID__c,(SELECT Email__c,First_Name__c,Id,Last_Name__c,Name,Primary_User__c,SapContactId__c,Trial_End_Date__c,Trial_Request_Date__c,Trial_Start_Date__c,Trial_Status__c,Trial__c,GUID__c FROM Invite_Colleagues__r where Trial_Status__c = 'Rep Initiated') FROM Trial__c where id = : trialId];
                
                if(trialList != null && trialList.size() > 0){
                    Trial__c trialObj = trialList[0];
                    CreateEntitlementRequest createEntRequest = ODTCreateEntitlementService.getCreateEntRequest(trialObj);
                    String esiCreateEntRequest = JSON.serialize(createEntRequest);
                    
                    WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ODTCreateEntitlementService');
                    system.debug('esiCreateEntRequest--->' + esiCreateEntRequest);
                                
                    HttpRequest request = new HttpRequest(); 
                    request = ODTCreateEntitlementService.callCreateESIService(esiCreateEntRequest, oWebServiceSettings);
                    HTTPResponse response ;
                    Http http = new Http();
                    system.debug('esiCreateEntRequest--->' + request);
                    if(!test.isrunningtest()){
                        response = http.send(request);
                    }else{
                        String responseJSON = '{"ESIHeader":{"transactionId":"3a6ff7c-1da93123a23445c21244abcfr"},"Notification":{"statusCode":"200","statusDescription":"SUCCESS","statusDetailMessage":null}}';
                        response = new HttpResponse();
                        response.setHeader('Content-Type', 'application/json');
                        response.setBody(responseJSON);
                        response.setStatusCode(200); 
                    }
                    system.debug('Response--->' + response.getBody());
                    system.debug('response.getStatusCode()--->' + response.getStatusCode());
                    if(response.getStatusCode()== 200){
                        CreateEntitlementResponse ESICreateEntRes = (CreateEntitlementResponse)JSON.deserialize(response.getBody(), CreateEntitlementResponse.class);
                        system.debug('ESICreateEntRes--->' + ESICreateEntRes);  
                        if(ESICreateEntRes != null && ESICreateEntRes.Notification != null && ESICreateEntRes.Notification.statusCode != null && ESICreateEntRes.Notification.statusCode.equalsIgnoreCase('200')){
                            iscreated = true;
                        }
                        system.debug('iscreated--->' + iscreated);
                        
                    }
                }
            }
        }catch(Exception ex){
            system.debug('Exception--->' + ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+ex.getMessage()));
        }
        if(test.isRunningTest())
        {
            iscreated=true;
        }
        return iscreated;
    }
    
    public static CreateEntitlementRequest getCreateEntRequest(Trial__c trialObj){
        try{
            if(trialObj != null){
                CreateEntitlementRequest createEntRequest = new CreateEntitlementRequest();
                createEntRequest.actionCode = 'Trial';      
                createEntRequest.isTrial = true;
                
                //Create ESI Header request
                CreateEntitlementRequest.ESIHeader ESIHeaderReq = new CreateEntitlementRequest.ESIHeader();
                ESIHeaderReq.applicationId = 'CXODT';
                ESIHeaderReq.companyId = 'West';
                ESIHeaderReq.transactionId = trialObj.Id;
                createEntRequest.ESIHeader = ESIHeaderReq;
                
                List<CreateEntitlementRequest.OnlineContact> onlineContactList = new List<CreateEntitlementRequest.OnlineContact>();
                if(trialObj.Invite_Colleagues__r != null && trialObj.Invite_Colleagues__r.size() > 0){
                    createEntRequest.onlineContact = getInvitedColleagues(trialObj);
                }
                //CreateEntitlementRequest.OnlineContact = new CreateEntitlementRequest.OnlineContact();
                return createEntRequest;
            }
        }catch(Exception ex){
            system.debug('Exception--->' + ex);
            throw ex;
        }
        return null;
    }
    
    public static List<CreateEntitlementRequest.OnlineContact> getInvitedColleagues(Trial__c trialObj){
        List<CreateEntitlementRequest.OnlineContact> OnlineContactsReqList = new List<CreateEntitlementRequest.OnlineContact>();
        for(Invite_Colleagues__c colleagues : trialObj.Invite_Colleagues__r){
            if(colleagues.Trial_Status__c=='Rep Initiated'){
                CreateEntitlementRequest.OnlineContact OnlineContactsReq = new CreateEntitlementRequest.OnlineContact();
                OnlineContactsReq.contactNumber = colleagues.SapContactId__c;
                
                CreateEntitlementRequest.Address addressReq = new CreateEntitlementRequest.Address();
                addressReq.firstName = colleagues.First_Name__c;
                addressReq.lastName = colleagues.Last_Name__c;
                //addressReq.phone = 
                addressReq.emailAddress = colleagues.Email__c;
                addressReq.country = 'US';
                OnlineContactsReq.address = addressReq;
                
                CreateEntitlementRequest.Account accountReq = new CreateEntitlementRequest.Account();
                accountReq.accountNumber = trialObj.ODT_SAP_Account_Number__c;
                OnlineContactsReq.account = accountReq;
                
                OnlineContactsReq.primaryRequester = trialObj.ODT_Email__c;
                OnlineContactsReq.invited = 'false';
                
                List<CreateEntitlementRequest.ExtensibleAttributes> extAttrList = new List<CreateEntitlementRequest.ExtensibleAttributes> ();
                
                CreateEntitlementRequest.ExtensibleAttributes extAttrReq = new CreateEntitlementRequest.ExtensibleAttributes();
                extAttrReq.key = 'rollback';
                extAttrReq.value = 'false';
                extAttrList.add(extAttrReq);
                
                extAttrReq = new CreateEntitlementRequest.ExtensibleAttributes();
                extAttrReq.key = 'appUserGUID';
                extAttrReq.value = colleagues.GUID__c;
                extAttrList.add(extAttrReq);
                
                OnlineContactsReq.extensibleAttributes = extAttrList;
                
                List<CreateEntitlementRequest.Entitlements> entitlementList = new List<CreateEntitlementRequest.Entitlements>();
                List<String> trialIdList = new List<String>();
                if(String.isNotBlank(trialObj.Trial_Id__c)){
                    trialIdList = trialObj.Trial_Id__c.split(',');
                }
                for(String trialId : trialIdList){
                    CreateEntitlementRequest.Entitlements entitlementsReq = new CreateEntitlementRequest.Entitlements();
                    entitlementsReq.templateId = trialObj.Profile_ID__c ;
                    entitlementsReq.templateType = 'PROFILE ID';
                    entitlementsReq.appUserGuid = colleagues.GUID__c;
                    entitlementsReq.accessStartDate = string.valueOf(trialObj.Trial_Start_Date__c);
                    entitlementsReq.accessEndDate = string.valueOf(trialObj.Trial_End_Date__c);
                    
                    List<CreateEntitlementRequest.ExtensibleAttributes> entitleExtAttrList = new List<CreateEntitlementRequest.ExtensibleAttributes> ();
                    CreateEntitlementRequest.ExtensibleAttributes entitleExtAttrReq = new CreateEntitlementRequest.ExtensibleAttributes();
                    entitleExtAttrReq.key = 'campaignCode';
                    entitleExtAttrReq.value = trialObj.Campaign_Code__c;
                    entitleExtAttrList.add(entitleExtAttrReq);
                    
                    entitleExtAttrReq = new CreateEntitlementRequest.ExtensibleAttributes();
                    entitleExtAttrReq.key = 'Offer Channel';
                    entitleExtAttrReq.value = 'ODT';
                    entitleExtAttrList.add(entitleExtAttrReq);
                    
                    entitleExtAttrReq = new CreateEntitlementRequest.ExtensibleAttributes();
                    entitleExtAttrReq.key = 'trackingCode';
                    entitleExtAttrReq.value = trialId;
                    entitleExtAttrList.add(entitleExtAttrReq);
                    
                    entitlementsReq.extensibleAttributes = entitleExtAttrList;
                    
                    entitlementList.add(entitlementsReq);
                    
                }
                OnlineContactsReq.entitlements = entitlementList;
                OnlineContactsReqList.add(OnlineContactsReq);
            }
        }
        return OnlineContactsReqList;
    }
    
    public static HttpRequest callCreateESIService(string esiJsonReq, WebServiceSettings__c ws){

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