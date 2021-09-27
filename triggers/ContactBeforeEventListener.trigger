/* CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-07-20   Navleen Kaur            Commented out digitalFieldValueCaptialisation dependency
 * =============================================================================
 */
trigger ContactBeforeEventListener on Contact (before delete, before insert, before update) {
    
    //LTS_5219 : Exclusion framework
    System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
    If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
    return;
    
    
    List<Contact> listContact = new List<Contact>();
    
   //Added for user story CRM-14346
    string triggerDisable = Label.DisableTrigger_Contact;
    system.debug('@@@@triggerDisable'+triggerDisable);
    Boolean triggerDisbl = triggerDisable.equalsIgnoreCase('True');
    system.debug('@@@triggerDisbl'+triggerDisbl);
  
   if(!triggerDisbl){// For Informatica load CRM-14346
    if(trigger.isInsert){
        ContactTriggerHandler.updateSalesOrgOnInsert(trigger.new);
    }
    if(trigger.isUpdate){
      for(Contact oContact : trigger.new){
       if(oContact.AccountId!=trigger.oldmap.get(oContact.Id).AccountId){
         listContact.add(oContact);
       }
      }
        if(!listContact.IsEmpty()){
       // ContactTriggerHandler.updateSalesOrgOnUpdate(trigger.new,trigger.oldmap);
         ContactTriggerHandler.updateSalesOrgOnInsert(listContact);
       }
       //DPS-17684 -commenting below method as Reservation process is not going to be used in Latam Partner Community
       //ContactUtil.validateAccountApprovedReservation(trigger.new);
    }
    
    /*-- Created by :- Dinesh Voonna
     Date :- 20/04/2017
     Purpose :- To update firstname value to Digital Format
     Jira Story :- DLT-342  
     -- */
    /*if(trigger.isInsert || trigger.isUpdate){
        DigitalFieldValueCaptialisation.contactFirstName(trigger.new);
    }*/
     //Start : LCRM Project : StrikeIron verification
    
       /*KeyValueListStore__c LCRMStrikeIronFlagINS = KeyValueListStore__c.getValues('LCRMDisableStrikeIronServices');
        Boolean LCRMStrikeIronFlag = LCRMStrikeIronFlagINS != null ? Boolean.valueof(LCRMStrikeIronFlagINS.TextValue__c) : False;
        System.debug('LCRMStrikeIronFlag****'+LCRMStrikeIronFlag);
       
       if(!LCRMStrikeIronFlag){*/
           
           ContactTriggerHandler oContactTriggerHandler = new ContactTriggerHandler();
           if(Trigger.IsBefore && Trigger.IsInsert){
                oContactTriggerHandler.addISDCodeToPhone(null,Trigger.New);
              // oContactTriggerHandler .verifyEmailAndPhone(null,Trigger.New);
           //}else if(Trigger.IsBefore && Trigger.IsUpdate && ContactTriggerHandler.verifyEmailAndPhoneRecCheck == false && !System.isFuture() && checkRecursive.hasRunVerifyEmailAndPhone()){ //commented as part of DPS-6078
           }else if(Trigger.IsBefore && Trigger.IsUpdate /*&& ContactTriggerHandler.verifyEmailAndPhoneRecCheck == false*/ && !System.isFuture()){
               //oContactTriggerHandler .verifyEmailAndPhone(Trigger.Old,Trigger.New);
              // ContactTriggerHandler.verifyEmailAndPhoneRecCheck = true;
              oContactTriggerHandler.addISDCodeToPhone(Trigger.Old,Trigger.New);
           }           
       //}

    //End : LCRM Project : StrikeIron verification
  }
  if(Trigger.IsBefore && Trigger.isdelete){
        LCRMRestrictRecordDeletion.restrictRecordDeletion(Trigger.old);
        }
}