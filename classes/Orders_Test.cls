/**
 * Validates the functionality provided by the Orders class
 */
@isTest
public class Orders_Test{

    @isTest static void testOrderService() {

        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'ANZ Eloqua' limit 1];
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
            testAcc1.Sales_Org__c = 'WEST';
            insert testAcc1;

            Account testAcc2 = new Account();
            testAcc2 = UnitTest.getAccountInstance();
            testAcc2.SAPAccountNumber__c = '5491344';
            testAcc1.Sales_Org__c = 'LRA';
            insert testAcc2;

            /*List <Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c = '1000000040';
            SSDwithSAPNo.Account_Name__c = testAcc1.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            SSDwithSAPNo.LCRM_Sub_BU__c = 'USL';
            ListofSSD.add(SSDwithSAPNo);

            Source_System_Detail__c SSDSAPNo = new Source_System_Detail__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.Source_System_Account_Number__c = '1000000846';
            SSDSAPNo.Account_Name__c = testAcc1.id;
            SSDSAPNo.Source_System_Name__c = 'LCRMGLISSD';
            SSDSAPNo.LCRM_Sales_Org__c = 'WEST';
            SSDwithSAPNo.LCRM_Sub_BU__c = 'LMS';
            ListofSSD.add(SSDSAPNo);

            if (ListofSSD.size() > 0) {
                insert ListofSSD;
            }*/
            
            
            List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'LCRM_GetOrder';
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/OrdersRequest_Service/ProxyService/OrderInbound/PS_OrdersRequest_REST/GetOrder';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'OrderService is unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);

            if (lstofWebServ.size() > 0) {
                insert lstofWebServ;
            }

            List<OrderType__c> listOT = new List<OrderType__c>();
            OrderType__c otAll = new OrderType__c();
            otAll.Name = 'All';
            otAll.Portuguese__c = 'Todos';
            otAll.Spanish__c = 'Todas';
            otAll.Values__c = 'ZNEW;ZPOD;ZRE;ZRNL;ZSD;';
            listOT.add(otAll);
            OrderType__c otNew = new OrderType__c();
            otNew.Name = 'New';
            otNew.Portuguese__c = 'Novos';
            otNew.Spanish__c = 'Nuevas';
            otNew.Values__c = 'ZNEW';
            listOT.add(otNew);
            if (listOT.size() > 0) {
                insert listOT;
            }

             Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockLCRMOrderServiceTest());
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMOrderServiceMockResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            Test.setCurrentPageReference(Page.LCRMOrderService);
            ApexPages.StandardController oStandardController1 = new ApexPages.StandardController(testAcc1);
            Orders oOrders = new Orders(oStandardController1);
            oOrders.pageSize = 1;
            oOrders.changeDisplayOrders();
            oOrders.nextPage();
            oOrders.updatePage();
            oOrders.previousPage();

            oOrders.sSelectedOption = 'All';
            oOrders.changeDisplayOrdersGo();
            oOrders.getOrderListOptions();
            oOrders.sSelectedOption = 'New';
            oOrders.changeDisplayOrdersGo();
            oOrders.sSelectedOption = 'All';
            oOrders.AllBegindt = system.today().addMonths(-3).format();
            oOrders.AllEnddt = system.today().format();
            oOrders.changeDisplayOrdersGo();
            
            ApexPages.StandardController oStandardController2 = new ApexPages.StandardController(testAcc2);
            Orders oOrders2 = new Orders(oStandardController2);
            oOrders2.changeDisplayOrders();
            Test.stopTest();
            System.assertEquals('0200009546',oOrders.DisplayOrders[0].OrderNo);
        }
    }


    @isTest static void testOrderServiceException() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'ANZ Eloqua' limit 1];

        User testexpUser = new User(
            Alias = 'Print',
            Email = 'Print@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'pt_BR',
            LocaleSidKey = 'pt_BR',
            ProfileId = testprofile.Id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'Print@testorg.com'
        );
        insert testexpUser;
        System.runAs(testexpUser) {
    
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.SAPAccountNumber__c = '12345';
            insert oAccount;
    
            Account oAccount2 = UnitTest.getAccountInstance();
            oAccount2.parentid = oAccount.id;
            insert oAccount2;
    
            /*List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c= '1000000040';
            SSDwithSAPNo.Account_Name__c = oAccount2.id;
            SSDwithSAPNo.Source_System_Name__c = 'WEST';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            SSDwithSAPNo.LCRM_Sub_BU__c = 'USL';
            ListofSSD.add(SSDwithSAPNo);
    
            Source_System_Detail__c SSDSAPNo = new Source_System_Detail__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.Source_System_Account_Number__c = '1000000846';
            SSDSAPNo.Account_Name__c = oAccount2.id;
            SSDSAPNo.Source_System_Name__c = 'LCRMGLISSD';
            SSDSAPNo.LCRM_Sales_Org__c = 'WEST';
            SSDwithSAPNo.LCRM_Sub_BU__c = 'USL';
            ListofSSD.add(SSDSAPNo);
    
            if(ListofSSD.size() > 0){
               insert ListofSSD;
                }*/
            List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'LCRM_GetOrder';
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/OrdersRequest_Service/ProxyService/OrderInbound/PS_OrdersRequest_REST/GetOrder';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'OrderService is unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);
    
            if (lstofWebServ.size() > 0){
                insert lstofWebServ;
            }
          List<OrderType__c> listOT = new List<OrderType__c>();
           OrderType__c otAll = new OrderType__c();
           otAll.Name = 'All';
           otAll.Portuguese__c = 'Todos';
           otAll.Spanish__c = 'Todas';
           otAll.Values__c = 'ZNEW;ZPOD;ZRE;ZRNL;ZSD;';
           listOT.add(otAll);
           OrderType__c otNew = new OrderType__c();
           otNew.Name = 'New';
           otNew.Portuguese__c = 'Novos';
           otNew.Spanish__c = 'Nuevas';
           otNew.Values__c = 'ZNEW';
           listOT.add(otNew);
           if (listOT.size() > 0) {
                 insert listOT;
           }
            List<LCRM_Exception_Handling__c> lstExceptionHandle = new List<LCRM_Exception_Handling__c>();
            LCRM_Exception_Handling__c exp = new LCRM_Exception_Handling__c();
            exp.Name = '1';
            exp.Destination_System__c = 'SAP';
            exp.Status_Code__c = '500';
            exp.Status_Description__c = 'NoOrdersFound';
            exp.Status_Reason__c = 'Sales Area information missing Or No data satisfying for input criteria';
            exp.UI_Error_Message_English__c = 'No Orders found in SAP for the selected criteria.';
            exp.Webservice_Name__c = 'LCRM_GetOrder';
            exp.Webservice_type__c = 'REST';
            lstExceptionHandle.add(exp);
            if(lstExceptionHandle.size()>0){
                insert lstExceptionHandle;
            }
            Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockLCRMOrderExceptionServiceTest());
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMOrderServiceMockException');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController1 = new ApexPages.StandardController(oAccount2);
            Orders oOrders = new Orders(oStandardController1);
            oOrders.changeDisplayOrders();
            Test.stopTest();
            System.debug('Msg'+ApexPages.getMessages());
            System.assert(ApexPages.getMessages().get(0).getDetail().contains('No Orders found in SAP for the selected criteria.'));
        }
    }
     @isTest static void testlogException() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'ANZ Eloqua' limit 1];

        User testexpUser = new User(
            Alias = 'Print',
            Email = 'Print@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'pt_BR',
            LocaleSidKey = 'pt_BR',
            ProfileId = testprofile.Id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'Print@testorg.com'
        );
        insert testexpUser;
        System.runAs(testexpUser) {
    
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.SAPAccountNumber__c = '12345';
            insert oAccount;
    
            Account oAccount2 = UnitTest.getAccountInstance();
            oAccount2.parentid = oAccount.id;
            insert oAccount2;
    
            /*List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c = '1000000040';
            SSDwithSAPNo.Account_Name__c = oAccount2.id;
            SSDwithSAPNo.Source_System_Name__c = 'WEST';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            SSDwithSAPNo.LCRM_Sub_BU__c = 'USL';
            ListofSSD.add(SSDwithSAPNo);
    
            Source_System_Detail__c SSDSAPNo = new Source_System_Detail__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.Source_System_Account_Number__c = '1000000846';
            SSDSAPNo.Account_Name__c = oAccount2.id;
            SSDSAPNo.Source_System_Name__c = 'LCRMGLISSD';
            SSDSAPNo.LCRM_Sales_Org__c = 'WEST';
            SSDwithSAPNo.LCRM_Sub_BU__c = 'USL';
            ListofSSD.add(SSDSAPNo);
    
            if(ListofSSD.size() > 0){
               insert ListofSSD;
                }*/
            List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'LCRM_GetOrder';
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/OrdersRequest_Service/ProxyService/OrderInbound/PS_OrdersRequest_REST/GetOrder';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'OrderService is unavailable';
            Webserve.Timeout__c = 120;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);
    
            if (lstofWebServ.size() > 0){
                insert lstofWebServ;
            }
          List<OrderType__c> listOT = new List<OrderType__c>();
           OrderType__c otAll = new OrderType__c();
           otAll.Name = 'All';
           otAll.Portuguese__c = 'Todos';
           otAll.Spanish__c = 'Todas';
           otAll.Values__c = 'ZNEW;ZPOD;ZRE;ZRNL;ZSD;';
           listOT.add(otAll);
           OrderType__c otNew = new OrderType__c();
           otNew.Name = 'New';
           otNew.Portuguese__c = 'Novos';
           otNew.Spanish__c = 'Nuevas';
           otNew.Values__c = 'ZNEW';
           listOT.add(otNew);
           if (listOT.size() > 0) {
                 insert listOT;
           }
            List<LCRM_Exception_Handling__c> lstExceptionHandle = new List<LCRM_Exception_Handling__c>();
            LCRM_Exception_Handling__c exp = new LCRM_Exception_Handling__c();
            exp.Name = '1';
            exp.Destination_System__c = 'SAP';
            exp.Status_Code__c = '500';
            exp.Status_Description__c = 'NoRecordsFound';
            exp.Status_Reason__c = 'Sales Area information missing Or No data satisfying for input criteria';
            exp.UI_Error_Message_English__c = 'No Orders found in SAP for the selected criteria.';
            exp.Webservice_Name__c = 'LCRM_GetOrder';
            exp.Webservice_type__c = 'REST';
            lstExceptionHandle.add(exp);
            if(lstExceptionHandle.size()>0){
                insert lstExceptionHandle;
            }
            Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockLCRMOrderExceptionServiceTest());
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMOrderServiceMockException');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.StandardController oStandardController1 = new ApexPages.StandardController(oAccount2);
            Orders oOrders = new Orders(oStandardController1);
            oOrders.changeDisplayOrders();
            Test.stopTest();
            System.assert(ApexPages.getMessages().get(0).getDetail().contains(Label.LCRMWebServiceError));
        }
    }
}