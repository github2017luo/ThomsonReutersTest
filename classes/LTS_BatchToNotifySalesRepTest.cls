/********************************************************************** 
Name: LTS_BatchToNotifySalesRepTest
====================================================== 
Req: Test Class for LTS_BatchToNotifySalesRepForOpportunity,LTS_ToNotifySalesRepForOpportunity and LTS_SendCustomEmailUtilityClass
====================================================== 
Purpose: Notify Rep with email
====================================================== 
History 
------- 
VERSION    AUTHOR           DATE           DETAIL 
1.0        TCS Developer    09/01/2019    Initial Development  
***********************************************************************/
@isTest(SeeAllData=false)
public class LTS_BatchToNotifySalesRepTest {    
    @isTest static void TestSendEmailTemplate1() {
        
        KeyValueListStore__c keyvaluestorestage = new KeyValueListStore__c();
        keyvaluestorestage.Name = 'LTS_Opportunity_NotifyEmailStages';
        keyvaluestorestage.TextValue__c = 'Solution Recommended,Needs Analysis';
        insert  keyvaluestorestage;
        
        KeyValueListStore__c noOfDays=new  KeyValueListStore__c();
        noOfDays.Name='LTS_Noofdaystonotify';
        noOfDays.Name='Test';
        noOfDays.TextValue__c='AB';
        insert noOfDays;
        
        //LTS_InformaticaUsers
        KeyValueListStore__c LTS_InformaticaUsers=new  KeyValueListStore__c();
        LTS_InformaticaUsers.Name='LTS_InformaticaUsers';
        LTS_InformaticaUsers.TextValue__c='Informatica GLI Integration,Test Informatica GLI Integration,Informatica User';
        insert LTS_InformaticaUsers;
        
        KeyValueListStore__c lTS_EmailToNotifyOpptyOwner = new KeyValueListStore__c();
        lTS_EmailToNotifyOpptyOwner.Name = 'LTS_EmailToNotifyOpptyOwner';
        lTS_EmailToNotifyOpptyOwner.TextValue__c = 'LTS_EmailToNotifyOpptyOwner';
        insert lTS_EmailToNotifyOpptyOwner;
        
        
        String jobId;
        List<Opportunity> opportunitytestlist = new List<Opportunity>();
        
        opportunitytestlist = LTS_TestDataFactory.createOpps(10);
        
        for(Opportunity opp : opportunitytestlist){
            System.debug('LASTMODIFIEDDATE** '+opp.lastmodifieddate);
        }
        Test.startTest();
        LTS_BatchToNotifySalesRepForOpportunity testIns = new LTS_BatchToNotifySalesRepForOpportunity();
        jobId = Database.executeBatch(testIns,200);
        Test.stopTest();
        // Get the Apex job and verify there are no errors.
        AsyncApexJob aaj = [Select JobType, TotalJobItems, JobItemsProcessed, Status,
                            CompletedDate, CreatedDate, NumberOfErrors
                            from AsyncApexJob where Id = :jobId];
        System.debug('aaj.NumberOfErrors '+aaj.NumberOfErrors);
        System.assertEquals(0, aaj.NumberOfErrors);
        
    }
    
    
    @isTest static void TestSendEmailTemplate() {
        
        KeyValueListStore__c keyvaluestorestage = new KeyValueListStore__c();
        keyvaluestorestage.Name = 'LTS_Opportunity_NotifyEmailStages';
        keyvaluestorestage.TextValue__c = 'Solution Recommended,Needs Analysis';
        insert  keyvaluestorestage;
        
        KeyValueListStore__c noOfDays=new  KeyValueListStore__c();
        noOfDays.Name='LTS_Noofdaystonotify';
        noOfDays.TextValue__c='1';
        insert noOfDays;
        
        //LTS_InformaticaUsers
        KeyValueListStore__c LTS_InformaticaUsers=new  KeyValueListStore__c();
        LTS_InformaticaUsers.Name='LTS_InformaticaUsers';
        LTS_InformaticaUsers.TextValue__c='Informatica GLI Integration,Test Informatica GLI Integration,Informatica User';
        insert LTS_InformaticaUsers;
        
        KeyValueListStore__c lTS_EmailToNotifyOpptyOwner = new KeyValueListStore__c();
        lTS_EmailToNotifyOpptyOwner.Name = 'LTS_EmailToNotifyOpptyOwner';
        lTS_EmailToNotifyOpptyOwner.TextValue__c = 'LTS_EmailToNotifyOpptyOwner';
        insert lTS_EmailToNotifyOpptyOwner;
        
        String jobId;
        List<Opportunity> opportunitytestlist = new List<Opportunity>();
        
        opportunitytestlist = LTS_TestDataFactory.createOpps(10);
        
        for(Opportunity opp : opportunitytestlist){
            System.debug('LASTMODIFIEDDATE** '+opp.lastmodifieddate);
        }
        Test.startTest();
        LTS_BatchToNotifySalesRepForOpportunity testIns = new LTS_BatchToNotifySalesRepForOpportunity();
        jobId = Database.executeBatch(testIns,200);
        Test.stopTest();
        // Get the Apex job and verify there are no errors.
        AsyncApexJob aaj = [Select JobType, TotalJobItems, JobItemsProcessed, Status,
                            CompletedDate, CreatedDate, NumberOfErrors
                            from AsyncApexJob where Id = :jobId];
        System.debug('aaj.NumberOfErrors '+aaj.NumberOfErrors);
        System.assertEquals(0, aaj.NumberOfErrors);
        
    }
    
