/**
* {Purpose} – Test class for CNGlobalViewController.
*
* @author   David Sarbello
* @version  2014-09-10
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2014-09-10    David Sarbello      Created      
* =============================================================================
*/
@isTest
private class CNGlobalViewControllerTest {

    /**
    * Validates LogEntry.
    */
    @isTest (OnInstall=false)
    private static void test_LogEntry() {
        //Note the use of startTest() and stopTest() because LogEntry calls an @future method
        Test.startTest();  
        Account a = CNUnitTest.getAccount(true);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        CNGlobalViewController controller = new CNGlobalViewController(sc);
        CNGlobalViewController.LogEntry('Account Component', 'Initial Load','Component was loaded', a.id, null);
       Test.stopTest();
       CN_Audit_Log__c oLog = [Select Id, Account__c from CN_Audit_Log__c Where Account__c=:a.id and Action_Type__c='Initial Load' LIMIT 1];
	   System.assertEquals(a.Id, oLog.Account__c,'insertLogEntry logic not working');
    }       
}