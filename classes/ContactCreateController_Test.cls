/**
 * Validates the functionality provided by the ContactCreateController class.
 *
 * @author  Shawn Gray
 * @version 2013-07-17
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-17   Shawn Gray              Created                                                                   
 * =============================================================================
 */
@IsTest(seealldata = false)

public class ContactCreateController_Test {
    /**
     * Validates controller handling for a null standard controller
     */
    public static testMethod void testNullStandardController() {
        //Setup Test
        PageReference oPage = Page.ContactCreate;
        Test.setCurrentPage(oPage);
        
        Test.startTest();
        
    //    ContactCreateController oController = new ContactCreateController(null);
    //    System.assert(ApexPages.hasMessages() == true, 'Expected error message when a null standard controller is used');
 
        Test.stopTest();
    }
    
   
    /**
     * Validates the save method
     */
    public static testMethod void testContinueSave() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
        DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
        
        LCRM_GLIUser__c test3 = new LCRM_GLIUser__c(Name='GLIProfileList',Profile_List__c='LatAm Helpdesk Agent');
        insert test3;
        
        Account oaccount = UnitTest.getAccountInstance();
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
       
        insert ocontact;
        GLIGenericUtilityHelper.GLIServiceUserCheck();
        
        //Execute Test
        Test.startTest();
        
        PageReference oPage = Page.ContactCreate;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
                
        ContactCreateController oController = new ContactCreateController(oStandardController);
        //oController.onPageLoad();
        
        
        oController.HasMatchingContacts = false;
        oController.SkipContactMatching = true;
       oController.gliUser=true;
   
        //PageReference oPageReference = oController.save();
        
