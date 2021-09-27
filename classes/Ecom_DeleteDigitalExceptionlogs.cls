global class Ecom_DeleteDigitalExceptionlogs implements Database.Batchable<sobject>,Database.Stateful{
  
    global Database.QueryLocator start(Database.BatchableContext bc){ 
      return Database.getQueryLocator('Select Id from Digital_Exception_Log__c where createddate < LAST_N_DAYS:'+System.Label.ED_DEL);
    }
    global void execute(Database.BatchableContext bc,List<Digital_Exception_Log__c> scope){
        
        try{
             if(!scope.isEmpty()){
                delete scope;
            }
        }
        catch(Exception e){ Digital_Exception_Log__c ex = new Digital_Exception_Log__c();ex.Exception_Message__c = e.getMessage();ex.Exception_Type__c = e.getStackTraceString();ex.Additional_Information__c = String.valueof(e.getLineNumber());ex.User_Message__c = String.valueof(e.getCause());ex.Class_Reference__c = 'Ecom_DeleteDigitalExceptionlogs > Execute'; insert ex; }
    }
    global void finish(Database.BatchableContext bc){
    }
}