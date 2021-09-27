@isTest
public class ESC_UPD_Utility_Test {
  @isTest
    public static void testClass(){
        Test.startTest();
        
        //field set
          List<Schema.FieldSetMember> customer = SObjectType.Case.FieldSets.ESC_Customer_UPD_Fields.getFields();
          List<Schema.FieldSetMember> owner = SObjectType.Case.FieldSets.ESC_Owner_UPD_Fields.getFields();
          List<Schema.FieldSetMember> resolver = SObjectType.Case.FieldSets.ESC_Resolver_UPD_Fields.getFields();
            
          Map<Id,Sobject> oldMap = new Map<Id,Sobject>();
        Map<Id,Sobject> newMap = new Map<Id,Sobject>();
         
        Map<String,List<Schema.FieldSetMember>> UPDFieldMap= new Map<String,List<Schema.FieldSetMember>>();
        Map<String,List<String>> UPDFieldAPIMap= new Map<String,List<String>>();
        
            String existingLabelVal = Label.ESC_ViaNormal;
        
        //custom setting create
            ESC_UpdFieldSetting__c upd= new ESC_UpdFieldSetting__c();
          //upd.SetupOwnerId = profile.Id;
          upd.ESC_CustomerUPD__c='CaseUpdUpdateSet,ESC_UPD_Customer__c';
          //upd.ESC_CustomerUPD__c='';
          upd.ESC_FieldsetName__c='CaseUpdUpdateSet';
          upd.ESC_ObjectName__c='Case';
          upd.ESC_OwnerUPD__c='CaseUpdUpdateSet,ESC_UPD__c';
          upd.ESC_ResloverUPD__c='CaseUpdUpdateSet,ESC_UPD_Resolver__c';
          insert upd;
            
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
            
          
            
          //insert case
          List <Case> listCase= new List<Case>();
            Case cs1=new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.subject='tst';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Content Explanation';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='2 - Medium';
            cs1.ESC_Apply_Milestone_Closure_Flag__c = true;
            cs1.ContactId= con1.Id;
            cs1.status ='New';
            cs1.ESC_UPD_Customer__c=false;
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
            insert listcase;
          oldmap.put(cs1.id,cs1);
          //user create
          Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            
            User user2 = new User(Alias = 'Test2', Email='sysadmin2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Test2@ss.com');
            insert user2;
            
             
            //insert referral(resolver id)
            ESC_Case_Collaborator__c referral= new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.ESC_Assign_To__c= user2.Id;
            referral.ESC_Role__c='Accountable Resolver';

            System.runAs(user){
            
            Case cs2= cs1.clone();
            cs2.id= cs1.id;
            cs2.ESC_Proactive_Type__c='Social Media';
            cs2.Priority='3 - Low';
            cs2.ESC_Severity__c='3 - Low';
            cs2.ESC_ResolverID__c=user2.Id;
            update cs2;
            
            Newmap.put(cs2.id,cs2);
            
          Attachment attach = new Attachment();
          attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
          attach.parentId=cs1.id;
          insert attach; 
          
            List<Attachment>AttachList= new List<Attachment>();
            AttachList.add(attach);
            
            ESC_UPD_Utility.CaseUPDCustomerAttachment(AttachList);
                
            }
            ESC_UPD_Utility.UPDFlagHelper(newMap, oldMap);
            Test.stopTest();
    }
    @isTest
    public static void testClass2(){
        Test.startTest();
        
        //field set
          List<Schema.FieldSetMember> customer = SObjectType.Case.FieldSets.ESC_Customer_UPD_Fields.getFields();
          List<Schema.FieldSetMember> owner = SObjectType.Case.FieldSets.ESC_Owner_UPD_Fields.getFields();
          List<Schema.FieldSetMember> resolver = SObjectType.Case.FieldSets.ESC_Resolver_UPD_Fields.getFields();
            
          Map<Id,Sobject> oldMap = new Map<Id,Sobject>();
        Map<Id,Sobject> newMap = new Map<Id,Sobject>();
         
        Map<String,List<Schema.FieldSetMember>> UPDFieldMap= new Map<String,List<Schema.FieldSetMember>>();
        Map<String,List<String>> UPDFieldAPIMap= new Map<String,List<String>>();
        
            String existingLabelVal = Label.ESC_ViaNormal;
        
        
          //user create
          UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com',
            UserRoleId = portalRole.Id, 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles',
             UserName='Test123@ss.com');
            insert user;
            
