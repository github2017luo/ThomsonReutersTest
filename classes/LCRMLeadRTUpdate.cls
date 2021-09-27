/**
* Description   : Batch class for updating the existing lead records with the S2E record types
*                 
* Author        : TCS 
* Change History: 27-Apr-2017 Initial Version
* 
* 
* 
*/
global class LCRMLeadRTUpdate implements Database.Batchable<sObject>{
    public String query;
    public Id rtId;
    public Id rtEliteId;
    
    global LCRMLeadRTUpdate(){
        
        rtId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
        rtEliteId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite').getRecordTypeId();
        query = 'Select Id from Lead';
        query += ' Where IsConverted = false AND Is_GLI__c = false';
        query += ' AND Status NOT IN (\'Discarded\',\'Converted\')';
        if(Test.isRunningTest())
        {
            query += ' AND LastName = \'TestLastName#123\'';
            query += ' AND RecordTypeId =  :rtEliteId';
        }
        else{
            query += ' AND RecordTypeId =  \'\'';
        }
        query += ' limit 50000' ;
    }
    
    global Database.QueryLocator Start(Database.BatchableContext BC){
         return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        System.debug(scope);
        List<Lead> leadList = new List<Lead>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        for(sObject sobj: scope){
            Lead L = new Lead(Id = sobj.Id, recordTypeID = rtId);
            leadList.add(L);
        }
        
        Database.SaveResult[] results = Database.update(leadList, false);
        for(Integer i=0;i<results.size();i++){
            if(!results.get(i).isSuccess()){
                exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),leadList.get(i).Id));
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
        excepObj.LCRM_Exception_Type__c = 'Lead record type update job failure';
        return excepObj;
    }
}