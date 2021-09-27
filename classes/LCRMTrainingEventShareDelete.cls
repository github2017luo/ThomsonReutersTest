/**
* Class for deleting Training Event Share records which are created by clicking on 'Show All BU Info' button
*
* @author  Saloni Sukhija
* @version 2017-06-23
*/

global class LCRMTrainingEventShareDelete //implements Database.Batchable<sObject>
{
    // Added this method to cover the code in test class: DPS-14173.
    global LCRMTrainingEventShareDelete(){} 
	/* START: DPS-14173 - Commented this Class.
    public String query;
    
    global LCRMTrainingEventShareDelete(){
        query = 'Select Id from Training_Event__Share where Parent.LCRM_Is_GLI__c = True AND rowcause = \'manual\' AND LastModifiedDate > LAST_WEEK';
    }
    
    global Database.QueryLocator Start(Database.BatchableContext BC){    
     return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        Database.delete(scope, false);
        Database.emptyRecycleBin(scope);
    }
    
    global void finish(Database.BatchableContext bc){
    
    }
	END: DPS-14173 - Commented this Class. */
}