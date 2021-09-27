/**
 * Provides helper methods for working with the data quality web services
 *
 * @author  John De Santiago
 * @version 2012-06-07
 */
 
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-06-07   John De Santiago        Created     
 * 2014-04-29   Nandita Shet            MCL-370 Billing Street or PO Box passed for request input street
 * 2015-03-27   Sripriya Kongot/Prathyush   ECM Integration related changes                                                                 
 * 2015-09-10   TCS                     Contact Data M360 Project Change to call new IDQ service     
 * 2016-09-16   Ravi Havashetty         ECM Integrated related changes for LCRM 
 * 2017-03-31   Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1                                                           
 * =============================================================================
 */
public class DataQualityUtil{
    //Constants
    public static final string CleanseAddressServiceName = 'DQ.CleanseAddressService';
    public static final string ECMAccountMatchingServiceName = 'ECMSearchServiceWS';
    public static final string ContactMatchingServiceName = 'DQ.ContactMatchingService';
    public static final string AccountMatchingServiceName = 'DQ.AccountMatchingService';
    public static final string CDSContactSearchServiceName = 'DQ.CDSContactSearchService';
    public static final string CDSContactSearchServiceNameContact = 'DQ.CDSContactSearchServiceContact';
    public static final string ECMAccountMatchingPartyServiceName = 'DQ.ECMSearchByPartyId';
    public static boolean isContactCall = false;
    public static boolean manualAccountSearch = false;
    public static KeyValueListStore__c ECMUsername = null;
    public static KeyValueListStore__c ECMPassword = null; 
    public static KeyValueListStore__c ECMPageSize = null;
    public static KeyValueListStore__c ECMPageNumber = null;
    public static KeyValueListStore__c GLI_ECM_AddressSourceSystemCode = null;
    public static KeyValueListStore__c ECM_AddressSourceSystemCode = null;         
    public static KeyValueListStore__c ECM_MAX_ADDRESS_RESULTS = null; 
    public static KeyValueListStore__c ECM_AddressSourceId_Prefix = null;        
    public static KeyValueListStore__c accountCountConfig = null;
    public static boolean isMixedCaseCall = false;
    
    public static ECMAccountInfo existingAccountInfo1= new ECMAccountInfo();

    //Public Methods
    //Static
    static{
        ECMUsername = KeyValueListStore__c.getInstance('ECM_Username');
        ECMPassword = KeyValueListStore__c.getInstance('ECM_Password'); 
        ECMPageSize = KeyValueListStore__c.getInstance('ECM_PageSize');
        ECMPageNumber = KeyValueListStore__c.getInstance('ECM_PageNumber');
        GLI_ECM_AddressSourceSystemCode = KeyValueListStore__c.getInstance('GLI_ECM_AddressSourceSystemCode');
        ECM_AddressSourceSystemCode = KeyValueListStore__c.getInstance('ECM_AddressSourceSystemCode');         
        ECM_MAX_ADDRESS_RESULTS = KeyValueListStore__c.getInstance('ECM_MAX_ADDRESS_RESULTS'); 
        ECM_AddressSourceId_Prefix = KeyValueListStore__c.getInstance('ECM_AddressSourceId_Prefix');        
        accountCountConfig = KeyValueListStore__c.getInstance('LCRMMax_Account_Count');
    }
    /**
     * Lists available country values configured in the Country__c custom setting object
     *
     * @return  a list of SelectOption objects
     */
    
     public static List<SelectOption> listAvailableCountryOptions(){
        List<SelectOption> listCountryOptions = new List<SelectOption>();
        //Add Default Option
        listCountryOptions.add(new SelectOption('', '-- None --'));
        //Add Available Options
        List<Country__c> lstCountry = New List<Country__c>(Country__c.getAll().values());
        lstCountry.sort();
        //for (Country__c oCountry : [SELECT Name, Country_Code__c FROM Country__c WHERE IsActive__c = true ORDER BY Country_Code__c]) {
        for(Country__c oCountry: lstCountry){
            string sValue = oCountry.Country_Code__c;
            string sLabel = sValue + ' - ' + oCountry.Name;            
            listCountryOptions.add(new SelectOption(sValue, sLabel));
        }
        lstCountry.clear();
        return listCountryOptions;
    }
    /* ------ Commented code as part of S2E Optimization ---START---------------
    public static List<SelectOption> listAvailableCountryOptions() {
        List<SelectOption> listCountryOptions = new List<SelectOption>();
        
        //Add Default Option
        listCountryOptions.add(new SelectOption('', '-- None --'));
        
        //Add Available Options
        for (Country__c oCountry : [SELECT Name, Country_Code__c FROM Country__c WHERE IsActive__c = true ORDER BY Country_Code__c]) {
            string sValue = oCountry.Country_Code__c;
            string sLabel = sValue + ' - ' + oCountry.Name;
            
            listCountryOptions.add(new SelectOption(sValue, sLabel));
        }
        
        return listCountryOptions;
    }
    ------ Commented code as part of S2E Optimization ---END--------------- */
    
    /**
     * Lists available country region values configured in the Country_Region__c custom setting object
     * filtered by the specified country code
     *
     * @param   sCountryCode    a valid 2 char country code to filter by
     * @return  a list of SelectOption objects
     */
     
      public static List<SelectOption> listAvailableCountryRegionOptions(string sCountryCode){
        List<SelectOption> listCountryRegionOptions = new List<SelectOption>();
        //Add Default Option
        listCountryRegionOptions.add(new SelectOption('', '-- None --'));
        //Map<String, Country_Region__c> allstates = Country_Region__c.getAll().values();
        List<Country_Region__c> lstCountryRegion = New List<Country_Region__c>(Country_Region__c.getAll().values());
        // Filter states that belong to the selected country
        Map<String, Country_Region__c> states = new Map<String, Country_Region__c>();
        for(Country_Region__c state : lstCountryRegion){
            if (state.country_code__c == sCountryCode){
                states.put(state.name, state);
            }
        }
        // Sort the states based on their names
        List<String> stateNames = new List<String>();
        stateNames.addAll(states.keySet());
        stateNames.sort();
        // Generate the Select Options based on the final sorted list
        for (String stateName : stateNames){
            Country_Region__c state = states.get(stateName);
            listCountryRegionOptions.add(new SelectOption(state.Region_Code__c, state.Region_Code__c + ' - ' + state.Region_Name__c));
        }
       lstCountryRegion.clear();
        return listCountryRegionOptions;
    }
    /* ------ Commented code as part of S2E Optimization ---START--------------- 
    public static List<SelectOption> listAvailableCountryRegionOptions(string sCountryCode) {
        List<SelectOption> listCountryRegionOptions = new List<SelectOption>();
        
        //Add Default Option
        listCountryRegionOptions.add(new SelectOption('', '-- None --'));
        
        //Add Available Options
        for (Country_Region__c oCountryRegion : [SELECT Region_Name__c, Region_Code__c FROM Country_Region__c WHERE IsActive__c = true AND Country_Code__c = :sCountryCode ORDER BY Region_Name__c]) {
            string sValue = oCountryRegion.Region_Code__c;
            string sLabel = sValue + ' - ' + oCountryRegion.Region_Name__c;
            
            listCountryRegionOptions.add(new SelectOption(sValue, sLabel));
        }
        
        return listCountryRegionOptions;
    }
    ------ Commented code as part of S2E Optimization ---END--------------- */
    
    /**
     * Validates that all required fields for the specified address have been
     * populated.
     *
     * @param   oAddress    an instance of an DataQualityUtil.Address object
     * @return  an instance of a ValidationResult object
     */
    public static ValidationResult validateAddress(DataQualityUtil.Address oAddress){
        ValidationResult oValidationResult = new ValidationResult();
        oValidationResult.IsValid = true;
        if (oAddress != null) {
            boolean isInvalid = false;
            isInvalid |= AppUtil.isEmpty(oAddress.Street)&& AppUtil.isEmpty(oAddress.POBox)? true:false;
           // isInvalid |= AppUtil.isEmpty(oAddress.Street);
            isInvalid |= AppUtil.isEmpty(oAddress.City);  //isInvalid |= AppUtil.isEmpty(oAddress.Country);
            if (isInvalid){
                oValidationResult.IsValid = false;
                oValidationResult.Failures.Add('Missing requried address fields');
            }
        }
        else{
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add('Invalid Address Object. Address can not be null');
        }
        return oValidationResult;
    }
    
