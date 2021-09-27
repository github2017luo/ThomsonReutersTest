/*
@purpose : JIRA Story- CRM-11779 and CRM-11442
IXOS Webservice on Order Report and Accounts Receivable button on Account and SSD
======================================================================================================================
DATE(DD/MM/YY)           Developer NAME                       DESC
11/12/2017               Navjyoti Mohanta (Developed by)    for CRM-11779 -IXOS service on Account Order Button 
29/12/2017               Seema Nagdev (Modified by)         for CRM-11442 - Accounts Receivable button on SSD
19/01/2018                Navjyoti Mohanta (Modified by)     for CRM-13111 - Remove Dates and Buttons from LCRMIXOS 
======================================================================================================================
*/
public class LCRMIXOSController {
    public static final string WebserviceName ='LCRM_DocumentService';
    public list<LCRMIXOSResponseWrapper.DisplayIxos> displayDoc_list {get; set;}
    public StatusDetails ExceptionMesginfo {get; set;}    
    public Id Accid{get;set;}
     public Id SSDid{get;set;}
    public String AcctSapId{get;set;}
    public String MessageId{get;set;}
    public String OrderNumber{get;set;}
    public String Sales_Org{get;set;}
    //public string IxosBegindt{get;set;}
    //public string IxosEnddt{get;set;}
    public string ReferenceNumber{get;set;}
    public String strBody;
    public String error;
    Public Account oAccount{get;set;}
    public Source_System_Detail__c oSSD {get; set;}
    public boolean flagOfInvoice {get; set;}
    public boolean flagOfOrder {get; set;}
    
    //Constructor
    public LCRMIXOSController(ApexPages.StandardController controller) {        
        accid = ApexPages.currentPage().getParameters().get('AccId');
       AcctSapId = ApexPages.currentPage().getParameters().get('AcctSapId');
       MessageId= ApexPages.currentPage().getParameters().get('MessageId');
       Sales_Org =ApexPages.currentPage().getParameters().get('SalesOrg').toUpperCase();
       //IxosBegindt =system.today().addMonths(-1).format();
       //IxosEnddt =system.today().format();
        if(MessageId == 'Order'){
       oAccount = [Select Id,Name from Account where Id =:accid];
       flagOfInvoice = false ;
        flagOfOrder = true ;
       }
       //Added for  CRM-11442
       if(MessageId == 'Invoice'){
       SSDid = ApexPages.currentPage().getParameters().get('SSDid');
       oSSD =[Select Id, Name from Source_System_Detail__c where id = :SSDid];
        flagOfInvoice = true ;
        flagOfOrder = false ;
       }
       //End: CRM-11442
       
         
     }
       /* -------------------------------------------------------------------------------    
     Retrieving the document list 
    --------------------------------------------------------------------------------*/    
    public PageReference  getIXOSHttpRequest(){
    displayDoc_list  = new list<LCRMIXOSResponseWrapper.DisplayIxos>();   
    try{ 
        
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebserviceName);        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(oWebServiceSettings.Endpoint__c);
        request.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
        request.setMethod('GET');
        
        Blob headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);        
        request.setHeader('Content-Type', 'application/json');        
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Accept', 'application/json');
        
        LCRMIXOSRequestWrapper.IXOSReqWrapper ixosRequest = new LCRMIXOSRequestWrapper.IXOSReqWrapper();
        ixosRequest.GetDocumentDetailsRequest.EsiHeader.applicationId = 'GLI';
        ixosRequest.GetDocumentDetailsRequest.EsiHeader.companyId = Sales_Org;
        
