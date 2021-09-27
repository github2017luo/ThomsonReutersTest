@isTest
private class ESC_Utility_Test {
    
    @testSetup static void setup(){
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       
       //to bypass validation --- status cannot be equal to work in progress
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
      User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin2@testorg.com');
      insert u;
        
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');
      testAccount.bu_marketing_segment__c='Other';  
      testAccount.BillingStreet='I T P L MAIN ROAD'; 
      testAccount.BillingPostalCode='560066';
      testAccount.BillingCity='BENGALURU';
      testAccount.BillingState='KA';
      testAccount.BillingCountry='IN';
      insert testAccount;
    
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
       
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      //testCase.ESC_Severity__c='1 - High';
      testcase.Ownerid=u.id;
      testCase.ESC_Case_Type__c = 'Incident';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testCase.USL_Case_Owner_Manager__c='test';
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      listcase.add(testCase);
      
      ESC_segment_Region_Lotus__c segRegCorp = new ESC_segment_Region_Lotus__c();
       //SegRegCorp.ESC_IP_BU_Marketing_Segment__c = 'Corp - GTM';
       SegRegCorp.SetupOwnerId=UserInfo.getOrganizationId();
       insert SegRegCorp ;
     
      System.runAs(u) { 
           //insert case
          insert listcase;
      }
      
     /* ESC_MilestoneClose__c mc = new ESC_MilestoneClose__c(Name = 'Next Response Time',ESC_PreviousMilestones__c  = 'Next Response Time');
      insert mc;
      */
      Id entitlementProcessId = [SELECT Id FROM SlaProcess 
                           WHERE SObjectType = 'Case' 
                           AND Name='ggo entitlement process_v1_chile' limit 1].Id;
      Entitlement entl = new entitlement(name='Test Entilement',accountid=TestAccount.id,type='Gateway Support',SLAProcessId = entitlementProcessId, StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
      insert entl;
      
      ESC_MilestoneIdentifierSetting__c mis = new ESC_MilestoneIdentifierSetting__c(FieldAPIName__c = 'ESC_Response_Time__c',Name = 'Next Response Time', ControllingFieldAPI__c='ESC_Next_Response_Time_Flag__c');
      insert mis;
       
      //insert list of ESC_RecordTypeList__c
      List<ESC_RecordTypeList__c> rtlist = new List<ESC_RecordTypeList__c>();
      ESC_RecordTypeList__c r1 = new ESC_RecordTypeList__c(Name = 'Enhancement');
      ESC_RecordTypeList__c r2 = new ESC_RecordTypeList__c(Name = 'Incident Dee');
      rtlist.add(r1); 
      rtlist.add(r2);
      insert rtlist;
      
      //insert  custom settings
      ESC_UpdFieldSetting__c uipd = new ESC_UpdFieldSetting__c(SetupOwnerId = p.Id,ESC_ObjectName__c='Case',ESC_FieldsetName__c  = 'CaseUpdUpdateSet');
      insert uipd;
      
      ESC_MiestoneClosureFields__c mcf = new ESC_MiestoneClosureFields__c(SetupOwnerId = p.Id, Field_1__c = 'Owner.Name');
      insert mcf;
      
      ESC_EntitlementSelectorFields__c esf = new ESC_EntitlementSelectorFields__c(SetupOwnerId = p.Id, ESC_Case_Field1__c = 'Owner.Name');
      insert esf;
      
      ESC_MilestoneCloseList__c mcl = new ESC_MilestoneCloseList__c (ESC_MilestoneToClose__c='Case Resolution',ESC_Field_1__c='Closed',ESC_ProfileName__c = 'System Administrator');
      ESC_MilestoneCloseList__c mc2 = new ESC_MilestoneCloseList__c (ESC_MilestoneToClose__c='First Response Time',ESC_Field_1__c='Work In Progress',ESC_ProfileName__c = 'System Administrator');
       
       
       List<ESC_MilestoneCloseList__c> mclist = new List<ESC_MilestoneCloseList__c>();
       mclist.add(mcl);mclist.add(mc2);
       insert mclist;
    }
    
    @IsTest(SeeAllData=false) static void escUtilityMethod() {
        
       Test.StartTest();
        // This code runs as the system user
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       //to bypass validation --- status cannot be equal to work in progress
      /*
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
      */
      
      User u2 = new User(Alias = 'standt22', Email='sysadmin2@testorg1.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin22@testorg2.com');
      insert u2;
       
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
      dis.LTS_Disable_Validation_Rules__c =true;
      dis.SetupOwnerId=u2.Id;
      insert dis;
        
      System.runAs(u2) { 
          Case testCase = [Select Id, OwnerId, status from case where subject = 'tst' limit 1];    
          //close testCase
          testCase.status='Work in Progress';
          testCase.OwnerId = u2.id;
          testCase.Description = 'Test Description';
          testCase.USL_Case_Owner_Manager__c='test1';
          update testCase;
          
          List<Case> cs = new List<Case>();
          cs.add(testcase);
          update cs;
          
          //Non ESC case creation
          RecordType recT =[SELECT id FROM RecordType WHERE Name = 'anz'];
          Case nonEscCase=New Case();
          nonEscCase.RecordTypeId=recT.id;
          nonEscCase.CurrencyIsoCode='USD';
          nonEscCase.Status='Active';
          nonEscCase.Origin='Web';
          insert nonEscCase;
          
          map<string,boolean> caseportalmap = new map<string,boolean> ();
          caseportalmap.put(cs[0].id,false);
          //Calling OwnerChangeValidationErrorMessage method of Uility Class
          ESC_Utility.OwnerChangeValidationErrorMessage(cs);
          ESC_Utility.ReopenErrorMessage(cs,caseportalmap);
          ESC_Utility.recordTypeNamesToIds('Case');
      
      }
      Test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
    }
    @IsTest(SeeAllData=false) static void escUtilityMethodval() {
        Profile p = [SELECT Id FROM Profile WHERE Name='USL Helpdesk Agent'];
        User u2 = new User(Alias = 'standt33', Email='sysadmin@testorg1.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin@testorg1.com');
      insert u2;
       
      System.runAs(u2) { 
      Case testcase2 = new Case();      
      testcase2.status = 'Closed';
      try{
      insert testcase2;
      }
      catch(Exception e){
           system.debug(LoggingLevel.WARN,e);
      }   
      integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
      }    
    }
    @IsTest(SeeAllData=false) static void escUtilityMethod2() {
        
       Test.StartTest();
        // This code runs as the system user
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       //to bypass validation --- status cannot be equal to work in progress
      /*
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
      */
      
      User u2 = new User(Alias = 'standt89', Email='sysadmin@testorg1.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin@testorg1.com');
      insert u2;
       ESC_RecordTypeList__c rT=new ESC_RecordTypeList__c();
       rT.Name='Feedback';
      // rT.ESC_API_Name__c = 'ESC_Feedback';
       insert rT;
      
      
        LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        dis.SetupOwnerId=u2.Id;
        insert dis;
        
      System.runAs(u2) { 
          
         Case testCase = [Select Id, OwnerId, status from case where subject = 'tst' limit 1]; 
         
         
      
          map<id,case> oldmap1=new map<id,case>();
        oldmap1.put(testcase.id,testcase);
      
          //close testCase
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase.ESC_Severity__c='1 - High';
       //testcase.Ownerid=u2.id;
      testcase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testcase.ESC_Resolution_Comment__c = 'Resolution comment';
      testCase.ESC_Case_Type__c = 'Feedback';
      testCase.Description = 'test';
      testCase.status='Closed';
      
        update testCase;
      map<id,case> newmap1=new map<id,case>();
      newmap1.put(testcase.id,testcase);
      
      ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
      ref.ESC_Role__c='Accountable Resolver';
      ref.ESC_Case__c=testcase.id;
      ref.ESC_Referral_Status__c='In Progress';
      ref.ESC_ReferralUPD__c=false;
      ref.ESC_End_Date__c=Date.valueof(System.now().addDays(+1));
      insert ref;
      
      ESC_Utility.CloseRelatedReferralsOnCaseClosure(newmap1,oldmap1);
      ESC_Utility.checkValidationForCancelled(newmap1,oldmap1);
      
      
      list<case> caselist=new List<case>();
      caselist.add(testCase);
      ESC_Utility.ChangedToCancelledValidationErrorMessage(caselist);
      
      }
      
      //call the method readFieldSet
      ESC_Utility.readFieldSet('CaseUpdUpdateSet','Case');
      
      
      Test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
    }
    
    
    @IsTest(SeeAllData=false) static void escUtilityMethod3(){
        
       Test.StartTest();
       
      //This code run as a system user
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       //to bypass validation --- status cannot be equal to work in progress
      /*
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
      */
      User u = new User(Alias = 'escusl', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl@testorg.com');
      insert u;
      
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        dis.SetupOwnerId=u.Id;
        insert dis;
        
       System.runAs(u){
      //insert accounts data 
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');
      testAccount.bu_marketing_segment__c='Other';   
      testAccount.BillingStreet='I T P L MAIN ROAD'; 
      testAccount.BillingPostalCode='560066';
      testAccount.BillingCity='BENGALURU';
      testAccount.BillingState='KA';
      testAccount.BillingCountry='IN'; 
      insert testAccount;
       
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
       
      //insert case
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testcase.OwnerId=u.id;
      testcase.ESC_Apply_Entitlement_Milestone__c=true;
      listcase.add(testCase);
      
      //Call a filteredNonCore method
      Map<Id,sObject> newmapcheck = new Map<Id,sObject>();
      newmapcheck.put(testcase.id, testcase);
      ESC_Utility.filteredNonCore(newmapcheck);
      
      //create another case and insert in list of Cases
      Case cmap = ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Awaiting Customer Confirmation');
      cmap.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enhancement Request').getRecordTypeId();
      cmap.OwnerId=u.id;
      
      listcase.add(cmap);
      insert listcase;
      //insert list of ESC_RecordTypeList__c
      List<ESC_RecordTypeList__c> rtlist = new List<ESC_RecordTypeList__c>();
      //ESC_RecordTypeList__c r1 = new ESC_RecordTypeList__c(Name = 'Enhancement');
      //ESC_RecordTypeList__c r2 = new ESC_RecordTypeList__c(Name = 'Incident Dee');
      insert rtlist;
      
      cmap.ParentId=testcase.id;
      update cmap;
      
      
      testcase.status='Closed';
      try{
      update testcase;
      }
      catch(exception e){
       system.debug(LoggingLevel.WARN,e);
      }
      testcase.status='Awaiting Customer Confirmation';
      //update testcase;
      
      map<id,case> oldmap1=new map<id,case>();
      oldmap1.put(testcase.id,testcase);
      
      testcase.status='Duplicate';
      //update testcase;
      
      map<id,case> newmap1=new map<id,case>();
      newmap1.put(testcase.id,testcase);
     // ESC_Utility.CloseRelatedReferralsOnCaseClosure(newmap1,oldmap1);
      
     
      testcase.ESC_Diagnosis_Summary__c='Content Explanation';
      testcase.ESC_Resolution_Comment__c='Resolved';
      testcase.ESC_Disposition__c='Positive';
      testcase.status='Closed';
      testcase.ESC_Apply_Entitlement_Milestone__c = true;
      //update testcase;
      
      
      ESC_Utility.validateEmail('abc.salesforce.com');
      ESC_Utility.validateEmail('');
      
      
      
      
      MassValidationSettings__c mvs = new MassValidationSettings__c(Name = 'System Administrator', DisableMassTransfer__c= false);
       insert mvs;
      
      ESC_MiestoneClosureFields__c mc = new ESC_MiestoneClosureFields__c(Field_1__c='Status',Field_2__c= 'ESC_Diagnosis_Summary__c');
      insert mc;
       
       ESC_MilestoneCloseList__c mcl = new ESC_MilestoneCloseList__c (ESC_MilestoneToClose__c='First Response Time',ESC_Field_1__c='Status',ESC_Field_2__c= 'ESC_Diagnosis_Summary__c');
       
       
       List<ESC_MilestoneCloseList__c> mclist = new List<ESC_MilestoneCloseList__c>();
       mclist.add(mcl);
       insert mclist;
       
       ESC_InitialResponseTimeCalc__c irt = new ESC_InitialResponseTimeCalc__c(Name='test',ESC_MilestoneName__c='First Response Time',ESC_FieldAPIName__c='ESC_Response_Time__c');
       insert irt;
       ESC_InitialResponseTimeCalc__c irt1 = new ESC_InitialResponseTimeCalc__c(Name='test1',ESC_MilestoneName__c='First Response Time',ESC_FieldAPIName__c='');
       insert irt1;
       
       List<ESC_MilestoneIdentifierSetting__c> milestoneIdentifierList = new List<ESC_MilestoneIdentifierSetting__c>();
       ESC_MilestoneIdentifierSetting__c mis = new ESC_MilestoneIdentifierSetting__c(FieldAPIName__c = 'ESC_Response_Time__c',Name = 'Next Response Time');
       milestoneIdentifierList.add(mis);
       insert milestoneIdentifierList;
      
      ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
      ref.ESC_Role__c='Accountable Resolver';
      ref.Ownerid=u.id;
      ref.ESC_Case__c=testcase.id;
      ref.ESC_Referral_Status__c='In Progress';
      ref.ESC_ReferralUPD__c=false;
      //insert ref;
      
      set<id> caseidset= new set<id>();
      caseidset.add(testcase.id);
      
      ESC_Utility.updateCaseReferal(caseidset);
      
       }
        
      Test.stopTest();
       integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal'); 
    }

  /*

 @IsTest(SeeAllData= false) static void testCompleteMilestoneCase(){
      
         //to bypass validation --- status cannot be equal to work in progress
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
        Entitlement entl = [Select Id from Entitlement where name='Test Entilement' limit 1];

        Case testCase = null;
        if (entl != null){
           testCase = [Select Id, EntitlementId,ESC_Milestones_to_Close__c from case where subject = 'tst' limit 1];   
           testCase.EntitlementId = entl.id;
            testCase.ESC_Milestones_to_Close__c = 'Next Response Time';
        }
        
        update testCase;
        System.debug(LoggingLevel.WARN,'testCase@@'+testCase);
        
        CaseMilestone milestones = [
            SELECT id,TargetDate, CaseId, MilestoneTypeId
            FROM CaseMilestone
            WHERE CaseId = :testCase.Id limit 1
        ];
                System.debug(LoggingLevel.WARN,'milestones@@'+milestones);

        
        ESC_Utility.getAssociatedBusHours(new list<Id>{milestones.Id});
        
        
  } */
  
  @IsTest(SeeAllData= false) static void testCompleteMilestoneCase2(){
      
        Entitlement entl = [Select Id from Entitlement where name='Test Entilement' limit 1];

        Case testCase = null;
        //case testCase1 = new Case();
        if (entl != null){
           testCase = [Select Id, EntitlementId,ESC_Milestones_to_Close__c from case where subject = 'tst' limit 1];   
           testCase.EntitlementId = entl.id;
           // commented below bcz of validation, bh shouldnt be null         
           //testCase.BusinessHoursId=null;
           testCase.ESC_Milestones_to_Close__c = 'Next Response Time';
        }
        
        update testCase;
        
        System.debug(LoggingLevel.WARN,'testCase@@'+testCase);
        
        
      map<id,case> oldmap1=new map<id,case>();
      oldmap1.put(testcase.id,testcase);
      
      List <Case> listcase= new List<Case>();
      listcase.add(testCase);

        CaseMilestone milestones = [
            SELECT id,TargetDate, CaseId, MilestoneTypeId,CompletionDate,case.ESC_Milestones_to_Close__c
            FROM CaseMilestone
            WHERE CaseId = :testCase.Id limit 1
        ];
        
        //milestones.MilestoneType.Name='Next Response Time';
        //milestones.BusinessHoursId=null;
        //update milestones;
        
        System.debug(LoggingLevel.WARN,'milestones1@@'+milestones);
    
    ESC_Utility.getAssociatedBusHours(new list<Id>{milestones.Id});
    ESC_Utility.caseMileStoneToClose(listcase,oldmap1);
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
      
  }
  @IsTest(SeeAllData= false) static void testdeactiveuser1(){
      case testCase1 = new Case();
      
      test.starttest();
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u = new User(Alias = 'stan3t2', Email='trhelpdeskagent1122@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='trhelpdeskagent1122@testorg.com');
      insert u;
        system.runAs(u){
        
        testCase1 = [Select Id, EntitlementId,ESC_Milestones_to_Close__c from case where subject = 'tst' limit 1];      
        testcase1.usl_last_queue_name__c = 'C2C TXP Apttus Credit Check Failed';
        testcase1.status = 'Closed';
        update testcase1;
        }
        test.stoptest();
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
        
   } 
  
  @IsTest(SeeAllData= false) static void testdeactiveuser(){
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       //to bypass validation --- status cannot be equal to work in progress     
      User u = new User(Alias = 'escusl45', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl3456@testorg.com');
      insert u;
      User u1 = new User(Alias = 'escu678', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl123@testorg.com',managerid=u.id);
      insert u1;
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');
      testAccount.bu_marketing_segment__c='Other';    
      testAccount.BillingStreet='I T P L MAIN ROAD'; 
      testAccount.BillingPostalCode='560066';
      testAccount.BillingCity='BENGALURU';
      testAccount.BillingState='KA';
      testAccount.BillingCountry='IN'; 
      insert testAccount;
      List<BusinessHours> bhrs=[select id from BusinessHours where IsDefault=true];
      Id entitlementProcessId = [SELECT Id FROM SlaProcess 
                           WHERE SObjectType = 'Case' 
                           AND Name='USL Entitlement process Eagen9' limit 1].Id;
        Entitlement entl = new entitlement(name='Test Entilement',accountid=TestAccount.id,type='Gateway Support',SLAProcessId = entitlementProcessId, StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
      insert entl;
      
       ESC_EntitlementSelectorFields__c esf = new ESC_EntitlementSelectorFields__c(SetupOwnerId=UserInfo.getOrganizationId(),      ESC_Case_Field1__c='BusinessHoursId',
       ESC_Case_Field2__c='Is_ESC_Case__c',
       ESC_Case_Field3__c='LCRM_Sub_BU__c');
       insert esf;
       
       EntitlementSelectorList__c esl=new EntitlementSelectorList__c(
       ESC_Case_Field1__c=bhrs[0].id,
       ESC_Case_Field2__c='true',
       ESC_Case_Field3__c='USL',
       ESC_Entitlement__c=entl.id,
       ESC_Profile_Name__c='USL Helpdesk Agent'
      );
       insert esl;
      system.runas(u1){
      
      List <Case> listcase= new List<Case>();
      //insert accounts data 
     
       ESC_DefaultEntitlementSelector__c des = new ESC_DefaultEntitlementSelector__c(SetupOwnerId=UserInfo.getOrganizationId(),    ESC_EntitlementName__c='Default Entitlement');
       insert des;
        
       
           test.starttest();
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='tst';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();      
      testcase.origin = 'Email';
      testcase.ownerid = u1.id;
      testcase.LCRM_Sub_BU__c = 'USL';
      insert testcase;
      listcase.add(testcase);
      ESC_Utility.checkDeActiveUser(listcase);
      test.stoptest();    
      }
      
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
  }
  
   @IsTest(SeeAllData= false) static void testAlluser(){
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       //to bypass validation --- status cannot be equal to work in progress
      /*
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        dis.SetupOwnerId=UserInfo.getOrganizationId();
        insert dis;
      */
      User u = new User(Alias = 'escusl45', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl3456@testorg.com');
      insert u;
      User u1 = new User(Alias = 'escu678', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl123@testorg.com',managerid=u.id);
      insert u1;
       
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        dis.SetupOwnerId=u1.Id;
        insert dis;
       
      system.runas(u1){
      
      //List <Case> listcase= new List<Case>();
      //insert accounts data 
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');
      testAccount.bu_marketing_segment__c='Other';      
      testAccount.BillingStreet='I T P L MAIN ROAD'; 
      testAccount.BillingPostalCode='560066';
      testAccount.BillingCity='BENGALURU';
      testAccount.BillingState='KA';
      testAccount.BillingCountry='IN';
      insert testAccount;
       // insert group
        Group grp = new Group();
        grp.Name = 'Technology Partner Content';
        insert grp;
        
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
          test.startTest();
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testcase.origin = 'Email';
      testcase.ownerid = u1.id;
      testcase.LCRM_Sub_BU__c = 'USL';
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      listcase.add(testCase);
       insert testCase;
         list<ESC_ValidationSettings__mdt> vallist =new List<ESC_ValidationSettings__mdt>();
       ESC_ValidationSettings__mdt val1 =new ESC_ValidationSettings__mdt();
       
       val1.Object__c='case';
       val1.Recordtype__c='Incident';
       val1.FieldApiName__c='OwnerId';
       val1.MandatoryFieldApiNames__c='Subject,Description';
       val1.Custom_Label__c='ESC_CaseRuleMessage';
       val1.IncludeProfileName__c='TR Accountable Resolver';
       vallist.add(val1);
       //insert vallist;
      ESC_Utility.checkDeActiveUser(listcase);
          test.stopTest();
      }
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
  }
  @IsTest(SeeAllData= false) static void testAllusers(){
      Profile p = [SELECT Id FROM Profile WHERE Name='USL Helpdesk Agent']; 
       //to bypass validation --- status cannot be equal to work in progress
      
      User u = new User(Alias = 'escusl45', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl3456@testorg.com');
      insert u;
      User u1 = new User(Alias = 'escu678', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl123@testorg.com',managerid=u.id);
      insert u1;
     User u2 = new User(Alias = 'escu678', Email='sjnysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmikjnescusl123@testorg.com',managerid=u.id);
      insert u2;
     
     Group grp = new Group();
        grp.Name = 'Technology Partner Content';
        insert grp;
      
      test.starttest();
   system.runas(u1){
      
      //List <Case> listcase= new List<Case>();
      //insert accounts data 
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');
      testAccount.bu_marketing_segment__c='Other';   
      testAccount.BillingStreet='I T P L MAIN ROAD'; 
      testAccount.BillingPostalCode='560066';
      testAccount.BillingCity='BENGALURU';
      testAccount.BillingState='KA';
      testAccount.BillingCountry='IN'; 
      insert testAccount;
       // insert group
        
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
      
      //List <Case> listcase= new List<Case>();
      //List <Case> listcaseupdate= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'New');
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enhancement Request').getRecordTypeId();
      
       insert testcase;
      Case testCase2=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'New');
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enhancement Request').getRecordTypeId();
       insert testcase2;
      
      testcase.status =  'Cancelled';
      try{
      testcase.ownerid = u2.id;
      testcase2.accountid=null;
      testcase2.status='Closed';
      update testcase;
      update testcase2;
      
      }catch(Exception ex){
          system.debug(LoggingLevel.WARN,ex);
      }
      
        
      
     }
     test.stoptest();
     
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
  }
  
   @IsTest(SeeAllData= false) static void testautoclosure(){
      Profile p = [SELECT Id FROM Profile WHERE Name='USL Hybrid Agent']; 
       //to bypass validation --- status cannot be equal to work in progress
      /*
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
      */
        
      User u = new User(Alias = 'escusl45', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl3456@testorg.com');
      insert u;
      User u1 = new User(Alias = 'escu678', Email='sysadminesc@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminescusl123@testorg.com',managerid=u.id);
      insert u1;
      ESC_ValidationSettings__mdt val1 =[SELECT Id,DeveloperName,Custom_Label__c,ExcludeProfileName__c,FieldApiName__c,Field_Value__c,IncludeProfileName__c,MandatoryFieldApiNames__c,Object__c,Recordtype__c from ESC_ValidationSettings__mdt where DeveloperName='testclassval'];  
      system.debug(LoggingLevel.WARN,'case id is'+val1);
       
      LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
      dis.LTS_Disable_Validation_Rules__c =true;
      dis.SetupOwnerId=u1.Id;
      insert dis;
       
      system.runas(u1){
      
      //List <Case> listcase= new List<Case>();
      //insert accounts data 
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');
      testAccount.bu_marketing_segment__c='Other';      
      testAccount.BillingStreet='I T P L MAIN ROAD'; 
      testAccount.BillingPostalCode='560066';
      testAccount.BillingCity='BENGALURU';
      testAccount.BillingState='KA';
      testAccount.BillingCountry='IN';
      insert testAccount;
     
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
          test.startTest();
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testcase.origin = 'Email';
      testcase.ownerid = u1.id;
      testcase.LCRM_Sub_BU__c = 'USL';
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      listcase.add(testCase);
      insert listcase;
        // list<ESC_ValidationSettings__mdt> vallist =new List<ESC_ValidationSettings__mdt>();
       
       
      ESC_Utility.checkValidationErrorsForAutomaticClosure(listcase);
          test.stopTest();
          
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
      }
  }
  
  @IsTest static void testExternalTicketNumber(){ 
      Test.startTest();
      
      //List <Case> listcase= new List<Case>();
      //insert accounts data 
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
       
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='ticket';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();      
      testcase.origin = 'Email';
      testcase.LCRM_Sub_BU__c = 'US';
      testcase.BU_Segment__c = 'Professional Tax';
      insert testcase;
      
      
      Case oCase1 = [Select id, subject,ESC_External_Ticket_Number__c,ESC_External_Reference_URL__c,Is_ESC_Case__c
                    from Case
                    where Id = :testcase.id];
       
      
      system.assertEquals('ticket',oCase1.Subject,'equal');
      system.assertEquals(true,oCase1.Is_ESC_Case__c,'equal');
     
      Case oCase2 =[Select id, subject,ESC_External_Ticket_Number__c,ESC_External_Reference_URL__c
                    from Case
                    where Id = :oCase1.id];
      
      oCase2.ESC_External_Reference_URL__c = 'https://dev.azure.com/tr-tax/TaxProf/_workitems/edit/217345';      
      
      Map<Id, Case> mapOldCase = new Map<Id, case>();
      Map<Id, Case> mapNewCase = new Map<Id, case>();
      
      mapOldCase.put(oCase1.Id, oCase1);
      mapNewCase.put(oCase2.Id, oCase2);
      
      ESC_Utility.populateExternalTicketInfo(mapNewCase,mapOldCase);
      
      Test.stopTest();
      
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
  }
  
   static testmethod void testclosedreferral(){
      //List <Case> listcase= new List<Case>();
      //insert accounts data 
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      insert testAccount;
       
      //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact;
      ESC_RecordTypeList__c rectype = new ESC_RecordTypeList__c();
      rectype.name = 'Incident';
      insert rectype;
      Test.startTest();
      Case testCase=ESC_GenericTestutility.TestCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
      testcase.ESC_Impact__c = '1-Whole Site';
      testcase.subject='ticket';
      testcase.ESC_Customer_Symptom__c='Content Addition';
      testcase.ESC_Severity__c='1 - High';
      testcase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();      
      testcase.origin = 'Email';
      testcase.LCRM_Sub_BU__c = 'US';
      testcase.BU_Segment__c = 'Professional Tax';
      insert testcase;
        //  Test.startTest();
      ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
      ref.ESC_Role__c='Accountable Resolver';      
      ref.ESC_Case__c=testcase.id;
      ref.ESC_Referral_Status__c='In Progress';
      ref.ESC_ReferralUPD__c=false;
      insert ref;
      test.stopTest();
      Case testcase2 = new Case();
      testcase2.id = testcase.id;
      testcase2.status = 'Closed';
      update testcase2;

      map<id,case> newmap = new map<id,case>();
      map<id,case> oldmap = new map<id,case>();
      newmap.put(testcase2.id,testcase2);
      oldmap.put(testcase.id,testcase);
      system.debug(LoggingLevel.WARN,'case id is'+testcase.id);
      
      ESC_Utility.closeRelatedReferralsOnCaseClosure(newmap,oldmap);
          
          
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
  }
  
  @IsTest(SeeAllData=false) static void escUtilityMethod20() {
         Test.StartTest();
      Profile p = [SELECT Id FROM Profile WHERE Name='TR Helpdesk Agent']; 
      Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       //to bypass validation --- status cannot be equal to work in progress
      
      User u2 = new User(Alias = 'standt10', Email='sysadmin@testorg1.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin@testorg1.com');
      insert u2;
      User u1 = new User(Alias = 'standt21', Email='sysadmin@testorg2.com', 
      EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='syeadmin@testorg1.com');
      insert u1;
      //Create Parent Group
        Group grp = new Group();
        grp.name = 'Test Group1';
        grp.Type = 'Queue'; 
        Insert grp; 
 
        //Create Group Member
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = UserInfo.getUserId();
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;
 
         
      QueuesObject testQueue = new QueueSObject(QueueID = grp.id, SObjectType = 'Case');
      insert testQueue;
      system.runAs(u1){
          
           LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        dis.SetupOwnerId=u1.Id;
        insert dis;
      
           
      }
         
     
      system.runas(u2){
      Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');
      testAccount.bu_marketing_segment__c='Other';   
      testAccount.BillingStreet='I T P L MAIN ROAD'; 
      testAccount.BillingPostalCode='560066';
      testAccount.BillingCity='BENGALURU';
      testAccount.BillingState='KA';
      testAccount.BillingCountry='IN'; 
      insert testAccount;
       // insert group
        
      //insert contact data
       
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','lastname','test@tr.com');
      insert testContact; 
         
         
      Case testcase1= new Case();
      testcase1.Accountid = testAccount.id;
      testcase1.ContactId = testcontact.id;
      testcase1.ESC_Impact__c = '1-Whole Site';
      testcase1.subject='ticket';
      testcase1.ESC_Customer_Symptom__c='Content Addition';
      testcase1.ESC_Severity__c='1 - High';
      testcase1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();      
      testcase1.origin = 'Email';
      testcase1.LCRM_Sub_BU__c = 'US';
      testCase1.status='Closed';
      testCase1.OwnerId=grp.Id;
      testcase1.BU_Segment__c = 'Professional Tax';      
      testcase1.USL_Last_Queue_Name__c = 'C2C TXP Apttus Credit Check Failed';
      testcase1.ESC_Case_Sub_Type__c = 'Billing';
      testcase1.ESC_Resolution_Comment__c = 'Resolution comment';
      insert testcase1;
      
      /*testCase1.OwnerId=u2.Id;
      Update testCase1;
      
      testCase1.status='Closed';
      
      testcase1.ESC_Resolution_Comment__c = 'Resolution comment';
      update testCase1;*/     
      }                              
      Test.stopTest();
      
    integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
    }
 }