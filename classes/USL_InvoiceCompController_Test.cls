@isTest
public class USL_InvoiceCompController_Test{
    static testmethod void Method1(){
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        case1.USL_SAP_Account_Number__c = '100556789';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        ESC_Case_Form_Extension__c CFormExt =new ESC_Case_Form_Extension__c();        
        CFormExt.USL_Residual_Amount__c=500;
        CFormExt.ESC_Form__c=form1.id;
        CFormExt.ESC_Case__c=case1.id;
        insert CFormExt;
        
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        //Apexpages.currentpage().getparameters().put('id',case1.id);
        //Apexpages.currentpage().getparameters().put('formid',case1.id);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=Acc1.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = 'valueMarket';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.City__c = 'BANGALORE';
        accountSSD.Digital_Billing_City__c='test';
        accountSSD.Digital_Firm_Name__c = 'test';
        accountSSD.Source_System_Account_Number__c = '100556789';
        accountSSD.State__c = 'California';
        insert accountSSD;
        
         PageReference pageRef = Page.USL_Invoicepage;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', case1.id);
            pageRef.getParameters().put('formid', form1.id);
        test.StartTest();
         Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
        USL_InvoiceCompController invcon = new USL_InvoiceCompController();
        invcon.goback();
        invcon.isresidualamount=False;
        invcon.isshowcheckField=False;  
        //invcon.isshowcheck1=False;
        
        invcon.validate();
       // invcon.openwrapperlist[0].isselected = true; 
        //invcon.saveselectedopen();
       
       
        invcon.setinvoicedaterange();
        //invcon.openwrapperlist[0].isselected = true;
         invcon.saveselectedopen();
        
        //invcon.clearwrapperlist[0].isselected = true;
        invcon.saveselectedclear();
        invcon.selectall = true;
        invcon.selectall1 = true;
        invcon.selectalllineitem();
       
        invcon.selectalllineitem1();
        
        invcon.showpreview();
        invcon.addrow();
         
        invcon.cupdatePage();        
        invcon.savecomponent();
        invcon.formext.USL_How_was_this_Debt_Paid__c = 'CREDIT CARD';
        invcon.showcheck();
       
        invcon.savecomponent();
        invcon.formext.USL_How_was_this_Debt_Paid__c = 'CHECK';
        invcon.showcheck();
         
        invcon.formext.USL_Payment_Decision__c = 'Refund';
        invcon.showdecision();
        invcon.formext.USL_Payment_Decision__c = 'Open';
        invcon.showdecision();
        invcon.formext.USL_Refund_Method__c = 'Credit Card';
        invcon.showpaymenttype();
        invcon.formext.USL_Refund_Method__c = 'Check';
        invcon.showpaymenttype();
        invcon.savecomponent();
        invcon.formext.USL_Is_credit_card_payment__c = 'Yes';
        invcon.showcreditcard();
        invcon.formext.USL_Is_credit_card_payment__c = 'No';
        invcon.showcreditcard();  
        invcon.showcreditcard1();
        invcon.formext.USL_Use_Account_Address__c='Yes';
         Test.StopTest();
    }
    static testmethod void Method2(){
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con = ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        case1.USL_SAP_Account_Number__c = '100556789';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='IFF Adjustment',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=Acc1.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = 'valueMarket';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.City__c = 'BANGALORE';
        accountSSD.Digital_Billing_City__c='test';
        accountSSD.Digital_Firm_Name__c = 'test';
        accountSSD.Source_System_Account_Number__c = '100556789';
        accountSSD.State__c = 'California';
        insert accountSSD;
        
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        Apexpages.currentpage().getparameters().put('id',case1.id);
        Apexpages.currentpage().getparameters().put('formid',form1.id);
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());

        USL_InvoiceCompController invcon = new USL_InvoiceCompController();
        invcon.getARItemType();
        invcon.goback();
        invcon.setinvoicedaterange();
        
