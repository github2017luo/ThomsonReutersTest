@isTest
public class LCRMActiviInactiveContactController_Test{
    @testSetup static void setup() {
        /*Embargoed_Country_List__c ebbargoedCountry = new  Embargoed_Country_List__c();
        ebbargoedCountry.Name = 'KP';
        insert ebbargoedCountry;
        List<Account> accList = new List<Account>();
        */
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        
        insert gliAccount;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
        gliContact.firstname = 'Shovon';
        gliContact.lastname = 'Bera';
        gliContact.Email = 'testuser@test.com';
        gliContact.accountid = gliAccount.id;
        gliContact.Contact_Inactive__c = false;
        
        insert gliContact;
    }
    public static testMethod void testActiveContact(){
        contact gliContact = [SELECT Id FROM Contact WHERE Email = 'testuser@test.com' LIMIT 1];
        
        Test.startTest(); 
            PageReference oPage = Page.LCRMActiveInactiveContactPage;
            oPage.getParameters().put('Id', gliContact.Id);
            Test.setCurrentPage(oPage);
            LCRMActiviInactiveContactController controller = new LCRMActiviInactiveContactController();
            controller.contactActiveInactive();
        Test.stopTest();
        System.Assert(oPage.getUrl().contains('/apex/lcrmactiveinactivecontactpage'));
    }
    public static testMethod void testInactiveContact(){
        contact gliContact = [SELECT Id, Contact_Inactive__c FROM Contact WHERE Email = 'testuser@test.com' LIMIT 1];
        gliContact.Contact_Inactive__c = true;
        
        update gliContact;
        
        Test.startTest(); 
            PageReference oPage = Page.LCRMActiveInactiveContactPage;
            oPage.getParameters().put('Id', gliContact.Id);
            Test.setCurrentPage(oPage);
            LCRMActiviInactiveContactController controller = new LCRMActiviInactiveContactController();
            controller.contactActiveInactive();
        Test.stopTest();
        System.Assert(oPage.getUrl().contains('/apex/lcrmactiveinactivecontactpage'));
    }
    
}