/**
* Test Class for 'LCRM Contact Last Call Date Task' Process Builder
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-06-24   Miriam Ghosh            Created     
* =============================================================================
*/

@isTest
public class LCRMContactLastCallDateTask_Test 
{
    public static testMethod void testContactLastCallDateTask() {
        
        
        Test.startTest();
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account';
        gliAccount.Phone = '1234567890';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        gliAccount.is_gli__c = True;
        insert gliAccount;
        
        Contact con = new Contact();
        con.AccountId = gliAccount.Id;
        con.FirstName = 'Unit';
        con.LastName = 'Test';
        con.MailingStreet = '123 Unit Test';
        con.MailingCity = 'Dallas';
        con.MailingCountry = 'US';
        con.MailingState = 'TX';
        con.MailingPostalCode = '75019';
        insert con;
        
        Task t = new Task();
        t.WhatId = gliAccount.id;
        t.WhoId = con.id;
        t.Subject = 'Other';
        t.priority= 'Normal';
        t.status = 'Not Started';
        t.description = 'New  Work';
        t.LCRM_Activity_Type__c = 'Call Inbound';
        insert t;
        
               
        Test.stopTest();
        
         system.assertEquals(t.CreatedDate, con.Last_Call_Date__c);
       
  }
    
    
}