@isTest
   private class USL_GenerateAutopayURL_Test {

    @IsTest(SeeAllData=false) static void GenerateAutopayURL() {
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
       WebServiceSettings__c PGWebServiceSettings = new WebServiceSettings__c();
       PGWebServiceSettings.Name='USL AutoPay';
       PGWebServiceSettings.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
       PGWebServiceSettings.Service_Unavailable_Message__c = 'Service Unavailable';      
       Insert PGWebServiceSettings;
      List <Case> cases= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testcase.LCRM_Sub_BU__c='USL';
      testcase.Subject='test1';
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.ESC_Severity__c='1 - High';
      testcase.GGO_Case_Response_Time__c=System.now();
      testcase.CreatedDate=System.now();
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.Description = 'test description';
      testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase.GGOIsReferralFlag__c =true;
       testcase.Is_GLI__c =true;     
      testcase.GGO_Referral_Milestone_Type__c='BR_Billing';
      testcase.ESC_Diagnosis_Summary__c='Content Explanation';
      cases.add(testCase);
      
        insert cases;
   
    USL_GenerateAutopayURL.getpaymenturl(cases);
    
    
    }
   }