            User user2 = new User(Alias = 'Test2', Email='sysadmin2@testorg.com', 
            UserRoleId = portalRole.Id,
            EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test2@ss.com');
            insert user2;
            
            Case cs1;
              //insert case
              system.runAs(user2){
                  //List <Case> listCase= new List<Case>();
            cs1 =new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.subject='tst';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Content Explanation';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='2 - Medium';
            cs1.ESC_Apply_Milestone_Closure_Flag__c = true;
            cs1.status ='New';
            cs1.ESC_UPD_Customer__c=false;
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            insert cs1;
          //oldmap.put(cs1.id,cs1);
          
              }
            
            
            System.runAs(user){
            
           //custom setting create
            ESC_UpdFieldSetting__c upd= new ESC_UpdFieldSetting__c();
          //upd.SetupOwnerId = profile.Id;
          upd.ESC_CustomerUPD__c='CaseUpdUpdateSet,ESC_UPD_Customer__c';
          //upd.ESC_CustomerUPD__c='';
          upd.ESC_FieldsetName__c='CaseUpdUpdateSet';
          upd.ESC_ObjectName__c='Case';
          upd.ESC_OwnerUPD__c='CaseUpdUpdateSet,ESC_UPD__c';
          upd.ESC_ResloverUPD__c='CaseUpdUpdateSet,ESC_UPD_Resolver__c';
          insert upd;
            
            Account acc= new Account();
          acc.Name='Test';
          acc.OwnerId = user2.Id;
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
            
          
            Profile profileUser = [SELECT Id FROM Profile WHERE UserType = 'PowerPartner' LIMIT 1];
            User user1 = new User(
            Username = System.now().millisecond() + 'test123456@test.com',
            ContactId = con1.Id,
            ProfileId = profileUser.Id,
            Alias = 'test123',
            Email = 'test123456@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test123456',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
         
          cs1.ContactId= con1.Id;
          cs1.status = 'Work In Progress';
          update cs1;
          
            Case cs2= cs1.clone();
            cs2.id= cs1.id;
            cs2.ESC_Proactive_Type__c='Social Media';
            cs2.Priority='3 - Low';
            cs2.ESC_Severity__c='3 - Low';
            cs2.ESC_ResolverID__c=user1.Id;
            update cs2;
            
            cs2.status = 'Work In Progress';
            cs2.Priority = '2 - Medium';
            update cs2;
            
            //insert referral(resolver id)
            ESC_Case_Collaborator__c referral= new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.ESC_referral_status__c = 'In Progress';
            referral.ESC_Role__c='Accountable Resolver';
            referral.ESC_Assign_To__c= user2.Id;
            insert referral;
            //referral.ESC_Assign_To__c= user2.Id;
           // update referral;
            
            
            // set<id> refid = [select id from ESC_Case_Collaborator__c where id =: referral.id];
             List<FeedItem> reflist= new List<FeedItem>();  
             FeedItem fd  = new FeedItem();
             fd.ParentId = referral.Id;
             fd.Body = '[xzxzxzxz]';
             fd.Type ='ContentPost';
             reflist.add(fd);
             insert reflist;
             ESC_UPD_Utility.updateCaseUPD(reflist);
             ESC_UPD_Utility.postFeedonCase(reflist);
            
            
            }
           /* 
            Newmap.put(cs2.id,cs2);
            
          Attachment attach = new Attachment();
          attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
          attach.parentId=cs1.id;
          insert attach; 
          
            List<Attachment>AttachList= new List<Attachment>();
            AttachList.add(attach);
            
            ESC_UPD_Utility.CaseUPDCustomerAttachment(AttachList);
                
            }
            ESC_UPD_Utility.UPDFlagHelper(newMap, oldMap);*/
            Test.stopTest();
    }
    @isTest
    public static void testClass4(){
        Test.startTest();
        
        //field set
          List<Schema.FieldSetMember> customer = SObjectType.Case.FieldSets.ESC_Customer_UPD_Fields.getFields();
          List<Schema.FieldSetMember> owner = SObjectType.Case.FieldSets.ESC_Owner_UPD_Fields.getFields();
          List<Schema.FieldSetMember> resolver = SObjectType.Case.FieldSets.ESC_Resolver_UPD_Fields.getFields();
            
          Map<Id,Sobject> oldMap = new Map<Id,Sobject>();
        Map<Id,Sobject> newMap = new Map<Id,Sobject>();
         
        Map<String,List<Schema.FieldSetMember>> UPDFieldMap= new Map<String,List<Schema.FieldSetMember>>();
        Map<String,List<String>> UPDFieldAPIMap= new Map<String,List<String>>();
        
            String existingLabelVal = Label.ESC_ViaNormal;
        
        
          //user create
          UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com',
            UserRoleId = portalRole.Id, 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles',
             UserName='Test123@ss.com');
            insert user;
            
            User user2 = new User(Alias = 'Test2', Email='sysadmin2@testorg.com', 
            UserRoleId = portalRole.Id,
            EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test2@ss.com');
            insert user2;
            User user1;
            Contact con1 ;
           System.runAs(user2){
            
           //custom setting create
            ESC_UpdFieldSetting__c upd= new ESC_UpdFieldSetting__c();
          //upd.SetupOwnerId = profile.Id;
          upd.ESC_CustomerUPD__c='CaseUpdUpdateSet,ESC_UPD_Customer__c';
          //upd.ESC_CustomerUPD__c='';
          upd.ESC_FieldsetName__c='CaseUpdUpdateSet';
          upd.ESC_ObjectName__c='Case';
          upd.ESC_OwnerUPD__c='CaseUpdUpdateSet,ESC_UPD__c';
          upd.ESC_ResloverUPD__c='CaseUpdUpdateSet,ESC_UPD_Resolver__c';
          insert upd;
            
          Account acc= new Account();
          acc.Name='Test';
          acc.OwnerId = user2.Id;
          insert acc;
          
          //insert contact
          con1 = new Contact();
            con1.LastName = '2Name';
            con1.Email = 'mail2g@mail.com';
            con1.Phone = '9889384214';
            con1.MobilePhone = '9889384214';
            con1.salutation = 'Ms.';
            con1.firstName = '2name';
            con1.AccountId = acc.Id;
            con1.Department = 'TR';
            insert con1;
            
          
          /* Profile profileUser = [SELECT Id FROM Profile WHERE UserType = 'PowerPartner' LIMIT 1];
             User1 = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = con1.Id,
            ProfileId = profileUser.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            );
            insert user1;*/
            
         
          
           Case cs1 =new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.subject='tst';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Content Explanation';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='2 - Medium';
            cs1.ESC_Apply_Milestone_Closure_Flag__c = true;
            cs1.status ='New';
            cs1.ESC_UPD_Customer__c=false;
            cs1.ESC_ResolverID__c = user.Id;
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.ESC_UPD_Action__c = '#1 via Manual Update';
            cs1.ESC_Resolver_UPD_Action__c = '#1 via Manual Update';
            cs1.ESC_Customer_UPD_Action__c = '#1 via Manual Update';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            insert cs1;
          //oldmap.put(cs1.id,cs1);
          
          cs1.ContactId= con1.Id;
          cs1.ESC_Customer_UPD_Action__c = '#2 via Manual Update';
          cs1.status = 'Work In Progress';
          update cs1;
          
            Case cs2= cs1.clone();
            cs2.id= cs1.id;
            cs2.ESC_Proactive_Type__c='Social Media';
            cs2.Priority='3 - Low';
            cs2.ESC_Severity__c='3 - Low';
            cs2.ESC_ResolverID__c=user.Id;
            cs2.ESC_UPD_Action__c = '#1 via Manual Update';
            cs2.ESC_Resolver_UPD_Action__c = '#2 via Manual Update';
            cs2.ESC_Customer_UPD_Action__c = '#1 via Manual Update';
            update cs2;
            
            cs2.status = 'Work In Progress';
            cs2.Priority = '2 - Medium';
            update cs2;
            
            //insert referral(resolver id)
            ESC_Case_Collaborator__c referral= new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.ESC_referral_status__c = 'In Progress';
            referral.ESC_Role__c='Accountable Resolver';
            referral.ESC_Assign_To__c= user.Id;
            insert referral;
            //referral.ESC_Assign_To__c= user2.Id;
           // update referral;
            
            
            // set<id> refid = [select id from ESC_Case_Collaborator__c where id =: referral.id];
             List<FeedItem> reflist= new List<FeedItem>();  
             FeedItem fd  = new FeedItem();
             fd.ParentId = referral.Id;
             fd.Body = '[xzxzxzxz]';
             fd.Type ='ContentPost';
             reflist.add(fd);
             insert reflist;
             ESC_UPD_Utility.updateCaseUPD(reflist);
             ESC_UPD_Utility.postFeedonCase(reflist);
             
            
            }
            
            Test.stopTest();
    }
    
    @isTest
    public static void testClass3(){
        Test.startTest();
        
        //field set
          List<Schema.FieldSetMember> customer = SObjectType.Case.FieldSets.ESC_Customer_UPD_Fields.getFields();
          List<Schema.FieldSetMember> owner = SObjectType.Case.FieldSets.ESC_Owner_UPD_Fields.getFields();
          List<Schema.FieldSetMember> resolver = SObjectType.Case.FieldSets.ESC_Resolver_UPD_Fields.getFields();
            
          Map<Id,Sobject> oldMap = new Map<Id,Sobject>();
        Map<Id,Sobject> newMap = new Map<Id,Sobject>();
         
        Map<String,List<Schema.FieldSetMember>> UPDFieldMap= new Map<String,List<Schema.FieldSetMember>>();
        Map<String,List<String>> UPDFieldAPIMap= new Map<String,List<String>>();
        
            String existingLabelVal = Label.ESC_ViaNormal;
        
        
          //user create
          UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com',
            UserRoleId = portalRole.Id, 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles',
             UserName='Test123@ss.com');
            insert user;
            
            User user2 = new User(Alias = 'Test2', Email='sysadmin2@testorg.com', 
            UserRoleId = portalRole.Id,
            EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='Test2@ss.com');
            insert user2;
            User user1;
            Contact con1 ;
           System.runAs(user2){
            
           //custom setting create
            ESC_UpdFieldSetting__c upd= new ESC_UpdFieldSetting__c();
          //upd.SetupOwnerId = profile.Id;
          upd.ESC_CustomerUPD__c='CaseUpdUpdateSet,ESC_UPD_Customer__c';
          //upd.ESC_CustomerUPD__c='';
          upd.ESC_FieldsetName__c='CaseUpdUpdateSet';
          upd.ESC_ObjectName__c='Case';
          upd.ESC_OwnerUPD__c='CaseUpdUpdateSet,ESC_UPD__c';
          upd.ESC_ResloverUPD__c='CaseUpdUpdateSet,ESC_UPD_Resolver__c';
          insert upd;
            
          Account acc= new Account();
          acc.Name='Test';
          acc.OwnerId = user2.Id;
          insert acc;
          
          //insert contact
          con1 = new Contact();
            con1.LastName = '2Name';
            con1.Email = 'mail2g@mail.com';
            con1.Phone = '9889384214';
            con1.MobilePhone = '9889384214';
            con1.salutation = 'Ms.';
            con1.firstName = '2name';
            con1.AccountId = acc.Id;
            con1.Department = 'TR';
            insert con1;
            
          
           Profile profileUser = [SELECT Id FROM Profile WHERE UserType = 'PowerPartner' LIMIT 1];
             User1 = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = con1.Id,
            ProfileId = profileUser.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
         
          
           Case cs1 =new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.subject='tst';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Content Explanation';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='2 - Medium';
            cs1.ESC_Apply_Milestone_Closure_Flag__c = true;
            cs1.status ='New';
            cs1.ESC_UPD_Customer__c=false;
            cs1.ESC_ResolverID__c = user2.Id;
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.ESC_UPD_Action__c = '#1 via Manual Update';
            cs1.ESC_Resolver_UPD_Action__c = '#1 via Manual Update';
            cs1.ESC_Customer_UPD_Action__c = '#1 via Manual Update';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            insert cs1;
          //oldmap.put(cs1.id,cs1);
          
          cs1.ContactId= con1.Id;
          cs1.ESC_Customer_UPD_Action__c = '#2 via Manual Update';
          cs1.status = 'Work In Progress';
          update cs1;
          
            Case cs2= cs1.clone();
            cs2.id= cs1.id;
            cs2.ESC_Proactive_Type__c='Social Media';
            cs2.Priority='3 - Low';
            cs2.ESC_Severity__c='3 - Low';
            cs2.ESC_ResolverID__c=user2.Id;
            cs2.ESC_UPD_Action__c = '#1 via Manual Update';
            cs2.ESC_Resolver_UPD_Action__c = '#2 via Manual Update';
            cs2.ESC_Customer_UPD_Action__c = '#1 via Manual Update';
            update cs2;
            
            cs2.status = 'Work In Progress';
            cs2.Priority = '2 - Medium';
            update cs2;
            
            //insert referral(resolver id)
            ESC_Case_Collaborator__c referral= new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.ESC_referral_status__c = 'In Progress';
            referral.ESC_Role__c='Accountable Resolver';
            referral.ESC_Assign_To__c= user2.Id;
            insert referral;
            //referral.ESC_Assign_To__c= user2.Id;
           // update referral;
            
            
            // set<id> refid = [select id from ESC_Case_Collaborator__c where id =: referral.id];
             List<FeedItem> reflist= new List<FeedItem>();  
             FeedItem fd  = new FeedItem();
             fd.ParentId = referral.Id;
             fd.Body = '[xzxzxzxz]';
             fd.Type ='ContentPost';
             reflist.add(fd);
             insert reflist;
             ESC_UPD_Utility.updateCaseUPD(reflist);
             ESC_UPD_Utility.postFeedonCase(reflist);
             
            
            }
            
            Test.stopTest();
            
    }
}