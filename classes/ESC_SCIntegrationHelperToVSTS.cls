public without sharing class ESC_SCIntegrationHelperToVSTS implements Database.Stateful{
    
    public static List<ESC_VSTS_Staging__c> VSTSCallout(List<ESC_VSTS_Staging__c> VSTSStagingList) {
        //String IntegrationSetting = 'VSTS';
        List<Id> InsertList= new List<Id>();
        List<Id> UpdateList= new List<Id>();
        List<Id> ReopenList= new List<Id>();
        List<ESC_VSTS_Staging__c> VSTSUpdateList = new List<ESC_VSTS_Staging__c>();
        //ESC_ServiceNow_Scheduler_Settings__c SNSettings = ESC_ServiceNow_Scheduler_Settings__c.getInstance('VSTS Scheduler Settings');
        
        for(ESC_VSTS_Staging__c vst:VSTSStagingList){
            if(vst.ESC_RequestType__c=='create'){
                InsertList.add(vst.id);
               
            }
            else if(vst.ESC_RequestType__c=='addDiscussion'){
                UpdateList.add(vst.id);
            }
            else if(vst.ESC_RequestType__c=='reopen'){
                ReopenList.add(vst.id);
            }
            
        }
        if(InsertList.size()>0){
            List<ESC_VSTS_Staging__c> createStagingList= VSTSTicketCreate(InsertList,'CreateVSTS');
             VSTSUpdateList.addAll(createStagingList);
        }
        if(UpdateList.size()>0){
          List<ESC_VSTS_Staging__c> updateStagingList= VSTSTicketCreate(UpdateList,'UpdateVSTS');
          VSTSUpdateList.addAll(updateStagingList);
          
        }
        if(ReopenList.size()>0){
           List<ESC_VSTS_Staging__c> reopenStagingList= VSTSTicketCreate(ReopenList,'ReopenVSTS');
           VSTSUpdateList.addAll(reopenStagingList);
        }
        return VSTSUpdateList;
    }
    
    public static List<ESC_VSTS_Staging__c> VSTSTicketCreate(List<Id> VSTSStagingIdList,String ServiceName){
        List<String> failedStaging= new List<String>();
        List<ESC_VSTS_Staging__c> newStagingList = new List<ESC_VSTS_Staging__c>();
       // try{
            List<ESC_VSTS_Staging__c> StagingList= new List<ESC_VSTS_Staging__c>();
            
            StagingList= [select id,name,ESC_Value__c,ESC_Feed_Comment__c,ESC_Feed_Commented_by__c,ESC_Feed_Commented_Date__c,ESC_SAP_Account_Num__c,ESC_Account_Name__c,ESC_SAP_TenancyName__c,ESC_Case_Number__c,ESC_Case_Owner__c,ESC_Case_Product__c,ESC_Case_Product_Version__c,ESC_RequestType__c,ESC_Case_Subject__c,ESC_Case_Description__c,ESC_Case_Created_Date__c,ESC_Case_Severity__c,ESC_Case_Priority__c,ESC_Case_Diagnosis__c,ESC_Customer_Category__c,ESC_IsAllowRepDB__c,ESC_Is_Customer__c,ESC_Case_Product_Complement__c from ESC_VSTS_Staging__c where id IN :VSTSStagingIdList];
            System.debug('StagingList>>>' +StagingList);
            
            for(ESC_VSTS_Staging__c vs:StagingList){
                if(!failedStaging.contains(vs.ESC_Case_Number__c)){
                CsAccount ca= new CsAccount();
                ca.accountNumber=vs.ESC_SAP_Account_Num__c;
                ca.accountName=vs.ESC_Account_Name__c;
                ca.companyName=vs.ESC_SAP_TenancyName__c;
                ca.ownerName=vs.ESC_Case_Owner__c;
               

                csProduct cp= new csProduct();
                cp.productId=vs.ESC_Case_Product_Complement__c;
                cp.productVersion=vs.ESC_Case_Product_Version__c;
                
                
                csstatus csstus= new csstatus();
                csstus.trackingId=vs.ESC_Value__c;
                //csstus.statusDetailMessage='';
                
                
                CaseRequestDetail crd= new CaseRequestDetail();
                crd.actionCode=vs.ESC_RequestType__c;
                crd.id=vs.ESC_Case_Number__c;
                crd.title=vs.ESC_Case_Subject__c;
                crd.description=vs.ESC_Case_Description__c;
                crd.status=csstus;
                crd.userId=vs.ESC_Feed_Commented_by__c;
                if(vs.ESC_Case_Created_Date__c!= Null)
                crd.createdDate=String.valueof(vs.ESC_Case_Created_Date__c.format('yyyy-MM-dd HH:mm:ss.SSS\'Z\'', 'GMT')).replace(' ','T'); 
                system.debug('Created Date GMT>>>' + crd.createdDate);
                crd.severity=vs.ESC_Case_Severity__c;
                crd.priority=vs.ESC_Case_Priority__c;
                crd.queryDescription=vs.ESC_Feed_Comment__c;
                crd.account=ca;
                if(vs.ESC_Feed_Commented_Date__c!= Null)
                crd.updatedDate=String.valueof(vs.ESC_Feed_Commented_Date__c.format('yyyy-MM-dd HH:mm:ss.SSS\'Z\'', 'GMT')).replace(' ','T'); 
                //crd.updatedDate=String.valueof(vs.ESC_Feed_Commented_Date__c).replace(' ','T');
                crd.product=cp;
                
                
                StagingReqWrapper ReqWrapper= new StagingReqWrapper();
                EsiHeader eh= new EsiHeader();
                eh.applicationId='S2E';
                ReqWrapper.esiHeader=eh;
                ReqWrapper.projectID=vs.ESC_Case_Product__c;
                ReqWrapper.ticketType=vs.ESC_Case_Diagnosis__c;
                ReqWrapper.customerCategory=vs.ESC_Customer_Category__c;
                ReqWrapper.isAllowRepDB=vs.ESC_IsAllowRepDB__c;
                ReqWrapper.isCustomer=vs.ESC_Is_Customer__c;
                ReqWrapper.caseRequestDetail=crd;

                String ReqJson= JSON.Serialize(ReqWrapper);
                system.debug(ReqJson);
                ESC_VSTS_Integration_Setting__c integrationdetails = ESC_VSTS_Integration_Setting__c.getInstance(ServiceName);
                system.debug(integrationdetails);
                HTTPRequest hReq= new HTTPRequest();
                hReq.setEndpoint(integrationdetails.ESC_Endpoint_Server__c+integrationdetails.ESC_Endpoint_URI__c);
                hReq.setMethod('POST');
                Map<String, String> mapHeaders = new Map<String, String>();
                if(String.isNotBlank(integrationdetails.ESC_HTTP_Headers__c)) {
                    for(String headers : integrationdetails.ESC_HTTP_Headers__c.split(';')) {
                        List<String> listHeaderMember = headers.split('=>');
                        if(listHeaderMember != null && listHeaderMember.size() == 2) {
                            mapHeaders.put(listHeaderMember[0].trim(), listHeaderMember[1].trim());
                        }
                    }
                } 
                else {
                    mapHeaders.put('Accept', 'application/json');
                }

                for(String headerKey : mapHeaders.keySet()) {
                    hReq.setHeader(headerKey, mapHeaders.get(headerKey));
                }
                hReq.setTimeout((Integer)integrationdetails.ESC_Timeout__c*1000);
            
                if(String.IsNotBlank(ReqJson)){
                    hReq.setBody(ReqJson);
                }
                system.debug(hReq);
                Http ht= new HTTP();
                 // If ESC_Integration_Setting__c has logging enabled, output the endpoint and request body, if applicable
                    if(integrationdetails.ESC_Enable_Logging__c) {
                        System.debug(LoggingLevel.INFO, 'Request Endpoint: ' + hReq.getEndpoint());
                        System.debug(LoggingLevel.INFO, 'Request Body: ' + hReq.getBody());
                    }
                    
               //Response from VSTS 
                HttpResponse hres = new HttpResponse();
                StagingResponseWrapper ResponseWrapper= new StagingResponseWrapper(); 
                    
                   
                if(!Test.isRunningTest()){    
                hres= ht.send(hReq);}
                
                
                 // If ESC_Integration_Setting__c has logging enabled, output the status code response body
                    if(integrationdetails.ESC_Enable_Logging__c) {
                        System.debug(LoggingLevel.INFO, 'Response Status Code: ' + hres.getStatusCode());
                        System.debug(LoggingLevel.INFO, 'Response Body: ' + hres.getBody());
                    }
                if(hres.getStatusCode()==200){
                    String JSONresponse= hres.getbody();
                    system.debug('JSONresponse>>>' +JSONresponse);
                    ResponseWrapper= (StagingResponseWrapper)JSON.deserialize(JSONresponse, StagingResponseWrapper.class);
                    if(ResponseWrapper.caseResponseDetail.status.statusCode=='200'){
                        vs.ESC_Staging_Status__c='Success';
                        vs.ESC_Error_Log__c='';
                        vs.ESC_Time_Stamp_Sent__c= system.now();
                        vs.ESC_VSTS_Id__c=ResponseWrapper.caseResponseDetail.id;
                        newStagingList.add(vs);
                    }
                    
                    else{
                        vs.ESC_Staging_Status__c='Error';
                        vs.ESC_Error_Log__c=ResponseWrapper.caseResponseDetail.status.statusCode+ResponseWrapper.caseResponseDetail.status.statusDescription;
                        ESC_VSTS_StagingBatch.DataErrorRecords.add(vs.Id);
                        failedStaging.add(vs.ESC_Case_Number__c);
                        newStagingList.add(vs);
                    }
                }
                
                else{
                    vs.ESC_Staging_Status__c='Error';
                    //vs.ESC_Error_Log__c=ResponseWrapper.status.statusDescription;
                    vs.ESC_Error_Log__c= hres.getStatus()+hres.getStatusCode()+hres.getBody();
                    ESC_VSTS_StagingBatch.DataErrorRecords.add(vs.Id);
                    failedStaging.add(vs.ESC_Case_Number__c);
                    newStagingList.add(vs);
                }
                }

            }
          
            return newStagingList;
         /*if(newStagingList.size()>0){
                update newStagingList;
            }
        }
        catch(Exception e){
             if(newStagingList.size()>0){
                update newStagingList;
            }
            system.debug(e);
        }*/

    }
    

    public class StagingReqWrapper{
        public EsiHeader esiHeader;
        public String projectID;
        public String ticketType;
        public String customerCategory;
        public Boolean isAllowRepDB;
        public Boolean isCustomer;
        public CaseRequestDetail caseRequestDetail;
    }
   
    public class CaseRequestDetail {
        public String actionCode;
        public String id;
        public String title;
        public String description;
        public csstatus status;
        public String userId;
        public String createdDate;
        public String severity;
        public String priority;
        public String queryDescription;
        //public List<ExtensibleAttributes> extensibleAttributes;
        public CsAccount account;
        public String updatedDate;
        public csProduct product;
        
    }
    public class csstatus {
        public String trackingId;
        //public String statusDetailMessage;
    }
     public class csProduct {
        public String productId;
        public String productVersion;
    }
     
     public class CsAccount {
        public String accountNumber;
        public String accountName;
        public String companyName;
        public String ownerName;
    }
    /*public class ExtensibleAttributes {
        public String systemIdentifier;
        public String key;
        public String value;
    }*/

    public class EsiHeader {
        public String applicationId;
        //public List<ExtensibleAttributes> extensibleAttributes;
    }
    public class StagingResponseWrapper{
        public CaseResponseDetail caseResponseDetail;
        
    }
    public class Status {
        public String statusCode;
        public String statusDescription;
        public String trackingId;
    }
    public class CaseResponseDetail {
        public String id;
        public Status status;
    }

}