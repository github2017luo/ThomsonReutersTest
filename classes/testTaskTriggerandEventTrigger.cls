@isTest(seealldata=true)
public class testTaskTriggerandEventTrigger
{

     public static List<Task> listtestTask = new List<Task>();
     public static List<Event> listtestevent = new List<Event>();
     public static Id testOppId;
     public static Id testLeadId;
     
     
     public static void testTaskTriggerandEventTrigger(){
     
        Account TestAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        
        Contact Testcontact = UnitTest.getContactInstance(TestAccount.Id);
        insert Testcontact;
        
        
        Opportunity testOpp = Unittest.getOpportunityInstance(TestAccount.Id);
        insert testOpp;
        testOppId = testOpp.Id;
        
        Lead testLead =  Unittest.getLeadInstance();
        insert testLead;
        testLeadId = testLead.Id;        
        
     }
      
     

    public static testmethod void testTaskandEventTrigger()
    {
        List<Account> listAccount = new List<Account>();
        listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000550771'];
        Account account = UnitTest.getAccountInstance();
        if(listAccount.isEmpty())
        {
            account.Name = 'testAccount';
            account.Customer_Type__c = 'Induvidual';
            account.Customer_Group__c = 'ACADEMIC';
            account.Industry = 'Energy';
            account.SAPAccountNumber__c = '1000550771';
            insert account;
        }
        else
        {
            account = listAccount[0];
        }
        
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.AccountId = account.Id;
        insert contact;
        
        //Opportunity testOpp  = Unittest.getOpportunityInstance(account.Id);
       // insert testOpp;
        
       // Lead testLead =  Unittest.getLeadInstance();
       // insert testLead;
                
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = account.Id;
        insert testTrainingEventAccount;
        
        Training_Event_Contact__c testTrainingEventContact= new Training_Event_Contact__c();
        testTrainingEventContact.Contact_Name__c = contact.Id;
        testTrainingEventContact.Training_Event__c = testTrainingEvent.Id;
        insert testTrainingEventContact;
        
        
        List<Event> listtestevents = new List<Event>();
        Event testEvent = new Event();
        testEvent.Owner_Group__c = 'Inside Sales';
        testEvent.Status__c = 'Pending';
        testEvent.Subject = 'test Subject';
        testEvent.WhatId = testTrainingEvent.Id;
        testEvent.Type = 'Appointment';
        testEvent.ActivityDate = System.Today();
        testEvent.StartDateTime = System.DateTime.Now();
        testEvent.DurationInMinutes = 60;
        testEvent.Comments__c = '12';
        testEvent.ReminderDateTime = System.DateTime.Now();
        listtestevents.add(testEvent);
        
        Event testEvent1 = new Event();
        testEvent1.Owner_Group__c = 'Inside Sales';
        testEvent1.Status__c = 'Pending';
        testEvent1.Subject = 'test Subject';
        testEvent1.WhoId = testLeadId;
        testEvent1.Type = 'Appointment';
        testEvent1.ActivityDate = System.Today();
        testEvent1.StartDateTime = System.DateTime.Now();
        testEvent1.DurationInMinutes = 60;
        testEvent1.Comments__c = '12';
        testEvent1.ReminderDateTime = System.DateTime.Now()+3;
        listtestevents.add(testEvent1);
        
        Event testEvent2 = new Event();
        testEvent2.Owner_Group__c = 'Inside Sales';
        testEvent2.Status__c = 'Pending';
        
        testEvent2.Subject = 'test Subject';
        testEvent2.WhatId = testOppId;
        testEvent2.StartDateTime = System.DateTime.Now();
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.ReminderDateTime = System.DateTime.Now()+3;
        listtestevents.add(testEvent2);
                        
        insert listtestevents;

        List<Task> listtestTasks = new List<Task>();
        Task testTask = new Task();
        testTask.Owner_Group__c = 'Inside Sales';
        testTask.Status__c = 'Pending';
        testTask.Status = 'Pending';
        testTask.Subject = 'test Subject';
        testTask.WhatId = testTrainingEvent.Id;
        
        testTask.Type = 'Outbound Call';
        testTask.ActivityDate = System.Today();
        testTask.ReminderDateTime = System.DateTime.Now();
        listtestTasks.add(testTask);


        Task testTask1 = new Task();
        testTask1.Owner_Group__c = 'Inside Sales';
        testTask1.Status__c = 'Pending';
        testTask1.Status = 'Pending';
        testTask1.Subject = 'test Subject';
        testTask1.WhatId = testOppId;
        
        testTask1.Type = 'Outbound Call';
        testTask1.ActivityDate = System.Today();
        testTask1.ReminderDateTime = System.DateTime.Now();
         listtestTasks.add(testTask1);
         
        Task testTask2 = new Task();
        testTask2.Owner_Group__c = 'Inside Sales';
        testTask2.Status__c = 'Pending';
        testTask2.Status = 'Pending';
        testTask2.Subject = 'test Subject';
        testTask2.WhoId = testLeadId;
        testTask2.Type = 'Outbound Call';
        testTask2.ActivityDate = System.Today();
        testTask2.ReminderDateTime = System.DateTime.Now();
        listtestTasks.add(testTask2);
        
        insert listtestTasks;
        test.starttest();   
           
        testEvent.Comments__c = '1234';
        testEvent.ActivityDate = System.Today()+2;
        testEvent1.ActivityDate = System.Today()+2;
        testEvent2.ActivityDate = System.Today()+2;
        update listtestevents;
        
        
        testTask.ActivityDate = System.Today()+2;
        update listtestTasks;
        
        delete listtestTasks;
        
        delete listtestevents;
        test.stoptest();        
        
    }
    
