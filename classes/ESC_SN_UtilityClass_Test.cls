@isTest(SeeAllData=false)
public class ESC_SN_UtilityClass_Test{

    testMethod static void Method1(){
        
          Test.startTest();
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
           User u = new User(Alias = 'Testb1', Email='sysadminb1@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='Testb1@ss.com');
          insert u;

         //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='Test';
          insert testContact;
          
          //Insert a List of Cases
          List <Case> listcase= new List<Case>();
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
          insert listcase;
    
          //Case created is assign to particular Queue and Queue is consist of group of member.
          Group g = new Group();
          g.Name = 'Test';
          g.type='Queue';
          insert g;
          
          
          //As we create mappingObject to map user with the particular queue or Group
          QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert mappingObject;}
          
            GroupMember gm = new GroupMember(
        GroupId = g.id,
        UserOrGroupId = u.id
        );
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert gm;}
        
          //Custom Setting - Service Now Assignment Group
          ESC_SN_AssignmentGroup__c asn=new ESC_SN_AssignmentGroup__c();
          asn.ESC_Assignment_Group__c='Test';
          asn.ESC_Sub_BU__c = 'GGO';
          asn.SetupOwnerId=p.id;
          insert asn;
       
        
         //Custom Object - ESC_Case_Collaborator__c (Referral) As created case can be referred to a group
          ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
          ref.ESC_Role__c='Accountable Resolver';
          ref.Ownerid=g.id;
          ref.ESC_Case__c=listcase[0].id;
          ref.ESC_Referral_Status__c='New';
          ref.ESC_End_Date__c=null;
          
          
          List<ESC_Case_Collaborator__c> cclist = new List<ESC_Case_Collaborator__c>();
          cclist.add(ref);
          insert cclist;
          
          
          //ESC_Staging_Object to hold the records to be sent to Service Now
          List<ESC_ServiceNow_Staging__c>  stagList=new List<ESC_ServiceNow_Staging__c>();  
          ESC_ServiceNow_Staging__c staging=new ESC_ServiceNow_Staging__c();
          staging.ESC_Description__c='descriptionTest';
          staging.ESC_ID__c=ref.id;
          staging.ESC_Transmit_Status__c='transmitstatustest';
          staging.ESC_Staging_Status__c='Sent';
          staging.ESC_No_Of_Retries__c= 21;
          staging.ESC_SNOW_ID__c='REQ001234';
          staging.ESC_Feed_Comment__c='Comment';
          stagList.add(staging);
          insert stagList;
          
          
          
        //Used to store the Interval,batchsize and current job id of the service now staging scheduler
         ESC_ServiceNow_Scheduler_Settings__c ss=new ESC_ServiceNow_Scheduler_Settings__c();
         ss.Name='ServiceNowSettings';
         ss.ESC_No_Of_Retries__c=10;
         insert ss;
         
         ESC_SN_UtilityClass.RefDeletionPostCommentInStaging(cclist);

}
}