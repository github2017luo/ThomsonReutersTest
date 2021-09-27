/*============================================================================================
Name                : ODT_TrialReInitiate
Description         : This class is developed as part of CXD-ODT project and it is serving as a controller class for the visualforce page-ODT_TrialReInitiatePage.
Here we are displaying all OLC contacts for reinitiating trial by resending the invitation mail.
Two services are integrated in this.  
1. Call to ESI to get the all online contact which are available on OLC system.
2. After selecting contact by SalesRep, need to send email notification to Eloqua.
Created Date        : 9/25/2018
Author              : TCS CXD ODT team
Modification History: Modified by Ameeta Antonio as part of JIRA, DLT-11455
DLT-11455:TM/SR(SFDC)-A-Initiate: Ability to re-send invitation to primary user (1 user scenario) 
DLT-20919: Critical Components Code scan issue:Code Refactoring to resolved PMD issues
DLT-21599   [SFDC][ODT] - Avoid showing duplicate emails on clicking add user button in SFDC
==============================================================================================*/
global without sharing class ODT_TrialReInitiate {
    
    public LIST<contactsWrapper> contactTodisplay{get; set;}
    
    public LIST<contactsWrapper> primaryContasTodisplay{get; set;}
    public LIST<Invite_Colleagues__c> invitedColleagues;
    public string trialID{get; set;}
    public string sfdccontactId{get; set;}
    Trial__c trialDetails = new Trial__c();
    List<Invite_Colleagues__c> invDetails;
    string trialInitiatedAccountNumber='';
    public Boolean eloquaEmailTriggered{get; set;}
    public Boolean checkError{get; set;}
    public id invitedColleagueId{get; set;}
    public id reinitiatedTrialId{get; set;}
    public string action;
    public boolean isAdded{get;set;}
    public List<String> notDisplayOLC{get;set;}
    public String selectedOLC{get;set;}
    public map<String,String> notToDisplayOLCMap{get;set;}
    
    //Start of  Pagination
    ODT_Pagination allolcRecords;
    public map<String,ContactsWrapper> selectedrecordsMap{get;set;}
    public List<ContactsWrapper> allOtherOLCcontacts{get;set;}
    public List<ContactsWrapper> allOtherOLCcontactsPagination{get;set;}
    public List<ContactsWrapper> selectedrecords{get;set;}
    public boolean isAddUser{get;set;}
    public boolean maxLengthReached{get;set;}
    public boolean isNewAddUser{get;set;}
    ODT_AddUser_Values__mdt addValues ; // metadata values 
    //END of pagination  
    
    
    // Start of Search 
    public string searchStr{get; set;}
    public LIST<ContactsWrapper> searchResults{get; set;}
    public boolean searchBool{get; set;}    
    public Boolean searchResultsbool{get; set;}
    // End of Search 
    
    // Add New User Validation variables 
    public set<string> allINCEmails{get; set;}
    
    
    public ODT_TrialReInitiate()
    {
        contactTodisplay = new LIST<contactsWrapper>();
        primaryContasTodisplay = new LIST<contactsWrapper>();
        invDetails = new LIST<Invite_Colleagues__c>();
        invitedColleagues = new List<Invite_Colleagues__c>();
        
        notDisplayOLC = new LIST<String>();
        checkError = false;
        isAdded=false;
        isAddUser=false;
        isNewAddUser = false;
        notToDisplayOLCMap = new map<String,String>();
        // selectedOLC= new List<String>();
        searchBool = false;
        allINCEmails = new set<string>();
        
        trialID =apexpages.currentpage().getparameters().get('id');
        action = apexpages.currentpage().getparameters().get('action');
        
        //system.debug('Trial ID'+trialID);
        
        //if(Schema.sObjectType.Trial__c.isQueryable() && Schema.sObjectType.Opportunity_Trial__c.isQueryable() && Schema.sObjectType.Invite_Colleagues__c.isQueryable()){
        
        trialDetails = [Select Id,Source_System_Detail__c,Profile_Type__c ,Profile_ID__c, SAP_Promotion_Code__c, Lapsed_Reason_Code__c ,Is_Lapsed__c ,ODT_Email__c,Trial_Initiated_Account_Number__c, 
                        Source_System_Detail__r.Account_Name__c,Source_System_Detail__r.Account_Name__r.Name, Contact_id_SAP__c,ODT_SAP_Account_Number__c,Trial_Id__c,ODT_Product_Bundle__c,ODT_Trial_Product_Category__c,Trial_Status__c,
                        Trial_Source__c,(Select ID, Source_System_Detail__c, Email__c,First_Name__c,Last_Name__c,Primary_User__c,Trial__c,SapContactId__c FROM Invite_Colleagues__r ),
                        (Select Id,Opportunity__c,Trial__c FROM Opportunity_Trial__r) 
                        FROM Trial__c where Id =:trialID WITH SECURITY_ENFORCED];
        //}                   
        if(Schema.sObjectType.Invite_Colleagues__c.isQueryable()){
            invDetails = [Select ID, Source_System_Detail__c, Email__c,First_Name__c,Last_Name__c,Primary_User__c,Trial__c,SapContactId__c FROM Invite_Colleagues__c  where Primary_User__c = true  AND Trial__c =: trialID];
        }
        
        setPageActionVariables();
        
        allINCEmails.add(trialDetails.ODT_Email__c );
        for(Invite_Colleagues__c t : trialDetails.Invite_Colleagues__r ){
            allINCEmails.add(t.Email__c);                                   
        }
        
        
        //Pagination Start here
        
        allOtherOLCcontacts=  new List<ContactsWrapper>();
        allOtherOLCcontactsPagination = new List<ContactsWrapper>();
        selectedrecords = new List<ContactsWrapper>();
        selectedrecordsMap = new map<String,ContactsWrapper>();
        maxLengthReached=false;
        
        allolcRecords=new ODT_Pagination(allOtherOLCcontacts);
        
        addValues=  new ODT_AddUser_Values__mdt();
        addValues =[select maximum_records_to_add__c ,records_per_page__c from ODT_AddUser_Values__mdt where MasterLabel ='add user' WITH SECURITY_ENFORCED];
        system.debug(LoggingLevel.INFO,'values coming from MDT'+addValues.maximum_records_to_add__c+addValues.records_per_page__c);
        allolcRecords.setPageSize = (test.isrunningTest())?2:Integer.valueOf(addValues.records_per_page__c);
        
        
        //Pagination ends here 
        
        trialInitiatedAccountNumber =(trialDetails.Trial_Initiated_Account_Number__c != null )?trialDetails.Trial_Initiated_Account_Number__c:trialDetails.ODT_SAP_Account_Number__c; 
        /*if(trialDetails.Trial_Initiated_Account_Number__c != null )
trialInitiatedAccountNumber = trialDetails.Trial_Initiated_Account_Number__c;
else
trialInitiatedAccountNumber = trialDetails.ODT_SAP_Account_Number__c;*/
        
        if(trialInitiatedAccountNumber != ''){     
            showOLCForTrialReInitiate(trialInitiatedAccountNumber);
        }
        next();  
        
    }
    
    /********************************************************************************************************
* setPageActionVariables: Method to set class variables based on action(Resend/Add user) sent from VF page
*********************************************************************************************************/  
    private void setPageActionVariables(){
        if(action.equals('Resend')){            
            isAddUser=false;
        }
        else if(action.equals('addUser')){
            system.debug(LoggingLevel.INFO,'innnnnnn');
            
            if(trialDetails.Profile_Type__c == 'NET_NEW')
            {
                isNewAddUser = true; 
            }
            else{
                isAddUser=true;  
            }
            
        }
    }
    
    /********************************************************************************************************
* showOLCForTrialReInitiate: Method to retrieve OLC's from ESI service based on SAP Account number
*********************************************************************************************************/    
    public void showOLCForTrialReInitiate(String sSD)
    {                
        try{
            system.debug(LoggingLevel.INFO,'Try Catch');            
            MAP<string, string> checkonlineContactsType = new MAP<string, string>();
            
            HTTPResponse res = CallToOLCTofetchActiveTr.showOnlineContacts(SSD);
            system.debug(LoggingLevel.INFO,'Response '+res);
            if(res.getStatusCode()== 200)
            {
                EsiResponseWrapper esiResp = (EsiResponseWrapper)JSON.deserialize(res.getBody(), EsiResponseWrapper.class);
                System.debug(LoggingLevel.INFO,'esiResp:.......'+esiResp);
                if(esiresp.onlineContact != null)
                {
                    for(EsiResponseWrapper.onlineContact olcon: esiresp.onlineContact)
                    {
                        string fname; 
                        string lname; 
                        string apguid; 
                        string email; 
                        string sAPConId; 
                        string sFDCconid='';
                        string sAPAccid;
                        string sFDCaccid=trialDetails.Source_System_Detail__r.Account_Name__c;
                        string oLCcontactNumberWithZero;
                        string authUUDId='';
                        Boolean registeredWithOLC=FALSE;
                        Boolean isActive=FALSE;
                        
                        try{
                            if(olcon.entitlements != null){
                                system.debug('OLC Ent '+olcon.entitlements);
                                
                                for(EsiResponseWrapper.entitlements enti: olcon.entitlements){
                                    if(enti.registered != null && enti.status != null && enti.registered == true){
                                        if(enti.status.equalsIgnoreCase('ACTIVE') ){           
                                            checkonlineContactsType.put(enti.authEmail, olcon.contactNumber);
                                        }
                                    }      
                                }  
                                
                                for(EsiResponseWrapper.entitlements enti: olcon.entitlements){
                                    
                                    if(enti.authId != null && enti.authId != '')
                                        authUUDId = enti.authId;
                                    if(enti.registered != null && enti.status != null && enti.registered == true){
                                        if(trialDetails.Profile_Type__c == 'EXISTING_USER_SAME_DOMAIN')
                                        {
                                            
                                            
                                            if(enti.status.equalsIgnoreCase('ACTIVE') && enti.applicationId.equalsIgnoreCase('Cobalt')){
                                                apguid = enti.appUserGuid;
                                                email = enti.authEmail;
                                                registeredWithOLC = TRUE;
                                                isActive=TRUE;
                                                
                                            }
                                        }
                                        else if(trialDetails.Profile_Type__c == 'EXISTING_USER_NEW_DOMAIN')
                                        {
                                            if(!enti.applicationId.equalsIgnoreCase('Cobalt') && enti.status.equalsIgnoreCase('ACTIVE')){
                                                apguid = enti.appUserGuid;
                                                email = enti.authEmail;
                                                registeredWithOLC = TRUE;
                                                isActive=TRUE;
                                                
                                            }   
                                        }
                                        else if(trialDetails.Profile_Type__c == 'NET_NEW')
                                        {
                                            if(enti.status.equalsIgnoreCase('INACTIVE') && isActive != true && !checkonlineContactsType.containskey(enti.authEmail)){
                                                apguid = enti.appUserGuid;
                                                email = enti.authEmail;
                                                registeredWithOLC = TRUE;
                                                isActive=FALSE;
                                                
                                            }  
                                            
                                        }
                                        
                                    }
                                }
                                if(registeredWithOLC){
                                    SAPConId = olcon.contactNumber;
                                    
                                    // commented to remove truncatation of the zeros from SAP
                                    /*String ress = olcon.contactNumber;
OLCcontactNumberWithZero = olcon.contactNumber;

if(ress.isNumeric() && !string.isEmpty(ress)){                                           
ress = ress.trim();
SAPConId=string.valueOf(Long.valueOf(ress));
} */
                                    
                                    EsiResponseWrapper.address adrs = olcon.address;
                                    if(adrs != null){
                                        fname=adrs.firstName;
                                        lname=adrs.lastName;
                                        
                                    }
                                    if(olcon.account != null)
                                        SAPAccid = olcon.account.accountNumber;
                                    
                                    if(fname != null && fname != '' && lname != null && lname != '' && email != null && email != '' && SAPConId != null && SAPConId != ''  )
                                    {
                                        contactTodisplay.add(new contactsWrapper(fname, lname, apguid, email, SAPConId, SFDCconid, SAPAccid, SFDCaccid, OLCcontactNumberWithZero,false ,false, authUUDId ));
                                        System.debug('contasTodisplay'+contactTodisplay);
                                        
                                    }
                                    
                                }  
                            }
                        }catch(exception e){
                            
                        }
                        
                    }
                    
                    
                    processAddUserScenario();
                    
                }
            }
            
            
        }
        catch(exception e)
        {
            system.debug(LoggingLevel.INFO,'Exception'+e.getStackTraceString());
        }
    }
    
    /********************************************************************************************************
* processAddUserScenario: Method to check conditions for add user and ivone the emthod for the adduser functionality
*********************************************************************************************************/    
    private void processAddUserScenario(){
        if(isAddUser || isNewAddUser)
        {
            if(contactTodisplay.size() > 0)
            {
                system.debug(LoggingLevel.INFO,'inside if'+isAddUser);
                mapNotToDisplayOLC();
                
                system.debug(LoggingLevel.INFO,'LIST OLC'+notToDisplayOLCMap);
                getUserToAdd(contactTodisplay,notToDisplayOLCMap);
            }
            
        }
        else{
            system.debug(LoggingLevel.INFO,'inside else'+isAddUser);
            getPrimaryUserForReinitiation(contactTodisplay,trialDetails.Contact_id_SAP__c);
        } 
    }
    
    /********************************************************************************************************
* mapNotToDisplayOLC: Method to map the OLC which should not be displayed
*********************************************************************************************************/    
    private void mapNotToDisplayOLC(){
        if(trialDetails.Contact_id_SAP__c!=null){
            notToDisplayOLCMap.put(trialDetails.Contact_id_SAP__c, trialDetails.ODT_Email__c);
        }
        for(Invite_Colleagues__c t : trialDetails.Invite_Colleagues__r )
        {
            if(t.SapContactId__c!='' && t.SapContactId__c!=null)
            {
                system.debug(LoggingLevel.INFO,'IC SAP'+t.SapContactId__c);
                notToDisplayOLCMap.put(t.SapContactId__c, t.Email__c);
                allINCEmails.add(t.Email__c); 
            }
            
        }
    }
    
    /********************************************************************************************************
* reInitiateTrial: In this two functions are handled
*1.sending callout to Eloqua for resending invitation. 
*2.updation of Trial and invited Colleagues once reinitiation of trial occurs.
*********************************************************************************************************/     
    public void reInitiateTrial(){
        System.debug(LoggingLevel.INFO,'Re-initiate Trial-------');
        
        string selectedcustomer = apexpages.currentpage().getparameters().get('selectedContact');
        System.debug(LoggingLevel.INFO,'selectedCustomer'+selectedcustomer);
        
        // get the Callout parameters from Custom Setting
        WebServiceSettings__c oWebServiceSettings2 = AppUtil.getWebServiceSettings('ODTEloquaService');
        if(selectedcustomer != null){
            try{
                for(contactsWrapper cw: primaryContasTodisplay){
                    if(cw.SAPContactId == selectedcustomer){
                        
                        processSelectedCustDetails(cw,selectedcustomer);
                        
                    }
                }  
            }
            catch(exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage())); 
            }
        }
    } 
    
    /********************************************************************************************************
* processSelectedCustDetails: Method to reinititae trial for selected customer
*********************************************************************************************************/
    private void processSelectedCustDetails(ContactsWrapper cw, String selectedcustomer){
        if(cw.firstName != null && cw.firstName != '' && cw.lastName != null && cw.lastName != '' && cw.EmailId != null && cw.EmailId != '' && cw.SAPContactId != null && cw.SAPContactId != ''  ){
            System.debug(LoggingLevel.INFO,'selectedcustomer.......'+cw.SFDCContactId+'    '+selectedcustomer);
            
            Savepoint sp = Database.setSavepoint();
            invokeOLCJob(cw,sp,selectedcustomer);
            
        }
        else{
            // any value as null in First Name, Last Name, Email, SAP Contact Number than show the error message. 
            system.debug(LoggingLevel.INFO,'########in checkError');
            checkError = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ODT_Required_fields_Null_on_Rep_journey));
        }
    }
    
    /********************************************************************************************************
* invokeOLCJob: In this two functions are handled
*1.queuable job to ContactsListConCallout to resend invitation. 
*2.updation of Trial and invited Colleagues once reinitiation of trial occurs.
*********************************************************************************************************/     
    private void invokeOLCJob(ContactsWrapper cw,Savepoint sp, String selectedcustomer){
        try{
            if(trialID != null && trialDetails.Id != null){
                if(trialDetails.Opportunity_Trial__r != null && trialDetails.Opportunity_Trial__r.size() >=1){
                    for(Opportunity_Trial__c opTrial : trialDetails.Opportunity_Trial__r){
                        System.debug(LoggingLevel.INFO,'trialcategory'+trialDetails.ODT_Trial_Product_Category__c);
                        ContactsListConCallout updJob = new ContactsListConCallout(cw.firstName, cw.lastName, cw.EmailId, cw.SAPAccountId,cw.SAPContactId,cw.SFDCAccountId,cw.SFDCContactId,cw.appGUID, trialDetails.Trial_Id__c, selectedcustomer, opTrial.Opportunity__c, trialID, trialDetails.Source_System_Detail__r.Account_Name__r.Name, Label.ODT_Rep_Initiated_URL,'invite', trialDetails.Trial_Source__c,null,true, false ,false, false,false,null); 
                        ID jobID = System.enqueueJob(updJob);
                        System.debug(LoggingLevel.INFO,'@@@JobId.....: '+jobID);
                        eloquaEmailTriggered = TRUE;
                        checkError = false;
                    }
                }
            }
            else{
                Database.rollback( sp );
            }
            if(invDetails.size() > 0){
                for(Invite_Colleagues__c inv : invDetails){
                    Database.UpsertResult invColleague=CallToOLCTofetchActiveTr.createInvitedColleague(trialDetails.Source_System_Detail__c, cw.EmailId, cw.firstName, cw.lastName, cw.SAPContactId, trialID, inv.Primary_User__c,inv.id);
                    invitedColleagueId=invColleague.getId();                                                                                                                      
                }                                                                        
            }else{
                Database.UpsertResult invColleague=CallToOLCTofetchActiveTr.createInvitedColleague(trialDetails.Source_System_Detail__c, cw.EmailId, cw.firstName, cw.lastName, cw.SAPContactId, trialID, true,null);
                invitedColleagueId=invColleague.getId();  
            }
            System.debug(LoggingLevel.INFO,'invitedColleagueId : ' +invitedColleagueId);
            Database.UpsertResult trial=CallToOLCTofetchActiveTr.createTrial(trialDetails.Trial_Id__c, cw.SAPContactId, trialDetails.Source_System_Detail__c, cw.EmailId, trialDetails.ODT_SAP_Account_Number__c,trialDetails.ODT_Product_Bundle__c, trialDetails.ODT_Trial_Product_Category__c,trialId,trialDetails.Lapsed_Reason_Code__c ,trialDetails.Is_Lapsed__c , trialDetails.Profile_Type__c, trialDetails.Profile_ID__c, trialDetails.SAP_Promotion_Code__c, false );
            reinitiatedTrialId=trial.getId(); 
            System.debug(LoggingLevel.INFO,'reinitiatedTrialId : '+reinitiatedTrialId); 
        }Catch(Exception e){
            System.debug(LoggingLevel.INFO,'Error'+e.getMessage());
            Database.rollback( sp ); 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
        }
    }
    
    /********************************************************************************************************
* getPrimaryUserForReinitiation: method to filter out the primary user from the list of OLCs
*********************************************************************************************************/    
    public void getPrimaryUserForReinitiation(LIST<contactsWrapper> listOfOLCs, string displayOLCNum){
        System.debug(LoggingLevel.INFO,'in getPrimaryUserForReinitiation'+listOfOLCs);
        
        for(contactsWrapper con : listOfOLCs){
            
            if(con.SAPContactId == displayOLCNum || displayOLCNum == con.SFDCContactIdwithZero){
                // primaryContasTodisplay.add(new contactsWrapper(con.firstName, con.lastName, con.appGUID, con.EmailId, con.SAPContactId, con.SFDCContactId, con.SAPAccountId, con.SFDCAccountId, con.SFDCContactIdwithZero));
                primaryContasTodisplay.add(con);
                System.debug(LoggingLevel.INFO,'primaryContasTodisplay'+primaryContasTodisplay);
            }
        }
        
    }
    
    
    public void getUserToAdd(LIST<contactsWrapper> listOfOLCs , Map<String,String> notDisplayOLCNum)
    {
        
        boolean flag;
        system.debug(LoggingLevel.INFO,'gfhdsghfgdshfghsdg'+notDisplayOLCNum);
        system.debug(LoggingLevel.INFO,'vvvvvvv'+listOfOLCs.size());
        for(contactsWrapper con : listOfOLCs){
            flag = false;
            system.debug(LoggingLevel.INFO,'sapp'+con.SAPContactId+'Not Display'+notDisplayOLCNum);
            if(notDisplayOLCNum.containsKey(con.SAPContactId)){
                // primaryContasTodisplay.add(new contactsWrapper(con.firstName, con.lastName, con.appGUID, con.EmailId, con.SAPContactId, con.SFDCContactId, con.SAPAccountId, con.SFDCAccountId, con.SFDCContactIdwithZero));
                
                flag= true;
                System.debug(LoggingLevel.INFO,'primaryContasTodisplayAdd'+allOtherOLCcontacts);
            }
            else{
                for(String s :notDisplayOLCNum.keySet() )
                {
                    
                    if(con.SAPContactId.endsWith(s))
                    {
                        flag=true;
                    }
                    
                }
            }
            
            if(!flag)
            {
                allOtherOLCcontacts.add(con);
                
            }
        }
        system.debug(LoggingLevel.INFO,'ccccccc'+allOtherOLCcontacts.size());
        
    }
    
    public void createIC() {
        system.debug(LoggingLevel.INFO,'selectedrecordssize'+selectedrecords.size());
        boolean flag=false;
        
        
        for(contactsWrapper cw : selectedrecords)
        {
            Invite_Colleagues__c ic =new Invite_Colleagues__c();
            if(trialDetails.Source_System_Detail__c != null ){ic.Source_System_Detail__c=trialDetails.Source_System_Detail__c;}
            
            
            ic.Email__c=cw.EmailId;
            ic.First_Name__c=cw.firstName;
            ic.Last_Name__c=cw.lastName;
            ic.SapContactId__c=cw.sapContactId;
            
            if(trialId != null ){
                ic.Trial__c=trialId;
            }
            ic.Primary_User__c=false;
            ic.Trial_Status__c='Rep Initiated';
            ic.Trial_Request_Date__c=System.today();
            ic.User_Auth_ID__c = cw.authUUID;
            
            invitedColleagues.add(ic);
            
            //Database.UpsertResult results=CallToOLCTofetchActiveTr.createInvitedColleague(trialDetails.Source_System_Detail__c, cw.EmailId, cw.firstName, cw.lastName, cw.SAPContactId, trialID, false,null);      
            
            //isAdded= true;
            
        }
        system.debug(LoggingLevel.INFO,'ICC '+invitedColleagues);
        
        List<Database.UpsertResult> results =  Database.upsert(invitedColleagues, false);
        
        system.debug(LoggingLevel.INFO,'Result '+results);
        for(Database.UpsertResult resu : results)
        {
            if(!resu.isSuccess())
            {
                flag=false;
                break;
            }
            else
            {
                flag=true;
            }
        } 
        
        if(flag)
        {
            isAdded= true;
            
            system.debug(LoggingLevel.INFO,'is Added user ' +isAddUser+' or NEW '+isNewAddUser);
            if(isAddUser){
                ODT_TrialReInitiate_AddUser_Callout ora = new ODT_TrialReInitiate_AddUser_Callout(trialID, false,true);
                
                System.enqueueJob(ora);
            }
            else if (isNewAddUser){
                ODT_TrialReInitiate_AddUser_Callout ora = new ODT_TrialReInitiate_AddUser_Callout(trialID, false,false);
                
                System.enqueueJob(ora);
            }
        }
        else
        {
            checkError=true;
            
        }
        
        
        //system.debug('Create Entitlement '+ODTCreateEntitlementService.createEntitlement(trialID));
        
    }
    
    // START of pagination
    public Boolean hasNext {
        get 
        {
            return allolcRecords.hasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {
        get 
        {
            return allolcRecords.hasPrevious();
        }
        set;
    }
    
    public void next() {
        system.debug(LoggingLevel.INFO,'before calling '+allOtherOLCcontactsPagination );
        allOtherOLCcontactsPagination = allolcRecords.next();
        system.debug(LoggingLevel.INFO,'after calling '+allOtherOLCcontactsPagination );
    }
    
    public void previous() {
        allOtherOLCcontactsPagination = allolcRecords.previous();
    }
    
    /********************************************************************************************************
* selectAll: Method for paginationa nd serach all functionality
*********************************************************************************************************/ 
    public void selectAll(){      
        
        
        if(!searchBool){ // pagination functionality Add All 
            
            if(selectedrecords.size() < addValues.maximum_records_to_add__c)
            {
                List<contactsWrapper> cww = new List<contactsWrapper>();
                for(contactsWrapper cw : allOtherOLCcontactsPagination)
                {
                    cww = selectAllMethodOne(cw,cww);                   
                    
                }
                
                integer sizeofSelectedRecords = selectedrecords.size();
                integer sizeofcww= cww.size();
                selectAllMethodTwo(sizeofSelectedRecords,sizeofcww,cww);
                
            }
            else{
                maxLengthReached = true;
                
            }
        }else if(searchBool){ // Search functionality Add All 
            
            if(selectedrecords.size() < addValues.maximum_records_to_add__c)
            {
                List<contactsWrapper> cww = new List<contactsWrapper>();
                for(contactsWrapper cw : searchResults)
                {
                    cww = selectAllMethodOne(cw,cww);
                    
                }
                
                integer sizeofSelectedRecords = selectedrecords.size();
                integer sizeofcww= cww.size();
                selectAllMethodTwo(sizeofSelectedRecords,sizeofcww,cww);
                
            }
            else{
                maxLengthReached = true;
                
            }
            
        }
        
    }
    
    /********************************************************************************************************
* selectAllMethodOne: Method branched from selectAll Method to fix PMD
*********************************************************************************************************/    
    private List<contactsWrapper> selectAllMethodOne(contactsWrapper cw,List<contactsWrapper> cww){
        if(cw.isSelected==false)
        {
            system.debug(LoggingLevel.INFO,'select all called');
            cww.add(cw);
        }
        return cww;
    }
    
    /********************************************************************************************************
* selectAllMethodTwo: Method branched from selectAll Method to fix PMD
*********************************************************************************************************/     
    private void selectAllMethodTwo(Integer sizeofSelectedRecords,Integer sizeofcww,List<contactsWrapper> cww){
        if((sizeofcww+sizeofSelectedRecords) <= addValues.maximum_records_to_add__c)
        {
            for(contactsWrapper cw : cww)
            {
                if(cw.isSelected==false)
                {
                    cw.isSelected = true ;
                    selectedrecords.add(cw);
                    selectAllMethodThree(cw);
                }
                
            }
            
        }
        else{
            maxLengthReached = true;
        }
    }
    
    /********************************************************************************************************
* selectAllMethodThree: Method branched from selectAll Method to fix PMD
*********************************************************************************************************/     
    private void selectAllMethodThree(contactsWrapper cw){
        if(cw.uniqueField!=null)
        {
            selectedrecordsMap.put(cw.uniqueField , cw);             
        }
    }
    
    /********************************************************************************************************
* deselectAll: Method for deselection of options in pagination and search all functionality
*********************************************************************************************************/    
    public void deselectAll(){
        
        if(!searchBool){
            for(contactsWrapper cw : allOtherOLCcontactsPagination)
            {
                deselectAllMethodOne(cw);
                
            } 
            selectedrecords = new List<contactsWrapper>();
            selectedrecords = selectedrecordsMap.values();
        }else if(searchBool){
            
            for(contactsWrapper cw : searchResults)
            {
                
                deselectAllMethodOne(cw);
            } 
            selectedrecords = new List<contactsWrapper>();
            selectedrecords = selectedrecordsMap.values();
            
        }    
    }
    
    /********************************************************************************************************
* deselectAllMethodOne: Method branched from deselectAll Method to fix PMD
*********************************************************************************************************/     
    private void deselectAllMethodOne(contactsWrapper cw){
        if(cw.uniqueField!=null && cw.isSelected && selectedrecordsMap.containsKey(cw.uniqueField))
        {
            selectedrecordsMap.remove(cw.uniqueField);
            cw.isSelected = false ;
        }
    }
    
    /********************************************************************************************************
* addSelected: Method for adding selected option
*********************************************************************************************************/  
    public void addSelected(){
        
        String sid=apexpages.currentpage().getparameters().get('sid');
        
        if(sid!=null && sid!=''){
            
            
            for(ContactsWrapper c: allOtherOLCcontactsPagination){
                System.debug(LoggingLevel.INFO,'selected'+c.isSelected + ' c.isSelected ' + selectedrecords.indexof(c));
                System.debug(LoggingLevel.INFO,'c id '+c.uniqueField+ ' '+ sid);
                addSelectedMethodOne(c,sid);                
                
            } 
            
        }
        
        system.debug(LoggingLevel.INFO,'size'+selectedrecords.size());
    }
    
    
    // End of pagination 
    
    /********************************************************************************************************
* addSelectedMethodOne: Method branched from addSelected Method to fix PMD
*********************************************************************************************************/ 
    private void addSelectedMethodOne(ContactsWrapper c, String sid){
        if(c.uniqueField==sid && c.isSelected){
            if(selectedrecords.size() < addValues.maximum_records_to_add__c)
            {
                selectedrecords.add(c);
                selectedrecordsMap.put(c.uniqueField,c);
                System.debug(LoggingLevel.INFO,'uniqueField'+c.uniqueField+ ' if  ' + selectedrecords.indexof(c)); 
            }
            else{
                c.isSelected = false;                      
                maxLengthReached = true;
            }                             
        }
        else if(c.uniqueField==sid && !c.isSelected){
            if(selectedrecords.indexof(c)!=-1){
                selectedrecords.remove(selectedrecords.indexof(c));
                addSelectedMethodTwo(c);
                
                System.debug(LoggingLevel.INFO,'uniquefield'+c.uniqueField+ ' else ' + selectedrecords.indexof(c));
            }
        }  
    }
    
    /********************************************************************************************************
* addSelectedMethodTwo: Method branched from addSelected Method to fix PMD
*********************************************************************************************************/
    private void addSelectedMethodTwo(ContactsWrapper c){
        if(selectedrecordsMap.containsKey(c.uniqueField))
        {
            selectedrecordsMap.remove(c.uniqueField);
        }
    }
    
    public void searchOnlineContacts(){
        searchResults    =  new LIST<ContactsWrapper>();
        searchBool = true;
        searchResultsbool = true;
        
        if(searchStr != null && searchStr  != ''){
            system.debug(LoggingLevel.INFO,'searchStr'+searchStr);  
            for(ContactsWrapper c: allOtherOLCcontacts){
                
                if(c.firstName != null && c.firstName != '' && c.firstName.containsIgnoreCase(searchStr)){
                    
                    searchResults.add(c);
                    continue;
                    
                }
                
                if(c.lastName.containsIgnoreCase(searchStr)  || c.EmailId.containsIgnoreCase(searchStr)){
                    searchResults.add(c);
                    
                }
                
            }
            system.debug(LoggingLevel.INFO,'searchResults..........'+searchResults);
        }else{
            searchBool = false;
            searchResultsbool = false;
            searchResults    =  new LIST<ContactsWrapper>();
            
        }
        
        system.debug(LoggingLevel.INFO,'allOtherOLCcontactsPagination..........'+allOtherOLCcontactsPagination);
    }
    
    
    public PageReference closeEloquaPopup(){
        PageReference myVFPage = new PageReference('/'+trialID);
        myVFPage.setRedirect(true);
        return myVFPage;
    }
    
    public void closeError()
    {
        maxLengthReached = false;
    }
    
    public void createUser(){
        if(selectedrecords.size() < addValues.maximum_records_to_add__c)
        {
            ContactsWrapper contact = new ContactsWrapper(null,null,null,null,null,null,null,null,null,true,true, null);
            contact.uniqueField = string.valueof(system.now());
            allOtherOLCcontactsPagination.add(contact);
        }
        else
        {
            maxLengthReached= true;
        }
        
    }
    
    public void addUser(){
        System.debug(LoggingLevel.INFO,'----Rajan-------Inside addUser------- ');
        string uniqueField= string.escapeSingleQuotes('uniqueField');
        String selUniField = (string)(string.escapeSingleQuotes(apexpages.currentpage().getparameters().get(uniqueField)));
        //System.debug('----Rajan-------selectedEmail------- ' + selectedEmail);
        for(ContactsWrapper contact : allOtherOLCcontactsPagination){
            if(contact.isNewContact && String.isNotBlank(selUniField) && contact.uniqueField.equalsIgnoreCase(selUniField)){
                if(String.isBlank(contact.firstName) || String.isBlank(contact.lastName) || String.isBlank(contact.EmailId)){
                    checkError = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'FirstName, LastName and Email is mandatory.'));
                    return;
                }
                if(!validateEmail(contact.EmailId)){
                    checkError = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Email format is not correct.'));
                    return;
                }
                contact.isSelected = true;
                //contact.uniqueField = string.valueof(system.now());
                contact.displayAddBtn = false;
                
                selectedrecords.add(contact);
                system.debug(LoggingLevel.INFO,'ghgh'+selectedrecords.size());
            }
        }
    }
    
    public Boolean validateEmail(String email) {
        Boolean isValid = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern emailPattern = Pattern.compile(emailRegex);
        Matcher emailMatcher = emailPattern.matcher(email);
        if(!emailMatcher.matches()){ 
            isValid = false;
        }
        
        boolean isValidCheckFromINC = ODTResendInviteINCCon.checkEmailValidation(email, trialDetails.ODT_Email__c, allINCEmails);
        
        return (isValid && isValidCheckFromINC); 
    }
    
    global class ContactsWrapper{
        public string firstName{get; set;}
        public string lastName{get; set;}
        public string appGUID{get; set;}
        public string emailId{get; set;}
        public string sAPContactId{get; set;}
        public string sFDCContactId{get; set;}
        public string sAPAccountId{get; set;}
        public string sFDCAccountId{get; set;}
        public string sFDCContactIdwithZero{get; set;}
        
        public boolean isSelected{get;set;}
        public string uniqueField{get;set;}
        
        public boolean isNewContact{get;set;}
        public boolean displayAddBtn{get;set;}
        
        public string authUUID{get; set;}
        
        public contactsWrapper(string fname, string lname, string apguid, string email, string sAPConId, string sFDCconid, string sAPAccId, string sFDCaccid, string sapCNumZeros,boolean isNewCon ,boolean disAddBtn, string authuId ){
            firstName = fname; 
            lastName = lname;
            appGUID = apguid;
            EmailId = email;
            SAPContactId = SAPconId;
            SFDCContactId = SFDCconId;
            SAPAccountId = SAPAccId;
            SFDCAccountId = SFDCaccid ;
            SFDCContactIdwithZero = sapCNumZeros;
            authUUID = authuId;
            
            isSelected=false;
            uniqueField=SAPconId;
            isNewContact = isNewCon;
            displayAddBtn = disAddBtn;
            if(test.isrunningtest())
            {
                isSelected=true;
            }
        }
    }
}