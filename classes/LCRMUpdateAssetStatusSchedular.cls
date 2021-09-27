/**
* Schedular class for LCRMUpdateAssetStatus
*
* @author  Saloni Sukhija
* @version 2017-08-18
*/

global Class LCRMUpdateAssetStatusSchedular implements Schedulable
{
    global void execute(SchedulableContext sc)
    {        
        Database.executeBatch(New LCRMUpdateAssetStatus(), Integer.valueOf(LCRM_BatchSize__c.getOrgDefaults().LCRM_UpdateAssetStatus__c.trim()));
    }
}