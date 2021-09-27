/**
* Provides methods helper methods for working with accounts
*
* @author  John De Santiago - Thomson Reuters Code Share
* @version 2011-03-24
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2011-03-24   John De Santiago        Created
* 2011-06-20   Nick Cook               Commented the market segment portion of the
dedupe token. 
* 2011-06-20   Nick Cook               Commented references to County field.       
* 2011-06-20   Nick Cook               Added default sales org = WEST       
* 2012-05-10   John De Santiago        Cleaned up class and added address helper methods
* 2012-12-11   Shawn Gray              Added Default sales org = WEST                                                               
* 2013-03-28   Shawn Gray              Added system.isBatch() ==false to executeMDBAccountUpsertService method
* 2015-04-23   Sripriya Kongot         Modified setBillingAddress, to use Account name input by user
* 2017-03-31   Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
* =============================================================================
*/
public without sharing class AccountUtil {
    
    //Constants
    public static final string ACCOUNT_TYPE_PROSPECT = 'Prospect';
    public static final string ACCOUNT_TYPE_PROSPECT_SPANISH = 'Prospecto';
    public static final string ACCOUNT_TYPE_PROSPECT_PORTUGUESE = 'Prospect';
    public static final string ACCOUNT_TYPE_CUSTOMER = 'Customer';
    public static final string ACCOUNT_TYPE_CUSTOMER_SPANISH = 'Cliente';
    public static final string ACCOUNT_TYPE_CUSTOMER_PORTUGUESE = 'Cliente';
    public static final string ACCOUNT_TYPE_GLOBAL = 'Global';
    public static final string ACCOUNT_TYPE_GLIACCOUNT = 'GLI_Account';
    public static final string ACCOUNT_TYPE_GLIACCOUNTECM = 'GLI_Account_ECM';
    public static final string ACCOUNT_TYPE_GLINEWACCOUNT = 'Create_New_Account';
    
    //Static Properties 
    public static Id CustomerRecordTypeId {
        get {
                //return AppUtil.getRecordTypeIdByName('Account', ACCOUNT_TYPE_CUSTOMER);
                ID recordTypeID = null;
                try{
                    recordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_TYPE_CUSTOMER).getRecordTypeId();
                }catch(exception e){System.debug('Message'+e.getMessage());
/*System.debug('exception trace: '+e.getstacktracestring());-- commented to reduce character for s2e optimization*/
                }
                if(recordTypeID == null){
                    try{
                        recordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_TYPE_CUSTOMER_SPANISH).getRecordTypeId();
                    }catch(exception e){System.debug('Message'+e.getMessage());
/*System.debug('exception trace: '+e.getstacktracestring());-- commented to reduce character for s2e optimization*/
                    }
                }
                if(recordTypeID == null){
                    try{
                        recordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_TYPE_CUSTOMER_PORTUGUESE).getRecordTypeId();
                    }catch(exception e){System.debug('Message'+e.getMessage());
/*System.debug('exception trace: '+e.getstacktracestring());-- commented to reduce character for s2e optimization*/
                    }
                }
/*System.debug('recordTypeID  : '+recordTypeID );-- commented to reduce character for s2e optimization*/
                return recordTypeID;
            }
    }
    
    public static Id ProspectRecordTypeId {
        get {
                // return AppUtil.getRecordTypeIdByName('Account', ACCOUNT_TYPE_PROSPECT);
                ID recordTypeID = null;
                try{
                    recordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_TYPE_PROSPECT).getRecordTypeId();
                }catch(exception e){System.debug('Message'+e.getMessage());
/*System.debug('exception trace: '+e.getstacktracestring());-- commented to reduce character for s2e optimization*/
                }
                if(recordTypeID == null){
                    try{
                        recordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_TYPE_PROSPECT_SPANISH).getRecordTypeId();
                    }catch(exception e){System.debug('Message'+e.getMessage());
/*System.debug('exception trace: '+e.getstacktracestring());-- commented to reduce character for s2e optimization*/
                    }
                }
                if(recordTypeID == null){
                    try{
                        recordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_TYPE_PROSPECT_PORTUGUESE).getRecordTypeId();
                    }catch(exception e){System.debug('Message'+e.getMessage());
/*System.debug('exception trace: '+e.getstacktracestring());-- commented to reduce character for s2e optimization*/
                    }
                }
