/*
/*** @Author: Harika Sai P And Divija Deepthi
/*** Created Date: 20 MAR 2019
/*** Purpose: This is a class used for Data base operations as part of the framework
/*** JIRA : DLT-15694 Create Global Data Layer - All our Sobjects operation should go with this layer */
/*** Change History  ******************************************************************************************************/
/*** Modified By    Modified Date    JIRA    
/**************************************************************************************************************************/

public without sharing class ExceptionFactory implements IExceptionFactory {
   
    
    public class ExceptionWrapper{
    
        public string sObjType;
        public Exception ex;
        public Id recordId;
        public DMLexception dmlError;
        public string userMessage;
        public string classRef;
        public string additionalInfo;
        public string exType;
        public string exMessage;
    
    
    }
    
    //This method is used to insert database Exceptions for the respective Exception Log object.
    public void logDatabaseException(ExceptionFactory.ExceptionWrapper  exWrap){ 
   
       if(exWrap.sObjType == 'Digital_Exception_Log__c'){
       
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = exWrap.dmlError.getMessage();
            ex.Exception_Type__c = 'DML Exception';                       
            //ex.User_Message__c = userMessage;
            
             if(ex!= null){
                insert ex;
            }                      
       
       }
   }
   // This method is used to insert error for the respective EXception Log object for any Exception thrown
   
   public void logException(ExceptionFactory.ExceptionWrapper  exWrap){
   
        
        if(exWrap.sObjType == 'Digital_Exception_Log__c'){
            
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            string userMEssage = 'Line Number ' + exWrap.ex.getLineNumber() + ' ' +  exWrap.ex.getMessage();  
                      
            ex.Exception_Message__c = exWrap.ex.getMessage();
            ex.Exception_Type__c = exWrap.ex.getTypeName();
            ex.Additional_Information__c = exWrap.ex.getStackTraceString() + 'Cause:' + exWrap.ex.getCause();            
            ex.User_Message__c = userMessage;
            ex.Class_Reference__c = exWrap.classRef ;
            ex.Object__c = exWrap.sObjType;
            ex.Record_Id__c = exWrap.recordId;  
            
             if(ex!= null){
                insert ex;
            }           
                     
       
       }   
   }
   
   // This method is used to insert error for the respective EXception Log object for any Exception thrown
   
   public void logExceptions(List<ExceptionFactory.ExceptionWrapper>  exWrapList){
  
    
   }
   
}