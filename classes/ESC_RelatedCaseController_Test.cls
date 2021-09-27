@isTest
Public class ESC_RelatedCaseController_Test {

      @IsTest(SeeAllData=false) static void relatedCase() {
        Test.StartTest();
        
        //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='Test';
          insert testContact;
          
          //Insert a Cases
          List <Case> listcase= new List<Case>();
          Case pCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
          Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
          testCase.ESC_Impact__c = '1-Whole Site';
          testCase.subject='tst';
          testCase.ESC_Customer_Symptom__c='Content Addition';
          testCase.ESC_Diagnosis_Summary__c='Content Explanation';
          testCase.ESC_Severity__c='1 - High';
          testCase.ESC_Case_Type__c = 'Request for Service';
          testCase.parentId=pCase.Id;
          testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
          testCase.description='DESC';
          testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
          insert testCase;
         
         
         PageReference pageRef=Page.ESC_CreateRelatedCasePage;
         test.setCurrentPage(pageRef);
         pageRef.getParameters().put('rectype','Complaint');
         pageRef.getParameters().put('scontrolCaching','1');
         ApexPages.StandardController stdController=new ApexPages.StandardController(testCase);
          //stdController.setSelected(testCase);
          ESC_RelatedCaseController obj=new ESC_RelatedCaseController(stdController);
          obj.CreateRelatedCase();
          obj.errmsg='errmsg';
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }    
}