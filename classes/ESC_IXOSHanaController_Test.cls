@isTest
public class ESC_IXOSHanaController_Test {
    
    @isTest static void testESCIXOSHana(){
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
            Sub_Bu__c = 'US',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'abc123@testorg.com'
        );
        insert testUser;
        
         System.runAs(testUser){
            Account testAccount = new Account();
            testAccount = UnitTest.getAccountInstance();
            testAccount.SAPAccountNumber__c = '5491';
            insert testAccount;
            
         USL_Integration_defaults__c  uslDefault = new USL_Integration_defaults__c ();
         uslDefault.Region__c = 'USL';
         uslDefault.Segment__c = 'Professional Tax';
         uslDefault.Applicationid__c = 'ESCH';
         uslDefault.Companyid__c ='S100';
         uslDefault.Name = 'HanaIntegration';
         insert uslDefault;
          
            list<WebServiceSettings__c > lstofWebServ = new list<WebServiceSettings__c >();
            WebServiceSettings__c paymentAutoCharge    = new WebServiceSettings__c();
            paymentAutoCharge.name = 'Payment AutoCharge';
            paymentAutoCharge.Active__c = true;
            paymentAutoCharge.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge';
           // IXOSWebserve.Password__c = 'esidevuser123';
            paymentAutoCharge.Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable';
            paymentAutoCharge.Timeout__c = 6000.0;
            //IXOSWebserve.Username__c = 'ESIDevUser';
            lstofWebServ.add(paymentAutoCharge);
            
            WebServiceSettings__c paymentCredit = new WebServiceSettings__c();
            paymentCredit.name = 'PaymentCreditIncrease';
            paymentCredit.Active__c = true;
            paymentCredit.Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease';
           // IXOSWebserve.Password__c = 'esidevuser123';
            paymentCredit.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable ';
            paymentCredit.Timeout__c = 120;
            //IXOSWebserve.Username__c = 'ESIDevUser';
            lstofWebServ.add(paymentCredit);
            
            WebServiceSettings__c iXOSWebserve = new WebServiceSettings__c();
            IXOSWebserve.name = 'ESC_IXOSHana_DocumentService';
            IXOSWebserve.Active__c = true;
            IXOSWebserve.Endpoint__c = 'https://api-uat.thomsonreuters.com/ebs/document/qa/getDocumentDetails';
            IXOSWebserve.Password__c = 'esidevuser123';
            IXOSWebserve.Service_Unavailable_Message__c = 'Document Service is not available.';
            IXOSWebserve.Timeout__c = 120;
            IXOSWebserve.Username__c = 'ESIDevUser';
            lstofWebServ.add(IXOSWebserve);
            
            insert lstofWebServ;

            Source_System_Detail__c sSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c= '1000175020';
            SSDwithSAPNo.Account_Name__c = testAccount.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
            SSDwithSAPNo.BU_Segment__c = 'Professional Tax';
            SSDwithSAPNo.LCRM_Sub_BU__c = 'USL';
            insert SSDwithSAPNo;
            System.assertEquals(SSDwithSAPNo.Source_System_Name__c,'LCRMGLI','Sap No is Correct?!!');
            
           
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ESC_IXOSHanaMockResponse());
            ApexPages.standardController sc = new ApexPages.standardController(testAccount);            
            Test.setCurrentPageReference(Page.ESC_IXOSHana_Document);
            System.currentPageReference().getParameters().put('AccId', testAccount.Id);
            System.currentPageReference().getParameters().put('AcctSapId', SSDwithSAPNo.Source_System_Account_Number__c);
            System.currentPageReference().getParameters().put('ReferenceNumber', '0004874279');
            System.currentPageReference().getParameters().put('SalesOrg', 'WEST');
            ESC_IXOSHanaController documentService = new ESC_IXOSHanaController(sc);                                               
            //ESC_IXOSHanaResponseWrapper testResponsWrap = new ESC_IXOSHanaResponseWrapper();
            ESC_IXOSHanaResponseWrapper.DocumentHeader tedtDocHeader = new ESC_IXOSHanaResponseWrapper.DocumentHeader();
            tedtDocHeader.documentNumber = 'ZX';
            ESC_IXOSHanaResponseWrapper.DocumentDetails testdoc = new ESC_IXOSHanaResponseWrapper.DocumentDetails();
            testdoc.documentHeader.documentNumber = '123456'; 
            documentService.getIXOSHttpRequest();
            
            
            Test.stopTest();            
         }
    }


}