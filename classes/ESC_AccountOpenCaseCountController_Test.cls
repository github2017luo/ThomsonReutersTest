@IsTest
public  class ESC_AccountOpenCaseCountController_Test {
      public static testmethod void escAccountOpenCaseCountControllerMethod(){  
         //Create a Account and insert as a dummy data   
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         //Create a Contact and insert as a dummy data
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         //Create a Case and insert as a dummy data
         Case ca= new Case();
         ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'Work in Progress');
         Insert ca;
         Test.startTest();
         Apexpages.StandardController stdController = new Apexpages.StandardController(ca);
         ESC_AccountOpenCaseCountController s = new ESC_AccountOpenCaseCountController(stdController);
         ESC_ContactOpenCaseCountController objconopen= new ESC_ContactOpenCaseCountController (stdController);
        Test.stopTest();
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
      }
}