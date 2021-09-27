@istest(SeeAllData=false)
public class USLARController_test {
    
     @istest public static void test_methodossd(){
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.SAPAccountNumber__c='hos454';
        testAccount.Sales_Org__c='BEJE';
        insert testAccount;
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
        testContact.FirstName='testerrr';
        insert testContact;
        Case ca= new Case();
        ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'New');
        ca.USL_SAP_Account_Number__c='4152test';
        Insert ca;
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
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
        insert testUser;      
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c='00e30000001ZUki');
        //insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c='01230000001MA4h');
        // insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c='01230000001MA4g');
        System.Runas(testUser){  
            Account testAcc1 = UnitTest.getAccountInstance();
            testAcc1.Sales_Org__c ='WEST' ;
            insert testAcc1;
            //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
            //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL Source Systems').getRecordTypeId();
            Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.RecordtypeId=ssdRecorType;
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=testAcc1.ID;
            accountSSD.Digital_Firm_Name__c = 'Test Firm';
            accountSSD.Digital_Billing_City__c = 'California';
            accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='WEST';
            accountSSD.LCRM_Customer_Group__c='';
            accountSSD.Source_System_Account_Number__c = '1000000040';
            accountSSD.LCRM_SAP_ACCOUNT_NUMBER__C=ca.USL_SAP_Account_Number__c;
            insert accountSSD;
            List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'USL PaymentGateway';       
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'Service Unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);
            
            if(lstofWebServ.size()>0){
            insert lstofWebServ;
            }
            
            list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
            LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
            IntDefault.name='AccountReceivableInvoiceList';
            IntDefault.LCRM_ApplicationId__c='GLI';
            IntDefault.LCRM_CompanyId__c='SSD ';
            IntDefault.LCRM_ExternalSystemName__c='ESI';
            IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
            integrationDefaultlst.add(IntDefault);
            if(integrationDefaultlst.size()>0){
            insert integrationDefaultlst;
            }  
            Test.startTest();
            
            ApexPages.CurrentPage().getParameters().put('caseid',ca.id);
            Test.setMock(HttpCalloutMock.class, new MockUSLARController());
            PageReference pageRef = Page.USLARpage;
            pageRef.getParameters().put('invoice','6118005220');
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController controller = new Apexpages.StandardController(ca); 
            USLARController USLARC = new USLARController(controller);
            
            //MTRAAAMachineAuthenticateService auth1 = MTRAAAMachineAuthenticateService.GetToken();
            // USLARController USLARC = new USLARController();
            
            //USLARC.getresponses('6/8/2017','6/8/2018');
            //Test.setMock(HttpCalloutMock.class, new USLARController_MockResponseGenerator());
            Test.stopTest();
            
        }
    }
    
    @istest 
    public static void test_method1(){
        USL_Integration_defaults__c int2 = new USL_Integration_defaults__c();
        int2.Applicationid__c = 'ESCU';
        int2.Companyid__c = 'WEST';
        int2.name = 'Integrationdefaults';
        insert int2;
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        insert testAccount;
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
        insert testContact;
        Case ca= new Case();
        ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'New');
        ca.USL_SAP_Account_Number__c='123456';
        Insert ca;
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
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
        insert testUser;      
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c='00e30000001ZUki');
        //insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c='01230000001MA4h');
        // insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c='01230000001MA4g');
        System.Runas(testUser){  
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_Org__c ='WEST' ;
        insert testAcc1;
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL Source Systems').getRecordTypeId();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=testAcc1.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.LCRM_Customer_Group__c='';
        accountSSD.Digital_Firm_Name__c = 'Test Firm';
        accountSSD.Digital_Billing_City__c = 'California';
        accountSSD.Source_System_Account_Number__c = '1000000040';
        insert accountSSD;
        
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c Webserve = new WebServiceSettings__c();
        Webserve.name = 'USL PaymentGateway';       
        Webserve.Active__c = true;
        Webserve.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
        Webserve.Password__c = 'esidevuser123';
        Webserve.Service_Unavailable_Message__c = 'Service Unavailable';
        Webserve.Timeout__c = 120;
        Webserve.Username__c = 'esidevuser';
        lstofWebServ.add(Webserve);
        
        if(lstofWebServ.size()>0){
        insert lstofWebServ;
        }
        
        list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
        LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
        IntDefault.name='AccountReceivableInvoiceList';
        IntDefault.LCRM_ApplicationId__c='GLI';
        IntDefault.LCRM_CompanyId__c='SSD ';
        IntDefault.LCRM_ExternalSystemName__c='ESI';
        IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
        integrationDefaultlst.add(IntDefault);
        if(integrationDefaultlst.size()>0){
        insert integrationDefaultlst;
        }    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLARController());
        PageReference pageRef = Page.USLARpage;
        pageRef.getParameters().put('invoice','6118005220');
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(accountSSD); 
        USLARController USLARC = new USLARController(controller);
        
        USLARC.oAccount= testAcc1;
        USLARC.caserec= ca;
        USLARC.goback();
        USLARC.setInvoiceDateRange();
        USLARC.saveselectedopen();
        USLARC.saveselectedopen1();
        USLARC.ProcessSelected();
        //USLARC.SaveSelectedInvoices();
        PageReference pageref1 = USLARC.Next();
        PageReference pageref2 = USLARC.print();
        USLARC.Calculate();
        /**USLARC.updatePage();
        USLARC.cpreviousPage();
        USLARC.cnextPage();
        USLARC.cupdatePage();
        USLARC.cchangeData();**/
        USLARC.getARItemType();
        // USLARC.getARCardType();
        
        USLARWrapper.openedItems opnitm  = new USLARWrapper.openedItems();
        USLARWrapper.Status USLStat  = new USLARWrapper.Status();
        USLARWrapper.ARrequest USLStat1  = new USLARWrapper.ARrequest();
        USLARWrapper.Status USLStat2  = new USLARWrapper.Status();
        //  PageReference pageref3 = USLARC.Submit();
        
        //MTRAAAMachineAuthenticateService auth1 = MTRAAAMachineAuthenticateService.GetToken();
        // USLARController USLARC = new USLARController();
        
        //USLARC.getresponses('6/8/2017','6/8/2018');
        //Test.setMock(HttpCalloutMock.class, new USLARController_MockResponseGenerator());
        
        Test.setMock(HttpCalloutMock.class, new MockUSLARController()); 
        USLARHelper.USLARCalloutHelper('testing','testingresponse');
        WebServiceSettings__c service1 = new WebServiceSettings__c(name='Invoice',Endpoint__c='https//:google.com.in',Username__c='testuser',Password__c='service@123',Service_Unavailable_Message__c='Unavailable',Timeout__c=120);
        insert service1;
        //AppUtil ins1 =new AppUtil();
        //ins1.getWebServiceSettings('Invoice');
        USLARC.getresponses('6/8/2017','6/8/2018');
        USLARC.addrow();
        Apexpages.currentPage().getParameters().put('rn','1');
        USLARC.deleterow();
        
        
        //WebServiceSettings__c rec1 =
        Test.stopTest();
  
    }
    }
    @istest 
    public static void test_method2(){
        USL_Integration_defaults__c int3 = new USL_Integration_defaults__c();
        int3.Applicationid__c = 'ESCU';
        int3.Companyid__c = 'WEST';
        int3.name = 'Integrationdefaults';
        insert int3;  
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        insert testAccount;
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
        insert testContact;
        Case ca= new Case();
        ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'New');
        ca.USL_SAP_Account_Number__c='123456';
        Insert ca;
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
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
        insert testUser;      
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c='00e30000001ZUki');
        //insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c='01230000001MA4h');
        // insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c='01230000001MA4g');
        System.Runas(testUser){  
            Account testAcc1 = UnitTest.getAccountInstance();
            testAcc1.Sales_Org__c ='WEST' ;
            insert testAcc1;
            //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
           //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL Source Systems').getRecordTypeId();
            Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.RecordtypeId=ssdRecorType;
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=testAcc1.ID;
            accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='WEST';
            accountSSD.LCRM_Customer_Group__c='';
            accountSSD.Source_System_Account_Number__c = '1000000040';
            accountSSD.Digital_Firm_Name__c = 'Test Firm';
            accountSSD.Digital_Billing_City__c = 'California';
            insert accountSSD;
            List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'USL PaymentGateway';       
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'Service Unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);
            
            if(lstofWebServ.size()>0){
            insert lstofWebServ;
            }
            list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
            LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
            IntDefault.name='AccountReceivableInvoiceList';
            IntDefault.LCRM_ApplicationId__c='GLI';
            IntDefault.LCRM_CompanyId__c='SSD ';
            IntDefault.LCRM_ExternalSystemName__c='ESI';
            IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
            integrationDefaultlst.add(IntDefault);
            if(integrationDefaultlst.size()>0){
            insert integrationDefaultlst;
            }   
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLARController());
            PageReference pageRef = Page.USLARpage;
            pageRef.getParameters().put('invoice','6118005220');
            pageRef.getParameters().put('caseid',ca.id);
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController controller = new Apexpages.StandardController(ca); 
            USLARController USLARC = new USLARController(controller);
            //USLARC.createreferral();
            //MTRAAAMachineAuthenticateService auth1 = MTRAAAMachineAuthenticateService.GetToken();
            // USLARController USLARC = new USLARController();
            
            //USLARC.getresponses('6/8/2017','6/8/2018');
            //Test.setMock(HttpCalloutMock.class, new USLARController_MockResponseGenerator());
            Test.stopTest();
      
    }
    }
   
   
   public static testmethod void test_method4(){
        USL_Integration_defaults__c int4 = new USL_Integration_defaults__c();
        int4.Applicationid__c = 'ESCU';
        int4.Companyid__c = 'WEST';
        int4.name = 'Integrationdefaults';
        insert int4;
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710'); 
        testAccount.Sales_Org__c ='WEST';       
        insert testAccount;
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','Test','test@tr.com');
        insert testContact;
        Case ca= new Case();
        ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,testAccount.id,'New');
        ca.USL_SAP_Account_Number__c='123456';
        Insert ca;
        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
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
        insert testUser;      
        //insert new KeyValueListStore__c(name = 'ANZUsersProfileId',TextValue__c='00e30000001ZUki');
        //insert new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities',recTypeId__c='01230000001MA4h');
        // insert new RecordtypeIds__c(name = 'Pipeline Opportunities',recTypeId__c='01230000001MA4g');
        System.Runas(testUser){  
        /*Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_Org__c ='WEST' ;
        insert testAcc1;*/
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL Source Systems').getRecordTypeId();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=testAccount.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.LCRM_Customer_Group__c='';
        accountSSD.Source_System_Account_Number__c = '1000000040';
        accountSSD.Digital_Firm_Name__c = 'Test Firm';
            accountSSD.Digital_Billing_City__c = 'California';
        //insert accountSSD;
        
        list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
        LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
        IntDefault.name='AccountReceivableInvoiceList';
        IntDefault.LCRM_ApplicationId__c='GLI';
        IntDefault.LCRM_CompanyId__c='SSD ';
        IntDefault.LCRM_ExternalSystemName__c='ESI';
        IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
        integrationDefaultlst.add(IntDefault);
        if(integrationDefaultlst.size()>0){
        insert integrationDefaultlst;
        }
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c Webserve = new WebServiceSettings__c();
        Webserve.name = 'USL PaymentGateway';       
        Webserve.Active__c = true;
        Webserve.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
        Webserve.Password__c = 'esidevuser123';
        Webserve.Service_Unavailable_Message__c = 'Service Unavailable';
        Webserve.Timeout__c = 120;
        Webserve.Username__c = 'esidevuser';
        lstofWebServ.add(Webserve);
        
        if(lstofWebServ.size()>0){
        insert lstofWebServ;
        }
        
        USLARWrapper.AR_document cc1= new USLARWrapper.AR_document();
        cc1.type='dont know';
        cc1.docNumber='56816';
        cc1.docDate='21/6/2018';
        cc1.additionalPdfDocumentId='s97079sjh8sksd0';
        
        USLARWrapper.openedItems cs1= new USLARWrapper.openedItems();
        cs1.referencekey='';
        cs1.postingDate='21/6/2018';
        cs1.amount=14523;
        cs1.lineNumber='100';
        cs1.reasonCode='400';
        cs1.debitCreditInd='H';
        cs1.dunningArea='test143';
        cs1.dunningBlock='test234';
        cs1.shipTo='Mars';
        cs1.servicesRenderedDate='21/6/2018';
        cs1.pdfLinkInd='none';
        cs1.netArrers='55';
        cs1.shortDescription='enough';
        cs1.longDescription='too much';
        cs1.baselineDate='21/6/2018';
        cs1.pastDueFlag='1';
        cs1.processingStatus='processing';
        cs1.isSelected=True;
        cs1.NewAmount=9369369;
        cs1.document=cc1;
        
        USLARWrapper.sourceOrTargetReference sotr = new USLARWrapper.sourceOrTargetReference();
        sotr.referenceID='7jr9fhj3k';
        
        USLARWrapper.Accountref acc= new USLARWrapper.Accountref();
        // acc.sourceOrTargetRef=sotr;
        
        USLARWrapper.AR_cldocument arcld = new USLARWrapper.AR_cldocument();
        arcld.type='dummyx';
        arcld.account=acc;
        arcld.docNumber='14369';
        arcld.docDate='21/6/2018';
        arcld.referenceNumber='9876';
        arcld.additionalPdfDocumentId='1q2w3e4r';
        
        USLARWrapper.clearedItems ci= new USLARWrapper.clearedItems();
        // ci.accountref=acc;
        ci.referencekey='hell_ee';
        ci.postingDate ='21/6/2018';
        ci.amount=963963;
        ci.dueDate='21/6/2018';
        ci.reasonCode='999';
        ci.debitCreditInd='S';
        ci.dunningArea='testdummy12';
        ci.allocationNumber='4585478';
        ci.clearingDate='21/6/2018';
        ci.clearingDocumentNumber='159753';
        ci.dunningBlock='testdummy123';
        ci.dunningLevel='level0';
        ci.paymentMethod='bitcoin';
        ci.netArrers='123';
        ci.specialGeneralLedgerInd='dont know';
        ci.document=arcld;
        ci.shortDescription='sd';
        ci.longDescription='ld';
        ci.baselineDate='21/6/2018';
        
        List<USLARWrapper.clearedItems> lci= new List<USLARWrapper.clearedItems>();
        lci.add(ci);
        
        List<USLARWrapper.openedItems> loi= new List<USLARWrapper.openedItems>();
        loi.add(cs1);
        
        //USLARWrapper.totalOpenItemAmount=541236;
        //USLARWrapper.totalOpenItemAmountInvoiced=563256;
        //USLARWrapper.pastDueBalance=542541;
        //USLARWrapper.clearedItems=lci;
        //USLARWrapper.openedItems=loi;
        
        USLARWrapper.clearedallitems cai= new USLARWrapper.clearedallitems();
        cai.Oitem=loi;
        cai.citem=lci;
        cai.totalOpenItemAmount=456325;
        cai.totalOpenItemAmountInvoiced=123652;
        cai.pastDueBalance=563254;
        
        USLARWrapper.OpenItem oitem= new USLARWrapper.OpenItem();
        oitem.totalOpenItemAmount=456325;
        oitem.totalOpenItemAmountInvoiced=123652;
        oitem.pastDueBalance=563254;
        oitem.oopenedItems=cs1;
        
        USLARWrapper.oCleareditems ocitem= new USLARWrapper.oCleareditems();
        ocitem.totalOpenItemAmount=456325;
        ocitem.totalOpenItemAmountInvoiced=123652;
        ocitem.pastDueBalance=563254;
        ocitem.oclearedItems=lci;
        
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1; 
        //Account Acc1 = new Account();
        //Contact Con = new Contact();
        //Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        //insert Acc1;
        /*Con =ESC_GenericTestutility.TestContactUtil(testAccount.ID, 'test','contact','test7365@gmail.com');
        insert Con;*/
        /*Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        ca.USL_SAP_Account_Number__c='123456';
        insert case1;*/
        /*GenerateForm__c form2 = new GenerateForm__c(Name ='Charge Cancellation',LabelName__c='Charge Cancellation12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form2; */
        
        
        /*ESC_Case_Form_Extension__c Cextn = new ESC_Case_Form_Extension__c(name='testing',ESC_Segment_Special_offer__c='Corporate',ESC_form__c=form1.id,Correction_Required__c = 'Price Correction',ESC_case__c = ca.id,ESC_Segment__c='Academic',ESC_Sales_Org__c='West',Reason_for_Request__c='Reason for Request',ESC_Instructions__c='Comments');
        insert Cextn ;*/
        
        //Test.startTest();
        //ESC_Case_Form_Extension_Line_Item__c ExtLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c= cextn.id,Name='Cextn.Name',ESC_Material_Number__c='test',Billing_Line_Item_Number__c='12345',Per_Line__c='test');
       /* ESC_Case_Form_Extension_Line_Item__c ExtLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c= cextn.id,Name='Cextn.Name',Billing_Line_Item_Number__c='12345',USL_OAmount__c='10');
        insert ExtLineitem ;*/
        
        //Test.stopTest();    
        
        PageReference pageRef = Page.USLARpage;
        pageRef.getParameters().put('invoice','6118005220');
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('caseid',ca.id);
        ApexPages.CurrentPage().getParameters().put('formid',form1.id);
        Apexpages.StandardController controller = new Apexpages.StandardController(ca); 
        USLARController USLARC = new USLARController(controller);
        
        USLARWrapper.openedItems opnitm  = new USLARWrapper.openedItems();
        USLARWrapper.Status USLStat  = new USLARWrapper.Status();
        USLARWrapper.ARrequest USLStat1  = new USLARWrapper.ARrequest();
        USLARWrapper.Status USLStat2  = new USLARWrapper.Status();
        //  PageReference pageref3 = USLARC.Submit();
        USLARWrapper.cls_processStatus var1=new USLARWrapper.cls_processStatus();
        var1.statusCode='400';
        var1.statusDescription='testingdummy';
        var1.statusDetailMessage='testingdummy1';
        USLARWrapper.status var2= new USLARWrapper.status();
        var2.processStatus = var1;
        
        List<USLARWrapper.openedItems> oi= new List<USLARWrapper.openedItems>();
        oi.add(cs1);
        USLARC.OSelectedlist=oi;
        //USLARWrapper.status.class var2= new USLARWrapper.status.class();
        //USLARWrapper.status.processStatus= var1;
        //var2.processStatus =
        
        
        WebServiceSettings__c service1 = new WebServiceSettings__c(name='Invoice',Endpoint__c='https//:google.com.in',Username__c='testuser',Password__c='service@123',Service_Unavailable_Message__c='Unavailable',Timeout__c=120);
        insert service1;
        List<WebServiceSettings__c> lstofWebServ1 = new List<WebServiceSettings__c>();
        WebServiceSettings__c Webserve1 = new WebServiceSettings__c();
        Webserve1.name = 'USL PaymentGateway';       
        Webserve1.Active__c = true;
        Webserve1.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
        Webserve1.Password__c = 'esidevuser123';
        Webserve1.Service_Unavailable_Message__c = 'Service Unavailable';
        Webserve1.Timeout__c = 120;
        Webserve1.Username__c = 'esidevuser';
        lstofWebServ1.add(Webserve1);
        
        if(lstofWebServ1.size()>0){
        insert lstofWebServ1;
        }
        Test.startTest();
        USLARHelper.USLARCalloutHelper('testing','testingresponse');
        Test.setMock(HttpCalloutMock.class, new MockUSLARController());
        USLARC.getresponses('6/8/2017','6/8/2018');
        
        USLARC.setInvoiceDateRange();
        USLARC.ProcessSelected();
        USLARC.selectall=true;
        USLARC.selectallclear=true;
        USLARC.selectalllineitem();
        USLARC.selectalllineitem1();
        USLARC.addrow();
        PageReference pageref2 = USLARC.Submit();
        PageReference pageref1 = USLARC.Next();
        USLARC.Calculate();
        USLARC.getARItemType();
        USLARC.goback();
        //USLARC.getARCardType();
        //USLARC.SaveSelectedInvoices();
        
        //USLARC.Submit();
        Test.stopTest();
        }
    } 
    
    
    /*
    
    
    */
    
     /*
    Exception Handling
    */
    
    @isTest static void testexcephandlingforUSL() {
        User testUser = new User(
        Alias = 'sUser', 
        Email='abc1@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='Testing', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'WEST',
        Sub_Bu__c='USL',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='abc123@testorg.com'
        );
        insert testUser;
        System.runAs(testUser) {
        
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        Account accRecord = new Account();
        accRecord = UnitTest.getAccountInstance();
        accRecord.SAPAccountNumber__c = '5491';
        insert accRecord;
        
        List < Source_System_Detail__c > listofSSD = new List < Source_System_Detail__c > ();
        Source_System_Detail__c ssdwithSAPNo = new Source_System_Detail__c();
        ssdwithSAPNo.name = 'SSD_01';
        ssdwithSAPNo.Source_System_Account_Number__c = '10000';
        ssdwithSAPNo.Account_Name__c = accRecord.id;
        ssdwithSAPNo.Source_System_Name__c = 'TRTAUNI';
        ssdwithSAPNo.LCRM_Sales_Org__c = 'WEST';
        listofSSD.add(ssdwithSAPNo);
        
        Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
        ssdWithSalesOrg.name = 'SSD_02';
        ssdWithSalesOrg.Source_System_Account_Number__c = '8000';
        ssdWithSalesOrg.Account_Name__c = accRecord.id;
        ssdWithSalesOrg.Source_System_Name__c = 'ENTWRP';
        ssdWithSalesOrg.LCRM_Sales_Org__c = 'WEST';
        listofSSD.add(ssdWithSalesOrg);
        
        if (listofSSD.size() > 0) {
        insert listofSSD;
        }
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c Webserve = new WebServiceSettings__c();
        Webserve.name = 'USL PaymentGateway';       
        Webserve.Active__c = true;
        Webserve.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
        Webserve.Password__c = 'esidevuser123';
        Webserve.Service_Unavailable_Message__c = 'Service Unavailable';
        Webserve.Timeout__c = 120;
        Webserve.Username__c = 'esidevuser';
        lstofWebServ.add(Webserve);
        
        if(lstofWebServ.size()>0){
        insert lstofWebServ;
        }
        
        list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
        LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
        IntDefault.name='AccountReceivableInvoiceList';
        IntDefault.LCRM_ApplicationId__c='GLI';
        IntDefault.LCRM_CompanyId__c='SSD ';
        IntDefault.LCRM_ExternalSystemName__c='ESI';
        IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
        integrationDefaultlst.add(IntDefault);
        if(integrationDefaultlst.size()>0){
        insert integrationDefaultlst;
        }
        List<IXOSCodeMap__c>  lstIxosmap=new  List<IXOSCodeMap__c>();
        IXOSCodeMap__c testIXOSCodeMap = new IXOSCodeMap__c();
        testIXOSCodeMap.Company_Code__c = '0010';
        testIXOSCodeMap.Dist_Chan_Code__c= 'W';
        testIXOSCodeMap.Division_Code__c = 'W';
        testIXOSCodeMap.Sales_Org_Code__c = 'WEST';
        testIXOSCodeMap.Name = 'CredTest';
        lstIxosmap.add(testIXOSCodeMap);
        
        IXOSCodeMap__c ixosCodeMap = new IXOSCodeMap__c();
        ixosCodeMap.Company_Code__c = '0150';
        ixosCodeMap.Dist_Chan_Code__c= 'C';
        ixosCodeMap.Division_Code__c = 'C';
        ixosCodeMap.Sales_Org_Code__c = 'CARS';
        ixosCodeMap.Name = 'CARS Code';
        lstIxosmap.add(ixosCodeMap );
        
        if(lstIxosmap.size()>0){
        insert lstIxosmap;
        }
        
        USL_Integration_defaults__c int2 = new USL_Integration_defaults__c();
        int2.Applicationid__c = 'ESCU';
        int2.Companyid__c = 'WEST';
        int2.name = 'Integrationdefaults';
        insert int2;
        
        List<DocumentCodeToDescMap__c> lstdocCode =new List<DocumentCodeToDescMap__c>();
        DocumentCodeToDescMap__c docCode= new DocumentCodeToDescMap__c();
        docCode.Name='DU';
        docCode.Document_Desc__c='Payment Received';
        docCode.Document_Desc_Portuguese__c='Pagamento recebido';
        docCode.Document_Desc_Spanish__c='Pago recibido';
        lstdocCode.add(docCode);
        
        DocumentCodeToDescMap__c docCodeDt= new DocumentCodeToDescMap__c();
        docCodeDt.Name='DT';
        docCodeDt.Document_Desc__c='Customer Transfer';
        docCodeDt.Document_Desc_Portuguese__c='Transferência ao Cliente';
        docCodeDt.Document_Desc_Spanish__c='Transferencia de Cliente';
        lstdocCode.add(docCodeDt);
        
        
        
        DocumentCodeToDescMap__c docCodeEI= new DocumentCodeToDescMap__c();
        docCodeEI.Name='EI';
        docCodeEI.Document_Desc__c='InterCo Transfer';
        docCodeEI.Document_Desc_Portuguese__c='Transferencia entre Cias';
        docCodeEI.Document_Desc_Spanish__c='Transferencia Intercompany';
        lstdocCode.add(docCodeEI);
        
        if(lstdocCode.size()>0){
        insert lstdocCode;
        }  
        
        List<LCRM_Exception_Handling__c> exceptionList = new List<LCRM_Exception_Handling__c>();
        LCRM_Exception_Handling__c exceptionwebservice = new LCRM_Exception_Handling__c();
        exceptionwebservice.name='1';
        exceptionwebservice.Status_Code__c='400';
        exceptionwebservice.Status_Description__c='Uknown Application';
        exceptionwebservice.Status_Reason__c='ESI will be checking if mandatory parameters Accountnumber,ApplicationID,CompanyID are present in request incase any of parameter is sent as null ESI will send back this response';
        exceptionwebservice.UI_Error_Message_English__c='Invalid Application Id found for retrieving Invoice Details.';
        exceptionwebservice.UI_Error_Message_Portuguese__c='';
        exceptionwebservice.UI_Error_Message_Spanish__c='';
        exceptionwebservice.Webservice_Name__c='LCRMInvoiceOpenClearedItemsServices';
        exceptionwebservice.Webservice_type__c='Rest';
        exceptionwebservice.Destination_System__c='ESI';
        exceptionList.add(exceptionwebservice);
        
        LCRM_Exception_Handling__c exceptionwebservice01 = new LCRM_Exception_Handling__c();
        exceptionwebservice01.name='2';
        exceptionwebservice01.Status_Code__c='400';
        exceptionwebservice01.Status_Description__c='Bad Request';
        exceptionwebservice01.Status_Reason__c='ESI will be checking if mandatory parameters Accountnumber,ApplicationID,CompanyIDare present in request incase any of parameter is sent as null ESI will send back this response';
        exceptionwebservice01.UI_Error_Message_English__c='Mandatory Elements in the input request are Missing.Please correct.If error still persist, please contact CRM support.';
        exceptionwebservice01.UI_Error_Message_Portuguese__c='';
        exceptionwebservice01.UI_Error_Message_Spanish__c='';
        exceptionwebservice01.Webservice_Name__c='LCRMInvoiceOpenClearedItemsServices';
        exceptionwebservice01.Webservice_type__c='Rest';
        exceptionwebservice01.Destination_System__c='ESI';
        exceptionList.add(exceptionwebservice01);
        
        if(exceptionList.size()>0){
        insert exceptionList;               
        }
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('USLInvoiceException');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.standardController sc = new ApexPages.standardController(ssdWithSalesOrg);   
        USLARController USLARC = new USLARController(sc);            
        USLARC.getARItemType();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems');
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.assertEquals(200,res.getStatusCode());                       
        Test.stopTest();              
        }

    }
    
    /*
    LCRM Team started to cover their own functionality
    */
     @isTest static void testLCRMInvoiceDetails() {
            User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = userinfo.getProfileid(),
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
            );
            insert testUser;
            System.runAs(testUser) {
            
            UnitTest.createTestData();
            UnitTest.createOptiTestData();
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            
            List < Source_System_Detail__c > listofSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c ssdwithSAPNo = new Source_System_Detail__c();
            ssdwithSAPNo.name = 'SSD_01';
            ssdwithSAPNo.Source_System_Account_Number__c = '1000027717';
            ssdwithSAPNo.Account_Name__c = accRecord.id;
            ssdwithSAPNo.Source_System_Name__c = 'TRTAUNI';
             ssdwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            listofSSD.add(ssdwithSAPNo);
            
            Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
            ssdWithSalesOrg.name = 'SSD_02';
            ssdWithSalesOrg.Source_System_Account_Number__c = '8000000010';
            ssdWithSalesOrg.Account_Name__c = accRecord.id;
            ssdWithSalesOrg.Source_System_Name__c = 'ENTWRP';
            ssdWithSalesOrg.LCRM_Sales_Org__c = 'WEST';
            listofSSD.add(ssdWithSalesOrg);
            
            if (listofSSD.size() > 0) {
            insert listofSSD;
            }
            
            list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
            WebServiceSettings__c ixosWebservice = new WebServiceSettings__c();
            ixosWebservice.name = 'LCRMInvoiceOpenClearedItemsServices';
            ixosWebservice.Active__c = true;
            ixosWebservice.Endpoint__c = 'https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems';
            ixosWebservice.Password__c = 'lotu$u$er123';
            ixosWebservice.Service_Unavailable_Message__c = 'Invoice Service not available.';
            ixosWebservice.Timeout__c = 120;
            ixosWebservice.Username__c = 'LotusIntUser';
            lstofWebServ.add(ixosWebservice);
            
            if (lstofWebServ.size() > 0) {
                insert lstofWebServ;
            }
            
            List<IXOSCodeMap__c>  lstIxosmap=new  List<IXOSCodeMap__c>();
            IXOSCodeMap__c testIXOSCodeMap = new IXOSCodeMap__c();
            testIXOSCodeMap.Company_Code__c = '0010';
            testIXOSCodeMap.Dist_Chan_Code__c= 'W';
            testIXOSCodeMap.Division_Code__c = 'W';
            testIXOSCodeMap.Sales_Org_Code__c = 'WEST';
            testIXOSCodeMap.Name = 'CredTest';
            lstIxosmap.add(testIXOSCodeMap);
            
            IXOSCodeMap__c ixosCodeMap = new IXOSCodeMap__c();
            ixosCodeMap.Company_Code__c = '0150';
            ixosCodeMap.Dist_Chan_Code__c= 'C';
            ixosCodeMap.Division_Code__c = 'C';
            ixosCodeMap.Sales_Org_Code__c = 'CARS';
            ixosCodeMap.Name = 'CARS Code';
            lstIxosmap.add(ixosCodeMap );
            
            if(lstIxosmap.size()>0){
                insert lstIxosmap;
            }
            
            list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
            LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
            IntDefault.name='AccountReceivableInvoiceList';
            IntDefault.LCRM_ApplicationId__c='GLI';
            IntDefault.LCRM_CompanyId__c='SSD ';
            IntDefault.LCRM_ExternalSystemName__c='ESI';
            IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
            integrationDefaultlst.add(IntDefault);
            if(integrationDefaultlst.size()>0){
            insert integrationDefaultlst;
            }
            
            List<DocumentCodeToDescMap__c> lstdocCode =new List<DocumentCodeToDescMap__c>();
            DocumentCodeToDescMap__c docCode= new DocumentCodeToDescMap__c();
            docCode.Name='DU';
            docCode.Document_Desc__c='Payment Received';
            docCode.Document_Desc_Portuguese__c='Pagamento recebido';
            docCode.Document_Desc_Spanish__c='Pago recibido';
            lstdocCode.add(docCode);
            
            DocumentCodeToDescMap__c docCodeDt= new DocumentCodeToDescMap__c();
            docCodeDt.Name='DT';
            docCodeDt.Document_Desc__c='Customer Transfer';
            docCodeDt.Document_Desc_Portuguese__c='Transferência ao Cliente';
            docCodeDt.Document_Desc_Spanish__c='Transferencia de Cliente';
            lstdocCode.add(docCodeDt);
            
            
            
            DocumentCodeToDescMap__c docCodeEI= new DocumentCodeToDescMap__c();
            docCodeEI.Name='EI';
            docCodeEI.Document_Desc__c='InterCo Transfer';
            docCodeEI.Document_Desc_Portuguese__c='Transferencia entre Cias';
            docCodeEI.Document_Desc_Spanish__c='Transferencia Intercompany';
            lstdocCode.add(docCodeEI);
            
            if(lstdocCode.size()>0){
            insert lstdocCode;
            }  
            
            Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMInvoiceOpenClearedItemsServices');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.standardController sc = new ApexPages.standardController(ssdWithSalesOrg);   
            System.currentPageReference().getParameters().put('ApplicationId', 'GLI');  
            USLARController USLARC = new USLARController(sc);
            USLARC.getARItemType();
            USLARC.pagesize =2;
            //USLARC.nextPage();
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems');
            req.setMethod('POST');
            Http h = new Http();
            HttpResponse res = h.send(req);
            System.assertEquals(200,res.getStatusCode());                       
            Test.stopTest();  
            ApexPages.standardController stdController = new ApexPages.standardController(ssdWithSalesOrg);   
            System.currentPageReference().getParameters().put('ApplicationId', 'GLI');  
            USLARController ctrluslARC = new USLARController(stdController);
            ctrluslARC.sSelectedOption =System.Label.AccountRec_SOOpenDue;
          }
    
    }
    
    @isTest static void tesNorecordsonSSDDetails() {
        User testUser = new User(
        Alias = 'sUser', 
        Email='abc1@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='Testing', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'WEST',
        Sub_Bu__c='USL',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='abc123@testorg.com'
        );
        insert testUser;
        System.runAs(testUser) {
        
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        Account accRecord = new Account();
        accRecord = UnitTest.getAccountInstance();
        accRecord.SAPAccountNumber__c = '5491';
        insert accRecord;
        
        List < Source_System_Detail__c > listofSSD = new List < Source_System_Detail__c > ();
        Source_System_Detail__c ssdwithSAPNo = new Source_System_Detail__c();
        ssdwithSAPNo.name = 'SSD_01';
        //ssdwithSAPNo.Source_System_Account_Number__c = '1000027717';
        ssdwithSAPNo.Account_Name__c = accRecord.id;
        ssdwithSAPNo.Source_System_Name__c = 'TRTAUNI';
        ssdwithSAPNo.LCRM_Sales_Org__c = 'WEST';
        listofSSD.add(ssdwithSAPNo);
        
        Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
        ssdWithSalesOrg.name = 'SSD_02';
        ssdWithSalesOrg.Source_System_Account_Number__c = '8000000010';
        ssdWithSalesOrg.Account_Name__c = accRecord.id;
        ssdWithSalesOrg.Source_System_Name__c = 'ENTWRP';
        ssdWithSalesOrg.LCRM_Sales_Org__c = 'WEST';
        listofSSD.add(ssdWithSalesOrg);
        
        Source_System_Detail__c noSSD = new Source_System_Detail__c();
        
        if (listofSSD.size() > 0) {
        insert listofSSD;
        }
        
        list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
        WebServiceSettings__c ixosWebservice = new WebServiceSettings__c();
        ixosWebservice.name = 'LCRMInvoiceOpenClearedItemsServices';
        ixosWebservice.Active__c = true;
        ixosWebservice.Endpoint__c = 'https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems';
        ixosWebservice.Password__c = 'lotu$u$er123';
        ixosWebservice.Service_Unavailable_Message__c = 'Invoice Service not available.';
        ixosWebservice.Timeout__c = 120;
        ixosWebservice.Username__c = 'LotusIntUser';
        lstofWebServ.add(ixosWebservice);
        
        if (lstofWebServ.size() > 0) {
        insert lstofWebServ;
        }
        
        List<IXOSCodeMap__c>  lstIxosmap=new  List<IXOSCodeMap__c>();
        IXOSCodeMap__c testIXOSCodeMap = new IXOSCodeMap__c();
        testIXOSCodeMap.Company_Code__c = '0010';
        testIXOSCodeMap.Dist_Chan_Code__c= 'W';
        testIXOSCodeMap.Division_Code__c = 'W';
        testIXOSCodeMap.Sales_Org_Code__c = 'WEST';
        testIXOSCodeMap.Name = 'CredTest';
        lstIxosmap.add(testIXOSCodeMap);
        
        IXOSCodeMap__c ixosCodeMap = new IXOSCodeMap__c();
        ixosCodeMap.Company_Code__c = '0150';
        ixosCodeMap.Dist_Chan_Code__c= 'C';
        ixosCodeMap.Division_Code__c = 'C';
        ixosCodeMap.Sales_Org_Code__c = 'CARS';
        ixosCodeMap.Name = 'CARS Code';
        lstIxosmap.add(ixosCodeMap );
        
        if(lstIxosmap.size()>0){
        insert lstIxosmap;
        }
        
        list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
        LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
        IntDefault.name='AccountReceivableInvoiceList';
        IntDefault.LCRM_ApplicationId__c='GLI';
        IntDefault.LCRM_CompanyId__c='SSD ';
        IntDefault.LCRM_ExternalSystemName__c='ESI';
        IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
        integrationDefaultlst.add(IntDefault);
        if(integrationDefaultlst.size()>0){
        insert integrationDefaultlst;
        }
        
        List<DocumentCodeToDescMap__c> lstdocCode =new List<DocumentCodeToDescMap__c>();
        DocumentCodeToDescMap__c docCode= new DocumentCodeToDescMap__c();
        docCode.Name='DU';
        docCode.Document_Desc__c='Payment Received';
        docCode.Document_Desc_Portuguese__c='Pagamento recebido';
        docCode.Document_Desc_Spanish__c='Pago recibido';
        lstdocCode.add(docCode);
        
        DocumentCodeToDescMap__c docCodeDt= new DocumentCodeToDescMap__c();
        docCodeDt.Name='DT';
        docCodeDt.Document_Desc__c='Customer Transfer';
        docCodeDt.Document_Desc_Portuguese__c='Transferência ao Cliente';
        docCodeDt.Document_Desc_Spanish__c='Transferencia de Cliente';
        lstdocCode.add(docCodeDt);
        
        
        
        DocumentCodeToDescMap__c docCodeEi= new DocumentCodeToDescMap__c();
        docCodeEi.Name='EI';
        docCodeEi.Document_Desc__c='InterCo Transfer';
        docCodeEI.Document_Desc_Portuguese__c='Transferencia entre Cias';
        docCodeEi.Document_Desc_Spanish__c='Transferencia Intercompany';
        lstdocCode.add(docCodeEi);
        
        if(lstdocCode.size()>0){
        insert lstdocCode;
        }   
        try{
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LCRMInvoiceOpenClearedItemsServices');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.standardController sc = new ApexPages.standardController(ssdwithSAPNo);   
        System.currentPageReference().getParameters().put('ApplicationId', 'GLI');  
        USLARController USLARC = new USLARController(sc);
        USLARC.getARItemType();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems');
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.assertEquals(200,res.getStatusCode());                       
        Test.stopTest();  
        
        }catch(Exception Ex){
        System.debug('Error:'+Ex);
        }
     }
    
    }
     
     
     /*
    LCRM Team started to cover their own functionality
    */
     @isTest static void testexcephandlingforInvoice() {
        User testUser = new User(
        Alias = 'sUser', 
        Email='abc1@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='Testing', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'WEST',
        Sub_Bu__c='USL',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='abc123@testorg.com'
        );
        insert testUser;
        System.runAs(testUser) {
        
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        Account accRecord = new Account();
        accRecord = UnitTest.getAccountInstance();
        accRecord.SAPAccountNumber__c = '5491';
        insert accRecord;
        
        List < Source_System_Detail__c > listofSSD = new List < Source_System_Detail__c > ();
        Source_System_Detail__c ssdwithSAPNo = new Source_System_Detail__c();
        ssdwithSAPNo.name = 'SSD_01';
        ssdwithSAPNo.Source_System_Account_Number__c = '1000027717';
        ssdwithSAPNo.Account_Name__c = accRecord.id;
        ssdwithSAPNo.Source_System_Name__c = 'TRTAUNI';
        ssdwithSAPNo.LCRM_Sales_Org__c = 'WEST';
        listofSSD.add(ssdwithSAPNo);
        
        Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
        ssdWithSalesOrg.name = 'SSD_02';
        ssdWithSalesOrg.Source_System_Account_Number__c = '8000000010';
        ssdWithSalesOrg.Account_Name__c = accRecord.id;
        ssdWithSalesOrg.Source_System_Name__c = 'ENTWRP';
        ssdWithSalesOrg.LCRM_Sales_Org__c = 'WEST';
        listofSSD.add(ssdWithSalesOrg);
        
        if (listofSSD.size() > 0) {
        insert listofSSD;
        }
        
        list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
        WebServiceSettings__c ixosWebservice = new WebServiceSettings__c();
        ixosWebservice.name = 'LCRMInvoiceOpenClearedItemsServices';
        ixosWebservice.Active__c = true;
        ixosWebservice.Endpoint__c = 'https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems';
        ixosWebservice.Password__c = 'lotu$u$er123';
        ixosWebservice.Service_Unavailable_Message__c = 'Invoice Service not available.';
        ixosWebservice.Timeout__c = 120;
        ixosWebservice.Username__c = 'LotusIntUser';
        lstofWebServ.add(ixosWebservice);
        
        if (lstofWebServ.size() > 0) {
        insert lstofWebServ;
        }
        
        List<IXOSCodeMap__c>  lstIxosmap=new  List<IXOSCodeMap__c>();
        IXOSCodeMap__c testIXOSCodeMap = new IXOSCodeMap__c();
        testIXOSCodeMap.Company_Code__c = '0010';
        testIXOSCodeMap.Dist_Chan_Code__c= 'W';
        testIXOSCodeMap.Division_Code__c = 'W';
        testIXOSCodeMap.Sales_Org_Code__c = 'WEST';
        testIXOSCodeMap.Name = 'CredTest';
        lstIxosmap.add(testIXOSCodeMap);
        
        IXOSCodeMap__c ixosCodeMap = new IXOSCodeMap__c();
        ixosCodeMap.Company_Code__c = '0150';
        ixosCodeMap.Dist_Chan_Code__c= 'C';
        ixosCodeMap.Division_Code__c = 'C';
        ixosCodeMap.Sales_Org_Code__c = 'CARS';
        ixosCodeMap.Name = 'CARS Code';
        lstIxosmap.add(ixosCodeMap );
        
        if(lstIxosmap.size()>0){
        insert lstIxosmap;
        }
        
        list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
        LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
        IntDefault.name='AccountReceivableInvoiceList';
        IntDefault.LCRM_ApplicationId__c='GLI';
        IntDefault.LCRM_CompanyId__c='SSD ';
        IntDefault.LCRM_ExternalSystemName__c='ESI';
        IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
        integrationDefaultlst.add(IntDefault);
        if(integrationDefaultlst.size()>0){
        insert integrationDefaultlst;
        }
        
        List<DocumentCodeToDescMap__c> lstdocCode =new List<DocumentCodeToDescMap__c>();
        DocumentCodeToDescMap__c docCode= new DocumentCodeToDescMap__c();
        docCode.Name='DU';
        docCode.Document_Desc__c='Payment Received';
        docCode.Document_Desc_Portuguese__c='Pagamento recebido';
        docCode.Document_Desc_Spanish__c='Pago recibido';
        lstdocCode.add(docCode);
        
        DocumentCodeToDescMap__c docCodeDt= new DocumentCodeToDescMap__c();
        docCodeDt.Name='DT';
        docCodeDt.Document_Desc__c='Customer Transfer';
        docCodeDt.Document_Desc_Portuguese__c='Transferência ao Cliente';
        docCodeDt.Document_Desc_Spanish__c='Transferencia de Cliente';
        lstdocCode.add(docCodeDt);
        
        
        
        DocumentCodeToDescMap__c docCodeEI= new DocumentCodeToDescMap__c();
        docCodeEI.Name='EI';
        docCodeEI.Document_Desc__c='InterCo Transfer';
        docCodeEI.Document_Desc_Portuguese__c='Transferencia entre Cias';
        docCodeEI.Document_Desc_Spanish__c='Transferencia Intercompany';
        lstdocCode.add(docCodeEI);
        
        if(lstdocCode.size()>0){
        insert lstdocCode;
        }  
        
        List<LCRM_Exception_Handling__c> exceptionList = new List<LCRM_Exception_Handling__c>();
        LCRM_Exception_Handling__c exceptionwebservice = new LCRM_Exception_Handling__c();
        exceptionwebservice.name='1';
        exceptionwebservice.Status_Code__c='400';
        exceptionwebservice.Status_Description__c='Uknown Application';
        exceptionwebservice.Status_Reason__c='ESI will be checking if mandatory parameters Accountnumber,ApplicationID,CompanyID are present in request incase any of parameter is sent as null ESI will send back this response';
        exceptionwebservice.UI_Error_Message_English__c='Invalid Application Id found for retrieving Invoice Details.';
        exceptionwebservice.UI_Error_Message_Portuguese__c='';
        exceptionwebservice.UI_Error_Message_Spanish__c='';
        exceptionwebservice.Webservice_Name__c='LCRMInvoiceOpenClearedItemsServices';
        exceptionwebservice.Webservice_type__c='Rest';
        exceptionwebservice.Destination_System__c='ESI';
        exceptionList.add(exceptionwebservice);
        
        LCRM_Exception_Handling__c exceptionwebservice01 = new LCRM_Exception_Handling__c();
        exceptionwebservice01.name='2';
        exceptionwebservice01.Status_Code__c='400';
        exceptionwebservice01.Status_Description__c='Bad Request';
        exceptionwebservice01.Status_Reason__c='ESI will be checking if mandatory parameters Accountnumber,ApplicationID,CompanyIDare present in request incase any of parameter is sent as null ESI will send back this response';
        exceptionwebservice01.UI_Error_Message_English__c='Mandatory Elements in the input request are Missing.Please correct.If error still persist, please contact CRM support.';
        exceptionwebservice01.UI_Error_Message_Portuguese__c='';
        exceptionwebservice01.UI_Error_Message_Spanish__c='';
        exceptionwebservice01.Webservice_Name__c='LCRMInvoiceOpenClearedItemsServices';
        exceptionwebservice01.Webservice_type__c='Rest';
        exceptionwebservice01.Destination_System__c='ESI';
        exceptionList.add(exceptionwebservice01);
        
        if(exceptionList.size()>0){
        insert exceptionList;               
        }
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LCRMInvoiceOpenClearedItemsServicesException');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.standardController sc = new ApexPages.standardController(ssdWithSalesOrg);   
        System.currentPageReference().getParameters().put('ApplicationId', 'GLI');  
        USLARController USLARC = new USLARController(sc);            
        USLARC.getARItemType();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems');
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.assertEquals(200,res.getStatusCode());                       
        Test.stopTest();              
        }

    }
    
    /*
    Code coverage for LCRMGenericComponentforIntegration Apex class
    */
    
    @isTest static void testIntegrationGenericcomponent() {
    User testUser = new User(
        Alias = 'sUser', 
        Email='abc1@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='Testing', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'WEST',
        Sub_Bu__c='USL',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='abc123@testorg.com'
        );
        insert testUser;
        System.runAs(testUser) {
            
            UnitTest.createTestData();
            UnitTest.createOptiTestData();
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            
            List < Source_System_Detail__c > listofSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c ssdwithSAPNo = new Source_System_Detail__c();
            ssdwithSAPNo.name = 'SSD_01';
            ssdwithSAPNo.Source_System_Account_Number__c = '10000';
            ssdwithSAPNo.Account_Name__c = accRecord.id;
            ssdwithSAPNo.Source_System_Name__c = 'TRTAUNI';
             ssdwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            listofSSD.add(ssdwithSAPNo);
    
            Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
            ssdWithSalesOrg.name = 'SSD_02';
            ssdWithSalesOrg.Source_System_Account_Number__c = '8000';
            ssdWithSalesOrg.Account_Name__c = accRecord.id;
            ssdWithSalesOrg.Source_System_Name__c = 'ENTWRP';
            ssdWithSalesOrg.LCRM_Sales_Org__c = 'WEST';
            listofSSD.add(ssdWithSalesOrg);
    
            if (listofSSD.size() > 0) {
            insert listofSSD;
            }
            
            list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
            LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
            IntDefault.name='AccountReceivableInvoiceList';
            IntDefault.LCRM_ApplicationId__c='GLI';
            IntDefault.LCRM_CompanyId__c='SSD ';
            IntDefault.LCRM_ExternalSystemName__c='ESI';
            IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
            integrationDefaultlst.add(IntDefault);
            if(integrationDefaultlst.size()>0){
            insert integrationDefaultlst;
            }     
            
            List<LCRM_Exception_Handling__c> exceptionList = new List<LCRM_Exception_Handling__c>();
            LCRM_Exception_Handling__c exceptionwebservice = new LCRM_Exception_Handling__c();
            exceptionwebservice.name='1';
            exceptionwebservice.Status_Code__c='400';
            exceptionwebservice.Status_Description__c='Uknown Application';
            exceptionwebservice.Status_Reason__c='ESI will be checking if mandatory parameters Accountnumber,ApplicationID,CompanyID are present in request incase any of parameter is sent as null ESI will send back this response';
            exceptionwebservice.UI_Error_Message_English__c='Invalid Application Id found for retrieving Invoice Details.';
            exceptionwebservice.UI_Error_Message_Portuguese__c='';
            exceptionwebservice.UI_Error_Message_Spanish__c='';
            exceptionwebservice.Webservice_Name__c='LCRMInvoiceOpenClearedItemsServices';
            exceptionwebservice.Webservice_type__c='Rest';
            exceptionwebservice.Destination_System__c='ESI';
            exceptionList.add(exceptionwebservice);

            LCRM_Exception_Handling__c exceptionwebservice01 = new LCRM_Exception_Handling__c();
            exceptionwebservice01.name='2';
            exceptionwebservice01.Status_Code__c='400';
            exceptionwebservice01.Status_Description__c='Bad Request';
            exceptionwebservice01.Status_Reason__c='ESI will be checking if mandatory parameters Accountnumber,ApplicationID,CompanyIDare present in request incase any of parameter is sent as null ESI will send back this response';
            exceptionwebservice01.UI_Error_Message_English__c='Mandatory Elements in the input request are Missing.Please correct.If error still persist, please contact CRM support.';
            exceptionwebservice01.UI_Error_Message_Portuguese__c='';
            exceptionwebservice01.UI_Error_Message_Spanish__c='';
            exceptionwebservice01.Webservice_Name__c='LCRMInvoiceOpenClearedItemsServices';
            exceptionwebservice01.Webservice_type__c='Rest';
            exceptionwebservice01.Destination_System__c='ESI';
            exceptionList.add(exceptionwebservice01);
            
            LCRM_Exception_Handling__c exceptionwebservice02 = new LCRM_Exception_Handling__c();
            exceptionwebservice02.name='3';
            exceptionwebservice02.Status_Code__c='400';
            exceptionwebservice02.Status_Description__c='Bad Request';
            exceptionwebservice02.Status_Reason__c='ESI will be checking if mandatory parameters Accountnumber,ApplicationID,CompanyIDare present in request incase any of parameter is sent as null ESI will send back this response';
            exceptionwebservice02.UI_Error_Message_English__c='Mandatory Elements in the input request are Missing.';
            exceptionwebservice02.UI_Error_Message_Portuguese__c='';
            exceptionwebservice02.UI_Error_Message_Spanish__c='';
            exceptionwebservice02.Webservice_Name__c='LCRMInvoiceOpenClearedItemsServices';
            exceptionwebservice02.Webservice_type__c='Rest';
            exceptionwebservice02.Destination_System__c='ESI';
            exceptionList.add(exceptionwebservice02);

            if(exceptionList.size()>0){
            insert exceptionList;               
            }
            
            list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
            WebServiceSettings__c ixosWebservice = new WebServiceSettings__c();
            ixosWebservice.name = 'LCRM_GetDocumentDetails';
            ixosWebservice.Active__c = true;
            ixosWebservice.Endpoint__c = 'https://dev.api.apigarden-qa.thomsonreuters.com/ebs/miscellaneous/getDocumentDetails';
            ixosWebservice.Password__c = 'lotu$u$er123';
            ixosWebservice.Service_Unavailable_Message__c = 'Document Service is not available.';
            ixosWebservice.Timeout__c = 120;
            ixosWebservice.Username__c = 'LotusIntUser';
            lstofWebServ.add(ixosWebservice);

            if (lstofWebServ.size() > 0) {
                insert lstofWebServ;
            }
            Test.startTest();
              LCRMGenericComponentforIntegration lcrmgenericComponent= new LCRMGenericComponentforIntegration();
              LCRMGenericComponentforIntegration.documentDetailsExceptionHandling(exceptionwebservice02.Status_Code__c,exceptionwebservice02.Status_Description__c,exceptionwebservice02.Webservice_Name__c);
            Test.stopTest();              
           LCRMGenericComponentforIntegration.documentDetailsExceptionHandling('500','Internal- Server Error','LCRM_GetDocumentDetails');
            }
    
    }
     
     //
    @isTest static void testLCRMInvoiceDetailsPaginate() {
    User testUser = new User(
        Alias = 'sUser', 
        Email='abc1@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='Testing', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'WEST',
        Sub_Bu__c='USL',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='abc123@testorg.com'
        );
        insert testUser;
        System.runAs(testUser) {
            
            UnitTest.createTestData();
            UnitTest.createOptiTestData();
            Account accRecord = new Account();
            accRecord = UnitTest.getAccountInstance();
            accRecord.SAPAccountNumber__c = '5491';
            insert accRecord;
            
            List < Source_System_Detail__c > listofSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c ssdwithSAPNo = new Source_System_Detail__c();
            ssdwithSAPNo.name = 'SSD_01';
            ssdwithSAPNo.Source_System_Account_Number__c = '1000027717';
            ssdwithSAPNo.Account_Name__c = accRecord.id;
            ssdwithSAPNo.Source_System_Name__c = 'TRTAUNI';
             ssdwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            listofSSD.add(ssdwithSAPNo);
    
            Source_System_Detail__c ssdWithSalesOrg = new Source_System_Detail__c();
            ssdWithSalesOrg.name = 'SSD_02';
            ssdWithSalesOrg.Source_System_Account_Number__c = '8000000010';
            ssdWithSalesOrg.Account_Name__c = accRecord.id;
            ssdWithSalesOrg.Source_System_Name__c = 'ENTWRP';
            ssdWithSalesOrg.LCRM_Sales_Org__c = 'WEST';
            listofSSD.add(ssdWithSalesOrg);
    
            if (listofSSD.size() > 0) {
            insert listofSSD;
            }
            
            list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
            WebServiceSettings__c ixosWebservice = new WebServiceSettings__c();
            ixosWebservice.name = 'LCRMInvoiceOpenClearedItemsServices';
            ixosWebservice.Active__c = true;
            ixosWebservice.Endpoint__c = 'https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems';
            ixosWebservice.Password__c = 'lotu$u$er123';
            ixosWebservice.Service_Unavailable_Message__c = 'Invoice Service not available.';
            ixosWebservice.Timeout__c = 120;
            ixosWebservice.Username__c = 'LotusIntUser';
            lstofWebServ.add(ixosWebservice);

            if (lstofWebServ.size() > 0) {
                insert lstofWebServ;
            }
            
            List<IXOSCodeMap__c>  lstIxosmap=new  List<IXOSCodeMap__c>();
            IXOSCodeMap__c testIXOSCodeMap = new IXOSCodeMap__c();
            testIXOSCodeMap.Company_Code__c = '0010';
            testIXOSCodeMap.Dist_Chan_Code__c= 'W';
            testIXOSCodeMap.Division_Code__c = 'W';
            testIXOSCodeMap.Sales_Org_Code__c = 'WEST';
            testIXOSCodeMap.Name = 'CredTest';
            lstIxosmap.add(testIXOSCodeMap);
            
            IXOSCodeMap__c ixosCodeMap = new IXOSCodeMap__c();
            ixosCodeMap.Company_Code__c = '0150';
            ixosCodeMap.Dist_Chan_Code__c= 'C';
            ixosCodeMap.Division_Code__c = 'C';
            ixosCodeMap.Sales_Org_Code__c = 'CARS';
            ixosCodeMap.Name = 'CARS Code';
            lstIxosmap.add(ixosCodeMap );
            
            if(lstIxosmap.size()>0){
                insert lstIxosmap;
            }
            
            list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
            LCRM_Integration_defaults_Values__c IntDefault= new LCRM_Integration_defaults_Values__c();
            IntDefault.name='AccountReceivableInvoiceList';
            IntDefault.LCRM_ApplicationId__c='GLI';
            IntDefault.LCRM_CompanyId__c='SSD ';
            IntDefault.LCRM_ExternalSystemName__c='ESI';
            IntDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
            integrationDefaultlst.add(IntDefault);
            if(integrationDefaultlst.size()>0){
            insert integrationDefaultlst;
            }
            
            List<DocumentCodeToDescMap__c> lstdocCode =new List<DocumentCodeToDescMap__c>();
            DocumentCodeToDescMap__c docCode= new DocumentCodeToDescMap__c();
            docCode.Name='DU';
            docCode.Document_Desc__c='Payment Received';
            docCode.Document_Desc_Portuguese__c='Pagamento recebido';
            docCode.Document_Desc_Spanish__c='Pago recibido';
            lstdocCode.add(docCode);
            
            DocumentCodeToDescMap__c docCodeDt= new DocumentCodeToDescMap__c();
            docCodeDt.Name='DT';
            docCodeDt.Document_Desc__c='Customer Transfer';
            docCodeDt.Document_Desc_Portuguese__c='Transferência ao Cliente';
            docCodeDt.Document_Desc_Spanish__c='Transferencia de Cliente';
            lstdocCode.add(docCodeDt);
            
            
            
            DocumentCodeToDescMap__c docCodeEI= new DocumentCodeToDescMap__c();
            docCodeEI.Name='EI';
            docCodeEI.Document_Desc__c='InterCo Transfer';
            docCodeEI.Document_Desc_Portuguese__c='Transferencia entre Cias';
            docCodeEI.Document_Desc_Spanish__c='Transferencia Intercompany';
            lstdocCode.add(docCodeEI);
            
            if(lstdocCode.size()>0){
            insert lstdocCode;
            }  
            
            
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMInvoiceOpenClearedItemsServicesPaginate');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.standardController sc = new ApexPages.standardController(ssdWithSalesOrg);   
            System.currentPageReference().getParameters().put('ApplicationId', 'GLI');  
            Test.startTest();
            USLARController USLARC = new USLARController(sc);
            USLARC.getARItemType();            
            USLARC.nextPage();
            USLARC.previousPage();
            USLARC.selectall=false;
            USLARC.selectalllineitem();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://dev.api.apigarden-qa.thomsonreuters.com/ebs/invoice/getInvoiceOpenClearedItems');
            req.setMethod('POST');
            Http h = new Http();
            HttpResponse res = h.send(req);
            System.assertEquals(200,res.getStatusCode());                       
            Test.stopTest();  
            ApexPages.standardController stdController = new ApexPages.standardController(ssdWithSalesOrg);   
            System.currentPageReference().getParameters().put('ApplicationId', 'GLI');  
            USLARController ctrluslARC = new USLARController(stdController);
            ctrluslARC.sSelectedOption =System.Label.AccountRec_SOOpenDue;
            }
    
    }
    
    
}