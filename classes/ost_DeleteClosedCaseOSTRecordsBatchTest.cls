/**
 *  ost_DeleteClosedCaseOSTRecordsBatchTest.cls
 *
 *  @description
 *      Test class for the ost functionality around deleting old OST Logs.
 *
 *  @date - 19/JUNE/2015
 *  @author - Dan Reich: Traction on Demand
 */
@isTest
private class ost_DeleteClosedCaseOSTRecordsBatchTest {
    //Resource contains 5 closed cases.
    private static final String TESTDATARESOURCE_CLOSEDCASES = 'OST_TestData_ClosedCases'; 
    private static final Integer NUMBER_OF_TEST_OSTS_PER_CASE = 5;
    private static Map<Id, Case> closedCaseData;

    @isTest 
    static void test2013January() {
        Datetime chosenCloseDate = Datetime.newInstance( 2013, 1, 23, 0, 0, 0 );
        Integer dayDifference = Date.today().daysBetween( chosenCloseDate.date() );
        initCustomSetting( dayDifference );
        initData();
        System.assertEquals( 35, loadAllTimeLogs().size() );
        Test.startTest();
            ost_DeleteClosedCaseOSTRecordsBatch.executeBatch();
        Test.stopTest();
        Set<String> validSubjects = new Set<String>{ 'Case3', 'Case4', 'Case5' };
        List<Time_Log__c> allTimeLogs = loadAllTimeLogs();
        System.assertEquals( 21, allTimeLogs.size() );
        for( Time_Log__c log : allTimeLogs ) {
            System.assert( validSubjects.contains( log.Case__r.Subject ), String.valueOf( log ) );
        }
    }

    @isTest 
    static void test2013June() {
        Datetime chosenCloseDate = Datetime.newInstance( 2013, 6, 23, 0, 0, 0 );
        Integer dayDifference = Date.today().daysBetween( chosenCloseDate.date() );
        initCustomSetting( dayDifference );
        initData();
        System.assertEquals( 35, loadAllTimeLogs().size() );
        Test.startTest();
            ost_DeleteClosedCaseOSTRecordsBatch.executeBatch();
        Test.stopTest();
        Set<String> validSubjects = new Set<String>{ 'Case4', 'Case5' };
        List<Time_Log__c> allTimeLogs = loadAllTimeLogs();
        System.assertEquals( 14, allTimeLogs.size() );
        for( Time_Log__c log : allTimeLogs ) {
            System.assert( validSubjects.contains( log.Case__r.Subject ), String.valueOf( log ) );
        }
    }

    @isTest 
    static void test2014January() {
        Datetime chosenCloseDate = Datetime.newInstance( 2014, 1, 23, 0, 0, 0 );
        Integer dayDifference = Date.today().daysBetween( chosenCloseDate.date() );
        initCustomSetting( dayDifference );
        initData();
        System.assertEquals( 35, loadAllTimeLogs().size() );
        Test.startTest();
            ost_DeleteClosedCaseOSTRecordsBatch.executeBatch();
        Test.stopTest();
        Set<String> validSubjects = new Set<String>{ 'Case4', 'Case5' };
        List<Time_Log__c> allTimeLogs = loadAllTimeLogs();
        System.assertEquals( 14, allTimeLogs.size() );
        for( Time_Log__c log : allTimeLogs ) {
            System.assert( validSubjects.contains( log.Case__r.Subject ), String.valueOf( log ) );
        }
    }

    @isTest 
    static void test2012January() {
        Datetime chosenCloseDate = Datetime.newInstance( 2012, 1, 23, 0, 0, 0 );
        Integer dayDifference = Date.today().daysBetween( chosenCloseDate.date() );
        initCustomSetting( dayDifference );
        initData();
        System.assertEquals( 35, loadAllTimeLogs().size() );
        Test.startTest();
            ost_DeleteClosedCaseOSTRecordsBatch.executeBatch();
        Test.stopTest();
        Set<String> validSubjects = new Set<String>{ 'Case2', 'Case3', 'Case4', 'Case5' };
        List<Time_Log__c> allTimeLogs = loadAllTimeLogs();
        System.assertEquals( 28, allTimeLogs.size() );
        for( Time_Log__c log : allTimeLogs ) {
            System.assert( validSubjects.contains( log.Case__r.Subject ), String.valueOf( log ) );
        }
    }

    private static List<Time_Log__c> loadAllTimeLogs() {
        return [
            SELECT Id, Case__r.Subject
            FROM Time_Log__c
        ];
    }

    private static void initCustomSetting( Integer numDaysToStore ) {
        insert new OST_CleanUpConfig__c(
            Days_To_Store_After_Case_Closure__c = numDaysToStore
        );
    }

    private static void initData() {
        closedCaseData = new Map<Id, Case>( (List<Case>) Test.loadData( Case.sObjectType, TESTDATARESOURCE_CLOSEDCASES ) );
        List<Time_Log__c> newTimeLogs = new List<Time_Log__c>();
        for( Case c : closedCaseData.values() ) {
            for( Integer i = 0; i < NUMBER_OF_TEST_OSTS_PER_CASE; i++ ) {
                newTimeLogs.add( new Time_Log__c( 
                    Case__c = c.Id
                ) );
            }
        }
        insert newTimeLogs;
    }
}