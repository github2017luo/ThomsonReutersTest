/**
 * Validates the functionality provided by the LCRMOrderDetailController class
 *
 * @author  Seema Nagdev
 * @version 2017-11-10
 */

@istest (seealldata=false)
public class LCRMOrderDetail_Test {
      @isTest static void testOrderDetails(){
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User' limit  1];
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

        System.runAs(testUser) {
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            insert testAcc1;

            Account testAcc2 = new Account();
            testAcc2 = UnitTest.getAccountInstance();
            testAcc2.SAPAccountNumber__c = '5491344';
            insert testAcc2;

            List < Source_System_Detail__c > ListofSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c = '1000000040';
            SSDwithSAPNo.Account_Name__c = testAcc1.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            ListofSSD.add(SSDwithSAPNo);

            Source_System_Detail__c SSDSAPNo = new Source_System_Detail__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.Source_System_Account_Number__c = '1000000846';
            SSDSAPNo.Account_Name__c = testAcc1.id;
            SSDSAPNo.Source_System_Name__c = 'LCRMGLISSD';
            SSDSAPNo.LCRM_Sales_Org__c = 'WEST';
            ListofSSD.add(SSDSAPNo);

            if (ListofSSD.size() > 0) {
                insert ListofSSD;
            }
            Product2 prod = new Product2();
            prod.ProductCode = '41477272';
            prod.Name = 'TestProduct';
            //prod.CurrencyIsoCode = 'USD - U.S. Dollar'; 
            insert prod;
    
    
            
            List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'LCRM_GetOrderDetail';       
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/OrdersRequest_Service/ProxyService/OrderInbound/PS_OrdersRequest_REST/GetOrderDetails';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'OrderDetail Service is unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);
            
            if(lstofWebServ.size()>0){
                insert lstofWebServ;
            }
    
           Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockLCRMOrderDetailServiceTest());
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMOrderDetailMockResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
            Test.setCurrentPageReference(Page.LCRMOrderDetail);
            LCRMOrderDetailController oOrders = new LCRMOrderDetailController(sc);
            oOrders.getOrderDetails();
            Test.stopTest();
            System.assertEquals('41477272', oOrders.odItems[0].MaterialNumber);
           
            }
    } 
    
    @isTest static void testOrderDetailException(){
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User' limit 1];
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

        System.runAs(testUser) {
            Account oAccount= new Account();
            oAccount = UnitTest.getAccountInstance();
            oAccount.SAPAccountNumber__c = '5491';
            insert oAccount;

            List < Source_System_Detail__c > ListofSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c = '1000000040';
            SSDwithSAPNo.Account_Name__c = oAccount.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            ListofSSD.add(SSDwithSAPNo);

            Source_System_Detail__c SSDSAPNo = new Source_System_Detail__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.Source_System_Account_Number__c = '1000000846';
            SSDSAPNo.Account_Name__c = oAccount.id;
            SSDSAPNo.Source_System_Name__c = 'LCRMGLISSD';
            SSDSAPNo.LCRM_Sales_Org__c = 'WEST';
            ListofSSD.add(SSDSAPNo);

            if (ListofSSD.size() > 0) {
                insert ListofSSD;
            }

           
            List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'LCRM_GetOrderDetail';       
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/OrdersRequest_Service/ProxyService/OrderInbound/PS_OrdersRequest_REST/GetOrderDetails';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'OrderDetail Service is unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);
            
            if(lstofWebServ.size()>0){
                insert lstofWebServ;
            }
            List<LCRM_Exception_Handling__c> lstExceptionHandle = new List<LCRM_Exception_Handling__c>();
            LCRM_Exception_Handling__c exp = new LCRM_Exception_Handling__c();
            exp.Name = '1';
            exp.Destination_System__c = 'SAP';
            exp.Status_Code__c = '400';
            exp.Status_Description__c = 'SalesDocNotFound';
            exp.Status_Reason__c = 'Sales doc not found by doc #';
            exp.UI_Error_Message_English__c = 'No Order Details found in SAP for the selected order.';
            exp.Webservice_Name__c = 'LCRM_GetOrderDetail';
            exp.Webservice_type__c = 'REST';
            lstExceptionHandle.add(exp);
             if(lstExceptionHandle.size()>0){
                insert lstExceptionHandle;
            }
            
            Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockLCRMOrderDetailExceptionTest());
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMOrderDetailMockException');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController1 = new ApexPages.StandardController(oAccount);
            LCRMOrderDetailController oOrders = new LCRMOrderDetailController(oStandardController1);
            oOrders.getOrderDetails();
            Test.stopTest(); 
            System.assertEquals('SalesDocNotFound', oOrders.ExceptionMesginfo.statusDescription);
            } 
    } 

     @isTest static void testOrderDetailExceptionLogger(){
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User' limit 1];
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

        System.runAs(testUser) {
            Account oAccount= new Account();
            oAccount = UnitTest.getAccountInstance();
            oAccount.SAPAccountNumber__c = '5491';
            insert oAccount;

            List < Source_System_Detail__c > ListofSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c = '1000000040';
            SSDwithSAPNo.Account_Name__c = oAccount.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            ListofSSD.add(SSDwithSAPNo);

            if (ListofSSD.size() > 0) {
                insert ListofSSD;
            }

           
            List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'LCRM_GetOrderDetail';       
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/OrdersRequest_Service/ProxyService/OrderInbound/PS_OrdersRequest_REST/GetOrderDetails';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'OrderDetail Service is unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);
            
            if(lstofWebServ.size()>0){
                insert lstofWebServ;
            }
            List<LCRM_Exception_Handling__c> lstExceptionHandle = new List<LCRM_Exception_Handling__c>();
            LCRM_Exception_Handling__c exp = new LCRM_Exception_Handling__c();
            exp.Name = '1';
            exp.Destination_System__c = 'SAP';
            exp.Status_Code__c = '400';
            exp.Status_Description__c = 'Invalid documentID';
            exp.Status_Reason__c = 'Sales doc not found by doc #';
            exp.UI_Error_Message_English__c = 'No Order Details found in SAP for the selected order.';
            exp.Webservice_Name__c = 'LCRM_GetOrderDetail';
            exp.Webservice_type__c = 'REST';
            lstExceptionHandle.add(exp);
             if(lstExceptionHandle.size()>0){
                insert lstExceptionHandle;
            }
            
             Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockLCRMOrderDetailExceptionTest2());
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMOrderDetailMockException');
            mock.setStatusCode(400);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController1 = new ApexPages.StandardController(oAccount);
            LCRMOrderDetailController oOrders = new LCRMOrderDetailController(oStandardController1);
            oOrders.getOrderDetails();
            Test.stopTest(); 
            System.assert(ApexPages.getMessages().get(0).getDetail().contains(Label.LCRMWebServiceError)); 
            } 
    } 

    
    
}