        LCRMIXOSRequestWrapper.BaseDocument bs = new LCRMIXOSRequestWrapper.BaseDocument ();
        bs.Account.accountNumber = AcctSapId;
        List<String> doc_list = new list<string>();
        OrderNumber = ApexPages.currentPage().getParameters().get('OrderNumber');
        if(MessageId == 'Order'){
            OrderNumber = ApexPages.currentPage().getParameters().get('OrderNumber');
            ixosRequest.GetDocumentDetailsRequest.EsiHeader.messageId = 'Order';
            //ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.startDate = formatDate(IxosBegindt);        
            //ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.endDate = formatDate(IxosEnddt);
            ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.startDate = '';        
            ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.endDate = '';
            List<IXOSDocumenttype__c> ixosdoc_list = IXOSDocumenttype__c.getall().values();
            
            for(IXOSDocumenttype__c i : ixosdoc_list){
                doc_list.add(i.name);
            }
            bs.referenceNumber = OrderNumber;
            
        }
        //Added for  CRM-11442
        if(MessageId == 'Invoice'){
            ReferenceNumber = ApexPages.currentPage().getParameters().get('ReferenceNumber');
            ixosRequest.GetDocumentDetailsRequest.EsiHeader.messageId = 'Invoice';
            ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.startDate = '';        
            ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.endDate = '';
            Map<String,InvoiceDocType__c> InvoiceDocTypes  = new Map<String,InvoiceDocType__c>();
                InvoiceDocTypes = InvoiceDocType__c.getall();
                Map<String,String> mapInvoiceDocTypes = new  Map<String,String>();
                for(InvoiceDocType__c oInvoiceDocType : InvoiceDocTypes.values()){
                    if(mapInvoiceDocTypes.containsKey(oInvoiceDocType.Sales_Org__c)){
                       String str1 = mapInvoiceDocTypes.get(oInvoiceDocType.Sales_Org__c)+oInvoiceDocType.Doc_Types__c;
                       mapInvoiceDocTypes.remove(oInvoiceDocType.Sales_Org__c);
                       mapInvoiceDocTypes.put(oInvoiceDocType.Sales_Org__c,str1);
                    }else{
                        mapInvoiceDocTypes.put(oInvoiceDocType.Sales_Org__c,oInvoiceDocType.Doc_Types__c);
                    }
                }
            List<String> ixosdoc_list =  mapInvoiceDocTypes.get(Sales_Org).split(';');
            System.debug('ixosdoc_list-->'+ixosdoc_list);
            for(String i : ixosdoc_list){
                doc_list.add(i);
            }
            //End: CRM-11442
            bs.referenceNumber = ReferenceNumber;
        }
        
