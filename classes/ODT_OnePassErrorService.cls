/*============================================================================================
    Name                : ODT_OnePassErrorService
    Description         : This class is developed as part of CXD-ODT project and it is used to send post back to Eloqua for Entitlement Errors
    Created Date        : 4/21/2019
    Author              : TCS CXD ODT team
  
  Enhancements:
      Date          Name                Jira        Description        
		1)  10-03-2021    Ameeta Antonio	 DLT-21506   Update Post to Eloqua for entitlement error 
        ==============================================================================================*/
public without Sharing class ODT_OnePassErrorService {
    public static boolean checkError(trial__c t  , Invite_Colleagues__c ic , String reqObj)
    {
        Boolean iscreated = false;
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ODTCreateEntitlementService');
        ODT_OnePassErrorRequest request;
        if(reqObj=='Trial'&& t!=null){
             request = getOnePassEntRequest(String.valueOf(t.id),t.Contact_id_SAP__c,t.Primary_User_First_Name__c,t.Primary_User_Last_Name__c,t.ODT_Email__c,t.ODT_SAP_Account_Number__c,t.User_Auth_ID__c,t.One_Pass_Identifier__c);
        }
        else if(reqObj=='IC'&& ic!=null){
               request = getOnePassEntRequest(String.valueOf(ic.id),ic.SapContactId__c ,ic.First_Name__c ,ic.Last_Name__c ,ic.Email__c,ic.Trial__r.ODT_SAP_Account_Number__c,ic.User_Auth_ID__c,ic.One_Pass_Identifier__c);
        }
        if(request!=null){
            String esiCreateEntRequest = JSON.serialize(request);
            HttpRequest req = new HttpRequest();
            req = callCreateESIService( esiCreateEntRequest, oWebServiceSettings);
            HTTPResponse response ;
            Http http = new Http();
            system.debug('esiCreateEntRequest--->' + esiCreateEntRequest);
            if(!test.isrunningtest()){
                response = http.send(req);
            }else{
                        String responseJSON = '{"ESIHeader": {"applicationId": "CXODT","transactionId": "f994e430-81cf-4891-ab09-3e84a77a1b6a"}, "Notification": { "statusCode": "200","statusDescription": "SUCCESS","statusDetailMessage": "Registration Key Added Successfully"}}';
                        response = new HttpResponse();
                        response.setHeader('Content-Type', 'application/json');
                        response.setBody(responseJSON);
                        response.setStatusCode(200);
            }
            system.debug('Response--->' + response.getBody());
            system.debug('response.getStatusCode()--->' + response.getStatusCode());
            if(response.getStatusCode()== 200){
                ODT_OnePassErrorResponse ESIresponse = (ODT_OnePassErrorResponse)JSON.deserialize(response.getBody(), ODT_OnePassErrorResponse.class);
                system.debug('ESIresponse--->' + ESIresponse);  
                if(ESIresponse != null && ESIresponse.Notification!=null && ESIresponse.Notification.statusCode!=null && ESIresponse.Notification.statusCode.equalsIgnoreCase('200'))
                {
                    iscreated = true;
                    if(reqObj == 'Trial'){
                        t.Trial_Status__c='Accepted';
                        database.update(t,false);
                        system.debug('Limitation   '+Limits.getQueueableJobs());
                        system.debug('Limitation22  '+Limits.getLimitQueueableJobs());

                        string statusString = 'Entitled';
                        if(t.Profile_Type__c == 'EXISTING_USER_NEW_DOMAIN' || t.Profile_Type__c == 'EXISTING_USER_SAME_DOMAIN')
                            statusString = 'ActiveEntitled';
                        else
                            statusString = 'Entitled';
                        
                        EloquaEmailCallouts updJob1 = new EloquaEmailCallouts(t.Primary_User_First_Name__c, t.Primary_User_Last_Name__c, t.ODT_Email__c, t.ODT_SAP_Account_Number__c, t.Contact_id_SAP__c, t.Contact_LeadId__c, null, t.GUID__c, t.Trial_Id__c, t.Contact_id_SAP__c, t.Contact_LeadId__c, t.Id , t.Contact_LeadId__r.Company, Label.ODT_Rep_Initiated_URL,'accepted', t.Trial_Source__c, t.Trial_End_Date__c, null, null, t.Is_Lapsed__c, false, true, t.Trial_Start_Date__c, statusString); 
                        ID jobID1 = System.enqueueJob(updJob1);
                    }
                    else if(reqObj == 'IC'){
                        ic.Trial_Status__c='Accepted';
                        database.update(ic,false);
                        
                        
                        string statusString = 'InviteeEntitled';
                        
                        EloquaEmailCallouts updJob5 = new EloquaEmailCallouts(ic.First_Name__c, ic.Last_Name__c, ic.Email__c, ic.Trial__r.ODT_SAP_Account_Number__c, ic.SapContactId__c, ic.Trial__r.Contact_LeadId__c, null, ic.GUID__c, ic.Trial__r.Trial_Id__c, ic.SapContactId__c, ic.Trial__r.Contact_LeadId__c, ic.Trial__r.Id , ic.Trial__r.Contact_LeadId__r.Company, Label.ODT_Rep_Initiated_URL,'accepted', ic.Trial__r.Trial_Source__c, ic.Trial__r.Trial_End_Date__c, null, null, ic.Trial__r.Is_Lapsed__c, false, true, ic.Trial__r.Trial_Start_Date__c, statusString); 
                        ID jobID5 = System.enqueueJob(updJob5);
                    }
                    
                }
                else{
                    if(reqObj == 'Trial'){
                        t.Service_Count__c=t.Service_Count__c+1;
                        database.update(t,false);
                        
                        
                    }
                    else if(reqObj == 'IC'){
                        ic.Service_Count__c=ic.Service_Count__c+1;
                        database.update(ic,false);
                    }

                }
                
                system.debug('iscreated--->' + iscreated);
            }
        }
      
        return iscreated;   
    }       
    public static ODT_OnePassErrorRequest getOnePassEntRequest(String transactionID , String contactNumber ,String firstName, String lastName , String emailAddress, String AccountNumber , String authID , String onePassIdentifier)
    {
         try{
             ODT_OnePassErrorRequest createEntRequest = new ODT_OnePassErrorRequest();
             createEntRequest.actionCode = 'ADD_REG_KEYS'; 
                
                //Create ESI Header request
                ODT_OnePassErrorRequest.ESIHeader ESIHeaderReq = new ODT_OnePassErrorRequest.ESIHeader();
                ESIHeaderReq.applicationId = 'CXODT';
                ESIHeaderReq.companyId = 'West';
                ESIHeaderReq.transactionId = transactionID+String.valueOf(system.now());
                createEntRequest.ESIHeader = ESIHeaderReq;
                
                //Create Online Contact
                List<ODT_OnePassErrorRequest.OnlineContact> onlineContactList = new List<ODT_OnePassErrorRequest.OnlineContact>();
                ODT_OnePassErrorRequest.OnlineContact OnlineContactsReq = new ODT_OnePassErrorRequest.OnlineContact();
                OnlineContactsReq.contactNumber = contactNumber;
                OnlineContactsReq.onePassIdentifier=onePassIdentifier;
                ODT_OnePassErrorRequest.Address addressReq = new ODT_OnePassErrorRequest.Address();
                addressReq.firstName = firstName;
                addressReq.lastName = lastName;
                addressReq.emailAddress = emailAddress;
             
                OnlineContactsReq.address = addressReq;
                
                ODT_OnePassErrorRequest.Account accountReq = new ODT_OnePassErrorRequest.Account();
                accountReq.accountNumber = accountNumber;
                OnlineContactsReq.account = accountReq;
                
               List<ODT_OnePassErrorRequest.Entitlements> entitlementList = new List<ODT_OnePassErrorRequest.Entitlements>();
 
               ODT_OnePassErrorRequest.Entitlements entitlementsReq = new ODT_OnePassErrorRequest.Entitlements();
               entitlementsReq.applicationId = 'COBALT' ;
               entitlementsReq.authId = authID;                  
               entitlementList.add(entitlementsReq);
            
               OnlineContactsReq.entitlements = entitlementList;
               onlineContactList.add(OnlineContactsReq);
                
            createEntRequest.onlineContact = onlineContactList ;
               //CreateEntitlementRequest.OnlineContact = new CreateEntitlementRequest.OnlineContact();
               return createEntRequest;
         }catch(Exception ex){
            system.debug('Exception--->' + ex);
            throw ex;
        }
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