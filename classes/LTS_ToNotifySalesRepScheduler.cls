/********************************************************************** 
Name: LTS_ToNotifySalesRepScheduler
====================================================== 
Req: Scheduler class to schedule 'LTS_BatchToNotifySalesRepForOpportunity' batch class
====================================================== 
Purpose: To schedule class 
====================================================== 
History 
------- 
VERSION    AUTHOR           DATE           DETAIL 
1.0        TCS Developer    09/01/2019    Initial Development  
***********************************************************************/
global without sharing class  LTS_ToNotifySalesRepScheduler implements Schedulable{
    
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new LTS_BatchToNotifySalesRepForOpportunity(), 200);
    }

}