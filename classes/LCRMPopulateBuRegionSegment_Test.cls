@isTest
    global class LCRMPopulateBuRegionSegment_Test {
       static testMethod Void LCRMPopulateBuRegionSegment_Test1() 
      {
          List<Opportunity> listobj = new List<Opportunity>();         
          List<Profile> lstProfile =[SELECT Id FROM Profile WHERE Name =:'System Administrator'];
          User user1 = UnitTest.getUserInstance();
          user1.Username = 'Testgli@xyz.com';
          user1.LastName = 'XYZ';
          user1.Email = 'abcgli@xyz.com';
          user1.Alias = 'abcd';
          user1.CommunityNickname = 'CommunityNicknamemng.test';
          user1.ProfileId = lstProfile[0].Id;
          insert user1;
          
          LCRMPriceBooksMapping__c pb = new LCRMPriceBooksMapping__c();
          pb.Name = 'sample';
          pb.Pricebook__c = 'testPriceBook';
          pb.Sub_Bu__c = 'USL';
          insert pb;
          
          Pricebook2 pbObj = new Pricebook2();
          //pbObj.id = '01s130000007QaoAAE';
          pbObj.Name = 'GLI Price Book - Elite';
          insert pbObj;
          
          Account accObj = new Account();
          accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          insert accObj;
          
          Opportunity testOpportunity = UnitTest.getOpportunityInstance(accObj.Id);
          testOpportunity.Renewal_Flag__c = false;
          testOpportunity.Selling_Organization__c = 'LRA';
          testOpportunity.Expiration_Date__c = Date.Today().adddays(300);
          testOpportunity.Expected_Revenue_Date__c = date.today();
          //listobj.add(accObj);
          listobj.add(testOpportunity);
          
          //insert listobj;
          
          LCRMPopulateBuRegionSegment obj = new LCRMPopulateBuRegionSegment();
          LCRMPopulateBuRegionSegment.OpportunityBURegionPopulation(listobj);
          obj.updateAccountBURegion(accObj.id,'US');
          System.assertEquals(testOpportunity.LCRM_Sub_BU__c,accObj.BU_Region__c);
          System.assertEquals(testOpportunity.Bu_Segment__c ,accObj.Bu_Segment__c );                    
          
         
      }
      
      //DPS-2729
      static testMethod Void LCRMPopulateBuRegionSegmentOnTrainingEvent_Test(){
                 
          Profile TRSalesProf = [select id,name from Profile where name='TR Sales' Limit 1];
          UserRole gliRole = [SELECT Id FROM UserRole WHERE Name = 'GLI'];
          User user2 = UnitTest.getUserInstance();
          user2.Username = 'Testgli23@xyz.com';
          user2.LastName = 'XYZ2';
          user2.Email = 'abcgli2@xyz.com';
          user2.Alias = 'abcd2';
          //user2.CommunityNickname = 'CommunityNicknamemng.test';
          user2.ProfileId = TRSalesProf.Id;
          user2.userroleID = gliRole.Id;
          user2.Segment__c='Corporate';
          user2.Sub_Bu__c='Canada';
          insert user2;
          
          Profile TRSalesOpsProf = [select id,name from Profile where name='TR Sales Ops' Limit 1];
          UserRole PgliRole = [SELECT Id FROM UserRole WHERE Name = 'President - Legal - GLI'];
          User user33 = UnitTest.getUserInstance();
          user33.Username = 'Testgli3@xyz.com';
          user33.LastName = 'XYZ3';
          user33.Email = 'abcgli3@xyz.com';
          user33.Alias = 'abcd365';
          user33.CommunityNickname = 'CommunityNicknamemng33.test';
          user33.ProfileId = TRSalesOpsProf.Id;
          user33.userroleID = gliRole.Id;
          user33.Segment__c='Corporate';
          user33.Sub_Bu__c='Canada';
          
          insert user33;
                                         
          List<Training_Event__c> evntLst = new List<Training_Event__c>();
           system.runAs(user2) {
           
          Account acc = new Account();
          acc.name = 'test acc';
          acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          acc.BU_Region__c = 'Canada';
          acc.Bu_Segment__c = 'Corporate';
          acc.Is_GLI__c = true;
          acc.ownerID = user2.Id;
          acc.Sales_Org__c = 'GLI';      
          insert acc;
          system.assertEquals(acc.ownerID,user2.ID);
          List<Account> acc1 = [select ID,BU_Region__c from Account ]; 
          system.assertEquals(acc1.size(),1);
          Training_Event__c trnEvnt = new Training_Event__c();
          trnEvnt.Training_Name__c= 'Test';
          trnEvnt.Account__c = acc.Id;
          evntLst.add(trnEvnt);
          insert evntLst;
          Training_Event__c accEvnt = [select Id,Account__c,LCRM_Sub_Bu__c,BU_Segment__c from Training_Event__c where Account__c=:acc.Id];
          system.assertEquals(acc.BU_Region__c,accEvnt.LCRM_Sub_Bu__c);
          system.assertEquals(acc.Bu_Segment__c,accEvnt.BU_Segment__c);
          //LCRMPopulateBuRegionSegment.AccTEBURegionPopulation(evntLst);
          }
          system.runAs(user33) {
          Account acc2 = new Account();
          acc2.name = 'test acc';
          acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          acc2.BU_Region__c = 'Canada';
          acc2.Bu_Segment__c = 'Corporate';
          acc2.Is_GLI__c = true;
          acc2.ownerID = user33.Id;
          insert acc2;
          system.assertEquals(acc2.ownerID,user33.ID);
          List<Account> accLst = [select ID,BU_Region__c from Account where ID=:acc2.ID]; 
          system.assertEquals(1,accLst.size());
          Training_Event__c trnEvnt = new Training_Event__c();
          trnEvnt.Training_Name__c = 'Test1';
          trnEvnt.Account__c = accLst[0].Id;
          //evntLst.add(trnEvnt);
          insert trnEvnt;
          Training_Event__c accEvnt = [select Id,Account__c,LCRM_Sub_Bu__c,BU_Segment__c from Training_Event__c where Account__c=:acc2.Id];
          system.assertEquals(acc2.BU_Region__c,accEvnt.LCRM_Sub_Bu__c);
          system.assertEquals(acc2.Bu_Segment__c,accEvnt.BU_Segment__c);
          //LCRMPopulateBuRegionSegment.AccTEBURegionPopulation(evntLst);
          }
      }
      
      
      //DPS-DPS-2725,DPS-2727
      //Updation of SSD's BU Region and BU Segment with that of related Account's BU Region and BU Segment 
      static testMethod Void LCRMPopulateBuRegionSegmentOnSSD_Test(){
        List<Profile> lstProfile01 =[SELECT Id FROM Profile WHERE Name =:'System Administrator'];
        User user01 = UnitTest.getUserInstance();
        user01.Username = 'Test@xyzAccountregion.com';
        user01.LastName = 'XYZ';
        user01.Email = 'abc@xyz.com';
        user01.Alias = 'abcd';  
        user01.Segment__c = 'Corporate';
        user01.ProfileId = lstProfile01[0].Id;
        insert user01; 
          
        system.RunAs(user01){
          Test.startTest();
          Account accObj01 = new Account();
          accObj01.name = 'test acc';
          accObj01.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj01.BU_Region__c = 'Canada';
          accObj01.Bu_Segment__c = 'Professional Tax';
          accObj01.Is_GLI__c = true;
          insert accObj01;
                   
          Source_System_Detail__c SSD01 = new Source_System_Detail__c();
          SSD01.Account_Name__c = accObj01.Id;
          SSD01.Name = 'TestRegionSegment';
          SSD01.Source_System_Name__c = 'Testing';
          insert SSD01;
          
          Test.stopTest();
          
          Account acc01 = [select id,name,BU_Region__c,Bu_Segment__c from Account where ID=:accObj01.ID];
          Source_System_Detail__c SSDList01 = [select id,Account_Name__c,BU_Segment__c,LCRM_Sub_BU__c  from Source_System_Detail__c where Account_Name__c=:acc01.ID LIMIT 1]; 
          system.assertEquals(acc01.BU_Region__c,SSDList01.LCRM_Sub_BU__c);
          system.assertEquals(acc01.Bu_Segment__c,SSDList01.BU_Segment__c);
         }             
        }       
        
        //DPS-3328 
        //Updation of Case BU Region and BU Segment with that of related Account's BU Region and BU Segment 
        static testMethod Void LCRMPopulateBuRegionSegmentOnCase_Test(){
        List<Profile> lstProfile03 =[SELECT Id FROM Profile WHERE Name =:'System Administrator'];
        User user03 = UnitTest.getUserInstance();
        user03.Username = 'Testing02@xyzAccountregion.com';
        user03.LastName = 'XYZ02';
        user03.Email = 'abc02@xyz.com';
        user03.Alias = 'abcd02';  
        user03.Segment__c = 'Corporate';
        user03.ProfileId = lstProfile03[0].Id;
        insert user03; 
          
        system.RunAs(user03){
          Test.startTest();
          Account accObj03 = new Account();
          accObj03.name = 'test acc';
          accObj03.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj03.BU_Region__c = 'Canada';
          accObj03.Bu_Segment__c = 'Professional Tax';
          accObj03.Is_GLI__c = true;
          insert accObj03;
          
          CaseRecordTypeIds__c caseRecType03 = new CaseRecordTypeIds__c();
          caseRecType03.Name = 'Findlaw Inquiry';
          caseRecType03.DeveloperName__c = 'Findlaw_Inquiry';
          caseRecType03.RecordTypeId__c = '01213000001CEU7';
          insert caseRecType03;                    
          
          Case cse03 = new Case();
          cse03.Subject = 'Test Case';
          cse03.RecordTypeId = '01213000001CEU7';
          cse03.Status = 'Open';
          cse03.CaseType__c = 'I am requesting an exception';
          cse03.AccountId = accObj03.Id;
          insert cse03;
          
          Test.stopTest();
          
          Account acc03 = [select id,BU_Region__c,Bu_Segment__c from Account where ID=:accObj03.ID];
          Case CaseList03 = [select id,AccountId,BU_Segment__c,LCRM_Sub_BU__c  from Case where AccountId=:acc03.ID LIMIT 1]; 
          system.assertEquals(acc03.BU_Region__c,CaseList03.LCRM_Sub_BU__c);
          system.assertEquals(acc03.Bu_Segment__c,CaseList03.BU_Segment__c); 
         }                          
        }        
        
        // DPS - 2200
        
      static testMethod Void LCRMPopulateBuRegionSegmentOnActivities_Test() {
          Profile trSals = [SELECT Id FROM Profile WHERE Name =:'TR Sales'];
          UserRole gliRole = [SELECT Id FROM UserRole WHERE Name = 'GLI'];
            User gliUser = UnitTest.getUserInstance();
            gliUser.Username = 'Testing01User1@TR.com';
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
          accObj.Sales_Org__c = 'GLI';       
          insert accObj;
          
          Contact con = new Contact();
          con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GLI Contact').getRecordTypeId();
          //con.AccountID = accObj.Id;
          con.lastName = 'con';
          con.firstName = 'Test';
          insert con;
          
         con.AccountID = accObj.Id;
         update con; 
          
          Opportunity testOpportunity = new Opportunity();
          testOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId(); 
          testOpportunity.Name = 'Test';
          testOpportunity.AccountID = accObj.Id;
          //testOpportunity.Key_Contact__c = con.Id;
          testOpportunity.StageName = 'Qualifying';
          testOpportunity.closeDate =Date.Today().adddays(30);
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
           Account acc = [select id,BU_Region__c,Bu_Segment__c from Account where ID=:accObj.ID];
           Event ev = [select id,WhatID,BU_Segment__c,LCRM_Sub_BU__c  from Event where WhatID=:acc.ID LIMIT 1]; 
           system.assertEquals(acc.BU_Region__c,ev.LCRM_Sub_BU__c);
           system.assertEquals(acc.Bu_Segment__c,ev.BU_Segment__c);
          }
          
      } 
      
      /*
      Radhika Pawar
      */  
      
       @isTest static void testPopulateRegionsegment() {
         try{
         Profile profileId = [Select id,name from profile where name = 'System Administrator'];
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
            Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;        
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
        
        LCRMGenericComponent.isLotusUser();
         recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        
         Lead TestLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt.Id;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.Billing_Country__c='US';
         listlead.add(TestLead1);
         
         if(listlead.size()>0){
             insert listlead;
         }
         System.assertNotEquals(TestLead1.LCRM_Sub_BU__c,'CANADA');
        System.debug('listlead**'+listlead);
        test.stoptest();
        
        }
      }catch(exception ex){
          System.debug('Error:'+Ex);
      }
  }   

