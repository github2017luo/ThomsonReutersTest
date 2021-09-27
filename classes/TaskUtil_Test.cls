@istest
public class TaskUtil_Test{


 static testmethod void pullTasksToAccountContactLeadActivitiesTest(){
     
      KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        
        KeyValueListStore__c tempValueStore = new KeyValueListStore__c(Name = 'LCRMStrikeIronInformaticaUsers', Textvalue__c = 'Test GLI User' ,Failure_Email__c ='Test');
        insert tempValueStore;
     
      Account acc = new Account();
        acc.Name = 'Acme Account Test';
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'US';
        acc.BillingState = 'IL';
        insert acc;
        
         Account acc1 = new Account();
        acc1.Name = 'Acme Account Test';
        acc1.BillingCountry = 'US';
        acc1.ShippingCountry = 'US';
        acc1.BillingState = 'IL';
        insert acc1;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= acc.id; 
        insert con;
        
        Contact con1= new Contact();
        con1.FirstNAme= 'TEst1';
        con1.LastNAme= 'Test2';
        con1.AccountId= acc1.id; 
        insert con1;
       
       //List<Lead> testLeads = new List<Lead>();
        Lead lead = new Lead();
        lead.Company = 'Test 1 New Company';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';       
        lead.LeadSource = 'Not Converted';
        //testLeads.add(lead1);
        insert lead;
     
         Training_Event__c testTE =UnitTest.getTrainingEventInstance();
         insert testTE;
         
        
        
        
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(
        ActivityDate = Date.today().addDays(7),
        Subject='Sample Task',        
        whoId= lead.id,     
        OwnerId = UserInfo.getUserId(),
        Status='In Progress'));
        
        tasks.add(new Task(
        Owner_Group__c = 'Inside Sales',
        Status__c = 'Pending',
        Status = 'Pending',
        Subject = 'test Subject',
        WhatId = testTE.Id,
        whoId= con1.id,
        Type = 'Outbound Call',
        ActivityDate = System.Today(),
        ReminderDateTime = System.DateTime.Now()));
        
        tasks.add(new Task(
        Owner_Group__c = 'Inside Sales',
        Status__c = 'Pending',
        Status = 'Pending',
        Subject = 'test Subject',
        WhatId = testTE.Id,
        whoId= con.id,
        Type = 'Outbound Call',
        ActivityDate = System.Today(),
        ReminderDateTime = System.DateTime.Now()));
        
        tasks.add(new Task(
        Owner_Group__c = 'Inside Sales',
        Status__c = 'Pending',
        Status = 'Pending',
        Subject = 'test Subject',
        WhatId = acc.Id,
        whoId= con.id,
        Type = 'Outbound Call',
        ActivityDate = System.Today(),
        ReminderDateTime = System.DateTime.Now()));
        

        insert tasks;
        
        tasks[0].subject= 'test sub';
        update tasks[0];
     
     
        Training_Event_Account__c tacc = new Training_Event_Account__c();
        tacc.Account__c = acc.id;       
        tacc.Training_Event__c = tasks[1].WhatId;
        insert tacc;
     
        Id aId = acc.Id;
         List<Task> taskRecords = [Select Id, WhatId, Subject from Task where WhatId = :aId]; 
        
        List<Lead> listLeads=new List<Lead>();
        List<ID> listActivityIds=new List<ID>();
        List<ID> listRelatedOptyId=new List<ID>();
        List<ID> listRelatedLeadId=new List<ID>();
        listRelatedLeadId.add(Lead.Id);
        listLeads  = [Select Id ,Name ,Next_Call_Date__c from Lead where Id in :listRelatedLeadId];
     
        
     
        //Insert
        AccountLeadActivity__c acctLeadActivity=new AccountLeadActivity__c();
        insert acctLeadActivity; 
        
        ContactLeadActivity__c conLeadActivity = new ContactLeadActivity__c();
        insert conLeadActivity;
        
