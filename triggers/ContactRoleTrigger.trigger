trigger ContactRoleTrigger on OpportunityContactRole (After insert) {
     /*
        Contact” Records that are “Contact Roles” of an “Opportunity” Record will have its “Contact Group” Field with the “Sales Contact” Picklist Value.
        JIRA#DPS-6437
        Developed By: TCS Developer
        Date: 05-11-2019
    */
    If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
    return;

    system.debug('Testing');
     if(trigger.isInsert){
            ContactRoleTriggerHandler.updateContactGroup(trigger.new);
        }
        
      
}