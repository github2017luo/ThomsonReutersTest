@isTest
public class LOTUSChildObjSegmentUpdate_Test{
    @isTest
    public static void testAccountWithOpportunity() {
        List<Id> accountIdList = new List<Id>();
        List<Account> accList = new List<Account>();
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
        KeyValueListStore__c kValue1 = new KeyValueListStore__c();
        kValue1.Name ='ANZUsersProfileId';
      
        KeyValueListStore__c kValue2 = new KeyValueListStore__c();
        kValue2.Name ='ReasonWithCompetitor';
        kValue2.TextValue__c = 'Content';
        
        KeyValueListStore__c kValue3 = new KeyValueListStore__c(); 
        kValue3.Name ='LTS_BURegion_Values';
        kValue3.TextValue__c = 'US,Canada';
        kValueLst.add(kValue1);
        kValueLst.add(kValue2);
        kValueLst.add(kValue3);
        insert kValueLst;
        Id pipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Id prePipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
            
          List<RecordtypeIds__c> recTypLst = new List<RecordtypeIds__c>();
            RecordtypeIds__c recTyp1 = new RecordtypeIds__c();
            recTyp1.Name = 'Pipeline Opportunities';
            recTyp1.recTypeId__c = pipeLinerecTypId;
            
            RecordtypeIds__c recTyp2 = new RecordtypeIds__c();
            recTyp2.Name = 'Pre-Pipeline Opportunities';
            recTyp2.recTypeId__c = prePipeLinerecTypId;
            
            recTypLst.add(recTyp1);
            recTypLst.add(recTyp2);
            insert recTypLst;
      
    
        Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.Name = 'TESTACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BU_Segment__c ='Corporate';
            acc.BU_Region__c = 'US';
            accList.add(acc);
           
            
            if(accList.size()>0)
            insert accList;
           accountIdList.add(accList[0].Id);
        List<Opportunity> opportunitytestlist = new List<Opportunity>();
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=new Opportunity();
        oppty.Name='TEST OPP';
        oppty.RecordtypeId=opptyRecorType;
        oppty.StageName ='Need Analysis';
        oppty.AccountId=accList[0].id;
        oppty.CloseDate = Date.Today() + 90;
        oppty.LCRM_Sub_BU__c ='Canada';
        oppty.BU_Segment__c ='Corporate';
        oppty.Is_GLI__c =TRUE;
        
       
        opportunitytestlist.add(oppty);
        
        Opportunity oppty1=new Opportunity();
        oppty1.Name='TEST OPP1';
        oppty1.RecordtypeId=opptyRecorType;
        oppty1.StageName ='Need Analysis';
        oppty1.AccountId=accList[0].id;
        oppty1.CloseDate = Date.Today() + 90;
        oppty1.LCRM_Sub_BU__c ='US';
        oppty1.BU_Segment__c ='Corporate';
        oppty.Is_GLI__c =true;
        opportunitytestlist.add(oppty1);
    
        if(opportunitytestlist.size()>0)
        insert opportunitytestlist ;
        
        List<Task> taskList= new List<Task>();
        List<Event> eventList= new List<Event>();
        for(Opportunity opp : opportunitytestlist){
            System.debug('LASTMODIFIEDDATE** '+opp.lastmodifieddate);
            Task taskIns = new Task();
            taskIns.WhatId = opp.id;
            taskIns.LCRM_Sub_BU__c = 'US';
            taskIns.BU_Segment__c ='Coporate'; 
            taskList.add(taskIns);
            
            Event eventIns = new Event();
            eventIns.WhatId = opp.Id;
            eventIns.LCRM_Sub_BU__c ='Canada';
            eventIns.BU_Segment__c ='Corporate';
            eventIns.ActivityDateTime = system.today();
            eventIns.DurationInMinutes = 120;
      
            eventList.add(eventIns);
        }
        if(taskList.size()> 0 && eventList.size() > 0 ){
            insert taskList;
            insert eventList;
            
        }
        Id leadRt= Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        List<Lead> LeadList = new List<Lead>();
        Lead TestLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.LCRM_Sub_BU__c='US';
         TestLead1.BU_Segment__c='Corporate';
         TestLead1.Is_GLI__c = true;
         TestLead1.Account__c =accList[0].Id;
     
        Lead ld = new Lead(FirstName ='Test',LastName='Lead',Company='Test',Is_GLI__c=true,RecordTypeId=leadRt);
    
        LeadList.add(TestLead1);
        LeadList.add(ld);
    
    if(LeadList.size() > 0)
        insert LeadList;
    
        
        List<XREFAccountSegment__c> accountSegmentList = new List<XREFAccountSegment__c>();
        XREFAccountSegment__c xrefaccSeg= new XREFAccountSegment__c();
        xrefaccSeg.Name ='XREFACCSEG';
        xrefaccSeg.BU_Segment__c =accList[0].BU_Segment__c;
        xrefaccseg.Is_Processed_Activity__c =false;
        accountSegmentList.add(xrefaccSeg);
        insert accountSegmentList;
    
        List<Account> updateAcc = new List<Account>();
        List<Account> ListofAccount = new List<Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT' AND BU_Segment__c ='Corporate' AND BU_Region__c ='US' LIMIT 1]);
        for(Account a:ListofAccount)
        {
            if(a.BU_Segment__c =='Corporate')
            a.BU_Segment__c ='Professional Tax';
         updateAcc.add(a);
        
        }
        Test.StartTest();
        update updateAcc;
      
        LOTUSChildObjSegmentUpdateInvocableClass.getAccountInfo(accountIdList);
        Test.StopTest();
         
    }
    public static void testAccountWithoutOpportunity() {
        List<Id> accountIdList = new List<Id>();
        List<Account> accList = new List<Account>();
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
        KeyValueListStore__c kValue1 = new KeyValueListStore__c();
        kValue1.Name ='ANZUsersProfileId';
      
        KeyValueListStore__c kValue2 = new KeyValueListStore__c();
        kValue2.Name ='ReasonWithCompetitor';
        kValue2.TextValue__c = 'Content';
        
        KeyValueListStore__c kValue3 = new KeyValueListStore__c(); 
        kValue3.Name ='LTS_BURegion_Values';
        kValue3.TextValue__c = 'US,Canada';
        kValueLst.add(kValue1);
        kValueLst.add(kValue2);
        kValueLst.add(kValue3);
        insert kValueLst;
        Id pipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Id prePipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
            
          List<RecordtypeIds__c> recTypLst = new List<RecordtypeIds__c>();
            RecordtypeIds__c recTyp1 = new RecordtypeIds__c();
            recTyp1.Name = 'Pipeline Opportunities';
            recTyp1.recTypeId__c = pipeLinerecTypId;
            
            RecordtypeIds__c recTyp2 = new RecordtypeIds__c();
            recTyp2.Name = 'Pre-Pipeline Opportunities';
            recTyp2.recTypeId__c = prePipeLinerecTypId;
            
            recTypLst.add(recTyp1);
            recTypLst.add(recTyp2);
            insert recTypLst;
      
    
        Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.Name = 'TESTACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BU_Segment__c ='Corporate';
            acc.BU_Region__c = 'US';
            accList.add(acc);
           
            
            if(accList.size()>0)
            insert accList;
           accountIdList.add(accList[0].Id);
        List<Opportunity> opportunitytestlist = new List<Opportunity>();
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=new Opportunity();
        oppty.Name='TEST OPP';
        oppty.RecordtypeId=opptyRecorType;
        oppty.StageName ='Need Analysis';
        oppty.AccountId=accList[0].id;
        oppty.CloseDate = Date.Today() + 90;
        //oppty.LCRM_Sub_BU__c ='Canada';
        //oppty.BU_Segment__c ='Corporate';
        oppty.Is_GLI__c =false;
        
       
        opportunitytestlist.add(oppty);
        
    
        if(opportunitytestlist.size()>0)
        insert opportunitytestlist ;
        
        List<Task> taskList= new List<Task>();
        List<Event> eventList= new List<Event>();
        for(Opportunity opp : opportunitytestlist){
            System.debug('LASTMODIFIEDDATE** '+opp.lastmodifieddate);
            Task taskIns = new Task();
            taskIns.WhatId = opp.id;
            taskIns.LCRM_Sub_BU__c = 'US';
            taskIns.BU_Segment__c ='Coporate'; 
            taskList.add(taskIns);
            
            Event eventIns = new Event();
            eventIns.WhatId = opp.Id;
            eventIns.LCRM_Sub_BU__c ='Canada';
            eventIns.BU_Segment__c ='Corporate';
            eventIns.ActivityDateTime = system.today();
            eventIns.DurationInMinutes = 120;
      
            eventList.add(eventIns);
        }
        if(taskList.size()> 0 && eventList.size() > 0 ){
            insert taskList;
            insert eventList;
            
        }
        Id leadRt= Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        List<Lead> LeadList = new List<Lead>();
        Lead TestLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.Is_GLI__c = false;
         TestLead1.Account__c =accList[0].Id;
     
        Lead ld = new Lead(FirstName ='Test',LastName='Lead',Company='Test',Is_GLI__c=false,RecordTypeId=leadRt);
    
        LeadList.add(TestLead1);
        LeadList.add(ld);
    
    if(LeadList.size() > 0)
        insert LeadList;
    
        
        
    
        List<Account> updateAcc = new List<Account>();
        List<Account> ListofAccount = new List<Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT' AND BU_Segment__c ='Corporate' AND BU_Region__c ='US' LIMIT 1]);
        for(Account a:ListofAccount)
        {
            if(a.BU_Segment__c =='Corporate')
            a.BU_Segment__c ='Professional Tax';
         updateAcc.add(a);
        
        }
        Test.StartTest();
        update updateAcc;
        LOTUSChildObjSegmentUpdateInvocableClass.getAccountInfo(accountIdList);
        Test.StopTest();
         
    }
  @isTest static void testChildObjects()
  {  
    List<Account>accList = new List<Account>();
    List<Id> accId = new List<Id>();
    List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
        KeyValueListStore__c kValue1 = new KeyValueListStore__c();
        kValue1.Name ='ANZUsersProfileId';
      
        KeyValueListStore__c kValue2 = new KeyValueListStore__c();
        kValue2.Name ='ReasonWithCompetitor';
        kValue2.TextValue__c = 'Content';
        
        KeyValueListStore__c kValue3 = new KeyValueListStore__c(); 
        kValue3.Name ='LTS_BURegion_Values';
        kValue3.TextValue__c = 'US,Canada';
        kValueLst.add(kValue1);
        kValueLst.add(kValue2);
        kValueLst.add(kValue3);
        insert kValueLst;
        Id pipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Id prePipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
            
        List<RecordtypeIds__c> recTypLst = new List<RecordtypeIds__c>();
            RecordtypeIds__c recTyp1 = new RecordtypeIds__c();
            recTyp1.Name = 'Pipeline Opportunities';
            recTyp1.recTypeId__c = pipeLinerecTypId;
            
            RecordtypeIds__c recTyp2 = new RecordtypeIds__c();
            recTyp2.Name = 'Pre-Pipeline Opportunities';
            recTyp2.recTypeId__c = prePipeLinerecTypId;
            
            recTypLst.add(recTyp1);
            recTypLst.add(recTyp2);
      insert recTypLst;
       LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c= 'errorMessage';
        excepObj.LCRM_Record_Ids__c= 'recordId';
        excepObj.LCRM_Exception_Type__c = 'BU_Segment_Update_Failure';
        insert excepObj;
        String Errormesg ='errorMessage';
        String recordId = 'recordIdValue';
        
    Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.Name = 'TESTACCOUNT_TAX';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BU_Segment__c ='Professional Tax';
            acc.BU_Region__c = 'US';
            accList.add(acc);
           
            
            if(accList.size()>0)
            insert accList;
        accId.add(accList[0].Id);
    Contact testContact = new Contact();
        testContact.AccountId = accList[0].Id;
        testContact.FirstName = 'MileFirst';
        testContact.LastName ='MileLast';
        testContact.Email ='test@tr.com';
    insert testContact;
    
    List<Case> caseList = new List<Case>();
        Case caseRec = new Case();
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('DQA Request').getRecordTypeId();
        caseRec.Origin = 'Web';      
        caseRec.Subject = 'Test Case';
        caseRec.AccountId = accList[0].id;
        caseRec.ContactId =testContact.Id; 
        caseRec.LCRM_Sub_BU__c ='US';
        caseRec.BU_Segment__c ='Professional Tax';
        caseList.add(caseRec);
        
        
        Case caseRec1 = new Case();
        caseRec1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('DQA Request').getRecordTypeId();
        caseRec1.Origin = 'Web';      
        caseRec1.Subject = 'Test Case';
        caseRec1.AccountId = accList[0].id;
        caseRec1.ContactId =testContact.Id; 
        caseRec1.LCRM_Sub_BU__c ='Canada';
        caseRec1.Is_GLI__c = true;
        caseRec1.BU_Segment__c ='Professional Tax';
        caseList.add(caseRec1);
        if(caseList.size()>0)
        insert caseList;
        
    List<Training_Event__c> evntLst = new List<Training_Event__c>();
        Training_Event__c trnEvnt = new Training_Event__c();
          trnEvnt.Training_Name__c = 'Test1';
          trnEvnt.Account__c = accList[0].Id;
          trnEvnt.LCRM_Sub_BU__c ='Canada';
          trnEvnt.BU_Segment__c ='Professional Tax';
          trnEvnt.LCRM_Is_GLI__c=true;
          
          Training_Event__c trnEvnt1 = new Training_Event__c();
          trnEvnt1.Training_Name__c = 'Test2';
          trnEvnt1.Account__c = accList[0].Id;
          trnEvnt1.LCRM_Sub_BU__c ='USL';
          trnEvnt1.LCRM_Is_GLI__c =true;
          trnEvnt1.BU_Segment__c ='Professional Tax';
          evntLst.add(trnEvnt);
          evntLst.add(trnEvnt1);
          insert evntLst;
      
    List<Account> updateAcc = new List<Account>();
    
        List<Account> ListofAccount = new List<Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT_TAX' AND BU_Segment__c ='Professional Tax' AND BU_Region__c ='US' LIMIT 1]);
        for(Account a:ListofAccount)
        {
            if(a.BU_Segment__c =='Professional Tax')
            a.BU_Segment__c ='Corporate';
      updateAcc.add(a);
        
        }
        Test.StartTest();
        update updateAcc;
      
        LOTUSChildObjSegmentUpdateInvocableClass.getAccountInfo(accId);
        LOTUSChildObjectSegmentUpdate.createExceptionLog(Errormesg,recordId);
        Test.StopTest();
  }