        PageReference oPageReference = oController.Continuesave();
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oPageReference);
    }
    public static testMethod void testBasicSave() { 
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
        DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
        
        LCRM_GLIUser__c test4 = new LCRM_GLIUser__c(Name='GLIProfileList',Profile_List__c='LatAm Helpdesk Agent');
        insert test4;
        
        Account oaccount = UnitTest.getAccountInstance();
        //insert oaccount;
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        //ocontact.accountid = oaccount.id;
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
        insert oaccount;
        ocontact.accountid = oaccount.id;
        insert ocontact;
        
        //Execute Test
        Test.startTest();
        
        PageReference oPage = Page.ContactCreate;
       
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
                
        ContactCreateController oController = new ContactCreateController(oStandardController);
        //oController.onPageLoad();
        
        
        oController.HasMatchingContacts = false;
        oController.SkipContactMatching = true;
        oController.SkipContactMatching = false;
        
        
        
        PageReference oPageReference = oController.save();
        oController.redirectnewPage();
        //PageReference oPageReference = oController.Continuesave();
        
        PageReference conPage = Page.ContactCreateNew;
        Test.setCurrentPage(conPage);
        
        //ContactCreateController contController = new ContactCreateController();
        oController.checkDuplicateContacts();
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(oPage , oPageReference);
    } 
    
    public static testMethod void testUSL() {
        Profile p = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent'];
        
        User USLUser = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert USLUser;
        
        LCRM_GLIUser__c test4 = new LCRM_GLIUser__c(Name='GLIProfileList',Profile_List__c='USL Helpdesk Agent');
        insert test4;
        system.Runas(USLUser){
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
        DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
        
        Account oaccount = UnitTest.getAccountInstance();
        //insert oaccount;
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        //ocontact.accountid = oaccount.id;
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
        insert oaccount;
        ocontact.RecordTypeId = '01213000001FuIH';    
        ocontact.accountid = oaccount.id;
        insert ocontact;
        
        Test.startTest();
        
        PageReference oPage = Page.ContactCreate;
       
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
                
        ContactCreateController oController = new ContactCreateController(oStandardController);
        //oController.onPageLoad();
        
        
        oController.HasMatchingContacts = false;
        oController.SkipContactMatching = true;
        oController.SkipContactMatching = false;
        oController.gliUser=false;  
        oController.uslUser=true;
        
        
        PageReference oPageReference = oController.save();
        oController.redirectnewPage();
        //PageReference oPageReference = oController.Continuesave();
        
        PageReference conPage = Page.ContactCreateNew;
        Test.setCurrentPage(conPage);
        
        //ContactCreateController contController = new ContactCreateController();
        oController.checkDuplicateContacts();
        
        Test.stopTest();
        }
    }
     public static testMethod void testGGO() {
        Profile p = [SELECT Id FROM profile WHERE name='LatAm Helpdesk Agent'];
        User GGOUser = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert GGOUser;
        
        LCRM_GLIUser__c test3 = new LCRM_GLIUser__c(Name='GLIProfileList',Profile_List__c='LatAm Helpdesk Agent');
        insert test3;
        system.Runas(GGOUser){
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
        DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
        
        Account oaccount = UnitTest.getAccountInstance();
        //insert oaccount;
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        //ocontact.accountid = oaccount.id;
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
        insert oaccount;
        ocontact.accountid = oaccount.id;
        insert ocontact;
        
        Test.startTest();
        
        PageReference oPage = Page.ContactCreate;
       
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
                
        ContactCreateController oController = new ContactCreateController(oStandardController);
        //oController.onPageLoad();
        
        
        oController.HasMatchingContacts = false;
        oController.SkipContactMatching = true;
        oController.SkipContactMatching = false;
        
        
        
        PageReference oPageReference = oController.save();
        oController.redirectnewPage();
        //PageReference oPageReference = oController.Continuesave();
        
        PageReference conPage = Page.ContactCreateNew;
        Test.setCurrentPage(conPage);
        
        //ContactCreateController contController = new ContactCreateController();
        oController.checkDuplicateContacts();
        
        Test.stopTest();
        }
    }
    public static testMethod void testGLI() {
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];
        User USLUser = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert USLUser;
        
        LCRM_GLIUser__c test2 = new LCRM_GLIUser__c(Name='GLIProfileList',Profile_List__c='Elite User');
        insert test2;
        system.Runas(USLUser){
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
        DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
        
        Account oaccount = UnitTest.getAccountInstance();
        //insert oaccount;
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        //ocontact.accountid = oaccount.id;
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
        insert oaccount;
        ocontact.accountid = oaccount.id;
        insert ocontact;
        
        Test.startTest();
        
        PageReference oPage = Page.ContactCreate;
       
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
                
        ContactCreateController oController = new ContactCreateController(oStandardController);
        //oController.onPageLoad();
        
        
        oController.HasMatchingContacts = false;
        oController.SkipContactMatching = true;
        oController.SkipContactMatching = false;
        
        
        
        PageReference oPageReference = oController.save();
        oController.redirectnewPage();
        //PageReference oPageReference = oController.Continuesave();
        
        PageReference conPage = Page.ContactCreateNew;
        Test.setCurrentPage(conPage);
        
        //ContactCreateController contController = new ContactCreateController();
        oController.checkDuplicateContacts();
        
        Test.stopTest();
        }
    }
   
    
    public static testMethod void testBasicGLI() { 
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];
        User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                               localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                               timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert gliUser;
        LCRM_GLIUser__c test1 = new LCRM_GLIUser__c(Name='GLIProfileList',Profile_List__c='Elite User');
        insert test1;
    
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = DataQualityUtil_Test.setupCleanseAddressServiceSettings();
        DataQualityUtil_Test.setupMockAddressCleanseServiceSuccessResponse();
        
        Account oaccount = UnitTest.getAccountInstance();
        //insert oaccount;
        Contact ocontact = UnitTest.getContactInstance(oaccount.Id);
        //ocontact.name = 'Fred';
        //ocontact.accountid = oaccount.id;
        ocontact.lastname = 'Smith';
        ocontact.Email = 'Fred@Smith.com';
        insert oaccount;
        ocontact.accountid = oaccount.id;
        insert ocontact;
        
        system.runAs(gliUser){
        //Execute Test
        Test.startTest();
        
        PageReference oPage = Page.ContactCreate;
       
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oContact);
                
        ContactCreateController oController = new ContactCreateController(oStandardController);
        oController.redirectnewPage();
        Test.stopTest();
        }
    } 
}