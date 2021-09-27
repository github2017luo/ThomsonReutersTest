/**
======================================================================================================================
TEST CLASS NAME: AccountCreateController_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the AccountCreateController class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2017-03-31            Karthi                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/
@IsTest(seeAllData=false)

private class AccountCreateController_Test{
 
    public static testMethod void testSaveAccount() {
       UnitTest.createOptiTestData();

       TestInfo oTestInfo = setupTest();
        
        oTestInfo.Account.RecordTypeId = AccountUtil.CustomerRecordTypeId;
       // insert oTestInfo.Account;
        
        boolean displayEditPage;
        PageReference oPageAccountAddress = Page.AccountCreate;
        Test.setCurrentPage(oPageAccountAddress);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oTestInfo.Account);
     //   Account oAccount = new Account();
       // Account acc1 = new Account(Name='Test1', BillingCountry ='US',BillingStreet = '555 Test Street',BillingCity = 'Dallas', BillingState='01',Industry_LMS__c='NOT APPLICABLE',BillingPostalCode = '60603-3801', Tax_Number__c='3654654654',Sales_Org__c='LLEY',Customer_Group__c= null);
        Account acc1 = new Account();
        acc1.Name='Test123';
        acc1.BillingCountry ='US';
        acc1.BillingCity = 'CARROLLTON';
        acc1.BillingState='TX';
       // acc1.RecordTypeId =cusRecordTypeId;
        acc1.Tax_Number__c='36546546';
        acc1.Sales_Org__c='FSCO';
        acc1.BillingPostalCode = '75006-2521';
        acc1.Customer_Group__c=null;
        acc1.Industry_LMS__c='NOT APPLICABLE';
        
          MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert acc1;
        Test.startTest();
        
        
        DataQualityUtil.ECMAccountInfo ECMAccountInfo = new DataQualityUtil.ECMAccountInfo();
     
        
        ECMAccountInfo.Name = 'Test123';    
        ECMAccountInfo.Street1 = '12-34';
        ECMAccountInfo.Street2 = '2395 MIDWAY RD';
        ECMAccountInfo.Country = 'US';       
        //ECMAccountInfo.State = 'TX';
        ECMAccountInfo.City = 'CARROLLTON';
        ECMAccountInfo.PostalCode = '75006-2521';
        ECMAccountInfo.AddressId = 'AB123';
       
        
        AccountCreateController oController = new AccountCreateController(oStandardController);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
         
         oController.editAction();
         
         oController.queryAccountsById(new Set<ID>{oTestInfo.Account.Id});
         oController.queryAccountsByMDBId(new Set<String>{oTestInfo.Account.Id});
         oController.isAnyrecordSelected = true;
         
         
         Profile p2 = [SELECT Id FROM Profile WHERE Name='LatAm User']; 
         User usr2 = [Select Id FROM User WHERE ProfileId =:p2.Id AND IsActive=TRUE LIMIT 1];
          System.runas(usr2){
         
        AccountCreateController.MatchedECMAccount matchedActs = new AccountCreateController.MatchedECMAccount();
        matchedActs.ECMAccountInfo = ECMAccountInfo;
        matchedActs.isSelected = true;
        oController.MatchedECMAccounts.add(matchedActs);
        oController.creatAccount();
         oController.saveSelectedAccount();
         oController.saveSelectedECMAccount();
         oController.conId = 'AB123';
         oController.updateList();
         oController.conId = 'AB134';
         oController.selId='AB134';
         oController.updateList();
         oController.continueSave();
         oController.addressCountryChanged();
         
         oController.retrySave();
         oController.doCancel();
         oController.addressCountryChanged();
         oController.addressCountryChanged();
         
         oController.onPageLoad();
         oController.save();
         oController.SkipAccountMatching = true;
         oController.ValidateAccount();
         oController.checkTaxNumberDuplicates();
         oController.checkTaxNumberDuplicatesWarn();
         try{
         oController.checkAccountAddress();
         }catch(Exception e){}
        Test.stopTest();
         
          
          }
    }
    
    
 public static TestInfo setupTest() {
 UnitTest.createOptiTestData();
     List<WebServiceSettings__c> wsList = new List<WebServiceSettings__c >();
      WebServiceSettings__c oCustomerProspectSettings = new WebServiceSettings__c();
    oCustomerProspectSettings.Name = MDBIntegrationUtil.UpsertAccountServiceName;
    oCustomerProspectSettings.Endpoint__c = 'https:\\thomsonreuters.com';
    oCustomerProspectSettings.Timeout__c = 5;
    oCustomerProspectSettings.Active__c = true;
    oCustomerProspectSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
    wsList.add(oCustomerProspectSettings);
    
    WebServiceSettings__c oAddressCleanseSettings = new WebServiceSettings__c();
    oAddressCleanseSettings.Name = DataQualityUtil.CleanseAddressServiceName;
    oAddressCleanseSettings.Endpoint__c = 'https:\\thomsonreuters.com';
    oAddressCleanseSettings.Timeout__c = 5;
    oAddressCleanseSettings.Active__c = true;
    oAddressCleanseSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
    wsList.add(oAddressCleanseSettings);
    
    WebServiceSettings__c oaccountmatchSettings = new WebServiceSettings__c();
    oaccountmatchSettings.Name = DataQualityUtil.ECMAccountMatchingServiceName;
    oaccountmatchSettings.Endpoint__c = 'https:\\thomsonreuters.com';
    oaccountmatchSettings.Timeout__c = 5;
    oaccountmatchSettings.Active__c = true;
    oaccountmatchSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
    wsList.add(oaccountmatchSettings);
    //insert wsList;
    
    List<KeyValueListStore__c> keyvalueList = new List<KeyValueListStore__c>();
    KeyValueListStore__c keyvalue = new KeyValueListStore__c();
    keyvalue.Name = 'ECM_PageSize';
    
    keyvalue.TextValue__c = '25';
    keyvalueList.add(keyvalue);
    
    KeyValueListStore__c keyvalue1 = new KeyValueListStore__c();
    keyvalue1.Name = 'ECM_PageNumber';
    
    keyvalue1.TextValue__c = '1';
    keyvalueList.add(keyvalue1);
    
    KeyValueListStore__c keyvalue2 = new KeyValueListStore__c();
    keyvalue2.Name = 'ECM_Username';
    
    keyvalue2.TextValue__c = 'admin';
    keyvalueList.add(keyvalue2);
    
    KeyValueListStore__c keyvalue3 = new KeyValueListStore__c();
    keyvalue3.Name = 'ECM_Password';
    
    keyvalue3.TextValue__c = 'admin';
    keyvalueList.add(keyvalue3);
    
    
    //insert keyvalueList;
    //Mock Response
        InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element oCustomerProspectResponse = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element();
        oCustomerProspectResponse.MDBID = 'UT001';
        
        InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType oCustomerProspectResponseType = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseType();
        oCustomerProspectResponseType.WS_CUSTPROSP_UPSERTResponseElement = oCustomerProspectResponse;
        
        UnitTest.MockWebServiceResponse.put(MDBIntegrationUtil.UpsertAccountServiceName, oCustomerProspectResponseType);
        
        //Mock Response
         DataQualityUtil.ECMAccountInfo oECMAccountInfo = new DataQualityUtil.ECMAccountInfo();
        
       
        Country__c oCountry = new Country__c();
    oCountry.Name = 'United States';
    oCountry.Country_Code__c = 'US';
    //insert oCountry;
    
    Country_Region__c oCountryRegion = new Country_Region__c();
    oCountryRegion.Country_Code__c = 'US';
    oCountryRegion.Name = 'US-TX';
    oCountryRegion.Region_Name__c = 'Texas';
    oCountryRegion.Region_Code__c = 'TX';
    //insert oCountryRegion;
    
        TestInfo oTestInfo = new TestInfo();
        oTestInfo.Account = UnitTest.getAccountInstance();
        oTestInfo.Account.Name = 'Unit Test';
        oTestInfo.Account.RecordTypeId = AccountUtil.ProspectRecordTypeId;
        oTestInfo.Account.BillingStreet = '555 Test Street';
        oTestInfo.Account.BillingCity = 'Dallas';
        oTestInfo.Account.BillingState = 'TX';
        oTestInfo.Account.BillingPostalCode = '60603-3801';
        oTestInfo.Account.BillingCountry = 'US';
        oTestInfo.Account.Sales_Org__c='FSCO';
        oTestInfo.Account.Customer_Group__c='';
        oTestInfo.Account.Tax_Number__c='3654654654';
        oTestInfo.Account.Industry_LatAm__c='NOT APPLICABLE';
        insert oTestInfo.Account;
    return oTestInfo;
    }
   
    
    //Internal Classes
    public class TestInfo {
      public Account Account {get;set;}
    }
    
    public static testMethod void accCrtPagTestMethod(){
    UnitTest.createOptiTestData();
     
            State_required_Countries__c st= new State_required_Countries__c();
            st.Country_Code__c='US';
            st.Name='ANZ';
          
            insert st;
            
            
            ZipCode_required_Countries__c zc = new ZipCode_required_Countries__c();
            zc.Country_Code__c='US';
            zc.name='ANZ';
            insert zc;
            
   
    Profile p = [SELECT Id FROM Profile WHERE Name='LatAm User']; 
    User usr = [Select Id FROM User WHERE ProfileId =:p.Id AND IsActive=TRUE LIMIT 1];
    
        System.runas(usr){
        test.StartTest();
        /* Account acc = new Account(Name='BANK OF MONTREAL', BillingCountry ='US', BillingState='02', BillingPostalCode = '60603-3801', Tax_Number__c= '12345',Sales_Org__c='LLEY',Customer_Group__c=null);
          insert acc;
  
         Account acc1 = new Account(Name='Test1', BillingCountry ='US',BillingStreet = '555 Test Street',BillingCity = 'Dallas', BillingState='01',Industry_LMS__c='NOT APPLICABLE',BillingPostalCode = '60603-3801', Tax_Number__c='3654654654',Sales_Org__c='LLEY',Customer_Group__c=null);
          insert acc1;
  */
  
  Account acc1 = new Account();
        acc1.Name='Test1';
        acc1.BillingCountry ='US';
        acc1.BillingCity = 'Dallas';
        acc1.BillingState='TX';
       // acc1.RecordTypeId =cusRecordTypeId;
        acc1.Tax_Number__c='3654';
        acc1.Sales_Org__c='FSCO';
        acc1.BillingPostalCode = '60603-3801';
        acc1.Customer_Group__c=null;
        acc1.Industry_LMS__c='NOT APPLICABLE';
        
          MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert acc1;
      
        // call out
        InformaticaAddressCleanse_WS.WS_SFDC_Address_Validation_V3Port oService = new InformaticaAddressCleanse_WS.WS_SFDC_Address_Validation_V3Port();
        oService.inputHttpHeaders_x = new Map<String, String>();
        oService.timeout_x = 1000; //1 Second
        oService.endpoint_x = 'http://unittest@thomsonreuters.com';
        oService.outputHttpHeaders_x = new Map<String,String>();
    
    //Mock Request
    InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationRequestElement_element requestElement = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationRequestElement_element();
        requestElement.Name1 = '123';
        requestElement.Street = '555 Some Street';
        requestElement.City = 'Dallas';
        requestElement.State_County = 'IL';
        requestElement.PostalCode = '60603-3801';
        requestElement.Country = 'US';
        
        //Mock Response
    InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element  responseElement = new  InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element();
    responseElement.Street = '555 SOME STREET';
        responseElement.Mailability_Score = '5';
        responseElement.Name1 = 'BANK OF MONTREAL';
        responseElement.City = 'Dallas';
        responseElement.PostalCode = '60603-3801';
        responseElement.State_County = 'IL';
        responseElement.Country = 'UNITED STATES';
        responseElement.Match_Code = '0';
        
        
      /*   AccountTaxNumSalOrgSetting__c Acctax = new AccountTaxNumSalOrgSetting__c();
            Acctax.Active__c=True;
            Acctax.Sales_Org__c='LatAm User';
            Acctax.Customer_Group_Exclude__c='LatAm User';
            Acctax.Sales_Org_warning__c='exception';
             Acctax.Name='LatAm User';
            insert Acctax;*/
                             
            
     InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType responseType = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType();
      responseType.WS_SFDC_Address_ValidationResponseElement = responseElement;
    
       UnitTest.MockWebServiceResponse.put(DataQualityUtil.CleanseAddressServiceName, responseType);
      
         PageReference pageRef = Page.AccountCreate;        
            Test.setCurrentPage(pageRef);        
            ApexPages.StandardController sc = new ApexPages.StandardController(acc1);
            AccountCreateController accContl = new AccountCreateController(sc);
            accContl.SkipAddressValidation = TRUE;
            accContl.SkipAccountMatching = TRUE;
            accContl.profilename='Elite User'; 
            accContl.isDupTaxNum=false;
            accContl.displayEditpage=false;
          
           
            accContl.onPageLoad();
            accContl.save();
            accContl.editAction();
            accContl.doCancel();
            accContl.retrySave();
            accContl.continueSave();
            accContl.addressCountryChanged();
            accContl.checkAccountAddress();
            
            accContl.creatAccount();
            accContl.saveSelectedAccount();
            accContl.saveSelectedECMAccount();
            accContl.updateList();
            accContl.checkTaxNumberDuplicatesWarn();
            accContl.checkTaxNumberDuplicates();
            accContl.ValidateAccount();
            
           
            accContl.save();
            AccountCreateController.MatchedECMAccount matchedEMCAcc = new AccountCreateController.MatchedECMAccount();
            
            matchedEMCAcc.ECMAccountInfo = new DataQualityUtil.ECMAccountInfo();
            matchedEMCAcc.isSelected = True;
            
            DataQualityUtil.AddressCleanseServiceException oaddress = new DataQualityUtil.AddressCleanseServiceException();
          
                      
            AccountCreateController.MatchedSFDCAccount matchedSFDCacc = new AccountCreateController.MatchedSFDCAccount();
            matchedSFDCacc .ECMAccountInfo = new DataQualityUtil.ECMAccountInfo();
            matchedSFDCacc .Account= acc1; 
            
        Test.StopTest();
       } 
        
    }
    
    //------
    public static testMethod void accCrtPagTestMethod1(){
         UnitTest.createOptiTestData();
         
         State_required_Countries__c st= new State_required_Countries__c();
            st.Country_Code__c='US';
            st.Name='ANZ';
            insert st;
            
            ZipCode_required_Countries__c zc = new ZipCode_required_Countries__c();
            zc.Country_Code__c='US';
            zc.name='ANZ';
            insert zc;
        
       // Id cusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='LatAm User']; 
         User usr = [Select Id FROM User WHERE ProfileId =:p.Id AND IsActive=TRUE LIMIT 1];
    
        System.runas(usr){
        test.StartTest();
       
        Account acc1 = new Account();
        acc1.Name='Test1';
        acc1.BillingCountry ='US';
        acc1.BillingCity = 'Dallas';
        acc1.BillingState='TX';
       // acc1.RecordTypeId =cusRecordTypeId;
        acc1.Tax_Number__c='36546554';
        acc1.Sales_Org__c='FSCO';
        acc1.BillingPostalCode = '60603-3801';
        acc1.Customer_Group__c=null;
        acc1.Industry_LMS__c='NOT APPLICABLE';
        
          MDBIntegrationUtil_Test.setupUpsertAccountServiceSettings();
        MDBIntegrationUtil_Test.setupMockUpsertAccountSuccessResponse();
        insert acc1;
        
      //  Account acc = new Account(Name='Test', BillingCountry ='US', BillingState='TX', RecordTypeId =cusRecordTypeId,Tax_Number__c='3654654654',Sales_Org__c='LLEY',Customer_Group__c ='');
     //   Insert acc;
       
        // WebServiceSettings__c oWebServiceSettings = WebServiceSettings__c.getInstance('DQ.CleanseAddressService');
     
       /*  AccountTaxNumSalOrgSetting__c Acctax = new AccountTaxNumSalOrgSetting__c();
         Acctax.Name = 'LatAm User';
            Acctax.Active__c=True;
            Acctax.Sales_Org__c='LLEY';
            Acctax.Customer_Group_Exclude__c='LatAm User';
            Acctax.Sales_Org_warning__c='exception';
             Acctax.Name='LatAm User';
            insert Acctax; */
              
            PageReference pageRef = Page.AccountCreate;        
            Test.setCurrentPage(pageRef);        
            ApexPages.StandardController sc = new ApexPages.StandardController(acc1);
            AccountCreateController accContl = new AccountCreateController(sc);
          
            accContl.bTaxNumChecked = False;
            accContl.onPageLoad();
            accContl.save();
            accContl.editAction();
            accContl.doCancel();
            accContl.checkTaxNumberDuplicates();
            accContl.checkTaxNumberDuplicatesWarn();
            accContl.saveSelectedAccount();
          /*  
           Profile p1 = [SELECT Id FROM Profile WHERE Name='LMS - User']; 
           User usr1 = [Select Id FROM User WHERE ProfileId =:p1.Id AND IsActive=TRUE LIMIT 1];
           System.runas(usr1){
              
                accContl.save();
          }
            */
        Test.StopTest();
       } 
    }
private static testMethod void testMatchAccountsSuccess() {
        //Setup Test
       
    }
    
}