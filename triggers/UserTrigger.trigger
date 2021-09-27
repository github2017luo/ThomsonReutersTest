trigger UserTrigger on User (before insert, before Update,after insert,after Update) {
           //DPS-1650: Added asa part of Exclusion framework 
          System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
          If(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){ return;}
            if((Trigger.isInsert || Trigger.IsUpdate) && Trigger.isAfter){
        List<User> uLst = new List<User>();
        for (User u:trigger.new){
            system.debug('user fields'+u.contactid+'**'+u.FederationIdentifier);
            if(u.contactid!=null && u.FederationIdentifier==null){
                uLst.add(u);
                
            }
        }
            if(uLst!=null && uLst.size() >0){
                ESC_UserTriggerHandler.associateFederationId(uLst);
            }
        }

    
        UserTriggerHandler.executeTriggerEvents(trigger.new,trigger.newMap,trigger.oldMap,Trigger.isInsert,
        Trigger.isUpdate,Trigger.isBefore,Trigger.isAfter);  
 

}