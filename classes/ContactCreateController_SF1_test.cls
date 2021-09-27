@isTest(seeAllData=true)
public class ContactCreateController_SF1_test{
    
    public static testmethod void method1(){
        test.startTest();
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
        DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
        PageReference oPage = Page.sf1NewContactCreate;
        Test.setCurrentPage(oPage);
        Account oaccount = UnitTest.getAccountInstance();
        insert oaccount;
        Contact oDupContact= UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        oDupContact.lastname = 'Smith';
        oDupContact.Email = 'Fred@Smith.com';
        oDupContact.MDB_Contact_ID__c = '1234567890';
        insert oDupContact;
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
        //insert ocontact;
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oaccount);
        ContactCreateController_SF1 oTestController = new ContactCreateController_SF1();
        ContactCreateController_SF1 oTestController2 = new ContactCreateController_SF1(oStandardController);
        oTestController.oContact = oContact;
        oTestController.listMatchedContacts = new List<DataQualityUtil.ContactInfo>();
        
        DataQualityUtil.ContactInfo oContactInfo = new DataQualityUtil.ContactInfo();
        oContactInfo.MDBCustomerID = '1234567890';
        oContactInfo.MDBContactID = '1234567890';
        oContactInfo.Name = 'Smith';
        oContactInfo.EMail = 'Fred@Smith.com';
        oContactInfo.Score = '1';
        oTestController.listMatchedContacts.add(oContactInfo);
        oTestController.save();
        Contact ocontact2 = UnitTest.getContactInstance(oaccount.Id);
        //ocontact2.name = 'Fred2';
        ocontact.lastname = 'Smith';
        ocontact2.Email = 'Fred2@Smith.com';
        oTestController.oContact = oContact2;
        oTestController.continueSave();
        ContactCreateController_SF1.MatchedContact oMatchedContact = new ContactCreateController_SF1.MatchedContact();
        Test.stopTest();
    }

}