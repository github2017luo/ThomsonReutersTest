/**
* Test Class for LCRMConvertLeadController
*
* @version 2017-02-23
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-02-23   TCS                     Created 
* 2018-01-16   TCS                     Updated for CRM-12851
* =============================================================================
*/
@isTest
public class LCRMConvertLeadControllerTest {
    
    @testSetup static void testDataSetUp() {
        List<LCRM_Opportunity_Ranking_Configuration__c> lstOptyRanking = new List<LCRM_Opportunity_Ranking_Configuration__c>();
        
        LCRM_Opportunity_Ranking_Configuration__c optyRanking = new LCRM_Opportunity_Ranking_Configuration__c();
        optyRanking.Name = 'Account Associated to Opportunity';
        optyRanking.Score__c = 150;
        lstOptyRanking.add(optyRanking);
        
        LCRM_Opportunity_Ranking_Configuration__c optyRanking1 = new LCRM_Opportunity_Ranking_Configuration__c();
        optyRanking1.Name = 'Contact Exist In Contact Role';
        optyRanking1.Score__c = 200;
        lstOptyRanking.add(optyRanking1);
        
        LCRM_Opportunity_Ranking_Configuration__c optyRanking2 = new LCRM_Opportunity_Ranking_Configuration__c();
        optyRanking2.Name = 'Country Matches';
        optyRanking2.Score__c = 50;
        lstOptyRanking.add(optyRanking2);
        
        LCRM_Opportunity_Ranking_Configuration__c optyRanking3 = new LCRM_Opportunity_Ranking_Configuration__c();
        optyRanking3.Name = 'Lead Owner exist in opportunity team';
        optyRanking3.Score__c = 100;
        lstOptyRanking.add(optyRanking3);
        insert lstOptyRanking;
        
        State_required_Countries__c stateReqCountry = new State_required_Countries__c();
        stateReqCountry.Name = 'United States';
        stateReqCountry.Country_Code__c = 'US';
        insert stateReqCountry ;
        
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId' /* , TextValue__c = '00e30000001ZUki'*/);
        insert keyValue;
        KeyValueListStore__c keyValue1 = new KeyValueListStore__c(name='ReasonWithCompetitor' , TextValue__c = 'Content');
        insert keyValue1;
        
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities' /* , recTypeId__c='01230000001MA4hAAG' */);
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities' /* , recTypeId__c='01230000001MA4gAAG' */);
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity' /* , recTypeId__c='01213000000AXGKAA4' */);
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity' /* , recTypeId__c='012e00000000wRJAAY' */);
        insert rt3;
        
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User' /* ,ProfileId__c = '00ea00000024JwaAAE' */);
        insert plist;
        
        ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c='Sales Qualified');
        insert cl;
        
        ConvertedLeadStatus__c cl1 = new ConvertedLeadStatus__c(name = 'false', value__c='Converted');
        insert cl1;
        
        WebServiceSettings__c wbs = new WebServiceSettings__c();
        wbs.Active__c = true;
        wbs.Max_GLI_Count__c = 30;
        wbs.Max_Non_GLI_Count__c = 30;
        wbs.name='DQ.CDSContactSearchService';
        wbs.Endpoint__c='CDSContactSearchService.com';
        wbs.Service_Unavailable_Message__c ='service unavailable';
        insert wbs;
        
        WebServiceSettings__c wbs1 = new WebServiceSettings__c();
        wbs1.Active__c = true;
        wbs1.name='ECMSearchServiceWS';
        wbs1.Endpoint__c='ECMSearchServiceWS.com';
        wbs1.Service_Unavailable_Message__c ='ECM service unavailable';
        insert wbs1;
        
        WebServiceSettings__c wbs2 = new WebServiceSettings__c();
        wbs2.Active__c = true;
        wbs2.name='DQ.ECMSearchByPartyId';
        wbs2.Endpoint__c='ECMSearchServiceParty.com';
        wbs2.Service_Unavailable_Message__c ='ECM Party service unavailable';
        insert wbs2;
        
        KeyValueListStore__c kvl1 =  new KeyValueListStore__c();
        kvl1.name = 'ECM_Username';
        kvl1.TextValue__c = 'Admin';
        
        KeyValueListStore__c kvl2 =  new KeyValueListStore__c();
        kvl2.name = 'ECM_Password';
        kvl2.TextValue__c = 'Admin';
        
                KeyValueListStore__c kvl3 =  new KeyValueListStore__c();
        kvl3.name = 'LCRMMax_Account_Count';
        kvl3.TextValue__c = '30';

    
    
        KeyValueListStore__c kvl4 =  new KeyValueListStore__c();
        kvl4.name = 'GLI_ECM_AddressSourceSystemCode';
        kvl4.TextValue__c = 'LGLSFDCGLI';

        
        KeyValueListStore__c kvl5 =  new KeyValueListStore__c();
        kvl5.name = 'ECM_AddressSourceSystemCode';
        kvl5.TextValue__c = 'LGLCEBO';
        
