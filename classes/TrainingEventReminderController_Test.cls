@isTest
public class TrainingEventReminderController_Test{

@testSetup static void testDataSetUp() {

    Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
    RecordType teRT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1]; 
               
    User gliUser = UnitTest.getUserInstance();
    gliUser.Username = 'TestUser1@TR.com';
    gliUser.profileid = ukiProfile.Id;
    gliUser.Sub_Bu__c = 'UKI';
    insert gliUser;
    system.runas(gliUser)
    {
    Training_Event__c gliTE = UnitTest.getTrainingEventInstance();
    gliTE.LCRM_Is_GLI__c = true;
    gliTE.LCRM_Sub_Bu__c = 'UKI';
    gliTE.RecordTypeId = teRT.Id;
    gliTE.OwnerId = gliUser.Id;
    insert gliTE;
    
    Product2 gliProduct = new Product2();
    gliProduct.Name = 'Test Product';
    gliProduct.IsActive = true;
    gliProduct.LCRM_Sub_Bu__c = 'UKI';
    insert gliProduct;
    
    Product2 gliProduct1 = new Product2();
    gliProduct1.Name = 'Test Product1';
    gliProduct1.IsActive = true;
    gliProduct1.LCRM_Sub_Bu__c = 'UKI';
    insert gliProduct1;
    
    
    
    Training_Event_Product__c tep = new Training_Event_Product__c();
    tep.LCRM_Training_Event__c = gliTE.Id;
    tep.LCRM_Product__c = gliProduct.Id;
    insert tep;
    
    Training_Event_Product__c tep1 = new Training_Event_Product__c();
    tep1.LCRM_Training_Event__c = gliTE.Id;
    tep1.LCRM_Product__c = gliProduct1.Id;
    insert tep1;
    
    
    
    
    LCRM_Learning_Objectives__c lo1 = new LCRM_Learning_Objectives__c(Name='LCRM_To_archive_content__c');
    insert lo1;
    LCRM_Learning_Objectives__c lo2 = new LCRM_Learning_Objectives__c(Name='LCRM_To_better_know_the_legal_steps__c');
    insert lo2;
    LCRM_Learning_Objectives__c lo3 = new LCRM_Learning_Objectives__c(Name='LCRM_To_better_understand_news__c');
    insert lo3;
    }
  }
  
   @isTest public static void testComponent(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
         PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users']; 
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = gliUser.Id);
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        gliTE.LCRM_To_better_know_the_legal_steps__c = true;
        update gliTE;
        
        TrainingEventReminderController controller = new TrainingEventReminderController();
        System.runas(gliUser){
            controller.trainingEventId = gliTE.Id;
            controller.getProducts();
            String strprodnames = controller.getProductNames(); 
            controller.getLearningObjectives();
            controller.getOwnerName();
             System.assert(controller.prods.size()==2, 'Number of products is:'+controller.prods.size());
        System.assertEquals(strprodnames , 'Test Product1,Test Product');
        System.assert(controller.learningObjs.size()==1, 'Number of learning objectives is:'+controller.learningObjs.size());
        }
       
   }
}