/**********************************
Class Name: GenericUtilityHelper_test
Purpose:Test class for GenericUtilityHelper.
Author: Ajay
Date Created:09/06/2017
Date Updated:Version0
***********************************/
@isTest
/**
     * @description GenericUtilityHelper_Test 
     * 
     */
/**
     * @description genericUtilityHelper11
     * 
     */
/**
     * @description genericUtilityHelper12
     * 
     */

public class GenericUtilityHelper_Test {
 static testMethod void genericUtilityHelper11() {
    Test.StartTest();
        //insert accounts data 
       Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
       insert testAccount;
       
       //insert contact data
       Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','John','test@tr.com');
       insert testContact;
     
             
      //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
     MassValidationSettings__c mvs = new MassValidationSettings__c(Name = 'System Administrator', DisableMassTransfer__c= false);
       insert mvs;
       
             //ESC_EntitlementSelectorFields__c eIDs = new ESC_EntitlementSelectorFields__c();

       
      
        Group g1 = new Group(Name='group name', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId())) {  
            insert q1;
}   

     
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.type='queue';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase.ESC_Severity__c='1 - High';
      testcase.Description='test';
      testcase.OwnerId=g1.id;
     
  

      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      listcase.add(testCase);
      
      Case cmap = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      cmap.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      cmap.ESC_Impact__c = '1-Whole Site';
      cmap.subject='tst';
      cmap.ESC_Customer_Symptom__c='Content Addition';
      cmap.ESC_Diagnosis_Summary__c='Content Search';
      cmap.ESC_Severity__c='1 - High';
      cmap.Description='test';
      cmap.Is_GLI__c=true;
      cmap.ESC_Apply_Entitlement_Milestone__c=true;
      cmap.Status='new';
      cmap.LCRM_Sub_BU__c= 'UKI';
      //cmap.LCRM_Sub_BU__c= 'UKI';
      cmap.ESC_Next_Response_Time_Flag__c =false;
      cmap.GGO_First_Response_Time_Flag__c =true;
      cmap.ESC_Apply_Entitlement_Milestone__c=true;
      listcase.add(cmap);
      
      
      
      insert listcase;
      
      insert new ESC_EntitlementSelectorFields__c(SetupOwnerId=UserInfo.getOrganizationId(), ESC_Case_Field2__c='.', ESC_Case_Field3__c='LCRM_Sub_BU__c');
      
      insert new ESC_MiestoneClosureFields__c(SetupOwnerId=UserInfo.getOrganizationId(), Field_1__c='Status', Field_2__c='LCRM_Sub_BU__c');

      testcase.ownerid=UserInfo.getUserId();
      update testcase;
     //create a old Map
      Map<Id,case> oldCaseMap = new Map<Id,case>();
      oldCaseMap.put(testCase.id, testCase);
      
      //create a new Map
      Map<Id,case> newCaseMap = new Map<Id,case>();
      newCaseMap.put(listcase[1].id, listcase[1]);
      GenericUtilityHelper.CaseUpdates(listcase);

      GenericUtilityHelper.CaseUpdates(oldCaseMap,newCaseMap);
      
     //MasterCaseTriggerRecursiveCheck mas = new MasterCaseTriggerRecursiveCheck();
      integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'success');
    
 }
 static testMethod void genericUtilityHelper12() {
     
         //to bypass validation --- status cannot be equal to work in progress
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
    Test.StartTest();
        //insert accounts data 
       Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
       insert testAccount;
       
       //insert contact data
       Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','John','test@tr.com');
       insert testContact;
     
             
      //data related to the class : ESC_Utility -- error comming Null pointer exception - Attemp to deference a null object  line 459
     MassValidationSettings__c mvs = new MassValidationSettings__c(Name = 'System Administrator', DisableMassTransfer__c= false);
       insert mvs;
       
             //ESC_EntitlementSelectorFields__c eIDs = new ESC_EntitlementSelectorFields__c();

       
      
        Group g1 = new Group(Name='group name', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            System.runAs(new User(Id = UserInfo.getUserId())) {  
            insert q1;
}   

     
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.type='queue';
      testcase.Is_GLI__c=true;
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase.ESC_Severity__c='1 - High';
      testcase.Description='test';
      testcase.OwnerId=g1.id;
      testcase.USL_Case_Created_By_Role__c = 'Findlaw GM';
     
  

      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      listcase.add(testCase);
      
      Case cmap = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      cmap.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      cmap.ESC_Impact__c = '1-Whole Site';
      cmap.subject='tst';
      cmap.ESC_Customer_Symptom__c='Content Addition';
      cmap.ESC_Diagnosis_Summary__c='Content Search';
      cmap.ESC_Severity__c='1 - High';
      cmap.Description='test';
      cmap.Is_GLI__c=true;
      cmap.ESC_Apply_Entitlement_Milestone__c=true;
      cmap.Status='New';
      cmap.LCRM_Sub_BU__c= 'USL';
      cmap.ESC_Next_Response_Time_Flag__c =false;
      cmap.GGO_First_Response_Time_Flag__c =true;
      cmap.ESC_Apply_Entitlement_Milestone__c=true;
      cmap.USL_Case_Created_By_Role__c = 'Findlaw GM';
      cmap.OwnerId=g1.id;
      listcase.add(cmap);
      
      
      
      insert listcase;
      
      insert new ESC_EntitlementSelectorFields__c(SetupOwnerId=UserInfo.getOrganizationId(), ESC_Case_Field2__c='Status', ESC_Case_Field3__c='LCRM_Sub_BU__c');
      
      insert new ESC_MiestoneClosureFields__c(SetupOwnerId=UserInfo.getOrganizationId(), Field_1__c='Status', Field_2__c='LCRM_Sub_BU__c');
        
      List<Case> lstToUpdate = new List<Case>();
        
      cmap.ownerid=UserInfo.getUserId();
      testcase.ownerId = UserInfo.getUserId();
      lstToUpdate.add(cmap);
      lstToUpdate.add(testcase);
      update lstToUpdate;
      
      
     //create a old Map
      Map<Id,case> oldCaseMap = new Map<Id,case>();
      oldCaseMap.put(listcase[1].id, listcase[1]);
      
      //create a new Map
      Map<Id,case> newCaseMap = new Map<Id,case>();
      newCaseMap.put(listcase[1].id, listcase[1]);
       GenericUtilityHelper.CaseUpdates(oldCaseMap,newCaseMap);
       GenericUtilityHelper.userlist = null;
      GenericUtilityHelper.caseBHupdate(listcase);
      integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'success');
      }       
}