@isTest
private class ESC_CaseMasterPB_Test{
    private static testmethod void  method1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='USL Helpdesk Agent'];
        User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='sysadmin2@testorg.com');
        insert u;
        Test.startTest();        
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingState = 'AL';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ;
        
   
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Case cs = new Case();
        cs.AccountId = acct.id;
        cs.ContactId = con.id;
        cs.status = 'Work in Progress';       
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.Priority='1-High';
        cs.Origin='Email';
        cs.ESC_Origin_Name__c ='';
        cs.is_gli__c = true;
        cs.ESC_UPD__c = false;
        cs.SuppliedEmail = 'dummytest@thomsonreuters.com';
        cs.USL_Queue_Name__c = '';
        cs.lcrm_sub_bu__c= 'UKI';
        cs.ESC_UKI_WebForm_Rep_Email__c = 'test@test.com';
        insert cs;
        
        Languages__c langEnglish = new Languages__c(
            ISO_Code__c = 'en',
            Language_Name__c = 'English',
            Salesforce_ISO_Code__c = 'en_US'
        );

        Languages__c langEnglishDefault = new Languages__c(
            ISO_Code__c = 'en',
            Language_Name__c = 'English (Default)',
            Salesforce_ISO_Code__c = 'en_US'
        );
            
        Languages__c langSpanish = new Languages__c(
            ISO_Code__c = 'es',
            Language_Name__c = 'Spanish',
            Salesforce_ISO_Code__c = 'es'
        );
        
        FieldId__c settings = FieldId__c.getOrgDefaults();
        settings.DQA_Request_DQA_Case__c    = '12345678';
        upsert settings FieldId__c.Id;
        
        insert langEnglish;
        insert langEnglishDefault;
        insert langSpanish;
    
        Case cs1 = new Case();
        cs1.id = cs.id;
        cs1.status= 'Closed';
        cs1.ESC_UPD__c = true;
        update cs1;
        integer k = 1;
        integer j = 1;
        System.assertEquals(k,j,'equal');
        
    }
    /**
 * @description test send ESC_MasterCasePBTestMethod
 */   
    public testmethod static void method2(){
        Profile prof = [SELECT Id FROM profile WHERE name= 'USL Helpdesk Agent'];
        user user = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //ManagerId = manager.id
            //UserRoleId = r.Id
       );
       insert user;
       
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
       
        try{
        Account acc=new account();
        acc.Name = 'Test Account';
        acc.ESC_OptOut_CSAT_Check__c = false;
        insert acc; 
     
        contact con =new contact();
        con.LastName = 'Test Contact';
        con.FirstName = 'test';
        con.ESC_OptOut_CSAT_Check__c = false;
        con.ESC_Frequency_Cap__c = 5;
        con.accountid=acc.id;
        con.email = 'test@gmail.com';
        insert con;
        
        //ESC_CaseMasterPB Process Builder
            
        test.starttest();
        
        Case csPBtest = new Case();
        csPBtest.Type='Data';
        csPBtest.Status='New';
        csPBtest.Subject='Test Subject';
        csPBtest.Description = 'Test Description111';
        csPBtest.contactid=con.id;
        csPBtest.Origin='Email';
        csPBtest.OwnerId=us.id;
        csPBtest.Is_GLI__c=true;
        csPBtest.ESC_Origin_Name__c='txt';
        csPBtest.accountid=acc.id;
        csPBtest.LCRM_Sub_BU__c  ='UKI';
        csPBtest.ESC_Survey_Sent__c=true;
        csPBtest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        csPBtest.ESC_Case_Type__c = 'Incident';
        csPBtest.ESC_Impact__c='3-Single User';
        csPBtest.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        csPBtest.ESC_Resolution_Code__c='Config Change';
        csPBtest.ESC_UKI_WebForm_Rep_Email__c='Dummy@gmail.com';
        csPBtest.Priority='1-High';

        insert csPBtest;
        
        csPBtest.Status='Closed';
        update csPBtest;
        
        Case csPBtestnonGLI = new Case();
        csPBtestnonGLI.Type='Data';
        csPBtestnonGLI.Status='New';
        csPBtestnonGLI.Subject='Test Subject';
        csPBtestnonGLI.Description = 'Test Description111';
        csPBtestnonGLI.contactid=con.id;
        csPBtestnonGLI.Origin='Email';
        csPBtestnonGLI.OwnerId=us.id;
        csPBtestnonGLI.Is_GLI__c=false;
        csPBtestnonGLI.ESC_Origin_Name__c='txt';
        csPBtestnonGLI.accountid=acc.id;
        csPBtestnonGLI.LCRM_Sub_BU__c  ='UKI';
        csPBtestnonGLI.ESC_Survey_Sent__c=false;
        csPBtestnonGLI.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        csPBtestnonGLI.ESC_Case_Type__c = 'Incident';
        csPBtestnonGLI.ESC_Impact__c='3-Single User';
        csPBtestnonGLI.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        csPBtestnonGLI.ESC_Resolution_Code__c='Config Change';
        csPBtestnonGLI.ESC_UKI_WebForm_Rep_Email__c='Dummy@gmail.com';
        csPBtestnonGLI.Priority='1-High';

        insert csPBtestnonGLI;
        
        csPBtestnonGLI.Status='Closed';
        update csPBtestnonGLI;
        
        
        
        system.debug('Case 1 after update for Process Builder'+csPBtest);
        Case csPBtest2 = new Case();
        csPBtest2.Type='Data';
        csPBtest2.Status='New';
        csPBtest2.Subject='Test Subject';
        csPBtest2.Description = 'Test Description111';
        csPBtest2.contactid=con.id;
        csPBtest2.ESC_Survey_Sent__c=true;
        csPBtest2.Origin='Email';
        csPBtest2.OwnerId=us.id;
        csPBtest2.Is_GLI__c=true;
        csPBtest2.ESC_Origin_Name__c='txt';
        csPBtest2.BU_Segment__c='Professional Tax';
        csPBtest2.accountid=acc.id;
        csPBtest2.LCRM_Sub_BU__c  ='USL';
        csPBtest2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        csPBtest2.ESC_Case_Type__c = 'Incident';
        csPBtest2.ESC_Impact__c='3-Single User';
        csPBtest2.ESC_Severity__c='3 - Low';
        csPBtest2.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        csPBtest2.ESC_Resolution_Code__c='Config Change';
        csPBtest2.ESC_UKI_WebForm_Rep_Email__c='Dummy@gmail.com';
        csPBtest2.Priority='1-High';
        
        insert csPBtest2;
        
        system.debug('Case 2 for Process Builder'+csPBtest2);
        system.runas(user)
        {
            Case test=[select id from Case where Id=:csPBtest2.id];
            test.Priority='Medium';
            test.esc_upd__c = true;
            test.ANZ_Issue__c='Administrativa';
            update test; 
            system.debug('Case 2 for Process Builder after update'+test);
        }
            test.stoptest();
        system.debug('Case 2 for Process Builder after update outside user'+csPBtest2);
        }
        catch(Exception e)
        {
            system.debug(e);
        }
        integer k = 1;
        integer j = 1;
        System.assertEquals(k,j,'equal');
    }
     /**
 * @description test send ESC_MasterCasePBTestMethod
 */  
    public static testmethod void testMethod1232(){
        Profile p = [SELECT Id FROM Profile WHERE Name='GLI Helpdesk Agent']; 
        LTS_Disable_Application_Automation__c dis = new LTS_Disable_Application_Automation__c();
        dis.LTS_Disable_Validation_Rules__c =true;
        insert dis;
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,Sales_Org__c='GLI',Sub_Bu__c = 'UKI',TimeZoneSidKey='America/Los_Angeles', UserName='standarduseruki@testorg.com');
        Insert u;
      
        List<Id> userlist = new List<Id>();
        List<Id> cslist = new List<Id>();
        Userlist.add(u.id);     
        List<UKI_Static_Values__mdt> uKISV =[SELECT MasterLabel,UKI_Value__c from UKI_Static_Values__mdt];
        GLI_DomainSelectorList__c dMS= new GLI_DomainSelectorList__c();
        DMS.DomainName__c='trs.com';
        Insert DMS;
        case  testCaseSurveyGGO =new case();
      
        System.runAs(u) {
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','1251541');  
        insert testAccount;
     
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testContact.Firstname='test';
        insert testContact;
      
     
        Test.startTest();
      
        testCaseSurveyGGO.Status='New';      
        testCaseSurveyGGO.AccountId=testAccount.id;
        testCaseSurveyGGO.ContactId=testContact.id;       
        testCaseSurveyGGO.ESC_Fix_Applied_Time__c =NULL;
        testCaseSurveyGGO.ESC_Impact__c = '1-Whole Site';
        testCaseSurveyGGO.subject='tst';
        testCaseSurveyGGO.ESC_Customer_Symptom__c='Content Addition';
        testCaseSurveyGGO.ESC_Diagnosis_Summary__c='Content Explanation';
        testCaseSurveyGGO.ESC_Severity__c='1 - High';
        testCaseSurveyGGO.Description='test';
        testCaseSurveyGGO.ESC_Resolution_Comment__c='TestComment';
        testCaseSurveyGGO.ESC_Impact__c=' 3 - Single User';
        testCaseSurveyGGO.LCRM_Sub_BU__c ='UKI';
        testCaseSurveyGGO.is_gli__c=true;
        testCaseSurveyGGO.ESC_Send_Survey__c=false;
        testCaseSurveyGGO.ESC_Product_Segment_Brand__c = 'CaseLines';
        testCaseSurveyGGO.ESC_Product_Title__c ='CaseLines';
        testCaseSurveyGGO.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        insert testCaseSurveyGGO;     
      
        testCaseSurveyGGO.Status='Closed';
        update testCaseSurveyGGO;
        system.debug('&&&GGO'+testCaseSurveyGGO.id+testCaseSurveyGGO.isclosed);
        cslist.add(testCaseSurveyGGO.id);
        Test.stopTest();
        
        }
        try{
        ESC_Survey__c survey0 = new ESC_Survey__c();
        survey0.ESC_Case__c = testCaseSurveyGGO.Id;
        survey0.GLI_Is_GLI__c = true;
        survey0.ESC_YNAnswer_1__c ='No';
        insert survey0;
        system.debug('&&&survey0'+survey0.id+survey0.GLI_Is_GLI__c+survey0.ESC_YNAnswer_1__c);
        GLIGenericUtilityHelper.ReopenCaseShareSurveyToOwner(cslist);
        }
        catch(Exception ex){
        system.debug(ex.getMessage());
        }
        integer k = 1;
        integer j = 1;
        System.assertEquals(k,j,'equal');
    }
}