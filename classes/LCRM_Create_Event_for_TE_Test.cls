/*
This apex class is written to cover process builder 'LCRM_Create_Event_for_Training_Event'
*/
@isTest
public class LCRM_Create_Event_for_TE_Test {
    
    @testSetup static void testDataSetUp() {

    Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
    RecordType teRT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1]; 
               
    User gliUser = UnitTest.getUserInstance();
    gliUser.Username = 'TE'+Math.random()*100 +'@TR.com';
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
        gliTE.LCRM_To_better_know_the_legal_steps__c = true;
        gliTE.LCRM_New_Training_Duration__c = 5;
        gliTE.LCRM_Start_Time__c = system.now();
        gliTE.LCRM_Event_exists__c = true;
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
    
    @isTest static void method1() {
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='UKI Users'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'New'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sub_Bu__c = 'UKI';
        insert gliUser2;
        Training_Event__c gliTE = [SELECT Id,ownerid FROM Training_Event__c WHERE LCRM_Sub_Bu__c LIKE 'UKI' LIMIT 1];
        gliTE.LCRM_To_better_know_the_legal_steps__c = true;
        gliTE.LCRM_New_Training_Duration__c = 5;
        gliTE.LCRM_Start_Time__c = system.now();
        gliTE.LCRM_Event_exists__c = true;
        gliTE.ownerid = gliUser2.id;
        update gliTE;
    }
  
 

}