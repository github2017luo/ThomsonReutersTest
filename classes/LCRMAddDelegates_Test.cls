@isTest
public class LCRMAddDelegates_Test{

@testSetup static void testDataSetUp() {

    Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
    //UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];
    RecordType teRT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1];
    RecordType accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1]; 
    Recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1]; 
    
    User gliUser;
    System.runAs ( new User(Id = UserInfo.getUserId()) ) {            
        gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'TestUser1@TR.com';
        gliUser.profileid = ukiProfile.Id;
        //gliUser.UserRoleId = ukiRole.Id;
        gliUser.Sub_Bu__c = 'UKI';
        insert gliUser;
    }
    
    Training_Event__c gliTE = UnitTest.getTrainingEventInstance();
    gliTE.LCRM_Is_GLI__c = true;
    gliTE.LCRM_Sub_Bu__c = 'UKI';
    gliTE.RecordTypeId = teRT.Id;
    gliTE.OwnerId = gliUser.Id;
    insert gliTE;
    
    Account gliAccount = UnitTest.getAccountInstance();
    gliAccount.Name = 'Test Account';
    gliAccount.Is_GLI__c = true;
    gliAccount.RecordTypeId = accountRT.Id;
    insert gliAccount;
    
    Contact gliContact1 = UnitTest.getContactInstance(gliAccount.Id);
    gliContact1.LastName = 'Test Contact 1';
    gliContact1.RecordTypeId = contactRT.id;
    insert gliContact1;
    
    Contact gliContact2 = UnitTest.getContactInstance(gliAccount.Id);
    gliContact2.LastName = 'Test Contact 2';
    gliContact2.RecordTypeId = contactRT.id;
    insert gliContact2;
    
    Contact gliContact3 = UnitTest.getContactInstance(gliAccount.Id);
    gliContact3.LastName = 'Test Contact 3';
    gliContact3.RecordTypeId = contactRT.id;
    insert gliContact3;
    
    Training_Event_Contact__c tec1 = new Training_Event_Contact__c(Training_Event__c=gliTe.Id, Contact_Name__c=gliContact1.Id);
    insert tec1;
    Training_Event_Contact__c tec2 = new Training_Event_Contact__c(Training_Event__c=gliTe.Id, Contact_Name__c=gliContact2.Id);
    insert tec2;
  }
  
    /** 
   * @description :  test method for addDelegates
   */
  public static testMethod void testAddDelegates(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        
        PageReference oPage = Page.LCRMAddDelegates;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('teId', gliTE.Id);
        
        LCRMAddDelegates controller = new LCRMAddDelegates(new ApexPages.StandardController(gliTE));
        controller.oPagingContacts.moveNext(); 
        controller.oPagingContacts.movePrev(); 
        controller.sSearchKey = 'Test';
        controller.ListSelectedfilter.add(new LCRMAddDelegates.Searchfilters('Account Name','equals','Test Account'));
        
        Test.startTest();
            system.runAs(gliUser){
                controller.getlistContactFields();
                controller.getlistOperatorFields();
                controller.addFilter();
                controller.toggleSort();
                controller.findContacts();
                controller.listMatchingContacts[0].bSelected = true;
                controller.AddtoTraining();
            }
        Test.stopTest();
        System.assert(controller.listMatchingContacts.size()==1,'Size is:'+controller.listMatchingContacts.size());
    }
}