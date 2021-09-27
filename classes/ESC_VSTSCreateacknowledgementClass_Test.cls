@isTest(SeeAllData=false)
public class ESC_VSTSCreateacknowledgementClass_Test{
    /*This is the combined test class for 
    +ESC_VSTSCreateacknowledgementClass
    +ESC_VSTS_StatusfromVSTS
    +ESC_VSTS_LastCommentUpdatefromVSTS
    */
    
    
   testMethod static void Method1(){
        
         Test.startTest();
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'Tuvsts15', Email='Tuvsts15@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Tuvsts15', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts15@ss.com');
          insert u;

         //Insert a Account Record     
          Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
          insert testAccount;
          
          //Insert a Contact Record 
          Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
          testContact.FirstName='test';
          insert testContact;
          
          //Insert a List of Cases
          List <Case> listcase= new List<Case>();
          Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'Work in Progress');
          testCase.ESC_Impact__c = '1-Whole Site';
          testCase.subject='tst';
          testCase.ESC_Customer_Symptom__c='Content Addition';
          testCase.ESC_Diagnosis_Summary__c='Content Explanation';
          testCase.ESC_Severity__c='1 - High';
          testCase.ESC_Case_Type__c = 'Request for Service';
          testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
          testCase.description='DESC';
          //testCase.='11111';
          testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
         //insert testCase;
          listcase.add(testCase);
          insert listcase;
    
          //Case created is assign to particular Queue and Queue is consist of group of member.
          Group g = new Group();
          g.Name = 'Test';
          g.type='Queue';
          insert g;
          
          
          //As we create mappingObject to map user with the particular queue or Group
          QueueSobject mappingObject = new QueueSobject(QueueId = g.Id, SobjectType = 'ESC_Case_Collaborator__c');
          System.runAs(new User(Id = UserInfo.getUserId()))
          {insert mappingObject;}
        
          GroupMember gm = new GroupMember(
        GroupId = g.id,
        UserOrGroupId = u.id
        );
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert gm;}
        
          
         //Custom Object - ESC_Case_Collaborator__c (Referral) As created case can be referred to a group
          ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
          ref.ESC_Role__c='Collaborator';
          ref.Ownerid=g.id;
          ref.ESC_Case__c=listcase[0].id;
          ref.ESC_Referral_Status__c='New';
          ref.ESC_End_Date__c=null;
          
          
          List<ESC_Case_Collaborator__c> cclist = new List<ESC_Case_Collaborator__c>();
          cclist.add(ref);
          insert cclist;
          
          
          //ESC_Staging_Object to hold the records to be sent to Service Now
          List<ESC_VSTS_Staging__c>  stagList=new List<ESC_VSTS_Staging__c>();  
          ESC_VSTS_Staging__c staging=new ESC_VSTS_Staging__c();
          staging.ESC_Case_Description__c='descriptionTest';
          staging.ESC_Referral_Id__c=ref.id;
          staging.ESC_Case_Number__c=testcase.CaseNumber;
          staging.ESC_Last_Comment_from_VSTS__c='transmitstatustest';
          staging.ESC_Last_Statusfrom_VSTS__c='Closed';
          staging.ESC_VSTS_Id__c='false';
          stagList.add(staging);
          insert stagList;
          
          List<Case> caseList1= new List<Case>();
          testCase.ESC_VSTS_Id__c = staging.ESC_VSTS_Id__c;
          caseList1.add(testCase);
          update caseList1;
          
            //Update listcase;
    ESC_VSTSCreateacknowledgementClass.VSTSCreateacknowledgementMethod(stagList);
   
   // ESC_VSTS_StatusfromVSTS.VSTSStatusUpdate(stagList);
   // ESC_VSTS_LastCommentUpdatefromVSTS.VSTSPostCreation(stagList);
    
    }
    
  
    static testMethod void testMethod2()
        {
              
          Profile profile = [SELECT Id FROM Profile where Name='LatAM Helpdesk Agent'];
        
          User testUser = new User(Alias = 'Tuvsts16', Email='Tuvsts16@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Tuvsts16', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Tuvsts16@ss.com');
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
    
    
           List<ESC_VSTS_Staging__c> StagingList= New List<ESC_VSTS_Staging__c>();
          
            Test.startTest(); 
          ESC_VSTSCreateacknowledgementClass.VSTSCreateacknowledgementMethod(StagingList);
            Test.stopTest();
           
}

}