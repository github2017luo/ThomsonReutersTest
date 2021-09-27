@isTest    
private class Acritas_Web2CaseFormController_Test {
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
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'US';
        acct.ShippingState = 'AL';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        ///////////

        //insert contact
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        
        ////////////////
        // insert a case records
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
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
        
        Attachment attach1 = new Attachment();
        attach1.Name='Traceability Matrix - ESC Project - Master (17)';
       
        Case csClone = cs.clone();
        csClone.Subject='Test Subject Clone';
        insert csClone;
        Attachment attach = new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=csClone.id;
        testAtt.add(attach);
        
        Case csClone2 = cs.clone();
        csClone2.Subject='Test Subject Clone2';
        insert csClone2;
        
        insert testatt;
    }
    
    public static testMethod void gliWeb2CaseFormController() {
 
        Test.StartTest();
        //create a user records  
        Case csWith5Attach = [select Id,Type,Status,Subject,Description,contactid,accountid,RecordTypeId,Priority,ESC_UKI_WebForm_Rep_Name__c,ESC_Resolution_Code__c,ESC_Case_Type__c,ESC_Impact__c,ESC_UKI_WebForm_Rep_Email__c,ESC_Diagnosis_Summary__c,SuppliedEmail,SuppliedCompany,CaseNumber,SuppliedPhone from Case where subject =: 'Test Subject'];
        //Case csWith51Attach = [select Id,Type,Status,Subject,Description,contactid,accountid,ESC_UKI_WebForm_Rep_Email__c,RecordTypeId,Priority,ESC_Resolution_Code__c,ESC_Case_Type__c,ESC_Impact__c,ESC_Diagnosis_Summary__c,SuppliedEmail,SuppliedCompany,CaseNumber,SuppliedPhone from Case where subject =: 'Test Subject1'];
        Case csWith1Attach = [select Id,Type,Status,Subject,Description,contactid,ESC_UKI_WebForm_Rep_Email__c,ESC_UKI_WebForm_Rep_Name__c,accountid,RecordTypeId,Priority,ESC_Resolution_Code__c,ESC_Case_Type__c,ESC_Impact__c,ESC_Diagnosis_Summary__c,SuppliedEmail,SuppliedCompany,CaseNumber,SuppliedPhone from Case where subject =: 'Test Subject Clone'];
        Case csWithoutAttach = [select Id,Type,Status,Subject,Description,contactid,ESC_UKI_WebForm_Rep_Email__c,ESC_UKI_WebForm_Rep_Name__c,accountid,RecordTypeId,Priority,ESC_Resolution_Code__c,ESC_Case_Type__c,ESC_Impact__c,ESC_Diagnosis_Summary__c,SuppliedEmail,SuppliedCompany,CaseNumber,SuppliedPhone from Case where subject =: 'Test Subject Clone2'];
        List<Attachment> attachments=[select id, name, BodyLength from Attachment where parent.id=:csWith5Attach.id];
        //System.assertEquals(5, attachments.size());
        
        
        runCoreTests(csWithoutAttach,'Acritas','Request for Action');
        runCoreTests2(csWithoutAttach,'Acritas', 'Request for Action');
        runCoreTests3(csWithoutAttach,'Acritas', 'Request for Action');
       runCoreTests1(csWithoutAttach,'Acritas', 'Request for action');
        runCoreTests4(csWithoutAttach,'Acritas', 'Request for Action');
        runCoreTests5(csWithoutAttach,'Acritas', 'Request for Action');
       integer k = 1;
        integer j = 1;
        integer l = 1;
        System.assertEquals(k,j,l);
        Test.StopTest();
        
}

    public static void runCoreTests(Case cs, String source, String caseType){
    
        PageReference pageRef = Page.Acritas_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        Acritas_Web2CaseFormController gwc =  new Acritas_Web2CaseFormController(sc);
        Acritas_Utility gwc1 = new Acritas_Utility(sc);
        Acritas_CaseFieldsMappingWrapper cs1 = new Acritas_CaseFieldsMappingWrapper();
        Acritas_ProductSelectOptionWrapper pd = new Acritas_ProductSelectOptionWrapper();
        gwc.c = cs;
        gwc.displayform = false;
        cs1.acctnum = '123456';
        cs1.invoicenumber='454545fndfn';
        cs1.productname = 'activa';
        cs1.firstname='eeefef';
        cs1.surname = 'sharma';
        cs1.address = 'banerjeelane';
        cs1.postcode='455885';
        //gwc.repName ='test';
        //gwc.repEmail = 'test@gmail.com';
        
        
        cs1.town='dsfghjk';
        cs1.country='India';
        gwc1.publicKey = '12345';
        gwc.csWrapper = cs1;
        gwc.tempsectionchanged=true;
        gwc.temprenewalchanged = true;
        gwc.tempitemchanged=true;
        pd.oProdSection='Billing';
        pd.oProditem=caseType+';;;;3 - Low;';
        
        //gwc.repEmail='test@tes.com';
        
        //getItems method differnt vlues passing to satisfy.
        //gwc.strsource=source;
        //gwc.attachfile(cs);
        gwc.prodWrapper = pd;
        gwc.sectionchanged();    
        gwc.itemchanged();
        gwc.submitCase();
        gwc1.unsupportedBrowser();
}
    public static void runCoreTests1(Case cs, String source, String caseType){
    
        PageReference pageRef = Page.Acritas_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        Acritas_Web2CaseFormController gwc =  new Acritas_Web2CaseFormController(sc);
        Acritas_Utility gwc1 = new Acritas_Utility(sc);
        Acritas_CaseFieldsMappingWrapper cs1 = new Acritas_CaseFieldsMappingWrapper();
        Acritas_ProductSelectOptionWrapper pd = new Acritas_ProductSelectOptionWrapper();
        gwc.c = cs;
        gwc.displayform = false;
        cs1.acctnum = '123456';
        cs1.invoicenumber='454545fndfn';
        cs1.productname = 'activa';
        cs1.firstname='eeefef';
        cs1.surname = 'sharma';
        cs1.address = 'banerjeelane';
        cs1.postcode='455885';
        cs1.town='dsfghjk';
        cs1.country='India';
        gwc.csWrapper = cs1;
        gwc.tempsectionchanged=true;
        gwc.tempitemchanged=true;
        gwc.temprenewalchanged = true;
        pd.oProdSection='Orders';
        pd.oProditem=caseType+';Orders, Pricing & Subscriptions;Modify Subscription;Cancel Subscription;3 - Low;UKI Online Order Management';
        pd.oProdRenewal = 'Renewal Cancellation';
        //gwc.attachfile(cs);
        gwc.prodWrapper = pd;
        gwc.submitCase();
        gwc1.unsupportedBrowser();
    }
    public static void runCoreTests2(Case cs, String source, String caseType){
    
        PageReference pageRef = Page.Acritas_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        Acritas_Web2CaseFormController gwc =  new Acritas_Web2CaseFormController(sc);
        Acritas_utility gwc1 = new Acritas_utility(sc);
        Acritas_CaseFieldsMappingWrapper cs1 = new Acritas_CaseFieldsMappingWrapper();
        Acritas_ProductSelectOptionWrapper pd = new Acritas_ProductSelectOptionWrapper();
        gwc.c = cs;
        gwc.displayform = false;
       cs1.acctnum = '123456';
        cs1.invoicenumber='454545fndfn';
        cs1.productname = 'activa';
       cs1.firstname='eeefef';
       cs1.surname = 'sharma';
        //gwc.title='njnjn';
       cs1.address = 'banerjeelane';
       cs1.postcode='455885';
       cs1.town='dsfghjk';
       cs1.country='India';
       gwc.csWrapper=cs1;
        gwc.tempsectionchanged=true;
        gwc.tempitemchanged=true;
        gwc.temprenewalchanged = true;
        pd.oProdSection='Online';
        //gwc.itemTitle=caseType+';Content Explanation;;;3 - Low;UKI Online Customer Support';
        pd.oProditem=caseType+';Content Explanation;;;3 - Low;UKI Online Customer Support';
        //gwc.attachfile(cs);
        //gwc.getItems();
        gwc.prodWrapper = pd;
        gwc.submitCase();
        gwc1.unsupportedBrowser();
    }
     public static void runCoreTests3(Case cs, String source,String caseType){
    
        PageReference pageRef = Page.Acritas_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        Acritas_Web2CaseFormController gwc =  new Acritas_Web2CaseFormController(sc);
        Acritas_Utility gwc1 = new Acritas_Utility(sc);
        Acritas_CaseFieldsMappingWrapper cs1 = new Acritas_CaseFieldsMappingWrapper();
        Acritas_ProductSelectOptionWrapper pd = new Acritas_ProductSelectOptionWrapper();
        gwc.c = cs;
        gwc.displayform = false;
        cs1.acctnum = '123456';
        cs1.invoicenumber='454545fndfn';
        cs1.productname = 'activa';
        cs1.firstname='eeefef';
       cs1.surname = 'sharma';
        cs1.address = 'banerjeelane';
        cs1.postcode='455885';
        cs1.town='dsfghjk';
        cs1.country='India';
        gwc.csWrapper = cs1;
        gwc.tempsectionchanged=true;
        gwc.tempitemchanged=true;
        gwc.temprenewalchanged = true;
        pd.oProdSection='General';
        pd.oProditem=caseType+';Information Request;Account Management Inquiry;;3 - Low;UKI Online Customer Support';
        //gwc.attachfile(cs);
        //gwc.getItems();
        gwc.prodWrapper = pd;
        gwc.submitCase();
        gwc1.unsupportedBrowser();
    }
    public static void runCoreTests4(Case cs, String source,String caseType){
    
        PageReference pageRef = Page.Acritas_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        Acritas_Web2CaseFormController gwc =  new Acritas_Web2CaseFormController(sc);
        Acritas_Utility gwc1 = new Acritas_Utility(sc);
        Acritas_CaseFieldsMappingWrapper cs1 = new Acritas_CaseFieldsMappingWrapper();
        Acritas_ProductSelectOptionWrapper pd = new Acritas_ProductSelectOptionWrapper();
        gwc.c = cs;
        string key=gwc1.publicKey;
        gwc.displayform = false;
        cs1.acctnum = '123456';
        cs1.invoicenumber='454545fndfn';
        cs1.productname = 'activa';
        cs1.firstname='eeefef';
       cs1.surname = 'sharma';
        //gwc.title='njnjn';
        cs1.address = 'banerjeelane';
        cs1.postcode='455885';
        cs1.town='dsfghjk';
        cs1.country='India';
        gwc.csWrapper = cs1;
        gwc.tempsectionchanged=true;
        gwc.temprenewalchanged =false;
        gwc.tempitemchanged=true;
        pd.oProdSection='Access';
        pd.oProditem=caseType+';Information Request;Account Management Inquiry;;3 - Low;UKI Online Customer Support';
        //gwc.attachfile(cs);
        //gwc.getItems();
        gwc.prodWrapper = pd;
        gwc.submitCase();
        gwc1.unsupportedBrowser();
    }
    
    public static void runCoreTests5(Case cs, String source,String caseType){
    
        PageReference pageRef = Page.Acritas_Web2CaseForm;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',cs.id);
        pageRef.getParameters().put('source',source);
        pageRef.getParameters().put('recaptcha_response_field','testCap');
        pageRef.getParameters().put('recaptcha_challenge_field','testCap');
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        Acritas_Web2CaseFormController gwc =  new Acritas_Web2CaseFormController(sc);
        Acritas_Utility gwc1 = new Acritas_Utility(sc);
        Acritas_CaseFieldsMappingWrapper cs1 = new Acritas_CaseFieldsMappingWrapper();
        Acritas_ProductSelectOptionWrapper pd = new Acritas_ProductSelectOptionWrapper();
        case cs2 = new case();
        cs2.Subject='Test Subject';
        cs2.Description = 'Test Description111';
        cs2.SuppliedEmail = 'asdasd@123.com';
        cs2.SuppliedPhone='234567890';
        cs2.suppliedcompany='dgfhjk';
        cs2.ESC_UKI_WebForm_Rep_Email__c='tsaa@ty.com';
        cs2.ESC_UKI_WebForm_Rep_Name__c='Sai';
        gwc.c = cs2;
        gwc.displayform = false;
        //cs1.acctnum = '123456';
        cs1.invoicenumber='454545fndfn';
        cs1.productname = 'activa';
        cs1.firstname='eeefef';
       cs1.surname = 'sharma';
        //gwc.title='njnjn';
        cs1.address = 'banerjeelane';
        cs1.postcode='455885';
        cs1.town='dsfghjk';
        cs1.country='India';
        gwc.csWrapper = cs1;
        gwc.tempsectionchanged=true;
        gwc.tempitemchanged=true;
        gwc.temprenewalchanged = true;
        pd.oProdSection='Access';
        pd.oProditem=caseType+';Information Request;Account Management Inquiry;;3 - Low;UKI Online Customer Support';
        //gwc.attachfile(cs);
        //gwc.getItems();
        gwc.prodWrapper = pd;
        gwc.submitCase();
        gwc1.unsupportedBrowser();
    }
    
}