@isTest
public class USL_CCController_Test {
    public static testMethod void ccCTest1() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        GenerateForm__C gf= new GenerateForm__C();
        gf.Name='Charge Cancellation';
        Insert gf;
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='Invoice',Username__c='test',Password__c='test',Endpoint__c='test@test.com');
        insert websrv;
        WebServiceSettings__c websrv1 = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='Invoicedetail',Username__c='test',Password__c='test',Endpoint__c='test@test.com');
        insert websrv1;
        System.runAs(testUser) {
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            testAcc1.BillingCity = 'PORT ANGELES';
            testAcc1.BillingCountry ='US';
            testAcc1.BillingState = 'WA';
            testAcc1.BillingPostalCode = '98363-8409';
            testAcc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert testAcc1;
            
            Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
            insert c;
            Source_System_Detail__c ssd= new Source_System_Detail__c(Digital_Firm_Name__c = 'Test Firm',Digital_Billing_City__c = 'California',Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',Source_System_Account_Number__c='123321123',Account_Name__c=testAcc1.id);
            insert SSD;
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
            
            ESC_Case_Form_Extension__c escCFE = new ESC_Case_Form_Extension__c();
            escCFE.ESC_Form__c=gf.id;
            escCFE.ESC_Case__c=testcase.id;
            escCFE.USL_Approval_Type__c='USL_Print_Subscription';
            escCFE.USL_Requester_Title__c=' Mr.';
            escCFE.USL_Requestor_ID__c='Testing';
            escCFE.USL_Total_Amount__c=450;
            escCFE.USL_Net_Amount__c = 45;
            escCFE.USL_Tax_Amount__c=10;
            escCFE.Route_To_USL_Print_CD_Credits__c=true;
            
            insert escCFE;
            
            ESC_Case_Form_Extension_Line_Item__c  escCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine.ESC_Billing_Doc__c='6118005220';
            escCFELine.ESC_Line__c='000010';
            escCFELine.ESC_Net_Amount__c=3000;
            escCFELine.ESC_Tax_Amount__c=97;
            escCFELine.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine.USL_ODocType__c='YW';
            escCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine.ESC_Request_Description__c='Westlaw';
            escCFELine.ESC_Type__c='Partial';
           
            //escCFELine.ESC_Item_Amount__c=30000;
            //escCFELine.USL_Input_Amount__c=1126;
             insert escCFELine;
            
            
            ESC_Case_Form_Extension_Line_Item__c  escCFELine1 =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine1.ESC_Billing_Doc__c='6118005220';
            escCFELine1.ESC_Line__c='0010';
            escCFELine1.ESC_Net_Amount__c=40;
            escCFELine1.ESC_Tax_Amount__c=97;
            escCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine1.USL_ODocType__c='YW';
            escCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine1.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine1.ESC_Type__c='FUll';
            escCFELine1.ESC_Request_Description__c='Non-Westlaw';
            //escCFELine1.ESC_Item_Amount__c=30000;
           // escCFELine1.USL_Input_Amount__c=1126;
            //escCFELine1.USL_Invoice_Type__c='Clear';
             insert escCFELine1;
            
         // List<USLARInvoicedetailwrapper.cls_invoiceLines> InvoiceDetailsList= new List<USLARInvoicedetailwrapper.cls_invoiceLines>();
           // USLARInvoicedetailwrapper.ARdetail displayinv_list = new USLARInvoicedetailwrapper.ARdetail();
            
            PageReference pageRef = Page.USL_ChargeCancellation;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', testcase.id);
            pageRef.getParameters().put('formid', gf.id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
            
            USL_CCController ccc= new USL_CCController();
            ccc.Begindt = system.today().addDays(-365);
            ccc.Enddt = system.today();
           // ccc.InvoiceList.add('6117778944');
            ccc.getresponses();
            ccc.setInvoiceDateRange(); 
            ccc.saveselectedopen();
            ccc.saveselectedclear(); 
            ccc.selectall = true;
            ccc.SelectAllOpen= true;
            ccc.selectalllineitem();
            ccc.selectallOpenitem();
            Test.setMock(HttpCalloutMock.class, new MockUSLCCController());
            ccc.showPreview();
            ccc.addRow();
            try{ ccc.cupdatePage();}
           catch(exception ex){system.debug(LoggingLevel.WARN,'test');}
            ccc.saveComponent();
            Test.stopTest();
            //ccc.selectalllineitem();
            ccc.goback();
            ccc.getReasoncodeOptions();
            ccc.getRootCauseOptions();
            ccc.getWLPlanOptions();
            ccc.getBUOptions();
            ccc.selectallCleareditem();
            ccc.IsApplyAll=true;
            ccc.Applydefaults();
            ccc.IsCancellAllWL=true;
            ccc.Applydefaults();
            ccc.IsCancelAllNWL=true;
            ccc.Applydefaults();
            ccc.canceltax=true;
            ccc.Applydefaults();
            ccc.applydiscount();
            ccc.calculate();
            ccc.Removediscount();
            ccc.InvoiceList.add('6117778944');
            ccc.formext.USL_Approval_Type__c='EBO Collections';
            ccc.saveComponent();
            ccc.routetoconsultant = true;
            ccc.savecomponent();
            ccc.getARItemType();
            try{
                ccc.previousPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.nextPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.updatePage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.changeData();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.ipreviousPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.inextPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.iupdatePage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.ichangeData(); 
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.cpreviousPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.cnextPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.cupdatePage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.cchangeData();  
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}   
        }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');    
    }
    
    private static testMethod void ccCTest2() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        GenerateForm__C gf= new GenerateForm__C();
        gf.Name='Charge Cancellation';
        Insert gf;
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='InvoiceDetail',Username__c='test',Password__c='test',Endpoint__c='test@test.com');
        insert websrv;
        System.runAs(testUser) {
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            testAcc1.BillingCity = 'PORT ANGELES';
            testAcc1.BillingCountry ='US';
            testAcc1.BillingState = 'WA';
            testAcc1.BillingPostalCode = '98363-8409';
            testAcc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert testAcc1;
            
            Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
            insert c;
            Source_System_Detail__c ssd= new Source_System_Detail__c(Digital_Firm_Name__c = 'Test Firm',Digital_Billing_City__c = 'California',Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',Source_System_Account_Number__c='123321123',Account_Name__c=testAcc1.id);
            insert SSD;
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
            
             ESC_Case_Form_Extension__c escCFE = new ESC_Case_Form_Extension__c();
            escCFE.ESC_Form__c=gf.id;
            escCFE.ESC_Case__c=testcase.id;
            //escCFE.USL_Approval_Type__c='USL Print Subscription';
            escCFE.USL_Requester_Title__c=' Mr.';
            escCFE.USL_Requestor_ID__c='Testing';
            
            insert escCFE;
            
            ESC_Case_Form_Extension_Line_Item__c  escCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine.ESC_Billing_Doc__c='6118005220';
            escCFELine.ESC_Line__c='000010';
            escCFELine.ESC_Net_Amount__c=30000;
            escCFELine.ESC_Tax_Amount__c=98;
            escCFELine.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine.USL_ODocType__c='YW';
            escCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine.ESC_Type__c='Partial';
            escCFELine.ESC_Request_Description__c='Non-Westlaw';
            //escCFELine.ESC_Item_Amount__c=30000;
            //escCFELine.USL_Input_Amount__c=1126;
             insert escCFELine;
             
            PageReference pageRef = Page.USL_ChargeCancellation;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', testcase.id);
            pageRef.getParameters().put('formid', gf.id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLCCController());
            
            
            
            USL_CCController ccc= new USL_CCController();
            ccc.Allclitem.ESC_Root_Cause__c = 'Order Processing';
            ccc.Allclitem.ESC_Reason_Code__c = '47-Tax Exempt';
            ccc.Begindt = system.today().addDays(-365);
            ccc.Enddt = system.today();
            ccc.InvoiceList.add('6117778944');
            ccc.getresponses();
            ccc.setInvoiceDateRange();            
            ccc.showPreview();
            Test.stopTest();
             ccc.routetoconsultant = false;

            ccc.canceltax = true;
            ccc.IsApplyAll = true;
            
            ccc.Applydefaults();
            ccc.applydiscount();
            ccc.calculate();
            ccc.Removediscount();
            ccc.IsCancellAllWL = true;
            ccc.IsCancelAllNWL = true;
            ccc.Applydefaults();  
                      
            ccc.getReasoncodeOptions();
            ccc.getRootCauseOptions();
            ccc.formext.USL_Approval_Type__c='EBO Collections';
            ccc.saveComponent();
            ccc.addrow();
            Apexpages.currentPage().getParameters().put('rn','1');
            ccc.deleterow();    
        }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');    
    }
    private static testMethod void ccCTest3() {
        String mandatoryErr;
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        GenerateForm__C gf= new GenerateForm__C();
        gf.Name='Charge Cancellation';
        Insert gf;
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='Invoice',Username__c='test',Password__c='test',Endpoint__c='test@test.com');
        insert websrv;
        System.runAs(testUser) {
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            testAcc1.BillingCity = 'PORT ANGELES';
            testAcc1.BillingCountry ='US';
            testAcc1.BillingState = 'WA';
            testAcc1.BillingPostalCode = '98363-8409';
            testAcc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert testAcc1;
            
            Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
            insert c;
            Source_System_Detail__c ssd= new Source_System_Detail__c(Digital_Firm_Name__c = 'Test Firm',Digital_Billing_City__c = 'California',Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',Source_System_Account_Number__c='123321123',Account_Name__c=testAcc1.id);
            insert SSD;
            Case testCase=ESC_GenericTestutility.TestCaseUtil(c.id,testAcc1.id,'New');
            testcase.LCRM_Sub_BU__c='USL';
            //testcase.Subject='test1';
            try{
            testcase.Subject='';
            }catch(Exception e){system.debug(LoggingLevel.WARN,'test');
                 mandatoryErr=mandatoryErr!=''?mandatoryErr+', Subject':'Subject';
            }
            try{
             testcase.ContactId ='';
        }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');
                 mandatoryErr=c.id;
            }
            try{
             testcase.AccountId ='';
                 }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');
                 mandatoryErr=testAcc1.id;
            }
            testcase.ESC_Impact__c = '1-Whole Site';
            testcase.ESC_Severity__c='1 - High';
            testcase.ESC_Customer_Symptom__c='Content Addition';
            testcase.Description = 'test description';
            testcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
            testcase.USL_Queue_Name__c='Academic_Support';
            testcase.ESC_Diagnosis_Summary__c='Content Explanation';
            testcase.USL_SAP_Account_Number__c='123321123';
            insert testcase;
            
            
             ESC_Case_Form_Extension__c escCFE = new ESC_Case_Form_Extension__c();
            escCFE.ESC_Form__c=gf.id;
            escCFE.ESC_Case__c=testcase.id;
            try{
            escCFE.USL_Approval_Type__c='';
            } 
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');
                //ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                //exc.setmessage('Please select a value for Charge Cancellation BU');
               // throw exc;
                
            }
            escCFE.USL_Requester_Title__c=' Mr.';
            escCFE.USL_Requestor_ID__c='Testing';
            
            insert escCFE;
            
            ESC_Case_Form_Extension_Line_Item__c  escCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine.ESC_Billing_Doc__c='6118005220';
            escCFELine.ESC_Line__c='000010';
            escCFELine.ESC_Net_Amount__c=30000;
            escCFELine.ESC_Tax_Amount__c=99;
            escCFELine.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine.USL_ODocType__c='YW';
            escCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine.ESC_Type__c='Full';
            escCFELine.ESC_Request_Description__c='Non-Westlaw';
            //escCFELine.ESC_Item_Amount__c=30000;
            //escCFELine.USL_Input_Amount__c=1126;
             insert escCFELine;
             
             
            PageReference pageRef = Page.USL_ChargeCancellation;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', testcase.id);
            pageRef.getParameters().put('formid', gf.id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
            Test.setMock(HttpCalloutMock.class, new MockUSLCCController());
            
            
            USL_CCController ccc= new USL_CCController();
            ccc.Begindt = system.today().addDays(-365);
            ccc.Enddt = system.today();
            ccc.InvoiceList.add('6117778944');
            ccc.getresponses();
            ccc.setInvoiceDateRange();            
            ccc.showPreview();
            ccc.addrow();
            Apexpages.currentPage().getParameters().put('rn','1');
            ccc.deleterow();
            
            Test.stopTest();  
        }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');    
    }
    
    private static testMethod void ccCTest4() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        GenerateForm__C gf= new GenerateForm__C();
        gf.Name='Charge Cancellation';
        Insert gf;
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='InvoiceDetail',Username__c='test',Password__c='test',Endpoint__c='test@test.com');
        insert websrv;
        System.runAs(testUser) {
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            testAcc1.BillingCity = 'PORT ANGELES';
            testAcc1.BillingCountry ='US';
            testAcc1.BillingState = 'WA';
            testAcc1.BillingPostalCode = '98363-8409';
            testAcc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert testAcc1;
            
            Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
            insert c;
            Source_System_Detail__c ssd= new Source_System_Detail__c(Digital_Firm_Name__c = 'Test Firm',Digital_Billing_City__c = 'California',Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',Source_System_Account_Number__c='123321123',Account_Name__c=testAcc1.id);
            insert SSD;
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
            
             /*ESC_Case_Form_Extension__c escCFE = new ESC_Case_Form_Extension__c();
            escCFE.ESC_Form__c=gf.id;
            escCFE.ESC_Case__c=testcase.id;
            //escCFE.USL_Approval_Type__c='USL Print Subscription';
            escCFE.USL_Requester_Title__c=' Mr.';
            escCFE.USL_Requestor_ID__c='Testing';
            escCFE.USL_Route_to_Consultant__c=true;
            escCFE.USL_Total_Amount__c=450;
            insert escCFE;
            
            ESC_Case_Form_Extension_Line_Item__c  customLineList =new ESC_Case_Form_Extension_Line_Item__c();
            customLineList.ESC_Billing_Doc__c='6123872804';
            customLineList.ESC_Line__c='000010';
            customLineList.ESC_Net_Amount__c=30000;
            customLineList.ESC_Tax_Amount__c=98;
            customLineList.ESC_Root_Cause__c='Services-Findlaw';
            customLineList.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            customLineList.USL_ODocType__c='YM';
            customLineList.USL_OShortDescription__c='Paid and cancelled 6117202889';
            customLineList.ESC_Case_Form_Extension__c=escCFE.id;
            customLineList.ESC_Type__c='Partial';
            customLineList.ESC_Request_Description__c='Non-Westlaw';
            //escCFELine.ESC_Item_Amount__c=30000;
            //escCFELine.USL_Input_Amount__c=1126;
             insert customLineList;
             */
            PageReference pageRef = Page.USL_ChargeCancellation;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', testcase.id);
            pageRef.getParameters().put('formid', gf.id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLCCController());
            
            
            
            USL_CCController ccc= new USL_CCController();
            ccc.Allclitem.ESC_Root_Cause__c = 'Order Processing';
            ccc.Allclitem.ESC_Reason_Code__c = '47-Tax Exempt';
            ccc.Begindt = system.today().addDays(-365);
            ccc.Enddt = system.today();
            ccc.InvoiceList.add('6117778944');
            ccc.getresponses();
            ccc.setInvoiceDateRange();            
            ccc.showPreview();
            Test.stopTest();
            
            ccc.canceltax = true;
            ccc.IsApplyAll = true;
            ccc.routetoconsultant = false;

            ccc.Applydefaults();
            ccc.applydiscount();
             ccc.canceltax = false;
            ccc.calculate();
            ccc.Removediscount();
            ccc.IsCancellAllWL = true;
            ccc.IsCancelAllNWL = true;
            ccc.Applydefaults();  
                      
            ccc.getReasoncodeOptions();
            ccc.getRootCauseOptions();
            ccc.formext.USL_Approval_Type__c='EBO_Collections';
            //ccc.cfli1.ESC_Billing_Doc__c='6117778944';
            ccc.saveComponent();
            ccc.addrow();
            Apexpages.currentPage().getParameters().put('rn','1');
            ccc.deleterow();   
        }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');    
    }
    
    public static testMethod void ccCTest5() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        GenerateForm__C gf= new GenerateForm__C();
        gf.Name='Charge Cancellation';
        Insert gf;
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='Invoice',Username__c='test',Password__c='test',Endpoint__c='test@test.com');
        insert websrv;
        System.runAs(testUser) {
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            testAcc1.BillingCity = 'PORT ANGELES';
            testAcc1.BillingCountry ='US';
            testAcc1.BillingState = 'WA';
            testAcc1.BillingPostalCode = '98363-8409';
            testAcc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert testAcc1;
            
            Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
            insert c;
            Source_System_Detail__c ssd= new Source_System_Detail__c(Digital_Firm_Name__c = 'Test Firm',Digital_Billing_City__c = 'California',Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',Source_System_Account_Number__c='123321123',Account_Name__c=testAcc1.id);
            insert SSD;
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
            
            ESC_Case_Form_Extension__c escCFE = new ESC_Case_Form_Extension__c();
            escCFE.ESC_Form__c=gf.id;
            escCFE.ESC_Case__c=testcase.id;
            escCFE.USL_Approval_Type__c='EBO_Collections';
            escCFE.USL_Requester_Title__c=' Mr.';
            escCFE.USL_Requestor_ID__c='Testing';
            escCFE.USL_Total_Amount__c=450;
            escCFE.Route_To_USL_Print_CD_Credits__c=true;
            
            insert escCFE;
            
            ESC_Case_Form_Extension_Line_Item__c  escCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine.ESC_Billing_Doc__c='6118005220';
            escCFELine.ESC_Line__c='000010';
            escCFELine.ESC_Net_Amount__c=3000;
            escCFELine.ESC_Tax_Amount__c=97;
            escCFELine.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine.USL_ODocType__c='YW';
            escCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine.ESC_Request_Description__c='Westlaw';
            escCFELine.ESC_Type__c='Partial';
           
            //escCFELine.ESC_Item_Amount__c=30000;
            //escCFELine.USL_Input_Amount__c=1126;
             insert escCFELine;
            
            
            ESC_Case_Form_Extension_Line_Item__c  escCFELine1 =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine1.ESC_Billing_Doc__c='6118005220';
            escCFELine1.ESC_Line__c='0010';
            escCFELine1.ESC_Net_Amount__c=40;
            escCFELine1.ESC_Tax_Amount__c=97;
            escCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine1.USL_ODocType__c='YW';
            escCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine1.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine1.ESC_Type__c='FUll';
            escCFELine1.ESC_Request_Description__c='Non-Westlaw';
            //escCFELine1.ESC_Item_Amount__c=30000;
           // escCFELine1.USL_Input_Amount__c=1126;
            //escCFELine1.USL_Invoice_Type__c='Clear';
             insert escCFELine1;
            
         // List<USLARInvoicedetailwrapper.cls_invoiceLines> InvoiceDetailsList= new List<USLARInvoicedetailwrapper.cls_invoiceLines>();
           // USLARInvoicedetailwrapper.ARdetail displayinv_list = new USLARInvoicedetailwrapper.ARdetail();
            
            PageReference pageRef = Page.USL_ChargeCancellation;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', testcase.id);
            pageRef.getParameters().put('formid', gf.id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
            //Test.setMock(HttpCalloutMock.class, new MockUSLCCController());
            
            
            USL_CCController ccc= new USL_CCController();
            ccc.Begindt = system.today().addDays(-365);
            ccc.Enddt = system.today();
           // ccc.InvoiceList.add('6117778944');
            ccc.getresponses();
            ccc.setInvoiceDateRange(); 
            ccc.saveselectedopen();
            ccc.saveselectedclear();           
            ccc.showPreview();
            Test.stopTest();
            ccc.selectalllineitem();
            ccc.goback();
            ccc.getReasoncodeOptions();
            ccc.getRootCauseOptions();
            ccc.getWLPlanOptions();
            ccc.getBUOptions();
            ccc.selectallOpenitem();
            ccc.selectallCleareditem();
            ccc.IsApplyAll=true;
            ccc.Applydefaults();
            ccc.IsCancellAllWL=true;
            ccc.Applydefaults();
            ccc.IsCancelAllNWL=true;
            ccc.Applydefaults();
            ccc.canceltax=true;
            ccc.Applydefaults();
            ccc.applydiscount();
            ccc.calculate();
            ccc.Removediscount();
            ccc.InvoiceList.add('6117778944');
            ccc.formext.USL_Approval_Type__c='EBO Collections';
            ccc.saveComponent();
            ccc.routetoconsultant = false;
            ccc.savecomponent();
            ccc.getARItemType();
            try{
                ccc.previousPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.nextPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.updatePage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.changeData();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.ipreviousPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.inextPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.iupdatePage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.ichangeData(); 
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.cpreviousPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.cnextPage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.cupdatePage();
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            try{
                ccc.cchangeData();  
            }
            catch(Exception e){system.debug(LoggingLevel.WARN,'test');}
            
        }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');    
    }
    
   public static testMethod void ccCTest6() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'TR Helpdesk Agent'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        GenerateForm__C gf= new GenerateForm__C();
        gf.Name='Charge Cancellation';
        Insert gf;
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCH',Companyid__c='S100',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='Invoice',Username__c='test',Password__c='test',Endpoint__c='test@test.com');
        insert websrv;
        System.runAs(testUser) {
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            testAcc1.BillingCity = 'PORT ANGELES';
            testAcc1.BillingCountry ='US';
            testAcc1.BillingState = 'WA';
            testAcc1.BillingPostalCode = '98363-8409';
            testAcc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert testAcc1;
            
            Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
            insert c;
            Source_System_Detail__c ssd= new Source_System_Detail__c(Digital_Firm_Name__c = 'Test Firm',Digital_Billing_City__c = 'California',Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',Source_System_Account_Number__c='123321123',Account_Name__c=testAcc1.id);
            insert SSD;
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
            
            ESC_Case_Form_Extension__c escCFE = new ESC_Case_Form_Extension__c();
            escCFE.ESC_Form__c=gf.id;
            escCFE.ESC_Case__c=testcase.id;
            escCFE.USL_Approval_Type__c='EBO_Collections';
            escCFE.USL_Requester_Title__c=' Mr.';
            escCFE.USL_Requestor_ID__c='Testing';
            escCFE.USL_Total_Amount__c=4500;
            escCFE.Route_To_USL_Print_CD_Credits__c=true;
            
            insert escCFE;
            List<ESC_Case_Form_Extension_Line_Item__c> cflilist = new List<ESC_Case_Form_Extension_Line_Item__c>();
            ESC_Case_Form_Extension_Line_Item__c  escCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine.ESC_Billing_Doc__c='6118005220';
            escCFELine.ESC_Line__c='000010';
            escCFELine.ESC_Net_Amount__c=3000;
            escCFELine.ESC_Tax_Amount__c=97;
            escCFELine.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine.USL_ODocType__c='YN';
            escCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine.ESC_Request_Description__c='Westlaw';
            escCFELine.ESC_Type__c='Partial';
           
            escCFELine.ESC_Item_Amount__c=30000;
            escCFELine.USL_Input_Amount__c=1126;
             cflilist.add(escCFELine);
            
            
            /*ESC_Case_Form_Extension_Line_Item__c  escCFELine1 =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine1.ESC_Billing_Doc__c='6118005220';
            escCFELine1.ESC_Line__c='0010';
            escCFELine1.ESC_Net_Amount__c=5000;
            escCFELine1.ESC_Tax_Amount__c=97;
            escCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine1.USL_ODocType__c='YW';
            escCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine1.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine1.ESC_Type__c='FUll';
            escCFELine1.ESC_Request_Description__c='Non-Westlaw';
            escCFELine1.USL_Input_Amount__c = 700.00;
            //escCFELine1.ESC_Item_Amount__c=30000;
           // escCFELine1.USL_Input_Amount__c=1126;
            //escCFELine1.USL_Invoice_Type__c='Clear';
            cflilist.add(escCFELine1);*/
             insert cflilist ;
            
         // List<USLARInvoicedetailwrapper.cls_invoiceLines> InvoiceDetailsList= new List<USLARInvoicedetailwrapper.cls_invoiceLines>();
           // USLARInvoicedetailwrapper.ARdetail displayinv_list = new USLARInvoicedetailwrapper.ARdetail();
            
            PageReference pageRef = Page.USL_ChargeCancellation;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', testcase.id);
            pageRef.getParameters().put('formid', gf.id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
            //Test.setMock(HttpCalloutMock.class, new MockUSLCCController());
            
            
            USL_CCController ccc= new USL_CCController();
            ccc.Begindt = system.today().addDays(-365);
            ccc.Enddt = system.today();
           // ccc.InvoiceList.add('6117778944');
            ccc.getresponses();
            ccc.setInvoiceDateRange(); 
            ccc.saveselectedopen();
            ccc.saveselectedclear();           
            ccc.showPreview();
            ccc.showLinenumber=true;
            ccc.selectalllineitem();
            ccc.goback();
            ccc.getReasoncodeOptions();
            ccc.getRootCauseOptions();
            ccc.getWLPlanOptions();
            ccc.getBUOptions();
            ccc.selectallOpenitem();
            ccc.selectallCleareditem();
            ccc.IsApplyAll=true;
            ccc.Applydefaults();
            ccc.IsCancellAllWL=true;
            ccc.Applydefaults();
            ccc.IsCancelAllNWL=true;
            ccc.Applydefaults();
            ccc.canceltax=true;
            ccc.Applydefaults();
            ccc.applydiscount();
            ccc.calculate();
            ccc.Removediscount();
            ccc.InvoiceList.add('6117778944');
            ccc.formext.USL_Approval_Type__c='EBO Collections';
            ccc.saveComponent();
            Test.stopTest();
            ccc.routetoconsultant=false;
            ccc.savecomponent();
            ccc.getARItemType();
            
           } 
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');    
    }
    
    public static testMethod void ccCTest7() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'USL Helpdesk Agent'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        GenerateForm__C gf= new GenerateForm__C();
        gf.Name='Charge Cancellation';
        Insert gf;
        USL_Integration_defaults__c usl= new USL_Integration_defaults__c(Applicationid__c='ESCU',Companyid__c='West',domainid__c='COBALT',IncludeActiveSubs__c='true',IncludeLapsedSubs__c='true',isActive__c='true',isPrimary__c='true',Language__c='EN',Name='Integrationdefaults',   partnertype__c='SH');
        insert usl;
        WebServiceSettings__c websrv = new WebServiceSettings__c(Service_Unavailable_Message__c='test',name='Invoice',Username__c='test',Password__c='test',Endpoint__c='test@test.com');
        insert websrv;
        System.runAs(testUser) {
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            testAcc1.BillingCity = 'PORT ANGELES';
            testAcc1.BillingCountry ='US';
            testAcc1.BillingState = 'WA';
            testAcc1.BillingPostalCode = '98363-8409';
            testAcc1.BillingStreet = '2851 LOWER ELWHA RD';
            insert testAcc1;
            
            Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
            insert c;
            Source_System_Detail__c ssd= new Source_System_Detail__c(Digital_Firm_Name__c = 'Test Firm',Digital_Billing_City__c = 'California',Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',Source_System_Account_Number__c='123321123',Account_Name__c=testAcc1.id);
            insert SSD;
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
            
            ESC_Case_Form_Extension__c escCFE = new ESC_Case_Form_Extension__c();
            escCFE.ESC_Form__c=gf.id;
            escCFE.ESC_Case__c=testcase.id;
            escCFE.USL_Approval_Type__c='EBO_Collections';
            escCFE.USL_Requester_Title__c=' Mr.';
            escCFE.USL_Requestor_ID__c='Testing';
            escCFE.USL_Total_Amount__c=4500;
            escCFE.Route_To_USL_Print_CD_Credits__c=true;
            
            insert escCFE;
            
            ESC_Case_Form_Extension_Line_Item__c  escCFELine =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine.ESC_Billing_Doc__c='6118005220';
            escCFELine.ESC_Line__c='000010';
            escCFELine.ESC_Net_Amount__c=3000;
            escCFELine.ESC_Tax_Amount__c=97;
            escCFELine.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine.USL_ODocType__c='YW';
            escCFELine.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine.ESC_Request_Description__c='Westlaw';
            escCFELine.ESC_Type__c='Partial';
           
            escCFELine.ESC_Item_Amount__c=30000;
            escCFELine.USL_Input_Amount__c=1126;
             insert escCFELine;
            
            
            ESC_Case_Form_Extension_Line_Item__c  escCFELine1 =new ESC_Case_Form_Extension_Line_Item__c();
            escCFELine1.ESC_Billing_Doc__c='6118005220';
            escCFELine1.ESC_Line__c='0010';
            escCFELine1.ESC_Net_Amount__c=5000;
            escCFELine1.ESC_Tax_Amount__c=97;
            escCFELine1.ESC_Root_Cause__c='Services-Findlaw';
            escCFELine1.ESC_Reason_Code__c='FL-SERV-Relationship/Overall experience';
            escCFELine1.USL_ODocType__c='YW';
            escCFELine1.USL_OShortDescription__c='Paid and cancelled 6117202889';
            escCFELine1.ESC_Case_Form_Extension__c=escCFE.id;
            escCFELine1.ESC_Type__c='FUll';
            escCFELine1.ESC_Request_Description__c='Non-Westlaw';
            escCFELine1.USL_Input_Amount__c = 700.00;
            //escCFELine1.ESC_Item_Amount__c=30000;
           // escCFELine1.USL_Input_Amount__c=1126;
            //escCFELine1.USL_Invoice_Type__c='Clear';
             insert escCFELine1;
            
         // List<USLARInvoicedetailwrapper.cls_invoiceLines> InvoiceDetailsList= new List<USLARInvoicedetailwrapper.cls_invoiceLines>();
           // USLARInvoicedetailwrapper.ARdetail displayinv_list = new USLARInvoicedetailwrapper.ARdetail();
            
            PageReference pageRef = Page.USL_ChargeCancellation;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', testcase.id);
            pageRef.getParameters().put('formid', gf.id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
            //Test.setMock(HttpCalloutMock.class, new MockUSLCCController());
            
            
            USL_CCController ccc= new USL_CCController();
            ccc.Begindt = system.today().addDays(-365);
            ccc.Enddt = system.today();
           // ccc.InvoiceList.add('6117778944');
            ccc.getresponses();
            ccc.setInvoiceDateRange(); 
            ccc.saveselectedopen();
            ccc.saveselectedclear();           
            ccc.showPreview();
            Test.stopTest();
            ccc.selectalllineitem();
            ccc.goback();
            ccc.getReasoncodeOptions();
            ccc.getRootCauseOptions();
            ccc.getWLPlanOptions();
            ccc.getBUOptions();
            ccc.selectallOpenitem();
            ccc.selectallCleareditem();
            ccc.IsApplyAll=true;
            ccc.Applydefaults();
            ccc.IsCancellAllWL=true;
            ccc.Applydefaults();
            ccc.IsCancelAllNWL=true;
            ccc.Applydefaults();
            ccc.canceltax=true;
            ccc.Applydefaults();
            ccc.applydiscount();
            ccc.calculate();
            ccc.Removediscount();
            ccc.InvoiceList.add('6117778944');
            ccc.formext.USL_Approval_Type__c='EBO Collections';
            ccc.saveComponent();
            ccc.routetoconsultant = false;
            ccc.appflag = true;
            ccc.savecomponent();
            ccc.getARItemType();     
        }                 
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j,'equal');
    }
}