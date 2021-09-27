@isTest
public class ESC_IntegrationUtil_Test{
    
    static testmethod void IntegrationUtilTestMethod1(){
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      

    UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
    insert r;

  User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
      insert u;
      
       

    System.RunAs(u)
     {
        
         USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESCWriteoffBoomiIntegration',Username__c='test',Password__c='test',Endpoint__c='https://api-test.thomsonreuters.com/dep/ordermanagement/v1/writeoff');
        insert websrv;
        
   Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='Canada';
      testAccount.Bu_Segment__c='Professional Legal';
      testAccount.BillingCity = 'PORT ANGELES';
        testAccount.BillingCountry ='US';
        testAccount.BillingState = 'WA';
        testAccount.BillingPostalCode = '98363-8409';
        testAccount.BillingStreet = '2851 LOWER ELWHA RD';
      insert testAccount;
  //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      insert testContact;

      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'new');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.USL_SAP_Account_Number__c = '2000000418';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
      testCase.ESC_Apply_Entitlement_Milestone__c=True;
      insert testCase;
      listcase.add(testCase);
          
      GenerateForm__C GF= new GenerateForm__C();
        GF.Name='Write Off Form';
        Insert GF;
      
      ESC_Case_Form_Extension__c ESCCFE = new ESC_Case_Form_Extension__c();
            ESCCFE.ESC_Form__c=GF.id;
            ESCCFE.ESC_Case__c=testcase.id;
            ESCCFE.USL_Approval_Type__c='Writeoff';
            ESCCFE.ESC_Form_BU__c='Tax Profs - Software';
            ESCCFE.USL_Requester_Title__c=' Mr.';
            ESCCFE.USL_Requestor_ID__c='Testing';
            ESCCFE.USL_Total_Amount__c=450;
            ESCCFE.USL_CSSWriteOffFormTypeID__c = '718';
            ESCCFE.Route_To_USL_Print_CD_Credits__c=true;
            ESCCFE.USL_Is_Processed__c = false;
            insert ESCCFE;
             ESCCFE.USL_Approval_Status__c='Approved';
             update ESCCFE;
            
            
           /* ESC_Case_Form_Extension_Line_Item__c  ESCCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine.ESC_Billing_Doc__c='6123872804';
            ESCCFELine.ESC_Line__c='000010';
            ESCCFELine.ESC_Net_Amount__c=3000;
            ESCCFELine.ESC_Tax_Amount__c=97;
            ESCCFELine.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            //ESCCFELine.USL_ODocType__c='YW';
            ESCCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine.ESC_Request_Description__c='Westlaw';
            ESCCFELine.ESC_Type__c='Partial';
           
            //ESCCFELine.ESC_Item_Amount__c=30000;
            //ESCCFELine.USL_Input_Amount__c=1126;
             insert ESCCFELine;*/
            
            
            ESC_Case_Form_Extension_Line_Item__c  ESCCFELine1 =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine1.ESC_Billing_Doc__c='79000000095';
            ESCCFELine1.ESC_Line__c='0010';
            ESCCFELine1.ESC_Net_Amount__c=40;
            ESCCFELine1.USL_Input_Amount__c=0.45;
            ESCCFELine1.ESC_Item_Amount__c = 0.45;
            ESCCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            ESCCFELine1.USL_ODocType__c='YM';
            ESCCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine1.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine1.ESC_Type__c='FUll';
            ESCCFELine1.ESC_Request_Description__c='Non-Westlaw';
            //ESCCFELine1.ESC_Item_Amount__c=30000;
           // ESCCFELine1.USL_Input_Amount__c=1126;
            //ESCCFELine1.USL_Invoice_Type__c='Clear';
             insert ESCCFELine1;
      
      
       set<id> caseextset = new set<id>();
      caseextset.add(ESCCFE.id);
    
       Test.startTest();
     
       Test.setMock(HttpCalloutMock.class, new ESC_WriteOfFormMockClass());
       Test.stopTest();
    
    }
    }
    
    static testmethod void IntegrationUtilTestMethod2(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      

    UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
    insert r;

  User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
      insert u;
      
       

    System.RunAs(u)
     {
        
         USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESC_CCBoomiIntegration',Username__c='test',Password__c='test',Endpoint__c='https://api-test.thomsonreuters.com/dep/ordermanagement/v1/writeoff');
        insert websrv;
        
   Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='UZ';
      testAccount.Bu_Segment__c='Professional Tax';
      testAccount.BillingCity = 'PORT ANGELES';
        testAccount.BillingCountry ='US';
        testAccount.BillingState = 'WA';
        testAccount.BillingPostalCode = '98363-8409';
        testAccount.BillingStreet = '2851 LOWER ELWHA RD';
      insert testAccount;
  //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      insert testContact;

      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'new');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.USL_SAP_Account_Number__c = '2000000418';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
      testCase.ESC_Apply_Entitlement_Milestone__c=True;
      insert testCase;
      listcase.add(testCase);
          
      GenerateForm__C GF= new GenerateForm__C();
        GF.Name='Charge Cancellation';
        Insert GF;
      
      ESC_Case_Form_Extension__c ESCCFE = new ESC_Case_Form_Extension__c();
            ESCCFE.ESC_Form__c=GF.id;
            ESCCFE.ESC_Case__c=testcase.id;
            ESCCFE.USL_Approval_Type__c='Tax Profs - Software';
            ESCCFE.ESC_Form_BU__c='Tax Profs - Software';
            ESCCFE.USL_Requester_Title__c=' Mr.';
            ESCCFE.USL_Requestor_ID__c='Testing';
            ESCCFE.USL_Total_Amount__c=450;
            ESCCFE.USL_CSSWriteOffFormTypeID__c = '718';
            ESCCFE.Route_To_USL_Print_CD_Credits__c=true;
            ESCCFE.USL_Is_Processed__c = false;
            insert ESCCFE;
             ESCCFE.USL_Approval_Status__c='Approved';
             update ESCCFE;
            
            
           /* ESC_Case_Form_Extension_Line_Item__c  ESCCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine.ESC_Billing_Doc__c='6123872804';
            ESCCFELine.ESC_Line__c='000010';
            ESCCFELine.ESC_Net_Amount__c=3000;
            ESCCFELine.ESC_Tax_Amount__c=97;
            ESCCFELine.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            //ESCCFELine.USL_ODocType__c='YW';
            ESCCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine.ESC_Request_Description__c='Westlaw';
            ESCCFELine.ESC_Type__c='Partial';
           
            //ESCCFELine.ESC_Item_Amount__c=30000;
            //ESCCFELine.USL_Input_Amount__c=1126;
             insert ESCCFELine;*/
            
            
            ESC_Case_Form_Extension_Line_Item__c  ESCCFELine1 =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine1.ESC_Billing_Doc__c='79000000096';
            ESCCFELine1.ESC_Line__c='0010';
            ESCCFELine1.ESC_Net_Amount__c=40;
            ESCCFELine1.USL_Input_Amount__c=0.45;
            ESCCFELine1.ESC_Item_Amount__c = 0.45;
            ESCCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            ESCCFELine1.USL_ODocType__c='YM';
            ESCCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine1.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine1.ESC_Type__c='FUll';
            ESCCFELine1.ESC_Request_Description__c='Non-Westlaw';
            //ESCCFELine1.ESC_Item_Amount__c=30000;
           // ESCCFELine1.USL_Input_Amount__c=1126;
            //ESCCFELine1.USL_Invoice_Type__c='Clear';
             insert ESCCFELine1;
      
      
       set<id> caseextset = new set<id>();
      caseextset.add(ESCCFE.id);
    
       Test.startTest();
         Test.setMock(HttpCalloutMock.class, new ESC_WriteOfFormMockClass());
          ESC_CaseFormExtensionResponseWrapper oWrapper = new ESC_CaseFormExtensionResponseWrapper();
          ESC_CaseFormExtensionRequestWrapper oWrapper1 = new ESC_CaseFormExtensionRequestWrapper();
       Test.stopTest();
      
    }
    
   }
   
   static testmethod void IntegrationUtilTestMethod4(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      

    UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
    insert r;

  User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
      insert u;
      
       

    System.RunAs(u)
     {
        
         USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESC_CCBoomiIntegration',Username__c='test',Password__c='test',Endpoint__c='https://api-test.thomsonreuters.com/dep/ordermanagement/v1/writeoff');
        insert websrv;
        
   Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='UZ';
      testAccount.Bu_Segment__c='Professional Tax';
      testAccount.BillingCity = 'PORT ANGELES';
        testAccount.BillingCountry ='US';
        testAccount.BillingState = 'WA';
        testAccount.BillingPostalCode = '98363-8409';
        testAccount.BillingStreet = '2851 LOWER ELWHA RD';
      insert testAccount;
  //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      insert testContact;

      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'new');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.USL_SAP_Account_Number__c = '2000000418';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
      testCase.ESC_Apply_Entitlement_Milestone__c=True;
      insert testCase;
      listcase.add(testCase);
          
      GenerateForm__C GF= new GenerateForm__C();
        GF.Name='Charge Cancellation';
        Insert GF;
      
      ESC_Case_Form_Extension__c ESCCFE = new ESC_Case_Form_Extension__c();
            ESCCFE.ESC_Form__c=GF.id;
            ESCCFE.ESC_Case__c=testcase.id;
            ESCCFE.USL_Approval_Type__c='Tax Profs - Software';
            ESCCFE.ESC_Form_BU__c='Tax Profs - Software';
            ESCCFE.USL_Requester_Title__c=' Mr.';
            ESCCFE.USL_Requestor_ID__c='Testing';
            ESCCFE.USL_Total_Amount__c=450;
            ESCCFE.USL_CSSWriteOffFormTypeID__c = '718';
            ESCCFE.Route_To_USL_Print_CD_Credits__c=true;
            ESCCFE.USL_Is_Processed__c = false;
            insert ESCCFE;
             ESCCFE.USL_Approval_Status__c='Approved';
             update ESCCFE;
            
            
           /* ESC_Case_Form_Extension_Line_Item__c  ESCCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine.ESC_Billing_Doc__c='6123872804';
            ESCCFELine.ESC_Line__c='000010';
            ESCCFELine.ESC_Net_Amount__c=3000;
            ESCCFELine.ESC_Tax_Amount__c=97;
            ESCCFELine.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            //ESCCFELine.USL_ODocType__c='YW';
            ESCCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine.ESC_Request_Description__c='Westlaw';
            ESCCFELine.ESC_Type__c='Partial';
           
            //ESCCFELine.ESC_Item_Amount__c=30000;
            //ESCCFELine.USL_Input_Amount__c=1126;
             insert ESCCFELine;*/
            
            
            ESC_Case_Form_Extension_Line_Item__c  ESCCFELine1 =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine1.ESC_Billing_Doc__c='79000000095';
            //ESCCFELine1.ESC_Line__c='0010';
            ESCCFELine1.ESC_Net_Amount__c=40;
            ESCCFELine1.USL_Input_Amount__c=0.45;
            ESCCFELine1.ESC_Item_Amount__c = 0.45;
            ESCCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            ESCCFELine1.USL_ODocType__c='YM';
            ESCCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine1.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine1.ESC_Type__c='FUll';
            ESCCFELine1.ESC_Request_Description__c='Non-Westlaw';
            //ESCCFELine1.ESC_Item_Amount__c=30000;
           // ESCCFELine1.USL_Input_Amount__c=1126;
            //ESCCFELine1.USL_Invoice_Type__c='Clear';
             insert ESCCFELine1;
      
      
       set<id> caseextset = new set<id>();
      caseextset.add(ESCCFE.id);
    
       Test.startTest();
         Test.setMock(HttpCalloutMock.class, new ESC_WriteOfFormMockClass());
          ESC_CaseFormExtensionResponseWrapper oWrapper = new ESC_CaseFormExtensionResponseWrapper();
          ESC_CaseFormExtensionRequestWrapper oWrapper1 = new ESC_CaseFormExtensionRequestWrapper();
       Test.stopTest();
      
    }
    
   }
   
   static testmethod void IntegrationUtilTestMethod3(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      

    UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
    insert r;

  User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
      insert u;
      
       

    System.RunAs(u)
     {
        
         USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='ESC_CCBoomiIntegration',Username__c='test',Password__c='test',Endpoint__c='https://api-test.thomsonreuters.com/dep/ordermanagement/v1/writeoff');
        insert websrv;
        
   Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
      testAccount.BU_Region__c='UZ';
      testAccount.Bu_Segment__c='Professional Tax';
      testAccount.BillingCity = 'PORT ANGELES';
        testAccount.BillingCountry ='US';
        testAccount.BillingState = 'WA';
        testAccount.BillingPostalCode = '98363-8409';
        testAccount.BillingStreet = '2851 LOWER ELWHA RD';
      insert testAccount;
  //insert contact data
      Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
      testContact.FirstName='Fname';
      insert testContact;

      List <Case> listcase= new List<Case>();
      Case testCase=ESC_GenericTestutility.testCaseUtil(testContact.id,TestAccount.id,'new');
      testCase.ESC_Impact__c = '1-Whole Site';
      testCase.USL_SAP_Account_Number__c = '2000000418';
      testCase.subject='tst';
      testCase.ESC_Customer_Symptom__c='Content Addition';
      testCase.ESC_Diagnosis_Summary__c='Content Explanation';
      testCase.ESC_Severity__c='1 - High';
      testCase.ESC_Case_Type__c = 'Request for Service';
      testCase.ESC_Apply_Milestone_Closure_Flag__c = true;
      testCase.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
      testCase.accountID=testAccount.id;
      testCase.ESC_Apply_Entitlement_Milestone__c=True;
      insert testCase;
      listcase.add(testCase);
          
      GenerateForm__C GF= new GenerateForm__C();
        GF.Name='Charge Cancellation';
        Insert GF;
      
      ESC_Case_Form_Extension__c ESCCFE = new ESC_Case_Form_Extension__c();
            ESCCFE.ESC_Form__c=GF.id;
            ESCCFE.ESC_Case__c=testcase.id;
            ESCCFE.USL_Approval_Type__c='Tax Profs - Software';
            ESCCFE.ESC_Form_BU__c='Tax Profs - Software';
            ESCCFE.USL_Requester_Title__c=' Mr.';
            ESCCFE.USL_Requestor_ID__c='Testing';
            ESCCFE.USL_Total_Amount__c=450;
            ESCCFE.USL_CSSWriteOffFormTypeID__c = '718';
            ESCCFE.Route_To_USL_Print_CD_Credits__c=true;
            ESCCFE.USL_Is_Processed__c = false;
            insert ESCCFE;
             ESCCFE.USL_Approval_Status__c='Approved';
             update ESCCFE;
            
            
           /* ESC_Case_Form_Extension_Line_Item__c  ESCCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine.ESC_Billing_Doc__c='6123872804';
            ESCCFELine.ESC_Line__c='000010';
            ESCCFELine.ESC_Net_Amount__c=3000;
            ESCCFELine.ESC_Tax_Amount__c=97;
            ESCCFELine.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            //ESCCFELine.USL_ODocType__c='YW';
            ESCCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine.ESC_Request_Description__c='Westlaw';
            ESCCFELine.ESC_Type__c='Partial';
           
            //ESCCFELine.ESC_Item_Amount__c=30000;
            //ESCCFELine.USL_Input_Amount__c=1126;
             insert ESCCFELine;*/
            
            
            ESC_Case_Form_Extension_Line_Item__c  ESCCFELine1 =new ESC_Case_Form_Extension_Line_Item__c();
            ESCCFELine1.ESC_Billing_Doc__c='79000000095';
            //ESCCFELine1.ESC_Line__c='0010';
            ESCCFELine1.ESC_Net_Amount__c=40;
            ESCCFELine1.USL_Input_Amount__c=0.45;
            ESCCFELine1.ESC_Item_Amount__c = 0.45;
            ESCCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            ESCCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            ESCCFELine1.USL_ODocType__c='YM';
            ESCCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            ESCCFELine1.ESC_Case_Form_Extension__c=ESCCFE.id;
            ESCCFELine1.ESC_Type__c='FUll';
            ESCCFELine1.ESC_Request_Description__c='Non-Westlaw';
            //ESCCFELine1.ESC_Item_Amount__c=30000;
           // ESCCFELine1.USL_Input_Amount__c=1126;
            //ESCCFELine1.USL_Invoice_Type__c='Clear';
             insert ESCCFELine1;
      
      
       set<id> caseextset = new set<id>();
      caseextset.add(ESCCFE.id);
    
       Test.startTest();
         Test.setMock(HttpCalloutMock.class, new ESC_WriteOfFormMockExceptionClass());
          ESC_CaseFormExtensionResponseWrapper oWrapper = new ESC_CaseFormExtensionResponseWrapper();
          ESC_CaseFormExtensionRequestWrapper oWrapper1 = new ESC_CaseFormExtensionRequestWrapper();
       Test.stopTest();
      
    }
    
   }
}