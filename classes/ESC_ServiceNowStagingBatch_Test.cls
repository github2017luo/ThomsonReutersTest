@isTest(SeeAllData=false)
/******Written by Saivaj
    Written on 12/1/2018
                      ******/

Public class ESC_ServiceNowStagingBatch_Test{

 static testMethod void testMethod1()
{
    List<Case> lstCase = new List<Case>();
    List<ESC_ServiceNow_Scheduler_Settings__c> lstsschset = new List<ESC_ServiceNow_Scheduler_Settings__c>();
         
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'Testa3', Email='sysadmina3@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testinga3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='Testa3@ss.com');
      insert u;
       
        ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
        cs.Name='ServiceNowSettings';
        cs.ESC_BatchSchedule_Interval__c=15;
        cs.ESC_Current_Job_ID__c='';
        cs.ESC_BatchSize__c=200;
        cs.ESC_EmailBody__c='The following records of the Service Now Staging Records are failed permanently.';
        cs.ESC_From_Address__c='Thomson Reuters Customer Support';
        cs.ESC_Subject__c='Salesforce Service Now Staging Failed records List';
        cs.ESC_To_Address__c='customersupportuki@tr.com';
        cs.ESC_No_Of_Retries__c= 5;
        cs.ESC_Query_Limit__c=50000 ;
        //cs.Other fiels values
        insert cs ;
      
               //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='test';
          //testContact.LastName='test';
          insert testContact;
          
          //Insert a List of Cases
          List <Case> listcase= new List<Case>();
          Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'New');
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
          QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert mappingObject;}
         
         
        GroupMember gm = new GroupMember(
        GroupId = g.id,
        UserOrGroupId = u.id);
        
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert gm;}

          ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
          ref.ESC_Role__c='Collaborator';
          ref.Ownerid=g.id;
          ref.ESC_Case__c=listcase[0].id;
          ref.ESC_Referral_Status__c='New';
          ref.ESC_End_Date__c=null;
          
          List<ESC_Case_Collaborator__c> cclist = new List<ESC_Case_Collaborator__c>();
          cclist.add(ref);
          insert cclist;
          
           List<ESC_ServiceNow_Staging__c> UpdateStagingList= New List<ESC_ServiceNow_Staging__c>();
           ESC_ServiceNow_Staging__c sns = new ESC_ServiceNow_Staging__c();
            sns.ESC_BusinessArea__c='GGO';
            sns.ESC_Source__c='LATAM-SFDCIntegration';
            sns.ESC_AssignmentGroup__c = 'DATA-CMDG-LATAM';
            sns.ESC_ID__c =cclist[0].id;
            sns.ESC_Description__c ='test desc';
            sns.ESC_No_Of_Retries__c =0;
            sns.ESC_Staging_Status__c ='Pending';
            sns.ESC_RequestType__c ='Create';
            sns.ESC_Case_Status__c = 'Open';
            sns.ESC_SLA__c= 'Low';
            sns.ESC_CaseNumber__c = listcase[0].CaseNumber;
            sns.ESC_Case_Id__c = listcase[0].id;
            sns.ESC_Employee_Number__c ='X83930';
            sns.ESC_SourceLink__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+Ref.ESC_Case__c; //for attachment
           
            /*Staging.ESC_RequestType__c = 'Update';
            staging.ESC_External_Task_Reference_Number__c = Ref.ESC_Case__r.ESC_External_Task_Reference_Number__c;
            staging.ESC_SNOW_ID__c = Ref.ESC_Case__r.ESC_External_Ticket_Number__c;
            staging.ESC_Case_Status__c = 'CloseComplete';  
            staging.ESC_Feed_Comment__c = ''; */
            
            UpdateStagingList.add(sns);
            insert UpdateStagingList;
            
        //This provides a setting to maintain all standard integration settings (e.g. Endpoint, Timeout etc.)
        ESC_Integration_Setting__c intsett = new ESC_Integration_Setting__c();
        intsett.Name = 'SNOW';
        intsett.ESC_Enable_Logging__c = true;
        intsett.ESC_Endpoint_Server__c = 'https://api-dev.thomsonreuters.com';
        intsett.ESC_Endpoint_URI__c= '/boomi/servicerequest/v1/createServiceRequest';
        intsett.ESC_Endpoint_Update_URI__c = '/boomi/servicerequest/v1/updateServiceRequest';
        intsett.ESC_HTTP_Headers__c = 'Content-Type=>application/json;Authorization=>BASIC c2Fwc3J1c2VyOiRhcDJTTl9lc2k=';
        intsett.ESC_HTTP_Method__c = 'POST';
        intsett.ESC_Timeout__c = 120000.0;
        insert intsett;
        
            
        /*ESC_ServiceNowStagingHelper.SNOWCallout(UpdateStagingList);
        List<ESC_ServiceNow_Staging__c> insertStagingList= New List<ESC_ServiceNow_Staging__c>();
        ESC_ServiceNow_Staging__c sns1 = new ESC_ServiceNow_Staging__c();
            sns1.ESC_ID__c =cclist[0].id;
            sns1.ESC_No_Of_Retries__c =5;
            sns1.ESC_Transmit_Status__c ='';
            sns1.ESC_SNOW_ID__c ='SNOW ID092';
            insertStagingList.add(sns1);
            insert insertStagingList;*/
          
          
            Test.startTest(); 
            ESC_ServiceNowStagingBatch obj = new ESC_ServiceNowStagingBatch(); 
            DataBase.executeBatch(obj); 
            Test.stopTest();
      
}
          
}