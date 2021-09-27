/********************************************************************** 
Name: LTS_ToNotifySalesRepSchedulerTest
====================================================== 
Req: Test class for LTS_ToNotifySalesRepScheduler
====================================================== 
Purpose: Test LTS_ToNotifySalesRepScheduler functionality
====================================================== 
History 
------- 
VERSION    AUTHOR           DATE           DETAIL 
1.0        TCS Developer    09/01/2019    Initial Development  
***********************************************************************/
@isTest
public class LTS_ToNotifySalesRepSchedulerTest {
  public static String CRON_EXP = '0 0 0 15 3 ? 2030';
        
  @isTest private static void testScheduler() {
        
      Test.startTest();
 
      // Schedule the test job
      String jobId = System.schedule('Test Job 1',CRON_EXP,
                        new LTS_ToNotifySalesRepScheduler());
    
          
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