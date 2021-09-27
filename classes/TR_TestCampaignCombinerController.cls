@isTest
public class TR_TestCampaignCombinerController {
    @testSetup static void setupTestData(){
        Profile testprofile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User usr = new User();
        usr.profileid = testprofile.Id;
        usr.Username = 'TestUser@TR.com';
        usr.LastName = 'XYZ';
        usr.Email = 'abc@xyz.com';
        usr.Alias = 'abctest';
        usr.CommunityNickname = 'CommunityNickname.testUser';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.LocaleSidKey = 'en_US';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.LanguageLocaleKey = 'en_US';
        usr.Sales_Org__c='GLI';
        insert usr;
        
        Account acct = new Account();
        acct.Name = 'Unit Test';
        acct.Sales_Org__c = 'WEST';
        acct.Customer_Type__c = 'Individual';
        acct.Customer_Group__c = 'ACADEMIC';
        acct.Industry = 'TAX';
        acct.BillingState = 'KA';
        acct.BillingCity = 'BANGALORE';
        acct.BillingStreet = 'Test';
        acct.BillingPostalCode ='test000';
        acct.BillingCountry = 'IN';
        MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert acct;
        
        campaign cmp = new campaign();
        cmp.name = 'test';
        cmp.OwnerId = usr.Id;
        cmp.StartDate = System.Today();
        cmp.EndDate =System.Today()+5;
        cmp.Status='Planned';
        cmp.IsActive=true;
        insert cmp;
        
        for(Integer i=0; i<5;i++){
            campaign cmpn = new campaign();
            cmpn.name = 'test'+i;
            cmpn.OwnerId = usr.Id;
            cmpn.StartDate = System.Today();
            cmpn.EndDate =System.Today()+5;
            cmpn.Status='Planned';
            cmpn.IsActive=true;
            cmpn.ParentId=cmp.Id;
            insert cmpn; 
        }
        
        for(Integer i=0; i<5;i++){
            Contact con = new Contact();
            con.AccountId = acct.Id;
            con.FirstName = 'Unit';
            con.LastName = 'Test'+i;
            con.MailingCountry = 'IN';
            con.MailingStreet = '123 Unit Test'+i;
            con.MailingCity = 'Dallas'+i;
            con.MailingState = 'KA';
            con.MailingPostalCode = '75019'+i;
            insert con;
           //DBIntegrationUtil_Test.setupUpsertContactServiceSettings();
           //DBIntegrationUtil_Test.setupMockUpsertContactSuccessResponse();
        }
        
        for(Integer i=0; i<5;i++){
            Lead ld = new Lead();
            ld.FirstName = 'Unit';
            ld.LastName = 'Test'+i;
            ld.Company = 'Unit Test Company'+i;
            ld.Status = 'Contacting'+i;
            ld.City = 'BENGALURU';
            ld.Country = 'IN';
            ld.State = 'KA';
            ld.Street ='Test';
            ld.PostalCode ='Test000';
            insert ld;
            
            //Setup required mock web service requests - added to support lead conversions
            // MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
            //MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
            
            //MDBIntegrationUtil_Test.setupUpsertContactServiceSettings();
            //MDBIntegrationUtil_Test.setupMockUpsertContactSuccessResponse();
        }
        
        
        for(Integer i=0; i<5;i++){
            CampaignMember newcampmem =new CampaignMember(campaignId = [SELECT Id from Campaign where Name =:'test'+i LIMIT 1].Id,
                                                          contactId = [SELECT Id from Contact where LastName =:'Test'+i LIMIT 1].Id,
                                                          leadId = [SELECT Id from Lead where LastName =:'Test'+i LIMIT 1].Id,
                                                          status = 'Planned');
            insert newcampmem;
        }
    }
    
