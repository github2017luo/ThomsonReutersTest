/*
===============================================================================
ApplicationLogUtility
===============================================================================

PURPOSE: Utility Class for logging the callouts,batch processing and exceptions in LTS_Application_Log__c object

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2018-08-23      Vaishali Nagar                Created 
===============================================================================
*/
public without sharing class ApplicationLogUtility {

    private static LTS_Application_Log__c errLog;
    
    
     /******************************************************************* 
    Purpose:This method is used to parse Exception object and return Exception log object with basic details 
    Parameters:Exception object.
    Returns: Application Log object 
    ********************************************************************/
    private static LTS_Application_Log__c parseException(Exception ex) {        
        errLog = new LTS_Application_Log__c();
        
        if(ex !=null){
            errLog.LTS_Exception_Type__c = ex.getTypeName();
            errLog.LTS_Short_Header__c = ex.getMessage();
            //errLog.LTS_Record_Id__c = ex.getId();
            Schema.DescribeFieldResult f = LTS_Application_Log__c.LTS_Long_Description__c.getDescribe();
            integer fieldLength = f.getLength();
            errLog.LTS_Long_Description__c = ex.getStackTraceString().length() <=fieldLength?ex.getStackTraceString():ex.getStackTraceString().subString(0,fieldLength);

        }else{
            system.debug('Exception object is empty' + ex);
        }
                //insert errLog;
        return errLog;   
    }
        
   
     /******************************************************************* 
    Purpose: Return the basic information.
    Parameters:Application name, method name, class name and exception object.
    Returns: Application Log object 
    ********************************************************************/
    private static LTS_Application_Log__c getException(Exception ex,String appName, String className, String methodName){
    
        errLog = parseException(ex);
        errLog.LTS_Application_Name__c = appName;
        errLog.LTS_Class_Name__c = className;
        errLog.LTS_Method_Name__c = methodName;
        return errLog;
        
    }
    
     /******************************************************************* 
    Purpose: Generic method to log for batch/Integration/Helper/Handler/Controller class.
    Parameters:All the fields from Application log object except for Exception type and Type.
    Returns: None 
    ********************************************************************/
    public static void logException (String appName, String className, String methodName, string webserviceName, String targetURL,String summary, String description,String type,String tags,String recordId){
        errLog = new LTS_Application_Log__c ();
        errLog.LTS_Application_Name__c = appName;
        errLog.LTS_Class_Name__c = className;
        errLog.LTS_Method_Name__c = methodName;
        errLog.LTS_Type__c = type;
        if(type =='Batch'){
            errLog.LTS_Batch_Processed__c = true;
        
        }
        errLog.LTS_Short_Header__c =summary;
        errLog.LTS_Long_Description__c = description;
        errLog.LTS_Target_URL__c = targetURL;
        errLog.LTS_Exception_Service_Name__c =webserviceName;
        errLog.LTS_Tags__c = tags;
        errLog.LTS_Record_Id__c = recordId;
        CaptureException(errLog);
        
    }
    
    
     /******************************************************************* 
    Purpose: Generic method to log Exception for Handler/controller/helper class in Application log object.
    Parameters:Application name, method name, class name and exception object.
    Returns: None 
    ********************************************************************/
    public static void logException(String appName, String className, String methodName, Exception ex) {     
         errLog = getException(ex,appname,classname,methodName);
         errLog.LTS_Type__c = 'Exception';
         CaptureException(errLog);
     }
     
     /******************************************************************* 
    Purpose: Called to log in application log object alongwith tags.
    Parameters:Application name, method name, class name, Tags and exception object.
    Returns: None 
    ********************************************************************/
    public static void logExceptionWithTag(String appName, String className, String methodName, Exception ex,String tags) {     
         errLog = getException(ex,appname,classname,methodName);
         errLog.LTS_Type__c = 'Exception';
         errLog.LTS_Tags__c = tags;
         CaptureException(errLog);
     }
     
    
     /******************************************************************* 
    Purpose: Called from batch class to log eception in application log object
    Parameters:Application name, method name, class name, Exception object.
    Returns: None 
    ********************************************************************/
    public static void logBatchException(String appName, String className, String methodName, Exception ex){         
         errLog = getException(ex,appname,classname,methodName);
         errLog.LTS_Type__c = 'Batch';
         errLog.LTS_Batch_Processed__c = true;
         CaptureException(errLog);
     }
     
     /******************************************************************* 
    Purpose: Called from batch class to log in Application log object
    Parameters: Application Name, method name, class name, summary and description
    Returns: None 
    ********************************************************************/
    public static void logBatch(String appName, String className, String methodName, String summary, String description){
         errLog = new LTS_Application_Log__c();
         errLog.LTS_Application_Name__c = appName;
         errLog.LTS_Class_Name__c = className;
         errLog.LTS_Method_Name__c = methodName;
         errLog.LTS_Type__c = 'Batch';
         errLog.LTS_Batch_Processed__c = true;
         errLog.LTS_Short_Header__c = summary;
         errLog.LTS_Long_Description__c = description;
         captureException(errLog);
         
    }
     
     /******************************************************************* 
    Purpose: Used to log exception in case of webservice callout.
    Parameters: Application Name, method name, class name, webservice name, target URL and Exception object
    Returns: None 
    ********************************************************************/
    public static void logCalloutException(String appName, String className, String methodName, string webserviceName, String targetURL, Exception ex) {     
         errLog = getException(ex,appname,classname,methodName);
         errLog.LTS_Target_URL__c = targetURL;
         errLog.LTS_Exception_Service_Name__c = webservicename;
         errLog.LTS_Type__c = 'Integration';
         captureException(errLog);
     }
     
    /******************************************************************* 
    Purpose: Generic method to log the apex callout in Application log object in case of Integration
    Parameters: take all the fields from Application Log object except for Exception type,Batch Processed,Tags fields.
    Returns: None 
    ********************************************************************/
     public static void logCallout(String appName, String className, String methodName, string webserviceName, String targetURL,String summary, String description){
         errLog = new LTS_Application_Log__c();
         errLog.LTS_Application_Name__c = appName;
         errLog.LTS_Class_Name__c = className;
         errLog.LTS_Method_Name__c = methodName;
         errLog.LTS_Target_URL__c = targetURL;
         errLog.LTS_Exception_Service_Name__c = webservicename;
         errLog.LTS_Type__c = 'Integration';
         errLog.LTS_Short_Header__c = summary;
         errLog.LTS_Long_Description__c = description;
         CaptureException(errLog);
    
     }
     
     /******************************************************************* 
    Purpose: Generic method to perform DML operation on Application log object
    Parameters: Application Log object
    Returns: None 
    ********************************************************************/
    private static void CaptureException(LTS_Application_Log__c oErrorLog){     
         
         try{
             insert oErrorLog;
         }catch(Exception ex){
             system.debug('@@ Error' + ex.getMessage());
         }
     }
}