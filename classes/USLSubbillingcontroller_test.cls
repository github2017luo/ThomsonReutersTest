@isTest
public class USLSubbillingcontroller_test {
      @isTest static void testsubbillingDetails(){
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
             USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.name = 'Integrationdefaults';
        insert int1;
            
        //    USLARInvoicedetailwrapper.EsiHeader esi=new USLARInvoicedetailwrapper.EsiHeader(val.Applicationid__c,val.Companyid__c,val.Messageid__c);

             
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
             
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLSubbillingcontroller());
            PageReference pageRef = Page.USLSubBilling;
            pageRef.getParameters().put('0110160241','000010');
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(ListofSSD[0]);
            USLSubbillingcontroller controller = new USLSubbillingcontroller(sc);  
           // USLSubbillingplanwrapper wrap1 = new USLSubbillingplanwrapper ();
            USLSubbillingplanwrapper.Billingresponsewrapper wrap = new USLSubbillingplanwrapper.Billingresponsewrapper();
            USLSubbillingplanwrapper wrap1 = new USLSubbillingplanwrapper();
            USLSubbillingplanwrapper.EsiHeader esi= new USLSubbillingplanwrapper.EsiHeader('test','123');
            USLSubbillingplanwrapper.SubscriptionDetails subs = new USLSubbillingplanwrapper.SubscriptionDetails('123','456');
            USLSubbillingplanwrapper.Billingresponsewrapper bill = new USLSubbillingplanwrapper.Billingresponsewrapper();           
            USLSubbillingplanwrapper.cls_billPlanHeader clsbill = new USLSubbillingplanwrapper.cls_billPlanHeader();
            clsbill.subscriptionNumber='0110160241';
            clsbill.endDate='0000-00-00';
           // clsbill.cls_billPlanHeader();
            USLSubbillingplanwrapper.cls_subscriptionLines clssub = new USLSubbillingplanwrapper.cls_subscriptionLines();
            clssub.subscriptionLineNumber='000010';
            USLSubbillingplanwrapper.cls_billPlanInfo clsbillinfo = new USLSubbillingplanwrapper.cls_billPlanInfo();
            clsbillinfo.billPlanNumber='0000614928';
            clsbillinfo.billPlanStartDate='2001-09-25';
            clsbillinfo.billPlanEndDate='2001-09-25';
            clsbillinfo.billPlanType='Z3';
            clsbillinfo.billPlanDescription='Z3'; 
            USLSubbillingplanwrapper.cls_billPlanDetails clsbilldet = new USLSubbillingplanwrapper.cls_billPlanDetails();
            clsbilldet.settlementDate='0000-00-00';
            clsbilldet.billItemStartDate='0000-00-00';
            clsbilldet.billItemEndDate='0000-00-00';
            clsbilldet.billItemPrice='00.00';
            clsbilldet.billCurrency='USD';
            clsbilldet.block='';
            clsbilldet.billItemStatus='';
            clsbilldet.billItemType='';
            clsbilldet.manaulDateInd='';
            clsbilldet.correctionDateInd='';
            clsbilldet.paymentTerms='';
            clsbilldet.dateCategory='';
            USLSubbillingplanwrapper.cls_statusDetails clsstat = new USLSubbillingplanwrapper.cls_statusDetails();
            clsstat.statusCode='200';
            clsstat.statusDescription='Success';
            clsstat.statusDetailMessage='Get Billing Plans Success';
           // wrap.Billingresponsewrapper();
            Test.setCurrentPageReference(new PageReference('Page.USLSubBilling'));      
            Test.stopTest();
            }

       
    } 
}