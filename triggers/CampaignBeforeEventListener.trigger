trigger CampaignBeforeEventListener on Campaign (before Insert,before update,before delete) {
    
         //LTS_5227 : Exclusion framework
        System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
        If(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){
        return;
        }
   
    if(trigger.isUpdate){
        for(Campaign oCampaign : trigger.new){
          if(oCampaign.Offer_Code__c!=trigger.oldmap.get(oCampaign.Id).Offer_Code__c){
              oCampaign.Has_Offer_Code__c = true;
              oCampaign.Has_Offer_Code_TE__c=true;
         }
       }
   }
   
   if(trigger.isInsert){
   
     //set the IsGLI Flag for the Campaign records  
     if(Boolean.valueOf(System.Label.Legal_CRM_Switch) == True){ 
     LCRMGenericComponent.populateSubbu(trigger.new);
     }
   }

}