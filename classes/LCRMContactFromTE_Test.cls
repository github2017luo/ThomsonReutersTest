@IsTest
public class LCRMContactFromTE_Test {

     public static testMethod void testContactCreateMock(){
    Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
    User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
    insert gliUser;
     PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'LCRM_USL_Training_Users'];
	insert new PermissionSetAssignment(AssigneeId = gliUser.id, PermissionSetId = ps.Id);    
       
    system.runAs(gliUser){
    
    Account gliAccount = UnitTest.getAccountInstance();
    gliAccount.Name = 'Parent Test Account';
    gliAccount.Phone = '91 80 67254199';
    gliAccount.BillingCountry = 'US';
    gliAccount.BillingState='IL';
    gliAccount.BillingPostalCode = '60603-3801';
    gliAccount.SAPAccountNumber__c = 'UTSAP001';
    insert gliAccount;
    
    Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
    gliContact.firstname = 'Shovon';
    gliContact.lastname = 'Bera';
    gliContact.ESC_tocLanguage__c = 'English';
    gliContact.Email = 'Shovon@Bera.com';
    gliContact.accountid = gliAccount.id;
    insert gliContact;
    
    WebServiceSettings__c wbs = new WebServiceSettings__c();
    wbs.Active__c = true;
    wbs.Max_GLI_Count__c = 30;
    wbs.Max_Non_GLI_Count__c = 30;
    wbs.name='DQ.CDSContactSearchServiceContact';
    wbs.Endpoint__c='CDSContactSearchService.com';
    wbs.Service_Unavailable_Message__c ='service unavailable';
    insert wbs;
     
    RecordType teRT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1];        
    Training_Event__c gliTE = UnitTest.getTrainingEventInstance();
        gliTE.LCRM_Is_GLI__c = true;
        gliTE.LCRM_Sub_Bu__c = 'UKI';
        gliTE.RecordTypeId = teRT.Id;
        insert gliTE;    
     system.assertequals(gliTE.LCRM_Sub_Bu__c,'UKI');
    Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest()); 
        Test.startTest(); 
            LCRMContactFromTE.createContact(gliContact.id,gliTE.id);
        Test.stopTest();
       
        }
        
    }
}