@isTest
public class USL_WestLawContactController_Test {
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

            List <LCRM_Contact_SSD__c> ListofSSD = new List <LCRM_Contact_SSD__c>();
            LCRM_Contact_SSD__c SSDwithSAPNo = new LCRM_Contact_SSD__c();
            SSDwithSAPNo.name = 'SSD1_01';
            SSDwithSAPNo.LCRM_Source_Contact_Id__c = '1000000040';
                           
            ListofSSD.add(SSDwithSAPNo);

            LCRM_Contact_SSD__c SSDSAPNo = new LCRM_Contact_SSD__c();
            SSDSAPNo.name = 'SSD1_02';
            SSDSAPNo.LCRM_Source_Contact_Id__c = '1000000846';
            USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
        int1.Applicationid__c = 'ESCU';
        int1.Companyid__c = 'WEST';
        int1.domainid__c = 'COBALT';
        int1.name = 'Integrationdefaults';
        insert int1;
            
            ListofSSD.add(SSDSAPNo);

            if (ListofSSD.size() > 0) {
                insert ListofSSD;
                  }
             /*   List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
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
            }
*/               
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockUSL_WestLawContactController());
            PageReference pageRef = Page.USL_WestLawContactPage;
            pageRef.getParameters().put('invoice','6118005220');
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(ListofSSD[0]);
            USL_WestLawContactController controller = new USL_WestLawContactController(sc);        
            Test.stopTest();
            }
    } 
    
   @isTest static void testInvoiceDetailswrapper(){
         USL_Integration_defaults__c int2 = new USL_Integration_defaults__c();
        int2.Applicationid__c = 'ESCU';
        int2.Companyid__c = 'WEST';
        int2.domainid__c = 'COBALT';
        int2.name = 'Integrationdefaults';
        insert int2;
       USL_WestLawContactController.WLConRequest wlc= new USL_WestLawContactController.WLConRequest();
           wlc.domain='';          
       
       USL_WestLawContactController.cls_esiHeader clsesi= new USL_WestLawContactController.cls_esiHeader();
           clsesi.applicationId='';
           clsesi.messageId='';
       
       USL_WestLawContactController.cls_Notification clsntf= new USL_WestLawContactController.cls_Notification();
           clsntf.statusCode='';
           clsntf.statusDescription='';
       
       USL_WestLawContactController.cUserPreferences cUser= new USL_WestLawContactController.cUserPreferences();
           cUser.contactNumber='';
           cUser.customerNumber='';
           cUser.domain='';
           cUser.guid='';
           cUser.startTime='';
       
       USL_WestLawContactController.cpreference cPref= new USL_WestLawContactController.cpreference();
           cPref.endDate='';
           cPref.prefDesc='';
           cPref.prefName='';
           cPref.prefValue='';
           cPref.startDate='';
           
       USL_WestLawContactController.responsewrapper reswrap= new USL_WestLawContactController.responsewrapper();
           reswrap.errorMessage='';
       
       USL_WestLawContactController.WLresponse wlres=new USL_WestLawContactController.WLresponse();
           wlres.Notification=clsntf;
           wlres.esiHeader=clsesi;
           
            }
}