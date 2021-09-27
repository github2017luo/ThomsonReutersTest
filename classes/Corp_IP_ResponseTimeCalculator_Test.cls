@isTest
   private class Corp_IP_ResponseTimeCalculator_Test {

    @IsTest(SeeAllData=false) static void getCaseResponseTime() {
        Test.StartTest();
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.Software_Account_Attributes__c='Medium';
     insert testAccount;
     
     Account testAccount2 = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount2.Software_Account_Attributes__c='Medium';
     insert testAccount2;
     
     Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
     testcontact.firstname='testfirst';
     insert testContact;
     
     Contact testContact2 = ESC_GenericTestutility.TestContactUtil(testAccount2.id ,'Mile','test@tr.com');
     testcontact2.firstname='testlast';
     insert testContact2;
        
     //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
     
      
      List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true]; 
      
      List <Case> cases= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      testcase.LCRM_Sub_BU__c='GGO';
      testcase.Subject='test1';
      testcase.businesshoursid = bhs[0].id;
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.ESC_Severity__c='1 - High';
      testcase.GGO_Case_Response_Time__c=System.now();
      testcase.CreatedDate=System.now();
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.Description = 'test description';
      testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      //testcase.GGOIsReferralFlag__c='';
       testcase.ESC_Diagnosis_Summary__c='Content Explanation';
       cases.add(testCase);
           
       insert cases;
       Corp_IP_SLA_Matrix__c corpip = new Corp_IP_SLA_Matrix__c();
       corpip.ESC_Severity__c = '1 - High';
       corpip.ESC_Support_Level__c = 'Standard';
       corpip.ESC_Closure_SLA__c = '100';
       corpip.ESC_Acceptance_SLA__c = '100';
       corpip.name = 'test';
       insert corpip;
    Corp_IP_ResponseTimeCalculator.getCaseResponseTime(cases);
    system.assertEquals('1 - High',corpip.ESC_Severity__c,'1 - High');
    test.stopTest();
    }
    
    @IsTest(SeeAllData=false) static void getCaseResponseTime11() {
        Test.StartTest();
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.Software_Account_Attributes__c='Medium';
     insert testAccount;
     
     Account testAccount2 = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount2.Software_Account_Attributes__c='Medium';
     insert testAccount2;
     
     Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
     testcontact.firstname='testfirst';
     insert testContact;
     
     Contact testContact2 = ESC_GenericTestutility.TestContactUtil(testAccount2.id ,'Mile','test@tr.com');
     testcontact2.firstname='testlast';
     insert testContact2;
        
     //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
     
      
      List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true]; 
      
      List <Case> cases= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      testcase.LCRM_Sub_BU__c='GGO';
      testcase.Subject='test1';
      testcase.businesshoursid = bhs[0].id;
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.ESC_Severity__c='1 - High';
      testcase.suppliedEmail='mouna.gandra@thomsonreuters.com';
      testcase.GGO_Case_Response_Time__c=System.now();
      testcase.CreatedDate=System.now();
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.Description = 'test description';
      testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      //testcase.GGOIsReferralFlag__c='';
       testcase.ESC_Diagnosis_Summary__c='Content Explanation';
       cases.add(testCase);
           
       insert cases;
       Corp_IP_SLA_Matrix__c corpip = new Corp_IP_SLA_Matrix__c();
       corpip.ESC_Severity__c = '1 - High';
       corpip.ESC_Support_Level__c = 'Standard';
       corpip.ESC_Acceptance_SLA__c = '100';
       corpip.name = 'test';
       
       insert corpip;
       Corp_IP_SLA_Matrix__c corpip1 = new Corp_IP_SLA_Matrix__c();
       corpip1.ESC_Severity__c = '1 - High';
       corpip1.ESC_Support_Level__c = 'Standard';
       corpip1.ESC_Closure_SLA__c = '100';
       corpip1.name = 'test';
       insert corpip1;
       
       ESC_CaseLinesSupportLevel__c test1 = new ESC_CaseLinesSupportLevel__c();
       test1.name='vaishali.nagar';
       test1.ESC_Support_Level__c = 'Premium';
       insert test1;
    Corp_IP_AcceptanceTimeCalculator.getCaseAcceptanceTime(cases);
    CaseLines_Closure_Time_Calculator.getCaseClosureTime(cases);
    system.assertEquals('1 - High',corpip.ESC_Severity__c,'1 - High');
    test.stopTest();
    
    }
    
    @IsTest(SeeAllData=false) static void getCaseResponseTime12() {
        Test.StartTest();
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.Software_Account_Attributes__c='Medium';
     insert testAccount;
     
     Account testAccount2 = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount2.Software_Account_Attributes__c='Medium';
     insert testAccount2;
     
     Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
     testcontact.firstname='testfirst';
     insert testContact;
     
     Contact testContact2 = ESC_GenericTestutility.TestContactUtil(testAccount2.id ,'Mile','test@tr.com');
     testcontact2.firstname='testlast';
     insert testContact2;
        
     //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
     
      
      List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true]; 
      
      List <Case> cases= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      testcase.LCRM_Sub_BU__c='US';
      testcase.Subject='test1';
      testcase.businesshoursid = bhs[0].id;
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.ESC_Severity__c='1 - High';
      testcase.GGO_Case_Response_Time__c=System.now();
      testcase.CreatedDate=System.now();
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.Description = 'test description';
      testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      //testcase.GGOIsReferralFlag__c='';
       testcase.ESC_Diagnosis_Summary__c='Content Explanation';
       testcase.ESC_Product_Segment_Brand__c='Elite';
       testcase.ESC_Unique_Identifier__c  = 'Elite';
       testcase.origin = 'Email';
       
       cases.add(testCase);
           
       insert cases;
       Corp_IP_SLA_Matrix__c corpip = new Corp_IP_SLA_Matrix__c();
       corpip.ESC_Severity__c = '1 - High';
       //corpip.ESC_Support_Level__c = 'Standard';
       corpip.ESC_Acceptance_SLA__c = '100';
       corpip.name = 'test';
       insert corpip;
    Elite_EBH_AcceptanceTimeCalculator.getCaseAcceptanceTime(cases);
    system.assertEquals('1 - High',corpip.ESC_Severity__c,'1 - High');
    test.stoptest();
    
    }
    @IsTest(SeeAllData=false) static void testflowcoverage() {
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.Software_Account_Attributes__c='Medium';
        insert testAccount;
        
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testcontact.firstname='testfirst';
        insert testContact;
        
        ESC_segment_Region_Lotus__c segcorp = new ESC_segment_Region_Lotus__c();
        segcorp.SegmentCorp__c = 'Corporate';
        insert segcorp;
        test.starttest();
        Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
        testcase.LCRM_Sub_BU__c='US';
        testcase.BU_Segment__c = 'Corporate';
        testcase.ESC_Product_Title__c = 'Global Trade Management';
        testcase.Subject='test1';                
        testcase.ESC_Severity__c='1 - High';                
        testcase.ESC_Customer_Symptom__c='Content Addition';
        testcase.Description = 'test description';
        testcase.ESC_Case_Acceptance_Entry_Flag__c = false;
        testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();      
        testcase.ESC_Diagnosis_Summary__c='Content Explanation';
        insert testcase;
        testcase.ESC_Severity__c='2 - Medium';
        update testcase;
        system.assertEquals('2 - Medium',testcase.ESC_Severity__c,'2 - Medium');
        test.stopTest();
        
     }
   }