@isTest
public class GGO_UpdateCaseRT_Test {
@IsTest(SeeAllData=false) static void getCaseResponseTime() {
        Test.StartTest();
     Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.Software_Account_Attributes__c='Medium';
     insert testAccount;
     
     Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
     testcontact.firstname='testfirst';
     insert testContact;
    
     GGO_Case_SLA_Matrix__c lstvs = new GGO_Case_SLA_Matrix__c(Name='MilestoneSLA',GGO_Diagnosis__c='Content Explanation', AccountType__c='Medium',GGO_SLA__c=50);
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
       insert cases;
    GGO_UpdateCaseRT.getCaseRTI(cases);
}
}