/*System.debug('recordTypeID  : '+recordTypeID );-- commented to reduce character for s2e optimization*/
                return recordTypeID;
            }
    }
    
    public static Id GlobalRecordTypeId {
        get{    //return AppUtil.getRecordTypeIdByName('Account', ACCOUNT_TYPE_GLOBAL);
            return Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_TYPE_GLOBAL).getRecordTypeId();}
    }
    public static Id GLIAccountRecordTypeId{
        get {return AppUtil.getRecordTypeIdByName('Account', ACCOUNT_TYPE_GLIACCOUNT);}
    }
    
    public static Id GLIAccountECMRecordTypeId{
        get {return AppUtil.getRecordTypeIdByName('Account', ACCOUNT_TYPE_GLIACCOUNTECM);}
    }
    public static Id GLINewAccountRecordTypeId{
        get {return AppUtil.getRecordTypeIdByName('Account', ACCOUNT_TYPE_GLINEWACCOUNT );}
    }
    //Public Methods
    
    /**
* Helper method that allows the specified accounts to be updated
* with default field values
* <p>
* Designed to be utilized by a before insert trigger this method will
* update the by reference object directly.
*
* @param   listAccounts    the list of accounts to set default values on
*/
    public static void applyAccountDefaults(List<Account> listAccounts){
        List<Id> listOwnerIds = new List<Id>();
        Map<Id,String> mapOwnerProfile = new Map<Id,String>();
        for(Account oAcc : listAccounts){
            listOwnerIds.add(oAcc.OwnerId);
        }
        if(User.sObjectType.getDescribe().isAccessible()){
        List<User> listOwners = [Select Id,Profile.Name from User where Id IN :listOwnerIds];
        for(User oUser  : listOwners){
            mapOwnerProfile.put(oUser.Id, oUser.Profile.Name);
        }
        }
    }
    
    /**
* Helper method that updates the company code, division, and distribution
* channel on the account based on the current Sales Org.
* <p>
* Designed to be utilized by a before insert/update trigger this method will
* update the by reference object directly.
*
* @param   listAccounts    the list of accounts to set default values on
*/
    public static void applySalesOrgDefaults(List<Account> listAccounts) {
        Map<string, SalesOrgDetail__c> mapSalesOrgDetails = getSalesOrgCodesMap();
        //string strprfName= [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;   /* Commented for DPS-17417  */
        String userSubbu = LCRMGenericComponent.getUserBU();  /* Added for DPS-17417  */
        /*system.debug('strprfName...'+strprfName);-- commented to reduce character for s2e optimization*/       
        //if(strprfName == 'Elite User' || strprfName == 'UKI Users' || strprfName == 'DQA User'){ /* Commented for DPS-17417  */
        if(LCRMGenericComponent.isLotusUser() || (LOTUS_Lightning_Profiles__c.getInstance(UserInfo.getProfileId()).End_State_Lightning__c == true) || (String.isNotBlank(userSubbu) && LCRMGenericComponent.validateUserBU(userSubbu))){  /* Added for DPS-17417  */
            /*system.debug('strprfName...'+strprfName);-- commented to reduce character for s2e optimization*/
            for(Account oAccount : listAccounts){
                //if (AppUtil.isEmpty(oAccount.Sales_Org__c)){
                    oAccount.Sales_Org__c = 'GLI';
                //}
            }
        }
        else{
            for (Account oAccount : listAccounts) {
                if (AppUtil.isEmpty(oAccount.Sales_Org__c)) {
                    oAccount.Sales_Org__c = 'WEST';
                }
                SalesOrgDetail__c oSalesOrgDetail = mapSalesOrgDetails.get(oAccount.Sales_Org__c);
                
                if (oSalesOrgDetail != null) {
                    oAccount.CompanyCodeDescription__c = oSalesOrgDetail.Company_Code__c;
                    oAccount.DivisionCodeDescription__c = oSalesOrgDetail.Division_Code__c;
                    oAccount.DistributionChannel__c = oSalesOrgDetail.Distribution_Channel__c;
                }
            }
        }
    }
    
    /**
* Helper method that returns an DataQualityUtil.Address object that has been populated
* from the specified account's billing address fields
*
* @param   oAccount    a reference to an account object
* @return  a instance of an DataQualityUtil.Address object
*/
    public static DataQualityUtil.Address getBillingAddress(Account oAccount){
        DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
        if (oAccount != null){
            Account clonedAccount = oAccount.clone(); //Work with copy to prevent error on fields not queried but referenced.
            oAddress.Name = clonedAccount.Name;
            oAddress.Street = clonedAccount.BillingStreet;
            oAddress.City = clonedAccount.BillingCity;
            oAddress.State = clonedAccount.BillingState;
            oAddress.PostalCode = clonedAccount.BillingPostalCode;
            oAddress.Country = clonedAccount.BillingCountry;
            oAddress.County = clonedAccount.County__c;
            oAddress.Province = clonedAccount.Province__c;
            oAddress.POBox = clonedAccount.PO_Box__c;
        }
        /*System.debug('My Log: ' + oAddress);-- commented to reduce character for s2e optimization*/
        return oAddress;
    }
    
    /**
* Helper method that sets the specified account's billing address fields 
* based on the specified DataQualityUtil.Address object
*
* @param   oAccount    a reference to an account object
* @param   oAddress    a reference to an DataQualityUtil.Address object
*/
    public static void setBillingAddress(Account oAccount, DataQualityUtil.Address oAddress){
        if (oAccount != null && oAddress != null){
            //oAccount.Name = oAddress.Name; Using the account name that user entered since IDQ was changing it to uppercase
            oAccount.BillingStreet = oAddress.Street;
            oAccount.BillingCity = oAddress.City;
            oAccount.BillingState = oAddress.State;
            oAccount.BillingPostalCode = oAddress.PostalCode;
            oAccount.BillingCountry = oAddress.Country;
            oAccount.County__c = oAddress.County;
            oAccount.Province__c= oAddress.Province;
            oAccount.PO_Box__c = oAddress.POBox;
        }
    }
    
    /**
* Updates the address tokens of the specified list of accounts 
* <p>
* Designed to be utilized by a before insert/update trigger this method will
* update the by reference object directly.
*
* @param   listAccounts    the list of accounts to update
*/
    public static void updateAddressTokens(List<Account> listAccounts){
        for (Account oAccount : listAccounts){
            DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(oAccount);
            oAccount.Address_Token__c = buildAddressToken(oAddress, oAccount.Sales_Org__c);
        }
    }
    
    /**
* Helper method that builds an address token based on the supplied parameters
*
* @param   oAddress        an instance of an DataQualityUtil.Address object
* @param   sSalesOrg       the sales orginization code for the account
* @return  a string representing the accounts address token utilized for de-duplication rule logic
*/
    public static string buildAddressToken(DataQualityUtil.Address oAddress, string sSalesOrg){
        string sAddressToken = '';
        sAddressToken += AppUtil.fixedWidthString(oAddress.Country, 2);
        sAddressToken += AppUtil.fixedWidthString(oAddress.PostalCode, 4);
        sAddressToken += AppUtil.fixedWidthString(oAddress.StreetName, 1);
        sAddressToken += AppUtil.fixedWidthString(sSalesOrg, 4);
        return sAddressToken;
    }
    
    /**
* Helper method that identifies if an account should be submitted
* to MDB based on specified list of accounts
*
* @param   listAccounts    a list of Account objects to process
*/
    public static void executeMDBAccountUpsertService(List<Account> listAccounts){
        executeMDBAccountUpsertService(listAccounts, false);
    }
    
    /**
* Helper method that identifies if an account should be submitted
* to MDB based on specified list of accounts
*
* @param   listAccounts    a list of Account objects to process
*/
    public static void executeMDBAccountUpsertService(List<Account> listAccounts, boolean isInsert){
        //Method modified due to PMD violations- Deeply nested if 
        boolean submitAccount = (listAccounts.size() == 1 && System.isFuture() == false && system.isBatch() ==false);
         Account oAccount = listAccounts[0];//queryAccount(listAccounts[0].Id);
         boolean bContinueSubmission = false;
         string sSubmissionToken;
         ValidationResult oValidationResult;
        if (submitAccount){
            //Account oAccount = listAccounts[0];//queryAccount(listAccounts[0].Id);
           bContinueSubmission = isInsert ? (oAccount.RecordTypeId == AccountUtil.ProspectRecordTypeId): true;
            
        }
        if (bContinueSubmission){
                oValidationResult = DataQualityUtil.validateAddress(AccountUtil.getBillingAddress(oAccount));
                sSubmissionToken = MDBIntegrationUtil.generateMDBSubmissionToken(oAccount.Id);
               
            }
             if (oValidationResult != null && oValidationResult.IsValid && oAccount.MDBID__c != sSubmissionToken 
                && AppUtil.isEmpty(oAccount.MDBID__c) && Account.sObjectType.getDescribe().isUpdateable() ) {
                    
                   // if (AppUtil.isEmpty(oAccount.MDBID__c)){ //PMD Violation
                        update new Account(Id = oAccount.Id, MDBID__c = sSubmissionToken);
                    
                    AccountUtil.upsertMDBAccountAsync(oAccount.Id);
                }
    }
    
    /**
* Executes the upsertMDBAccount method as an asynchronous transaction
*
* @param   accountId   the account id to submit to MDB
*/
    @future(callout=true)
    public static void upsertMDBAccountAsync(Id accountId){
        upsertMDBAccount(accountId);
    }
    
    /**
* Initiates a web service command to submit the specified account to 
* MDB for upsert
*
* @param   accountId   the account id to submit to MDB
*/
    public static void upsertMDBAccount(Id accountId) {
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(MDBIntegrationUtil.UpsertAccountServiceName);
        Account oAccount = queryAccount(accountId);
        string sSubmissionToken = MDBIntegrationUtil.generateMDBSubmissionToken(accountId);
        //Map sales org values based on configuration
        Map<string, SalesOrgDetail__c> mapSalesOrgDetails = getSalesOrgCodesMap();
        string sSalesOrg = oAccount.Sales_Org__c;
        string sCompanyCode = oAccount.CompanyCodeDescription__c;
        string sDivisionCode = oAccount.DivisionCodeDescription__c;
        string sDistributionChannel = oAccount.DistributionChannel__c;
        if (AppUtil.isEmpty(oAccount.Sales_Org__c) == false) {
            SalesOrgDetail__c oSalesOrgDetail = mapSalesOrgDetails.get(oAccount.Sales_Org__c);
            if (oSalesOrgDetail != null){
                sSalesOrg = oSalesOrgDetail.Name;
                sCompanyCode = oSalesOrgDetail.Company_Code__c;
                sDivisionCode = oSalesOrgDetail.Division_Code__c;
                sDistributionChannel = oSalesOrgDetail.Distribution_Channel__c;
            }
        }
        MDBIntegrationUtil.UpsertAccountRequest oRequest = new MDBIntegrationUtil.UpsertAccountRequest();
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
        oRequest.MDBId = (oAccount.MDBID__c == sSubmissionToken ? null : oAccount.MDBId__c); //Prevents submission token from being sent to MDB
        oRequest.SAPId = oAccount.SAPAccountNumber__c;
        oRequest.AccountGroupCode = 'Prospective customer';
        oRequest.AccountId = oAccount.Id;
        oRequest.SalesOrg = sSalesOrg;
        oRequest.CompanyCode = sCompanyCode;
        oRequest.DivisionCode = sDivisionCode;
        oRequest.DistributionChannel = sDistributionChannel;
        oRequest.Name1 = oAccount.Name;
        oRequest.Name2 = oAccount.NameTwo__c;
        oRequest.Name3 = oAccount.NameThree__c;
        oRequest.AddressLine1 = oAccount.BillingStreet;
        oRequest.AddressLine2 = oAccount.Street_Address_2__c;
        oRequest.AddressLine3 = oAccount.Street_Address_3__c;
        oRequest.POBox = oAccount.PO_Box__c;
        oRequest.City = oAccount.BillingCity;
        oRequest.State = oAccount.BillingState;
        oRequest.PostalCode = oAccount.BillingPostalCode;
        oRequest.Country = oAccount.BillingCountry;
        oRequest.Phone = oAccount.Phone;
        oRequest.Fax = oAccount.Fax;
        oRequest.Industry = oAccount.Industry;
        oRequest.CustomerGroup = oAccount.Customer_Group__c;
        oRequest.CustomerType = oAccount.Customer_Type__c;
        oRequest.MarkgeSegment = oAccount.Market_Segment__c;
        MDBIntegrationUtil.UpsertAccountResponse oResponse = MDBIntegrationUtil.upsertAccount(oRequest);
        if (oResponse.IsSuccess == true){
             if(Account.sObjectType.getDescribe().isUpdateable()){
            update new Account(Id=oAccount.Id, MDBID__c = oResponse.MDBAccountId);
             }
        }
        else{
            if (oAccount.MDBID__c == sSubmissionToken){
                 if(Account.sObjectType.getDescribe().isUpdateable()){//Fixed pmd violation
                update new Account(Id=oAccount.Id, MDBID__c = null); //Reset MDBID to null if token is specified. This will allow the account to be processed again on future updates
                 }
            }
        }
    }
    
    /**
* Initiates a web service command to match and score the specified accounts that potentially
* qualify as a duplicate utilizing the DQXI web service
*
* @param   sAddressToken   an address token to filter potential duplicate accounts by
* @return  a list of DataQualityUtil.AccountInfo objects
*/
    /* public static List<DataQualityUtil.AccountInfo> matchAccounts(string sAddressToken) {
WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.AccountMatchingServiceName);

List<DataQualityUtil.AccountInfo> listMatchedAccountResults = new List<DataQualityUtil.AccountInfo>();

List<Account> listAccounts = queryAccountByAddressToken(sAddressToken);

System.debug('is empty flag' + listAccounts.isEmpty());

if (listAccounts.isEmpty() == false) {  

List<DataQualityUtil.AccountInfo> listMatchedAccounts = new List<DataQualityUtil.AccountInfo>();                            
for (Account oAccount : listAccounts) {
DataQualityUtil.AccountInfo oAccountInfo = new DataQualityUtil.AccountInfo();
oAccountInfo.AccountId = oAccount.Id;
oAccountInfo.MDBId = oAccount.MDBID__c;
oAccountInfo.SAPId = oAccount.SAPAccountNumber__c;
oAccountInfo.Name = oAccount.Name;
oAccountInfo.Nametwo = oAccount.Nametwo__c;
oAccountInfo.Namethree = oAccount.Namethree__c;
oAccountInfo.AddressLine1 = oAccount.BillingStreet;
oAccountInfo.City = oAccount.BillingCity;
oAccountInfo.PostalCode = oAccount.BillingPostalCode;
oAccountInfo.Country = oAccount.BillingCountry;

System.debug('account info' + oAccountInfo);

listMatchedAccounts.add(oAccountInfo);
}

listMatchedAccountResults = DataQualityUtil.matchAccounts(listMatchedAccounts);
}

return listMatchedAccountResults;
}*/
    
    /**
* Generates a map of SalesOrgDetail__c objects by sales organization code
*
* @return a map of SalesOrgDetail__c objects by Sales_Org_Code__c
*/
    public static Map<string, SalesOrgDetail__c> getSalesOrgCodesMap(){
        Map<string, SalesOrgDetail__c> mapSalesOrgCodes = new Map<string, SalesOrgDetail__c>();
        for (SalesOrgDetail__c oSalesOrgDetail : [SELECT Id, Name, Sales_Org_Code__c, Company_Code__c, Distribution_Channel__c
                                                  , Division_Code__c FROM  SalesOrgDetail__c WHERE Sales_Org_Code__c != null ORDER BY Sales_Org_Code__c]){
                                                      mapSalesOrgCodes.put(oSalesOrgDetail.Sales_Org_Code__c, oSalesOrgDetail);
                                                  }
        return mapSalesOrgCodes;
    }
    
    //Private Methods
    
    /**
* Queries the database for and account filtered by the specified account id
*
* @param   accountId   the account id to filter by
* @return  an instance of an Account object
*/
    private static Account queryAccount(Id accountId){
        Account queryResult = new Account();
        if(Account.sObjectType.getDescribe().isAccessible()){//Fixed pmd violation
        queryResult = [SELECT Id, Name, RecordTypeId, MDBID__c, SAPAccountNumber__c, Sales_Org__c, CompanyCodeDescription__c
                    , DivisionCodeDescription__c, DistributionChannel__c, NameTwo__c, NameThree__c, BillingStreet, Street_Address_2__c
                    , Street_Address_3__c, PO_Box__c, BillingCity, BillingState, BillingPostalCode, BillingCountry, Phone, Fax, Industry
                    , Customer_Group__c, Customer_Type__c, Customer_Class_c__c, Market_Segment__c FROM Account WHERE Id = :accountId];
 }
 return queryResult;
  }
    
    /**
     * Queries the database for the specified address token
     * and returns a list of account objects
     * <p>
     * Currently deduplication is allowed across sales org so the token is stripped of
     * the sales org portion of the token when searching existing accounts for matches.
     *
     * @param   sAddressToken   the address token to filter accounts by
     * @return  a list of Account objects
     */
    @testVisible private static List<Account> queryAccountByAddressToken(string sAddressToken){
        string sModifiedToken = sAddressToken.substring(0, 7) + '%'; //Ignore Sales Org Portion of Token
        /*System.debug('Modified Token: ' + sModifiedToken);-- commented to reduce character for s2e optimization*/
        return [SELECT Id, Name, MDBID__c, SAPAccountNumber__c, BillingStreet, BillingCity, BillingState, BillingPostalCode
                , BillingCountry, Address_Token__c, NameTwo__c, NameThree__c FROM  Account WHERE Address_Token__c LIKE :sModifiedToken];
    }
    /**
* Generates Unique transaction Id- used in ECM integration     
* */
    public static String getTimeStamp(){
        String s = String.valueOf(DateTime.now().getTime()); // or some other datetime 
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(s));
        return EncodingUtil.convertToHex(hash);
    }
}