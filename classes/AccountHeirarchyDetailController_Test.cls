/**
* @author:        Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* @Date:          2020-01-13
* @Description:   Test class for the capex controller AccountHeirarchyDetailController
*/

@isTest
public class AccountHeirarchyDetailController_Test {
    
    /**
     * This method is used to set up the test data
     * <p>since 47.0 (Force.com ApiVersion)</p>
     * <p>
     * changelog
     * <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
     * <br> -- Created
     * </p>
     * @author   Jayanth Kumar
     * @date     2020-01-13 
     * @return   returns the test data for the SObject
     */ 
    
    @testSetup static void setupTestData(){
        Profile testprofile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User oUser = new User();
        oUser.profileid = testprofile.Id;
        oUSer.Username = 'TestUser@TR.com';
        oUser.LastName = 'XYZ';
        oUser.Email = 'abc@xyz.com';
        oUser.Alias = 'abctest';
        oUSer.CommunityNickname = 'CommunityNickname.testUser';
        oUSer.TimeZoneSidKey = 'America/Los_Angeles';
        oUser.LocaleSidKey = 'en_US';
        oUser.EmailEncodingKey = 'ISO-8859-1';
        oUSer.LanguageLocaleKey = 'en_US';
        oUSer.Sales_Org__c='GLI';
        insert oUSer;
        
        Account acct = new Account();
        acct.Name = 'Unit Test';
        acct.BillingCountry = 'US';
        acct.BillingState = 'TX';
        acct.Sales_Org__c = 'WEST';
        acct.Customer_Type__c = 'Individual';
        acct.Customer_Group__c = 'ACADEMIC';
        acct.Industry = 'TAX';
       // MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
       // MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert acct;
        
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        //ssd.Account__c=acct.Id;
        ssd.Source_System_Name__c='test';
        ssd.Address_2__c='test';
        insert ssd;
        
        Account acct1 = new Account();
        acct1.Name = 'Unit Test1';
        acct1.BillingCountry = 'US';
        acct1.BillingState = 'TX';
        acct1.Sales_Org__c = 'WEST1';
        acct1.Customer_Type__c = 'Individual1';
        acct1.Customer_Group__c = 'ACADEMIC1';
        acct1.Industry = 'TAX1';
        //MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        //MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert acct1;
        
        Training_Event__c te = new Training_Event__c();
        te.LCRM_Is_GLI__c = true;
        te.Account__c = acct.Id;
        te.Training_Name__c='TestEvent-01';
        te.Training_Type__c = 'Advanced';
        te.Status__c = 'Completed';
        te.OwnerId= oUser.id;
        insert te;
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        ali.Apttus_Config2__StartDate__c = Date.Today();
        ali.Apttus_Config2__AssetStatus__c = 'Activated';
        ali.Apttus_Config2__EndDate__c = Date.Today()+5;
        ali.APTS_Renewal_Type__c = 'Evergreen';
        insert ali;
        
        KeyValueListStore__c keyValueList=new KeyValueListStore__c();
        keyValueList.Name='ANZUsersProfileId';
        keyValueList.TextValue__c='00e30000001ZUki';
        insert keyValueList;
        KeyValueListStore__c reason=new KeyValueListStore__c();
        reason.Name='ReasonWithCompetitor';
        reason.TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other';
        insert reason;
        RecordtypeIds__c rec=new RecordtypeIds__c();
        rec.Name='Pre-Pipeline Opportunities';
        rec.recTypeId__c='01230000001MA4h';
        insert rec;
        RecordtypeIds__c rec1=new RecordtypeIds__c();
        rec1.Name='Pipeline Opportunities';
        rec1.recTypeId__c='01230000001MA4g';
        insert rec1;
        Opportunity opp = new Opportunity();
        opp.AccountId = acct.Id;
        opp.Name = 'Unit Test Opportuntiy';
        opp.CloseDate = System.Today() + 5;
        opp.StageName = 'Prospect';
        opp.isDigitalSpearHead__c = true;
        opp.ShipTo_Source_System_Detail__c=ssd.Id;
        opp.Owner=[SELECT Id,Name,Email from User LIMIT 1];
        insert opp;
        
        /*Apttus_Proposal__Proposal__c prop = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Test001', Apttus_Proposal__Account__c = acct.Id, Apttus_Proposal__Opportunity__c = opp.Id);
prop.Digital_Batch_Processed__c = TRUE;
prop.APTS_Order_Confirmation_Contact_Email__c = 'test.test@gmail.com';
prop.Digital_Quote_Type__c = 'Best Value';
prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
prop.Digital_Batch_Processed__c = TRUE;
prop.Digital_Ready_Online_Export__c = true;
prop.Apttus_Proposal__Primary__c = FALSE;
prop.APTS_SSD_bill_to__c=ssd.Id;
insert prop;*/
        
        Contact con = new Contact();
        con.AccountId = acct.Id;
        con.FirstName = 'Unit';
        con.LastName = 'Test';
        con.MailingStreet = '123 Unit Test';
        con.MailingCity = 'Dallas';
        con.MailingCountry = 'US';
        con.MailingState = 'TX';
        con.MailingPostalCode = '75019';
        
        //Setup required mock web service requests
        MDBIntegrationUtil_Test.setupUpsertContactServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertContactSuccessResponse();
        insert con;
        
        Case cs = new Case();
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
        cs.ContactId=con.Id;
        cs.CurrencyIsoCode='USD';
        cs.Status='New';
        cs.Origin='Email';
        insert cs; 
        
       /* recordtype  taskrecordtype = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND Name = 'S2E Record Type'];
        Task tasks = new Task();
        tasks .RecordTypeId  =taskrecordtype .Id;
        tasks.Owner_Group__c = 'Inside Sales';
        //tasks.Status__c = 'Pending';
        //tasks.Status = 'Pending';
        tasks.Subject = 'test Subject';
        tasks.WhatId = acct.Id;
        tasks.whoId= con.id;
        tasks.Type = 'Outbound Call';
        tasks.ActivityDate = System.Today();
        tasks.ReminderDateTime = System.DateTime.Now();
        insert tasks;*/
        
        Event evt = new Event();
        evt.WhoId = con.Id;
        evt.Training_Event_Id__c = te.Id;
        //evt.Training_Event_Name__c = mapTrainingEvent.get(t.WhatId).Name;
        evt.WhatId = acct.Id;
        evt.DurationInMinutes=10;
        evt.ActivityDate=system.Today();
        evt.ActivityDateTime=system.Today();
        insert evt;
    }
    
