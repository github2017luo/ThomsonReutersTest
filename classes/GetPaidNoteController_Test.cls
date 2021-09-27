/*  *** New Test Class for S2E Optimization------PSO-1***  
 *  CHANGE HISTORY
 ====================================================
  Date         Name                    Description
  2020-03-23   Shyamsundar Shet       BMP-1592 - Added mock testing for GetPaidNoteServices
*/

@IsTest
private class GetPaidNoteController_Test {
    public static testmethod void testgetpaidnotecontroller()
    {
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.SAPAccountNumber__c = '12345';
        oAccount.CompanyCodeDescription__c = '0010';
        oAccount.Sales_Org__c = 'WEST';
        oAccount.DistributionChannel__c = 'W';
        oAccount.DivisionCodeDescription__c = 'W';
        oAccount.parentid =null;
        insert oAccount;
        
        IXOSCodeMap__c IXOSCodeMaprecord = new IXOSCodeMap__c();
        IXOSCodeMaprecord.Name = 'West';
        IXOSCodeMaprecord.Company_Code__c = '0010';
        IXOSCodeMaprecord.Dist_Chan_Code__c ='W';
        IXOSCodeMaprecord.Division_Code__c = 'W';
        IXOSCodeMaprecord.Sales_Org_Code__c = 'WEST';
        insert IXOSCodeMaprecord;
        // testAcc1.SAPAccountNumber__c = '001';
        // insert testAcc1;
        
        /*GetPaidNoteServicesWS.GetPaidNote_v2_0Port oService = new GetPaidNoteServicesWS.GetPaidNote_v2_0Port();
        oService.inputHttpHeaders_x.put('Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=');
        oService.endpoint_x = 'http://crmrocketqa.int.westgroup.com/rocketdeploy/services/GetPaidNote_v2_0Port';
        oService.timeout_x = 120;*/
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://api-test.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
            ws1.Timeout__c = 120;
        insert ws1;

        WebServiceSettings__c ws2 = new WebServiceSettings__c();
        ws2.Name = 'GetPaidNoteServices';       
        ws2.Active__c = true;
        ws2.Endpoint__c = 'https://api-test.thomsonreuters.com/boomi/getpaidnoteservice/dev/v1';
        ws2.Password__c = '$aleForce';
        ws2.Service_Unavailable_Message__c = 'Get Notes service Unavailable';
        ws2.Timeout__c = 120;
        ws2.Username__c = 'Salesforce';
        insert ws2;
        
       /* Map<string, object> mapMockWebServiceResponse;
        
        SubscriptionsWSObject.SubUserItem oSubUserItem  = new SubscriptionsWSObject.SubUserItem();
        mapMockWebServiceResponse.put('SubsUser',oSubUserItem );*/
        
        Test.StartTest();
        Test.setCurrentPageReference(Page.GetPaidNote);
        Account testAcc1 = [select id, parentId, SAPAccountNumber__c, CompanyCodeDescription__c, Sales_Org__c, DistributionChannel__c, DivisionCodeDescription__c from account where id = :oAccount.Id];
        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
        GetPaidNoteController ogetpaid = new GetPaidNoteController(sc);
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
        
        // ApexPages.standardController sc1 = new ApexPages.standardController(oAccount);
        // GetPaidNoteController gpnc= new GetPaidNoteController(sc1);
        
        Test.StopTest();
        
    }
    /*@@Desc : 'testUSLPaidNotes' method is used to test getpaid note details */
    @isTest
    static void testUSLPaidNotes(){
        
        Profile testProfile = [Select id, name FROM Profile WHERE name = 'GLI Sales User'];
         User uslUser = TestData.createTestUser();
         insert uslUser;
         System.debug('uslUser@@@'+uslUser);
        if(testProfile.id != null){
            
            User uslUser1 = [Select profileid,Sub_Bu__c FROM User Where id
            =: uslUser.id ];
           
            uslUser1.profileid  = testProfile.id;
            uslUser1.Sub_Bu__c = 'USL';
            update uslUser1;
        }
        
     
        Test.StartTest();
        system.runas(uslUser){
        
        
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
        
        IXOSCodeMap__c IXOSCodeMaprecord = new IXOSCodeMap__c();
        IXOSCodeMaprecord.Name = 'WEST';
        IXOSCodeMaprecord.Company_Code__c = '0010';
        IXOSCodeMaprecord.Dist_Chan_Code__c ='W';
        IXOSCodeMaprecord.Division_Code__c = 'W';
        IXOSCodeMaprecord.Sales_Org_Code__c = 'WEST';
        insert IXOSCodeMaprecord;
            
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        ws1.Timeout__c = 120;
        insert ws1;

        WebServiceSettings__c ws2 = new WebServiceSettings__c();
        ws2.Name = 'BigRuleCreateCustomer';       
        ws2.Active__c = true;
        ws2.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        ws2.Password__c = 'sfdconepass123';
        ws2.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        ws2.Timeout__c = 120;
        ws2.Username__c = 'Salesforce';
        insert ws2;
        
        List<GetPaidNoteServices.PaidNoteInfo> testList = new List<GetPaidNoteServices.PaidNoteInfo>();
        GetPaidNoteServices.PaidNoteInfo testPaidNote = new GetPaidNoteServices.PaidNoteInfo();
        testPaidNote.CollectorCode = 'test';
        testPaidNote.CollectorName = 'test';
        testPaidNote.CreateDt = Date.valueOf(system.today());
        testPaidNote.ModifyDt = Date.valueOf(system.today());
        testPaidNote.Note = 'test';
        testList.add(testPaidNote); 
        
        
            
        Test.setCurrentPageReference(Page.LCRMGetPaidNote);
        /*Account testAcc1 = [select id, parentId, SAPAccountNumber__c, CompanyCodeDescription__c, Sales_Org__c, DistributionChannel__c, DivisionCodeDescription__c from account where id = :oAccount.Id];*/

        Source_System_Detail__c oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, Account_Name__r.CompanyCodeDescription__c, Account_Name__r.Sales_Org__c, Account_Name__r.DistributionChannel__c, Account_Name__r.DivisionCodeDescription__c,Account_Name__r.parentId FROM Source_System_Detail__c where id = :SSDwithSAPNo.id]; 
        //System.debug('oSSD'+oSSD);
        //IXOSCodeMap__c recordIXOSCodeMap = [Select Company_Code__c, Dist_Chan_Code__c,Division_Code__c,Sales_Org_Code__c FROM IXOSCodeMap__c WHERE Sales_Org_Code__c = 'WEST'];

        ApexPages.standardController sc = new ApexPages.standardController(oSSD);
        GetPaidNoteController ogetpaid = new GetPaidNoteController(sc);

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

        system.debug('ogetpaid'+ogetpaid);
        System.assertequals(ogetpaid!=null,true);
        system.debug('ogetpaid'+ogetpaid.SAPAccountNumber);
        System.assertEquals('1000000040', String.valueof(ogetpaid.SAPAccountNumber));

        // ApexPages.standardController sc1 = new ApexPages.standardController(oAccount);
        // GetPaidNoteController gpnc= new GetPaidNoteController(sc1);

        }
        
        Test.StopTest();
        
        
    }
    @isTest
    static void testgetPaidNoteServices(){
        Test.startTest();
        GetPaidNoteServices.GetPaidNotesRequest oGetPaidNotesRequest = new GetPaidNoteServices.GetPaidNotesRequest();
        oGetPaidNotesRequest.AcctSapId= 4.0;
        oGetPaidNotesRequest.CompanyCode= 'hello';
        oGetPaidNotesRequest.SalesOrgCode= 'hello';
        oGetPaidNotesRequest.DistChanCode= 'hello';
        oGetPaidNotesRequest.DivisionCode= 'hello';
        oGetPaidNotesRequest.ModifiedDtStart= system.today();
        oGetPaidNotesRequest.ModifiedDtEnd= system.today();
        Test.stopTest();
    }
    
}