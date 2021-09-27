@isTest (SeeAllData=false)
public class ESC_CaseTimerController_Test{
 
 
  @IsTest(SeeAllData= false) static void method1(){
 
 Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'trlex', Email='TRlexuser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='TRlexuser@testorg.com');
      insert u;
  //insert accounts data 
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
       
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Firstname';
      insert testContact;
  //insert case
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      //case testcase=new Case();
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase.OwnerId=u.id;
      insert testCase;      
      
       string t = testCase.id;
      
       Test.startTest();
        ESC_CaseTimerController.isCaseOwner(testCase.id);
        ESC_CaseTimerController.newSession(t,'00:00:50');
        ESC_CaseTimerController.getSessionRec(testCase.id);        
        Test.stopTest();  

  }
}