        //invcon.openwrapperlist[0].isselected = true; 
        invcon.saveselectedopen();
           invcon.showpreview();                
                     
            
        invcon.updatePage(); 
        invcon.selectall = true;
        invcon.selectall1 = true;
        invcon.selectalllineitem();
        invcon.selectalllineitem1(); 
        invcon.savecomponent();
        invcon.addrow();
        Apexpages.currentPage().getParameters().put('rn','1');
        invcon.deleterow();
        invcon.createreferral('Academic_Support');
        Test.StopTest();
    }
     static testmethod void Method3(){
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        case1.USL_SAP_Account_Number__c = '100556789';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        ESC_Case_Form_Extension__c CFormExt =new ESC_Case_Form_Extension__c();        
        CFormExt.USL_Residual_Amount__c=500;
        CFormExt.ESC_Form__c=form1.id;
        CFormExt.ESC_Case__c=case1.id;
         insert CFormExt;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=Acc1.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = 'valueMarket';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.City__c = 'BANGALORE';
        accountSSD.Digital_Billing_City__c='test';
        accountSSD.Digital_Firm_Name__c = 'test';
        accountSSD.Source_System_Account_Number__c = '100556789';
        accountSSD.State__c = 'California';
        insert accountSSD;
        
        ESC_Case_Form_Extension_Line_Item__c cLI = new ESC_Case_Form_Extension_Line_Item__c();
        cLI.USL_Invoice_Type__c = 'Open';
        cLI.ESC_Case_Form_Extension__c = CFormExt.id;
        insert cLI;
        
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        //Apexpages.currentpage().getparameters().put('id',case1.id);
        //Apexpages.currentpage().getparameters().put('formid',case1.id);
       
        
         PageReference pageRef = Page.USL_Invoicepage;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('id', case1.id);
            pageRef.getParameters().put('formid', form1.id);
        test.StartTest();
         Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
        USL_InvoiceCompController invcon = new USL_InvoiceCompController();
        USL_InvoiceCompController.openWrapper openWrapper1= new USL_InvoiceCompController.openWrapper(true,null,cLI);
        invcon.goback();
        invcon.isresidualamount=False;
        invcon.isshowcheckfield=False;  
        //invcon.isshowcheck1=False;
        
        invcon.validate();
       // invcon.openwrapperlist[0].isselected = true; 
       // invcon.saveselectedopen();
       // invcon.selectalllineitem();
       // invcon.selectalllineitem1();
        
        invcon.setinvoicedaterange();
        //invcon.openwrapperlist[0].isselected = true;
         invcon.saveselectedopen();
        
        invcon.clearwrapperlist[0].isselected = true;
        invcon.saveselectedclear();
        invcon.showpreview();
        
        
        invcon.cupdatePage();        
        invcon.savecomponent();
        invcon.formext.USL_How_was_this_Debt_Paid__c = 'CREDIT CARD';
        invcon.showcheck();
       
        invcon.savecomponent();
        invcon.formext.USL_How_was_this_Debt_Paid__c = 'CHECK';
        invcon.showcheck();
         
        invcon.formext.USL_Payment_Decision__c = 'Refund';
        invcon.showdecision();
        invcon.formext.USL_Payment_Decision__c = 'Open';
        invcon.showdecision();
        invcon.formext.USL_Refund_Method__c = 'Credit Card';
        invcon.showpaymenttype();
        invcon.formext.USL_Refund_Method__c = 'Check';
        invcon.showpaymenttype();
        invcon.savecomponent();
        invcon.formext.USL_Is_credit_card_payment__c = 'Yes';
        invcon.showcreditcard();
        invcon.formext.USL_Is_credit_card_payment__c = 'No';
        invcon.showcreditcard();  
        invcon.showcreditcard1();
        invcon.formext.USL_Use_Account_Address__c='Yes';
          
        Test.StopTest();
    }
    
    static testmethod void Method4(){
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con = ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        case1.USL_SAP_Account_Number__c = '100556789';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Refund',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=Acc1.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = 'valueMarket';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.City__c = 'BANGALORE';
        accountSSD.Digital_Billing_City__c='test';
        accountSSD.Digital_Firm_Name__c = 'test';
        accountSSD.Source_System_Account_Number__c = '100556789';
        accountSSD.State__c = 'California';
        insert accountSSD;
        
        Apexpages.currentpage().getparameters().put('id',case1.id);
        Apexpages.currentpage().getparameters().put('formid',form1.id);
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());

        USL_InvoiceCompController invcon = new USL_InvoiceCompController();
        invcon.getARItemType();
        invcon.goback();
        invcon.setinvoicedaterange();
        
        //invcon.openwrapperlist[0].isselected = true; 
        invcon.saveselectedopen();
           invcon.showpreview();                
                     
            
        invcon.updatePage(); 
        invcon.selectall = true;
        invcon.selectall1 = true;
        invcon.selectalllineitem();
        invcon.selectalllineitem1(); 
        invcon.savecomponent();
        invcon.addrow();
        Apexpages.currentPage().getParameters().put('rn','1');
        invcon.deleterow();
        invcon.createreferral('Academic_Support');
        Test.StopTest();
    }
    
    static testmethod void Method5(){
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con = ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        case1.USL_SAP_Account_Number__c = '100556789';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Debits/Credits',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=Acc1.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = 'valueMarket';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.City__c = 'BANGALORE';
        accountSSD.Digital_Billing_City__c='test';
        accountSSD.Digital_Firm_Name__c = 'test';
        accountSSD.Source_System_Account_Number__c = '100556789';
        accountSSD.State__c = 'California';
        insert accountSSD;
        
        Apexpages.currentpage().getparameters().put('id',case1.id);
        Apexpages.currentpage().getparameters().put('formid',form1.id);
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());

        USL_InvoiceCompController invcon = new USL_InvoiceCompController();
        invcon.getARItemType();
        invcon.goback();
        invcon.setinvoicedaterange();
        
        //invcon.openwrapperlist[0].isselected = true; 
        invcon.saveselectedopen();
           invcon.showpreview();                
                     
            
        invcon.updatePage(); 
        invcon.selectall = true;
        invcon.selectall1 = true;
        invcon.selectalllineitem();
        invcon.selectalllineitem1(); 
        invcon.savecomponent();
        invcon.addrow();
        Apexpages.currentPage().getParameters().put('rn','1');
        invcon.deleterow();
        invcon.createreferral('Academic_Support');
        Test.StopTest();
    }
}