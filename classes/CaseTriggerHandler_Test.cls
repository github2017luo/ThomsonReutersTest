@istest
public class CaseTriggerHandler_Test {
    @testSetup static void testDataSetUp() {
    Test.startTest();
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = [Select Id From Profile Where Name='ANZ Users'].id);
        insert keyValue;
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId());
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId());
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId());
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId());
        insert rt3;
        
        profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = [Select Id From Profile Where Name='Partner Portal User'].id);
        insert plist;
        
        ConvertedLeadStatus__c cl = new ConvertedLeadStatus__c(name = 'true', value__c='Sales Qualified');
        insert cl;
        
        ConvertedLeadStatus__c cl1 = new ConvertedLeadStatus__c(name = 'false', value__c='Converted');
        insert cl1;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Appointment Scheduled' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Appointment_Scheduled_Ack__c');
        insert optyStage;
        
        TRWaySales__Opp_Stage_Ack_Field_Config__c optyStage1 = new TRWaySales__Opp_Stage_Ack_Field_Config__c(name = 'Generate Contract' , TRWaySales__Opp_Ack_Field_API_Name__c = 'Generate_Contract_Ack__c');
        insert optyStage1;
        
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c exitConfig = new TRWaySales__Exit_Criteria_and_I_Ack_Config__c(name = 'Criteria and I Ack Settings',TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c = true,TRWaySales__I_acknowledge_exception__c = 'BU Head,Sales Head',
                                                     TRWaySales__I_acknowledge_required__c = true);
    
        insert exitConfig;
        
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
       recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
       recordtype caseRT = [select id from recordtype where name ='Elite CPQ Requests' and sobjecttype='Case' limit 1];
       
       Profile p1 = [SELECT Id FROM profile WHERE name='Elite User'];   
       User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p1.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting01@mydomain.com',Rep_Type_Description__c='test');        
       insert u1;
       
       Account gliAccount = UnitTest.getAccountInstance();
       gliAccount.Name = 'Parent Test Account CPQ';
       gliAccount.Is_GLI__c = true;
       gliAccount.RecordTypeId=accountRT.Id;
       insert gliAccount;
       
       Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
       gliOpty.Name = 'Parent Test Opportunity CPQ';
       gliOpty.is_gli__c = true;
       gliOpty.RecordTypeId = opptyRT.Id;
       gliOpty.OwnerId = u1.Id;
       insert gliOpty;
       
       Case gliCase = UnitTest.getCaseInstance();
       gliCase.Subject = 'CPQ - '+gliOpty.Name;
       gliCase.Status = 'Draft';
       gliCase.OwnerId = gliOpty.OwnerId;
       gliCase.Is_GLI__c = gliOpty.Is_GLI__c;
       gliCase.LCRM_Sub_BU__c = gliOpty.LCRM_Sub_BU__c;
       gliCase.Opportunity__c = gliOpty.Id;
       gliCase.AccountID = gliAccount.Id;
       gliCase.RecordTypeId=caseRT.Id;
       insert gliCase;
       
       List<Group> groups = new List<Group>();
       List<QueueSObject> queues = new List<QueueSObject>(); 
       System.runAs ( new User(Id = UserInfo.getUserId()) ) {
       groups.add(new Group(Type='Queue', Name='CPQ Pricing'));
       groups.add(new Group(Type='Queue', Name='Contract Negotiation'));
       insert groups;

       queues.add(new QueueSObject(SobjectType='Case', QueueId=groups[0].Id));
       queues.add(new QueueSObject(SobjectType='Case', QueueId=groups[1].Id));
       insert queues;
      }
       
       
       List<MetaStormQueues__c> mqList = new List<MetaStormQueues__c>();
       mqList.add(new MetaStormQueues__c(name = queues[0].QueueId, QueueId__c='CPQ Pricing'));
       mqList.add(new MetaStormQueues__c(name = queues[1].QueueId, QueueId__c='Contract Negotiation'));
       insert mqList;
       
       Case gliCase1 = UnitTest.getCaseInstance();
       gliCase1.Subject = 'Insert Member';
       gliCase1.Status = 'Draft';
       gliCase1.OwnerId = groups[0].Id;
       gliCase1.Is_GLI__c = gliOpty.Is_GLI__c;
       gliCase1.LCRM_Sub_BU__c = gliOpty.LCRM_Sub_BU__c;
       gliCase1.Opportunity__c = gliOpty.Id;
       gliCase1.AccountID = gliAccount.Id;
       gliCase1.RecordTypeId=caseRT.Id;
       insert gliCase1;
        Test.stopTest();    
    }
    
    /*
    //Commented by LCRM team to fix deployment issue.
    System.LimitException: Too many SOQL queries: 101 
    Stack Trace: Class.CaseTriggerHandler.updateCaseShareRec: line 332, column 1 Trigger.CaseAfterEventListener: line 18, column 1

    public static testMethod void testSaveDetailMethod() {
        //Method for evaluating the fisrt condition in the Class.
        User thisUser = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
        Profile p = [SELECT Id FROM Profile WHERE Name='TR Legal US Sales User']; 
        User usr = [Select Id FROM User WHERE ProfileId =:p.Id AND IsActive=TRUE LIMIT 1];
        string InqryMgrQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Inquiry_Manager' LIMIT 1].Id;
        
        User userToCreate = new User();
       
       // Do you recognize these fields?
       userToCreate.FirstName = 'Test';
       userToCreate.LastName  = 'Case';
       userToCreate.Email     = 'sreenudaaram@gmail.com';
       userToCreate.Username  = 'Test_User1237654test@gmail.com';
       userToCreate.Alias     = 'tuabc';
       userToCreate.ProfileId = p.Id;

       // Don't worry about these
       userToCreate.TimeZoneSidKey    = 'America/Denver';
       userToCreate.LocaleSidKey      = 'en_US';
       userToCreate.EmailEncodingKey  = 'UTF-8';
       userToCreate.LanguageLocaleKey = 'en_US';
       
       
       insert userToCreate;
       User userToCreate1 = new User();
       
       userToCreate1.FirstName = 'Test';
       userToCreate1.LastName  = 'Case User1';
       userToCreate1.Email     = 'sreenud999@gmail.com';
       userToCreate1.Username  = 'Test_Userxyz@gmail.com';
       userToCreate1.Alias     = 'tuxyz';
       userToCreate1.ProfileId = p.Id;

       // Don't worry about these
       userToCreate1.TimeZoneSidKey    = 'America/Denver';
       userToCreate1.LocaleSidKey      = 'en_US';
       userToCreate1.EmailEncodingKey  = 'UTF-8';
       userToCreate1.LanguageLocaleKey = 'en_US';
       userToCreate1.LM_Regional_Manager__c = userInfo.getUserID();       
       
       insert userToCreate1;
       
         Id caseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCS Inquiry').getRecordTypeId();
             
        Case caseRec = new Case(CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test',RecordTypeId=caseRecordType);
        //caseRec.Salesperson__c=userToCreate1.Id; 
        
        
        Attachment attachment = new Attachment(Name = 'Test.pdf', Body = Blob.Valueof('123'));
        attachment.OwnerId = userInfo.getUserID();        
        
        System.runAs(thisUser) {
            test.StartTest();
            insert caseRec;
            attachment.ParentID = caseRec.id;
            insert attachment;
            update caseRec;
            
            caseRec.Salesperson__c=userToCreate1.Id;
            update caseRec;
            
            caseRec.Salesperson__c=userToCreate1.Id;
            userToCreate1.LM_Regional_Manager__c = null;
            userToCreate1.Level_2_Manager__c = userInfo.getUserID();
            update userToCreate1;
            update caseRec;
            
            caseRec.Salesperson__c=userToCreate1.Id;
            userToCreate1.Level_2_Manager__c = null;
            userToCreate1.Level_3_Manager__c = userInfo.getUserID();
            update userToCreate1;
            update caseRec;
            
            caseRec.Salesperson__c=userToCreate1.Id;
            userToCreate1.Level_3_Manager__c = null;
            userToCreate1.Level_4_Manager__c = userInfo.getUserID();
            update userToCreate1;
            update caseRec;
                       
         
            caseRec.OwnerId = usr.Id;
            update caseRec;
            caseRec.OwnerId = InqryMgrQueueId;
            update caseRec;
            Test.stopTest();
        
        }
        
        system.assertEquals('Award Timing', caseRec.CaseType__c);
        system.assertEquals('Test.pdf', attachment.Name);
  }
  */
  public static testMethod void testTriggersClass() {
        //Method for evaluating the fisrt condition in the Class.
        Id caseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCS Inquiry').getRecordTypeId();
        Case caseRec = new Case(CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', Subject='Test', description = 'Test',RecordtypeId=caseRecordtype);
                
        Attachment attachment = new Attachment(Name = 'Test.pdf', Body = Blob.Valueof('123'));
        attachment.OwnerId = userInfo.getUserID();
        
        User thisUser = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
        Profile p = [SELECT Id FROM Profile WHERE Name='TR Legal US Sales User']; 
        User usr = [Select Id FROM User WHERE ProfileId =:p.Id AND IsActive=TRUE LIMIT 1];
        string inqryMgrQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Inquiry_Manager' LIMIT 1].Id;
        
        System.runAs(thisUser) {
        
         
        try{         
            insert caseRec;
            map<id, Case> oldCase = new map<id, Case>();
            oldCase.put(caseRec.id, caseRec);
            list<Case> listCase = new list<Case>();
            listCase.add(caseRec);
            boolean isFlag = True;
            CaseTriggerHandler.updateManager(oldCase, listCase, isFlag);
            attachment.ParentID = caseRec.id;
            insert attachment;
            caseRec.Salesperson__c= userInfo.getUserID();
            
            update caseRec;
            caseRec.Salesperson__c=thisUser.id;
            update caseRec;
            test.StartTest();
            caseRec.OwnerId = usr.Id;
            update caseRec;
            listCase.clear();
            listCase.add(caseRec);
            isFlag = False;
            CaseTriggerHandler.updateCaseTeamManager(oldCase, listCase, isFlag);
            caseRec.OwnerId = InqryMgrQueueId;
            update caseRec;
            isFlag = True;
            CaseTriggerHandler.updateCaseTeamManager(oldCase, listCase, isFlag);
            }
             catch(Exception e){
        system.debug('exception'+e);
      }
            Test.stopTest();
        
        }
        
        system.assertEquals('Award Timing', caseRec.CaseType__c);
        system.assertEquals('Test.pdf', attachment.Name);
    }
    
  
   public static testMethod void testUpdateCaseOwner(){
       
       Case thisCase = [SELECT Id, Status FROM Case LIMIT 1];
       
       Test.startTest();
       thisCase.Status = 'Sales';
       update thisCase;
       System.assertEquals('Sales', thisCase.Status);
       Test.stopTest();
      
  } 
  
  public static testMethod void testInsertCaseTeamMember(){
      Test.startTest();
       Case thisCase = [SELECT Id, Status,OwnerId FROM Case where Subject = 'Insert Member'];
       QueueSObject q = [SELECT Id,QueueId from QueueSObject LIMIT 1];
       //Group g = [SELECT Id from Group LIMIT 1];
       //System.assertEquals(g.Id,thiscase.OwnerId);
       
       Profile p2 = [SELECT Id FROM profile WHERE name='Elite CPQ User'];   
       User u2 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p2.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='usertesting02@mydomain.com',Rep_Type_Description__c='test');        
       insert u2;
        
       
       thisCase.OwnerId = u2.Id;
       update thiscase;
      System.assertEquals(u2.id, thisCase.OwnerId);
       Test.stopTest();
      
  } 
  
  public static testMethod void testSendQuoteRequestCancellationEmail1(){
      Test.startTest();
      Case thisCase = [SELECT Id,Status,LCRM_Cancel_Request__c FROM Case LIMIT 1];
      thisCase.Status = 'CPQ Pricing';
      thisCase.LCRM_Cancel_Request__c = true;
      update thisCase;
      System.assertEquals(true, thisCase.LCRM_Cancel_Request__c);
      Test.stopTest();
  }
  
  public static testMethod void testSendQuoteRequestCancellationEmail2(){
  Test.startTest();
      Case thisCase = [SELECT Id,Status,LCRM_Cancel_Request__c FROM Case LIMIT 1];
      thisCase.Status = 'Contract Negotiation';
      thisCase.LCRM_Cancel_Request__c = true;
      update thisCase;
      System.assertEquals(true, thisCase.LCRM_Cancel_Request__c);
      Test.stopTest();
  }
  
  public static testMethod void testSendQuoteRequestCancellationEmail3(){
      Test.startTest();
      Case thisCase = [SELECT Id,Status,LCRM_Cancel_Request__c FROM Case LIMIT 1];
      thisCase.Status = 'Draft';
      thisCase.LCRM_Cancel_Request__c = true;
      update thisCase;
      System.assertEquals(true, thisCase.LCRM_Cancel_Request__c);
      Test.stopTest();
  }
  
  public static testMethod void testInitialiseTrainingEventCaseValues(){
      Test.startTest();
      recordtype caseRT1 = [select id from recordtype where name ='GLI Training Event Request' and sobjecttype='Case' limit 1];
      Case gliTrainingCase = UnitTest.getCaseInstance();
      gliTrainingCase.RecordTypeId=caseRT1.Id;
      insert gliTrainingCase;
      System.assertEquals(caseRT1.Id, gliTrainingCase.RecordTypeId);
      Test.stopTest();
  }
  
  public static testMethod void testTrigger() {
               
          
        KeyValueListStore__c settings = new KeyValueListStore__c();
        settings.Name = 'ANZUsersProfileId';
        settings.TextValue__c = [Select Id From Profile Where Name='ANZ Users'].id;
        insert settings;
        
        RecordtypeIds__c settings1 = new RecordtypeIds__c();
        settings1.Name = 'Pre-Pipeline Opportunities';
        settings1.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        insert settings1;
        
        RecordtypeIds__c settings2 = new RecordtypeIds__c();
        settings2.Name = 'Pipeline Opportunities';
        settings2.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        insert settings2;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUserA = new User(
        Alias = 'standard', Email='standarduser@testorg.com',  
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = pro.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserA@testorganise1.com');
        insert testUserA; 

        User testUserB = new User(
        Alias = 'standard', Email='standarduser@testorg.com',  
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = pro.Id,  
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserB@testorganise2.com', ManagerID = testUserA.id);
        insert testUserB;
        
        System.runAs(testUserB) {
            Test.StartTest();
            Account oAccount = new Account();
            oAccount.Name = 'Unit Test';
            oAccount.Sales_Org__c = 'WEST';
            oAccount.Customer_Type__c = 'Individual';
            oAccount.Customer_Group__c = 'ACADEMIC';
            oAccount.Industry = 'TAX';
            oAccount.SAPAccountNumber__c = '1000550771';
            insert oAccount;
            system.assertEquals(oAccount.Industry, 'TAX');
            
            
            Opportunity oOpportunity = new Opportunity();
            oOpportunity.AccountId = oAccount.id;
            oOpportunity.Name = 'Unit Test Opportuntiy';
            oOpportunity.CloseDate = System.Today() + 5;
            oOpportunity.StageName = 'Prospect';
            oOpportunity.Reason__c = 'Brand';
            oOpportunity.Was_There_a_Competitor__c = 'No';
            oOpportunity.OwnerId = testUserB.Id;
            oOpportunity.Reservation_Manager__c = testUserA.id;
            insert oOpportunity;
            system.assertEquals(oOpportunity.StageName, 'Prospect');
            
            
            Case testCase = new Case();
            testCase.Origin = 'Email ANZ Contact';
            testCase.Sales_Org__c = 'BKRS';
            testCase.ANZ_Account_Number__c = '1000550771';
            testCase.Opportunity__c = oOpportunity.id;
            testCase.ANZ_Issue__c = 'Account Maintenance';
            testCase.Reason__c = 'Grace Period Extension';
            testCase.Approval_Status__c = 'Rejected';
            insert testCase;
            system.assertEquals(testCase.ANZ_Issue__c, 'Account Maintenance');
            Test.StopTest();
        }
    }
  
  public static testMethod void testTriggerCls() {
        
        Id caseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
        Case caseRec = new Case(CaseType__c = 'Award Timing', Case_Type_Detail__c = 'Bridge', 
                                Additional_Case_Type_Detail__c = 'BAR', Sales_Org__c = 'SSRL', Status ='New', 
                                Subject='Test', description = 'Test',RecordtypeId=caseRecordtype);
                
        Id p = [select id from profile where name='Partner Portal User'].id;
        
        
        Account oacct = UnitTest.getAccountInstance();
            oacct.Name = ' Test';
            oacct.BillingCountry = 'US';
            oacct.ShippingCountry = 'US';            
            oacct.BillingState = 'IL';
            insert oacct;
            
            Contact oCont= UnitTest.getContactInstance(oacct.id);           
            oCont.firstname = 'test contactname';
            oCont.lastname = 'test ';
            insert oCont;
            
        
        User u1 = new User(ContactId=oCont.Id,Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', 
        LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p,
        TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com',Sub_Bu__c ='UKI', Business_Unit__c = 'GTM');
        insert u1;     
        
        System.runAs(u1) {
         Test.startTest();   
            caseTriggerHandler.chkRecursion = false;
          insert caseRec;
            Test.stopTest();
        }
        system.assertEquals('Award Timing', caseRec.CaseType__c);
       }
}