        ixosRequest.GetDocumentDetailsRequest.BaseDocument.add(bs);
        ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.documentType = doc_list ;
        
       
        String jsonString = JSON.serialize(ixosRequest);
        system.debug('@@@@@jsonString'+jsonString);
         if(String.IsNotBlank(jsonString)){
                request.setBody(jsonString);
                System.debug('request:-'+request);
         }
        Http http = new Http();
        HttpResponse response = http.send(request);
        string responseBody = response.getBody();        
        system.debug('@@@responseBody'+responseBody);
        system.debug('@@@responseBodycode'+response.getStatusCode());
        if(response.getStatusCode() == 200 ){
            system.debug('Inside If block');
            if(LCRMIXOSResponseWrapper.DisplayIxosMapping(responseBody).size() >0){
              displayDoc_list = LCRMIXOSResponseWrapper.DisplayIxosMapping(responseBody);
            }
            else if(LCRMIXOSResponseWrapper.DisplayIxosMapping(responseBody).size() ==0 && getExceptionMsg(responseBody) != null){
                ExceptionMesginfo = getExceptionMsg(responseBody);
              system.debug('@@ExceptionMesginfo'+ExceptionMesginfo);
                handleException(ExceptionMesginfo,WebserviceName);
            } 
        }  else {
                    strBody = 'Exception received.';
                    error = 'Response Status Code:-' + Response.getStatusCode() + ' Response Status:- ' + Response.getStatus();
                    System.debug('strBody' + strBody + 'error' + error);
                    logException(strBody, error, WebServiceName);
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LCRMWebServiceError));
                }
        system.debug('@@@@final displayDoc_list'+displayDoc_list);
        
        
      }
      catch(Exception oException){
            ApexPages.addMessages(oException);
        }
        return null;
    }
      /* -------------------------------------------------------------------------------    
    Set the Date format
    --------------------------------------------------------------------------------*/  
   /** public static String formatDate(String d) {
        String formatteddate ='';
        Date dt = Date.parse(d);
        String datemonth = String.valueOf(dt.month());
        System.debug('dt.month().length()-->'+datemonth.length());
        if(datemonth.length() == 1)
            formatteddate= dt.year() + '-0' + dt.month() + '-' + dt.day(); 
        else
            formatteddate= dt.year() + '-' + dt.month() + '-' + dt.day();
        return formatteddate;
    }**/
    
    /* -------------------------------------------------------------------------------    
    Exception Handling Wrapper
    --------------------------------------------------------------------------------*/  
    
   public class IXOSExceptionWrapper {
    public GetDocumentDetailsResponse getDocumentDetailsResponse;
        
        public IXOSExceptionWrapper(){
            getDocumentDetailsResponse = new GetDocumentDetailsResponse();
        }
  }
  
  public class GetDocumentDetailsResponse {
    public StatusDetails statusDetails;
        
        public GetDocumentDetailsResponse(){
            StatusDetails = new StatusDetails();
        }
  }

  public class StatusDetails {
    public String statusDescription;
    public String statusDetailMessage;
    public String statusCode;
        
        public StatusDetails(){
            statusDescription ='';
            statusDetailMessage ='';
            statusCode ='';
        }
  }
  
    //Exception Handling Wrapper Ends
    
     /* -------------------------------------------------------------------------------    
    Deserialize the response received during exception
    --------------------------------------------------------------------------------*/      
    public static StatusDetails getExceptionMsg(string jsonResponse){        
        StatusDetails statusInfo = new StatusDetails();
        IXOSExceptionWrapper exceptionResp = new IXOSExceptionWrapper();
        try{
            system.debug('@@ExceptionJson_jsonResponse'+jsonResponse);
           exceptionResp = (IXOSExceptionWrapper)System.JSON.deserialize(jsonResponse, IXOSExceptionWrapper.class);
           system.debug('@@@exceptionResp'+exceptionResp);
            if(exceptionResp.GetDocumentDetailsResponse.StatusDetails != null){
                statusInfo = exceptionResp.GetDocumentDetailsResponse.StatusDetails ;
            }            
        }
        catch(Exception e){
            system.debug('Exception is'+e);
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO,'Error: '+e.getMessage()));
        }
        
        return statusInfo;
    }
    
     /* -------------------------------------------------------------------------------    
    Method to display error on UI from custom setting
    --------------------------------------------------------------------------------*/  
    public void handleException(StatusDetails exceptionMsg , String webservicename){
        system.debug('Inside Handle Exception');
        Map<String, String> mapExceptionhandle = new  Map<String, String>();
        String keyValueExp = '';
        
        String exceptionReceived = webservicename +exceptionMsg.statusDescription ;
        List<LCRM_Exception_Handling__c> lstExceptionHandle = LCRM_Exception_Handling__c.getall().values();
        System.debug('lstExceptionHandle-->'+lstExceptionHandle);
        for(LCRM_Exception_Handling__c exp : lstExceptionHandle){
             keyValueExp = exp.Webservice_Name__c + exp.Status_Description__c;
             mapExceptionhandle.put(keyValueExp, exp.UI_Error_Message_English__c);
        }
        System.debug('mapExceptionhandle-->'+mapExceptionhandle);
        if(mapExceptionhandle.containsKey(exceptionReceived)){
            System.debug('exceptionReceived-->'+exceptionReceived);
            System.debug('exceptionReceived-->'+mapExceptionhandle.get(exceptionReceived));
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '' + mapExceptionhandle.get(exceptionReceived)));
        }else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
            strBody = 'Exception received.';
            error = 'Exception Status Code:-'+exceptionMsg.statusCode+' Exception Status:- '+exceptionMsg.statusDescription+' StatusDetail:-'+exceptionMsg.statusDetailMessage;
            System.debug('strBody'+strBody+'error'+error);
            logException(strBody, error, WebServiceName);
        }
        
    }
    /* -------------------------------------------------------------------------------    
    Method to Log Exception under Integration Logger object
    --------------------------------------------------------------------------------*/ 
     public void logException(string strBody, string error, String WebServiceName) {
        try{
            System.debug('Inside logException-->');
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName); 
            Integration_Logger__c intLog = new Integration_Logger__c();
            intLog.Object_Name__c = 'Source System Detail';
            intLog.Exception_Message__c = error;
            intLog.Request_Message__c = strBody;
            intLog.Request_Type__c = 'Outbound';
            intLog.Service_Name__c = WebServiceName;
            intLog.Object_Id__c = '01I1300000224X1EAI';
            database.insert(intLog,false); 
            System.debug('intLog'+intLog);
        } catch(Exception e){
             ApexPages.addMessages(e);
        }
    }  

}