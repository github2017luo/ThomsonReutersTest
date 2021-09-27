@istest(SeeAllData=false)
public class USLsubscriptionController_test {
     @isTest static void testsubscription(){
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         Case ca= new Case();
         ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'Work in Progress');
         Insert ca;
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser',
            Email = 'abc1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );
        integer pagesize=20;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();

      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
           accountSSD.RecordtypeId=ssdRecorType;
           accountSSD.Name='ABC';
           accountSSD.Source_System_Name__c='ABC';
           accountSSD.Account_Name__c=testAccount.ID;
             accountSSD.Account_Inactive__c=false;
         accountSSD.LCRM_Sales_Org__c='WEST';
         accountSSD.LCRM_Customer_Group__c='';
         accountSSD.Source_System_Account_Number__c = '1000000040';
         insert accountSSD;

        insert testUser;
        System.Runas(testUser){  
            
       /* Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_Org__c ='WEST' ;
        insert testAcc1;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
   
       Source_System_Detail__c accountSSD= new Source_System_Detail__c();
           accountSSD.RecordtypeId=ssdRecorType;
           accountSSD.Name='ABC';
           accountSSD.Source_System_Name__c='ABC';
           accountSSD.Account_Name__c=testAcc1.ID;
             accountSSD.Account_Inactive__c=false;
         accountSSD.LCRM_Sales_Org__c='WEST';
         accountSSD.LCRM_Customer_Group__c='';
         accountSSD.Source_System_Account_Number__c = '1000000040';
         insert accountSSD;
          }
       
           List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'USLSubscriptionService';       
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://api.thomsonreuters.com/ebs/subscription/qa/getSubscriptionsByAccount';
            Webserve.Password__c = 'esiscsap@123';
            Webserve.Service_Unavailable_Message__c = 'Service Unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esiSCSAPInt';
            lstofWebServ.add(Webserve);
            
            if(lstofWebServ.size()>0){
                insert lstofWebServ;
            }*/
            
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            insert testAcc1;

            Account testAcc2 = new Account();
            testAcc2 = UnitTest.getAccountInstance();
            testAcc2.SAPAccountNumber__c = '5491344';
            insert testAcc2;
                    
         
            List <LCRM_Contact_SSD__c> ListofSSD = new List <LCRM_Contact_SSD__c>();
            LCRM_Contact_SSD__c SSDwithSAPNo = new LCRM_Contact_SSD__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.LCRM_Contact_ID__c = '1000000040';
                           
            ListofSSD.add(SSDwithSAPNo);

            LCRM_Contact_SSD__c SSDSAPNo = new LCRM_Contact_SSD__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.LCRM_Contact_ID__c = '1000000846';
           
            
            ListofSSD.add(SSDSAPNo);

            if (ListofSSD.size() > 0) {
                insert ListofSSD;
                  }
        }
        
        WebServiceSettings__c web=new WebServiceSettings__c();
        web.name='USLSubscriptionService';
        web.Active__c=true;
        web.Endpoint__c='https://api.thomsonreuters.com/ebs/subscription/qa/getSubscriptionsByAccount';
        web.Username__c='esiSCSAPInt';
        web.Password__c='esiscsap@123';
        web.Service_Unavailable_Message__c='Service unavailable';
        insert web;
                     
      Test.startTest();
      Set<Id> listAccId=new Set<Id>();
      listAccId.add(testAccount.ID);
      
      string bu='USL';
      
