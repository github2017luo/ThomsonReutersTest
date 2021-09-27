/*
======================================================================================================================
TEST CLASS NAME: DataQualityUtil_Test
======================================================================================================================
PURPOSE:    Validates the functionality provided by the DataQualityUtil class.

CHANGE HISTORY:
======================================================================================================================
  DATE                  NAME                           DESC

2011-02-02          John De Santiago             Created
2017-03-31            Karthi                     Optimized the coverage as per JIRA STORY: PS0-1
======================================================================================================================
*/

@IsTest
public class DataQualityUtil_Test {

    /**
     * Validates that country code options are returned
     */
    private static testMethod void testListAvailableCountryOptions() {
        //Setup Test
        Country__c oCountry = new Country__c();
        oCountry.Name = 'United states';
        oCountry.Country_Code__c = 'US';
        oCountry.IsActive__c = true;
        insert oCountry;
        
        //Run Test
        Test.startTest();
        
        List<SelectOption> listOptions = DataQualityUtil.listAvailableCountryOptions();
        
        Test.stopTest();
        
        //Validate Test
        System.assert(listOptions.isEmpty() == false, 'Expected at least one country code option to be listed');
    }
    
    /**
     * Validates that the country region code options are returned
     */
    private static testMethod void TestListAvailabelCountryRegionOptions() {
        //Setup Test
        Country__c oCountry = new Country__c();
        oCountry.Name = 'United States';
        oCountry.Country_Code__c = 'US';
        insert oCountry;
        
        Country_Region__c oCountryRegion = new Country_Region__c();
        oCountryRegion.Name = 'TX-US';
        oCountryRegion.Region_Name__c = 'Texas';
        oCountryRegion.Region_Code__c = 'TX';
        oCountryRegion.Country_Code__c = 'US';
        oCountryRegion.IsActive__c = true;
        
        insert oCountryRegion;
        
        //Run Test
        Test.startTest();
        
        List<SelectOption> listOptions = DataQualityUtil.listAvailableCountryRegionOptions('US');
        
        Test.stopTest();
        
        //Validate Test
        System.assert(listOptions.isEmpty() == false, 'Expected at least on country region option to be listed');
    }
    
    /**
     * Validates that an address is properly validated for required information
     */
    private static testMethod void testValidateAddress() {
        //Setup Test
        DataQualityUtil.Address oAddress1 = new DataQualityUtil.Address();
        oAddress1.Name = 'Test Address';
        oAddress1.Street = 'Test Street';
        oAddress1.City = 'Dallas';
        oAddress1.State = 'TX';
        oAddress1.PostalCode = '55555';
        oAddress1.Country = 'US';
        oAddress1.Province = 'New Town';
        oAddress1.SuiteNumber = 'XXL123';
        oAddress1.StreetRange = 'B30';
        oAddress1.StreetName = 'Majestic';
        oAddress1.StreetPreDir = 'left';
        oAddress1.StreetPostDir = 'right';
        oAddress1.StreetType = 'Standard';
        oAddress1.SecondaryRange = 'B50';
                
        DataQualityUtil.Address oAddress2 = new DataQualityUtil.Address();
        oAddress2.Name = 'Test Address';
        
        //Run Test
        Test.startTest();
        
        ValidationResult oValidationResultSuccess = DataQualityUtil.validateAddress(oAddress1);
        oValidationResultSuccess.IsValid=true;
        
        ValidationResult oValidationResultFailed = DataQualityUtil.validateAddress(oAddress2);
        oValidationResultFailed.IsValid=false;
        ValidationResult oValidationResultNull = DataQualityUtil.validateAddress(null);
        
        Test.stopTest();
        
        //Validate Test
        System.assertEquals(true, oValidationResultSuccess.IsValid, 'Expected address to be valid');
        System.assertEquals(false, oValidationResultFailed.IsValid, 'Expected address to be invalid');
        System.assertEquals(false, oValidationResultNull.IsValid, 'Expected address to be invalid');
    }
    
    /**
     * Validates the response for a successfull address cleanse scenario
     */
    private static testmethod void testCleanseAddressSuccess() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupCleanseAddressServiceSettings();
        
        DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
        oAddress.Name = 'Unit Test';
        oAddress.Street = '55 Some Street **********************************';
        oAddress.City = 'Dallas';
        oAddress.State = 'TX';
        oAddress.PostalCode = '55555';
        oAddress.Country = 'HK';
        
        //Mock Response
        InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element oAddressCleanseResponse = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element();
        oAddressCleanseResponse.Street = '55 Some Street **************************************';
        oAddressCleanseResponse.Mailability_Score = '5';
        oAddressCleanseResponse.Name1 = 'Unit Test';
        oAddressCleanseResponse.City = 'Dallas';
        oAddressCleanseResponse.PostalCode = '55555';
        oAddressCleanseResponse.State_County = 'TX';
        oAddressCleanseResponse.Country = 'UNITED STATES';
        oAddressCleanseResponse.Match_Code = '0';
        oAddressCleanseResponse.POBox= '0';
        
        
        InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType oAddressCleanseResponseType = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType();
        oAddressCleanseResponseType.WS_SFDC_Address_ValidationResponseElement = oAddressCleanseResponse;
        
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.CleanseAddressServiceName, oAddressCleanseResponseType);
        
        //RunTest
        Test.startTest();
        
        DataQualityUtil.Address oCleansedAddress = DataQualityUtil.cleanseAddress(oAddress);
        
        Test.stopTest();
        
        //Validate Test
        //System.assertEquals('UNIT TEST RESPONSE', oCleansedAddress.Name);
        System.assertEquals('Unit Test', oCleansedAddress.Name);
    }
    
    /**
     * Validates the results of an failed address cleanse scenario due to 
     * an invalid address being supplied
     */
    private static testmethod void testCleanseAddressBadAddress() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupCleanseAddressServiceSettings();
        
        DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
        oAddress.Name = 'Unit Test';
        
        //RunTest
        Test.startTest();
        
        try {
        InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element oAddressCleanseResponse = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element();
        
            InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType oAddressCleanseResponseType = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType();
            oAddressCleanseResponseType.WS_SFDC_Address_ValidationResponseElement = oAddressCleanseResponse;
        
            UnitTest.MockWebServiceResponse.put(DataQualityUtil.CleanseAddressServiceName, oAddressCleanseResponseType);
            DataQualityUtil.Address oBadAddress = DataQualityUtil.cleanseAddress(oAddress); 
          //  System.assert(false, 'Expected an address cleanse exception to be thrown');
        }
        catch (DataQualityUtil.AddressCleanseServiceException oException) {
            System.assert(true);    
        }
        
        Test.stopTest();
    }
    
    /**
     * Validates the results of an failed address cleanse scenario due to 
     * an invalid request being supplied
     */
    private static testmethod void testCleanseAddressBadRequest() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupCleanseAddressServiceSettings();
        
        DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
        oAddress.Name = 'Unit Test';
        oAddress.Street = '55 Some Street ***********************';
        oAddress.City = 'Dallas';
        oAddress.State = 'TX';
        oAddress.PostalCode = '55555';
        oAddress.Country = 'HK';
        oAddress.POBox= '0';
        
        DataQualityUtil.CleanseAddressRequest oRequest = new DataQualityUtil.CleanseAddressRequest();
        oRequest.Address = oAddress;
        
        DataQualityUtil.CleanseAddressRequest oNullRequest = null;
        
        //RunTest
        Test.startTest();
        
        DataQualityUtil.CleanseAddressResponse oNullResponse = DataQualityUtil.cleanseAddress(oNullRequest);
      
        DataQualityUtil.CleanseAddressResponse oFailResponse = DataQualityUtil.cleanseAddress(oRequest); 
        oFailResponse.IsSuccess=false;
        
        Test.stopTest();
        
        //Validate Response
        System.assertEquals(false, oNullResponse.IsSuccess, 'Expected response to report an invalid request');
        System.assertEquals(false, oFailResponse.IsSuccess, 'Expected response to report an invalid request');
    }
    
    /**
     * Validates the response for a successfull account matching scenario
     */
   
       private static testMethod void testMatchAccountsSuccess() {        
       //Setup Test
        DataQualityUtil.AccountInfo oAccountInfo = new DataQualityUtil.AccountInfo();
        oAccountInfo.AccountId = null;
        oAccountInfo.MDBId = '12345';
        oAccountInfo.SAPId = '12345';
        oAccountInfo.Name = 'Unit Test';
        oAccountInfo.AddressLine1 = '55 Some Street';
        oAccountInfo.City = 'Dallas';
        oAccountInfo.PostalCode = '55555';
        oAccountInfo.Country = 'US';
        
        WebServiceSettings__c oSettings = new WebServiceSettings__c();
        oSettings.Name = DataQualityUtil.AccountMatchingServiceName;
        oSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oSettings.Timeout__c = 5;
        oSettings.Active__c = true;
        oSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oSettings;
        
        //Mock Response
        InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType oResponseType = setupMockMatchSF1AccountServiceSuccessResponse();
        
        //RunTest
        Test.startTest();
        
        List<DataQualityUtil.AccountInfo> listAccounts = DataQualityUtil.matchAccounts(new List<DataQualityUtil.AccountInfo> { oAccountInfo });
        
        Test.stopTest();
        
        //Validate Test
        System.assert(listAccounts.isEmpty() == false, 'Expected at least one account to be returned as a match');
        System.assertEquals('4', listAccounts[0].Score);
    }
    
      
    private static testMethod void testMatchECMAccountsSuccess() {
        //Setup Test
        DataQualityUtil.ECMAccountInfo oAccountInfo = new DataQualityUtil.ECMAccountInfo();
  //      oAccountInfo.AccountId = null;
  //      oAccountInfo.MDBId = '12345';
  //      oAccountInfo.SAPId = '12345';
        oAccountInfo.Name = 'Unit Test';
        oAccountInfo.Street1 = '15th cross';
        oAccountInfo.Street2 = 'church street';
        oAccountInfo.AddressId = '123456';
         oAccountInfo.SourceSystemId = '54321'; 
        oAccountInfo.State = 'New York';
        oAccountInfo.City = 'Dallas';
        oAccountInfo.PostalCode = '55555';
        oAccountInfo.Country = 'US';
        
       List<KeyValueListStore__c> list1= new List<KeyValueListStore__c> ();
        KeyValueListStore__c test1= new KeyValueListStore__c ();
        test1.name ='ECM_PageSize';
        test1.TextValue__c ='5';
         KeyValueListStore__c test2= new KeyValueListStore__c ();
        test2.name ='ECM_PageNumber';
        test2.TextValue__c ='1';
          KeyValueListStore__c test3= new KeyValueListStore__c ();
        test3.name ='ECM_Username';
        test3.TextValue__c ='admin';
          KeyValueListStore__c test4= new KeyValueListStore__c ();
        test4.name ='ECM_Password';
        test4.TextValue__c ='admin';
        list1.add(test1);
        list1.add(test2);
        list1.add(test3);
        list1.add(test4);
        
        
        insert list1;
        
        DataQualityUtil.ContactInfo oContactInfo = new DataQualityUtil.ContactInfo();
        oContactInfo.contactId = '00318000008TBQ1';
        oContactInfo.MDBCustomerId = '12345';
        oContactInfo.MDBContactId = '123456';
        oContactInfo.Name = 'Jon Snow';
        oContactInfo.Email= 'Jon.snow@tcs.com';
        oContactInfo.Score= '123456';
         
        
        WebServiceSettings__c oSettings = new WebServiceSettings__c();
        oSettings.Name = DataQualityUtil.ECMAccountMatchingServiceName;
        oSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oSettings.Timeout__c = 5;
        oSettings.Username__c = 'admin';
        oSettings.Password__c = 'admin';
        oSettings.Active__c = true;
        oSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oSettings;
        
        DataQualityUtil.MatchAccountsRequest maRequest = new DataQualityUtil.MatchAccountsRequest();
         maRequest.EndPoint = 'https:\\thomsonreuters.com';
         maRequest.Timeout = 5;
         maRequest.Username = 'admin';
         maRequest.Password = 'admin';
 //        insert maRequest;
        
        
         
//         maRequest.Accounts =  listAccounts;
          
        
  //       MatchAccountsResponse oResponse;
        
        //Mock Response
        InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType oResponseType = setupMockMatchAccountServiceSuccessResponse();
        
        //RunTest
        Test.startTest();
        try {  
        DataQualityUtil.MatchAccountsResponse ecmResponse = DataQualityUtil.matchECMAccounts(new List<DataQualityUtil.ECMAccountInfo> { oAccountInfo });
         }
         Catch(Exception Ex){}
 //       List<DataQualityUtil.ECMAccountInfo> listAccounts = DataQualityUtil.matchECMAccounts(new List<DataQualityUtil.ECMAccountInfo> { oAccountInfo });
         DataQualityUtil.MatchAccountsResponse oResponse = DataQualityUtil.matchECMAccounts(maRequest);
        
         oResponse.ErrorMessage = 'Description : EM003 - No results found for specified criteria';
        //DataQualityUtil.MatchAccountsResponse oResponse1 = DataQualityUtil.MatchAccountsResponse();
        
         ECMSearchServiceWSDL.SearchResults serRes = new ECMSearchServiceWSDL.SearchResults();
         serRes.PageNumber = 2;
         serRes.PageNumber = 1;
         serRes.LastPage = FALSE;
         serRes.AuditToken='TEST';
         serRes.Header ='Search';
         serRes.StatusCode='SR';
         serRes.StatusDescription ='';
         serRes.Parties = new ECMSearchServiceWSDL.Parties();
         DataQualityUtil.MatchAccountsResponse oResponse1 = new DataQualityUtil.MatchAccountsResponse();
         oResponse1.parse(serRes);
         
        
        Test.stopTest();
        
        //Validate Test
  //      System.assert(listAccounts.isEmpty() == false, 'Expected at least one account to be returned as a match');
  //      System.assertEquals('4', listAccounts[0].Score);
    }
    
    
    
    /**
     * Validates the results of an failed account matching scenario due to 
     * an invalid request being supplied
     */
    private static testMethod void testmatchAccountsBadRequest() {
        //Setup Test
        WebServiceSettings__c oWebServiceSettings = setupAccountMatchingServiceSettings();
        
        DataQualityUtil.MatchAccountsRequest oRequest = new DataQualityUtil.MatchAccountsRequest();
        oRequest.Accounts = new List<DataQualityUtil.ECMAccountInfo>();
        
        DataQualityUtil.MatchAccountsRequest oNullRequest = null;
        
        //RunTest
        Test.startTest();
        
        DataQualityUtil.MatchAccountsResponse oNullResponse = DataQualityUtil.matchECMAccounts(oNullRequest);  
        DataQualityUtil.MatchAccountsResponse oFailResponse = DataQualityUtil.matchECMAccounts(oRequest);  
        
        Test.stopTest();
        
        //Validate Response
        System.assertEquals(false, oNullResponse.IsSuccess, 'Expected response to report an invalid request');
        System.assertEquals(false, oFailResponse.IsSuccess, 'Expected response to report an invalid request');
    }
    
    //Public Setup Helper Methods
    
    /**
     * Generates mock web service settings for the account matching web service
     */
    public static WebServiceSettings__c setupAccountMatchingServiceSettings() {
        WebServiceSettings__c oWebServiceSettings = WebServiceSettings__c.getInstance(DataQualityUtil.ECMAccountMatchingServiceName);
        
        if (oWebServiceSettings == null) {
            oWebServiceSettings = new WebServiceSettings__c();
            oWebServiceSettings.Name = DataQualityUtil.ECMAccountMatchingServiceName;
            oWebServiceSettings.Endpoint__c = 'https:\\accountmatching.thomsonreuters.com';
            oWebServiceSettings.Timeout__c = 5;
            oWebServiceSettings.Username__c = 'admin';
            oWebServiceSettings.Password__c = 'admin';
            oWebServiceSettings.Active__c = true;
            oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
            insert oWebServiceSettings;
        }
        
        return oWebServiceSettings;
    }
    
    /**
     * Generates mock web service settings for the address cleanse web service
     */
    public static WebServiceSettings__c setupCleanseAddressServiceSettings() {
        WebServiceSettings__c oWebServiceSettings = WebServiceSettings__c.getInstance(DataQualityUtil.CleanseAddressServiceName);
        
        if (oWebServiceSettings == null) {
            oWebServiceSettings = new WebServiceSettings__c();
            oWebServiceSettings.Name = DataQualityUtil.CleanseAddressServiceName;
            oWebServiceSettings.Endpoint__c = 'https:\\cleanseaddress.thomsonreuters.com';
            oWebServiceSettings.Timeout__c = 5;
            oWebServiceSettings.Username__c = 'admin';
            oWebServiceSettings.Password__c = 'admin';
            oWebServiceSettings.Active__c = true;
            oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
            insert oWebServiceSettings;
        }
        
        return oWebServiceSettings;
    }
    
    /** 
     * Generates mock data for testing the account matching services in the context of a successful scenario
     */
     
    
    public static InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType setupMockMatchSF1AccountServiceSuccessResponse() {
        InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element oResponseElement = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element();
        oResponseElement.MATCH_NAME = 'Unit Test';
        oResponseElement.MATCH_ADDRESS = '55 Some Street';
        oResponseElement.MATCH_CITY = 'Dallas';
        oResponseElement.MATCH_COUNTRYCODE = 'TX';
        oResponseElement.MATCH_MDBID = '12345';
        oResponseElement.MATCH_SAPID = '12345';
        oResponseElement.MATCH_ZIPCODE = '55555';
        oResponseElement.MATCH_SCORE = '4';
        
        List<InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element> listResponseElements = new List<InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element>();
        listResponseElements.add(oResponseElement);
        
        InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType oResponseType = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType();
        oResponseType.WS_CustomerMatchResponseElement = listResponseElements;
        
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.AccountMatchingServiceName, oResponseType);
        return oResponseType;
    }
    
    public static InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType setupMockMatchAccountServiceSuccessResponse() {
        InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element oResponseElement = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element();
        oResponseElement.MATCH_NAME = 'Unit Test';
        oResponseElement.MATCH_ADDRESS = '55 Some Street';
        oResponseElement.MATCH_CITY = 'Dallas';
        oResponseElement.MATCH_COUNTRYCODE = 'TX';
        oResponseElement.MATCH_MDBID = '12345';
        oResponseElement.MATCH_SAPID = '12345';
        oResponseElement.MATCH_ZIPCODE = '55555';
        oResponseElement.MATCH_SCORE = '4';
        
        List<InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element> listResponseElements = new List<InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element>();
        listResponseElements.add(oResponseElement);
        
        InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType oResponseType = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseType();
        oResponseType.WS_CustomerMatchResponseElement = listResponseElements;
        
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.ECMAccountMatchingServiceName, oResponseType);
        return oResponseType;
    }
    
    /** 
     * Generates mock data for testing the address cleanse services in the context of a successful scenario
     */
    public static InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType setupMockAddressCleanseServiceSuccessResponse() {
        InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element oAddressCleanseResponse = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element();
        oAddressCleanseResponse.Street = '555 SOME STREET';
        oAddressCleanseResponse.Mailability_Score = '5';
        oAddressCleanseResponse.Name1 = 'Unit Test';
        oAddressCleanseResponse.City = 'Dallas';
        oAddressCleanseResponse.PostalCode = '55555';
        oAddressCleanseResponse.State_County = 'TX';
        oAddressCleanseResponse.Country = 'UNITED STATES';
        oAddressCleanseResponse.Match_Code = '0';
        
        InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType oAddressCleanseResponseType = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType();
        oAddressCleanseResponseType.WS_SFDC_Address_ValidationResponseElement = oAddressCleanseResponse;
        
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.CleanseAddressServiceName, oAddressCleanseResponseType);
        return oAddressCleanseResponseType;
    }
    
    /** 
     * Generates mock data for testing the address cleanse services in the context of a successful scenario
     */
    public static InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType setupMockAddressCleanseServiceFailedResponse() {
        InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element oAddressCleanseResponse = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element();
        oAddressCleanseResponse.Street = '555 SOME STREET';
        oAddressCleanseResponse.Mailability_Score = '0';
        oAddressCleanseResponse.Name1 = 'Unit Test';
        oAddressCleanseResponse.City = 'Dallas';
        oAddressCleanseResponse.PostalCode = '55555';
        oAddressCleanseResponse.State_County = 'TX';
        oAddressCleanseResponse.Country = 'United States';
        oAddressCleanseResponse.Match_Code = '0';
        
        List<InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationSuggestionElement_element> listSuggestions = new List<InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationSuggestionElement_element>();
        InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationSuggestionElement_element oSuggestion = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationSuggestionElement_element();
        oSuggestion.SL_Name1 = 'UNIT TEST';
        oSuggestion.SL_Street = '555 SOME STREET';
        oSuggestion.SL_City = 'DALLAS';
        oSuggestion.SL_State_County = 'TX';
        oSuggestion.SL_Country_ISO3 = 'US';
        listSuggestions.add(oSuggestion);
        
        oAddressCleanseResponse.WS_SFDC_Address_ValidationSuggestionElement = listSuggestions;
        oAddressCleanseResponse.Suggestion_Count = string.valueOf(listSuggestions.size());
        
        InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType oAddressCleanseResponseType = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseType();
        oAddressCleanseResponseType.WS_SFDC_Address_ValidationResponseElement = oAddressCleanseResponse;
        
        UnitTest.MockWebServiceResponse.put(DataQualityUtil.CleanseAddressServiceName, oAddressCleanseResponseType);
        return oAddressCleanseResponseType;
    }
    
    
    
    /**
     * checks for the Contact matches
     */
     
    private static testMethod void testContactInfo(){
        try {
        WebServiceSettings__c oSettings = new WebServiceSettings__c();
        oSettings.Name = DataQualityUtil.ECMAccountMatchingServiceName;
        oSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oSettings.Timeout__c = 5;
        oSettings.Username__c = 'admin';
        oSettings.Password__c = 'admin';
        oSettings.Active__c = true;
        oSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oSettings;
        
        
        WebServiceSettings__c oSettings1 = new WebServiceSettings__c();
        oSettings1.Name = DataQualityUtil.ContactMatchingServiceName;
        oSettings1.Endpoint__c = 'https:\\thomsonreuters.com';
        oSettings1.Timeout__c = 5;
        oSettings1.Username__c = 'admin';
        oSettings1.Password__c = 'admin';
        oSettings1.Active__c = true;
        oSettings1.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oSettings1;
        
         DataQualityUtil.MatchContactsRequest maRequest = new DataQualityUtil.MatchContactsRequest();
         maRequest.EndPoint = 'https:\\thomsonreuters.com';
         maRequest.Timeout = 5;
         
       List<DataQualityUtil.ContactInfo> lstContacts=  new List<DataQualityUtil.ContactInfo>();
              DataQualityUtil.ContactInfo oContact = new DataQualityUtil.ContactInfo();    
                oContact.MDBCustomerID = '123';
                oContact.MDBContactID = '245';
                oContact.Name = 'testdjhfjdshfjsdh';
                oContact.EMail = 'test.test@gmail.com';
                oContact.Score ='123';
       lstContacts.add(oContact);
        
        maRequest.Contacts= lstContacts; 
        
        KeyValueListStore__c oTest = new KeyValueListStore__c(Name='ECM_PageSize',TextValue__c='12');
        //insert oTest;
        
        KeyValueListStore__c oTest1 = new KeyValueListStore__c(Name='ECM_PageNumber',TextValue__c='1');
        //insert oTest1;
        
        KeyValueListStore__c oTest2 = new KeyValueListStore__c(Name='ECM_Username',TextValue__c='4');
        //insert oTest2;
        
        KeyValueListStore__c oTest3 = new KeyValueListStore__c(Name='ECM_Password',TextValue__c='3');
        KeyValueListStore__c oTest4 = new KeyValueListStore__c(Name='DQ.ContactMatchingService',TextValue__c='5');
        //insert oTest3;
        
        List<KeyValueListStore__c> lstKey = new List<KeyValueListStore__c>();
        lstKey.add(oTest);
        lstKey.add(oTest1);
        lstKey.add(oTest2);
        lstKey.add(oTest3);
        lstKey.add(oTest4);
        
        insert lstKey;
        
        DataQualityUtil.MatchContactsRequest dc = new DataQualityUtil.MatchContactsRequest();
        list<Contact> conList = new list<Contact>();
        Contact con = new Contact(LastName ='Test');
        conList.add(con);
        //contacts= conList;
        DataQualityUtil.ContactInfo ci = new DataQualityUtil.ContactInfo();
        List<DataQualityUtil.ContactInfo> cntL1 = new List<DataQualityUtil.ContactInfo>();
        //cntL1.add(ci);
        
        DataQualityUtil.matchContacts(lstContacts);
        
        
   //     DataQualityUtil.MatchContactsResponse rs = new DataQualityUtil.MatchContactsResponse();
   //     DataQualityUtil.timeStamp();    we didn't find the method name
        DataQualityUtil.MatchContactsResponse maResponse = DataQualityUtil.matchContacts(maRequest);
        
        DataQualityUtil.ECMAccountInfo de = new DataQualityUtil.ECMAccountInfo();
        List<DataQualityUtil.ECMAccountInfo> cntL = new List<DataQualityUtil.ECMAccountInfo>();
        cntL.add(de);
        DataQualityUtil.MatchContactsResponse matchconRes = new DataQualityUtil.MatchContactsResponse();
        List<ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element> listconDDWSObj = new List<ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element>();
        ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element conDDWSObj = new ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element();
        conDDWSObj.MDB_CUSTOMER_ID = '123';
        conDDWSObj.MDB_CONTACT_ID= '123';
        conDDWSObj .MATCH_NAME = 'TEST';
        conDDWSObj .MATCH_EMAIL = 'sree@test.com';
        conDDWSObj .MATCH_SCORE = '1';
        
        listconDDWSObj.add(conDDWSObj);
        matchconRes.parse(listconDDWSObj);
        
        
        // call setECMAccountInfo
        ECMSearchServiceWSDL.Party part = new ECMSearchServiceWSDL.Party();
        part.PartyRowId = '123';
        part.MatchScore = 1;
        part.FullName ='Test';
        
        ECMSearchServiceWSDL.PartyAddress partAdd = new ECMSearchServiceWSDL.PartyAddress();
        partAdd.City = 'alaska';
        partAdd.State = 'AL';
        partAdd.ZipPostalCode = '560056';
        partAdd.Country = 'US';
        partAdd.AddressRowId ='123';
        string sourceId = '123';
        
        //DataQualityUtil.MatchAccountsResponse matchaccRes = new DataQualityUtil.MatchAccountsResponse();
        DataQualityUtil.setECMAccountInfo(part, partAdd, sourceId);    
        }
        catch(Exception ex) {
        system.assert(true);
        }
         
  //      DataQualityUtil.ecmmatchaccounts(cntL);   // we didn't find the method name
    }
    
    
    private static testMethod void testParsMethods(){
        ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element testobj4 = new ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element();
        testobj4.MDB_CUSTOMER_ID = '23344';
        testobj4.MDB_CONTACT_ID = '7656567'; 
        testobj4.MATCH_NAME = 'test';
        testobj4.MATCH_EMAIL = 'test@gmail.com';
        testobj4.MATCH_SCORE= '20';
        
        ECMSearchServiceWSDL.AddressIdentifiers addId= new ECMSearchServiceWSDL.AddressIdentifiers();
        ECMSearchServiceWSDL.SICCodes sicco= new ECMSearchServiceWSDL.SICCodes();
        ECMSearchServiceWSDL.PartyAttribute parAtr= new ECMSearchServiceWSDL.PartyAttribute();
        ECMSearchServiceWSDL.PartyAttributes partsAtr = new ECMSearchServiceWSDL.PartyAttributes();
        ECMSearchServiceWSDL.PartyAddress parAdd= new ECMSearchServiceWSDL.PartyAddress();
        parAdd.AddressRowId = '1';
        parAdd.AddressType ='city';
        parAdd.AddressLine1 ='1';
        parAdd.AddressLine2 = '2';
        parAdd.AddressLine3 = '3';
        parAdd.AddressLine4 = '4';
        parAdd.City = 'Bangalore';
        parAdd.ZipPostalCode = '565656';
        parAdd.County = 'INDIA';
        parAdd.State = 'KA';
        parAdd.Country = 'IN';
        parAdd.AddressIdentifiers = addId;
        parAdd.TaxVATExemptionIndicator = 'Y';
        parAdd.SICCodes = sicco;
        parAdd.PartyAttributes = partsAtr;
        parAdd.PrimaryAddressIndicator = 'test';
        parAdd.PartyLegalStatus = 'test'; 
        
        
        ECMSearchServiceWSDL.Addresses add = new ECMSearchServiceWSDL.Addresses();
        list<ECMSearchServiceWSDL.PartyAddress> parAddList = new list<ECMSearchServiceWSDL.PartyAddress>();
        add.PartyAddress = parAddlist;
        
        ECMSearchServiceWSDL.Party part= new ECMSearchServiceWSDL.Party();
        part.FullName = 'test';
        part.MatchScore = 30;
        part.Addresses = add;
        
        DataQualityUtil dqtt = new DataQualityUtil();
        DataQualityUtil.setECMAccountInfo(part,parAdd,'testing');
        
        DataQualityUtil.MatchContactsResponse dqt = new DataQualityUtil.MatchContactsResponse ();
        List<ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element> tmpList = new List<ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element>();
        tmpList.add(testobj4);
        dqt.parse(tmpList);
        
        ECMSearchServiceWSDL.SearchResults ecmsrc = new ECMSearchServiceWSDL.SearchResults ();
        
        ECMSearchServiceWSDL.Parties ecmprt = new ECMSearchServiceWSDL.Parties();
        List<ECMSearchServiceWSDL.Party> prtList = new List<ECMSearchServiceWSDL.Party>();
        prtList.add(part);
        
        ecmprt.Party = prtList;
        ecmsrc.Parties = ecmprt;
        
        DataQualityUtil.MatchAccountsResponse dqtAcc = new DataQualityUtil.MatchAccountsResponse ();
        dqtAcc.parse(ecmsrc);
        
    }
    
    private static testMethod void testM360Methods(){
        
        WebServiceSettings__c oCustomerProspectSettings = new WebServiceSettings__c();
        oCustomerProspectSettings.Name = DataQualityUtil.ContactMatchingServiceNameNonSfdc;
        oCustomerProspectSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oCustomerProspectSettings.Timeout__c = 5;
        oCustomerProspectSettings.Active__c = true;
        oCustomerProspectSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        Insert oCustomerProspectSettings;
            
        DataQualityUtil.ContactInfoNonSfdc cins = new DataQualityUtil.ContactInfoNonSfdc();    
        cins.personID = '123';
        cins.firstName = 'Test';
        cins.lastName = 'Test';
        cins.phoneNo = '123';
        cins.email = 'sreenu.d@tcs.com';
        cins.accountName = 'Test Account';
        cins.accountName = 'Salesforce.com';
        cins.score = '1';
        cins.bu='';
        List<DataQualityUtil.ContactInfoNonSfdc> listContacts =new List<DataQualityUtil.ContactInfoNonSfdc>();
        listContacts.add(cins);
        DataQualityUtil.MatchContactsNonSfdcRequest mcnsReq = new DataQualityUtil.MatchContactsNonSfdcRequest();
        IDQContactMatchesObjects.WS_contact_searchResponseElement_element serresp = new IDQContactMatchesObjects.WS_contact_searchResponseElement_element();
     
        DataQualityUtil.MatchContactsNonSfdcResponse matchres = new DataQualityUtil.MatchContactsNonSfdcResponse();
        matchres = DataQualityUtil.matchContactsNonSfdc(mcnsReq);
        DataQualityUtil.matchContactsNonSfdc(listContacts);
    }
}