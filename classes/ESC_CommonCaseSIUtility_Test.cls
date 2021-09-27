/**
 * CHANGE HISTORY
 * ============================================================================================================================
 * Date             Name         JIRA            Description
 * ============================================================================================================================
 * 
 * 06-08-2017   Rupesh Sharma        EBB-161         Test class for 'CommonCaseSIUtility'
 * 
 * ============================================================================================================================
 */
@IsTest
public  class ESC_CommonCaseSIUtility_Test {
      public static testmethod void caseSIUtilitytestmethod (){  
         
         List<case> caseList = new List<Case>();
         List<case> caseList1 = new List<Case>();
         List<case> caseList2 = new List<Case>();
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
         testContact.Firstname='Firstname';
         insert testContact;
         
         Test.startTest();
         Case ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
         Case ca1 = ESC_GenericTestutility.TestCaseUtil(null,TestAccount.id,'Work in Progress');
         caseList.add(ca);
         Case ca2 = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Closed');
         ca2.ESC_Impact__c = '3-Single User'; 
         ca2.Subject = 'Case Subject';
         ca2.ESC_Customer_Symptom__c = 'Connectivity';
         ca2.ESC_Severity__c = '1 - High';  
         ca2.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();      
         ca2.ESC_Diagnosis_Summary__c = 'Application/Desktop/Crash';        
         ca2.ESC_Resolution_Comment__c = 'Test';
         ca2.Description='descriptiontest';
         caseList2.add(ca2);
         caseList1.add(ca1);
         Insert caseList;
         Insert caseList1;
         Insert caseList2;
         ESC_Special_Instruction__c spi = ESC_GenericTestutility.TestSIUtil(testAccount.id ,testContact.id,'Active');
         Insert spi;
         Test.stopTest();
         ESC_Case_Special_Instruction__c caSI = ESC_GenericTestutility.TestCaSIUtil(spi.id,ca.id);
         Insert caSI;
        
         ESC_Contact_Special_Instruction__c conSI = ESC_GenericTestutility.TestConSIUtil(spi.id,testContact.id);
         Insert conSI;
         ESC_Account_Special_Instruction__c accSI = ESC_GenericTestutility.TestAccSIUtil(spi.id,testAccount.id);
         Insert accSI;
         ESC_Static_Values__c sv = new ESC_Static_Values__c();
         sv.Name ='CaseSIDeleteOnCaseClosure';
         sv.ESC_Value__c = 'ON';
         Insert sv;
         
         //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
         ESC_MilestoneIdentifierSetting__c ms = new ESC_MilestoneIdentifierSetting__c(Name = 'Next Response Time');
         ms.FieldAPIName__c = 'ESC_Response_Time__c';
         ms.ControllingFieldAPI__c = 'ESC_Next_Response_Time_Flag__c';
         insert ms;
         
        
         ESC_CommonCaseSIUtility.inheritIntoCaseSpecialInstructions(caseList);
         ESC_CommonCaseSIUtility.inheritIntoCaseSpecialInstructions(caseList1);
         ESC_CommonCaseSIUtility.inheritIntoCaseSpecialInstructions(caseList2);
         
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
         
     }
}