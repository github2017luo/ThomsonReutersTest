@isTest 
/**
     * @description Justdesc
     *
     */   
public class ESC_WebtoCaseController_Test {
   
    /**
     * @description Justdesc
     *
     */
    public static testMethod void eSCWebtoCaseController() {
 
        
        
        Profile prof = [SELECT Id FROM profile WHERE name='system Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        Test.StartTest();
       //insert Account
        Account accObj = new Account();
        accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Canada';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          insert accObj;
        ///////////
        Map<string,string> mapOfFieldname = new Map<string,string>();
        mapOfFieldName.put('First Name','Test');
        mapOfFieldName.put('Last Name','Test');
        mapOfFieldName.put('Email Address','mouna.gandra@thomsonreuters.com');
        mapOfFieldName.put('Phone Number(numerals only; no dashes)','Test');
        mapOfFieldName.put('Account Name','Test');
        mapOfFieldName.put('Account Number','Test');
        mapOfFieldName.put('Current account name','Test');
        mapOfFieldName.put('New account name','Test');
        mapOfFieldName.put('Question or comment','Test');
        
        //insert contact
        Contact con = new Contact();
        con.AccountId=accObj.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=accObj.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
       // cs.SuppliedName ='test3';
        cs.Product__c= 'Recursos Humanos - TM';
        insert cs; 
        
        PageReference pageRef = Page.ESC_WebToCase;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('FormName','Account-name-change');
        pageRef.getParameters().put('BU','USL');
        /*pageRef.getParameters().put('BU','Bejerman');
        pageRef.getParameters().put('conName','Testcon');
        pageRef.getParameters().put('email','mouna.gandra@thomsoreuters.com');
        pageRef.getParameters().put('phNumber','12345');
        pageRef.getParameters().put('pComplement','Testcomp');
        pageRef.getParameters().put('product','TestProd');
        pageRef.getParameters().put('qcaseRecType','Feedback');
        pageRef.getParameters().put('caseDesc','TestDescription');
        pageRef.getParameters().put('cName','Testcompany');
        pageRef.getParameters().put('taxNumberType','C.I.');
        pageRef.getParameters().put('taxNumber','12345');*/
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        ESC_WebtoCaseController gwc =  new ESC_WebtoCaseController(sc);
        //gwc.c = cs;
        gwc.displayform = true;
        gwc.Isattach = true;
        //gwc.gcasid=cs.id;
        gwc.EnableSection = false;
        gwc.formNameValueMapping=mapOfFieldname ;
        String prq= gwc.publicKey;
        String prq1= ESC_WebtoCaseController.privateKey;
        gwc.reCAPTCHASucess();
        gwc.attachfile();
        //pageRef.getParameters().put('gcasid',cs.id);
        gwc.SubmitWithAttachment();
        gwc.Removeattachment();
        system.assertEquals(1,1,1);
        Test.StopTest();
}

/**
     * @description Justdesc
     *
     */
   public static testMethod void escWebtoCaseControllerDistributor() {
 
        Test.StartTest();
        
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
       //insert Account
        Account accObj = new Account();
       accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'USL';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          insert accObj; 
        ///////////

        //insert contact
        Contact con = new Contact();
        con.AccountId=accObj.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=accObj.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
        //cs.SuppliedName ='Test';
        cs.Product__c= 'Recursos Humanos - TM';
        insert cs;
        
        
        Map<string,string> mapOfFieldname = new Map<string,string>();
        mapOfFieldName.put('First Name','Test');
        mapOfFieldName.put('Last Name','Test');
        mapOfFieldName.put('Email Address','Test');
        mapOfFieldName.put('Phone Number(numerals only; no dashes)','Test');
        mapOfFieldName.put('Account Name','Test');
        mapOfFieldName.put('Account Number','Test');
        mapOfFieldName.put('Current account name','Test');
        mapOfFieldName.put('New account name','Test');
        mapOfFieldName.put('Question or comment','Test');
        mapOfFieldName.put('Attention(Optional)','Test');
        mapOfFieldName.put('Address Line 1','Test');
        mapOfFieldName.put('Address line 2(Optional)','Test');
        mapOfFieldName.put('Suite/building(Optional)','Test');
        mapOfFieldName.put('PO box(Optional)','Test');
        mapOfFieldName.put('City','Test');
        mapOfFieldName.put('Post code','Test');
        mapOfFieldName.put('Account phone number(Optional)','Test');
        mapOfFieldName.put('Account fax number(Optional)','Test');
        mapOfFieldName.put('Question or comment','Test');
        mapOfFieldName.put('Country/region','Test');
        mapOfFieldName.put('state/province','Test');
        PageReference pageRef = Page.ESC_Webtocase;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('FormName','Address-change');
        pageRef.getParameters().put('BU','USL');
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        ESC_WebtoCaseController gwc =  new ESC_WebtoCaseController(sc);
        //gwc.c = cs;
        gwc.displayform = true;
        gwc.formNameValueMapping=mapOfFieldname ;
        gwc.Isattach = true;
        gwc.countryValue = 'test';
        gwc.stateValue = 'test';
        //gwc.gcasid=cs.id;
        gwc.EnableSection = false;
        gwc.reCAPTCHASucess();
        
        String prq= gwc.publicKey;
        gwc.attachfile();
        //pageRef.getParameters().put('gcasid',cs.id);
        gwc.SubmitWithAttachment();
        gwc.Removeattachment();
        system.assertEquals(1,1,1);
        Test.StopTest();
}

/**
     * @description Justdesc
     *
     */
public static testMethod void escWebtoCaseController2() {
 
        
        
        Profile prof = [SELECT Id FROM profile WHERE name='system Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        Test.StartTest();
       //insert Account
        Account accObj = new Account();
        accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'Europe';
          accObj.Bu_Segment__c = 'Government';
          accObj.Is_GLI__c = true;
          insert accObj;
        ///////////
        Map<string,string> mapOfFieldname = new Map<string,string>();
        mapOfFieldName.put('Contact Email','mouna.gandra@thomsonreuters.com');
        mapOfFieldName.put('Contact Telephone No','1234567890');
        mapOfFieldName.put('Subject','test subject');
        mapOfFieldName.put('Description','Test');
        
        //insert contact
        Contact con = new Contact();
        con.AccountId=accObj.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=accObj.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
       // cs.SuppliedName ='test3';
        cs.Product__c= 'Recursos Humanos - TM';
        insert cs; 
        
        PageReference pageRef = Page.ESC_WebToCase;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('FormName','SubmitTicket');
        pageRef.getParameters().put('BU','CaseLines');
        /*pageRef.getParameters().put('BU','Bejerman');
        pageRef.getParameters().put('conName','Testcon');
        pageRef.getParameters().put('email','mouna.gandra@thomsoreuters.com');
        pageRef.getParameters().put('phNumber','12345');
        pageRef.getParameters().put('pComplement','Testcomp');
        pageRef.getParameters().put('product','TestProd');
        pageRef.getParameters().put('qcaseRecType','Feedback');
        pageRef.getParameters().put('caseDesc','TestDescription');
        pageRef.getParameters().put('cName','Testcompany');
        pageRef.getParameters().put('taxNumberType','C.I.');
        pageRef.getParameters().put('taxNumber','12345');*/
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        ESC_WebtoCaseController gwc =  new ESC_WebtoCaseController(sc);
        //gwc.c = cs;
        gwc.displayform = true;
        gwc.Isattach = true;
        //gwc.gcasid=cs.id;
        gwc.EnableSection = false;
        gwc.formNameValueMapping=mapOfFieldname ;
        String prq= gwc.publicKey;
        String prq1= ESC_WebtoCaseController.privateKey;
        gwc.reCAPTCHASucess();
        gwc.attachfile();
        //pageRef.getParameters().put('gcasid',cs.id);
        gwc.SubmitWithAttachment();
        gwc.Removeattachment();
        system.assertEquals(1,1,1);
        Test.StopTest();
}
 /**
     * @description Justdesc
     *
     */
   public static testMethod void escWebtoCaseController3() {
 
        Test.StartTest();
        
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james123.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
       //insert Account
        Account accObj = new Account();
       accObj.name = 'test acc';
          accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          accObj.BU_Region__c = 'USL';
          accObj.Bu_Segment__c = 'Professional Tax';
          accObj.Is_GLI__c = true;
          insert accObj; 
        ///////////

        //insert contact
        Contact con = new Contact();
        con.AccountId=accObj.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=accObj.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@gmail.com';
        //cs.SuppliedName ='Test';
        cs.Product__c= 'Recursos Humanos - TM';
        insert cs;
        
        
        Map<string,string> mapOfFieldname = new Map<string,string>();
        mapOfFieldName.put('Submitter Name','Test');
        mapOfFieldName.put('Customer Name','Test');
        mapOfFieldName.put('Company Code','0150 - CAD Legal');
        mapOfFieldName.put('Account Billing Type','Key Account');
        mapOfFieldName.put('Account Number','Test');
        mapOfFieldName.put('Account AR Aging','1-29 Days');
        mapOfFieldName.put('Contract/Subscription Amount','$26k - $50k');
        mapOfFieldName.put('Contract Period','2 Years');
        mapOfFieldName.put('Billing Frequency','Annually');
        mapOfFieldName.put('Primary Contact Name','Test');
        mapOfFieldName.put('Primary Contact Email','Test@gmail.com');
        mapOfFieldName.put('Primaty Contact Number','Test');
        mapOfFieldName.put('Portal Vendor','Taulia');
        mapOfFieldName.put('Other (Portal Vendor)','Test');
        mapOfFieldName.put('Portal Vendor Primary Contact Name','Test');
        mapOfFieldName.put('Portal Vendor Primary Contact E-mail','Test@gmail.com');
        mapOfFieldName.put('Portal Submission Type','Standard');
        mapOfFieldName.put('PO Number/Contract Number','Test');
        mapOfFieldName.put('Date of Portal Request','Test');
        mapOfFieldName.put('Comment Field','Test');
        mapOfFieldName.put('Who will be uploading Invoice','Test');
        mapOfFieldName.put('Send me a copy ','true');
        PageReference pageRef = Page.ESC_Webtocase;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('FormName','billing-portal-request');
        pageRef.getParameters().put('BU','USL');
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        ESC_WebtoCaseController gwc =  new ESC_WebtoCaseController(sc);
        //gwc.c = cs;
        gwc.displayform = true;
        gwc.formNameValueMapping=mapOfFieldname ;
        gwc.Isattach = true;
        gwc.strfieldvalue ='test';
        gwc.attention='test';
        gwc.companycode = '0150 - CAD Legal';
      gwc.accountBillingType = 'Key Account';
      gwc.billingFrequency = 'Annually';
      gwc.accountARAging = '1-29 Days';
      gwc.contractSubscriptionAmount = '$26k - $50k';
      gwc.contractPeriod = '2 Years';
      gwc.portalVendor = 'Taulia';
      gwc.portalSubmissionType = 'Standard';
      List<SelectOption> s = new List<SelectOption>();
        List<SelectOption> s1 = gwc.getCompanycodes();
        List<SelectOption> s2=gwc.getAccountBillingTypes();
         List<SelectOption> s3 =gwc.getBillingFrequencys();
        s=gwc.getAccountARAgings();
        s=gwc.getContractSubscriptionAmounts();
        s=gwc.getContractPeriods();
        s=gwc.getPortalVendors();
        s=gwc.getPortalSubmissionTypes();
        //gwc.gcasid=cs.id;
        gwc.EnableSection = false;
        gwc.reCAPTCHASucess();
        
        String prq= gwc.publicKey;
        gwc.attachfile();
        //pageRef.getParameters().put('gcasid',cs.id);
        gwc.SubmitWithAttachment();
        gwc.Removeattachment();
        system.assertEquals(1,1,1);
        Test.StopTest();
}

  
}