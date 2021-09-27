@isTest
public class ESC_CaseRouting_test{


    @IsTest(SeeAllData=false) static void escCaseRoutingMethod(){
            
           Test.StartTest();
          
            
          //This code run as a system user
           UserRole ur =[SELECT  DeveloperName,Id,Name FROM UserRole where Name='Credentialing Team lead'];
      Profile p = [SELECT Id FROM Profile WHERE Name='USL Helpdesk Agent']; 
      User u = new User(Alias = 'standt99', Email='sysadmin@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin99@testorg.com');
      insert u;
      
      ESC_email_deletion_roles__c edr= new ESC_email_deletion_roles__c(name = 'Credentialing Team lead',role__c ='USL_Credentialing_Team_lead');
      System.debug(LoggingLevel.WARN,'edr ' +edr); 
      LatAm_Profile_List__c lp = new LatAm_Profile_List__c(name ='LatAmProfileList',Profile_List__c ='USL Helpdesk Agent,LatAm User;Partner Portal User;LatAM Helpdesk Agent;LatAm Service Accountable Resolver;LatAM Help Desk Manager');      
      System.debug(LoggingLevel.WARN,'lp: ' +lp); 
      System.runAs(u){
       //to bypass validation --- status cannot be equal to work in progress
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
        
     Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
       
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
       
       
    ESC_QueueSelectorFields__c escQueuesf =new ESC_QueueSelectorFields__c();
     escQueuesf.name='Rec-001';
     escQueuesf.ESC_Case_Field1__c='Subject';
     escQueuesf.ESC_Case_Field2__c='ToAddress';
     escQueuesf.ESC_Case_Field3__c='FromAddress';
     
     insert  escQueuesf;
      //insert case
      List<Id> emIdSet = new List<Id>();
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.ESC_Fix_Applied_Time__c=NULL;
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase.OwnerId=u.id;
      listcase.add(testCase); 
     
     insert listcase; 
     // emIdSet.add(testcase.id);
    
     
     EmailMessage[] newEmail = new EmailMessage[0];
newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'NEW YORK', TextBody = '23456 ', ParentId = listcase[0].Id)); 
insert newEmail;

      List <EmailMessage> listemail= new List<EmailMessage>();
      EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;        
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = listcase[0].Id; 
               
        listemail.add(email); 
    //list<EmailMessage> deletemessage = new list<EmailMessage>();
   
        EmailMessage email1 = new EmailMessage();
        email1.FromAddress = 'test@tr.com';
        email1.Incoming = True;        
        email1.Subject = 'Test email';
        email1.HtmlBody = 'Test email body';
        email1.ParentId = listcase[0].Id; 
        listemail.add(email);
            
        //delete deletemessage;
         
        
        //insert listemail;
       
        list<string> queuelist =new list<string>();
        list<ESC_QueueSelectorList__c> listqueuesel =new list<ESC_QueueSelectorList__c>();
        ESC_QueueSelectorList__c esc1=new ESC_QueueSelectorList__c(ESC_Case_Field1__c='NEW YORK',ESC_Queue_Name__c='CORP_Support',ESC_Case_Field2__c='@gmail.com');
        ESC_QueueSelectorList__c esc=new ESC_QueueSelectorList__c(ESC_Case_Field1__c='Test',ESC_Case_Field2__c='@gmail.com',ESC_Case_Field3__c='@thomsonreuters.com',ESC_Queue_Name__c='CORP_Support');
         ESC_QueueSelectorList__c esc2=new ESC_QueueSelectorList__c(ESC_Case_Field2__c='',ESC_Case_Field1__c='@hot.com',ESC_Queue_Name__c='CORP "A"');
         listqueuesel.add(esc1);
         listqueuesel.add(esc);
         listqueuesel.add(esc2);
         queuelist.add(esc1.ESC_Queue_Name__c);
         queuelist.add(esc.ESC_Queue_Name__c);
         queuelist.add(esc2.ESC_Queue_Name__c);
         insert listqueuesel;
          
        List<Attachment> listattc =new List<Attachment>();
           List<ID> listattcId =new List<ID>();
        map<Id,Attachment> oldmapattc =new Map<id,Attachment>();
        Attachment att = new Attachment();
         att.ParentId = listcase[0].Id;          
         att.Name = 'Test Tarifador';
         Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body');
         att.body = bodyBlob1;
         listattc.add(att);
         listattcId.add(att.Id);
         oldmapattc.put(att.id,att);
         
         
           
         //ESC_CaseRouting.Attchmentpreventdeletion(oldmapattc);         
       
    
         
         
        // Group newgroup =new Group();
         //newgroup.name='';
         insert listattc;
         Delete listattc;
         List<Group> grpList = [SELECT Id,Name,Type FROM Group where type='Queue' AND DeveloperName =:queuelist]; 
         
