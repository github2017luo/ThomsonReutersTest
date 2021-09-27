/**
 * @Comment Class Name : USLARHelper  
 * @description
 Code behind the Service Notes button on the account
  PURPOSE:    GLIEDW, Integration between Salesforce and EDW and middleware system is ESI.
  RestWebService is used for developing the subscription functionality.
 *
 */
public without sharing class USLARHelper {
    
    public static USLARWrapper.ARrequest USLARRequestHelper(String SAPNumber,String CompId,String OrgId,String configGrp,String Begindate,String Enddate){
         USLARWrapper.ARrequest odReqWrap = new USLARWrapper.ARrequest();
         USLARWrapper.oAccount acc = new USLARWrapper.oAccount();
         acc.accountNumber=SAPNumber;
           odReqWrap.Account=acc;
           USLARWrapper.EsiHeader eh=new USLARWrapper.EsiHeader(CompId,OrgId,'',configGrp);
           odReqWrap.esiHeader=eh;
           USLARWrapper.Filter fil=new USLARWrapper.Filter(Begindate,Enddate,true,true,true);
           odReqWrap.filter=fil;
        return odReqWrap;
    }
    
    public static HttpResponse USLARCalloutHelper(String WebServiceName,String jsonString){
        // USLARWrapper ARresponse = new USLARWrapper();
         LCRM_Integration_defaults_Values__c integrationDefault = LCRM_Integration_defaults_Values__c.getvalues(Label.LCRMARInvoicelist);
        HttpResponse Response = new HttpResponse();
        try {
            // Send HTTP Request and assign responseHttp http = new Http(); 
             Http http = new Http();
             HttpRequest HTrequest = new HttpRequest();
             HTrequest = getHttpRequestAR(WebServiceName,jsonString);
             system.debug('HTrequest'+HTrequest.getbody());
             Response = http.Send(HTrequest);
            system.debug('Response'+Response.getBody());
            if(Response.getStatusCode() != 200 && WebServiceName!= integrationDefault.LCRM_WebserviceName__c) {
                ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
               commonCalloutException.setMessage('A callout exception occurred with a status of: ' + Response.getStatusCode());
               throw commonCalloutException;
            }

           // response.isSuccess = TRUE;
          //  response.responseBodyJSON = httpCalloutResponse.getBody();
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }

        return response;
    }
    
    Public static HttpRequest getHttpRequestAR(String WebServiceName,String jsonString){
        HttpRequest request = new HttpRequest();
        try{
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);
        
        request.setEndpoint(oWebServiceSettings.Endpoint__c);
      // request.setEndpoint('https://api.thomsonreuters.com/ebs/invoice/qa/getInvoiceOpenClearedItems');
        request.setMethod('POST');
        // Specify the required user name and the password to access the endpoint 
        // As well as the header and header information 
        Blob headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        request.setHeader('Content-Type', 'application/json');
        // Header info with remote server user name and password
        request.setHeader('Authorization', authorizationHeader);
        // timeout in milliseconds       
        request.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
      
        if(String.IsNotBlank(jsonString)){
            request.setBody(jsonString);
        }
         
    
    }
    catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
        return request;
}
    public static Set<ID> getAccountSetList(Account oAccount){
        System.debug('Account Data:**'+oAccount);
        Set<ID> accountIdSet = new Set<ID>();

        if(oAccount.parentid!=null || oAccount.Account_Indicator__c=='Branch'){
            accountIdSet.add(oAccount.id);
        }
        else{

            List<Account> acclst= new List<Account>();
            acclst = [select id,SAPAccountNumber__c from account where id in :AccountDetailController.getChildAccountIds(oAccount.id)];
            System.debug('acclst:-'+acclst);

            for(Account acc:[select id,SAPAccountNumber__c from account where id in :AccountDetailController.getChildAccountIds(oAccount.id)]){
                accountIdSet.add(acc.id);
            }
        }

        System.debug('###########################accountIdSet:-'+accountIdSet);


        return accountIdSet;

    }

    /**
     * public getSourceSystemDetails method
     * @description : Get the source system details based on current logged in users sales org value should be matched with SSD sales Org field value
     * @param listAccId
     * @param strSubBu
     * @return List<Source_System_Detail__c> list Return description
     */
    public static List<Source_System_Detail__c> getSourceSystemDetails(Set<Id> listAccId,String strSubBu){
       String tempSubBuValues = KeyValueListStore__c.getInstance('LCRMServiceNotesUserSubBu').TextValue__c;//Gets the SUBBU value from KeyValueListStore__c custom settings
        Set<String> subBuValueSet = new Set<String>();
        for(String val : tempSubBuValues.split(',')){
            subBuValueSet.add(val); 
           
        } 
        system.debug(LoggingLevel.DEBUG,'@@@SubBuValueSet'+subBuValueSet+'----'+strSubBu);
        if ((Schema.sObjectType.Source_System_Detail__c.isAccessible() || Schema.sObjectType.Source_System_Detail__c.isQueryable()) && !String.isBlank(strSubBu)) {
        //if( !String.isBlank(strSubBu)){
            System.debug(LoggingLevel.DEBUG,'USL');
            return [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :listAccId and Source_System_Account_Number__c != null and LCRM_Sub_BU__c  IN: subBuValueSet and LCRM_Sales_Org__c!= null];
        }else{
           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.LCRMSubBuMissed));
            return null;
        }
    }
    
    public static USL_Integration_defaults__c getIntegrationDefaults(String segment, String region){
        
        USL_Integration_defaults__c val;
        
        List<USL_Integration_defaults__c> lstDefaults = USL_Integration_defaults__c.getall().values();
        
        for(USL_Integration_defaults__c values : lstDefaults)
        {
            if(values.Segment__c == segment && values.region__c == region)
            {
                val = values;
                break;
            }
        }

        if(val == null)
        {
            val = USL_Integration_defaults__c.getValues('Integrationdefaults');
        }
        
        return val;
    }
}