/**
 * @Description: :
 * ****************************************************************************************
 * This class provides common methods for SN callouts to external systems.
 * ****************************************************************************************
 * @History     : 
 * * ---Name --------------Date-------------
 * Mousumi Panda       ->    14-May-2020 
 * 
 */

public without sharing class ESC_ServiceNowStagingHelper implements Database.Stateful{
  
    /**
     * @Description Generic method that converts the Sobject passed to match the parameters of the processCallout method whic
     * is used for ServiceNow Callout.
     *
     * @Parameter:  List<ESC_ServiceNow_Staging__c> SNOWStagingList - Staging object List to send to ServiceNow
     * 
     * @Return:    List<ESC_ServiceNow_Staging__c> - The data obtained as response to be updated in SFDC ESC_ServiceNow_Staging__c object
     */
     
     public static List<ESC_ServiceNow_Staging__c> SNOWCallout(List<ESC_ServiceNow_Staging__c> SNOWStagingList) {
        List<ESC_ServiceNow_Staging__c> InsertList= new List<ESC_ServiceNow_Staging__c>();
        List<ESC_ServiceNow_Staging__c> UpdateList= new List<ESC_ServiceNow_Staging__c>();
        List<ESC_ServiceNow_Staging__c> SNUpdatedList = new List<ESC_ServiceNow_Staging__c>();
        
        for(ESC_ServiceNow_Staging__c sn:SNOWStagingList){
           system.debug('sn.ESC_log__c****'+sn.ESC_log__c);
            if(sn.ESC_RequestType__c=='Create'){
             if(sn.ESC_log__c == null || sn.ESC_log__c == ''){
                InsertList.add(sn);
              }Else if(sn.ESC_log__c != null && !sn.ESC_log__c.startswith('400')){
                InsertList.add(sn);
              }
            }
            else if(sn.ESC_RequestType__c=='Update'){
                if(sn.ESC_log__c == null || sn.ESC_log__c == ''){
                  UpdateList.add(sn);
              }Else if(sn.ESC_log__c != null && !sn.ESC_log__c.startswith('400')){
                  UpdateList.add(sn);
              }
                
            }
        }
        if(InsertList.size()>0){
            List<ESC_ServiceNow_Staging__c> createStagingList= sendSN(InsertList);
             SNUpdatedList.addAll(createStagingList);
        }
        if(UpdateList.size()>0){
          List<ESC_ServiceNow_Staging__c> updateStagingList= sendSN(UpdateList);
          SNUpdatedList.addAll(updateStagingList);
          
        }
        
        return SNUpdatedList;
     }
    
     public static List<ESC_ServiceNow_Staging__c> sendSN(List<ESC_ServiceNow_Staging__c> SNOWStagingList) {
        String IntegrationSetting = 'SNOW';
        List<ESC_ServiceNow_Staging__c> SNowUpdateList = new List<ESC_ServiceNow_Staging__c>();
        ESC_ServiceNow_Scheduler_Settings__c SNSettings = ESC_ServiceNow_Scheduler_Settings__c.getInstance('ServiceNowSettings');
        Integer NoOfRetries = Integer.valueOf(SNSettings.ESC_No_Of_Retries__c);
       
        system.debug('SNOWStagingList***'+SNOWStagingList);
       
        for(ESC_ServiceNow_Staging__c Staging:SNOWStagingList){
            ESC_ServiceNowStagingWrapper.ServiceNowStagingRequest SnowRequest = new ESC_ServiceNowStagingWrapper.ServiceNowStagingRequest();
            try{
            
            SnowRequest.businessArea = Staging.ESC_BusinessArea__c;//required
            SnowRequest.source = Staging.ESC_Source__c;//required
            SnowRequest.assignmentGroup = Staging.ESC_AssignmentGroup__c;//required
            SnowRequest.description =Staging.ESC_Description__c; //required
            SnowRequest.requestType = Staging.ESC_RequestType__c;//required
            SnowRequest.sourceLink = Staging.ESC_SourceLink__c;//required
            //SnowRequest.customerNumber =Staging.ESC_CustomerNumber__c; //not required
            SnowRequest.SLA = Staging.ESC_SLA__c;//required
            //SnowRequest.SLAJustification = Staging.ESC_SLAJustification__c;//Not required
            SnowRequest.caseNumber = Staging.ESC_CaseNumber__c;
            //SnowRequest.auditResult = Staging.ESC_AuditResult__c;// not required
            //SnowRequest.quoteNumber = staging.ESC_QuoteNumber__c;// not required
            SnowRequest.referenceNumber = staging.ESC_Case_Id__c; //required & 18 digit casenumber
            SnowRequest.externalStatus = staging.ESC_Case_Status__c;   //required at the Update time
            SnowRequest.requestedBy = staging.ESC_Employee_Number__c;  //required * Xid
            SnowRequest.serviceRequest = staging.ESC_SNOW_ID__c;    //required at the Update Time
            SnowRequest.taskNumber = staging.ESC_External_Task_Reference_Number__c;
            SnowRequest.additionalComments = staging.ESC_Feed_Comment__c;    //required at the Update Time
            SnowRequest.requestType = Staging.ESC_RequestType__c;//required
           
            ESC_ServiceNowStagingWrapper.cls_BOOMIHeader boomidetails = new ESC_ServiceNowStagingWrapper.cls_BOOMIHeader();
            boomidetails.applicationId='ESCU';
            boomidetails.timeStamp=String.Valueof(System.now());
            SnowRequest.BOOMIHeader = boomidetails;
            SnowRequest.extensibleAttributes = new List<ESC_ServiceNowStagingWrapper.cls_extensibleAttributes>();
           }
            catch(Exception e){
            }
            
            // Build a list of CommonCalloutTypes. and serialize to JSON
            String calloutRequestBodyJSON = JSON.serialize(SnowRequest);
            
            // Pass the JSON request body and Integration setting to CommonCalloutHandler
            system.debug('calloutRequestBodyJSON***'+calloutRequestBodyJSON);
            HTTPResponse response = processCallout(IntegrationSetting,calloutRequestBodyJSON,Staging.ESC_RequestType__c); 
            String strRes = response.getBody();
            system.debug('strRes******'+strRes);
              ESC_ServiceNowStagingWrapper res = ESC_ServiceNowStagingWrapper.parse(strRes);
             system.debug('res******'+res);
            if (res.ServiceRequestResponse.statusCode != '200') {
                System.debug(LoggingLevel.INFO, 'ServiceNow Callout Failed with Error: ' + res.ServiceRequestResponse.statusMessage);
                staging.ESC_Transmit_Status__c = 'Failed';
                staging.ESC_Staging_Status__c='Error';
                staging.ESC_log__c = res.ServiceRequestResponse.statusCode + ' & Message: '+ res.ServiceRequestResponse.statusMessage;
                if(staging.ESC_No_Of_Retries__c == null || staging.ESC_No_Of_Retries__c == 0){
                    staging.ESC_No_Of_Retries__c=1;
                }else{
                staging.ESC_No_Of_Retries__c++;
                }
                
                if(staging.ESC_No_Of_Retries__c>NoOfRetries)
                ESC_ServiceNowStagingBatch.DataErrorRecords.add(staging.Id);
                SNowUpdateList.add(staging);
                
            } else {
                staging.ESC_Transmit_Status__c = 'Success';
                staging.ESC_Staging_Status__c='Sent';
                staging.ESC_log__c = res.ServiceRequestResponse.statusCode + ' & Message: '+res.ServiceRequestResponse.statusMessage;
                staging.ESC_Time_Stamp_Sent__c= system.now();
                if(staging.ESC_SNOW_ID__c == null || staging.ESC_SNOW_ID__c == ''){
                staging.ESC_SNOW_ID__c=res.ServiceRequestResponse.serviceRequest;
                }
                if(staging.ESC_External_Task_Reference_Number__c == null || staging.ESC_External_Task_Reference_Number__c == ''){
                staging.ESC_External_Task_Reference_Number__c=res.ServiceRequestResponse.taskNumber;
                }
                 SNowUpdateList.add(staging);
            }
            
        }
     
        return SNowUpdateList;   
        
        }
  
  //-------------------------------------------------------------------------------------------------------------------
  
    /**
     * @Description Generic method that constructs a HTTP request to a RESTful service
     * and handles mapping the response result / body to ESC_ServiceNowStagingWrapper.ServiceRequestResponse.
     * Calling methods are responsible for building the JSON request body and handling the
     * JSON response body.
     *
     * Any HTTP callout errors should not be thrown via Exception, instead are caught, and
     * returned in ESC_ServiceNowStagingWrapper.ServiceRequestResponse with isSuccess = FALSE and the
     * corresponding error message.
     *
     * @Parameter:  String integrationSettingName - Integration Setting Name in ESC_Integration_Setting__c
     * @Parameter:  Map<String, String> mapQueryStringParameterToValue (can be passed as null)
     * @Parameter:  String calloutRequestBodyJSON - serialized JSON request body (can be passed as null)
     *
     * @Return:     ESC_ServiceNowStagingWrapper.ServiceRequestResponse - The Http Callout httpCalloutResponse with the status
     *              and httpCalloutResponse Body JSON
     */
    public static  HTTPResponse processCallout(String integrationSettingName,String ServiceNowRequestBodyJSON,String requestType) {
         Http http = new Http();
         HttpRequest httpCalloutRequest = new HttpRequest();
         HTTPResponse httpCalloutResponse = new HTTPResponse();
         
            
       ESC_Integration_Setting__c integrationSetting = ESC_Integration_Setting__c.getInstance(integrationSettingName);

        // If ESC_Integration_Setting__c isn't present, throw an error
        if(integrationSetting == null) {
            ESC_HandlerCustomException integrationSettingException = new ESC_HandlerCustomException();
            integrationSettingException.setMessage('Integration setting: ' + integrationSettingName + ' not found!');
            throw integrationSettingException;
        }

        String endpointServer = integrationSetting.ESC_Endpoint_Server__c.removeEnd('/'); 
        String endpointURI;
        if(requestType == 'Create'){
          endpointURI = integrationSetting.ESC_Endpoint_URI__c.removeStart('/').removeEnd('/'); 
        }else if(requestType == 'Update'){
          endpointURI = integrationSetting.ESC_Endpoint_Update_URI__c.removeStart('/').removeEnd('/'); 
        }
        String endpoint = endpointServer + '/' + endpointURI;
       
        httpCalloutRequest.setMethod(integrationSetting.ESC_HTTP_Method__c); 
        httpCalloutRequest.setEndpoint(endpoint);
        httpCalloutRequest.setTimeout(integrationSetting.ESC_Timeout__c.intValue()); 
        //httpCalloutRequest.setHeader(headerKey, mapHeaders.get(headerKey));
        String accessToken = ' ';
            if(!Test.isRunningTest()){
                accessToken = DellBoomiTokenGenerationApigee.getAuthToken();
        }
        httpCalloutRequest.setHeader('Authorization','Bearer '+accessToken);                
        httpCalloutRequest.setHeader('Content-Type', 'application/json');
        //httpCalloutRequest.setHeader('grant_type', grantType);
        

        if(String.isNotBlank(ServiceNowRequestBodyJSON)) {
            httpCalloutRequest.setBody(ServiceNowRequestBodyJSON);
        }

        if(integrationSetting.ESC_Enable_Logging__c) {
            System.debug(LoggingLevel.INFO, 'Request Endpoint: ' + httpCalloutRequest.getEndpoint());
            System.debug(LoggingLevel.INFO, 'Request Body: ' + httpCalloutRequest.getBody());
        }
        try {
           
              httpCalloutResponse = http.send(httpCalloutRequest);
              String strRes = httpCalloutResponse.getBody();
              ESC_ServiceNowStagingWrapper res = ESC_ServiceNowStagingWrapper.parse(strRes);
              if(integrationSetting.ESC_Enable_Logging__c) {
                System.debug(LoggingLevel.INFO, 'httpCalloutResponse Status Code: ' + httpCalloutResponse.getStatusCode());
                System.debug(LoggingLevel.INFO, 'httpCalloutResponse Body: ' + httpCalloutResponse.getBody());
               }

             
              if(res.ServiceRequestResponse.statusCode != '200'){
              ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
               commonCalloutException.setMessage('A callout exception occurred with a status of: ' + res.ServiceRequestResponse.statusCode + ' & Message: '+res.ServiceRequestResponse.statusMessage);
               throw commonCalloutException;
              
              }

            
            
            
          } 
      catch (Exception e){
           //httpCalloutResponse.statusMessage = 'Exception Message: ' + e.getMessage() + ' Exception Stack Trace: ' + e.getStackTraceString();
      }
        system.debug('httpCalloutResponse***'+httpCalloutResponse);
        return httpCalloutResponse;
        
    }   
   /*-------------------------------------------------------------------------------*/
   // Called From FeedITem and FeedCommnet Trigger
    public static boolean isSNfeedContext = false;
    public static void updateSNstagingFeedUpdate(List<SObject> NewFeed){
    List<ESC_ServiceNow_Staging__c> SNowUpdateList = new List<ESC_ServiceNow_Staging__c>();
    Map<Id,List<String>> caseIdMap = new Map<Id,List<String>>();        
        ESC_SN_AssignmentGroup__c snsettings = ESC_SN_AssignmentGroup__c.getInstance();
        try{
            Map<Id,Group> OwnerMap = new Map<Id,Group>([Select id,Name from Group where Type='Queue' and Name in :snsettings.ESC_SN_Chatter_Group__c.split(',')]);
            List<String> qnames = snsettings.ESC_SN_Chatter_Group__c.split(',');
            if(qnames.size()>0 && isSNfeedContext == false){
            caseIdMap = ESC_VSTSstagingUpdate.removetheSpecialCharactor(NewFeed,qnames);
            }           
            
           if(caseIdMap.size()>0){
               
                List<ESC_Case_Collaborator__c> RefList=[Select ESC_Case__c,ESC_CaseNumber__c,ESC_Case__r.Description,ESC_Case__r.ESC_SLA__c,ESC_Case__r.ESC_SLA_Justification__c,ESC_Case__r.BU_Segment__c,ESC_Case__r.LCRM_Sub_BU__c,ESC_Case__r.ESC_Severity__c,ESC_Case__r.ESC_External_Task_Reference_Number__c,ESC_Case__r.ESC_External_Ticket_Number__c,ESC_Case__r.Status,ESC_Case__r.IsClosed from ESC_Case_Collaborator__c where ESC_Case__c In:caseIdMap.KeySet() and ESC_Referral_Status__c!='Closed' and ESC_Referral_Status__c!='Completed' and OwnerId IN :OwnerMap.Keyset()];
                for(ESC_Case_Collaborator__c Ref:RefList){
        

                   if(Ref.ESC_Case__r.ESC_External_Ticket_Number__c!=null  && Ref.ESC_Case__r.ESC_External_Task_Reference_Number__c!=null){
                            ESC_ServiceNow_Staging__c Staging = new ESC_ServiceNow_Staging__c();
                            Staging.ESC_Staging_Status__c ='Pending';
                            Staging.ESC_RequestType__c = 'Update';
                            staging.ESC_External_Task_Reference_Number__c = Ref.ESC_Case__r.ESC_External_Task_Reference_Number__c;
                            staging.ESC_SNOW_ID__c = Ref.ESC_Case__r.ESC_External_Ticket_Number__c;
                            staging.ESC_Feed_Comment__c = caseIdMap.get(Ref.ESC_Case__c)[0]; 
                            Staging.ESC_CaseNumber__c = Ref.ESC_CaseNumber__c;
                            staging.ESC_Case_Id__c = Ref.ESC_Case__c; //(18 digits case id)
                            if(Ref.ESC_Case__r.IsClosed==true){
                            staging.ESC_Case_Status__c = 'Closed';
                            }else{
                            staging.ESC_Case_Status__c = 'Open';
                            }
                            SNowUpdateList.add(staging);
                    }
                    
                }
                insert SNowUpdateList;
               isSNfeedContext = true;
           }    

        }
       catch(Exception e){
       }           
  
}

}