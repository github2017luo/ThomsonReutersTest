global class LCRMLeadShareDelete //implements Database.Batchable<sObject>
{
    // Added this method to cover the code in test class: DPS-14173.
    global LCRMLeadShareDelete(){}
	/* START: DPS-14173 - Commented this Class.
    public String query;
    
    global LCRMLeadShareDelete(){
        query = 'Select Id from LeadShare where Lead.Is_GLI__c = True AND rowcause = \'manual\' AND LastModifiedDate > LAST_WEEK';
    }
    
    global Database.QueryLocator Start(Database.BatchableContext BC){    
     return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        Database.delete(scope, false);
        Database.emptyRecycleBin(scope);
    }
    
    global void finish(Database.BatchableContext bc){
        Id batchJobId = Database.executeBatch(New LCRMTrainingEventShareDelete(), Integer.valueof(Label.LCRM_Delete_Share_Batch_Size.trim()));
    }
	END: DPS-14173 - Commented this Class. */
}