    /**
     * Initiates a web service command to cleanse the specified address information utilizing
     * the DQXI web service
     *
     * @param   oAddress    an instance of an Address object
     * @return  an instance of an DataQualityUtil.Address object
     */
    public static Address cleanseAddress(Address oAddress){
        /* SKG change HK to correct country to bipass Hong Kong */
        if (oAddress.Country == 'HK'){
             return oAddress;
        }
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.CleanseAddressServiceName);
        CleanseAddressRequest oRequest = new CleanseAddressRequest();
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
        oRequest.Address = oAddress;
        CleanseAddressResponse oResponse = cleanseAddress(oRequest);
/*System.debug('---------------------++++++++++++oResponse+++++++++++---------->'+oResponse);-- commented to reduce character for s2e optimization */
        if (oResponse.IsSuccess == false){
            throw new AddressCleanseServiceException(oResponse.ErrorMessage);
        }
       return oResponse.Address;
    }
    
    /**
     * Initiates a web service command to cleanse the specified address information utilizing
     * the DQXI web service
     *
     * @param   oCleanseAddressRequest  an instance of an CleanseAddressRequest object
     * @return  an instance of an CleanseAddressResponse object
     */
    public static CleanseAddressResponse cleanseAddress(CleanseAddressRequest oCleanseAddressRequest) {
        CleanseAddressResponse oCleanseAddressResponse = new CleanseAddressResponse();
/*System.debug('***oCleanseAddressRequest...' +oCleanseAddressRequest);-- commented to reduce character for s2e optimization */
        //Validate Request
        ValidationResult oValidationResult = validateRequest(oCleanseAddressRequest);
        if (oValidationResult.isValid){
            oCleanseAddressResponse.Address = oCleanseAddressRequest.Address.clone();
/*system.debug('***oCleanseAddressResponse.Address...'+oCleanseAddressResponse.Address);-- commented to reduce character for s2e optimization */
            //Validate Address
            //oValidationResult = validateAddress(oCleanseAddressRequest.Address);
            oValidationResult.IsValid = true;
            if (oValidationResult.IsValid == false){
/*System.debug('------------------hereif----------->');-- commented to reduce character for s2e optimization */
                oCleanseAddressResponse.parse(oValidationResult);
            }
            else{
                //Initialize Web Service
/*System.debug('------------------herelse----------->');-- commented to reduce character for s2e optimization */
                InformaticaAddressCleanse_WS.WS_SFDC_Address_Validation_V3Port oService = new InformaticaAddressCleanse_WS.WS_SFDC_Address_Validation_V3Port();
                oService.inputHttpHeaders_x = new Map<String, String>();
                oService.timeout_x = oCleanseAddressRequest.Timeout.intValue();
                oService.endpoint_x = oCleanseAddressRequest.EndPoint;
/*System.debug('cleanseAddress.Endpoint: ' + oCleanseAddressRequest.EndPoint);-- commented to reduce character for s2e optimization */
                //Map Request
                InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationRequestElement_element oRequest = new InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationRequestElement_element();
/*System.debug('=============oRequest============>'+oRequest);-- commented to reduce character for s2e optimization */
                Address oAddress = oCleanseAddressRequest.Address;
/*System.debug('=============oAddress============>'+oAddress);-- commented to reduce character for s2e optimization */
                oRequest.Suggest_Always = 'N';
                oRequest.Suggestion_Threshold = '80';
                oRequest.Verbose_Error_Descr = 'N';
                oRequest.Name1 = oAddress.Name;
                /************MCL-370**********/
                oRequest.Street = oAddress.Street;
                //oRequest.Street = AppUtil.IsEmpty(oAddress.Street)?oAddress.POBox:oAddress.Street;
                oRequest.City = oAddress.City;
/*System.debug('=========================>'+oRequest.State_County);-- commented to reduce character for s2e optimization */
                oRequest.State_County = AppUtil.IsNull(oAddress.State, oAddress.County);
                // System.debug('=========================>'+oRequest.State_County);
                oRequest.PostalCode = oAddress.PostalCode;
                oRequest.Country = oAddress.Country;
                oRequest.POBox = oAddress.POBox;
                //oRequest.POBox = oAddress.County;
/*System.debug('cleanseAddress.Request: ' + oRequest);-- commented to reduce character for s2e optimization */
                try {
                    //Submit Request
                    InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element  oResponse = oService.WS_SFDC_Address_Validation_V3Operation(oRequest);
/*System.debug('cleanseAddress.Response: ' + oResponse);-- commented to reduce character for s2e optimization */
                    oCleanseAddressResponse.parse(oResponse);
                    /* Address service doesn't return the proper country code, so to avoid losing data
                     * the original values replace the values returned by the service */
                    if(oCleanseAddressResponse.Address.Street != null && oCleanseAddressResponse.Address.Street != '' && oCleanseAddressResponse.Address.Street.length() > 35){
                        oCleanseAddressResponse.Address.Street = oCleanseAddressRequest.Address.Street;
                    }
                    oCleanseAddressResponse.Address.State = oCleanseAddressRequest.Address.State;
                    oCleanseAddressResponse.Address.Country = oCleanseAddressRequest.Address.Country;
                }
                catch (CalloutException calloutException){
                    oCleanseAddressResponse.parse(calloutException);
                }
            }
        }
        else {
            oCleanseAddressResponse.parse(oValidationResult);
        }
/*System.debug('oCleanseAddressResponse : '+oCleanseAddressResponse);-- commented to reduce character for s2e optimization */
        return oCleanseAddressResponse;
    }

    /**
     * Initiates a web service call to ECM searchParty() service to retrieve all potential matched accounts in ECM universe     
     *
     * @param   listAccounts    a list of ECMAccountInfo objects to match against
     * @return  a list of DataQualityUtil.ECMAccountInfo objects
     */
    public static MatchAccountsResponse matchECMAccounts(List<ECMAccountInfo> listAccounts){
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.ECMAccountMatchingServiceName);
        MatchAccountsResponse oResponse;
        List<ECMAccountInfo> listMatchedAccounts = new List<ECMAccountInfo>();
        if (listAccounts.isEmpty() == false){
            MatchAccountsRequest oRequest = new MatchAccountsRequest();
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
            oRequest.Username = oWebServiceSettings.Username__c;
            oRequest.Password = oWebServiceSettings.Password__c;
            oRequest.Accounts = listAccounts;
/*System.debug('oRequest...' + oRequest);-- commented to reduce character for s2e optimization */
             oResponse = matchECMAccounts(oRequest);
            if (oResponse.IsSuccess == false){
                /** edit by prathyush **/
                //if(oResponse.ErrorMessage.Contains(System.Label.DataQualityUtil_errmsg_Description + ':' + 'EM003 - No results found for specified criteria')){
                  if(oResponse.ErrorMessage.Contains('EM003 - No results found for specified criteria')){  
                    String Err = System.Label.ECM_Informatin_Message;
                    ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.INFO,+Err);
                    ApexPages.addMessage(msg);
                }
                else{
                    throw new AccountMatchingServiceException(oResponse.ErrorMessage);
                }
            }
/*System.debug('oResponse...' + oResponse);-- commented to reduce character for s2e optimization */
            //listMatchedAccounts = oResponse.Accounts;
        }
        //return listMatchedAccounts;
        return oResponse;
    }
    
    /**
     * Initiates a web service command to match and score the specified accounts that potentially
     * qualify as a duplicate utilizing the DQXI web service
     *
     * @param   oMatchAccountsRequest   an instance of a MatchAccountsRequest object
     * @return  an instance of an MatchAccountsResponse object
     */
    public static MatchAccountsResponse matchECMAccounts(MatchAccountsRequest oMatchAccountsRequest){
/*System.debug('bigerrequest' + oMatchAccountsRequest);-- commented to reduce character for s2e optimization */
        MatchAccountsResponse oMatchAccountsResponse = new MatchAccountsResponse();
        ECMSearchServiceWSDL.SearchResults oResponse;
        //Added for Mixed Case PoC
        ECMSearchServiceWSDL.GetResults oResponseMixedCase;
        ValidationResult oValidationResult = validateRequest(oMatchAccountsRequest);
        if (oValidationResult.isValid){
            //Initialize Web Service
           // InformaticaCustomerMatchWS.WS_Customer_MatchPort oService = new InformaticaCustomerMatchWS.WS_Customer_MatchPort();
            ECMSearchServiceWSDL.IcglV1PortTypePort oService = new ECMSearchServiceWSDL.IcglV1PortTypePort();
            oService.inputHttpHeaders_x = new Map<String, String>();
            Blob blobCredentials = Blob.valueOf(oMatchAccountsRequest.Username + ':' + oMatchAccountsRequest.Password);
            string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            oService.timeout_x = oMatchAccountsRequest.Timeout.intValue();
            oService.endpoint_x = oMatchAccountsRequest.EndPoint;
/*System.debug('matchAccounts.Endpoint: ' + oMatchAccountsRequest.EndPoint);-- commented to reduce character for s2e optimization */
            ECMSearchServiceWSDL.EAIHeader objEAIHeader = new ECMSearchServiceWSDL.EAIHeader();
            //Map Request
            //Added IF check for Mixed Case PoC.
            if(!isMixedCaseCall){
                system.debug('+++ inside manual search');
                objEAIHeader.applicationId = 'S2E';
                objEAIHeader.transactionId = AccountUtil.getTimeStamp();
                ECMSearchServiceWSDL.SearchRequest oRequest = new ECMSearchServiceWSDL.SearchRequest();
                for (ECMAccountInfo oAccount : oMatchAccountsRequest.Accounts){
                    oRequest.Firstname = '';
                    oRequest.Middlename = '';
                    oRequest.Lastname = '';
                    oRequest.Fullname = oAccount.Name;
                    oRequest.Address = oAccount.Street1;
                    oRequest.City = oAccount.City;
                    oRequest.State = oAccount.State;
                    oRequest.Country = oAccount.Country;
                    oRequest.Zipcode = oAccount.PostalCode;
                    oRequest.PageSize= integer.ValueOf(ECMPageSize.TextValue__c);
                    oRequest.PageNumber= integer.ValueOf(ECMPageNumber.TextValue__c);
                    oRequest.Username= ECMUsername.TextValue__c;
                    oRequest.Password= ECMPassword.TextValue__c;
                    oRequest.AuditToken= '';
                    oRequest.Header= '';
                }
/*System.debug('matchAccounts.Request: ' + oRequest);-- commented to reduce character for s2e optimization */
                try{
                    //Submit Request
                    oResponse  = oService.SearchParty(oRequest.EAIHeader, oRequest.Firstname, oRequest.Middlename, oRequest.Lastname, oRequest.Fullname,
                                   oRequest.Address, oRequest.City, oRequest.State, oRequest.Country, oRequest.Zipcode,
                                   oRequest.PageSize, oRequest.PageNumber, oRequest.Username, oRequest.Password, 
                                   oRequest.AuditToken, oRequest.Header);
/*System.debug('matchAccounts.Response: ' + oResponse);
                    System.debug('came to try');-- commented to reduce character for s2e optimization */
                    oMatchAccountsResponse.parse(oResponse);
                }
                catch (CalloutException calloutException){
/*System.debug('came to catch 1 '+calloutException.getmessage());-- commented to reduce character for s2e optimization */
                    oMatchAccountsResponse.parse(calloutException);
                }
                catch (Exception e){
/*System.debug('came to catch 2 '+e.getmessage());-- commented to reduce character for s2e optimization */
                    oMatchAccountsResponse.parse(e);
                }
            }else{
                system.debug('+++ mixed case search');
                //Else condition for Mixed Case call.
                objEAIHeader.applicationId = 'GLI';
                objEAIHeader.transactionId = AccountUtil.getTimeStamp();
                ECMSearchServiceWSDL.GetRequest oRequestMixedCase = new ECMSearchServiceWSDL.GetRequest();
                for (ECMAccountInfo oAccount : oMatchAccountsRequest.Accounts) {
                    oRequestMixedCase.RowId = oAccount.partyRowId;
                    oRequestMixedCase.SourceSystemCode = oAccount.sourceSystemCodeSystems;
                    oRequestMixedCase.SourceSystemId = oAccount.sourceSystemIdSystems;
                    oRequestMixedCase.Username= ECMUsername.TextValue__c;                
                    oRequestMixedCase.Password= ECMPassword.TextValue__c;  
                    oRequestMixedCase.AuditToken= '';
                    oRequestMixedCase.Header= ''; 
                    oRequestMixedCase.EAIHeader = objEAIHeader;
                }
                try{
                    //Submit Request
                    oResponseMixedCase  = oService.GetParty(oRequestMixedCase.EAIHeader, oRequestMixedCase.RowId, 
                                                            oRequestMixedCase.SourceSystemCode,
                                                            oRequestMixedCase.SourceSystemId, oRequestMixedCase.Username,
                                                            oRequestMixedCase.Password, oRequestMixedCase.AuditToken,
                                                            oRequestMixedCase.Header);
/*System.debug('Mixed Case Reposne: ' + oResponseMixedCase);
                    System.debug('************* ');-- commented to reduce character for s2e optimization */
                    oMatchAccountsResponse.parseMixedCase(oResponseMixedCase);
                }
                catch (CalloutException calloutException) {
/*System.debug(' **** came to catch 1 of MIXED case response '+calloutException.getmessage());-- commented to reduce character for s2e optimization */
                    oMatchAccountsResponse.parse(calloutException);
                }
                catch (Exception e){
/*System.debug(' **** came to catch 2 of Mixed Case response '+e.getmessage());-- commented to reduce character for s2e optimization */
                    oMatchAccountsResponse.parse(e);
                }
            }
        }
        else{
            oMatchAccountsResponse.parse(oValidationResult);
        }
        return oMatchAccountsResponse;
    }
    
 
 /** Added by Srini
     * Initiates a web service command to match and score the specified accounts that potentially
     * qualify as a duplicate utilizing the DQXI web service
     *
     * @param   listAccounts    a list of AccountInfo objects to match against
     * @return  a list of DataQualityUtil.AccountInfo objects
     */
    public static List<AccountInfo> matchAccounts(List<AccountInfo> listAccounts){
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.AccountMatchingServiceName);
        List<AccountInfo> listMatchedAccounts = new List<AccountInfo>();
        if (listAccounts.isEmpty() == false){
            MatchSF1AccountsRequest  oRequest = new MatchSF1AccountsRequest();
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
            oRequest.Accounts = listAccounts;
/*System.debug('bigrequest' + oRequest);-- commented to reduce character for s2e optimization */
            MatchSF1AccountsResponse oResponse = matchAccounts(oRequest);
            if (oResponse.IsSuccess == false){
                throw new AccountMatchingServiceException(oResponse.ErrorMessage);
            }
/*System.debug('bigresponse' + oResponse);-- commented to reduce character for s2e optimization */
            listMatchedAccounts = oResponse.Accounts;
        }
        return listMatchedAccounts;
    }
    
    /**
     * Initiates a web service command to match and score the specified accounts that potentially
     * qualify as a duplicate utilizing the DQXI web service
     *
     * @param   oMatchAccountsRequest   an instance of a MatchAccountsRequest object
     * @return  an instance of an MatchAccountsResponse object
     */
    public static MatchSF1AccountsResponse matchAccounts(MatchSF1AccountsRequest oMatchAccountsRequest) {
/*System.debug('bigerrequest' + oMatchAccountsRequest);-- commented to reduce character for s2e optimization */
        MatchSF1AccountsResponse oMatchAccountsResponse = new MatchSF1AccountsResponse();
        ValidationResult oValidationResult = validateRequest(oMatchAccountsRequest);
        if (oValidationResult.isValid){
            //Initialize Web Service
           // InformaticaCustomerMatchWS.WS_Customer_MatchPort oService = new InformaticaCustomerMatchWS.WS_Customer_MatchPort();
            InformaticaCustomerMatch_WS.WS_Customer_Match_V2Port oService = new InformaticaCustomerMatch_WS.WS_Customer_Match_V2Port();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.timeout_x = oMatchAccountsRequest.Timeout.intValue();
            oService.endpoint_x = oMatchAccountsRequest.EndPoint;
/*System.debug('matchAccounts.Endpoint: ' + oMatchAccountsRequest.EndPoint);-- commented to reduce character for s2e optimization */
            //Map Request
            //List<InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element> oRequest = new List<InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element>();
            //**********MCL-370***********
            InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestElement_element oRequest = new InformaticaCustomerMatch_WSObject.WS_CustomerMatchRequestElement_element();
            for (AccountInfo oAccount : oMatchAccountsRequest.Accounts){
            /* InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element oRequestElement = new InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element();
                /* skg added name to test */ 
                /*oRequestElement.Name = oAccount.Name;
                oRequestElement.Name2 = oAccount.Nametwo;
                oRequestElement.Name3 = oAccount.Namethree;
                oRequestElement.ID = oAccount.AccountId;
                oRequestElement.ADDRESS = oAccount.AddressLine1;
                oRequestElement.CITY = oAccount.City;
                oRequestElement.ZIPCODE = oAccount.PostalCode;
                oRequestElement.COUNTRYCODE = oAccount.Country;
                
                oRequest.add(oRequestElement);*/
                oRequest.Name = oAccount.Name;
                oRequest.Name2 = oAccount.Nametwo;
                oRequest.Name3 = oAccount.Namethree;
                oRequest.ID = oAccount.AccountId;
                oRequest.ADDRESS = oAccount.AddressLine1;
                oRequest.CITY = oAccount.City;
                oRequest.ZIPCODE = oAccount.PostalCode;
                oRequest.COUNTRYCODE = oAccount.Country;
                oRequest.POBOX = oAccount.POBox;
            }
/*System.debug('matchAccounts.Request: ' + oRequest);-- commented to reduce character for s2e optimization */
            try {
                //Submit Request
               // InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element[] oResponse = oService.WS_Customer_MatchOperation(oRequest);
                InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element[] oResponse  = oService.WS_Customer_Match_V2Operation(oRequest);
/*System.debug('matchAccounts.Response: ' + oResponse);-- commented to reduce character for s2e optimization */
                oMatchAccountsResponse.parse(oResponse);
            }
            catch (CalloutException calloutException){
                oMatchAccountsResponse.parse(calloutException);
            }
        }
        else{
            oMatchAccountsResponse.parse(oValidationResult);
        }
        return oMatchAccountsResponse;
    }  
    
