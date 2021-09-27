/*
======================================================================================================================
TEST CLASS NAME: RenewalsQuoteSyncLoad_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the RenewalsQuoteSyncLoad class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest(SeeAllData=false)
 public class RenewalsQuoteSyncLoad_Test {
  public static testmethod void RenewalsQuoteSyncLoad_Test(){
        UnitTest.createTestData();
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.currencyIsoCode = 'USD';
        opp1.Renewal_Flag__c = true;
       // opp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert opp1;

        Quote Q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
       // Q1.Approval_Status__c = 'Quote Rejected';
        Q1.Primary_Quote__c = true;
        Q1.RecordTypeId =  Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        Insert Q1;

        Test.StartTest();
        RenewalsQuoteSyncLoad renQuoteSyncLoad = new RenewalsQuoteSyncLoad();
        Database.executeBatch(renQuoteSyncLoad,100);   

        Test.StopTest();
        }
   }