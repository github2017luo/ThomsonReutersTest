/*
===============================================================================
 ScheduledBatchable 
===============================================================================

PURPOSE: To Schedule OpptyRenewalCancellation_Batch class                   

FUNCTIONALITY: Schedulable interface to Batch class OpptyRenewalCancellation_Batch 

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
28/8/2017      Radhika          Created
//cron Expression : system.schedule('Oppty RenewalCancellation batch', '0 0 0 * * ?', new OpptyRenewalCancellationBatch_Scheduler());
===============================================================================
*/
global class OpptyRenewalCancellationBatch_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
        OpptyRenewalCancellation_Batch renewCancelOppty = new OpptyRenewalCancellation_Batch();
        Database.executeBatch(renewCancelOppty,200);           
    }
}