/*SKG Contacts dedup code**************************************************************************    
    
    
    
    /**
     * Initiates a web service command to match and score the specified cotacts that potentially
     * qualify as a duplicate utilizing the DQXI web service
     *
     * @param   listcontacts    a list of contact objects to match against
     * @return  a list of DataQualityUtil.contact objects
     */
    public static List<ContactInfo> matchContacts(List<ContactInfo> listContacts){
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.ContactMatchingServiceName);
        List<ContactInfo> listMatchedContacts = new List<ContactInfo>();
/*system.debug('SKGHERE1' + listcontacts.isempty());-- commented to reduce character for s2e optimization */
        if (listContacts.isEmpty() == false){
            MatchContactsRequest oRequest = new MatchContactsRequest();
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
            oRequest.Contacts = listContacts;
/*system.debug('@@@SKGRequest ' +oRequest);-- commented to reduce character for s2e optimization */
            MatchContactsResponse oResponse = matchContacts(oRequest);
/*system.debug('@@@SKGResponse ' +oResponse);-- commented to reduce character for s2e optimization */
            if (oResponse.IsSuccess == false){
                throw new ContactMatchingServiceException(oResponse.ErrorMessage);
            }
            listMatchedContacts = oResponse.Contacts;
        }
        return listMatchedContacts;
    }
    
    /**
     * Initiates a web service command to match and score the specified Contact that potentially
     * qualify as a duplicate utilizing the DQXI web service
     *
     * @param   oMatchContactsRequest   an instance of a MatchContactsRequest object
     * @return  an instance of an MatchContactsResponse object
     */    
public static MatchContactsResponse matchContacts(MatchContactsRequest oMatchcontactsRequest){
        MatchContactsResponse oMatchContactsResponse = new MatchContactsResponse();
        ValidationResult oValidationResult = validateRequest(oMatchContactsRequest);
        if (oValidationResult.isValid){
            //Initialize Web Service
            ContactDeDupWS.WS_Contact_MatchPort oService = new ContactDeDupWS.WS_Contact_MatchPort();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.timeout_x = oMatchContactsRequest.Timeout.intValue();
            oService.endpoint_x = oMatchContactsRequest.EndPoint;
            //Map Request
            List<ContactDeDupWSObjects.WS_Contact_MatchRequestElement_element> oRequest = new List<ContactDeDupWSObjects.WS_Contact_MatchRequestElement_element>();
            //for (ContactInfo oContact : oMatchContactsRequest.Contacts) {
            ContactInfo oContact = new ContactInfo();
            oContact = oMatchContactsRequest.Contacts[0];
                ContactDeDupWSObjects.WS_Contact_MatchRequestElement_element oRequestElement = new ContactDeDupWSObjects.WS_Contact_MatchRequestElement_element();
                ORequestElement.MDB_CUSTOMER_ID = oContact.MDBCustomerID;
                ORequestElement.NAME = oContact.Name;
                ORequestElement.EMAIL = oContact.EMAIL;
                oRequest.add(oRequestElement);
/*} 
               //ContactDeDupWSObjects.WS_Contact_MatchRequestElement_element oRequest = new ContactDeDupWSObjects.WS_Contact_MatchRequestElement_element();
               //oRequest.EMAIL = oMatchcontactsRequest.contacts.email;
               system.debug('skghere2 reqeust ' +oRequestElement);-- commented to reduce character for s2e optimization */
            try {
                //Submit Request
                ContactDeDupWSObjects.WS_Contact_MatchResponseElement_Element[] oResponse = oService.WS_Contact_matchOperation(oRequestElement);
/*ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element[] oResponse = oService.WS_Contact_MatchOperation(oRequest);
                System.debug('matchAccounts.Response: ' + oResponse);-- commented to reduce character for s2e optimization */
                oMatchContactsResponse.parse(oResponse);
            }
            catch (CalloutException calloutException){
                oMatchContactsResponse.parse(calloutException);
            }
        }
        else{
            oMatchContactsResponse.parse(oValidationResult);
        }
        return oMatchContactsResponse;
    }    
    
