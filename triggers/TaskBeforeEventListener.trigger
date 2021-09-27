trigger TaskBeforeEventListener on Task (before delete, before insert, before update) {
    
    //LTS_6268 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
    
    if(trigger.isUpdate || trigger.isInsert){

        if(trigger.isBefore && trigger.isInsert){
             if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser()) 
            {
                LCRMGenericComponent.populatebuRegionSegmentLotus(trigger.new);
}
        }
       
       //Updated for CRM-6244 & CRM-6243
        if(!IncentivePasswordController.sendEmailcheck){
            if(!IncentivePasswordControllerOpty.sendEmailcheck){
            
                TaskUtil.updateTaskOwnerGroup(trigger.new);
                }
            
            
        }
        
        
        
    }
    
    if(trigger.IsInsert){
    //Harika -Moved the whole logic into TaskUtil class as per EQA Comments
    TaskUtil.beforeinsertmethod(trigger.new);
    }
}