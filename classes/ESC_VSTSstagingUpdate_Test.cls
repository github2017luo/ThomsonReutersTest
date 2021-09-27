@isTest(SeeAllData=false)
public class ESC_VSTSstagingUpdate_Test{
    
     static testmethod void VSTSUpdate_feed(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        try
            {
        
            
        ESC_VSTS_Product_List__c productList = new ESC_VSTS_Product_List__c();
            productList.Name='Checkpoint';
            insert productList;
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts17', Email='Tuvsts17@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts17', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts17@ss.com');
            insert testUser;
            
        Account acc= new Account();
          acc.Name='Test';
          acc.SAPAccountNumber__c='Test123';
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
            con1.ESC_IsAllowRepDB__c=true;
            insert con1;
        
        
            //insert case
        List <Case> listCase= new List<Case>();
        Case cs1=new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.AccountId=acc.Id;
            cs1.OwnerId=testUser.Id;
            cs1.Description='testDescription';
            cs1.ESC_VSTS_Description__c ='';
            cs1.subject='Creating a test case and trying to insert subject on this case as Test subject created for testing. This case is to check the character length greater than 210 Characters. This is for testing GGO and VSTS integration through ESI.';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Content Explanation';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='2 - Medium';
            cs1.ContactId= con1.Id;
            //cs1.ProductId=product.Id;
            cs1.GGO_Product_Complement__c='Test';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.Product__c='Checkpoint';
            cs1.LCRM_Sub_BU__c='GGO';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
         ESC_Special_Instruction__c spIns=new ESC_Special_Instruction__c();
            spIns.ESC_Category_Account__c='Premium Support Account';
            spIns.ESC_Instructions__c='A';
            insert spIns;
            
            
            ESC_Case_Special_Instruction__c cSpIns=new ESC_Case_Special_Instruction__c();
            cSpIns.ESC_Special_Instruction__c=spIns.Id;
            cSpIns.ESC_Case__c=cs1.Id;
            insert cSpIns;
            
            
                
        List<FeedItem> feedList= new List<FeedItem>();
        FeedItem feed = new FeedItem();
            feed.Type= 'TextPost';
            feed.body='@BR_LE_Development_Legal_One test';
            feed.parentId=cs1.Id;
            insert feed;
            feedList.add(feed);
            
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
        Map<Id,List<String>> caseIdMap = new Map<Id,List<String>>();
        List<String> tempList= new List<String>();
            //tempList.add(Object listElement)
            //caseIdMap.put(feed.parentId,);
            
        test.startTest();
        ESC_VSTSstagingUpdate.updateVSTSstaging(feedList);
        test.stopTest();
        }catch(Exception e)
        {
            system.debug(e);
        }
      }
      static testmethod void VSTSUpdateMethod1(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
        ESC_VSTS_Product_List__c productList = new ESC_VSTS_Product_List__c();
            productList.Name='Checkpoint';
            insert productList;
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts18', Email='Tuvsts18@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts18', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts187@ss.com');
            insert testUser;
          
        Account acc= new Account();
          acc.Name='Test';
          acc.SAPAccountNumber__c='';
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
            con1.ESC_IsAllowRepDB__c=true;
            insert con1;
        
        
            //insert case
        List <Case> listCase= new List<Case>();
        Case cs1=new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.AccountId=acc.Id;
            cs1.OwnerId=testUser.Id;
            cs1.Description='testDescription';
            cs1.ESC_VSTS_Description__c ='';
            cs1.subject='Creating a test case and trying to insert subject on this case as Test subject created for testing. This case is to check the character length greater than 210 Characters. This is for testing GGO and VSTS integration through ESI.';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='test';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='';
            cs1.ContactId= con1.Id;
            //cs1.ProductId=product.Id;
            cs1.GGO_Product_Complement__c='';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.Product__c='Checkpoint';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
        
        ESC_Special_Instruction__c spIns=new ESC_Special_Instruction__c();
            spIns.ESC_Category_Account__c='Premium Support Account';
            spIns.ESC_Instructions__c='B';
            insert spIns;
            
            
            ESC_Case_Special_Instruction__c cSpIns=new ESC_Case_Special_Instruction__c();
            cSpIns.ESC_Special_Instruction__c=spIns.Id;
            cSpIns.ESC_Case__c=cs1.Id;
            insert cSpIns;
        
        List<FeedItem> feedList= new List<FeedItem>();
        FeedItem feed = new FeedItem();
            feed.Type= 'TextPost';
            feed.body='@BR_LE_Development_Legal_One test';
            feed.parentId=cs1.Id;
            insert feed;
            feedList.add(feed);
            
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
        Map<Id,List<String>> caseIdMap = new Map<Id,List<String>>();
        List<String> tempList= new List<String>();
            //tempList.add(Object listElement)
            //caseIdMap.put(feed.parentId,);
            
            test.startTest();  
        
        ESC_VSTSstagingUpdate.updateVSTSstaging(feedList);
        test.stopTest();
        
      }
      
      static testmethod void VSTSUpdateMethod2(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
        ESC_VSTS_Product_List__c productList = new ESC_VSTS_Product_List__c();
            productList.Name='Checkpoint';
            insert productList;
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts18', Email='Tuvsts18@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts18', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts18@ss.com');
            insert testUser;
          
        Account acc= new Account();
          acc.Name='Test';
          acc.SAPAccountNumber__c='';
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
            con1.ESC_IsAllowRepDB__c=true;
            insert con1;
        
        
            //insert case
        List <Case> listCase= new List<Case>();
        Case cs1=new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.AccountId=acc.Id;
            cs1.OwnerId=testUser.Id;
            cs1.Description='';
            cs1.ESC_VSTS_Description__c = 'test';
            cs1.subject='test';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='test';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='';
            cs1.ContactId= con1.Id;
            //cs1.ProductId=product.Id;
            cs1.GGO_Product_Complement__c='';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.Product__c='Checkpoint';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
        
        ESC_Special_Instruction__c spIns=new ESC_Special_Instruction__c();
            spIns.ESC_Category_Account__c='Premium Support Account';
            spIns.ESC_Instructions__c='B';
            insert spIns;
            
            
            ESC_Case_Special_Instruction__c cSpIns=new ESC_Case_Special_Instruction__c();
            cSpIns.ESC_Special_Instruction__c=spIns.Id;
            cSpIns.ESC_Case__c=cs1.Id;
            insert cSpIns;
        
        List<FeedItem> feedList= new List<FeedItem>();
        FeedItem feed = new FeedItem();
            feed.Type= 'TextPost';
            feed.body='@BR_LE_Development_Legal_One test';
            feed.parentId=cs1.Id;
            insert feed;
            feedList.add(feed);
            
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
        Map<Id,List<String>> caseIdMap = new Map<Id,List<String>>();
        List<String> tempList= new List<String>();
            //tempList.add(Object listElement)
            //caseIdMap.put(feed.parentId,);
            
            test.startTest();  
        
        ESC_VSTSstagingUpdate.updateVSTSstaging(feedList);
        test.stopTest();
        
      }
      static testmethod void VSTSUpdateMethod3(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
        ESC_VSTS_Product_List__c productList = new ESC_VSTS_Product_List__c();
            productList.Name='Checkpoint';
            insert productList;
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts18', Email='Tuvsts18@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts18', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts184@ss.com');
            insert testUser;
          
        Account acc= new Account();
          acc.Name='Test';
          acc.SAPAccountNumber__c='1000000000';
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
            con1.ESC_IsAllowRepDB__c=true;
            insert con1;
        
        
            //insert case
        List <Case> listCase= new List<Case>();
        Case cs1=new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.AccountId=acc.Id;
            cs1.OwnerId=testUser.Id;
            cs1.Description='test';
            cs1.ESC_VSTS_Description__c = 'test';
            cs1.subject='';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Assistive Technology';
            cs1.ESC_Severity__c='Critical';
            cs1.Priority='3 - Low';
            cs1.ContactId= con1.Id;
            //cs1.ProductId=product.Id;
            cs1.GGO_Product_Complement__c='';
            //cs1.GGO_Product_Complement_2__c = 'API';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.Product__c='Checkpoint';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
        
        ESC_Special_Instruction__c spIns=new ESC_Special_Instruction__c();
            spIns.ESC_Category_Account__c='Premium Support Account';
            spIns.ESC_Instructions__c='A';
            insert spIns;
            
            
            ESC_Case_Special_Instruction__c cSpIns=new ESC_Case_Special_Instruction__c();
            cSpIns.ESC_Special_Instruction__c=spIns.Id;
            cSpIns.ESC_Case__c=cs1.Id;
            insert cSpIns;
        
        List<FeedItem> feedList= new List<FeedItem>();
        FeedItem feed = new FeedItem();
            feed.Type= 'TextPost';
            feed.body='@BR_LE_Development_Legal_One test';
            feed.parentId=cs1.Id;
            insert feed;
            feedList.add(feed);
            
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
        Map<Id,List<String>> caseIdMap = new Map<Id,List<String>>();
        List<String> tempList= new List<String>();
            //tempList.add(Object listElement)
            //caseIdMap.put(feed.parentId,);
            
            test.startTest();  
        
        ESC_VSTSstagingUpdate.updateVSTSstaging(feedList);
        test.stopTest();
        
      }
      
      static testmethod void VSTSUpdate_feedComment(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        String RefError= Label.VSTS_Referal_Role_Msg;
        String Duplicate= Label.VSTS_Duplicate_Ref;
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
        ESC_VSTS_Product_List__c productList = new ESC_VSTS_Product_List__c();
            productList.Name='Checkpoint';
            insert productList;
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts19', Email='Tuvsts19@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts19', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts19@ss.com');
            insert testUser;
            
        Account acc= new Account();
          acc.Name='Test';
          acc.SAPAccountNumber__c='Test123';
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
            con1.ESC_IsAllowRepDB__c=true;
            insert con1;
            
        
        
            //insert case
        List <Case> listCase= new List<Case>();
        Case cs1=new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.AccountId=acc.Id;
            cs1.OwnerId=testUser.Id;
            cs1.Description='testDescription';
            cs1.subject='test';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Content Explanation';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='2 - Medium';
            cs1.ContactId= con1.Id;
            //cs1.ProductId=product.Id;
            cs1.Product__c='Checkpoint';
            cs1.GGO_Product_Complement__c='Test';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
        
        FeedItem feed = new FeedItem();
            feed.Type= 'TextPost';
            feed.body='@BR_LE_Development_Legal_One test';
            feed.parentId=cs1.Id;
            insert feed;
        
        List<FeedComment> feedCommentList= new List<FeedComment>();
        FeedComment feedComment = new FeedComment();
            feedComment.CommentType= 'TextComment';
            feedComment.commentbody='@BR_LE_Development_Legal_One test';
            feedComment.FeedItemId=feed.Id;
            insert feedComment;
            feedCommentList.add(feedComment);
            
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
        Map<Id,List<String>> caseIdMap = new Map<Id,List<String>>();
        List<String> tempList= new List<String>();
            //tempList.add(Object listElement)
            //caseIdMap.put(feed.parentId,);
            
        test.startTest();
        ESC_VSTSstagingUpdate.updateVSTSstaging(feedCommentList);
        test.stopTest();
        
      }
              public static testmethod void test_ESC_Referral_Field_UpdatesPB()
      {
          Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        try{
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        Profile profile1 = [SELECT Id FROM Profile where Name='System Administrator'];
        
        User testUser = new User(Alias = 'Tuvsts19', Email='Tuvsts19@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts19', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts19@ss.com');
            insert testUser;
            
            
        
        User testUser2 = new User(Alias = 'Tuvsts20', Email='Tuvsts20@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts20', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile1.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts20@ss.com');
            insert testUser2;
            
            ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
        Account acc= new Account();
          acc.Name='Test';
          acc.SAPAccountNumber__c='Test123';
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
            con1.ESC_IsAllowRepDB__c=true;
            insert con1;
            
        
        
            //insert case
        List <Case> listCase= new List<Case>();
        Case cs1=new Case();
            cs1.ESC_Impact__c = '1-Whole Site';
            cs1.AccountId=acc.Id;
            cs1.OwnerId=testUser.Id;
            cs1.Description='testDescription';
            cs1.subject='test';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Content Explanation';
            cs1.ESC_Severity__c='1 - High';
            cs1.Priority='2 - Medium';
            cs1.ContactId= con1.Id;
            cs1.LCRM_Sub_BU__c=VSTSRouting.VSTSSub_BU__c;
            cs1.Product__c='Checkpoint';
            cs1.GGO_Product_Complement__c='Test';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
        test.starttest();
        ESC_Case_Collaborator__c referral_VSTS = new ESC_Case_Collaborator__c();
            referral_VSTS.ESC_Case__c= cs1.Id;
            referral_VSTS.OwnerId= grp.Id;
            referral_VSTS.ESC_Referral_Status__c='New';
            referral_VSTS.ESC_Role__c='Accountable Resolver';
            

            insert referral_VSTS;
        
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            referral.RecordtypeID=Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();

            insert referral;
            
            system.debug(referral);
            referral.ESC_Referral_Status__c='Closed';
            update referral;
            
            ESC_Case_Collaborator__c referral1 = new ESC_Case_Collaborator__c();
            referral1.ESC_Case__c= cs1.Id;
            referral1.OwnerId= testUser.Id;
            referral1.ESC_Referral_Status__c='New';
            referral1.ESC_Role__c='Escalation';
            referral1.RecordtypeID=Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Escalations').getRecordTypeId();

            insert referral1;
            system.debug(referral1);
            system.runas(testUser2)
            {
                ESC_Case_Collaborator__c testcc=[Select id from ESC_Case_Collaborator__c where id=:referral1.id];
                testcc.ESC_Role__c='Accountable Resolver';
                update testcc;
            }
            test.stoptest();
            }
            catch(Exception e)
            {
                system.debug(e);
            }
      }
}