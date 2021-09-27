@isTest
private class ESC_ListViewController_Test {
    @isTest
    static void test() {
        Test.startTest();
        
        //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        
        System.RunAs(us)
        {
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        acct.BillingCity = 'New York';
        acct.BillingState = 'AL';
        acct.BillingCountry = 'US';
        acct.BillingPostalCode = '1007';
        acct.BillingStreet = 'Diamond';
        insert acct ; 
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Product2 prod = new Product2(name='Teest Prod');
        insert prod;
        
      
      // insert a case records
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(con.id,acct.id,'New');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=acct.id;
      testCase.ESC_Apply_Entitlement_Milestone__c=True;
      testCase.USL_Referral_Milestone_Type__c='Case Closure Time';
      insert testCase;
      listcase.add(testCase);
      
      Group g = new Group();
       g.Name = 'Test';
       g.type='Queue';
       insert g;
       
      
       
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        GroupMember gm = new GroupMember(
        GroupId = g.id,
        UserOrGroupId = us.id
        );
        
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert gm;}
        
      /*list<ListView> lstListViews = new list<ListView>();
      lstListViews.Name='test';
      insert lstListViews;*/
        
     
        ESC_ListViewController.fetchListViews('test',True);
        
        
     }
        
        Test.stopTest();
        
    }
    
    @isTest
    static void test1() {
        Test.startTest();
        
        //create a user records  
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US',Department ='Test', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        
        System.RunAs(us)
        {
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        acct.BillingCity = 'New York';
        acct.BillingState = 'AL';
        acct.BillingCountry = 'US';
        acct.BillingPostalCode = '1007';
        acct.BillingStreet = 'Diamond';
        insert acct ; 
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        //con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Product2 prod = new Product2(name='Teest Prod');
        insert prod;
        
      // insert a case records
      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(con.id,acct.id,'New');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      //testcase.BusinessHours=defaultBHid;
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=acct.id;
      testCase.ESC_Apply_Entitlement_Milestone__c=True;
      testCase.USL_Referral_Milestone_Type__c='Case Closure Time';
      insert testCase;
      listcase.add(testCase);
      
      Group g = new Group();
       g.Name = 'Test';
       g.type='Queue';
       insert g;
        Group g1 = new Group();
       g1.Name = 'Test1';
       g1.type='regular';
       insert g1;
        QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'case');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        GroupMember gm = new GroupMember(
        GroupId = g.id,
        UserOrGroupId = us.id
        );
        
        GroupMember gm1 = new GroupMember(
        GroupId = g1.id,
        UserOrGroupId = us.id
        );
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert gm;
        insert gm1;
          ESC_Home_Page_ListViews__c hp= new ESC_Home_Page_ListViews__c();
       hp.ESC_Group_Name__c = 'Test1';
       hp.ESC_ObjectName__c = 'case';
       hp.ESC_ListViewName__c = 'test_listview';
       insert hp;
        
        }
        
        
       //list<ListView> lstViews = new list<ListView>();
      
       
       
        ESC_ListViewController.fetchListViews('case',False);
        
        
     }
        
        Test.stopTest();
        
    }
    }