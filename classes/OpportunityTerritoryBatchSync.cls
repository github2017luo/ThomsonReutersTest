/*
======================================================================================================================
CLASS NAME:   OpportunityTerritoryBatchSync
======================================================================================================================
=
PURPOSE:To update the all Opportunity Territory Id with active Territory Ids

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
31-03-2017        Gunaseelan K            <Optimized the code as per JIRA STORY: PS0-1>
======================================================================================================================
*/
global without sharing class OpportunityTerritoryBatchSync implements Database.Batchable<sObject>
{
    global OpportunityTerritoryBatchSync() {
    }
    global Database.Querylocator start(Database.BatchableContext bcContext) {
	    return Database.getQueryLocator([SELECT Id, Name, CloseDate, OwnerId, AccountId,is_GLI__c, Territory2Id FROM Opportunity]);
    } 
    global void execute(Database.BatchableContext bcContext, List<sObject> listOpportunities)
    {
		if (listOpportunities != null && !listOpportunities.isEmpty()) {
			OpportunityTriggerHandler.updateOptyTerritory(listOpportunities);
			update listOpportunities;
		}
    } 
    global void finish(Database.BatchableContext bcContext) {}
}