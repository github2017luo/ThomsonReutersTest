/**
* Test Class for LCRMTaskActivityCategoryUpdateScheduler Scheduler class
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-04-27   TCS                     Created     
* =============================================================================
*/
@isTest
public class LCRMTaskActCategoryUpdateScheduler_Test {

    // CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2030';
        
  private static testMethod void testScheduler() {
        
      Test.startTest();
 
      // Schedule the test job
      String jobId = System.schedule('Test Task Activity Category Update Job 1',
                        CRON_EXP,
                        new LCRMTaskActivityCategoryUpdateScheduler());
          
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];
 
      // Verify the expressions are the same
      System.assertEquals(CRON_EXP,
         ct.CronExpression);
 
      // Verify the job has not run
      // Verify the next time the job will run
      System.assertEquals('2030-03-15 00:00:00',String.valueOf(ct.NextFireTime));
  
      Test.stopTest();

  }

}