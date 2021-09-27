/*
======================================================================================================================
CLASS NAME:  XREFOpportunityFamily_Batch
======================================================================================================================
PURPOSE:  Re parenting of Notes & Attachments across all Objects(CRM-13837)

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                  DESC
20/3/2018       Radhika Pawar         Created.      
======================================================================================================================
*/
global class XREFOpportunityFamily_Batch implements Database.Batchable<SObject>{ 
        private String Query;
           // Start Method
global Database.QueryLocator start(Database.BatchableContext BcthCon){ 
    Query = 'Select Id,Name,Is_Processed__c,New_Id__c,Old_Id__c,Processed_Date_Time__c from XREF_Opportunity_Family__c   where Is_Processed__c = false And Old_Id__c!=null';
    System.debug('XREF_Opportunity_Family__c     Query:-'+Query);
    return Database.getQueryLocator(Query);
 }
    //Execute Method
global void execute(Database.BatchableContext BtchCon, List<XREF_Opportunity_Family__c  > scope){
    //call method
    System.debug('scope++**'+scope);
    if(!scope.Isempty()){
        XREFFamilyHelper_class.CreateNotesandAttachments(scope);
    }
}
//Finish Method
    global void finish(Database.BatchableContext BtchCon){
        
    }

}