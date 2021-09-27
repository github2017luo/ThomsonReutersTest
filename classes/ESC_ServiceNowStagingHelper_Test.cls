@isTest(SeeAllData=false)
public class ESC_ServiceNowStagingHelper_Test{

    testMethod static void Method1(){
         //Get a fresh set of Governor Limits.
          Test.startTest();
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'Testa4', Email='sysadmina4@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testinga4', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='Testa4@ss.com');
          insert u;

         //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='hgs';
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
          g.Name = 'SNI_Customer Master Data';
          g.type='Queue';
          insert g;
          
          
          //As we create mappingObject to map user with the particular queue or Group
          QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert mappingObject;}
          
          GroupMember gm = new GroupMember( GroupId = g.id,UserOrGroupId = u.id);
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert gm;}
        
          //Custom Setting - Service Now Assignment Group
          ESC_SN_AssignmentGroup__c asn=new ESC_SN_AssignmentGroup__c();
          asn.ESC_Assignment_Group__c = 'SNI_Customer Master Data';
          asn.ESC_SN_Chatter_Group__c = 'SNI_Customer Master Data';
          asn.ESC_Sub_BU__c = 'GGO';
          asn.ESC_SLA_Default__c= 'Low';
          asn.SetupOwnerId=p.id;
          insert asn;
       
          // Custom Object Routing data to be sent to Service Now 
           ESC_ServiceNow_Routing__c routing= new ESC_ServiceNow_Routing__c();
           routing.ESC_Sub_BU__c = 'GGO';
           routing.ESC_SOURCE__c='LATAM-SFDCIntegration';
           routing.ESC_ASSIGNMENT_GROUP__c='DATA-CMDG-LATAM';
           insert routing;
        
         //Custom Object - ESC_Case_Collaborator__c (Referral) As created case can be referred to a group
          ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
          ref.ESC_Role__c='Collaborator';
          ref.Ownerid=g.id;
          ref.ESC_Case__c=listcase[0].id;
          ref.ESC_Referral_Status__c='New';
          ref.ESC_End_Date__c=null;
          
          
          List<ESC_Case_Collaborator__c> cclist = new List<ESC_Case_Collaborator__c>();
          cclist.add(ref);
          insert cclist;
          
          
           //ESC_Staging_Object to hold the records to be sent to Service Now
           
           List<ESC_ServiceNow_Staging__c> stagList = New List<ESC_ServiceNow_Staging__c>();
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
            sns.ESC_SLA__c= '4-Low';
            sns.ESC_CaseNumber__c = listcase[0].CaseNumber;
            sns.ESC_Case_Id__c = listcase[0].id;
            sns.ESC_Employee_Number__c ='X83930';
            sns.ESC_SNOW_ID__c='REQ001234';
            sns.ESC_SourceLink__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+Ref.ESC_Case__c; //for attachment
            stagList.add(sns);
            /*Staging.ESC_RequestType__c = 'Update';
            staging.ESC_External_Task_Reference_Number__c = Ref.ESC_Case__r.ESC_External_Task_Reference_Number__c;
            staging.ESC_SNOW_ID__c = Ref.ESC_Case__r.ESC_External_Ticket_Number__c;
            staging.ESC_Case_Status__c = 'CloseComplete';  
            staging.ESC_Feed_Comment__c = ''; */
            
            
            insert stagList;
            
            sns.ESC_SNOW_ID__c='REQ00123';
            update sns;
         
       //Used to store the Interval,batchsize and current job id of the service now staging scheduler
            ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
            cs.Name='ServiceNowSettings';
            cs.ESC_BatchSchedule_Interval__c=15;
            cs.ESC_Current_Job_ID__c='';
            cs.ESC_BatchSize__c=200;
            cs.ESC_EmailBody__c='The following records of the Service Now Staging Records are failed permanently.';
            cs.ESC_From_Address__c='Thomson Reuters Customer Support';
            cs.ESC_Subject__c='Salesforce Service Now Staging Failed records List';
            cs.ESC_To_Address__c='customersupportukiuat@tr.com';
            cs.ESC_No_Of_Retries__c= 5;
            cs.ESC_Query_Limit__c=50000 ;
            //cs.Other fiels values
            insert cs ;
    
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
        
        //ESC_HandlerCustomException ce = new ESC_HandlerCustomException();
  
         
        
         //ESC_ServiceNowStagingWrapper.cls_ServiceRequestResponse strRes = new ESC_ServiceNowStagingWrapper.cls_ServiceRequestResponse();
        
        HttpResponse response = new HttpResponse();
         String strRes =  '{'+
        '   "ServiceRequestResponse": {'+
        '       "statusCode": "200",'+
        '       "statusMessage": "success",'+
        '       "serviceRequest": "RITM000111",'+
        '       "taskNumber": "Task10002"'+
        '   }'+
        '}';
        response.setHeader('Content-Type', 'application/json');
        response.setBody(strRes);
        response.setStatusCode(200); 
         
        ESC_ServiceNowStagingWrapper res = ESC_ServiceNowStagingWrapper.parse(response.getBody()); 
        system.debug('res.ServiceRequestResponse.statusCode****'+res.ServiceRequestResponse.statusCode);
         
        //Caling a method of ESC_ServiceNowStagingHelper class 
        try{
         ESC_ServiceNowStagingHelper.SNOWCallout(stagList);
         }Catch(Exception e){
         }
         //ESC_ServiceNowStagingHelper.StagingUpdater(cclist);
        response =ESC_ServiceNowStagingHelper.processCallout('SNOW','{sadsf : retet;}','Create');
        
        
   
        Test.stopTest(); 
        }
        
       testMethod static void Method2(){
         //Get a fresh set of Governor Limits.
          Test.startTest();
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'Testb4', Email='sysadminb4@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testingb4', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='Testb4@ss.com');
          insert u;

         //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='fesdf';
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
          testCase.ESC_External_Task_Reference_Number__c = 'Task28329w0';
          testCase.ESC_External_Ticket_Number__c = 'SNw829w2';
          listcase.add(testCase);
          insert listcase;
    
         //Case created is assign to particular Queue and Queue is consist of group of member.
          Group g = new Group();
          g.Name = 'SNI_Customer Master Data';
          g.type='Queue';
          insert g;
          
          
          //As we create mappingObject to map user with the particular queue or Group
          QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert mappingObject;}
          
          GroupMember gm = new GroupMember( GroupId = g.id,UserOrGroupId = u.id);
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert gm;}
        
          //Custom Setting - Service Now Assignment Group
          ESC_SN_AssignmentGroup__c asn=new ESC_SN_AssignmentGroup__c();
          asn.ESC_Assignment_Group__c = 'SNI_Customer Master Data';
          asn.ESC_SN_Chatter_Group__c = 'SNI_Customer Master Data';
          asn.ESC_Sub_BU__c = 'GGO';
          asn.ESC_SLA_Default__c= 'Low';
          asn.SetupOwnerId=p.id;
          insert asn;
       
          // Custom Object Routing data to be sent to Service Now 
           ESC_ServiceNow_Routing__c routing= new ESC_ServiceNow_Routing__c();
           routing.ESC_Sub_BU__c = 'GGO';
           routing.ESC_SOURCE__c='LATAM-SFDCIntegration';
           routing.ESC_ASSIGNMENT_GROUP__c='DATA-CMDG-LATAM';
           insert routing;
        
         //Custom Object - ESC_Case_Collaborator__c (Referral) As created case can be referred to a group
          ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
          ref.ESC_Role__c='Collaborator';
          ref.Ownerid=g.id;
          ref.ESC_Case__c=listcase[0].id;
          ref.ESC_Referral_Status__c='New';
          ref.ESC_End_Date__c=null;
          
          
          List<ESC_Case_Collaborator__c> cclist = new List<ESC_Case_Collaborator__c>();
          cclist.add(ref);
          insert cclist;
          
          
          //ESC_Staging_Object to hold the records to be sent to Service Now
          List<ESC_ServiceNow_Staging__c>  stagList=new List<ESC_ServiceNow_Staging__c>();  
          ESC_ServiceNow_Staging__c sns2 = new ESC_ServiceNow_Staging__c();
            sns2.ESC_BusinessArea__c='GGO';
            sns2.ESC_Source__c='LATAM-SFDCIntegration';
            sns2.ESC_AssignmentGroup__c = 'DATA-CMDG-LATAM';
            sns2.ESC_ID__c =cclist[0].id;
            sns2.ESC_Description__c ='test desc';
            sns2.ESC_No_Of_Retries__c =0;
            sns2.ESC_Staging_Status__c ='Pending';
            sns2.ESC_RequestType__c ='Update';
            sns2.ESC_Case_Status__c = 'Open';
            sns2.ESC_SLA__c= '4-Low';
            sns2.ESC_CaseNumber__c = listcase[0].CaseNumber;
            sns2.ESC_Case_Id__c = listcase[0].id;
            sns2.ESC_Employee_Number__c ='X83930';
            sns2.ESC_SourceLink__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+Ref.ESC_Case__c; //for attachment
            sns2.ESC_External_Task_Reference_Number__c = 'Task28329w0';
            sns2.ESC_SNOW_ID__c = 'SNw829w2';
            
            stagList.add(sns2);
            insert stagList;
          
        //Used to store the Interval,batchsize and current job id of the service now staging scheduler
            ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
            cs.Name='ServiceNowSettings';
            cs.ESC_BatchSchedule_Interval__c=15;
            cs.ESC_Current_Job_ID__c='';
            cs.ESC_BatchSize__c=200;
            cs.ESC_EmailBody__c='The following records of the Service Now Staging Records are failed permanently.';
            cs.ESC_From_Address__c='Thomson Reuters Customer Support';
            cs.ESC_Subject__c='Salesforce Service Now Staging Failed records List';
            cs.ESC_To_Address__c='customersupportukiuat@tr.com';
            cs.ESC_No_Of_Retries__c= 5;
            cs.ESC_Query_Limit__c=50000 ;
            //cs.Other fiels values
            insert cs ;
             try{
              ESC_ServiceNowStagingHelper.SNOWCallout(stagList);
              }Catch(Exception e){
            }
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
          try{
         ESC_ServiceNowStagingHelper.SNOWCallout(stagList);
         }Catch(Exception e){
         }
        List<FeedItem> feedList= new List<FeedItem>();
        FeedItem feed = new FeedItem();
        feed.Type= 'TextPost';
        feed.body='@SNI_Customer Master Data test';
        feed.parentId=listcase[0].Id;
        insert feed;
        feedList.add(feed);
        ESC_ServiceNowStagingHelper.updateSNstagingFeedUpdate(feedList);
        
        List<FeedComment> feedCommentList= new List<FeedComment>();
        FeedComment feedComment = new FeedComment();
            feedComment.CommentType= 'TextComment';
            feedComment.commentbody='@SNI_Customer Master Data test test';
            feedComment.FeedItemId=feed.Id;
            insert feedComment;
            feedCommentList.add(feedComment);
            ESC_ServiceNowStagingHelper.updateSNstagingFeedUpdate(feedCommentList);
    }     
        


