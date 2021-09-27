@isTest
public class LCRMCloneTrainingEventController_Test{

@testSetup static void testDataSetUp() {

    Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
    //UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'UKI - CE & Support - Training Administrator'];
    PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users'];  
    RecordType teRT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1];
    
    User gliUser;
    System.runAs ( new User(Id = UserInfo.getUserId()) ) {            
        gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'TestUser1@TR.com';
        gliUser.profileid = ukiProfile.Id;
        //gliUser.UserRoleId = ukiRole.Id;
        gliUser.Sub_Bu__c = 'UKI';
        insert gliUser;
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = gliUser.Id);
        insert psa; 
    }
    
    Training_Event__c gliTE = UnitTest.getTrainingEventInstance();
    gliTE.LCRM_Is_GLI__c = true;
    gliTE.RecordTypeId = teRT.Id;
    gliTE.LCRM_Sub_Bu__c = 'UKI';
    gliTE.OwnerId = gliUser.Id;
    insert gliTE;
    
    Product2 gliProduct = new Product2();
    gliProduct.Name = 'Test Product';
    gliProduct.IsActive = true;
    gliProduct.LCRM_Sub_Bu__c = 'UKI';
    insert gliProduct;
    
    System.runAs(gliUser){
    Training_Event_Product__c tep = new Training_Event_Product__c();
    tep.LCRM_Training_Event__c = gliTE.Id;
    tep.LCRM_Product__c = gliProduct.Id;
    insert tep;
    }
  }
  
   @isTest public static void testClone(){
        User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        
        PageReference oPage = Page.LCRMCloneTrainingEvent;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('teId', gliTE.Id);
        
        LCRMCloneTrainingEventController controller = new LCRMCloneTrainingEventController(new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.onPageLoad();
            }
        Test.stopTest();
    }
    
    @isTest public static void testCloneWithCancelledStatus(){
        User gliUser = [SELECT id FROM User where Username = 'TestUser1@TR.com' LIMIT 1];
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        gliTE.Status__c = 'Cancelled';
        gliTE.LCRM_Cancelled_Reason__c='Cancelled by TR';
        update gliTE;
        
        PageReference oPage = Page.LCRMCloneTrainingEvent;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('teId', gliTE.Id);
        
        LCRMCloneTrainingEventController controller = new LCRMCloneTrainingEventController(new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.onPageLoad();
            }
        Test.stopTest();
    }
}