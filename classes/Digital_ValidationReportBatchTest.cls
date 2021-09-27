/***************************************************************************************************
    CLASS NAME  : Digital_ValidationReportBatchTest
    DESCRIPTION : Test Class for Batch Testing of Digital Cohort Classes
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 07-10-2020      Brenda Shields          DLT-20728 - Updated to track Fatal errors during Automation
                                         Updated for PMD violations
 01-04-2021      Brenda Shields          DLT-21098        Add option to run automation and post validation searately                                 
 ====================================================================================================
====================================================================================================*/

@isTest
public class Digital_ValidationReportBatchTest {

    @testSetup static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE ORDER BY Name ASC NULLS LAST LIMIT 1];
        System.runas(usr) {
        	// to avoid too many SOQL queries error
        	Test.startTest();
        	DCTestData.createPaymentCreditWebService();
        	DCTestData.createPaymentAutoCharge();
            Digital_Validation_ReportRecordsTest.digitalValidationCreateRecords();
            Test.stopTest();
        }
    }
    
    @isTest static void digitalValidationDummy() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Cohort_DcCreation.dsCreation('dsSettings.Id', Null);
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalValidationGovPreCheck1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id from Digital_Settings__c where Name = 'Check Government 1'][0];
            Digital_Cohort_DcCreation.dsCreation(dsSettings.Id, Null);
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalValidationEmptySSDBatch() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id from Digital_Settings__c where Name = 'Empty SSDBatch'][0];
            Digital_Cohort_DcCreation.dsCreation(dsSettings.Id, Null);
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalValidationDummySSDBatch() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c from Digital_Settings__c where Name = 'Dummy SSDBatch'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_SSDCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalValidationCheckGovernmentDataLoad2() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c from Digital_Settings__c where Name = 'Check Government DataLoad2'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_SSDCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalValidationEmptyProductCheck1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c from Digital_Settings__c where Name = 'Check EmptyProductCheck1'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_ProductCheck(dsSettings, new List < Product_Account_Detail__c > ()), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }

    @isTest static void digitalValidationGOVProductCheck2() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check FindLawProductCheck2'][0]; // GovernmentProductCheck2
            Digital_Customer__c dc = [Select Id, SAP_Number__c from Digital_Customer__c where Digital_Settings__c =: dsSettings.Id][0];
            List < Product_Account_Detail__c > dsList = [SELECT Id, DC_Contract_Number__c, Campaign_Code__c, sub_Campaign_Code__c, AccountSSD__c, ZP_Cust_Number__c, Current_Subscription__c, Add_On_Sub__c, Add_On_Svc__c, Renewal_Date__c, Quantity__c, Actual_New_Service__c, Actual_New_Subscription__c, Premium_New_Service__c, Premium_New_Subscription__c, Type__c, Digital_Firm__c, Current_Term_Length__c
                FROM Product_Account_Detail__c
                WHERE ZP_Cust_Number__c =: dc.SAP_Number__c AND Renewal_Date__c > Today
            ];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_ProductCheck(dsSettings, dsList), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }

    @isTest static void digitalValidationGOVProductCheck3() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check GovernmentProductCheck3'][0];
            Digital_Customer__c dc = [Select Id, SAP_Number__c from Digital_Customer__c where Digital_Settings__c =: dsSettings.Id][0];
            List < Product_Account_Detail__c > dsList = [SELECT Id, DC_Contract_Number__c, Campaign_Code__c, sub_Campaign_Code__c, AccountSSD__c, ZP_Cust_Number__c, Current_Subscription__c, Add_On_Sub__c, Add_On_Svc__c, Renewal_Date__c, Quantity__c, Actual_New_Service__c, Actual_New_Subscription__c, Premium_New_Service__c, Premium_New_Subscription__c, Type__c, Digital_Firm__c, Current_Term_Length__c
                FROM Product_Account_Detail__c
                WHERE ZP_Cust_Number__c =: dc.SAP_Number__c AND Renewal_Date__c > Today
            ];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_ProductCheck(dsSettings, dsList), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }

    @isTest static void digitalValidationGOVAssetCheck1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check GovernmentDataLoadAssetCheck1'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_AssetCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }

    @isTest static void digitalValidationGOVAssetCheck2() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check GovernmentDataLoadAssetCheck2'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_AssetCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }

    @isTest static void digitalValidationGOVAccCONCheck1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check GovernmentDataLoadAccountCheck1'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_AccConCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }

    @isTest static void digitalValidationGOVSSDCheck2() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check GovernmentDataLoadSSDCheck21'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_SSDCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
