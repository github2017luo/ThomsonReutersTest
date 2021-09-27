/**
* Description   : CRM-1250, CRM-1259, CRM-1268, CRM-1278 ,CRM-6328
*                 Controller for Lead Conversion functionality.    
* Author        : TCS 
* Change History: 15-Dec-2016 Initial Version
11-Mar-2019 :DPS-3112 - Added new method named addAccountTeamMember for CorpPartnerCommunity 
12-Feb-2019 : Replaced hard coded values with Custom labels as a aprt of DPS-1836 and added checks to prevent violations like Apex CRUD and Apex Sharing
20-Apr-2018 : Carry the Lead's Description value over to Opportunity.
24-May-2018: Exclude the renewal Opportunities from Opportunity selection screen.
28-Aug-2017  Updated for CRM-6328, CRM-6333 & CRM-6332 (R4), CRM-12851 
12-Feb-2019: Replaced hard coded values with Custom labels as a aprt of DPS-1836 and added checks to prevent violations like Apex CRUD and Apex Sharing
05-Mar-2019: DPS-2516: Updated convertLead function so that convertLead function execution redirects the page to Newly created contact in Lightning.
* 
* 
* 
*/
//Added without sharing to prevent Apex Sharing violation Rule
public without sharing class LCRMConvertLeadController {
    ApexPages.standardController leadSC = null;
    //public boolean isAccountSection {get;set;} //Unused code, so commented
    public boolean displayContact {get;set;}
    public boolean displayAccount {get;set;}
    public boolean displayOpty {get;set;}
    public boolean displayOpportunity {get;set;}
    public string selectedContact {get;set;}
    public string selectedType {get;set;}
    public string selectedAccountId {get;set;}
    public string selectedAccountType {get;set;}
    public Lead leadDetails = new Lead();
    //public static Lead leadRec = new Lead();
    
    //public string selectedCDSContactId {get;set;} //Unused code, so commented
    //public string selectedCDSType {get;set;} //Unused code, so commented
    
    public string selectedOpptyId {get;set;}
    public string selectedOpptyType {get;set;}
    
    public String leadId {get;set;}  
    //public boolean allpages {get;set;} //Unused code, so commented
    //public boolean onlyContact {get;set;} //Unused code, so commented
    public boolean onlyOpportunity {get;set;}
    
    public string selectedContactName {get;set;}
    public string selectedContactEmail {get;set;}
    
    public string selectedAccountName {get;set;}
    public string selectedAccountAddress {get;set;}
    
    public List<OpportunityOption> leadOpportunityOptions {get;set;}
    
    //New Contact and Account
    public NewContactOption newContactDetails {get;set;}
    public NewAccountOption newAccountDetails {get;set;}
    public AccountSearchOption newAccountSearchDetails {get;set;}
    
    public List<DataQualityUtil.CDSContactInfo> matchedSFDCContacts {get;set;}
    public List<DataQualityUtil.CDSContactInfo> matchedCDSContacts {get;set;} 
    
    public map<string, DataQualityUtil.CDSContactInfo> sfdcContactMap;
    public map<string, DataQualityUtil.CDSContactInfo> cdsContactMap;
    public Map<String, DataQualityUtil.CDSContactInfo> selectedSFDCContact = new Map<String, DataQualityUtil.CDSContactInfo>();
    public Map<String, DataQualityUtil.CDSContactInfo> selectedCDSContact = new Map<String, DataQualityUtil.CDSContactInfo>();
    
    public Map<String, DataQualityUtil.ECMAccountInfo> selectedSFDCAccount = new Map<String, DataQualityUtil.ECMAccountInfo>();
    public Map<String, DataQualityUtil.ECMAccountInfo> selectedECMAccount = new Map<String, DataQualityUtil.ECMAccountInfo>();
    
    
    public DataQualityUtil.CDSContactInfo sfdcContact = new DataQualityUtil.CDSContactInfo();
    public DataQualityUtil.CDSContactInfo cdsContact = new DataQualityUtil.CDSContactInfo();
    
    public DataQualityUtil.ECMAccountInfo sfdcAccount = new DataQualityUtil.ECMAccountInfo();
    public DataQualityUtil.ECMAccountInfo ecmAccount = new DataQualityUtil.ECMAccountInfo();
    
    //DataQualityUtil.ECMAccountInfo ecmAccount = selectedSFDCAccount.get(2);
    public DataQualityUtil.MatchContactsSearchResponse oResponse {get;set;}
    //public DataQualityUtil.MatchContactsSearchResponse match {get;set;}
    
    public DataQualityUtil.MatchAccountsResponse oResponseAccount {get;set;}
    
    public String selectedOppOwnerId {get;set;}
    
    public Integer contactExistInContactRole {get;set;}
    public Integer accountAssociatedToOpp {get;set;}
    public Integer leadOwnerExistInOppTeam {get;set;}
    public Integer countryMatches {get;set;}
    
    public List<SelectOption> countryOptions {get;set;}
    public List<SelectOption> countryRegionOptions {get;set;}
    
    public List<SelectOption> countrySearchOptions {get;set;}
    public List<SelectOption> countryRegionSearchOptions {get;set;}
    public Map<String,String> mapLeadfields = new Map<String,String>{   'Billing_Street__c'=> 'Street ',
        'Billing_City__c'=>'City ',
        'Billing_Country__c'=>'Country ',
        'Email'=>'Email Address ',
        'Billing_Zip__c'=> 'Zip/Postal Code ',
        'FirstName'=> 'First Name '};
            public String sErrorMsg='';
    public boolean bError {get;set;}
    public String convertedStatusLabel {get;set;}
    
    public Map<String, Opportunity> selectedSFDCOppty = new Map<String, Opportunity>();
    public Opportunity selectedOppty = new Opportunity();
    
    public String convertedAccountId {get;set;}
    public String convertedContactId {get;set;}
    public String convertedOpptyId {get;set;}
    
    Map<String,LM_Lead_History__c> lHistoryMap{get;set;}
    
    public Contact accountSkipRecord = new Contact();
    public boolean skipAccount = false;
    //public String strOpptyPageNumber {get;set;}
    public Integer maxOpptyRecordsRetrieved {get;set;}
    public Integer maxOpptyRecordsDisplayed {get;set;}
    
    public Integer maxCDSConRecordsDisplayed {get;set;}
    public Integer maxSFDCConRecordsDisplayed {get;set;}
    
    
    public Integer maxECMAcctRecordsDisplayed {get;set;}
    public Integer maxSFDCAcctRecordsDisplayed {get;set;}
    public String userObjPrefix = Schema.sobjectType.user.getKeyPrefix();
    
    public Set<String> setStateCountry = new set<String>();
    public Set<String> setZipCountry = new set<String>();
    public Id informaticaUserId = null;
    public Boolean canEdit {get;set;}
    
    public String profileName; //Added for R4 functionality
    public String subbu; //Added for R4 functionality
    public boolean uslUser {get;set;} //Added for R4 functionality
    public boolean ukiOrEliteUser ;// Added for R4 functionality
    public List<LCRM_Recommended_Product__c>  listRecommendProd;
    public static boolean restrictTMSFunc = true;
    Public SET<id> leadids = new SET<id>();
    private string idofLead =string.escapeSingleQuotes('id');
    public boolean partnerUser = LCRMGenericComponent.isLotusUser();
    
    List<Task>  taskListforLeads = new List<Task>(); //Added for CRM-17825
    List<Event> eventListforLeads = new List<Event>(); //Added for CRM-17825
    
    public static boolean lcrmConvertLeadFlag = true; //Added for CRM-17836
    
    public LCRMConvertLeadController(ApexPages.StandardController controller) {
        //selectedContact='';
        //selectedType='';
        system.debug('+++ inside LCRMConvertLeadController');
        leadSC = controller;
        //Added if condition and  string.escapeSingleQuotes() to avoid Apex XSSFROMURLPARAM Violation Rule_PMD Scan
    if(string.isNotBlank(ApexPages.currentPage().getParameters().get(idofLead ))){
        leadId  = (String)(string.escapeSingleQuotes(ApexPages.CurrentPage().getparameters().get(idofLead)));}
        displayAccount = false;
        displayOpty = false;
        onlyOpportunity = false;
        canEdit = false;
        lHistoryMap = new  Map<String,LM_Lead_History__c>();
        maxOpptyRecordsRetrieved = 0;
        maxOpptyRecordsDisplayed = 0;
        
        maxCDSConRecordsDisplayed = 0;
        maxSFDCConRecordsDisplayed = 0;
        maxECMAcctRecordsDisplayed = 0;
        maxSFDCAcctRecordsDisplayed = 0;
        
        contactExistInContactRole = 0;
        accountAssociatedToOpp = 0;
        leadOwnerExistInOppTeam = 0;
        countryMatches = 0;
        
        uslUser = false;
        ukiOrEliteUser = false ;
        //Check if user has edit access on the lead record. If he has then only proceed
        //Otherwise throw an error.
        
        Id loggedInUserId = UserInfo.getUserId();
        leadids.add(leadid);
        User loggedinUser = new User();
        
        //Start : Added for R4 functionality CRM - 6332
        /**profileName = [SELECT Profile.Id, Profile.Name from User Where Id =:loggedInUserId].Profile.Name;
        subbu = [SELECT Sub_Bu__c from User Where Id =:loggedInUserId].Sub_Bu__c; **/
        //Added a conditin to avoid APEX CRUD VIOLATION RULE
    if(Schema.sObjectType.User.isQueryable()){
        loggedinUser  = [SELECT Profile.Id, Profile.Name,Sub_Bu__c from User Where Id =:loggedInUserId limit 1];}
        profileName = loggedinUser.Profile.Name;
        subbu = loggedinUser.Sub_Bu__c;
        system.debug('@@@@@profile Name @@@@@' +profileName);
        if((profileName == 'GLI Sales User' || profileName == 'GLI Sales Ops User'  || subbu == 'FindLaw' || subbu == 'USL' || subbu == 'LMS')){
             uslUser = true;
        }
         else if((profileName == 'UKI Sales Ops' || profileName == 'UKI Users' || profileName == 'Elite Sales Ops' || profileName == 'Elite User' || subbu == 'UKI' || subbu == 'Elite')){
              ukiOrEliteUser = true ;
        }
       
        //End : Added for R4 functionality CRM - 6332
        listRecommendProd = new List<LCRM_Recommended_Product__c>();//Added for CRM-12851
        UserRecordAccess oUserAccessRecord = new UserRecordAccess ();
    //Added a conditin to avoid APEX CRUD VIOLATION RULE
        if(Schema.sObjectType.UserRecordAccess.isQueryable()){
         oUserAccessRecord = [SELECT RecordId ,HasEditAccess FROM UserRecordAccess where recordId = :leadId and userid = :loggedInUserId  limit 1];}
        if(oUserAccessRecord != null)
        {
            canEdit = oUserAccessRecord.HasEditAccess;
        }
        //Added a conditin to avoid APEX CRUD VIOLATION RULE
        if(canEdit && Schema.sObjectType.User.isQueryable())
        {
            List<User> lstUser = [Select Id from User where Name = 'Informatica User' limit 1];
            
            if(lstUser != null && lstUser.size()>0)
            {
                informaticaUserId = lstUser[0].Id;
            }
            
            
            oResponseAccount = new DataQualityUtil.MatchAccountsResponse();
            try{
                getContactDetails(leadId);
            }catch(Exception e){
                system.debug('++++++ Exception is '+ e);
                system.debug('++++++ Exception message is  '+ e.getMessage());
                bError = true;
                ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(msg);
            }
        }
        else        {
            bError = true;
            ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR, Label.LCRM_Insufficient_Privilege_Error_Message);
            ApexPages.addMessage(msg);        }
    }
    
    
    /**
* Modifies the countryRegionOptions property based on the selected
* country.
*/
    public void addressCountryChanged() 
    {
        this.countryRegionOptions = DataQualityUtil.listAvailablecountryRegionOptions(newAccountDetails.billingCountry);
    }
    
    public void addressSearchCountryChanged() 
    {
        this.countryRegionSearchOptions = DataQualityUtil.listAvailablecountryRegionOptions(newAccountSearchDetails.country);
    }
    
    public void checkifGLILead(boolean isGLI, string salesOrg)
    {
        if(!isGLI || (salesOrg != 'GLI' && salesOrg != 'WEST'))
        {
            leadDetails.addError(Label.LCRM_GLI_Lead_Convert_Error_Non_GLI);
            bError = true;
        }
    }
    
    //Method to determine if mandatory field is blank and give appropriate error message.
    public void checkRequiredFields()
    {
        Schema.DescribeSObjectResult leadDescresult = Schema.SObjectType.Lead;         
        Map<string,LCRMConvertLeadCountryCode__c> countryName = LCRMConvertLeadCountryCode__c.getall()!=null?LCRMConvertLeadCountryCode__c.getall():new Map<string,LCRMConvertLeadCountryCode__c>();
        
        for(String sfield : mapLeadfields.Keyset()){
            if(leadDetails.get(sfield)==null)
            { 
                System.debug(sfield+'&&&&&');
                
                if(sfield == 'Billing_Zip__c'){
                    
                    if(string.isNotBlank(leadDetails.Billing_Country__c )){
                        
                        system.debug('Billing Country' + leadDetails.Billing_Country__c);
                        if(countryName !=null && countryName.size() > 0){
                            
                            system.debug('@@ countryname'+ countryName);
                            List<string> subBu = new List<string>();
                            if(countryName.containsKey(leadDetails.Billing_Country__c))
              {
                if(String.isNotBlank(countryName.get(leadDetails.Billing_Country__c).Region__c)){
                    subBu = countryName.get(leadDetails.Billing_Country__c).Region__c.split(',');}
                
                if(subBu.isEmpty() || !subBu.contains(leadDetails.LCRM_Sub_Bu__c))
                {
                  sErrorMsg +=  '  '+leadDescresult.fields.getMap().get(sfield).getDescribe().getlabel();
                  bError = true;    
                }
                
              }
              else{
                sErrorMsg +=  '  '+leadDescresult.fields.getMap().get(sfield).getDescribe().getlabel();
                                bError = true;
              }
              
            }
            else
            {
              sErrorMsg +=  '  '+leadDescresult.fields.getMap().get(sfield).getDescribe().getlabel();
                            bError = true;
            }              
              
          }
                }else{
                    //sErrorMsg += '  '+mapAccountfields.get(sfield) ;
                    sErrorMsg +=  '  '+leadDescresult.fields.getMap().get(sfield).getDescribe().getlabel();
                    bError = true;
                }
                                              
                                             
            }
        }        
        sErrorMsg =sErrorMsg.trim();
        sErrorMsg =sErrorMsg.replace('  ',', ');
        if(bError == true){
            
            //primaryLead.addError( 'Please navigate back to Lead and enter values for '+sErrorMsg+'.');
            leadDetails.addError( Label.LCRM_GLI_Lead_Convert+': '+sErrorMsg+'.');
            
        }
    }
    
    
    //This method does a Call out to CDS to retreive contacts from CDS.
    //If a contact is already associated with Lead then the call out is skipped and user is redirected 
    //to Opportunity selection screen.
    
    public void getContactDetails(String selectedLead){
        displayContact = true;
        if (Schema.sObjectType.Lead.isAccessible()) {
        leadDetails = [SELECT Id,Description,URL__c,Phone,Email,FirstName,LastName,Status,Convert_by__c,Accept_by__c,MDBId__c,
                              SAPAccountNumber__c,Is_Trial_Lead__c,Lead_Scoring_Combined__c,Billing_City__c,Billing_State__c,
                              Billing_Street__c,PO_Box__c,Tax_Number__c,Tax_Number_Type__c,Billing_Zip__c,Sales_Org__c,Billing_Country__c,
                              Customer_Class__c,Customer_Group__c,ConvertedOpportunityId,Campaign_Cell__c,Contact__c,
                              Contact__r.AccountId,Account__c,Account__r.BillingCity,Account__r.Name,Contact__r.Account.Name,
                              Account__r.Operational_Ultimate_Parent_ECM_Party_ID__c,Account__r.BillingStreet,Contact__r.Email,
                              Contact__r.Account.BillingStreet,Contact__r.Account.Operational_Ultimate_Parent_ECM_Party_ID__c,
                              Account__r.BillingPostalCode,Account__r.BillingState,Account__r.BillingCountry,Contact__r.Account.BillingCountry,
                              Customer_Type__c,Industry,Contact__r.Name,Campaign_code__c,Source__c,Legacy_System_ID__c,OwnerId,
                              Acceptance_SLA_Violation__c,Accept_By_Date__c,Convert_By_Date__c,Company,Business_Org__c,Contact_SAP_ID__c,
                              Convert_SLA_violation__c,Discard_Reason__c,External_Contact_ID__c,External_ID__c,LeadID18__c,LastModifiedBy.Name,
                              Owner.Name,LeadSource,Job_Function__c,Title,Type__c,Name,Primary_Campaign_Source__c,Priority__c,Source_Desc__c,
                              Tracking_Code__c,Is_GLI__c,Account__r.ECM_Party_ID__c,Contact__r.Account.Operational_Ultimate_Parent_Name1__c,
                              LCRM_Email_Verification__c,LCRM_Email_Verification_TimeStamp__c,LCRM_Phone_Verification__c,
                              LCRM_Phone_Verification_TimeStamp__c,LCRM_Mobile_Verification__c,LCRM_Mobile_Verification_TimeStamp__c,
                              LCRM_Sub_BU__c,Budget_Available__c,Decision_Maker_Champion__c,Need_Identified__c,Qualified_Product_s__c,
                              Qualifying_Notes__c,Telequalified_Appointment_Complete__c,Timeline_Identified__c,Line_of_Business__c,
                              Operating_Unit__c,Tele_Interaction__c,Is_Marketing__c
                       FROM   Lead
                       WHERE  Id =: selectedLead];
        //LCRMConvertLeadController.leadRec = leadDetails;
        
        List<State_required_Countries__c> stateCountryList = State_required_Countries__c.getall().values();
        for(State_required_Countries__c rec: stateCountryList){
            setStateCountry.add(rec.Country_Code__c);        }
        
        //If the country specified on Lead needs a state and if the State is left blank, then add it to 
        //the map, to error out.
        if(setStateCountry.contains(leadDetails.Billing_Country__c) && AppUtil.IsEmpty(leadDetails.Billing_State__c))        { 
            mapLeadfields.put('Billing_State__c','State');        } 
        
        checkRequiredFields();
        
        String isgli =string.valueOf(leadDetails.Is_GLI__c);
        system.debug('+++ isgli '+ isgli);
        //String status = LCRMGenericComponent.convertedLeadStatus(isgli+'');
        checkifGLILead(leadDetails.Is_GLI__c, leadDetails.sales_org__c);
        String status = Label.LCRMLeadConvertStatus;
        system.debug('+++ status '+ status);
        convertedStatusLabel = getLeadStatusIsConverted(status);
        
        system.debug('++++++++++++ leadDetails.Contact__c '+ leadDetails.Contact__c);
        system.debug('************ leadDetails '+ leadDetails);
        
        
        
        
        //If Lead already has a Contact associated then directly goto Opportunity selection page.
        if(leadDetails.Contact__c != null){
            //Directly goto Opportunity Page.
            displayContact = false;
            displayAccount = false;
            displayOpportunity = true;
            onlyOpportunity = true;
            selectedAccountId = leadDetails.contact__r.AccountId;
            selectedContact = leadDetails.contact__c;
            selectedContactName =  leadDetails.contact__r.name;
            selectedContactEmail =  leadDetails.contact__r.email;
            selectedAccountName =  leadDetails.contact__r.Account.Name;
            selectedAccountAddress =  leadDetails.contact__r.Account.BillingStreet;
            goToOptySelection(); 
            
        }else{
            //Method to invoke CDS.
            try{
                getLeadContactOptions(leadDetails);
            }catch(DataQualityUtil.ContactMatchingServiceException oException) {
                bError = true;
                system.debug('++++ Inside getContactDetails ->  ContactMatchingServiceException');
                ApexPages.addMessages(oException);
            }catch(Exception e){
                bError = true;
                ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(msg);
            }
            
            
        }
        
        
        newContactDetails = new NewContactOption();
        newContactDetails.firstName = leadDetails.FirstName;
        newContactDetails.lastName =  leadDetails.LastName;
        newContactDetails.email = leadDetails.Email;
        newContactDetails.LCRMEmailVerification = leadDetails.LCRM_Email_Verification__c;
        newContactDetails.title = leadDetails.Title;
        //Function field is not available
        newContactDetails.function = leadDetails.Job_Function__c;
        newContactDetails.phone =  leadDetails.Phone;
        newContactDetails.LCRMPhoneVerification =  leadDetails.LCRM_Phone_Verification__c;
        system.debug('+++ newContactDetails '+ newContactDetails);
        
        //New Account details
        newAccountDetails = new NewAccountOption();
        newAccountDetails.accountName = leadDetails.Company;
        newAccountDetails.billingStreet = leadDetails.Billing_Street__c;
        newAccountDetails.billingState = leadDetails.Billing_State__C;
        newAccountDetails.billingCountry = leadDetails.Billing_Country__c;
        newAccountDetails.billingCity = leadDetails.Billing_City__c;
        newAccountDetails.billingZipCode = leadDetails.Billing_Zip__c;
        newAccountSearchDetails = new AccountSearchOption();
        system.debug('+++ newAccountDetails '+ newAccountDetails);
        
        this.countryOptions = DataQualityUtil.listAvailablecountryOptions();
        this.countryRegionOptions = DataQualityUtil.listAvailablecountryRegionOptions(newAccountDetails.billingCountry);
        
        this.countrySearchOptions = DataQualityUtil.listAvailablecountryOptions();
        this.countryRegionSearchOptions = DataQualityUtil.listAvailablecountryRegionOptions(newAccountSearchDetails.country);
      }  
    }
    
    public void getLeadContactOptions(Lead leadDetails){
        
        //CDS service related code.
        
        this.matchedSFDCContacts = new List<DataQualityUtil.CDSContactInfo>();
        this.matchedCDSContacts = new List<DataQualityUtil.CDSContactInfo>();
        
        //Set up Contact data to be sent to CDS
        system.debug('+++ before calling system debug');
        //Get the webservice settings details to invoke CDS.
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataQualityUtil.CDSContactSearchServiceName);
        DataQualityUtil.ContactDetails oContactDetails = new DataQualityUtil.ContactDetails();
        oContactDetails.firstName = leadDetails.Firstname;
        oContactDetails.lastName = leadDetails.Lastname;
        oContactDetails.eMail = leadDetails.Email;
        oContactDetails.phone = leadDetails.Phone;
        
        //Since it is Lead conversion, the search type is LEAD.
        oContactDetails.searchType = 'Lead';
        
        //TBD: if contact is populated then get the GUIP from account associated to contact else from Account associated with Lead
        //Pass the Account ID to the CDS and not the GUP ID.
        //For the Account id, CDS will find its GUP ID  and 
        //then we have to read all its child account contacts & its own contacts
        oContactDetails.gUltimate_ParentId = leadDetails.Account__c;
        oContactDetails.maxCount_GLI = (Integer) oWebServiceSettings.Max_GLI_Count__c;
        oContactDetails.maxCount_NonGLI = (Integer) oWebServiceSettings.Max_Non_GLI_Count__c;
        
        
        oResponse = new DataQualityUtil.MatchContactsSearchResponse();
        
        system.debug('++ before calling Debug'+oContactDetails);
        oResponse =  DataQualityUtil.matchCDSContacts(oContactDetails);
        
    // 20181231 - Jason Flippen - Added for Jira Story CRM-17978.
    if (Schema.sObjectType.Contact.isAccessible()) {
        List<Contact> sfdcContactList = [SELECT Id,FirstName,LastName,Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingState,Account.BillingPostalCode,
                                            Email, Phone,Job_Function__c,Title, Contact_Inactive__c FROM Contact WHERE  FirstName = :leadDetails.FirstName AND LastName = :leadDetails.LastName AND Email = :leadDetails.Email  AND  LCRM_Is_GLI__c = true];

        System.debug(sfdcContactList +'+++++ SFDC Contacts' + leadDetails);
/*
        for(DataQualityUtil.CDSContactInfo rec: oResponse.SFDCContacts){
            system.debug('+++++ Inside SFDC Contacts');
            selectedSFDCContact.put(rec.source_system_id, rec); 
            
        }
*/
    // 20181231 - Jason Flippen - Added for Jira Story CRM-17978.
    oResponse.SFDCContacts.clear();
        if (!sfdcContactList.isEmpty()) {
            for (Contact sfdcContact : sfdcContactList) {
                DataQualityUtil.CDSContactInfo rec = new DataQualityUtil.CDSContactInfo();
                rec.Source_System_ID = sfdcContact.Id;
                rec.First_Name = sfdcContact.FirstName;
                rec.Last_Name = sfdcContact.LastName;
                rec.Contact_Email = sfdcContact.Email;
                rec.Contact_Phone = sfdcContact.Phone;
                rec.Account_Name = sfdcContact.Account.Name;
                rec.Account_Address = sfdcContact.Account.BillingStreet;
                rec.City = sfdcContact.Account.BillingCity;
                rec.Country = sfdcContact.Account.BillingCountry;
                rec.State = sfdcContact.Account.BillingState;
                rec.ZIP_Code = sfdcContact.Account.BillingPostalCode;
                rec.Job_Function = sfdcContact.Job_Function__c;
                rec.Title = sfdcContact.Title;
                rec.Contact_Inactive = sfdcContact.Contact_Inactive__c;
                oResponse.SFDCContacts.add(rec);
              selectedSFDCContact.put(rec.source_system_id, rec); 
            }        }
        maxSFDCConRecordsDisplayed = selectedSFDCContact.size();
        system.debug('+++++ Inside CDS Contacts');
        for(DataQualityUtil.CDSContactInfo rec: oResponse.CDSContacts)
        {
            // 20181231 - Jason Flippen - Added for Jira Story CRM-17978.
            // We don't want to show Contacts in the CDS List if they're
            // already being displayed in the Salesforce List.
            if (!selectedSFDCContact.containsKey(rec.source_system_id))
             {
              selectedCDSContact.put(rec.source_system_id, rec); 
            }
        }
        
        maxCDSConRecordsDisplayed = selectedCDSContact.size();
        
       }
        
    }
    
    //Button to goto Account selection Page on click of Next button
    public PageReference goToAccountSelection(){
        //Hide the Contact section and display account section
        displayContact = false;
        displayAccount = true;
        displayOpportunity = false;
        try{
            getAccountSelection();
        }catch(Exception e){
            system.debug('+++ Exception is '+ e.getStackTraceString());
            system.debug('+++ Exception is '+ e.getLineNumber());
            bError = true;
            ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
        
        return null;
    }
    
    public PageReference cancelOperation(){
        PageReference ref = new PageReference('/'+leadId);
        ref.setRedirect(true);
        return ref;
        //return leadSC.cancel();
    }
    
    //Button to goto Opportunity selection screen.
    public PageReference goToOptySelection()
    {
        system.debug('++ Inside goToOptySelection');
        displayContact = false;
        displayAccount = false;
        displayOpportunity = true;
        try
        {
            
            getOpportunityDetails(leadDetails);
        }catch(Exception e)
        {
            bError = true;
            ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
        system.debug('++ Exiting goToOptySelection');
        return null;
    }
    
    public PageReference optionSelected(){
        /*
        system.debug('+++ selectedContact is '+ selectedContact);
        system.debug('+++ selectedType is '+ selectedType);
        system.debug('+++ selectedCDSContactId is '+ selectedCDSContactId);
        system.debug('+++ selectedCDSType is '+ selectedCDSType);
        system.debug('+++ selectedAccount is '+ selectedAccountId);
        system.debug('+++ selectedAccountType is '+ selectedAccountType);
        system.debug('+++ selectedOpptyId is '+ selectedOpptyId);
        system.debug('+++ selectedOpptyType is '+ selectedOpptyType);
        */
        return null;
    }
    
    public void getAccountSelection(){
        system.debug('+++ Selected Type is '+ selectedType);
        system.debug('+++ Selected selectedContact is '+ selectedContact);
        if(selectedType == 'SFDCContact'){
            selectedContactName = selectedSFDCContact.get(selectedContact).first_name + ' ' + selectedSFDCContact.get(selectedContact).last_name;
            selectedContactEmail = selectedSFDCContact.get(selectedContact).Contact_Email;
            sfdcContact = selectedSFDCContact.get(selectedContact);
            //Added if conditin to avoid APEX CRUD VIOLATION Rule
            if(Schema.sObjectType.Contact.isQueryable()){
                accountSkipRecord = [select Id, AccountId, Account.name, Account.BillingStreet, Account.BillingCountry, Account.Operational_Ultimate_Parent_Name1__c from Contact where Id =: selectedContact limit 1];}
            
            if(accountSkipRecord!= null){
                selectedAccountId = accountSkipRecord.AccountId;
                selectedAccountType = 'SFDCAccount';
                selectedAccountName = accountSkipRecord.Account.Name;
                selectedAccountAddress = accountSkipRecord.Account.BillingStreet;
                displayOpportunity = true;
                displayContact = false;
                displayAccount = false;
                skipAccount = true;
                goToOptySelection();
            }
            
            
        }else if(selectedType == 'CDSContact')
        {
            system.debug('+_+++ selectedCDSContact '+ selectedCDSContact);
            selectedContactName = selectedCDSContact.get(selectedContact).first_name + ' ' + selectedCDSContact.get(selectedContact).last_name;
            selectedContactEmail = selectedCDSContact.get(selectedContact).Contact_Email;
            cdsContact = selectedCDSContact.get(selectedContact);
            system.debug('+++ cdsContact '+ cdsContact);
            skipAccount = false;

         //If Lead is associated with Account, then add the Account to the
        //top of SFDC Accounts
        if(leadDetails.Account__c != null)
        {
            DataQualityUtil.ECMAccountInfo existingAccountInfo1 = new DataQualityUtil.ECMAccountInfo();
            DataQualityUtil.existingAccountInfo1.Name = leadDetails.Account__r.NAme;
            DataQualityUtil.existingAccountInfo1.Street1 = leadDetails.Account__r.BillingStreet;
            DataQualityUtil.existingAccountInfo1.City = leadDetails.Account__r.BillingCity;
            DataQualityUtil.existingAccountInfo1.State = leadDetails.Account__r.BillingState;
            DataQualityUtil.existingAccountInfo1.PostalCode = leadDetails.Account__r.BillingPostalCode;
            DataQualityUtil.existingAccountInfo1.SourceSystemId = leadDetails.Account__c;
        }
            queryECMAccount('CDSContact');
        }else if(selectedType == 'NEWContact'){
            system.debug('+++ first name '+ newContactDetails);
            system.debug('+++ last name '+ newContactDetails.LastName);
            selectedContactName = newContactDetails.firstName + ' ' + newContactDetails.LastName;
            selectedContactEmail = newContactDetails.email;
            skipAccount=false;
            queryECMAccount('NEWContact');
        }
        system.debug('+++ displayOpportunity '+ displayOpportunity + ' displayContact '+ displayContact + ' displayAccount '+ displayAccount);
        system.debug('++ Exiting getAccountSelection');
        
    }
    
    //Method to query ECM Account
    public void queryECMAccount(String contactType){
        try{
            DataQualityUtil.CDSContactInfo cdsContactRec = new DataQualityUtil.CDSContactInfo();
            DataQualityUtil.ECMAccountInfo oECMAccountInfo = new DataQualityUtil.ECMAccountInfo();  

            List<Account> sfdcAccountList = new List<Account>();
            if(contactType == 'SFDCContact'){
                cdsContactRec = sfdcContact;
            }else if(contactType == 'CDSContact'){
                cdsContactRec = cdsContact;
                oECMAccountInfo.partyRowId = cdsContactRec.Party_ID;
            }else if(contactType == 'NEWContact'){
        // 20181231 - Jason Flippen - Added for Jira Story CRM-17978.
        if (Schema.sObjectType.Account.isAccessible()) {
                sfdcAccountList = [SELECT Id,
                                         Name,
                                         BillingStreet,
                      BillingCity,
                                         BillingState,
                                         BillingCountry,
                                         BillingPostalCode,
                                         ECM_Party_ID__c
                                   FROM   Account
                                   WHERE  Name = :newAccountDetails.accountName
                                   AND    BillingCity = :newAccountDetails.billingCity
                                   AND    BillingCountry = :newAccountDetails.billingCountry
                                   AND    BillingState = :newAccountDetails.billingState
                                   AND    Is_GLI__c = true
                                   ORDER BY ECM_Party_ID__c ASC NULLS LAST];
        
                oECMAccountInfo.Name = newAccountDetails.accountName;           
                oECMAccountInfo.City = newAccountDetails.billingCity;
                oECMAccountInfo.Country = newAccountDetails.billingCountry; 
                oECMAccountInfo.State = newAccountDetails.billingState;
                DataQualityUtil.manualAccountSearch = true;
            }
            system.debug('+++ cdsContactRec is '+ cdsContactRec);
            
            // test coverage condition
            oResponseAccount =  DataQualityUtil.MatchECMAccountsLC(new List<DataQualityUtil.ECMAccountInfo>{ oECMAccountInfo });
            
      // 20181112 - Jason Flippen - Added for Jira Story CRM-17978.
      oResponseAccount.SFDCAccounts.clear();
            if (!sfdcAccountList.isEmpty()) {
                for (Account sfdcAccount : sfdcAccountList) {
                    DataQualityUtil.ECMAccountInfo ecmRec = new DataQualityUtil.ECMAccountInfo();
                    ecmRec.SourceSystemId = sfdcAccount.Id;
                    ecmRec.Name = sfdcAccount.Name;
                    ecmRec.Street1 = sfdcAccount.BillingStreet;
                    ecmRec.City = sfdcAccount.BillingCity;
                    ecmRec.Country = sfdcAccount.BillingCountry;
                    ecmRec.State = sfdcAccount.BillingState;
                    ecmRec.PostalCode = sfdcAccount.BillingPostalCode;
          ecmRec.partyRowId = sfdcAccount.ECM_Party_ID__c;
                    oResponseAccount.SFDCAccounts.add(ecmRec);
                  selectedSFDCAccount.put(ecmRec.SourceSystemId, ecmRec);
                }
            }
           } 
/*
            for(DataQualityUtil.ECMAccountInfo ecmRec: oResponseAccount.SFDCAccounts) {
                selectedSFDCAccount.put(ecmRec.SourceSystemId, ecmRec);
            }
*/
            system.debug('++ selectedSFDCAccount '+ selectedSFDCAccount);
            maxSFDCAcctRecordsDisplayed = selectedSFDCAccount.size();

            for(DataQualityUtil.ECMAccountInfo ecmRec: oResponseAccount.ECMAccounts) {
                // 20181231 - Jason Flippen - Added for Jira Story CRM-17978.
                // We don't want to show Accounts in the ECM List if they're
                // already being displayed in the Salesforce List.
                if (!selectedSFDCAccount.containsKey(ecmRec.SourceSystemId)) {
                  selectedECMAccount.put(ecmRec.SourceSystemId, ecmRec);
                }
            } 
            system.debug('++ selectedECMAccount '+ selectedECMAccount);
            maxECMAcctRecordsDisplayed = selectedECMAccount.size();
            
        }catch(DataQualityUtil.AccountMatchingServiceException oException) {
            bError = true;
            system.debug('++++ Inside AccountMatchingServiceException');
            ApexPages.addMessages(oException);        }
        catch(Exception oException){
            bError = true;
            system.debug('++++ Inside Exception line no 454 LCRMConvertLeadController');
            ApexPages.addMessages(oException);
        }
        //}
    }
    
    
    
    //Search for Account
    public PageReference searchAccount(){
        try{
            
            boolean initiateSearch = true;
            sErrorMsg ='';
            if(newAccountSearchDetails.accountName == '')
            { 
             //sErrorMsg += '  '+mapAccountfields.get(sfield) ;
             sErrorMsg +=  '  '+ System.Label.Account_NameN; //Added custom label to aviod hard coding
                initiateSearch = false;
            }
            
            if(newAccountSearchDetails.country == null || newAccountSearchDetails.country == ''){
             sErrorMsg +=  '  '+ System.Label.Country;   //Added custom label to aviod hard coding
                initiateSearch= false;
            }
            
            if((newAccountSearchDetails.state == null || newAccountSearchDetails.state == '') && countryRegionSearchOptions.size() >1){
              sErrorMsg +=  '  '+ System.Label.State_Region; //Added custom label to aviod hard coding  
                initiateSearch = false;
            }
            sErrorMsg =sErrorMsg.trim();
            sErrorMsg =sErrorMsg.replace('  ',', ');
            if(!initiateSearch){
                ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR, Label.LCRM_Manual_Acc_Search + ' ' +sErrorMsg+'.');
                ApexPages.addMessage(msg);
                return null;
            }
            
                oResponseAccount = null;
            DataQualityUtil.manualAccountSearch = true;
            DataQualityUtil.ECMAccountInfo oECMAccountInfo = new DataQualityUtil.ECMAccountInfo();            
            oECMAccountInfo.Name = newAccountSearchDetails.accountName;            
            oECMAccountInfo.City = newAccountSearchDetails.city;
            oECMAccountInfo.Country = newAccountSearchDetails.country; 
            oECMAccountInfo.State = newAccountSearchDetails.state;         
            // test coverage condition
            
            oResponseAccount =  DataQualityUtil.MatchECMAccountsLC(new List<DataQualityUtil.ECMAccountInfo>{ oECMAccountInfo });
            selectedSFDCAccount.clear();
            selectedECMAccount.clear();
            DataQualityUtil.manualAccountSearch = false;
            
            // 20181231 - Jason Flippen - Added for Jira Story CRM-17978.
            String accountName = newAccountSearchDetails.accountName;
            String accountCity = newAccountSearchDetails.city;
            String accountCountry = newAccountSearchDetails.country;
            String accountState = newAccountSearchDetails.state;
         /*   String queryString = 'SELECT Id,' +
                         '     Name,' +
                         '     BillingStreet,' +
                         '     BillingCity,' +
                         '     BillingState,' +
                         '     BillingCountry,' +
                         '     BillingPostalCode,' +
                         '     ECM_Party_ID__c ' +
                         'FROM   Account ' +
                         'WHERE  Name = :accountName ' +
                         'AND    BillingCountry = :accountCountry ' +
                         'AND    BillingState = :accountState ' +
                 'AND    Is_GLI__c = true ';
            if (String.isNotBlank(newAccountSearchDetails.city)) {
                queryString += 'AND    BillingCity = :accountCity ';
            }
            queryString += 'ORDER BY ECM_Party_ID__c ASC NULLS LAST';
            
             List<Account> sfdcAccountList = Database.query(String.escapeSingleQuotes('queryString')); */
           //  Moved Dynamic SOQL to Static SOQL to fix PMD voilation issue as part of FSC-44
           List<Account> sfdcAccountList;
           
            if (String.isNotBlank(newAccountSearchDetails.city) && Schema.sObjectType.Account.isQueryable()) {
                sfdcAccountList = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ECM_Party_ID__c FROM   Account WHERE  Name = :accountName AND    BillingCountry = :accountCountry AND BillingState = :accountState AND   Is_GLI__c = true AND  BillingCity = :accountCity ORDER BY ECM_Party_ID__c ASC NULLS LAST];
            } else if(Schema.sObjectType.Account.isQueryable()) {
                sfdcAccountList = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ECM_Party_ID__c FROM   Account WHERE  Name = :accountName AND    BillingCountry = :accountCountry AND BillingState = :accountState AND    Is_GLI__c = true ORDER BY ECM_Party_ID__c ASC NULLS LAST];
            } 
           
      oResponseAccount.SFDCAccounts.clear();
            if (!sfdcAccountList.isEmpty()) {
                for (Account sfdcAccount : sfdcAccountList) {
                    DataQualityUtil.ECMAccountInfo ecmRec = new DataQualityUtil.ECMAccountInfo();
                    ecmRec.SourceSystemId = sfdcAccount.Id;
                    ecmRec.Name = sfdcAccount.Name;
                    ecmRec.Street1 = sfdcAccount.BillingStreet;
                    ecmRec.City = sfdcAccount.BillingCity;
                    ecmRec.Country = sfdcAccount.BillingCountry;
                    ecmRec.State = sfdcAccount.BillingState;
                    ecmRec.PostalCode = sfdcAccount.BillingPostalCode;
                    ecmRec.partyRowId = sfdcAccount.ECM_Party_ID__c;
                    oResponseAccount.SFDCAccounts.add(ecmRec);
                  selectedSFDCAccount.put(ecmRec.SourceSystemId, ecmRec);
                }
            }

/*
            for(DataQualityUtil.ECMAccountInfo ecmRec: oResponseAccount.SFDCAccounts) {
                selectedSFDCAccount.put(ecmRec.SourceSystemId, ecmRec);
            }
*/
            
            maxSFDCAcctRecordsDisplayed = selectedSFDCAccount.size();
            
            for(DataQualityUtil.ECMAccountInfo ecmRec: oResponseAccount.ECMAccounts) {
                // 20181231 - Jason Flippen - Added for Jira Story CRM-17978.
                // We don't want to show Accounts in the ECM List if they're
                // already being displayed in the Salesforce List.
                if (!selectedSFDCAccount.containsKey(ecmRec.SourceSystemId)) {
                  selectedECMAccount.put(ecmRec.SourceSystemId, ecmRec);       }
            }
            maxECMAcctRecordsDisplayed = selectedECMAccount.size();
      
        }catch(DataQualityUtil.AccountMatchingServiceException oException) {
            bError = true;
            ApexPages.addMessages(oException);
        }
        catch(Exception oException){
            bError = true;
            ApexPages.addMessages(oException);        }
        return null;
    }
    
    public void getOpportunityDetails(Lead oLead){
        
        system.debug('+++ selectedAccountId  is '+ selectedAccountId);
        system.debug('+++ selectedAccountType is '+ selectedAccountType);
        
        if(selectedAccountType == 'SFDCAccount'){
            if(!skipAccount){
                system.debug('+++ inside account details NOT SKIP');
                selectedAccountName = selectedSFDCAccount.get(selectedAccountId).Name;
                selectedAccountAddress = selectedSFDCAccount.get(selectedAccountId).Street1;//added just street.
                sfdcAccount = selectedSFDCAccount.get(selectedAccountId);
            }
            
            system.debug('*** sfdcAccount ***' + sfdcAccount);
            //queryECMAccount('SFDCContact');
        }else if(selectedAccountType == 'ECMAccount'){
            selectedAccountName = selectedECMAccount.get(selectedAccountId).Name;
            selectedAccountAddress = selectedECMAccount.get(selectedAccountId).Street1;//added just street.
            ecmAccount = selectedECMAccount.get(selectedAccountId);
            system.debug('*** ecmAccount ***' + ecmAccount);
            //queryECMAccount('CDSContact');
        }else if(selectedAccountType == 'NewAccount'){
            selectedAccountName = newAccountDetails.accountName;
            selectedAccountAddress = newAccountDetails.billingStreet;//added just street.
        }
        
        system.debug('*** selectedAccountName ***' + selectedAccountName);
        system.debug('*** selectedAccountAddress ***' + selectedAccountAddress);
        
        leadOpportunityOptions = getOpportunityOptions(leadDetails);
        
        //formulate pagination string
        
    }
    
    public List<OpportunityOption> getOpportunityOptions(Lead oLead){
        system.debug('+++ inside getOpportunityOptions');
        List<OpportunityOption> opportunityOptions = new List<OpportunityOption>();
        
        List<Opportunity> opportunityQueryResult = queryOpptyByLead(oLead);
        for (Opportunity opptyRec : opportunityQueryResult) {
            OpportunityOption opptyOption = new OpportunityOption(opptyRec);
            opportunityOptions.add(opptyOption);
        }
        
        //Salesforce Oppty details
        return opportunityOptions; 
    }
    
    public List<Opportunity> queryOpptyByLead(Lead oLead){
        system.debug('++ inside queryOpptyByLead');
        String gupId = '';
        String accountId = '';
        String accountBillingCountry = '';
        String contactId = '';
        
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        
        if(onlyOpportunity){
            system.debug('+++ inside onlyOpportunity');
            
            if(String.isNotBlank(oLead.Contact__r.AccountId)){
                accountId = oLead.Contact__r.AccountId;
            }
            
            if(String.isNotBlank(oLead.Contact__r.Account.BillingCountry)){
                accountBillingCountry = oLead.Contact__r.Account.BillingCountry;
            }
            
            if(String.isNotBlank(oLead.Contact__c)){
                contactId = oLead.Contact__c;
            }
            
            
            if(String.isNotBlank(oLead.Contact__r.Account.Operational_Ultimate_Parent_Name1__c)){
                gupId = oLead.Contact__r.Account.Operational_Ultimate_Parent_Name1__c;
            }
        }
        else if(selectedAccountType == 'SFDCAccount'){
            system.debug('+++ inside selectedAccountType == sfdcaccount check');
            
            accountId = selectedAccountId;
            
            if(!skipAccount){
                system.debug('^^^^^^^^ SKIP ACCOUNT FALSE');
                 Account oAccount = new Account();
                //Query account to get the GUP ID && Added a condition to avoid APEX CRUD Violation Rule 
                if(Schema.sObjectType.Account.isQueryable()){
                    oAccount = [select id, BillingCountry, Operational_Ultimate_Parent_Name1__c  from Account  where id = :accountId];}
                
                
                //Comment the below query and uncomment the above one.
                /*Account oAccount = [select id, Billing_Country__c, Operational_Ultimate_Parent_ECM_Party_ID__c 
from Account 
where id = '001S000000pexBg'];
*/
                
                if(String.isNotBlank( oAccount.Operational_Ultimate_Parent_Name1__c)){
                    gupId = oAccount.Operational_Ultimate_Parent_Name1__c;}
                
                if(String.isNotBlank(oAccount.BillingCountry)){
                    accountBillingCountry = oAccount.BillingCountry;}
            }else{
                accountId = accountSkipRecord.AccountId;
                
                system.debug('^^^^^^^^ SKIP ACCOUNT TRUE : ' + accountId);
                if(String.isNotBlank( accountSkipRecord.Account.Operational_Ultimate_Parent_Name1__c )){
                    gupId = accountSkipRecord.Account.Operational_Ultimate_Parent_Name1__c;
                }
                
                if(String.isNotBlank(accountSkipRecord.Account.BillingCountry)){
                    accountBillingCountry = accountSkipRecord.Account.BillingCountry;
                }
            }
            
            
            //get Contact Id based on contact selection screen, get only if its an sfdc contact
            system.debug('++ contact selectedType ' + selectedType);
            system.debug('++ sfdcContact.Source_System_ID ' + sfdcContact.Source_System_ID);
            if(selectedType == 'SFDCContact')
            {
                contactId = sfdcContact.Source_System_ID;
                system.debug('++ contact contactId ' + contactId);
            }
            
            
        }
        
        Date closeDate = system.today().addDays(-365);
        system.debug('*** close Date ***' + closeDate);
        
        //the below query will be made based on the Account GUP ID if there is an selected account
        //otherwise this query will not be fired
        if(string.isnotblank(accountId))
        {
            system.debug('GUP ID is '+ gupId);
            String strQuery = '';
            strQuery = 'select id, name, StageName, Owner.name, OwnerId,Created_by_Role__c,CloseDate,';
            strQuery += 'Total_Incremental__c,Total_Renewal__c,LCRM_Total_New_ACV_Sales_Price__c,Renewal_Flag__c,createdDate,Status__c, Account.Name,';
            strQuery += 'City_State__c, Billing_City__c, AccountId, Key_Contact__c, Account.BillingCountry,';
            strQuery += '(SELECT ContactId,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRoles),';
            strQuery += '(select id, UserId, OpportunityId, OpportunityAccessLevel, TeamMemberRole from OpportunityTeamMembers)';
            strQuery += ' From Opportunity';
            strQuery += ' Where is_GLI__c = true AND';
            if(oLead.LCRM_Sub_BU__c == 'Elite' || oLead.LCRM_Sub_BU__c == 'UKI')
            {
                strQuery += ' Renewal_Flag__c = false AND';
            }
            strQuery += ' StageName NOT IN (\'Order Complete\',\'Closed Lost\') AND';
            strQuery += ' CloseDate > :closeDate AND';
            if(string.isNotBlank(gupId)){
                strQuery += ' (Account.Operational_Ultimate_Parent_Name1__c = :gupId OR AccountId = :gupId)';
            }else{
                strQuery += ' AccountId = :accountId';}
            
            system.debug('++ query ++' + strQuery );
            
            lstOpportunity = Database.query(strQuery);
            
            if(lstOpportunity != null && lstOpportunity.size() > 0)
            {
                system.debug('++++ before calling performOpportunityRanking');
                lstOpportunity = performOpportunityRanking(lstOpportunity, oLead, accountId, contactId, accountBillingCountry);
            }
        }
        return lstOpportunity;
    }
    
    public List<Opportunity> performOpportunityRanking(List<Opportunity> lstOpportunity, Lead oLead, String accountId, String contactId, String accountBillingCountry)
    {
        
        Map<Opportunity, Integer> mapOpportunityAndScore = new Map<Opportunity, Integer>();
        
        Boolean isAccountAssociated = false;
        Boolean isContactPresentInContactRole = false;
        Boolean isLeadPresentInOpptyTeam = false;
        Boolean isCountryMatches = false;
        Boolean isValidOpportunity = false;
        
        Map<String, LCRM_Opportunity_Ranking_Configuration__c> mapRankingConfig = LCRM_Opportunity_Ranking_Configuration__c.getAll();
        
        if(mapRankingConfig.containsKey('Account Associated to Opportunity')){
            accountAssociatedToOpp = Integer.ValueOf(mapRankingConfig.get('Account Associated to Opportunity').Score__c);}
        
        if(mapRankingConfig.containsKey('Contact Exist In Contact Role')){
            contactExistInContactRole = Integer.ValueOf(mapRankingConfig.get('Contact Exist In Contact Role').Score__c);}
        
        if(mapRankingConfig.containsKey('Country Matches')){
            countryMatches = Integer.ValueOf(mapRankingConfig.get('Country Matches').Score__c);}
        
        if(!uslUser && mapRankingConfig.containsKey('Lead Owner exist in opportunity team')){
            leadOwnerExistInOppTeam = Integer.ValueOf(mapRankingConfig.get('Lead Owner exist in opportunity team').Score__c);}
        
        system.debug('++accountAssociatedToOpp ++' + accountAssociatedToOpp);
        system.debug('++contactExistInContactRole ++' + contactExistInContactRole);
        system.debug('++countryMatches ++' + countryMatches);
        system.debug('++leadOwnerExistInOppTeam ++' + leadOwnerExistInOppTeam);
        
        Integer score = 0;
        
        for(Opportunity oOppty: lstOpportunity)
        {
            isAccountAssociated = false;
            isContactPresentInContactRole = false;
            isLeadPresentInOpptyTeam = false;
            isCountryMatches = false;
            isValidOpportunity = false;
            
            List<OpportunityTeamMember> lstOpptyTeamMember = oOppty.OpportunityTeamMembers;
            
            //Filter out Opportunities that needs to be used for displaying on screen
            if(!uslUser && !ukiOrEliteUser && oLead.OwnerId == oOppty.OwnerId)
            { isValidOpportunity = true;     }
            if(uslUser || ukiOrEliteUser)
            {
                isValidOpportunity = true;
            }
            
            for(OpportunityTeamMember oTeamMember : lstOpptyTeamMember)
            {
                if(!uslUser && oTeamMember.UserId == oLead.OwnerId)
                {
                    //Lead Owner match
                    system.debug('++ lstOpptyTeamMember ++' + lstOpptyTeamMember);
                    system.debug('++ oLead.OwnerId  ++' + oLead.OwnerId);
                    isLeadPresentInOpptyTeam = true;
                    if(oTeamMember.OpportunityAccessLevel == 'Edit' || oTeamMember.OpportunityAccessLevel =='All' ){
                        isValidOpportunity = true;
                    }
                    break;
                }
            }
            if(!isValidOpportunity){
                continue;}
            
            //account match
            if(String.isNotBlank(accountId)){
                system.debug('++accountId ++' + accountId);
                system.debug('++oOppty.AccountId ++' + oOppty.AccountId);
                if(oOppty.AccountId == accountId)
                {
                    isAccountAssociated = true;
                }
            }
            
            //Country match
            system.debug('++accountBillingCountry ++' + accountBillingCountry);
            system.debug('++oOppty.Account.BillingCountry ++' + oOppty.Account.BillingCountry);
            
            if(String.isNotBlank(accountBillingCountry)){
                if(oOppty.Account.BillingCountry == accountBillingCountry)
                {
                    isCountryMatches = true;
                }
            }
            //Contact Role Match
            List<OpportunityContactRole> lstOpptyContactRole = oOppty.OpportunityContactRoles;
            system.debug('++ lstOpptyContactRole ++' + lstOpptyContactRole);
            system.debug('++ contactId - Oppty Role ++' + contactId);
            
            for(OpportunityContactRole oContactRole : lstOpptyContactRole)
            {
                if(String.isNotBlank(contactId)){
                    system.debug('++ inside contact role check');
                    if(oContactRole.ContactId == contactId)
                    {
                        system.debug('++ contact role matched');
                        isContactPresentInContactRole = true;
                        break;
                    }
                }
            }
            
            
            
            score = 0;
            if(isAccountAssociated)
            {
                
                score += accountAssociatedToOpp;
                system.debug('++ isAccountAssociated ++');
                system.debug('++ score after isAccountAssociated ++' + score);
                
            }
            
            if(isContactPresentInContactRole)
            {
                score += contactExistInContactRole ;
                system.debug('++ isContactPresentInContactRole ++');
                system.debug('++ score after isContactPresentInContactRole ++' + score);
                
            }
            
            if(isLeadPresentInOpptyTeam)
            {
                score += leadOwnerExistInOppTeam ;
                system.debug('++ isLeadPresentInOpptyTeam ++');
                system.debug('++ score after isLeadPresentInOpptyTeam ++' + score);
                
            }
            
            if(isCountryMatches)
            {
                score += countryMatches;
                system.debug('++ isCountryMatches ++');
                system.debug('++ score after isCountryMatches ++' + score);
                
            }
            
            mapOpportunityAndScore.put(oOppty, score);
        }
        
        system.debug('**** mapOpportunityAndScore ****' + mapOpportunityAndScore );
        
        
        List<Opportunity> lstSortedOpportunity = new List<Opportunity>();
        Map<Integer, List<Opportunity>> mapScoreAndOpptyList = new Map<Integer, List<Opportunity>>();
        
        Integer fetchScored = 0;
        List<Opportunity> lstOpportunityTemp;
        for(Opportunity oOppty: mapOpportunityAndScore.keySet())
        {
            fetchScored = mapOpportunityAndScore.get(oOppty);
            
            if(mapScoreAndOpptyList.containsKey(fetchScored))    {
                lstOpportunityTemp = mapScoreAndOpptyList.get(fetchScored);
                lstOpportunityTemp.add(oOppty);
                mapScoreAndOpptyList.put(fetchScored, lstOpportunityTemp);    }
            else
            {
                lstOpportunityTemp = new List<Opportunity>();
                lstOpportunityTemp.add(oOppty);
                mapScoreAndOpptyList.put(fetchScored, lstOpportunityTemp);
            }
        }
        
        system.debug('*** mapScoreAndOpptyList ***' + mapScoreAndOpptyList);
        
        List<Integer> setSortedOpportunityScore = new List<Integer>();
        setSortedOpportunityScore.addAll(mapScoreAndOpptyList.keyset());
        setSortedOpportunityScore.sort();
        
        
        for(Integer scoreValue: setSortedOpportunityScore )
        {
            lstSortedOpportunity.addAll(mapScoreAndOpptyList.get(scoreValue));
        }
        
        system.debug('*** lstSortedOpportunity in Ascending order ***' + lstSortedOpportunity);
        
        //Reverse the list to sort in descending order
        List<Opportunity> lstFinalRankedOpportunity = new List<Opportunity>();
        for(integer i=lstSortedOpportunity.size() - 1; i >= 0; i--)
        {
            lstFinalRankedOpportunity.add(lstSortedOpportunity.get(i));
            //create map of opportunity to be used later for retrieving which opportunity has been selected
            selectedSFDCOppty.put(lstSortedOpportunity.get(i).Id, lstSortedOpportunity.get(i));
        }
        
        system.debug('*** lstSortedOpportunity in descending order ***' + lstFinalRankedOpportunity);
        
        maxOpptyRecordsRetrieved = lstFinalRankedOpportunity.size();
        
        //Return only top 30, if no. of records is greater than 30
        KeyValueListStore__c opptyCountConfig = KeyValueListStore__c.getInstance('LCRMMax Oppty Count');
        Integer maxOpptyCountAllowed = Integer.ValueOf(opptyCountConfig.TextValue__c); 
        
        if(lstFinalRankedOpportunity != null && lstFinalRankedOpportunity.size()>maxOpptyCountAllowed )
        {
            List<Opportunity> lstTempOpportunity = new List<Opportunity>();
            for(integer i=0; i < maxOpptyCountAllowed; i++)      {
                lstTempOpportunity.add(lstFinalRankedOpportunity.get(i));       }
            lstFinalRankedOpportunity = lstTempOpportunity;        }
        
        maxOpptyRecordsDisplayed = lstFinalRankedOpportunity.size();
        
        return lstFinalRankedOpportunity;
    }
    
    
    public PageReference convertLead(){
        restrictTMSFunc = false;
        lcrmConvertLeadFlag = false; //Added for CRM-17836
        System.debug('+++selectedOpptyType+++ -->'+selectedOpptyType);
        
        if(String.isBlank(selectedOpptyType))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Lead_Convert_Opportunity_Selection_Error));
            return null;
        }
        
        
        if(selectedOpptyType == 'SFDCOppty')
        {
            selectedOppty = selectedSFDCOppty.get(selectedOpptyId);
            selectedOppOwnerId = selectedOppty.OwnerId;
        }
        
        try {
            createLeadHistory(); 
            fetchLeadActivities();  //Added for CRM-17825
            
            Database.LeadConvertResult leadConvertResult = null;
            try{
                leadConvertResult = this.executeLeadConversion();
                System.debug('leadConvertResult **'+leadConvertResult );
            }catch (Exception oException) {
                System.debug('oException StackTrace: '+oException.getStacktraceString());
                System.debug('oException Message: '+oException.getMEssage());
                System.debug('oException getTypeName: '+oException.getTypeName());
                System.debug('oException getLineNumber: '+oException.getLineNumber());
                bError = true;
                if(oException.getMEssage().contains('INACTIVE_OWNER_OR_USER')){
                    String userId = (oException.getMEssage().split('User Id').size()>=2)?oException.getMEssage().split('User Id')[1]:'';
            //Added Custom labels in the ApexPages.addMessage to avoid Hard Coding 
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'<b>' +System.label.ConvertLead_failed +'</b>.'+System.Label.INACTIVE_OWNER_OR_USER +((userId!=null && userId!='')? +System.Label.User_Id +userId:' ')+'.' +System.Label.Please_save_with_Active_Owers +'.'));
                }else{
                System.debug('oException.getMEssage()**'+oException.getMEssage());
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,oException.getMEssage()));
                }
                //Added a condition to avoid APEX CRUD Violation Rule 
                if(lHistoryMap.Values() != null && lHistoryMap.Values().size() > 0 && Schema.sObjectType.LM_Lead_History__c.isDeletable()){
                    try{
                        List<LM_Lead_History__c> delHist = lHistoryMap.values();
                        delete delHist;
                        lHistoryMap.clear();
                    }catch(Exception e){
                System.debug('+++ Exception StackTrace: '+e.getStacktraceString());
                System.debug('+++ Exception Message: '+e.getMEssage());
                System.debug('+++ Exception getTypeName: '+e.getTypeName());
                System.debug('+++ Exception getLineNumber: '+e.getLineNumber());

                    }
                }
            }
            
            if (leadConvertResult != null && leadConvertResult.isSuccess() == true) { 
                convertedAccountId = leadConvertResult.getAccountId();
                convertedContactId = leadConvertResult.getContactId();
                convertedOpptyId = leadConvertResult.getOpportunityId();
                //DLT-10237 - CXD-ODT - creates Accountssd,asset,contactentitlement
                if(Leaddetails.Is_Trial_Lead__c){
                 LeadConvDetail.getLeadProdDetails(leadids); 
                }
                
                //Create LM Lead History
                createLeadHistory();
               
                //Create Contact Role;
                if(selectedOpptyType == 'SFDCOppty')
                {
                    createContactRole();
                    updateOppTeamMembers(selectedOpptyId);
                    createLeadTasksUnderOpp(selectedOpptyId,convertedContactId); //Added for  CRM-17825
                    createLeadEventsUnderOpp(selectedOpptyId,convertedContactId);//Added for  CRM-17825
                }
                //--------DPS-3112-------------------
              
                 if(convertedAccountId!= null)
                {
                     system.debug('@@@convertedAccountId@@@' +convertedAccountId);
                     addAccountTeamMember(convertedAccountId);
                     
                     if(String.isnotblank(convertedOpptyId)){
                     System.debug('@convertedOpptyId**'+convertedOpptyId);
                     updateOppTeamMembers(convertedOpptyId);
                     }
                 
                } //-------DPS-3112 Ends-------------
                //Updated for R4
                System.debug('+++LCRMGenericComponent.isLotusUser()+++-->'+LCRMGenericComponent.isLotusUser());
                System.debug('+++uslUser+++-->'+uslUser);
                System.debug('+++convertedOpptyId1+++-->'+convertedOpptyId + ' :: ' +String.isNotBlank(convertedOpptyId));
                System.debug('+++Selected update OpptyID+++-->'+selectedOppty);
                if(!uslUser && (convertedOpptyId != null && convertedOpptyId !='')){
				    UpdateOpportunityfields(convertedOpptyId);
                }
                //Start : Added for R4
                if(String.isNotBlank(convertedOpptyId) && uslUser ){
                    System.debug('+++convertedOpptyId1+++-->'+convertedOpptyId);
                    UpdateOpportunityfields(convertedOpptyId);
                } 
                else if(selectedOpptyType == 'SFDCOppty' && ( LCRMGenericComponent.isLotusUser() || uslUser || ukiOrEliteUser)) {
                    UpdateOpportunityfields(selectedOpptyId);
                }
                //End : Added for R4
         //Start:Added for CRM-12851 && Added a condition to avoid APEX CRUD Violation Rule 
                if(subBu == 'USL' && Schema.sObjectType.LCRM_Recommended_Product__c.isQueryable()){
                    listRecommendProd = [Select Id,Name,LCRM_Product_Name__c,LCRM_Quantity__c,LCRM_List_Price__c,LCRM_Lead_Name__c,LCRM_Product_Category__c from LCRM_Recommended_Product__c where LCRM_Lead_Name__c = :leadId and LCRM_Identified_for_Opportunity_Product__c = true];
                    //if(listRecommendProd.size()>0){
                        if(listRecommendProd.size()>0 && String.isNotBlank(convertedOpptyId)){
                            addOptyProduct(convertedOpptyId,listRecommendProd);
                        }
                     if(listRecommendProd.size()>0 && selectedOpptyType == 'SFDCOppty'){
                         System.debug('selectedOpptyId:-'+selectedOpptyId);
                            addOptyProduct(selectedOpptyId,listRecommendProd);
                //}
                    }
                }
                
        //End:Added for CRM-12851
        //DPS-2516: Updated convertLead function so that convertLead function execution redirects the page to Newly created contact if the user is in lightning.        
                system.debug('+++++ Before page reference ');
                PageReference pageReference;
                // If the user is using Lightning Interface then redirect the user to Converted Contact
                if(UserInfo.getUiThemeDisplayed() == 'Theme4d'){
                pageReference = new PageReference('/'+convertedContactId);
                } else{
                    pageReference = new PageReference('/'+leadId);
                }
                pageReference.setRedirect(true);
                system.debug('+++++ Before return reference ');
                return pageReference;

            }
            return null;
        }        catch(Exception ex){
            bError = true;
            System.debug('ex.getMessage()**'+ex.getMessage());
            ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            return null;
        }
    }
    //Start:Added for CRM-12851
    private void addOptyProduct(Id oppId,List<LCRM_Recommended_Product__c> listRecommendProd){
            List<OpportunityLineItem> addOLIList = new List<OpportunityLineItem>();
            Opportunity oOpp = new Opportunity();
            try{
        //Added if condition to avoid APEX CRUD Violation Rule 
                if(Schema.sObjectType.Opportunity.isQueryable()){
                    oOpp = [SELECT Pricebook2Id,CurrencyIsoCode  FROM Opportunity where id = :oppId];}
            System.debug('oOpp.Pricebook2Id-->'+oOpp.Pricebook2Id);
            if(oOpp.Pricebook2Id == null){
               System.debug('addOptyPricebook**');
                  Map<String, String> pbsubBuMap = new  Map<String, String>();
                List<LCRMPriceBooksMapping__c> pblist = LCRMPriceBooksMapping__c.getall().values();
                for(LCRMPriceBooksMapping__c pb :pblist){
                    pbsubBuMap.put(pb.Sub_Bu__c,pb.Pricebook__c);
                }
                if(pbsubBuMap.containsKey(subBu)){
                    oOpp.Pricebook2Id = [SELECT Id FROM Pricebook2 WHERE Name = :pbsubBuMap.get(subBu)].Id;
              }   
              System.debug('updateoppty');
          //Added if condition to aviod APEX CRUD VIOLATION Rule for UPDATE Operation
                if(Schema.sObjectType.Opportunity.isUpdateable()){
                    update oOpp;}
            } 
            System.debug('afterupdate**');
            Id pricebookId = oOpp.Pricebook2Id;
            String currencyCode = oOpp.CurrencyIsoCode ;
            System.debug('Pricebook2Id-->'+pricebookId);
            System.debug('inside addOptyProduct****');
            System.debug('listRecommendProd2-->'+listRecommendProd);
            Set<id> productid = new Set<Id>();
             for(LCRM_Recommended_Product__c rp : listRecommendProd ){
                 productid.add(rp.LCRM_Product_Name__c);
             }
              List<PricebookEntry> pbentrylist = new List<PricebookEntry>(); 
         //Added if condition to avoid APEX CRUD VIOLATIN Rule
                if(Schema.sObjectType.PricebookEntry.isQueryable()){
                    pbentrylist = [SELECT Id,Product2Id FROM PricebookEntry WHERE Product2Id IN :productid and Pricebook2Id = :pricebookId and CurrencyIsoCode = :currencyCode];}
             System.debug('pbentrylist-->'+pbentrylist);
             Map<Id,Id> pricebookProductMap = new Map<Id,Id>();
             for(PricebookEntry pe :pbentrylist){
                 pricebookProductMap.put(pe.Product2Id,pe.id);
             }
             System.debug('pricebookProductMap-->'+pricebookProductMap); 
             for(LCRM_Recommended_Product__c rp : listRecommendProd ){
                   OpportunityLineItem oli = new OpportunityLineItem();
                    oli.OpportunityId = oppId;
                    //oli.LCRM_Action__c = 'New';
                    oli.LCRM_Units__c = rp.LCRM_Quantity__c;
                    oli.List_Price__c = rp.LCRM_List_Price__c;
                    System.debug('rp.LCRM_Product_Name__c-->'+rp.LCRM_Product_Name__c);
                   
                        System.debug('oli.PricebookEntryId-->'+oli.PricebookEntryId);
                    if(pricebookProductMap.containsKey(rp.LCRM_Product_Name__c)){
                        oli.PricebookEntryId= pricebookProductMap.get(rp.LCRM_Product_Name__c);
                        System.debug('oli.PricebookEntryId-->'+oli.PricebookEntryId);
                        
                    } 
                        addOLIList.add(oli);
             
              }
              
                System.debug('addOLI-->'+addOLIList.size());
                if(addOLIList.size()>0){
                     Database.SaveResult[] results = Database.insert(addOLIList,false);
                     System.debug('Result-->'+results );
                     System.debug('Result-->'+results.size() );
                     
            }}catch(Exception ex){
                 system.debug('*** AddProductError:: '+ex.getMEssage());
                 bError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage()));          }
    }
     //End:Added for CRM-12851    
         
    //-----------DPS-3112-New method created as a part of Partner Community to add user to Account Team Members ---------------//
   
    public void addAccountTeamMember(Id accId){
        
            system.debug('@@@Inside accountTeam Method@@@' );
            Id leadId  = ApexPages.CurrentPage().getparameters().get('id');
            Lead leadDetails = new Lead();
            boolean partneruser = LCRMGenericComponent.isLotusUser();
            //Added a check to verify if user has Query access on Lead Object to avoid APEX CRUD Violatin 
        if(Schema.sObjectType.lead.isQueryable() && Schema.sObjectType.lead.isAccessible()){
            leadDetails = [select id, Description,Phone,Email,FirstName,LastName,Status,Convert_by__c,Accept_by__c,LastModifiedBy.Name,CreatedBy.Name,
                           owner.name,LeadSource, Job_Function__c, title, Type__c,Name,Is_GLI__c from lead where Id =: leadId]; }
                               
            List<AccountTeamMember> listAccteam = new List<AccountTeamMember>();
            if(partneruser ==true && accId!=null && leadDetails.CreatedBy.Id !=null)    {
                system.debug('@@@Lead createdBy Id@@@' +leadDetails.CreatedBy.Id);
                system.debug('@@@Inside Selected Account to add AccTeamMem @@@' +selectedAccountId);
                AccountTeamMember atm = new AccountTeamMember(accountId=accId,userId = leadDetails.CreatedBy.Id,TeamMemberRole = 'Partner',AccountAccesslevel ='Read');
                listAccteam.add(atm);
                if(Schema.sObjectType.AccountTeamMember.isCreateable()){
                    insert listAccteam;}
                system.debug('@@@AccountTeamMemberList@@@' +listAccteam);
            }
            
           
    }
     //---DPS-3112 Ends---------
     ////Updated for CRM-6328 & CRM-6332
    private void updateOpportunityfields(Id oppId){
    
            System.debug('+++Inside updateOpportunityfields+++ ');
            Opportunity oOpportunity;
            //Start : Added for R4
            if(uslUser && Schema.sObjectType.Opportunity.isQueryable()){//Added a condition to avoid APEX CRUD Violation
            oOpportunity = [Select Id,CampaignId,Description from Opportunity where Id = :oppId ];
            system.debug('*****oOpportunity *****'+oOpportunity );
                if(leadDetails.primary_campaign_source__c != null){ //DPS-18633
                oOpportunity.CampaignId = leadDetails.primary_campaign_source__c;}
            oOpportunity.Source__c = leadDetails.LeadSource;
                //oOpportunity.Is_Marketing__c = leadDetails.Is_Marketing__c; // Is_Marketing__c to flow from lead
            if(String.isNotBlank(oOpportunity.Description) && String.isNotBlank(leadDetails.Description)){
        //Added Custom label 'From_Converted_Lead' to avoid Hard coding values
                    oOpportunity.Description = oOpportunity.Description+' " ' + System.Label.From_Converted_Lead +': '+leadDetails.Description+'"';
                } else if(String.isBlank(oOpportunity.Description)){
            oOpportunity.Description = leadDetails.Description;
                    }
            
            } 
            //End : Added for R4
            else {
            oOpportunity = new Opportunity(id=oppId);
            if(leadDetails.primary_campaign_source__c != null){ //DPS-18633
                oOpportunity.CampaignId = leadDetails.primary_campaign_source__c;}
            oOpportunity.Source__c = leadDetails.LeadSource;
               system.debug('*****oOpportunity *****'+oOpportunity ); 
              //oOpportunity.Is_Marketing__c = leadDetails.Is_Marketing__c; // Is_Marketing__c to flow from lead
            }
             
           try{
       //  //Added a condition to avoid APEX CRUD violation Rule before UPDATE Operation
               if(Schema.sObjectType.Opportunity.isUpdateable()){
                update oOpportunity;}
           }catch(DMLException dmlEx){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
           }
    
    }
    
    
    
    private Database.LeadConvertResult executeLeadConversion() {
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        
        Account oNewAccount = null;
        Contact oNewContact = null;
        Boolean bNewAccountToBeCreated = false;
        //system.debug('****Selected Account,Contact and Opportunity' + selectedAccount + ':' + primaryContactId  + ':' + SelectedoppId );
        //system.debug('resetLeadFields : selectedAccount : '+selectedAccount);
        
        leadConvert.setLeadId(leadId);
        
        if(onlyOpportunity)
        {
            
            //Change the below statement to get Account ID from Contact instead of LEAD
            leadConvert.setAccountId(leadDetails.Contact__r.AccountId); 
            leadConvert.setContactId(leadDetails.Contact__c);
        }
        else
        {
            //Create a new account if required
            if(selectedAccountType == 'SFDCAccount')
            {
                leadConvert.setAccountId(selectedAccountId);
                bNewAccountToBeCreated = false;
            }
            else if(selectedAccountType == 'ECMAccount'){
                bNewAccountToBeCreated = true;
                oNewAccount = createNewAccount(ecmAccount, null);
                leadConvert.setAccountId(oNewAccount.Id);
                
            }
            else if(selectedAccountType == 'NewAccount'){
                bNewAccountToBeCreated = true;
                oNewAccount = createNewAccount(null, newAccountDetails);
                leadConvert.setAccountId(oNewAccount.Id);
                
                
            }
        
            //Create a new contact if required
            if(selectedType == 'SFDCContact')
            {
                leadConvert.setContactId(selectedContact);
            }else if(selectedType == 'CDSContact'){
                system.debug('******** Inside CDSContact');
                if(bNewAccountToBeCreated){
                    system.debug('++++ CDSContact IF Check '+ bNewAccountToBeCreated + ' and Account id is '+ oNewAccount.Id);
                    oNewContact = createNewContact(cdsContact, null, oNewAccount.Id);
                }
                else{
                    system.debug('++++ CDSContact ELSE Check  and Account id is '+ selectedAccountId);
                    oNewContact = createNewContact(cdsContact, null, selectedAccountId);
                }
                
                //leadConvert.setContactId(leadDetails.Contact__c);
                leadConvert.setContactId(oNewContact.Id);
            }
            else if(selectedType == 'NEWContact'){
                system.debug('******** Inside NEWContact');
                
                if(bNewAccountToBeCreated){
                    oNewContact = createNewContact(null, newContactDetails, oNewAccount.Id);
                }else{
                    oNewContact = createNewContact(null, newContactDetails, selectedAccountId);}
                
                leadConvert.setContactId(oNewContact.Id);
            }
        }
        
        leadConvert.setConvertedStatus(convertedStatusLabel);
        
        system.debug('**** convertedStatusLabel ****' + convertedStatusLabel);
        
        
        if(selectedOpptyType == 'SFDCOppty' || selectedOpptyType == 'NoOppty')
        {
            leadConvert.setDoNotCreateOpportunity(true);
        }
        else
        {
            String accName = leadDetails.Company;
            if(String.isnotBlank(selectedAccountName)){
                accName = selectedAccountName; }
            
            leadDetails.Company = accName;
          //Added if condition to avoid APEX CRUD violation Rule before UPDATE Operation
            if(Schema.sObjectType.Lead.isUpdateable()){
                update leadDetails;}
            
            leadConvert.setOpportunityName(accName + ' - Oppty');
        }
        
        if(selectedOpptyType == 'SFDCOppty')
        {
            if(!String.valueOf(leadDetails.OwnerID).startsWith(userObjPrefix)){
                leadConvert.setOwnerId(UserInfo.getUserId());
            }else{
                leadConvert.setOwnerId(selectedOppOwnerId);}
        }else{
            if(!String.valueOf(leadDetails.OwnerID).startsWith(userObjPrefix)){
                leadConvert.setOwnerId(UserInfo.getUserId());
        	}else{
                leadConvert.setOwnerId(leadDetails.OwnerID);}
        }
        
        return Database.convertLead(leadConvert);
    }
    
    private String getLeadStatusIsConverted(String status) {
        LeadStatus oLeadStatus = new LeadStatus();
          //Added if condition to avoid APEX CRUD violation Rule 
        if(Schema.sObjectType.LeadStatus.isQueryable()){
         oLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true and MasterLabel = :status LIMIT 1];}
        
        return oLeadStatus.MasterLabel;
        
    }
    //Start: Added for CRM-17825
    
     public void fetchLeadActivities(){   
        Lead l = leadDetails;
        system.debug('***SelectedLeadIds' + leadDetails);
        if(Schema.sObjectType.TASK.isAccessible()) {
        taskListforLeads = [SELECT id,callType,ActivityDate,Status,whoId,Subject,whatId,ownerId FROM TASK WHERE whoid = : l.id];
        }
        if(Schema.sObjectType.EVENT.isAccessible()) {
        eventListforLeads = [SELECT id,Type,ActivityDate,Status__c,whoId,Subject,whatId,ownerId FROM EVENT WHERE whoid = : l.id];
        } 
    }
    
    public void createLeadEventsUnderOpp(Id optyId,Id conId){
         List<Event> eventsToUpdate = new List<Event>();
        if(!eventListforLeads.isEmpty()){
         for(Event e: eventListforLeads){
                    e.whatId = optyId;
                    e.whoId= conId;
                    eventsToUpdate.add(e);
                }
            }
        try{
            if(!eventsToUpdate.isEmpty()){
               if(Schema.sObjectType.Event.isUpdateable()) {
                update eventsToUpdate;
                }

            }
            
        } catch(DMLException dmlEx){
          
              system.debug('*** createLeadEventsUnderOpp error:: dmlEx.getMEssage()');
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
          
          }
        
    }
    
    public void createLeadTasksUnderOpp(Id optyId,Id conId){
         List<Task> tasksToUpdate = new List<Task>();
        if(!taskListforLeads.isEmpty()){
           for(Task t: taskListforLeads){
                    t.whatId = optyId;
                    t.whoId= conId;
                    tasksToUpdate.add(t);
                } 
        }
         
        try{
         if(Schema.sObjectType.Task.isUpdateable())
         {
            if(!tasksToUpdate.isEmpty()){            
                update tasksToUpdate;       }
         }   
        } catch(DMLException dmlEx){
          
              system.debug('*** createLeadEventsUnderOpp error:: dmlEx.getMEssage()');
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
          
          }
        
    }
    
    //End:Added for CRM-17825
    private void createLeadHistory(){
        Lead l = leadDetails;
        LM_Lead_History__c lHistory;
        
        if(lHistoryMap != null && lHistoryMap.size() > 0 && lHistoryMap.get(l.ID) != null)
        {
            lHistory = lHistoryMap.get(l.ID);
        }
        else
        {
            lHistory = new LM_Lead_History__c ();
        }
        
        lHistory.name= l.name;
        lHistory.Status__c = convertedStatusLabel;
        if(selectedOpptyType == 'SFDCOppty')
        {
            lHistory.opportunity__c = selectedOpptyId;
        }else{
            lHistory.opportunity__c = convertedOpptyId;    
        }
        
        lHistory.contact__c= convertedContactId;   
        lHistory.Campaign_Cell__c = l.Campaign_Cell__c ;
        lHistory.Campaign_Code__c = l.Campaign_Code__c;
        lHistory.Acceptance_SLA_Violation__c = l.Acceptance_SLA_Violation__c;
        lHistory.Accept_By__c = l.Accept_By_Date__c;
        lHistory.Convert_By__c = l.Convert_By_Date__c;
        lHistory.Account_Name__c = l.Company;
        lHistory.Business_Org__c = l.Business_Org__c;
        //lHistory.Contact_ID__c = l.Contact__c;
        lHistory.Contact_SAP_ID__c = l.Contact_SAP_ID__c;
        lHistory.Convert_SLA_violation__c = l.Convert_SLA_violation__c;
        lHistory.Discard_Reason__c = l.Discard_Reason__c;
        lHistory.External_Contact_ID__c = l.External_Contact_ID__c;
        lHistory.External_ID__c = l.External_ID__c;
        lHistory.Lead_ID__c = l.id;
        lHistory.LeadID18__c = l.LeadID18__c;
        lHistory.Lead_Last_Modified_by__c = l.LastModifiedBy.Name;
        lHistory.Lead_Owner__c = l.owner.name;
        lHistory.Lead_Source__c= l.LeadSource;
        lHistory.Lead_Type__c = l.Type__c;
        lHistory.Name__c = l.Name;
        lHistory.Primary_Campaign_Source__c = l.Primary_Campaign_Source__c;
        lHistory.Priority__c = l.Priority__c;
        lHistory.Source_Desc__c = l.Source_Desc__c;
        lHistory.Source_Type__c = l.Source__c;
        lHistory.Tracking_Code__c = l.Tracking_Code__c;
        lHistory.Account_ID__c= convertedAccountId; 
        //lHistory.Account_ID__c= '001S000000pexBg'; 
        lHistory.Lead__C = l.ID;        
  lHistory.Budget_Available__c = l.Budget_Available__c;
        lHistory.Decision_Maker_Champion__c = l.Decision_Maker_Champion__c;
        lHistory.Need_Identified__c = l.Need_Identified__c;
        lHistory.Qualified_Product_s__c = l.Qualified_Product_s__c;
        lHistory.Qualifying_Notes__c = l.Qualifying_Notes__c;
        lHistory.Telequalified_Appointment_Complete__c = l.Telequalified_Appointment_Complete__c;
        lHistory.Timeline_Identified__c = l.Timeline_Identified__c; 
        // 20190213 - Jason Flippen - Added for Jira Story CRM-18115
        lHistory.Line_of_Business__c = l.Line_of_Business__c;
        lHistory.Operating_Unit__c = l.Operating_Unit__c;
        lHistory.Tele_Interaction__c = l.Tele_Interaction__c;
        lHistory.Lead_Score__c = l.Lead_Scoring_Combined__c; //added as a part of DPS-18629
        lHistory.Is_Marketing__c = l.Is_Marketing__c; //added as a part of DPS-18629
            system.debug('***lead Score:'+l.Lead_Scoring_Combined__c);
            system.debug('***lead is marketing:'+l.Is_Marketing__c);
            system.debug('***Lead History lead Score:'+lHistory.Lead_Score__c);
            system.debug('***Lead History lead is marketing:'+lHistory.Is_Marketing__c);
        lHistoryMap.put(l.ID,lHistory);
        
        system.debug('***lHistory ***'+lHistory );
        
        try{
            upsert lHistoryMap.values();
            system.debug('*** LOG STATUS:: LM Lead History created');
        }catch(DMLException dmlEx){
            system.debug('*** create LM Lead History error:: '+dmlEx.getMEssage());
            bError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMessage()));       }
    }
    
    
     //Start : Added for R4 functionality CRM-6333 & CRM-7711
    private void updateOppTeamMembers(Id oppty){
    
     //String profileName; //Added for R4 functionality
     //String subBu; //Added for R4 functionality
     //boolean uslUser; //Added for R4 functionality 
     boolean isLeadPresentInopptyTeam; //Added for R4 functionality
     Integer count = 0;
    
    //Id loggedInUserId = UserInfo.getUserId();
    
    
        /**profileName = [SELECT Profile.Id, Profile.Name from User Where Id =:loggedInUserId].Profile.Name;
        subBu = [SELECT Sub_Bu__c from User Where Id =:loggedInUserId].Sub_Bu__c;
        if((profileName == 'GLI Sales User' || profileName == 'GLI Sales Ops User' || subBu == 'FindLaw' || subBu == 'USL' || subBu == 'LMS')){
             uslUser = true;
        } else{
       uslUser = false; //Added for CRM-13709
    }**/
    
    
                Id leadId  = ApexPages.CurrentPage().getparameters().get('id');
                Lead leadDetails = new Lead();
                //Added if conditin before SOQL Query to avoid APEX CRUD Violatin 
                if(Schema.sObjectType.Lead.isQueryable()){
                leadDetails = [select id, Description,URL__c,Phone,Email,FirstName,LastName,Status,Convert_by__c,Accept_by__c,MDBId__c,SAPAccountNumber__c,
                               Lead_Scoring_Combined__c,Billing_City__c,Billing_State__C,Billing_Street__c,PO_Box__c,Tax_Number__c,Tax_Number_Type__c,
                               Billing_Zip__c,Sales_Org__c,Billing_Country__c,Customer_Class__c,Customer_Group__c,ConvertedOpportunityId,Campaign_Cell__c,Contact__c,Account__c, Contact__r.AccountId, 
                               Account__r.BillingCity, Account__r.NAme, Contact__r.Account.NAme, Account__r.Operational_Ultimate_Parent_ECM_Party_ID__c, Account__r.BillingStreet,Contact__r.email, Contact__r.Account.BillingStreet, Contact__r.Account.Operational_Ultimate_Parent_ECM_Party_ID__c, 
                               Account__r.BillingPostalCode, Account__r.BillingState,Account__r.BillingCountry, Contact__r.Account.BillingCountry,  Customer_Type__c,Industry,Contact__r.name,Campaign_code__c,Source__c,Legacy_System_ID__c, OwnerId,Acceptance_SLA_Violation__c,Accept_By_Date__c,Convert_By_Date__c,
                               Company,Business_Org__c,Contact_SAP_ID__c,Convert_SLA_violation__c, Discard_Reason__c,External_Contact_ID__c,External_ID__c,LeadID18__c,LastModifiedBy.Name,CreatedBy.Name,
                               owner.name,LeadSource, Job_Function__c, title, Type__c,Name,Primary_Campaign_Source__c,Priority__c,Source_Desc__c,Tracking_Code__c,Is_GLI__c, Account__r.ECM_Party_ID__c, Contact__r.Account.Operational_Ultimate_Parent_Name1__c, Budget_Available__c, Decision_Maker_Champion__c, 
                 Need_Identified__c, Qualified_Product_s__c, Qualifying_Notes__c, Telequalified_Appointment_Complete__c, Timeline_Identified__c,Is_Marketing__c from lead where Id =: leadId];}
                Opportunity opptyRec = new Opportunity();
                //Added a check to verify if user has access on OpportunityTeamMembers to avoid Apex Crud Violation
                if(Schema.sObjectType.Opportunity.isQueryable() && Schema.sObjectType.OpportunityTeamMember.isQueryable()){
                opptyRec = [SELECT Owner.id,accountId,(select id, UserId, OpportunityId, OpportunityAccessLevel, TeamMemberRole from OpportunityTeamMembers) FROM Opportunity WHERE id = :oppty];
                List<OpportunityTeamMember> lstopptyTeamMember = opptyRec.OpportunityTeamMembers;
                
                List<OpportunityTeamMember> lstOppTeams = new List<OpportunityTeamMember>(); 
                
                if(!lstopptyTeamMember.isEmpty()){
          for(OpportunityTeamMember oTeamMember : lstopptyTeamMember)
          {
            if(uslUser && oTeamMember.UserId == leadDetails.OwnerId)
            {   
              count++;
              break;
            }
        }  }

                 if(uslUser && count == 0 ){
                                  //CRM-11535 : When you add the converted user to the opportunity team the member role needs to reflect the sales rep type.
                                    
                                    
                                    OpportunityTeamMember otm = new OpportunityTeamMember(OpportunityId = oppty, UserId = leadDetails.Owner.id, TeamMemberRole = 'Sales Rep',OpportunityAccessLevel = 'Edit') ;
                                    lstOppTeams.add(otm);
                 }
                  //---DPS-1999 ---                
                if(partnerUser == true){
                                    OpportunityTeamMember partnerOtm = new OpportunityTeamMember(OpportunityId = oppty, UserId = leadDetails.CreatedBy.id, TeamMemberRole = 'Partner',OpportunityAccessLevel = 'Read') ;
                                    lstOppTeams.add(partnerOtm);
                                    
                } 
                                    //Added a check to verify if user has access on OpportunityTeamMembers to avoid APEX CRUD violation Rule before INSERT Operation
                                    if(Schema.sObjectType.OpportunityTeamMember.isCreateable()){
                                    insert lstOppTeams;}
                                    system.debug('lstOppTeams++++'+lstOppTeams);
                                    
               }                     
                               
                } //---DPS-1999 END---
                
                
      
      //End : Added for R4 functionality CRM-6333 & CRM-7711
    private void createContactRole(){
        
        Opportunity oRetrievedOpportunity;
        Boolean bContactExists = false;
        
        try{
            if(selectedopptyType == 'SFDCoppty' )
            {
                //Updated query for R4 CRM-6333
    if(Schema.sObjectType.Opportunity.isQueryable() && Schema.sObjectType.OpportunityTeamMember.isQueryable() &&Schema.sObjectType.OpportunityContactRole.isQueryable())
     {
                oRetrievedOpportunity = [select id, name, StageName, Owner.name, OwnerId,Created_by_Role__c,CloseDate,
                                         Total_Incremental__c,Total_Renewal__c,LCRM_Total_New_ACV_Sales_Price__c,createdDate,Status__c, Account.Name, 
                                         City_State__c, Billing_City__c, AccountId, Account.BillingCountry, Key_Contact__c,
                                         (SELECT ContactId,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRoles),
                                         (select id, UserId, OpportunityId, TeamMemberRole from OpportunityTeamMembers)
                                         from Opportunity
                                         where Id = :selectedopptyId];
                
                
                if(oRetrievedOpportunity != null)
                {
                    List<OpportunityContactRole> lstOpportunityContactRole = oRetrievedOpportunity.OpportunityContactRoles;
                    
                    for(OpportunityContactRole oContactRole : lstOpportunityContactRole)
                    {
                        if(oContactRole.ContactId == convertedContactId)
                        {
                            bContactExists = true;
                            break;
                        }
                    }
                }   
                    if(!bContactExists)
                    {
                        OpportunityContactRole oRole = new OpportunityContactRole();
                        oRole.ContactId = convertedContactId;
                        oRole.OpportunityId = oRetrievedOpportunity.Id;
            //Added a condition to avoid APEX CRUD violation Rule before INSERT Operation
                        if(Schema.sObjectType.OpportunityContactRole.isCreateable()){
                        insert oRole;
                        system.debug('*** LOG STATUS:: Contact Roles created');}
                    }
                }
            }
        }
        catch(Exception ex){
            system.debug('*** createContactRole error:: '+ex.getMEssage());
            bError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage()));
        }
    }
    
        @TestVisible
        private Account createNewAccount(DataQualityUtil.ECMAccountInfo ecmAccountInfo, NewAccountOption newAccountDetails)
    {
        System.debug('@@@@@ Inside createNewAccount Method');
        Account oAccount = new Account();
        
        try{
            if(ecmAccountInfo != null)
            {
                String streetAddress = '';
                oAccount.Name = ecmAccountInfo.Name; 
                oAccount.BillingCity = ecmAccountInfo.City; 
                
                if(String.isNotBlank(ecmAccountInfo.Street1))
                {
                    streetAddress = ecmAccountInfo.Street1;
                }
                
                if(String.isNotBlank(ecmAccountInfo.Street2))
                {
                    if(String.isNotBlank(streetAddress)){
                        streetAddress += ', ' + ecmAccountInfo.Street2;
                    }
                    else{
                        streetAddress = ecmAccountInfo.Street2;    }
                }
                
                oAccount.BillingStreet = streetAddress;
                oAccount.BillingState = ecmAccountInfo.State;
                oAccount.BillingCountry = ecmAccountInfo.Country;
                oAccount.BillingPostalCode = ecmAccountInfo.PostalCode;
                oAccount.ECM_Party_ID__c = ecmAccountInfo.partyRowId;
                oAccount.ECM_Address_Row_Id__c = ecmAccountInfo.AddressId;
                /* Commented out as part of CRM-6072
                oAccount.Validated_Account__c = true;
                */
            }
            else if(newAccountDetails != null)
            {
                oAccount.Name = newAccountDetails.accountName; 
                oAccount.BillingCity = newAccountDetails.billingCity; 
                oAccount.BillingStreet = newAccountDetails.billingStreet;
                oAccount.BillingState = newAccountDetails.billingState;
                oAccount.BillingCountry = newAccountDetails.billingCountry;
                oAccount.BillingPostalCode = newAccountDetails.billingZipCode;
                // Added below if condition for CRM-6135 by Shovon
                if(oResponseAccount.ECMAccounts.size() > 0 || oResponseAccount.SFDCAccounts.size() > 0){
                    oAccount.LCRM_Bypassed_Potential_Matches__c = true;           }
            }
            
            if(informaticaUserId != null){
                system.debug('+++ inside informatica user assignment for Acount');
                oAccount.OwnerId = informaticaUserId;
                
            }
            //Added if condition to avoid APEX CRUD violation Rule before INSERT Operation
            if(Schema.sObjectType.Account.isCreateable()){
            insert oAccount;}
            system.debug('*** Account after inserting ***' + oAccount);
            
            return oAccount;
        }
        catch(Exception ex)        {
            system.debug('** Error while creating new Account**' + ex);
            bError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage()));
            return null;     }
    }
    
    private Contact createNewContact(DataQualityUtil.CDSContactInfo cdsContact, NewContactOption newContactDetails, String accountId)
    {
        Contact oContact = new Contact();
        
        try
        {
            if(cdsContact != null)
            {   
                system.debug('+++ Within cdsContact IF check '+ accountId);
                oContact.FirstName = cdsContact.First_Name;
                oContact.LastName = cdsContact.Last_Name;
                oContact.Email = cdsContact.Contact_Email;
                oContact.Title = cdsContact.Title;
                oContact.Phone = cdsContact.Contact_Phone;
                oContact.Job_Function__c = cdsContact.Job_Function;
                oContact.AccountId = accountId; //Set whatever Account Id that has been selected
                oContact.Person_ID__c = String.valueOf(cdsContact.PERSON_ID);
                oContact.LCRM_Is_CDS_Ready__c = true;
                if(cdsContact.Contact_Inactive != null){// Added by Shovon for CRM-6056
                oContact.Contact_Inactive__c = cdsContact.Contact_Inactive; }
            }
            else if(newContactDetails != null)
            {
                system.debug('+++ Within newContactDetails else check '+ accountId);
                oContact.FirstName = newContactDetails.firstName;
                oContact.LastName = newContactDetails.lastName;
                oContact.Email = newContactDetails.email;
                oContact.LCRM_Email_Verification__c = newContactDetails.LCRMEmailVerification;
                oContact.Title = newContactDetails.title;
                oContact.Phone = newContactDetails.phone;
                oContact.LCRM_Phone_Verification__c = newContactDetails.LCRMPhoneVerification;
                oContact.Job_Function__c = newContactDetails.function;
                oContact.AccountId = accountId; //Set whatever Account Id that has been selected
            }
            //Added a condition to avoid APEX CRUD violation Rule before INSERT Operation
            if(informaticaUserId != null && Schema.sObjectType.Contact.isCreateable()){
                oContact.OwnerId = informaticaUserId;}
            
            insert oContact;
            system.debug('*** Contact after inserting ***' + oContact);
            
            return oContact;
        }
        catch(Exception ex)        {
            system.debug('** Error while creating new Contact**' + ex);
            bError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage()));
            return null;
        }    }
    
    
    
    //Inner Class for NEW Salesforce Contact
    public class NewContactOption {
        //Properties
        public boolean isSelected {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String email {get;set;}
        public String lCRMEmailVerification {get;set;}
        public String title {get;set;}
        public String function {get;set;}
        public String phone {get;set;}
        public String lCRMPhoneVerification {get;set;}
        
        //Constructors
        public NewContactOption() {
            this.isSelected = false;
            this.firstName = null;
            this.lastName = null;
            this.email = null;
            this.lCRMEmailVerification = null;
            this.title = null;
            this.function = null;
            this.phone = null;
            this.lCRMPhoneVerification = null;
        }
        
    } 
    
    //Inner Class for NEW Account
    public class NewAccountOption {
        //Properties
        public boolean isSelected {get;set;}
        public String accountName {get;set;}
        public String billingStreet {get;set;}
        public String billingCity {get;set;}
        public String billingState {get;set;}
        public String billingCountry {get;set;}
        public String billingZipCode {get;set;}
        
        //Constructors
        public NewAccountOption() {
            this.isSelected = false;
            this.accountName = null;
            this.billingStreet = null;
            this.billingCity = null;
            this.billingState = null;
            this.billingCountry = null;
            this.billingZipCode = null;
        }
        
    } 
    
    //Inner Class for Account Search
    public class AccountSearchOption {
        //Properties
        
        public String accountName {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        
        //Constructors
        public AccountSearchOption() {
            this.accountName = null;
            this.city = null;
            this.state = null;
            this.country = null;
        }
        
    }
    
    //Inner Class for Existing Salesforce Opportunities
    public class OpportunityOption {
        //Properties
        public boolean isSelected {get;set;}
        public Opportunity opportunity {get;set;}
        
        //Constructors
        public opportunityOption() {
            this.isSelected = false;
            this.opportunity = new opportunity();
        }
        
        public opportunityOption(opportunity ooppty) 
        {
            this();
            this.opportunity = ooppty;
        }
    }
    
    //Internal Classes
    
    /**
* Data structure representing a account that was
* matched with ECM and scored
*/
    public class MatchedCDSContact {
        public DataQualityUtil.CDSContactInfo cdsContactInfo {get;set;}
        public boolean isSelected{get;set;}
    }
    
    /**
* Data structure representing a account that was
* matched with salesforce account records and scored
*/
    public class MatchedSFDCContact { 
        public DataQualityUtil.cdsContactInfo cdsContactInfo {get;set;}
        public Contact contact {get;set;}       
    }
    
}