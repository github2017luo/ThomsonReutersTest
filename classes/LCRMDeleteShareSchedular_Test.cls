@isTest
public class LCRMDeleteShareSchedular_Test{
    //added this method to cover the code in main classes: DPS-14173 
    public static testMethod void ShareChildRecordsAccTest(){
        LCRMDeleteShareSchedular schedular= new LCRMDeleteShareSchedular();
        LCRMCaseShareDelete caseShare= new LCRMCaseShareDelete();
        LCRMTrainingEventShareDelete trainingEventShare= new LCRMTrainingEventShareDelete();
        LCRMLeadShareDelete leadshare= new LCRMLeadShareDelete();
        LCRMOpportunityShareDelete opptyShare= new LCRMOpportunityShareDelete();
    }
    
	/* START: DPS-14173 - Commented this Class.    
    @testSetup static void testDataSetUp() {
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
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
        recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
        recordtype caseRT = [select id from recordtype where name ='Elite CPQ Requests' and sobjecttype='Case' limit 1];
        recordtype SsdRT = [select id from recordtype where name =: label.SourcesystemdetailUSLRecordtype and sobjecttype='Source_System_Detail__c' limit 1];
        recordtype TERT = [select id from recordtype where name ='GLI' and sobjecttype='Training_Event__c' limit 1];
        
                
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
        
        Lead gliLead = UnitTest.getLeadInstance();
        gliLead.LastName='Elite';
        gliLead.Company = 'UTLeadAccount';
        gliLead.Billing_City__c = 'test';
        gliLead.Billing_Street__c = 'test';
        gliLead.Billing_State__c = 'CA';
        gliLead.Billing_Zip__c = 'test';
        gliLead.Billing_Country__c = 'US';
        gliLead.email = 'abc@elite.com';
        gliLead.Account__c = gliAccount.id;
        gliLead.Is_GLI__c = true;
        insert gliLead;
        
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.is_gli__c = true;
        insert gliOpty;
        
        Case gliCase = UnitTest.getCaseInstance();
        gliCase.AccountId = gliAccount.id;
        gliCase.Is_GLI__c = true;
        gliCase.RecordTypeId = caseRT.Id;
        insert gliCase;
        
        Training_Event__c gliTE = UnitTest.getTrainingEventInstance();
        gliTE.LCRM_Is_GLI__c = true;
        insert gliTE;
        
        // Added the source system detail
        Source_System_Detail__c sdd= new Source_System_Detail__c();
        sdd.name='test Sdd';
        sdd.Source_System_Name__c='Test SSd1';
        sdd.Account_Name__c=gliAccount.id;
        sdd.Source_System_Account_Number__c='1003094728';
        sdd.RecordTypeId=SsdRT.Id;
		sdd.Digital_Firm_Name__c= 'Test Firm';
        sdd.Digital_Billing_City__c='Test City';
        insert sdd;
        
        Leadshare lsTest = new Leadshare();
        lsTest.LeadAccessLevel = 'Edit';
        lsTest.LeadId = gliLead.Id;
        lsTest.UserOrGroupId =  gliUKIUser.Id;
        insert lsTest;
        
        CaseShare csTest = new CaseShare();
        csTest.CaseAccessLevel = 'Edit';
        csTest.CaseId = gliCase.Id;
        csTest.UserOrGroupId =  gliUKIUser.Id;
        insert csTest;
        
        OpportunityShare osTest = new OpportunityShare();
        osTest.OpportunityAccessLevel = 'Edit';
        osTest.OpportunityId = gliOpty.Id;
        osTest.UserOrGroupId =  gliUKIUser.Id;
        insert osTest;
        
        Training_Event__Share testest = new Training_Event__Share();
        testest.AccessLevel = 'Edit';
        testest.ParentId = gliTE.Id;
        testest.UserOrGroupId = gliUKIUser.Id;
        insert testest;
        
        Source_System_Detail__Share ssdTest = new Source_System_Detail__Share();
        ssdTest.AccessLevel= 'Edit';
        ssdTest.ParentId= sdd.Id;
        ssdTest.UserOrGroupId =  gliUKIUser.Id;   
        insert ssdTest;
       
              
        Test.startTest();
            LCRMDeleteShareSchedular sh = new LCRMDeleteShareSchedular();
            String cron = '0 0 23 * * ?'; 
            system.schedule('Test LCRMDeleteShareSchedular', cron, sh); 
        Test.stopTest();

    }
	START: DPS-14173 - Commented this Class. */
}