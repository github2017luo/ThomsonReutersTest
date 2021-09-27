/**************************************************************************************
/*
Version     : 1.0 
Name		: UserLicenseActivationLogTriggerMethods
Function    : User License Activation Trigger Helper Implementation
*/
/**************************************************************************************/

public with sharing class UserLicenseActivationLogTriggerMethods 
{
	/*
    * Method name  : onDeactivationDateReached
    * Description  : Function to handle the deactivation of log record
    * Return Type  : none
    * Parameter    : map of old UserLicenseActivationLog, map of new UserLicenseActivationLog  
    */
	public static void onDeactivationDateReached(Map<Id, User_License_Activation_Log__c> mapOldUserLicenseActivationLogs, Map<Id, User_License_Activation_Log__c> mapNewUserLicenseActivationLogs)
	{
		if(mapNewUserLicenseActivationLogs != null && !mapNewUserLicenseActivationLogs.isEmpty())
		{
			Map<Id,User_License_Activation_Log__c> mapUserLogs = new Map<Id,User_License_Activation_Log__c>();
			
			for(User_License_Activation_Log__c userLicenseActivationLog : mapNewUserLicenseActivationLogs.values())
			{
				// check if log is marked as Deactivated. This is set using the time based workflow when Deactivation Date is reached
				if(userLicenseActivationLog.Deactivate_User__c == true && mapOldUserLicenseActivationLogs.get(userLicenseActivationLog.Id).Deactivate_User__c == false)
				{
					mapUserLogs.put(userLicenseActivationLog.User__c, userLicenseActivationLog);
				}
			}
			
			// check if any log records are found marked as deactivated
			if(!mapUserLogs.isEmpty())
			{
				Set<Id> allUserIds = mapUserLogs.keySet();
				Set<Id> usedIdsToDeactivate = new Set<Id>();
				Set<Id> userIdsToSkipDeactivation = new Set<Id>();

                System.debug('## allUserIds : ' + allUserIds);
				
				// retrieve the custom settings for the License Manager app
				License_Manager_Settings__c settings = License_Manager_Settings__c.getOrgDefaults();
				String objectsToMonitor = settings.Objects_to_Monitor__c; 
				Integer monitoringTimePeriod = settings.Monitoring_Time_Period_in_min__c != null ? Integer.valueOf(settings.Monitoring_Time_Period_in_min__c) : 0;
				Integer deactivationSlideOut = settings.Deactivation_Slide_out_in_min__c != null ? Integer.valueOf(settings.Deactivation_Slide_out_in_min__c) : 0;
				
				// Objects to monitor is a list of objects that are to be checked for user activity. 
				// If any record is modified by the user in last X time period (Monitoring_Time_Period_in_min__c), then deactivation should be skipped.
				// Instead the deactivation should be slided out by X minutes (Deactivation_Slide_out_in_min__c)
				if(objectsToMonitor != null && objectsToMonitor != '')
				{
					List<String> lstObjectsToMonitor = objectsToMonitor.split(',');
					
					if(lstObjectsToMonitor != null && lstObjectsToMonitor.size() > 0)
					{
						string dtLastTouched = Datetime.now().addMinutes(-1 * (monitoringTimePeriod)).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'.000Z\'');

						// loop through all objects to be monitored
						for(String objectToMonitor : lstObjectsToMonitor)
						{	
							System.debug('## objectToMonitor : ' + objectToMonitor);
							
							string soql = 'Select Id, LastModifiedById from ' + objectToMonitor + ' where LastModifiedDate > ' + dtLastTouched + ' and LastModifiedById in :allUserIds limit 50000';
							
                            List<SObject> lstSObject = Database.query(soql);
							
							System.debug('## lstSObject : ' + lstSObject);
							
							if(lstSObject != null && lstSObject.size() > 0)
							{
								for(SObject obj : lstSObject)
								{
									Id lastModifiedById = (Id)(obj.get('LastModifiedById'));
									
									if(allUserIds.contains(lastModifiedById) && !userIdsToSkipDeactivation.contains(lastModifiedById))
									{
										userIdsToSkipDeactivation.add(lastModifiedById);
									}
								}
							}
						}
					}
				}
								
				for(Id userId : allUserIds)
				{
					// for all users that need to skip deactivation, reset the deactivation flag and time on the log record
					if(userIdsToSkipDeactivation.contains(userId))
					{
						mapUserLogs.get(userId).Deactivate_User__c = false;
						mapUserLogs.get(userId).Deactivation_Date__c = mapUserLogs.get(userId).Deactivation_Date__c.addMinutes(deactivationSlideOut);
                        mapUserLogs.get(userId).Status__c = 'Deactivation Delayed';
					}
					else
					{
						// users to deactivate
						mapUserLogs.get(userId).Status__c = 'Deactivated';
					}
				}	
			}
		}
	}    
}