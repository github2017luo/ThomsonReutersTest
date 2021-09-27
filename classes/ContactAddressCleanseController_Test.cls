@istest
public with sharing class ContactAddressCleanseController_Test{
    public static testMethod void testContactAddress(){
        account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        contact testCon = UnitTest.getContactInstance(testAcc.id);
        insert testCon;
        ApexPages.standardController sc = new ApexPages.standardController(testCon);
        Test.setCurrentPageReference(Page.ContactAddress);
        ContactAddressCleanseController cont = new ContactAddressCleanseController(sc);
        cont.edit();
        cont.cancel();
        cont.Save();
        cont.saveWithoutCleanse();
       /* testcon.MailingCity = 'a';
        testcon.MailingState = 'b';
        testcon.MailingPostalCode = 'c';
        testcon.MailingCountry='US';
        update testcon;
        sc = new ApexPages.standardController(testCon);
        cont = new ContactAddressCleanseController(sc);
        cont.Save();*/
    } 
}