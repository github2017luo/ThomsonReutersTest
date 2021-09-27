/*
===============================================================================
 ScheduledBatchable 
===============================================================================

PURPOSE: To Schedule OpportunityTriggerUpdate class                   

FUNCTIONALITY: Schedulable interface to Batch class OpportunityTriggerUpdate 

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
2011-08-29      Nandita          Created

===============================================================================
*/


global without sharing class ScheduledOpportunityTerritoryUpdate implements Schedulable{
//Executing the Batch class OpportunityTriggerUpdate 
   global void execute(SchedulableContext sc) {
      OpportunityTerritoryUpdate oOpportunityTerritoryUpdate = new OpportunityTerritoryUpdate();
        database.executeBatch(oOpportunityTerritoryUpdate);
    }

}