/*This apex class is used to cover 'LCRM_Opportunity_Renewal_Cancellation_process' process builder */
@isTest
public class LCRMOpportunityRenewalCancellationTest {
    @isTest static void method1() {
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='UKI Users'];
        User gliUser1 = UnitTest.getUserInstance();
        gliUser1.Username = 'New'+Math.random()*100 +'@TR.com';        
        gliUser1.profileid = ukiProfiles.Id;
        gliUser1.CommunityNickname = 'Xnkpa';
        gliUser1.Sub_Bu__c = 'UKI';
              
        insert gliUser1;
        
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'New'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sub_Bu__c = 'UKI';
        gliUser2.ManagerId = gliUser1.id;        
        insert gliUser2;
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
 
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Is_GLI__c = true;
        Insert TestAccount;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = 'Appointment Scheduled';
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        //add
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.LCRM_Sub_BU__c = 'UKI';
        opp1.Renewal_Flag__c = true;
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(40);
        opp1.is_GLI__c = true;
        opp1.OwnerId = gliUser2.id;
        opp1.LCRM_Owners_Manager_Email__c = 'Manager'+Math.random()*100+'@GT.com'; 
        opp1.LCRM_Status__c = 'Cancelled';
        insert opp1;
        
       /* opp1.StageName = 'Closed Lost'; 
        opp1.LCRM_Status__c = 'Open';
        update opp1;*/
        
      
        
        
    }
    
    @isTest static void method2() {
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='UKI Users'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'New'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sub_Bu__c = 'UKI';
        insert gliUser2;
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Is_GLI__c = true;
        Insert TestAccount;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = 'Appointment Scheduled';
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        //add
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.LCRM_Sub_BU__c = 'UKI';
        opp1.Renewal_Flag__c = true;
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(20);
        opp1.is_GLI__c = true;
        opp1.LCRM_Status__c = 'Pending Cancel';
        insert opp1;
        
        //opp1.StageName = 'Closed Lost';     
        //update opp1;
        
        
        
        
    }
    
    @isTest static void method3() {
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='UKI Users'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'New'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sub_Bu__c = 'UKI';
        insert gliUser2;
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Is_GLI__c = true;
        Insert TestAccount;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        //opp1.StageName = 'Appointment Scheduled';
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        //add
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.LCRM_Sub_BU__c = 'UKI';
        opp1.Renewal_Flag__c = true;
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().addDays(55);
        opp1.is_GLI__c = true;
        opp1.StageName = 'Closed Lost'; 
        opp1.LCRM_Status__c = 'Cancelled';
        opp1.LCRM_Owners_Manager_Email__c = 'Manager'+Math.random()*100+'@GT.com'; 
        insert opp1;
        
        opp1.StageName = 'Closed Lost'; 
        opp1.LCRM_Status__c = 'Open';
        update opp1;
        
        
        
        
    }
    
    @isTest static void method4() {
        
        Profile ukiProfiles = [SELECT Id FROM profile WHERE name='UKI Users'];
        User gliUser2 = UnitTest.getUserInstance();
        gliUser2.Username = 'New'+Math.random()*100 +'@TR.com';        
        gliUser2.profileid = ukiProfiles.Id;
        gliUser2.CommunityNickname = 'nkpa2';
        gliUser2.Sub_Bu__c = 'UKI';
        insert gliUser2;
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Is_GLI__c = true;
        Insert TestAccount;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = 'Appointment Scheduled';
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        //add
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.LCRM_Sub_BU__c = 'UKI';
        opp1.Renewal_Flag__c = true;
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(92);
        opp1.is_GLI__c = true;
        opp1.LCRM_Status__c = 'Pending Cancel';
        insert opp1;
        
        //opp1.StageName = 'Closed Lost';     
        //update opp1;
        
        
        
        
    }
    
    
}