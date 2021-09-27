global class LCRMCaseShareDelete // implements Database.Batchable<sObject>
{
    // Added this method to cover the code in test class: DPS-14173.
    global LCRMCaseShareDelete(){}
	/* START: DPS-14173 - Commented this Class.
    public String query;
    
    global LCRMCaseShareDelete(){
        query = 'Select Id From CaseShare Where rowcause = \'Manual\' AND (Case.Account.Is_GLI__c = True OR Case.Contact.LCRM_Is_GLI__c = True) AND LastModifiedDate > LAST_WEEK';
    }
    
    global Database.queryLocator Start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Database.delete(scope, false);
        Database.emptyRecycleBin(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        Id batchJobId = Database.executeBatch(New LCRMOpportunityShareDelete(), Integer.valueof(Label.LCRM_Delete_Share_Batch_Size.trim()));
    }
	START: DPS-14173 - Commented this Class. */	
}