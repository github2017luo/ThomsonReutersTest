public with sharing class APTS_GroupTriggerHandler {
    
    public void onAfterInsert(APTS_Group__c[] newObjects){
        APTS_GroupTriggerHelper.updateGroupRequired(newObjects);
    }
    
    public void onAfterUpdate(APTS_Group__c[] updatedObjects){
        APTS_GroupTriggerHelper.updateGroupRequired(updatedObjects);
    }

}