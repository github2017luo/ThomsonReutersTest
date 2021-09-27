@isTest
   private class GGO_ResponseTimeCalculator_Test {

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
     MassValidationSettings__c mvs = new MassValidationSettings__c(Name = 'System Administrator', DisableMassTransfer__c= false);
       insert mvs;
     GGO_Case_SLA_Matrix__c lstvs = new GGO_Case_SLA_Matrix__c(Name='CaseEnt4',GGO_Diagnosis__c='Content Explanation', SeverityType__c='1 - High',GGO_SLA__c=50);
        insert lstvs;
      
      List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true]; 
      
      List <Case> cases= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
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
      
     /* Case testCase1=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testcase1.subject='test';
      testcase1.GGOIsReferralFlag__c = true;
      testcase1.Description = 'test description1';
      testcase.businesshoursid = bhs[0].id;
      testcase1.ESC_Impact__c = '1-Whole Site';
      testcase1.ESC_Severity__c='1 - High';
      testcase1.ESC_Customer_Symptom__c='Content Addition';
      testcase1.LCRM_Sub_BU__c='GGO';
      testcase1.Subject='test2';
      testcase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase1.GGO_Referral_Milestone_Type__c='BR_Billing';
      testcase1.ESC_Diagnosis_Summary__c='Entitlement Lost';
      cases.add(testCase1);*/
        insert cases;
   
    GGO_ResponseTimeCalculator.getCaseResponseTime(cases);
    
    
    }
   }