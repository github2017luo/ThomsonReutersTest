/*
 * This class provides the Digital Support team with a button on the Digital Settings page layout
 * so they can 'Unmark' Opportunities as Digital if they have failed the Digital Automation PRocess
 *
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2020-10-07   Brenda Shields          DLT-20728 - Class creation  
 * ==================================================================================================================================   
 */
@isTest
public with sharing class Digital_Cohort_Cust_Cntl_Test {

    public static String oppId;
    public static String quoteId;
    
    @testSetup static void init() {
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Test.StopTest();  
        
        // update renewal date on Opp
        Opportunity oOpp = new Opportunity();
        oOpp.id = DCTestData.oppId;
        oOpp.StageName = 'Contacting';
        oOpp.isDigitalSpearhead__c = true;
        oOpp.Unmarked_Digital_Channel__c = false;
        oOpp.DRS_Status_Digital__c = '';
        oOpp.Renewal_Date__c = system.today()+30;
        update oOpp; 
        
        // update Proposal
        Apttus_Proposal__Proposal__c oQuote = [Select id  from Apttus_Proposal__Proposal__c limit 1];
        oQuote.Apttus_Proposal__Approval_Stage__c = 'Draft';
        oQuote.Apttus_Proposal__Primary__c = true;
        oQuote.Digital_Quote_Type__c = 'Manual';
        oQuote.Digital_Envelope_Created__c = false;     
        oQuote.Apttus_Proposal__Opportunity__c = oOpp.id;  
        oQuote.Display_in_CXD_Renewals__c = false; 
        oQuote.Latam_APTS_Win_Loss__c = 'Won';
        oQuote.Latam_APTS_Reason__c = 'Digital';
        update oQuote;
        
        oppId = oOpp.id;
        quoteId = oQuote.id;
    
        Apttus_Proposal__Proposal__c prop=[Select id from Apttus_Proposal__Proposal__c LIMIT 1];
        // create envelope record
        Apttus_DocuApi__DocuSignEnvelope__c newEnv = DCTestdata.createDocuSignEnvelope('sent',prop.Id);
        insert newEnv;   
        
        // Create records for the Cohort Validation
        
        // Create Digital Setting
        Digital_Settings__c dSetting = new Digital_Settings__c();
        dSetting.Name = 'Test Small Law Cohort Run';
        dSetting.RecordTypeId = Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId();
        dSetting.Batch_Size__c = 5;
        dSetting.Data_Status__c = 'Data Load';
        dSetting.Segment__c = 'Small Law';
        insert dSetting;
		
		// Create Digital Customer for this Setting
        Digital_Customer__c dCustomer = new Digital_Customer__c();
        dCustomer.Digital_Settings__c = dSetting.Id;
        dCustomer.SAP_Number__c = '012345';
        dCustomer.Opportunity__c = oOpp.Id;
        insert dCustomer;
        
        // Create Digital Message for this Customer
        Digital_Message__c dMessage = new Digital_Message__c();
        dMessage.Name = 'test object name';
        dMessage.Digital_Customer__c = dCustomer.Id;
        dMessage.Digital_Settings__c = dSetting.Id;
        dMessage.Message__c = 'test message';
        dMessage.Fatal_Error__c = true;
        dMessage.Severity_Level__c = '9000';
        insert dMessage;
        
     }
     
    @isTest static void testUnmarkOpp()
    {
		// select Digital Settings Data
        Digital_Settings__c oDigitalSetting = [Select id from Digital_Settings__c LIMIT 1];
        // call vf page
        PageReference pageRef = Page.Digital_Cohort_Customer;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oDigitalSetting.id);
       
        Test.startTest();
        list<Digital_Settings__c> listDSRecords = [Select id from Digital_Settings__c]; 
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(listDSRecords);
        
        Digital_Cohort_Cust_Controller generateCtrl = new Digital_Cohort_Cust_Controller(con);
        generateCtrl.updateOpps();
        PageReference pg1 = generateCtrl.continueUpdate();
        PageReference pg2 = generateCtrl.returnToSettings();
                
        Opportunity oOpp = [Select Unmarked_Digital_Channel__c from Opportunity limit 1];
        // we don't actually create the attachment during test runs
        system.assertEquals(oOpp.Unmarked_Digital_Channel__c, true, 'Opp should be Unmarked');
        Test.stopTest();
        
    }

}