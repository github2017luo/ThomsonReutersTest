@isTest(SeeAllData=false)
public class ESC_VSTS_StatusfromVSTS_Test{
    
    static testmethod void VSTSStatusMethod(){
 
        
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts13', Email='Tuvsts13@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts13', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts13@ss.com');
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
            
        Product2 product = new Product2();
            product.Name='Test';
            insert product;
        
        ESC_Product_Version__c prodVersion = new ESC_Product_Version__c();
            prodVersion.name='Test';
            prodVersion.ESC_Product__c=product.Id;
            insert prodVersion;
        
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
            cs1.ProductId=product.Id;
            cs1.GGO_Product_Complement__c='Test';
            cs1.ESC_Product_Version__c=prodVersion.Id;
            cs1.status ='Work in progress';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
        
         List<case> caselist1 = [select id, CaseNumber from Case where id =: cs1.id];
         
        
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
            
           List<ESC_VSTS_Staging__c> StagingList= New List<ESC_VSTS_Staging__c>();
           ESC_VSTS_Staging__c vs = new ESC_VSTS_Staging__c ();
           vs.ESC_Account_Name__c='Test Account';
           vs.ESC_SAP_Account_Num__c='Test SAP Account';
           vs.ESC_Case_Product__c=cs1.ProductId;
           vs.ESC_Case_Product_Version__c=cs1.ESC_Product_Version__c;
           vs.ESC_Case_Subject__c=cs1.subject;
           vs.ESC_Case_Description__c=cs1.Description;
           vs.ESC_Case_Created_Date__c=system.now();
           vs.ESC_Case_Severity__c=cs1.ESC_Severity__c;
           vs.ESC_Case_Priority__c= cs1.Priority;
           vs.ESC_Case_Diagnosis__c=cs1.ESC_Diagnosis_Summary__c;
            vs.ESC_Case_Number__c = caselist1[0].CaseNumber;
           vs.ESC_Error_Log__c='';
           vs.ESC_Feed_Comment__c='Test Feed Comment';
           vs.ESC_RequestType__c='Create';
           vs.ESC_Staging_Status__c='Pending';
           vs.ESC_Case_Owner__c=cs1.OwnerId;
          vs.ESC_Last_Statusfrom_VSTS__c = 'Closed';
           StagingList.add(vs);
           insert StagingList;
  
           test.startTest();
            ESC_VSTS_StatusfromVSTS.VSTSStatusUpdate(StagingList);
           test.stopTest();
            
    }
      static testmethod void VSTSStatusMethod2(){
 
        
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts14', Email='Tuvsts14@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts14', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts14@ss.com');
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
            
        Product2 product = new Product2();
            product.Name='Test';
            insert product;
        
        ESC_Product_Version__c prodVersion = new ESC_Product_Version__c();
            prodVersion.name='Test';
            prodVersion.ESC_Product__c=product.Id;
            insert prodVersion;
        
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
            cs1.ProductId=product.Id;
            cs1.GGO_Product_Complement__c='Test';
            cs1.ESC_Product_Version__c=prodVersion.Id;
            cs1.status ='Work in progress';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
        
         List<case> caselist1 = [select id, CaseNumber from Case where id =: cs1.id];
         
        
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
            
           List<ESC_VSTS_Staging__c> StagingList1= New List<ESC_VSTS_Staging__c>();
        
           
           test.startTest();
            ESC_VSTS_StatusfromVSTS.VSTSStatusUpdate(StagingList1);
           test.stopTest();
            
    }
    
}