@IsTest(SeeAllData=false) 
public class ESC_ReferralAssignmentEngine_Test{
   
    static testmethod void  ESC_ReferralAssignmentEngineTestmethod1(){
        
            GenerateForm__c form1 = new GenerateForm__c(Name='CreditDebitPayment',LabelName__c='CreditDebitPayment',ESC_Executer__c='ESC_Apply_Transfer_Credits',Description__c='Test');
            insert form1;
            ESC_FormsSegmentRegionMapping__c oForm = new ESC_FormsSegmentRegionMapping__c();
            oForm.ESC_CSS_Form__c = form1.Id;
            oForm.ESC_Form_Label_Name__c = 'CreditDebitPayment';
            oForm.ESC_Form_Section__c = 'Account Maintenance';
            oForm.ESC_LandingURL__c = '/apex/USLARPaymentPage?';
            oForm.ESC_Region__c ='US';
            oForm.ESC_Segment__c = 'Professional Tax';
            oForm.ESC_Form_Field1__c = 'ESC_Case__r.ESC_Product_Segment_Brand__c';
            oForm.ESC_Form_Field2__c = 'ESC_Case__r.ESC_Product_Title__c';
            oForm.ESC_Form_Field3__c = 'ESC_Case__r.ESC_Product_Feature_Module__c';
            oForm.ESC_Form_Field4__c = 'ESC_Case__r.Subject';
            oForm.ESC_Form_Field5__c = 'ESC_Case__r.Description';
            oForm.ESC_Product_Segment_Brand__c ='Audit';
            insert oForm;
            
            Group g = new Group();
            g.Name = 'TXP_C2C_Order_Management';
            g.type='Queue';
            insert g;
       
            List<QueueSobject> mappingObjectLst = new List<QueueSobject>();
            QueueSobject mappingObject = new QueueSobject();
            mappingObject.QueueId = g.Id;
            mappingObject.SobjectType = 'ESC_Case_Collaborator__c';
            mappingObjectLst.add(mappingObject);
            QueueSobject mappingObject1 = new QueueSobject();
            mappingObject1.QueueId = g.Id;
            mappingObject1.SobjectType = 'Case';
            mappingObjectLst.add(mappingObject1);
            System.runAs(new User(Id = UserInfo.getUserId()))
             {insert mappingObjectLst;}
            
            USL_Case_SLA_Matrix__c sla= new USL_Case_SLA_Matrix__c();
            sla.Name='TXP_C2C_Order_Management';
            sla.USL_Queue__c='TXP_C2C_Order_Management';
            sla.USL_Referral_SLA_Minutes__c=1220;
            insert sla;
            
            
            ESC_Referral_Form_Assign_Selector_List__c refqueueselect = new ESC_Referral_Form_Assign_Selector_List__c();
            refqueueselect.Form_Segment_Region_Id__c =oForm.id;
            refqueueselect.ESC_Form_Field1__c = 'Audit';
            refqueueselect.ESC_Form_Field2__c = 'Checkpoint Tools';
            //refqueueselect.ESC_Form_Field3__c  ='';
            //refqueueselect.ESC_Form_Field4__c ='US';
            //refqueueselect.ESC_Form_Field5__c = 'Professional Tax';
            refqueueselect.Referral_Creation_Required__c =True;
            refqueueselect.ESC_Referral_Queue_Name__c = 'TXP_C2C_Order_Management';
            refqueueselect.ESC_Case_Update_Required__c = True;
            refqueueselect.ESC_Case_Queue_Name__c = 'TXP_C2C_Order_Management';
            
            insert refqueueselect ;
            
            Profile profile = [SELECT Id FROM Profile where Name='TR Helpdesk Agent'];
          
          
            User user = new User(Alias = 'txprf', Email='Taxpfofform3@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, Segment__c = 'Professional Tax',
            TimeZoneSidKey='America/Los_Angeles', UserName='Taxpfofform3@ss.com');
            insert user;
            system.runAs(user){
            
                 
                
                Account acc = new Account();
                Contact con = new Contact();
                acc = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
                acc.BU_Region__c='US';
                acc.Bu_Segment__c='Professional Tax';
                insert acc; 
                System.assertequals('test account',acc.name,'Success');
                con =ESC_GenericTestutility.TestContactUtil(acc.ID, 'test','contact','test7365@gmail.com');
                insert con;
                Case case1=new Case();
                case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc.ID,'New');
                case1.ESC_Product_Segment_Brand__c ='Audit';
                case1.ESC_Product_Title__c= 'Checkpoint Tools';
                //case1.ESC_Product_Feature_Module__c='Browser';
                case1.LCRM_Sub_BU__c='US';
                case1.Bu_Segment__c='Professional Tax';
                insert case1;
                //ID caseid=case1.Id;
                ESC_Case_Form_Extension__c caseForm1 = new ESC_Case_Form_Extension__c();
                caseForm1.name = 'CreditDebitPayment';
                caseForm1.esc_form__c = form1.id;
                caseForm1.ESC_Case__c = case1.Id;
                
                insert caseForm1;
                
                String caseId1 = case1.Id;
                String formId = form1.id;
                string formName = 'CreditDebitPayment';
                Test.startTest();
                try{
                ESC_ReferralAssignmentEngine objeerfassign= new ESC_ReferralAssignmentEngine(caseId1,formId,formName);
                //ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine();
                objeerfassign.createReferral();
                objeerfassign.validateFormSegmentMappingExist();
                objeerfassign.createReferral();
                 ESC_ReferralAssignmentEngine objeerfassign1= new ESC_ReferralAssignmentEngine(null,formId,formName);
                 objeerfassign1.createReferral();
                 //ESC_ReferralAssignmentEngine objeerfassign2= new ESC_ReferralAssignmentEngine(caseId1,null,formName);
                 //objeerfassign2.createReferral();
                 //ESC_ReferralAssignmentEngine objeerfassign3= new ESC_ReferralAssignmentEngine(caseId1,formId,'');
                 //objeerfassign3.createReferral();
                }
                catch(Exception e)
                {
                    System.debug(logginglevel.warn,'rf--->'+e.getMessage());
                }
                Test.stopTest();
            }          
     }
    
    @isTest
    public static void testSaveSSD(){
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'CreditCheck',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings1 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings2 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'EnterpriseWSDL',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings3 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'StatusPostbackLocation',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wsList = new List<WebServiceSettings__c>{oWebServiceSettings, o1WebServiceSettings, 
                        o1WebServiceSettings1, o1WebServiceSettings2, o1WebServiceSettings3};
        insert wsList ;

        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account acc1 =APTS_TestDataFactory.createAccount('Test');
        acc1.FrozenMarketSegment__c = valueMarket;
        acc1.Customer_Group__c='FEDERAL GOVERNMENT';
        acc1.CurrencyIsoCode='USD';
        acc1.Sales_Org__c='LLEY';
        acc1.Customer_Type__c = 'Individual';
        acc1.Industry = 'TAX';
        acc1.BillingStreet = '275 BATTERY ST STE 1500';
        acc1.BillingCity = 'SAN FRANCISCO';
        acc1.BillingState = 'CA';
        acc1.BillingPostalCode = '94111-3334';
        acc1.BillingCountry = 'US';
        acc1.Is_Customer_Review_Complete__c=true;        
        insert acc1;
        
        System.assertequals('Test',acc1.name,'Success');
        
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD.name ='test source system';
        accountSSD.city__c='CA';
        accountSSD.Account_Name__c=acc1.Id;
        accountSSD.Source_System_Name__c='Test SSD';
        accountSSD.country__c ='US';
        accountSSD.LCRM_Industry__c='TAX';
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD.State__c='CA';
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Source_System_Account_Number__c='1003606828';
        accountSSD.CurrencyIsoCode='USD';
        insert accountSSD;
        
        Contact testContact = ESC_GenericTestutility.TestContactUtil(acc1.id ,'Mile','Test','test@tr.com');
        testContact.FirstName='testerrr';
        insert testContact;
        Case ca= new Case();
        ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,acc1.id,'New');
        ca.USL_SAP_Account_Number__c='1003606828';
        Insert ca;
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c webServe = new WebServiceSettings__c();
        webServe.name = 'USL PaymentGateway';       
        webServe.Active__c = true;
        webServe.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
        webServe.Password__c = 'esidevuser123';
        webServe.Service_Unavailable_Message__c = 'Service Unavailable';
        webServe.Timeout__c = 120;
        webServe.Username__c = 'esidevuser';
        lstofWebServ.add(webServe);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }

        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        
        JSONGenerator gen = JSON.createGenerator(true);
        //gen.writeStartObject();
        //gen.writeFieldName('0');
        gen.writeStartArray();
        
        gen.writeStartObject();
        gen.writeStringField('billDoc', '123456');
        gen.writeNumberField('amount', 450);
        gen.writeStringField('lineNumber', '12345');
        gen.writeStringField('refNumber', '250');
        gen.writeStringField('deInd', 'D');
        gen.writeStringField('netar', '150');
        gen.writeStringField('sDec', 'Test');
        gen.writeStringField('bDate', '12/02/1990');
        gen.writeStringField('doct', 'DD');
        gen.writeEndObject();
        
        gen.writeEndArray();
        //gen.writeEndObject();
        
        JSONGenerator gen1 = JSON.createGenerator(true);
        //gen1.writeStartObject();
        //gen1.writeFieldName('0');
        gen1.writeStartArray();
        
        gen1.writeStartObject();
        gen1.writeStringField('docNumber', '5000077441');
        gen1.writeStringField('doct', 'DD');
        gen1.writeNumberField('newAmount', 68.95);
        gen1.writeStringField('invList', '2000312');
        gen1.writeStringField('ccode', 'USD');
        gen1.writeStringField('lnum', '001');
        gen1.writeStringField('subItemNumber', '234678');
        gen1.writeStringField('baselineDate', '12/04/2020');
        gen1.writeNumberField('amount', 68.95);
        gen1.writeStringField('shortDescription', 'Partial Balance');
        gen1.writeEndObject();
        
        gen1.writeEndArray();
        //gen1.writeEndObject();

       GenerateForm__c form1 = new GenerateForm__c(Name ='CreditCard/Debit Payment',LabelName__c='CreditCard/Debit Payment');
	   insert form1;
       
       list<LCRM_Integration_defaults_Values__c> integrationDefaultlst= new list<LCRM_Integration_defaults_Values__c>();
        LCRM_Integration_defaults_Values__c intDefault= new LCRM_Integration_defaults_Values__c();
        intDefault.name='AccountReceivableInvoiceList';
        intDefault.LCRM_ApplicationId__c='GLI';
        intDefault.LCRM_CompanyId__c='SSD ';
        intDefault.LCRM_ExternalSystemName__c='ESI';
        intDefault.LCRM_WebserviceName__c='LCRMInvoiceOpenClearedItemsServices';
        integrationDefaultlst.add(intDefault);
        if(integrationDefaultlst.size()>0){
            insert integrationDefaultlst;
        }
        
       String nmData = gen1.getAsString();
       String csData = gen.getAsString();
       String buSeg = 'Professional Legal';
       String lcrmSubbu = 'USL';
       //String formId ='aCh1B000000blhCSAQ';
       String systemSrcAccNumber = '123456';
       Double newAmount =129.36;
       String extFromId1 = null;
       Double upAmount = 128.98;
       
       WebServiceSettings__c service1 = new WebServiceSettings__c(name='Invoice',Endpoint__c='https://api-uat.thomsonreuters.com/ebs/invoice/uat/getInvoiceOpenClearedItems',Username__c='esidevuser',Password__c='esidevuser123',Service_Unavailable_Message__c='Unavailable',Timeout__c=120);
       insert service1;
        
       ESC_ReferralAssignmentEngine.saveSelectedInvoices(nmData,csData,buSeg,lcrmSubbu,ca.Id,form1.Id,systemSrcAccNumber,newAmount,extFromId1,upAmount);
       
       List<esc_case_form_extension__c> csextForm=[select Id,USL_Total_Amount__c from esc_case_form_extension__c where esc_case__c=:ca.Id and esc_form__c =:form1.Id];
       //System.debug('csextForm '+csextForm);
       
       List<ESC_Case_Form_Extension_Line_Item__c> caseextLineItemList=[select Id,USL_ODocNumber__c,USL_InvListNumber__c,USL_ODocType__c,USL_Input_Amount__c,Billing_Line_Item_Number__c,ESC_Item_Amount__c,USL_OShortDescription__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c=:csextForm[0].Id];
       //System.debug('caseextLineItemList'+caseextLineItemList);
        
       ESC_ReferralAssignmentEngine.saveSelectedInvoices(nmData,csData,buSeg,lcrmSubbu,ca.Id,form1.Id,SystemSrcAccNumber,newAmount,csextForm[0].Id,upAmount);
       
       Test.startTest();
        
        String bData = '2020-06-17';
        String eData = '2021-06-17';
       
       Test.setMock(HttpCalloutMock.class, new MockUSLARController());
       ESC_ReferralAssignmentEngine.uslarLoad(ca.Id,form1.Id,null,false,bData,eData); 
       ESC_ReferralAssignmentEngine.getUpdatedCaseExtensions(caseextLineItemList[0].Id);
       Test.stopTest();
    }
    
    @isTest
    public static void testResponse(){
		
			WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'CreditCheck',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings1 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings2 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'EnterpriseWSDL',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c o1WebServiceSettings3 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'StatusPostbackLocation',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        
        List<WebServiceSettings__c> wsList = new List<WebServiceSettings__c>{oWebServiceSettings, o1WebServiceSettings, 
                        o1WebServiceSettings1, o1WebServiceSettings2, o1WebServiceSettings3};
        insert wsList ;

        Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account acc1 =APTS_TestDataFactory.createAccount('Test');
        acc1.FrozenMarketSegment__c = valueMarket;
        acc1.Customer_Group__c='FEDERAL GOVERNMENT';
        acc1.CurrencyIsoCode='USD';
        acc1.Sales_Org__c='LLEY';
        acc1.Customer_Type__c = 'Individual';
        acc1.Industry = 'TAX';
        acc1.BillingStreet = '275 BATTERY ST STE 1500';
        acc1.BillingCity = 'SAN FRANCISCO';
        acc1.BillingState = 'CA';
        acc1.BillingPostalCode = '94111-3334';
        acc1.BillingCountry = 'US';
        acc1.Is_Customer_Review_Complete__c=true;        
        insert acc1;
        
        System.assertequals('Test',acc1.name,'Success');
        
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(acc1);
        accountSSD.name ='test source system';
        accountSSD.city__c='CA';
        accountSSD.Account_Name__c=acc1.Id;
        accountSSD.Source_System_Name__c='Test SSD';
        accountSSD.country__c ='US';
        accountSSD.LCRM_Industry__c='TAX';
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Number_Street__c='275 BATTERY ST STE 1500';
        accountSSD.State__c='CA';
        accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
        accountSSD.Source_System_Account_Number__c='1003606828';
        accountSSD.CurrencyIsoCode='USD';
        insert accountSSD;
        
        Contact testContact = ESC_GenericTestutility.TestContactUtil(acc1.id ,'Mile','Test','test@tr.com');
        testContact.FirstName='testerrr';
        insert testContact;
        Case ca= new Case();
        ca = ESC_GenericTestutility.TestCaseUtil(testContact.id,acc1.id,'New');
        ca.USL_SAP_Account_Number__c='1003606828';
        Insert ca;
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c webServe = new WebServiceSettings__c();
        webServe.name = 'USL PaymentGateway';       
        webServe.Active__c = true;
        webServe.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentGateway?e=1&';
        webServe.Password__c = 'esidevuser123';
        webServe.Service_Unavailable_Message__c = 'Service Unavailable';
        webServe.Timeout__c = 120;
        webServe.Username__c = 'esidevuser';
        lstofWebServ.add(webServe);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }

        USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
        
        List<IXOSCodeMap__c> codeList = new List<IXOSCodeMap__c>{new IXOSCodeMap__c(Name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='West')};
        insert codeList;
        
         WebServiceSettings__c service1 = new WebServiceSettings__c(name='Invoice',Endpoint__c='https//:google.com.in',Username__c='testuser',Password__c='service@123',Service_Unavailable_Message__c='Unavailable',Timeout__c=120);
        insert service1;
        
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockUSLARController());
         ESC_ReferralAssignmentEngine.uslarLoad(ca.Id,null,null,true,null,null);
         Test.stopTest();
    } 
}