/*SKG end Contacts dedup code**************************************************************************/


    //Private Methods
    
    /**
     * Validates that all required information has been supplied for the specified request
     * 
     * @param   oRequest an instance of a Request object to validate
     * @returns a instance of a ValidationResult object representing the results of the validation
     */
    private static ValidationResult validateRequest(Request oRequest){
        ValidationResult oValidationResult = new ValidationResult();
        oValidationResult.IsValid = true;
        if (oRequest != null){
            //Validate Request Credentials
            boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.EndPoint);
            if (isMissingEndPoint){
                oValidationResult.IsValid = false;
                oValidationResult.Failures.add(System.Label.InvalidOrMissingCredentials);
            }
            //Validate Timeout Limit
            boolean isTimeoutValid = (oRequest.Timeout > 0);
            if (!isTimeoutValid){
                oValidationResult.IsValid = false;
                oValidationResult.Failures.Add(System.Label.InvalidTimeoutValue);   
            }
        }
        else{
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add('Invalid Request Object. Request can not be null');
        }
        return oValidationResult;   
    }
    
    /* Start : Contact Data M360 Code Changes for new IDQ servie ******************************/
    /**
    * Initiates a web service command to match and score the specified contacts outside Salesforce that potentially
    * qualify as a duplicate utilizing the DQXI web service
    *
    * @param   listcontacts    a list of contact objects to match against
    * @return  a list of DataQualityUtil.contact objects
    */
    
    public static final string ContactMatchingServiceNameNonSfdc = 'DQ.NonSfdcContactMatchingService';
    public class NonSfdcContactMatchingServiceException extends Exception {}
    
    public class ContactInfoNonSfdc{
        //public String ID{get;set;}
        public String personID{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String phoneNo{get;set;}
        public String email{get;set;}
        public String accountName{get;set;}
        //public String company{get;set;}
        public String BU{get;set;}
        public String score{get;set;}
    }
    
    /**
     * Request information for an Contact matching web service callout to DQXI
     */
    public class MatchContactsNonSfdcRequest extends Request {
        public List<ContactInfoNonSfdc> Contacts {get;set;}
        public MatchContactsNonSfdcRequest() {
            this.Contacts = new List<ContactInfoNonSfdc>();
        }
    }
    
    /**
     * Response information for a match Contacts callout to DQXI
     */
    public class MatchContactsNonSfdcResponse extends Response{
        public List<ContactInfoNonSfdc> Contacts {get;set;}
        public MatchContactsNonSfdcResponse() {
            this.Contacts = new List<ContactInfoNonSfdc>();
        }
        public void parse(IDQContactMatchesObjects.WS_contact_searchResponseElement_element[] oResponse){
            this.IsSuccess = true;
            this.Contacts = new List<ContactInfoNonSfdc>();
            if (oResponse != null){
                for (IDQContactMatchesObjects.WS_contact_searchResponseElement_element oResponseElement : oResponse){
                    ContactInfoNonSfdc oContact = new ContactInfoNonSfdc(); 
                    oContact.personId = oResponseElement.PERSON_ID;   
                    oContact.firstName = oResponseElement.FIRST_NAME_MCM;
                    oContact.lastName = oResponseElement.LAST_NAME_MCM;
                    oContact.email = oResponseElement.EMAIL_MCM;
                    oContact.phoneNo = oResponseElement.PHONE_MCM;
                    oContact.accountName = oResponseElement.ACCOUNT_NAME_MCM;
                    oContact.BU = oResponseElement.BUSINESS_UNIT;
                    oContact.Score =oResponseElement.MATCH_SCORE;
                    this.Contacts.add(oContact);
                }
/*System.debug('parsed : '+this.Contacts);-- commented to reduce character for s2e optimization */
            }
        }
    }

    public static List<ContactInfoNonSfdc> matchContactsNonSfdc(List<ContactInfoNonSfdc> listContacts) {
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.ContactMatchingServiceNameNonSfdc);
        
        List<ContactInfoNonSfdc> listMatchedContacts = new List<ContactInfoNonSfdc>();
/*system.debug('test : ' + listcontacts.isempty());-- commented to reduce character for s2e optimization */
        if (listContacts.isEmpty() == false){
            MatchContactsNonSfdcRequest oRequest = new MatchContactsNonSfdcRequest();
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
            oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
            oRequest.Contacts = listContacts;
/*system.debug('Request : ' +oRequest);-- commented to reduce character for s2e optimization */
            MatchContactsNonSfdcResponse oResponse = matchContactsNonSfdc(oRequest);
            if (oResponse.IsSuccess == false){
                throw new ContactMatchingServiceException(oResponse.ErrorMessage);
            }
            listMatchedContacts = oResponse.Contacts;
/*system.debug('listMatchedContacts : '+listMatchedContacts);-- commented to reduce character for s2e optimization */
        }
        return listMatchedContacts;
    }
    
    /**
    * Initiates a web service command to match and score the specified Contact outside Salesforce that potentially
    * qualify as a duplicate utilizing the DQXI web service
    *
    * @param   oMatchContactsRequest   an instance of a MatchContactsRequest object
    * @return  an instance of an MatchContactsNonSfdcResponse object
    */    
    
    public static MatchContactsNonSfdcResponse matchContactsNonSfdc(MatchContactsNonSfdcRequest oMatchcontactsRequest){
        MatchContactsNonSfdcResponse oMatchContactsResponse = new MatchContactsNonSfdcResponse();
        ValidationResult oValidationResult = validateRequest(oMatchContactsRequest);
        if (oValidationResult.isValid){
            //Initialize Web Service
            IDQContactMatches.ws_contact_match_scoresPort oService = new IDQContactMatches.ws_contact_match_scoresPort();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.timeout_x = oMatchContactsRequest.Timeout.intValue();
            oService.endpoint_x = oMatchContactsRequest.EndPoint;
            oService.outputHttpHeaders_x = new Map<String, String>();
            //Map Request
            //List<ContactDeDupNonSfdcWSObjects.WS_Provider_ExtractRequestElement_element> oRequest = new List<ContactDeDupNonSfdcWSObjects.WS_Provider_ExtractRequestElement_element>();
            ContactInfoNonSfdc oContact = oMatchContactsRequest.Contacts[0];
            //oContact = oMatchContactsRequest.Contacts[0];
            IDQContactMatchesObjects.WS_contact_searchRequestElement_element oRequestElement = new IDQContactMatchesObjects.WS_contact_searchRequestElement_element ();
            ORequestElement.FIRST_NAME = oContact.firstName;
            ORequestElement.LAST_NAME = oContact.lastName;
            ORequestElement.EMAIL = oContact.EMAIL;
            ORequestElement.PHONE = oContact.phoneNo;
            ORequestElement.ACCOUNT_NAME = oContact.accountName;
            //oRequest.add(oRequestElement);
/*system.debug('request ' +oRequestElement);-- commented to reduce character for s2e optimization */
            try{
                //Submit Request
                IDQContactMatchesObjects.WS_contact_searchResponseElement_element [] oResponse;
                if(Test.isRunningTest()){
                oResponse = MockWebserviceResponses.getIDQMatchesResponse();
                }
                else{
                oResponse = oService.ws_contact_match_scoresOperation(oRequestElement);
/*System.debug('matchAccounts.Response: ' + oResponse);-- commented to reduce character for s2e optimization */
                }
                oMatchContactsResponse.parse(oResponse);
            }
            catch (CalloutException calloutException){
/*System.debug('exception msg '+calloutException.getStackTraceString());
                System.debug('exception String '+calloutException.getMessage());-- commented to reduce character for s2e optimization */
                oMatchContactsResponse.parse(calloutException);
            }
        }
        else{
            oMatchContactsResponse.parse(oValidationResult);
        }
        return oMatchContactsResponse;
        //return null;
    } 
    