     public static testmethod void testUpdateOwnerGroup(){
        List<User> listestuser = new List<User>();
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        User testuser1 = new User(Username='testUser157@salesforce.com', LastName='test157', Email='test157@salesforce.com', Alias='tuser157', 
        CommunityNickname='test1', TimeZoneSidKey='America/Chicago', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        ProfileId=p.Id, LanguageLocaleKey='en_US');
        testuser1.Market_Segment_Description__c = 'CLEAR';
        testuser1.Sales_Force_Description__c = 'Nationaltest';
        listestuser.add(testuser1);
        
        User testuser2 = new User(Username='testUser257@salesforce.com', LastName='test257', Email='test257@salesforce.com', Alias='tuser257', 
        CommunityNickname='test2', TimeZoneSidKey='America/Chicago', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        ProfileId=p.Id, LanguageLocaleKey='en_US');
        listestuser.add(testuser2);
        
        insert listestuser;
        
        OwnerGroup__c testOwnergrp = new OwnerGroup__c(Name='CLEAR-Nationaltest',Channel__c='Investigative');
        Insert testOwnergrp;
        
        Task testTask;
        
        System.runas(testuser1){
            Account TestAccount = UnitTest.getAccountInstance();
            Insert TestAccount;
                   
            Opportunity testOpp  = Unittest.getOpportunityInstance(TestAccount.Id);
            insert testOpp;
            
            testTask = UnitTest.getTaskInstance(testOpp.Id, false);
            Insert testTask;
        
        }
        test.starttest();
        testTask = [select Owner_group__c from Task where Id =: testTask.Id];
        System.assertEquals(testTask.Owner_group__c,'Investigative','Error');
        testTask.OwnerId = testuser2.Id;
        update testTask;
        testTask = [select Owner_group__c from Task where Id =: testTask.Id];
        System.assertEquals(testTask.Owner_group__c,'Other','Error');
        test.stoptest();
        
    }
    
    
    public static testmethod void testUpdateNextCallDate()
    {
       testTaskTriggerandEventTrigger();
                
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        
        Task testTask = UnitTest.getTaskInstance(testTrainingEvent.Id, false);
        
        testTask.Owner_Group__c = 'Inside Sales';
        testTask.Status__c = 'Pending';
        testTask.Status = 'Pending';
        testTask.Subject = 'test Subject';
        testTask.Type = 'Outbound Call';
        
        listtestTask.add(testTask);


        Task testTask1 = new Task();
        testTask1.Owner_Group__c = 'Inside Sales';
        testTask1.Status__c = 'Pending';
        testTask1.Status = 'Pending';
        testTask1.Subject = 'test Subject';
        testTask1.WhatId = testOppId;
        testTask1.Type = 'Outbound Call';
        testTask1.ActivityDate = System.Today();
        testTask1.ReminderDateTime = System.DateTime.Now();
        listtestTask.add(testTask1);
         
        Task testTask2 = new Task();
        testTask2.Owner_Group__c = 'Inside Sales';
        testTask2.Status__c = 'Pending';
        testTask2.Status = 'Pending';
        testTask2.Subject = 'test Subject';
        testTask2.WhoId = testLeadId;
        testTask2.Type = 'Outbound Call';
        testTask2.ActivityDate = System.Today();
        testTask2.ReminderDateTime = System.DateTime.Now();
        listtestTask.add(testTask2);
        
        
        Task testTask3 = new Task();
        testTask3.Owner_Group__c = 'Inside Sales';
        testTask3.Status__c = 'Pending';
        testTask3.Status = 'Pending';
        testTask3.Subject = 'test Subject';
        testTask3.WhatId = testOppId;
        testTask3.Type = 'Outbound Call';
        testTask3.ActivityDate = System.Today()+1;
        testTask3.ReminderDateTime = System.DateTime.Now();
         listtestTask.add(testTask3);
         
        Task testTask4 = new Task();
        testTask4.Owner_Group__c = 'Inside Sales';
        testTask4.Status__c = 'Pending';
        testTask4.Status = 'Pending';
        testTask4.Subject = 'test Subject';
        testTask4.WhoId = testLeadId;
        testTask4.Type = 'Outbound Call';
        testTask4.ActivityDate = System.Today()+1;
        testTask4.ReminderDateTime = System.DateTime.Now();
        listtestTask.add(testTask4);
        
        insert listtestTask;
        
        
        
        Event testEvent = new Event();
        testEvent.Owner_Group__c = 'Inside Sales';
        testEvent.Status__c = 'Pending';
        testEvent.Subject = 'test Subject';
        testEvent.WhatId = testTrainingEvent.Id;
        testEvent.Type = 'Appointment';
        testEvent.ActivityDate = System.Today();
        testEvent.StartDateTime = System.DateTime.Now();
        testEvent.DurationInMinutes = 60;
        testEvent.Comments__c = '12';
        testEvent.ReminderDateTime = System.DateTime.Now();
        listtestevent.add(testEvent);
        
        Event testEvent1 = new Event();
        testEvent1.Owner_Group__c = 'Inside Sales';
        testEvent1.Status__c = 'Pending';
        testEvent1.Subject = 'test Subject';
        testEvent1.WhoId = testLeadId;
        testEvent1.Type = 'Appointment';
        testEvent1.ActivityDate = System.Today();
        testEvent1.StartDateTime = System.DateTime.Now();
        testEvent1.DurationInMinutes = 60;
        testEvent1.Comments__c = '12';
        testEvent1.ReminderDateTime = System.DateTime.Now()+3;
        listtestevent.add(testEvent1);
        
        Event testEvent2 = new Event();
        testEvent2.Owner_Group__c = 'Inside Sales';
        testEvent2.Status__c = 'Pending';
        
        testEvent2.Subject = 'test Subject';
        testEvent2.WhatId = testOppId;
        testEvent2.StartDateTime = System.DateTime.Now();
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.ReminderDateTime = System.DateTime.Now()+3;
        listtestevent.add(testEvent2);

                        
        insert listtestevent;
        
        test.starttest();
        
        testTask1.ActivityDate = System.Today()+2;
        testTask2.ActivityDate = System.Today()+2;
        
        update listtestTask;
        
        testEvent1.ActivityDate = System.Today()+2;
        testEvent2.ActivityDate = System.Today()+2;
        update listtestevent;
          
        test.stoptest();
        
        Opportunity testopp = [Select Next_Call_Date__c from Opportunity where Id=:testOppId];
        Lead testLead = [Select Next_Call_Date__c from Lead where Id=:testLeadId];
        
        //System.assertEquals(testopp.Next_Call_Date__c,System.today()+1,'Error: Next Call Date not populated correctly on Opp');
        //System.assertEquals(testLead.Next_Call_Date__c,System.today()+1,'Error: Next Call Date not populated correctly on Lead');
        
        
    }
    
