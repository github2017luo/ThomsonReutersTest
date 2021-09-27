@isTest
public class LCRMTrainingEventAddressController_Test{

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
    
    //Address 1 is empty
    public static testMethod void testAddressWithEmptyAddress1(){
        Training_Event__c gliTE = [SELECT Id FROM Training_Event__c LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username='TestUser1@TR.com'];
        
        gliTE.LCRM_Address_1__c = '';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventAddressSection;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventAddressController controller = new LCRMTrainingEventAddressController(new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
   //Address 1 has more than 35 characters
    public static testMethod void testAddressWithLongAddress1(){
        Training_Event__c gliTE = [SELECT Id FROM Training_Event__c LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username='TestUser1@TR.com'];
        
        gliTE.LCRM_Address_1__c = 'AAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventAddressSection;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventAddressController controller = new LCRMTrainingEventAddressController(new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
   //City has more than 40 characters
    public static testMethod void testAddressWithLongCity(){
        Training_Event__c gliTE = [SELECT Id FROM Training_Event__c LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username='TestUser1@TR.com'];
        
        gliTE.LCRM_Address_1__c = 'ABC';
        gliTE.LCRM_City__c = 'AAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventAddressSection;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventAddressController controller = new LCRMTrainingEventAddressController (new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
   //Postcode has more than 10 characters
    public static testMethod void testAddressWithLongPostcode(){
        Training_Event__c gliTE = [SELECT Id FROM Training_Event__c LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username='TestUser1@TR.com'];
        
        gliTE.LCRM_Address_1__c = 'ABC';
        gliTE.LCRM_Postcode_Zip__c = '111112222223333333';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventAddressSection;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventAddressController controller = new LCRMTrainingEventAddressController(new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
   //
    public static testMethod void testAddressWithAppropriateAddress(){
        Training_Event__c gliTE = [SELECT Id FROM Training_Event__c LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username='TestUser1@TR.com'];
        
        gliTE.OwnerId = gliUser.Id;
        gliTE.LCRM_Address_1__c = '1 MG Road';
        gliTE.LCRM_City__c = 'Bangalore';
        gliTE.LCRM_State__c = 'Karnataka';
        gliTE.LCRM_Postcode_Zip__c = '560066';
        gliTE.LCRM_Country__c = 'India';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventAddressSection;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventAddressController controller = new LCRMTrainingEventAddressController (new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.continueSave();
                controller.cancel();
            }
        Test.stopTest();
   }
   
   public static testMethod void testAddressWithAppropriateAddressWithUpdateException(){
        Training_Event__c gliTE = [SELECT Id FROM Training_Event__c LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username='TestUser1@TR.com'];
        
        gliTE.LCRM_Address_1__c = '1 MG Road';
        gliTE.LCRM_City__c = 'Bangalore';
        gliTE.LCRM_State__c = 'Karnataka';
        gliTE.LCRM_Postcode_Zip__c = '560066';
        gliTE.LCRM_Country__c = 'India';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventAddressSection;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventAddressController controller = new LCRMTrainingEventAddressController (new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.continueSave();
                controller.cancel();
            }
        Test.stopTest();
   }
   
   //
    public static testMethod void testAddressWithInappropriateAddress(){
        Training_Event__c gliTE = [SELECT Id FROM Training_Event__c LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username='TestUser1@TR.com'];
        
        gliTE.LCRM_Address_1__c = '1 MG Road';
        gliTE.LCRM_City__c = 'Los Angeles';
        gliTE.LCRM_State__c = 'abc';
        gliTE.LCRM_Postcode_Zip__c = '';
        gliTE.LCRM_Country__c = 'US';
        update gliTE;
        
        PageReference oPage = Page.LCRMTrainingEventAddressSection;
        Test.setCurrentPage(oPage);
        
        LCRMTrainingEventAddressController controller = new LCRMTrainingEventAddressController(new ApexPages.StandardController(gliTE));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.continueSave();
                controller.cancel();
            }
        Test.stopTest();
   }
}