        //Update
        AccountLeadActivity__c acctLeadActivityUpdate=new AccountLeadActivity__c();
        acctLeadActivityUpdate.due_date__c=Date.today();
        acctLeadActivityUpdate.Status__c= 'In Progress';
                                          
        acctLeadActivityUpdate.Related_To_Account__c =acc.id;                    
        acctLeadActivityUpdate.Subject__c = 'Test1';
        acctLeadActivityUpdate.Lead__c= lead.id;
        //acctLeadActivityUpdate.TaskId__c=tasks.id;
        acctLeadActivityUpdate.Comments__c='Test1' ;
        acctLeadActivityUpdate.type__c= 'Test1';
        
        insert acctLeadActivityUpdate; 
        map<id,task> newMap=new map<id,task>();
        map<id,task> oldMap=new map<id,task>();
        List<Task> newTaskList= new List<Task>();
        
                
        List<ID> listInsertedActivityIds=new List<ID>();
        
       ContactLeadActivity__c conLeadActivityupdate = new ContactLeadActivity__c();               
       conLeadActivityupdate .Call_Type__c = 'Cont1';
       conLeadActivityupdate .due_date__c= Date.today();
       conLeadActivityupdate .Status__c= 'In Progress';
                                     
       conLeadActivityupdate .Related_To_Contact__c =con.id ;                    
       conLeadActivityupdate .Subject__c = 'Cont1';
       conLeadActivityupdate .Lead__c=lead.id;
       //conLeadActivityupdate .TaskId__c=tasks.id;
       conLeadActivityupdate .Comments__c= 'Comment1';
       conLeadActivityupdate .Type__c='Type1' ;
       //conLeadActivityupdate .Activity_Owner__c= tasks.OwnerId;
                     
       insert conLeadActivityupdate ; 
       
    
         Profile p = [SELECT Id FROM Profile WHERE Name='UKI Users'];
         
         User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8',
                           LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,Sales_Force_Description__c='TEST',Market_Segment_Description__c= 'TEST',
                           TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal123.com',Sub_Bu__c='UKI');
        insert u;
        Map<id,task> newMapAfterUpdate = new Map<id,task>();
         
        
     Test.startTest();
     system.runas(u){
         TaskUtil.deleteRelatedTasks(tasks);
         TaskUtil.UpdateNextCallDate_Future(listInsertedActivityIds,'EVENT');
         TaskUtil.UpdateNextCallDateOnDelete(listActivityIds, listRelatedOptyId, listRelatedLeadId, 'Event');
         TaskUtil.copyTaskAfterInserted(tasks);      
         TaskUtil.deleteTasksToContactLeadActivities(tasks,newMap,oldMap,true,true);
         TaskUtil.deleteTasksToAccountLeadActivities(tasks, newMap, oldMap,true, true);
         TaskUtil.pullTasksToAccountContactLeadActivities(newTaskList, newMap,oldMap,true,true,true,true);
     }
     Test.stopTest();
     

}

//Created as a part of CRM - 11169 for TaskBeforeEventListener code coverage