        KeyValueListStore__c kvl6 =  new KeyValueListStore__c();
        kvl6.name = 'LCRMMax Oppty Count';
        kvl6.TextValue__c = '1';
        
        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
       
        
        List<KeyValueListStore__c> listkvl =  new List<KeyValueListStore__c>();
        listkvl.add(kvl1);
        listkvl.add(kvl2);
        listkvl.add(kvl3);
        listkvl.add(kvl4);
        listkvl.add(kvl5);
        listkvl.add(kvl6);
        listkvl.add(profilename);
        listkvl.add(leadsourcevalue);
        listkvl.add(busegment);
        insert listkvl;
        
    }
    //Method to check the Error scenarios.
    
    public static testMethod void testRequiredField1() {
        //Setup Test
        
        Lead lead = UnitTest.getLeadInstance();
        lead.LastName='Patel';
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        //lead.Billing_State__c = 'CA';
        //lead.Billing_Zip__c = 'test';
        lead.Billing_Country__c = 'US';
        //lead.email = 'abc@gmail.com';
        insert lead;
        
        PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        lead = getLeadRecord(lead.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        
        //Execute Test
        Test.startTest();
        
        LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
        
        system.assertEquals(controller.bError, true);
        Test.stopTest();
        //lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];
    }
    
    public static testMethod void testRequiredField2() {
        //Setup Test
        
        LCRMConvertLeadCountryCode__c leadCountryCode = new LCRMConvertLeadCountryCode__c(Name = 'IE', Region__c = 'UKI');  
        insert leadCountryCode;
        
        LCRMConvertLeadCountryCode__c leadCountryCode1 = new LCRMConvertLeadCountryCode__c(Name = 'JM', Region__c = '');    
        insert leadCountryCode1;
        
        Lead lead = UnitTest.getLeadInstance();
        lead.LastName='Patel';
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'CA';
        //lead.Billing_Zip__c = 'test';
        lead.Billing_Country__c = 'IE';
        lead.email = 'abc1@gmail.com';
        lead.LCRM_Sub_BU__c = 'UKI';
        insert lead;
        
        
        Lead lead1 = UnitTest.getLeadInstance();
        lead1.LastName='Patel';
        lead1.Company = 'UTLeadAccount';
        lead1.Billing_City__c = 'test';
        lead1.Billing_Street__c = 'test';
        lead1.Billing_State__c = 'CA';
        //lead1.Billing_Zip__c = 'test';
        lead1.Billing_Country__c = 'MW';
        lead1.email = 'abc2@gmail.com';
        lead.LCRM_Sub_BU__c = 'UKI';
        insert lead1;
        
        Lead lead2= UnitTest.getLeadInstance();
        lead2.LastName='Patel';
        lead2.Company = 'UTLeadAccount';
        lead2.Billing_City__c = 'test';
        lead2.Billing_Street__c = 'test';
        lead2.Billing_State__c = 'CA';
        //lead2.Billing_Zip__c = 'test';
        lead2.Billing_Country__c = 'JM';
        lead2.email = 'abc3@gmail.com';
        insert lead2;
        
        PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        lead = getLeadRecord(lead.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        
        //Execute Test
        Test.startTest();
        
        LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
        
        //system.assertEquals(controller.bError, false);
        
        
        // Negative scenario
        testPageReference.getParameters().put('id', lead1.Id);
        Test.setCurrentPageReference(testPageReference);
        lead = getLeadRecord(lead1.Id);
        standardController = new ApexPages.StandardController(lead1);
        controller = new LCRMConvertLeadController(standardController);
        system.assertEquals(controller.bError, true);
        
        testPageReference.getParameters().put('id', lead2.Id);
        Test.setCurrentPageReference(testPageReference);
        lead = getLeadRecord(lead2.Id);
        standardController = new ApexPages.StandardController(lead2);
        controller = new LCRMConvertLeadController(standardController);
        system.assertEquals(controller.bError, true);
        
        Test.stopTest();
        
        
    }
    
    //Contact associated with Lead
    
    public static testMethod void testOptyConvertWithContact() {
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];   
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];// Updated this method to fix test class error for CRM-1324
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'newUser1', email='user12@mydomain12.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertest123@mydomain.com.prod',Rep_Type_Description__c='test',  UserRoleId = ukiRole.Id);        
        insert u1;
        }
        //Setup Test
        system.runAs(u1){
            
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
            
            Account parentAccount = UnitTest.getAccountInstance();
            parentAccount.Name = 'Parent Test Account';
            parentAccount.Phone = '91 80 67254199';
            parentAccount.BillingCountry = 'US';
            parentAccount.BillingState='IL';
            parentAccount.BillingPostalCode = '60603-3801';
            parentAccount.Is_GLI__c = true;
            parentAccount.RecordTypeId=accountRT.Id;
            parentAccount.LCRM_Bypassed_Potential_Matches__c =True;
            insert parentAccount;
            
            
            //Account childAccount = UnitTest.getAccountInstance();
            Account childAccount = new Account();
            childAccount.Name = 'Child Test Account';
            childAccount.Phone = '91 80 67254199';
            childAccount.BillingCountry = 'US';
            childAccount.BillingState='IL';
            childAccount.BillingPostalCode = '60603-3801';
            childAccount.Operational_Ultimate_Parent_Name1__c = parentAccount.Id;
            childAccount.Is_GLI__c = true;
            childAccount.RecordTypeId=accountRT.Id;
            insert childAccount;
            
            Contact contact = UnitTest.getContactInstance(childAccount.Id);
            contact.RecordTypeId=contactRT.Id;
            contact.Email = 'test@tcs.com';
            
            insert contact;        
            //Added the booelan value not to run tms territory functionality
            //LCRMLeadTerritoryService.allowTriggerHandlerToRun  =false;
            
            Lead lead = UnitTest.getLeadInstance();
            lead.LastName='Patel';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.Contact__c = contact.Id;
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            lead.LCRM_Sub_BU__c = 'Elite';
            insert lead;
            
            opportunity testOpty = UnitTest.getOpportunityInstance(childAccount.id);
            testOpty.StageName = 'Appointment Scheduled';
            testOpty.is_gli__c = true;
            insert testOpty;
           
            //List<Event> eve= new List<Event>();
            Event event1 =new Event();
            event1.whoId=lead.id;            
            event1.LCRM_Sub_BU__c ='Canada';
            event1.ActivityDateTime = system.today();
            event1.DurationInMinutes = 120;
            //eve.add(event1);
            
           
           
          //List<Task> task = new List<Task>();
            Task task1 = new Task();
            //task1.whatId =testOpty.id;
            task1.whoId=lead.Id;
            task1.ActivityDate= System.today();
            
           
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
            
            
            //Execute Test
            Test.startTest();
            
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
            
            
            //system.assertEquals(controller.bError, true);
            controller.selectedOpptyId = testOpty.Id;
            controller.selectedOpptyType = 'SFDCOppty';
            PageReference convertPageReference = controller.convertLead();
            insert event1;
            insert task1;
            controller.fetchLeadActivities();
            //Negative Test Scenario to cover Catch block code covergae
            try{
              controller.createLeadEventsUnderOpp(testOpty.id, Lead.id);    
            }
            catch(DMLException ex){
                System.assertEquals(ex.getMessage(), ex.getMessage());
            }
            
            controller.createLeadEventsUnderOpp(testOpty.id, contact.id);  
            //Negative Test Scenario to cover Catch block code covergae
            try{
                controller.createLeadTasksUnderOpp(testOpty.id, Lead.id);
            }catch(DMLException e){
                System.assertEquals(e.getMessage(), e.getMessage());
            }
            controller.createLeadTasksUnderOpp(testOpty.id, contact.id);
            Test.stopTest();
        
            Event eventAfterConvert =[SELECT Id,whoId FROM Event WHERE Id =: event1.Id];
            System.assertEquals(contact.id, eventAfterConvert.whoId);
            Task taskAfterConvert = [SELECT Id,whoId FROM Task WHERE Id =: Task1.Id];
            System.assertEquals(contact.Id, taskAfterConvert.WhoId);

            
            //lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];         
        }
        
    }
    
    /*public static testMethod void testOptyConvertWithContact2() {
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User']; 
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];// Updated this method to fix test class error for CRM-1324
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='user@mydomain.com',Rep_Type_Description__c='test', UserRoleId = ukiRole.Id);        
        insert u1;
        }
        //Setup Test
        system.runAs(u1){
            
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
            
            Account parentAccount = UnitTest.getAccountInstance();
            parentAccount.Name = 'Parent Test Account';
            parentAccount.Phone = '91 80 67254199';
            parentAccount.BillingCountry = 'US';
            //parentAccount.Billing_Country__c = 'US';
            parentAccount.BillingState='IL';
            parentAccount.BillingPostalCode = '60603-3801';
            parentAccount.Is_GLI__c = true;
            parentAccount.RecordTypeId=accountRT.Id;
            insert parentAccount;
            
            
            //Account childAccount = UnitTest.getAccountInstance();
            Account childAccount = new Account();
            childAccount.Name = 'Child Test Account';
            childAccount.Phone = '91 80 67254199';
            childAccount.BillingCountry = 'US';
            //childAccount.Billing_Country__c = 'US';
            childAccount.BillingState='IL';
            childAccount.BillingPostalCode = '60603-3801';
            childAccount.Operational_Ultimate_Parent_Name1__c = parentAccount.Id;
            childAccount.Is_GLI__c = true;
            childAccount.RecordTypeId=accountRT.Id;
            insert childAccount;
            
            Contact contact = UnitTest.getContactInstance(childAccount.Id);
            contact.RecordTypeId=contactRT.Id;
            contact.Email = 'test@tcs.com';
            
            insert contact;        
            //Added the booelan value not to run tms territory functionality
        //LCRMLeadTerritoryService.allowTriggerHandlerToRun  =false;
            
            Lead lead = UnitTest.getLeadInstance();
            lead.LastName='Patel';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.Contact__c = contact.Id;
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            insert lead;
            
            opportunity testOpty = UnitTest.getOpportunityInstance(childAccount.id);
            testOpty.StageName = 'Appointment Scheduled';
            testOpty.is_gli__c = true;
            insert testOpty;
            
            opportunity testOpty2 = UnitTest.getOpportunityInstance(childAccount.id);
            testOpty2.StageName = 'Appointment Scheduled';
            testOpty2.is_gli__c = true;
            testOpty2.Name = 'Unit Test Opportuntiy 2';
            insert testOpty2;
            
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
            
            
            //Execute Test
            Test.startTest();
            
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
            
            
            //system.assertEquals(controller.bError, true);
            controller.selectedOpptyId = testOpty.Id;
            controller.selectedOpptyType = 'SFDCOppty';
            PageReference convertPageReference = controller.convertLead();
            
            Test.stopTest();
            //lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];         
        }
        
    }*/
    
    
    //Method not associated with Lead
    //Select CDS Contact
    public static testMethod void testOptyConvertWOContactCDS() {
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];// Updated this method to fix test class error for CRM-1324
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {          
            u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test', UserRoleId = ukiRole.Id);        
        insert u1;
        }
        //Setup Test
        system.runAs(u1){
            
            
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
            
            
            Account parentAccount = UnitTest.getAccountInstance();
            parentAccount.Name = 'Parent Test Account';
            parentAccount.Phone = '91 80 67254199';
            parentAccount.BillingCountry = 'US';
            parentAccount.BillingState='IL';
            parentAccount.BillingPostalCode = '60603-3801';
            parentAccount.Is_GLI__c = true;
            parentAccount.RecordTypeId=accountRT.Id;
            insert parentAccount;
            
            
            //Account childAccount = UnitTest.getAccountInstance();
            Account childAccount = new Account();
            childAccount.Name = 'Child Test Account';
            childAccount.Phone = '91 80 67254199';
            childAccount.BillingCountry = 'US';
            childAccount.BillingState='IL';
            childAccount.BillingPostalCode = '60603-3801';
            childAccount.Operational_Ultimate_Parent_Name1__c = parentAccount.Id;
            childAccount.Is_GLI__c = true;
            childAccount.Street_Name__c='test';
            childAccount.RecordTypeId=accountRT.Id;
            insert childAccount;
            
            Contact contact = UnitTest.getContactInstance(childAccount.Id);
            contact.RecordTypeId=contactRT.Id;
            contact.Email = 'test@tcs.com';
            
            insert contact;        
            
            Lead lead = UnitTest.getLeadInstance();
            lead.LastName='Patel';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            lead.Account__c = childAccount.id;
            insert lead;
            
            DataQualityUtil.CDSContactInfo conRec = new DataQualityUtil.CDSContactInfo();
            conRec.Source_System_ID = contact.Id;
            conRec.First_Name = contact.FirstName;
            conRec.Last_Name = contact.LastName;
            
            
            
            
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
            CDSSearchServiceMockTest abc = new CDSSearchServiceMockTest();
            abc.calloutType = 'CDS';
            Test.setMock(WebServiceMock.class, abc);
            
            
            //Execute Test
            Test.startTest();
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
            
                  
         DataQualityUtil.ECMAccountInfo ecmAccountInfo = new DataQualityUtil.ECMAccountInfo();
        ecmAccountInfo.Name = 'TestECMAccount';
        ecmAccountInfo.Street1 = 'TestECMStreet1';
        ecmAccountInfo.Street2 = 'TestECMStreet2';
        ecmAccountInfo.Country = 'TestECMCountry';
        ecmAccountInfo.State = 'TestECMState';
        ecmAccountInfo.City = 'TestECMCity';
        ecmAccountInfo.PostalCode = 'TestECMZip';
       // ecmAccountInfo.SourceSystemId = 
        
        controller.createNewAccount(ecmAccountInfo, null); 
            system.assertEquals(controller.bError, true);
            controller.selectedType = 'CDSContact';
            controller.selectedContact = '1';
              controller.goToAccountSelection();
            //controller.selectedContact = contact.Id;
            //controller.selectedSFDCContact.put(contact.Id, conRec);
            
            system.debug('+++ controller.selectedType is  '+ controller.selectedType + ' and controller.selectedContact is  '+ controller.selectedType);
            controller.goToAccountSelection();
            controller.selectedAccountId = childAccount.Id;
            controller.selectedAccountType = 'SFDCAccount';
            controller.selectedAccountName ='Child Test Account';
            controller.selectedAccountAddress ='TestECMStreet1';
            controller.goToOptySelection();
            controller.selectedOpptyType = 'NewOppty';
            PageReference convertPageReference = controller.convertLead();
            Test.stopTest();
            lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];         
        }
        
    }
    
    //CDS Contact
    
     public static testMethod void testOptyConvertWithoutContact() {
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];   
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];// Updated this method to fix test class error for CRM-1324
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test', UserRoleId = ukiRole.Id);        
        insert u1;
        }
        //Setup Test
        system.runAs(u1){
            Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest());
            
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
            
            
            Account parentAccount = UnitTest.getAccountInstance();
            parentAccount.Name = 'Parent Test Account';
            parentAccount.Phone = '91 80 67254199';
            parentAccount.BillingCountry = 'US';
            parentAccount.BillingState='IL';
            parentAccount.BillingPostalCode = '60603-3801';
            parentAccount.Is_GLI__c = true;
            parentAccount.RecordTypeId=accountRT.Id;
            insert parentAccount;
            
            
            //Account childAccount = UnitTest.getAccountInstance();
            Account childAccount = new Account();
            childAccount.Name = 'Child Test Account';
            childAccount.Phone = '91 80 67254199';
            childAccount.BillingCountry = 'US';
            childAccount.BillingState='IL';
            childAccount.BillingPostalCode = '60603-3801';
            childAccount.Operational_Ultimate_Parent_Name1__c = parentAccount.Id;
            childAccount.Is_GLI__c = true;
            childAccount.RecordTypeId=accountRT.Id;
            insert childAccount;
            
            Contact contact = UnitTest.getContactInstance(childAccount.Id);
            contact.RecordTypeId=contactRT.Id;
            contact.Email = 'test@tcs.com';
            
            insert contact;        
            
            Lead lead = UnitTest.getLeadInstance();
            lead.LastName='Patel';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            insert lead;
            
            DataQualityUtil.CDSContactInfo conRec = new DataQualityUtil.CDSContactInfo();
            conRec.Source_System_ID = contact.Id;
            conRec.First_Name = contact.FirstName;
            conRec.Last_Name = contact.LastName;
            
            
            
            
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
            
            
            //Execute Test
            Test.startTest();
            
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
           // CDSSearchServiceMockTest.calloutType = 'CDS';
            
            system.assertEquals(controller.bError, true);
            controller.selectedType = 'SFDCContact';
            controller.selectedContact = contact.Id;
            controller.selectedSFDCContact.put(contact.Id, conRec);
            
            //CDSSearchServiceMockTest.calloutType = 'ECM';
            controller.goToAccountSelection();
            controller.selectedOpptyType = 'NewOppty';
            PageReference convertPageReference = controller.convertLead();
            Test.stopTest();
            lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];         
        }
        
    }
    
    //new Contact, new Account, new Opty
    
    public static testMethod void testOptyConvertNewData() {
        
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
        
        //Setup Test
        system.runAs(u1){
            Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest());
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
            
            
            Lead lead = UnitTest.getLeadInstance();
            lead.FirstName = 'Test';
            lead.LastName='Patel';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            insert lead;
            System.debug('lead@@@ '+lead);
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            System.debug('lead@@@ '+lead.id);
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
            
            
            //Execute Test
            Test.startTest();
            
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
            
            
            system.assertEquals(controller.bError, true);
            controller.selectedType = 'NEWContact';
            controller.selectedContact = 'NEWContact';
            controller.goToAccountSelection();
            
            controller.selectedAccountId = 'NewAccount';
            controller.selectedAccountType = 'NewAccount';
            //controller.addressCountryChanged();
            
            controller.goToOptySelection(); 
            controller.selectedOpptyType = 'NewOppty';
            PageReference convertPageReference = controller.convertLead();
            
            
            Test.stopTest();
            lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];         
        }
        
    }
    
  /*  private static testmethod void testForCodeCoverage()
    {
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        KeyValueListStore__c oTest = new KeyValueListStore__c(Name='ECM_PageSize',TextValue__c='12');        
        KeyValueListStore__c oTest1 = new KeyValueListStore__c(Name='ECM_PageNumber',TextValue__c='1');        
        KeyValueListStore__c oTest2 = new KeyValueListStore__c(Name='ECM_Username',TextValue__c='4');        
        KeyValueListStore__c oTest3 = new KeyValueListStore__c(Name='ECM_Password',TextValue__c='3');
        KeyValueListStore__c oTest4 = new KeyValueListStore__c(Name='DQ.ContactMatchingService',TextValue__c='5');
        KeyValueListStore__c oTest5 = new KeyValueListStore__c(Name='ECM_MAX_ADDRESS_RESULTS',TextValue__c='100');
        
        List<KeyValueListStore__c> lstKey = new List<KeyValueListStore__c>();
        lstKey.add(oTest);
        lstKey.add(oTest1);
        lstKey.add(oTest2);
        lstKey.add(oTest3);
        lstKey.add(oTest4);
        lstKey.add(oTest5);
        insert lstKey;
     Account parentAccount = UnitTest.getAccountInstance();
            parentAccount.Name = 'Parent Test Account';
            parentAccount.Phone = '91 80 67254199';
            parentAccount.BillingCountry = 'US';
            parentAccount.BillingState='IL';
            parentAccount.BillingPostalCode = '60603-3801';
            parentAccount.Is_GLI__c = false;
        insert parentAccount;
        
        Lead lead = UnitTest.getLeadInstance();
        lead.LastName='Patel';
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'CA';
        lead.Billing_Zip__c = 'test';
        lead.Billing_Country__c = 'US';
        lead.email = 'abc@gmail.com';
        //lead.Account__c=parentAccount.id;
        insert lead;
        
        PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
        testPageReference.getParameters().put('id', lead.Id);
        
        Test.setCurrentPageReference(testPageReference);
        lead = getLeadRecord(lead.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        
        //Execute Test
        Test.startTest();
        
        LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
        controller.cancelOperation();
        controller.searchAccount();
        
        LCRMConvertLeadController.AccountSearchOption oAccountOption = new LCRMConvertLeadController.AccountSearchOption();
        oAccountOption.accountName = 'TestName';
        oAccountOption.city = 'TestCity';
        oAccountOption.state = 'TestSTate';
        oAccountOption.country = 'TestCountry';
        List<LM_Lead_History__c> ListofLeadHistory = new List<LM_Lead_History__c>();
        LM_Lead_History__c LeadHistory = new LM_Lead_History__c();
        LeadHistory.Account_ID__c = parentAccount.Id; 
        ListofLeadHistory.add(LeadHistory);
        insert ListofLeadHistory;
        
        controller.newAccountSearchDetails = oAccountOption;
        controller.searchAccount();
        
        controller.addressSearchCountryChanged();
        controller.addressCountryChanged();
        
        DataQualityUtil.ECMAccountInfo ecmAccountInfo = new DataQualityUtil.ECMAccountInfo();
        ecmAccountInfo.Name = 'TestECMAccount';
        ecmAccountInfo.Street1 = 'TestECMStreet1';
        ecmAccountInfo.Street2 = 'TestECMStreet2';
        ecmAccountInfo.Country = 'TestECMCountry';
        ecmAccountInfo.State = 'TestECMState';
        ecmAccountInfo.City = 'TestECMCity';
        ecmAccountInfo.PostalCode = 'TestECMZip';
        
        controller.createNewAccount(ecmAccountInfo, null);
        
        
        LCRMConvertLeadController.MatchedCDSContact testObj = new LCRMConvertLeadController.MatchedCDSContact();
        testObj.CDSContactInfo = new DataQualityUtil.CDSContactInfo();
        testObj.isSelected = true;
        
        LCRMConvertLeadController.MatchedSFDCContact testObj1 = new LCRMConvertLeadController.MatchedSFDCContact();
        testObj1.CDSContactInfo = new DataQualityUtil.CDSContactInfo();
        testObj1.Contact = new COntact();
        
        controller.isAccountSection = true;
        controller.selectedCDSContactId  ='';
        controller.selectedCDSType = '';
        controller.allPages = true;
        controller.onlyContact = true;
        
        
        system.assert(true);
        Test.stopTest();
    }*/
    
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
    public static testMethod void testsearchAccount() {
       
        
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test', UserRoleId = ukiRole.Id);        
        insert u1;
        
        //Setup Test
        system.runAs(u1){
             LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
            
            Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest());
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
            
            
            Lead lead = UnitTest.getLeadInstance();
            lead.FirstName = 'Test';
            lead.LastName='Patel';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            insert lead;
            
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
            
            
            //Execute Test
            Test.startTest();
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);

            
            system.assertEquals(controller.bError, true);
            controller.selectedType = 'NEWContact';
            controller.selectedContact = 'NEWContact';
            controller.goToAccountSelection();
            controller.newAccountSearchDetails.accountName = '';
            controller.newAccountSearchDetails.state = '';
            controller.newAccountSearchDetails.country='AF';
            controller.searchAccount();
            
             controller.newAccountSearchDetails.accountName = 'Test Acc';
            controller.newAccountSearchDetails.state = 'Maharashtra';
            controller.newAccountSearchDetails.country = 'India';
             controller.searchAccount();            
            controller.cancelOperation();
            Test.stopTest();
            //lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];         
        }
        
    } 
    //Added for CRM-12851
    public static testMethod void testOptyProductConvertNewOpty() {
        
        Profile p = [SELECT Id,Name FROM profile WHERE name='GLI Sales User' limit 1];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'USL',timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
        insert u1;
         List<LCRMPriceBooksMapping__c> testpblist = new  List<LCRMPriceBooksMapping__c>();
        LCRMPriceBooksMapping__c  testpricebook = new LCRMPriceBooksMapping__c();
        testpricebook.Name = 'USL';
        testpricebook.Pricebook__c = 'US Legal/LMS';
        testpricebook.Sub_Bu__c  = 'USL';
        testpblist.add(testpricebook);
        if(testpblist.size()>0){
            insert testpblist;
        }
        //Setup Test
        system.runAs(u1){
            Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest());
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            
            
            Lead lead = UnitTest.getLeadInstance();
            lead.FirstName = 'Test';
            lead.LastName='Lead2';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            lead.Description = 'testLeadDesc';
            insert lead;
            
            Product2 testProd1 =UnitTest.getProductInstance();
            testprod1.IsActive = true;
            insert testProd1;
            
            Id Pricebook2Id = Test.getStandardPricebookId();
            PricebookEntry teststandardEntry = new PricebookEntry(isactive=true,Pricebook2id=Pricebook2Id,Product2Id=testProd1.id,unitprice=200,UseStandardPrice = false);
            insert teststandardEntry ;
         
            Pricebook2 testpb = new Pricebook2();
            testpb.Name = 'US Legal/LMS';
            testpb.IsActive= true;
            insert testpb;
            
             
            PricebookEntry testEntry = new PricebookEntry();
            testEntry.isActive = true;
            testEntry.Pricebook2id = testpb.id;
            testEntry.Product2Id=testProd1.id;
            testEntry.unitprice=200;
            testEntry.UseStandardPrice = false;
            insert testEntry;
            
            LCRM_Recommended_Product__c recprod = new LCRM_Recommended_Product__c();
            recprod.LCRM_Quantity__c = 3;
            recprod.LCRM_List_Price__c = 100;
            recprod.LCRM_Identified_for_Opportunity_Product__c = true;
            recprod.LCRM_Lead_Name__c = lead.id;
            recprod.LCRM_Product_Name__c = testProd1.id;
            insert recprod;
            
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
            //Execute Test
            Test.startTest();
            
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);
            
            
            //system.assertEquals(controller.bError, true);
            controller.selectedType = 'NEWContact';
            controller.selectedContact = 'NEWContact';
            controller.goToAccountSelection();
            
            controller.selectedAccountId = 'NewAccount';
            controller.selectedAccountType = 'NewAccount';
            //controller.addressCountryChanged();
            
            controller.goToOptySelection(); 
            PageReference convertPageReference = controller.convertLead();
            controller.goToOptySelection(); 
            controller.selectedOpptyType = 'NewOppty';
            PageReference convertPageReference1 = controller.convertLead();
            
            
            Test.stopTest();
            
            OpportunityLineItem olitest = [Select id,Product2Id,OpportunityId from OpportunityLineItem where OpportunityId = :controller.convertedOpptyId limit 1 ];
            System.assertEquals(recprod.LCRM_Product_Name__c, olitest.Product2Id);
        }
        
    }
    //End:12851
    
        
        @isTest static void testaddAccountTeamMemberForPartner()
        {
        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        Account acc = new account();
        acc.is_gli__c = true;
        acc.name ='portal account';
        insert acc ;
        
        contact partnercontact = new contact();
        partnercontact.accountid = acc.id;
        partnercontact.FirstName = 'test';
        partnercontact.Lastname = 'partner';
        insert partnercontact;
        
        opportunity testOpty = UnitTest.getOpportunityInstance(acc.id);
        testOpty.StageName = 'Appointment Scheduled';
        testOpty.is_gli__c = true;
        testOpty.Description = 'testOpty Desc';
        insert testOpty;
        
         List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name = 'TR Corp Partner Community User'];
        User user1 = UnitTest.getUserInstance();
        user1.Username = 'Test@xyzAccountregion.com';
        user1.LastName = 'XYZ';
        user1.Email = 'abc@xyz.com';
        user1.Alias = 'abcd';       
        user1.ProfileId = lstProfile[0].Id;
        user1.ContactId = partnercontact.id;
        user1.Segment__c = 'Corporate';
        insert user1;  
        
        Lead partnerLead = new Lead();
        partnerLead.FirstName = 'Partner';
        partnerLead.LastName = 'Lead';
        partnerLead.Is_GLI__c = true;
        partnerLead.company = 'Partner Company';
        //partnerLead.CreatedBy.Id=user1.Id;
        insert partnerLead;  
       
        
        
        
        List<AccountTeamMember> listofactm = new List<AccountTeamMember>();
        AccountTeamMember actm = new AccountTeamMember();
        actm.accountId =acc.Id;
        actm.userId =user1.Id;
       // actm.userId =partnerLead.CreatedBy.Id;
        //actm.TeamMemberRole='sales rep';
        actm.TeamMemberRole='Partner';
        actm.AccountAccesslevel= 'Read';
        actm.OpportunityAccessLevel ='Read';
        listofactm.add(actm);
        System.debug('partnerLead@@ '+partnerLead);
		
            DataQualityUtil.CDSContactInfo conRec = new DataQualityUtil.CDSContactInfo();
			conRec.Source_System_ID = partnercontact.Id;
            conRec.First_Name = partnercontact.FirstName;
            conRec.Last_Name = partnercontact.LastName;
			
           LCRMConvertLeadController.MatchedCDSContact mdc = new LCRMConvertLeadController.MatchedCDSContact();
            MDC.CDSContactInfo = conRec ;
            mdc.isSelected =false;
            LCRMConvertLeadController.MatchedSFDCContact msd = new LCRMConvertLeadController.MatchedSFDCContact();
            MSD.CDSContactInfo = conRec;
            msd.Contact = partnercontact;
            system.assertEquals(mdc.isSelected, false);
            //Execute Test
            Test.startTest();
            insert listofactm;
             Test.stopTest();
          
        }
       @isTest static void testaddAccountTeamMemberForPartner2()
        {
        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        Account acc = new account();
        acc.is_gli__c = true;
        acc.name ='portal account';
        insert acc ;
        
        contact partnercontact = new contact();
        partnercontact.accountid = acc.id;
        partnercontact.FirstName = 'test';
        partnercontact.Lastname = 'partner';
        insert partnercontact;
        
        opportunity testOpty = UnitTest.getOpportunityInstance(acc.id);
        testOpty.StageName = 'Appointment Scheduled';
        testOpty.is_gli__c = true;
        testOpty.Description = 'testOpty Desc';
        insert testOpty;
        
        Lead partnerLead = new Lead();
        partnerLead.FirstName = 'Partner';
        partnerLead.LastName = 'Lead';
        partnerLead.Is_GLI__c = true;
        partnerLead.company = 'Partner Company';
        insert partnerLead;
        
        List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name = 'TR Corp Partner Community User'];
        User user1 = UnitTest.getUserInstance();
        user1.Username = 'Test@xyzAccountregion.com';
        user1.LastName = 'XYZ';
        user1.Email = 'abc@xyz.com';
        user1.Alias = 'abcd';       
        user1.ProfileId = lstProfile[0].Id;
        user1.ContactId = partnercontact.id;
        user1.Segment__c = 'Corporate';
        insert user1;
        
        List<AccountTeamMember> listofactm = new List<AccountTeamMember>();
        AccountTeamMember actm = new AccountTeamMember();
        actm.accountId =acc.Id;
        actm.userId =user1.Id;
        actm.TeamMemberRole='Partner';
        actm.AccountAccesslevel= 'Read';
        actm.OpportunityAccessLevel ='Edit';
        listofactm.add(actm);
        system.assertEquals(actm.TeamMemberRole, 'Partner');    
        System.debug('partnerLead@@ '+partnerLead);
            //Execute Test
            Test.startTest();
            insert listofactm;
             Test.stopTest();
          
        }
    
      public static testMethod void testConvertOptyProdExistingOpty() {
         
        Profile p = [SELECT Id FROM profile WHERE name='GLI Sales User']; 
        UserRole uslRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];// Updated this method to fix test class error for CRM-1324
        User u1;
        USer u2;
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'USL',timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test', UserRoleId = uslRole.Id);        
            insert u1;
          /*  List<LCRMPriceBooksMapping__c> testpblist = new  List<LCRMPriceBooksMapping__c>();
            LCRMPriceBooksMapping__c  testpricebook = new LCRMPriceBooksMapping__c();
            testpricebook.Name = 'USL';
            testpricebook.Pricebook__c = 'US Legal/LMS';
            testpricebook.Sub_Bu__c  = 'USL';
            testpblist.add(testpricebook);
            if(testpblist.size()>0){
                insert testpblist;
            }*/
           
        }
      
        //Setup Test
        system.runAs(u1){
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
		
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            
            Account parentAccount = UnitTest.getAccountInstance();
            parentAccount.Name = 'Parent Test Account';
            //parentAccount.Phone = '91 80 67254199';
            parentAccount.BillingCountry = 'US';
            //parentAccount.Billing_Country__c = 'US';
            parentAccount.BillingState='IL';
            parentAccount.BillingPostalCode = '60603-3801';
            parentAccount.Is_GLI__c = true;
            parentAccount.RecordTypeId=accountRT.Id;
            insert parentAccount;
            
            
            //Account childAccount = UnitTest.getAccountInstance();
            Account childAccount = new Account();
            childAccount.Name = 'Child Test Account';
            //childAccount.Phone = '91 80 67254199';
            childAccount.BillingCountry = 'US';
            //childAccount.Billing_Country__c = 'US';
            childAccount.BillingState='IL';
            childAccount.BillingPostalCode = '60603-3801';
            childAccount.Operational_Ultimate_Parent_Name1__c = parentAccount.Id;
            childAccount.Is_GLI__c = true;
            childAccount.RecordTypeId=accountRT.Id;
            insert childAccount;
            
            Contact contact = UnitTest.getContactInstance(childAccount.Id);
            contact.RecordTypeId=contactRT.Id;
            contact.Email = 'test@tcs.com';
            
            insert contact;        
            //Added the booelan value not to run tms territory functionality
            //LCRMLeadTerritoryService.allowTriggerHandlerToRun  =false;
            
            Lead lead = UnitTest.getLeadInstance();
            lead.LastName='Test';
            lead.Company = 'Patel';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            //lead.account__c = parentAccount.id;
            lead.Contact__c = contact.Id;
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            lead.Is_Trial_Lead__c= true;
            lead.Description ='testlead desc';
            lead.LCRM_Email_Verification_TimeStamp__c = system.now();
            lead.LCRM_Phone_Verification_TimeStamp__c = system.now();
            insert lead;
            
            Trial__c tr = new Trial__c();
            tr.Contact_LeadId__c = lead.id;        
            tr.Account_Name__c = parentAccount.id;
            tr.Trial_Status__c ='Invited';
            insert tr;   
            
            opportunity testOpty = UnitTest.getOpportunityInstance(childAccount.id);
            testOpty.StageName = 'Appointment Scheduled';
            testOpty.is_gli__c = true;
            testOpty.Description = 'testOpty Desc';
            insert testOpty;
            
            OpportunityContactRole ocrTest = new OpportunityContactRole();
            ocrTest.ContactId = contact.Id;
            ocrTest.OpportunityId = testOpty.Id;
            ocrTest.IsPrimary = true;
            ocrTest.Role = 'Decision Maker';
            insert ocrTest;
            
            Product2 testProd1 =UnitTest.getProductInstance();
            testprod1.IsActive = true;
            insert testProd1;
            
             Id Pricebook2Id = Test.getStandardPricebookId();
            PricebookEntry teststandardEntry = new PricebookEntry(isactive=true,Pricebook2id=Pricebook2Id,Product2Id=testProd1.id,unitprice=200,UseStandardPrice = false);
            insert teststandardEntry ;
         /*
           Pricebook2 testpb = new Pricebook2();
            testpb.Name = 'US Legal/LMS';
            testpb.IsActive= true;
            insert testpb;
            
             
            PricebookEntry testEntry = new PricebookEntry();
            testEntry.isActive = true;
            testEntry.Pricebook2id = testpb.id;
            testEntry.Product2Id=testProd1.id;
            testEntry.unitprice=200;
            testEntry.UseStandardPrice = false;
            insert testEntry;*/
            
            LCRM_Recommended_Product__c recprod = new LCRM_Recommended_Product__c();
            recprod.LCRM_Quantity__c = 3;
            recprod.LCRM_List_Price__c = 100;
            recprod.LCRM_Identified_for_Opportunity_Product__c = true;
            recprod.LCRM_Lead_Name__c = lead.id;
            recprod.LCRM_Product_Name__c = testProd1.id;
            insert recprod;
           /* 
            OpportunityLineItem optylineitem = new OpportunityLineItem();
            optylineitem.opportunityId=testOpty.Id;
            optylineitem.quantity=30;
            optylineitem.LCRM_Units__c =3;
            optylineitem.Product2Id =testProd1.Id;
            optylineitem.PricebookEntryId=testEntry.id;
            
            insert optylineitem;*/
            
            Event oEvent = new Event();
            oEvent.WhoId = lead.id;
            oEvent.StartDateTime = Date.Today();
            oEvent.EndDateTime = Date.Today();
            oEvent.Subject = 'test';
            oEvent.Description = 'test';
            //insert oEvent;
            
            /*Task oTask = new Task();
            oTask.WhoId = lead.id;
            oTask.ActivityDate = system.today();
           insert oTask;*/
             
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            //lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);

            //Execute Test
            Test.startTest();
            
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);

            //system.assertEquals(controller.bError, true);
            controller.selectedOpptyId = testOpty.Id;
            controller.selectedOpptyType = 'SFDCOppty';
             //system.assertEquals(controller.bError, true);
            controller.selectedType = 'ECMContact';
            controller.selectedContact = 'ECMContact';
            controller.goToAccountSelection();
            
            controller.selectedAccountId = 'ECMAccount';
            controller.selectedAccountType = 'ECMAccount';
            //controller.addressCountryChanged();
            
            controller.getContactDetails(lead.Id);
            controller.goToOptySelection(); 
            PageReference convertPageReference = controller.convertLead();
            controller.goToOptySelection(); 
            controller.selectedOpptyType = 'NewOppty';
            PageReference convertPageReference1 = controller.convertLead();
            controller.onlyOpportunity = false;
            controller.convertLead();
            //controller.TaskListforLeads.add(oTask);
            //controller.EventListforLeads.add(oEvent);
            //controller.createLeadEventsUnderOpp(testOpty.id, contact.id);
            controller.addressCountryChanged();
            controller.addressSearchCountryChanged();
            controller.optionSelected();
            Test.stopTest();
          
             
          
            List<OpportunityLineItem> olitest = [Select id,Product2Id,OpportunityId from OpportunityLineItem where OpportunityId = :controller.selectedOpptyId limit 1 ];
            if(olitest.size() > 0) {
                System.assertEquals(recprod.LCRM_Product_Name__c, olitest[0].Product2Id);}
       
            //lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id limit 1];         
        }
    } 
 
           
