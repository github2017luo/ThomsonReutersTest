/*
===============================================================================
 ScheduledBatchable 
===============================================================================

PURPOSE: To Schedule CampaignOfferCodeUpdateonOpp class                   

FUNCTIONALITY: Schedulable interface to Batch class CampaignOfferCodeUpdateonOpp

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
2013-01-08     Nandita          Created

===============================================================================
*/


global class ScheduledCampaignOfferCodeUpdateonOpp implements Schedulable{
//Executing the Batch class OpportunityTriggerUpdate 
   
   global ScheduledCampaignOfferCodeUpdateonOpp(){
      
   }

   global void execute(SchedulableContext sc) {
      CampaignOfferCodeUpdateonOpp oCampaignOfferCodeUpdateonOpp = new CampaignOfferCodeUpdateonOpp();
        database.executeBatch(oCampaignOfferCodeUpdateonOpp);
       
    }

}