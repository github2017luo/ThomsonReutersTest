/**
* Description   : Batch class for updating the existing contact records with the S2E record types
*                 
* Author        : TCS 
* Change History: 27-Apr-2017 Initial Version
* 
* 
* 
*/
global class LCRMContactRTUpdate implements Database.Batchable<sObject>{
    public String query;
    public Id rtId;
    public Id rtGLIContactId;
    //Date deploymentDate;
    
    global LCRMContactRTUpdate(){
        //deploymentDate = GLI_Deployment_Date__c.getValues('DeploymentDate').Deployment_Date__c;
        
        //rtId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'S2E'].Id;
        
        rtId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
        rtGLIContactId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        
        //query = 'Select Id from Contact Where RecordTypeId =  \'\' AND createdDate <=: deploymentDate';
        
        query = 'Select Id from Contact';
        query += ' Where LCRM_Is_GLI__c = false';
        if(Test.isRunningTest())
        {
            //query += ' AND LastName = \'TestLastName#123\'';
            query += ' AND RecordTypeId =  :rtGLIContactId';
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
        List<Contact> contactList = new List<Contact>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
        
        for(sObject sobj: scope){
        Contact c = new Contact(Id = sobj.Id, recordTypeID = rtId);
        contactList.add(c);
        }
        //Database.update(contactList, false);
        Database.SaveResult[] results = Database.update(contactList, false);
        for(Integer i=0;i<results.size();i++){
            if(!results.get(i).isSuccess()){
                exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),contactList.get(i).Id));
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
        excepObj.LCRM_Exception_Type__c = 'Contact record type update job failure';
        return excepObj;
    }
}