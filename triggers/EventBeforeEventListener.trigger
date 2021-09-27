trigger EventBeforeEventListener on Event(before delete, before insert, before update) {

//LTS_6301 : Exclusion framework
System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
return;
    
    
    if(trigger.isInsert){
        //EventUtil.PopulateSubBuonActivity(trigger.new);
        if(Boolean.valueOf(System.Label.Legal_CRM_Switch) == True){ 
        LCRMGenericComponent.populateSubbu(trigger.new);//tejas code to update subbu
        }
          
        if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()) 
         {
           LCRMGenericComponent.populatebuRegionSegmentLotus(trigger.new);
         }
        
    }
    if(trigger.isUpdate || trigger.isInsert){
      /*  for(Task oTask : trigger.new){
            if(oTask.OwnerId!=trigger.oldmap.get(oTask.Id).OwnerId){
               listTask.add(oTask);
               
            }
        }*/
     EventUtil.updateEventOwnerGroup(trigger.new);
    /* for(Event e : Trigger.new) { 
    if(trigger.isInsert){ 
        e.LCRM_Activity_Type__c = 'In Person';
        e.Activity_Category__c = 'Initial Appointment';
        }
        //add multiple Task field assignment from Account  

    } */
    }
    
}