    public static testmethod void testUpdateNextCallDatetask_del(){
        testTaskTriggerandEventTrigger();
        
        Event testEvent1 = new Event();
        testEvent1.Owner_Group__c = 'Inside Sales';
        testEvent1.Status__c = 'Pending';
        testEvent1.Subject = 'test Subject';
        testEvent1.WhoId = testLeadId;
        testEvent1.Type = 'Appointment';
        testEvent1.ActivityDate = System.Today();
        testEvent1.StartDateTime = System.DateTime.Now()+1;
        testEvent1.DurationInMinutes = 60;
        testEvent1.Comments__c = '12';
        testEvent1.ReminderDateTime = System.DateTime.Now()+3;
        listtestevent.add(testEvent1);
        
        Event testEvent2 = new Event();
        testEvent2.Owner_Group__c = 'Inside Sales';
        testEvent2.Status__c = 'Pending';
        
        testEvent2.Subject = 'test Subject';
        testEvent2.WhatId = testOppId;
        testEvent2.StartDateTime = System.DateTime.Now()+1;
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.ReminderDateTime = System.DateTime.Now()+3;
        listtestevent.add(testEvent2);
        
        Task testTask = UnitTest.getTaskInstance(testOppId, false);
        
        testTask.Owner_Group__c = 'Inside Sales';
        testTask.Status__c = 'Pending';
        testTask.Status = 'Pending';
        testTask.Subject = 'test Subject';
        testTask.Type = 'Outbound Call';
        listtestTask.add(testTask);
        
       Task testTask1 = new Task();
        testTask1.Owner_Group__c = 'Inside Sales';
        testTask1.Status__c = 'Pending';
        testTask1.Status = 'Pending';
        testTask1.Subject = 'test Subject';
        testTask1.WhoId = testLeadId;
        testTask1.Type = 'Outbound Call';
        testTask1.ActivityDate = System.Today()+1;
        testTask1.ReminderDateTime = System.DateTime.Now();
        testTask1.Description = 'Offer Code 704330';
        testTask1.subject ='30-Day Onboarding';
        
        listtestTask.add(testTask1);
        Insert listtestTask;
        
        test.starttest();
        Insert listtestevent;
        delete listtestTask;  
        test.stoptest(); 
       
        Opportunity testopp1 = [Select Next_Call_Date__c from Opportunity where Id=:testOppId];
       
        Lead testLead1 = [Select Next_Call_Date__c from Lead where Id=:testLeadId];
        
        System.assertEquals(testopp1.Next_Call_Date__c,System.today()+1,'Error: Next Call Date not populated correctly on Opp');
        System.assertEquals(testLead1.Next_Call_Date__c,System.today()+1,'Error: Next Call Date not populated correctly on Lead');
        
    
    }
    
