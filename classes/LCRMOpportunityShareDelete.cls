global class LCRMOpportunityShareDelete //implements Database.Batchable<sObject>
{
    // Added this method to cover the code in test class: DPS-14173.
    global LCRMOpportunityShareDelete(){}
    /* START: DPS-14173 - Commented this Class.
    public String query;
    
    global LCRMOpportunityShareDelete(){
        query = 'Select Id, OpportunityId, UserOrGroupId From OpportunityShare Where Opportunity.Is_GLI__c = True AND rowcause = \'Manual\' AND LastModifiedDate > LAST_WEEK';    
    }
    
    global Database.QueryLocator Start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        /*
        //old code
        Database.delete(scope, false);
        Database.emptyRecycleBin(scope);
        // removed closed multi line comment at this line.
        List<OpportunityShare> oppShareList = scope;
        Set<String> userIdSet = new Set<String>();
        Set<String> oppIdSet = new Set<String>();
        for(OpportunityShare oppShare : oppShareList){
            userIdSet.add(oppShare.UserOrGroupId);
            oppIdSet.add(oppShare.OpportunityId);
        }
        List<OpportunityShare> oppShareList2 = new List<OpportunityShare>();
        try{
            oppShareList2 = [Select Id, OpportunityId, UserOrGroupId From OpportunityShare Where Opportunity.Is_GLI__c = True AND rowcause = 'Team' AND (OpportunityId IN :oppIdSet OR UserOrGroupId IN :userIdSet) AND LastModifiedDate > LAST_WEEK];
        }catch(Exception e){}
        Set<String> userOppSet = new Set<String>();
        if(oppShareList2 != null && oppShareList2.size() > 0){
            for(OpportunityShare oppShare : oppShareList2){
                userOppSet.add(oppShare.OpportunityId + ':' + oppShare.UserOrGroupId);
            }
        }
        List<OpportunityShare> oppShareDelList = new List<OpportunityShare>();
        for(OpportunityShare oppShare : oppShareList){
            if(!userOppSet.contains(oppShare.OpportunityId + ':' + oppShare.UserOrGroupId)){
                oppShareDelList.add(oppShare);
            }
        }
        if(oppShareDelList != null && oppShareDelList.size() > 0){
            Database.delete(oppShareDelList, false);
            Database.emptyRecycleBin(oppShareDelList);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        ID batchJobId = Database.executeBatch(New LCRMLeadShareDelete(), Integer.valueof(Label.LCRM_Delete_Share_Batch_Size.trim()));
    }
	END: DPS-14173 - Commented this Class. */
}