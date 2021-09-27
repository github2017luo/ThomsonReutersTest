/**
* {Purpose} – Deletes the cached relationship records when they meet one of the following two conditions:
*				1. Record expired based on the expiry date on web service queue record
*				2. Total relationship records size (2KB per record) exceeded the maximum allowed cap configured on custom setting. If this condition is met,
*						the oldest records are deleted first until the cap is met.
*				This job runs once every hour.
*
* @author	Shah Kadirmohideen
* @version	2012-01-26
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-01-26	Shah Kadirmohideen		Created 
* 2012-05-01	Shah Kadirmohideen		Fixed scheduling related issue. Allowed functionality to delete all records without any condition.     
* 2012-07-16	Shah Kadirmohideen		Enhanced error handling
* 2012-09-30	Shah Kadirmohideen		Used a new error handling method from CNAppUtils class 
* 2012-10-05	Shah Kadirmohideen		Enhanced exception handling using handleException() method
* =============================================================================
*/
global class CNDataCleanupJob implements Database.Batchable<SObject>, Database.Stateful {

	/* PRIVATE VARIABLES */
	 
	private Long lNonExpiredRelationships = 0;  //record count
	private Integer iMaxRecordsAllowedToKeep;  
	private Integer i80PercentRecordsAllowedToKeep;
	private List<Id> listQueueIds;
	private List<Id> list20PercentQueueIds = new List<Id>();
	private Long lTotalRecordsDeleted = 0;
	private Boolean deleteAll = false;
	private static final String sClassName = 'CNDataCleanupJob';
			
	/* CONSTRUCTORS */
	
	public CNDataCleanupJob(List<Id> listQueueIds, Boolean deleteAll) {
		System.debug('invoking cleanup job constructor');
		this.listQueueIds = listQueueIds;
		this.deleteAll = deleteAll;
	}
	
	/* GLOBAL METHODS */
		
	//Prepares the initial query for the batch job
	global Database.QueryLocator start(Database.BatchableContext bc){ 
        System.debug('start');
        
        calculateMaxRecordsAllowedTokeep();
	        
        //Desending soring based on CreatedDate is important so that the oldest records will appear at the bottom for priority deletion 
       	String sQuery = 'Select Id, Total_Colleague_Relationships__c, Total_Contact_Relationships__c, Expiration_Date__c ' +
       				'from CN_Webservice_Queue__c ';
		if (listQueueIds != null) {
			sQuery += ' where Id in :listQueueIds ';
		}       				
       	sQuery += 'order by CreatedDate desc';
        System.debug('sQuery: ' + sQuery);
        
        return Database.getQueryLocator(sQuery); 
	} 
    	
   	//Main logic goes here. This method is called multiple times based on the batch size.
	global void execute(Database.BatchableContext bc, List<SObject> rows){
		System.debug('input rows: ' + rows.size() + ', data: ' + rows);
       	List<CN_Webservice_Queue__c> listQueues = (List<CN_Webservice_Queue__c>) rows;
       	List<Id> listQueuesToDelete = new List<Id>();

       	for (CN_Webservice_Queue__c oQueue : listQueues) {
       		System.debug('oQueue: ' + oQueue);
       		if (deleteAll == false) {
	       		if (lNonExpiredRelationships > i80PercentRecordsAllowedToKeep && lNonExpiredRelationships <= iMaxRecordsAllowedToKeep) {
	       			System.debug('adding record to list20PercentQueueIds');
	       			this.list20PercentQueueIds.add(oQueue.Id);
	       		}
	       		
	       		if (oQueue.Expiration_Date__c <= System.now()) {
	       			System.debug('adding record to listQueuesToDelete');
	       			listQueuesToDelete.add(oQueue.Id);
	       		}
	       		else {
	       			Integer iQueueRelationshipCount = oQueue.Total_Colleague_Relationships__c.intValue() + oQueue.Total_Contact_Relationships__c.intValue() + 1;
	       			if ((lNonExpiredRelationships + iQueueRelationshipCount) > iMaxRecordsAllowedToKeep) {
	       				System.debug('adding record to listQueuesToDelete');
	       				listQueuesToDelete.add(oQueue.Id);
	       			}
	       			else {
	       				lNonExpiredRelationships += iQueueRelationshipCount;
	       			}
	       		}
       		}
       		else {
       			listQueuesToDelete.add(oQueue.Id);
       		}
       	}	
       	
       	System.debug('listQueuesToDelete: ' + listQueuesToDelete.size());
       	if (listQueuesToDelete.size() > 0) {
       		deleteCache(listQueuesToDelete);  //performs cascade deletion on child records (CN_Relationship__c)
       		
       		System.debug('list20PercentQueueIds: ' + list20PercentQueueIds.size());
       		if (list20PercentQueueIds.size() > 0) {
       			deleteCache(list20PercentQueueIds);
       			list20PercentQueueIds.clear();
       		}
       	}
   	}
   	
   	//Method which is executed towards the end of the job.
   	global void finish(Database.BatchableContext bc){
   	 	System.debug('Total records deleted from cache: ' + lTotalRecordsDeleted);
   	 	
   	 	if (deleteAll) {
   	 		CN_App_Settings__c oAppSetup = CNAppUtils.fetchExistingCustomSetting();
			oAppSetup.Data_Cleanup_Job_Id__c = CNDataCleanupJob.scheduleJob();
			if (oAppSetup.Data_Cleanup_Job_Id__c != null) {
				oAppSetup.Enable_Data_Cleanup_Job__c = true;
				update oAppSetup;   	 	
			}
		}

		CNAppUtils.CleanAuditLog(); //2014-09-10 Sarbello - Removes expired records from CN_Audit_Log__c
   	 }

	 /* PUBLIC STATIC METHODS */
	
	 //Schedules data clean up job to run once every hour.
	 public static Id scheduleJob() {
	 	try {
	 		System.debug('scheduling the job to run once every hour'); 
			return System.schedule(CNConstants.DATA_CLEANUP_JOB_NAME, '0 0 0-23 ? JAN-DEC MON-SUN', new CNDataCleanupJobScheduler());
	 	}
	 	catch (Exception e) {
	 		System.debug(e);
	 		return null;
	 	}
	}    
	
	 //Removes the data clean up job from the apex scheduler
	 public static void unscheduleJob(Id jobId) {
	 	try {
	 		if (jobId != null) {
				System.abortJob(jobId);
	 		}
	 	} 
	 	catch (Exception e) {
	 		System.debug(e);
	 		//ignore the error
	 	}
	 }
  	
  	 //Runs the job now instead of scheduling it for a future run
  	 public static void runJobNow() {
  		Database.executeBatch(new CNDataCleanupJob(null, false), CNConstants.DATA_CLEANUP_JOB_BATCH_SIZE);
  	 }
  	
   	 /* PRIVATE METHODS */
 
	 //Based on custom setting configuration, converts the max storage size (MB) into max records count allowed.
	 private void calculateMaxRecordsAllowedTokeep() {
	 	this.iMaxRecordsAllowedToKeep = CNAppUtils.getAppCustomSetting().Max_Data_Storage__c.intValue() * 1000 / 2;
	 	System.debug('iMaxRecordsAllowedToKeep: ' + iMaxRecordsAllowedToKeep);
	 	this.i80PercentRecordsAllowedToKeep = Integer.valueOf(this.iMaxRecordsAllowedToKeep * .80);
	 	System.debug('i80PercentRecordsAllowedToKeep: ' + i80PercentRecordsAllowedToKeep);
	 }
	 
	 //Deletes a set of queue records
	 private void deleteCache(List<Id> listQueuesToDelete) {
	 	Boolean errorFound = false;
	 	try {
	 		System.debug('Perform soft delete on queue records: ' + listQueuesToDelete.size());
	 		Database.delete(listQueuesToDelete);
	 		this.lTotalRecordsDeleted += listQueuesToDelete.size(); 
	 	}
	 	catch (Exception oException) {
	 		System.debug('error: ' + oException);
	 		errorFound = true;  
	 		
	 		String sMoreInfo = CNAppUtils.concatenateList(listQueuesToDelete, ', '); 
			CNAppUtils.handleException(new CNData.CNExceptionInfo(oException, ApexPages.Severity.ERROR, 
					sClassName, 'listQueuesToDelete()',
					sMoreInfo, false, true, 'Soft Deletion of Expired Cache Data'));
	 	}
		
		if (errorFound == false) {
		 	try {
		 		//Perform hard delete
		 		Database.emptyRecycleBin(listQueuesToDelete);
		 	}
		 	catch (Exception oException) {
		 		System.debug('error: ' + oException);
		 		String sMoreInfo = CNAppUtils.concatenateList(listQueuesToDelete, ', '); 
				CNAppUtils.handleException(new CNData.CNExceptionInfo(oException, ApexPages.Severity.ERROR, 
						sClassName, 'listQueuesToDelete()',
						sMoreInfo, false, true, 'Empty Recycle Bin'));
		 	}
		}
	 }
	 
	/* INNER CLASSES */
	
	/**
	*	Schedules the data clean up batch apex class
	*/
	global class CNDataCleanupScheduler implements Schedulable {
		global void execute(SchedulableContext sc) {
			//System.debug('invoking batch apex');
			//Database.executeBatch(new CNDataCleanupJob(null), CNConstants.DATA_CLEANUP_JOB_BATCH_SIZE);
		}
	}
}