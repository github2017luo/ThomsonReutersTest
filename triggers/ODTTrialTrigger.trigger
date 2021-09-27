/**
 * CHANGE HISTORY
 * =========================================================================================================
 * Name                : ODTTrialTrigger
 * Description         : This trigger gets invoked whenever a trial record has been updated.
 *                       Using this trigger we are checking if the trial status has been changed to 'Accepted'
 * Created Date        : 8/13/2018
 * Author              : Ameeta Antonio
 * Modification History: Modified by Harshitha
                         DLT-12322: To update Invited Colleague(Primary User) record's Trial Status based on corresponding Trial record
 * ==========================================================================================================
 */ 
trigger ODTTrialTrigger on Trial__c (before update, after update, before insert,after insert) {

    //DLT-11534 to create assets based on trial status being 'Accepted'
    if(Trigger.isAfter && Trigger.isUpdate){
        System.debug('after');
        ODTTrialTriggerHandler.handleODTTrialAfterUpdate(trigger.New, trigger.oldMap);
    }
    //DLT-12322 starts:Added by Harshitha
    if(Trigger.isBefore && Trigger.isUpdate && ODTTrialTriggerHandler.checkexecuted){
        system.debug('before update trigger');
        ODTTrialTriggerHandler.updateIcPrimaryUser(trigger.New, trigger.oldMap);
    }
    //DLT-12322 ends
    
    //Changing recordtypes based on trial status 
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate) && ODTTrialTriggerHandler.recordTypeBool){
    
        ODTTrialTriggerHandler.processRecordTypes(trigger.new);
    }
    //Changes added part of MLD-81 to check the account record type .
     if(Trigger.isAfter && Trigger.isInsert){
             system.debug('inside contactafter event listener trigger');
               LCRMGenericComponent.checkArchiveAccountType(trigger.new);
    }
}