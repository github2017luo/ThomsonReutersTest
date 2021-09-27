/********************************************************************** 
Name: LTS_GetPaidNotesRestService
====================================================== 
Req:The purpose of this rest service class is to send the 'GetPaidNote' salesforce request to 'Dell boomi' and receive the response.
The Response is then displayed on LTS_getPaidNotes VF page
====================================================== 
The service is triggered from SSD level/get paid Button on 'GLI' layout

Method Type : POST
====================================================== 
History 
------- 
VERSION    AUTHOR             DATE             DETAIL            JIRA STory Number
1.0        Niket Kapasi    08/04/2019  Initial Development         DPS-4006
***********************************************************************/
Public without sharing class LTS_GetPaidNotesRestService{
    public String Endpoint {get;set;}  
    public String Authorization {get;set;}  
    public String ContentType {get;set;}  
    public String Accept {get;set;}  
    
    public String jsonString {get;set;}    
    public String jsonResponseString {get;set;}
    public ResponseWrapper responseWrapper;
    public string sSelectedOption{get;set;}
    public CustomDate__c Calldt{get;set;}
    public List<GetPaidNotesResponses> AllGetPaidNotes {get;set;}
    public List<GetPaidNotesResponses> GetPaidNotes {get;set;}
    public List<GetPaidNotesResponses> DisplayGetPaidNotesList {get;set;}
    
    public Source_System_Detail__c oSSD{get;set;}
    Private String tempObjIdString;// variable to store the keyPrefix of Account SSD object 
    Public static boolean ltsUser = false;//Boolean variable to check whether user is lotus user or not
    public String profileName{get;set;}//Variable to store the profile name based on user profile Id
    public string strUserSubBU{get;set;}//Variable to store loggedin user SubBu 
    
    List<ExtensibleAttributes> extensibleAttributesRequestList = new List<ExtensibleAttributes>();        
    GPRequestWrapper requestEsi = new GPRequestWrapper();        
    GetPaidNotes getPaidRequest = new GetPaidNotes();
    

    BoomiHeader reqBHGPNIns = new BoomiHeader();
    extensibleAttributes extensibleAttributesRequest = new extensibleAttributes(); 
    
    
    ResponseWrapper responseReceived = new ResponseWrapper();
    public String CollectorCode{get;set;}
    public String CollectorName{get;set;}
    public DateTime CreateDt{get;set;}
    public DateTime ModifyDt{get;set;}
    public String Note{get;set;}
    
    public Boolean errorFlag{get; set;}
    List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
    
    
    
    public LTS_GetPaidNotesRestService(ApexPages.StandardController controller){
        errorFlag = false;
        oSSD = new Source_System_Detail__c();
        String objid = controller.getRecord().id;                    
        String[] types = new String[]{'Source_System_Detail__c'};
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) {            
            tempObjIdString = res.getKeyPrefix();  
        }
        //Desc@@ : The below if loop handles the implementation of USL 'get Paid Notes Webservice.
        if( String.isNotBlank(objid) && String.isNotEmpty(objid) && objid.startswith(tempObjIdString)){
            System.debug('Inside Object');
            //GLI R4 Check
                id profileId = userinfo.getProfileId();
            if(Schema.sObjectType.Profile.isQueryable()){
                Profile pObj = [select Name from Profile where id = :profileId];
                profileName = pObj.Name;
            } 
                KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMSubBuValues');//Gets the SUBBU value from KeyValueListStore__c custom settings
                String tempSubBuValues = tempObj.TextValue__c;
                KeyValueListStore__c tempProfileObj = KeyValueListStore__c.getInstance('LCRMGLIProfileNames');//Gets the profile name value from KeyValueListStore__c custom settings
                String tempProfileValues = tempProfileObj.TextValue__c;
                                 
                strUserSubBU = LCRMGenericComponent.getUserBU();
            
            if((LCRMGenericcomponent.islotususer()) || (String.isnotBlank(profileName) && String.isNotEmpty(profileName) && String.isnotblank(strUserSubBU) && String.isnotempty(strUserSubBU))){
                System.debug('Inside Canada');
                oSSD = new Source_System_Detail__c();
                oSSD = (Source_System_Detail__c) controller.getRecord();
                
                if(oSSD != null && Schema.sObjectType.Source_System_Detail__c.isAccessible() && Schema.sObjectType.Source_System_Detail__c.isQueryable()){
                    oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c FROM Source_System_Detail__c where id = :oSSD.id]; 
                    System.debug(oSSD);
                }                
                sSelectedOption = 'All';   
                changeDisplayGetPaidNotesList();            
            }
            else{
                ApexPages.addMessages(new LTS_GetPaidNotesRestService.AppServiceException(''+Label.LTS_getPaidNotesAuthorizedUser));
            }            
        }
    }
    /*
Purpose : This method is used to display realtime data of getPaidnote service on vf data table. 
The date values are assigned in this method.

*/
    public void changeDisplayGetPaidNotesList(){
        try{
            if(sSelectedOption == 'All'){
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-24),End_date__c= system.today());
                AllGetPaidNotes = sendRequest(calldt); 
                DisplayGetPaidNotesList =  AllGetPaidNotes;
                System.debug('AllGetPaidNotes'+DisplayGetPaidNotesList);
            }
            if(sSelectedOption == '6 months back'){
                System.debug('@@@ sSelectedOption'+sSelectedOption);
                AllGetPaidNotes.clear();     
                DisplayGetPaidNotesList.clear(); 
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-6),End_date__c= system.today());               
                AllGetPaidNotes = sendRequest(calldt);
                System.debug('@@@ sSelectedOption'+sSelectedOption);                
                DisplayGetPaidNotesList =  AllGetPaidNotes;
            }
            if(sSelectedOption == '6 - 12 months back'){
                System.debug('@@@ sSelectedOption'+sSelectedOption);
                 AllGetPaidNotes.clear();     
                DisplayGetPaidNotesList.clear(); 
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-12),End_date__c= system.today().addMonths(-6));
                AllGetPaidNotes = sendRequest(calldt);
                
                DisplayGetPaidNotesList =  AllGetPaidNotes;
            }
            if(sSelectedOption == '12 - 18 months back'){
                System.debug('@@@ sSelectedOption'+sSelectedOption);
                 AllGetPaidNotes.clear();     
                DisplayGetPaidNotesList.clear(); 
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-18),End_date__c= system.today().addMonths(-12));
                AllGetPaidNotes = sendRequest(calldt);
                
                DisplayGetPaidNotesList =  AllGetPaidNotes;
            }
            if(sSelectedOption == '18 - 24 months back'){
                System.debug('@@@ sSelectedOption'+sSelectedOption);
                 AllGetPaidNotes.clear();     
                DisplayGetPaidNotesList.clear(); 
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-24),End_date__c= system.today().addMonths(-18));
                AllGetPaidNotes = sendRequest(calldt);                
                DisplayGetPaidNotesList =  AllGetPaidNotes;               
            }}
        
        catch (Exception oException){
            //ApexPages.addMessages(oException);
        }
        /*if(DisplayGetPaidNotesList == null && DisplayGetPaidNotesList.size() == 0 ){
            DisplayGetPaidNotesList= new List<GetPaidNotesResponses>() ; 
        }    */
    }
    /*
Purpose : this method is used to send the http request to Dell Boomi server.
Endpoint url and Baisc Auth values are stored in WebServiceSettings__c custom settings (name : LCRMGetPaidNoteRestService)
*/
    Public List<GetPaidNotesResponses>  sendRequest(CustomDate__c dateRequest){
        System.debug('@@@@@@@ :: '+oSSD);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:LotusGetPaidNoteRestService');
        request.setMethod('POST');
        Http http = new Http();
        HttpResponse response = new HttpResponse();      
        extensibleAttributesRequest.key = '';
        extensibleAttributesRequest.value = '';
        extensibleAttributesRequestList.add(extensibleAttributesRequest);
        
        reqBHGPNIns.applicationId = 'GLI';
        reqBHGPNIns.companyId= '';
        reqBHGPNIns.configGroup = '';
        reqBHGPNIns.instanceId = '';
        reqBHGPNIns.messageId = 'String';
        reqBHGPNIns.messageHistory = 'String';
        reqBHGPNIns.payloadVersion = '';
        reqBHGPNIns.postBackURL='';
        reqBHGPNIns.timeStamp = String.valueof(System.today());
        reqBHGPNIns.tracingId = '';
        reqBHGPNIns.transactionId = '';
        reqBHGPNIns.extensibleAttributes = extensibleAttributesRequestList;
        
        
        getPaidRequest.boomiHeader =reqBHGPNIns;
        
        SYSTEM.debug('oSSD'+oSSD);
        if(oSSD != null && oSSD.Source_System_Account_Number__c != null && String.isNotBlank(oSSD.Source_System_Account_Number__c)){
            System.debug('@@@@@@@@ ::::::: SSD :::::: @@@');
            getPaidRequest.acctSapId = oSSD.Source_System_Account_Number__c;
        }else{
            getPaidRequest.acctSapId = '1003846246222222';
        }
        
        IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oSSD.LCRM_Sales_org__c);
        if(oIXOSCodeMap != null){
            System.debug('oIXOSCodeMap@@@ '+oIXOSCodeMap);
            if(String.isnotblank(oIXOSCodeMap.Company_Code__c)){
                getPaidRequest.companyCode = oIXOSCodeMap.Company_Code__c;
            }else{  getPaidRequest.companyCode = '107833123';}
            if(String.isNotBlank(oIXOSCodeMap.Dist_Chan_Code__c)){
                getPaidRequest.distChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            }else{getPaidRequest.distChanCode = 'Test';}
            if(String.isNotBlank(oIXOSCodeMap.Division_Code__c)){
                getPaidRequest.divisionCode = oIXOSCodeMap.Division_Code__c;
            }else{getPaidRequest.divisionCode = 'Test';}
            if(String.isNotBlank(oIXOSCodeMap.Sales_Org_Code__c)){
                getPaidRequest.salesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            }else{getPaidRequest.salesOrgCode = 'TA78Test';   }
            if(dateRequest.Begin_date__c != null && dateRequest.End_date__c != null){
                if(dateRequest.Begin_date__c > dateRequest.End_date__c){                       
                    throw new AppUtil.AppException(Label.GetPaidNoteEx); 
                }
                getPaidRequest.ModifiedDtStart = String.valueof(dateRequest.Begin_date__c);
                getPaidRequest.ModifiedDtEnd = String.valueof(dateRequest.End_date__c);
            }else{getPaidRequest.ModifiedDtEnd='2018-02-23';
            getPaidRequest.modifiedDtStart = '2018-02-21'; }
        }
       /* 
        else{
            getPaidRequest.companyCode = '107833123';
            getPaidRequest.distChanCode = 'Test';
            getPaidRequest.divisionCode = 'Test';
            getPaidRequest.salesOrgCode = 'TA78Test';                
            getPaidRequest.ModifiedDtEnd='2018-02-23';
            getPaidRequest.modifiedDtStart = '2018-02-21';                
        }*/

        requestEsi.getPaidNotes = getPaidRequest; 
        jsonString = JSON.serialize(requestEsi); 
        SYSTEM.debug(jsonString+'<-- JSON STRING'+sSelectedOption); 
        request.setBody(jsonString);  
        SYSTEM.debug(request.getbody()+ '<--- REQUEST --->');            
        response = http.send(request);
        System.debug(response);            
        jsonResponseString=response.getBody();
        System.debug('response.getBody()@@' +response.getBody());
        if (response.getStatusCode() == 200) {
            if(String.isNotBlank(jsonResponseString)){
                
                responseWrapper = (ResponseWrapper)JSON.deserialize(jsonResponseString,ResponseWrapper.class);
            }
            if(responseWrapper.statusResponse != null){
                responseReceived.statusResponse = responseWrapper.statusResponse;
                System.debug('responseReceived.statusResponse@@@ '+responseReceived.statusResponse);
                if(responseWrapper.statusResponse.StatusDetails != null){
                    System.debug('@@@@@ '+responseWrapper.statusResponse.StatusDetails.statuscode);
                    System.debug('@@@@@ '+responseWrapper.statusResponse.StatusDetails.statusDetailMessage);
                    if(String.isNotBlank(responseWrapper.statusResponse.StatusDetails.statuscode) && responseWrapper.statusResponse.StatusDetails.statuscode == '200' ){
                        if(responseWrapper.getPaidNotesResponses.size() > 0){
                            responseReceived.getPaidNotesResponses = responseWrapper.getPaidNotesResponses;
                        }                          
                    }                    
                } 
                
            }                
            SYSTEM.debug('responseWrapper@@@@ '+responseWrapper);
        }
        else if(response.getStatusCode() != 200){
            System.debug('response.getStatusCode()'+response.getStatusCode());
            //ApexPages.addMessages(new LTS_GetPaidNotesRestService.AppServiceException('Status Code: '+response.getStatusCode()+' Message :'+response.getStatus()));
            Apexpages.addMessages(new LTS_GetPaidNotesRestService.AppServiceException(''+label.LTS_getPaidNotesServerError));
            LCRM_Exception_Log__c errorLog = new LCRM_Exception_Log__c();
            errorLog.LCRM_Exception_Message__c = request.getBody();
            errorLog.LCRM_Exception_Trace__c=response.getBody();
            errorLog.LCRM_Exception_Type__c=response.getStatus();
            errorLog.LCRM_User_ID__c = userinfo.getName();
            exceptionList.add(errorLog);
            
        }
       
        if(responseReceived.getPaidNotesResponses != null){
            return responseReceived.getPaidNotesResponses;
        }
        else{
            return null;
        }
        
        
    }
    
    /*Request Wrapper*/    
    public class GPRequestWrapper {
        public GetPaidNotes getPaidNotes;
    }
    
    public class GetPaidNotes {
        public BoomiHeader boomiHeader;
        public String acctSapId;
        public String companyCode;
        public String salesOrgCode;
        public String distChanCode;
        public String divisionCode;
        public String modifiedDtStart;
        public String ModifiedDtEnd;
    }
    public class ExtensibleAttributes {
        public String key;
        public String value;
    }
    
    public class BoomiHeader {
        public String applicationId;
        public String transactionId;
        public String messageId;
        public String messageHistory;
        public String tracingId;
        public String timeStamp;
        public String instanceId;
        public String companyId;
        public String configGroup;
        public String payloadVersion;
        public String postBackURL;
        public List<ExtensibleAttributes> extensibleAttributes;
    }
    /*Respomse Wrapper*/ 
    public class ResponseWrapper {
        public StatusResponse statusResponse;
        public List<GetPaidNotesResponses> getPaidNotesResponses;
    }
    public class StatusResponse {
        public StatusDetails statusDetails;
    }
    public class StatusDetails {
        public String statusCode;
        public String statusDescription;
        public String statusDetailMessage;
    }
    
    
    public class GetPaidNotesResponses {
        public String collectorCode{get;set;}
        public String collectorName{get;set;}
        public String createDt{get;set;}
        public String modifyDt{get;set;}
        public String note{get;set;}
    }
    /*EXCEPTION*/   
    public class AppServiceException extends Exception {}
    
    //This method is used to display dropdown
    public List<selectoption> getPaidNoteListOptions(){
        List<selectoption> NoteList = new List<selectoption>();
        NoteList.add(new selectoption('All','All'));
        NoteList.add(new selectoption('6 months back','6'));
        NoteList.add(new selectoption('6 - 12 months back','6-12'));
        NoteList.add(new selectoption('12 - 18 months back','12-18'));
        NoteList.add(new selectoption('18 - 24 months back','18-24'));
        return NoteList; 
    }
    public void insertExceptions(){
         if(exceptionList.size() > 0 && errorFlag == false){
             LTSStoreErrors.customLTSException(exceptionList);
         errorFlag = true;}
    }
    
}