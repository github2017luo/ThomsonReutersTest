@isTest
   private class GLI_ResolutionTimeCalculator_Test {

    @IsTest(SeeAllData=false) static void getCaseResolutionTime() {
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
    // MassValidationSettings__c mvs = new MassValidationSettings__c(Name = 'System Administrator', DisableMassTransfer__c= false);
      // insert mvs;
     GLI_Case_SLA_Matrix__c lstvs = new GLI_Case_SLA_Matrix__c(Name='SLA Matrix1',Accept_SLA__c=48, Case_Type__c='Incident',Priority__c='1 - High',Resolution_SLA__c=12);
        insert lstvs;
      
      List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true]; 
      
      List <Case> cases= new List<Case>();
      List <id> cases1= new List<id>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');      
      testcase.Subject='test1';
      testcase.ESC_Case_Type__c = 'Incident';
      testcase.Priority = '1 - High';
      //testcase.IS_ESC_Case__c=true;
      testcase.LCRM_Sub_BU__c='UKI';
      testcase.IS_GLI__c=True;      
      testcase.businesshoursid = bhs[0].id;
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.ESC_Severity__c='1 - High';            
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.Description = 'test description';
      testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      //testcase.GGOIsReferralFlag__c='';
      testcase.ESC_Diagnosis_Summary__c='Content Explanation';
      cases.add(testCase);
      
      Case testcase1=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work In Progress');      
      testcase1.Subject='test1';
      testcase1.ESC_Case_Type__c = 'Incident';
      testcase1.Priority = '1 - High';
      //testcase1.IS_ESC_Case__c=true;
      testcase1.LCRM_Sub_BU__c='UKI';
      testcase1.IS_GLI__c=True;      
      testcase1.businesshoursid = bhs[0].id;
      testcase1.ESC_Impact__c = '1-Whole Site';
      testcase1.ESC_Severity__c='1 - High';            
      testcase1.ESC_Customer_Symptom__c='Content Addition';
      testcase1.Description = 'test description';
      testcase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      //testcase1.GGOIsReferralFlag__c='';
      testcase1.ESC_Diagnosis_Summary__c='Content Explanation';
      cases.add(testcase1);                
        insert cases;
       cases1.add(cases[0].id); 
      
      list<case> listcaseudate =new list<case>();
      case casenew =new case();
       casenew.id= cases[0].id;
       casenew.Status='Work In Progress';
       listcaseudate.add(casenew);
       update listcaseudate;
    map<id,case> newmap = new map<id,case>();
    map<id,case> oldmap = new map<id,case>();
    oldmap.put(cases[0].id,cases[0]);
    newmap.put(listcaseudate[0].id,cases[0]);
    GLI_ResolutionTimeCalculator.getCaseResolutionTime(cases1);
    GLI_ResolutionTimeCalculator.CaseResolutionTimefromTrigger(oldmap,newmap);
    
    }
   }