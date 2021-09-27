/*
===============================================================================
 ScheduledBatchable 
===============================================================================

PURPOSE: To Schedule CampaignOfferCodeUpdateonTE class                   

FUNCTIONALITY: Schedulable interface to Batch class CampaignOfferCodeUpdateonTE

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
2013-01-11      Nandita          Created

===============================================================================
*/


global class ScheduledCampaignOfferCodeUpdateonTE implements Schedulable{
//Executing the Batch class OpportunityTriggerUpdate 
   
   global ScheduledCampaignOfferCodeUpdateonTE(){
      
   }

   global void execute(SchedulableContext sc) {
      CampaignOfferCodeUpdateonTE oCampaignOfferCodeUpdateonTE = new CampaignOfferCodeUpdateonTE();
        database.executeBatch(oCampaignOfferCodeUpdateonTE );
    }

}