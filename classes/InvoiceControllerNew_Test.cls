/**
 * ===================================================================================================
 * TEST CLASS NAME: InvoiceControllerNew_Test
 * ===================================================================================================
 * PURPOSE:   Validates the functionality provided by the InvoiceControllerNew class.

 * CHANGE HISTORY
 * ===================================================================================================
 * Date         Name                    Description
 * 2016-09-27   TCS                     Created     
 * 2017-03-31  Karthi                    Optimized the coverage as per JIRA STORY: PS0-1
 * 2018-03-28  Seema                    Updated
 * ===================================================================================================
 */

@isTest (seeAllData=false)
public class InvoiceControllerNew_Test{
 
        public static testmethod void testInvoiceController(){
        UnitTest.createOptiTestData();
        
            WebServiceSettings__c ws= new WebServiceSettings__c();
            ws.Name='Dellboomi SFDC Legal';
            ws.Username__c='Username';
            ws.Password__c='Password';
            ws.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
            ws.Service_Unavailable_Message__c='Service_Unavailable';
            insert ws;
            
            WebServiceSettings__c ws1= new WebServiceSettings__c();
            ws1.Name='InvoiceServicesMISSOA';
            ws.Username__c='Username';
            ws1.Password__c='Password';
            ws1.Endpoint__c='https://tacss.thomsonreuters.com/rocketdeploy/services/Invoice_v4_0Port';
            ws1.Service_Unavailable_Message__c='Service_Unavailable';
            insert ws1;
            
            WebServiceSettings__c ws2= new WebServiceSettings__c();
            ws2.Name='InvoiceServices';
            ws2.Username__c='Username';
            ws2.Password__c='Password';
            ws2.Endpoint__c='https://tacss.thomsonreuters.com/rocketdeploy/services/Invoice_v4_0Port';
            ws2.Service_Unavailable_Message__c='Service_Unavailable';
            insert ws2;     
            
            WebServiceSettings__c ws3= new WebServiceSettings__c();
            ws3.Name='PaymentCreditIncrease';
            ws3.Username__c='Username';
            ws3.Password__c='Password';
            ws3.Endpoint__c='https://securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
            ws3.Service_Unavailable_Message__c='Service_Unavailable';
            insert ws3; 
                    
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '1234';
        testAcc1.Sales_Org__c = 'WEST';
       //testAcc1.Dist_Chan_Code__c='1234'
        insert testAcc1;
        
         //Added as a part of S2E Optimisation Start
         IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(testAcc1.Sales_org__c);
           InvoiceDocType__c inv =InvoiceDocType__c.getinstance(testAcc1.Sales_org__c);
            InvoiceServices.InvoiceItemsRequest oRequest = new InvoiceServices.InvoiceItemsRequest(); 
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServicesMISSOA');
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oRequest.Username = oWebServiceSettings.Username__c;
            oRequest.Password = oWebServiceSettings.Password__c;
            oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();            
            oRequest.AccountSAPID = Decimal.valueOf(testAcc1.SAPAccountNumber__c);
            oRequest.CompanyCode = oIXOSCodeMap.Company_Code__c;
            oRequest.SalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            oRequest.DistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            oRequest.DivisionCode = oIXOSCodeMap.Division_Code__c;
            oRequest.OpenItemsRequested = true;
            oRequest.ClearedItemsRequested = true;
            oRequest.AdditionalTextRequested = true;
            oRequest.InvoiceBegDt = date.parse('06/27/2009');
            oRequest.InvoiceEndDt = date.parse('12/27/2009');
            //insert inv;
            InvoiceServices.InvoiceDocUrlRequest oDocrequest = new InvoiceServices.InvoiceDocUrlRequest();
            WebServiceSettings__c oWebServiceSettings1 = AppUtil.getWebServiceSettings('InvoiceServices');
            oDocrequest.EndPoint = oWebServiceSettings1.Endpoint__c;
            oDocrequest.Username = oWebServiceSettings1.Username__c;
            oDocrequest.Password = oWebServiceSettings1.Password__c;
            oDocrequest.Timeout = (oWebServiceSettings1.Timeout__c * 1000).intValue();
            oDocrequest.AccountSAPID = Integer.valueof(testAcc1.SAPAccountNumber__c);
            //Added as a part of S2E Optimisation End
            

            
            
        Test.StartTest();
            Test.setMock(HttpCalloutMock.class, new DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
            ApexPages.standardController oStandardController  = new ApexPages.standardController(testAcc1);
            InvoiceControllerNew oInvoiceController  = new InvoiceControllerNew(oStandardController);
            Test.setCurrentPageReference(Page.OpenClearedItemsPageUSL);   
            // Coverage for Cleared Items   
            oInvoiceController.sSelectedOption = 'Cleared' ;            
            oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009'); 

            // Coverage for Open Items
            oInvoiceController.sSelectedOption = 'Open' ;    
            oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009'); 

            // Coverage for Open/Due Items
            oInvoiceController.sSelectedOption = 'Open/Due' ;    
            oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009');  

            // Coverage for Open/Not Due Items
            oInvoiceController.sSelectedOption = 'Open/Not Due' ;    
            oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009');  

            // Coverage for All: Open and Cleared Items
            //oInvoiceController.sSelectedOption = 'All';
            //Positive Testing: Invoice Begin Date < Invoice End Date 
            oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009');  
            //Negative Testing: Invoice Begin Date > Invoice End Date
            oInvoiceController.getInvoiceItemList('12/27/2009', '06/27/2009');    
            //Negative Testing: Date Range filter > 180 days
            oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2010');    
            oInvoiceController.getDocUrl();
            oInvoiceController.setInvoiceDateRange();
            oInvoiceController.getInvoiceItemType();
            System.assertequals('1234',String.valueof(oInvoiceController.accountSapId));
            
        Test.StopTest();
    }
    
  
    
     public static testmethod void testInvoiceControllerSSD() {
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        
        
            WebServiceSettings__c ws= new WebServiceSettings__c();
            ws.Name='Dellboomi SFDC Legal';
            ws.Username__c='Username';
            ws.Password__c='Password';
            ws.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
            ws.Service_Unavailable_Message__c='Service_Unavailable';
            insert ws;
            
            WebServiceSettings__c ws1= new WebServiceSettings__c();
            ws1.Name='InvoiceServicesMISSOA';
            ws.Username__c='Username';
            ws1.Password__c='Password';
            ws1.Endpoint__c='https://tacss.thomsonreuters.com/rocketdeploy/services/Invoice_v4_0Port';
            ws1.Service_Unavailable_Message__c='Service_Unavailable';
            insert ws1;
            
            WebServiceSettings__c ws2= new WebServiceSettings__c();
            ws2.Name='InvoiceServices';
            ws2.Username__c='Username';
            ws2.Password__c='Password';
            ws2.Endpoint__c='https://tacss.thomsonreuters.com/rocketdeploy/services/Invoice_v4_0Port';
            ws2.Service_Unavailable_Message__c='Service_Unavailable';
            insert ws2;     
            
            WebServiceSettings__c ws3= new WebServiceSettings__c();
            ws3.Name='PaymentCreditIncrease';
            ws3.Username__c='Username';
            ws3.Password__c='Password';
            ws3.Endpoint__c='https://securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
            ws3.Service_Unavailable_Message__c='Service_Unavailable';
            ws3.Active__c=true;
            insert ws3; 
            
            WebServiceSettings__c ws4= new WebServiceSettings__c();
            ws4.Name='Payment AutoCharge';
            ws4.Username__c='Username';
            ws4.Password__c='Password';
            ws4.Endpoint__c='https://securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
            ws4.Service_Unavailable_Message__c='Service_Unavailable';
            ws4.Active__c=true;
            insert ws4;             
            
            
                            

        Account testAcc1 = new Account();
        testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '5491';
        insert testAcc1;
        
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>(); 
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name = 'SSD1_01';
        SSDwithSAPNo.Source_System_Account_Number__c= '1000000040';
        SSDwithSAPNo.Account_Name__c = testAcc1.id;
        SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
        SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
        ssdList.add(SSDwithSAPNo);
         
        Source_System_Detail__c SSDwithNoSAPNo = new Source_System_Detail__c();
        SSDwithNoSAPNo.name = 'SSD1_01';
        //SSDwithNoSAPNo.Source_System_Account_Number__c= '1000000040';
        SSDwithNoSAPNo.Account_Name__c = testAcc1.id;
        SSDwithNoSAPNo.Source_System_Name__c = 'LCRMGLI';
        SSDwithNoSAPNo.LCRM_Sales_Org__c = 'WEST';
        ssdList.add(SSDwithNoSAPNo);
        
         if(ssdList.size()>0){
             insert ssdList;
         }
         
        IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(SSDwithSAPNo.LCRM_Sales_Org__c);
        InvoiceDocType__c inv = InvoiceDocType__c.getinstance(SSDwithSAPNo.LCRM_Sales_Org__c);
        InvoiceServices.InvoiceItemsRequest oRequest = new InvoiceServices.InvoiceItemsRequest();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('InvoiceServicesMISSOA');
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Username = oWebServiceSettings.Username__c;
        oRequest.Password = oWebServiceSettings.Password__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000).intValue();
        oRequest.AccountSAPID = Decimal.valueOf(SSDwithSAPNo.Source_System_Account_Number__c);
        oRequest.CompanyCode = oIXOSCodeMap.Company_Code__c;
        oRequest.SalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
        oRequest.DistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
        oRequest.DivisionCode = oIXOSCodeMap.Division_Code__c;
        oRequest.OpenItemsRequested = true;
        oRequest.ClearedItemsRequested = true;
        oRequest.AdditionalTextRequested = true;
        oRequest.InvoiceBegDt = date.parse('06/27/2009');
        oRequest.InvoiceEndDt = date.parse('12/27/2009');
        
        InvoiceServices.InvoiceDocUrlRequest oDocrequest = new InvoiceServices.InvoiceDocUrlRequest();
        WebServiceSettings__c oWebServiceSettings1 = AppUtil.getWebServiceSettings('InvoiceServices');
        oDocrequest.EndPoint = oWebServiceSettings1.Endpoint__c;
        oDocrequest.Username = oWebServiceSettings1.Username__c;
        oDocrequest.Password = oWebServiceSettings1.Password__c;
        oDocrequest.Timeout = (oWebServiceSettings1.Timeout__c * 1000).intValue();
        oDocrequest.AccountSAPID = Integer.valueof(SSDwithSAPNo.Source_System_Account_Number__c);


        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new DellBoomiTokenGeneration_Test.DellBoomiCalloutMock());
        Test.setCurrentPageReference(Page.OpenClearedItemsPageUSL);
        
        ApexPages.standardController oStandardController1 = new ApexPages.standardController(SSDwithSAPNo);
        InvoiceControllerNew oInvoiceController = new InvoiceControllerNew(oStandardController1);
        oInvoiceController.sSelectedOption = 'Cleared';
        oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009');
        System.assertequals('1000000040',String.valueof(oInvoiceController.accountSapId));
        oInvoiceController.getDocUrl();
        oInvoiceController.setInvoiceDateRange();
        oInvoiceController.getInvoiceItemType();
            
        ApexPages.standardController oStandardController2 = new ApexPages.standardController(SSDwithNoSAPNo);
        InvoiceControllerNew oInvoiceController2 = new InvoiceControllerNew(oStandardController2);
        oInvoiceController2.sSelectedOption = 'Cleared';
        oInvoiceController2.getInvoiceItemList('06/27/2009', '12/27/2009');
        Test.StopTest();

    }

    
    
}