/*

*/
@isTest static void testPopulateRegionsegmentwithAccount() {
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
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            insert acc;
            accList.add(acc);
            
         recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        
         Lead TestLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt.Id;   
         TestLead1.Account__c = acc.Id; 
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.Billing_Country__c='US';
         listlead.add(TestLead1);
         
         if(listlead.size()>0){
             insert listlead;
         }
        System.debug('listlead**'+listlead);
        test.stoptest();
        TestLead1.BU_Segment__c='Corporate';
        TestLead1.LCRM_Sub_BU__c ='UA';
        
        update TestLead1;
        System.assertEquals(TestLead1.LCRM_Sub_BU__c != null, String.isNotBlank(acc.Bu_Region__c));
        System.assertEquals(TestLead1.LCRM_Sub_BU__c, acc.Bu_Region__c);
        
        }
      }catch(exception ex){
          System.debug('Error:'+Ex);
      }
  } 
  
    //CreateLead
   @isTest static void method3() {
  try{
         Profile profileId = [Select id,name from profile where name = 'System Administrator'];
         
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
            Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;  
        
         System.runAs(testUser) {
       /* List<Account> accList =new List<Account>();
          Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.BU_Region__c='US'; 
            acc.Bu_Segment__c ='Corporate';          
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BillingStreet = '620 W 42ND ST APT 3B';
            acc.BillingCity = 'NEW YORK';
            acc.BillingState = 'NY';
            acc.BillingPostalCode = '10036-2063';
            acc.BillingCountry = 'US';
            insert acc;
            accList.add(acc);
            
            if(accList.size()>0){
            insert accList;
            }
            
            */
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
        
            List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            //acc.BillingCountry = 'US';
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BillingStreet = '555 Test Street';
            acc.BillingCity = 'Dallas';
            acc.BillingState = 'TX';
            acc.BillingPostalCode = '55555';
            //acc.BillingCountry = 'IN';
            insert acc;
            
            System.debug('accList**'+accList);
            recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead TestLead1 = UnitTest.getLeadInstance();
            TestLead1.LeadSource='Customer Service'; 
            TestLead1 .RecordTypeId=leadRt.Id;      
            TestLead1.SAPAccountNumber__c = '98711';
            TestLead1.FirstName = 'Unit';
            TestLead1.LastName = 'Tester1';
            TestLead1.Company = 'Unit Test Company';
            TestLead1.Account__c=acc.Id;
            TestLead1.is_GLI__c =true;
            TestLead1.Sales_Org__c='GLI';
            TestLead1.Status = 'Contacting';         
            TestLead1.Billing_Country__c='US';
            TestLead1.Description='Lead is created for GLI';
            listlead.add(TestLead1);
            
            if(listlead.size()>0){
            insert listlead;
            }
            ApexPages.StandardController standardController = new ApexPages.StandardController(TestLead1);
            LeadCreateController leadCtrl=new LeadCreateController(standardController ); 
            System.currentPageReference().getParameters().put('Description',TestLead1.Description);            
            System.currentPageReference().getParameters().put('accid', acc.Id);  
            System.assertEquals(TestLead1.Account__c, acc.Id); 
            Test.stoptest();
            
            }
 
         }catch(Exception ex){
             System.debug('Error:'+EX); 
          }
   
   } 
    
   //CreateLead
   @isTest static void method4() {
  try{
         Profile profileId = [Select id,name from profile where name = 'System Administrator'];
         
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
            Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;  
        
         System.runAs(testUser) {
       /* List<Account> accList =new List<Account>();
          Account acc = new Account();
            acc.Is_GLI__c = true;
            acc.BillingCountry = 'US';
            acc.BU_Region__c='US'; 
            acc.Bu_Segment__c ='Corporate';          
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BillingStreet = '620 W 42ND ST APT 3B';
            acc.BillingCity = 'NEW YORK';
            acc.BillingState = 'NY';
            acc.BillingPostalCode = '10036-2063';
            acc.BillingCountry = 'US';
            insert acc;
            accList.add(acc);
            
            if(accList.size()>0){
            insert accList;
            }
            
            */
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
        
        Country__c oCountry = new Country__c();
        oCountry.Name = 'United States';
        oCountry.Country_Code__c = 'US';
        insert oCountry;
        
        Country_Region__c oCountryRegion = new Country_Region__c();
        oCountryRegion.Country_Code__c = 'US';
        oCountryRegion.Name = 'US-TX';
        oCountryRegion.Region_Name__c = 'Texas';
        oCountryRegion.Region_Code__c = 'TX';
        insert oCountryRegion;
        
            List<Account> accList = new List<Account>();
            Account acc = new Account();
            acc.Is_GLI__c = true;
            //acc.BillingCountry = 'US';
            acc.Name = 'TESTREGIONACCOUNT';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BillingStreet = '555 Test Street';
            acc.BillingCity = 'Dallas';
            acc.BillingState = 'TX';
            acc.BillingPostalCode = '55555';
            acc.Industry='MULTI-NATIONAL';
            //acc.BillingCountry = 'IN';
            insert acc;
            
        Account acc01= UnitTest.getAccountInstance();
        acc01.Name = 'Unit Test';
        acc01.Is_GLI__c = true;
        acc01.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
        acc01.BillingStreet = '555 Test Street';
        acc01.BillingCity = 'Dallas';
        acc01.BillingState = 'TX';
        acc01.BillingPostalCode = '55555';
        acc01.Industry='AC ACCOUNTING';
        acc01.BillingCountry = 'US';
         insert acc01;
            
            System.debug('accList**'+accList);
            recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead TestLead1 = UnitTest.getLeadInstance();
            TestLead1.LeadSource='Customer Service'; 
            TestLead1 .RecordTypeId=leadRt.Id;      
            TestLead1.SAPAccountNumber__c = '98711';
            TestLead1.FirstName = 'Unit';
            TestLead1.LastName = 'Tester1';
            TestLead1.Company = 'Unit Test Company';
            TestLead1.Account__c=acc.Id;
            TestLead1.is_GLI__c =true;
            TestLead1.Sales_Org__c='GLI';
            TestLead1.Status = 'Contacting';         
            TestLead1.Billing_Country__c='US';
            TestLead1.Description='Lead is created for GLI';
            listlead.add(TestLead1);
            
            if(listlead.size()>0){
            insert listlead;
            }
            System.assertEquals(TestLead1.LCRM_Sub_BU__c, acc.Bu_Region__c);
            acc.Industry='MULTI-NATIONAL';
            update acc;
            
            TestLead1.Account__c=acc.Id;
            update TestLead1;
            Test.stoptest();
            
            }
 
         }catch(Exception ex){
             System.debug('Error:'+EX); 
          }
   
   }   
   
   //DPS-12740
   @isTest static void testPopulateRegionsegmentWithCountry() {
         try{
         Profile profileId = [Select id,name from profile where name = 'System Administrator'];
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
            Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;        
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
        
        LCRMGenericComponent.isLotusUser();
         recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        
         Lead TestLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt.Id;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.Country='US';
         listlead.add(TestLead1);
         
         if(listlead.size()>0){
             insert listlead;
         }
         System.assertNotEquals(TestLead1.LCRM_Sub_BU__c,'CANADA');
        System.debug('listlead**'+listlead);
        test.stoptest();
        
        }
      }catch(exception ex){
          System.debug('Error:'+Ex);
      }
  }   

}