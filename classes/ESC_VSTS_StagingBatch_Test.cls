@isTest(SeeAllData=false)
public class ESC_VSTS_StagingBatch_Test
{
        static testMethod void testMethod1()
        {
              
          Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
          User testUser = new User(Alias = 'Tuvsts6', Email='Tuvsts6@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts6', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts6@ss.com');
            insert testUser;
      
        ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
        cs.Name='VSTS Scheduler Settings';
        cs.ESC_BatchSchedule_Interval__c=10;
        cs.ESC_Current_Job_ID__c='';
        cs.ESC_BatchSize__c=200;
        cs.ESC_EmailBody__c='The following records of the VSTS Staging Records are failed permanently.';
        cs.ESC_From_Address__c='Thomson Reuters Customer Support';
        cs.ESC_Subject__c='Salesforce VSTS Staging Failed records List';
        cs.ESC_To_Address__c='customersupportuki@tr.com';
        cs.ESC_No_Of_Retries__c= 5;
        cs.ESC_Query_Limit__c=50000 ;
        //cs.Other fiels values
        insert cs ;
        
        
         /*  
         
        //VSTS Routing Custom Setting
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
        */
            
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
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
    
            string DBError='big error';
            string emailbody='big error email';
   
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
           vs.ESC_RequestType__c='Create';
           vs.ESC_Staging_Status__c='Pending';
           vs.ESC_Case_Owner__c=cs1.OwnerId;
           StagingList.add(vs);
           insert StagingList;
           
           
            System.debug('vs.ESC_Case_Number__c----> ' + vs.ESC_Case_Number__c);
           System.debug('vs.Id----> ' + vs.Id);
           System.debug('vs----> ' + vs);
           
           System.debug('StagingList.ESC_Case_Number__c----> ' + StagingList[0].ESC_Case_Number__c);
           System.debug('StagingList.Id----> ' + StagingList[0].Id);
           System.debug('StagingList----> ' + StagingList);
           
           //This provides a setting to maintain all standard integration settings (e.g. Endpoint, Timeout etc.)
        ESC_VSTS_Integration_Setting__c intsett = new ESC_VSTS_Integration_Setting__c();
        intsett.Name = 'CreateVSTS';
        intsett.ESC_Enable_Logging__c = true;
        intsett.ESC_Endpoint_Server__c = 'https://esi-dev.thomsonreuters.com/';
        intsett.ESC_Endpoint_URI__c = '/osb/CaseManagement_Service/CaseManagement_REST/createTicket';
        intsett.ESC_HTTP_Headers__c = 'Content-Type=>application/json;Authorization=>Basic ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz';
        intsett.ESC_HTTP_Method__c = 'POST';
        intsett.ESC_Timeout__c = 120.0;
        insert intsett;
      
            Test.startTest(); 
            ESC_VSTS_StagingBatch obj = new ESC_VSTS_StagingBatch(); 
            DataBase.executeBatch(obj); 
            Test.stopTest();
           
}

    static testMethod void testMethod2()
        {
              
          Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
          User testUser = new User(Alias = 'Tuvsts7', Email='Tuvsts7@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts7', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts7@ss.com');
            insert testUser;
      
        ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
        cs.Name='VSTS Scheduler Settings';
        cs.ESC_BatchSchedule_Interval__c=10;
        cs.ESC_Current_Job_ID__c='';
        cs.ESC_BatchSize__c=200;
        cs.ESC_EmailBody__c='The following records of the VSTS Staging Records are failed permanently.';
        cs.ESC_From_Address__c='Thomson Reuters Customer Support';
        cs.ESC_Subject__c='Salesforce VSTS Staging Failed records List';
        cs.ESC_To_Address__c='customersupportuki@tr.com';
        cs.ESC_No_Of_Retries__c= 5;
        cs.ESC_Query_Limit__c=50000 ;
        //cs.Other fiels values
        insert cs ;
        
        
         /*  
         
        //VSTS Routing Custom Setting
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
        */
            
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
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
    
            string DBError='big error';
            string emailbody='big error email';
   
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
           vs.ESC_RequestType__c='Update';
           vs.ESC_Staging_Status__c='Pending';
           vs.ESC_Case_Owner__c=cs1.OwnerId;
           StagingList.add(vs);
           insert StagingList;
           
           
            System.debug('vs.ESC_Case_Number__c----> ' + vs.ESC_Case_Number__c);
           System.debug('vs.Id----> ' + vs.Id);
           System.debug('vs----> ' + vs);
           
           System.debug('StagingList.ESC_Case_Number__c----> ' + StagingList[0].ESC_Case_Number__c);
           System.debug('StagingList.Id----> ' + StagingList[0].Id);
           System.debug('StagingList----> ' + StagingList);
           
           //This provides a setting to maintain all standard integration settings (e.g. Endpoint, Timeout etc.)
        ESC_VSTS_Integration_Setting__c intsett = new ESC_VSTS_Integration_Setting__c();
        intsett.Name = 'UpdateVSTS';
        intsett.ESC_Enable_Logging__c = true;
        intsett.ESC_Endpoint_Server__c = 'https://esi-dev.thomsonreuters.com/';
        intsett.ESC_Endpoint_URI__c = '/osb/CaseManagement_Service/CaseManagement_REST/createTicket';
        intsett.ESC_HTTP_Headers__c = 'Content-Type=>application/json;Authorization=>Basic ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz';
        intsett.ESC_HTTP_Method__c = 'POST';
        intsett.ESC_Timeout__c = 120.0;
        insert intsett;
      
            Test.startTest(); 
            ESC_VSTS_StagingBatch obj = new ESC_VSTS_StagingBatch(); 
            DataBase.executeBatch(obj); 
            Test.stopTest();
           
}

    static testMethod void testMethod3()
        {
              
          Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
          User testUser = new User(Alias = 'Tuvsts8', Email='Tuvsts8@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts8', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts8@ss.com');
            insert testUser;
      
        ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
        cs.Name='VSTS Scheduler Settings';
        cs.ESC_BatchSchedule_Interval__c=10;
        cs.ESC_Current_Job_ID__c='';
        cs.ESC_BatchSize__c=200;
        cs.ESC_EmailBody__c='The following records of the VSTS Staging Records are failed permanently.';
        cs.ESC_From_Address__c='Thomson Reuters Customer Support';
        cs.ESC_Subject__c='Salesforce VSTS Staging Failed records List';
        cs.ESC_To_Address__c='customersupportuki@tr.com';
        cs.ESC_No_Of_Retries__c= 5;
        cs.ESC_Query_Limit__c=50000 ;
        //cs.Other fiels values
        insert cs ;
        
        
         /*  
         
        //VSTS Routing Custom Setting
        ESC_VSTS_Routing__c VSTSRouting= new ESC_VSTS_Routing__c();
            VSTSRouting.ESC_Referral_Role__c='Accountable Resolver';
            VSTSRouting.VSTSAssignmentGroup__c='BR_LE_Development_Legal_One';
            VSTSRouting.VSTSSub_BU__c='GGO';
            insert VSTSRouting;
        */
            
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
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
    
            string DBError='big error';
            string emailbody='big error email';
   
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
           vs.ESC_RequestType__c='Reopen';
           vs.ESC_Staging_Status__c='Pending';
           vs.ESC_Case_Owner__c=cs1.OwnerId;
           StagingList.add(vs);
           insert StagingList;
           
           
            System.debug('vs.ESC_Case_Number__c----> ' + vs.ESC_Case_Number__c);
           System.debug('vs.Id----> ' + vs.Id);
           System.debug('vs----> ' + vs);
           
           System.debug('StagingList.ESC_Case_Number__c----> ' + StagingList[0].ESC_Case_Number__c);
           System.debug('StagingList.Id----> ' + StagingList[0].Id);
           System.debug('StagingList----> ' + StagingList);
           
           //This provides a setting to maintain all standard integration settings (e.g. Endpoint, Timeout etc.)
        ESC_VSTS_Integration_Setting__c intsett = new ESC_VSTS_Integration_Setting__c();
        intsett.Name = 'ReopenVSTS';
        intsett.ESC_Enable_Logging__c = true;
        intsett.ESC_Endpoint_Server__c = 'https://esi-dev.thomsonreuters.com/';
        intsett.ESC_Endpoint_URI__c = '/osb/CaseManagement_Service/CaseManagement_REST/createTicket';
        intsett.ESC_HTTP_Headers__c = 'Content-Type=>application/json;Authorization=>Basic ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz';
        intsett.ESC_HTTP_Method__c = 'POST';
        intsett.ESC_Timeout__c = 120.0;
        insert intsett;
      
            Test.startTest(); 
            ESC_VSTS_StagingBatch obj = new ESC_VSTS_StagingBatch(); 
            DataBase.executeBatch(obj); 
            Test.stopTest();
           
}


}