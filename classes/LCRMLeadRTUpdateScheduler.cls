/**
* Scheduler Class for LCRMLeadRTUpdate batch class
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-04-27   TCS                     Created     
* =============================================================================
*/
global class LCRMLeadRTUpdateScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new LCRMLeadRTUpdate(), 200);
    }
   
   /* CRON expression to schedule job on daily basis to run every 15 mins.
   
    System.schedule('Lead RecordType Update Job 1', '0 0 * * * ?', new LCRMLeadRTUpdateScheduler());
    System.schedule('Lead RecordType Update Job 2', '0 15 * * * ?', new LCRMLeadRTUpdateScheduler());
    System.schedule('Lead RecordType Update Job 3', '0 30 * * * ?', new LCRMLeadRTUpdateScheduler());
    System.schedule('Lead RecordType Update Job 4', '0 45 * * * ?', new LCRMLeadRTUpdateScheduler());
   */
}