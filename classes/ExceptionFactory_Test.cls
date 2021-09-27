/*
/*** @Author: Pavithra Raman 
/*** Created Date: 11 APR 2019
/*** Purpose: Test class
/*** JIRA : DLT-15694 Test Class for ExceptionFactory */
/*** Change History  ******************************************************************************************************/
/*** Modified By    Modified Date    JIRA    
/**************************************************************************************************************************/

@isTest
private class ExceptionFactory_Test {  
    
    public static String sObjType;
    public static Exception ex;
    public static Id recordId;
    public static DMLexception dmlError;
    public static string userMessage;
    public static string classRef;
    public static string additionalInfo;
    public static string exType;
    public static string exMessage;
    
    
    @isTest static void logDatabaseExceptionTest(){
        
        Test.startTest();
        
        ExceptionFactory exFac= new ExceptionFactory();
        try{
        
            Account acc = new Account(name = '');
            insert acc;
            System.assertEquals(acc.Name,'');
        }
        catch(DMLException dmlError){
            ExceptionFactory.ExceptionWrapper exWrap = new ExceptionFactory.ExceptionWrapper();
            exWrap.sObjType = 'Digital_Exception_Log__c';         
            exWrap.dmlError = dmlError;    
            exFac.LogDatabaseException(exWrap);        
        
        }
        Test.stopTest();
    }
    
    @isTest static void logExceptionTest(){
        
        Test.startTest();
        ExceptionFactory exFac= new ExceptionFactory();
        
        try{
        
            Account acc = new Account(name = 'trest',ownerID = '005xxxxxxxxxxx');
            insert acc;
            System.assertEquals(acc.Name,'trest');
        }
        catch(Exception ex){
            ExceptionFactory.ExceptionWrapper exWrap = new ExceptionFactory.ExceptionWrapper();
            exWrap.sObjType = 'Digital_Exception_Log__c';         
            exWrap.ex= ex;    
            exFac.LogException(exWrap);        
        
        }        
        
        Test.stopTest();
    }

}