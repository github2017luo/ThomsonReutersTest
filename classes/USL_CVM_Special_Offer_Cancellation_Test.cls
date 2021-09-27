@isTest
public class USL_CVM_Special_Offer_Cancellation_Test{
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
        case1.USL_SAP_Account_Number__c = '123456678';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        WebServiceSettings__c webserv = new WebServiceSettings__c ();
        webserv.name = 'USLSubscriptionService';
        webserv.Active__c = true;
        webserv.Username__c = 'test';
        webserv.Password__c = 'test';
        webserv.Timeout__c = 10;
        webserv.Endpoint__c = 'test';
        webserv.Service_Unavailable_Message__c = 'test';
        insert webserv;
        Apexpages.currentpage().getparameters().put('caseid',case1.id);
        Apexpages.currentpage().getparameters().put('formid',form1.id);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLSubscriptionController());
        USL_CVM_Special_Offer_Cancellation cvmcont = new USL_CVM_Special_Offer_Cancellation();
        cvmcont.CFE.Special_billing_allocation__c = 'Yes';
        cvmcont.CFE.Location__c='Individual Locations';
        cvmcont.showdecision();
        cvmcont.CFE.Product_Type__c = 'Multiple Products';
        cvmcont.showProducttype();
        cvmcont.SubsList[0].isselected = true;
        cvmcont.CFE.ESC_List_Product__c = 'test';
        cvmcont.CFE.ESC_Special_Offer_time__c = system.today();
        cvmcont.CFE.ESC_Segment_Special_offer__c = 'Small Law';
        cvmcont.Savebutton();
        Test.StopTest();   
    }
    static testmethod void Method2(){
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        case1.USL_SAP_Account_Number__c = '123456678';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        
        Apexpages.currentpage().getparameters().put('caseid',case1.id);
        Apexpages.currentpage().getparameters().put('formid',form1.id);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLSubscriptionController());
        USL_CVM_Special_Offer_Cancellation cvmcont = new USL_CVM_Special_Offer_Cancellation();
        cvmcont.CFE.Special_billing_allocation__c = 'No';
        cvmcont.CFE.Location__c='All Locations';
        cvmcont.showdecision();
        cvmcont.CFE.Product_Type__c = 'Products';
        cvmcont.showProducttype();                
        cvmcont.CFE.ESC_Special_Offer_time__c = system.today();
        cvmcont.CFE.ESC_Segment_Special_offer__c = 'Small Law';
        cvmcont.Savebutton();
        try{
        cvmcont.nextPage();}
        catch(Exception e){}
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
        case1.USL_SAP_Account_Number__c = '123456678';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        WebServiceSettings__c webserv = new WebServiceSettings__c ();
        webserv.name = 'USLSubscriptionService';
        webserv.Active__c = true;
        webserv.Username__c = 'test';
        webserv.Password__c = 'test';
        webserv.Timeout__c = 10;
        webserv.Endpoint__c = 'test';
        webserv.Service_Unavailable_Message__c = 'test';
        insert webserv;
        Apexpages.currentpage().getparameters().put('caseid',case1.id);
        Apexpages.currentpage().getparameters().put('formid',form1.id);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLSubscriptionController());
        USL_CVM_Special_Offer_Cancellation cvmcont = new USL_CVM_Special_Offer_Cancellation();        
        
        cvmcont.CFE.ESC_List_Product__c = 'test';
        cvmcont.Savebutton();
        cvmcont.CFE.ESC_Special_Offer_time__c = system.today();
        cvmcont.CFE.ESC_List_Product__c = '';
        cvmcont.Savebutton();
        cvmcont.CFE.ESC_Segment_Special_offer__c = 'Small Law';
        cvmcont.Savebutton();
        cvmcont.CFE.ESC_Segment_Special_offer__c = '';
        cvmcont.CFE.ESC_Special_Offer_time__c = null;
        cvmcont.CFE.ESC_List_Product__c = '';
        cvmcont.Savebutton();
        try{
        cvmcont.PreviousPage();}
        catch(Exception e){}
        Test.StopTest();   
    }
    static testmethod void Method4(){
        Account Acc1 = new Account();
        Contact Con = new Contact();
        Acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert Acc1;
        Con =ESC_GenericTestutility.TestContactUtil(Acc1.ID, 'test','contact','test7365@gmail.com');
        insert Con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(Con.ID,Acc1.ID,'New');
        case1.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        case1.USL_SAP_Account_Number__c = '123456678';
        insert case1;
        GenerateForm__c form1 = new GenerateForm__c(Name ='Transfer Credits12',LabelName__c='Transfer Credits12',ESC_Executer__c='ESC_BillingRequestController',Description__c='Test');
        insert form1;
        WebServiceSettings__c webserv = new WebServiceSettings__c ();
        webserv.name = 'USLSubscriptionService';
        webserv.Active__c = true;
        webserv.Username__c = 'test';
        webserv.Password__c = 'test';
        webserv.Timeout__c = 10;
        webserv.Endpoint__c = 'test';
        webserv.Service_Unavailable_Message__c = 'test';
        insert webserv;
        Apexpages.currentpage().getparameters().put('caseid',case1.id);
        Apexpages.currentpage().getparameters().put('formid',form1.id);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockUSLSubscriptionController());
        USL_CVM_Special_Offer_Cancellation cvmcont = new USL_CVM_Special_Offer_Cancellation();
        cvmcont.SubsList[0].isselected = true;
        cvmcont.validate();
        cvmcont.CFE.Special_billing_allocation__c = 'Yes';
        cvmcont.validate();
        cvmcont.CFE.Location__c='Individual Locations';
        cvmcont.validate();
        cvmcont.CFE.Product_Type__c = 'test';
        cvmcont.validate();
        cvmcont.CFE.ESC_Special_Offer_time__c = system.today();
        cvmcont.validate();
        cvmcont.CFE.ESC_Segment_Special_offer__c = 'Small Law';
        cvmcont.validate();
        Test.StopTest();
    }
}