   public static testmethod void testUpdateNextCallDateevent_del(){
       testTaskTriggerandEventTrigger();
       test.starttest();    
        delete listtestevent;
        test.stoptest(); 
        Opportunity testopp1 = new Opportunity();
        testopp1 = [Select Next_Call_Date__c from Opportunity where Id=:testOppId];
        Lead testLead1 =new Lead();
        testLead1 = [Select Next_Call_Date__c from Lead where Id=:testLeadId];
        
        System.assertEquals(testopp1.Next_Call_Date__c,null,'Error: Next Call Date not populated correctly on Opp');
        System.assertEquals(testLead1.Next_Call_Date__c,null,'Error: Next Call Date on Lead incorrect');
        
   }
   
       public static testmethod void testTrainingEventTrigger()
    {
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        User testuser1 = new User(Username='testUser157@salesforce.com', LastName='test157', Email='test157@salesforce.com', Alias='tuser157', 
        CommunityNickname='test1', TimeZoneSidKey='America/Chicago', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        ProfileId=p.Id, LanguageLocaleKey='en_US');
        testuser1.Market_Segment_Description__c = 'CLEAR';
        testuser1.Sales_Force_Description__c = 'Nationaltest';
        insert testuser1;
        
       // Set up Training Event
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        testTrainingEvent.Training_Rep_2__c = testuser1.id;
        testTrainingEvent.Training_Rep_3__c = testuser1.id;
        testTrainingEvent.Training_Rep_4__c = testuser1.id;
        insert testTrainingEvent;
 
        Training_Event_Team__c testTrainingEventTeam = new Training_Event_Team__c();
        testTrainingEventTeam.Training_Event_Team__c = testTrainingEvent.Id;
        testTrainingEventTeam.Training_Team_Member__c = testuser1.id;
        testTrainingEventTeam.Send_Notification__c = true;
        insert testTrainingEventTeam;
               
        test.starttest();   
           
        testTrainingEvent.Status__c = 'Completed';
        update testTrainingEvent;
        
        test.stoptest();        
        
    }
    
