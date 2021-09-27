/**
* Test Class for LCRMTaskActivityCategoryUpdate batch class
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-05-16   TCS                     Created     
* =============================================================================
*/
@isTest
private class LCRMTaskActivityCategoryUpdate_Test {

  private static testMethod void testTaskActivityCategoryUpdate() {
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        insert gliAccount;
        
        Task t = new Task();
        t.WhatId = gliAccount.id;
        t.Subject = 'Other';
        t.priority= 'Normal';
        t.status = 'Not Started';
        t.description = 'New  Work';
        t.LCRM_Activity_Type__c = null;
        insert t;
        
        Test.startTest();  
                LCRMTaskActivityCategoryUpdate  obj1 = new LCRMTaskActivityCategoryUpdate();
                Database.executeBatch(obj1);
                obj1.createExceptionLog('Test Error','#111');
        Test.stopTest();
        
        Task retrieveTask = [select id, LCRM_Activity_Type__c from Task where id = :t.Id ];
        system.assertEquals('S2E', retrieveTask.LCRM_Activity_Type__c);
  }

}