      ApexPages.CurrentPage().getParameters().put('caseid',ca.id);
      Test.setMock(HttpCalloutMock.class, new MockUSLSubscriptionController());
      PageReference pageRef = Page.USLSubscription;
     Test.setCurrentPage(pageRef);
      Apexpages.StandardController controller = new Apexpages.StandardController(accountSSD); 
      USLsubscriptionController USLSub = new USLsubscriptionController(controller);
     // USLSub.getSourceSystemDetails(testAcc1.id,"USL");
     USLSub.strSalesOrg='strSalesOrg';
     USLSub.oAccount=testAccount;
     USLSub.sSelectedOption=label.USL_AllLapsed;
     USLSub.sSelectedOption=label.USL_CD;
     USLSub.sSelectedOption=label.USL_Software;
     USLSub.sSelectedOption=label.USL_print;
     USLSub.sSelectedOption=label.USL_Online;
     USLSub.sSelectedOption=label.USL_Others;     
       USLSub.displayUSLSubcriptioninfo();
       USLSub.getSubscriptionListOptions();
        USLSub.sortSubscription();
        //USLSub.PrintPDF();
        USLSub.processSelected();
        USLSub.saveselectedopen();
        USLSub.selectall=True;
        USLSub.selectalllineitem();
        PageReference pr1 = USLSub.saveAsPDF();
        PageReference pr2 = USLSub.saveAsExcel();
        USLSub.pagesize=1;
        
        //USLSub.selectalllineitem();
        //USLSub.previousPage();
     //   USLSub.updatePage();
     //   USLSub.nextPage();
        USLSub.getSourceSystemDetails(listAccId,bu);
        
