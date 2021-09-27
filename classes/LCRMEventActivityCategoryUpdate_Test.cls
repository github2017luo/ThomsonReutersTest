/**
* Test Class for LCRMEventActivityCategoryUpdate batch class
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
private class LCRMEventActivityCategoryUpdate_Test {

  private static testMethod void testEventActivityCategoryUpdate() {
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        insert gliAccount;
        
        Event ev = new Event();
        ev.WhatId = gliAccount.id;
        ev.Description = 'Event';
        ev.ShowAs = 'Busy';
        ev.Subject = 'Event';
        ev.StartDateTime=datetime.now();
        ev.EndDateTime=datetime.now();
        insert ev;
        
        Test.startTest();  
                LCRMEventActivityCategoryUpdate  obj1 = new LCRMEventActivityCategoryUpdate();
                Database.executeBatch(obj1); 
        Test.stopTest();
        
        Event retrieveEvent = [select id, LCRM_Activity_Type__c from Event where id = :ev.Id ];
        //system.assertEquals('S2E', retrieveEvent.LCRM_Activity_Type__c);
  }

}