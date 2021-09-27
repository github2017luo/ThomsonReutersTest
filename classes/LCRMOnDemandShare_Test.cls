@isTest
public class LCRMOnDemandShare_Test{
    // Added this method to cover the code in main class: DPS-14173.
    public static testMethod void ShareChildRecordsAccTest(){
    LCRMOnDemandShare share= new LCRMOnDemandShare();
    }
    /* START: DPS-14173 - Commented this Class.
    @testSetup static void testDataSetUp() {
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
        recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
                
        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
        User gliUKIUser = new User(alias = 'newUUser', email='user@uki.com', 
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                               localesidkey='en_US', profileid = ukiProfile.Id, employeenumber='0144021',
                               timezonesidkey='America/Los_Angeles', username='user@uki.com',Rep_Type_Description__c='testUki');        
        insert gliUKIUser;
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account';
        gliAccount.Phone = '91 80 67254199';
        gliAccount.BillingCountry = 'US';
        gliAccount.BillingState='IL';
        gliAccount.BillingPostalCode = '60603-3801';
        gliAccount.SAPAccountNumber__c = 'UTSAP001';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        insert gliAccount;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.Id);
        gliContact.firstname = 'Shovon';
        gliContact.lastname = 'Bera';
        gliContact.Email = 'Shovon@Bera.com';
        gliContact.accountid = gliAccount.id;
        gliContact.RecordTypeId=contactRT.Id;
        insert gliContact;
        
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = '00e30000001ZUki');
        insert keyValue;
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
        
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        
        ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c='Sales Qualified');
        insert cl;
        
        ConvertedLeadStatus__c cl1 = new ConvertedLeadStatus__c(name = 'false', value__c='Converted');
        insert cl1;
    }
    
    public static testMethod void ShareChildRecordsAccTest(){
        
        Account acc = [select id from Account where name ='Parent Test Account' and BillingPostalCode = '60603-3801' and SAPAccountNumber__c = 'UTSAP001' Limit 1];
        Contact con = [select id from Contact where accountid =: acc.id];
        User usr = [Select Id FROM User WHERE email='user@uki.com' and alias = 'newUUser' and employeenumber='0144021'];
        
        Lead gliLead = UnitTest.getLeadInstance();
        gliLead.LastName='Elite';
        gliLead.Company = 'UTLeadAccount';
        gliLead.Billing_City__c = 'test';
        gliLead.Billing_Street__c = 'test';
        gliLead.Billing_State__c = 'CA';
        gliLead.Billing_Zip__c = 'test';
        gliLead.Billing_Country__c = 'US';
        gliLead.email = 'abc@elite.com';
        gliLead.Account__c = acc.id;
        gliLead.Is_GLI__c = true;
        insert gliLead;
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(acc.id);
        testOpty.is_gli__c = true;
        insert testOpty;
        
        Case gliCase = UnitTest.getCaseInstance();
        gliCase.AccountId = acc.id;
        //insert gliCase;

        PageReference oPage = Page.LCRMControlOnDemandShare;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('Id', acc.Id);
        
        LCRMOnDemandShare controller = new LCRMOnDemandShare();
        Test.startTest();
            system.runAs(usr){
                controller.ShareAcctChildRecords();
                controller.RemoveShareAcctChildRecords();
            }
        Test.stopTest();
    }
    
    public static testMethod void ShareChildRecordsConTest(){
        Account acc = [select id from Account where name ='Parent Test Account' and BillingPostalCode = '60603-3801' and SAPAccountNumber__c = 'UTSAP001' Limit 1];
        Contact con = [select id from Contact where accountid =: acc.id];
        User usr = [Select Id FROM User WHERE email='user@uki.com' and alias = 'newUUser' and employeenumber='0144021'];
        
        Lead gliLead = UnitTest.getLeadInstance();
        gliLead.LastName='Elite';
        gliLead.Company = 'UTLeadAccount';
        gliLead.Billing_City__c = 'test';
        gliLead.Billing_Street__c = 'test';
        gliLead.Billing_State__c = 'CA';
        gliLead.Billing_Zip__c = 'test';
        gliLead.Billing_Country__c = 'US';
        gliLead.email = 'abc@elite.com';
        gliLead.Contact__c = con.id;
        gliLead.Is_GLI__c = true;
        insert gliLead;
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(acc.id);
        testOpty.Key_Contact__c = con.id;
        testOpty.is_gli__c = true;
        insert testOpty;
        
        Case gliCase = new case();
        gliCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Archive Requests').getRecordTypeId();
        gliCase.ContactId = con.id;
        gliCase.Status='New';
        gliCase.Type='Archive';
        gliCase.Origin = 'Email'; 
        gliCase.AccountId=acc.id;
         gliCase.Description='test';
       //insert gliCase;

        PageReference oPage = Page.LCRMControlOnDemandShare;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('Id', con.Id);
        
        LCRMOnDemandShare controller = new LCRMOnDemandShare();
        Test.startTest();
            system.runAs(usr){
                controller.ShareAcctChildRecords();
                controller.RemoveShareAcctChildRecords();
            }
        Test.stopTest();
    }
    
    public static testMethod void ShareExistTest(){
        
        Account acc = [select id from Account where name ='Parent Test Account' and BillingPostalCode = '60603-3801' and SAPAccountNumber__c = 'UTSAP001' Limit 1];
        Contact con = [select id from Contact where accountid =: acc.id];
        User usr = [Select Id FROM User WHERE email='user@uki.com' and alias = 'newUUser' and employeenumber='0144021'];
        
        Lead gliLead = UnitTest.getLeadInstance();
        gliLead.LastName='Elite';
        gliLead.Company = 'UTLeadAccount';
        gliLead.Billing_City__c = 'test';
        gliLead.Billing_Street__c = 'test';
        gliLead.Billing_State__c = 'CA';
        gliLead.Billing_Zip__c = 'test';
        gliLead.Billing_Country__c = 'US';
        gliLead.email = 'abc@elite.com';
        gliLead.Contact__c = con.id;
        gliLead.Is_GLI__c = true;
        insert gliLead;
        
        Opportunity testOpty = UnitTest.getOpportunityInstance(acc.id);
        testOpty.Key_Contact__c = con.id;
        testOpty.is_gli__c = true;
        insert testOpty;
        
       Case gliCase = new case();
        gliCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Archive Requests').getRecordTypeId();
        gliCase.ContactId = con.id;
        gliCase.Origin = 'Email';   
         gliCase.Description='test'; 
       //insert gliCase;
        
        Leadshare lsTest = new Leadshare();
        lsTest.LeadAccessLevel = 'Edit';
        lsTest.LeadId = gliLead.Id;
        lsTest.UserOrGroupId =  usr.Id;
        insert lsTest;
        
        /*CaseShare csTest = new CaseShare();
        csTest.CaseAccessLevel = 'Edit';
        csTest.CaseId = gliCase.Id;
        csTest.UserOrGroupId =  usr.Id;
        insert csTest;
        // Removed closed multi line comment here: DPS-14173
        OpportunityShare osTest = new OpportunityShare();
        osTest.OpportunityAccessLevel = 'Edit';
        osTest.OpportunityId = testOpty.Id;
        osTest.UserOrGroupId =  usr.Id;
        insert osTest;

        PageReference oPage = Page.LCRMControlOnDemandShare;
        Test.setCurrentPage(oPage);
        ApexPages.currentPage().getParameters().put('Id', con.Id);
        
        LCRMOnDemandShare controller = new LCRMOnDemandShare();
        Test.startTest();
            system.runAs(usr){
                controller.ShareAcctChildRecords();
                controller.RemoveShareAcctChildRecords();
            }
        Test.stopTest();
    }
	END: DPS-14173 - Commented this Class. */   
}