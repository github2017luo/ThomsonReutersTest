/**
* {Purpose} – Schedules cache cleanup job
*
* @author	Shah Kadirmohideen
* @version	2012-05-01
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-05-01	Shah Kadirmohideen		Created 
* =============================================================================
*/
global class CNDataCleanupJobScheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		System.debug('invoking batch apex');
		Database.executeBatch(new CNDataCleanupJob(null, false), CNConstants.DATA_CLEANUP_JOB_BATCH_SIZE);
	}

}