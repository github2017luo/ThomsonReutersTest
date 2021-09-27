@isTest
private class TXP_Notification_Home_PageFlow_Test{

    @IsTest(SeeAllData=false) static void testflowcoverage() {
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Software_Account_Attributes__c='Medium';
        insert testAccount;
        
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testcontact.firstname='testfirst';
        insert testContact;
        
        ESC_segment_Region_Lotus__c segcorp = new ESC_segment_Region_Lotus__c();
        segcorp.SegmentTax__c= 'Professional Tax';
        insert segcorp;
        
        case objCase1= ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
              
              
            objCase1.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase1.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase1.ESC_EnquiryType__c='Cancellation';
            objCase1.LCRM_Sub_Bu__c='US';
            objCase1.BU_Segment__c='Professional Tax';
            objCase1.ESC_Case_Type__c='Request For Action';
            objCase1.ESC_Sub_Type__c='Approved';
            objCase1.USL_SAP_Account_Number__c ='2000000418';
            objCase1.ESC_Submit_For_Auto_Approval__c=false;
            objCase1.ESC_Subscription_Start_Date__c=system.today();
            //objCase1.ESC_Suspend_Asset__c=true;
            objCase1.Status='New';
            objCase1.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase1.ESC_Product_Title__c = 'Global Trade Management';
            objCase1.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase1.Subject = 'Test Cancellation';
            objcase1.ESC_Total_Net_Price1__c=2;
            insert objcase1;
            objcase1.ESC_Submit_For_Auto_Approval__c=true;
            update objcase1;
        
     }
     
      @IsTest(SeeAllData=false) static void testflowcoverage1() {
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Software_Account_Attributes__c='Medium';
        insert testAccount;
        
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testcontact.firstname='testfirst';
        insert testContact;
        
        ESC_segment_Region_Lotus__c segcorp = new ESC_segment_Region_Lotus__c();
        segcorp.SegmentTax__c= 'Professional Tax';
        insert segcorp;
        
        Case testCase= new Case();
        testcase.Accountid = testAccount.id;
        testcase.Contactid = testContact.id;
        testcase.LCRM_Sub_BU__c='US';
        testcase.BU_Segment__c = 'Professional Tax';
        //testcase.ESC_Product_Title__c = 'Global Trade Management';
        testcase.Subject='test1';  
        testcase.ESC_Case_Type__c = 'Request for Action' ;             
        //testcase.ESC_Severity__c='1 - High';                
        testcase.ESC_Customer_Symptom__c='Content Addition';
        testcase.Description = 'test description';
        //testcase.ESC_Submit_For_Auto_Approval__c= false;
        testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();      
        //testcase.ESC_Diagnosis_Summary__c='Content Explanation';
        insert testcase;
        testcase.Status='Set for Auto Close';
        testcase.ESC_Auto_Close_Date__c = system.NOW() +1;
        update testcase;
     }
}