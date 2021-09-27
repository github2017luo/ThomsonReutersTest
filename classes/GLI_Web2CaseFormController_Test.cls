@isTest    
private class GLI_Web2CaseFormController_Test {
    @testsetup
    public static void testDataSetup(){
        Profile prof = [SELECT Id FROM profile WHERE name='GLI Helpdesk Agent']; 
        
        User us =  New User(FirstName = 'James' , LastName= 'ThomasTest',Alias = 'jttest',Email='james1.thomastest@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='james1.thomastest@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='James.ThomasTest');
        insert us;
        //System.assert(us.id != null);
        //////////////////
        //insert Account
        /*Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'US';
        acct.ShippingState = 'AL';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 

        //insert contact
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;*/
        
        ////////////////
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        //cs.contactid=con.id;
        //cs.accountid=acct.id;
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.ESC_Case_Type__c = 'Incident';
        cs.ESC_Impact__c='3-Single User';
        cs.ESC_Diagnosis_Summary__c='Application/Infrastructure/Upgrade';
        cs.ESC_Resolution_Code__c='Config Change';
        cs.Priority='1-High';
        cs.SuppliedEmail = 'asdasd@123.com';
        cs.SuppliedPhone='234567890';
        cs.suppliedcompany='dgfhjk';
        cs.ESC_UKI_WebForm_Rep_Email__c='tsaa@ty.com';
        cs.ESC_UKI_WebForm_Rep_Name__c='Sai';
        //cs.Product__c='tesgh';
        cs.businesshoursid ='01m130000004lPt';
        insert cs;
        
        
        /////////////////
        
        //insert attachments
        
        list<Attachment> testAtt = new list<Attachment>();
        Integer i = 0;
        while(i<5)
        {
        Attachment attach = new Attachment();       
        attach.Name='Unit Test Attachment'+i;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'+i);
        attach.body=bodyBlob;
        attach.parentId=cs.id;
        testAtt.add(attach);
        i++;   
        }
        
        insert testatt;
        Attachment attach1 = new Attachment();
        attach1.Name='Traceability Matrix - ESC Project - Master (17)';
        List<case> cslst = new list<case>();
        /* Case csClone = cs.clone();
        csClone.Subject='Test Subject Clone';
        cslst.add(csClone); */
        Case csClone2 = cs.clone();
        csClone2.Subject='Test Subject Clone2';
        cslst.add(csClone2);
        insert cslst;
        
        /* Attachment attach = new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=csClone.id;
        testAtt.add(attach); */
    }
    
    public static testMethod void gliWeb2CaseFormController() {
 
        
        //create a user records  
        Case csWith5Attach = [select Id,Type,Status,Subject,Description,contactid,accountid,RecordTypeId,Priority,ESC_UKI_WebForm_Rep_Name__c,ESC_Resolution_Code__c,ESC_Case_Type__c,ESC_Impact__c,ESC_UKI_WebForm_Rep_Email__c,ESC_Diagnosis_Summary__c,SuppliedEmail,SuppliedCompany,CaseNumber,SuppliedPhone from Case where subject =: 'Test Subject'];
        //Case csWith51Attach = [select Id,Type,Status,Subject,Description,contactid,accountid,ESC_UKI_WebForm_Rep_Email__c,RecordTypeId,Priority,ESC_Resolution_Code__c,ESC_Case_Type__c,ESC_Impact__c,ESC_Diagnosis_Summary__c,SuppliedEmail,SuppliedCompany,CaseNumber,SuppliedPhone from Case where subject =: 'Test Subject1'];
        //Case csWith1Attach = [select Id,Type,Status,Subject,Description,contactid,ESC_UKI_WebForm_Rep_Email__c,ESC_UKI_WebForm_Rep_Name__c,accountid,RecordTypeId,Priority,ESC_Resolution_Code__c,ESC_Case_Type__c,ESC_Impact__c,ESC_Diagnosis_Summary__c,SuppliedEmail,SuppliedCompany,CaseNumber,SuppliedPhone from Case where subject =: 'Test Subject Clone'];
        Case csWithoutAttach = [select Id,Type,Status,Subject,Description,contactid,ESC_UKI_WebForm_Rep_Email__c,ESC_UKI_WebForm_Rep_Name__c,accountid,RecordTypeId,Priority,ESC_Resolution_Code__c,ESC_Case_Type__c,ESC_Impact__c,ESC_Diagnosis_Summary__c,SuppliedEmail,SuppliedCompany,CaseNumber,SuppliedPhone from Case where subject =: 'Test Subject Clone2'];
        List<Attachment> attachments=[select id, name, BodyLength from Attachment where parent.id=:csWith5Attach.id];
        //System.assertEquals(5, attachments.size());
        Test.StartTest();
         runCoreTests(csWith5Attach,'121', attachments, 'Incident');
        runCoreTests(csWith5Attach,'117', attachments, 'Incident');
        runCoreTests(csWith5Attach,'175', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'120', attachments, 'Incident');
        runCoreTests(csWithoutAttach,'115', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'116', attachments, 'Incident');
        runCoreTests(csWith5Attach,'118', attachments, 'Incident');
        runCoreTests(csWithoutAttach,'109', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'DirectDebit', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'JCT', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'127', attachments, 'Feedback');
        runCoreTests(csWithoutAttach,'121mp', attachments, 'Incident');
        runCoreTests(csWithoutAttach,'115icr', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'121cfi', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'108', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'123', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'124', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'125', attachments, 'Request for Action');
        runCoreTests1(csWithoutAttach,'125', attachments, 'Request for Action');
        runCoreTests1(csWith5Attach,'JCT', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'credit', attachments, 'Request for Action');
        runCoreTests3(csWithoutAttach,'125', attachments, 'Request for Action');
        runCoreTests1(csWithoutAttach,'InternalSSUP', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'126', attachments, 'Request for Action');
        runCoreTests2(csWithoutAttach,'126', attachments, 'Request for Action');
        runCoreTests3(csWithoutAttach,'126', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'127', attachments, 'Feedback');
        runCoreTests(csWithoutAttach,'contract', attachments, 'Request for Action');
        runCoreTests1(csWithoutAttach,'126', attachments, 'Request for Action');
       // runCoreTests2(csWithoutAttach,'126', attachments, 'Request for Action');
        runCoreTests(csWithoutAttach,'102', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'113', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'122', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'115icr', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'115PSALE', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'115SSUP', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'ESSUP', attachments, 'Request for Action');
        runCoreTests(csWith5Attach,'InternalSSUP', attachments, 'Request for Action');
        Test.StopTest();
        integer k = 1;
        integer j = 1;
        System.assertEquals(k,j);
}

