@isTest
public class LCRMTrainingStatusSectionController_Test{

@testSetup static void testDataSetUp() {

    Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
     UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'UKI Managing Director'];
    PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users']; 
    RecordType teRT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1];
    
    System.runAs ( new User(Id = UserInfo.getUserId()) ) {            
        User gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'TestUser1@TR.com';
        gliUser.profileid = ukiProfile.Id;
        gliUser.UserRoleId = ukiRole.Id;
        gliUser.Sub_Bu__c = 'UKI';
        insert gliUser;
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = gliUser.Id);
        insert psa; 
    }
    
    Training_Event__c gliTE = UnitTest.getTrainingEventInstance();
    gliTE.LCRM_Is_GLI__c = true;
    gliTE.LCRM_Sub_Bu__c = 'UKI';
    gliTE.RecordTypeId = teRT.Id;
    insert gliTE;
  }
  
  @isTest public static void testStatusChangeWithConfirmTrue(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com' LIMIT 1];
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c LIMIT 1];
        gliTE.OwnerId = gliUser.Id;
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventStatusSection;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        ApexPages.currentPage().getParameters().put('param2', 'Cancelled');
        
        LCRMTrainingEventStatusSectionController controller = new LCRMTrainingEventStatusSectionController(new ApexPages.StandardController(gliTE));
        Test.setCurrentPage(oPage);
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.setStatus();
                controller.save();
                controller.cancel();
            }
            System.assert(gliTE.Status__c=='Cancelled','Status is:'+gliTE.Status__c);
        Test.stopTest();
    }
    
    @isTest public static void testStatusChangeWithConfirmFalse(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com' LIMIT 1];
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c LIMIT 1];
        gliTE.OwnerId = gliUser.Id;
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventStatusSection;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('param1', 'false');
        ApexPages.currentPage().getParameters().put('param2', 'Cancelled');
        
        LCRMTrainingEventStatusSectionController controller = new LCRMTrainingEventStatusSectionController(new ApexPages.StandardController(gliTE));
        Test.setCurrentPage(oPage);
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.setStatus();
                controller.save();
                controller.cancel();
            }
            System.assert(gliTE.Status__c=='Pending','Status is:'+gliTE.Status__c);
        Test.stopTest();
    }
    
    @isTest public static void testStatusChangeWithStatusException(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com' LIMIT 1];
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c LIMIT 1];
        gliTE.Status__c = 'Cancelled';
        gliTE.LCRM_Cancelled_Reason__c='Cancelled by TR';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventStatusSection;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        ApexPages.currentPage().getParameters().put('param2', 'Completed');
        
        LCRMTrainingEventStatusSectionController controller = new LCRMTrainingEventStatusSectionController(new ApexPages.StandardController(gliTE));
        Test.setCurrentPage(oPage);
        Test.startTest();
            system.runAs(gliUser){
                try{
                    controller.changeToEdit();
                    controller.setStatus();
                    controller.save();
                    controller.cancel();
                }
                catch(Exception e){
                    System.assert(e.getMessage().contains('Update failed'),e.getMessage());
                }
            }
        Test.stopTest();
    }
    
    @isTest public static void testStatusChangeWithTypeException(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com' LIMIT 1];
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c LIMIT 1];
        gliTE.Training_Type__c = 'Unknown';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventStatusSection;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('param1', 'true');
        ApexPages.currentPage().getParameters().put('param2', 'Cancelled');
        
        LCRMTrainingEventStatusSectionController controller = new LCRMTrainingEventStatusSectionController(new ApexPages.StandardController(gliTE));
        Test.setCurrentPage(oPage);
        Test.startTest();
            system.runAs(gliUser){
                try{
                    controller.changeToEdit();
                    controller.setStatus();
                    controller.save();
                    controller.cancel();
                }
                catch(Exception e){
                    System.assert(e.getMessage().contains('Update failed'),e.getMessage());
                }
            }
        Test.stopTest();
    }
}