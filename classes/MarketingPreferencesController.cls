public class MarketingPreferencesController{

    public ApexPages.StandardController oStandardController;
    public Contact oContact;
    public boolean isEditable{get;set;}
    //public string tpsLink{get;set;}
    public string preferenceCenterLink{get;set;}
    public String profileName;
    public boolean CheckPermission{get;set;}
    public boolean isEuropeanCountry{get;set;}
    public LCRMPreferenceMethod preferenceMethod = new LCRMPreferenceMethod();
    
    public MarketingPreferencesController(ApexPages.StandardController oController) {
            oStandardController = oController;
            oContact = (Contact) oController.getRecord();
            isEditable = false;
            CheckPermission = false;
            isEuropeanCountry = false;
            //Call Helper Class for Prefernce Link
            profileName = [SELECT Id,Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
            User username = [SELECT Id,Sub_Bu__c FROM User where Id =:UserInfo.getUserId()];
            Contact con = [SELECT Id,LCRM_Is_CDS_Ready__c,LCRM_Country__c,Email from Contact where Id=:oContact.Id];
            
            List<LCRM_Country_List_Europe__c> cleList = LCRM_Country_List_Europe__c.getall().values();
            List<String> europeCountryList = new List<String>();
            for(LCRM_Country_List_Europe__c cle: cleList){
                europeCountryList.add(cle.Name);
            }
            if(europeCountryList.size()>0 && europeCountryList.contains(con.LCRM_Country__c)){
                isEuropeanCountry = true;
            }
            System.debug('@@@@@europeCountryList: '+europeCountryList);
            System.debug('@@@@@isEuropeanCountry: '+isEuropeanCountry);
            //system.debug('++++ tpsLink BEFORE is '+ tpsLink);
            //tpsLink =preferenceMethod.getTpsLink(con.id);
            preferenceCenterLink = preferenceMethod.getPreferenceCenterLink(con.Email,con.Id,username.Sub_Bu__c,con.LCRM_Country__c,con.id);
         
            
            Schema.DescribeFieldResult getDoNotMail = Schema.SObjectType.Contact.fields.Do_not_Mail__c; 
            Schema.DescribeFieldResult getDoNotCall = Schema.SObjectType.Contact.fields.DoNotCall; 
            
            Schema.DescribeFieldResult getConsentToMobileCall = Schema.SObjectType.Contact.fields.LCRM_Consent_To_Mobile_Call__c; 
            Schema.DescribeFieldResult getLCRMConsentToMail = Schema.SObjectType.Contact.fields.LCRM_Consent_To_Mail__c; 
            Schema.DescribeFieldResult getConsentToLandlineCall = Schema.SObjectType.Contact.fields.LCRM_Consent_To_Landline_Call__c; 
            Schema.DescribeFieldResult getConsentToSMS = Schema.SObjectType.Contact.fields.LCRM_Consent_To_SMS__c; 
            
            if(!isEuropeanCountry && (getDoNotMail.Updateable || getDoNotCall.Updateable || profileName=='System Administrator')){
            CheckPermission=true;
            }
            
            else if(isEuropeanCountry && (getConsentToMobileCall.Updateable || getLCRMConsentToMail.Updateable || getConsentToLandlineCall.Updateable || getConsentToSMS.Updateable || profileName=='System Administrator')){
            CheckPermission=true;
            }
            
      }
     
     
     public void changeToEdit(){
    IF(CheckPermission){
        isEditable = true;
     }
        
     }
     
   
   public PageReference  save(){
         Database.update(oContact,false);
         isEditable = false;
        /** PageReference oPage = Page.MarketingPreferencesSection;
         oPage.getParameters().put('id',oContact.id);
         oPage.setRedirect(true);
         return oPage;**/
       if(UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4t'){
             PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/' + oContact.id);
             return pageRef;
         }else{
             PageReference oPage = Page.MarketingPreferencesSection;
         oPage.getParameters().put('id',oContact.id);
         oPage.setRedirect(true);
         return oPage;
         }
         
     }
     
     public PageReference cancel(){
         isEditable = false;
         if(UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4t'){
             PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/' + oContact.id);
             return pageRef;
         }else{
             return null;
         }
     }
}