/**
* Controller for the LCRMContactCreate that extends the 
* Contact standard controller
*
* @author  Shovon Bera
* @version 2017-01-09
*/
/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-06-14   Karthi                 Added UKI Service cloud profiles as per UKD-50
* =============================================================================
*/
public without sharing class LCRMContactCreateController{
    private final ApexPages.StandardController oStandardController;
    public Contact oContact{get;set;}
    public boolean gliUser {get;set;}
	public boolean uslUser {get;set;} //Added as part of DSS-6058
    public string profileName;
    public boolean HasMatchingContacts {get;set;}
    public string selectedContact {get;set;}
    public string selectedType {get;set;}
    public List<SalesforceContactOption> SFDCContactOptions {get;set;}
    public List<NewContact> NewContactOptions {get;set;}
    
    public List<DataQualityUtil.CDSContactInfo> MatchedSFDCContacts {get;set;}
    public List<DataQualityUtil.CDSContactInfo> MatchedCDSContacts {get;set;} 
    
    public Map<String, DataQualityUtil.CDSContactInfo> selectedSFDCContact = new Map<String, DataQualityUtil.CDSContactInfo>();
    public Map<String, DataQualityUtil.CDSContactInfo> selectedCDSContact = new Map<String, DataQualityUtil.CDSContactInfo>();
    
    public map<string, DataQualityUtil.CDSContactInfo> sfdcContactMap;
    public map<string, DataQualityUtil.CDSContactInfo> cdsContactMap;
    public DataQualityUtil.CDSContactInfo cdsContact = new DataQualityUtil.CDSContactInfo();
    
    public DataQualityUtil.MatchContactsSearchResponse oResponse {get;set;}
    
    public Integer maxCDSConRecordsDisplayed {get;set;}
    public Integer maxSFDCConRecordsDisplayed {get;set;}
    
    public boolean sfdcMatchAvailable {get;set;}
    public boolean cdsMatchAvailable {get;set;}
    
    String fromTrainingEvent;
    public String TrainingEventId{get;set;}
    public String ProposalId{get;set;}//added by apttus CRM-7828
    public String UserBusinessUnit;  // added by Harika CRM-17590 
    
    public LCRMContactCreateController(ApexPages.StandardController controller) {
        oStandardController = controller;
        oContact = (Contact)controller.getRecord(); 
        HasMatchingContacts = false;
        
        string profileID = UserInfo.getProfileID(); 
        ProfileName = [SELECT Name from Profile Where Id =:profileID].Name;
    // START--New profile added for ESC_UKI by Karthi as per UKD-50
        boolean GLIServiceUser = GLIGenericUtilityHelper.GLIServiceUserCheck();
         // END--New profile added for ESC_UKI by Karthi as per UKD-50
        if(ProfileName == System.Label.Elite_User || ProfileName == System.Label.UKI_User || ProfileName == System.Label.DQA_User|| GLIServiceUser){
            gliUser = true;
        }
        if(this.gliUser == true){
            oContact.Sales_Org__c = 'GLI';
        }
		uslUser = false;
        if(profileName.containsIgnoreCase('USL')){
            uslUser = true;
        }
        maxCDSConRecordsDisplayed = 0;
        maxSFDCConRecordsDisplayed = 0;
        sfdcMatchAvailable = false;
        cdsMatchAvailable = false;
        UserBusinessUnit = LCRMGenericComponent.getUserBU();  // added by Harika CRM-17590 
        fromTrainingEvent = Apexpages.currentPage().getParameters().get('fromTrainingEvent');
        TrainingEventId =Apexpages.currentPage().getParameters().get('TEId');
        
    ProposalId = ApexPages.currentPage().getParameters().get('ProposalId');//added by apttus CRM-7828
        System.debug('ProposalId : '+ProposalId);//added by apttus CRM-7828
    }
    public void Next(){
        if(oContact.FirstName == null || oContact.Sales_Org__c != 'GLI' || (!uslUser && oContact.ESC_tocLanguage__c == null)){
            if(oContact.FirstName == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.LTS_RequiredFieldFN));
            }
            if(oContact.Sales_Org__c != 'GLI'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.Sales_Org_GLI_Error));
            }
			if(!uslUser){
                if(oContact.ESC_tocLanguage__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.Language_Preference_Required)); //Added as per DPS-5528
                }
				}
        }
        else{
        HasMatchingContacts = true;
        SFDCContactOptions = getContactDetails(oContact);
        NewContactOptions = getNewContact(oContact);
        }
    }
    public void Back(){
        HasMatchingContacts = false;
    }
    public pageReference ContactCreate(){
        pageReference oPageReference = null;
        if(selectedType == 'NEWContact'){
        
            //added by Saloni for CRM-3247
                if(fromTrainingEvent == '1'){
                    oContact.LCRM_Created_from_Training_Event__c = true;
                    oContact.Do_not_Mail__c = true;
                    oContact.DoNotCall = true;
                    //added by Harika for CRM-17590
                    IF(UserBusinessUnit == 'UKI')
                    {
                        oContact.Contact_Type__c = 'UKI - Training Event';
                    }
                    
                }
                
            PageReference oSavePageReference = oStandardController.save();
            Contact oSavedContact = (Contact) oStandardController.getRecord();
            
            if (oSavedContact.Id != null) {
            
                if(fromTrainingEvent == '1' && TrainingEventId != null)
                {
                     
                    Training_Event_Contact__c tecontact = new Training_Event_Contact__c();
                    tecontact.Contact_Name__c = oSavedContact.Id;
                    tecontact.Training_Event__c=TrainingEventId.escapeHtml4(); 
                    if(Schema.sObjectType.Training_Event_Contact__c.isUpdateable())
                    insert tecontact;
                }
                oPageReference = oStandardController.view();
                
                oPageReference.getParameters().put('retUrl', '/' + oSavedContact.Id);
                oPageReference.setRedirect(true);
                //Start : added by apttus CRM-7828
                System.debug('ProposalId redirect : '+ProposalId);
                if(ProposalId !=null && ProposalId!=''){
                    Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c(id=ProposalId, APTS_Order_Confirmation_Contact__c = oSavedContact.Id);
                    update prop;
                    oPageReference = new PageReference('/'+ ProposalId);
                    System.debug('Proposal redirect : '+oPageReference);
                }
                //End : added by apttus CRM-7828
            }
        }
        else if(selectedCDSContact.get(selectedContact) != null){
            Contact newContact = new Contact();
            newContact.firstname = selectedCDSContact.get(selectedContact).first_name;
            newContact.lastname = selectedCDSContact.get(selectedContact).last_name;
            newContact.Email = selectedCDSContact.get(selectedContact).Contact_Email;
            newContact.Phone = selectedCDSContact.get(selectedContact).Contact_Phone;
            newContact.Job_Function__c = selectedCDSContact.get(selectedContact).Job_Function;
            newContact.Title = selectedCDSContact.get(selectedContact).Title;
            if(selectedCDSContact.get(selectedContact).Contact_Inactive != null)// Added by Shovon for CRM-6056
            newContact.Contact_Inactive__c = selectedCDSContact.get(selectedContact).Contact_Inactive; 
            newContact.AccountId = oContact.AccountId;
            newContact.LCRM_Is_CDS_Ready__c = true;
            
            //added by Saloni for CRM-3247
            if(fromTrainingEvent == '1'){
                newContact.LCRM_Created_from_Training_Event__c = true;
                newContact.Do_not_Mail__c = true;
                newContact.DoNotCall = true;
            }
            
            System.debug('@@@@@ Contact is: '+newContact);
            if(Schema.sObjectType.Contact.isCreateable())
            insert newContact;
            System.debug('@@@@@ Contact ID is: '+newContact.Id);
            if (newContact.Id != null) {
            
            if(fromTrainingEvent == '1' && TrainingEventId != null)
            {
            Training_Event_Contact__c tecontact = new Training_Event_Contact__c();
            tecontact.Contact_Name__c = newContact.Id;
            tecontact.Training_Event__c=TrainingEventId.escapeHtml4(); 
            if(Schema.sObjectType.Training_Event_Contact__c.isCreateable())
            insert tecontact;
            }
                oPageReference = new PageReference('/'+ newContact.Id);
                //Start : added by apttus CRM-7828
                System.debug('ProposalId redirect : '+ProposalId);
                if(ProposalId !=null && ProposalId!=''){
                    Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c(id=ProposalId, APTS_Order_Confirmation_Contact__c = newContact.Id);
                    if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable())
                    update prop;
                    oPageReference = new PageReference('/'+ ProposalId);
                    System.debug('Proposal redirect : '+oPageReference);
                }
                //End : added by apttus CRM-7828
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.label.LTS_SelectContact
));
        }
        return oPageReference;
    }
    public List<NewContact> getNewContact(Contact oContact){
        List<NewContact> contactOptions = new List<NewContact>();
        NewContact conOption = new NewContact(oContact);
        contactOptions.add(conOption);
        return contactOptions;
    }
    
    public List<SalesforceContactOption> getContactDetails(Contact oContact){
        
        List<SalesforceContactOption> contactOptions = new List<SalesforceContactOption>();
        
        List<Contact> contactQueryResult = queryContactByLeadContactName();
        for (Contact conRec : contactQueryResult) {
            SalesforceContactOption conOption = new SalesforceContactOption(conRec);
            contactOptions.add(conOption);
        }
        
        this.MatchedSFDCContacts = new List<DataQualityUtil.CDSContactInfo>();
        this.MatchedCDSContacts = new List<DataQualityUtil.CDSContactInfo>();
        
        //Set up Contact data to be sent to CDS
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.CDSContactSearchServiceNameContact);
        
        DataQualityUtil.ContactDetails oContactDetails = new DataQualityUtil.ContactDetails();
        oContactDetails.firstName = oContact.Firstname;
        oContactDetails.lastName = oContact.Lastname;
        oContactDetails.eMail = oContact.Email;
        oContactDetails.phone = oContact.Phone;
        oContactDetails.searchType = 'Contact';
        //Pass the Account ID to the CDS and not the GUP ID.
        //For the Account id, CDS will find its GUP ID  and 
        //then we have to read all its child account contacts & its own contacts
        oContactDetails.gUltimate_ParentId = oContact.AccountId;
        oContactDetails.maxCount_GLI = (Integer) oWebServiceSettings.Max_GLI_Count__c;
        oContactDetails.maxCount_NonGLI = (Integer) oWebServiceSettings.Max_Non_GLI_Count__c;
        System.debug('@@@@@oContactDetails: '+oContactDetails);
        //Use Custom setting for below changes
        
        // test coverage condition   
            
           DataQualityUtil.isContactCall = true;
           oResponse =  DataQualityUtil.matchCDSContacts(oContactDetails);
           System.debug('@@@@@oResponse : '+oResponse);
           system.debug('+++++ SFDC COntacts');
            for(DataQualityUtil.CDSContactInfo rec: oResponse.SFDCContacts){
                system.debug('+++++ Inside SFDC Contacts');
                selectedSFDCContact.put(rec.source_system_id, rec); 
            }
            maxSFDCConRecordsDisplayed = selectedSFDCContact.size();
            system.debug('+++++ CDS COntacts');
            for(DataQualityUtil.CDSContactInfo rec: oResponse.CDSContacts){
                system.debug('+++++ Inside CDS Contacts');
                selectedCDSContact.put(rec.source_system_id, rec); 
            }
            maxCDSConRecordsDisplayed = selectedCDSContact.size();
            if(selectedSFDCContact.size() > 0){
                sfdcMatchAvailable = true;
            }
            if(selectedCDSContact.size() > 0){
                cdsMatchAvailable = true;
            }
        return contactOptions; 
    }
    //Inner Class for Existing Salesforce Contacts
    public class SalesforceContactOption {
        //Properties
        public boolean IsSelected {get;set;}
        public Contact Contact {get;set;}
        
        //Constructors
        public SalesforceContactOption() {
            this.IsSelected = false;
            this.Contact = new Contact();
        }
        
        public SalesforceContactOption(Contact oContact) {
            this();
            this.Contact = oContact;
        }
    }
    public class NewContact {
        //Properties
        public boolean IsSelected {get;set;}
        public Contact Contact {get;set;}
        public String Name {get;set;}
        public Account Acc {get;set;}
        public String AccName {get;set;}
        public String AccStAdd {get;set;}
        public String cityState {get;set;}
        //Constructors
        public NewContact() {
            this.IsSelected = false;
            this.Contact = new Contact();
            this.Name = null;
            this.Acc = null;
            this.AccName = null;
            this.AccStAdd = null;
            this.cityState = null;
            
        }
        
        public NewContact(Contact oContact) {
            this();
            this.Contact = oContact;
            if(oContact.salutation != null){
                this.Name = oContact.salutation;
            }
            if(oContact.FirstName != null){
                if(this.Name != null){
                this.Name = this.Name + ' ' + oContact.FirstName;
                }
                else{
                this.Name = oContact.FirstName;
                }
            }
            if(oContact.LastName != null){
                if(this.Name != null){
                this.Name = this.Name + ' ' + oContact.LastName;
                }
                else{
                this.Name = oContact.LastName;
                }
            }
            if(oContact.accountId != null){
            	
            	if(Schema.sObjectType.Account.isQueryable())
                this.Acc = [select Id, Name, BillingStreet, BillingCity, BillingState From Account Where Id =: oContact.accountId Limit 1];
                this.AccName = this.Acc.Name;
                this.AccStAdd = this.Acc.BillingStreet;
                this.cityState = this.Acc.BillingCity +', '+this.Acc.BillingState;
            }
        }
    }
    //Returns Salesforce Contact. This method will be replaced with a Webservice Call.
    public List<Contact> queryContactByLeadContactName(){
        return (List<Contact>) [select id, name, Account.Name, MailingStreet,Email, Phone, Job_Function__c, Title, MailingCity, Account.Billing_City_State__c from contact limit 5];
    }
    /* 
    public PageReference myMethod(){
        system.debug('+++ Uinside myMethod');
        system.debug('+++ selectedContact is '+ selectedContact);
        system.debug('+++ selectedType is '+ selectedType);
        system.debug('++++++++++++');
        return null;
    }
    */
}