/**
* Scheduler Class for LCRMEventActivityCategoryUpdate batch class
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-04-27   TCS                     Created     
* =============================================================================
*/
global class LCRMEventActivityCategoryUpdateScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new LCRMEventActivityCategoryUpdate(), 200);
    }
   
   /* CRON expression to schedule job on daily basis to run every 15 mins.
   
    System.schedule('Event Activity Category Update Job 1', '0 0 * * * ?', new LCRMEventActivityCategoryUpdateScheduler());
    System.schedule('Event Activity Category Update Job 2', '0 15 * * * ?', new LCRMEventActivityCategoryUpdateScheduler());
    System.schedule('Event Activity Category Update Job 3', '0 30 * * * ?', new LCRMEventActivityCategoryUpdateScheduler());
    System.schedule('Event Activity Category Update Job 4', '0 45 * * * ?', new LCRMEventActivityCategoryUpdateScheduler());
   */
}