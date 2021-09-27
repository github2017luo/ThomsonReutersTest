public without sharing class LeadMarketingPreferencesController{
    
    
    public ApexPages.StandardController oStandardController;
    public string preferenceCenterLink{get;set;}
    public Lead oLead;
    public Lead objLead;
    public User username;
    public string emailString;
    public string countryString;
    public boolean isEuropeanCountry{get;set;}
    //public string tpsLink {get;set;}
    //public boolean TpsFlag = true;
    //public Boolean chkContact{get;set;}
    public LCRMPreferenceMethod preferenceMethod = new LCRMPreferenceMethod();
    @TestVisible static boolean lightningFlag = false;
    
    
    public LeadMarketingPreferencesController(ApexPages.StandardController oController){

        isEuropeanCountry = false;
        oStandardController = oController;       
        
        lightningFlag = UserInfo.getUiThemeDisplayed() == 'Theme4d';        
        system.debug('@lightningFlag'+lightningFlag);
        
        oLead = (Lead)oController.getRecord();
        system.debug('@@ oLead '+oLead);
        
        username = [SELECT Id,Sub_Bu__c FROM User where Id =:UserInfo.getUserId()];      
        objLead = [SELECT Id,Email,Contact__c,Contact__r.Email,contact__r.Id, contact__r.LCRM_Country__c,Billing_Country__c,LCRM_TPS_Screening__c,Country from Lead where Id=:oLead.Id];
        system.debug('@@ objLead' + objLead + '@@ username' + username);        
        List<LCRM_Country_List_Europe__c> cleList = LCRM_Country_List_Europe__c.getall().values();
        List<String> europeCountryList = new List<String>();
        if(!cleList.isEmpty()){for(LCRM_Country_List_Europe__c cle: cleList){
            europeCountryList.add(cle.Name);
        }}
        if(europeCountryList.size()>0 && europeCountryList.contains(objLead.contact__r.LCRM_Country__c)){
            isEuropeanCountry = true;
        }

        if(objLead.Email != null && objLead.Email != ''){
            emailString = objLead.Email;
        }
        
        else if(!string.IsBlank(objLead.contact__r.Id)){
            emailString = objLead.contact__r.Email;
        }
        system.debug('@@ emailString' + emailString + '@@ objLead.contact__r' + objLead.contact__r.Id + 
                     '@@username.Sub_Bu__c'+username.Sub_Bu__c+'@@objLead.Country '+objLead.Country+ '@@objLead.id '+objLead.id+
                     '@objLead.Billing_Country__c'+objLead.Billing_Country__c+'@@lightningFlag '+lightningFlag);
        if(objLead.Billing_Country__c != null && objLead.Billing_Country__c != ''){
            countryString = objLead.Billing_Country__c;
            system.debug('@@INSIDE objLead');
        }           
        else if( lightningFlag == true && String.isnotBlank(objLead.Country)){ //BillingCountry- country condition for lightning DPS - 14248 [getUiThemeDisplayed()]
            countryString = objLead.Country;
            system.debug('@@INSIDE lightning country');
        }           
        else if(!string.IsBlank(objLead.contact__r.Id)){
            countryString = objLead.contact__r.LCRM_Country__c;
            system.debug('@@INSIDE Contact country');
        }
       
        system.debug('@@ emailString' + emailString + '@@ objLead.contact__r' + objLead.contact__r.Id + '@@username.Sub_Bu__c'+username.Sub_Bu__c+'@@countryString '+countryString+ '@@objLead.id '+objLead.id+'@@UserInfo.getUiThemeDisplayed()'+UserInfo.getUiThemeDisplayed());
        //tpsLink = preferenceMethod.getTPSLink(objLead.id);
        preferenceCenterLink = preferenceMethod.getPreferenceCenterLink(emailString,objLead.contact__r.Id,username.Sub_Bu__c,countryString,objLead.id );
        
    }
    
    
}