/**
======================================================================================================================
TEST CLASS NAME: AccountOnlinePasswords_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the AccountOnlinePasswords class.

CHANGE HISTORY:
 * ===================================================================================================================
 * Date         Name                    Description
 * 2012-09-13   Nandita R. Shet         Created   
 * 2016-09-29   Subhajit Karmakar       Changed settings to ESI
 * 2017-03-31   Karthi                  Optimized the coverage as per JIRA STORY: PS0-1
 * ===================================================================================================================
 */
 
@IsTest (seealldata=false)  // As part of  s2e Optimisation project making seeAllData as false [Rajashree]

private class AccountOnlinePasswords_Test {
 
    public static testMethod void testAccountOnlinePasswords() {
        UnitTest.createOptiTestData();   //  As part of  s2e Optimisation project adding test data [Priyanka]    
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '001';
        insert testAcc1;
        
              
        
        Test.starttest();
        Test.setCurrentPageReference(Page.AccountPasswords);
              
        ApexPages.standardController sc = new ApexPages.standardController(testAcc1);
        AccountOnlinePasswords oAccountOnlinePasswords = new AccountOnlinePasswords(sc);
        ContactPasswordsServices oContactPasswordServices = new ContactPasswordsServices();
        ContactPasswordsServices.AccountPasswordRequest oAccountPasswordRequest = new ContactPasswordsServices.AccountPasswordRequest();
        //oContactPasswords.displayContactPasswords();
        oAccountOnlinePasswords.exportAccountPswds();
        oAccountOnlinePasswords.getDomainListOptions();
        
        oAccountOnlinePasswords.sSelectedOption = 'COBALT';
        oAccountOnlinePasswords.displayAccountOnlinePasswords();
        oAccountOnlinePasswords.sSelectedOption = 'CLEAR';
        oAccountOnlinePasswords.displayAccountOnlinePasswords();
        oAccountOnlinePasswords.sSelectedOption = 'DRAFTING';
        oAccountOnlinePasswords.displayAccountOnlinePasswords();
        oAccountOnlinePasswords.sSelectedOption = 'EREADER';
        oAccountOnlinePasswords.displayAccountOnlinePasswords();
        oAccountOnlinePasswords.sSelectedOption = 'ORION';
        oAccountOnlinePasswords.displayAccountOnlinePasswords();
        oAccountOnlinePasswords.sSelectedOption = 'SLW';
        oAccountOnlinePasswords.displayAccountOnlinePasswords();
        
        Test.stoptest();
    }
      private static testMethod void testpaging(){
        /*
        ContactPasswordWSObjects.AccountOnlineUser oResponse﻿ = new ContactPasswordWSObjects.AccountOnlineUser();
        oResponse.StartRec = 1;
        oResponse.EndRec = 5;
        oResponse.TotalRecs = 5;
        */        
        UnitTest.createOptiTestData(); //  As part of  s2e Optimisation project adding test data [Priyanka] 
        
        ContactPasswordsServices.AccountPasswordRequest oAccountPasswordRequest = new ContactPasswordsServices.AccountPasswordRequest();
        AccountOnlinePasswords.PagingOnlineAccountPasswords oPagingOnlineAccountPasswords = new AccountOnlinePasswords.PagingOnlineAccountPasswords(oAccountPasswordRequest);
        oPagingOnlineAccountPasswords.pageSize = 2;
      //  oPagingOnlineAccountPasswords.oRequest = new ContactPasswordsServices.AccountPasswordRequest();
        oAccountPasswordRequest.Domain= 'test'; 
        // WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ContactPasswords');
         WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ContactPasswordsESI');    
        oAccountPasswordRequest.endpoint= oWebServiceSettings.Endpoint__c;
          oAccountPasswordRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
          oAccountPasswordRequest.username=oWebServiceSettings.Username__c;
          oAccountPasswordRequest.password= oWebServiceSettings.Password__c;
        oAccountPasswordRequest.AcctSAPId = 1223;
      //  oPagingOnlineAccountPasswords.oRequest.AcctSAPId.add(Decimal.valueOf('512345'));
        oAccountPasswordRequest.CompanyCode = 'test';
        oAccountPasswordRequest.SalesOrgCode = 'Westlaw';
        oAccountPasswordRequest.DistChanCode = 'test';
        oAccountPasswordRequest.DivisionCode = 'test';
        oAccountPasswordRequest.StartRec = 1;
        oAccountPasswordRequest.MaxResults = 5;
        
        List<ContactPasswordsServices.OnlineAccountUsers> listOnlineUser = new List<ContactPasswordsServices.OnlineAccountUsers>();
        
        oPagingOnlineAccountPasswords.getOnlineAccountUsers();
        oPagingOnlineAccountPasswords.getRecordCount();
        ContactPasswordsServices oContactPasswordServices = new ContactPasswordsServices();
        ContactPasswordWS.Contact_v11_0Port testPortResponse = new ContactPasswordWS.Contact_v11_0Port();
        //testPortResponse.endpoint_x = oAccountPasswordRequest.EndPoint;
        
     //   oContactPasswordServices.returnService(oAccountPasswordRequest);
        
       // ContactPasswordsServices oContactPasswordServices = new ContactPasswordsServices();
        oAccountPasswordRequest.StartRec = 1;
        listOnlineUser =  oContactPasswordServices.GetAccountPasswords(oAccountPasswordRequest);
        
        Test.StartTest();
        oPagingOnlineAccountPasswords.moveNext();
        oPagingOnlineAccountPasswords.movePrev();
        oPagingOnlineAccountPasswords.moveLast();
        oPagingOnlineAccountPasswords.moveFirst();
        Test.StopTest();
        
     }
}