/**
*	{Purpose} - Class to refresh the Activity Count field on GLI Leads that
*				haven't been converted.
*
*				Test code coverage provided by the following class:
*				- RefreshLeadActivityCountBatchTest
*
*	CHANGE HISTORY
*	=============================================================================
*	Date			Name					Description
*	20181018		Jason Flippen			Created
*	=============================================================================
**/
global class RefreshLeadActivityCountBatch implements Database.Batchable<sObject>, Database.Stateful {
	
    private static final String STATUS_COMPLETED = 'Completed';    
    
    /**
    *	{Purpose} - Method to return a List of Lead records.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date			Name					Description
    *	20180918		Jason Flippen			Created
    *	=============================================================================
    **/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String queryString = 'SELECT Id,' +
            				 '       Lead__c ' +
            				 'FROM   Lead_Activity_Count_Stage__c';
        
        return Database.getQueryLocator(queryString);
        
    }
    
    /**
    *	{Purpose} - Method to process the List of Lead records.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date			Name					Description
    *	20180918		Jason Flippen			Created
    *	=============================================================================
    **/
    global void execute(Database.BatchableContext BC, List<Lead_Activity_Count_Stage__c> lacsList) {
        
        // Grab the Set of Ids from the LeadActivityCountStage records.
        Set<Id> leadIdSet = new Set<Id>();
        for (Lead_Activity_Count_Stage__c lacs : lacsList) {
			leadIdSet.add(lacs.Lead__c);
        }
        
        if (!leadIdSet.isEmpty()) {
            
            // Iterate through the List of Leads and grab
            // the List of records to be updated.
            List<Lead> updateLeadList = new List<Lead>();
            for (Lead l : [SELECT Completed_Activity_Count__c,
                           		  (SELECT Id FROM Tasks WHERE Status = :STATUS_COMPLETED),
                           		  (SELECT Id FROM Events WHERE Status__c = :STATUS_COMPLETED)
                           FROM   Lead
                           WHERE  Id IN :leadIdSet
                           AND    Is_GLI__c = true
						   AND    IsConverted = false]) {
                
                // Get the Task count for this Lead.
                Integer taskCount = l.Tasks.size();
                
                // Get the Event count for this Lead.
                Integer eventCount = l.Events.size();
                
                // Update the Completed Activity Count field on the
                // Lead and add it to the update List, if applicable.
                Integer activityCount = (taskCount + eventCount);
                if (l.Completed_Activity_Count__c != activityCount) {
                    l.Completed_Activity_Count__c = activityCount;
                    updateLeadList.add(l);
                }
                
            }
            
            // If we have records to update, update them.
            if (!updateLeadList.isEmpty()) {
                
                try {
					
					// Update the List of related Leads.
                    update updateLeadList;
        			
                    // Delete the List of LeadActivityCountStage
                    // records that were processed.
                    delete lacsList;
                    
                }
                catch (Exception ex) {
                    
                    // Log the error
                    String errorPoint = 'RefreshLeadActivityCountBatch.execute()';
                    String errorMessage = ex.getMessage();
                    TR_Retention__Error_Log__c newErrorLog = new TR_Retention__Error_Log__c(TR_Retention__Error_Point__c = errorPoint,
                                                                                            TR_Retention__Error_Message__c = errorMessage);
                    insert newErrorLog;
				
                }
                
            } // End If (!updateLeadList.isEmpty())
            
        } // End If (!leadIdSet.isEmpty())
        
    }
    
    /**
    *	{Purpose} - Method to do post-processing tasks (if necessary).
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date			Name					Description
    *	20180918		Jason Flippen			Created
    *	=============================================================================
    **/
    global void finish(Database.BatchableContext BC) {
        
        GLI_Load_Tracker__c gliLoadTracker = [SELECT Id,
                                              		 JobCompletedDate__c
                                              FROM   GLI_Load_Tracker__c
                                              WHERE  Name = 'Lead Completed Activity Count'];
        
        gliLoadTracker.JobCompletedDate__c = Datetime.now();
        Update gliLoadTracker;
        
    }
    
}