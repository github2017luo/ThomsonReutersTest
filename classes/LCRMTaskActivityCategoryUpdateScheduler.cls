/**
* Scheduler Class for LCRMTaskActivityCategoryUpdate batch class
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-04-27   TCS                     Created     
* =============================================================================
*/
global class LCRMTaskActivityCategoryUpdateScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new LCRMTaskActivityCategoryUpdate(), 200);
    }
   
   /* CRON expression to schedule job on daily basis to run every 15 mins.
   
    System.schedule('Task Activity Category Update Job 1', '0 0 * * * ?', new LCRMTaskActivityCategoryUpdateScheduler());
    System.schedule('Task Activity Category Update Job 2', '0 15 * * * ?', new LCRMTaskActivityCategoryUpdateScheduler());
    System.schedule('Task Activity Category Update Job 3', '0 30 * * * ?', new LCRMTaskActivityCategoryUpdateScheduler());
    System.schedule('Task Activity Category Update Job 4', '0 45 * * * ?', new LCRMTaskActivityCategoryUpdateScheduler());
   */
}