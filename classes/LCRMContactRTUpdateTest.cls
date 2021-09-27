/**
* Test Class for LCRMContactRTUpdate batch class
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-04-27   TCS                     Created     
* =============================================================================
*/
@isTest
private class LCRMContactRTUpdateTest {

  private static testMethod void testContactRecordTypeUpdate1() {
        
        Id rtId;
        Id rtGLIContactId ;
        rtId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
        rtGLIContactId  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        insert gliAccount;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
        gliContact.firstname = 'Test FirstName';
        gliContact.lastname = 'Test Last Name#123';
        gliContact.Email = 'Shovon@Bera.com';
        gliContact.accountid = gliAccount.id;
        gliContact.RecordTypeId = rtGLIContactId;
        insert gliContact;
        
        
        Contact oContactRetrieved = [select id, recordTypeid from Contact where id = :gliContact.Id ];
        
        system.assertEquals(rtGLIContactId, oContactRetrieved.RecordTypeId);
        
        Test.startTest();  
                LCRMContactRTUpdate  obj1 = new LCRMContactRTUpdate();
                Database.executeBatch(obj1);
                obj1.createExceptionLog('Test Error','#111');
                system.assert(true);
        Test.stopTest();
        
        oContactRetrieved = [select id, recordTypeid from Contact where id = :gliContact.Id ];
        system.assertEquals(rtId, oContactRetrieved.RecordTypeId);
  }

}