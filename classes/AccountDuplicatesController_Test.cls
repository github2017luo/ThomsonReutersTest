/*
===============================================================================
 AccountDuplicatesController_Test
===============================================================================

PURPOSE:        Tests the functionality of the AccountDuplicatesController class

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2011-07-14      Nick Cook               Created
2017-03-31      Karthi                  Optimized the coverage as per JIRA STORY: PS0-1
===============================================================================
*/
@isTest
private class AccountDuplicatesController_Test 
{
    static testMethod void testExceptionBlockInsideContructor() 
    {
        Contact oCont = new Contact(FirstName='Test First Name', LastName='Test Last Name');
        
        Test.startTest();
        
        ApexPages.standardController oController = new ApexPages.standardController(oCont);     
        AccountDuplicatesController oDupController = new AccountDuplicatesController(oController);
        
        Test.stopTest();
    }
    
    static testMethod void unitTestRunDeDupe() 
    {
        Account oAcct = UnitTest.getAccountInstance();
        oAcct.BillingStreet = '18321 kerrville';
        oAcct.BillingCity = 'lakeville';
        oAcct.BillingCountry = 'US';
        oAcct.BillingState = 'MN';
        oAcct.BillingPostalCode = '55044';
        insert oAcct;
        
        Account oAcct2 = UnitTest.getAccountInstance();
        oAcct2.BillingStreet = '18321 kerrville';
        oAcct2.BillingCity = 'lakeville';
        oAcct.BillingCountry = 'US';
        oAcct2.BillingState = 'MN';
        oAcct2.BillingPostalCode = '55044';
        //insert oAcct2;
        
        Test.startTest();        
        
        //Commented code START -- Comment removed to increase code coverage
        
        ApexPages.standardController oController = new ApexPages.standardController(oAcct);     
        AccountDuplicatesController oDupController = new AccountDuplicatesController(oController);
        oDupController.setEnableButton();
        oDupController.runAccountDedupe();
        oDupController.save();
        oDupController.cancel();
        oDupController.runAccountDedupe();
        oDupController.selectedAccountId = oAcct2.Id;
        oDupController.save();
        
        //Commented code END  -- Comment removed to increase code coverage
        
        Test.stopTest();
    }
  
}