/* End: Contact Data M360 Code Changes for new IDQ servie****************/

    //Internal Exeptions
    public class AddressCleanseServiceException extends Exception {}
    public class AccountMatchingServiceException extends Exception {}
    public class ContactMatchingServiceException extends Exception {}
    
    //Internal Data Structures
    
    /**
     * Address information for callouts to the cleanse address web service
     */
    public class Address{
        public string Name {get;set;}
        public string Street {get;set;}
        public string City {get;set;}
        public string State {get;set;}
        public string PostalCode {get;set;}
        public string Country {get;set;}
        public string County {get;set;}
        public string Province {get;set;}
        public string SuiteNumber {get;set;}
        public string POBox {get;set;}
        public string StreetRange {get;set;}
        public string StreetName {get;set;}
        public string StreetPreDir {get;set;}
        public string StreetPostDir {get;set;}
        public string StreetType {get;set;}
        public string SecondaryRange {get;set;}
    }
    
    /**
     * Account information for callouts to the ECM account matching/search web service
     */
    public class ECMAccountInfo{
        public Integer MatchScore;        
        public String Name{get;set;}        
        public String Street1{get;set;}
        public String Street2{get;set;}
        public String Country{get;set;}       
        public String State{get;set;}
        public String City{get;set;}
        public String PostalCode{get;set;} 
        public String SourceSystemId {get;set;}
        public String AddressId{get;set;}
        //For Party ID Search and Mixed Case
        public String partyRowId {get;set;}
        public String sourceSystemCodeSystems{get;set;}
        public String sourceSystemIdSystems{get;set;}
    }
    
    /**
     * Added by Arpit for R2
     * Contact information for callouts to the CDS account matching/search web service
     */
    public class CDSContactInfo{ 
        public String Source_System_ID {get;set;}
        public String Title {get;set;}
        public String First_Name {get;set;}
        public String Last_Name {get;set;}
        public String Contact_Email {get;set;}
        public String Contact_Phone {get;set;}
        public String Job_Function {get;set;}
        public String Account_Name {get;set;}
        public String Account_Address {get;set;}
        public String City {get;set;}
        public String State {get;set;}
        public String Country {get;set;}
        public String ZIP_Code {get;set;}
        public String Party_ID {get;set;} 
        public Integer PERSON_ID {get;set;}
        public String GLI_Account_ID {get;set;} // Added by Shovon
        public boolean Contact_Inactive {get;set;} // Added by Shovon for CRM-6056
    }
    
     /**
     * Contact information for callouts to the CDS Service
     */
    public class ContactDetails{
        public string firstName {get;set;}
        public string LastName {get;set;}
        public string gUltimate_ParentId {get;set;}
        public string searchType {get;set;}
        public string eMail {get;set;}
        public string phone {get;set;}
        public integer maxCount_GLI {get;set;}
        public integer maxCount_NonGLI {get;set;}
    }
    
    //R2 Ends
        
         /**
     * Account information for callouts to the account matching web service
     */
    public class AccountInfo{
        public Id AccountId {get;set;}
        public string MDBID {get;set;}
        public string SAPID {get;set;}
        public string Name {get;set;}
        public string Nametwo {get;set;}
        public string Namethree {get;set;}
        public string AddressLine1 {get;set;}
        public string City {get;set;}
        public string PostalCode {get;set;}
        public string Country {get;set;}
        public string POBox {get;set;}
        public string Score {get;set;}
    }
    
        /**
     * Contact information for callouts to the Contact matching web service
     */
    public class ContactInfo{
        public string MDBCustomerID {get;set;}
        public string MDBContactID {get;set;}
        public id contactID {get;set;}
        public string Name {get;set;}
        public string EMail {get;set;}
        public string Score {get;set;}
    }
    
    //Internal Web Service Requests
    
    /**
     * Base request class for web service calls to DQXI
     */
    public virtual class Request{
        public string Endpoint {get;set;}
        public decimal Timeout {get;set;}
        public string Username {get;set;}
        public string Password {get;set;}
        public Request(){
            this.Endpoint = '';
            this.Timeout = (10 * 1000); //10 Seconds
        }
    }
    
    /**
     * Request information for a cleanse address web service callout to DQXI
     */
    public class CleanseAddressRequest extends Request{
        public Address Address {get;set;}
        public CleanseAddressRequest(){
          this.Address = new Address();
        }
    }
    
    /**
     * Request information for an account matching/search web service callout to ECM
     */
    public class MatchAccountsRequest extends Request{
        public List<ECMAccountInfo> Accounts {get;set;}
        public MatchAccountsRequest(){
            this.Accounts = new List<ECMAccountInfo>();
        }
    }

   /**
     * Request information for an account matching web service callout to DQXI
     */
    public class MatchSF1AccountsRequest extends Request{
        public List<AccountInfo> Accounts {get;set;}
        public MatchSF1AccountsRequest(){
            this.Accounts = new List<AccountInfo>();
        }
    }

    /**
     * Request information for an Contact matching web service callout to DQXI
     */
    public class MatchContactsRequest extends Request{
        public List<ContactInfo> Contacts {get;set;}
        public MatchContactsRequest(){
            this.Contacts = new List<ContactInfo>();
        }
    }

    
    //Internal Web Service Responses
    
    /**
     * Base response class for web service calls to DQXI
     */
    public virtual class Response{
        public boolean IsSuccess {get;set;}
        public string ErrorMessage {get;set;}
        public Response(){
            this.IsSuccess = true;
            this.ErrorMessage = '';
        }
        public void parse(Exception oException){
            this.IsSuccess = false;
            this.ErrorMessage = oException.getMessage();
        }
        public void parse(ValidationResult oValidationResult) {
            this.IsSuccess = oValidationResult.isValid;
            this.ErrorMessage = oValidationResult.toString();
        }
    }
    
    /**
     * Response information for a cleanse address callout to DQXI
     */
    public class CleanseAddressResponse extends Response{
        public Address Address {get;set;}
        public CleanseAddressResponse(){
            this.Address = new Address();
        }
        
        public void parse(InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationResponseElement_element  oResponse){
            this.IsSuccess = true;
            this.Address = new Address();
            if (oResponse != null){
                this.Address.Name = oResponse.Name1;
                this.Address.Street = oResponse.Street;
                this.Address.City = oResponse.City;
                this.Address.State = oResponse.State_County;
                this.Address.Country = oResponse.Country;
                this.Address.PostalCode = oResponse.PostalCode;
                this.Address.County = oResponse.Province_2;
                this.Address.POBox = oResponse.POBox;
                this.IsSuccess = (oResponse.Mailability_Score != '0');
                if (oResponse.WS_SFDC_Address_ValidationSuggestionElement != null){
                    this.ErrorMessage = System.Label.DataQualityUtil_errmsg_The_specified_address_validity + '<br/>';
                    this.ErrorMessage += '<ul>';
                    for ( InformaticaAddressCleanse_WSObject.WS_SFDC_Address_ValidationSuggestionElement_element oSuggestion : oResponse.WS_SFDC_Address_ValidationSuggestionElement) {
                        string sAddress = AppUtil.isNull(oSuggestion.SL_Street,''); 
                        sAddress += '<br/>' + AppUtil.isNull(oSuggestion.SL_City, '') + ', ' + AppUtil.IsNull(oSuggestion.SL_State_County, '') + ' ' + AppUtil.isNull(oSuggestion.SL_PostalCode, '');
                        sAddress += '<br/>' + AppUtil.isNull(oSuggestion.SL_Country, '');
                        sAddress += '<br/>' + AppUtil.isNull(oSuggestion.SL_POBox, '');
                        this.ErrorMessage += string.format('<li>{0}</li>', new string[]{ sAddress });
                    }
                    this.ErrorMessage += '</ul>';
                }
                else{
                    this.ErrorMessage = '<ul>'+System.Label.DataQualityUtil_errmsg_The_specified_address_is_not_valid;
                }
            }
        }
    }
    
    /**
     * Response information for a match accounts callout to DQXI
     */
    public class MatchSF1AccountsResponse extends Response{
        public List<AccountInfo> Accounts {get;set;}
        public MatchSF1AccountsResponse(){
            this.Accounts = new List<AccountInfo>();
        }
        
       // public void parse(InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element[] oResponse) {
        public void parse(InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element[] oResponse){
            this.IsSuccess = true;
            this.Accounts = new List<AccountInfo>();
            if (oResponse != null) {
                for (InformaticaCustomerMatch_WSObject.WS_CustomerMatchResponseElement_element oResponseElement : oResponse) {
                    AccountInfo oAccount = new AccountInfo();
                    oAccount.AccountId = oResponseElement.SOURCE_ID;
                    oAccount.MDBID = oResponseElement.MATCH_MDBID;
                    oAccount.SAPID = oResponseElement.MATCH_SAPID;
                    oAccount.Name = oResponseElement.MATCH_NAME;
                    oAccount.Nametwo = oResponseElement.MATCH_NAME2;
                    oAccount.Namethree = oResponseElement.MATCH_NAME3;
                    oAccount.Nametwo = oResponseElement.MATCH_NAME2;
                    oAccount.Namethree = oResponseElement.MATCH_NAME3;
                    oAccount.AddressLine1 = oResponseElement.MATCH_ADDRESS;
                    oAccount.City = oResponseElement.MATCH_CITY;
                    oAccount.PostalCode = oResponseElement.MATCH_ZIPCODE;
                    oAccount.Country = oResponseElement.MATCH_COUNTRYCODE;
                    oAccount.POBox= oResponseElement.POBOX;
                    oAccount.Score = oResponseElement.MATCH_SCORE;
                    this.Accounts.add(oAccount);
                }
            }
        }
    }
    
    /**
     * Response information for a match accounts callout to DQXI
     */
    public class MatchAccountsResponse extends Response{
        public List<ECMAccountInfo> ECMAccounts {get;set;}
        public List<ECMAccountInfo> SFDCAccounts {get;set;}
        public MatchAccountsResponse(){
            this.ECMAccounts = new List<ECMAccountInfo>();
            this.SFDCAccounts = new List<ECMAccountInfo>();
        }
    
        
       // public void parse(InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element[] oResponse) {
        public void parse(ECMSearchServiceWSDL.SearchResults oResponse) {
            this.IsSuccess = true;// Call was successful TO DO- have to handle possible statuscode/StatusDescription
            this.ECMAccounts = new List<ECMAccountInfo>();
            this.SFDCAccounts = new List<ECMAccountInfo>();   
            Map<String,String> mapAddressSourceSystem = new Map<String,String>();
            // LCRM changes on 9/9/16  by Ravi                                             
            String sUserSubBU = LCRMGenericComponent.getUserBU();
            Boolean bLCRMUserBU = LCRMGenericComponent.validateUserBU(sUserSubBU);
            //System.debug('Checking oResponse != null'+oResponse != null);
            if (oResponse != null) {
                if(oResponse.Parties !=null && oResponse.Parties.Party!=null){
                for (ECMSearchServiceWSDL.Party objParty : oResponse.Parties.Party) {
                    for(ECMSearchServiceWSDL.PartyAddress objPartyAddress : objParty.Addresses.PartyAddress){
                        if(this.ECMAccounts.size() < Integer.valueOf(ECM_MAX_ADDRESS_RESULTS.TextValue__c))
                        {
                        for(ECMSearchServiceWSDL.AddressSourceSystem objSourceSystem : objPartyAddress.AddressSourceSystems.AddressSourceSystem){                        
/*system.debug('+++++ objSourceSystem.AddressSourceSystemCode '+ objSourceSystem.AddressSourceSystemCode);-- commented to reduce character for s2e optimization */    
                            //mapAddressSourceSystem.put(objSourceSystem.AddressSourceSystemCode,objSourceSystem.AddressSourceSystemId.substringAfter(ECM_AddressSourceId_Prefix.TextValue__c) ); //Maintain a map to get addresssourcesystems under a partyAddress
                             mapAddressSourceSystem.put(objSourceSystem.AddressSourceSystemCode,objSourceSystem.AddressSourceSystemId.substring(3)); //Maintain a map to get addresssourcesystems under a partyAddress
                        }
/*System.Debug('+++++ mapAddressSourceSystem '+mapAddressSourceSystem);-- commented to reduce character for s2e optimization */
                        // START modifying the LCRM Call by Ravi
                        if(bLCRMUserBU = true && mapAddressSourceSystem.get(GLI_ECM_AddressSourceSystemCode.TextValue__c) !=null ){
                            ECMAccountInfo oSFDCAccount = new ECMAccountInfo();
                                oSFDCAccount= setECMAccountInfo(objParty,objPartyAddress,mapAddressSourceSystem.get(GLI_ECM_AddressSourceSystemCode.TextValue__c));
                                this.SFDCAccounts.add(oSFDCAccount); 
                        }
                        else if(bLCRMUserBU = false && mapAddressSourceSystem.get(ECM_AddressSourceSystemCode.TextValue__c) !=null) {                      
                                ECMAccountInfo oSFDCAccount = new ECMAccountInfo();
                                oSFDCAccount= setECMAccountInfo(objParty,objPartyAddress,mapAddressSourceSystem.get(ECM_AddressSourceSystemCode.TextValue__c));
                                this.SFDCAccounts.add(oSFDCAccount);
                         }
                         // End modifying the LCRM Call by Ravi
                        else{
                                ECMAccountInfo oECMAccount = new ECMAccountInfo();
                                oECMAccount = setECMAccountInfo(objParty,objPartyAddress,'');
                                this.ECMAccounts.add(oECMAccount);                                       
                        }
                   mapAddressSourceSystem.clear();// Clear the map before next iteration of partyAddress                  
                }
              }//end of PartyAddress loop
            }//end of Party loop
/*System.debug('this.ECMAccounts'+this.ECMAccounts);
                    System.debug('this.SFDCAccounts'+this.SFDCAccounts);-- commented to reduce character for s2e optimization */
      }
      else{
            this.IsSuccess = false;
            if(oResponse.StatusDescription !=null && oResponse.StatusDescription !=''){
                String strStatusDescription = oResponse.StatusDescription.length() >50? oResponse.StatusDescription.substring(0,50):oResponse.StatusDescription;
                this.ErrorMessage = System.Label.DataQualityUtil_errmsg_Response_from_ECM + System.Label.DataQualityUtil_errmsg_Status_Code +oResponse.StatusCode+'<br/>' + System.Label.DataQualityUtil_errmsg_Description +strStatusDescription ;
            }
      }   
     }
    }
        
        //Method to parse Mixed Case response
        public void parseMixedCase(ECMSearchServiceWSDL.GetResults oResponseMixedCase){
            this.IsSuccess = true;// Call was successful TO DO- have to handle possible statuscode/StatusDescription
            this.ECMAccounts = new List<ECMAccountInfo>();
            this.SFDCAccounts = new List<ECMAccountInfo>();   
            Map<String,String> mapAddressSourceSystem = new Map<String,String>();
            // LCRM changes on 9/9/16  by Ravi                                             
            String sUserSubBU = LCRMGenericComponent.getUserBU();
            Boolean bLCRMUserBU = LCRMGenericComponent.validateUserBU(sUserSubBU);
            //System.debug('Checking oResponseMixedCase != null'+oResponseMixedCase != null);
            if (oResponseMixedCase != null){
                if(oResponseMixedCase.Party !=null){
                    for(ECMSearchServiceWSDL.PartyAddress objPartyAddress : oResponseMixedCase.Party.Addresses.PartyAddress){
                         ECMAccountInfo oECMAccount = new ECMAccountInfo();
                         oECMAccount = setECMAccountInfo(oResponseMixedCase.Party,objPartyAddress,'');
                         this.ECMAccounts.add(oECMAccount);
              }//end of PartyAddress loop
/*System.debug('this.ECMAccounts'+this.ECMAccounts);
                    System.debug('this.SFDCAccounts'+this.SFDCAccounts);-- commented to reduce character for s2e optimization */
            }
            else{
              this.IsSuccess = false;
              if(oResponseMixedCase.StatusDescription !=null && oResponseMixedCase.StatusDescription !=''){
                 String strStatusDescription = oResponseMixedCase.StatusDescription.length() >50? oResponseMixedCase.StatusDescription.substring(0,50):oResponseMixedCase.StatusDescription;
                 this.ErrorMessage = System.Label.DataQualityUtil_errmsg_Response_from_ECM +System.Label.DataQualityUtil_errmsg_Status_Code +oResponseMixedCase.StatusCode+'<br/>'+System.Label.DataQualityUtil_errmsg_Description +strStatusDescription ;
                }
           } 
     }
    }
        
        /*** Method to parse the response returned as a result of manual search while Lead Conversion**/
        public void parseAccManualSearch(ECMSearchServiceWSDL.SearchResults oResponse){
            this.IsSuccess = true;// Call was successful TO DO- have to handle possible statuscode/StatusDescription
            this.ECMAccounts = new List<ECMAccountInfo>();
            this.SFDCAccounts = new List<ECMAccountInfo>();   
            Map<String,String> mapAddressSourceSystem = new Map<String,String>();
            String sUserSubBU = LCRMGenericComponent.getUserBU();
            Boolean bLCRMUserBU = LCRMGenericComponent.validateUserBU(sUserSubBU);
            Integer maxAccountCountAllowed = Integer.ValueOf(accountCountConfig.TextValue__c); 
            Integer ecmAccountCount = 1;
            Integer gliAccountCount = 1;
            if (oResponse != null) {
                if(oResponse.Parties !=null && oResponse.Parties.Party!=null){
                    for (ECMSearchServiceWSDL.Party objParty : oResponse.Parties.Party) {
                        for(ECMSearchServiceWSDL.PartyAddress objPartyAddress : objParty.Addresses.PartyAddress){
                            for(ECMSearchServiceWSDL.AddressSourceSystem objSourceSystem : objPartyAddress.AddressSourceSystems.AddressSourceSystem){                        
                                mapAddressSourceSystem.put(objSourceSystem.AddressSourceSystemCode,objSourceSystem.AddressSourceSystemId.substring(3)); //Maintain a map to get addresssourcesystems under a partyAddress
                            }
                            // START modifying the LCRM Call by Ravi
                            if(bLCRMUserBU = true && mapAddressSourceSystem.get(GLI_ECM_AddressSourceSystemCode.TextValue__c) !=null ){
                                ECMAccountInfo oSFDCAccount = new ECMAccountInfo();
                                /*GLI_ECM_AddressSourceSystemCode.TextValue__c)*/ 
                                oSFDCAccount= setECMAccountInfo(objParty,objPartyAddress,mapAddressSourceSystem.get(GLI_ECM_AddressSourceSystemCode.TextValue__c));
                                if(gliAccountCount <= maxAccountCountAllowed){
                                    this.SFDCAccounts.add(oSFDCAccount);
                                }
                                gliAccountCount++;
                            }
                            else if(bLCRMUserBU = false && mapAddressSourceSystem.get(ECM_AddressSourceSystemCode.TextValue__c) !=null) {                      
                                ECMAccountInfo oSFDCAccount = new ECMAccountInfo();
                                oSFDCAccount= setECMAccountInfo(objParty,objPartyAddress,mapAddressSourceSystem.get(ECM_AddressSourceSystemCode.TextValue__c));
                                if(gliAccountCount <= maxAccountCountAllowed){
                                    this.SFDCAccounts.add(oSFDCAccount);
                                }
                                gliAccountCount++;
                            }
                            // End modifying the LCRM Call by Ravi
                            else{
                                ECMAccountInfo oECMAccount = new ECMAccountInfo();
                                oECMAccount = setECMAccountInfo(objParty,objPartyAddress,String.valueOf(ecmAccountCount));
                                if(ecmAccountCount <= maxAccountCountAllowed){
                                    this.ECMAccounts.add(oECMAccount);
                                }
                              ecmAccountCount++;
                            }
                         mapAddressSourceSystem.clear();// Clear the map before next iteration of partyAddress 
                        }//end of PartyAddress loop
                    }//end of Party loop
/*System.debug('this.ECMAccounts'+this.ECMAccounts);
                    System.debug('this.SFDCAccounts'+this.SFDCAccounts);-- commented to reduce character for s2e optimization */
                }
                else{
                    this.IsSuccess = false;
                    if(oResponse.StatusDescription !=null && oResponse.StatusDescription !=''){
                        String strStatusDescription = oResponse.StatusDescription.length() >50? oResponse.StatusDescription.substring(0,50):oResponse.StatusDescription;
                        this.ErrorMessage = System.Label.DataQualityUtil_errmsg_Response_from_ECM + System.Label.DataQualityUtil_errmsg_Status_Code +oResponse.StatusCode+'<br/>' + System.Label.DataQualityUtil_errmsg_Description +strStatusDescription ;
                    }
                }
            }
        }
        
        /** Method for Getting the Party by passing the Party ID.
         ** This method will be called during Lead Conversion.  
        **/
        
        public void parseParty(ECMSearchPartyWSDL.RetrievePartyResults oResponse){
            //system.debug('+++ Inside parseParty');
            this.IsSuccess = true;// Call was successful TO DO- have to handle possible statuscode/StatusDescription
            this.ECMAccounts = new List<ECMAccountInfo>();
            this.SFDCAccounts = new List<ECMAccountInfo>();
            Map<String,String> mapAddressSourceSystem = new Map<String,String>();
            // LCRM changes on 9/9/16  by Ravi                                             
            String sUserSubBU = LCRMGenericComponent.getUserBU();
            Boolean bLCRMUserBU = LCRMGenericComponent.validateUserBU(sUserSubBU);
            Integer maxAccountCountAllowed = Integer.ValueOf(accountCountConfig.TextValue__c); 
            Integer ecmAccountCount = 1;
            Integer gliAccountCount = 1;
            String gliLeadAccountId = null;
            ECMAccountInfo leadAccountDetails = null;
            //System.debug('Checking oResponse != null'+oResponse != null);
            if (oResponse != null){
                //system.debug('+++ Inside oResponse IF '+ existingAccountInfo1);
                if(existingAccountInfo1.name != null){
                    system.debug('+++ Inside LCRMConvertLeadController.existingAccountInfo1');
                    gliLeadAccountId = existingAccountInfo1.SourceSystemId;
                    this.SFDCAccounts.add(existingAccountInfo1);
                    gliAccountCount++;
                }
                system.debug('+++ Outside oResponse IF');
                if(oResponse.Party.Addresses !=null){
                    for(ECMSearchPartyWSDL.PartyAddress objPartyAddress : oResponse.Party.Addresses.PartyAddress){
                        for(ECMSearchPartyWSDL.AddressSourceSystem objSourceSystem : objPartyAddress.AddressSourceSystems.AddressSourceSystem){                        
                            /*system.debug('+++++ objSourceSystem.AddressSourceSystemCode '+ objSourceSystem.AddressSourceSystemCode);-- commented to reduce character for s2e optimization */
                            //mapAddressSourceSystem.put(objSourceSystem.AddressSourceSystemCode,objSourceSystem.AddressSourceSystemId.substringAfter(ECM_AddressSourceId_Prefix.TextValue__c) ); //Maintain a map to get addresssourcesystems under a partyAddress
                            mapAddressSourceSystem.put(objSourceSystem.AddressSourceSystemCode,objSourceSystem.AddressSourceSystemId.substring(3)); //Maintain a map to get addresssourcesystems under a partyAddress
                        }
                        /*System.Debug('+++++ mapAddressSourceSystem '+mapAddressSourceSystem);-- commented to reduce character for s2e optimization */
                        // START modifying the LCRM Call by Ravi
                        if(bLCRMUserBU = true && mapAddressSourceSystem.get(GLI_ECM_AddressSourceSystemCode.TextValue__c) !=null ){
                            if(gliLeadAccountId != mapAddressSourceSystem.get(GLI_ECM_AddressSourceSystemCode.TextValue__c))
                            {
                                ECMAccountInfo oSFDCAccount = new ECMAccountInfo();
                                oSFDCAccount= setECMPartyAccountInfo(oResponse.Party,objPartyAddress,mapAddressSourceSystem.get(GLI_ECM_AddressSourceSystemCode.TextValue__c));
                                if(gliAccountCount <= maxAccountCountAllowed){
                                    this.SFDCAccounts.add(oSFDCAccount);
                                }
                                gliAccountCount++;
                            }
                        }
                        else if(bLCRMUserBU = false && mapAddressSourceSystem.get(ECM_AddressSourceSystemCode.TextValue__c) !=null) {                      
                            if(gliLeadAccountId != mapAddressSourceSystem.get(GLI_ECM_AddressSourceSystemCode.TextValue__c))
                            {    
                            ECMAccountInfo oSFDCAccount = new ECMAccountInfo();
                                oSFDCAccount= setECMPartyAccountInfo(oResponse.Party,objPartyAddress,mapAddressSourceSystem.get(ECM_AddressSourceSystemCode.TextValue__c));
                                   if(gliAccountCount <= maxAccountCountAllowed){
                                        this.SFDCAccounts.add(oSFDCAccount); 
                                    }
                                    gliAccountCount++;
                            }
                         }
                         // End modifying the LCRM Call by Ravi
                        else{
                            ECMAccountInfo oECMAccount = new ECMAccountInfo();
                            oECMAccount = setECMPartyAccountInfo(oResponse.Party,objPartyAddress,String.valueOf(ecmAccountCount) );
                            if(ecmAccountCount <= maxAccountCountAllowed){
                                this.ECMAccounts.add(oECMAccount);
                            }
                            ecmAccountCount++;
                           }
                      mapAddressSourceSystem.clear();// Clear the map before next iteration of partyAddress
              }//end of PartyAddress loop
/*System.debug('this.ECMAccounts'+this.ECMAccounts);
                    System.debug('this.SFDCAccounts'+this.SFDCAccounts);-- commented to reduce character for s2e optimization */
           }
           else{
                 this.IsSuccess = false;
                 if(oResponse.StatusDescription !=null && oResponse.StatusDescription !=''){
                     String strStatusDescription = oResponse.StatusDescription.length() >50? oResponse.StatusDescription.substring(0,50):oResponse.StatusDescription;
                     this.ErrorMessage = System.Label.DataQualityUtil_errmsg_Response_from_ECM +System.Label.DataQualityUtil_errmsg_Status_Code +oResponse.StatusCode+'<br/>' + System.Label.DataQualityUtil_errmsg_Description +strStatusDescription ;
                  }
                }
     }
    }   
   } //end MatchAccountsResponse class    
  
    
    public static ECMAccountInfo setECMAccountInfo(ECMSearchServiceWSDL.Party objParty,ECMSearchServiceWSDL.PartyAddress objPartyAddress,String strSourceSystemId)
    {
        ECMAccountInfo oAccount = new ECMAccountInfo();
        oAccount.Name = objParty.FullName;
        oAccount.MatchScore = objParty.MatchScore;
        oAccount.City = objPartyAddress.City;
        oAccount.State = objPartyAddress.State;
        oAccount.PostalCode = objPartyAddress.ZipPostalCode;
        oAccount.Country = objPartyAddress.Country;
        oAccount.AddressId = objPartyAddress.AddressRowId;
        oAccount.SourceSystemId = strSourceSystemId; 
/*System.debug('******** strSourceSystemId '+strSourceSystemId);-- commented to reduce character for s2e optimization */
        if(objPartyAddress.AddressLine1<> null && objPartyAddress.AddressLine1<>''){
            oAccount.Street1 = objPartyAddress.AddressLine1;
            oAccount.Street2 = objPartyAddress.AddressLine2;
        }
        else{
            oAccount.Street1 = objPartyAddress.AddressLine2;
            oAccount.Street2 = objPartyAddress.AddressLine3;
        }
        //Changes for Mixed Case PoC Starts
        oAccount.partyRowId = objParty.PartyRowId;
        return oAccount;
    }
    
    //For Party Id Search
    
    public static ECMAccountInfo setECMPartyAccountInfo(ECMSearchPartyWSDL.Party objParty,ECMSearchPartyWSDL.PartyAddress objPartyAddress,String strSourceSystemId)
    {
        ECMAccountInfo oAccount = new ECMAccountInfo();
        oAccount.Name = objParty.FullName;
        //oAccount.MatchScore = objParty.MatchScore;
        oAccount.City = objPartyAddress.City;
        oAccount.State = objPartyAddress.State;
        oAccount.PostalCode = objPartyAddress.ZipPostalCode;
        oAccount.Country = objPartyAddress.Country;
        oAccount.AddressId = objPartyAddress.AddressRowId;
        oAccount.SourceSystemId = strSourceSystemId;
/*System.debug('******** strSourceSystemId '+strSourceSystemId);-- commented to reduce character for s2e optimization */
        if(objPartyAddress.AddressLine1<> null && objPartyAddress.AddressLine1<>''){
            oAccount.Street1 = objPartyAddress.AddressLine1;
            oAccount.Street2 = objPartyAddress.AddressLine2;
        }
        else{
            oAccount.Street1 = objPartyAddress.AddressLine2;    
            oAccount.Street2 = objPartyAddress.AddressLine3; 
        }
        //Changes for Mixed Case PoC Starts
        oAccount.partyRowId = objParty.PartyRowId;
        return oAccount;
    }
    
    /**
     * Response information for a match Contacts callout to DQXI
     */
    public class MatchContactsResponse extends Response{
        public List<ContactInfo> Contacts {get;set;}
        public MatchContactsResponse(){
            this.Contacts = new List<ContactInfo>();
        }
        public void parse(ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element[] oResponse){
            this.IsSuccess = true;
            this.Contacts = new List<ContactInfo>();
            if (oResponse != null){
                for (ContactDeDupWSObjects.WS_Contact_MatchResponseElement_element oResponseElement : oResponse){
                ContactInfo oContact = new ContactInfo();    
                oContact.MDBCustomerID = oResponseElement.MDB_CUSTOMER_ID;
                oContact.MDBContactID = oResponseElement.MDB_CONTACT_ID;
                oContact.Name = oResponseElement.MATCH_NAME;
                oContact.EMail = oResponseElement.MATCH_EMAIL;
                oContact.Score =oResponseElement.MATCH_SCORE;
                this.Contacts.add(oContact);
               }
            }
        }
    }
    
    /**
     * Response information for Contact Search Call out
     * This method will be calledduring Lead Conversion after receving response from CDS.
     * R2
     */
    public class MatchContactsSearchResponse extends Response{
        public List<CDSContactInfo> CDSContacts {get;set;}
        public List<CDSContactInfo> SFDCContacts {get;set;}
        public MatchContactsSearchResponse(){
        this.CDSContacts = new List<CDSContactInfo>();
        this.SFDCContacts = new List<CDSContactInfo>();
    }
        
        
        public void parse(CDSSearchServiceWsdl.CDS_Output_Summary_element[] oResponse){ 
            this.IsSuccess = true;
            if (oResponse != null){
                for (CDSSearchServiceWsdl.CDS_Output_Summary_element oSummaryElement : oResponse){
                    for (CDSSearchServiceWsdl.CDS_Output_Detail_element oResponseElement : oSummaryElement.CDS_Output_Detail) {
                        if(oResponseElement.Source_System_ID != null && oResponseElement.Source_System_ID.startsWith('003') && oResponseElement.Source_System_ID.length() == 18){
                            SFDCContacts.add(setContactInfo(oResponseElement));
                        }else{
                            CDSContacts.add(setContactInfo(oResponseElement));
                        }
                    }
                }
            }
        }
    }
    
     public static CDSContactInfo setContactInfo(CDSSearchServiceWsdl.CDS_Output_Detail_element outputDetails)
    {
        CDSContactInfo contactInfo = new CDSContactInfo();
        contactInfo.Title = outputDetails.Title;
        contactInfo.First_Name = outputDetails.First_Name;
        contactInfo.Last_Name = outputDetails.Last_Name;
        contactInfo.Contact_Email = outputDetails.Contact_Email;
        contactInfo.Contact_Phone = outputDetails.Contact_Phone;
        contactInfo.Job_Function = outputDetails.Job_Function;
        contactInfo.Party_ID = outputDetails.Party_ID;
        contactInfo.Source_System_Id = outputDetails.Source_System_Id;
        contactInfo.Account_Address = outputDetails.Account_Address;
        contactInfo.Account_Name = outputDetails.Account_Name;
        contactInfo.City= outputDetails.City;
        contactInfo.State= outputDetails.State;
        contactInfo.ZIP_Code= outputDetails.ZIP_Code;
        contactInfo.PERSON_ID= outputDetails.PERSON_ID;
        contactInfo.GLI_Account_ID= outputDetails.GLI_Account_ID; // Added by Shovon
        contactInfo.Contact_Inactive= outputDetails.Contact_Inactive; // Added by Shovon for CRM-6056
        return contactInfo;
    }

    
    /*R2 code **************************************************************************    
    
    /**
     * Request information for an Contact matching/search web service callout to CDS
     */
    public class MatchCDSContactsRequest extends Request{
        public ContactDetails Contacts {get;set;}
        public MatchCDSContactsRequest(){
            this.Contacts = new ContactDetails();
        }
    }
    
    
    /**
     * Initiates a web service command to search for contacts from CDS. 
     * It will return both CDS and Salesforce contacts.
     *
     * @param   listcontacts    a list of contact objects to match against
     * @return  a list of DataQualityUtil.contact objects
     */
    
    public static MatchContactsSearchResponse  matchCDSContacts(ContactDetails contactsDetails){
/*system.debug('+++ Inside matchCDSContacts with contactDetails');-- commented to reduce character for s2e optimization */
        WebServiceSettings__c oWebServiceSettings = null;
        if(isContactCall){
            oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.CDSContactSearchServiceNameContact);
        }else{
           oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.CDSContactSearchServiceName); 
        }
        //WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.CDSContactSearchServiceName);
        List<ContactDetails> listMatchedContacts = new List<ContactDetails>();
        MatchContactsSearchResponse oResponse = new MatchContactsSearchResponse();
         if (contactsDetails != null){
            MatchCDSContactsRequest oRequest = new MatchCDSContactsRequest();
            oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
/*system.debug('oWebServiceSettings.Endpoint__c '+ oWebServiceSettings.Endpoint__c);-- commented to reduce character for s2e optimization */
            oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
            oRequest.Contacts = contactsDetails;
            oRequest.Username = oWebServiceSettings.Username__c;
            oRequest.Password = oWebServiceSettings.Password__c;
            oResponse = matchCDSContacts(oRequest);
/*system.debug('@@@SKGResponse ' +oResponse);-- commented to reduce character for s2e optimization */
            if (oResponse.IsSuccess == false){
                throw new ContactMatchingServiceException(oResponse.ErrorMessage);
            }
        }
       return oResponse;
    }
    

    
    /**
     * Initiates a web service command to search for contacts from CDS. 
     * It will return both CDS and Salesforce contacts.
     *
     * @param   oMatchContactsRequest   an instance of a MatchContactsRequest object
     * @return  an instance of an MatchContactsResponse object
     */ 
    
