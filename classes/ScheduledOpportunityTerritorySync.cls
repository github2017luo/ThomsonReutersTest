/*
===============================================================================
 ScheduledBatchable 
===============================================================================

PURPOSE: To Schedule OpportunityTerritorySync class                   

FUNCTIONALITY: Schedulable interface to Batch class OpportunityTerritorySync

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
2012-10-10      Nandita          Created

===============================================================================
*/


global without sharing class ScheduledOpportunityTerritorySync implements Schedulable{
//Executing the Batch class OpportunityTriggerUpdate 
   global void execute(SchedulableContext sc) {
      OpportunityTerritorySync oOpportunityTerritorySync= new OpportunityTerritorySync();
        database.executeBatch(oOpportunityTerritorySync);
    }

}