    //RecodswithEventsandtasks
    @isTest static void TaskAndEventFunctionality() {
        
        KeyValueListStore__c keyvaluestorestage = new KeyValueListStore__c();
        keyvaluestorestage.Name = 'LTS_Opportunity_NotifyEmailStages';
        keyvaluestorestage.TextValue__c = 'Solution Recommended,Needs Analysis';
        insert  keyvaluestorestage;
        
        KeyValueListStore__c noOfDays=new  KeyValueListStore__c();
        noOfDays.Name='LTS_Noofdaystonotify';
        noOfDays.TextValue__c='1';
        
        insert noOfDays;
        
        //LTS_InformaticaUsers
        KeyValueListStore__c LTS_InformaticaUsers=new  KeyValueListStore__c();
        LTS_InformaticaUsers.Name='LTS_InformaticaUsers';
        LTS_InformaticaUsers.TextValue__c='Informatica GLI Integration,Test Informatica GLI Integration,Informatica User';
        insert LTS_InformaticaUsers;
        
        KeyValueListStore__c lTS_EmailToNotifyOpptyOwner = new KeyValueListStore__c();
        lTS_EmailToNotifyOpptyOwner.Name = 'LTS_EmailToNotifyOpptyOwner';
        lTS_EmailToNotifyOpptyOwner.TextValue__c = 'LTS_EmailToNotifyOpptyOwner';
        insert lTS_EmailToNotifyOpptyOwner;
        
        String jobId;
        List<Opportunity> opportunitytestlist = new List<Opportunity>();
        
        opportunitytestlist = LTS_TestDataFactory.createOpps(10);
        List<Task> taskList= new List<Task>();
        List<Event> eventList= new List<Event>();
        for(Opportunity opp : opportunitytestlist){
            System.debug('LASTMODIFIEDDATE** '+opp.lastmodifieddate);
            Task taskIns = new Task();
            taskIns.WhatId = opp.id;
            taskList.add(taskIns);
            Event eventIns = new Event();
            eventIns.WhatId = opp.Id;
            eventIns.ActivityDateTime = system.today();
            eventIns.DurationInMinutes = 120;
            eventList.add(eventIns);
        }
        if(taskList.size()> 0 && eventList.size() > 0 ){
            insert taskList;
            insert eventList;
            
        }
        for(Opportunity opp : opportunitytestlist){
            System.debug('LASTMODIFIEDDATE** '+opp.lastmodifieddate);
        }
        Test.startTest();
        LTS_BatchToNotifySalesRepForOpportunity testIns = new LTS_BatchToNotifySalesRepForOpportunity();
        jobId = Database.executeBatch(testIns,200);
        Test.stopTest();
        // Get the Apex job and verify there are no errors.
        AsyncApexJob aaj = [Select JobType, TotalJobItems, JobItemsProcessed, Status,
                            CompletedDate, CreatedDate, NumberOfErrors
                            from AsyncApexJob where Id = :jobId];
        System.debug('aaj.NumberOfErrors '+aaj.NumberOfErrors);
        System.assertEquals(0, aaj.NumberOfErrors);
        
    }
    
    //exceptionFunctionality
   @isTest static void exceptionFunctionality() {
      
       List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();//used to store exceptions
       LCRM_Exception_Log__c lcrmError = new LCRM_Exception_Log__c();
       lcrmError.LCRM_Exception_Message__c = 'e.getMessage()';
       lcrmError.LCRM_Exception_Type__c = 'e.getTypeName()';
       lcrmError.LCRM_Exception_Trace__c = 'e.getStackTraceString()';
       exceptionList.add(lcrmError);
       
       Test.startTest();
       LTSStoreErrors.customLTSException(exceptionList);
       Test.stopTest();
        
    }
}