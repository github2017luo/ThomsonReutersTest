@isTest
public class LCRMCasetoTrainingEventController_Test{

@testSetup static void testDataSetUp() { 
        recordtype caseRT = [select id from recordtype where name ='GLI Training Event Request' and sobjecttype='Case' limit 1]; 
        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users'];  
                
        User gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'TestUser1@TR.com';
        gliUser.profileid = ukiProfile.Id;
        gliUser.Sub_Bu__c = 'UKI';
        insert gliUser;
		
        System.runAs(new User(Id=UserInfo.getUserId())){
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = gliUser.Id);
            insert psa; 
        }
        
        FieldId__c fi = new FieldId__c(DQA_Request_Case__c='012S00000000o9r');
        insert fi;
        Case gliCase = UnitTest.getCaseInstance();
        gliCase.Is_GLI__c = true;
        gliCase.RecordTypeId = caseRT.Id;
        gliCase.OwnerId = gliUser.Id;
        insert gliCase;
        
        Product2 gliProduct = new Product2();
        gliProduct.Name = 'Test Product';
        gliProduct.IsActive = true;
        gliProduct.LCRM_Sub_Bu__c = 'UKI';
        insert gliProduct;
        
        LCRM_Training_Event_Case_Product__c tecp = new LCRM_Training_Event_Case_Product__c (LCRM_Training_Event_Case__c=gliCase.Id,LCRM_Product__c=gliProduct.Id);
        insert tecp;
      }
    
    //user is not an admin user
    @isTest public static void testConvertCaseByNonAdminUser(){
        Case gliCase = [SELECT Id FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        
        PageReference oPage = Page.LCRMCasetoTrainingEvent;
        Test.setCurrentPage(oPage);
        
        LCRMCasetoTrainingEventController controller = new LCRMCasetoTrainingEventController(new ApexPages.StandardController(gliCase));
        Test.startTest();
            system.runAs(gliUser){
                controller.onPageLoad();
            }
        Test.stopTest();
    }
    
    //user is an admin user
    @isTest public static void testConvertCaseByAdminUser(){
        Case gliCase = [SELECT Id,OwnerId FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        Group adminGroup = [SELECT Id FROM Group WHERE Name = 'GLI Training Admins'];
        
        gliCase.Subject = 'Test Case 1';
        update gliCase;
        
        System.runAs(new User(Id = UserInfo.getUserId())){
            GroupMember gm = new GroupMember(GroupId=adminGroup.Id,UserorGroupId=gliUser.Id);
            insert gm;
        }
        
        PageReference oPage = Page.LCRMCasetoTrainingEvent;
        Test.setCurrentPage(oPage);
        
        LCRMCasetoTrainingEventController controller = new LCRMCasetoTrainingEventController(new ApexPages.StandardController(gliCase));
        Test.startTest();
           system.runAs(gliUser){
                controller.onPageLoad();
           }
        Test.stopTest(); 
        Training_Event__c te = [SELECT Id FROM Training_Event__c LIMIT 1];
        System.assert(te.id!=null,'Training Event not created');
        System.assert(gliCase.Status=='Converted','Status not set to converted,status is:'+gliCase.Status);
        
    }
    
    //getting an exception while trying to create a training event
    @isTest public static void testConvertCaseWithException(){
        Case gliCase = [SELECT Id,OwnerId FROM Case LIMIT 1];
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        Group adminGroup = [SELECT Id FROM Group WHERE Name = 'GLI Training Admins'];
        
        GroupMember gm = new GroupMember(GroupId=adminGroup.Id,UserorGroupId=gliUser.Id);
        insert gm;
        
        PageReference oPage = Page.LCRMCasetoTrainingEvent;
        Test.setCurrentPage(oPage);
        
        LCRMCasetoTrainingEventController controller = new LCRMCasetoTrainingEventController(new ApexPages.StandardController(gliCase));
        Test.startTest();
            system.runAs(gliUser){
                try{   
                    controller.onPageLoad();
                }
                catch(Exception e){
                    System.assert(e.getMessage().contains('Insert failed.'),e.getMessage());
                }
            }
        Test.stopTest();
    }
	
    //user is a GLI Sales User
    @isTest public static void testConvertCaseByGLISalesUser(){
        Case gliCase = [SELECT Id FROM Case LIMIT 1];
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_USL_Training_Users'];
        System.runAs(new User(Id=UserInfo.getUserId())){
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = u.Id);
            insert psa; 
        }
        PageReference oPage = Page.LCRMCasetoTrainingEvent;
        Test.setCurrentPage(oPage);
        
        LCRMCasetoTrainingEventController controller = new LCRMCasetoTrainingEventController(new ApexPages.StandardController(gliCase));
        Test.startTest();
        system.runAs(u){
            controller.onPageLoad();
        }
        
        Test.stopTest();
    }
	
    //user is a GLI Sales Ops User
    @isTest public static void testConvertCaseByGLISalesOpsUser(){
        Case gliCase = [SELECT Id FROM Case LIMIT 1];
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'GLI Sales Ops User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_USL_Training_Users'];
        System.runAs(new User(Id=UserInfo.getUserId())){
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = u.Id);
            insert psa; 
        }
        PageReference oPage = Page.LCRMCasetoTrainingEvent;
        Test.setCurrentPage(oPage);
        
        LCRMCasetoTrainingEventController controller = new LCRMCasetoTrainingEventController(new ApexPages.StandardController(gliCase));
        Test.startTest();
        system.runAs(u){
            controller.onPageLoad();
        }
        
        Test.stopTest();
    }
	
}