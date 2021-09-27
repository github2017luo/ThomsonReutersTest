@istest
public class ESC_VSTSPB_Test{
    static testmethod void Method1(){
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
        
        test.startTest();
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
            cs1.lcrm_sub_bu__c = 'GGO';
            cs1.GGO_Product_Complement__c='';
            cs1.GGO_Product_Version__c='Test123';
            cs1.status ='New';
            cs1.ESC_Proactive_Type__c='Internal Origin';
            cs1.Product__c='Checkpoint';
            cs1.RecordtypeID=Schema.SObjectType.case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            listcase.add(cs1);
        insert listcase;
        system.assertequals(cs1.status,'New');
    
        List<ESC_Case_Collaborator__c> refList=new List<ESC_Case_Collaborator__c>();
        ESC_Case_Collaborator__c referral = new ESC_Case_Collaborator__c();
            referral.ESC_Case__c= cs1.Id;
            referral.OwnerId= grp.Id;
            referral.ESC_Referral_Status__c='New';
            referral.ESC_Role__c='Accountable Resolver';            
            refList.add(referral);
            insert refList;
        
        test.stopTest();
        
      }
      
      static testMethod void Method2()
    {
       Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
          User testUser = new User(Alias = 'Tuvsts4', Email='Tuvsts4@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='User',FirstName = 'Esi', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts4@ss.com');
            insert testUser;
        
        ESC_ServiceNow_Scheduler_Settings__c cs = new ESC_ServiceNow_Scheduler_Settings__c();
        cs.Name='VSTS Scheduler Settings';
        cs.ESC_BatchSchedule_Interval__c=10;
        cs.ESC_Current_Job_ID__c='';
        cs.ESC_BatchSize__c=200;
        cs.ESC_EmailBody__c='The following records of the VSTS Staging Records are failed permanently.';
        cs.ESC_From_Address__c='Thomson Reuters Customer Support';
        cs.ESC_Subject__c='Salesforce VSTS Staging Failed records List';
        cs.ESC_To_Address__c='customersupportukiuat@tr.com';
        cs.ESC_No_Of_Retries__c= 5;
        cs.ESC_Query_Limit__c=50000 ;
        //cs.Other fiels values
        insert cs ;
       
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
        Test.startTest();
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
        //    insert cs1;
            listcase.add(cs1);
        insert listcase;
        
         System.debug('Case Id---> ' +cs1.Id);
        System.debug('Case Number---> ' +cs1.CaseNumber);
        
        List<case> caselist = [select id, CaseNumber from Case where id =: cs1.id];
         System.debug('Caselist---> ' +caselist);
         System.debug('caselist[0].CaseNumber---> ' +caselist[0].CaseNumber);
        
       
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
           vs.ESC_Error_Log__c='';
           vs.ESC_Feed_Comment__c='Test Feed Comment';
           vs.ESC_RequestType__c='Create';
           vs.ESC_Staging_Status__c='Pending';
           vs.ESC_Case_Owner__c=cs1.OwnerId;
           vs.ESC_Last_Comment_from_VSTS__c='Last Commented Updated';
           vs.ESC_Case_Number__c = caselist[0].CaseNumber;
          // vs.ESC_Last_Comment_from_VSTS__c='Last Commented';
           StagingList.add(vs);
           insert StagingList;
           
          //Process builder Flow Coverage
          ESC_VSTS_Staging__c vs1 = new ESC_VSTS_Staging__c ();
           vs1.ESC_Account_Name__c='Test Account';
           vs1.ESC_SAP_Account_Num__c='Test SAP Account';
           vs1.ESC_Case_Product__c=cs1.ProductId;
           vs1.ESC_Case_Product_Version__c=cs1.ESC_Product_Version__c;
           vs1.ESC_Case_Subject__c=cs1.subject;
           vs1.ESC_Case_Description__c=cs1.Description;
           vs1.ESC_Case_Created_Date__c=system.now();
           vs1.ESC_Case_Severity__c=cs1.ESC_Severity__c;
           vs1.ESC_Case_Priority__c= cs1.Priority;
           vs1.ESC_Case_Diagnosis__c=cs1.ESC_Diagnosis_Summary__c;
           vs1.ESC_Error_Log__c='';
           vs1.ESC_Feed_Comment__c='Test Feed Comment';
           vs1.ESC_RequestType__c='Create';
           vs1.ESC_Staging_Status__c='Pending';
           vs1.ESC_VSTS_Id__c='abc';
           vs1.ESC_Case_Owner__c=cs1.OwnerId;
           vs1.ESC_Last_Statusfrom_VSTS__c='xyz';
           vs1.ESC_Last_Comment_from_VSTS__c='Last Commented Updated';
           vs1.ESC_Case_Number__c = caselist[0].CaseNumber;
          // vs.ESC_Last_Comment_from_VSTS__c='Last Commented';

           insert vs1;
           System.runas(testuser){
           vs1.ESC_VSTS_Id__c='def';
           update vs1;           
           }
                      
          
             
            
            Test.stopTest();
         
    }
}