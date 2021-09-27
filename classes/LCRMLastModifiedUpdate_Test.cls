/**
* Test Class for 'LCRM_Last_Modified_Update' Process Builder
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-07-06   Miriam Ghosh            Created     
* =============================================================================
*/

@isTest
public class LCRMLastModifiedUpdate_Test {
    
    public static testMethod void testLCRMLastModifiedUpdate() {
        
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
        
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Create New Contact').getRecordTypeId();
        Contact con = new Contact();
        con.AccountId = gliAccount.Id;
        con.FirstName = 'Unit';
        con.LastName = 'Test';
        con.MailingStreet = '123 Unit Test';
        con.MailingCity = 'Dallas';
        con.MailingCountry = 'US';
        con.MailingState = 'TX';
        con.MailingPostalCode = '75019';
        con.RecordTypeId = RecordTypeIdContact;
        insert con;
        
        Test.stopTest();
        
        
    }

}