    @isTest static void  testpullEventsToAccountLeadActivities()
    {
         recordtype leadRT = [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
         
         Account TestAccount = UnitTest.getAccountInstance();
         Insert TestAccount;
        
        
         Lead testlead= UnitTest.getLeadInstance();
         testlead.LastName='Smith';
         testlead.Company = 'UTLeadAccount';
         testlead.Billing_City__c = 'test';
         testlead.Billing_Street__c = 'test';
         testlead.Billing_State__c = 'CA';
         testlead.Billing_Zip__c = 'test';
         testlead.Billing_Country__c = 'US';
         testlead.email = 'abc@gmail.com';
         testlead.Account__c= TestAccount.Id;
         testlead.RecordTypeId = leadRT.Id;
         testlead.Is_GLI__c = true;
         insert testlead;
       
        
        List<Event> listtestevents = new List<Event>();
        Event testEvent1 = new Event();
        testEvent1.Owner_Group__c = 'Inside Sales';
        testEvent1.Status__c = 'Pending';
        testEvent1.Subject = 'test Subject';
        testEvent1.WhoId = testlead.id;
        testEvent1.Type = 'Appointment';
        testEvent1.ActivityDate = System.Today();
        testEvent1.StartDateTime = System.DateTime.Now();
        testEvent1.DurationInMinutes = 60;
        testEvent1.Comments__c = '12';
        testEvent1.ReminderDateTime = System.DateTime.Now()+3;
        listtestevents.add(testEvent1);
        
        Event testEvent2 = new Event();
        testEvent2.Owner_Group__c = 'Inside Sales';
        testEvent2.Status__c = 'Pending';
        testEvent2.Subject = 'test Subject';
        testEvent2.WhoId = testlead.id;
        testEvent2.StartDateTime = System.DateTime.Now();
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.ReminderDateTime = System.DateTime.Now()+3;
        listtestevents.add(testEvent2);
                        
        insert listtestevents;
        
        //checkRecursive rec = new checkRecursive();
        Test.startTest();
        checkRecursive.runEvent = true;
        testEvent2.Status__c = 'Completed';
        update listtestevents;
        
        Test.stopTest();
        System.debug('testEvent2:-'+testEvent2);
        AccountLeadActivity__c testaccleadactivity = [Select id,Status__c,Related_To_Account__c,Lead__c,TaskId__c,Comments__c from AccountLeadActivity__c where TaskId__c=:testEvent2.id and  Related_To_Account__c=:TestAccount.Id and Lead__c = :testlead.id limit 1];
        System.debug('testaccleadactivity :-'+testaccleadactivity );
        System.assertEquals('Completed', testaccleadactivity.Status__c);
        
    }
    public static testmethod void testDeleteTrainingEventShare()
    {
        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
        User gliUKIUser = new User(alias = 'newUUser', email='user@uki.com', 
                               emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                               localesidkey='en_US', profileid = ukiProfile.Id, employeenumber='0144021',
                               timezonesidkey='America/Los_Angeles', username='user@uki.com',Rep_Type_Description__c='testUki');        
        insert gliUKIUser;
        Training_Event__c gliTE = UnitTest.getTrainingEventInstance();
        gliTE.LCRM_Is_GLI__c = true;
        insert gliTE;
                
        Training_Event__Share testest = new Training_Event__Share();
        testest.AccessLevel = 'Edit';
        testest.ParentId = gliTE.Id;
        testest.UserOrGroupId = gliUKIUser.Id;
        insert testest;
        TrainingEventsUtil.deleteTrainingeventshare(gliTE.Id, gliUKIUser.Id);
    }
    
    /**
    *	{Purpose} - Method to test the Completed Activity Count functionality
	*				in the (Event) After Insert action.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date		Name				Description
    *	20181022	Jason Flippen		Created
    *	=============================================================================
    **/
    private static testMethod void testEventAfterInsert_CompletedActivityCount() {
		
        Map<String,Id> objectRTIdMap = new Map<String,Id>();
        for (RecordType rt : [SELECT Id,
                              		 SObjectType
                              FROM   RecordType
                              WHERE  SObjectType IN ('Lead','Event')
                              AND    DeveloperName IN ('GLI','GLI_Event_Record_Type')]) {
			objectRTIdMap.put(rt.SObjectType, rt.Id);
		}
        
        // Insert a test Lead.
        Id leadRTId = objectRTIdMap.get('Lead');
        Lead testLead = new Lead(RecordTypeId = leadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked',
                                 Is_GLI__c = true);
        insert testLead;
        
        Test.startTest();
			
            // Insert a test Event.
            Id eventRTId = objectRTIdMap.get('Event');
            Event testEvent = new Event(RecordTypeId = eventRTId,
                                        WhoId = testLead.Id,
                                        ActivityDate = Date.today(),
                                        LCRM_Activity_Type__c = 'In Person',
                                        Activity_Category__c = 'Business Review',
                                        StartDateTime = DateTime.now(),
                                        EndDateTime = DateTime.now(),
                                        Subject = 'Event',
                                        Status__c = 'Completed');
            insert testEvent;
        	
        Test.stopTest();
        
        // Check the LeadActivityCountStage table and verify the Event Trigger worked.
        List<Lead_Activity_Count_Stage__c> lacsList = [SELECT Id FROM Lead_Activity_Count_Stage__c WHERE Lead__c = :testLead.Id];
		System.assertEquals(1, lacsList.size());
        
    } // End Method: testEventAfterInsert_CompletedActivityCount()    
    
    /**
    *	{Purpose} - Method to test the Completed Activity Count functionality
	*				in the (Event) After Update action.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date		Name				Description
    *	20181022	Jason Flippen		Created
    *	=============================================================================
    **/
    private static testMethod void testEventAfterUpdate_CompletedActivityCount() {
		
        Map<String,Id> objectRTIdMap = new Map<String,Id>();
        for (RecordType rt : [SELECT Id,
                              		 SObjectType
                              FROM   RecordType
                              WHERE  SObjectType IN ('Lead','Event')
                              AND    DeveloperName IN ('GLI','GLI_Event_Record_Type')]) {
			objectRTIdMap.put(rt.SObjectType, rt.Id);
		}
        
        // Insert a test Lead.
        Id leadRTId = objectRTIdMap.get('Lead');
        Lead testLead = new Lead(RecordTypeId = leadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked',
                                 Is_GLI__c = true);
        insert testLead;
        
        // Insert a test Event.
        Id eventRTId = objectRTIdMap.get('Event');
        Event testEvent = new Event(RecordTypeId = eventRTId,
                                    WhoId = testLead.Id,
                                    ActivityDate = Date.today(),
                                    LCRM_Activity_Type__c = 'In Person',
                                    Activity_Category__c = 'Business Review',
                                    StartDateTime = DateTime.now(),
                                    EndDateTime = DateTime.now(),
                                    Subject = 'Event',
                                    Status__c = 'Pending');
        insert testEvent;
        
        Test.startTest();
			
        	testEvent.Status__c = 'Completed';
        	update testEvent;
        	
        Test.stopTest();
        
        // Check the LeadActivityCountStage table and verify the Event Trigger worked.
        List<Lead_Activity_Count_Stage__c> lacsList = [SELECT Id FROM Lead_Activity_Count_Stage__c WHERE Lead__c = :testLead.Id];
		System.assertEquals(1, lacsList.size());
        
    } // End Method: testEventAfterUpdate_CompletedActivityCount()    

    /**
    *	{Purpose} - Method to test the Completed Activity Count functionality
	*				in the (Event) After Delete action.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date		Name				Description
    *	20181022	Jason Flippen		Created
    *	=============================================================================
    **/
    private static testMethod void testEventAfterDelete_CompletedActivityCount() {
		
        Map<String,Id> objectRTIdMap = new Map<String,Id>();
        for (RecordType rt : [SELECT Id,
                              		 SObjectType
                              FROM   RecordType
                              WHERE  SObjectType IN ('Lead','Event')
                              AND    DeveloperName IN ('GLI','GLI_Event_Record_Type')]) {
			objectRTIdMap.put(rt.SObjectType, rt.Id);
		}
        
        // Insert a test Lead.
        Id leadRTId = objectRTIdMap.get('Lead');
        Lead testLead = new Lead(RecordTypeId = leadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked',
                                 Is_GLI__c = true);
        insert testLead;
        
        // Insert a test Event.
        Id eventRTId = objectRTIdMap.get('Event');
        Event testEvent = new Event(RecordTypeId = eventRTId,
                                    WhoId = testLead.Id,
                                    ActivityDate = Date.today(),
                                    LCRM_Activity_Type__c = 'In Person',
                                    Activity_Category__c = 'Business Review',
                                    StartDateTime = DateTime.now(),
                                    EndDateTime = DateTime.now(),
                                    Subject = 'Event',
                                    Status__c = 'Completed');
        insert testEvent;
        
        Test.startTest();
			
			delete testEvent;
        	
        Test.stopTest();
        
        // Check the LeadActivityCountStage table and verify the Event Trigger worked.
        List<Lead_Activity_Count_Stage__c> lacsList = [SELECT Id FROM Lead_Activity_Count_Stage__c WHERE Lead__c = :testLead.Id];
		System.assertEquals(1, lacsList.size());
		
    } // End Method: testEventAfterDelete_CompletedActivityCount()    

    /**
    *	{Purpose} - Method to test the Completed Activity Count functionality
	*				in the (Task) After Insert action.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date		Name				Description
    *	20181022	Jason Flippen		Created
    *	=============================================================================
    **/
    private static testMethod void testTaskAfterInsert_CompletedActivityCount() {
		
        Map<String,Id> objectRTIdMap = new Map<String,Id>();
        for (RecordType rt : [SELECT Id,
                              		 SObjectType
                              FROM   RecordType
                              WHERE  SObjectType IN ('Lead','Task')
                              AND    DeveloperName IN ('GLI','GLI_Record_Type')]) {
			objectRTIdMap.put(rt.SObjectType, rt.Id);
		}
        
        // Insert a test Lead.
        Id leadRTId = objectRTIdMap.get('Lead');
        Lead testLead = new Lead(RecordTypeId = leadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked',
                                 Is_GLI__c = true);
        insert testLead;
        
        Test.startTest();
			
            // Insert a test Task.
            Id taskRTId = objectRTIdMap.get('Task');
            Task testTask = new Task(RecordTypeId = taskRTId,
                                     WhoId = testLead.Id,
                                     ActivityDate = Date.today(),
                                     LCRM_Activity_Type__c = 'Email Outbound',
                                     Activity_Category__c = 'Follow Up',
                                     Subject = 'Task',
                                     Priority = 'Normal',
                                     Status = 'Completed');
            insert testTask;
        
        Test.stopTest();
        
        // Check the LeadActivityCountStage table and verify the Task Trigger worked.
        List<Lead_Activity_Count_Stage__c> lacsList = [SELECT Id FROM Lead_Activity_Count_Stage__c WHERE Lead__c = :testLead.Id];
		System.assertEquals(1, lacsList.size());
		
    } // End Method: testTaskAfterInsert_CompletedActivityCount()

    /**
    *	{Purpose} - Method to test the Completed Activity Count functionality
	*				in the (Task) After Update action.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date		Name				Description
    *	20181022	Jason Flippen		Created
    *	=============================================================================
    **/
    private static testMethod void testTaskAfterUpdate_CompletedActivityCount() {
		
        Map<String,Id> objectRTIdMap = new Map<String,Id>();
        for (RecordType rt : [SELECT Id,
                              		 SObjectType
                              FROM   RecordType
                              WHERE  SObjectType IN ('Lead','Task')
                              AND    DeveloperName IN ('GLI','GLI_Record_Type')]) {
			objectRTIdMap.put(rt.SObjectType, rt.Id);
		}
        
        // Insert a test Lead.
        Id leadRTId = objectRTIdMap.get('Lead');
        Lead testLead = new Lead(RecordTypeId = leadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked',
                                 Is_GLI__c = true);
        insert testLead;
        
        // Insert a test Task.
        Id taskRTId = objectRTIdMap.get('Task');
        Task testTask = new Task(RecordTypeId = taskRTId,
                                 WhoId = testLead.Id,
                                 ActivityDate = Date.today(),
                                 LCRM_Activity_Type__c = 'Email Outbound',
                                 Activity_Category__c = 'Follow Up',
                                 Subject = 'Task',
                                 Priority = 'Normal',
                                 Status = 'Pending');
        insert testTask;
        
        Test.startTest();
			
			testTask.Status = 'Completed';
			update testTask;
        	
        Test.stopTest();
        
        // Check the LeadActivityCountStage table and verify the Task Trigger worked.
        List<Lead_Activity_Count_Stage__c> lacsList = [SELECT Id FROM Lead_Activity_Count_Stage__c WHERE Lead__c = :testLead.Id];
		System.assertEquals(1, lacsList.size());
		
    } // End Method: testTaskAfterUpdate_CompletedActivityCount()

    /**
    *	{Purpose} - Method to test the Completed Activity Count functionality
	*				in the (Task) After Delete action.
    *
    *	CHANGE HISTORY
    *	=============================================================================
    *	Date		Name				Description
    *	20181022	Jason Flippen		Created
    *	=============================================================================
    **/
    private static testMethod void testTaskAfterDelete_CompletedActivityCount() {
		
        Map<String,Id> objectRTIdMap = new Map<String,Id>();
        for (RecordType rt : [SELECT Id,
                              		 SObjectType
                              FROM   RecordType
                              WHERE  SObjectType IN ('Lead','Task')
                              AND    DeveloperName IN ('GLI','GLI_Record_Type')]) {
			objectRTIdMap.put(rt.SObjectType, rt.Id);
		}
        
        // Insert a test Lead.
        Id leadRTId = objectRTIdMap.get('Lead');
        Lead testLead = new Lead(RecordTypeId = leadRTId,
                                 Company = 'Test Lead',
                                 FirstName = 'Test',
                                 LastName = 'Tester',
                                 Status = 'Unworked',
                                 Is_GLI__c = true);
        insert testLead;
        
        // Insert a test Task.
        Id taskRTId = objectRTIdMap.get('Task');
        Task testTask = new Task(RecordTypeId = taskRTId,
                                 WhoId = testLead.Id,
                                 ActivityDate = Date.today(),
                                 LCRM_Activity_Type__c = 'Email Outbound',
                                 Activity_Category__c = 'Follow Up',
                                 Subject = 'Task',
                                 Priority = 'Normal',
                                 Status = 'Completed');
        insert testTask;
        
        Test.startTest();
			
			delete testTask;
        	
        Test.stopTest();
        
        // Check the LeadActivityCountStage table and verify the Task Trigger worked.
        List<Lead_Activity_Count_Stage__c> lacsList = [SELECT Id FROM Lead_Activity_Count_Stage__c WHERE Lead__c = :testLead.Id];
		System.assertEquals(1, lacsList.size());
		
    } // End Method: testTaskAfterDelete_CompletedActivityCount()
    
}