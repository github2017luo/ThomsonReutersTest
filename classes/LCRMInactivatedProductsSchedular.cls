/**
* Schedular class for LCRMNotificationforInactivatedProducts
*
* @author  Saloni Sukhija
* @version 2017-08-27
*/

global without sharing Class LCRMInactivatedProductsSchedular implements Schedulable //Removing Sonar Qube Violation
{
    global void execute(SchedulableContext sc)
    {        
        Database.executeBatch(New LCRMNotificationforInactivatedProducts(),  Integer.valueOf(LCRM_BatchSize__c.getOrgDefaults().LCRM_NotifyOpportunityTeam__c.trim()));
    }
}