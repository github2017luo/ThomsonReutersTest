trigger ContactAfterEventListener on Contact (after delete, after insert, after undelete, after update) {
    
    //LTS_5219 : Exclusion framework
    System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
    If(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){
    return;
    }
    
    
    List<Contact> listContact = new List<Contact>();

     //Added for user story CRM-14346
    string triggerDisable = Label.DisableTrigger_Contact;
    system.debug('@@@@triggerDisable'+triggerDisable);
    Boolean triggerDisbl = triggerDisable.equalsIgnoreCase('True');
    system.debug('@@@triggerDisbl'+triggerDisbl);
    
    if(!triggerDisbl){// For Informatica load CRM-14346
    if (trigger.isInsert || trigger.isUpdate) {
        if(!Test.isRunningTest()) {
            ContactUtil.executeMDBContactUpsertService(trigger.new);
        }
    }
    
    if(trigger.isInsert){
        for(Contact oContact : trigger.new){
            if(oContact.External_ID__c!=null){
                listContact.add(oContact);
            }
        }
        
        //DPS-17684 -commenting below method as Reservation process is not going to be used in Latam Partner Community
        //ContactUtil.validateAccountApprovedReservation(trigger.new);
    }
    
    if(trigger.isUpdate){
    
       for(Contact oContact : trigger.new){
        if(oContact.Email!=trigger.oldmap.get(oContact.Id).Email 
               || oContact.SAP_Email_1__c!=trigger.oldmap.get(oContact.Id).SAP_Email_1__c
               || oContact.WLEC_Email_Address_1__c !=trigger.oldmap.get(oContact.Id).WLEC_Email_Address_1__c 
               || oContact.Title!=trigger.oldmap.get(oContact.Id).Title
               || oContact.Job_Function__c!=trigger.oldmap.get(oContact.Id).Job_Function__c
               || oContact.External_ID__c!=trigger.oldmap.get(oContact.Id).External_ID__c){
            listContact.add(oContact);   
        }
       
    }
    
    }
    
    if(!listContact.IsEmpty()){
        ContactUtil.updateLeadEmail(listContact,trigger.newmap );
    }
          
          
        ContactTriggerHandler oContactTriggerHandler = new ContactTriggerHandler();
       
            
            if(Trigger.IsInsert){
               List<Contact>newcontactList = new List<Contact>();
               for (contact con:Trigger.new){
                    newcontactList.add(con);
               }
               oContactTriggerHandler .addISDCodeToPhone(null,newcontactList);
                LCRMGenericComponent.checkArchiveAccountType(newcontactList);
            }
        
    if(Trigger.IsUpdate){//Added for CRM-13505 by Shovon
        oContactTriggerHandler.trackHistory(Trigger.New, trigger.oldmap);
    }
    }
}