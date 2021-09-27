trigger UserLicenseActivationLogTriggers on User_License_Activation_Log__c (before update) 
{
	// check if the triggers by passed and if not then run them. This comes from the custom setting - License Manager Settings
	if(License_Manager_Settings__c.getOrgDefaults().Bypass_Triggers__c == false)
	{
		// trigger to deactivate the user when deactivation datetime is reached
		UserLicenseActivationLogTriggerMethods.onDeactivationDateReached(trigger.oldMap, trigger.newMap);
	}
}