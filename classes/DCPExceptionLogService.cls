/********************************************************************************
Class Name : DCPExceptionLogService 
@description : This class is used to Store exceptions, occured in Classes, in Application Log (Salesforce Object) . 
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                         Developer                    Description
12-08-2021                  Vinit Nagar            DCP-3086 | Initial Creation
*/
@SuppressWarnings('PMD.ApexCRUDViolation')
@RestResource(urlMapping='/digital/renewal/exceptionlog')
global without sharing class DCPExceptionLogService {
	/**
    * @description Rest API will trigger this Method and return response
    * @return Returns DCPServiceResponse in case of success Or throws exception.
    */
    @HttpPost
    global static DCPServiceResponse createException(){
        
        DCPServiceResponse response = new DCPServiceResponse();
        DCPExceptionLogService service = new DCPExceptionLogService();
        try{
            RestRequest req = RestContext.request;
            if(req !=null){
                Map<String,String> requestBody = (Map<String,String>)JSON.deserialize(req.requestBody.toString(),Map<String,String>.class);
                
                response = service.insertException(requestBody); 
    
                response.Code = 200;
                response.response = 'Exception Log Inserted';
                response.status = 'Success';
            }
            else{
                response.response = 'Digital Exception is not available';
            }
            
        }Catch(Exception ex){
            response.Code = 400;
            response.response = ex.getMessage();
            response.status = 'Success';
        }
        return response; 
    }
    /**
    * @description this Method will be called by createException and return response
    * @param req Map of Exception details
    * @return Returns DCPServiceResponse in case of success Or throws exception.
    */
    public DCPServiceResponse insertException(Map<String,String> req){
        DCPServiceResponse res = new DCPServiceResponse();
        
        LTS_Application_Log__c errLog = new LTS_Application_Log__c ();
        errLog.LTS_Application_Name__c = req.get('appName');
        errLog.LTS_Class_Name__c = req.get('className');
        errLog.LTS_Method_Name__c = req.get('methodName');
        errLog.LTS_Short_Header__c = req.get('ShortHeader');
        errLog.LTS_Long_Description__c = req.get('LongDescription');
        errLog.LTS_Exception_Type__c = req.get('ExceptionType');
        errLog.LTS_Type__c = req.get('type');
        if (Schema.SObjectType.LTS_Application_Log__c.isCreateable() ){
        	Insert errLog;
        }
        return res;
    }
}