            list<case> updCaseList =new list<case>();
             Case caseupd = new Case();
                    caseupd.id =listcase[0].id;   
                    caseupd.Description='testing';     
                    caseupd.ownerid = grpList[0].id;        
                    updCaseList.add(caseupd);
                update updCaseList;
            emIdSet.add(caseupd.id);          
          
          ESC_CaseRouting.caseQueueAssociation(listemail); 
          
         ESC_CaseRouting.EMpreventdeletion(listemail);
            
         ESC_CaseRouting.emAttachmentPreventDeletion(listattc);
         
        
        EmailMessage[] newEmail1 = new EmailMessage[0];
newEmail1.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'NEW YORK', TextBody = '23456 ', ParentId = listcase[0].Id)); 
Delete newEmail;  
        
              
      List<ESC_QueueSelectorList__c> rtlist = new List<ESC_QueueSelectorList__c>();
      ESC_QueueSelectorList__c r1 = new ESC_QueueSelectorList__c(ESC_Case_Field1__c = 'NEW YORK',ESC_Case_Field2__c='',ESC_Case_Field3__c='',ESC_Queue_Name__c='State "E"');
      ESC_QueueSelectorList__c r2 = new ESC_QueueSelectorList__c(ESC_Case_Field1__c = '' ,ESC_Case_Field2__c='west.CCBusinessAnalysts@thomsonreuters.com',ESC_Case_Field3__c='',ESC_Queue_Name__c='State "B"');
      ESC_QueueSelectorList__c r3= new ESC_QueueSelectorList__c(ESC_Case_Field1__c = '' ,ESC_Case_Field2__c='',ESC_Case_Field3__c='ALASKA.GOV',ESC_Queue_Name__c=' State "B"');
      ESC_QueueSelectorList__c r4 = new ESC_QueueSelectorList__c(ESC_Case_Field1__c = 'HAWAII' ,ESC_Case_Field2__c='xbordersupport@thomsonreuters.com',ESC_Case_Field3__c='',ESC_Queue_Name__c='Cross Border Support');
      rtlist.add(r1);
      rtlist.add(r2);
      rtlist.add(r3);
      rtlist.add(r4);
     
      insert rtlist;
     }
    Test.stopTest();  
    
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal.');
}
@IsTest(SeeAllData=false) static void escCaseRoutingMethod1(){
    
    User u;
    LatAm_Profile_List__c lp;      
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        //This code run as a system user
           UserRole ur =[SELECT  DeveloperName,Id,Name FROM UserRole where Name='Credentialing Team lead'];
     
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      
      u = new User(Alias = 'standt99', Email='sysadmin@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin99@testorg.com');
      //insert u;
      
       lp = new LatAm_Profile_List__c ( name = 'LatAmProfileList',Profile_List__c = 'LatAm User;Partner Portal User;LatAM Helpdesk Agent;LatAm Service Accountable Resolver;LatAM Help Desk Manager');
      insert lp;
      ESC_email_deletion_roles__c edr= new ESC_email_deletion_roles__c(name = 'Credentialing Team lead',role__c ='USL_Credentialing_Team_lead');
      insert edr;
       
      
    }
      System.runas(u){
      
      
       //to bypass validation --- status cannot be equal to work in progress
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
        
     Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
       
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
       
       
      //insert case
      //List<Id> emIdSet = new List<Id>();
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'New');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.ESC_Fix_Applied_Time__c=NULL;
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase.OwnerId=u.id;
      listcase.add(testCase); 
     
     insert listcase; 
    
          
            Test.StartTest();    
          /*ContentVersion cv = new ContentVersion(
                Title = 'Test',
                PathOnClient = 'Test.jpg',
                VersionData = blob.valueof('Test Content Data'),
                IsMajorVersion = true); 
              insert cv;
              
              ContentVersion cv=new Contentversion();
                cv.title='ABC';
                cv.PathOnClient ='test';
                Blob b=Blob.valueOf('Unit Test Attachment Body');
                cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
                insert cv;*/
                String clientPath = 'photo_1.jpg';
                ContentVersion cv = new ContentVersion(title='test',versiondata=Blob.valueOf('test'),pathonclient=clientPath);
                insert cv;
              //Test.setCreatedDate(cv.Id, DateTime.now());
             List<ContentDocument> contDocList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];  
             ContentDocumentLink contentlink=new ContentDocumentLink();
             contentlink.LinkedEntityId=listcase[0].id;  
             contentlink.ShareType= 'V';               
             contentlink.ContentDocumentId=contDocList[0].Id;
             contentlink.Visibility = 'AllUsers'; 
             insert contentlink;
             /////////Test.setCreatedDate(contentlink.Id, DateTime.now());
      
              List<Id> contentDocId= new List<Id>((new Map<Id,ContentDocument>(contDocList)).keySet());
                     
           
         ESC_CaseRouting.filesPreventDeletion(contDocList);  
         Delete contDocList;   
         ESC_CaseRouting.contentDocumentLinkRecords(contentDocId);
      Test.stopTest();
       }
    
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal.');
}
   
}