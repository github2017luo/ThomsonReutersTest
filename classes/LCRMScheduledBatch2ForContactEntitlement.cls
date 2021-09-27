/*
@Author: Navjyoti Mohanta
@JIRA Story: CRM-8058
@Purpose: This class is for scheduling LCRMBatch2ForActiveContactEntitlements class.
@Version: 

* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
*                                      
* =============================================================================
*/
global class LCRMScheduledBatch2ForContactEntitlement implements Schedulable {
   global void execute(SchedulableContext sc) {
      LCRMBatch2ForActiveContactEntitlements b = new LCRMBatch2ForActiveContactEntitlements (); 
      database.executebatch(b,200);
   }
}