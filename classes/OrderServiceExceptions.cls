/**
 * This is used to handle exceptions for both LCRM_GetOrder and LCRMGetOrderDetail services.
 *
 * @author  Seema Nagdev
 * @version 2017-11-01
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-11-01   Seema Nagdev       Created                                                           
 * =============================================================================
 */

public class OrderServiceExceptions {
    public class OrdExceptions {
        public EsiHeader esiHeader{get;set;} 
        public String orderHeader {get;set;} 
        public StatusDetail statusDetail{get;set;} 
        
        public OrdExceptions(){
            esiHeader = new EsiHeader();
            orderHeader = '';
            statusDetail = new StatusDetail();
        }
    }
    public class StatusDetail {
        public String statusCode{get;set;} 
        public String statusDescription{get;set;} 
        public String statusDetailMessage{get;set;} 
        
        public StatusDetail(){
            statusCode = '';
            statusDescription = '';
            statusDetailMessage = '';    
        }
    }

    public class EsiHeader {
        public String applicationId{get;set;} 
        
        public EsiHeader(){
            applicationId='';
        }
    }
    
   /*-------------------------------------------------------------------------------    
        Method to deserialize the exception received
    --------------------------------------------------------------------------------*/
     public static StatusDetail getExceptionMesg(String jsonResponse){
        System.debug('getExceptionMesg jsonResponse**:-'+jsonResponse);
        StatusDetail statusinfo = new StatusDetail ();
        OrdExceptions excpetionRes = new OrdExceptions();
        try{
            excpetionRes = (OrdExceptions)System.JSON.deserialize(jsonResponse, OrdExceptions.class);
            System.debug('excpetionRes-->'+excpetionRes);
            if(excpetionRes.statusDetail!=null){
                 statusinfo = excpetionRes.statusDetail;  
            }
        }catch(Exception e){
            System.debug('Error: '+e.getMessage());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+e.getMessage()));
        }
        System.debug('statusinfo -->'+statusinfo );
        return statusinfo ;
    }
    
    /*-------------------------------------------------------------------------------    
        Method to handle exceptions from custom setting
    --------------------------------------------------------------------------------*/
    public static void handleException(OrderServiceExceptions.StatusDetail exceptionMsg,String webservicename){
        System.debug('Inside handleException**');
        String strBody;
        String error;
        
        String keyValueExp = '';
        String exceptionReceived = webservicename + exceptionMsg.statusDescription;
        System.debug('exceptionReceived-->'+exceptionReceived);
        Map<String, String> mapExceptionhandle = new  Map<String, String>();
        
        List<LCRM_Exception_Handling__c> lstExceptionHandle = LCRM_Exception_Handling__c.getall().values();
        System.debug('lstExceptionHandle-->' + lstExceptionHandle);
         System.debug('KeySet-->'+mapExceptionhandle.keySet());
        System.debug('MapValues-->'+mapExceptionhandle.values());
        
        if(!lstExceptionHandle.isEmpty()){
            for(LCRM_Exception_Handling__c exp : lstExceptionHandle){
                keyValueExp = exp.Webservice_Name__c + exp.Status_Description__c;
                mapExceptionhandle.put(keyValueExp, exp.UI_Error_Message_English__c);
            }
        }
        System.debug('KeySet1-->'+mapExceptionhandle.keySet());
        System.debug('MapValues1-->'+mapExceptionhandle.values());
        
        if(mapExceptionhandle.containsKey(exceptionReceived)){
            System.debug('Corresponding value-->'+mapExceptionhandle.get(exceptionReceived));
            if(exceptionMsg.statusDescription == 'UnexpectedError'){
                strBody = 'Exception received.';
                error = 'Exception Status Code:-'+exceptionMsg.statusCode+' Exception Status:- '+exceptionMsg.statusDescription+' StatusDetail:-'+exceptionMsg.statusDetailMessage;
                System.debug('strBody'+strBody+'error'+error);
                logException(strBody, error, WebServiceName);
            }
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '' + mapExceptionhandle.get(exceptionReceived)));
            
        } else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
            strBody = 'Exception received.';
            error = 'Exception Status Code:-'+exceptionMsg.statusCode+' Exception Status:- '+exceptionMsg.statusDescription+' StatusDetail:-'+exceptionMsg.statusDetailMessage;
            System.debug('strBody'+strBody+'error'+error);
            logException(strBody, error, WebServiceName);
        }
    }
    
    /*-------------------------------------------------------------------------------    
        Method to create records for Integration_Logger
    --------------------------------------------------------------------------------*/
    public static void logException(string strBody, string error, String WebServiceName) {
        try{
            System.debug('Inside logException-->');
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName); 
            Integration_Logger__c intLog = new Integration_Logger__c();
            intLog.Object_Name__c = 'Source System Detail';
            intLog.Exception_Message__c = error;
            intLog.Request_Message__c = strBody;
            intLog.Request_Type__c = 'Outbound';
            intLog.Service_Name__c = WebServiceName;
            intLog.Object_Id__c = Label.LCRMSourceSystemDetailsID;
            database.insert(intLog,false); 
            System.debug('intLog'+intLog);
        } catch(Exception e){
             ApexPages.addMessages(e);
        }
    }  
}