/*    
    //???????????????????????????????????????????????
    @isTest static void digitalValidationDeleteCheck1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check GovernmentDataLoadSSDCheck21'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_SSDCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
            delete dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
*/    
    @isTest static void digitalValidationOppPropCheck1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check GovernmentDataLoadOppPropCheck1'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_OppPropCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalValidationCompletionCheck1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check results settings'][0];
            Digital_Cohort_CompletionTasks dc=new Digital_Cohort_CompletionTasks();
            dc.sendcompletionemail(dsSettings.Id);
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    
    // check cohort validation initiation
    @isTest static void digitalValidationListbutton1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            list <Product_Account_Detail__c> dslist = [Select Id from Product_Account_Detail__c
            		where Digital_Firm__c = 'Government'];
            test.setCurrentPage(Page.Digital_ValidationExecute);
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(dslist);
            stdSetController.setSelected(dslist);
            Digital_Cohort_Initiation dci = new Digital_Cohort_Initiation(stdSetController);
            dci.valWrapper.selName = 'Test List';
            dci.valWrapper.selSeg = 'Government';
            dci.valWrapper.selJob = 'Post-CohortsJob';
            dci.valWrapper.batchSize = 5;
            dci.dupcheck();
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalValidationListbutton2() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            list <Product_Account_Detail__c> dslist = [Select Id from Product_Account_Detail__c
            		where Digital_Firm__c = 'Government'];
            test.setCurrentPage(Page.Digital_ValidationExecute);
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(dslist);
            stdSetController.setSelected(dslist);
            Digital_Cohort_Initiation dci = new Digital_Cohort_Initiation(stdSetController);
            dci.valWrapper.selName = null;
            dci.valWrapper.selSeg = 'Government';
            dci.valWrapper.selJob = 'Pre-CohortsJob';
            dci.valWrapper.batchSize  = 5;
            dci.dupcheck();
        }
                        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalValidationListbutton3() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            List < Product_Account_Detail__c > dslist = [Select Id from Product_Account_Detail__c];
            test.setCurrentPage(Page.Digital_ValidationExecute);
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(dslist);
            stdSetController.setSelected(dslist);
            Digital_Cohort_Initiation dci = new Digital_Cohort_Initiation(stdSetController);
            dci.valWrapper.selName = 'Test List';
            dci.valWrapper.selSeg = 'Government';
            dci.valWrapper.selJob = 'Pre-CohortsJob';
            dci.valWrapper.batchSize = 10;
            dci.dupcheck();
        }
                
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    
	// test submit anautomation run    
    @isTest static void digitalValidationListbutton4AutoRun() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            List < Product_Account_Detail__c > dslist = [Select Id from Product_Account_Detail__c];
            test.setCurrentPage(Page.Digital_ValidationExecute);
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(dslist);
            stdSetController.setSelected(dslist);
            Digital_Cohort_Initiation dci = new Digital_Cohort_Initiation(stdSetController);
            dci.valWrapper.selName = 'Test List';
            dci.valWrapper.selSeg = 'Government';
            dci.valWrapper.selJob = 'AutomationJob';
            dci.valWrapper.batchSize = 1;
            dci.submitRequest();
        }
                
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    // test submit to re-run a prior Digital Setting Validation 
    @isTest static void digitalValidationListbutton5AutoPost() {
        Test.startTest();
        // build DS record
        Digital_Settings__c dvs = new Digital_Settings__c();
        dvs.Name = 'Test List';
        dvs.Data_Status__c = 'Post-CohortsJob';
        dvs.Segment__c = 'Government';
        dvs.Batch_Size__c = 1;
        insert dvs;
        // build Customers
        Digital_Customer__c dvc = new Digital_Customer__c();
        dvc.Digital_Settings__c = dvs.id; 
        dvc.SAP_Number__c = '1112223456';
        dvc.Cohort_Execution__c = true;
		insert dvc;
        // build Messages
        Digital_Message__c dvm = new Digital_Message__c();
        dvm.Name = 'Test';
		dvm.Digital_Customer__c = dvc.Id; 
		dvm.Digital_Settings__c = dvs.Id;
		dvm.Message__c = 'Test Message';
		dvm.Fatal_Error__c = false;
		dvm.Severity_Level__c = '1';
		insert dvm;
		
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            list <Product_Account_Detail__c> dslist = [Select Id from Product_Account_Detail__c];
            test.setCurrentPage(Page.Digital_ValidationExecute);
            ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(dslist);
            stdSetController.setSelected(dslist);
            Digital_Cohort_Initiation dci = new Digital_Cohort_Initiation(stdSetController);
            dci.valWrapper.selName = 'Test List';
            dci.valWrapper.selSeg = 'Government';
            dci.valWrapper.selJob = 'Post-CohortsOnly';
            dci.valWrapper.dsName = dvs.Id;
            dci.valWrapper.batchSize = 1;
            dci.submitRequest();
            
            // submit job to get apex record to dispaly
			Digital_OpportunityDigitalFlagSync dx = new Digital_OpportunityDigitalFlagSync();
			Database.executeBatch(dx, 50);
            // display automation job status
            dci.refreshStatus();
        }
                
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    
    @isTest static void digitalValidationDSCheck1() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check GovernmentDSCheck1'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_DSCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
                
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
    
    @isTest static void digitalEmptyValidationDSCheck2() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [Select Id FROM User WHERE ProfileId =: p.Id AND IsActive = TRUE LIMIT 1];
        System.runas(usr) {
            Digital_Settings__c dsSettings = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
            dsSettings.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_DSCheck(dsSettings), Integer.valueOf(dsSettings.Batch_Size__c)));
            update dsSettings;
        }
        
        Digital_Settings__c dSettingsResults = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Name = 'Check EmptyGovernmentDSCheck1'][0];
        system.assertEquals(dSettingsResults.Completion__c, 0, 'Completion code Should be 0');
        Test.stopTest();
    }
}