@isTest
public class LCRM_CaseAddressController_Test{

    @testSetup static void testDataSetUp() {
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1]; 
        recordtype caseRT = [select id from recordtype where name ='GLI Training Event Request' and sobjecttype='Case' limit 1]; 
        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users']; 
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];
        
        User gliUser;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            gliUser = UnitTest.getUserInstance();
            gliUser.Username = 'TestUser1@TR.com';
            gliUser.profileid = ukiProfile.Id;
            gliUser.UserRoleId = ukiRole.Id;
            gliUser.Sub_Bu__c = 'UKI';
            insert gliUser;
        }
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId = accountRT.Id;
        gliAccount.OwnerId = gliUser.Id;
        insert gliAccount;
        
        FieldId__c fi = new FieldId__c(DQA_Request_Case__c='012S00000000o9r');
        insert fi;
        Case gliCase = UnitTest.getCaseInstance();
        gliCase.Is_GLI__c = true;
        gliCase.RecordTypeId = caseRT.Id;
        gliCase.OwnerId = gliUser.Id;
        insert gliCase;       
    }
    
    @isTest public static void testAddressWithNoAddress(){
        Case gliCase = [SELECT id,LCRM_Address_1__c,LCRM_Address_2__c,LCRM_City__c,LCRM_State__c,LCRM_Postcode_Zip__c,LCRM_Country__c FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        Test.setCurrentPage(oPage);
        
        LCRM_TrainingEventCase_AddressController controller = new LCRM_TrainingEventCase_AddressController(new ApexPages.StandardController(gliCase));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
    @isTest public static void testAddressWithEmptyAddress1(){
        Case gliCase = [SELECT id,LCRM_Address_1__c,LCRM_Address_2__c,LCRM_City__c,LCRM_State__c,LCRM_Postcode_Zip__c,LCRM_Country__c FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        gliCase.LCRM_Address_1__c = '';
        update gliCase;
        
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        Test.setCurrentPage(oPage);
        
        LCRM_TrainingEventCase_AddressController controller = new LCRM_TrainingEventCase_AddressController(new ApexPages.StandardController(gliCase));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
    @isTest public static void testAddressWithInvalidAddress1(){
        Case gliCase = [SELECT id,LCRM_Address_1__c,LCRM_Address_2__c,LCRM_City__c,LCRM_State__c,LCRM_Postcode_Zip__c,LCRM_Country__c FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        gliCase.LCRM_Address_1__c = 'AAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC';
        update gliCase;
        
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        Test.setCurrentPage(oPage);
        
        LCRM_TrainingEventCase_AddressController controller = new LCRM_TrainingEventCase_AddressController(new ApexPages.StandardController(gliCase));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
    @isTest public static void testAddressWithInvalidCity(){
        Case gliCase = [SELECT id,LCRM_Address_1__c,LCRM_Address_2__c,LCRM_City__c,LCRM_State__c,LCRM_Postcode_Zip__c,LCRM_Country__c FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        gliCase.LCRM_Address_1__c = 'ABC';
        gliCase.LCRM_City__c = 'AAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC';
        update gliCase;
        
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        Test.setCurrentPage(oPage);
        
        LCRM_TrainingEventCase_AddressController controller = new LCRM_TrainingEventCase_AddressController(new ApexPages.StandardController(gliCase));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
    @isTest public static void testAddressWithInvalidPostcode(){
        Case gliCase = [SELECT id,LCRM_Address_1__c,LCRM_Address_2__c,LCRM_City__c,LCRM_State__c,LCRM_Postcode_Zip__c,LCRM_Country__c FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        gliCase.LCRM_Address_1__c = 'ABC';
        gliCase.LCRM_Postcode_Zip__c = '111112222223333333';
        update gliCase;
        
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        Test.setCurrentPage(oPage);
        
        LCRM_TrainingEventCase_AddressController controller = new LCRM_TrainingEventCase_AddressController(new ApexPages.StandardController(gliCase));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.cancel();
            }
        Test.stopTest();
   }
   
    @isTest public static void testAddressWithValidAddress(){
        Case gliCase = [SELECT id,LCRM_Address_1__c,LCRM_Address_2__c,LCRM_City__c,LCRM_State__c,LCRM_Postcode_Zip__c,LCRM_Country__c FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        gliCase.LCRM_Address_1__c = '1 MG Road';
        gliCase.LCRM_City__c = 'Bangalore';
        gliCase.LCRM_State__c = 'Karnataka';
        gliCase.LCRM_Postcode_Zip__c = '560066';
        gliCase.LCRM_Country__c = 'India';
        update gliCase;
        
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        Test.setCurrentPage(oPage);
        
        LCRM_TrainingEventCase_AddressController controller = new LCRM_TrainingEventCase_AddressController(new ApexPages.StandardController(gliCase));
        Test.startTest();
            system.runAs(gliUser){
                controller.changeToEdit();
                controller.save();
                controller.continueSave();
                controller.cancel();
            }
        Test.stopTest();
   }
   
    @isTest public static void testAddressWithInvalidAddress(){
        Case gliCase = [SELECT id,LCRM_Address_1__c,LCRM_Address_2__c,LCRM_City__c,LCRM_State__c,LCRM_Postcode_Zip__c,LCRM_Country__c FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        gliCase.LCRM_Address_1__c = '1 MG Road';
        gliCase.LCRM_City__c = 'Los Angeles';
        gliCase.LCRM_State__c = 'abc';
        gliCase.LCRM_Postcode_Zip__c = '';
        gliCase.LCRM_Country__c = 'US';
        update gliCase;
        
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        Test.setCurrentPage(oPage);
        
        LCRM_TrainingEventCase_AddressController controller = new LCRM_TrainingEventCase_AddressController(new ApexPages.StandardController(gliCase));
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