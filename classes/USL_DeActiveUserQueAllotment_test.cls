@isTest
public class USL_DeActiveUserQueAllotment_test{


public static testmethod void TestMethods(){
        
       Test.StartTest();
       
        
      //This code run as a system user
      Profile prf = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User usr = new User(Alias = 'stadt', Email='sysadmin@test.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = prf.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin36458@test.com');
      insert usr;
      
      System.runAs(usr){
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
       
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Sample','lastname','test@sample.com');
      insert testContact;
      
      
      list<ID> icases = new list<ID>();
      
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase.OwnerId=usr.id;
      insert testCase;
     
     
     //insert listcase; 
     icases.add(testCase.id);
     
     USL_DeActiveUserQueAllotment.checkDeActiveUser(icases);
     // icases.add(testcase.id);
     
     }
     Test.stopTest();  
}

   
}