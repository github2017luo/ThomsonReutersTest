public without sharing class ESC_CaseFormExtensionTriggerHandler {
    public static void callCaseFormExtensionHandler(){
        if(Trigger.IsInsert ){
            ESC_CaseFormExtInsertTriggerHandler.onInsert(Trigger.New);
        } 

        if(Trigger.isBefore && Trigger.isUpdate){
           ESC_CaseFormExtUpdateTriggerHandler.onBeforeUpdate((Map<Id,ESC_Case_Form_Extension__c >) Trigger.oldMap,(Map<Id,ESC_Case_Form_Extension__c >) Trigger.newMap);
        } 
        
        if(Trigger.isAfter && Trigger.isUpdate){
           ESC_CaseFormExtUpdateTriggerHandler.onAfterUpdate((List<ESC_Case_Form_Extension__c >) Trigger.new,(Map<Id,ESC_Case_Form_Extension__c >) Trigger.oldmap);
           ESC_CaseFormExtUpdateTriggerHandler.onAfterUpdate2((Map<Id,ESC_Case_Form_Extension__c >) Trigger.newMap,(Map<Id,ESC_Case_Form_Extension__c >) Trigger.oldmap);
        
        } 
    }
}