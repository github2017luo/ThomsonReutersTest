/**
* Description   : Batch class for updating the existing Task with Activity Type as S2E
*                 
* Author        : TCS 
* Change History: 16-May-2017 Initial Version
* 
* 
* 
*/
global class LCRMTaskActivityCategoryUpdate implements Database.Batchable<sObject>{
    public String query;
    
    global LCRMTaskActivityCategoryUpdate(){
        query = 'SELECT Id, LCRM_Activity_Type__c from Task';
        query += ' WHERE LCRM_Activity_Type__c = null AND IsRecurrence = false AND LastModifiedDate > LAST_YEAR';
        query += ' limit 50000' ;
    }
    
    global Database.QueryLocator Start(Database.BatchableContext BC){
     return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug(scope);
        List<Task> taskList = new List<Task>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        
        for(sObject sobj: scope){
        Task t = new Task(Id = sobj.Id, LCRM_Activity_Type__c = 'S2E');
        taskList.add(t);
        }
        //Database.update(taskList, false);
        Database.SaveResult[] results = Database.update(taskList, false);
        for(Integer i=0;i<results.size();i++){
            if(!results.get(i).isSuccess()){
                exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),taskList.get(i).Id));
            }
        }
        
        if(exceptionList != null && exceptionList.size() > 0)
            insert exceptionList ;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
    @TestVisible
    private LCRM_Exception_Log__c createExceptionLog(String errorMessage, String recordId){
        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c= errorMessage;
        excepObj.LCRM_Record_Ids__c= recordId;
        excepObj.LCRM_Exception_Type__c = 'Activity Type changing batch job for Task';
        return excepObj;
    }
}