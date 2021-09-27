/**
 * CHANGE HISTORY
 * ============================================================================================================================
 * Date         Name             JIRA          Description
 * ============================================================================================================================
 * 
 * 2017-01-06  Karthi            EBB         Trigger in ESC_EmailSelectorList__c
 * ============================================================================================================================
 */
trigger ESC_MasterEmailSelectorList on ESC_EmailSelectorList__c (before insert, after insert, before update, after update, 
                                    before delete, after delete, after undelete) {
    if((trigger.isinsert && trigger.isbefore) || (trigger.isUndelete&& trigger.isafter)){
        ESC_EmailSelectorListHandler.populateConcatenatedField(trigger.new);
    }
    else if(trigger.isupdate&& trigger.isbefore){
         ESC_EmailSelectorListHandler.updatelkpfield(trigger.oldmap,trigger.new);
    }

}