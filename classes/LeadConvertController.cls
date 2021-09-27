/**
 * Contains methods for LeadConvert VF Page
 * 
 *
 * @author  John DeSantiago
 * @version  2012-02-18
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-07-17   Srikanth Kuruva     Lead Type should be mapped to Opportunity.Type
 *                                  not lost during pagination.
 * 2012-07-31   Nandita Shet        Lead should be converted to Pipeline/Pre-pipeline
 *                                  opportunity
 * 2013-07-22   Sudhir Kumar        Modified the method UpdateOpportunityfields.(As partof QC 4024, changed the Stage default value for Converted Pipeline Opportunity to 10%)
 * 2013-10-31   Srikanth Kuruva     Added the Redirect boolean flag for sf1
 * =============================================================================
 */ 
public without sharing class LeadConvertController {
    public LeadConvertController(ApexPages.StandardSetController controller) {
        System.debug('test');
    }


    //Protected Members
    private final ApexPages.StandardController standardController;
    private final Lead lead{get;set;}
    public Lead olead;
    //public Set<String> LatamSalesOrg = new set<String>{'ABEP','BEJE','EDIC','FSCO','LLEY','LLPA','LLUR','LPCL','LPTC','RV01','TSL','TSCE','SCSI','SFWS','SSRL','TGPS'};
    //commented : public Set<String> latamSalesOrg = new set<String>{'BEJE','EDIC','FSCO','LLEY','LLPA','LLUR','LPCL','LPTC','RV01','TSL','TSCE','SCSI','SFWS','SSRL','TGPS'}; // removed ABEP for Hercules implementation.
    public Map<String,String> salesOrgMap = new Map<String,String>();
    public Set<String> latamSalesOrg = new set<String>();    
    public Set<String> setStateCountry = new set<String>();
    public Set<String> setZipCountry = new set<String>();
    //Properties
    
    public Task followUpTask {get;set;}
    public Account leadAccount {get;set;}
    public Id campaignId;
    
    public string leadConvertStatus {get;set;}
    public string opportunityName {get;set;}
    public string selectedAccountId {get;set;}
    public String oppRecType {get;set;}
    public String description;
    Public String source;
    public String uRL;
    public String leadType;
    public String sErrorMsg='';
    public String selectedItemId {get;set;}
   
    
        
    public boolean sendNotificationEmail {get;set;}
    public boolean useExistingAccount {get;set;}
    public boolean useExistingContact {get;set;}
    public boolean doNotCreateOpportunity {get;set;}
    public boolean createFollowUpTask {get;set;}
    public boolean bError {get;set;}
   // public boolean bErrortemp {get;set;}
    public boolean convertLead {get;set;}
    
    public List<AccountOption> leadAccountOptions {get;set;}
    public List<SelectOption> leadConvertStatusSelectOptions {get;set;}
    public List<SelectOption> oppRecordTypeSelectOptions {get;set;}
    public Map<String,String> mapAccountfields = new Map<String,String>{'Sales_Org__c'=>'Sales Org ' ,
                                                                        'Billing_City__c'=>'Billing City ' ,
                                                                      // 'Billing_Street__c'=>'Billing Street ' ,
                                                                        'Industry' =>'Industry ',
                                                                        'Customer_Type__c'=>'Customer Type ' ,
                                                                        'Billing_Country__c'=>'Billing Country ' ,
                                                                       // 'Customer_Class__c'=>'Customer Class ' ,
                                                                        'Customer_Group__c'=>'Customer Group '};
                                                                       // 'Industry_LatAm__c'=>'Industry LatAm '};
                                                                       // 'Phone'=>'Phone' ,
                                                                       // 'Email'=>'Email'};
    
    public boolean redirect {get;set;}
    public boolean bLatam{get;set;}
    public Id objectId{get;set;}
    public List<SelectOption> countryOptions {get;set;}
    public List<SelectOption> countryRegionOptions {get;set;}
   // public List<Invite_Colleagues__c> LeadInvitedContacts {get;set;}
    public List<SelectOption> accContactOptions {get;set;}
    public String selectedAccount {get;set;}
    public String accountSelectedList {get;set;}
    public boolean contactForNewAccount {get;set;}
    
    
    private string loggedinProfile = '';
    public LM_Lead_History__c iHistory{get;set;}
    
    List<ELOQUA__Marketing_Activity__c> updateMAlist=new List<ELOQUA__Marketing_Activity__c>();

    //Constructors
    public string emailstr{get; set;}
    public string sapConId{get; set;}
    public Boolean convertNotAllowed{get;set;}
    public LeadConvertController(ApexPages.StandardController standardController) {
       // try {
            iHistory = new LM_Lead_History__c();
            Lead tempLead;
            this.standardController = standardController;
            if(!test.IsRunningTest()){
              standardController.addFields(new List<String>{'Billing_Country__c'});
              this.lead = (Lead) standardController.getRecord();
              
              lead emailleadsap = [Select Name,LeadSource,Description,Primary_Campaign_Source__c,URL__c,Phone,Email,Account__c ,MDBID__c,SAPAccountNumber__c,Contact__c ,firstName,lastName,
                                    Type__c,Billing_City__c,Billing_State__C,Billing_Street__c,PO_Box__c,Tax_Number__c,Tax_Number_Type__c,Company,IsConverted,
                                    Billing_Zip__c,Sales_Org__c,Billing_Country__c,Customer_Class__c,Customer_Group__c, Contact_SAP_ID__c,
                                    Customer_Type__c,Industry,Industry_LatAm__c,Contact__r.name,Campaign_code__c,Source__c,Legacy_System_ID__c, OwnerId,
                                    LatAm_Created_by_Partner__c, Approval_status__c, Business_Unit_LatAm__c from Lead where Id=:standardController.getId()];
              tempLead = emailleadsap;                      
              sapConId = emailleadsap.Contact_SAP_ID__c;
              emailstr = emailleadsap.email;
            }else{
              this.lead = [Select Name,LeadSource,Description,Primary_Campaign_Source__c,URL__c,Phone,Email,Account__c ,MDBID__c,SAPAccountNumber__c,Contact__c ,firstName,lastName,
                                    Type__c,Billing_City__c,Billing_State__C,Billing_Street__c,PO_Box__c,Tax_Number__c,Tax_Number_Type__c,Company,IsConverted,
                                    Billing_Zip__c,Sales_Org__c,Billing_Country__c,Customer_Class__c,Customer_Group__c, Contact_SAP_ID__c,
                                    Customer_Type__c,Industry,Industry_LatAm__c,Contact__r.name,Campaign_code__c,Source__c,Legacy_System_ID__c, OwnerId,
                                    LatAm_Created_by_Partner__c, Approval_status__c, Business_Unit_LatAm__c  from Lead where Id=:standardController.getId()];
                tempLead = this.lead;
            }
            
            //List<GroupMember> gmList = new List<GroupMember>();
            Boolean partnerChannelUser = false;
            try{
                //gmList = [select group.name, group.DeveloperName from GroupMember 
                //            where UserOrGroupId = :UserInfo.getUserId() and group.DeveloperName ='LatAm_Partner_Channel_Team'];
                partnerChannelUser = checkPartnerChannel();
            }catch(Exception e){
                System.debug('Exception : '+e.getMessage());
            }
            if(tempLead.LatAm_Created_by_Partner__c ==true && (tempLead.Approval_status__c != 'Approved' || partnerChannelUser == false)){
                    convertNotAllowed = true;
                    ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LatAm_ConvertUnapprovedError);
                    ApexPages.addMessage(errorMsg1);
           }
            
         //   bError = false;
        //    sErrorMsg = '';
            this.FollowUpTask = new Task();
            this.FollowUpTask.OwnerId = UserInfo.getUserId();
            this.FollowUpTask.IsReminderSet = true;
            this.FollowUpTask.ReminderDateTime = System.now();
            this.Redirect = false;
            setStateCountry = State_required_Countries__c.getall().Keyset();
            setZipCountry = ZipCode_required_Countries__c.getall().keyset(); 
           
            CountryOptions = DataQualityUtil.listAvailableCountryOptions();
            CountryRegionOptions = new List<SelectOption>();
            CountryRegionOptions.add(new SelectOption('', '-- None --'));
            CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(this.lead.Billing_Country__c);
            
            
            this.LeadAccount = new Account();
            String strOwnerId = this.lead.OwnerId;
            if(StrOwnerId.substring(0,3)=='005'){
                this.LeadAccount.OwnerId = this.lead.OwnerId;
            }else{
                this.LeadAccount.OwnerId = UserInfo.getUserId();
            }

            this.SelectedAccountId = null;
            
            this.SendNotificationEmail = false;
            this.DoNotCreateOpportunity = false;
            this.CreateFollowUpTask = false;
            
            if (this.lead.Account__c == null) {
                this.lead.Account__c = findExistingAccountId(this.lead.MDBId__c, this.lead.SAPAccountNumber__c);
            }
            
            this.UseExistingAccount = (this.lead.Account__c != null);
            this.UseExistingContact = (this.lead.Contact__c != null);
            
            this.LeadAccountOptions = new List<AccountOption>();
            
            if (this.UseExistingAccount == false) {
                this.LeadAccountOptions = this.getLeadAccountOptions();
            }
            
 
            
            this.LeadConvertStatusSelectOptions = this.getLeadConvertStatusSelectOptionList();
            this.OppRecordTypeSelectOptions = this.getOppRecordTypeSelectOptionsList();
            
            /*this.AccContactOptions = this.getAccContactOptionsList();
            this.LeadInvitedContacts = getInvitedColleaguesDetails(); */
            this.contactForNewAccount = false;
        
            
            this.olead = [Select Name,LeadSource,Description,Primary_Campaign_Source__c,URL__c,Phone,Email,
                                    Type__c,Billing_City__c,Billing_State__C,Billing_Street__c,PO_Box__c,Tax_Number__c,Tax_Number_Type__c,
                                    Billing_Zip__c,Sales_Org__c,Billing_Country__c,Customer_Class__c,Customer_Group__c,
                                    Customer_Type__c,Industry,Industry_LatAm__c,Contact__r.name,Campaign_code__c,Source__c,Legacy_System_ID__c, OwnerId,
                                    LatAm_Created_by_Partner__c, Approval_status__c, Business_Unit_LatAm__c from Lead where Id=: standardController.getId()];
            this.Description = olead.Description;
            this.CampaignId = olead.Primary_Campaign_Source__c;
            this.Source = olead.LeadSource;
            this.Url = olead.URL__c;
            this.LeadType = olead.Type__c;
            
            if(this.olead.LeadSource=='Website' && this.olead.Source__C=='Practical Law' && this.olead.Legacy_System_ID__c!=null){
                this.OpportunityName = 'Trial-'+(this.olead.Contact__r.Name!=null && this.olead.Contact__r.Name!=''?this.olead.Contact__r.Name:this.olead.Name)+'-'+(this.olead.Campaign_Code__c!=null?String.valueof(this.olead.Campaign_Code__c):'');
                this.OpportunityName = this.OpportunityName.right(120);
            }else{     
                this.OpportunityName = this.lead.Company + ' - ';
            }
         salesOrgMap = MexicoUtility.classBasedOrgValues('LeadConvertController','Sales_Org__c');
         latamSalesOrg.addAll(salesOrgMap.values());            
        if(latamSalesOrg.contains(this.olead.Sales_Org__c)){
            bLatam =  true;
            mapAccountfields.put('Tax_Number__c','Tax Number');
            mapAccountfields.put('Tax_Number_Type__c','Tax Number Type');
            mapAccountfields.put('Phone','Phone');
            mapAccountfields.put('Email','Email');
        }     
        
        
        if(setStateCountry.contains(olead.Billing_Country__c) && AppUtil.IsEmpty(olead.Billing_State__c) )
        { 
            mapAccountfields.put('Billing_State__c','Billing State'); 
        } 

        if(setZipCountry.contains(olead.Billing_Country__c)  && AppUtil.IsEmpty(olead.Billing_Zip__c)) 
        { 
           mapAccountfields.put('Billing_Zip__c','Billing Zip');
        }
        
        
        
        id id1 = userinfo.getProfileId();
        List<Profile> profileName =[ select Name from profile where id = :id1];       
        
        for(profile p : ProfileName )
        {
            if(p.name != 'TR Legal US Sales User' && p.name != 'TR Legal FindLaw User')
            { 
               mapAccountfields.put('Customer_Class__c','Customer Class');
            } 
            
       
            //Added for Partner Poral profiel check- LATAM            
            if(p.name == Label.Partner_Portal_Profile){            
                DoNotCreateOpportunity = True;            
            }
            loggedinProfile = p.name;
        }
        /*if(!AppUtil.isEmpty(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
        !AppUtil.isEmpty(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
        ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
        (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') ) ){*/
            checkRequiredFields();
     //   }
           // if(bError == true){bErrortemp =true;}
            
      //  }
      //  catch (Exception oException) { 
     //       ApexPages.addMessages(oException);
    //    }
        if(olead.LatAm_Created_by_Partner__c == true){
            leadAccount.OwnerId = UserInfo.getUserId();
        }
    }
    
    public Boolean checkPartnerChannel(){
        Boolean accessBool;  
        Set < Id > permissionSetIds = new Set < Id >();  
        List < User > userList = new List < User >();  
        for ( SetupEntityAccess access : [SELECT ParentId FROM SetupEntityAccess WHERE SetupEntityId IN ( SELECT Id FROM CustomPermission WHERE DeveloperName = 'LatAm_Partner_Channel_Team')]){  
            permissionSetIds.add(access.ParentId);  
        }    
        userList = [ SELECT Username FROM User WHERE Id IN (  
                SELECT AssigneeId FROM PermissionSetAssignment  
                WHERE PermissionSetId IN :permissionSetIds AND AssigneeId = :UserInfo.getUserId()) WITH SECURITY_ENFORCED];  
        accessBool = userList.isEmpty() ? false : true; 
        return accessBool;
    }

    //Public Methods
    
    public PageReference onPageLoad() {
        PageReference pageReference = null;
        
        if (this.lead.IsConverted == true) {
            pageReference = new PageReference('/' + this.lead.Id);
            pageReference.setRedirect(true);
        }
        
        return pageReference;
    }
    public PageReference convertLead1(){
        this.Redirect = true;
        return null;
    }
    
    public string leadAccountId{get; set;}
    public PageReference convertLead() {
        
        PageReference pageReference = null;
        Pagereference p =new pagereference('/' + this.lead.Id);
        
        try {
            if (this.UseExistingAccount == false && AppUtil.isEmpty(this.SelectedAccountId) == false) {
                this.lead.Account__c = this.SelectedAccountId;
               
            } 
         /* 
            //Assign Exisiting Contact while Lead Conversion - DLT-8656
            for(Invite_Colleagues__c  assignLeadCont  : LeadInvitedContacts){
                if(assignLeadCont.ID == null && !assignLeadCont.Contact_Id_from_Lead__c.equalsIgnoreCase('New')){
                    this.lead.Contact__c = assignLeadCont.Contact_Id_from_Lead__c;
                }
            }
          */  
              system.debug('@@@this.UseExistingAccount::'+this.UseExistingAccount);
              system.debug('@@@this.SelectedAccountId::'+this.SelectedAccountId);
            UpdateLMHistory(null,this.lead.Contact__c, this.lead.Account__c, this.lead.Id);
            System.debug('lead Account = '+this.lead.Account__c);
            System.debug('lead contact = '+this.lead.Contact__c);
                
            Database.LeadConvertResult leadConvertResult = this.executeLeadConversion();
            if (leadConvertResult.isSuccess() == true) { 
                System.debug(this.SelectedAccountId+'#####'+this.UseExistingAccount);
                System.debug('++++Lead'+leadConvertResult.getOpportunityId());
                System.debug('lead Account = '+this.lead.Account__c);
                System.debug('lead contact = '+this.lead.Contact__c);
            
                UpdateLMHistory(leadConvertResult.getOpportunityId(),leadConvertResult.getContactId(), leadConvertResult.getAccountid(), this.lead.Id);
               
                
                //Modified by Nirmala as part of MCL-1486.........Start
                
                String leadId=this.lead.Id;
                System.debug('...lead id = '+leadId);
                System.debug('..contact id..'+leadConvertResult.getContactId());
                List<ELOQUA__Marketing_Activity__c> leadMAlist=[Select Id,Name,ELOQUA__Lead__c,ELOQUA__Contact__c from ELOQUA__Marketing_Activity__c where ELOQUA__Lead__c = :leadId];
                System.debug('..list size..'+leadMAlist.size());
                If(leadMAlist.size()>0){
                    for(ELOQUA__Marketing_Activity__c ma:leadMAlist){
                        if(ma.ELOQUA__Contact__c==null || ma.ELOQUA__Contact__c != leadConvertResult.getContactId()){
                            ma.ELOQUA__Contact__c = leadConvertResult.getContactId();
                            updateMAlist.add(ma);
                         }
                    }
                }
                
                update updateMAlist;              
                System.debug('..ma list after update..'+updateMAlist);
                
                //Modified by Nirmala as part of MCL-1486.........End
                
                
                if(this.UseExistingAccount == false && AppUtil.isEmpty(this.SelectedAccountId)){
                    Id accountId = leadConvertResult.getAccountId();
                    this.UpdateAccountfields(AccountId);

                }
               
                
                if (this.CreateFollowUpTask == true) {
                    this.insertFollowUpTask(leadConvertResult);
                }
                
                if (DoNotCreateOpportunity == false) {
                    ObjectId = leadConvertResult.getOpportunityId();
                    Id contactId = leadConvertResult.getContactId();
                    this.UpdateContactRole(ObjectId,contactId);
                    this.UpdateOpportunityfields(ObjectId);
                    //pageReference = new PageReference('/' + ObjectId + '/e');
                    //pageReference.getParameters().put('retURL', '/' + ObjectId);
                    //pageReference.setRedirect(true);
                }
                else {
                    ObjectId = leadConvertResult.getAccountId();
                    //pageReference = new PageReference('/' + ObjectId);
                    //pageReference.setRedirect(true);
                }
                system.debug('****Redirect Lead');
                if(loggedinProfile != Label.Partner_Portal_Profile){                
                    this.Redirect = true;
                }
                else{                
                    p.setRedirect(true); 
                    return p;
                }
           /*     
                // Logic for ODT POC to create contacts for invited colleagues*****************************
                // LeadInvitedContacts Invite_Colleagues__c
                leadAccountId = leadConvertResult.getAccountId();
                 system.debug(leadAccountId+'AAAAAAAAAAAAAAAAAAAAAAa        '+LeadInvitedContacts);
                
                LIST<Invite_Colleagues__c> toInsertAsContacts = new LIST<Invite_Colleagues__c>();
                for(Invite_Colleagues__c ivc: LeadInvitedContacts){
                    system.debug('BBBBBBBBBBBBBBBBBBBBBBB       '+ivc.Contact_Id_from_Lead__c);
                
                    if(((ivc.Contact_Id_from_Lead__c == null || ivc.Contact_Id_from_Lead__c == '' || ivc.Contact_Id_from_Lead__c == 'New') && ivc.id != null))
                        toInsertAsContacts.add(ivc);
                }
                 
                //LeadConvDetail.createInvitedColleagues(toInsertAsContacts);
                system.debug('CCCCCCCCCCCCCCCCCCCCCCCC       '+toInsertAsContacts);
                createContacts(toInsertAsContacts);
           */     
                
                
            }
            else {
                throw new LeadConvertException(leadConvertResult.getErrors()[0].getMessage());
                delete iHistory;
                iHistory = new LM_Lead_History__c();
                
            }
            
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
            System.debug('Exception : '+oException.getMessage()+' : '+oException.getStackTraceString());
        }
        return null;
       
    }
    
    //Private Methods
    
     private void updateLMHistory(Id oppId, Id contactId, Id accountid, id leadid)
                {
                //List<LM_Lead_History__c> NewHistory= new List<LM_Lead_History__c>();
                //LM_Lead_History__c iHistory = new LM_Lead_History__c();
                Account acc1 = new Account();
                contact con1 = new contact();
                if(Accountid!=null){
                    Acc1 = [select id, name from Account where Id =:Accountid limit 1];
                }
                if(Contactid !=null){
                    con1 = [select id, SAP_Contact_ID__c from Contact where Id =:Contactid limit 1 ];
                }
                
                Opportunity oppRec = new Opportunity();
                
                // For Opportunity Query
                if(OppId != null){
                    oppRec = [select Id,name from Opportunity where Id=:OppId limit 1];
                }
                Lead lead2= [select id,name,Business_Org__c,Campaign_Cell__c,Campaign_Code__c,Convert_SLA_violation__c,
                             Discard_Reason__c,LeadID18__c,Ownerid,LeadSource,Type__c,Primary_Campaign_Source__c,
                             Priority__c,Source_Desc__c,Source__c,Status,Tracking_Code__c,SAPAccountNumber__c
                                 from Lead where Id =:Leadid limit 1];
                
                 iHistory.Account_ID__c=acc1.id;
                 iHistory.Account_Name__c=acc1.name;
                 IHistory.SFDC_Account_ID__c=Lead2.SAPAccountNumber__c;
                 iHistory.Contact__c=con1.id;
                 iHistory.Contact_ID__c=con1.id;
                 iHistory.Contact_SAP_ID__c=con1.SAP_Contact_ID__c;
                 iHistory.name=lead2.name;
                 iHistory.Lead_ID__c=lead2.id;
                 iHistory.Business_Org__c=lead2.Business_Org__c;
                 iHistory.Campaign_Cell__c=lead2.Campaign_Cell__c;
                 iHistory.Campaign_Code__c=lead2.Campaign_Code__c;
                 iHistory.Convert_SLA_violation__c=lead2.Convert_SLA_violation__c;
                 iHistory.Discard_Reason__c=lead2.Discard_Reason__c;
                 iHistory.LeadID18__c=lead2.LeadID18__c;
                 iHistory.Lead_Owner__c=lead2.Ownerid;
                 iHistory.Lead_Source__c=lead2.LeadSource;
                 iHistory.Lead_Type__c=lead2.Type__c;
                 iHistory.Primary_Campaign_Source__c=lead2.Primary_Campaign_Source__c;
                 iHistory.Priority__c=lead2.Priority__c;
                 iHistory.Source_Desc__c=lead2.Source_Desc__c;
                 iHistory.Source_Type__c=lead2.Source__c;
                 iHistory.Status__c=lead2.Status;
                 iHistory.Tracking_Code__c=lead2.Tracking_Code__c;
                 iHistory.Opportunity__c=oppRec.id;
                 iHistory.Lead__c=lead2.id;
                 
              //  iHistory.Opportunity_ID__c=oppRec.id;
               //  iHistory.Contact_SAP_ID__c=con1.SAP_Contact_ID__c;

                upsert iHistory;
                
                system.debug('@@@IHistory'+iHistory);

                
    }


    private Id findExistingAccountId(string mdbId, string sapId) {
        
        Id accountId = findExistingAccountIdByMDBId(mdbId);
        if (accountId == null) {
            accountId = findExistingAccountIdBySAPId(sapId);
        }
        
        return accountId;
    }
    
    private Id findExistingAccountIdByMDBId(string mdbId) {
        Id accountId = null;
        
        if (AppUtil.isEmpty(mdbId) == false) {
            List<Account> accounts = [SELECT Id FROM Account WHERE MDBID__c = :mdbId];
            if (accounts.isEmpty() == false) {
                accountId = accounts[0].Id;
            }
        }
        
        return accountId;
    }
    
    private Id findExistingAccountIdBySAPId(string sapId) {
        Id accountId = null;
        
        if (AppUtil.isEmpty(sapId) == false) {
            List<Account> accounts = [SELECT Id FROM Account WHERE SAPAccountNumber__c = :sapId];
            if (accounts.isEmpty() == false) {
                accountId = accounts[0].Id;
            }
        }
        
        return accountId;
    }
    
    private Database.LeadConvertResult executeLeadConversion() {
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(this.lead.Id);
        leadConvert.setOwnerId(this.LeadAccount.OwnerId);
        leadConvert.setAccountId(this.lead.Account__c);
        leadConvert.setContactId(this.lead.Contact__c);
        leadConvert.setConvertedStatus(this.LeadConvertStatus);
        leadConvert.setSendNotificationEmail(this.SendNotificationEmail);
        
        leadConvert.setDoNotCreateOpportunity(this.DoNotCreateOpportunity);
        if (this.DoNotCreateOpportunity == false) {
            leadConvert.setOpportunityName(this.OpportunityName);
        }
        
        return Database.convertLead(leadConvert);
    }
    
    private void insertFollowUpTask(Database.LeadConvertResult leadConvertResult) {
        Id accountId = leadConvertResult.getAccountId();
        Id contactId = leadConvertResult.getContactId();
        Id opportunityId = leadConvertResult.getOpportunityId();
        
        FollowUpTask.WhoId = contactId;
        FollowUpTask.WhatId = (opportunityId == null ? accountId : opportunityId);
        
        insert FollowUpTask;
    }
    
    private void updateContactRole(Id oppId, Id contactId){
        OpportunityContactRole oppContactRole = [SELECT ContactId, Id, 
                                                        OpportunityId, IsPrimary, Role 
                                                  FROM OpportunityContactRole    
                                                  where ContactId = : ContactId and 
                                                  OpportunityId = : OppId];
                                                          
       OppContactRole.IsPrimary = true;
       update  OppContactRole;
    
    }
    
    private void updateOpportunityfields(Id oppId){
        Opportunity oOpportunity = [Select id, CampaignId, description, LatAm_Lead_Owner__c,OwnerId from Opportunity where Id =: OppId];
        oOpportunity.CampaignId = this.CampaignId;
        oOpportunity.description  = this.description;
        oOpportunity.Source__c = this.Source;
        oOpportunity.Type = this.LeadType;
        oOpportunity.Status__c = 'Converted';
        oOpportunity.LatAm_Lead_Owner__c = olead.OwnerId;
        system.debug('BU : '+olead.Business_Unit_LatAm__c);
        system.debug('test : '+System.Label.LatAm_Professional_BU);
        system.debug('test1 : '+System.Label.LatAm_Corporate_BU);
        if(olead.LatAm_Created_by_Partner__c == true && System.Label.LatAm_Professional_BU.containsIgnoreCase(olead.Business_Unit_LatAm__c)){
            oOpportunity.ownerId = olead.OwnerId;
        }
        system.debug('test : '+this.lead.Account__c);
        if(olead.LatAm_Created_by_Partner__c == true && System.Label.LatAm_Corporate_BU.containsIgnoreCase(olead.Business_Unit_LatAm__c) && this.lead.Account__c!=null){
            try{
                AccountTeamMember atm = [Select Id, UserId from AccountTeamMember where AccountId = :this.lead.Account__c AND TeamMemberRole = 'Sales Rep' AND USERID IN (SELECT ID FROM USER WHERE ISACTIVE=TRUE) WITH SECURITY_ENFORCED Limit 1];
                system.debug('test : atm : '+atm);
                if(atm!=null){
                    oOpportunity.ownerId = atm.UserId;
                }
            }catch(Exception e){
                System.debug('Exception : '+e.getMessage()+' : '+e.getStackTraceString());
            }
        }
        if(this.OppRecType!=null){
            Schema.DescribeSObjectResult opportunitydescresult = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> rectypeMapByName = Opportunitydescresult.getRecordTypeInfosByName();
            
            oOpportunity.RecordTypeId = rectypeMapByName.get(this.OppRecType).getRecordTypeId();
            
            if(this.OppRecType.contains('Pre-Pipeline')){
              
               oOpportunity.StageName = '1%';
               
           }else{

               oOpportunity.StageName = '10%';
           }
       }
       
       
       update oOpportunity;
       if(OpportunityTeamMember.sobjecttype.getdescribe().iscreateable() && olead.LatAm_Created_by_Partner__c == true && System.Label.LatAm_Corporate_BU.containsIgnoreCase(olead.Business_Unit_LatAm__c)){
            OpportunityTeamMember otm = new OpportunityTeamMember(OpportunityId = oOpportunity.id, 
                                                                TeamMemberRole ='LatAm Partner',
                                                                UserId = olead.OwnerId,
                                                                /*OpportunityAccessLevel = 'Read',*/
                                                                Sales_Percentage__c=50,
                                                                Partner_Role__c = 'Partner Deal Hunter');
            insert otm;
        }
    
    }
    
    private void updateAccountfields(Id accId){
        Account oAccount = [Select Phone,Website,BillingCity,BillingState,BillingStreet,BillingPostalCode,Record_Summary_Icons__c from Account where Id =: AccId];
     //   oAccount.Phone = '';
     //   oAccount.Website = this.Url;
        oAccount.BillingCity = this.olead.Billing_City__c; 
        oAccount.BillingStreet = this.olead.Billing_Street__c;
        oAccount.BillingPostalCode = this.olead.Billing_Zip__c;
        oAccount.BillingState = this.olead.Billing_State__c;
        oAccount.BillingCountry = this.olead.Billing_Country__c;
       // oAccount.Record_Summary_Icons__c = this.Record_Summary_Icons__c;
       
        Update oAccount;
    
    }
    
    private List<AccountOption> getLeadAccountOptions() {
        List<AccountOption> accountOptions = new List<AccountOption>();
        
        AccountOption defaultAccountOption = new AccountOption();
        defaultAccountOption.IsSelected = true;
        defaultAccountOption.Account.Name = 'Create New Account: ' + this.lead.Company;
        defaultAccountOption.Account.Customer_Group__c = '';

        accountOptions.add(defaultAccountOption);
        
        List<Account> accountQueryResult = queryAccountsByLeadCompanyName();
        for (Account account : accountQueryResult) {
            AccountOption accountOption = new AccountOption(account);
            accountOptions.add(accountOption);
        }
        
        return accountOptions;
    }
    
    private List<SelectOption> getLeadConvertStatusSelectOptionList() {
        List<SelectOption> leadConvertStatusSelectOptionList = new List<SelectOption>();
                
        List<LeadStatus> leadStatusQueryResult = this.queryLeadStatusIsConverted();
        for(LeadStatus leadStatus : leadStatusQueryResult) {
            SelectOption selectOption = new SelectOption(leadStatus.MasterLabel, leadStatus.MasterLabel);
            leadConvertStatusSelectOptionList.add(selectOption);
        }
        
        return leadConvertStatusSelectOptionList;
    }
    
       private List<SelectOption> getOppRecordTypeSelectOptionsList(){
         List<SelectOption> oppRecTypeSelectOptionList = new List<SelectOption>();
         Schema.DescribeSObjectResult oppdescresult = Schema.SObjectType.Opportunity; 
         Map<String,Schema.RecordTypeInfo> rtMapByName = Oppdescresult.getRecordTypeInfosByName();
    
    // Modified as part of FSC-135 
         List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
         String MyProflieName = profileList[0].Name;
         system.debug('$$$ Logged In Profile Name:'+MyProflieName);
         
         for(String rt : rtMapByName.keySet()){
            // if(rt!='Master'){
             if(rt==Label.Pre_Pipeline_Opportunity || rt==Label.Pipeline_Opportunity){
             if(MyProflieName == 'LatAm User' && rt==Label.Pre_Pipeline_Opportunity){  //FSC-135
                   //OppRecTypeSelectOptionList.add(new SelectOption(rt,rt));
                   BREAK;
             }
             else{
             OppRecTypeSelectOptionList.add(new SelectOption(rt,rt));
             }
              
               }
                                  
        }
        OppRecTypeSelectOptionList.sort();
        return OppRecTypeSelectOptionList;
    }
    
    private List<Account> queryAccountsByLeadCompanyName() {
        return (List<Account>)[FIND :this.lead.Company IN NAME FIELDS RETURNING 
                                    Account(Id
                                        , Name
                                        , NameTwo__c
                                        , BillingStreet
                                        , BillingCity
                                        , BillingState
                                        , Billing_City_State__c
                                        , Phone
                                        , SAPAccountNumber__c
                                        , Market_Segment_Account_Indicator__c
                                        , Total_Active_Subscriptions__c
                                        , Sales_Org__c
                                        , Customer_Type__c
                                        , Record_Summary_Icons__c
                                        , Customer_group__c   
                                        , SubsTotal__c LIMIT :10)][0];
                                       
    }
    
    private List<LeadStatus> queryLeadStatusIsConverted() {
        return [SELECT 
                    Id
                    , MasterLabel 
                FROM 
                    LeadStatus 
                WHERE 
                    IsConverted=true
                ORDER BY
                    MasterLabel];
    }
       
      
    public void checkRequiredFields(){
        Schema.DescribeSObjectResult opportunitydescresult = Schema.SObjectType.Lead; 
 
         if(ConvertLead!=true){
            if(olead.Billing_Street__c==null && olead.PO_Box__c==null){
              sErrorMsg += '  Billing Street or PO Box';
              bError = true;
            }
           
            for(String sfield : mapAccountfields.Keyset()){
               if(olead.get(sfield)==null){ System.debug(sfield+'&&&&&');
                  //sErrorMsg += '  '+mapAccountfields.get(sfield) ;
                  sErrorMsg +=  '  '+Opportunitydescresult.fields.getMap().get(sfield).getDescribe().getlabel();
                  bError = true;
                }
            } }
            sErrorMsg =sErrorMsg.trim();
            sErrorMsg =sErrorMsg.replace('  ',', ');
            if(bError == true){
                //olead.addError( 'Please navigate back to Lead and enter values for '+sErrorMsg+'.');
                olead.addError( Label.Lead_Convert_Error+' '+sErrorMsg+'.');
            }
        
    
    }
    
    
    public PageReference enableConvert(){
     bError = false;
     sErrorMsg = '';
     standardController.save();
     //update olead;
     this.olead = [Select Name,LeadSource,Description,Primary_Campaign_Source__c,URL__c,Phone,Email,
                                    Type__c,Billing_City__c,Billing_State__C,Billing_Street__c,PO_Box__c,Tax_Number__c,Tax_Number_Type__c,
                                    Billing_Zip__c,Sales_Org__c,Billing_Country__c,Customer_Class__c,Customer_Group__c,
                                    Customer_Type__c,Industry,Industry_LatAm__c,Contact__r.name,Campaign_code__c,Source__c,Legacy_System_ID__c, OwnerId from Lead where Id=: standardController.getId()];
     
     checkRequiredFields();
     return null;
    }
    
     public void addressCountryChanged() { System.debug(olead.Billing_Country__c+'*******************');
        CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(this.lead.Billing_Country__c);
    }
    
  /*  
    public List<Invite_Colleagues__c> getInvitedColleaguesDetails(){
        Set<ID> invitedColleagueIds = new Set<ID>();
        LeadInvitedContacts = new LIST<Invite_Colleagues__c >();
         
        if(SelectedAccountId != null && SelectedAccountId != '' ){
            Invite_Colleagues__c  ico = new Invite_Colleagues__c ();
            ico.SapContactId__c  = sapConId ;
            ico.First_Name__c=lead.firstName;
            ico.Last_Name__c=lead.lastName;
            ico.Email__c=emailstr;
            
            LeadInvitedContacts.add(ico);
        }
            
    
        LIST<Invite_Colleagues__c> LeadInvitedContactsWithoutLead = new LIST<Invite_Colleagues__c>([Select ID,Name,First_Name__c,Last_Name__c,Lead__c,Email__c, Contact_Id_from_Lead__c,GUID__c, SapContactId__c FROM Invite_Colleagues__c where Lead__c =: Lead.Id]);
 
         
        for(Invite_Colleagues__c ic : LeadInvitedContacts){
            invitedColleagueIds.add(ic.id);
        }
        
        LeadInvitedContacts.addAll(LeadInvitedContactsWithoutLead);
      //  LeadConvDetail.createInvitedColleagues(invitedColleagueIds);
       
        return LeadInvitedContacts;
    }
    
    private List<SelectOption> getAccContactOptionsList(){
        
         List<SelectOption> accContactSelectOptionList = new List<SelectOption>();
        List<Contact> conListForSelectedAccount = new List<Contact>();
        accContactSelectOptionList.add(new SelectOption('New', 'Create Contact'));
        
         LeadInvitedContacts = getInvitedColleaguesDetails();
        if(SelectedAccountId != null){
        conListForSelectedAccount= [Select ID, Name, Email, AccountId FROM Contact Where AccountId =:this.SelectedAccountId AND AccountId != null ];
        
        for(Contact cont : conListForSelectedAccount){
            SelectOption selectOptions = new SelectOption(cont.id, cont.Name);
            
            accContactSelectOptionList.add(selectOptions);
        }
        }
         
        return accContactSelectOptionList;
    }
    
    public void showContactInfo(){
        System.debug('In showContactInfo');
        if(this.SelectedAccountId == null){
            contactForNewAccount = false;
        }else{
            contactForNewAccount =true;
        }
        this.AccContactOptions = this.getAccContactOptionsList(); 
    }
    */
    
    //Internal Classes
    public class LeadConvertException extends Exception {}
    
    public class AccountOption {
        //Properties
        public boolean isSelected {get;set;}
        public Account account {get;set;}
        
        //Constructors
        public AccountOption() {
            this.IsSelected = false;
            this.Account = new Account();
        }
        
        public AccountOption(Account oAccount) {
            this();
            this.Account = oAccount;
        }
    }
   /* 
   public void createContacts(LIST<Invite_Colleagues__c> invitedColleagues){
       
       LIST<contact> ivcContacts = new LIST<contact>();
       for(Invite_Colleagues__c ivc: invitedColleagues){
           //ivcContacts
           contact c = new contact();
           c.FirstName = ivc.First_Name__c;
           c.LastName = ivc.Last_Name__c;
           c.Email = ivc.Email__c;
           c.SAP_Contact_ID__c = ivc.SapContactId__c;
           c.App_User_GUID__c = ivc.GUID__c;
           c.Accountid = leadAccountId;
           ivcContacts.add(c);
       }
       
        LIST<database.saveresult> dbconRes =  Database.insert(ivcContacts, false);
       
       system.debug('DDDDDDDDDDDDDDDDDDDD.........'+dbconRes );
        system.debug('DDDDDDDDDDDDDDDDDDDD.........'+ivcContacts);
       
       MAP<string, contact> conMap = new MAP<string, contact>();
       for(contact c: ivcContacts){
           //conMap.put(c.SAP_Contact_ID__c, c);
           conMap.put(c.Email, c);
       }
       system.debug('EEEEEEEEEEEEEEEEEEE.........'+conMap);
       LIST<Invite_Colleagues__c > tobeUpdate = new LIST<Invite_Colleagues__c >();
       for(Invite_Colleagues__c ivc: LeadInvitedContacts){
           
           if((ivc.Contact_Id_from_Lead__c == 'New'|| ivc.Contact_Id_from_Lead__c =='' || ivc.Contact_Id_from_Lead__c == null) && conMap.containsKey(ivc.Email__c) ){
               //ivc.Contact_Id_from_Lead__c = conMap.get(ivc.SapContactId__c).id;
               ivc.Contact_Id_from_Lead__c = conMap.get(ivc.Email__c).id; 
                tobeUpdate.add(ivc);   
           }else if(ivc.id != null){
               tobeUpdate.add(ivc);
           }    
               
               
       }
       system.debug('FFFFFFFFFFFFFFF.........'+tobeUpdate);
        
       database.update(tobeUpdate , false);
       SET<id> leadids = new SET<id>();
       leadids.add(lead.id);
       //Create Asset, Contact Entit. etc if Is Trial Lead is checked
       if(this.Lead.Is_Trial_Lead__c){
           LeadConvDetail.getLeadProdDetails(leadids);
       }
   }
   */
   
}