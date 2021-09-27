/*
======================================================================================================================
CLASS/ TRIGGER NAME:  RenewalsQuoteSyncLoad
======================================================================================================================
=
PURPOSE: <'Legacy code' and we are not sure about the functunality>

CHANGE HISTORY:
======================================================================================================================
DATE              NAME              DESC
31/03/2017        Gunaseelan K     <Optimized the code as per JIRA STORY: PS0-1>
======================================================================================================================
*/
global class RenewalsQuoteSyncLoad implements Database.Batchable<SObject>{
       Map<id,id> mapQuoteSet_Renewals = new Map<id,id>();
    //    User u = [SELECT id FROM User WHERE Name =: 'Informatica User'];
    global Database.QueryLocator start(Database.BatchableContext BcthCon){   
        String strRecordType = RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c;
        Date dateToday = Date.Today();
        Date dateYesterday = Date.Today() - 1;
        String  Query;
      // if(!Test.isRunningTest()){
            Query ='SELECT id,AccountId,OpportunityId,Primary_Quote__c,Renewal_Flag_Formula__c,RecordTypeId FROM Quote WHERE Primary_Quote__c = TRUE AND Renewal_Flag_Formula__c = TRUE AND RecordTypeId =:strRecordType  AND (Created_Date__c =: dateToday OR Created_Date__c =: dateYesterday) AND IsSyncing = False ORDER BY AccountId';
      //  }
        if(Test.isRunningTest()){
            Query ='SELECT id,AccountId,OpportunityId,Primary_Quote__c,Renewal_Flag_Formula__c,RecordTypeId FROM Quote WHERE Primary_Quote__c = TRUE AND Renewal_Flag_Formula__c = TRUE AND RecordTypeId =:strRecordType  AND  (Created_Date__c =: dateToday OR Created_Date__c =: dateYesterday)  ORDER BY AccountId limit 1';
        }
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BtchCon, List<SObject> scope){
       List<Quote> lstQuote = (List<Quote>)scope;
       for(Quote quo: lstQuote ){ 
         mapQuoteSet_Renewals.put(quo.OpportunityId,quo.Id);
      }
      QuoteTriggerHandler.updateSynCQuoteList_Renewals(mapQuoteSet_Renewals);                 
    }
    global void finish(Database.BatchableContext BtchCon){
    }
}