public static MatchContactsSearchResponse matchCDSContacts(MatchCDSContactsRequest oMatchcontactsRequest){
        MatchContactsSearchResponse oMatchCDSContactsResponse = new MatchContactsSearchResponse();
            //Initialize Web Service
            CDSSearchService.GLI_Contact_Port oService = new CDSSearchService.GLI_Contact_Port();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.timeout_x = oMatchContactsRequest.Timeout.intValue();
            oService.endpoint_x = oMatchContactsRequest.EndPoint;
            //oService.endpoint_x = 'https://tr-mis-infadv.thomsonreuters.com/wsh/services/RealTime/WS_CDS_Contact_Search_from_GLI_LEAD';
    try {
/*system.debug('++++ BEFORE Initiating CDS Service call out '+ oMatchcontactsRequest);
        system.debug('++++ oMatchcontactsRequest.Contacts.firstName '+ oMatchcontactsRequest.Contacts.firstName);
        system.debug('++++ oMatchcontactsRequest.Contacts.phone '+ oMatchcontactsRequest.Contacts.phone);        
        system.debug('++++ oMatchcontactsRequest.Contacts.gUltimate_ParentId '+ oMatchcontactsRequest.Contacts.gUltimate_ParentId);-- commented to reduce character for s2e optimization */
                //Submit Request
    CDSSearchServiceWsdl.CDS_Output_Summary_element[] oResponse = oService.GLI_Contact_Operation(oMatchcontactsRequest.Contacts.searchType, oMatchcontactsRequest.Contacts.gUltimate_ParentId, oMatchcontactsRequest.Contacts.firstName, oMatchcontactsRequest.Contacts.LastName, oMatchcontactsRequest.Contacts.eMail, oMatchcontactsRequest.Contacts.phone, oMatchcontactsRequest.Contacts.maxCount_GLI, oMatchcontactsRequest.Contacts.maxCount_NonGLI);
/*system.debug('+++ response from CDS service is '+ oResponse);-- commented to reduce character for s2e optimization */
                oMatchCDSContactsResponse.parse(oResponse);
            }
            catch (CalloutException calloutException){
/*system.debug('+++ Inside calloutException block');
                system.debug('+++ calloutException '+ calloutException.getStackTraceString());
                system.debug('+++ calloutException '+ calloutException.getLineNumber());
                system.debug('+++ calloutException '+ calloutException.getCause());-- commented to reduce character for s2e optimization */
                oMatchCDSContactsResponse.parse(calloutException);
            }
        return oMatchCDSContactsResponse;
    }    
    
    /************** Temp Code for ECM Call out ****************/
    
    public static MatchAccountsResponse MatchECMAccountsLC(List<ECMAccountInfo> listAccounts){
        WebServiceSettings__c oWebServiceSettings = null;
        MatchAccountsResponse oResponse;
        List<ECMAccountInfo> listMatchedAccounts = new List<ECMAccountInfo>();
        if (listAccounts.isEmpty() == false) {
            MatchAccountsRequest oRequest = new MatchAccountsRequest();
/*System.debug('oRequest...' + oRequest);-- commented to reduce character for s2e optimization */
             //oResponse = tempMatchECMAccounts(oRequest);
            if(manualAccountSearch){
                oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.ECMAccountMatchingServiceName);
                oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
                oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
                oRequest.Username = oWebServiceSettings.Username__c;
                oRequest.Password = oWebServiceSettings.Password__c;
                oRequest.Accounts = listAccounts;
                oResponse = MatchECMAccountsManualSearch(oRequest);
            }else{
                oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.ECMAccountMatchingPartyServiceName);
                oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
                oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
                oRequest.Accounts = listAccounts;
                oRequest.Username = oWebServiceSettings.Username__c;
                oRequest.Password = oWebServiceSettings.Password__c;
                oResponse = GetECMParty(oRequest);
            }
