@isTest
public class ESC_PushTopicHelperObjTest {
    
   
    static testmethod void testFetchGuestUsers(){
        
        Map<string ,set<string>> returnTest = new Map<string ,set<string>>();
        Map<string , set<string>> compareTest = new Map<string , set<string>>();
        set<string> testRecIDSet= new set<string>();
        
        Profile Prof = [SELECT Id FROM profile WHERE name='GLI Helpdesk Agent'];
        User testUser = new User(FirstName = 'Anne' , LastName= 'Frank', Alias = 'afrank',Email= 'anne.frank@thomsonreuters.com', emailencodingkey='UTF-8',UserName='anne.frank@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', profileid = Prof.Id, timezonesidkey='America/Los_Angeles',CommunityNickname='Anne.Frank');
        insert testUser; 
        
        //resolver user create
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User testUser2 = new User(Alias = 'Test2', Email='sysadmin2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Test2@ss.com');
            insert testUser2;
            
        String userID = ''+ testUser.id;
        Set<String> userIDs = new Set<String>();
        userIDs.add(userID);
        
        //Account insert   
        Account acc= new Account();
        acc.Name='Test';
        insert acc;
          
        //insert contact
        Contact con1 = new Contact();
        con1.LastName = '2Name';
        con1.Email = 'mail2g@mail.com';
        con1.Phone = '9889384214';
        con1.MobilePhone = '9889384214';
        con1.salutation = 'Ms.';
        con1.firstName = '2name';
        con1.AccountId = acc.Id;
        con1.Department = 'TR';
        insert con1;
        
        Case testCase = new Case();
        testCase.OwnerId = testUser.id;
        testCase.ESC_Impact__c = '1-Whole Site';
        testCase.subject='tst';
        testCase.ESC_Customer_Symptom__c='Content Addition';
        testCase.ESC_Diagnosis_Summary__c='Content Explanation';
        testCase.ESC_Severity__c='1 - High';
        testCase.Priority='2 - Medium';
        testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
        testCase.ContactId= con1.Id;
        testCase.status ='New';
       // testCase.ESC_UPD_Customer__c=false;
        testCase.ESC_Proactive_Type__c='Internal Origin';
        testCase.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert testCase;
        
        String caseID = '' + testCase.Id;
        testRecIdSet.add(caseID);
        
      /* ESC_Case_Collaborator__c testObject = new ESC_Case_Collaborator__c();
         testObject.ESC_Role__c='Accountable Resolver';
         testObject.ESC_Referral_Status__c='New';
         testObject.ESC_Case__c=testCase.id;
         testObject.ownerId = testUser2.id;
         insert testObject;*/
           
        EmailMessage email = new EmailMessage(ParentId = testCase.Id);
        List<EmailMessage> emailList = new List<EmailMessage>();
        emailList.add(email);
        insert emailList;
        
         ESC_PushTopicHelper__c pth = new ESC_PushTopicHelper__c();
            pth.ESC_ParentRecID__c = email.id;
            pth.ESC_ObjectType__c = 'EmailMessage';
            pth.ESC_RecOwner__c = testCase.OwnerId;
            pth.ESC_EventType__c='Email Read By';
            insert pth;
            
        
        
        
       
         Test.startTest();
        System.runAs(testUser){
        //compareTest.put(caseId, userIDs);
        returnTest = ESC_PushTopicHelperObj.fetchGuestUsers(testRecIDSet, 'Case');
        ESC_PushTopicHelperObj.populateLogs(email, 'Email Read By');
       // ESC_PushTopicHelperObj.populateLogs(emailList);
        ESC_PushTopicHelperObj.updateMap(emailList);
        ESC_PushTopicHelperObj.getRecordsToBeUpdated(emailList, 'Email Read By');
        }
        Test.stopTest();
        
    }
    
   //METHOD2
    static testmethod void  testFetchGuestUsers2(){
        
        Map<string ,set<string>> returnTest = new Map<string ,set<string>>();
        Map<string , set<string>> compareTest = new Map<string , set<string>>();
        set<string> testRecIDSet= new set<string>();
        
        Profile Prof = [SELECT Id FROM profile WHERE name='GLI Helpdesk Agent'];
        User testUser = new User(FirstName = 'Anne' , LastName= 'Frank', Alias = 'afrank',Email= 'anne.frank@thomsonreuters.com', emailencodingkey='UTF-8',UserName='anne.frank@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', profileid = Prof.Id, timezonesidkey='America/Los_Angeles',CommunityNickname='Anne.Frank');
        insert testUser; 
        
        //resolver user create
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User testUser2 = new User(Alias = 'Test2', Email='sysadmin2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Test2@ss.com');
            insert testUser2;
            
        String userID = ''+ testUser.id;
        Set<String> userIDs = new Set<String>();
        userIDs.add(userID);
        
        //Account insert   
        Account acc= new Account();
        acc.Name='Test';
        insert acc;
          
        //insert contact
        Contact con1 = new Contact();
        con1.LastName = '2Name';
        con1.Email = 'mail2g@mail.com';
        con1.Phone = '9889384214';
        con1.MobilePhone = '9889384214';
        con1.salutation = 'Ms.';
        con1.firstName = '2name';
        con1.AccountId = acc.Id;
        con1.Department = 'TR';
        insert con1;
        
        Case testCase = new Case();
        testCase.OwnerId = testUser.id;
        testCase.ESC_Impact__c = '1-Whole Site';
        testCase.subject='tst';
        testCase.ESC_Customer_Symptom__c='Content Addition';
        testCase.ESC_Diagnosis_Summary__c='Content Explanation';
        testCase.ESC_Severity__c='1 - High';
        testCase.Priority='2 - Medium';
        testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
        testCase.ContactId= con1.Id;
        testCase.status ='New';
        //testCase.ESC_UPD_Customer__c=false;
        testCase.ESC_Proactive_Type__c='Internal Origin';
        testCase.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert testCase;
        
        String caseID = '' + testCase.Id;
        testRecIdSet.add(caseID);
           
        EmailMessage email = new EmailMessage(ParentId = testCase.Id,subject=testCase.subject,TextBody=testCase.subject);
        EmailMessage email2 = new EmailMessage(ParentId = testCase.Id,subject=testCase.subject+'ref:_00D',TextBody=testCase.subject+'ref:_00D');
        List<EmailMessage> emailList = new List<EmailMessage>();
        emailList.add(email);
        emailList.add(email2);
        insert emailList;
        
        
        /*ESC_Case_Collaborator__c testObject = new ESC_Case_Collaborator__c();
         testObject.ESC_Role__c='Accountable Resolver';
         testObject.ESC_Referral_Status__c='New';
         testObject.ESC_Case__c=testcase.Id;
         testObject.ownerId = testUser2.id;
         insert testObject;*/
        
       
         Test.startTest();
        System.runAs(testUser2){
        compareTest.put(caseId, userIDs);
        returnTest = ESC_PushTopicHelperObj.fetchGuestUsers(testRecIDSet, 'Case');
        ESC_PushTopicHelperObj.populateLogs(email, 'Email Read By');
        ESC_PushTopicHelperObj.populateLogs(emailList);
        ESC_PushTopicHelperObj.updateMap(emailList);
        ESC_PushTopicHelperObj.populateLogs(email2, 'Email Read By');
        }
        Test.stopTest();
        
    }
    
}