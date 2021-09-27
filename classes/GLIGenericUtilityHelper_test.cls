/**********************************
Class Name: GLIGenericUtilityHelper_test
Purpose:Test class for GLIGenericUtilityHelper.
Author: Saivaj
Date Created:26/06/2017
Date Updated:Version0
***********************************/
@isTest
private class GLIGenericUtilityHelper_test{
    static testMethod void GLIGenericUtilityHelper() {
      // Setup test data
      // This code runs as the system user
      boolean serviceuser;
      Profile p = [SELECT Id FROM Profile WHERE Name='GLI Helpdesk Agent']; 
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p.Id,Sales_Org__c='GLI',Sub_Bu__c = 'UKI',TimeZoneSidKey='America/Los_Angeles', UserName='standarduseruki@testorg.com');
      Insert u;
      User u1 = new User(Alias = 'standt', Email='standarduser1@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p.Id,Sales_Org__c='GLI',Sub_Bu__c = 'USL',TimeZoneSidKey='America/Los_Angeles', UserName='standarduseruki1@testorg.com');
      Insert u1;
      User u2 = new User(Alias = 'sta2ndt', Email='standardus2er1@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p.Id,Sales_Org__c='GLI',Sub_Bu__c = 'FindLaw',TimeZoneSidKey='America/Los_Angeles', UserName='standarduse2ruki1@testorg.com');
      Insert u2;
        
        
      List<UKI_Static_Values__mdt> UKISV =[SELECT MasterLabel,UKI_Value__c from UKI_Static_Values__mdt];
      GLI_DomainSelectorList__c DMS= new GLI_DomainSelectorList__c();
      DMS.DomainName__c='trs.com';
      Insert DMS;
      
      Case testCase= new case();
       Case testCase1= new case();
       case  testCase2=new case();
      
      System.runAs(u) {
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','1251541');  
      testAccount.bu_marketing_segment__c='Other';
      insert testAccount;
      /**testAccount.BU_Marketing_Segment__c='Other';
      update testAccount;**/
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.Firstname='test';
      insert testContact;
      Account testAccount1 = ESC_GenericTestutility.TestAccountUtil('TestAccount1' ,'TestAccount002','1251541'); 
      testAccount1.bu_marketing_segment__c='Other';
      testAccount1.GLI_Survey_Exclusion_Start_Date__c=System.Today();
      testAccount1.GLI_Survey_Exclusion_End_Date__c=System.Today()+5;
      insert testAccount1;
      Contact testContact1 = ESC_GenericTestutility.TestContactUtil(testAccount1.id ,'Mile1','test@trs.com');
      testContact1.Firstname='test';
      insert testContact1;
       Contact testContact11 = ESC_GenericTestutility.TestContactUtil(testAccount1.id ,'Mile11','test@trs.com');
      testContact11.Firstname='test1';
      insert testContact11;
      Test.startTest();
      
      ESC_segment_Region_Lotus__c segRegCorp = ESC_segment_Region_Lotus__c.getOrgDefaults();
      
      //list<case> lstcase= new list<case>();
      testcase.contactid=testContact1.id;
      //Fix Applied
      testcase.Status='Work in Progress';
      testcase.ESC_Fix_Applied_Time__c=NULL;
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      //testcase.esc_account_marketing_segment__c=segRegCorp.ESC_IP_BU_Marketing_Segment__c;
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase.ESC_Severity__c='1 - High';
      testcase.Description='test';
      testcase.LCRM_Sub_BU__c ='US';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase.ESC_Suspend_Asset__c=false;
      //lstcase.add(testcase);
      insert testcase;
      
      GLIGenericUtilityHelper.setGLI(testcase);
      
      Apttus_Config2__AssetLineItem__c testAppasset=new Apttus_Config2__AssetLineItem__c();
      testAppasset.Name='TestApptusasset';
      testAppasset.Apttus_Config2__AssetStatus__c='Activated';
      testAppasset.Apttus_Config2__AccountId__c=testAccount1.id;
      testAppasset.Apttus_Config2__LineType__c='Product/Service';
      testAppasset.Apttus_Config2__NetPrice__c=700.00000;
      //testAppasset.Name='TestAppasset';
      Insert testAppasset;
      
      ESC_Case_Asset_Line_Item__c testCAsset= new ESC_Case_Asset_Line_Item__c();
      testCAsset.ESC_Case__c=testcase.id;
      testCAsset.ESC_Asset_Line_Item__c=testAppasset.id;
      Insert testCAsset;
      
       /**map<id,case> oldmap1=new map<id,case>();
       oldmap1.put(testcase.id,testcase);**/
       //remove in promotion
       testcase.contactid=testContact1.id;
      /* testcase.accountid=testaccount1.id;*/
       
       testcase.ESC_Suspend_Asset__c=true;
        
       update testcase;
       
    
        serviceuser= GLIGenericUtilityHelper.GLIServiceUserCheck();
         
      Test.StopTest();
      }
      
      
     
      }
      public static testmethod void testMethod2()
    {
         // Setup test data
      // This code runs as the system user
      boolean serviceuser;
      Profile p = [SELECT Id FROM Profile WHERE Name='GLI Helpdesk Agent'];
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p.Id,Sales_Org__c='GLI',Sub_Bu__c = 'UKI',TimeZoneSidKey='America/Los_Angeles', UserName='standarduseruki@testorg.com');
      Insert u;
      List<Id> Userlist = new List<Id>();
      Userlist.add(u.id);     
      List<UKI_Static_Values__mdt> UKISV =[SELECT MasterLabel,UKI_Value__c from UKI_Static_Values__mdt];
      GLI_DomainSelectorList__c DMS= new GLI_DomainSelectorList__c();
      DMS.DomainName__c='trs.com';
      Insert DMS;
      try{
      Case testCase= new case();
       Case testCase1= new case();
       case  testCase2=new case();
       case  testCaseSurvey=new case();
       case  testCaseSurveyGGO=new case();
       case  testCaseSurveyGGO1=new case();
      
      System.runAs(u) {
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','1251541');  
      insert testAccount;
      /**testAccount.BU_Marketing_Segment__c='Other';
      update testAccount;**/
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.Firstname='test';
      insert testContact;
      Account testAccount1 = ESC_GenericTestutility.TestAccountUtil('TestAccount1' ,'TestAccount002','1251541'); 
      testAccount1.GLI_Survey_Exclusion_Start_Date__c=System.Today();
      testAccount1.GLI_Survey_Exclusion_End_Date__c=System.Today()+5;
      insert testAccount1;
      Contact testContact1 = ESC_GenericTestutility.TestContactUtil(testAccount1.id ,'Mile1','test@trs.com');
      testContact1.Firstname='test';
      insert testContact1;
      
      Test.startTest();
      
      testcase.Status='Work in Progress';      
      testcase.ESC_Fix_Applied_Time__c =NULL;
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase.ESC_Severity__c='1 - High';
      testcase.Description='test';
      testcase.LCRM_Sub_BU__c ='US';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      insert testcase;                
      
      //GGO_Survey_Email Process Builder
      
      testCaseSurveyGGO.Status='New';      
      testCaseSurveyGGO.ESC_Fix_Applied_Time__c =NULL;
      testCaseSurveyGGO.ESC_Impact__c = '1-Whole Site';
      testCaseSurveyGGO.subject='tst';
      testCaseSurveyGGO.ESC_Customer_Symptom__c='Content Addition';
      testCaseSurveyGGO.ESC_Diagnosis_Summary__c='Content Explanation';
      testCaseSurveyGGO.ESC_Severity__c='1 - High';
      testCaseSurveyGGO.Description='test';
      testCaseSurveyGGO.ESC_Resolution_Comment__c='TestComment';
      testCaseSurveyGGO.ESC_Impact__c=' 3 - Single User';
      testCaseSurveyGGO.LCRM_Sub_BU__c ='GGO';
      testCaseSurveyGGO.ESC_Send_Survey__c=false;
      testCaseSurveyGGO.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      insert testCaseSurveyGGO;     
      
        testCaseSurveyGGO.Status='Closed';
        update testCaseSurveyGGO;
        
        testCaseSurveyGGO1.Status='New';      
      testCaseSurveyGGO1.ESC_Fix_Applied_Time__c =NULL;
      testCaseSurveyGGO1.ESC_Impact__c = '1-Whole Site';
      testCaseSurveyGGO1.subject='tst';
      testCaseSurveyGGO1.ESC_Customer_Symptom__c='Content Addition';
      testCaseSurveyGGO1.ESC_Diagnosis_Summary__c='Content Explanation';
      testCaseSurveyGGO1.ESC_Severity__c='1 - High';
      testCaseSurveyGGO1.ESC_Resolution_Comment__c='TestComment';
      testCaseSurveyGGO1.ESC_Impact__c=' 3 - Single User';
      testCaseSurveyGGO1.Description='test';
      testCaseSurveyGGO1.LCRM_Sub_BU__c ='GGO';
      testCaseSurveyGGO1.ESC_Send_Survey__c=true;
      testCaseSurveyGGO1.ESC_Survey_Sent__c=false;
      testCaseSurveyGGO1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident (Read Only)').getRecordTypeId();
      insert testCaseSurveyGGO1;     
      
        testCaseSurveyGGO1.Status='Closed';
        update testCaseSurveyGGO1;
        

        testCaseSurvey.Status='New';      
      testCaseSurvey.ESC_Fix_Applied_Time__c =NULL;
      testCaseSurvey.ESC_Impact__c = '1-Whole Site';
      testCaseSurvey.subject='tst';
      testCaseSurvey.ESC_Customer_Symptom__c='Content Addition';
      testCaseSurvey.ESC_Diagnosis_Summary__c='Content Explanation';
      testCaseSurvey.ESC_Severity__c='1 - High';
      testCaseSurvey.Description='test';
      testCaseSurvey.LCRM_Sub_BU__c ='US';
      testCaseSurvey.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      insert testCaseSurvey;     
      
        testCaseSurvey.Status='Closed';
        update testCaseSurvey;
               
      GLIGenericUtilityHelper.setGLI(testcase); 
      Test.stopTest();
   
      }
        
        
     
      List<Id> clist= new List<ID>();
        
      clist.add(testcase.Id);
        clist.add(testcase1.Id);
      
      ESC_Survey__c survey1= new ESC_Survey__c();
      survey1.ESC_Case__c= testcase.Id;
      Survey1.GLI_Is_GLI__c = true;
      survey1.ESC_YNAnswer_1__c='No';
      Insert Survey1;
              
      //ESC_SurveyFieldUpdation Process Builder
      ESC_Survey__c survey2= new ESC_Survey__c();
      survey2.ESC_Case__c= testcase.Id;
      Survey2.GLI_Is_GLI__c = true;
      survey2.ESC_YNAnswer_1__c='No';
      survey2.ESC_Answer_1__c=12;
      survey2.ESC_Answer_2__c=876;
      survey2.ESC_Answer_3__c=87;
      survey2.ESC_Answer_4__c=89;
      survey2.ESC_Answer_5__c=98;
      survey2.ESC_Answer_6__c=53;
      survey2.ESC_Answer_7__c=764;
      survey2.ESC_Answer_8__c=3454;
      survey2.ESC_Answer_9__c=34;
      survey2.ESC_Answer_10__c=9879;
      survey2.ESC_YNAnswer_1__c='No';
      survey2.ESC_YNAnswer_1__c='No';
      survey2.GLI_Is_GLI__c=true;
      survey2.GLI_Is_GLI__c=true;
      Insert Survey2;
      
      ESC_Survey__c survey3= new ESC_Survey__c();
      survey3.ESC_Case__c= testCaseSurvey.Id;
      Survey3.GLI_Is_GLI__c = true;
      survey3.ESC_YNAnswer_1__c='No';
      survey3.ESC_Answer_1__c=12;
      survey3.ESC_Answer_2__c=876;
      survey3.ESC_Answer_3__c=87;
      survey3.ESC_Answer_4__c=89;
      survey3.ESC_Answer_5__c=98;
      survey3.ESC_Answer_6__c=53;
      survey3.ESC_Answer_7__c=764;
      survey3.ESC_Answer_8__c=3454;
      survey3.ESC_Answer_9__c=34;
      survey3.ESC_Answer_10__c=9879;
      survey3.ESC_YNAnswer_1__c='No';
      survey3.ESC_YNAnswer_1__c='No';
      survey3.GLI_Is_GLI__c=true;
      survey3.GLI_Is_GLI__c=true;
      Insert Survey3;
      
      
      GLIGenericUtilityHelper.ReopenCaseShareSurveyToOwner(clist);
      GLIGenericUtilityHelper.ShareRecords(survey2.id,Userlist);
          }
          catch(Exception e)    
          {
              system.debug(e);
          }
    }
    
