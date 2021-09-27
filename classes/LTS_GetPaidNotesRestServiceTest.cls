/********************************************************************** 
Name: LTS_GetPaidNotesRestServiceTest
====================================================== 
test class for LTS_GetPaidNotesRestService apex class
====================================================== 
The service is triggered from SSD level/get paid Button on 'GLI' layout

Method Type : POST
====================================================== 
History 
------- 
VERSION    AUTHOR             DATE             DETAIL            JIRA STory Number
1.0        Niket Kapasi    08/04/2019  Initial Development         DPS-4006
***********************************************************************/
@isTest
public class LTS_GetPaidNotesRestServiceTest {
    @isTest static void testCallout() {
        
         Profile testProfile = [Select id, name FROM Profile WHERE name = 'Tr Sales'];
        User TRUser = TestData.createTestUser();
        TRUser.Segment__c = 'Corporate';
        TRUser.Sub_Bu__c = 'Canada';
        TRUser.ProfileId = testProfile.id;
        insert TRUser;
        

        System.runAs(TRUser){
          
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.SAPAccountNumber__c = '1000000040';
            oAccount.CompanyCodeDescription__c = '0010';
            oAccount.Sales_Org__c = 'WEST';
            oAccount.DistributionChannel__c = 'W';
            oAccount.DivisionCodeDescription__c = 'W';
            oAccount.parentid =null;
            insert oAccount;
            
            List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name ='SSD1_01';        
            SSDwithSAPNo.LCRM_Sales_org__c = 'WEST';
            SSDwithSAPNo.Source_System_Account_Number__c='1000000040';
            SSDwithSAPNo.Account_Name__c=oAccount.id;
            SSDwithSAPNo.Source_System_Name__c ='LCRMGLI';
            insert SSDwithSAPNo;
            
            KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
            testLcrmSUBBU.Name = 'LCRMSubBuValues';
            testLcrmSUBBU.TextValue__c = 'USL';
            insert testLcrmSUBBU;
            
            KeyValueListStore__c testLcrmProfileName = new KeyValueListStore__c();
            testLcrmProfileName.Name = 'LCRMGLIProfileNames';
            testLcrmProfileName.TextValue__c = 'System Administrator,GLI Sales User';
            insert testLcrmProfileName;
            
           /* WebServiceSettings__c customSettingstest = new WebServiceSettings__c();
            customSettingstest.Active__c = true;
            customSettingstest.Endpoint__c = 'https://dev.api.apigarden-qa.thomsonreuters.com/ebs/collections/PaidNotes';
            customSettingstest.Name = 'LCRMGetPaidNoteRestService';
            customSettingstest.Service_Unavailable_Message__c = 'Service Unavailable';
            insert customSettingstest;*/
            
            IXOSCodeMap__c IXOSCodeMaprecord = new IXOSCodeMap__c();
            IXOSCodeMaprecord.Name = 'WEST';
            IXOSCodeMaprecord.Company_Code__c = '0010';
            IXOSCodeMaprecord.Dist_Chan_Code__c ='W';
            IXOSCodeMaprecord.Division_Code__c = 'W';
            IXOSCodeMaprecord.Sales_Org_Code__c = 'WEST';
            insert IXOSCodeMaprecord;

        Test.StartTest();
          Test.setMock(HttpCalloutMock.class, new LTS_GetPaidNotesRestMockCallout(false));            
            Test.setCurrentPageReference(Page.LTS_getPaidNotes);
 
            
            Source_System_Detail__c oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, Account_Name__r.CompanyCodeDescription__c, Account_Name__r.Sales_Org__c, Account_Name__r.DistributionChannel__c, Account_Name__r.DivisionCodeDescription__c,Account_Name__r.parentId FROM Source_System_Detail__c where id = :SSDwithSAPNo.id]; 
            //System.debug('oSSD'+oSSD);
            //IXOSCodeMap__c recordIXOSCodeMap = [Select Company_Code__c, Dist_Chan_Code__c,Division_Code__c,Sales_Org_Code__c FROM IXOSCodeMap__c WHERE Sales_Org_Code__c = 'WEST'];
            
            ApexPages.standardController sc = new ApexPages.standardController(oSSD);
            LTS_GetPaidNotesRestService ogetpaid = new LTS_GetPaidNotesRestService(sc);
            
            ogetpaid.getPaidNoteListOptions();
            
          
            
            ogetpaid.sSelectedOption = 'All';
            ogetpaid.changeDisplayGetPaidNotesList();
           ogetpaid.sSelectedOption = '6 months back';
            ogetpaid.changeDisplayGetPaidNotesList();
            ogetpaid.sSelectedOption = '6 - 12 months back';
            ogetpaid.changeDisplayGetPaidNotesList();
            ogetpaid.sSelectedOption = '12 - 18 months back';
            ogetpaid.changeDisplayGetPaidNotesList();
            ogetpaid.sSelectedOption = '18 - 24 months back';
            ogetpaid.changeDisplayGetPaidNotesList();
            ogetpaid.sSelectedOption = '';
            ogetpaid.changeDisplayGetPaidNotesList();
            List<LTS_GetPaidNotesRestService.GetPaidNotesResponses> actualList = ogetpaid.DisplayGetPaidNotesList;
            System.assertEquals(true, actualList.size()!=0);
        }
        Test.stopTest();        
    }
    
        //@@Exception
      @isTest static void testCalloutException() {
        
         Profile testProfile = [Select id, name FROM Profile WHERE name = 'Tr Sales'];
        User TRUser = TestData.createTestUser();
        TRUser.Segment__c = 'Corporate';
        TRUser.Sub_Bu__c = 'Canada';
        TRUser.ProfileId = testProfile.id;
        insert TRUser;
        

        System.runAs(TRUser){
          
            Account oAccount = UnitTest.getAccountInstance();
            oAccount.SAPAccountNumber__c = '1000000040';
            oAccount.CompanyCodeDescription__c = '0010';
            oAccount.Sales_Org__c = 'WEST';
            oAccount.DistributionChannel__c = 'W';
            oAccount.DivisionCodeDescription__c = 'W';
            oAccount.parentid =null;
            insert oAccount;
            
            List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.name ='SSD1_01';        
            SSDwithSAPNo.LCRM_Sales_org__c = 'WEST';
            SSDwithSAPNo.Source_System_Account_Number__c='1000000040';
            SSDwithSAPNo.Account_Name__c=oAccount.id;
            SSDwithSAPNo.Source_System_Name__c ='LCRMGLI';
            insert SSDwithSAPNo;
            
            KeyValueListStore__c testLcrmSUBBU = new KeyValueListStore__c();
            testLcrmSUBBU.Name = 'LCRMSubBuValues';
            testLcrmSUBBU.TextValue__c = 'USL';
            insert testLcrmSUBBU;
            
            KeyValueListStore__c testLcrmProfileName = new KeyValueListStore__c();
            testLcrmProfileName.Name = 'LCRMGLIProfileNames';
            testLcrmProfileName.TextValue__c = 'System Administrator,GLI Sales User';
            insert testLcrmProfileName;
            
           /* WebServiceSettings__c customSettingstest = new WebServiceSettings__c();
            customSettingstest.Active__c = true;
            customSettingstest.Endpoint__c = 'https://dev.api.apigarden-qa.thomsonreuters.com/ebs/collections/PaidNotes';
            customSettingstest.Name = 'LCRMGetPaidNoteRestService';
            customSettingstest.Service_Unavailable_Message__c = 'Service Unavailable';
            insert customSettingstest;*/
            
            IXOSCodeMap__c IXOSCodeMaprecord = new IXOSCodeMap__c();
            IXOSCodeMaprecord.Name = 'WEST';
            IXOSCodeMaprecord.Company_Code__c = '0010';
            IXOSCodeMaprecord.Dist_Chan_Code__c ='W';
            IXOSCodeMaprecord.Division_Code__c = 'W';
            IXOSCodeMaprecord.Sales_Org_Code__c = 'WEST';
            insert IXOSCodeMaprecord;

        Test.StartTest();
          Test.setMock(HttpCalloutMock.class, new LTS_GetPaidNotesRestMockCallout(true));            
            Test.setCurrentPageReference(Page.LTS_getPaidNotes);
            /*Account testAcc1 = [select id, parentId, SAPAccountNumber__c, CompanyCodeDescription__c, Sales_Org__c, DistributionChannel__c, DivisionCodeDescription__c from account where id = :oAccount.Id];*/
            
            Source_System_Detail__c oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, Account_Name__r.CompanyCodeDescription__c, Account_Name__r.Sales_Org__c, Account_Name__r.DistributionChannel__c, Account_Name__r.DivisionCodeDescription__c,Account_Name__r.parentId FROM Source_System_Detail__c where id = :SSDwithSAPNo.id]; 
            //System.debug('oSSD'+oSSD);
            //IXOSCodeMap__c recordIXOSCodeMap = [Select Company_Code__c, Dist_Chan_Code__c,Division_Code__c,Sales_Org_Code__c FROM IXOSCodeMap__c WHERE Sales_Org_Code__c = 'WEST'];
            
            ApexPages.standardController sc = new ApexPages.standardController(oSSD);
            LTS_GetPaidNotesRestService ogetpaid = new LTS_GetPaidNotesRestService(sc);
            
            ogetpaid.getPaidNoteListOptions();
            
          
       
            ogetpaid.sSelectedOption = 'All';
            ogetpaid.changeDisplayGetPaidNotesList();
           ogetpaid.sSelectedOption = '6 months back';
            ogetpaid.changeDisplayGetPaidNotesList();
            ogetpaid.sSelectedOption = '6 - 12 months back';
            ogetpaid.changeDisplayGetPaidNotesList();
            ogetpaid.sSelectedOption = '12 - 18 months back';
            ogetpaid.changeDisplayGetPaidNotesList();
            ogetpaid.sSelectedOption = '18 - 24 months back';
            ogetpaid.changeDisplayGetPaidNotesList();
            ogetpaid.sSelectedOption = '';
            ogetpaid.changeDisplayGetPaidNotesList();
            //List<LTS_GetPaidNotesRestService.GetPaidNotesResponses> actualList = ogetpaid.DisplayGetPaidNotesList;
            List<ApexPages.Message> errorMsg = ApexPages.getMessages();
            System.assertEquals('We are facing issue while connecting to the server. Please try again later or contact salesforce crm support.',errorMsg[0].getDetail());
        }
        Test.stopTest();        
    }

}