/*
 * Created as part of DPS-17666
 * This is a Test class is for controller class LOTUS_FlipS2ELeadsToGSI_Controller
*/

@IsTest
public class LOTUS_Flips2ELeadtoGSIController_Test {
    
      public static testMethod void testLeadFlip() {
        
        Profile ProfileId = [SELECT Id FROM Profile WHERE Name = 'UKI Users' limit 1];
        User u1 = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfileId .Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='UKI');
        insert u1;
          
        PermissionSet ps = new PermissionSet();
        ps.Name = 'LOTUS_Permission_Set_to_Flip_S2E_Leads_to_GSI1';
        ps.Label = 'LOTUS - Permission Set to Flip S2E Leads to GSI1';
        insert ps;
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = [select Id from CustomPermission where DeveloperName = 'LOTUS_Lead_Flip_to_GSI'].Id;
        insert sea;
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u1.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
          
        system.runAs(u1)   {  
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        insert account;
        
        List<lead> lstLead = new List<Lead>();
        Lead lead = UnitTest.getLeadInstance();
        lead.Account__c = account.id;  
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'test';
        lead.Billing_Zip__c = 'test';
        //lstLead.add(lead);
          insert lead;
        //insert lstlead;
       System.assert(lead.Company == 'UTLeadAccount');
       
        Test.startTest();
        PageReference testPageReference = new PageReference('/apex/LOTUS_FlipS2ELeadsToGSI');
        testPageReference.getParameters().put('id', lead.Id);
        Test.setCurrentPageReference(testPageReference);
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        LOTUS_FlipS2ELeadsToGSI_Controller controller = new LOTUS_FlipS2ELeadsToGSI_Controller(standardController);
        PageReference convertPageReference = controller.FlipLead();
        
        Test.stopTest();
        }
     }
  
    public static testMethod void testLeadFlip1() {
        Profile ProfileId = [SELECT Id FROM Profile WHERE Name = 'TR Legal US Sales User' limit 1];
        User u1 = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfileId .Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='UKI');
        insert u1;
        system.runAs(u1)   {
            Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        insert account;
        
        List<lead> lstLead = new List<Lead>();
        Lead lead = UnitTest.getLeadInstance();
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'test';
        lead.Billing_Zip__c = 'test';
        //lstLead.add(lead);
          insert lead;
        //insert lstlead;
        System.assert(lead.Company == 'UTLeadAccount');
        Test.startTest();
        PageReference testPageReference = new PageReference('/apex/LOTUS_FlipS2ELeadsToGSI');
        testPageReference.getParameters().put('id', lead.Id);
        Test.setCurrentPageReference(testPageReference);
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        LOTUS_FlipS2ELeadsToGSI_Controller controller = new LOTUS_FlipS2ELeadsToGSI_Controller(standardController);
        PageReference convertPageReference = controller.flipLead();
        
        Test.stopTest();
            
        }
    }
}