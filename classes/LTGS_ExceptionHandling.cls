/* 
CHANGE HISTORY
==========================================================================================================
   Date          Name         Description
2019-03-08      Preetham     Exception Handling class to log expection for LTGS
==========================================================================================================

*/

public without sharing class LTGS_ExceptionHandling  
{
        
     public static void createExceptionLog(String exMessage, String exType, String additionalInfo, String userMessage, String classRef,String obj,String recordId) 
     {
        
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex.Exception_Message__c = exMessage;
        ex.Exception_Type__c = exType;
        ex.Additional_Information__c = additionalInfo;            
        ex.User_Message__c = userMessage;
        ex.Class_Reference__c = classRef ;
        ex.Object__c = obj;
        ex.Record_Id__c = recordId;                     
        if (Schema.sObjectType.Digital_Exception_Log__c.isCreateable())
         insert ex;
    }
  
  }