@IsTest(seeAllData=false)
private class UserTriggerHandler_Test{
    public static boolean isExecuted = true;
    public static List<User> newUsers = new List<User>();
    public static Map<id,User> newMap = new Map<id,User>();
    public static Map<id,User> oldMap = new Map<id,User>();
    
    public static testMethod void testExecuteTriggerEvents() {
        
         List<ID> setUser = new List<ID>(); 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sattudt', Email='sattu@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='chan', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, isActive=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='sattu@testorg.com');
        insert u;
        
        User u2 = new User(Alias = 'use11', Email='user76@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='user11', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, isActive=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='testsdfhsjdfusqerh@s2e.com',Regional_Mgr__c =u.name);
            insert u2;
       
           u2.LM_Regional_Manager__c=u.Id;
           update u2;
       
        
         //Setup Test
        Account account = UnitTest.getAccountInstance();
        account.Name = 'UTLeadAccount';
        account.BillingCountry = 'US';
        account.ShippingCountry = 'US';
        account.BillingState = 'IL';
        account.Is_GLI__c = false;
        insert account;
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment1';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
                
        //List<Lead> testLeads = new List<Lead>();
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
        //lead.Account__c= account.Id;
        lead.OwnerId = u.id;
       // insert lead;
        //lead.LeadSource = 'Not Converted';
        
        Lead lead1= new Lead();
        lead1.Company = 'UTLeadAccount';
        lead1.FirstName = 'Martha1';
        lead1.LastName = 'Belly1';  
        //lead1.Account__c= account.Id; 
        lead1.OwnerId = u.id;
        //insert nonPrimLead;
        
       system.assertEquals(lead1.OwnerId,u.id);
        
        List<Lead> leadList= new List<Lead>();
        leadList.add(lead);
        leadList.add(lead1);
       
        
        insert leadList;
        
         //System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        
        
        
        //UserTriggerHandler handler = new UserTriggerHandler();
        
        if(isExecuted ){
                isExecuted = false;
                UserTriggerHandler.updateSalesRegionalManager(newUsers ,newMap, oldMap,true,true);
           }
           
        //Test.startTest();
        
        //if ( !Test.isRunningTest() ) 
       // UserTriggerHandler.updateLeadsSalesRegionalManager(newUsers ,newMap, oldMap,true,true);
        //Test.stopTest();
        //
        Test.startTest();
        UserTriggerHandler.emailUpdateOnOpportunity(setUser);
        Test.stopTest();
        
        //}
    }
    
    public static testMethod void testMngUpdateOnQuote() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        profile anzProfile = [SELECT Id FROM Profile WHERE Name='ANZ Users'];
    
        User user1 = UnitTest.getUserInstance();
        User user2 = UnitTest.getUserInstance();
        User user3 = UnitTest.getUserInstance();
        
        user2.Username = 'Testmng@case.com';
        user2.LastName = 'XYZMNG';
        user2.Email = 'abcmng@xyz.com';
        user2.Alias = 'abmngtst';
        user2.CommunityNickname = 'CommunityNicknamemng.test';
        user2.ProfileId = p.Id;
        
        insert user2;
        
        user3.Username = 'Testnewmng@case.com';
        user3.LastName = 'XYNMNG';
        user3.Email = 'acbmng@xyz.com';
        user3.Alias = 'acmngtst';
        user3.CommunityNickname = 'NewCommunityNicknamemng.test';
        user3.ProfileId = p.Id;
        //user3.ManagerId = user2.Id;
        insert user3;
        
        user1.Username = 'TestUnit@tcscase.com';
        user1.CommunityNickname = 'CommunityNname.test';
        user1.ManagerId = user2.Id;
        user1.ProfileId = p.Id;
        user1.Regional_Mgr__c = user3.id;
        insert user1;
        
       
        Account testAccount = UnitTest.getAccountInstance();
        insert testAccount;
        
        Lead lead= new Lead();
        lead.Company = 'UTLeadAccount';
        lead.FirstName = 'Martha';
        lead.LastName = 'Belly';
       // lead.Account__c= testAccount.Id;
        lead.OwnerId = user1.id;
        lead.Regional_Manager__c = user1.id;
        insert lead;
         system.assertEquals(lead.ownerId,user1.Id);
        KeyValueListStore__c keyValue =  new KeyValueListStore__c();
        keyValue.Name='ANZUsersProfileId';
        keyValue.TextValue__c = anzProfile.Id;
        insert KeyValue;
        
        RecordtypeIds__c recType = new RecordtypeIds__c();
        recType.name = 'LATAM Renewal Opportunity';
        recType.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert recType;
        
        RecordtypeIds__c recType1 = new RecordtypeIds__c();
        recType1.name = 'Pipeline Opportunities';
        recType1.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        insert recType1;
        
        RecordtypeIds__c recType2 = new RecordtypeIds__c();
        recType2.name = 'Pre-Pipeline Opportunities';
        recType2.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        insert recType2;
        Opportunity testOpportunity = UnitTest.getOpportunityInstance(testAccount.Id);
       // testOpportunity.RecordTypeId = RecordtypeIds__c.getValues('LATAM Renewal Opportunity').recTypeId__c;
        testOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpportunity;
        
        testOpportunity.OwnerId = user3.id;
        
        Quote testQuote = new Quote();
        testQuote.Name = 'Test Quote';
        testQuote.Status = 'Draft';
        testQuote.OpportunityId = testOpportunity.id;
        testQuote.Remove_Renewal_Requested__c = true;
        testQuote.Remove_Renewal_Comments__c = 'ABC'; 
        testQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM New Quote').getRecordTypeId();  
        //testQuote.Reservation_Manager__c = user2.Id;
        //testQuote.Manager_of_Reservation_Manager__c = user1.Id;
        insert testQuote;
        
        user1.ManagerId = user3.Id;
        update user1;
        
        system.assertEquals(user1.Id != null,true);
    }
     
     
      public static testMethod void UpdateLvlMgrTest(){
    
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u1 = new User(Alias = 'levelMgr', Email='levelMgr1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Mgr', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, isActive=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='levelMgr1@testorg.com');
            insert u1;
            
            
    List<User> usrs= new List<User>();
        User u2 = new User(Alias = 'use1', Email='user@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='user1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, isActive=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='testsdfhsjdfuserh@s2e.com',LM_Regional_Manager__c=u1.Id,Regional_Mgr__c =u1.name);
            usrs.add(u2);
            
        User u3 = new User(Alias = 'lvlMgr21', Email='levelManager21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Mgr21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='levelManager21@testorg.com',LM_Regional_Manager__c=u1.Id,Regional_Mgr__c =u1.name);
            usrs.add(u3);
            
            insert usrs;
            system.assertEquals(u1.isActive,true);
            u1.isActive=false;
            
            update u1;
            system.debug('@@newU1'+u1);
         Test.stopTest();
         
            
            
            
          
            
            
            
    
    }  
    
       
}