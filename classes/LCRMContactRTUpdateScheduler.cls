/**
* Scheduler Class for LCRMContactRTUpdate batch class
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-04-27   TCS                     Created     
* =============================================================================
*/
global class LCRMContactRTUpdateScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new LCRMContactRTUpdate(), 200);
    }
   
   /* CRON expression to schedule job on daily basis to run every 15 mins.
   
    System.schedule('Contact RecordType Update Job 1', '0 0 * * * ?', new LCRMContactRTUpdateScheduler());
    System.schedule('Contact RecordType Update Job 2', '0 15 * * * ?', new LCRMContactRTUpdateScheduler());
    System.schedule('Contact RecordType Update Job 3', '0 30 * * * ?', new LCRMContactRTUpdateScheduler());
    System.schedule('Contact RecordType Update Job 4', '0 45 * * * ?', new LCRMContactRTUpdateScheduler());
   */
}