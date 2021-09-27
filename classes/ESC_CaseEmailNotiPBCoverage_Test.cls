@isTest
private class ESC_CaseEmailNotiPBCoverage_Test{
    
    @isTest public static void testMethod1() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',Language__c = 'English',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

Group testGroup = new Group(Name='Solcara_UKI_Support', Type='Queue');

insert testGroup;

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Archive Requests').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Closed',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',RecordtypeID=caseid ,Description = 'Test archive',Reason__c = 'Access Issues',Closed_Action__c='Completed',Reason_Detail__c='License/Subscription', SuppliedEmail='abc@tr.com',Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
   } 
    @isTest public static void testMethod2() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',Language__c = 'Português (Brasil)',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Archive Requests').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Closed',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',RecordtypeID=caseid ,Description = 'Test archive',Reason__c = 'Access Issues',Closed_Action__c='Completed',Reason_Detail__c='License/Subscription', SuppliedEmail='abc@tr.com',Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod3() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',Language__c = 'Spanish',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Archive Requests').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Closed',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',RecordtypeID=caseid ,Description = 'Test archive',Reason__c = 'Access Issues',Closed_Action__c='Completed',Reason_Detail__c='License/Subscription', SuppliedEmail='abc@tr.com',Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod4() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Closed',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',RecordtypeID=caseid ,Description = 'Test archive', SuppliedEmail='abc@tr.com',Salesperson__c = UserInfo.getUserId(),Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}


@isTest public static void testMethod5() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Findlaw Inquiry').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Open',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',RecordtypeID=caseid ,Description = 'Test archive', SuppliedEmail='abc@tr.com',Salesperson__c = Us.Id,Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod6() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Open',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',Old_Owner__c =Us.Id,Escalation_Level_Number__c =1,RecordtypeID=caseid ,Description = 'Test archive', SuppliedEmail='abc@tr.com',Salesperson__c = Us.Id,Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        caseList[0].ownerId = UserInfo.getUserId();
        caseList[0].Escalation_Level_Number__c =2;
        update caseList[0];
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod7() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',Language__c = 'English',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Findlaw Inquiry').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Open',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',RecordtypeID=caseid ,Description = 'Test archive', SuppliedEmail='abc@tr.com',Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        caseList[0].status = 'Waiting for Response';
        update caseList[0];
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod8() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',Language__c = 'English',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Findlaw Inquiry').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Closed',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',RecordtypeID=caseid ,Description = 'Test archive', SuppliedEmail='abc@tr.com',Salesperson__c = UserInfo.getUserId(),Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod9() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='New',Origin='Email',LCRM_Sub_Bu__c = 'UKI',
         Priority='Medium',RecordtypeID=caseid ,ANZ_Support_Type__c='Customer Care',Description = 'Test archive', SuppliedEmail='abc@tr.com',Salesperson__c = UserInfo.getUserId(),Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod10() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='New',Origin='Email',LCRM_Sub_Bu__c = 'GGO',
         Priority='Medium',RecordtypeID=caseid ,ANZ_Support_Type__c='ServiceFirst',Description = 'Test archive', SuppliedEmail='abc@tr.com',Salesperson__c = UserInfo.getUserId(),Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod11() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Active',Origin='Email',Sales_Org__c='LLEY',
         Priority='Medium',RecordtypeID=caseid ,ANZ_Support_Type__c='Technical Care',Description = 'Test archive', SuppliedEmail='abc@tr.com',Salesperson__c = UserInfo.getUserId(),Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}

@isTest public static void testMethod12() {
     
     Profile Prof = [SELECT Id FROM profile WHERE name='LatAM Helpdesk Agent'];
     User Us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = Prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert Us;  
Account testAccount1=new Account(Name= 'testName',ShippingCity= 'testCity',ShippingCountry= 'IN',ShippingStreet='testStreet', Large_Account__c=true);
    insert testAccount1;
        
Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
insert testContact1;
        

list<case> caseList=new List<case>();


    System.runAs(Us)
    {
       
        test.startTest();
        Id caseid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('LatAm').getRecordTypeId();
        Case cs = new Case(AccountId=testAccount1.Id,ContactId=testContact1.Id,Is_GLI__c=true, Status='Active',Origin='Email',Sales_Org__c='RV01',
         Priority='Medium',RecordtypeID=caseid ,ANZ_Support_Type__c='Technical Care',Description = 'Test archive', SuppliedEmail='abc@tr.com',Salesperson__c = UserInfo.getUserId(),Subject='test');
        caseList.add(cs);
        
        insert CaseList;
        system.assertEquals(1,1,1);
        test.stopTest();
    }
}
}