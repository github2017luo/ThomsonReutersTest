/*
======================================================================================================================
TEST CLASS NAME: OpportunityTerritoryBatchSync_test
======================================================================================================================
PURPOSE: Validates the functionality provided by the OpportunityTerritoryBatchSync class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@isTest             
private class OpportunityTerritoryBatchSync_test 
{
    static testmethod void OpportunityTerritoryBatchSync() 
	{
	    
	    KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
        List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
				
        List<Opportunity> opps = new List<Opportunity>();
        for (integer i=0; i<50; i++)
		{
            Opportunity oOpportunity = UnitTest.getOpportunityInstance(acc.Id);
            opps.add(oOpportunity);
           
            
        }
        insert opps;
        
       Test.startTest();
		   OpportunityTerritoryBatchSync obj = new  OpportunityTerritoryBatchSync();
		   Database.executeBatch(obj, 200);
       Test.stopTest();

    }
}