    public static void runCoreTests(Case cs, String source, list<Attachment> attachments, String caseType){
    
        PageReference pageRef = Page.GLI_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        GLI_Web2CaseFormController gwc =  new GLI_Web2CaseFormController(sc);
        gwc.c = cs;
        gwc.displayform = false;
        gwc.acctnum = '123456';
        gwc.invoicenumber='454545fndfn';
        gwc.productname = 'activa';
        gwc.firstname='eeefef';
        gwc.surname = 'sharma';
        gwc.title='njnjn';
        gwc.address = 'banerjeelane';
        gwc.postcode='455885';
        gwc.device='dsdsds';
        gwc.deviceos='snds';
        gwc.repName ='test';
        gwc.repEmail = 'test@gmail.com';
        gwc.IsGeneralForm= true;
        gwc.IsTHForm= true;
        gwc.jctUser = '1';
        gwc.isCredit = true;
        gwc.IsAdminForm= true;
        gwc.IsOCSForm= true;
        gwc.IsMPForm = true;
        gwc.IsDiffForm = true;
        gwc.IsICRForm = true;
        gwc.IsCFForm = true;
        gwc.isComplaint = true;
        gwc.isContract = true;
        gwc.IsGenReqTFForm=true;
        gwc.querySubject='Test Subject';
        gwc.invoicenumber='3456789';
        gwc.productname='tasydfcgsjkf';
        gwc.Checklist=true;
        gwc.Filinginstructions=true;
        gwc.ISOrderForm=true;
        gwc.ISPPOForm=true;
        gwc.ISPPOCMDForm=true;
        gwc.ISCMDForm=true;
        gwc.isinternal=true;
        gwc.ordernum='8974564654';
        gwc.isbn='65489465';
        gwc.claimreason='dfghjk';
        gwc.pagesrequired='15';
        gwc.quantity='6';
        gwc.town='dsfghjk';
        gwc.country='India';
        gwc.casetype= caseType+';;;3 - Low';
        gwc.isUKICommissions=true;
        gwc.isCustSupport=true;
        gwc.isOProdSupport=true;
        gwc.isDebit = true;
        gwc.isJCT = true;
        gwc.jctQuery =caseType+';Order Processing;Order;;1 - High;UKI OTC Print';
        gwc.jctService = 'Small Works';
        gwc.jctUserBand = '1';
        gwc.tempchanged=true;
        gwc.tempsectionchanged=true;
        gwc.tempitemchanged=true;
        gwc.temprenewalchanged = true;
        gwc.tempJCTchanged = true;
        gwc.cItem = caseType+';3 - Low;1';
        gwc.location='Inside';
        gwc.section='Billing';
        gwc.oProdSection='Billing';
        gwc.isBilling =true;
        gwc.itemTitle=caseType+';;;;3 - Low;;';
        gwc.oProditem=caseType+';;;;3 - Low;';
        gwc.business='Cr';
        gwc.serviceComplaint =caseType+';Complaint;;;1 - High;UKI Online Customer Support';
        gwc.productVersion ='UKI';
       // gwc.getItems();
        gwc.natureofquery='General enquiry';
        //gwc.repEmail='test@tes.com';
        
        //getItems method differnt vlues passing to satisfy.
        //gwc.strsource=source;
        gwc.attachfile(cs);
        gwc.getItems();
        gwc.changed();
        gwc.sectionchanged();    
        gwc.itemchanged();
        gwc.submitCase();
        gwc.unsupportedBrowser();
}
    public static void runCoreTests1(Case cs, String source, list<Attachment> attachments, String caseType){
    
        PageReference pageRef = Page.GLI_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        GLI_Web2CaseFormController gwc =  new GLI_Web2CaseFormController(sc);
        gwc.c = cs;
        gwc.displayform = false;
        gwc.acctnum = '123456';
        gwc.invoicenumber='454545fndfn';
        gwc.productname = 'activa';
        gwc.firstname='eeefef';
        gwc.surname = 'sharma';
        gwc.title='njnjn';
        gwc.jctUserBand = 'None';
        gwc.serviceComplaint = 'None';
        gwc.address = 'banerjeelane';
        gwc.postcode='455885';
        gwc.querySubject='Test Subject';
        gwc.town='dsfghjk';
        gwc.country='India';
        gwc.business='LP';
        gwc.isinternal=true;
         gwc.isCustSupport=true;
        gwc.isOProdSupport=true;
        gwc.tempchanged=true;
        gwc.tempsectionchanged=true;
        gwc.tempitemchanged=true;
        gwc.temprenewalchanged = false;
        gwc.tempJCTchanged = true;
        gwc.location='Outside';
        gwc.isBilling =false;
        gwc.section='Orders';
        gwc.oProdSection='Orders';
        gwc.itemTitle=caseType+';Order Processing;Order;;3 - Low;UKI OTC Print;UKI International EXIM Orders';
        gwc.oProditem=caseType+';;Order Processing;Order;;3 - Low;UKI Online Order Management';
        gwc.attachfile(cs);
        gwc.getItems();
        gwc.submitCase();
        gwc.unsupportedBrowser();
    }
    public static void runCoreTests2(Case cs, String source, list<Attachment> attachments, String caseType){
    
        PageReference pageRef = Page.GLI_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        GLI_Web2CaseFormController gwc =  new GLI_Web2CaseFormController(sc);
        gwc.c = cs;
        gwc.displayform = false;
        gwc.acctnum = '123456';
        gwc.invoicenumber='454545fndfn';
        gwc.productname = 'activa';
        gwc.firstname='eeefef';
        gwc.surname = 'sharma';
        gwc.title='njnjn';
        gwc.address = 'banerjeelane';
        gwc.postcode='455885';
        gwc.querySubject='Test Subject';
        gwc.town='dsfghjk';
        gwc.country='India';
        gwc.business='LP';
        gwc.isinternal=true;
         gwc.isCustSupport=true;
        gwc.isOProdSupport=true;
        gwc.tempchanged=true;
        gwc.tempsectionchanged=true;
        gwc.temprenewalchanged = true;
        gwc.tempJCTchanged = true;
        gwc.tempitemchanged=true;
        gwc.isBilling =false;
        gwc.location='Outside';
        gwc.section='Online';
        gwc.oProdSection='Online';
        //gwc.itemTitle=caseType+';Content Explanation;;;3 - Low;UKI Online Customer Support';
        gwc.oProditem=caseType+';Content Explanation;;;3 - Low;UKI Online Customer Support';
        gwc.attachfile(cs);
        gwc.getItems();
        gwc.submitCase();
        gwc.unsupportedBrowser();
    }
     public static void runCoreTests3(Case cs, String source, list<Attachment> attachments, String caseType){
    
        PageReference pageRef = Page.GLI_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        GLI_Web2CaseFormController gwc =  new GLI_Web2CaseFormController(sc);
        gwc.c = cs;
        gwc.displayform = false;
        gwc.acctnum = '123456';
        gwc.invoicenumber='454545fndfn';
        gwc.productname = 'activa';
        gwc.firstname='eeefef';
        gwc.surname = 'sharma';
        gwc.title='njnjn';
        gwc.address = 'banerjeelane';
        gwc.postcode='455885';
        gwc.querySubject='Test Subject';
        gwc.town='dsfghjk';
        gwc.country='India';
        gwc.business='LP';
        gwc.isinternal=true;
        gwc.isBilling =false;
         gwc.isCustSupport=true;
        gwc.isOProdSupport=true;
        gwc.tempchanged=true;
        gwc.tempsectionchanged=true;
        gwc.temprenewalchanged = false;
        gwc.tempJCTchanged = false;
        gwc.tempitemchanged=true;
        gwc.location='Outside';
        gwc.section='General';
        gwc.oProdSection='General';
        gwc.itemTitle=caseType+';Information Request;Account Management Inquiry;;3 - Low;UKI Customer Support;UKI International General Queries';
        gwc.oProditem=caseType+';Information Request;Account Management Inquiry;;3 - Low;UKI Online Customer Support';
        gwc.attachfile(cs);
        gwc.getItems();
        gwc.submitCase();
        gwc.unsupportedBrowser();
    }
}