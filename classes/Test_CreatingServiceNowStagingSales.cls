@IsTest
Public Class Test_CreatingServiceNowStagingSales{
    static testMethod void CreatingServiceNowStagingSales() {
        SN_ESI_Values_del__c tu=new SN_ESI_Values_del__c(SetupOwnerId=Userinfo.getUserId());
        tu.Type__c ='Sale';
        
        insert tu;
        
        Case objCase = new Case();
        objCase = UnitTest.getCaseInstance();
        objCase.Status = 'New';
        objCase.ESC_SLA__c ='3- 2 to 3 business days';
        objCase.ESC_SLA_Justification__c='hello';
        objCase.Description ='Hello';
        INSERT objCase;
        
    }
    static testMethod void CreatingServiceNowStagingSalesNegative() {
        SN_ESI_Values_del__c tu=new SN_ESI_Values_del__c(SetupOwnerId=Userinfo.getUserId());
        tu.Type__c ='Sale';
        tu.SLA__c ='Sale';
        tu.SLAJustification__c ='Sale';
        insert tu;
        
        Case objCase = new Case();
        objCase = UnitTest.getCaseInstance();
        objCase.Status = 'New';
        
        INSERT objCase;
        
    }
      public static testmethod void CaseSIUtilitytestmethod (){  
         
         List<case> CaseList = new List<Case>();
         List<case> CaseList1 = new List<Case>();
         List<case> CaseList2 = new List<Case>();
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test','test@tr.com');
         insert testContact;
         Test.startTest();
         Case ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
         Case ca1 = ESC_GenericTestutility.TestCaseUtil(null,TestAccount.id,'Work in Progress');
         CaseList.add(ca);
         Case ca2 = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Closed');
         ca2.ESC_Impact__c = '3 - Single User'; 
         ca2.Subject = 'Case Subject';
         ca2.ESC_Customer_Symptom__c = 'Connectivity';
         ca2.ESC_Severity__c = '1 - High';  
         ca2.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();      
         ca2.ESC_Diagnosis_Summary__c = 'Application/Desktop/Crash';        
         ca2.ESC_Resolution_Comment__c = 'Test';
         CaseList2.add(ca2);
         CaseList1.add(ca1);
         Insert CaseList;
         Insert CaseList1;
         Insert CaseList2;
         ESC_Special_Instruction__c spi = ESC_GenericTestutility.TestSIUtil(testAccount.id ,testContact.id,'Active');
         Insert spi;
         Test.stopTest();
         ESC_Case_Special_Instruction__c CaSI = ESC_GenericTestutility.TestCaSIUtil(spi.id,ca.id);
         Insert CaSI;
        
         ESC_Contact_Special_Instruction__c ConSI = ESC_GenericTestutility.TestConSIUtil(spi.id,testContact.id);
         Insert ConSI;
         ESC_Account_Special_Instruction__c AccSI = ESC_GenericTestutility.TestAccSIUtil(spi.id,testAccount.id);
         Insert AccSI;
         ESC_Static_Values__c SV = new ESC_Static_Values__c();
         sv.Name ='CaseSIDeleteOnCaseClosure';
         sv.ESC_Value__c = 'ON';
         Insert SV;
         
         //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
         ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
         ms.FieldAPIName__c = 'ESC_Response_Time__c';
         ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
         insert ms;
         
        
       /*  ESC_CommonCaseSIUtility.inheritIntoCaseSpecialInstructions(CaseList);
         ESC_CommonCaseSIUtility.inheritIntoCaseSpecialInstructions(CaseList1);
         ESC_CommonCaseSIUtility.inheritIntoCaseSpecialInstructions(CaseList2);*/
         
     }
}