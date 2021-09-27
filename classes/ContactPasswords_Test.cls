/**
 * Validates the functionality provided by the ContactPasswords class.
 *
 * @author  Nandita R. Shet
 * @version  2012-08-08
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-08-08   Nandita R. Shet        Created                                                                   
 * =============================================================================
 */
 
@IsTest(seealldata=true)
private class ContactPasswords_Test {
 
    public static testMethod void testContactPasswords() {
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        Contact testContact = UnitTest.getContactInstance(testAcc1.Id);
        insert testContact;
        
        
        Test.starttest();
        Test.setCurrentPageReference(Page.ContactPasswords);
              
        ApexPages.standardController sc = new ApexPages.standardController(testContact);
        ContactPasswords oContactPasswords = new ContactPasswords(sc);
        oContactPasswords.exportContactPswds();
        Test.stoptest();
    }
}