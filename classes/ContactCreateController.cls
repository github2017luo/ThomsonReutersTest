/**
* Controller for the ContactCreate.page that extends the 
* Contact standard controller
*
* @author  Srikanth Kuruva
* @version 2013-06-28
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2013-06-28   Srikanth Kuruva         Created    
* 2015-10-14   Sreenu Daram            Added "redirectnewPage" method.   
* 2017-01-09   Shovon Bera             Modified "redirectnewPage" method to redirect to LCRMContactCreateError and LCRMContactCreate page for GLI Users
* 2017-06-14    Karthi                 Added UKI Service cloud profiles as per UKD-50
  2017-09-13    Gunaseelan K           Added GGO Service cloud profiles to avoid duplicate contact create as per GGD-649
* =============================================================================
*/
public without sharing class ContactCreateController{
    
    private final ApexPages.StandardController oStandardController;
    public Contact oContact{get;set;}
    public boolean HasMatchingContacts {get;set;}
    public boolean SkipContactMatching {get;set;}
    public List<MatchedContact> MatchedContacts {get;set;}
    public List<DataQualityUtil.ContactInfo> listMatchedContacts{get;set;}
    public boolean isDupContacts {get;set;}
    public string profileName;
    public boolean gliUser {get;set;} // Added by Shovon as per CRM-1035
    public boolean GGOUser{get;set;}
    public boolean uslUser{get;set;}
    public string gliRecordTypeId;  // Added by Shovon as per CRM-1035
    private final string ACCOUNT_ID = 'accid';
    private final string RETURN_URL = 'retURL';
    private final string ENTITY = 'ent';
    private final string SAVE_NEW ='save_new';
    private final string SFDC_OVERRIDE ='sfdc.override';
    
    public ContactCreateController(ApexPages.StandardController controller) {
        oStandardController = controller;
        oContact = (Contact)controller.getRecord();              
        HasMatchingContacts = false;
        this.Matchedcontacts = new List<Matchedcontact>();
        this.SkipContactMatching = false;
        this.isDupContacts = false;
        this.gliUser = false; // Added by Shovon as per CRM-1035
        //string oppId = ApexPages.currentPage().getParameters().get('retURL');
         string oppId = '';
        String oppIdTemp = ApexPages.currentPage().getParameters().get('retURL');
        If(String.isNotBlank(oppIdTemp)){
            oppId = oppIdTemp.escapeHtml4();
        }
        system.debug('oppId..'+oppId);
        if(!string.isEmpty(oppId)) {
            oppId = oppId.substringAfter('.com/'); 
        if(oppId.startsWith('006')) {
            oContact.Opportunity__c = oppId;
        }
        system.debug('oppId..'+oppId);
        }
        // START Added by Shovon as per CRM-1035
        gliRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'GLI Contact'].Id;
        string profileID = UserInfo.getProfileID();        // Added by Shovon
        ProfileName = [SELECT Name from Profile Where Id =:profileID].Name;
        system.debug('profName'+ProfileName);
        // START--New profile added for ESC_UKI by Karthi as per UKD-50
        boolean GLIServiceUser = GLIGenericUtilityHelper.GLIServiceUserCheck();
         // END--New profile added for ESC_UKI by Karthi as per UKD-50
         String user = LCRM_GLIUser__c.getValues('GLIProfileList').Profile_List__c;
         String recordType='';
         String recordTypeName = apexpages.currentpage().getparameters().get('RecordType');
         If(String.isNotBlank(recordTypeName )){
            recordType= recordTypeName.escapeHtml4();
        }
         //Removing hard coding by using custom setting
        //if((ProfileName == 'GLI Marketing User'||ProfileName == 'GLI Sales User'||ProfileName == 'GLI Sales Ops User'|| ProfileName == 'Elite User' || ProfileName == 'Elite Sales Ops' || ProfileName == 'UKI Users' || ProfileName == 'UKI Sales Ops' || ProfileName == 'DQA User' || ProfileName == 'UKI Marketing' || GLIServiceUser) || (gliRecordTypeId != null && apexpages.currentpage().getparameters().get('RecordType') != null && gliRecordTypeId.contains(apexpages.currentpage().getparameters().get('RecordType')))){
        if((user.contains(ProfileName)||GLIServiceUser) || (String.isnotblank(gliRecordTypeId) && String.isnotblank(recordType) && gliRecordTypeId.contains(recordType)))
        {   
            gliUser = true;
        }
        if(this.gliUser == true){
            oContact.Sales_Org__c = 'GLI';
        }
        // END Added by Shovon as per CRM-1035
        List<GGO_Static_Values__mdt> GGOSV =[SELECT MasterLabel,GGO_Value__c from GGO_Static_Values__mdt];
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
        if(profileName.containsIgnoreCase('USL')){
            uslUser = true;
        }
    }

    public PageReference redirectnewPage() {
        //string profileID = UserInfo.getProfileID();        // Commented by Shovon
        //ProfileName = [SELECT Name from Profile Where Id =:profileID].Name;
        system.debug('ProfileName..'+ProfileName);
        
        String url='';
        String returnURL = ApexPages.currentPage().getParameters().get('retURL');
        If(String.isNotBlank(returnURL)){
            url= returnURL.escapeHtml4();
        }
        if(ProfileName == System.Label.US_Sales_Users_profileName_of_CDM_M360 || ProfileName == System.Label.SalesRep_ProfileName_of_CDM_M360) {
            PageReference oPage = Page.ContactCreateNew;
            oPage.getParameters().put(RETURN_URL, ApexPages.currentPage().getParameters().get('retURL').escapeHtml4());
            system.debug('oPage..'+oPage);
            return oPage;
        }
        // START Added by Shovon as per CRM-1035
        // Redirecting GLI users to LCRMContactCreateError page when users trying to create contact from Contact home page
        else if(oContact.accountid == null && (gliUser == true || LCRMGenericComponent.isLotusUser() )){ 
            PageReference oPage = Page.LCRMContactCreateError;
            oPage.getParameters().put(RETURN_URL, ApexPages.currentPage().getParameters().get('retURL').escapeHtml4());
            //system.debug('oPage..'+oPage);
            return oPage;
        }
        // Redirecting GLI users to LCRMContactCreate page when users trying to create contact from Account related list
         else if(oContact.accountid != null && (gliUser == true || LCRMGenericComponent.isLotusUser() )){ 
            PageReference oPage = Page.LCRMContactCreate;
            oPage.getParameters().put(ACCOUNT_ID, oContact.accountId);
            oPage.getParameters().put(ENTITY, 'Contact');
            oPage.getParameters().put(SAVE_NEW, '1');
            oPage.getParameters().put(SFDC_OVERRIDE, '1');
            oPage.getParameters().put(RETURN_URL, url);
            system.debug('oPage..'+oPage);
            return oPage;
        }
         else if(uslUser == true){
            PageReference oPage = Page.LCRMContactCreate;
            oPage.getParameters().put(ACCOUNT_ID, oContact.accountId);
            oPage.getParameters().put(ENTITY, 'Contact');
            oPage.getParameters().put(SAVE_NEW, '1');
            oPage.getParameters().put(SFDC_OVERRIDE, '1');
            oPage.getParameters().put(RETURN_URL, url);
            //system.debug('oPage..'+oPage);
            return oPage;       
        }
        // END Added by Shovon as per CRM-1035
        return null;
    }
    public PageReference continueSave() {
        //this.SkipAddressValidation = true;
        this.SkipContactMatching = true;
        this.isDupContacts = false;
        return this.save();
    }
    public pageReference save(){
        pageReference oPageReference = null;
        this.isDupContacts = false;
        if(profileName == 'LatAm User' || profileName == 'Partner Portal User'|| GGOUser){
            this.checkDuplicateContacts();
            system.debug('isDupContacts11::'+isDupContacts);
            if(isDupContacts){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Duplicate_Contact));
                system.debug('isDupContacts22::'+isDupContacts);
                return null;
            }
            
        } 
        //make a call out to IDQ to see if there are any matching contacts
        
        if (this.SkipContactMatching == false){
            DataQualityUtil.ContactInfo oContactInfo = new DataQualityUtil.ContactInfo();
            //oContactInfo.MDBCustomerID = oContact.MDB_Account_Number__c;
            oContactInfo.Name = oContact.Firstname + ' ' + oContact.LastName;
            oContactInfo.email = oContact.Email;
            Account oAccount = queryAccount(oContact.accountid);
            oContactInfo.MDBCustomerID = oAccount.MDBID__c;
            if(Test.isRunningTest()) {
                listMatchedContacts = MockWebserviceResponses.getContactInfoResponse();
            }
            else {                        
                listMatchedContacts = DataQualityUtil.matchContacts(new List<DataQualityUtil.ContactInfo>{ oContactInfo });
            }
        }
        else {
            PageReference oSavePageReference = oStandardController.save();
            Contact oSavedContact = (Contact) oStandardController.getRecord();
            if (oSavedContact.Id != null) {
                oPageReference = oStandardController.view();
                
                oPageReference.getParameters().put('retUrl', '/' + oSavedContact.Id);
                oPageReference.setRedirect(true);
            }
            return oPageReference;
            
        } 
        //if there are matching contacts set the HasMatchingContacts to true
        if(!listMatchedContacts.isEmpty()){
            HasMatchingContacts =true;
            
            //****************************************************

            //Build Set of Matched Contact Ids
            Set<string> MDBIds = new Set<string>();
            for (DataQualityUtil.ContactInfo oContactMatchInfo : listMatchedContacts) {
                MDBIds.add(oContactMatchInfo.MDBContactID);
            }
            
            Map<string, Contact> mapMatchedContacts = new Map<string, Contact>();
            for (Contact oContact : this.queryContactsByMDBId(MDBIds)) {
                mapMatchedContacts.put(oContact.MDB_Contact_ID__c, oContact);
            }
            system.debug('listmatchedcontacts:' + listmatchedcontacts);
            for (DataQualityUtil.ContactInfo oContactMatchInfo : listMatchedContacts) {
                MatchedContact oMatchedContact = new MatchedContact();
                oMatchedContact.ContactInfo = oContactMatchInfo;
                oMatchedContact.Contact = mapMatchedContacts.get(ocontactMatchInfo.MDBContactID);
                oMatchedContact.Score = oContactMatchInfo.Score;
                system.debug('matchedcontact' + omatchedcontact); 
                this.MatchedContacts.add(oMatchedContact);
            }


            //*******************************************************************************************            
            
            
            return null;
        }
        else{//else if no matching records are found create the contact and redirect to the detail
            PageReference oSavePageReference = oStandardController.save();
            Contact oSavedContact = (Contact) oStandardController.getRecord();
            if (oSavedContact.Id != null) {
                oPageReference = oStandardController.view();
                
                oPageReference.getParameters().put('retUrl', '/' + oSavedContact.Id);
                oPageReference.setRedirect(true);
            }
            return oPageReference;
        }
    }
    
    // public class MatchedContact{
    
    // }
    /**
    * Identifies duplicate Contact to show a message to users
    */
    @testVisible
    private void checkDuplicateContacts() {
        if(oContact.FirstName != null && oContact.FirstName !='' && oContact.LastName != null && oContact.LastName != '' && oContact.Email != null && oContact.Email !=''){
            List<Contact> listCon = [select Id from Contact where FirstName=:oContact.FirstName and LastName=:oContact.LastName and Email=:oContact.Email and AccountId=:oContact.AccountId limit 1];
            if(listCon.size() > 0){
                this.isDupContacts = true;
            }
            
        }
        
        
    }
    /**
    * Queries the database for and account filtered by the specified account id
    *
    * @param   accountId   the account id to filter by
    * @return  an instance of an Account object
    */
    private static Account queryAccount(Id accountId) {
        return [SELECT 
        Id
        , MDBID__c
        FROM
        Account
        WHERE
        Id = :accountId];
    }
    private List<Contact> queryContactsByMDBId(Set<string> ContactIds) {
        return [SELECT  
        Id,
        MDB_Contact_ID__c                    
        FROM 
        Contact 
        WHERE 
        MDB_Contact_ID__c IN :ContactIds]; 
    }
    public class MatchedContact {
        public DataQualityUtil.ContactInfo ContactInfo {get;set;}
        public contact Contact {get;set;}
        public string Score {get;set;}
    }
}