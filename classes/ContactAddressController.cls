/**
 * Controller for the ContactDetail.page that extends the 
 * Contact standard controller
 *
 * @author  John De Santiago
 * @version 2012-05-10
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-05-10   John De Santiago        Created   
 * 2012-07-19   Srikanth Kuruva         Mailing Country is defaulted to 'US' which
 *                                      is be a problem to ANZ. so defaulting to ''.
 * =============================================================================
 */
public with sharing class ContactAddressController {
    //Protected Members
    private final ApexPages.StandardController standardController;
    private final Contact contact;
    
    //Properties
    public boolean AllowEdit {get;set;}
    public boolean EditAddress {get;set;}
    public boolean ServiceError {get;set;}
    public boolean SkipAddressCleanse {get;set;}
    public boolean Redirect {get;set;}
    public String strContactId {get; set;}
    
    public List<SelectOption> CountryOptions {get;set;}
    public List<SelectOption> CountryRegionOptions {get;set;}
    
    //Constructor
    
    /**
     * Contact Standard Controller Constructor
     */
    public ContactAddressController(ApexPages.StandardController controller) {
        try {
            this.standardController = controller;
            this.contact = (Contact) controller.getRecord();
            
            this.AllowEdit = isEditAllowed(this.contact);
            this.EditAddress = false;
            this.ServiceError = false;
            this.SkipAddressCleanse = false;
            this.Redirect = false;
            strContactId = this.contact.Id;
            this.contact.MailingCountry = AppUtil.isNull(this.contact.MailingCountry, '');
            
            this.CountryOptions = DataQualityUtil.listAvailableCountryOptions();
            this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(this.contact.MailingCountry);
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
        this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(this.contact.MailingCountry);
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
     * the results to the contact and redirects the user to the
     * contact address detail view
     */
    public PageReference save() {
        PageReference oPageReference = null;
        
        try {
            this.ServiceError = false;
            
            //Validate Address
            DataQualityUtil.Address oAddress = ContactUtil.getMailingAddress(this.contact);
            
            if (this.SkipAddressCleanse == false) {
                oAddress = DataQualityUtil.cleanseAddress(oAddress);
            }
            
            //Update Address
            Contact oContactAddress = new Contact(Id=this.contact.Id);
            ContactUtil.setMailingAddress(oContactAddress, oAddress);
            update oContactAddress;
            this.Redirect = true;
           /* oPageReference = new PageReference('/apex/ContactAddress');
            oPageReference.getParameters().put('id', this.contact.Id);
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
     * contact address detail view
     */
    public PageReference cancel() {
        /*PageReference oPageReference = new PageReference('/apex/ContactAddress');
        oPageReference.getParameters().put('id', this.contact.Id);
        oPageReference.setRedirect(true);        
        return oPageReference;*/
        this.Redirect = true;
        return null;
        
    }

    //Private Methods
    
    /**
     * Determines if the specified contact can be edited by the current user
     *
     * @return  a boolean that indicates true if the contact can be edited
     */
    private boolean isEditAllowed(Contact oContact) {
        boolean allowEdit = true;
        
        if (oContact.Id != null) {
            List<UserRecordAccess> listUserRecordAccess = [SELECT RecordId, HasReadAccess, HasEditAccess FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =: oContact.Id];
            allowEdit = listUserRecordAccess[0].HasEditAccess;
        }
        
        return allowEdit;
    }
}