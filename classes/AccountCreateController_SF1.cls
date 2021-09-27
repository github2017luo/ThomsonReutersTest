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
 * Date         Name                                    Description
 * 2012-05-22   John De Santiago                        Created                                                                   
 * 2014-04-29   Nandita Shet                            MCL -370 Billing Street or PO Box reqd
 * 2015-01-05   Sripriya Kongot                                  MCL -531 Enable prospect create for SF1- Changes made to page reference redirect logic
 * =============================================================================
 */
public with sharing class AccountCreateController_SF1 {

    public Account getOAccount() {
        return oAccount ;
    }


   // public String Account { get; set; }  

    //Protected Members
    private final ApexPages.StandardController oStandardController;
   // private final Account oAccount ;
    private final string sReturnUrl;
    
    //Properties
    public boolean IsAddressValid {get;set;}
    public boolean HasServiceErrors {get;set;}
    public boolean HasMatchingAccounts {get;set;}
    public boolean SkipAddressValidation {get;set;}
    public boolean SkipAccountMatching {get;set;}
    public boolean isDupTaxNum {get;set;}
    public boolean bTaxNumChecked;    
    public boolean Redirect {get;set;}
    
    public List<MatchedAccount> MatchedAccounts {get;set;}
    public List<SelectOption> CountryOptions {get;set;}
    public List<SelectOption> CountryRegionOptions {get;set;}  
    public Id oSavedAccountId {get; set;}
    public String strSavedAccountId {get; set;}
    public string profileName {get; set;}
    public Account oAccount {get; set;}
    
    
    //Constructors
    
    
    public AccountCreateController_SF1() {
    
     oAccount = new Account();
        oAccount.RecordTypeId = KeyValueListStore__c.getInstance('Prospect Account').TextValue__c ;  
        oAccount.Sales_Org__c = [Select Sales_Org__c from User where Id =:UserInfo.getUserId()].Sales_Org__c;
        profileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
        oAccount.Customer_Type__c = 'Organization';
        oAccount.Industry = 'Not Applicable';
        
        system.debug('oAccount.Industry='+oAccount.Industry);
        this.IsAddressValid = false;
        this.HasServiceErrors = false;
        this.HasMatchingAccounts = false;
        this.SkipAddressValidation = false;
        this.SkipAccountMatching = false;
        this.isDupTaxNum = false;
        this.bTaxNumChecked = false;
        this.Redirect =false;        
        this.MatchedAccounts = new List<MatchedAccount>();
        this.CountryOptions = DataQualityUtil.listAvailableCountryOptions();
        this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(oAccount.BillingCountry);
        oStandardController = new ApexPages.StandardController(oAccount);
                
    }
    
    public Account getAccount() {
        
        return oAccount;
    }
    
    
    /**
     * Account Standard Controller Constructor
     */
    public AccountCreateController_SF1(ApexPages.StandardController oController) {
        try {
            oStandardController = oController;
            oAccount = (Account) oController.getRecord();
            
            oAccount.RecordTypeId = AppUtil.getURLParam(ApexPages.currentPage(), 'RecordType', oAccount.RecordTypeId);
            if (oAccount.RecordTypeId == null) {
                oAccount.RecordTypeId = AccountUtil.ProspectRecordTypeId;
            }
            
           oAccount.Sales_Org__c = [Select Sales_Org__c from User where Id =:UserInfo.getUserId()].Sales_Org__c;
           oAccount.Customer_Type__c = 'Organization';
           oAccount.Industry = 'Not Applicable';
            profileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
       //     oAccount.BillingCountry = AppUtil.isNull(oAccount.BillingCountry, 'US');
            
            sReturnUrl = AppUtil.getURLParam(ApexPages.currentPage(), 'retURL', '/001/o');
            
            this.IsAddressValid = false;
            this.HasServiceErrors = false;
            this.Redirect =false;
            this.HasMatchingAccounts = false;
            this.SkipAddressValidation = false;
            this.SkipAccountMatching = false;
            this.isDupTaxNum = false;
            this.bTaxNumChecked = false;
            
            
            this.MatchedAccounts = new List<MatchedAccount>();
            this.CountryOptions = DataQualityUtil.listAvailableCountryOptions();
            this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(oAccount.BillingCountry);
            
       }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
    }
    
    //Public Methods
    
    /**
     * Executes on page load and redirects the user to the native new account edit view 
     * if the current account is not a prospect record type
     */
    public PageReference onPageLoad() {
        PageReference oPageReference = null;
        
        try {
            if (this.isProspectAccount(oAccount) == false) {
                oPageReference = new PageReference('/001/e');
                oPageReference.getParameters().put('RecordType', oAccount.RecordTypeId);
                oPageReference.getParameters().put('retURL', sReturnUrl);
                oPageReference.getParameters().put('nooverride', '1');
                oPageReference.setRedirect(true);
            }   
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
        
        return oPageReference;  
    }
    
    /**
     * Validates and saves the current account and if successful redirects the user
     * to the native account edit screen
     *
     * @return  an instance of a PageReference object
     */
    public PageReference save() {
        PageReference oPageReference = null;
        
        try {
            integer matches = 0;
            
            /**
             *Throws an error if State or Zip Code fields are not selected for particular countries 
             *as listed in custom settings.
            */              
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
               if(Strcountrystate.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingState)
                  && Strcountryzip.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingPostalCode))
               {
                   throw new customException('Billing State/Province and Billing Zip/Postal Code are required');    
               }
               else if(Strcountrystate.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingState))
               {
                   throw new customException('Billing State/Province is required');    
               }
               else if(Strcountryzip.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingPostalCode))
               {
                   throw new customException('Billing Zip/Postal Code is required    ');    
               }
           } 
           
           else if(Strcountrystate.size()>0)
           {
               if(Strcountrystate.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingState))
               {
                   throw new customException('Billing State/Province is required');    
               }
           } 
           
           else if(Strcountryzip.size()>0)
           {    
               if(Strcountryzip.Contains(oAccount.BillingCountry) && AppUtil.isEmpty(oAccount.BillingPostalCode))
               {
                   throw new customException('Billing Zip/Postal Code is required    ');    
               } 
           }    

            
             if(AppUtil.isEmpty(oAccount.BillingStreet) && AppUtil.isEmpty(oAccount.PO_Box__c)){
               throw new customException('Billing Street or PO Box is required.');
            }
            
            if(!AppUtil.isEmpty(oAccount.BillingStreet) && oAccount.BillingStreet.length()>35){
               throw new customException(Label.Billing_Street_cannot_exceed_35_characters);
            }
            
            if(oAccount.BillingCity.length()>40){
               throw new customException(Label.Billing_City_cannot_exceed_40_characters);
            }
            if(!AppUtil.isEmpty(oAccount.BillingPostalCode) &&oAccount.BillingPostalCode.length()>10){
               throw new customException(Label.Billing_PostalCode_cannot_exceed_10_characters);
            }
            
            
            if((profileName == 'LatAm User' && bTaxNumChecked == true)||(profileName != 'LatAm User' )){
                oPageReference = ValidateAccount();
            }
            
            if(profileName == 'LatAm User' && bTaxNumChecked != true){
                this.checkTaxNumberDuplicates();
                system.debug('isDupTaxNum1:'+isDupTaxNum);
                system.debug('bTaxNumChecked1:'+bTaxNumChecked);
                if(!isDupTaxNum){
                    oPageReference = ValidateAccount();
                }
            }
        }
        catch (DataQualityUtil.AddressCleanseServiceException oException) {
            this.IsAddressValid = false;
            this.HasServiceErrors = true;
            
            ApexPages.addMessages(oException);
        }
        catch(DataQualityUtil.AccountMatchingServiceException oException) {
            this.HasServiceErrors = true;
            
            ApexPages.addMessages(oException);
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
        
        return oPageReference;
    }
    public PageReference ValidateAccount(){
        PageReference oPageReference = null;
        //Validate Account
        this.checkAccountAddress();
        this.checkAccountDuplicates();
        //Save and/or Move to Next Step
        //if(bDisplayedMessage == null)
        isDupTaxNum = false;
        system.debug('isDupTaxNum2:'+isDupTaxNum);
        system.debug('bTaxNumChecked2:'+bTaxNumChecked);
        if (this.HasMatchingAccounts == false) {
            System.debug(oAccount);
            PageReference oSavePageReference = oStandardController.save();
            
            Account oSavedAccount = (Account) oStandardController.getRecord();
            oSavedAccountId = oSavedAccount.Id;  
            System.debug('oSavedAccountId at ValidateAccount '+oSavedAccountId ); 
                         
            //Sripriya 4/21 TO DO - Handle for SF1
            if (oSavedAccount.Id != null) {
                this.Redirect =true;      
             System.debug('this.Redirect at ValidateAccount '+this.Redirect);
                /*oPageReference = oStandardController.view();
                 
                oPageReference.getParameters().put('retUrl', '/' + oSavedAccount.Id);
                oPageReference.setRedirect(true);*/

            }
        }
        system.debug('ValidateAccount() PageReference:: '+ oPageReference) ;
        return oPageReference;
    }
    /**
     * Puts the display into a state that allows the user to edit the account
     * and perform validations
     */
    public void edit() {
        this.IsAddressValid = false;
        this.HasServiceErrors = false;
        this.HasMatchingAccounts = false;
        this.SkipAccountMatching = false;
        this.SkipAddressValidation = false;
    }
        
    /**
     * Saves the current account and ensures that the validation is executed
     *
     * @return an instance of a PageReference object
     */
    public PageReference retrySave() {
        Pagereference oPageReference = null ;
        this.save();
        //oPageReference = oStandardController.view();       
        return oPageReference;
    }
    
    /**
     * Saves the current account but does not execute any validation process
     *
     * @return an instance of a PageReference object
     */
    public PageReference continueSave() {
        PageReference oPageReference = null;
        this.SkipAddressValidation = true;
        this.SkipAccountMatching = true;
        //Sripriya 4/21 Modified for SF1. returning null & doing a save        
       // return this.save();        
       this.save();
        Account oSavedAccount = (Account) oStandardController.getRecord();
       oSavedAccountId  = oSavedAccount.Id;       
     // Commented this section by sripriya for testing 6-9-14 SF1 changes
     // oPageReference = oStandardController.view();
     // oPageReference.setRedirect(true);
      system.debug('continueSave() PageReference:: '+ oPageReference) ;  
      this.Redirect =true;  
      return oPageReference ;
    }
    
    /**
     * Modifies the CountryRegionOptions property based on the selected
     * country.
     */
    public void addressCountryChanged() {
        this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(oAccount.BillingCountry);
    }
    
    //Private Methods
    
    /**
     * Validates and cleans the current account billing address
     */
    private void checkAccountAddress() {
        if (this.IsAddressValid == false && this.SkipAddressValidation == false) {
            //Validate Address 
            DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(oAccount);
            
            oAddress = DataQualityUtil.cleanseAddress(oAddress);
            AccountUtil.setBillingAddress(oAccount, oAddress);
            
            //Update Address Token
            oAccount.Address_Token__c = AccountUtil.buildAddressToken(oAddress, oAccount.Sales_Org__c);
            this.IsAddressValid = true;
        }
    }
    
    /**
     * Identifies potential duplicate accounts based on the current account
     */
    private void checkAccountDuplicates() {
        this.MatchedAccounts = new List<MatchedAccount>();
        this.HasMatchingAccounts = false;
        
        if (this.SkipAccountMatching == false) {
            //Match Duplicates by Address Token
            if (AppUtil.isEmpty(oAccount.Address_Token__c)) {
                DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(oAccount);
                oAccount.Address_Token__c = AccountUtil.buildAddressToken(oAddress, oAccount.Sales_Org__c);
            }
            
            //List<DataQualityUtil.AccountInfo> listMatchedCustomers = AccountUtil.matchAccounts(oAccount.Address_Token__c);
            DataQualityUtil.AccountInfo oAccountInfo = new DataQualityUtil.AccountInfo();
            oAccountInfo.AccountId = null;
            oAccountInfo.MDBId = oAccount.MDBID__c;
            oAccountInfo.SAPId = oAccount.SAPAccountNumber__c;
            oAccountInfo.Name = oAccount.Name;
            oAccountInfo.Nametwo = oAccount.Nametwo__c;
            oAccountInfo.Namethree = oAccount.Namethree__c;
            oAccountInfo.AddressLine1 = oAccount.BillingStreet;
            oAccountInfo.City = oAccount.BillingCity;
            oAccountInfo.PostalCode = oAccount.BillingPostalCode;
            oAccountInfo.Country = oAccount.BillingCountry;
            oAccountInfo.POBox = oAccount.PO_Box__c;
            
            List<DataQualityUtil.AccountInfo> listMatchedCustomers = DataQualityUtil.matchAccounts(new List<DataQualityUtil.AccountInfo>{ oAccountInfo });
            
            //Build Set of Matched Account Ids
            Set<string> MDBIds = new Set<string>();
            for (DataQualityUtil.AccountInfo oCustomerMatchInfo : listMatchedCustomers) {
                MDBIds.add(oCustomerMatchInfo.MDBID);
            }
            
            Map<string, Account> mapMatchedAccounts = new Map<string, Account>();
            for (Account oAccount : this.queryAccountsByMDBId(MDBIds)) {
                mapMatchedAccounts.put(oAccount.MDBID__c, oAccount);
            }
            
            for (DataQualityUtil.AccountInfo oCustomerMatchInfo : listMatchedCustomers) {
                MatchedAccount oMatchedAccount = new MatchedAccount();
                oMatchedAccount.AccountInfo = oCustomerMatchInfo;
                oMatchedAccount.Account= mapMatchedAccounts.get(ocustomerMatchInfo.MDBID);
                oMatchedAccount.Score = oCustomerMatchInfo.Score;
                
                this.MatchedAccounts.add(oMatchedAccount);
            }
            
            this.HasMatchingAccounts = this.MatchedAccounts.isEmpty() == false;
        }
    }
    
    /**
     * Determines if the specified account is a prospect account
     *
     * @param   oAccount    the account to evaluate
     * @return  a boolean indicating true if the account is a prospect
     */
    private boolean isProspectAccount(Account oAccount) {
        boolean isProspect = (oAccount.RecordTypeId == null || oAccount.RecordTypeId == AccountUtil.ProspectRecordTypeId);
        return isProspect;
    }
    
    private List<Account> queryAccountsById(Set<Id> accountIds) {
        return [SELECT 
                    Id
                    , Name
                    , RecordTypeId
                    , MDBID__c
                    , SAPAccountNumber__c
                    , Sales_Org__c
                    , CompanyCodeDescription__c
                    , DivisionCodeDescription__c
                    , DistributionChannel__c
                    , NameTwo__c
                    , NameThree__c
                    , BillingStreet
                    , Street_Address_2__c
                    , Street_Address_3__c
                    , PO_Box__c
                    , BillingCity
                    , BillingState
                    , BillingPostalCode
                    , BillingCountry
                    , Phone
                    , Fax
                    , Industry
                    , Customer_Group__c
                    , Customer_Type__c
                    , Customer_Class_c__c
                    , Market_Segment__c 
                    , Account_Indicator__c
                FROM 
                    Account 
                WHERE 
                    Id IN :accountIds]; 
    }
    private List<Account> queryAccountsByMDBId(Set<string> accountIds) {
        return [SELECT 
                    Id
                    , Name
                    , RecordTypeId
                    , MDBID__c
                    , SAPAccountNumber__c
                    , Sales_Org__c
                    , CompanyCodeDescription__c
                    , DivisionCodeDescription__c
                    , DistributionChannel__c
                    , NameTwo__c
                    , NameThree__c
                    , BillingStreet
                    , Street_Address_2__c
                    , Street_Address_3__c
                    , PO_Box__c
                    , BillingCity
                    , BillingState
                    , BillingPostalCode
                    , BillingCountry
                    , Phone
                    , Fax
                    , Industry
                    , Customer_Group__c
                    , Customer_Type__c
                    , Customer_Class_c__c
                    , Market_Segment__c
                    , Account_Indicator__c 
                FROM 
                    Account 
                WHERE 
                    MDBId__C IN :accountIds];   
    }
    
    //Internal Classes
    
    /**
     * Data structure representing a account that was
     * matched and scored
     */
    public class MatchedAccount {
        public DataQualityUtil.AccountInfo AccountInfo {get;set;}
        public Account Account {get;set;}
        public string Score {get;set;}
    }
    
      /**
     * Identifies duplicate Tax Number to show a message to users
     */
    private void checkTaxNumberDuplicates() {
        system.debug('Anshita='+oAccount.Tax_Number__c);
        if(oAccount.Tax_Number__c !=null && oAccount.Tax_Number__c !=''){
              //    Integer oCount = [select count() from Account where Tax_Number__c =:oAccount.Tax_Number__c];
            List<Account> listAcct = [select Id from Account where Tax_Number__c =:oAccount.Tax_Number__c limit 1];
            if(listAcct.size() > 0){
                isDupTaxNum = true;
            }
            bTaxNumChecked = true;
        }
    
    }
    
    public class customException extends Exception{}
   
}