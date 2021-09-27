/*
======================================================================================================================
CLASS NAME:   AccountMDBBatchSync
======================================================================================================================
=
PURPOSE: Batch class to submit the accountid to MDB for update.

CHANGE HISTORY:
======================================================================================================================
DATE          NAME              DESC
 
31/3/2017    Gunaseelan K      <Optimized the code  as per JIRA STORY:PS0-1>
======================================================================================================================
*/

global without sharing class AccountMDBBatchSync implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    public set<string> salesorgs{get;set;}
    private set<string> defaultOrgs;
    global AccountMDBBatchSync() {
        salesorgs = new set<string>();  
        defaultOrgs = new Set<String>();
        Map<String,String> salesorgMap = new Map<String,String>();
        salesorgMap = MexicoUtility.classBasedOrgValues('AccountMDBBatchSync','Sales_Org__c');
        for(String st : salesorgMap.values()){
            defaultOrgs.add(st);
        }
        //defaultOrgs.add('WEST');
        /*for (SalesOrgDetail__c oSalesOrgDetail : [SELECT  Sales_Org_Code__c   FROM  SalesOrgDetail__c WHERE  Sales_Org_Code__c != null ]) {
            defaultOrgs.add(oSalesOrgDetail.Sales_Org_Code__c);
        }*/
    }
    global Database.Querylocator start(Database.BatchableContext bcContext) {
        //return Database.getQueryLocator([SELECT Id FROM Account where (Sales_Org__c = 'LRA' or Sales_Org__c = 'BKRS' or Sales_Org__c = 'SMHK') and MDBID__C = '' and recordtype.name = 'Prospect']);
        if (SalesOrgs == null || SalesOrgs.isEmpty()) {
            SalesOrgs = defaultOrgs;
        }
        return Database.getQueryLocator([SELECT Id FROM Account WHERE Sales_Org__c IN :SalesOrgs and MDBID__C = '' and recordtype.name = 'Prospect']);
    }
    global void execute(Database.BatchableContext bcContext, List<sObject> listAccounts)
    {
        if (listAccounts != null && listAccounts.isEmpty() == false) {
            for (sObject account: listAccounts){
                AccountUtil.upsertMDBAccount(account.Id);
            }
        }
    }
    global void finish(Database.BatchableContext bcContext) {}
}