@isTest
private class creditCardTokeniserController_Test {
    static testmethod void method_test1(){
       Test.startTest();
        //insert accounts data 
       Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
       insert testAccount;
       
       //insert contact data
       Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','john','test@tr.com');
       insert testContact;
       
       Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
       testcase.ESC_Impact__c = '1-Whole Site';
       testcase.subject='tst';
       testcase.ESC_Customer_Symptom__c='Content Addition';
       testcase.ESC_Diagnosis_Summary__c='Content Explanation';
       testcase.ESC_Severity__c='1 - High';
       testcase.description = 'test';
       testcase.ESC_Apply_Milestone_Closure_Flag__c = true;
       
       testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
       insert testcase;
       
       ApexPages.currentPage().getParameters().put('Id',testcase.id);
       creditCardTokeniserController cctok = new creditCardTokeniserController();
       cctok.isfeedview=true;
       cctok.getCaseNumber();
       cctok.getmyPage();
       cctok.getendpointURL();
       Apexpages.currentpage().getparameters().put('postresponse','{"Hash":"sAnoPB62//hsArvFqb3u5b5AMGWNMJz6yKXZbp0CMbM=","Payload":{"Brand":"visa","ClientIP":"10.25.16.148","Success":true,"Error":"","Token":"-E803-4448-8N01000000000Q","SesssionID":"RLQUKZEH21D2NUJLZH6EAWSA1ITPB4QB","CustomerRefNumber":null}}');
       cctok.processResponse();
       cctok.expdate = '04/2019';
       cctok.processResponse();
       cctok.expdate = '04/2019';
       cctok.name = 'test';
       cctok.processResponse();
       cctok.dynamicmonthlist();
       cctok.getdynamicyearlist();
       cctok.selectedyear = '2018';
       cctok.dynamicmonthlist();
       
       

       Test.stopTest();
    }
    
    
    static testmethod void method2(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorcc());
        creditCardTokeniserController cctok = new creditCardTokeniserController();
        cctok.getendpointURL();
        
    }
}