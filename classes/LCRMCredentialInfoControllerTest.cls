/*
@Author: Radhika Pawar
@JIRA Story: CRM-6978
@Purpose: This Page is used for Displying the Credential and IP Address Restriction Webservices Response. 
          Credential Information Page Block Section which is returning the response from ESI external system when callout is made to ‘Credential’ and IP Address Restrictionwebservice 
@Version: 2017-09-15

* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
*                                                         
* =============================================================================

*/

@isTest
private class LCRMCredentialInfoControllerTest {
     @isTest static void testCredentialSendRequest() {
        //
        User testUser = new User(
        Alias = 'sUser', 
        Email='abc1@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='Testing', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'WEST',
        Sub_Bu__c='USL',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='abc123@testorg.com'
        );
        insert testUser;
        
        System.runAs(testUser) {
        List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
        RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
        SSDRecordtype.name ='LOTUS Source Systems';       
        SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
        ListofRecordtype.add(SSDRecordtype);
        
        RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
        AccRecordtype.name ='GLI Account';       
        AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
        ListofRecordtype.add(AccRecordtype);
        
        if(ListofRecordtype.size()>0){
            insert ListofRecordtype;            
        }
        
        System.assertNotEquals(ListofRecordtype,null,'success');
        //assert
        System.assertEquals(SSDRecordtype.Name, 'LOTUS Source Systems');
        System.assertEquals(AccRecordtype.Name, 'GLI Account');
        
        //
        UnitTest.createTestData();
       
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '1000000040';       
        insert testAcc;
       
        final String strSalesOrgVal='WEST'; 
        List<Source_System_Detail__c> ListofSSDCred = new List<Source_System_Detail__c>();
        
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name ='SSDCredential';
        SSDwithSAPNo.Source_System_Account_Number__c='1000000040';
        SSDwithSAPNo.Account_Name__c=testAcc.id;
        SSDwithSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDwithSAPNo.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSDwithSAPNo);
        
        Source_System_Detail__c SSDCredSAPNo = new Source_System_Detail__c();
        SSDCredSAPNo.name ='SSD_Credential';
        SSDCredSAPNo.Source_System_Account_Number__c='1000000846';
        SSDCredSAPNo.Account_Name__c=testAcc.id;
        SSDCredSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDCredSAPNo.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSDCredSAPNo);
        
        
        Source_System_Detail__c SSD_SAPNo_Cred = new Source_System_Detail__c();
        SSD_SAPNo_Cred.name ='SSD_SAPNO_Cred';
        SSD_SAPNo_Cred.Source_System_Account_Number__c='1000564058';
        SSD_SAPNo_Cred.Account_Name__c=testAcc.id;
        SSD_SAPNo_Cred.LCRM_Sales_Org__c =strSalesOrgVal;
        SSD_SAPNo_Cred.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSD_SAPNo_Cred);
         
        if(ListofSSDCred.size()>0){
            insert ListofSSDCred;
        }
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_CredentialInfoServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/AccountService/AccountService_RestService/getCredentialInfo';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
            String json = '{'+
		'  \"getCredentialInfoResponse\" : {'+
		'    \"CredentialInfoItem\" : [ {'+
		'      \"accountNumber\" : \"1000497321\",'+
		'      \"domain\" : \"WESTLAW\",'+
		'      \"credentialProgress\" : null,'+
		'      \"credentialProgressDesc\" : null,'+
		'      \"credentialStatus\" : \"AA\",'+
		'      \"credentialStatusDesc\" : \"Approved - All\",'+
		'      \"businessType\" : null,'+
		'      \"businessTypeDesc\" : null,'+
		'      \"restrictionCls\" : null,'+
		'      \"restrictionClsDesc\" : null,'+
		'      \"progessDt\" : \"0000-00-00\",'+
		'      \"statusDt\" : \"0000-00-00\",'+
		'      \"responseStatus\" : null,'+
		'      \"responseStatusDescription\" : null'+
		'    } ],'+
		'    \"BusinessRestrictionItem\" : [ {'+
		'      \"accountNumber\" : \"1000497321\",'+
		'      \"businessRestriction\" : null,'+
		'      \"businessRestrictionDesc\" : null,'+
		'      \"responseStatus\" : \"E\",'+
		'      \"responseStatusDescription\" : \"No Data Found\"'+
		'    } ]'+
		'  }'+
		'}';
        
        LCRMCredentialInfoHelper CredentialHelper = new LCRMCredentialInfoHelper();
        CredentialHelper.getSourceSystemDetails(testAcc);
            LCRMCredentialJsonWrapper.getjsonresponse(json);
        
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LCRMCredInfoResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        //Start 
        ApexPages.currentPage().getParameters().put('id',testAcc.Id);
        String id = ApexPages.currentPage().getParameters().get('id');
        system.assertEquals(true,id!=null);
        //End
        ApexPages.standardController sc = new ApexPages.standardController(testAcc);
        LCRMCredentialInfoController oCredInfo  = new LCRMCredentialInfoController(sc);
        oCredInfo.displayCredInfoList(); 
        oCredInfo.getTabInFocus();
        String s='Credential';
        oCredInfo.setTabInFocus(s);
        oCredInfo.nextPage();
        oCredInfo.updatePage();
        oCredInfo.previousPage();
        Test.stopTest();
        
        }
     
     }
     
   @isTest static void testLCRMCredentialJsonWrapper() {
    LCRMCredentialJsonWrapper.StatusDetailcls statusDetailCls = new LCRMCredentialJsonWrapper.StatusDetailcls();
    statusDetailCls.statusCode = '400';
    statusDetailCls.statusDescription = 'Description';
    statusDetailCls.statusDetailMessage = 'Status';
    String ExceptioJsonCred ='{"getCredentialInfoResponse": {"StatusDetail": {   "statusCode": "400",   "statusDescription": "DISTRIBUTION_CHANNEL_INVALID",   "statusDetailMessage": "Distribution Channel d is Invalid"}}}';
    LCRMCredentialJsonWrapper.getSAPExceptionMesg(ExceptioJsonCred);
    
    LCRMCredentialJsonWrapper.BusinessRestrictionItemcls BusinessRestrictionItem =new LCRMCredentialJsonWrapper.BusinessRestrictionItemcls();
    BusinessRestrictionItem.accountNumber='1000564058';
    BusinessRestrictionItem.businessRestriction='EX';
    BusinessRestrictionItem.businessRestrictionDesc='Experian';
    BusinessRestrictionItem.responseStatus='S';
    BusinessRestrictionItem.responseStatusDescription='Sucess';    
    }
    /*
    *IP Restriction 
    */
    @isTest static void testLCRMIPRestrictionController(){
        List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
        RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
        SSDRecordtype.name ='LOTUS Source Systems';       
        SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
        ListofRecordtype.add(SSDRecordtype);
        
        RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
        AccRecordtype.name ='GLI Account';       
        AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
        ListofRecordtype.add(AccRecordtype);
        
        if(ListofRecordtype.size()>0){
            insert ListofRecordtype;            
        }
       
        //assert
        System.assertEquals(SSDRecordtype.Name, 'LOTUS Source Systems');
        System.assertEquals(AccRecordtype.Name, 'GLI Account');
         
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        
        List<Account> acclst =new List<Account>(); 
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '3008049939';       
        acclst.add(testAcc);
             
        Account Acc_child = new Account();
        Acc_child = UnitTest.getAccountInstance();
        Acc_child.ParentId = testAcc.Id;
        Acc_child.SAPAccountNumber__c = '3008060507';       
        acclst.add(Acc_child);
        
        if(acclst.size() > 0){
            insert acclst;          
        }
        Set<id> ListofAcct = new Set<id>();       
        for(Account acc : acclst){
            ListofAcct.add(acc.id);
        }
        
        List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
        
        
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.Source_System_Account_Number__c='3008049939';
            SSDwithSAPNo.Account_Name__c=testAcc.id; 
            SSDwithSAPNo.Source_System_Name__c ='LGLSFDCGLI';
            ListofSSD.add(SSDwithSAPNo);
             
      for(integer i=0;i<20;i++)
        {
          Source_System_Detail__c SSDwithSAPNo1 = new Source_System_Detail__c();
            SSDwithSAPNo1.Source_System_Account_Number__c='3008060507'+i;
            SSDwithSAPNo1.Account_Name__c=Acc_child.id; 
            SSDwithSAPNo1.Source_System_Name__c ='LGLSFDCGLI';
            ListofSSD.add(SSDwithSAPNo1);
           
        }
         if(ListofSSD.size()>0){
                insert ListofSSD;
        }
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_IPRestrictionServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/GetIPRestrictionService/GetIPRestriction_RestService/GetIPRestriction';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'IPRestriction Services is not available for GLI Sales User';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
        //Used for populating the Domain list for CLEAR info
        List<CredentialInfo__c> CredInfolst = new List<CredentialInfo__c>();
        CredentialInfo__c CredInfo_value = new CredentialInfo__c();
        CredInfo_value.name ='CLEAR';
        CredInfolst.add(CredInfo_value);
        
        CredentialInfo__c credentialing = new CredentialInfo__c();
        credentialing.name='CREDENTIALING';
        CredInfolst.add(credentialing);
        
        CredentialInfo__c CredInfoRFI = new CredentialInfo__c();
        CredInfoRFI.name ='RFI';
        CredInfolst.add(CredInfoRFI);
        
        if(CredInfolst.size()>0){
            insert CredInfolst;
        }
        
        LCRMCredentialInfoHelper OIPHelper = new LCRMCredentialInfoHelper();
        OIPHelper.getSourceSystemDetailsIPva(ListofAcct);
         
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockLCRMIPRestrictionTest());
        ApexPages.standardController sc = new ApexPages.standardController(Acc_child);
        LCRMCredentialInfoController oCredInfo  = new LCRMCredentialInfoController(sc);
        oCredInfo.getDomainListOptions();
        oCredInfo.sSelectedOption = 'CLEAR'; 
        oCredInfo.validDate=Date.valueof('0001-01-01'); 
        oCredInfo.displayIPInfoList();
        oCredInfo.getTabInFocus();
        String s='IPAddress';
        oCredInfo.setTabInFocus(s);
        oCredInfo.updatePageIP();
        
        LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem ipRestrictionItem = new LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem();
        ipRestrictionItem.accountNumber = '3008049939';
        ipRestrictionItem.groupType = 'EE';
        ipRestrictionItem.groupID = 2000012201;
        ipRestrictionItem.IPRestrictionType = 'SI';
        ipRestrictionItem.IPRestrictionDesc = 'Single IP';
        ipRestrictionItem.IPAddress = '123.255.255.255';
        ipRestrictionItem.IPUpper = '123.255.255.255';
        ipRestrictionItem.countryCode = null;
        ipRestrictionItem.countryDesc = null;
        ipRestrictionItem.effectiveBegDate ='2009-07-23';
        ipRestrictionItem.effectiveEndDate = '2009-12-31';
        oCredInfo.FetchRecords();
        Test.stopTest();
      }
      
    @isTest static void testLCRMIPRestrictionJsonWrapper() {
        
      LCRMIPRestrictionJsonWrapper.StatusDetailcls statusDetailCls = new LCRMIPRestrictionJsonWrapper.StatusDetailcls();
      statusDetailCls.statusCode = '400';
      statusDetailCls.statusDescription = 'Description';
      statusDetailCls.statusDetailMessage = 'Status';
      String ExceptioJsonCred ='{"GetIPRestrictionResponse": { "statusDetails":    { "statusCode": "400","statusDescription": "DOMAIN_NOT_FOUND","statusDetailMessage": null}}}';
      LCRMIPRestrictionJsonWrapper.getSAPExceptionMesg(ExceptioJsonCred);
       LCRMIPRestrictionJsonWrapper.getSAPExceptionMesg(null);  
      LCRMIPRestrictionJsonWrapper.getMatchedCredentialRecord(null);
      LCRMIPRestrictionJsonWrapper.getCredentialReqJsonString(null, null, null, null, null);
         
    }
 //Exception Messg
  @isTest static void testCredExceptionRes() {
        //
        User testUserexp = new User(
        Alias = 'EUser', 
        Email='ExceptionTest@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='GLI', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'West',
        Sub_Bu__c='Usl',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='ExceptionTest@testorg.com'
        );
        insert testUserexp;
        System.runAs(testUserexp) {
        List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
        RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
        SSDRecordtype.name ='LOTUS Source Systems';       
        SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
        ListofRecordtype.add(SSDRecordtype);
        
        RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
        AccRecordtype.name ='GLI Account';       
        AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
        ListofRecordtype.add(AccRecordtype);
        
        if(ListofRecordtype.size()>0){
            insert ListofRecordtype;            
        }
        //assert
        System.assertEquals(SSDRecordtype.Name, 'LOTUS Source Systems');
        System.assertEquals(AccRecordtype.Name, 'GLI Account');
        
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        
        //
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '549';       
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.SAP_Contact_ID__c = null;
        insert testcontact;
        
        final String strSalesOrgVal='WEST'; 
        List<Source_System_Detail__c> ListofSSDCred = new List<Source_System_Detail__c>();
        
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name ='SSD_01';
        SSDwithSAPNo.Source_System_Account_Number__c='1000000040';
        SSDwithSAPNo.Account_Name__c=testAcc.id;
        SSDwithSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDwithSAPNo.Source_System_Name__c ='LCRMGLI';
        ListofSSDCred.add(SSDwithSAPNo);
        
        Source_System_Detail__c SSDCredSAPNo = new Source_System_Detail__c();
        SSDCredSAPNo.name ='SSD_02';
        SSDCredSAPNo.Source_System_Account_Number__c='1000000846';
        SSDCredSAPNo.Account_Name__c=testAcc.id;
        SSDCredSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDCredSAPNo.Source_System_Name__c ='LCRMGLISSD';
        ListofSSDCred.add(SSDCredSAPNo);
        
        
        Source_System_Detail__c SSD_SAPNo_Cred = new Source_System_Detail__c();
        SSD_SAPNo_Cred.name ='SSD_03';
        SSD_SAPNo_Cred.Source_System_Account_Number__c='1000564058';
        SSD_SAPNo_Cred.Account_Name__c=testAcc.id;
        SSD_SAPNo_Cred.LCRM_Sales_Org__c =strSalesOrgVal;
        SSD_SAPNo_Cred.Source_System_Name__c ='LCRMGLISSD';
        ListofSSDCred.add(SSD_SAPNo_Cred);
         
        if(ListofSSDCred.size()>0){
            insert ListofSSDCred;
        }
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_CredentialInfoServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/AccountService/AccountService_RestService/getCredentialInfo';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
        System.assertEquals(WebserveCred.Name, 'LCRM_CredentialInfoServices');
        System.assertEquals(WebserveCred.Active__c, true);
        
        LCRMCredentialInfoHelper CredentialHelper = new LCRMCredentialInfoHelper();
        CredentialHelper.getSourceSystemDetails(testAcc);
        
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockLCRMCredInfoExceptionTest());
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LCRMCredentialException');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.standardController sc = new ApexPages.standardController(testAcc);
        LCRMCredentialInfoController oCredInfo  = new LCRMCredentialInfoController(sc);
        oCredInfo.displayCredInfoList(); 
        oCredInfo.FetchRecords();
        Test.stopTest(); 
        
        }
     }     
     
     // No SSD Record for Credential Web service
     @isTest static void testCredentialwithoutSSD() {
        //
        User testUserexp = new User(
        Alias = 'EUser', 
        Email='ExceptionTest@testorg.com',
        EmailEncodingKey='UTF-8', 
        LastName='GLI', 
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        ProfileId = userinfo.getProfileid(),
        Sales_Org__c = 'West',
        Sub_Bu__c='Usl',
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='ExceptionTest@testorg.com'
        );
        insert testUserexp;
        System.runAs(testUserexp) {
        List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
        RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
        SSDRecordtype.name ='LOTUS Source Systems';       
        SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
        ListofRecordtype.add(SSDRecordtype);
        
        RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
        AccRecordtype.name ='GLI Account';       
        AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
        ListofRecordtype.add(AccRecordtype);
        
        if(ListofRecordtype.size()>0){
            insert ListofRecordtype;            
        }
        
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        
        //
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '1000000040';       
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.SAP_Contact_ID__c = null;
        insert testcontact;
        
        final String strSalesOrgVal='WEST'; 
        List<Source_System_Detail__c> ListofSSDCred = new List<Source_System_Detail__c>();
        
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name ='SSDCredential';
        SSDwithSAPNo.Account_Name__c=testAcc.id;
        SSDwithSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDwithSAPNo.Source_System_Name__c ='ExcpLGLSFDCGLI';
        ListofSSDCred.add(SSDwithSAPNo);
        
         if(ListofSSDCred.size()>0){
            insert ListofSSDCred;
        }
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_CredentialInfoServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/AccountService/AccountService_RestService/getCredentialInfo';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
        
        Integration_Logger__c IntegrtLog = new Integration_Logger__c();
        IntegrtLog.Object_Name__c = 'Source System Detail';
        IntegrtLog.Exception_Message__c = 'No records found';
        IntegrtLog.Request_Message__c = 'There are no SSD record for the Account';
        insert IntegrtLog;
        
        LCRMCredentialInfoHelper CredentialHelper = new LCRMCredentialInfoHelper();
        CredentialHelper.getSourceSystemDetails(testAcc);
        
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LCRMCredInfoResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.standardController sc = new ApexPages.standardController(testAcc);
        LCRMCredentialInfoController oCredInfo  = new LCRMCredentialInfoController(sc);
        oCredInfo.displayCredInfoList(); 
        Test.stopTest();
        }
     }
      
     // No SSD Record for IPRestriction Web service
     @isTest static void testIPAddressReswithoutSSD() {
        //
        List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
        RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
        SSDRecordtype.name ='LOTUS Source Systems';       
        SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
        ListofRecordtype.add(SSDRecordtype);
        
        RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
        AccRecordtype.name ='GLI Account';       
        AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
        ListofRecordtype.add(AccRecordtype);
        
        if(ListofRecordtype.size()>0){
            insert ListofRecordtype;            
        }
        
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        
        //
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '1000000040';       
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.SAP_Contact_ID__c = null;
        insert testcontact;
        
        final String strSalesOrgVal='WEST'; 
        List<Source_System_Detail__c> ListofSSDCred = new List<Source_System_Detail__c>();
        
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name ='SSDCredential';
        SSDwithSAPNo.Account_Name__c=testAcc.id;
        SSDwithSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDwithSAPNo.Source_System_Name__c ='ExcpLGLSFDCGLI';
        ListofSSDCred.add(SSDwithSAPNo);
        
         if(ListofSSDCred.size()>0){
            insert ListofSSDCred;
        }
        
       List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_IPRestrictionServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/GetIPRestrictionService/GetIPRestriction_RestService/GetIPRestriction';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'IPRestriction Services is not available for GLI Sales User';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
        
        Integration_Logger__c IntegrtLog = new Integration_Logger__c();
        IntegrtLog.Object_Name__c = 'Source System Detail';
        IntegrtLog.Exception_Message__c = 'No records found';
        IntegrtLog.Request_Message__c = 'There are no SSD record for the Account';
        insert IntegrtLog;
        
        LCRMCredentialInfoHelper CredentialHelper = new LCRMCredentialInfoHelper();
        CredentialHelper.getSourceSystemDetails(testAcc);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockLCRMIPRestrictionTest ());
        ApexPages.standardController sc = new ApexPages.standardController(testAcc);
        LCRMCredentialInfoController oCredInfo  = new LCRMCredentialInfoController(sc);
        oCredInfo.sSelectedOption = '';
        oCredInfo.displayIPInfoList(); 
        Test.stopTest();
     }  
     //Callout Exception from IPRestriction 
     @isTest static void testLCRMIPRestcalloutexception(){
    List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
    RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
    SSDRecordtype.name ='LOTUS Source Systems';       
    SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
    ListofRecordtype.add(SSDRecordtype);

    RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
    AccRecordtype.name ='GLI Account';       
    AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
    ListofRecordtype.add(AccRecordtype);

    if(ListofRecordtype.size()>0){
    insert ListofRecordtype;            
    }

    UnitTest.createTestData();
    UnitTest.createOptiTestData();

    List<Account> acclst =new List<Account>(); 
    Account testAcc = new Account();
    testAcc = UnitTest.getAccountInstance();
    testAcc.SAPAccountNumber__c = '3008049939';       
    acclst.add(testAcc);

    Account Acc_child = new Account();
    Acc_child = UnitTest.getAccountInstance();
    Acc_child.ParentId = testAcc.Id;
    Acc_child.SAPAccountNumber__c = '3008060507';       
    acclst.add(Acc_child);

    if(acclst.size() > 0){
    insert acclst;          
    }
    Set<id> ListofAcct = new Set<id>();       
    for(Account acc : acclst){
        ListofAcct.add(acc.id);
    }
    for(Account acc : acclst){
        ListofAcct.add(acc.id);
        ListofAcct.add(acc.ParentId);    
    }
    List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();

    Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
    SSDwithSAPNo.Source_System_Account_Number__c='3008049939';
    SSDwithSAPNo.Account_Name__c=testAcc.id; 
    SSDwithSAPNo.Source_System_Name__c ='LGLSFDCGLI';
    ListofSSD.add(SSDwithSAPNo);

    Source_System_Detail__c SSDwithSAPNo1 = new Source_System_Detail__c();
    SSDwithSAPNo1.Source_System_Account_Number__c='3008060507';
    SSDwithSAPNo1.Account_Name__c=Acc_child.id; 
    SSDwithSAPNo1.Source_System_Name__c ='LGLSFDCGLI';
    ListofSSD.add(SSDwithSAPNo1);
    if(ListofSSD.size()>0){
    insert ListofSSD;
    }

    List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
    WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
    WebserveCred.name = 'LCRM_IPRestrictionServices';       
    WebserveCred.Active__c = true;
    WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/GetIPRestrictionService/GetIPRestriction_RestService/GetIPRestriction';
    WebserveCred.Password__c = 'Gliu$er1234';
    WebserveCred.Service_Unavailable_Message__c = 'IPRestriction Services is not available for GLI Sales User';
    WebserveCred.Timeout__c = 120;
    WebserveCred.Username__c = 'gliuserIP';
    lstofWebServ.add(WebserveCred);

    if(lstofWebServ.size()>0){
    insert lstofWebServ;
    }
    //Used for populating the Domain list for CLEAR info
    List<CredentialInfo__c> CredInfolst = new List<CredentialInfo__c>();
    CredentialInfo__c CredInfo_value = new CredentialInfo__c();
    CredInfo_value.name ='CLEAR';
    CredInfolst.add(CredInfo_value);

    CredentialInfo__c credentialing = new CredentialInfo__c();
    credentialing.name='CREDENTIALING';
    CredInfolst.add(credentialing);

    CredentialInfo__c CredInfoRFI = new CredentialInfo__c();
    CredInfoRFI.name ='RFI';
    CredInfolst.add(CredInfoRFI);

    if(CredInfolst.size()>0){
    insert CredInfolst;
    }

    LCRMCredentialInfoHelper OIPHelper = new LCRMCredentialInfoHelper();
    OIPHelper.getSourceSystemDetailsIPva(ListofAcct);

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockLCRMIPRestrictionTest());
    ApexPages.standardController sc = new ApexPages.standardController(Acc_child);
    LCRMCredentialInfoController oCredInfo  = new LCRMCredentialInfoController(sc);
    oCredInfo.getDomainListOptions();
    oCredInfo.sSelectedOption = 'CREDENTIALING';
    oCredInfo.strValidityDateIP = '2009-08-27';       
    oCredInfo.displayIPInfoList();  
    Test.stopTest();
   }
   
   
   //Credential callout
 
 @isTest static void testCredCalloutException() {
        //
        List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
        RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
        SSDRecordtype.name ='LOTUS Source Systems';       
        SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
        ListofRecordtype.add(SSDRecordtype);
        
        RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
        AccRecordtype.name ='GLI Account';       
        AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
        ListofRecordtype.add(AccRecordtype);
        
        if(ListofRecordtype.size()>0){
            insert ListofRecordtype;            
        }
        
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        
        //
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '543';       
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.SAP_Contact_ID__c = null;
        insert testcontact;
        
        final String strSalesOrgVal='WEST'; 
        List<Source_System_Detail__c> ListofSSDCred = new List<Source_System_Detail__c>();
        
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name ='SSDCredential';
        SSDwithSAPNo.Source_System_Account_Number__c='1000000040';
        SSDwithSAPNo.Account_Name__c=testAcc.id;
        SSDwithSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDwithSAPNo.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSDwithSAPNo);
        
        Source_System_Detail__c SSDCredSAPNo = new Source_System_Detail__c();
        SSDCredSAPNo.name ='SSD_Credential';
        SSDCredSAPNo.Source_System_Account_Number__c='1000000846';
        SSDCredSAPNo.Account_Name__c=testAcc.id;
        SSDCredSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDCredSAPNo.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSDCredSAPNo);
        
        
        Source_System_Detail__c SSD_SAPNo_Cred = new Source_System_Detail__c();
        SSD_SAPNo_Cred.name ='SSD_SAPNO_Cred';
        SSD_SAPNo_Cred.Source_System_Account_Number__c='1000664058';
        SSD_SAPNo_Cred.Account_Name__c=testAcc.id;
        SSD_SAPNo_Cred.LCRM_Sales_Org__c =strSalesOrgVal;
        SSD_SAPNo_Cred.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSD_SAPNo_Cred);
         
        if(ListofSSDCred.size()>0){
            insert ListofSSDCred;
        }
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_CredentialInfoServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/GetIPRestrictionService/GetIPRestriction_RestService/GetIPRestriction';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
        
        LCRMCredentialInfoHelper CredentialHelper = new LCRMCredentialInfoHelper();
        CredentialHelper.getSourceSystemDetails(testAcc);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockLCRMIPRestrictionTest()); 
        ApexPages.standardController sc = new ApexPages.standardController(testAcc);
        LCRMCredentialInfoController oCredInfo  = new LCRMCredentialInfoController(sc);
        oCredInfo.displayCredInfoList();
        Test.stopTest();  
     }  
     
     @isTest static void testCredentialInternalErrorRequest() {
        //
        List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
        RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
        SSDRecordtype.name ='LOTUS Source Systems';       
        SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
        ListofRecordtype.add(SSDRecordtype);
        
        RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
        AccRecordtype.name ='GLI Account';       
        AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
        ListofRecordtype.add(AccRecordtype);
        
        if(ListofRecordtype.size()>0){
            insert ListofRecordtype;            
        }
        //assert
        System.assertEquals(SSDRecordtype.Name, 'LOTUS Source Systems');
        System.assertEquals(AccRecordtype.Name, 'GLI Account');
        
        
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        
        //
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '1000000040';       
        insert testAcc;
        
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'testContact';
        testcontact.FirstName = 'testContact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        testcontact.SAP_Contact_ID__c = null;
        insert testcontact;
                
        final String strSalesOrgVal='west'; 
        List<Source_System_Detail__c> ListofSSDCred = new List<Source_System_Detail__c>();
        
        Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
        SSDwithSAPNo.name ='SSDCredential';
        SSDwithSAPNo.Source_System_Account_Number__c='1000000040';
        SSDwithSAPNo.Account_Name__c=testAcc.id;
        SSDwithSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDwithSAPNo.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSDwithSAPNo);
        
        Source_System_Detail__c SSDCredSAPNo = new Source_System_Detail__c();
        SSDCredSAPNo.name ='SSD_Credential';
        SSDCredSAPNo.Source_System_Account_Number__c='1000000846';
        SSDCredSAPNo.Account_Name__c=testAcc.id;
        SSDCredSAPNo.LCRM_Sales_Org__c =strSalesOrgVal;
        SSDCredSAPNo.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSDCredSAPNo);
        
        
        Source_System_Detail__c SSD_SAPNo_Cred = new Source_System_Detail__c();
        SSD_SAPNo_Cred.name ='SSD_SAPNO_Cred';
        SSD_SAPNo_Cred.Source_System_Account_Number__c='1000564058';
        SSD_SAPNo_Cred.Account_Name__c=testAcc.id;
        SSD_SAPNo_Cred.LCRM_Sales_Org__c =strSalesOrgVal;
        SSD_SAPNo_Cred.Source_System_Name__c ='LGLSFDCGLI';
        ListofSSDCred.add(SSD_SAPNo_Cred);
         
        if(ListofSSDCred.size()>0){
            insert ListofSSDCred;
        }
        
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_CredentialInfoServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/AccountService/AccountService_RestService/getCredentialInfo';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
        
        LCRMCredentialInfoHelper CredentialHelper = new LCRMCredentialInfoHelper();
        CredentialHelper.getSourceSystemDetails(testAcc);
        
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockLCRMCredInfoExceptionTest ());
        
        StaticResourceCalloutMock Omock = new StaticResourceCalloutMock();
        Omock.setStaticResource('LCRMCredentialException');
        Omock.setStatusCode(400);
        Omock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, Omock);
        ApexPages.standardController sc = new ApexPages.standardController(testAcc);
        LCRMCredentialInfoController oCredInfo  = new LCRMCredentialInfoController(sc);
        oCredInfo.displayCredInfoList();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LCRMCredentialException');
        mock.setStatusCode(400);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.standardController sc01 = new ApexPages.standardController(testAcc);
        LCRMCredentialInfoController oCredentialInfo  = new LCRMCredentialInfoController(sc01);
        oCredentialInfo.displayCredInfoList(); 
        
        Test.stopTest();
     }
     
    /*
    IPAddressRestriction
    */
     @isTest static void testLCRMIPResInternalExcepController(){
        List<RecordtypeIds__c> ListofRecordtype = new List<RecordtypeIds__c>();
        RecordtypeIds__c SSDRecordtype = new RecordtypeIds__c ();
        SSDRecordtype.name ='LOTUS Source Systems';       
        SSDRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Source_System_Detail__c' AND DeveloperName = 'USL_Source_Systems' LIMIT 1].Id;
        ListofRecordtype.add(SSDRecordtype);
        
        RecordtypeIds__c AccRecordtype = new RecordtypeIds__c ();
        AccRecordtype.name ='GLI Account';       
        AccRecordtype.recTypeId__c = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'GLI_Account' LIMIT 1].Id;
        ListofRecordtype.add(AccRecordtype);
        
        if(ListofRecordtype.size()>0){
            insert ListofRecordtype;            
        }
       
        //assert
        System.assertEquals(SSDRecordtype.Name, 'LOTUS Source Systems');
        System.assertEquals(AccRecordtype.Name, 'GLI Account');
         
        UnitTest.createTestData();
        UnitTest.createOptiTestData();
        
        List<Account> acclst =new List<Account>(); 
        Account testAcc = new Account();
        testAcc = UnitTest.getAccountInstance();
        testAcc.SAPAccountNumber__c = '3008049939';       
        acclst.add(testAcc);
             
        Account Acc_child = new Account();
        Acc_child = UnitTest.getAccountInstance();
        Acc_child.ParentId = testAcc.Id;
        Acc_child.SAPAccountNumber__c = '3008060507';       
        acclst.add(Acc_child);
         
        Account Acc_child1 = new Account();
         
        if(acclst.size() > 0){
            insert acclst;          
        }
        Set<id> ListofAcct = new Set<id>();       
        for(Account acc : acclst){
            ListofAcct.add(acc.id);
        }
         ListofAcct.add(Acc_child.id);
         ListofAcct.add(Acc_child.ParentId);
         List<Source_System_Detail__c> ListofSSD = new List<Source_System_Detail__c>();
        
        
            Source_System_Detail__c SSDwithSAPNo = new Source_System_Detail__c();
            SSDwithSAPNo.Source_System_Account_Number__c='3008049939';
            SSDwithSAPNo.Account_Name__c=testAcc.id; 
            SSDwithSAPNo.Source_System_Name__c ='LGLSFDCGLI';
            ListofSSD.add(SSDwithSAPNo);
             
      for(integer i=0;i<20;i++)
        {
          Source_System_Detail__c SSDwithSAPNo1 = new Source_System_Detail__c();
            SSDwithSAPNo1.Source_System_Account_Number__c='3008060507'+i;
            SSDwithSAPNo1.Account_Name__c=Acc_child.id; 
            SSDwithSAPNo1.Source_System_Name__c ='LGLSFDCGLI';
            ListofSSD.add(SSDwithSAPNo1);
           
        }
         if(ListofSSD.size()>0){
                insert ListofSSD;
        }
        List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_IPRestrictionServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/GetIPRestrictionService/GetIPRestriction_RestService/GetIPRestriction';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'IPRestriction Services is not available for GLI Sales User';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
        //Used for populating the Domain list for CLEAR info
        List<CredentialInfo__c> CredInfolst = new List<CredentialInfo__c>();
        CredentialInfo__c CredInfo_value = new CredentialInfo__c();
        CredInfo_value.name ='CLEAR';
        CredInfolst.add(CredInfo_value);
        
        CredentialInfo__c credentialing = new CredentialInfo__c();
        credentialing.name='CREDENTIALING';
        CredInfolst.add(credentialing);
        
        CredentialInfo__c CredInfoRFI = new CredentialInfo__c();
        CredInfoRFI.name ='RFI';
        CredInfolst.add(CredInfoRFI);
        
        if(CredInfolst.size()>0){
            insert CredInfolst;
        }
        
        LCRMCredentialInfoHelper OIPHelper = new LCRMCredentialInfoHelper();
        OIPHelper.getSourceSystemDetailsIPva(ListofAcct);
         
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockLCRMIPRestrictionExceptionTest());
        ApexPages.standardController sc = new ApexPages.standardController(Acc_child);
        LCRMCredentialInfoController IPAddressInfo  = new LCRMCredentialInfoController(sc);
        IPAddressInfo.getDomainListOptions();
        IPAddressInfo.sSelectedOption = 'CLEAR'; 
        IPAddressInfo.displayIPInfoList();
        IPAddressInfo.getTabInFocus();
        String s ='IPAddress';
         IPAddressInfo.ExceptionIPRestriction=false;
        Test.stopTest();
         
         
       
      }
      
 }