/*system.debug('++++++ oResponse is '+ oResponse.IsSuccess);-- commented to reduce character for s2e optimization */
            if (oResponse.IsSuccess == false){
/*system.debug('+++ inside oResponse.IsSuccess = false');-- commented to reduce character for s2e optimization */
                if(oResponse.ErrorMessage.Contains(System.Label.DataQualityUtil_errmsg_Description + 'EM003 - No results found for specified criteria')){
/*system.debug('+++ inside IF ');-- commented to reduce character for s2e optimization */
                    String Err = System.Label.LCRM_ECM_Information_Message;
                    ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.INFO,+Err);
                    ApexPages.addMessage(msg);
                    //throw new AccountMatchingServiceException(oResponse.ErrorMessage);
                }
                else{
                    //ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.INFO,+oResponse.ErrorMessage);
                    //ApexPages.addMessage(msg);
/*system.debug('+++ inside ELSE before throwing AccountMatchingServiceException');-- commented to reduce character for s2e optimization */
                    throw new AccountMatchingServiceException(oResponse.ErrorMessage);
                }
            }
        }
        //return listMatchedAccounts;
        return oResponse;
    }
    
    public static MatchAccountsResponse MatchECMAccountsManualSearch(MatchAccountsRequest oMatchAccountsRequest){
        MatchAccountsResponse oMatchAccountsResponse = new MatchAccountsResponse();
        ECMSearchServiceWSDL.SearchResults oResponse;
        ValidationResult oValidationResult = validateRequest(oMatchAccountsRequest);
        if (oValidationResult.isValid){
            //Initialize Web Service
           // InformaticaCustomerMatchWS.WS_Customer_MatchPort oService = new InformaticaCustomerMatchWS.WS_Customer_MatchPort();
            ECMSearchServiceWSDL.IcglV1PortTypePort oService = new ECMSearchServiceWSDL.IcglV1PortTypePort();
            oService.inputHttpHeaders_x = new Map<String, String>();
            Blob blobCredentials = Blob.valueOf(oMatchAccountsRequest.Username + ':' + oMatchAccountsRequest.Password);
            string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            oService.timeout_x = oMatchAccountsRequest.Timeout.intValue();
            oService.endpoint_x = oMatchAccountsRequest.EndPoint;
            ECMSearchServiceWSDL.EAIHeader objEAIHeader = new ECMSearchServiceWSDL.EAIHeader();
            objEAIHeader.applicationId = 'S2E';
            objEAIHeader.transactionId = AccountUtil.getTimeStamp();
            //Map Request
            ECMSearchServiceWSDL.SearchRequest oRequest = new ECMSearchServiceWSDL.SearchRequest();
            for (ECMAccountInfo oAccount : oMatchAccountsRequest.Accounts){
                oRequest.Firstname = '';
                oRequest.Middlename = '';
                oRequest.Lastname = '';
                oRequest.Fullname = oAccount.Name;
                oRequest.Address = oAccount.Street1;
                oRequest.City = oAccount.City;
                oRequest.State = oAccount.State;
                oRequest.Country = oAccount.Country;
                oRequest.Zipcode = oAccount.PostalCode;
                oRequest.PageSize= integer.ValueOf(ECMPageSize.TextValue__c);
                oRequest.PageNumber= integer.ValueOf(ECMPageNumber.TextValue__c);
                oRequest.Username= ECMUsername.TextValue__c;                
                oRequest.Password= ECMPassword.TextValue__c;  
                oRequest.AuditToken= '';
                oRequest.Header= '';             
            }
/*System.debug('matchAccounts.Request: ' + oRequest);-- commented to reduce character for s2e optimization */
            try {
                //Submit Request
                oResponse  = oService.SearchParty(oRequest.EAIHeader, oRequest.Firstname, oRequest.Middlename, oRequest.Lastname, oRequest.Fullname,
                                   oRequest.Address, oRequest.City, oRequest.State, oRequest.Country, oRequest.Zipcode,
                                   oRequest.PageSize, oRequest.PageNumber, oRequest.Username, oRequest.Password, 
                                   oRequest.AuditToken, oRequest.Header);
System.debug('matchAccounts.Response: ' + oResponse);
          /*      System.debug('came to try');-- commented to reduce character for s2e optimization */
                oMatchAccountsResponse.parseAccManualSearch(oResponse);
            }
            catch (CalloutException calloutException){
/* System.debug('came to catch 1 '+calloutException.getmessage()); -- commented to reduce character for s2e optimization */
                oMatchAccountsResponse.parse(calloutException);
           }
            catch (Exception e){
/*System.debug('came to catch 2 '+e.getmessage());-- commented to reduce character for s2e optimization */
                oMatchAccountsResponse.parse(e);
            }
        }
        else{
            oMatchAccountsResponse.parse(oValidationResult);
        }
        return oMatchAccountsResponse;
    }
    
    //PoC for Get Party ID.
    public static MatchAccountsResponse GetECMParty(MatchAccountsRequest oMatchAccountsRequest){
        MatchAccountsResponse oMatchAccountsResponse = new MatchAccountsResponse();
        ECMSearchPartyWSDL.RetrievePartyResults oResponse;
        ValidationResult oValidationResult = validateRequest(oMatchAccountsRequest);
        if (oValidationResult.isValid){
            //Initialize Web Service
           // InformaticaCustomerMatchWS.WS_Customer_MatchPort oService = new InformaticaCustomerMatchWS.WS_Customer_MatchPort();
            ECMSearchPartyWSDL.MDMV1PortTypePort oService = new ECMSearchPartyWSDL.MDMV1PortTypePort();
            oService.inputHttpHeaders_x = new Map<String, String>();
            Blob blobCredentials = Blob.valueOf(oMatchAccountsRequest.Username + ':' + oMatchAccountsRequest.Password);
            string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            oService.timeout_x = oMatchAccountsRequest.Timeout.intValue();
            oService.endpoint_x = oMatchAccountsRequest.EndPoint;
/*System.debug('matchAccounts.Endpoint: ' + oMatchAccountsRequest.EndPoint);-- commented to reduce character for s2e optimization */
            ECMSearchPartyWSDL.ESIHEADER objEAIHeader = new ECMSearchPartyWSDL.ESIHEADER();
            objEAIHeader.applicationId = 'GLI';
            objEAIHeader.transactionId = AccountUtil.getTimeStamp();
            //Map Request
            ECMSearchPartyWSDL.RetrievePartyRequest oRequest = new ECMSearchPartyWSDL.RetrievePartyRequest();
            for (ECMAccountInfo oAccount : oMatchAccountsRequest.Accounts) {
                oRequest.ESIHEADER= objEAIHeader;
                oRequest.PartyId= oAccount.partyRowId;
                oRequest.SourceSystemCode= '';
                oRequest.SourceSystemId= '';             
                oRequest.Username= ECMUsername.TextValue__c;                
                oRequest.Password= ECMPassword.TextValue__c;  
                oRequest.AuditToken= '';
                oRequest.Header = '';
            }
/*System.debug('Search by Party ID Request: ' + oRequest);-- commented to reduce character for s2e optimization */
            try {
                //Submit Request              
/*system.debug('+++ 1 Srini '+ oService);-- commented to reduce character for s2e optimization */
                oResponse  = oService.RetrieveParty(oRequest.ESIHeader, oRequest.PartyId, oRequest.SourceSystemCode, oRequest.SourceSystemId, oRequest.Username, oRequest.Password, 
                                                  oRequest.AuditToken,  oRequest.Header);
/*System.debug('matchAccounts.Response: ' + oResponse);
                System.debug('came to try');-- commented to reduce character for s2e optimization */
                oMatchAccountsResponse.parseParty(oResponse);
            }
            catch (CalloutException calloutException){
/*system.debug('+++ 2 Srini');
                System.debug('came to catch 1 '+calloutException.getmessage());-- commented to reduce character for s2e optimization */
                oMatchAccountsResponse.parse(calloutException);
            }
            catch (Exception e){
/*System.debug('came to catch 2 '+e.getmessage());
                System.debug('came to catch 2 '+e.getStackTraceString());
                System.debug('came to catch 2 get Cause'+e.getCause());
                System.debug('came to catch 2 get lineno'+e.getLineNumber());-- commented to reduce character for s2e optimization */
                oMatchAccountsResponse.parse(e);
            }
        }
        else {
            oMatchAccountsResponse.parse(oValidationResult);
        }
        return oMatchAccountsResponse;
    }
    //Poc for get Party ID ends
}