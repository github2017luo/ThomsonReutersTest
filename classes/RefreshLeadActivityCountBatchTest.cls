/**
*	{Purpose} - Test Class for the following classes:
*				- RefreshLeadActivityCountBatch
*
*	CHANGE HISTORY
*	=============================================================================
*	Date		Name				Description
*	20181018	Jason Flippen		Created
*	=============================================================================
**/
@isTest
private class RefreshLeadActivityCountBatchTest {

    /**
    *	{Purpose} - Method to test the batch functionality.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date		Name				Description
    *	20181018	Jason Flippen		Created
    *	=============================================================================
    **/
    private static testMethod void testBatch() {
		
        Map<String,Id> objectRTIdMap = new Map<String,Id>();
        for (RecordType rt : [SELECT Id,
                              		 SObjectType
                              FROM   RecordType
                              WHERE  SObjectType IN ('Lead','Task','Event')
                              AND    DeveloperName IN ('GLI','GLI_Record_Type','GLI_Event_Record_Type')]) {
			objectRTIdMap.put(rt.SObjectType, rt.Id);
		}
        
        // Insert a test Lead.
        Id leadRTId = objectRTIdMap.get('Lead');
        Lead testLead = new Lead(RecordTypeId = leadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked',
                                 Is_GLI__c = true);
        insert testLead;
        
        // Insert a test Task.
        Id taskRTId = objectRTIdMap.get('Task');
        Task testTask = new Task(RecordTypeId = taskRTId,
                                 WhoId = testLead.Id,
                                 ActivityDate = Date.today(),
                                 LCRM_Activity_Type__c = 'Email Outbound',
                                 Activity_Category__c = 'Follow Up',
                                 Subject = 'Task',
                                 Priority = 'Normal',
                                 Status = 'Completed');
        insert testTask;
        
        // Insert a test Event.
        Id eventRTId = objectRTIdMap.get('Event');
        Event testEvent = new Event(RecordTypeId = eventRTId,
                                    WhoId = testLead.Id,
                                    ActivityDate = Date.today(),
                                    LCRM_Activity_Type__c = 'In Person',
                                    Activity_Category__c = 'Business Review',
                                    StartDateTime = DateTime.now(),
                                    EndDateTime = DateTime.now(),
                                    Subject = 'Event',
                                    Status__c = 'Completed');
        insert testEvent;
        
        GLI_Load_Tracker__c gliLoadTracker = new GLI_Load_Tracker__c();
        gliLoadTracker.Name = 'Lead Completed Activity Count';
        insert gliLoadTracker;

        Test.startTest();
			
        	// Execute the batch job.
        	RefreshLeadActivityCountBatch refreshBatch = new RefreshLeadActivityCountBatch();
        	Database.executeBatch(refreshBatch,100);
        	
        Test.stopTest();
        
        // Check the Completed Activity Count field to verify the batch job worked.
        Lead updatedLead = [SELECT Id, Completed_Activity_Count__c FROM Lead WHERE Id = :testLead.Id];
		System.assertEquals(2, updatedLead.Completed_Activity_Count__c);
        
    } // End Method: testBatch()
    
}