/********************************************************************************
Class Name : DCPAccount_Test   
@description : This class is used for testing DCPAccount class.
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                Description
21-05-2021                  Vishnu Santhosh            Initial Creation
*/ 

@isTest
public class DCPAccount_Test {

    @TestSetup
    static void setup() {

        List<Account> testAccount = new List<Account>();
        Map<String, Sobject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        DCPTestDataFactory.disableApplicationAutomation(); 
        testAccount.add((Account)objectToDataMap.get('Account'));
        insert testAccount;
    }
    @isTest static void testGetAccounts() {

        List<Account> testAccount = [SELECT id, Name From Account];
        List<Id> testAccountId = new List<Id>();
        List<Account> retrievedTestAccount = new List<Account>();
        testAccountId.add(testAccount[0].Id);
        Test.startTest();
        retrievedTestAccount = DCPAccount.getAccounts(testAccountId);
        Test.stopTest();
        System.assertEquals(testAccount[0].Id, retrievedTestAccount[0].Id, 'The returned data from DCPAccount is not correct.');
    }

}