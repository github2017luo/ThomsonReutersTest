@isTest(SeeAllData=false)
public class ESC_SCIntegrationHelperToVSTS_Test{
    
    static testmethod void VSTSIntegrationMethod(){
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
          User testUser = new User(Alias = 'Tuvsts1', Email='Tuvsts1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts1@ss.com');
            insert testUser;
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
         
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
    
            
   
           
        //List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
        List<Id> InsertList= new List<Id>();
        List<Id> UpdateList= new List<Id>();
        List<Id> ReopenList= new List<Id>();
        List<ESC_VSTS_Staging__c> VSTSUpdateList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Integration_Setting__c integrationdetails = new ESC_VSTS_Integration_Setting__c();
        integrationdetails.Name='CreateVSTS';
        integrationdetails.ESC_Enable_Logging__c=False;
        integrationdetails.ESC_Endpoint_Server__c='https://esi-dev.thomsonreuters.com';
        integrationdetails.ESC_HTTP_Headers__c='Content-Type=>application/json;Authorization=>Basic ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz';
        integrationdetails.ESC_HTTP_Method__c='POST';
        integrationdetails.ESC_Timeout__c=120;
        integrationdetails.ESC_Endpoint_URI__c='/osb/CaseManagement_Service/CaseManagement_REST/createTicket';
        insert integrationdetails;
        
        
            
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
           vs.ESC_Case_Number__c=cs1.CaseNumber;
           vs.ESC_Error_Log__c='';
           vs.ESC_Feed_Comment__c='Test Feed Comment';
           vs.ESC_Feed_Commented_Date__c=System.now();
           vs.ESC_RequestType__c='Create';
           vs.ESC_Staging_Status__c='Pending';
           vs.ESC_Case_Owner__c=cs1.OwnerId;
           StagingList.add(vs);
           insert StagingList;
            InsertList.add(StagingList[0].Id);
            
            
            
            test.startTest();
            ESC_SCIntegrationHelperToVSTS.VSTSCallout(StagingList);
            ESC_SCIntegrationHelperToVSTS.VSTSTicketCreate(InsertList,'CreateVSTS');
            test.stopTest();
        
        
    }
    
    static testmethod void VSTSIntegrationMethod2(){
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
          User testUser = new User(Alias = 'Tuvsts2', Email='Tuvsts2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts2@ss.com');
            insert testUser;
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
         
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
    
        
        List<Id> InsertList= new List<Id>();
        List<Id> UpdateList= new List<Id>();
        List<Id> ReopenList= new List<Id>();
        List<ESC_VSTS_Staging__c> VSTSUpdateList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Integration_Setting__c integrationdetails = new ESC_VSTS_Integration_Setting__c();
        integrationdetails.Name='UpdateVSTS';
        integrationdetails.ESC_Enable_Logging__c=False;
        integrationdetails.ESC_Endpoint_Server__c='https://esi-dev.thomsonreuters.com';
        integrationdetails.ESC_HTTP_Headers__c='Content-Type=>application/json;Authorization=>Basic ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz';
        integrationdetails.ESC_HTTP_Method__c='POST';
        integrationdetails.ESC_Timeout__c=120;
        integrationdetails.ESC_Endpoint_URI__c='/osb/CaseManagement_Service/CaseManagement_REST/createTicket';
        insert integrationdetails;
            
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
           vs.ESC_Case_Number__c=cs1.CaseNumber;
           vs.ESC_Error_Log__c='';
           vs.ESC_Feed_Comment__c='Test Feed Comment';
           vs.ESC_Feed_Commented_Date__c=System.now();
           vs.ESC_RequestType__c='Update';
           vs.ESC_Staging_Status__c='Pending';
           vs.ESC_Case_Owner__c=cs1.OwnerId;
           StagingList.add(vs);
           insert StagingList;
            UpdateList.add(StagingList[0].Id);
            
           test.startTest();
            ESC_SCIntegrationHelperToVSTS.VSTSCallout(stagingList);
            ESC_SCIntegrationHelperToVSTS.VSTSTicketCreate(UpdateList,'UpdateVSTS');
            test.stopTest();
        
        
    }
    
    static testmethod void VSTSIntegrationMethod3(){
        Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
          User testUser = new User(Alias = 'Tuvsts3', Email='Tuvsts3@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts3', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts3@ss.com');
            insert testUser;
        Group grp = [Select id,Name from Group where Type='Queue' and DeveloperName='BR_LE_Development_Legal_One'];
         
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
        
        List<Id> InsertList= new List<Id>();
        List<Id> UpdateList= new List<Id>();
        List<Id> ReopenList= new List<Id>();
        List<ESC_VSTS_Staging__c> VSTSUpdateList = new List<ESC_VSTS_Staging__c>();
        
        ESC_VSTS_Integration_Setting__c integrationdetails = new ESC_VSTS_Integration_Setting__c();
        integrationdetails.Name='ReopenVSTS';
        integrationdetails.ESC_Enable_Logging__c=False;
        integrationdetails.ESC_Endpoint_Server__c='https://esi-dev.thomsonreuters.com';
        integrationdetails.ESC_HTTP_Headers__c='Content-Type=>application/json;Authorization=>Basic ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz';
        integrationdetails.ESC_HTTP_Method__c='POST';
        integrationdetails.ESC_Timeout__c=120;
        integrationdetails.ESC_Endpoint_URI__c='/osb/CaseManagement_Service/CaseManagement_REST/createTicket';
        insert integrationdetails;
        
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
           vs.ESC_Case_Number__c=cs1.CaseNumber;
           vs.ESC_Error_Log__c='';
           vs.ESC_Feed_Comment__c='Test Feed Comment';
           vs.ESC_Feed_Commented_Date__c=System.now();
           vs.ESC_RequestType__c='Reopen';
           vs.ESC_Staging_Status__c='Pending';
           vs.ESC_Case_Owner__c=cs1.OwnerId;
           StagingList.add(vs);
           insert StagingList;
            ReopenList.add(StagingList[0].Id);
        
        
            
           test.startTest();
            ESC_SCIntegrationHelperToVSTS.VSTSCallout(stagingList);
            ESC_SCIntegrationHelperToVSTS.VSTSTicketCreate(ReopenList,'ReopenVSTS');
        test.stopTest(); 
        
        
    }

}