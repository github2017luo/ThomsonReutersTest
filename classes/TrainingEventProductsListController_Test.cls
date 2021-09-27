@isTest
public class TrainingEventProductsListController_Test{

@testSetup static void testDataSetUp() {

    Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
    RecordType teRT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1]; 
               
    User gliUser = UnitTest.getUserInstance();
    gliUser.Username = 'TestUser1@TR.com';
    gliUser.profileid = ukiProfile.Id;
    gliUser.Sub_Bu__c = 'UKI';
    insert gliUser;
    
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
    
    Training_Event_Product__c tep = new Training_Event_Product__c();
    tep.LCRM_Training_Event__c = gliTE.Id;
    tep.LCRM_Product__c = gliProduct.Id;
    insert tep;
    
  }
  
   @isTest public static void testComponent(){
        User gliUser = [SELECT id FROM User WHERE Username = 'TestUser1@TR.com'];
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        
        TrainingEventProductsListController controller = new TrainingEventProductsListController();
        System.runas(gliUser){
            controller.trainingEventId = gliTE.Id;
            controller.getProducts();
        }
        System.assert(controller.prods.size()==1, 'Number of products is:'+controller.prods.size());
   }
}