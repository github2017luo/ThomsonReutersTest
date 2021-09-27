/*
@Author: Navjyoti Mohanta
@JIRA Story: CRM-8058
@Purpose: This class is for scheduling LCRMBatchForActiveContactEntitlements class.
@Version: 

* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
*                                      
* =============================================================================
*/
global class LCRMScheduledBatchForContactEntitlements implements Schedulable {
   global void execute(SchedulableContext sc) {
      LCRMBatchForActiveContactEntitlements b = new LCRMBatchForActiveContactEntitlements (); 
      database.executebatch(b,200);
   }
}