testMethod static void Method3(){
         //Get a fresh set of Governor Limits.
          
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'Testb4', Email='sysadminb4@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testingb4', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='Testb4@ss.com');
          insert u;

         //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='fesdf';
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
          testCase.ESC_External_Task_Reference_Number__c = 'Task28329w0';
          testCase.ESC_External_Ticket_Number__c = 'SNw829w2';
          listcase.add(testCase);
          insert listcase;
    
         //Case created is assign to particular Queue and Queue is consist of group of member.
          Group g = new Group();
          g.Name = 'SNI_Customer Master Data';
          g.type='Queue';
          insert g;
          
          
          //As we create mappingObject to map user with the particular queue or Group
          QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert mappingObject;}
          
          GroupMember gm = new GroupMember( GroupId = g.id,UserOrGroupId = u.id);
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert gm;}
        
          //Custom Setting - Service Now Assignment Group
          ESC_SN_AssignmentGroup__c asn=new ESC_SN_AssignmentGroup__c();
          asn.ESC_Assignment_Group__c = 'SNI_Customer Master Data';
          asn.ESC_SN_Chatter_Group__c = 'SNI_Customer Master Data';
          asn.ESC_Sub_BU__c = 'GGO';
          asn.ESC_SLA_Default__c= 'Low';
          asn.SetupOwnerId=p.id;
          insert asn;
       
          // Custom Object Routing data to be sent to Service Now 
           ESC_ServiceNow_Routing__c routing= new ESC_ServiceNow_Routing__c();
           routing.ESC_Sub_BU__c = 'GGO';
           routing.ESC_SOURCE__c='LATAM-SFDCIntegration';
           routing.ESC_ASSIGNMENT_GROUP__c='DATA-CMDG-LATAM';
           insert routing;
        
         //Custom Object - ESC_Case_Collaborator__c (Referral) As created case can be referred to a group
          ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
          ref.ESC_Role__c='Collaborator';
          ref.Ownerid=g.id;
          ref.ESC_Case__c=listcase[0].id;
          ref.ESC_Referral_Status__c='New';
          ref.ESC_End_Date__c=null;
          
          
          List<ESC_Case_Collaborator__c> cclist = new List<ESC_Case_Collaborator__c>();
          cclist.add(ref);
          insert cclist;
        //  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSNStage());
          
          //ESC_Staging_Object to hold the records to be sent to Service Now
          List<ESC_ServiceNow_Staging__c>  stagList=new List<ESC_ServiceNow_Staging__c>();  
          ESC_ServiceNow_Staging__c sns2 = new ESC_ServiceNow_Staging__c();
            sns2.ESC_BusinessArea__c='GGO';
            sns2.ESC_Source__c='LATAM-SFDCIntegration';
            sns2.ESC_AssignmentGroup__c = 'DATA-CMDG-LATAM';
            sns2.ESC_ID__c =cclist[0].id;
            sns2.ESC_Description__c ='test desc';
            sns2.ESC_No_Of_Retries__c =0;
            sns2.ESC_Staging_Status__c ='Pending';
            sns2.ESC_RequestType__c ='Update';
            sns2.ESC_Case_Status__c = 'Open';
            sns2.ESC_SLA__c= '4-Low';
            sns2.ESC_CaseNumber__c = listcase[0].CaseNumber;
            sns2.ESC_Case_Id__c = listcase[0].id;
            sns2.ESC_Employee_Number__c ='X83930';
            sns2.ESC_SourceLink__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+Ref.ESC_Case__c; //for attachment
            sns2.ESC_External_Task_Reference_Number__c = 'Task28329w0';
            sns2.ESC_SNOW_ID__c = 'SNw829w2';
            
            stagList.add(sns2);
            insert stagList;
          
        //Used to store the Interval,batchsize and current job id of the service now staging scheduler
            ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
            cs.Name='ServiceNowSettings';
            cs.ESC_BatchSchedule_Interval__c=15;
            cs.ESC_Current_Job_ID__c='';
            cs.ESC_BatchSize__c=200;
            cs.ESC_EmailBody__c='The following records of the Service Now Staging Records are failed permanently.';
            cs.ESC_From_Address__c='Thomson Reuters Customer Support';
            cs.ESC_Subject__c='Salesforce Service Now Staging Failed records List';
            cs.ESC_To_Address__c='customersupportukiuat@tr.com';
            cs.ESC_No_Of_Retries__c= 5;
            cs.ESC_Query_Limit__c=50000 ;
            //cs.Other fiels values
            insert cs ;
             try{
              ESC_ServiceNowStagingHelper.SNOWCallout(stagList);
              }Catch(Exception e){
            }
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
         Test.startTest();
          try{
          
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSNStage());
         ESC_ServiceNowStagingHelper.SNOWCallout(stagList);
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSNStage());
         HTTPResponse response =ESC_ServiceNowStagingHelper.processCallout('SNOW','{sadsf : retet;}','Create');
         
         }Catch(Exception e){
         }
        Test.stopTest();
    }     
               
