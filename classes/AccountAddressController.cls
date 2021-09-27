/**
 * Controller for the AccountDetail.page that extends the 
 * Account standard controller
 *
 * @author  John De Santiago
 * @version 2012-05-10
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-05-10   John De Santiago        Created
 * 2012-07-27   Srikanth Kuruva         Mailing Country is defaulted to 'US' which
 *                                      is be a problem to ANZ. so defaulting to ''. 
 * 2012-10-01   Shawn Gray              Change so that the update address uses update this.account instead of a new instance of address     
 * 2014-04-29   Nandita Shet            MCL -370 Billing Street or PO Box reqd      
 * 2014-06-20   Sripriya Kongot         Changes to enable for Sf1(mainly redirect logic)                                                                                                              
 * =============================================================================
 */
public with sharing class AccountAddressController {
    //Protected Members
    private final ApexPages.StandardController standardController;
    private final Account account;
    
    //Properties
    public boolean AllowEdit {get;set;}
    public boolean EditAddress {get;set;}
    public boolean ServiceError {get;set;}
    public boolean Redirect {get;set;}
    public boolean SkipAddressCleanse {get;set;}
    public String strAccountId {get; set;}
    
    public List<SelectOption> CountryOptions {get;set;}
    public List<SelectOption> CountryRegionOptions {get;set;}
    public boolean GLIServiceUser {get;set;}
    public boolean GGOUser {get;set;}
    public boolean USLUser {get;set;}
    public String profileName;
    
    //Constructor
    
    /**
     * Account Standard Controller Constructor
     */
    public AccountAddressController(ApexPages.StandardController controller) {
        try {
            this.standardController = controller;
            this.account = (Account) controller.getRecord();
            
            this.AllowEdit = isEditAllowed(this.account);
            this.EditAddress = false;
            this.ServiceError = false;
            this.Redirect = false;
            this.SkipAddressCleanse = false;
            this.account.BillingCountry = AppUtil.isNull(this.account.BillingCountry, '');
            
            this.CountryOptions = DataQualityUtil.listAvailableCountryOptions();
            this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(this.account.BillingCountry);
            strAccountId = this.Account.Id;
            // UKD-40 --- START -------/
            GLIServiceUser = GLIGenericUtilityHelper.GLIServiceUserCheck();
            // UKD-40 --- END -------/
            
            
            
            string profileID = UserInfo.getProfileID(); 
            ProfileName = [SELECT Name from Profile Where Id =:profileID].Name;
            List<GGO_Static_Values__mdt> GGOSV = new List<GGO_Static_Values__mdt>();
			if(Schema.sObjectType.GGO_Static_Values__mdt.isAccessible())
	        GGOSV =[SELECT MasterLabel,GGO_Value__c from GGO_Static_Values__mdt];
            /* System.debug('GGOSV Is'+GGOSV); */
            Set<String> ProfileSet = new Set<String>();
            if(GGOSV.size()>0){
            for(GGO_Static_Values__mdt val: GGOSV){
                if(val.MasterLabel == 'Profiles'){
                    for(String temp:val.GGO_Value__c.split(';')){
                            ProfileSet.add(temp);
                        }
                }
             }
        }
        GGOUser =false;
        if(ProfileSet.contains(profileName)){
            GGOUser =true;
        }
        USLUser=false;
        if(profilename.containsignorecase('USL'))
        {
        USLUser=true;
        }
            
            
   
        
       }
        catch (Exception unknownException) {
            ApexPages.addMessages(unknownException);
        }
    }
    
    //Public Methods
    
    /**
     * Modifies the CountryRegionOptions property based on the selected
     * country.
     */
    public void addressCountryChanged() {
        this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(this.account.BillingCountry);
    }
    
    /**
     * Modifies the view mode from read-only to edit
     */
    public void edit() {
        EditAddress = true;
    }
    
    /**
     * Initiates the save method and enforces that the 
     * cleases address service is not executed during this
     * transaction
     */
    public PageReference continueSave() {
        this.SkipAddressCleanse = true;        
        return save();
    }
    
    /**
     * Initiates a web request to cleanse the address and save
     * the results to the account and redirects the user to the
     * account address detail view
     */
    public PageReference save() {
        PageReference oPageReference = null;
        
        try {
            this.ServiceError = false;
           if(AppUtil.isEmpty(this.account.BillingStreet) && AppUtil.isEmpty(this.account.PO_Box__c)){
               throw new customException(Label.Billing_Street_or_PO_Box);
            }
            
            if(!AppUtil.isEmpty(this.account.BillingStreet) && this.account.BillingStreet.length()>35){
               throw new customException(Label.Billing_Street_cannot_exceed_35_characters);
            }
            
            if(this.account.BillingCity.length()>40){
               throw new customException(Label.Billing_City_cannot_exceed_40_characters);
            }
            if(!AppUtil.isEmpty(this.account.BillingPostalCode) && this.account.BillingPostalCode.length()>10){
               throw new customException(Label.Billing_PostalCode_cannot_exceed_10_characters);
            }
            
            
            //Validate Address
            DataQualityUtil.Address oAddress = AccountUtil.getBillingAddress(this.account);
            
            DataQualityUtil.Address oAddressOrigional = AccountUtil.getBillingAddress(this.account);
            
            if (this.SkipAddressCleanse == false) {
                oAddress = DataQualityUtil.cleanseAddress(oAddress);
                
                // Changes starts for SFD-313
                System.debug('oAddressOrigional.County is:: '+oAddressOrigional.County);
                System.debug('oAddress.County is:: '+oAddress.County);
                if(oAddressOrigional.County != null  && oAddress.County == null){
                    oAddress.County = oAddressOrigional.County;
                }
                // Changes ends for SFD-313
            }
          
            
   
            
         
            AccountUtil.setBillingAddress(this.account, oAddress);
            
            //Update Address DPS-1709
           	LCRMPopulateBuRegionSegment  accRegionUpdate = new LCRMPopulateBuRegionSegment();
            System.debug('@@@@ this.account.BillingCountry @@@@@'+this.account.BillingCountry);
            this.account.BU_Region__c = accRegionUpdate.updateAccountBURegion(this.account.id,this.account.BillingCountry);
            
            if(Schema.sObjectType.account.isUpdateable())
            update this.account;
            AllowEdit = TRUE;
            EditAddress = False;
            oPageReference =null;
           this.Redirect = true;
           System.debug('this.Redirect>>'+this.Redirect);
           /* oPageReference = new PageReference('/apex/AccountAddress');
            oPageReference.getParameters().put('id', this.account.Id);
            oPageReference.setRedirect(true);*/
        }
        catch (DataQualityUtil.AddressCleanseServiceException addressCleanseServiceException) {
            ServiceError = true;
            ApexPages.addMessages(addressCleanseServiceException);
        }
        catch (Exception unknownException) {
            ApexPages.addMessages(unknownException);
        }
         
        return oPageReference;
    }
    
    /**
     * Cancels the current operation and redirects user to the 
     * account address detail view
     */
    public PageReference cancel() {
        /*PageReference oPageReference = new PageReference('/apex/AccountAddress');
        oPageReference.getParameters().put('id', this.account.Id);
        oPageReference.setRedirect(true);
        
        return oPageReference;*/
         this.Redirect = true;
         AllowEdit = TRUE;
            EditAddress = False;
        return null;
    }

    //Private Methods
    
    /**
     * Determines if the specified account can be edited by the current user
     *
     * @return  a boolean that indicates true if the account can be edited
     */
    private boolean isEditAllowed(Account oAccount) {
        boolean allowEdit = (oAccount.RecordTypeId == AccountUtil.ProspectRecordTypeId);
        List<UserRecordAccess> listUserRecordAccess = new List<UserRecordAccess>();
        if (oAccount.Id != null) {
            if(Schema.sObjectType.UserRecordAccess.isAccessible())
            listUserRecordAccess = [SELECT RecordId, HasReadAccess, HasEditAccess FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =: oAccount.Id];
            allowEdit = listUserRecordAccess[0].HasEditAccess;
        }
        
        return allowEdit;
    }
    
    public class customException extends Exception{}
}