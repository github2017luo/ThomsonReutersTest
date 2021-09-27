/**
* Description   : Batch class for updating the existing Event with Activity Type as S2E
*                 
* Author        : TCS 
* Change History: 16-May-2017 Initial Version
* 
* 
* 
*/
global class LCRMEventActivityCategoryUpdate implements Database.Batchable<sObject>{
    public String query;
    
    global LCRMEventActivityCategoryUpdate(){
        query = 'SELECT Id, LCRM_Activity_Type__c from Event';
        query += ' WHERE LCRM_Activity_Type__c = null AND IsRecurrence = false AND LastModifiedDate > LAST_YEAR';
        query += ' limit 50000' ;
    }
    
    global Database.QueryLocator Start(Database.BatchableContext BC){
     return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug(scope);
        List<Event> eventList = new List<Event>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        
        for(sObject sobj: scope){
        Event e = new Event(Id = sobj.Id, LCRM_Activity_Type__c = 'S2E');
        eventList.add(e);
        }
        //Database.update(eventList, false);
        Database.SaveResult[] results = Database.update(eventList, false);
        for(Integer i=0;i<results.size();i++){
            if(!results.get(i).isSuccess()){
                Database.Error error = results.get(i).getErrors().get(0);
                LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                excepObj.LCRM_Exception_Message__c= error.getMessage();
                excepObj.LCRM_Record_Ids__c= eventList.get(i).Id;
                excepObj.LCRM_Exception_Type__c = 'Activity Type changing batch job for Event';
                exceptionList.add(excepObj);
                system.debug('Exception: '+ excepObj);
            }
        }
        
        if(exceptionList != null && exceptionList.size() > 0)
            insert exceptionList ;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}