testMethod static void Method4(){
         //Get a fresh set of Governor Limits.
          
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'Testb4', Email='sysadminb4@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testingb4', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='Testb4@ss.com');
          insert u;

         //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='fesdf';
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
          testCase.ESC_External_Task_Reference_Number__c = 'Task28329w0';
          testCase.ESC_External_Ticket_Number__c = 'SNw829w2';
          listcase.add(testCase);
          insert listcase;
    
         //Case created is assign to particular Queue and Queue is consist of group of member.
          Group g = new Group();
          g.Name = 'SNI_Customer Master Data';
          g.type='Queue';
          insert g;
          
          
          //As we create mappingObject to map user with the particular queue or Group
          QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert mappingObject;}
          
          GroupMember gm = new GroupMember( GroupId = g.id,UserOrGroupId = u.id);
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert gm;}
        
          //Custom Setting - Service Now Assignment Group
          ESC_SN_AssignmentGroup__c asn=new ESC_SN_AssignmentGroup__c();
          asn.ESC_Assignment_Group__c = 'SNI_Customer Master Data';
          asn.ESC_SN_Chatter_Group__c = 'SNI_Customer Master Data';
          asn.ESC_Sub_BU__c = 'GGO';
          asn.ESC_SLA_Default__c= 'Low';
          asn.SetupOwnerId=p.id;
          insert asn;
       
          // Custom Object Routing data to be sent to Service Now 
           ESC_ServiceNow_Routing__c routing= new ESC_ServiceNow_Routing__c();
           routing.ESC_Sub_BU__c = 'GGO';
           routing.ESC_SOURCE__c='LATAM-SFDCIntegration';
           routing.ESC_ASSIGNMENT_GROUP__c='DATA-CMDG-LATAM';
           insert routing;
        
         //Custom Object - ESC_Case_Collaborator__c (Referral) As created case can be referred to a group
          ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
          ref.ESC_Role__c='Collaborator';
          ref.Ownerid=g.id;
          ref.ESC_Case__c=listcase[0].id;
          ref.ESC_Referral_Status__c='New';
          ref.ESC_End_Date__c=null;
          
          
          List<ESC_Case_Collaborator__c> cclist = new List<ESC_Case_Collaborator__c>();
          cclist.add(ref);
          insert cclist;
        //  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSNStage());
          
          //ESC_Staging_Object to hold the records to be sent to Service Now
          List<ESC_ServiceNow_Staging__c>  stagList=new List<ESC_ServiceNow_Staging__c>();  
          ESC_ServiceNow_Staging__c sns2 = new ESC_ServiceNow_Staging__c();
            sns2.ESC_BusinessArea__c='GGO';
            sns2.ESC_Source__c='LATAM-SFDCIntegration';
            sns2.ESC_AssignmentGroup__c = 'DATA-CMDG-LATAM';
            sns2.ESC_ID__c =cclist[0].id;
            sns2.ESC_Description__c ='test desc';
            sns2.ESC_No_Of_Retries__c =0;
            sns2.ESC_Staging_Status__c ='Pending';
            sns2.ESC_RequestType__c ='Update';
            sns2.ESC_Case_Status__c = 'Open';
            sns2.ESC_SLA__c= '4-Low';
            sns2.ESC_CaseNumber__c = listcase[0].CaseNumber;
            sns2.ESC_Case_Id__c = listcase[0].id;
            sns2.ESC_Employee_Number__c ='X83930';
            sns2.ESC_SourceLink__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+Ref.ESC_Case__c; //for attachment
            sns2.ESC_External_Task_Reference_Number__c = 'Task28329w0';
            sns2.ESC_SNOW_ID__c = 'SNw829w2';
            
            stagList.add(sns2);
            insert stagList;
          
        //Used to store the Interval,batchsize and current job id of the service now staging scheduler
            ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
            cs.Name='ServiceNowSettings';
            cs.ESC_BatchSchedule_Interval__c=15;
            cs.ESC_Current_Job_ID__c='';
            cs.ESC_BatchSize__c=200;
            cs.ESC_EmailBody__c='The following records of the Service Now Staging Records are failed permanently.';
            cs.ESC_From_Address__c='Thomson Reuters Customer Support';
            cs.ESC_Subject__c='Salesforce Service Now Staging Failed records List';
            cs.ESC_To_Address__c='customersupportukiuat@tr.com';
            cs.ESC_No_Of_Retries__c= 5;
            cs.ESC_Query_Limit__c=50000 ;
            //cs.Other fiels values
            insert cs ;
             try{
              ESC_ServiceNowStagingHelper.SNOWCallout(stagList);
              }Catch(Exception e){
            }
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
         Test.startTest();
          try{
          
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSNStageFailure());
         ESC_ServiceNowStagingHelper.SNOWCallout(stagList);
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSNStageFailure());
         HTTPResponse response =ESC_ServiceNowStagingHelper.processCallout('SNOW','{sadsf : retet;}','Create');
         
         }Catch(Exception e){
         }
        Test.stopTest();
    }
        testMethod static void Method5(){
         //Get a fresh set of Governor Limits.
          
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'Testb4', Email='sysadminb4@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testingb4', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='Testb4@ss.com');
          insert u;

         //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='fesdf';
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
          testCase.ESC_External_Task_Reference_Number__c = 'Task28329w0';
          testCase.ESC_External_Ticket_Number__c = 'SNw829w2';
          listcase.add(testCase);
          insert listcase;
    
         //Case created is assign to particular Queue and Queue is consist of group of member.
          Group g = new Group();
          g.Name = 'SNI_Customer Master Data';
          g.type='Queue';
          insert g;
          
          
          //As we create mappingObject to map user with the particular queue or Group
          QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert mappingObject;}
          
          GroupMember gm = new GroupMember( GroupId = g.id,UserOrGroupId = u.id);
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert gm;}
        
          //Custom Setting - Service Now Assignment Group
          ESC_SN_AssignmentGroup__c asn=new ESC_SN_AssignmentGroup__c();
          asn.ESC_Assignment_Group__c = 'SNI_Customer Master Data';
          asn.ESC_SN_Chatter_Group__c = 'SNI_Customer Master Data';
          asn.ESC_Sub_BU__c = 'GGO';
          asn.ESC_SLA_Default__c= 'Low';
          asn.SetupOwnerId=p.id;
          insert asn;
       
          // Custom Object Routing data to be sent to Service Now 
           ESC_ServiceNow_Routing__c routing= new ESC_ServiceNow_Routing__c();
           routing.ESC_Sub_BU__c = 'GGO';
           routing.ESC_SOURCE__c='LATAM-SFDCIntegration';
           routing.ESC_ASSIGNMENT_GROUP__c='DATA-CMDG-LATAM';
           insert routing;
        
         //Custom Object - ESC_Case_Collaborator__c (Referral) As created case can be referred to a group
          ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
          ref.ESC_Role__c='Collaborator';
          ref.Ownerid=g.id;
          ref.ESC_Case__c=listcase[0].id;
          ref.ESC_Referral_Status__c='New';
          ref.ESC_End_Date__c=null;
          
          
          List<ESC_Case_Collaborator__c> cclist = new List<ESC_Case_Collaborator__c>();
          cclist.add(ref);
          insert cclist;
         
        List<FeedItem> lstFItem = new List<FeedItem>();
        FeedItem feed = new FeedItem();
        feed.Type= 'TextPost';
        feed.body='@SNI_Customer Master Data test';
        feed.parentId=cclist[0].Id;
        lstFItem.add(feed);
        
        FeedItem feed2 = new FeedItem();
        feed2.Type= 'LinkPost';
        feed2.body='@SNI_Customer Master Data test';
        feed2.parentId=listcase[0].Id;
        feed2.title='Test';
        feed2.LinkUrl='https://login.salesforce.com';
        lstFItem.add(feed2);
        insert lstFItem;
          
    }
}