/**
* {Purpose} – Test class for CNDataCleanupJob
* 
* @author	Shah Kadirmohideen
* @version	2012-01-26
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date			Name					Description
* 2012-01-26	Shah Kadirmohideen		Created
* 2012-05-03	Shah Kadirmohideen		Added new test method to test CNDataCleanupAllController class      
* =============================================================================
*/
@isTest(seeAllData=true)
private class CNDataCleanupJobTest {
    /**
    * Validates data cleanup job
    */
    @isTest (OnInstall=false)
    private static void test_BatchJob() {
    	//09.15.14 CNUnitTest.initializeCustomSetting();
    	Account oAcct = CNUnitTest.getAccount(true);
    	Contact oCont = CNUnitTest.getContact(oAcct.Id, true);
    	CN_Webservice_Queue__c oQueueExpired = CNUnitTest.getWebserviceQueue(oAcct.Id, null, System.now().addHours(-2), true);  //expire it 2 hours ago.
    	Id colRecTypeId = Schema.SObjectType.CN_Relationship__c.getRecordTypeInfosByName().get('Colleague').getRecordTypeId();
    	CNUnitTest.getRelationships(oQueueExpired.Id, 5, true, colRecTypeId);
    	CN_Webservice_Queue__c oQueueActive = CNUnitTest.getWebserviceQueue(null, oCont.Id, System.now().addHours(2), true);  //active for 2 more hours
    	CNUnitTest.getRelationships(oQueueActive.Id, 5, true, colRecTypeId);
		
		List<Id> listQueueIds = new List<Id>();
		listQueueIds.add(oQueueExpired.Id); 
		listQueueIds.add(oQueueActive.Id);
		
		Test.startTest();
		
		Database.executeBatch(new CNDataCleanupJob(listQueueIds, false), CNConstants.DATA_CLEANUP_JOB_BATCH_SIZE);
		
		Test.stopTest();
		
		System.assertEquals(0, [Select count() from CN_Webservice_Queue__c where Id=:oQueueExpired.Id], 'Expired data is not deleted');
		System.assertEquals(1, [Select count() from CN_Webservice_Queue__c where Id=:oQueueActive.Id], 'Active data is deleted');
    }
    
    /**
    * Validates data cleanup static methods
    */
    @isTest (seeAllData=true)
    private static void test_DataCleanupAllController() {
    	CNUnitTest.initializeCustomSetting();
		
		Test.startTest();
		
		CNDataCleanupAllController oController = new CNDataCleanupAllController();
		oController.deleteCache();
		System.assertNotEquals(null, oController.goBack(), 'Go back functionality not working');
		
		Test.stopTest();
    }
        
    /**
    * Validates data cleanup static methods
    */
    @isTest (seeAllData=true)
    private static void test_OtherMethods() {
    	//09.15.14 CNUnitTest.initializeCustomSetting();
		Test.startTest();
		
		CNDataCleanupJob.runJobNow();
		
		CNConstants.DATA_CLEANUP_JOB_NAME = 'CNDataCleanupJob_' + System.now().format();
		Id jobId = CNDataCleanupJob.scheduleJob();
		System.assertNotEquals(null, jobId, 'Data cleanup job not scheduled');
		
		CNDataCleanupJob.unscheduleJob(jobId);
		
		new CNDataCleanupJob.CNDataCleanupScheduler().execute(null);
		string x = null;
		CNDataCleanupJob.unscheduleJob(x);
		CNDataCleanupJob.runJobNow();
		Test.stopTest(); 
    }	
    	
}