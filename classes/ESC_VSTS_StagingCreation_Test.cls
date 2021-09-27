@isTest(SeeAllData=false)
public class ESC_VSTS_StagingCreation_Test
 {
    
    static testmethod void VSTSStagingCreate(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
            
            ESC_VSTS_Product_List__c prodCs = new ESC_VSTS_Product_List__c();
            prodCs.Name='Checkpoint';
            insert prodCs;
            
            
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts9', Email='Tuvsts9@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts9', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts9@ss.com');
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
            cs1.product__c='Checkpoint';
            cs1.GGO_Product_Complement__c='Test';
            cs1.GGO_Product_Version__c='test';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
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
            
            Map<String,String> specialInstructionMap= new Map<String,String>();
            
        
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
 
            List<id> reflistid = new List<id>();
            for(ESC_Case_Collaborator__c ref : refList ){
                reflistid.add(ref.id);
            }
            
             Test.startTest(); 
          ESC_VSTS_StagingCreation.escVSTSStagingCreation(reflistid);
            Test.stopTest();
      }
      
      static testmethod void VSTSStagingReopen(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
               ESC_VSTS_Product_List__c prodCs = new ESC_VSTS_Product_List__c();
            prodCs.Name='Checkpoint';
            insert prodCs;
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts10', Email='Tuvsts10@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts10', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts10@ss.com');
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
           cs1.product__c='Checkpoint';
            cs1.GGO_Product_Complement__c='Test';
            cs1.GGO_Product_Version__c='Test';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.ESC_VSTS_Id__c='1234';
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
            
            Map<String,String> specialInstructionMap= new Map<String,String>();
            
        
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
            
           List<id> reflistid = new List<id>();
            for(ESC_Case_Collaborator__c ref : refList ){
                reflistid.add(ref.id);
            }
            
             Test.startTest(); 
          ESC_VSTS_StagingCreation.escVSTSStagingCreation(reflistid);
            Test.stopTest();
      }
   
    static testmethod void VSTSStagingCreate1(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
            
            ESC_VSTS_Product_List__c prodCs = new ESC_VSTS_Product_List__c();
            prodCs.Name='Checkpoint';
            insert prodCs;
            
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts11', Email='Tuvsts11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts11', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts11@ss.com');
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
            cs1.Description='';
            cs1.subject='Creating a test case and trying to insert subject on this case as Test subject created for testing. This case is to check the character length greater than 210 Characters. This is for testing GGO and VSTS integration through ESI.';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='';
            cs1.ESC_Severity__c='';
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
        
           // Case cs2=new Case();
            
            
            ESC_Special_Instruction__c spIns=new ESC_Special_Instruction__c();
            spIns.ESC_Category_Account__c='Premium Support Account';
            spIns.ESC_Instructions__c='A';
            insert spIns;
            
            
            ESC_Case_Special_Instruction__c cSpIns=new ESC_Case_Special_Instruction__c();
            cSpIns.ESC_Special_Instruction__c=spIns.Id;
            cSpIns.ESC_Case__c=cs1.Id;
            insert cSpIns;
            
            Map<String,String> specialInstructionMap= new Map<String,String>();
            
        /*
         cs1.product__c='Checkpoint';
         cs1.ESC_Diagnosis_Summary__c='';
            cs1.ESC_Severity__c='';
            cs1.Priority='';
             cs1.subject='test';
              cs1.ContactId= con1.Id;
               cs1.AccountId=acc.Id;
            
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            
            listcase.add(cs1);
          
        insert listcase;
         */  
        
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
             List<id> reflistid = new List<id>();
            for(ESC_Case_Collaborator__c ref : refList ){
                reflistid.add(ref.id);
            }
            
             Test.startTest(); 
          ESC_VSTS_StagingCreation.escVSTSStagingCreation(reflistid);
            Test.stopTest();
      }
      
   
      static testmethod void VSTSStagingReopen1(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
               ESC_VSTS_Product_List__c prodCs = new ESC_VSTS_Product_List__c();
            prodCs.Name='Checkpoint';
            insert prodCs;
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts12', Email='Tuvsts12@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts12', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts12@ss.com');
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
            cs1.Description='';
            cs1.subject='';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='';
            cs1.ESC_Severity__c='';
            cs1.Priority='';
            cs1.ContactId= con1.Id;
            //cs1.ProductId=product.Id;
            cs1.GGO_Product_Complement__c='';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.Product__c='Checkpoint';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            cs1.ESC_VSTS_Id__c='1234';
            listcase.add(cs1);
        insert listcase;
        
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
           List<id> reflistid = new List<id>();
            for(ESC_Case_Collaborator__c ref : refList ){
                reflistid.add(ref.id);
            }
            
             Test.startTest(); 
          ESC_VSTS_StagingCreation.escVSTSStagingCreation(reflistid);
            Test.stopTest();
      }
      static testmethod void VSTSStagingCreate2(){
        List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
            
            
            ESC_VSTS_Product_List__c prodCs = new ESC_VSTS_Product_List__c();
            prodCs.Name='Checkpoint';
            insert prodCs;
            
            
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
        
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
        User testUser = new User(Alias = 'Tuvsts11', Email='Tuvsts112@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts11', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts112@ss.com');
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
            //cs1.SAP_Account_Number__c ='';
            cs1.subject='';
            cs1.ESC_Customer_Symptom__c='Content Addition';
            cs1.ESC_Diagnosis_Summary__c='Assistive Technology';
            cs1.ESC_Severity__c='Critical';
            cs1.Priority='';
            cs1.ContactId= con1.Id;
            //cs1.ProductId=product.Id;
            //cs1.GGO_Product_Complement_2__c='API';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.Product__c='Checkpoint';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
           
            listcase.add(cs1);
             insert listcase;
        
           // Case cs2=new Case();
            
            
            ESC_Special_Instruction__c spIns=new ESC_Special_Instruction__c();
            spIns.ESC_Category_Account__c='Premium Support Account';
            spIns.ESC_Instructions__c='A';
            insert spIns;
            
            
            ESC_Case_Special_Instruction__c cSpIns=new ESC_Case_Special_Instruction__c();
            cSpIns.ESC_Special_Instruction__c=spIns.Id;
            cSpIns.ESC_Case__c=cs1.Id;
            insert cSpIns;
            
            Map<String,String> specialInstructionMap= new Map<String,String>();
            
        /*
         cs1.product__c='Checkpoint';
         cs1.ESC_Diagnosis_Summary__c='';
            cs1.ESC_Severity__c='';
            cs1.Priority='';
             cs1.subject='test';
              cs1.ContactId= con1.Id;
               cs1.AccountId=acc.Id;
            
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            
            listcase.add(cs1);
          
        insert listcase;
         */  
        
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';
            refList.add(referral);
            insert refList;
            
             List<id> reflistid = new List<id>();
            for(ESC_Case_Collaborator__c ref : refList ){
                reflistid.add(ref.id);
            }
            
             Test.startTest(); 
          ESC_VSTS_StagingCreation.escVSTSStagingCreation(reflistid);
            Test.stopTest();
      }
}