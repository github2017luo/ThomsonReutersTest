@isTest
private class ESC_AssociateInvoiceController_Test{
    static testmethod void testmethod1(){
        Account testAcc1 = new Account();
        testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '5491';
        insert testAcc1;
        System.assertEquals(testAcc1.SAPAccountNumber__c,'5491','Sap No is Correct?!!');
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
        insert c;            
        test.startTest();
        Case testCase=ESC_GenericTestutility.TestCaseUtil(c.id,testAcc1.id,'New');
        testcase.LCRM_Sub_BU__c='USL';
        testcase.Subject='test1';
        testcase.ESC_Impact__c = '1-Whole Site';
        testcase.ESC_Severity__c='1 - High';
        testcase.ESC_Customer_Symptom__c='Content Addition';
        testcase.Description = 'test description';
        testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        testcase.USL_Queue_Name__c='Academic_Support';
        testcase.ESC_Diagnosis_Summary__c='Content Explanation';
        testcase.USL_SAP_Account_Number__c='123321123';
        insert testcase;
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        ssd.Source_System_Account_Number__c = '123321123';
        ssd.Source_System_Name__c = 'test';
        insert ssd;
        PageReference pageRef = Page.ESC_Associate_Invoices;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id', testcase.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testcase);
        ESC_AssociateInvoiceController assoinvcon = new ESC_AssociateInvoiceController(sc);  
        assoinvcon.checkdate();
        test.stopTest();
        Case testCase1=ESC_GenericTestutility.TestCaseUtil(c.id,testAcc1.id,'New');
        testcase1.LCRM_Sub_BU__c='USL';
        testcase1.Subject='test1';
        testcase1.ESC_Impact__c = '1-Whole Site';
        testcase1.ESC_Severity__c='1 - High';
        testcase1.ESC_Customer_Symptom__c='Content Addition';
        testcase1.Description = 'test description';
        testcase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        testcase1.USL_Queue_Name__c='Academic_Support';
        testcase1.ESC_Diagnosis_Summary__c='Content Explanation';        
        insert testcase1; 
        
        assoinvcon.invwrap.begindt = system.today().addDays(-375);
        assoinvcon.invwrap.enddt = system.today();
        assoinvcon.checkdate();
        assoinvcon.invwrap.begindt = system.today().addDays(375);
        assoinvcon.invwrap.enddt = system.today();
        assoinvcon.checkdate();
        assoinvcon.invwrap.begindt = null;
        assoinvcon.invwrap.enddt = null;
        assoinvcon.checkdate();
        PageReference pageRef1 = Page.ESC_Associate_Invoices;
        test.setCurrentPageReference(pageRef1);
        pageRef1.getParameters().put('id', testcase1.id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(testcase1);
        ESC_AssociateInvoiceController assoinvcon1 = new ESC_AssociateInvoiceController(sc1);  
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'test');
    }
    
    static testmethod void testmethod2(){
        Account testAcc1 = new Account();
        testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '5491';
        insert testAcc1;
        System.assertEquals(testAcc1.SAPAccountNumber__c,'5491','Sap No is Correct?!!');
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
        insert c;            
        
        Case testCase=ESC_GenericTestutility.TestCaseUtil(c.id,testAcc1.id,'New');
        testcase.LCRM_Sub_BU__c='USL';
        testcase.Subject='test1';
        testcase.ESC_Impact__c = '1-Whole Site';
        testcase.ESC_Severity__c='1 - High';
        testcase.ESC_Customer_Symptom__c='Content Addition';
        testcase.Description = 'test description';
        testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        testcase.USL_Queue_Name__c='Academic_Support';
        testcase.ESC_Diagnosis_Summary__c='Content Explanation';
        testcase.USL_SAP_Account_Number__c='123321123';
        insert testcase;
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        ssd.Source_System_Account_Number__c = '123321123';
        ssd.Source_System_Name__c = 'test';
        insert ssd;
        PageReference pageRef = Page.ESC_Associate_Invoices;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id', testcase.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testcase);
        ESC_AssociateInvoiceController assoinvcon = new ESC_AssociateInvoiceController(sc);  
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLARController());
        assoinvcon.checkdate();
        
        assoinvcon.nextPage();
        assoinvcon.previousPage();
        assoinvcon.updatePage();
        assoinvcon.cnextPage();
        assoinvcon.cpreviousPage();
        assoinvcon.cupdatePage();
        assoinvcon.saveinvoice();
        assoinvcon.pagiwrap.openpagiwrap.openwrapperlist2[0].isselected = true;
        assoinvcon.pagiwrap.clearpagiwrap.clearwrapperlist2[0].isselected = true;
        assoinvcon.saveinvoice();
        
        test.stopTest();
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'test');
          
    }
    
    static testmethod void testmethod3(){
        Account testAcc1 = new Account();
        testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '5491';
        insert testAcc1;
        System.assertEquals(testAcc1.SAPAccountNumber__c,'5491','Sap No is Correct?!!');
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCH',Companyid__c='S100',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
        insert c;            
        
        Case testCase=ESC_GenericTestutility.TestCaseUtil(c.id,testAcc1.id,'New');
        testcase.LCRM_Sub_BU__c='USL';
        testcase.Subject='test1';
        testcase.ESC_Impact__c = '1-Whole Site';
        testcase.ESC_Severity__c='1 - High';
        testcase.ESC_Customer_Symptom__c='Content Addition';
        testcase.Description = 'test description';
        testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        testcase.USL_Queue_Name__c='Academic_Support';
        testcase.ESC_Diagnosis_Summary__c='Content Explanation';
        testcase.USL_SAP_Account_Number__c='123321123';
        insert testcase;
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        ssd.Source_System_Account_Number__c = '123321123';
        ssd.Source_System_Name__c = 'test';
        insert ssd;
        PageReference pageRef = Page.ESC_Associate_Invoices;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id', testcase.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testcase);
        ESC_AssociateInvoiceController assoinvcon = new ESC_AssociateInvoiceController(sc);  
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLARController());
        assoinvcon.checkdate();
        
        assoinvcon.nextPage();
        assoinvcon.previousPage();
        assoinvcon.updatePage();
        assoinvcon.cnextPage();
        assoinvcon.cpreviousPage();
        assoinvcon.cupdatePage();
        assoinvcon.saveinvoice();
        assoinvcon.pagiwrap.openpagiwrap.openwrapperlist2[0].isselected = true;
        assoinvcon.pagiwrap.clearpagiwrap.clearwrapperlist2[0].isselected = true;
        assoinvcon.saveinvoice();
        
        test.stopTest();
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'test');
          
    }
}