private static testmethod void inserttasksTest(){
     
    
    UnitTest.createTestData();
     Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        Contact testcon = UnitTest.getContactInstance(testAcc1 .Id);
        insert testcon;
          
        Training_Event__c testTE =UnitTest.getTrainingEventInstance();
        insert testTE;
        
        Training_Event_Contact__c tec1 = new Training_Event_Contact__c(Training_Event__c=testTE.Id, Contact_Name__c=testcon.Id,LCRM_Send_Survey__c =true,LCRM_Send_Reminder__c =true );
         insert tec1;
   
    
    
        List<Opportunity> listOpportunity=new List<Opportunity>();
        
        Opportunity testOpty= UnitTest.getOpportunityInstance(testAcc1 .Id);
        
        insert testOpty;
        listOpportunity.add(testOpty);
         
            
        List<ID> listActivityIds=new List<ID>();
        List<ID> listRelatedOptyId=new List<ID>();
        List<ID> listRelatedLeadId=new List<ID>();
        listRelatedOptyId.add(testOpty.Id);
        listOpportunity  = [Select Id ,Name ,Next_Call_Date__c from Opportunity where Id in :listRelatedOptyId];
        
        
        
        incentive_promotion__c testIPC = new incentive_promotion__c(Training_Event__c=testTE.id,account__C=testAcc1.id,opportunity__c = testOpty.id);
        insert testIPC;
        Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today(),LCRM_Training_Event__c=testTE.id);
        insert testIPD;
        
        Incentive_Password__c testIPD1 = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today(),LCRM_Account__c=testAcc1.id);
        insert testIPD1;
        
        Incentive_Password__c testIPD2 = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today(),LCRM_Opportunity__c=testOpty.id);
        insert testIPD2;
        
        
        IncentivePasswordController.Trainingeventtask = true;
        IncentivePasswordController.LCRMSubBu ='USL';
    IncentivePasswordController.sendEmailcheck = true;
        IncentivePasswordControllerOpty.sendEmailcheck = true;
        
        
        
         //Added to fix the build failure while deploying LCRM Updating custom Status Field with the standard status field Value Process builder

         recordtype  taskrecordtype = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND Name = 'S2E Record Type'];
        
        Test.startTest();
        
        Task oTask = new Task();     
        oTask .ActivityDate = Date.today();
        oTask .Subject='Sample Task';
        oTask .WhatId = testIPD.Id;
        oTask .Status='In Progress';
        oTask .Status__c='In Progress';
        oTask .RecordTypeId  =taskrecordtype .Id;
        
        insert oTask;
        
        
        IncentivePasswordController.Trainingeventtask = false;
        IncentivePasswordController.Accounttask =true;
        
        
        Task tasks1 = new Task();     
        tasks1 .ActivityDate = Date.today();
        tasks1 .Subject='Sample Task';
        tasks1 .WhatId = testIPD1.Id;
        tasks1 .Status='In Progress';
        tasks1.Status__c='In Progress';
        tasks1 .RecordTypeId =taskrecordtype .Id ;
        insert tasks1 ;
        
        
        IncentivePasswordController.Trainingeventtask = false;
        IncentivePasswordController.Accounttask =false;
        IncentivePasswordControllerOpty.opptytask =true;
        
        Task tasks2 = new Task();     
        tasks2 .ActivityDate = Date.today();
        tasks2 .Subject='Sample Task';
        tasks2 .WhatId = testIPD2.Id;
        tasks2 .Status='In Progress';
        tasks2.Status__c='In Progress';
        tasks2 .RecordTypeId =taskrecordtype .Id ;
        insert tasks2;
       
        Test.stopTest();
        TaskUtil.UpdateNextCallDateOnDelete(listActivityIds, listRelatedOptyId, listRelatedLeadId, 'Event');
        
     
     }
     //Created as a part of CRM -12068 for TaskBeforeEventListener code coverage

private static testmethod void inserttasksTest1(){
     
    Test.startTest();
    UnitTest.createTestData();
     Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        
          
         recordtype  taskrecordtype = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND Name = 'GLI Record Type'];
        
        
        Task oTask = new Task();     
        oTask .ActivityDate = Date.today();
        oTask .Subject='Email:Test';
        oTask .WhatId = testAcc1.Id;
        oTask .Status='Completed';
        oTask .Status__c='Completed';
        oTask .RecordTypeId  =taskrecordtype .Id;
        
        insert oTask;
        System.assertNotEquals(oTask.Id, null);
        
        Task oTask1 = new Task();     
        oTask1 .ActivityDate = Date.today();
        oTask1 .Subject='60-Day Onboarding';
        oTask1 .WhatId = testAcc1.Id;
        oTask1 .Status='Completed';
        oTask1 .Status__c='Completed';
        oTask1 .RecordTypeId  =taskrecordtype .Id;
        oTask1 .Description='Offer Code 704330 Test';
        
        insert oTask1;
        System.assertNotEquals(oTask1.Id, null);
        
        Event oevent= new Event();     
        oevent.activitydatetime=system.now();
        oevent.Subject='60-Day Onboarding';
         oevent.DurationInMinutes=60;
        
        oevent.Status__c='Completed';
        
        
        insert oevent;
              
              
        List<Task> otaskemail =[Select Id,Status,LCRM_Activity_Type__c,WhatId  from task where Id =:oTask.Id];
        System.assertEquals(otaskemail [0].Status,'Completed');
        System.assertEquals(otaskemail [0].LCRM_Activity_Type__c ,'Email Outbound');
    
        Test.stopTest();
        
     
     }
     
     //Created as a part of CRM - 11169 for TaskBeforeEventListener code coverage