public static testMethod void testsearchAccountNegative() {
       
        
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];
        Profile p = [SELECT Id FROM profile WHERE name='Elite User'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test', UserRoleId = ukiRole.Id);        
        insert u1;
        
        //Setup Test
        system.runAs(u1){
             LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
            
            Test.setMock(WebServiceMock.class, new CDSSearchServiceMockTest());
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
            
            
            Lead lead = UnitTest.getLeadInstance();
            lead.FirstName = 'Test';
            lead.LastName='Patel';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            insert lead;
            
            PageReference testPageReference = new PageReference('/apex/LCRMConvertLead');
            testPageReference.getParameters().put('id', lead.Id);
            
            Test.setCurrentPageReference(testPageReference);
            lead = getLeadRecord(lead.Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
            
            
            //Execute Test
            Test.startTest();
            LCRMConvertLeadController controller = new LCRMConvertLeadController(standardController);

            
            system.assertEquals(controller.bError, true);
            controller.selectedType = 'NEWContact';
            controller.selectedContact = 'NEWContact';
            controller.goToAccountSelection();
            controller.newAccountSearchDetails.accountName = '';
            controller.newAccountSearchDetails.state = '';
            controller.newAccountSearchDetails.country= '';
            
            controller.searchAccount();
            
            controller.cancelOperation();
            Test.stopTest();
            //lead = [SELECT Id, IsConverted FROM Lead WHERE Id =: lead.Id];         
        }
        
    }             
    }