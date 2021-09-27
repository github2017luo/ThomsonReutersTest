/**
 * @description LCRMCreateNewLeadFromContact_Test Description
 *
 */
@isTest
public without sharing class LCRMCreateNewLeadFromContact_Test {
    /**
     * @description TestCreateLeadFromContact description
     * @comment TestCreateLeadFromContact comment
     *
     * 
     */
    public static testMethod void testCreateLeadFromContact(){

        //create account
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        insert gliAccount;
        //create contact 
        Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
        gliContact.firstname = 'test';
        gliContact.lastname = 'test lead create';
        gliContact.ESC_tocLanguage__c = 'English';
        gliContact.Email = 'Shovonleadcreate@Bera.com';
        gliContact.accountid = gliAccount.id;
        insert gliContact;
        System.assertEquals(gliContact != null,true,'Contact Found');
        //invoke LCRMCreateNewLeadFromContact getAccountDetails
        LCRMCreateNewLeadFromContact.getAccountDetails(gliContact.id);
       

    }
    
}