private static testmethod void inserttasksTest2(){
     
    
    UnitTest.createTestData();
    
     Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        Contact testcon = UnitTest.getContactInstance(testAcc1 .Id);
        insert testcon;
          
        Training_Event__c testTE =UnitTest.getTrainingEventInstance();
        insert testTE;
        
        Training_Event_Contact__c tec1 = new Training_Event_Contact__c(Training_Event__c=testTE.Id, Contact_Name__c=testcon.Id,LCRM_Send_Survey__c =true,LCRM_Send_Reminder__c =true );
         insert tec1;
   
        
        List<Opportunity> listOpportunity=new List<Opportunity>();
        
        Opportunity testOpty= UnitTest.getOpportunityInstance(testAcc1 .Id);
        
        insert testOpty;
        listOpportunity.add(testOpty);
         
            
        List<ID> listActivityIds=new List<ID>();
        List<ID> listRelatedOptyId=new List<ID>();
        List<ID> listRelatedLeadId=new List<ID>();
        listRelatedOptyId.add(testOpty.Id);
        listOpportunity  = [Select Id ,Name ,Next_Call_Date__c from Opportunity where Id in :listRelatedOptyId];
        
        
        
        incentive_promotion__c testIPC = new incentive_promotion__c(Training_Event__c=testTE.id,account__C=testAcc1.id,opportunity__c = testOpty.id);
        insert testIPC;
        Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today(),LCRM_Training_Event__c=testTE.id);
        insert testIPD;
        
        Incentive_Password__c testIPD1 = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today(),LCRM_Account__c=testAcc1.id);
        insert testIPD1;
        
        Incentive_Password__c testIPD2 = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today(),LCRM_Opportunity__c=testOpty.id);
        insert testIPD2;
        
        
        
        
        
         //Added to fix the build failure while deploying LCRM Updating custom Status Field with the standard status field Value Process builder

         recordtype  taskrecordtype = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND Name = 'S2E Record Type'];
        
        Test.startTest();
        
        
        
        
        
        //Added as part of CRM -11533
        IncentivePasswordController.sendEmailcheck = true;
        IncentivePasswordControllerOpty.sendEmailcheck = true;
        LCRMMassEditTrainingContacts.surveyEmail =true;
        LCRMMassEditTrainingContacts.mysubBu ='USL';
        
        Task tasks3 = new Task();     
        tasks3 .ActivityDate = Date.today();
        tasks3 .Subject='Survey Email';
        tasks3 .WhatId = testIPD2.Id;
        tasks3 .Status='In Progress';
        tasks3 .RecordTypeId =taskrecordtype .Id ;
        tasks3 .Status__c='In Progress';
        
        insert tasks3 ; 
        
        Test.stopTest(); 
        
        
         //Added as part of CRM -10938
         
        LCRMMassEditTrainingContacts.uslreminderEmail=true;
        
         
         
         
        Task tasks4 = new Task();     
        tasks4 .ActivityDate = Date.today();
        tasks4 .Subject='Sample Task';
        tasks4 .WhatId = tec1.Id;
       tasks4 .Status='In Progress';
        tasks4 .RecordTypeId =taskrecordtype .Id ;
        tasks4 .Status__c='In Progress';
        
        insert tasks4 ;  
        System.assertNotEquals(tasks4 .Id, null);
        
        
       
        List<Task> otaskemail =[Select Id,Status,LCRM_Activity_Type__c,WhatId  from task where Id =:tasks3 .Id or Id =:tasks4 .Id Order By Id];
        System.assertEquals(otaskemail[1].WhatId ,testTE.Id);
        System.assertEquals(otaskemail [0].Status,'Completed');
        System.assertEquals(otaskemail [0].LCRM_Activity_Type__c ,  'Training');
    
        TaskUtil.UpdateNextCallDateOnDelete(listActivityIds, listRelatedOptyId, listRelatedLeadId, 'Event');
        
     
     }
      static testmethod void pullTasksToSAccountContactLeadActivitiesTest(){
     
      KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        
        KeyValueListStore__c tempValueStore = new KeyValueListStore__c(Name = 'LCRMStrikeIronInformaticaUsers', Textvalue__c = 'Test GLI User' ,Failure_Email__c ='Test');
        insert tempValueStore;
     
      Account acc = new Account();
        acc.Name = 'Acme Account Test';
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'US';
        acc.BillingState = 'IL';
        insert acc;
        
         Account acc1 = new Account();
        acc1.Name = 'Acme Account Test';
        acc1.BillingCountry = 'US';
        acc1.ShippingCountry = 'US';
        acc1.BillingState = 'IL';
        insert acc1;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        Contact con= new Contact();
        con.FirstNAme= 'TEst1';
        con.LastNAme= 'Test2';
        con.AccountId= acc.id; 
        insert con;
        
        Contact con1= new Contact();
        con1.FirstNAme= 'TEst1';
        con1.LastNAme= 'Test2';
        con1.AccountId= acc1.id; 
        insert con1;
        
        /*Opportunity testOpp  = Unittest.getOpportunityInstance(acc.Id);
        insert testOpp;
        
        Event testEvent2 = new Event();
        testEvent2.Owner_Group__c = 'Inside Sales';
        testEvent2.Status__c = 'Pending';
        
        testEvent2.Subject = 'test Subject';
        testEvent2.WhatId = testOpp.id;
        testEvent2.whoId = con.id;
        testEvent2.StartDateTime = System.DateTime.Now();
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.ReminderDateTime = System.DateTime.Now()+3;
        
        insert testEvent2;*/
       
       //List<Lead> testLeads = new List<Lead>();
        Lead lead = new Lead();
        lead.Company = 'Test 1 New Company';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';       
        lead.LeadSource = 'Not Converted';
        //testLeads.add(lead1);
        insert lead;
     
         Training_Event__c testTE =UnitTest.getTrainingEventInstance();
         insert testTE;
         
        
        
        
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(
        ActivityDate = Date.today().addDays(7),
        Subject='Sample Task',        
        whoId= lead.id,     
        OwnerId = UserInfo.getUserId(),
        Status='In Progress'));
        
        tasks.add(new Task(
        Owner_Group__c = 'Inside Sales',
        Status__c = 'Pending',
        Status = 'Pending',
        Subject = 'test Subject',
        WhatId = testTE.Id,        
        Type = 'Outbound Call',
        ActivityDate = System.Today(),
        ReminderDateTime = System.DateTime.Now()));
        
        tasks.add(new Task(
        Owner_Group__c = 'Inside Sales',
        Status__c = 'Pending',
        Status = 'Pending',
        Subject = 'test Subject',
        WhatId = testTE.Id,        
        Type = 'Outbound Call',
        ActivityDate = System.Today(),
        ReminderDateTime = System.DateTime.Now()));
        
        tasks.add(new Task(
        Owner_Group__c = 'Inside Sales',
        Status__c = 'Pending',
        Status = 'Pending',
        Subject = 'test Subject',
        WhatId = acc.Id,        
        Type = 'Outbound Call',
        ActivityDate = System.Today(),
        ReminderDateTime = System.DateTime.Now()));
        

        insert tasks;
        
        tasks[0].subject= 'test sub';
        update tasks[0];
     
     
        Training_Event_Account__c tacc = new Training_Event_Account__c();
        tacc.Account__c = acc.id;       
        tacc.Training_Event__c = tasks[1].WhatId;
        insert tacc;
     
        Id aId = acc.Id;
         List<Task> taskRecords = [Select Id, WhatId, Subject from Task where WhatId = :aId]; 
        
        List<Lead> listLeads=new List<Lead>();
        List<ID> listActivityIds=new List<ID>();
        List<ID> listRelatedOptyId=new List<ID>();
        List<ID> listRelatedLeadId=new List<ID>();
        listRelatedLeadId.add(Lead.Id);
        listLeads  = [Select Id ,Name ,Next_Call_Date__c from Lead where Id in :listRelatedLeadId];
     
        
     
        //Insert
        AccountLeadActivity__c acctLeadActivity=new AccountLeadActivity__c();
        insert acctLeadActivity; 
        
        ContactLeadActivity__c conLeadActivity = new ContactLeadActivity__c();
        insert conLeadActivity;
        
        //Update
        AccountLeadActivity__c acctLeadActivityUpdate=new AccountLeadActivity__c();
        acctLeadActivityUpdate.due_date__c=Date.today();
        acctLeadActivityUpdate.Status__c= 'In Progress';
                                          
        acctLeadActivityUpdate.Related_To_Account__c =acc.id;                    
        acctLeadActivityUpdate.Subject__c = 'Test1';
        acctLeadActivityUpdate.Lead__c= lead.id;
        //acctLeadActivityUpdate.TaskId__c=tasks.id;
        acctLeadActivityUpdate.Comments__c='Test1' ;
        acctLeadActivityUpdate.type__c= 'Test1';
        
        insert acctLeadActivityUpdate; 
        map<id,task> newMap=new map<id,task>();
        map<id,task> oldMap=new map<id,task>();
        List<Task> newTaskList= new List<Task>();
        
                
        List<ID> listInsertedActivityIds=new List<ID>();
        
       ContactLeadActivity__c conLeadActivityupdate = new ContactLeadActivity__c();               
       conLeadActivityupdate .Call_Type__c = 'Cont1';
       conLeadActivityupdate .due_date__c= Date.today();
       conLeadActivityupdate .Status__c= 'In Progress';
                                     
       conLeadActivityupdate .Related_To_Contact__c =con.id ;                    
       conLeadActivityupdate .Subject__c = 'Cont1';
       conLeadActivityupdate .Lead__c=lead.id;
       //conLeadActivityupdate .TaskId__c=tasks.id;
       conLeadActivityupdate .Comments__c= 'Comment1';
       conLeadActivityupdate .Type__c='Type1' ;
       //conLeadActivityupdate .Activity_Owner__c= tasks.OwnerId;
                     
       insert conLeadActivityupdate ; 
       
    
         Profile p = [SELECT Id FROM Profile WHERE Name='UKI Users'];
         
         User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8',
                           LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,Sales_Force_Description__c='TEST',Market_Segment_Description__c= 'TEST',
                           TimeZoneSidKey='America/Los_Angeles',UserName='testus12er@trpcorelegal123.com',Sub_Bu__c='UKI');
        insert u;
        Map<id,task> newMapAfterUpdate = new Map<id,task>();
         
        
     Test.startTest();
     system.runas(u){
         TaskUtil.deleteRelatedTasks(tasks);
         TaskUtil.UpdateNextCallDate_Future(listInsertedActivityIds,'EVENT');
         TaskUtil.UpdateNextCallDateOnDelete(listActivityIds, listRelatedOptyId, listRelatedLeadId, 'Event');
         TaskUtil.copyTaskAfterInserted(tasks);      
         TaskUtil.deleteTasksToContactLeadActivities(tasks,newMap,oldMap,true,true);
         TaskUtil.deleteTasksToAccountLeadActivities(tasks, newMap, oldMap,true, true);
         TaskUtil.pullTasksToAccountContactLeadActivities(newTaskList, newMap,oldMap,true,true,true,true);
     }
     Test.stopTest();
     

}



    
}