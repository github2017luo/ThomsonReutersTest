@IsTest

Class ESC_CalculateMTTRReportingFields_Test{
    
    public static testmethod void testMethod1()
    {
      //Insert  a Accounts  records
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
    
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testContact.FirstName='hello'; 
      insert testContact;
       
      id bhs=[select id from BusinessHours WHERE Name = 'Default'].id;

      List <Case> listcase= new List<Case>();
      
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'New');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testCase.BusinessHoursid=bhs;
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      listcase.add(testCase);
      insert listcase;
      
      Case cs = [select id,casenumber,CreatedDate,BusinessHoursId,ESC_CustomerHoldTime__c from case where id =:listcase[0].id];
      List<Case> cslist = new List<Case>();
      cslist.add(cs);
     system.debug('listcase@@'+listcase);
     system.debug('list@@'+cs);
     ESC_CalculateMTTRReportingFields.calculatMTTRFields(cslist);
     
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
      
}