     /**
    * This method is used to test AccountHeirarchyDetailController functionality with test parameters.
    * <p>since 47.0 (Force.com ApiVersion)</p>
    * <p>
    * changelog
    * <br> - 2020-01-13 Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
    * <br> -- Created
    * </p>
    * @author   Jayanth Kumar
    * @date     2020-01-13  
    */
    
    @isTest static void testgetChildObjectDetails(){
        Test.startTest();
        List<Id> lId = new List<Id>();
        for(Account acct2 :[SELECT Id FROM Account where Name IN ('Unit Test','Unit Test1') LIMIT 2]){
            lId.add(acct2.Id);
        }
        
        AccountHeirarchyDetailController.getChildObjectDetails([SELECT Id FROM Account where Name = 'Unit Test' LIMIT 1].Id);
        AccountHeirarchyDetailController.ProposalWrap prop = new AccountHeirarchyDetailController.ProposalWrap();
        prop.proposalName='test';
        prop.name='test';
        prop.ownerFN='test';
        prop.ownerLN='test';
        prop.opp='test';
        prop.oppUrl='test';
        prop.stage='test';
        prop.propUrl='test';
        prop.createdDate=System.Today();
        prop.activationDate=System.Today() + 5;
        AccountHeirarchyDetailController.getProposals(lId,2);
        AccountHeirarchyDetailController.getTrainingEvents(lId,2);
        AccountHeirarchyDetailController.getCases(lId,2);
        AccountHeirarchyDetailController.getActHis(lId,2);
        AccountHeirarchyDetailController.ActivityHistoryWrap actwrap = new AccountHeirarchyDetailController.ActivityHistoryWrap();
        actwrap.name='test';
        actwrap.relTo='test';
        actwrap.taskName='test';
        actwrap.comments='test';
        actwrap.dueDate=System.Today();
        actwrap.assignedTo='test';
        actwrap.lastmodified=System.Today()+5;
        actwrap.taskUrl='test';
        actwrap.astoUrl='test';
        actwrap.actUrl='test'; 
        actwrap.subjectURL='test';
        actwrap.subject='test';
        actwrap.activityType='test';
        actwrap.whatIdUrl='test';   
        actwrap.whatId='test';   
        actwrap.whoIdUrl='test';  
        actwrap.whoId='test'; 
        actwrap.status='test'; 
        actwrap.ownerIdUrl='test';
        actwrap.ownerId='test'; 
        actwrap.assignedToUrl='test';
        AccountHeirarchyDetailController.ActivityWrap actywrap = new AccountHeirarchyDetailController.ActivityWrap();
        actywrap.subjectURL='test';
        actywrap.Name='test';
        actywrap.leadConName='test';
        actywrap.subject='test';
        actywrap.status='test';
        actywrap.comments='test';
        actywrap.dueDate='test';
        actywrap.owner='test';
        actywrap.ownerUrl='test';
        actywrap.contactUrl='test'; 
        actywrap.leadUrl='test';      
        actywrap.whatIdURL='test';  
        actywrap.whatId='test';  
        actywrap.whoId='test';   
        actywrap.leadContactUrl='test';  
        actywrap.ActivityType='test';
        AccountHeirarchyDetailController.getActivities(lId,2);
        Test.stopTest();
    }
    
     /**
    * This method is used to test AccountHeirarchyDetailController functionality without test parameters.
    * <p>since 47.0 (Force.com ApiVersion)</p>
    * <p>
    * changelog
    * <br> - 2020-01-13 Jayanth Kumar <jayanth.kumar@thomsonreuters.com> 
    * <br> -- Created
    * </p>
    * @author   Jayanth Kumar
    * @date     2020-01-13 
    */
    
    @isTest static void testgetChildObjectDetailsNegative (){ 
        try{
            Test.startTest();
            AccountHeirarchyDetailController.getChildObjectDetails(null);
            AccountHeirarchyDetailController.getTrainingEvents(null,null);
            AccountHeirarchyDetailController.getCases(null,null);
            AccountHeirarchyDetailController.getActHis(null,null);
            AccountHeirarchyDetailController.getProposals(null,null);
            AccountHeirarchyDetailController.getActivities(null,null);
            Test.stopTest();
        }catch(Exception ex){
            System.assertNotEquals(ex.getMessage(), null);
        }
    }    
}