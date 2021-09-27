@isTest
global class LCRMEventUtil_Test {
    
     static testMethod Void LCRMEventUtiltask_Test() {
        //Profile trSals = [SELECT Id FROM Profile WHERE Name =:'TR Sales'];
        Profile trSals = [Select id from profile where name = 'System Administrator'];
        UserRole gliRole = [SELECT Id FROM UserRole WHERE Name = 'GLI'];
        User gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'Testing11User1@TR.com';
        gliUser.profileid = trSals.Id;
        gliUser.Sales_Org__c ='GLI';
        gliUser.Segment__c = 'Corporate';
        gliUser.Sub_Bu__c='Canada';
        gliUser.userRoleID = gliRole.Id;
        insert gliUser;          
        
        system.RunAs(gliUser){
            List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
            KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';
            
            KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';
            
            KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';
            
            KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';
            
            kValueLst.add(kValue1);
            kValueLst.add(kValue2);
            kValueLst.add(kValue3);
            kValueLst.add(kValue4);        
            insert  kValueLst;
            
            Id pipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
            Id prePipeLinerecTypId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
            
            List<RecordtypeIds__c> recTypLst = new List<RecordtypeIds__c>();
            RecordtypeIds__c recTyp1 = new RecordtypeIds__c();
            recTyp1.Name = 'Pipeline Opportunities';
            //recTyp1.recTypeId__c = '01230000001MA4g';
            recTyp1.recTypeId__c = pipeLinerecTypId;
            
            RecordtypeIds__c recTyp2 = new RecordtypeIds__c();
            recTyp2.Name = 'Pre-Pipeline Opportunities';
            //recTyp2.recTypeId__c = '01230000001MA4h';
            recTyp2.recTypeId__c = prePipeLinerecTypId;
            
            recTypLst.add(recTyp1);
            recTypLst.add(recTyp2);
            insert recTypLst;
            Test.startTest();
            Account accObj = new Account();
            accObj.name = 'test acc';
            accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
            accObj.BU_Region__c = 'Canada';
            accObj.Bu_Segment__c = 'Professional Tax';
            accObj.Is_GLI__c = true;
            accObj.ECM_Party_ID__c = '9090909';
            insert accObj;
            
            Contact con = new Contact();
            con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
            //con.AccountID = accObj.Id;
            con.lastName = 'con';
            con.firstName = 'Test';
            insert con;
            
            //con.AccountID = accObj.Id;
            //update con; 
            
            Opportunity testOpportunity = new Opportunity();
            testOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId(); 
            testOpportunity.Name = 'Test';
            testOpportunity.AccountID = accObj.Id;
            //testOpportunity.Key_Contact__c = con.Id;
            testOpportunity.StageName = 'Qualifying';
            testOpportunity.closeDate =Date.Today().adddays(30);
            testOpportunity.LCRM_Sub_BU__c='LatAm';
            //testOpportunity.ForecastCategoryName = 'Pipeline';
            //testOpportunity.GLI
            //testOpportunity.Renewal_Flag__c = false;
            //testOpportunity.Selling_Organization__c = 'LRA';
            //testOpportunity.Expiration_Date__c = Date.Today().adddays(300);
            //testOpportunity.Expected_Revenue_Date__c = date.today();
            
            insert  testOpportunity;
            
            Lead ld = new Lead(FirstName ='Test',LastName='Lead',Company='Test');
            insert ld;
            
            List<Event> evntLst = new List<Event>();
            DateTime dt1 = datetime.newInstance(2019, 3, 11, 12, 30, 0);
            DateTime dt2 = datetime.newInstance(2019, 3, 11, 13, 30, 0);
            Event accEvnt1 = new Event(whatId=accObj.ID,DurationInMinutes=60,ActivityDateTime= dt1);
            Event oppEvnt1 = new Event(whatId=testOpportunity.Id,DurationInMinutes=60,ActivityDateTime= dt2);
            Event leadEvnt1 = new Event(whoId=ld.Id,DurationInMinutes=60,ActivityDateTime= dt2);
            evntLst.add(accEvnt1);
            evntLst.add(oppEvnt1);
            evntLst.add(leadEvnt1);
            //LCRMPopulateBuRegionSegment.populateRegionSegmentOnActvts(evntLst);    
            insert evntLst;
            
            List<Task> tskLst = new List<Task>();                 
            Task accTsk1 = new Task(whatId=accObj.ID);
            Task oppTsk1 = new Task(whatId=testOpportunity.Id);
            Task leadTsk = new Task(whoID=ld.ID);
            tskLst.add(accTsk1);
            tskLst.add(oppTsk1);
            tskLst.add(leadTsk);
            //LCRMPopulateBuRegionSegment.populateRegionSegmentOnActvts(tskLst); 
            insert tskLst;
            
            Test.stopTest(); 
            //Account acc = [select id,BU_Region__c,Bu_Segment__c from Account where ID=:accObj.ID];
            //Event ev = [select id,WhatID,BU_Segment__c,LCRM_Sub_BU__c  from Event where WhatID=:acc.ID LIMIT 1]; 
            //system.assertEquals(acc.BU_Region__c,ev.LCRM_Sub_BU__c);
            //system.assertEquals(acc.Bu_Segment__c,ev.BU_Segment__c);
            }
            
        }
        
        
        static testMethod Void copyEventAfterInserted_test() {
        try{
         Profile profileId = [Select id,name from profile where name = 'TR Sales'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            Market_Segment_Description__c='CLEAR',
            Sales_Force_Description__c='National',
            Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;  
        
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
          KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';
          
          KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';
          
          KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';
          
          KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';
           
           kValueLst.add(kValue1);
           kValueLst.add(kValue2);
           kValueLst.add(kValue3);
           kValueLst.add(kValue4);        
           if(kValueLst.size()>0){
           insert  kValueLst;
           }       
              
            list<OwnerGroup__c>   ownerlst= new list<OwnerGroup__c>();          
              OwnerGroup__c ownerval= new OwnerGroup__c();
              ownerval.name='CLEAR-National';
              ownerval.Channel__c='Investigative';
              ownerval.Market_Segment__c    ='CLEAR';
              ownerval.Sales_force_Description__c   ='National';
              ownerlst.add(ownerval);
              
              OwnerGroup__c owner_val= new OwnerGroup__c();
              owner_val.name='Division-SAM';
              owner_val.Channel__c='Westlaw';
              owner_val.Market_Segment__c    ='Division';
              owner_val.Sales_force_Description__c   ='SAM';
              ownerlst.add(owner_val);
              
              
              if(ownerlst.size()>0){
                  insert ownerlst;
              }
              
        System.debug('lstProfile **'+profileId.name );
        //create account data
        System.runAs(testUser) {
        System.debug('testUser**'+testUser);
        test.startTest();
        
        List<LOTUS_Region_and_Segmentation_Rule__mdt> listLotusProfile = new List<LOTUS_Region_and_Segmentation_Rule__mdt>([select MasterLabel,Profile_Name__c,User_Region__c, User_Segment__c from LOTUS_Region_and_Segmentation_Rule__mdt]);
        Map<String,LOTUS_Region_and_Segmentation_Rule__mdt> mapSegment = new Map<String,LOTUS_Region_and_Segmentation_Rule__mdt>();
        LIST<String> SegmentList= new LIST<String>();
        for(LOTUS_Region_and_Segmentation_Rule__mdt mdt:listLotusProfile)
        {
            mapSegment.put(mdt.MasterLabel,mdt);
            System.debug('@@printing mapsegment'+mapSegment);
        }
          List<Lotus_countrycode_region_mappings__mdt> countryCodeRegionMappingTestList = [SELECT LTS_Country_Code__c, LTS_Country_Name__c, LTS_Region__c, Id FROM Lotus_countrycode_region_mappings__mdt];
        for(Lotus_countrycode_region_mappings__mdt countryInstance : countryCodeRegionMappingTestList){
            System.debug('COUNTRY REGION'+countryInstance.LTS_Country_Code__c+':::'+countryInstance.LTS_Region__c);
            
        }
        
        List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.BU_Region__c='US'; 
            acc.Bu_Segment__c ='Corporate';          
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
            insert acc;
            accList.add(acc);
            
         List<Event> evntLst = new List<Event>();
            DateTime dt1 = datetime.newInstance(2019, 3, 11, 12, 30, 0);
            DateTime dt2 = datetime.newInstance(2019, 3, 11, 13, 30, 0);
            Event accEvnt1 = new Event(whatId=acc.ID,DurationInMinutes=60,ActivityDateTime= dt1);
            evntLst.add(accEvnt1);            
            
            insert evntLst;
        
        
        }
      }catch(exception ex){
          System.debug('Error:'+Ex);
      }
        }
        
        
        
        public static testmethod void deleteRelatedEvents_test()
    {
        
        Profile trSals = [SELECT Id FROM Profile WHERE Name =:'System Administrator'];
        UserRole gliRole = [SELECT Id FROM UserRole WHERE Name = 'GLI'];
        User gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'Testing112User1@TR.com';
        gliUser.profileid = trSals.Id;
        gliUser.Sales_Org__c ='GLI';
        gliUser.Segment__c = 'Corporate';
        gliUser.Sub_Bu__c='Canada';
        gliUser.userRoleID = gliRole.Id;
        insert gliUser;          
        
        try{
         system.RunAs(gliUser){
        
         List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
          KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';
          
          KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';
          
          KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';
          
          KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';
            
            kValueLst.add(kValue1);
           kValueLst.add(kValue2);
           kValueLst.add(kValue3);
           kValueLst.add(kValue4);        
           if(kValueLst.size()>0){
           insert  kValueLst;
           }      
        
       List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.BU_Region__c='US'; 
            acc.Bu_Segment__c ='Corporate';          
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
       //     insert acc;
            accList.add(acc);
            
            if(accList.size()>0){
                insert accList;
            }
            
             
        Contact contact = UnitTest.getContactInstance(acc.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.AccountId = acc.Id;
        insert contact;
                        
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = acc.Id;
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
        //testEvent1.WhoId = testLeadId;
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
        //testEvent2.WhatId = testOppId;
        testEvent2.StartDateTime = System.DateTime.Now();
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.ReminderDateTime = System.DateTime.Now()+3;
        listtestevents.add(testEvent2);          
        
        
        
        if(listtestevents.size()>0){
            insert listtestevents;
        }            
        test.starttest();   
           
        testEvent.Comments__c = '1234';
        testEvent.ActivityDate = System.Today()+2;
        testEvent1.ActivityDate = System.Today()+2;
        testEvent2.ActivityDate = System.Today()+2;
        testEvent.ParentActivityId__c =testEvent.id;
        testEvent1.ParentActivityId__c = testEvent1.id;
        testEvent2.ParentActivityId__c = testEvent2.id;
        
        //testEvent3.Comments__c = '1234';
//        testEvent3.ActivityDate = System.Today()+2;
        update listtestevents;
        delete listtestevents;
        test.stoptest(); 
        
               
         }
        }catch(exception ex){
            system.debug('Error**'+ex);
            
        }
    }
    
    
    //
    public static testmethod void copyEventsAfterInserted_test()    {
        
        Profile trSals = [SELECT Id FROM Profile WHERE Name =:'System Administrator'];
        UserRole gliRole = [SELECT Id FROM UserRole WHERE Name = 'GLI'];
        User gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'Testing1User01@TR.com';
        gliUser.profileid = trSals.Id;
        gliUser.Sales_Org__c ='GLI';
        gliUser.Segment__c = 'Corporate';
        gliUser.Sub_Bu__c='Canada';
        gliUser.userRoleID = gliRole.Id;
        insert gliUser;  
         try{
         system.RunAs(gliUser){
        
            List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
            KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';

            KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';

            KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';

            KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';

            kValueLst.add(kValue1);
            kValueLst.add(kValue2);
            kValueLst.add(kValue3);
            kValueLst.add(kValue4);        
            if(kValueLst.size()>0){
            insert  kValueLst;
            }      

       List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.BU_Region__c='US'; 
            acc.Bu_Segment__c ='Corporate';          
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
       //     insert acc;
            accList.add(acc);
            
             Account accval = new Account();
            accval.Is_GLI__c = true;
            accval.BillingCountry = 'US';
            accval.BU_Region__c='US'; 
            accval.Bu_Segment__c ='Corporate';          
            accval.Name = 'TESTREGIONACCOUNTval';
            accval.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();    
            accList.add(accval);
            
            if(accList.size()>0){
                insert accList;
            }            
             
        Contact con = UnitTest.getContactInstance(accval.Id);
        con.LastName = 'testContact';
        con.FirstName = 'testContact';
        con.AccountId = accval.Id;
        insert con;
                        
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        
        /*Training_Event__c testTrainingEvent1 = new Training_Event__c();
        testTrainingEvent1.Training_Name__c = 'testTrainingEvent1';
        testTrainingEvent1.Training_Date__c = System.Today();
        testTrainingEvent1.Status__c = 'Pending';
        insert testTrainingEvent1;*/
        
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = acc.Id;
        insert testTrainingEventAccount;
        
        /*Training_Event_Account__c testTrainingEventAccount1 = new Training_Event_Account__c();
        testTrainingEventAccount1.Training_Event__c = testTrainingEvent1.Id;
        testTrainingEventAccount1.Account__c = acc.Id;
        insert testTrainingEventAccount1;*/
        
        List<Event> listtestevents = new List<Event>();
        Event testEvent = new Event();
        testEvent.Owner_Group__c = 'Inside Sales';
        testEvent.Status__c = 'Pending';
        testEvent.Subject = 'test Subject';
        testEvent.WhatId = testTrainingEvent.Id;
        testEvent.WhoId = con.Id;
        testEvent.Type = 'Appointment';
        testEvent.ActivityDate = System.Today();
        testEvent.StartDateTime = System.DateTime.Now();
        testEvent.DurationInMinutes = 60;
        testEvent.Comments__c = '12';
        testEvent.ReminderDateTime = System.DateTime.Now();
        listtestevents.add(testEvent);
        //
       /* Event testEvent1 = new Event();
        testEvent1.Owner_Group__c = 'Inside Sales';
        testEvent1.Status__c = 'Pending';
        testEvent1.Subject = 'test Subject';
        testEvent1.WhoId = con.Id;
        testEvent1.Type = 'Appointment';
        testEvent1.ActivityDate = System.Today();
        testEvent1.StartDateTime = System.DateTime.Now();
        testEvent1.DurationInMinutes = 60;
        testEvent1.Comments__c = '12';
        testEvent1.ReminderDateTime = System.DateTime.Now();
        listtestevents.add(testEvent1);
        //
        
        Event testEvent2 = new Event();
        testEvent2.Owner_Group__c = 'Inside Sales';
        testEvent2.Status__c = 'Pending';
        testEvent2.Subject = 'test Subject';
        testEvent2.WhatId = testTrainingEvent1.Id;
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.StartDateTime = System.DateTime.Now();
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.ReminderDateTime = System.DateTime.Now();
        listtestevents.add(testEvent2);
        */
        if(listtestevents.size()>0){
            insert listtestevents;
        }            
        test.starttest();   
           
        testEvent.Comments__c = '1234';
        testEvent.ActivityDate = System.Today()+2;        
        update listtestevents;        
        test.stoptest();         
               
       }
       }catch(exception ex){
       system.debug('error:'+ex);
       }
       
    }
    
    
    
 public static testmethod void copyEventsAfterInserted1_test()    {
        try{
        Profile trSals = [SELECT Id FROM Profile WHERE Name =:'System Administrator'];
        UserRole gliRole = [SELECT Id FROM UserRole WHERE Name = 'GLI'];
        User gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'Testing1User01@TR.com';
        gliUser.profileid = trSals.Id;
        gliUser.Sales_Org__c ='GLI';
        gliUser.Segment__c = 'Corporate';
        gliUser.Sub_Bu__c='Canada';
        gliUser.userRoleID = gliRole.Id;
        insert gliUser;  
         system.RunAs(gliUser){
        
            List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
            KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';

            KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';

            KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';

            KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';

            kValueLst.add(kValue1);
            kValueLst.add(kValue2);
            kValueLst.add(kValue3);
            kValueLst.add(kValue4);        
            if(kValueLst.size()>0){
            insert  kValueLst;
            }      

       List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.BU_Region__c='US'; 
            acc.Bu_Segment__c ='Corporate';          
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
       //     insert acc;
            accList.add(acc);
            
             Account accval = new Account();
            accval.Is_GLI__c = true;
            accval.BillingCountry = 'US';
            accval.BU_Region__c='US'; 
            accval.Bu_Segment__c ='Corporate';          
            accval.Name = 'TESTREGIONACCOUNTval';
            accval.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();      
            accList.add(accval);
            
            if(accList.size()>0){
                insert accList;
            }            
             
        Contact con = UnitTest.getContactInstance(accval.Id);
        con.LastName = 'testContact';
        con.FirstName = 'testContact';
        con.AccountId = accval.Id;
        insert con;
                        
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        
        /*Training_Event__c testTrainingEvent1 = new Training_Event__c();
        testTrainingEvent1.Training_Name__c = 'testTrainingEvent1';
        testTrainingEvent1.Training_Date__c = System.Today();
        testTrainingEvent1.Status__c = 'Pending';
        insert testTrainingEvent1;*/
        
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = acc.Id;
        insert testTrainingEventAccount;
        
        /*Training_Event_Account__c testTrainingEventAccount1 = new Training_Event_Account__c();
        testTrainingEventAccount1.Training_Event__c = testTrainingEvent1.Id;
        testTrainingEventAccount1.Account__c = acc.Id;
        insert testTrainingEventAccount1;*/
        
        List<Event> listtestevents = new List<Event>();
        Event testEvent = new Event();
        testEvent.Owner_Group__c = 'Inside Sales';
        testEvent.Status__c = 'Pending';
        testEvent.Subject = 'test Subject';
        testEvent.WhatId = testTrainingEvent.Id;
        testEvent.WhoId = con.Id;
        testEvent.Type = 'Appointment';
        testEvent.ActivityDate = System.Today();
        testEvent.StartDateTime = System.DateTime.Now();
        testEvent.DurationInMinutes = 60;
        testEvent.Comments__c = '12';
        testEvent.ReminderDateTime = System.DateTime.Now();
        listtestevents.add(testEvent);
        //
       /* Event testEvent1 = new Event();
        testEvent1.Owner_Group__c = 'Inside Sales';
        testEvent1.Status__c = 'Pending';
        testEvent1.Subject = 'test Subject';
        testEvent1.WhoId = con.Id;
        testEvent1.Type = 'Appointment';
        testEvent1.ActivityDate = System.Today();
        testEvent1.StartDateTime = System.DateTime.Now();
        testEvent1.DurationInMinutes = 60;
        testEvent1.Comments__c = '12';
        testEvent1.ReminderDateTime = System.DateTime.Now();
        listtestevents.add(testEvent1);
        //
        
        Event testEvent2 = new Event();
        testEvent2.Owner_Group__c = 'Inside Sales';
        testEvent2.Status__c = 'Pending';
        testEvent2.Subject = 'test Subject';
        testEvent2.WhatId = testTrainingEvent1.Id;
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.StartDateTime = System.DateTime.Now();
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.ReminderDateTime = System.DateTime.Now();
        listtestevents.add(testEvent2);
        */
        if(listtestevents.size()>0){
            insert listtestevents;
        }            
        test.starttest();   
           
        testEvent.Comments__c = '1234';
        testEvent.ActivityDate = System.Today()+2;        
        update listtestevents;        
        test.stoptest(); 
                
               
       }
       }catch(exception ex){
        system.debug('Error:'+ex);
        }
    }
    
   
    @isTest static void testXrefAccountSegmentLoadBatch21(){
     
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
            acc.Name = 'TESTACCOUNT_Xref';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BU_Segment__c ='Professional Tax';
            acc.BU_Region__c = 'US';
            accList.add(acc);
           
            
            if(accList.size()>0)
            insert accList;
            
            Contact testContact = new Contact();
         testContact.FirstName='TestFirst';
         testContact.LastName='Lastname';
         testContact.Email='test@tr.com';
         testContact.AccountId=accList[0].id;
         insert testContact;
         
        List<Training_Event__c> evntLst = new List<Training_Event__c>();
        Training_Event__c trnEvnt = new Training_Event__c();
          trnEvnt.Training_Name__c = 'Test1';
          trnEvnt.Account__c = accList[0].Id;
          trnEvnt.LCRM_Sub_BU__c ='Canada';
          trnEvnt.BU_Segment__c ='Corporate';
          trnEvnt.LCRM_Is_GLI__c =TRUE;
          evntLst.add(trnEvnt);
          insert evntLst;
          
          
          List<Event> listtestevents = new List<Event>();
        Event testEvent = new Event();
        testEvent.Owner_Group__c = 'Inside Sales';
        testEvent.Status__c = 'Pending';
        testEvent.Subject = 'test Subject';
        testEvent.WhatId = trnEvnt.Id;
        testEvent.WhoId = testContact.Id;
        testEvent.Type = 'Appointment';
        testEvent.ActivityDate = System.Today();
        testEvent.StartDateTime = System.DateTime.Now();
        testEvent.DurationInMinutes = 60;
        testEvent.Comments__c = '12';
        testEvent.ReminderDateTime = System.DateTime.Now();
        listtestevents.add(testEvent);
        
                if(listtestevents.size()>0){
            insert listtestevents;
        }            
        test.starttest();   
           
        testEvent.Comments__c = '1234';
        testEvent.ActivityDate = System.Today()+2;        
        update listtestevents;        
        test.stoptest();
        
}

static testMethod Void copyEventAfterInserted1_test() {
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
        
    
              
            list<OwnerGroup__c>   ownerlst= new list<OwnerGroup__c>();          
              OwnerGroup__c ownerval= new OwnerGroup__c();
              ownerval.name='CLEAR-National';
              ownerval.Channel__c='Investigative';
              ownerval.Market_Segment__c    ='CLEAR';
              ownerval.Sales_force_Description__c   ='National';
              ownerlst.add(ownerval);
              
              OwnerGroup__c owner_val= new OwnerGroup__c();
              owner_val.name='Division-SAM';
              owner_val.Channel__c='Westlaw';
              owner_val.Market_Segment__c    ='Division';
              owner_val.Sales_force_Description__c   ='SAM';
              ownerlst.add(owner_val);
              
              
              if(ownerlst.size()>0){
                  insert ownerlst;
              }
              
        
        //create account data
        test.startTest();
        
        List<LOTUS_Region_and_Segmentation_Rule__mdt> listLotusProfile = new List<LOTUS_Region_and_Segmentation_Rule__mdt>([select MasterLabel,Profile_Name__c,User_Region__c, User_Segment__c from LOTUS_Region_and_Segmentation_Rule__mdt]);
        Map<String,LOTUS_Region_and_Segmentation_Rule__mdt> mapSegment = new Map<String,LOTUS_Region_and_Segmentation_Rule__mdt>();
        LIST<String> SegmentList= new LIST<String>();
        for(LOTUS_Region_and_Segmentation_Rule__mdt mdt:listLotusProfile)
        {
            mapSegment.put(mdt.MasterLabel,mdt);
            System.debug('@@printing mapsegment'+mapSegment);
        }
          List<Lotus_countrycode_region_mappings__mdt> countryCodeRegionMappingTestList = [SELECT LTS_Country_Code__c, LTS_Country_Name__c, LTS_Region__c, Id FROM Lotus_countrycode_region_mappings__mdt];
        for(Lotus_countrycode_region_mappings__mdt countryInstance : countryCodeRegionMappingTestList){
            System.debug('COUNTRY REGION'+countryInstance.LTS_Country_Code__c+':::'+countryInstance.LTS_Region__c);
            
        }
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
            
         List<Event> evntLst = new List<Event>();
            DateTime dt1 = datetime.newInstance(2019, 3, 11, 12, 30, 0);
            DateTime dt2 = datetime.newInstance(2019, 3, 11, 13, 30, 0);
            Event accEvnt1 = new Event(whatId=acc.ID,DurationInMinutes=60,ActivityDateTime= dt1);
            evntLst.add(accEvnt1);            
            
            insert evntLst;
        
        
        
      
        }
        
        public static testmethod void deleteRelatedEvents1_test()    {
        
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
            acc.Name = 'TESTACCOUNT_Xref';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BU_Segment__c ='Professional Tax';
            acc.BU_Region__c = 'US';
            accList.add(acc);
           
            
            if(accList.size()>0)
            insert accList;
            
             
        Contact contact = UnitTest.getContactInstance(acc.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.AccountId = acc.Id;
        insert contact;
                        
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = acc.Id;
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
        //testEvent1.WhoId = testLeadId;
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
        //testEvent2.WhatId = testOppId;
        testEvent2.StartDateTime = System.DateTime.Now();
        testEvent2.DurationInMinutes = 60;
        testEvent2.Comments__c = '12';
        testEvent2.Type = 'Appointment';
        testEvent2.ActivityDate = System.Today();
        testEvent2.ReminderDateTime = System.DateTime.Now()+3;
        listtestevents.add(testEvent2);          
        
        
        
        if(listtestevents.size()>0){
            insert listtestevents;
        }            
        test.starttest();   
           
        testEvent.Comments__c = '1234';
        testEvent.ActivityDate = System.Today()+2;
        testEvent1.ActivityDate = System.Today()+2;
        testEvent2.ActivityDate = System.Today()+2;
        testEvent.ParentActivityId__c =testEvent.id;
        testEvent1.ParentActivityId__c = testEvent1.id;
        testEvent2.ParentActivityId__c = testEvent2.id;
        
        //testEvent3.Comments__c = '1234';
//        testEvent3.ActivityDate = System.Today()+2;
        update listtestevents;
        delete listtestevents;
        test.stoptest(); 
        
               
         
        
    }
        
      }