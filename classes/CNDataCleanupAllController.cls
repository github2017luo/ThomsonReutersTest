/**
* {Purpose} – Deletes all the cached relationship records when initiated from the visual force page using a button.
* 				This functionality may be necessary when the regularly scheduled batch job fails for some reason.
*
* @author	Shah Kadirmohideen
* @version	2012-05-03
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-05-03	Shah Kadirmohideen		Created 
* =============================================================================
*/
public with sharing class CNDataCleanupAllController {
	
	
	/* PUBLIC METHODS */
	
	//Delete the entire cache by starting a batch job	
	public void deleteCache() {
		System.debug('trying to abort the data cleanup job if exists');
		CN_App_Settings__c oAppSetup = CNAppUtils.fetchExistingCustomSetting();
		if (oAppSetup != null) {
			CNDataCleanupJob.unscheduleJob(oAppSetup.Data_Cleanup_Job_Id__c);
			oAppSetup.Data_Cleanup_Job_Id__c = null;
			update oAppSetup;
		}
		
		System.debug('invoking cleanup batch apex');
		Database.executeBatch(new CNDataCleanupJob(null, true), CNConstants.DATA_CLEANUP_JOB_BATCH_SIZE);
		
	}
	
	//redirects the control to the App Settings VF page
	public PageReference goBack() {
		return Page.CNAppSettings;
	}
	
	/* PRIVATE METHODS */
	
	
}