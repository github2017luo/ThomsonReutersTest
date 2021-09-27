/*
======================================================================================================================
CLASS NAME: LCRMGenericComponentforIntegration
======================================================================================================================
=
PURPOSE:    LEGACY CODE
LCRM Team Helper Methods. Specially used for GLI,Canada KS and WSS

CHANGE HISTORY:

======================================================================================================================
DATE              NAME                    DESC
2019-02-15        Radhika Pawar           Optimized the code as per JIRA STORY: DPS-80 AR/Billing Data Ability to View invoice details
======================================================================================================================
*/

public class LCRMGenericComponentforIntegration{

public static void documentDetailsExceptionHandling(String statusCode, String statusDescription,String webserviceName){
       System.debug('**Called subscriptionExceptionHandling Method***'+statusCode+''+statusDescription+''+webserviceName);
        String uniqueValueExp = '';
        String existingvalue = '';
        String matchedStatusDetailinfo = '';
        map<String,String> mapOfExceptionInfo = new map<String,String>();
        matchedStatusDetailinfo = webserviceName+statusCode+statusDescription;
        System.debug('matchedStatusDetailinfo :-'+matchedStatusDetailinfo );
        List<LCRM_Exception_Handling__c> lstofExceptionInfo = LCRM_Exception_Handling__c.getall().values();
        System.debug('lstofExceptionInfo:-'+lstofExceptionInfo);
        
         For(LCRM_Exception_Handling__c expHandling : lstofExceptionInfo) {
            UniqueValueExp =expHandling.Webservice_Name__c+expHandling.Status_Code__c+expHandling.Status_Description__c;
            System.debug('UniqueValueExp:-'+UniqueValueExp);
            if(mapOfExceptionInfo.containsKey(UniqueValueExp)){
                existingvalue = mapOfExceptionInfo.get(expHandling.UI_Error_Message_English__c);
                System.debug('---->'+existingvalue);
                mapOfExceptionInfo.put(UniqueValueExp,existingvalue);
            } else {
                mapOfExceptionInfo.put(UniqueValueExp,expHandling.UI_Error_Message_English__c);
                System.debug('Not contain value---->'+mapOfExceptionInfo);
            }
        }
        System.debug('mapOfExceptionInfo value---->'+mapOfExceptionInfo.values());
        System.debug('mapOfExceptionInfo KeySet---->'+mapOfExceptionInfo.Keyset());
        
         If(mapOfExceptionInfo.containsKey(matchedStatusDetailinfo)){
             
              Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+mapOfExceptionInfo.get(matchedStatusDetailinfo)));    
                System.debug('matched Error Information**:-'+mapOfExceptionInfo.get(matchedStatusDetailinfo));  
             
         }else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
            
            System.debug('**statusCode:**'+statusCode+'**StatusDescription**'+StatusDescription);
            if(webServiceName =='LCRM_GetDocumentDetails'){
            String strBody = 'Exception received.';
            String strerror = 'Got the Exception Status Code'+statusCode+' and get the Exception Status '+statusDescription;
            System.debug('strBody'+strBody+'error'+strerror);            
            logException(strBody, strerror, 'LCRM_GetDocumentDetails');
            }
        }
   }//End Exception Handling Method
   
   /*-------------------------------------------------------------------------------    
        Method to create records for Integration_Logger
    --------------------------------------------------------------------------------*/
    public static void logException(string strBody, string error, String webServiceName) {
        try{
            System.debug('**call logException method**');
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(webServiceName); 
            Integration_Logger__c intLog = new Integration_Logger__c();
            intLog.Object_Name__c = 'Source System Detail';
            intLog.Exception_Message__c = error;
            intLog.Request_Message__c = strBody;
            intLog.Request_Type__c = 'Outbound';
            intLog.Service_Name__c = webServiceName;
            intLog.Object_Id__c = '01I1300000224X1EAI';
            database.insert(intLog,false); 
            System.debug('intLog'+intLog);
        } catch(Exception e){
             ApexPages.addMessages(e);
        }
           
     }

}