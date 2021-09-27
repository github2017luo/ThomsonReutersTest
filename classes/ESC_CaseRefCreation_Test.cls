@IsTest
public class ESC_CaseRefCreation_Test{
    
    
    @IsTest(SeeAllData=false) static void Method1() {

      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      //added to bypass cannot use status as workin progress validation issue
      
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
        
      User u = new User(Alias = 'Testb6', Email='sysadminb6@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testingb6', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='Testb6@ss.com');
      insert u;
      
      
      
      
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'MileFirst','Milelast','test@tr.com');
      insert testContact;
       
      List <Case> listcase= new List<Case>();
      list<id> listid=new list<id>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;

      testCase.description='DESC';
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      listcase.add(testCase);
     // insert testCase;

      
     
      
     // insert testCase;
      insert listcase;
      
      System.debug('testCase@@'+testCase);

       Group g = new Group();
       g.Name = 'Test';
       g.type='Queue';
       insert g;
       
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        GroupMember gm = new GroupMember(
        GroupId = g.id,
        UserOrGroupId = u.id
        );
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert gm;}

        ESC_SN_AssignmentGroup__c asn=new ESC_SN_AssignmentGroup__c();
        asn.ESC_Assignment_Group__c='Test';
        insert asn;
  
      ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
      ref.ESC_Role__c='Accountable Resolver';
      ref.Ownerid=g.id;
      ref.ESC_Case__c=listcase[0].id;
      ref.ESC_Referral_Status__c='New';
      //ref.ESC_End_Date__c=null;
      insert ref;
      
      ESC_ServiceNow_Staging__c staging=new ESC_ServiceNow_Staging__c();
      staging.ESC_Description__c='descriptionTest';
      staging.ESC_ID__c=ref.id;
      staging.ESC_Transmit_Status__c='Success';
      staging.ESC_Staging_Status__c='Sent';
      insert staging;
      
      listid.add(listcase[0].id);
     //Used to store the Interval,batchsize and current job id of the service now staging scheduler
      ESC_ServiceNow_Scheduler_Settings__c ss=new ESC_ServiceNow_Scheduler_Settings__c();
      ss.Name='ServiceNowSettings';
      ss.ESC_No_Of_Retries__c=10;
      insert ss;
 
       Test.startTest();
       ESC_CaseRefCreation.CaseRefCreation(listid);
       Test.stopTest();
        }
        
         @IsTest(SeeAllData=false) static void Method2() {
         
         //added to bypass cannot use status as workin progress validation issue
         LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
         
                Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'MileFirst','Milelast','test@tr.com');
      insert testContact;
       
      List <Case> listcase= new List<Case>();
      list<id> listid=new list<id>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      
      testCase.description='DESC';
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      listcase.add(testCase);
     // insert testCase;
      insert listcase;
      System.debug('testCase@@'+testCase);

       Group g = new Group();
       g.Name = 'Test';
       g.type='Queue';
       insert g;
       
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        GroupMember gm = new GroupMember(
        GroupId = g.id,
        UserOrGroupId = UserInfo.getUserId()
        );
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert gm;}

        ESC_SN_AssignmentGroup__c asn=new ESC_SN_AssignmentGroup__c();
        asn.ESC_Assignment_Group__c='Test';
        insert asn;
  
        Case testCase1=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
        insert testCase1;
        
      ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
      ref.ESC_Role__c='Accountable Resolver';
      ref.Ownerid=g.id;
      ref.ESC_Case__c=testCase1.id;
      ref.ESC_Referral_Status__c='New';
      ref.ESC_End_Date__c=null;
      insert ref;
      
      ESC_ServiceNow_Staging__c staging=new ESC_ServiceNow_Staging__c();
      staging.ESC_Description__c='descriptionTest';
      staging.ESC_ID__c=ref.id;
      staging.ESC_Transmit_Status__c='Success';
      staging.ESC_Staging_Status__c='Sent';
      insert staging;
      
      listid.add(listcase[0].id);
      
      //Used to store the Interval,batchsize and current job id of the service now staging scheduler
      ESC_ServiceNow_Scheduler_Settings__c ss=new ESC_ServiceNow_Scheduler_Settings__c();
      ss.Name='ServiceNowSettings';
      ss.ESC_No_Of_Retries__c=10;
      insert ss;
      
     
       Test.startTest();
       ESC_CaseRefCreation.CaseRefCreation(listid);
      
       list<id> listid2;
       ESC_CaseRefCreation.CaseRefCreation(listid2);
       Test.stopTest();
         }


}