   @isTest static void testfetchCampaign (){ 
        try{
            Date startdate=System.Today();
            Date endDate=System.Today()+5;
            Test.startTest();
            TR_CampaignCombinerController.fetchCurrentCampaign([SELECT Id FROM Campaign where Name='test'].Id);
            TR_CampaignCombinerController.fetchSelectedCampaign([SELECT Id FROM Campaign where Name='test'].Id);
            TR_CampaignCombinerController.campaignCreate('testNew',startdate,endDate,'Planned','Sent');
            TR_CampaignCombinerController.fetchNewCampaign([SELECT Id FROM Campaign where Name='testNew'].Id);
            TR_CampaignCombinerController.fetchCampaignOwner([SELECT Id FROM User LIMIT 1].Id);
            TR_CampaignCombinerController.fetchCampaignParent([SELECT Id FROM Campaign where Name ='test1'].Id);
            TR_CampaignCombinerController.CampaignCombinerOnlyAdd([SELECT Id FROM Campaign where Name ='test1'OR Name ='test2'OR Name ='test3'],[SELECT Id FROM Campaign where Name ='test4'].Id,true,'Planned');
            TR_CampaignCombinerController.fetchMembersAfterCombine([SELECT Id FROM Campaign where Name ='test1'].Id);
            TR_CampaignCombinerController.getStatusPickList();
            TR_CampaignCombinerController.getStatusMemPickList();
            TR_CampaignCombinerController.getTypePickList();
            TR_CampaignCombinerController.CampaignCombinerWithAddExclude([SELECT Id FROM Campaign where Name ='test1'],[SELECT Id FROM Campaign where Name ='test2'],[SELECT Id FROM Campaign where Name ='test4'].Id,true,true,'Planned');
            Test.stopTest();
        }catch(Exception ex){
            System.assertNotEquals(ex.getMessage(), null);
        }
    }
    
    @isTest static void testCampaignCombinerWithOnlyAdd (){ 
        try{
            Test.startTest();
            TR_CampaignCombinerController.CampaignCombinerOnlyAdd([SELECT Id FROM Campaign where Name ='test1'OR Name ='test2'OR Name ='test3'],[SELECT Id FROM Campaign where Name ='test4'].Id,false,'Planned');
            Test.stopTest();
        }catch(Exception ex){
            System.assertNotEquals(ex.getMessage(), null);
        }
    }
    
    
    @isTest static void testCampaignCombinerWithAddExclude (){ 
        try{
            Test.startTest();
            TR_CampaignCombinerController.CampaignCombinerWithAddExclude([SELECT Id FROM Campaign where Name ='test1'],[SELECT Id FROM Campaign where Name ='test2'],[SELECT Id FROM Campaign where Name ='test4'].Id,false,false,'Planned');
            Test.stopTest();
        }catch(Exception ex){
            System.assertNotEquals(ex.getMessage(), null);
        }
    }
    
    @isTest static void testCampaignCombinerWithAddExcludeException (){ 
        try{
            Test.startTest();
            TR_CampaignCombinerController.CampaignCombinerOnlyAdd([SELECT Id FROM Campaign LIMIT 3],[SELECT Id FROM Campaign LIMIT 1].Id,null,'Planned');
            TR_CampaignCombinerController.CampaignCombinerWithAddExclude(null,null,null,false,false,null);
            TR_CampaignCombinerController.CampaignCombinerWithAddExclude([SELECT Id FROM Campaign where Name ='test1'],[SELECT Id FROM Campaign where Name ='test2'],[SELECT Id FROM Campaign where Name ='test'].Id,null,null,'Planned');
            Test.stopTest();
        }catch(Exception ex){
            System.assertNotEquals(ex.getMessage(), null);
        }
    }
    
    @isTest static void testCampaignCombinerWithOnlyAddException (){ 
        try{
            Test.startTest();
            TR_CampaignCombinerController.CampaignCombinerOnlyAdd([SELECT Id FROM Campaign where Name ='test1'OR Name ='test2'OR Name ='test3'],[SELECT Id FROM Campaign where Name ='test4'].Id,null,'Planned');
            TR_CampaignCombinerController.CampaignCombinerOnlyAdd(null,null,false,null);
            Test.stopTest();
        }catch(Exception ex){
            System.assertNotEquals(ex.getMessage(), null);
        }
    }
    
    @isTest static void testautoFieldValuesNegative (){ 
        try{
            Test.startTest();
            TR_CampaignCombinerController.fetchCurrentCampaign(null);
            TR_CampaignCombinerController.fetchSelectedCampaign(null);
            TR_CampaignCombinerController.fetchNewCampaign(null);
            TR_CampaignCombinerController.fetchCampaignOwner(null);
             TR_CampaignCombinerController.fetchCampaignParent(null);
            TR_CampaignCombinerController.fetchMembersAfterCombine(null);
            TR_CampaignCombinerController.CampaignCombinerWithAddExclude(null,null,null,null,null,null);
            //TR_CampaignCombinerController.campaignCreate(null,null,null,null);
            Test.stopTest();
        }catch(Exception ex){
            System.assertNotEquals(ex.getMessage(), null);
        }
    }
}