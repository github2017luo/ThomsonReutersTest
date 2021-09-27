public without sharing class LeadAddressController{

    private final ApexPages.StandardController oStandardController;
    //private final Lead oLead;
    public Lead oLead{get;set;}
    public List<SelectOption> countryOptions {get;set;}
    public List<SelectOption> countryRegionOptions {get;set;}

    public boolean allowEdit {get;set;}
    public boolean editAddress {get;set;}
    public boolean hasServiceErrors {get;set;}
    public boolean isAddressValid {get;set;}
    public boolean redirect {get;set;}
    public String strLeadId {get; set;}
    public boolean skipAddressValidation {get;set;}


    public LeadAddressController(ApexPages.StandardController oController) {
        oStandardController = oController;
        //oLead = (Lead) oController.getRecord();
        String leadID = (Id) oController.getId();
        if(Schema.sObjectType.Lead.isAccessible()){
            oLead = [select Id,Approval_status__c,Name,Billing_Country__c,Billing_Street__c,Billing_Street_2__c,County__c,Billing_Zip__c,PO_Box__c,Billing_City__c,Billing_State__c from Lead where ID =:leadId];
        }
        system.debug('------'+oLead);
        AllowEdit = true;
        EditAddress = false;
        IsAddressValid = false;
        HasServiceErrors = false;
        SkipAddressValidation = false;
        this.Redirect = false;
        strLeadId = oLead.Id;
        CountryOptions = DataQualityUtil.listAvailableCountryOptions();
        CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(oLead.Billing_Country__c);
    }
    
    public pageReference save(){
        pageReference oPageReference = null;
        try{
            
            validateLeadFields();
            
            
            
            if(SkipAddressValidation == false && IsAddressValid == false && checkEmptyAdd()){
              LeadUtils.validateLeadAddress(oLead);
              IsAddressValid = true;
            }
            system.debug('------'+oLead.Billing_Zip__c);
            if(Schema.sObjectType.Lead.isUpdateable()){
                update oLead;
            }
            //pageReference oSavePageReference = oStandardController.save();
            EditAddress = FALSE;
            AllowEdit = TRUE;
            /*oPageReference = new PageReference('/apex/LeadAddress');
            oPageReference.getParameters().put('id', oLead.Id);
            oPageReference.setRedirect(true);
            system.debug('oPageReference:'+oPageReference);
            return oPageReference;*/
           this.Redirect = true;
            
        }
        catch (DataQualityUtil.AddressCleanseServiceException oException) {
            IsAddressValid = false;
            HasServiceErrors = true;
            
            ApexPages.addMessages(oException);
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
        
        return null;
    }
    public pageReference continueSave(){
        SkipAddressValidation = true;
        return save();
    }
    public void addressCountryChanged() {
        CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(oLead.Billing_Country__c);
    }

    public pageReference edit(){
        EditAddress = true;
        AllowEdit = false;
        return null;
    }
    /**
     * Cancels the current operation and redirects user to the 
     * account address detail view
     */
    public PageReference cancel() {
       /* PageReference oPageReference = new PageReference('/apex/LeadAddress');
        oPageReference.getParameters().put('id', oLead.Id);
        oPageReference.setRedirect(true);        
        return oPageReference;*/
        EditAddress = FALSE;
        AllowEdit = TRUE;
        this.Redirect = true;
        return null;
    }

    private void validateLeadFields(){
        checkStreet();
         if(!AppUtil.isEmpty(oLead.Billing_City__c) && oLead.Billing_City__c.length()>40){
            throw new customException(Label.Billing_City_cannot_exceed_40_characters);
         }
         system.debug('------'+oLead.Billing_Zip__c);
         if(!AppUtil.isEmpty(oLead.Billing_Zip__c) && oLead.Billing_Zip__c.length()>10){
            system.debug('------');
            throw new customException(Label.Billing_Zip_cannot_exceed_10_characters);
         }
    }

    private void checkStreet(){
        if(!AppUtil.isEmpty(oLead.Billing_Street__c) && oLead.Billing_Street__c.length()>35){
            throw new customException(Label.Billing_Street_cannot_exceed_35_characters);
         }
    }

    private Boolean checkEmptyAdd(){
        return (!((AppUtil.isEmpty(oLead.Billing_Street__c) && AppUtil.isEmpty(oLead.PO_Box__c)) || AppUtil.isEmpty(oLead.Billing_City__c) || AppUtil.isEmpty(oLead.Billing_Country__c)));
    }
    
     public class CustomException extends Exception{}
}