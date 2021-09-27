@isTest
public class USLARinvoicecontroller_test {
      @isTest static void testInvoiceDetails(){
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
			
			Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
            List < Source_System_Detail__c > ListofSSD = new List < Source_System_Detail__c > ();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.Source_System_Account_Number__c = '1000000040';
            SSDwithSAPNo.Account_Name__c = testAcc1.id;
            SSDwithSAPNo.Source_System_Name__c = 'LCRMGLI';
            SSDwithSAPNo.LCRM_Sales_Org__c = 'WEST';
			
			SSDwithSAPNo.RecordtypeId=ssdRecorType;
			  SSDwithSAPNo.City__c = 'BANGALORE';
			  SSDwithSAPNo.Account_Inactive__c = false;
			  SSDwithSAPNo.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
			  SSDwithSAPNo.LCRM_SAP_Account_Number__c = '1004284494';  
			  SSDwithSAPNo.LCRM_APTS_Band_Number__c= 1;
			  SSDwithSAPNo.APTS_Customer_Category__c = '3';
			  SSDwithSAPNo.LCRM_eOutput_Eligibility__c= '';
			  SSDwithSAPNo.State__c = 'California';
			  SSDwithSAPNo.Digital_Firm_Name__c = 'test';
			  SSDwithSAPNo.Digital_Billing_City__c = 'testcity';
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
			SSDSAPNo.RecordtypeId=ssdRecorType;
			
			  SSDSAPNo.City__c = 'BANGALORE';
			  SSDSAPNo.Account_Inactive__c = false;
			  SSDSAPNo.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
			  SSDSAPNo.LCRM_SAP_Account_Number__c = '1004284494';  
			  SSDSAPNo.LCRM_APTS_Band_Number__c= 1;
			  SSDSAPNo.APTS_Customer_Category__c = '3';
			  SSDSAPNo.LCRM_eOutput_Eligibility__c= '';
			  SSDSAPNo.State__c = 'California';
			  SSDSAPNo.Digital_Firm_Name__c = 'test';
			  SSDSAPNo.Digital_Billing_City__c = 'testcity';
            ListofSSD.add(SSDSAPNo);

            if (ListofSSD.size() > 0) {
                insert ListofSSD;
                  }
              /*  List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
            WebServiceSettings__c Webserve = new WebServiceSettings__c();
            Webserve.name = 'LCRM_GetOrderDetail';       
            Webserve.Active__c = true;
            Webserve.Endpoint__c = 'https://api.thomsonreuters.com/ebs/invoice/qa/getInvoiceOpenClearedItems';
            Webserve.Password__c = 'esidevuser123';
            Webserve.Service_Unavailable_Message__c = 'OrderDetail Service is unavailable';
            Webserve.Timeout__c = 1000;
            Webserve.Username__c = 'esidevuser';
            lstofWebServ.add(Webserve);
            
            if(lstofWebServ.size()>0){
                insert lstofWebServ;
            }*/
               
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSLARdetailcontroller());
            PageReference pageRef = Page.USLArdetailpage;
            pageRef.getParameters().put('invoice','6118005220');
            pageRef.getParameters().put('ssdId',ListofSSD[0].id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(ListofSSD[0]);
            USLARdetailcontroller controller = new USLARdetailcontroller(sc);        

            }
            /* USLARInvoicedetailwrapper USLARtest = new USLARInvoicedetailwrapper();  
        USLARInvoicedetailwrapper.ARrequest Arreq = new USLARInvoicedetailwrapper.ARrequest();
        Arreq.invoiceNumber='13456';
        */
       
    } 
}