        //Informatica XREFAccountBuSegmet  Load
     @isTest static void testXREFAccountBuSegmentLoad() {
    
     List<Account> accList = new List<Account>();
     List<Id> accId = new List<Id>();
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
        KeyValueListStore__c kValue1 = new KeyValueListStore__c();
        kValue1.Name ='ANZUsersProfileId';
      
        KeyValueListStore__c kValue2 = new KeyValueListStore__c();
        kValue2.Name ='ReasonWithCompetitor';
        kValue2.TextValue__c = 'Content';
        
        KeyValueListStore__c kValue3 = new KeyValueListStore__c(); 
        kValue3.Name ='LTS_BURegion_Values';
        kValue3.TextValue__c = 'US,Canada';
        kValueLst.add(kValue1);
        kValueLst.add(kValue2);
        kValueLst.add(kValue3);
        insert kValueLst;
        Id pipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Id prePipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
            
          List<RecordtypeIds__c> recTypLst = new List<RecordtypeIds__c>();
            RecordtypeIds__c recTyp1 = new RecordtypeIds__c();
            recTyp1.Name = 'Pipeline Opportunities';
            recTyp1.recTypeId__c = pipeLinerecTypId;
            
            RecordtypeIds__c recTyp2 = new RecordtypeIds__c();
            recTyp2.Name = 'Pre-Pipeline Opportunities';
            recTyp2.recTypeId__c = prePipeLinerecTypId;
            
            recTypLst.add(recTyp1);
            recTypLst.add(recTyp2);
            insert recTypLst;
        
        
        
        Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.Name = 'TESTACCOUNT_Xref';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BU_Segment__c ='Professional Tax';
            acc.BU_Region__c = 'US';
            accList.add(acc);
           
            
            if(accList.size()>0)
            insert accList;
           accId.add(accList[0].Id);
        List<Opportunity> opportunitytestlist = new List<Opportunity>();
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=new Opportunity();
        oppty.Name='TEST OPP';
        oppty.RecordtypeId=opptyRecorType;
        oppty.StageName ='Need Analysis';
        oppty.AccountId=accList[0].id;
        oppty.CloseDate = Date.Today() + 90;
        oppty.LCRM_Sub_BU__c ='Canada';
        oppty.BU_Segment__c ='Corporate';
        
       
        opportunitytestlist.add(oppty);
        
        Opportunity oppty1=new Opportunity();
        oppty1.Name='TEST OPP1';
        oppty1.RecordtypeId=opptyRecorType;
        oppty1.StageName ='Need Analysis';
        oppty1.AccountId=accList[0].id;
        oppty1.CloseDate = Date.Today() + 90;
        oppty1.LCRM_Sub_BU__c ='US';
        oppty1.BU_Segment__c ='Corporate';
    
        opportunitytestlist.add(oppty1);
    
        if(opportunitytestlist.size()>0)
        insert opportunitytestlist ;
        
        List<Task> taskList= new List<Task>();
        List<Event> eventList= new List<Event>();
        for(Opportunity opp : opportunitytestlist){
            System.debug('LASTMODIFIEDDATE** '+opp.lastmodifieddate);
            Task taskIns = new Task();
            taskIns.WhatId = opp.id;
            taskIns.LCRM_Sub_BU__c = 'US';
            taskIns.BU_Segment__c ='Coporate'; 
            taskList.add(taskIns);
            Event eventIns = new Event();
            eventIns.WhatId = opp.Id;
            eventIns.LCRM_Sub_BU__c ='Canada';
            eventIns.BU_Segment__c ='Corporate';
            eventIns.ActivityDateTime = system.today();
            eventIns.DurationInMinutes = 120;
      
            eventList.add(eventIns);
        }
        if(taskList.size()> 0 && eventList.size() > 0 ){
            insert taskList;
            insert eventList;
            
        }
        Id leadRt= Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        List<Lead> LeadList = new List<Lead>();
        Lead TestLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.LCRM_Sub_BU__c='US';
         TestLead1.BU_Segment__c='Corporate';
         TestLead1.Is_GLI__c = true;
         TestLead1.Account__c =accList[0].Id;
     
        Lead ld = new Lead(FirstName ='Test',LastName='Lead',Company='Test',Is_GLI__c=true,RecordTypeId=leadRt);
    
        LeadList.add(TestLead1);
        LeadList.add(ld);
    
    if(LeadList.size() > 0)
        insert LeadList;
    
    List<Account> ListofAccount = new List<Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT_Xref' AND BU_Segment__c ='Professional Tax' AND BU_Region__c ='US' LIMIT 1]);
        Map<Id, Account> accountIdSegmentMap = new Map<Id, Account>([Select Id,Name,BU_Region__c,BU_Segment__c,IS_GLI__c from Account where IS_GLI__c = true AND Name ='TESTACCOUNT_Xref' AND BU_Segment__c ='Professional Tax' AND BU_Region__c ='US' LIMIT 1]);
    List<XREFAccountSegment__c> accountSegmentList = new List<XREFAccountSegment__c>();
        XREFAccountSegment__c xrefaccSeg= new XREFAccountSegment__c();
        xrefaccSeg.Name =ListofAccount[0].Id;
        xrefaccSeg.BU_Segment__c =ListofAccount[0].BU_Segment__c;
        xrefaccseg.Is_Processed_Activity__c =false;
        accountSegmentList.add(xrefaccSeg);
        insert accountSegmentList;
      
        LCRM_BatchsizeDefine__c Obatchsize = new LCRM_BatchsizeDefine__c();
        Obatchsize.Name ='XREFAccountSegment';
        Obatchsize.Object__c ='XREFAccountSegment__c';
        Obatchsize.Batch_Size__c = 200 ;   
        insert  Obatchsize;
                
        GLI_Load_Tracker__c gliloadtracker = new GLI_Load_Tracker__c();
        gliloadtracker.name = 'Informatica Account Segment Update';
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2017, 9, 15, 12, 30, 0);
        Insert gliloadtracker;
        
        Test.StartTest(); 
        gliloadtracker.JobCompletedDate__c= datetime.newInstance(2018, 10, 16, 11, 30, 0);
        UPDATE gliloadtracker; 
        LOTUSChildObjSegmentUpdateInvocableClass.getAccountInfo(accId);
        Test.StopTest();
        
      } 
    }