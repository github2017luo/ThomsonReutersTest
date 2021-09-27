/**
 * @description ESC_IXOSHanaController
 */

public without sharing class ESC_IXOSHanaController{
    Id accid;     
    String acctSapId;
    //public String Sales_Org{get;set;}
    string referenceNumber;
    String strBody;
    Account oAccount;
    String error;
    Source_System_Detail__c oSSD ;
    
    USL_Integration_defaults__c integrationDefaultvalues;
    final string webServiceName ='ESC_IXOSHana_DocumentService';
    String jsonString;

    /**
    @description displayDoclist    
    */
    public list<ESC_IXOSHanaResponseWrapper.DisplayIxos> displayDoclist {get; set;}


    /**  
    *@description ESC_IXOSHanaController
    *@param controller
    */
    public ESC_IXOSHanaController(ApexPages.StandardController controller) {            
        accid = ApexPages.currentPage().getParameters().get('AccId').escapeHtml4();
        AcctSapId = ApexPages.currentPage().getParameters().get('AcctSapId').escapeHtml4();            
        ReferenceNumber = ApexPages.currentPage().getParameters().get('ReferenceNumber').escapeHtml4();
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible()){
            oSSD = [Select BU_Segment__c,LCRM_Sub_BU__c from Source_System_Detail__c where Source_System_Account_Number__c =:AcctSapId];
        }                     
        integrationDefaultvalues = USLARHelper.getIntegrationDefaults(oSSD.BU_Segment__c,oSSD.LCRM_Sub_BU__c);
    }

 /**
 * @description getIXOSHttpRequest    
 * @return PageReference
 */
    public PageReference  getIXOSHttpRequest(){
        displayDoclist  = new list<ESC_IXOSHanaResponseWrapper.DisplayIxos>();                
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
        
        try{
            
            jsonString = createRequest();
            System.debug(LoggingLevel.DEBUG,'ixosRequest'+jsonString);   
            
            if(String.IsNotBlank(jsonString)){
                request.setBody(jsonString);
                System.debug(LoggingLevel.DEBUG,'request:-'+request);
            }           
            processResponse(request );
        }catch(Exception oException){
            ApexPages.addMessages(oException);
        }
        
        return null;
    }       
/**
 * @description createRequest    
 * @return String
 */
    public String createRequest(){
        ESC_IXOSHanaRequestWrapper.IXOSReqWrapper ixosRequest = new ESC_IXOSHanaRequestWrapper.IXOSReqWrapper();
            ixosRequest.GetDocumentDetailsRequest.EsiHeader.applicationId = integrationDefaultvalues.Applicationid__c;
            ixosRequest.GetDocumentDetailsRequest.EsiHeader.companyId = integrationDefaultvalues.Companyid__c;
            ixosRequest.GetDocumentDetailsRequest.EsiHeader.postBackURL = '';
            
            //Document Details
            ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.startDate = System.today();        
            ixosRequest.GetDocumentDetailsRequest.DocumentDetails.DocumentHeader.endDate = System.today().addDays(-365);
            
            //Base Document Detials
            ESC_IXOSHanaRequestWrapper.BaseDocument bs = new ESC_IXOSHanaRequestWrapper.BaseDocument();    
            bs.referenceNumber = ReferenceNumber;           
            bs.account.accountNumber = AcctSapId;           
            bs.account.salesforeOrg = integrationDefaultvalues.Companyid__c;         
            ixosRequest.GetDocumentDetailsRequest.BaseDocument.add(bs);
            
            String jsonString = JSON.serialize(ixosRequest);
            return jsonString;
    }
    
    /**
        * @description displayIxosMapping
        
        * @param request
        */
    public void processResponse(HttpRequest request){
        Http http = new Http();
            HttpResponse response = http.send(request);
            string responseBody = response.getBody();  
            System.debug(LoggingLevel.DEBUG,'@@@responseBody'+responseBody);                              
            system.debug(LoggingLevel.DEBUG,'@@@responseBodycode'+response.getStatusCode());
            
            
            if(response.getStatusCode() == 200 ){
                if(ESC_IXOSHanaResponseWrapper.DisplayIxosMapping(responseBody).size() >0){
                    displayDoclist = ESC_IXOSHanaResponseWrapper.DisplayIxosMapping(responseBody);
                } else if(ESC_IXOSHanaResponseWrapper.DisplayIxosMapping(responseBody).size() ==0 ){
                     Apexpages.addmessage(new ApexPages.message(ApexPages.Severity.INFO,'No records exist'));
                } 
                
            } 
            else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LCRMWebServiceError));
                ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                commonCalloutException.setMessage('A callout exception occurred with a status of: ' + Response.getStatusCode());
                throw commonCalloutException;               
                
            }
    }     
}