    public static testmethod void testMethod3()
    {
        boolean serviceuser;
      Profile p = [SELECT Id FROM Profile WHERE Name='GLI Helpdesk Agent']; 
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
        
        /**ESC_segment_Region_Lotus__c SegRegCorp = new ESC_segment_Region_Lotus__c();*/
      // SegRegCorp.ESC_IP_BU_Marketing_Segment__c = 'Corp - GTM';
      /* SegRegCorp.SetupOwnerId=UserInfo.getOrganizationId();
       insert SegRegCorp ;*/
       
      User u1 = new User(Alias = 'standt', Email='standarduser1@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p.Id,Sales_Org__c='GLI',Sub_Bu__c = 'USL',TimeZoneSidKey='America/Los_Angeles', UserName='standarduseruki1@testorg.com');
      Insert u1;
      User u2 = new User(Alias = 'sta2ndt', Email='standardus2er1@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p.Id,Sales_Org__c='GLI',Sub_Bu__c = 'FindLaw',TimeZoneSidKey='America/Los_Angeles', UserName='standarduse2ruki1@testorg.com');
      Insert u2;
        
        
      List<UKI_Static_Values__mdt> UKISV =[SELECT MasterLabel,UKI_Value__c from UKI_Static_Values__mdt];
      GLI_DomainSelectorList__c DMS= new GLI_DomainSelectorList__c();
      DMS.DomainName__c='trs.com';
      Insert DMS;
      
            ESC_segment_Region_Lotus__c segRegCorp = ESC_segment_Region_Lotus__c.getOrgDefaults();
      
      Case testCase= new case();
       Case testCase1= new case();
       case  testCase2=new case();
    System.runAs(u1) {
       Account testAccount1 = ESC_GenericTestutility.TestAccountUtil('TestAccount1' ,'TestAccount002','1251541'); 
      testAccount1.bu_marketing_segment__c='Other';
      insert testAccount1;
      Contact testContact1 = ESC_GenericTestutility.TestContactUtil(testAccount1.id ,'Mile1','test@trs.com');
      testContact1.Firstname='test';
      insert testContact1;
      
      testcase1.contactid=testContact1.id;  
      testcase1.Status='Work in Progress';
      testcase1.ESC_Fix_Applied_Time__c =NULL;
      testcase1.ESC_Impact__c = '1-Whole Site';
      testcase1.subject='tst';
      testcase1.ESC_Customer_Symptom__c='Content Addition';
      testcase1.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase1.ESC_Severity__c='1 - High';
      testcase1.Description='test';
      testcase.LCRM_Sub_BU__c ='US';
      testcase1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase1.ESC_Suspend_Asset__c=false;
      //testcase1.esc_account_marketing_segment__c=segRegCorp.ESC_IP_BU_Marketing_Segment__c;
      Insert testcase1;
      
      Test.startTest();
      GLIGenericUtilityHelper.setGLI(testcase1);
       // The following code runs as user 'u' 
        serviceuser= GLIGenericUtilityHelper.GLIServiceUserCheck();
      Test.stopTest();
    
      }  
      System.runAs(u2) {
       Account testAccount1 = ESC_GenericTestutility.TestAccountUtil('TestAccount1' ,'TestAccount002','1251541'); 
      testAccount1.bu_marketing_segment__c='Other';
      insert testAccount1;
      Contact testContact2 = ESC_GenericTestutility.TestContactUtil(testAccount1.id ,'Mile1','test@trs.com');
      testContact2.Firstname='test';
      insert testContact2;
      
      testcase2.contactid=testContact2.id;  
      testcase2.Status='Work in Progress';
      testcase2.ESC_Fix_Applied_Time__c =NULL;
      testcase2.ESC_Impact__c = '1-Whole Site';
      testcase2.subject='tst';
      testcase2.ESC_Customer_Symptom__c='Content Addition';
      testcase2.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase2.ESC_Severity__c='1 - High';
      testcase2.Description='test1';
      testcase2.LCRM_Sub_BU__c ='US';
      testcase1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      Insert testcase2;
      set<Id> caseid = new set<Id>();
      caseid.add(testcase2.id);
      GLIGenericUtilityHelper.setGLI(testcase2);
      GLIGenericUtilityHelper.callForAssetSubscriptionChanges(caseid);
      
    
      serviceuser= GLIGenericUtilityHelper.GLIServiceUserCheck();
      }
    } 
    public static testmethod void testMethod4(){    
        Account testAccount1 = ESC_GenericTestutility.TestAccountUtil('TestAccount1' ,'TestAccount002','1251541'); 
          testAccount1.bu_marketing_segment__c='Other';
          insert testAccount1;
          Contact testContact1 = ESC_GenericTestutility.TestContactUtil(testAccount1.id ,'Mile1','test@trs.com');
          testContact1.Firstname='test';
          insert testContact1;
          case  testCase2=new case();
          testcase2.contactid=testContact1.id;  
      testcase2.Status='Work in Progress';
      testcase2.ESC_Fix_Applied_Time__c =NULL;
      testcase2.ESC_Impact__c = '1-Whole Site';
      testcase2.subject='tst';
      testcase2.ESC_Customer_Symptom__c='Content Addition';
      testcase2.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase2.ESC_Severity__c='1 - High';
      testcase2.Description='test1';
      testcase2.LCRM_Sub_BU__c ='US';
      testcase2.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      Insert testcase2;
      List<Id> caseid = new List<Id>();
      caseid.add(testcase2.id);
      ESC_Survey__c survey3= new ESC_Survey__c();
      survey3.ESC_Case__c= testcase2.Id;
      Survey3.GLI_Is_GLI__c = true;
      survey3.ESC_YNAnswer_1__c='No';
      survey3.ESC_Answer_1__c=12;
      survey3.ESC_Answer_2__c=876;
      survey3.ESC_Answer_3__c=87;
      survey3.ESC_Answer_4__c=89;
      survey3.ESC_Answer_5__c=98;
      survey3.ESC_Answer_6__c=53;
      survey3.ESC_Answer_7__c=764;
      survey3.ESC_Answer_8__c=3454;
      survey3.ESC_Answer_9__c=34;
      survey3.ESC_Answer_10__c=9879;
      survey3.ESC_YNAnswer_1__c='No';
      survey3.ESC_YNAnswer_1__c='No';
      survey3.GLI_Is_GLI__c=true;
      survey3.GLI_Is_GLI__c=true;
      Insert Survey3;
      try{
      GLIGenericUtilityHelper.ReopenCaseShareSurveyToOwner(caseid);
      }
      catch(Exception e){}    
    }
}