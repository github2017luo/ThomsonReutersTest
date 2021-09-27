/*
======================================================================================================================
TEST CLASS NAME: LCRMIXOSController_Test
======================================================================================================================
=
PURPOSE:     Validates the functionality provided by the LCRMIXOSController class

CHANGE HISTORY:
======================================================================================================================
DATE              NAME              DESC
1-2-2018         Navjyoti            Created for CRM-11779
1-29-2018        Seema               Updated for CRM-11442
======================================================================================================================
*/

@isTest
public class LCRMIXOSController_Test {
    @isTest static void testOrderIXOS(){
         Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User'];
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
        
        System.runAs(testUser){
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            insert testAcc1;
            
            List <Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c= '1000175020';
            SSDwithSAPNo.Account_Name__c = testAcc1.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            ListofSSD.add(SSDwithSAPNo);
            
            Source_System_Detail__c SSDSAPNo = new Source_System_Detail__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.Source_System_Account_Number__c= '1000175020';
            SSDSAPNo.Account_Name__c = testAcc1.id;
            SSDSAPNo.Source_System_Name__c = 'LCRMGLISSD';
            SSDSAPNo.LCRM_Sales_Org__c = 'WEST';
            ListofSSD.add(SSDSAPNo);
            
            if (ListofSSD.size() > 0) {
                insert ListofSSD;
            }
                       
            list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
            WebServiceSettings__c IXOSWebserve = new WebServiceSettings__c();
            IXOSWebserve.name = 'LCRM_DocumentService';
            IXOSWebserve.Active__c = true;
            IXOSWebserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/DocumentService/DocumentService_Rest';
            IXOSWebserve.Password__c = 'Gliu$er123';
            IXOSWebserve.Service_Unavailable_Message__c = 'Document Service is not available.';
            IXOSWebserve.Timeout__c = 120;
            IXOSWebserve.Username__c = 'gliuser';
            lstofWebServ.add(IXOSWebserve);

            if (lstofWebServ.size() > 0) {
                insert lstofWebServ;
            }
                        
            
            List < IXOSDocumenttype__c > listDocumentType = new List < IXOSDocumenttype__c> ();
            IXOSDocumenttype__c docType1 = new IXOSDocumenttype__c ();
            docType1.Name ='ZSDORDPDF';
            listDocumentType.add(docType1);
            
            IXOSDocumenttype__c docType2 = new IXOSDocumenttype__c ();
            docType2.Name ='ZSDORDCUST';
            listDocumentType.add(docType2);
            
             if (listDocumentType.size() > 0) {
                insert listDocumentType ;
            }
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockLCRMOrderIXOSTest());
            ApexPages.standardController sc = new ApexPages.standardController(testAcc1);            
            Test.setCurrentPageReference(Page.LCRMIXOS_Document);
            System.currentPageReference().getParameters().put('AccId', testAcc1.Id);
            System.currentPageReference().getParameters().put('AcctSapId', SSDwithSAPNo.Source_System_Account_Number__c);
            System.currentPageReference().getParameters().put('OrderNumber', '0004874279');
            System.currentPageReference().getParameters().put('SalesOrg', 'WEST');
            System.currentPageReference().getParameters().put('MessageId', 'Order');
            LCRMIXOSController documentService = new LCRMIXOSController(sc);                       
            LCRMIXOSRequestWrapper testReqWrap = new LCRMIXOSRequestWrapper();
            LCRMIXOSResponseWrapper testResponsWrap = new LCRMIXOSResponseWrapper();
            LCRMIXOSResponseWrapper.DocumentHeader tedtDocHeader = new LCRMIXOSResponseWrapper.DocumentHeader();
            documentService.getIXOSHttpRequest();
            Test.stopTest();
        }
    }
    @isTest static void testOrderIXOSException() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales Ops User'];
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
        System.runAs(testexpUser){
            
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.SAPAccountNumber__c = '12345';
            insert oAccount; 
            
            List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c = '1000175020';
            SSDwithSAPNo.Account_Name__c = oAccount.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            ListofSSD.add(SSDwithSAPNo);
            
            if(ListofSSD.size() > 0){
               insert ListofSSD;
            }
            
            list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
            WebServiceSettings__c IXOSWebserve = new WebServiceSettings__c();
            IXOSWebserve.name = 'LCRM_DocumentService';
            IXOSWebserve.Active__c = true;
            IXOSWebserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/DocumentService/DocumentService_Rest';
            IXOSWebserve.Password__c = 'Gliu$er123';
            IXOSWebserve.Service_Unavailable_Message__c = 'Document Service is not available.';
            IXOSWebserve.Timeout__c = 120;
            IXOSWebserve.Username__c = 'gliuser';
            lstofWebServ.add(IXOSWebserve);

            if (lstofWebServ.size() > 0) {
                insert lstofWebServ;
            }
            
            List<LCRM_Exception_Handling__c> lstExceptionHandle = new List<LCRM_Exception_Handling__c>();
            LCRM_Exception_Handling__c exp = new LCRM_Exception_Handling__c();
            exp.Name = '1';
            exp.Destination_System__c = 'SAP';
            exp.Status_Code__c = '400';
            exp.Status_Description__c = 'Mandatory Elements are Missing';
            exp.Status_Reason__c = 'Missing Mandatory Elements. Please Send Valid Inputs';
            exp.UI_Error_Message_English__c = 'Missing Mandatory Elements. Please Send Valid Inputs';
            exp.Webservice_Name__c = 'LCRM_DocumentService';
            exp.Webservice_type__c = 'REST';
            lstExceptionHandle.add(exp);
            if(lstExceptionHandle.size()>0){
                insert lstExceptionHandle;
            }
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockLCRMOrderIXOSExceptionTest());
            ApexPages.standardController sc = new ApexPages.standardController(oAccount);            
            Test.setCurrentPageReference(Page.LCRMIXOS_Document);
            System.currentPageReference().getParameters().put('AccId', oAccount.Id);
            System.currentPageReference().getParameters().put('AcctSapId', '');
            System.currentPageReference().getParameters().put('OrderNumber', '0004874279');
            System.currentPageReference().getParameters().put('SalesOrg', 'WEST');
            System.currentPageReference().getParameters().put('MessageId', 'Order');
            LCRMIXOSController documentService = new LCRMIXOSController(sc);
            LCRMIXOSController.IXOSExceptionWrapper  oExcep = new LCRMIXOSController.IXOSExceptionWrapper();
            documentService.getIXOSHttpRequest();                       
            
            Test.stopTest();
            
        }
    }
    @isTest static void testOrderIXOSException2() {
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales Ops User'];
        User testexpUser = new User(
            Alias = 'Print',
            Email = 'Print1112@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'pt_BR',
            LocaleSidKey = 'pt_BR',
            ProfileId = testprofile.Id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'Print112@testorg.com'
        );
        insert testexpUser;
        System.runAs(testexpUser){
            
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.SAPAccountNumber__c = '12345';
            insert oAccount; 
            
            List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c= '1000175020';
            SSDwithSAPNo.Account_Name__c = oAccount.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            ListofSSD.add(SSDwithSAPNo);
            
            if(ListofSSD.size() > 0){
               insert ListofSSD;
            }
            
            list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
            WebServiceSettings__c IXOSWebserve = new WebServiceSettings__c();
            IXOSWebserve.name = 'LCRM_DocumentService';
            IXOSWebserve.Active__c = true;
            IXOSWebserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/DocumentService/DocumentService_Rest';
            IXOSWebserve.Password__c = 'Gliu$er123';
            IXOSWebserve.Service_Unavailable_Message__c = 'Document Service is not available.';
            IXOSWebserve.Timeout__c = 120;
            IXOSWebserve.Username__c = 'gliuser';
            lstofWebServ.add(IXOSWebserve);

            if (lstofWebServ.size() > 0) {
                insert lstofWebServ;
            }
            
            List<LCRM_Exception_Handling__c> lstExceptionHandle = new List<LCRM_Exception_Handling__c>();
            LCRM_Exception_Handling__c exp = new LCRM_Exception_Handling__c();
            exp.Name = '1';
            exp.Destination_System__c = 'SAP';
            exp.Status_Code__c = '400';
            exp.Status_Description__c = 'Mandatory Elements are Missing';
            exp.Status_Reason__c = 'Missing Mandatory Elements. Please Send Valid Inputs';
            exp.UI_Error_Message_English__c = 'Missing Mandatory Elements. Please Send Valid Inputs';
            exp.Webservice_Name__c = 'LCRM_DocumentService';
            exp.Webservice_type__c = 'REST';
            lstExceptionHandle.add(exp);
            if(lstExceptionHandle.size()>0){
                insert lstExceptionHandle;
            }
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockLCRMOrderIXOSExceptionTest2 ());
            ApexPages.standardController sc = new ApexPages.standardController(oAccount);            
            Test.setCurrentPageReference(Page.LCRMIXOS_Document);
            System.currentPageReference().getParameters().put('AccId', oAccount.Id);
            System.currentPageReference().getParameters().put('AcctSapId', '');
            System.currentPageReference().getParameters().put('OrderNumber', '0004874279');
            System.currentPageReference().getParameters().put('SalesOrg', 'WEST');
            System.currentPageReference().getParameters().put('MessageId', 'Order');
            LCRMIXOSController documentService = new LCRMIXOSController(sc);
            LCRMIXOSController.IXOSExceptionWrapper  oExcep = new LCRMIXOSController.IXOSExceptionWrapper();
            documentService.getIXOSHttpRequest();                       
            
            Test.stopTest();
            
        }
    }
    //Start: Added forCRM-11442
     @isTest static void testInvoiceIXOS(){
         Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'GLI Sales User'];
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
        
        System.runAs(testUser){
            Account testAcc1 = new Account();
            testAcc1 = UnitTest.getAccountInstance();
            testAcc1.SAPAccountNumber__c = '5491';
            insert testAcc1;
            
            List <Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c= '1000175020';
            SSDwithSAPNo.Account_Name__c = testAcc1.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            ListofSSD.add(SSDwithSAPNo);
            
           if (ListofSSD.size() > 0) {
                insert ListofSSD;
            }
                       
            list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
            WebServiceSettings__c IXOSWebserve = new WebServiceSettings__c();
            IXOSWebserve.name = 'LCRM_DocumentService';
            IXOSWebserve.Active__c = true;
            IXOSWebserve.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/DocumentService/DocumentService_Rest';
            IXOSWebserve.Password__c = 'Gliu$er123';
            IXOSWebserve.Service_Unavailable_Message__c = 'Document Service is not available.';
            IXOSWebserve.Timeout__c = 120;
            IXOSWebserve.Username__c = 'gliuser';
            lstofWebServ.add(IXOSWebserve);

            if (lstofWebServ.size() > 0) {
                insert lstofWebServ;
            }
                        
            
            List <InvoiceDocType__c> listDocumentType = new List <InvoiceDocType__c> ();
            InvoiceDocType__c docType1 = new InvoiceDocType__c ();
            docType1.Name ='WEST1';
             docType1.Doc_Types__c = 'ZSDORDPDF';
            docType1.Sales_Org__c = 'WEST';
            listDocumentType.add(docType1);
            
            InvoiceDocType__c docType2 = new InvoiceDocType__c ();
            docType2.Name ='WEST2';
            docType2.Doc_Types__c = 'ZSDORDCUST';
            docType2.Sales_Org__c = 'WEST';
            listDocumentType.add(docType2);
            
             if (listDocumentType.size() > 0) {
                insert listDocumentType ;
            }
            
            Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockLCRMInvoiceIXOSTest());
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('LCRMIXOSInvoiceMockResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            Test.setMock(HttpCalloutMock.class, mock);
            ApexPages.standardController sc = new ApexPages.standardController(SSDwithSAPNo);            
            Test.setCurrentPageReference(Page.LCRMIXOS_Document);
            System.currentPageReference().getParameters().put('AccId', testAcc1.Id);
            System.currentPageReference().getParameters().put('AcctSapId', SSDwithSAPNo.Source_System_Account_Number__c);
            System.currentPageReference().getParameters().put('OrderNumber', '0004874279');
            System.currentPageReference().getParameters().put('SalesOrg', 'WEST');
            System.currentPageReference().getParameters().put('MessageId', 'Invoice');
            System.currentPageReference().getParameters().put('SSDid', SSDwithSAPNo .Id);
            LCRMIXOSController documentService = new LCRMIXOSController(sc);                       
            LCRMIXOSResponseWrapper.DisplayIxos testdisp = new  LCRMIXOSResponseWrapper.DisplayIxos();
            documentService.getIXOSHttpRequest();
            testdisp.compareTo(documentService.displayDoc_list[0]);
             //System.assertEquals(1,documentService.displayDoc_list.size());
            System.assertEquals('6239141926',documentService.displayDoc_list[0].ContractNumber );
            
            Test.stopTest();
        }
    }
     //End: Added forCRM-11442
}