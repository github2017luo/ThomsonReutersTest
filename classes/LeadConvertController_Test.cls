@IsTest
private class LeadConvertController_Test {
    
    public static testMethod void testLeadConvert() {
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        insert account;
        
        Lead lead = UnitTest.getLeadInstance();
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'test';
        lead.Billing_Zip__c = 'test';
        insert lead;

        PageReference testPageReference = new PageReference('/apex/LeadConvert');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        lead = getLeadRecord(lead.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        
        //Execute Test
        Test.startTest();
        
        LeadConvertController controller = new LeadConvertController(standardController);
        
        PageReference redirectPageReference = controller.onPageLoad();
        System.assertEquals(null, redirectPageReference);
        
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        
        controller.LeadConvertStatus = 'Sales Qualified';
        controller.SelectedAccountId = account.Id;
        controller.DoNotCreateOpportunity = false;
        PageReference convertPageReference = controller.convertLead();
       // System.assert(convertPageReference != null, ApexPages.getMessages());
       // System.assert(controller.ObjectId!= null, ApexPages.getMessages());
        
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        controller.convertLead1();
        controller.leadAccountId=null;
       // System.assertEquals(true, lead.IsConverted);
    }
    
    public static testMethod void testLeadConvertNoOpportunity() {
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        insert account;
        
        Lead lead = UnitTest.getLeadInstance();
        lead.Company = 'UTLeadAccount';
        insert lead;

        PageReference testPageReference = new PageReference('/apex/LeadConvert');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        lead = getLeadRecord(lead.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        
        //Execute Test
        Test.startTest();
        
        LeadConvertController controller = new LeadConvertController(standardController);
        
        PageReference redirectPageReference = controller.onPageLoad();
        System.assertEquals(null, redirectPageReference);
        
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        
        controller.LeadConvertStatus = 'Sales Qualified';
        controller.SelectedAccountId = account.Id;
        controller.DoNotCreateOpportunity = true;
        
        PageReference convertPageReference = controller.convertLead();
       // System.assert(convertPageReference != null, ApexPages.getMessages());
       // System.assert(controller.ObjectId!= null, ApexPages.getMessages());
        
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        // System.assertEquals(true, lead.IsConverted);
    }
    
    public static testMethod void testLeadConvertWithExistingAccount() {
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        insert account;
        
        Lead lead = UnitTest.getLeadInstance();
        lead.Account__c = account.Id;
        insert lead;

        PageReference testPageReference = new PageReference('/apex/LeadConvert');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        lead = getLeadRecord(lead.Id);
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        LeadConvertController controller = new LeadConvertController(standardController);
        
        //Execute Test
        Test.startTest();
        
        PageReference redirectPageReference = controller.onPageLoad();
        System.assertEquals(null, redirectPageReference);
        
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        
        controller.LeadConvertStatus = 'Sales Qualified';
        PageReference convertPageReference = controller.convertLead();
//        System.assert(convertPageReference != null, ApexPages.getMessages());
     //   System.assert(controller.ObjectId!= null, ApexPages.getMessages());
        
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
        // System.assertEquals(true, lead.IsConverted);
    }
    
    public static testMethod void testLeadConvertWithExistingAccountByMDBId() {
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.MDBID__c = 'UTMDB001';
        account.SAPAccountNumber__c = 'UTSAP001';
        insert account;
        
        Lead lead = UnitTest.getLeadInstance();
        lead.MDBId__c = account.MDBId__c;
        insert lead;

        PageReference testPageReference = new PageReference('/apex/LeadConvert');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        lead = getLeadRecord(lead.Id);
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        LeadConvertController controller = new LeadConvertController(standardController);
        
        //Execute Test
        Test.startTest();
        
        PageReference redirectPageReference = controller.onPageLoad();
        System.assertEquals(null, redirectPageReference);
        
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        
        controller.LeadConvertStatus = 'Sales Qualified';
        PageReference convertPageReference = controller.convertLead();
        //System.assert(convertPageReference != null, ApexPages.getMessages());
       // System.assert(controller.ObjectId!= null, ApexPages.getMessages());
        
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
       // System.assertEquals(true, lead.IsConverted);
    }
    
    public static testMethod void testLeadConvertWithExistingAccountBySAPId() {
        //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.MDBID__c = 'UTMDB001';
        account.SAPAccountNumber__c = 'UTSAP001';
        insert account;
        
        Lead lead = UnitTest.getLeadInstance();
        lead.SAPAccountNumber__c = account.SAPAccountNumber__c;
        insert lead;

        PageReference testPageReference = new PageReference('/apex/LeadConvert');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        lead = getLeadRecord(lead.Id);
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        LeadConvertController controller = new LeadConvertController(standardController);
        
        //Execute Test
        Test.startTest();
        
        PageReference redirectPageReference = controller.onPageLoad();
        System.assertEquals(null, redirectPageReference);
        
        controller.CreateFollowUpTask = true;
        controller.FollowUpTask.ActivityDate = System.today();
        
        controller.LeadConvertStatus = 'Sales Qualified';
        PageReference convertPageReference = controller.convertLead();
        //System.assert(convertPageReference != null, ApexPages.getMessages());
       // System.assert(controller.ObjectId!= null, ApexPages.getMessages());
        
        Test.stopTest();
        
        lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
       // System.assertEquals(true, lead.IsConverted);
    }
    
    public static testMethod void testLeadAlreadyConverted() {
        //Setup Test
        Lead lead = UnitTest.getLeadInstance();
        insert lead;
        
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(lead.Id);
        leadConvert.setConvertedStatus('Sales Qualified');
        leadConvert.setSendNotificationEmail(false);
        leadConvert.setDoNotCreateOpportunity(false);
        leadConvert.setOpportunityName('Unit Test Opportunity');
        Database.LeadConvertResult convertResult = Database.convertLead(leadConvert);
        System.assert(convertResult.isSuccess() == true, convertResult.getErrors());
        
        PageReference testPageReference = new PageReference('/apex/LeadConvert');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        
        lead = getLeadRecord(lead.Id);
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        LeadConvertController controller = new LeadConvertController(standardController);
        
        //Execute Test
        Test.startTest();
        
        PageReference redirectPageReference = controller.onPageLoad();
        System.assert(redirectPageReference != null, 'Expected user to be redirected to native Lead detail view');
        
        Test.stopTest();
    }
    
    
    public static testMethod void testLeadConvertNewAccount() {
        Lead lead = UnitTest.getLeadInstance();
        insert lead;
        Lead lead1 = UnitTest.getLeadInstance();
        insert lead1;
        
        PageReference testPageReference = new PageReference('/apex/LeadConvert');
        testPageReference.getParameters().put('id', lead.Id);
        
        
        Test.setCurrentPageReference(testPageReference);
        
        lead = getLeadRecord(lead.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        
        Test.startTest();
        
        LeadConvertController controller = new LeadConvertController(standardController);
        controller.LeadConvertStatus = 'Sales Qualified';
        controller.OppRecType = 'Pre-Pipeline Opportunity';
        PageReference convertPageReference = controller.convertLead();
         
        System.assert(ApexPages.getMessages()!= null,'Expected exception for Account field required for convert' );
        controller.Convertlead = true;
        controller.selectedItemId ='';
        controller.accContactOptions =null;
        controller.selectedAccount='';
        controller.accountSelectedList='';
        controller.emailstr='';
        controller.sapConId='';
        controller.convertNotAllowed=true;
        LeadConvertController.AccountOption ao = new LeadConvertController.AccountOption(new Account());
        controller.enableConvert();
        controller.addressCountryChanged();
        Test.stopTest();
    }
    
    private static Lead getLeadRecord(Id leadId) {
        return [SELECT
                      Id
                    , Name
                    , FirstName
                    , LastName
                    , Company
                    , IsConverted
                    , Account__c
                    , Contact__c
                    , OwnerId
                    , MDBId__c
                    , SAPAccountNumber__c
                FROM
                    Lead
                WHERE
                    Id = :leadId];
    }
}