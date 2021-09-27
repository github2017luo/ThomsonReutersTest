/**
 * Validates the functionality provided by the ContactAttributePasswords class.
 *
 * @author  TCS
 * @version  2016-01-28
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2016-01-28   TCS        Created                                                                   
 * =============================================================================
 */
 
@IsTest(seealldata=true)
private class ContactAttributePasswords_Test {
 
    public static testMethod void testContactAttributePasswords() {
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        insert testContact;
        
        Contact_Attribute__c ca = new Contact_Attribute__c();
        ca.Name = 'test';
        ca.LastName__c = 'test';
        ca.AccountID__c = testAcc1.Id;
        ca.Contact__c = testContact.ID;
        insert ca;
        
        Test.starttest();
        Test.setCurrentPageReference(Page.ContactAttributePasswords);
              
        ApexPages.standardController sc = new ApexPages.standardController(ca);
        ContactAttributePasswords oContactPasswords = new ContactAttributePasswords(sc);
        oContactPasswords.exportContactPswds();
        Test.stoptest();
    }
}