        USLsubscriptionsJsonWrapper wrap = new USLsubscriptionsJsonWrapper();
         Test.setCurrentPageReference(new PageReference('Page.USLsubscription'));
       
         
          Test.stopTest(); 
     }
      @isTest static void testsubscription2(){
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         Case ca= new Case();
         ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'Work in Progress');
         Insert ca;
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser',
            Email = 'abc1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );
        integer pagesize=20;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();

      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
           accountSSD.RecordtypeId=ssdRecorType;
           accountSSD.Name='ABC';
           accountSSD.Source_System_Name__c='ABC';
           accountSSD.Account_Name__c=testAccount.ID;
             accountSSD.Account_Inactive__c=false;
         accountSSD.LCRM_Sales_Org__c='WEST';
         accountSSD.LCRM_Customer_Group__c='';
         accountSSD.Source_System_Account_Number__c = '1000000040';
         insert accountSSD;

        insert testUser;
        System.Runas(testUser){  
            
       /* Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_Org__c ='WEST' ;
        insert testAcc1;
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
   
       Source_System_Detail__c accountSSD= new Source_System_Detail__c();
           accountSSD.RecordtypeId=ssdRecorType;
           accountSSD.Name='ABC';
           accountSSD.Source_System_Name__c='ABC';
           accountSSD.Account_Name__c=testAcc1.ID;
             accountSSD.Account_Inactive__c=false;
         accountSSD.LCRM_Sales_Org__c='WEST';
         accountSSD.LCRM_Customer_Group__c='';
         accountSSD.Source_System_Account_Number__c = '1000000040';
         insert accountSSD;
          }
       
           List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'USLSubscriptionService';       
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://api.thomsonreuters.com/ebs/subscription/qa/getSubscriptionsByAccount';
            Webserve.Password__c = 'esiscsap@123';
            Webserve.Service_Unavailable_Message__c = 'Service Unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esiSCSAPInt';
            lstofWebServ.add(Webserve);
            
            if(lstofWebServ.size()>0){
                insert lstofWebServ;
            }*/
            
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            insert testAcc1;

            Account testAcc2 = new Account();
            testAcc2 = UnitTest.getAccountInstance();
            testAcc2.SAPAccountNumber__c = '5491344';
            insert testAcc2;
                    
         
            List <LCRM_Contact_SSD__c> ListofSSD = new List <LCRM_Contact_SSD__c>();
            LCRM_Contact_SSD__c SSDwithSAPNo = new LCRM_Contact_SSD__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.LCRM_Contact_ID__c = '1000000040';
                           
            ListofSSD.add(SSDwithSAPNo);

            LCRM_Contact_SSD__c SSDSAPNo = new LCRM_Contact_SSD__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.LCRM_Contact_ID__c = '1000000846';
           
            
            ListofSSD.add(SSDSAPNo);

            if (ListofSSD.size() > 0) {
                insert ListofSSD;
                  }
        }
        
        WebServiceSettings__c web=new WebServiceSettings__c();
        web.name='USLSubscriptionService';
        web.Active__c=true;
        web.Endpoint__c='https://api.thomsonreuters.com/ebs/subscription/qa/getSubscriptionsByAccount';
        web.Username__c='esiSCSAPInt';
        web.Password__c='esiscsap@123';
        web.Service_Unavailable_Message__c='Service unavailable';
        insert web;
                     
      Test.startTest();
      Set<Id> listAccId=new Set<Id>();
      listAccId.add(testAccount.ID);
      
      string bu='Other Profiles';
       
      ApexPages.CurrentPage().getParameters().put('caseid',ca.id);
      Test.setMock(HttpCalloutMock.class, new MockUSLSubscriptionController());
      PageReference pageRef = Page.USLSubscription;
     Test.setCurrentPage(pageRef);
      Apexpages.StandardController controller = new Apexpages.StandardController(accountSSD); 
      USLsubscriptionController USLSub = new USLsubscriptionController(controller);
     // USLSub.getSourceSystemDetails(testAcc1.id,"USL");
     USLSub.strSalesOrg='strSalesOrg';
     USLSub.oAccount=testAccount;
       USLSub.displayUSLSubcriptioninfo();
       USLSub.getSubscriptionListOptions();
        USLSub.sortSubscription();
        //USLSub.previousPage();
      //  USLSub.updatePage();
      //  USLSub.nextPage();
        USLSub.getSourceSystemDetails(listAccId,bu);
        
        USLsubscriptionsJsonWrapper wrap = new USLsubscriptionsJsonWrapper();
        
         Test.setCurrentPageReference(new PageReference('Page.USLsubscription'));
       
         
          Test.stopTest(); 
     }
     @isTest static void displayFinplanSubcriptioninfoTest()
     {
         
         UserRole UR =[SELECT  DeveloperName,Id,Name FROM UserRole where DeveloperName='USL_Customer_Service_Agent_Level_1'];
    Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser',
            Email = 'abc1@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            UserRoleId=UR.id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );

                         insert testUser;
       
        
        try{
        
        System.runAs(testUser){
       
       Test.startTest();
       
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         Case ca= new Case();
         ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'Work in Progress');
         Insert ca;
         
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();

      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
           accountSSD.RecordtypeId=ssdRecorType;
           accountSSD.Name='ABC';
           accountSSD.Source_System_Name__c='ABC';
           accountSSD.Account_Name__c=testAccount.ID;
             accountSSD.Account_Inactive__c=false;
         accountSSD.LCRM_Sales_Org__c='WEST';
         accountSSD.LCRM_Customer_Group__c='';
         accountSSD.Source_System_Account_Number__c = '1000000040';
         insert accountSSD;

        
        USL_Roles_Static_CC_Milestone__c uslInstance=new USL_Roles_Static_CC_Milestone__c();
        uslInstance.Rolename__c='USL_Customer_Service_Agent_Level_1';
        uslInstance.Name='USL_Customer_Service_Agent_Level_1';
        insert uslInstance;
        
        ApexPages.CurrentPage().getParameters().put('caseid',ca.id);
      Test.setMock(HttpCalloutMock.class, new MockUSLSubscriptionController());
      
      PageReference pageRef = Page.USLSubscription;
     Test.setCurrentPage(pageRef);
      Apexpages.StandardController controller = new Apexpages.StandardController(accountSSD); 
      USLsubscriptionController USLSub = new USLsubscriptionController(controller);
        USLSub.displayFinplanSubcriptioninfo();
        
        USLsubscriptionsJsonWrapper wrap = new USLsubscriptionsJsonWrapper();
        
         Test.setCurrentPageReference(new PageReference('Page.USLsubscription'));
       
       
        
          Test.stopTest(); 
        }
        }
        
            catch(Exception e){
           system.debug('Exception Occurred Test Class'+e.getMessage());       
          }
     }
     public testmethod static void test_PB()
     {
         try{
         Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
         insert testAccount;
         Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
         insert testContact;
         
         USL_Email2case_SCM_TAM__c testrec=new USL_Email2case_SCM_TAM__c();
         testrec.SCM_Email_Id__c='scm_support';
         testrec.TAM_Email_Id__c='cmi_support';
         insert testrec;
         
         Id caserecordId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
         Id caserecordIdRO=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident (Read Only)').getRecordTypeId();
         List<Case> list_ca=new List<Case>();
         
         test.starttest();
         Case ca= new Case();
         
         ca= ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'New');
         ca.ESC_Origin_Name__c='test';
         ca.RecordtypeID=caserecordId;
         ca.LCRM_Sub_BU__c ='USL';
         ca.ESC_Impact__c = '1-Whole Site';
          ca.subject='tst';
          ca.ESC_CustHoldTimeCheck__c=true;
          ca.ESC_CustHoldTimeStart__c=datetime.newInstance(2019, 9, 15, 12, 30, 0);
          ca.ESC_Customer_Symptom__c='Content Addition';
          ca.ESC_Diagnosis_Summary__c='Content Explanation';
          ca.ESC_Severity__c='1 - High';
          ca.Origin='Walk-In';
          ca.Description='text';
          ca.ESC_Proactive_Type__c='Incident';
          ca.Priority='3 - Low';
            insert ca;
            
         ca.ESC_Origin_Name__c=testrec.SCM_Email_Id__c;
         update ca;
         
         
         Case ca1= new Case();
         
         ca1 = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'New');
         ca1.ESC_Origin_Name__c='tam';
         ca1.RecordtypeID=caserecordId;
         ca1.LCRM_Sub_BU__c ='USL';
         ca1.ESC_Impact__c = '1-Whole Site';
          ca1.subject='tst';
          ca1.ESC_CustHoldTimeCheck__c=true;
          ca1.ESC_CustHoldTimeStart__c=datetime.newInstance(2019, 9, 15, 12, 30, 0);
          ca1.ESC_Customer_Symptom__c='Content Addition';
          ca1.ESC_Diagnosis_Summary__c='Content Explanation';
          ca1.ESC_Severity__c='1 - High';
          ca1.Origin='Walk-In';
          ca1.Description='text';
          ca1.ESC_Proactive_Type__c='Incident';
          ca1.Priority='3 - Low';
            insert ca1;
         
       ca1.ESC_Origin_Name__c=testrec.TAM_Email_Id__c;
       update ca1;
       
        Case cs_GGO = new Case();
        cs_GGO.Type='Data';
        cs_GGO.Status='Closed';
        cs_GGO.Subject='Test Subject';
        cs_GGO.Description = 'Test Description111';
        cs_GGO.contactid=testAccount.id;
        cs_GGO.ESC_Impact__c='3 - Single User';
        cs_GGO.ESC_Severity__c='1 - High';
        cs_GGO.Priority='Medium';
        cs_GGO.accountid=testContact.id;
        cs_GGO.LCRM_Sub_BU__c='GGO';
        cs_GGO.ESC_Send_Survey__c=false;
        cs_GGO.RecordTypeId = caserecordId;
        insert cs_GGO;
            
            Case cs_GGO2 = new Case();
        cs_GGO2.Type='Data';
        cs_GGO2.Status='Closed';
        cs_GGO2.Subject='Test Subject';
        cs_GGO2.Description = 'Test Description111';
        cs_GGO2.contactid=testContact.id;
        cs_GGO2.ESC_Impact__c='3 - Single User';
        cs_GGO2.ESC_Severity__c='1 - High';
        cs_GGO2.Priority='Medium';
        cs_GGO2.accountid=testAccount.id;
        cs_GGO2.LCRM_Sub_BU__c='GGO';
        cs_GGO2.ESC_Send_Survey__c=true;
        cs_GGO2.ESC_Survey_Sent__c=false;
        cs_GGO2.RecordTypeId = caserecordIdRO;
        insert cs_GGO2;
         test.stoptest();
         }catch(Exception e)
         {
             system.debug(e);
         }
     }
     
}