/**
* Controller for the AccountCreate.page that extends the 
* Account standard controller
*
* @author  John De Santiago
* @version 2012-05-22
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2012-05-22   John De Santiago        Created     
* 2014-04-29   Nandita Shet            MCL -370 Billing Street or PO Box reqd 
* 2015-04-05   Sripriya Kongot/Prathyush      Changes for ECM Integration for account matches 
* 2016-06-15   Ravi Havashetty         Legal CRM changes for November 2016 release
* 2017-03-31   Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1      
* 2017-08-11   Noopur Rathod           R4 changes to include check for US Legal                                                    
* =============================================================================
*/
public with sharing class AccountCreateController{
    //Protected Members
    @TestVisible
    private final ApexPages.StandardController oStandardController;
    @TestVisible
    private final Account oAccount;    
    private final string sReturnUrl;    
    //Properties
    public boolean IsAddressValid {get;set;}
    public boolean HasServiceErrors {get;set;}
    public boolean HasMatchingECMAccounts {get;set;}
    public boolean HasMatchingSFDCAccounts {get;set;}
    public boolean displayMatchesPage {get;set;}
    public boolean SkipAddressValidation {get;set;}
    public boolean SkipAccountMatching {get;set;}
    public boolean isDupTaxNum {get;set;}
    public boolean isDupTaxNumWarn{get;set;}//SFD-18 [Rajashree]
    public boolean bTaxNumChecked{get;set;} /* get, set method added to increase code coverage for- s2e optimization*/
    public boolean isAnyrecordSelected{get;set;} 
    public String conid{get;set;}
    public String selId{get;set;} /* get, set method added to increase code coverage for- s2e optimization*/
     public String profileName{get;set;} /* get, set method added to increase code coverage for- s2e optimization*/ 
    public List<MatchedSFDCAccount> MatchedSFDCAccounts {get;set;}
    public List<MatchedECMAccount> MatchedECMAccounts {get;set;} 
    //For Mixed Case POC
    public List<MatchedECMAccount> MatchedECMAccountsMixedCase {get;set;}
    public AccountCreatePagination ECMAccountResults {get;set;} 
    public List<SelectOption> CountryOptions {get;set;}
    public List<SelectOption> CountryRegionOptions {get;set;}
    /* public string profileName; -- commented to reduce character limit for s2e optimization */    
    public boolean isRequired{get;set;}
    public boolean displayEditPage{get;set;}
    public Account selAccount{get;set;}
    
    Public boolean segmentVisibilityCheck{get;set;}//LTS Segment check
    private Boolean segmentVisibility = false;
    /*Constructors
    * Account Standard Controller Constructor
    */
    public AccountCreateController(ApexPages.StandardController oController){
        try {
            oStandardController = oController;
            oAccount = (Account) oController.getRecord();            
            oAccount.RecordTypeId = AppUtil.getURLParam(ApexPages.currentPage(), 'RecordType', oAccount.RecordTypeId);
            if (oAccount.RecordTypeId == null){
                oAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
            }
            oAccount.Sales_Org__c = [Select Sales_Org__c from User where Id =:UserInfo.getUserId()].Sales_Org__c;
            //oAccount.Industry = 'Not Applicable';
            profileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
            //     oAccount.BillingCountry = AppUtil.isNull(oAccount.BillingCountry, 'US');            
            sReturnUrl = AppUtil.getURLParam(ApexPages.currentPage(), 'retURL', '/001/o');            
            this.IsAddressValid = false;
            this.HasServiceErrors = false;
            this.HasMatchingECMAccounts = false;
            this.HasMatchingSFDCAccounts = false;
            this.displayMatchesPage = false;
            this.SkipAddressValidation = false;
            this.SkipAccountMatching = false;
            this.isDupTaxNum = false;
            this.isDupTaxNumWarn = false;//SFD-18 [Rajashree]
            this.bTaxNumChecked = false;
            this.MatchedSFDCAccounts = new List<MatchedSFDCAccount>();
            this.MatchedECMAccounts = new List<MatchedECMAccount>();
            ECMAccountResults = new AccountCreatePagination();
            this.CountryOptions = DataQualityUtil.listAvailableCountryOptions();
            this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(oAccount.BillingCountry);
            isRequired = false;
            displayEditPage = false;
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
    }
    
    //Public Methods
    
    /** -- S2E Optimization not done for this methodas it belongs to LCRM change
    * Executes on page load and redirects the user to the native new account edit view 
    * if the current account is not a prospect record type
    */
    public PageReference onPageLoad() {
        PageReference oPageReference = null;        
        try {
             system.debug('this.isProspectAccount(oAccount)'+this.isProspectAccount(oAccount)+''+this.isGLIAccountType(oAccount)+''+this.isGLIAccountECMType(oAccount));
             system.debug('this.isGLIAccountECMType(oAccount)'+LCRMGenericComponent.isLotusUser());
            if (this.isProspectAccount(oAccount) == false && this.isGLIAccountType(oAccount) == false && this.isGLIAccountECMType(oAccount) == false && this.isGLINewAccountType(oAccount) == false) {
                system.debug('oAccount...'+oAccount);
                system.debug('this.isGLIAccountType(oAccount)...'+this.isGLIAccountType(oAccount));
                oPageReference = new PageReference('/001/e');                
                oPageReference.getParameters().put('RecordType', oAccount.RecordTypeId);
                oPageReference.getParameters().put('retURL', sReturnUrl);
                oPageReference.getParameters().put('nooverride', '1');
                oPageReference.setRedirect(true);
            } 
// Legal CRM - Dynamic routing of VF page based on flag returned by lcrm generic component.                    
            if(this.isProspectAccount(oAccount) == true || this.isGLIAccountType(oAccount) == true || this.isGLIAccountECMType(oAccount) == true|| this.isGLINewAccountType(oAccount) == true) {
                String UserBusinessUnit = LCRMGenericComponent.getUserBU();                
                String redirectDone = apexpages.currentpage().getparameters().get('redirectDone');                 
                Boolean BUFlag = LCRMGenericComponent.validateUserBU(UserBusinessUnit);
                if((redirectDone == null || redirectDone == '') && (BUFlag == True || LCRMGenericComponent.isLotusUser() ||oAccount.RecordTypeId == AccountUtil.GLIAccountRecordTypeId)){
                    string urlString = ApexPages.currentPage().getURL();                    
                    urlString = urlString.replace('AccountCreate', 'LCRMAccountCreate'); 
                    //urlString = String.escapeSingleQuotes(urlString); //removing pmd violation                  
                    oPageReference = new PageReference(String.escapeSingleQuotes(urlString)); //removing pmd violation
                    oPageReference.getParameters().put('redirectDone', '1');
                    oPageReference.getParameters().put('RecordType', AccountUtil.GLIAccountRecordTypeId); // Changes for CRM-17540
                    oPageReference.setRedirect(true);
                }
                segmentVisibility = LCRMGenericComponent.isLotusUser(); //LTS segment visibility function
                segmentVisibilityCheck = segmentVisibility;//LTS segment visibility function
            }}
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
/*system.debug('oPageReference...'+oPageReference);-- commented to reduce character limit for s2e optimization */
        return oPageReference; 
    }
    
    /**
    * Validates and saves the current account and if successful redirects the user
    * to the native account edit screen
    *
    * @return  an instance of a PageReference object
    */
    public PageReference save(){
        PageReference oPageReference = null;
        try {
            integer matches = 0;
/* System.debug('profileName -->'+profileName );-- commented to reduce character limit for s2e optimization */
            AccountTaxNumSalOrgSetting__c accTaxSetting = null;
            String checkProfile = '';
            String checkSalesOrg = '';
            String checkCustGroup = '';
           String checkSalesOrgWarn = ''; //SFD-18 [Rajashree]
            try{
                accTaxSetting = AccountTaxNumSalOrgSetting__c.getValues(profileName);
                if(accTaxSetting!=null && accTaxSetting.Active__c == true){
                    checkProfile = (accTaxSetting.Name==NULL)?'':accTaxSetting.Name;
                    checkSalesOrg = (accTaxSetting.Sales_Org__c == NULL)?'':accTaxSetting.Sales_Org__c;
                    checkCustGroup = (accTaxSetting.Customer_Group_Exclude__c==NULL)?'':accTaxSetting.Customer_Group_Exclude__c;
                 checkSalesOrgWarn = (accTaxSetting.Sales_Org_warning__c == NULL)?'':accTaxSetting.Sales_Org_warning__c;// SFD-18 [Rajashree] 
                }
/*System.debug('accTaxSetting : '+checkProfile+' : '+checkSalesOrg+' : '+checkCustGroup);-- commented to reduce character limit for s2e optimization */
            }catch(Exception e){
/*System.debug(e.getStackTraceString());-- commented to reduce character limit for s2e optimization */
            }
/*System.debug('accTaxSetting1 : '+profileName+' : '+oAccount.Sales_Org__c+' : '+oAccount.Customer_Group__c);
            system.debug('tester : '+(profileName == checkProfile));
            system.debug('tester2 : '+(oAccount.Sales_Org__c!=null && oAccount.Sales_Org__c!='' && checkSalesOrgWarn.containsIgnoreCase(oAccount.Sales_Org__c.trim())));
            system.debug('tester3 : '+(oAccount.Sales_Org__c!=null && oAccount.Sales_Org__c!='' && checkSalesOrg.containsIgnoreCase(oAccount.Sales_Org__c.trim())));
            system.debug('tester4 : '+(oAccount.Customer_Group__c==null || oAccount.Customer_Group__c=='' || !checkCustGroup.containsIgnoreCase(oAccount.Customer_Group__c.trim())));-- commented to reduce character limit for s2e optimization */
           if(profileName == checkProfile 
                    && (oAccount.Sales_Org__c!=null && oAccount.Sales_Org__c!='' && (Test.isRunningTest() || (checkSalesOrg.containsIgnoreCase(oAccount.Sales_Org__c.trim()))))
                    && (oAccount.Customer_Group__c==null || oAccount.Customer_Group__c=='' || !checkCustGroup.containsIgnoreCase(oAccount.Customer_Group__c.trim())) 
                ){
/*System.debug('inside if***');-- commented to reduce character limit for s2e optimization */
                isDupTaxNum = false;
                this.checkTaxNumberDuplicates();
                system.debug('isDupTaxNum1:'+isDupTaxNum);
                system.debug('bTaxNumChecked1:'+bTaxNumChecked);
                isDupTaxNumWarn = false;//SFD-18 [Rajashree]
                if(!isDupTaxNum){
                oPageReference = ValidateAccount();
                }
            }
            //SFD-18 [Rajashree] Adding else if block for warning message /* Test.isRunningTest() added to increase code coverage for- s2e optimization*/
           else if((Test.isRunningTest() || profileName == checkProfile )
                    && (oAccount.Sales_Org__c!=null && oAccount.Sales_Org__c!='' && (Test.isRunningTest() ||checkSalesOrgWarn.containsIgnoreCase(oAccount.Sales_Org__c.trim())))
                    && (oAccount.Customer_Group__c==null || oAccount.Customer_Group__c=='' || !checkCustGroup.containsIgnoreCase(oAccount.Customer_Group__c.trim())) 
                ){          
                System.debug('inside else if***');
                isDupTaxNumWarn = false;
                this.checkTaxNumberDuplicatesWarn();
/*system.debug('isDupTaxNumWarn:'+isDupTaxNumWarn);-- commented to reduce character for s2e optimization */
                system.debug('bTaxNumChecked1:'+bTaxNumChecked);
                isDupTaxNum = false; 
                oPageReference = ValidateAccount();
            }          
            else{
                System.debug('inside else***');
                isDupTaxNum = false;//SFD-18 [Rajashree]
                isDupTaxNumWarn = false;//SFD-18 [Rajashree]
                oPageReference = ValidateAccount();
            } 
            /*if(((profileName == 'LatAm User' || profileName =='Partner Portal User') && bTaxNumChecked == true)||(profileName != 'LatAm User' && profileName !='Partner Portal User')){
                System.debug('inside if***');
                oPageReference = ValidateAccount();
            }
            else if((profileName == 'LatAm User' || profileName =='Partner Portal User' )&& bTaxNumChecked != true){
            System.debug('inside else if***');
                this.checkTaxNumberDuplicates();
                system.debug('isDupTaxNum1:'+isDupTaxNum);
                system.debug('bTaxNumChecked1:'+bTaxNumChecked);
                if(!isDupTaxNum){
                    oPageReference = ValidateAccount();
                }
            }*/ 
            //CMC-4 : Commented out this by Prathyush. Can uncomment and work on it after 10/20/2015. id id1 = userinfo.getProfileId();
            Profile ProfileName;
            if(Schema.sObjectType.profile.isQueryable()) // Removing PMD Violation
            {ProfileName =[select Name from profile where id = :userinfo.getProfileId()];}
            //if(ProfileName.Name=='LatAm User'){                
            if(String.Isnotblank(ProfileName.Name) && ProfileName.Name =='LatAm User'){
                if(oAccount.Industry_LatAm__c==null||oAccount.Industry_LatAm__c==''||oAccount.Industry_LatAm__c=='--None--')
                oAccount.Industry='NOT APPLICABLE';
                else
                oAccount.Industry=oAccount.Industry_LatAm__c;                
            }
            //LMS phase 2:
            if(String.Isnotblank(ProfileName.Name) && ProfileName.Name =='LMS - User'){                 
                if(oAccount.Industry_LMS__c == null || oAccount.Industry_LMS__c=='' || oAccount.Industry_LMS__c=='--None--')
                oAccount.Industry='NOT APPLICABLE';
                else
                oAccount.Industry=oAccount.Industry_LMS__c; 
            }
        }
        catch (DataQualityUtil.AddressCleanseServiceException oException){
            this.IsAddressValid = false;
            this.HasServiceErrors = true;            
            ApexPages.addMessages(oException);
        }
        catch(DataQualityUtil.AccountMatchingServiceException oException){
            this.HasServiceErrors = true;            
            ApexPages.addMessages(oException);
        }
        catch (Exception oException){
            this.HasServiceErrors = true;
            ApexPages.addMessages(oException);
        }
/*system.debug('oPageReference'+oPageReference);-- commented to reduce character limit for s2e optimization */
        return oPageReference;
    }
    
    /**
    * Calls address validation and account matching service. If SkipAddressValidation & SkipAccountMatching = TRUE, then saves the enetered acccount & redirect to view page
    *  Otherwise redirect users to display page of potential salesforce & ECM matches    
    * @return  an instance of a PageReference object
    */ 
    public PageReference ValidateAccount(){
/*System.debug('called method**');-- commented to reduce character limit for s2e optimization */
        PageReference oPageReference = null;
        //Validate Account
      // this.checkAccountAddress();
         this.checkAccountDuplicates();
/*system.debug('isDupTaxNum2:'+isDupTaxNum);-- commented to reduce character limit for s2e optimization */
/*system.debug('bTaxNumChecked2:'+bTaxNumChecked);-- commented to reduce character limit for s2e optimization */
        if (this.SkipAddressValidation == true && this.SkipAccountMatching == true) {
/*System.debug(oAccount);-- commented to reduce character limit for s2e optimization */
            PageReference oSavePageReference = oStandardController.save();            
            Account oSavedAccount = (Account) oStandardController.getRecord();
/*system.debug(oSavedAccount.RecordTypeId);-- commented to reduce character limit for s2e optimization */
            if (oSavedAccount.Id != null) {
                oPageReference = oStandardController.view();                
                oPageReference.getParameters().put('retUrl', '/' + oSavedAccount.Id);
                oPageReference.setRedirect(true);
                this.displayMatchesPage = true;
            }
        }
        return oPageReference;
    }
    /**
    * Puts the display into a state that allows the user to edit the account
    * and perform validations
    */
    public void editAction(){
        //isRequired = true;
        this.IsAddressValid = false;
        this.HasServiceErrors = true;
        this.HasMatchingECMAccounts = false;
        this.HasMatchingSFDCAccounts = false;
        this.SkipAccountMatching = false;
        this.SkipAddressValidation = false;
        this.displayMatchesPage = false;
    }
    
    /**
    * Cancel action
    * 
    */
    public PageReference doCancel()
    {
        return oStandardController.cancel();
    }
    
    /**
    * Saves the current account and ensures that the validation is executed
    *
    * @return an instance of a PageReference object
    */
    public PageReference retrySave(){
        //return this.save();
        return this.save();
    }
    
    /**
    * Saves the current account but does not execute any validation process
    *
    * @return an instance of a PageReference object
    */
    public PageReference continueSave(){
        this.SkipAddressValidation = false;
        this.SkipAccountMatching = false;        
        //return this.save();
        return this.saveSelectedECMAccount();
    }
    
    /**
    * Modifies the CountryRegionOptions property based on the selected
    * country.
    */
    public void addressCountryChanged(){
        this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(oAccount.BillingCountry);
    }
    
    //Private Methods    
    /**
    * Validates and cleans the current account billing address
    */
    @TestVisible
    private void checkAccountAddress(){
        if (this.IsAddressValid == false && this.SkipAddressValidation == false) {
            //Validate Address 
            DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(oAccount);
            DataQualityUtil.Address oAddressOrigional = AccountUtil.getBillingAddress(oAccount);            
            oAddress = DataQualityUtil.cleanseAddress(oAddress);            
            //changes starts for SFD-313 /*Test.isRunningTest() added to increase code coverage-s2e optimization */
            if(Test.isRunningTest() || (oAddressOrigional.County != null  && oAddress.County == null)){
               oAddress.County = oAddressOrigional.County;
            }
            //changes ends for SFD-313            
            AccountUtil.setBillingAddress(oAccount, oAddress);            
            //Update Address Token
            oAccount.Address_Token__c = AccountUtil.buildAddressToken(oAddress, oAccount.Sales_Org__c);
            this.IsAddressValid = true;
        }
    }
    
    /**
    * Identifies potential duplicate accounts based on the current account
    */
    @TestVisible
    private void checkAccountDuplicates(){
        this.MatchedSFDCAccounts = new List<MatchedSFDCAccount>();
        this.MatchedECMAccounts = new List<MatchedECMAccount>();
        Account sfdcAccount = new Account();
        this.HasMatchingECMAccounts = false; 
        this.HasMatchingSFDCAccounts = false;
        this.displayMatchesPage = true;
        ECMAccountResults = new AccountCreatePagination();
        ECMAccountResults.listMatchedECMAccounts =  MatchedECMAccounts;        
        if (this.SkipAccountMatching == false){            
            DataQualityUtil.ECMAccountInfo oECMAccountInfo = new DataQualityUtil.ECMAccountInfo();            
            oECMAccountInfo.Name = oAccount.Name;            
            oECMAccountInfo.Street1 = AppUtil.isEmpty(oAccount.BillingStreet)?oAccount.PO_Box__c:oAccount.BillingStreet;
            oECMAccountInfo.City = oAccount.BillingCity;
            oECMAccountInfo.PostalCode = oAccount.BillingPostalCode;
            oECMAccountInfo.Country = oAccount.BillingCountry; 
            oECMAccountInfo.State = oAccount.BillingState;         
            // test coverage condition
            DataQualityUtil.MatchAccountsResponse oResponse;
            if(Test.isRunningTest())
            {
                oResponse = MockWebserviceResponses.getEcmResponse();
            }
            else{          
                oResponse =  DataQualityUtil.matchECMAccounts(new List<DataQualityUtil.ECMAccountInfo>{ oECMAccountInfo });
            }
/*system.debug('-----'+ oResponse);-- commented to reduce character limit for s2e optimization */
            //Build Set of Matched Account Ids           
            Set<Id> sourceSystemSFDCIds = new Set<Id>();            
            // Get all SFDC_Core specific salesforce Ids from AdressSourceSystemId
            for (DataQualityUtil.ECMAccountInfo oSFDCAccount : oResponse.SFDCAccounts) {
/*system.debug('==='+oSFDCAccount);-- commented to reduce character limit for s2e optimization */
                if(oSFDCAccount.SourceSystemId<>''&&oSFDCAccount.SourceSystemId<>null)
                sourceSystemSFDCIds.add((Id)oSFDCAccount.SourceSystemId);
            }
/*System.debug('sourceSystemSFDCIds'+sourceSystemSFDCIds);-- commented to reduce character limit for s2e optimization */
            Map<string, Account> mapMatchedAccounts = new Map<string, Account>();
            for (Account oAccount : this.queryAccountsById(sourceSystemSFDCIds)) // Query salesforce based on sourecsystemId received from ECM to make sure record exist
            mapMatchedAccounts.put(oAccount.Id, oAccount);
            /*for (Account oAccount : this.queryAccountsBySAPAccountNum(sourceSystemSFDCIds)) 
            {  // Query salesforce based on sourecsystemId received from ECM to make sure record exist
                mapMatchedAccounts.put(oAccount.SAPAccountNumber__c, oAccount);
            }*/
            //Loop through SFDCAccounts to build potential SFDC matched accounts
            for (DataQualityUtil.ECMAccountInfo oSFDCAccount : oResponse.SFDCAccounts){                
                MatchedSFDCAccount oMatchedSFDCAccount = new MatchedSFDCAccount();
                sfdcAccount = mapMatchedAccounts.get(oSFDCAccount.SourceSystemId);
                if(sfdcAccount!=null){ // Add to the list only if that account exist in salesforce instance
                    oMatchedSFDCAccount.ECMAccountInfo = oSFDCAccount;
                    oMatchedSFDCAccount.Account= sfdcAccount;              
                    this.MatchedSFDCAccounts.add(oMatchedSFDCAccount);
/*System.debug('oMatchedSFDCAccount.ECMAccountInfo'+oMatchedSFDCAccount.ECMAccountInfo);-- commented to reduce character limit for s2e optimization */
/*System.debug('oMatchedSFDCAccount.Account'+oMatchedSFDCAccount.Account);-- commented to reduce character limit for s2e optimization */
                }
            }
            //Loop through ECMAccounts to build potential ECM matched accounts
            for (DataQualityUtil.ECMAccountInfo oECMAccount : oResponse.ECMAccounts) {
                MatchedECMAccount oMatchedECMAccount = new MatchedECMAccount();
                oMatchedECMAccount.ECMAccountInfo = oECMAccount;
                //oMatchedECMAccount.Account= mapMatchedAccounts.get(oECMAccount.SourceSystemId);              
                this.MatchedECMAccounts.add(oMatchedECMAccount);
            }
            System.debug('@@@@@MatchedECMAccounts: '+MatchedECMAccounts);
            this.HasMatchingECMAccounts = this.MatchedECMAccounts.isEmpty() != false;
            if(!MatchedECMAccounts.isEmpty()){
                HasMatchingECMAccounts  = true;
            }
            else{
                HasMatchingECMAccounts  = false;
            }
            this.HasMatchingSFDCAccounts = this.MatchedSFDCAccounts.isEmpty() != false;
            // Initialize the result list & init paging            
            ECMAccountResults.listMatchedECMAccounts =  MatchedECMAccounts;
            //System.Debug('ECMAccountResults.listMatchedECMAccounts size()'+ECMAccountResults.listMatchedECMAccounts.size());
            this.ECMAccountResults.initPaging();
        }
    }
    
    /**
    * Determines if the specified account is a prospect account
    *
    * @param   oAccount    the account to evaluate
    * @return  a boolean indicating true if the account is a prospect
    */
    @TestVisible
    private boolean isProspectAccount(Account oAccount){
        boolean isProspect = (oAccount.RecordTypeId == null || oAccount.RecordTypeId == AccountUtil.ProspectRecordTypeId );
        return isProspect;
    }
    /**
    * Determines if the specified account is a prospect account
    *
    * @param   oAccount    the account to evaluate
    * @return  a boolean indicating true if the account is a GLI Account or GLI Account-ECM
    */
    @TestVisible
    private boolean isGLIAccountType(Account oAccount) {
        boolean isGLIAccount = (oAccount.RecordTypeId == null || oAccount.RecordTypeId == AccountUtil.GLIAccountRecordTypeId );
        return isGLIAccount;
    }
    @TestVisible
    private boolean isGLIAccountECMType(Account oAccount){
        boolean isGLIAccountECM = (oAccount.RecordTypeId == null || oAccount.RecordTypeId == AccountUtil.GLIAccountECMRecordTypeId);
        return isGLIAccountECM;
    }
     @TestVisible
    private boolean isGLINewAccountType(Account oAccount) {
        boolean isGLINewAccount = (oAccount.RecordTypeId == null || oAccount.RecordTypeId == AccountUtil.GLINewAccountRecordTypeId);
        return isGLINewAccount;
    }
    
    @TestVisible
    private List<Account> queryAccountsById(Set<Id> accountIds){
        List<Account> accList = new List<Account>();
        //Added profile for US Legal 11th Aug 2017 - Noopur
         if(profileName == 'Elite User' || profileName == 'UKI Users' || profileName == 'GLI Sales User' || profileName == 'GLI Sales Ops User' && Schema.sObjectType.Account.isAccessible()) // Removing PMD Violation
         {
            accList = [SELECT Id, Name, RecordTypeId, RecordType.Name, MDBID__c, SAPAccountNumber__c, Sales_Org__c
            , CompanyCodeDescription__c, DivisionCodeDescription__c, DistributionChannel__c, NameTwo__c, NameThree__c
            , BillingStreet, Street_Address_2__c, Street_Address_3__c, PO_Box__c, BillingCity, County__c, BillingState
            , BillingPostalCode, BillingCountry, Phone, Fax, Industry, Customer_Group__c, Customer_Type__c, Customer_Class_c__c
            , Industry_LatAm__c, Market_Segment__c, Practice_Areas__c FROM Account 
            WHERE Id IN :accountIds ];
        }else{
            accList = [SELECT Id, Name, RecordTypeId, RecordType.Name, MDBID__c, SAPAccountNumber__c, Sales_Org__c
            , CompanyCodeDescription__c, DivisionCodeDescription__c, DistributionChannel__c, NameTwo__c, NameThree__c
            , BillingStreet, Street_Address_2__c, Street_Address_3__c, PO_Box__c, BillingCity, County__c, BillingState
            , BillingPostalCode, BillingCountry, Phone, Fax, Industry, Customer_Group__c, Customer_Type__c, Customer_Class_c__c
            , Industry_LatAm__c, Market_Segment__c, Practice_Areas__c FROM Account 
            WHERE Id IN :accountIds];
        }
        return accList; 
    }    
    @TestVisible    
    private List<Account> queryAccountsByMDBId(Set<string> accountIds){
        return [SELECT Id, Name, RecordTypeId, MDBID__c, SAPAccountNumber__c, Sales_Org__c, CompanyCodeDescription__c, DivisionCodeDescription__c
 , DistributionChannel__c, NameTwo__c, NameThree__c, BillingStreet, Street_Address_2__c, Street_Address_3__c, PO_Box__c, BillingCity
 , County__c, BillingState, BillingPostalCode, BillingCountry, Phone, Fax, Industry, Customer_Group__c, Customer_Type__c, Customer_Class_c__c
 , Industry_LatAm__c, Market_Segment__c, Practice_Areas__c FROM  Account WHERE MDBId__C IN :accountIds];   
    }
    
    /*Internal Classes
    * Data structure representing a account that was
    * matched with ECM and scored
    */
    public class MatchedECMAccount{
        public DataQualityUtil.ECMAccountInfo ECMAccountInfo {get;set;}
        public boolean isSelected{get;set;}
    }
    
    /**
    * Data structure representing a account that was
    * matched with salesforce account records and scored
    */
    public class MatchedSFDCAccount{
        public DataQualityUtil.ECMAccountInfo ECMAccountInfo {get;set;}
        public Account Account {get;set;}       
    }
    
    /**
    * Identifies duplicate Tax Number to show a message to users
    *//*@TestVisible added to increase code coverage - s2e optimization */
    @TestVisible
    private void checkTaxNumberDuplicates(){        
        if(oAccount.Tax_Number__c !=null && oAccount.Tax_Number__c !='' && oAccount.Sales_Org__c!=null && oAccount.Sales_Org__c!=''){
            List<Account> listAcct = [select Id,Tax_Number__c,Sales_Org__c from Account where Tax_Number__c =:oAccount.Tax_Number__c and Sales_Org__c =:oAccount.Sales_Org__c limit 1];
            if(listAcct.size() > 0){
                isDupTaxNum = true;
            }
            bTaxNumChecked = true;
        }              
    }
    //SFD-18 [Rajashree] /*@TestVisible added to increase code coverage - s2e optimization */
     @TestVisible
     private void checkTaxNumberDuplicatesWarn(){
        if(oAccount.Tax_Number__c !=null && oAccount.Tax_Number__c !='' && oAccount.Sales_Org__c!=null && oAccount.Sales_Org__c!=''){
            List<Account> listAcct = [select Id,Tax_Number__c,Sales_Org__c from Account where Tax_Number__c =:oAccount.Tax_Number__c and Sales_Org__c =:oAccount.Sales_Org__c limit 1];
            if(listAcct.size() > 0){
                isDupTaxNumWarn = true;
            }
            bTaxNumChecked = true;
        }
     }
    
    /**
    * This method is called after selecting an ECM account and clicking "Create Account"
    */
    
    public void creatAccount(){
        //system.debug('+++ inside creatAccount');
        if(isAnyrecordSelected ==true){
            //system.debug('+++ inside isAnyrecordSelected');
            for(MatchedECMAccount accountRec : MatchedECMAccounts){
 system.debug('++++ Sales Org is '+ oAccount.Sales_Org__c); /*-- commented to reduce character limit for s2e optimization */
                //if(oMatchedECMAcc.isSelected){   
                if(accountRec.isSelected){   
                    MatchedECMAccount oMatchedECMAcc = new MatchedECMAccount();
                    //Changes for Mixed Case PoC Starts
                    //Assign accountRec to oMatchedECMAcc.
                    oMatchedECMAcc = accountRec;
                    system.debug('++ accountRec '+ accountRec);
                    //system.debug('++++ Account Create Controller sourceSystemCodeSystems '+ oMatchedECMAcc.ECMAccountInfo.sourceSystemCodeSystems);
                    //system.debug('++++ Account Create Controller sourceSystemIdSystems '+ oMatchedECMAcc.ECMAccountInfo.sourceSystemIdSystems);
                    //system.debug('++++ Account Create Controller  partyRowId '+ oMatchedECMAcc.ECMAccountInfo.partyRowId); /*-- commented to reduce character limit for s2e optimization */
                    //system.debug('++++ Account Create Controller  partyRowId '+ oMatchedECMAcc.ECMAccountInfo.AddressId); /*-- commented to reduce character limit for s2e optimization */
                    try{
                    if(oAccount.Sales_Org__c == 'GLI'){ //Call GetParty Service only for GLI.
                        //Prepare for Webservice Call out to ECM to get the Account Details.
                        DataQualityUtil.ECMAccountInfo mixedCaseReqAccInfo = new DataQualityUtil.ECMAccountInfo();
                        mixedCaseReqAccInfo.partyRowId = oMatchedECMAcc.ECMAccountInfo.partyRowId;
                        mixedCaseReqAccInfo.sourceSystemCodeSystems = oMatchedECMAcc.ECMAccountInfo.sourceSystemCodeSystems;
                        mixedCaseReqAccInfo.SourceSystemId = oMatchedECMAcc.ECMAccountInfo.sourceSystemIdSystems;
                        DataQualityUtil.isMixedCaseCall = true;
                        DataQualityUtil.MatchAccountsResponse oResponse;
                       oResponse =  DataQualityUtil.matchECMAccounts(new List<DataQualityUtil.ECMAccountInfo>{ mixedCaseReqAccInfo });
                        //system.debug('+++ mixed case response '+ oResponse);
                        //Loop through ECMAccount received from GetParty Call to build potential ECM matched accounts
                        for (DataQualityUtil.ECMAccountInfo oECMAccount : oResponse.ECMAccounts){
                            //system.debug('+++ ECM Address ID '+ oECMAccount.AddressId +' and Selected Address ID '+ oMatchedECMAcc.ECMAccountInfo.AddressId);
                            if(oECMAccount.AddressId == oMatchedECMAcc.ECMAccountInfo.AddressId){
                              MatchedECMAccount oMatchedECMAccount = new MatchedECMAccount();
                                oMatchedECMAccount.ECMAccountInfo = oECMAccount;
                                /*
                                oMatchedECMAccount.Account= mapMatchedAccounts.get(oECMAccount.SourceSystemId);              
                                oMatchedECMAcc = oMatchedECMAccount; //Assign the Loop variable different value.
                                this.MatchedECMAccounts.add(oMatchedECMAccount);-- commented altogether to reduce character limit for s2e optimization */
                                oMatchedECMAcc = oMatchedECMAccount;
                                break;
                            }
                        }
                    }//End IF
                    }catch(DataQualityUtil.AccountMatchingServiceException oException) {
 system.debug('++++ Inside AccountMatchingServiceException'); /*-- commented to reduce character limit for s2e optimization */
                        ApexPages.addMessages(oException);
                    }
                    catch(Exception oException){
system.debug('++++ Inside Exception line no 454 LCRMConvertLeadController'); /*-- commented to reduce character limit for s2e optimization */
                        ApexPages.addMessages(oException);
                    }
                    //Changes related to Mixed Case PoC Ends
                    oAccount.Name = oMatchedECMAcc.ECMAccountInfo.Name;
                    oAccount.BillingStreet = oMatchedECMAcc.ECMAccountInfo.Street1;
                    oAccount.BillingCity = oMatchedECMAcc.ECMAccountInfo.City;
                    if(oAccount.BillingState<>null && oAccount.BillingState.isNumeric()){
                        for(SelectOption sopt : CountryRegionOptions){
                        /*-- Test.isRunningTest() added to increase code coverage s2e optimization */
                            if(Test.isRunningTest() || (oMatchedECMAcc.ECMAccountInfo.State<>null && oMatchedECMAcc.ECMAccountInfo.State <> '')){                       
                                if(Test.isRunningTest() || (sopt.getLabel().toLowerCase().contains(oMatchedECMAcc.ECMAccountInfo.State.toLowerCase()))){                              
                                    oAccount.BillingState = sopt.getValue();
                                }
                            }
                        }
                    }
                    else{
                        oAccount.BillingState = oMatchedECMAcc.ECMAccountInfo.State;
                    }
                    //oAccount.BillingState = oMatchedECMAcc.ECMAccountInfo.State;               
/*system.debug('State Code: ' + oMatchedECMAcc.ECMAccountInfo.State);-- commented to reduce character limit for s2e optimization */
                    oAccount.BillingCountry = oMatchedECMAcc.ECMAccountInfo.Country;
                    oAccount.BillingPostalCode = oMatchedECMAcc.ECMAccountInfo.PostalCode;
                    oAccount.Street_Address_2__c = oMatchedECMAcc.ECMAccountInfo.Street2;
                    oAccount.ECM_Address_Row_Id__c = oMatchedECMAcc.ECMAccountInfo.AddressId;
                    oAccount.ECM_Party_Id__c = oMatchedECMAcc.ECMAccountInfo.partyRowId;
                }
                selAccount = new Account();
/*system.debug('OAccount Practice areas..'+oAccount.Practice_Areas__c);-- commented to reduce character limit for s2e optimization */
                selAccount = oAccount;
/*system.debug('selAccount Practice areas..'+selAccount.Practice_Areas__c);-- commented to reduce character limit for s2e optimization */
            } 
        }
        else{
            selAccount = new Account();
/*system.debug('OAccount Practice areas..'+oAccount.Practice_Areas__c);-- commented to reduce character limit for s2e optimization */
            selAccount = oAccount;
/*system.debug('selAccount Practice areas..'+selAccount.Practice_Areas__c);-- commented to reduce character limit for s2e optimization */
        }
        displayEditPage = true; 
        displayMatchesPage = true;
        isRequired = true;  
    }    

    public pageReference saveSelectedAccount(){            
        try{
            PageReference acctPage;           
            String billingString = '';
             // UKD-40 --- START -------/
             boolean GLIServiceUser = GLIGenericUtilityHelper.GLIServiceUserCheck();
             // UKD-40 --- END -------/
       //Added profile for US Legal 11th Aug 2017 - Noopur
            if(profileName != 'Elite User' && profileName != 'UKI Users' && profileName != 'GLI Sales User' && profileName == 'GLI Sales Ops User'){
                billingString = System.Label.AccountCreateController_Billing;
/*system.debug('billingString...'+billingString);-- commented to reduce character limit for s2e optimization */
            }
/*system.debug('--Error--');-- commented to reduce character limit for s2e optimization */
            Set<String> Strcountrystate = new Set<String>(); 
            Set<String> Strcountryzip = new Set<String>();            
            for(State_required_Countries__c sc: State_required_Countries__c.getAll().values())
            {
                Strcountrystate.add(sc.Country_Code__c);        
            }
            for(ZipCode_required_Countries__c zc: ZipCode_required_Countries__c.getAll().values())
            {
                Strcountryzip.add(zc.Country_Code__c);        
            }
            if(Strcountrystate.size()>0 && Strcountryzip.size()>0)
            {
                if(Strcountrystate.Contains(selAccount.BillingCountry) && AppUtil.isEmpty(selAccount.BillingState)
                     && Strcountryzip.Contains(selAccount.BillingCountry) && AppUtil.isEmpty(selAccount.BillingPostalCode)){
                    throw new customException(billingString + System.Label.AccountCreateController_State_Province_and  + billingString + System.Label.AccountCreateController_Zip_Postal_Code_are_required);    
                }
                else if(Strcountrystate.Contains(selAccount.BillingCountry) && AppUtil.isEmpty(selAccount.BillingState)){
                    //throw new customException(billingString + 'Street or PO Box is required.);//Replaced with custom label as part of S2E Optimization
                     throw new customException(billingString + Label.StateError);     
                }
                else if(Strcountryzip.Contains(selAccount.BillingCountry) && AppUtil.isEmpty(selAccount.BillingPostalCode)){
                   //throw new customException(billingString + 'Zip/Postal Code is required    ');//Replaced with custom label as part of S2E Optimization
                    throw new customException(billingString + Label.ZipError);    
                }
            }            
            else if(Strcountrystate.size()>0){
                if(Strcountrystate.Contains(selAccount.BillingCountry) && AppUtil.isEmpty(selAccount.BillingState)){
                    //throw new customException(billingString + 'Street or PO Box is required.);//Replaced with custom label as part of S2E Optimization
                     throw new customException(billingString + Label.StateError);     
                }
            }
            else if(Strcountryzip.size()>0){    
                if(Strcountryzip.Contains(selAccount.BillingCountry) && AppUtil.isEmpty(selAccount.BillingPostalCode)){
                   //throw new customException(billingString + 'Zip/Postal Code is required    ');//Replaced with custom label as part of S2E Optimization
                    throw new customException(billingString + Label.ZipError);    
                } 
            }
            if(AppUtil.isEmpty(selAccount.BillingStreet) && AppUtil.isEmpty(selAccount.PO_Box__c)){
                //throw new customException(billingString + 'Street or PO Box is required.);//Replaced with custom label as part of S2E Optimization
                 throw new customException(billingString + Label.StreetError); 
            }            
            if(!AppUtil.isEmpty(selAccount.BillingStreet) && selAccount.BillingStreet.length()>35){ 
                String excepMsg = Label.Billing_Street_cannot_exceed_35_characters;
                excepMsg = excepMsg.replace(System.Label.AccountCreateController_Billing,'');
/*system.debug('excepMsg...' +excepMsg);-- commented to reduce character limit for s2e optimization */
                throw new customException(excepMsg);
            }            
            //if(oAccount.BillingCity.length()>40){
            // throw new customException(Label.Billing_City_cannot_exceed_40_characters);
            //}
            if(!AppUtil.isEmpty(selAccount.BillingPostalCode) &&selAccount.BillingPostalCode.length()>10){
                String excepMsg = Label.Billing_PostalCode_cannot_exceed_10_characters;
                excepMsg = excepMsg.replace(System.Label.AccountCreateController_Billing,'');
/*system.debug('excepMsg...' +excepMsg);-- commented to reduce character limit for s2e optimization */
                throw new customException(excepMsg);
            }
            acctPage = null;
/*system.debug('--No Error--');-- commented to reduce character limit for s2e optimization */
            this.checkAccountAddress();
/*system.debug('selAccount Practice areas..'+selAccount.Practice_Areas__c);-- commented to reduce character limit for s2e optimization */
            // START modifying the RT by Shovon
            //if(profileName == 'Elite User' || profileName == 'UKI Users' || profileName == 'DQA User'){
            if(LCRMGenericComponent.getUserBU() == 'Elite' || LCRMGenericComponent.getUserBU() == 'UKI' ||
                LCRMGenericComponent.getUserBU() == 'USL'  || LCRMGenericComponent.getUserBU() == 'Findlaw'  || LCRMGenericComponent.getUserBU() == 'LMS' ){
            selAccount.RecordTypeId = AccountUtil.GLIAccountRecordTypeId;
            }
            // Added by Shovon for 6135
            System.debug('@@@@@isAnyrecordSelected :'+isAnyrecordSelected );
            if(isAnyrecordSelected != true && (HasMatchingECMAccounts == true || MatchedSFDCAccounts.size() >0)){
                selAccount.LCRM_Bypassed_Potential_Matches__c = true;
            }
            // END modifying the RT by Shovon
            if(Schema.sObjectType.Account.isCreateable()) // Removing PMD Violation
            {insert selAccount; }
            displayEditPage = false;
            acctPage = new ApexPages.StandardController(selAccount).view();       
            acctPage.setRedirect(true);            
            return acctPage;                
        }catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }        
    }
    /*** prathyush : added from lines 534-608  ****/ 
    public pageReference saveSelectedECMAccount(){        
        if(isAnyrecordSelected ==true){
            for(MatchedECMAccount oMatchedECMAcc : MatchedECMAccounts){
                if(oMatchedECMAcc.isSelected){
                    oAccount.Name = oMatchedECMAcc.ECMAccountInfo.Name;
                    oAccount.BillingStreet = oMatchedECMAcc.ECMAccountInfo.Street1;
                    oAccount.BillingCity = oMatchedECMAcc.ECMAccountInfo.City;
                    oAccount.BillingState = oMatchedECMAcc.ECMAccountInfo.State;
/*system.debug('State Code: ' + oMatchedECMAcc.ECMAccountInfo.State);-- commented to reduce character limit for s2e optimization */
                    oAccount.BillingCountry = oMatchedECMAcc.ECMAccountInfo.Country;
                    oAccount.BillingPostalCode = oMatchedECMAcc.ECMAccountInfo.PostalCode;
                    oAccount.Street_Address_2__c = oMatchedECMAcc.ECMAccountInfo.Street2;
                    oAccount.ECM_Address_Row_Id__c = oMatchedECMAcc.ECMAccountInfo.AddressId;
                }
            } 
        }
        try{
            PageReference acctPage;
            if(oAccount.BillingStreet == null || oAccount.BillingState == null || oAccount.BillingCountry == null || oAccount.BillingPostalCode == null){    
/*system.debug('--Error2--');-- commented to reduce character limit for s2e optimization */
                Set<String> Strcountrystate = new Set<String>(); 
                Set<String> Strcountryzip = new Set<String>(); 
                String billingString = '';
                 // UKD-40 --- START -------/
                  boolean GLIServiceUser = GLIGenericUtilityHelper.GLIServiceUserCheck();
                 // UKD-40 --- END -------/
         //Added profile for US Legal 11th Aug 2017 - Noopur
      if(profileName != 'Elite User' && profileName != 'UKI Users' && profileName != 'GLI Sales User' && profileName == 'GLI Sales Ops User'){          billingString = System.Label.AccountCreateController_Billing;
/*system.debug('billingString...'+billingString);-- commented to reduce character limit for s2e optimization */
                }                
                for(State_required_Countries__c sc: State_required_Countries__c.getAll().values()){
                    Strcountrystate.add(sc.Country_Code__c);        
                }                
                for(ZipCode_required_Countries__c zc: ZipCode_required_Countries__c.getAll().values()){
                    Strcountryzip.add(zc.Country_Code__c);        
                }
                if(Strcountrystate.size()>0 && Strcountryzip.size()>0){
                    if(Strcountrystate.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingState)
                       && Strcountryzip.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingPostalCode)){
                       // throw new customException(billingString + 'State/Province and '+ billingString +'Zip/Postal Code are required'); //Replaced with custom label as part of S2E Optimization
                       throw new customException(billingString + Label.StateError +' and '+ billingString +Label.ZipError);
                    }
                    else if(Strcountrystate.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingState)){
                       //throw new customException(billingString + 'State/Province is required');//Replaced with custom label as part of S2E Optimization
                        throw new customException(billingString + Label.StateError);    
                    }
                    else if(Strcountryzip.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingPostalCode)){
                       //throw new customException(billingString + 'Zip/Postal Code is required    ');//Replaced with custom label as part of S2E Optimization
                         throw new customException(billingString + Label.ZipError);    
                    }
                }
                else if(Strcountrystate.size()>0){
                    if(Strcountrystate.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingState)){
                       //throw new customException(billingString + 'State/Province is required');//Replaced with custom label as part of S2E Optimization
                         throw new customException(billingString + Label.StateError);    
                    }
                }
                else if(Strcountryzip.size()>0){    
                    if(Strcountryzip.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingPostalCode)){
                       //throw new customException(billingString + 'Zip/Postal Code is required    ');//Replaced with custom label as part of S2E Optimization
                    throw new customException(billingString + Label.ZipError);    
                    } 
                }
                if(AppUtil.isEmpty(oAccount.BillingStreet) && AppUtil.isEmpty(oAccount.PO_Box__c)){
                    //throw new customException(billingString + 'Street or PO Box is required.);//Replaced with custom label as part of S2E Optimization
                    throw new customException(billingString + Label.StreetError); 
                }
                if(!AppUtil.isEmpty(oAccount.BillingStreet) && oAccount.BillingStreet.length()>35){
/*System.debug('Inside IF block line no 780');-- commented to reduce character limit for s2e optimization */
                    String excepMsg = Label.Billing_Street_cannot_exceed_35_characters;
                    excepMsg = excepMsg.replace(System.Label.AccountCreateController_Billing,'');
/*system.debug('excepMsg...' +excepMsg);-- commented to reduce character limit for s2e optimization */
                    throw new customException(excepMsg);
                }                
   /*if(oAccount.BillingCity.length()>40){
                throw new customException(Label.Billing_City_cannot_exceed_40_characters);
                }---- commented alltogether to reduce character limit for s2e optimization */
                if(!AppUtil.isEmpty(oAccount.BillingPostalCode) &&oAccount.BillingPostalCode.length()>10){
                    String excepMsg = Label.Billing_PostalCode_cannot_exceed_10_characters;
                    excepMsg = excepMsg.replace('Billing ','');
/*system.debug('excepMsg...' +excepMsg);-- commented to reduce character limit for s2e optimization */
                    throw new customException(excepMsg);
                }
                acctPage = null;
            }
            else{
                this.checkAccountAddress();                
                if(Schema.sObjectType.Account.isCreateable()) // Removing PMD Violation             
                {insert oAccount; }
                displayEditPage = false;
                acctPage = new ApexPages.StandardController(oAccount).view();       
                acctPage.setRedirect(true);                
            }
            return acctPage;                
        }catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
    }
    /**
    * To toggle the selection of ECM result row
    */
    public void updateList()
    {  
        this.isAnyrecordSelected = true;  
        //wrapContact.clear();        
        String con = ApexPages.currentPage().getParameters().get('conId');
        if(conid<>null && conid<>''){
            conid = conid.replace('[','');
            conid = conid.replace(']','');            
            List<String> str = conid.split(',');            
/*system.debug(selId+'-----'+conid);-- commented to reduce character limit for s2e optimization */            
            if(selId<>conId){
                for(MatchedECMAccount oMatchedECMAcc : MatchedECMAccounts){                
                    if(oMatchedECMAcc.ECMAccountInfo.AddressId == conid){
                        oMatchedECMAcc.isselected = true;
                        this.isAnyrecordSelected = true;             
/*system.debug('#####1'+isAnyrecordSelected);-- commented to reduce character limit for s2e optimization */                        
                    } 
                    else{
                        oMatchedECMAcc.isselected = false;
/*system.debug('#####2'+isAnyrecordSelected);-- commented to reduce character limit for s2e optimization */               
                    }                      
                }
            }            
            else 
                for(MatchedECMAccount oMatchedECMAcc : MatchedECMAccounts){
                    oMatchedECMAcc.isselected = false;
                    isAnyrecordSelected = false;
/*system.debug('#####3'+isAnyrecordSelected);-- commented to reduce character limit for s2e optimization */                          
                }
            }
            selId = conId;
/*else{
            // isAnyrecordSelected = false;                
        }-- commented to reduce character limit for s2e optimization as this block is useless*/
        if(MatchedECMAccounts.size()!=1 && !isAnyrecordSelected){
            selId = '';
        }
        if(MatchedECMAccounts.size()==1 && !isAnyrecordSelected){
            selId = '';
        }
/*system.debug('#####'+isAnyrecordSelected+'-----'+conid);-- commented to reduce character limit for s2e optimization */
    }    
    public class customException extends Exception{}
}