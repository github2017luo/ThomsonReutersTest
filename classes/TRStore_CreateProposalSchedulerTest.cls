/* Class: TRStore_CreateProposalSchedulerTest
* Purpose: Test coverage for the scheduler class TRStore_CreateProposalScheduler
* Created: 06/02/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-06-02   Avudaiappan A     DUE-2952   For Test coverage
* =============================================================================
*/
@isTest
public class TRStore_CreateProposalSchedulerTest {
    
    public static testmethod void createTestData(){
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        
        Apttus_Config2__PriceList__c plSO1 = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert plSO1;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='TRStorePricelistUS', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='thresholdLimit' , value__c='2'),
            new Static_Values__c(name='halfPointLimit' , value__c='1'),
            new Static_Values__c(name='ProposalBusinessUnitCA', value__c='Canada'),
            new Static_Values__c(name='ProposalBusinessUnitUSL', value__c='SCS'),
            new Static_Values__c(name='OrderProcessSupportEmail', value__c='sample@tr.com'),
            new Static_Values__c(name='ProposalBusinessUnitTP', value__c='Tax Professional')};
            
            
        insert staticCSList;
        
        UE_Proposal__c oQ = new UE_Proposal__c(quoteId__c='abc', cartId__c='abc', appId__c='UECAPR');
        insert oQ;
        system.assert(oQ.cartId__c=='abc','PASSED');
    }

    public static testmethod void testSchedule(){
        test.startTest();
        createTestData();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Proposal Scheduler', sch, new TRStore_CreateProposalScheduler());
        test.stopTest();
    }
}