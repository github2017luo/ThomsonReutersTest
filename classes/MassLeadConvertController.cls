public without sharing class MassLeadConvertController {
    
    
    public MassLeadConvertController() {
    
        

    }
    ApexPages.StandardSetController setCon;
    public List<AccountOption> LeadAccountOptions {get;set;}
    public string SelectedAccountId {get;set;}    
    public string selectedOppId{get;set;} 
    public boolean isLeadSection{get;set;}
    public boolean isAccountSection{get;set;}
    public boolean isContactSection{get;set;}
    public boolean isopportunitySection{get;set;}
    public boolean isActivitySection{get;set;}
    public Task FollowUpTask {get;set;}   
    public string selectedOppOwnerId;
    public Lead primaryLead{get;set;}
    public List<string> selectedLeads =new List<string>();
    public List<Lead> rootSelectedList{get;set;}
    public boolean leadError{get;set;}
    public boolean accessError{get;set;}    
    public boolean validationError{get;set;}
    List<Lead> tempLead;
    public String sErrorMsg='';
    public boolean bError {get;set;}
    public Id ExisitngAccountIdForMDBSAP{get;set;}
    public Map<String,String> mapAccountfields = new Map<String,String>{'Sales_Org__c'=>'Sales Org ' ,
                                                                        'Billing_City__c'=>'City ' ,
                                                                      // 'Billing_Street__c'=>'Street ' ,
                                                                        'Industry' =>'Industry ',
                                                                        'Customer_Type__c'=>'Customer Type ' ,
                                                                        'Billing_Country__c'=>'Country ' ,
                                                                        'Customer_Class__c'=>'Customer Class ' ,
                                                                        'Customer_Group__c'=>'Customer Group '};
    //public Set<String> LatamSalesOrg = new set<String>{'BEJE','EDIC','FSCO','LLEY','LLPA','LLUR','LPCL','LPTC','RV01','TSL','TSCE','SCSI','SFWS','SSRL','TGPS'};
    //commeted public Set<String> LatamSalesOrg = new set<String>{'BEJE','EDIC','LLEY','LLPA','LLUR','LPCL','LPTC','RV01','TSL','TSCE','SCSI','SFWS','SSRL','TGPS'}; //Removed FSCO Sales org as part of HER-BRAZIL
    Map<String,String> salesOrgMap = new Map<String,String>();
    public Set<String> LatamSalesOrg = new set<String>();
    public boolean bLatam{get;set;}
    public Set<String> setStateCountry = new set<String>();
    public Set<String> setZipCountry = new set<String>();
    @testvisible string convertedAccountId;
    public List<Lead> nonPrimarySelctedLeads {    
        get {
            return tempLead;
        }
        set;
    }

   public string selectedLead{get;set;}
  
   public string selectedAccount{get;set;}   
   public string selectedAccountName{get;set;}   
   public string str{get;set;}
   public boolean UseExistingAccount {get;set;}
   public boolean CreateFollowUpTask {get;set;}
   public string convertedOpportunityId{get;set;}
   
   public Lead convertedLead;
   Map<id,Opportunity> opportuntiyMap= new Map<id,Opportunity>();
   Map<id,List<Task>> tasksForLeadMap = new Map<id,List<Task>>();
   Map<id,List<Event>> EventsForLeadMap = new Map<id,List<Event>>();
   Map<string,string> selectednpleadAccountMap = new Map<string,string>();
   
   List<Task> newTasksToOpp= new List<Task>();
   List<Task>  TaskListforLeads = new List<Task>(); 
   List<Event> EventListforLeads = new List<Event>(); 
   // This map is used to map LEad and converted contact after lead conversion
   private map<id,Id> leadToContactMapAfterConversion= new map<id,Id>(); 
    
    public Id CampaignId;
    public String Description;
    Public String Source;
    public String URL;
    public String LeadType;
    public string strProfileName;
    
    //Start MCL- 1326
    //for standard
    public Lead tempLd{get;set;}  
    //for custom
    public String accName{get;set;}
    public ID accID{get;set;}
    //End MCL- 1326
    Map<String,LM_Lead_History__c> lHistoryMap{get;set;}
    public boolean isAccSelected {get;set;} //MCL-1891
    
    //public void init(){

         /*LIST<String> ILMProfilesList= new LIST<String>();         
         SET<String> ILMProfilesSet= new SET<String>();
         ILMProfilesList= ILMGeneral__c.getValues('AllowedProfilesForMassLeadConvert').value__c.split('\n');
         for(String s:ILMProfilesList){
             ILMProfilesSet.add(s.trim());
         }
         strProfileName = [Select Id, Name from Profile where Id =:UserInfo.getProfileId()].Name;
         system.debug('****ilmProfilesList' + ILMProfilesSet + strProfileName );
         if(ILMProfilesSet!=null && !ILMProfilesSet.contains(strProfileName)){
             accessError = true; 
             isLeadSection = false;        
         }*/
         
    //}
    
    public MassLeadConvertController(ApexPages.StandardSetController controller)
    {
        //Start MCL- 1326
        tempLd = new Lead(); 
        //populating dummy data for required fields
        tempLd.FirstName = 'dummy';
        tempLd.LastName = 'dummy';
        tempLd.Billing_Country__c = 'dummy';
        tempLd.Company = 'dummy';
        //End MCL- 1326
        lHistoryMap = new  Map<String,LM_Lead_History__c>();
        
        isLeadSection = false;
        isAccountSection = false;
        isContactSection = false;
        isopportunitySection = false;
        isActivitySection= false;
        isAccSelected = False; //MCL-1891
        this.FollowUpTask = new Task();
        this.FollowUpTask.OwnerId = UserInfo.getUserId();
        this.FollowUpTask.IsReminderSet = true;
        this.FollowUpTask.ReminderDateTime = System.now();
           
        setCon = controller;
        rootSelectedList= setCon.getSelected();
        integer leadThreshold = Integer.ValueOf(Label.LM_Mass_Lead_Threshold);
        if(rootSelectedList.size() <= leadThreshold){
            leadError = false;        
            system.debug('***selectedLEads' + rootSelectedList);
            for ( Lead l : rootSelectedList )
                {
                     system.debug('***lead id' + l.id);
                     selectedLeads.add(l.id);
                     
                }
            calcPrimaryLead(selectedLeads);
            isLeadSection = true;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.LM_Lead_Threshold_Error)); 
            leadError = true;  
        }
    }
    //MCL-1891 start
    public void setisAccSelected() {
        system.debug('tempLd.Account__c...'+tempLd.Account__c);
        isAccSelected = False;
        if((bError && !string.isEmpty(SelectedAccount)) || !bError)
            isAccSelected = True;
        system.debug('isAccSelected...'+isAccSelected);
    }
    public void setisAccSelectedforSearch(){
        isAccSelected = False;
        system.debug('tempLd.Account__c...'+tempLd.Account__c);
        if(tempLd.Account__c != null)
            isAccSelected = True;
    }
    //MCL-1891 end
    public void calcPrimaryLead(List<string> selectedLeads){
        system.debug('calcPrimaryLead : selectedLeads : '+selectedLeads);
        String primLead = '';
        if(selectedLeads != null && selectedLeads.size() > 0){
            List<Lead> ldList = [SELECT ID, Lead_Scoring_Combined__c, CreatedDate FROM LEAD WHERE ID IN :selectedLeads AND Lead_Scoring_Combined__c!=NULL];
            system.debug('calcPrimaryLead : ldList : '+ldList);
            if(ldList != null && ldList.size() > 0){
                //List<String> scoreList = new List<String>();
                String highscore = '';
                DateTime compDate = null;
                System.debug('highscore1 : '+highscore+' ID : '+primLead+' compDate : '+compDate);
                for(Lead ld : ldList){
                    if(highscore == null || highscore==''){
                        if(ld.Lead_Scoring_Combined__c !=null && ld.Lead_Scoring_Combined__c!='' && ld.Lead_Scoring_Combined__c.length()>1){
                            highscore = ld.Lead_Scoring_Combined__c;
                            primLead = ld.ID;
                            compDate = ld.CreatedDate;
                        }else{
                            continue;
                        }
                    }
                    String sc = ld.Lead_Scoring_Combined__c;
                    String hcPart1 = highscore.substring(0,1);
                    String hcPart2 = highscore.substring(1);
                    String scPart1 = sc.substring(0,1);
                    String scPart2 = sc.substring(1);
                    system.debug('hcPart1 : '+hcPart1+' hcPart2 : '+hcPart2+' scPart1 : '+scPart1+' scPart2 : '+scPart2);
                    System.debug('before comp temp highscore : '+highscore+' ld.Lead_Scoring_Combined__c : '+ld.Lead_Scoring_Combined__c+' primLead : '+primLead+' ld.ID : '+ld.ID+' compDate : '+compDate+' ld.CreatedDate : '+ld.CreatedDate);
                    if(hcPart2!=null && hcPart2!='' && hcPart2.isNumeric() && scPart2!=null && scPart2!='' && scPart2.isNumeric() && Integer.valueOf(hcPart2) >= Integer.valueOf(scPart2)){
                        if(Integer.valueOf(hcPart2) == Integer.valueOf(scPart2)){
                            if(hcPart1 >= scPart1){
                                if(hcPart1 == scPart1){
                                    //System.debug('compDate : '+compDate+' ld.CreatedDate : '+ld.CreatedDate);
                                    if(compDate!=null && ld.CreatedDate!=null && compDate < ld.CreatedDate){
                                        highscore = sc;
                                        primLead = ld.ID;
                                        compDate = ld.CreatedDate;
                                    }
                                }
                                else{
                                    highscore = sc;
                                    primLead = ld.ID;
                                    compDate = ld.CreatedDate;
                                }
                            }
                        }else{
                            highscore = sc;
                            primLead = ld.ID;
                            compDate = ld.CreatedDate;
                        }
                    }
                    System.debug('highscore temp : '+highscore+' ID : '+primLead+' compDate : '+compDate);
                }
                System.debug('highscore2 : '+highscore+' ID : '+primLead);
            }
            if(primLead == null || primLead == ''){
                primLead = selectedLeads[0];
            }
        }
        selectedLead = primLead;
    }

    public pageReference doSomething()
    {   
        
        bError = false;
        sErrorMsg = '';
        system.debug('****selectLead' +selectedLead);
        primaryLead= (Lead) [Select Description,URL__c,Phone,Email,FirstName,LastName,Status,Convert_by__c,Accept_by__c,MDBId__c,SAPAccountNumber__c,
                                    Lead_Scoring_Combined__c,Billing_City__c,Billing_State__C,Billing_Street__c,PO_Box__c,Tax_Number__c,Tax_Number_Type__c,
                                    Billing_Zip__c,Sales_Org__c,Billing_Country__c,Customer_Class__c,Customer_Group__c,ConvertedOpportunityId,Campaign_Cell__c,Account__r.NAme,
                                    Customer_Type__c,Industry,Contact__r.name,Campaign_code__c,Source__c,Legacy_System_ID__c, OwnerId,Acceptance_SLA_Violation__c,Accept_By_Date__c,Convert_By_Date__c,
                                    Company,Business_Org__c,Contact_SAP_ID__c,Convert_SLA_violation__c, Discard_Reason__c,External_Contact_ID__c,External_ID__c,LeadID18__c,LastModifiedBy.Name,
                                    owner.name,LeadSource,Type__c,Name,Primary_Campaign_Source__c,Priority__c,Source_Desc__c,Tracking_Code__c,account__c from Lead where Id=: selectedLead];
        setStateCountry = State_required_Countries__c.getall().Keyset();
        setZipCountry = ZipCode_required_Countries__c.getall().keyset();
        system.debug('****primaryLead.Account__c' +primaryLead.Account__c+'mdbid' +primaryLead.MDBId__c+'sapid'+ primaryLead.SAPAccountNumber__c);
        if (primaryLead.Account__c == null) {
                system.debug('***inside executed');
                this.ExisitngAccountIdForMDBSAP= findExistingAccountId(primaryLead.MDBId__c, primaryLead.SAPAccountNumber__c);  
                this.selectedAccount =   this.ExisitngAccountIdForMDBSAP; 
                this.primaryLead.Account__c= this.ExisitngAccountIdForMDBSAP;
                system.debug('***ExisitngAccountIdForMDBSAP' +ExisitngAccountIdForMDBSAP);           
                
        }
        else 
        if(this.primaryLead.account__c != null){
            selectedAccount= this.primaryLead.account__c;
            selectedAccountAttribute = this.primaryLead.account__c;
            system.debug('***seletedaccountand selectedAttribute' +selectedAccount + selectedAccountAttribute);
        }
        
        salesOrgMap = MexicoUtility.classBasedOrgValues('MassLeadConvertController','Sales_Org__c');
        LatamSalesOrg.addAll(salesOrgMap.values());
        if(LatamSalesOrg.contains(primaryLead.Sales_Org__c)){
            bLatam =  true;
            mapAccountfields.put('Tax_Number__c','Tax Number');
            mapAccountfields.put('Tax_Number_Type__c','Tax Number Type');
            mapAccountfields.put('Phone','Phone');
            mapAccountfields.put('Email','Email');
        }     
        
        
        if(setStateCountry.contains(primaryLead.Billing_Country__c) && AppUtil.IsEmpty(primaryLead.Billing_State__c) )
        { 
            mapAccountfields.put('Billing_State__c','State'); 
        } 

        if(setZipCountry.contains(primaryLead.Billing_Country__c)  && AppUtil.IsEmpty(primaryLead.Billing_Zip__c)) 
        { 
           mapAccountfields.put('Billing_Zip__c','Zip/Postal Code');
        } 
        
        if(isValidPrimaryLead()){
            isLeadSection = false;
            isAccountSection = true;  
            system.debug('***Primary Lead' + selectedLead+ '   ' + primaryLead);   
            
            Description = primaryLead.Description;
            CampaignId = primaryLead.Primary_Campaign_Source__c;
            Source = primaryLead.LeadSource;
            Url = primaryLead.URL__c;
            LeadType = primaryLead.Type__c;
            
            LeadAccountOptions = getLeadAccountOptions(primaryLead);
            tempLead = new List<Lead>();
            for(Lead l: rootSelectedList){
                if(l.id != selectedLead){
                    tempLead.add(l);
                    
                }
            }
            system.debug('***nonPrimarySelctedLeads' + nonPrimarySelctedLeads);
           // PageReference CovertAccountMatchesPage= new pagereference('/apex/CovertAccountMatchesPage?id='+ selectedLead);
           // CovertAccountMatchesPage.setRedirect(true);
           leadContactOptions = newFetchContactMatchsPrimary(primaryLead);
           for(ContactOption co:leadContactOptions)
           {
                if(co.contact.id != null)
                    primaryContactId = co.contact.id;
           }
           
        }
        else
        {           
            primaryLead.addError(Label.Lead_Convert_Not_Valid_for_Reject_Discard);
            
        }
        checkRequiredFields();
    setisAccSelected(); //MCL-1891
        return null;       

    }
    public pagereference selectLead(){
        selectedLead = System.currentPagereference().getParameters().get('leadid');
        system.debug('***selectedLead 1 ' +selectedLead );
        return null;
    }
    public pagereference selectExistingAccount(){
        selectedAccount = System.currentPagereference().getParameters().get('existingAcntId');
        system.debug('***selectedRadio existingAccount' + selectedAccount );
        return null;
    }
    
    
    public pagereference selectAccount(){
        selectedAccount = System.currentPagereference().getParameters().get('accountId');
        system.debug('***selectedAccount' + selectedAccount );
        return null;
    }
    
    @TestVisible
    private List<AccountOption> getLeadAccountOptions(Lead l) {
        List<AccountOption> accountOptions = new List<AccountOption>();
        
        AccountOption defaultAccountOption = new AccountOption();
        defaultAccountOption.IsSelected = true;
        if(this.ExisitngAccountIdForMDBSAP != null){        
            defaultAccountOption.Account.Name =  l.Account__r.Name;
        }else{
            defaultAccountOption.Account.Name = 'Create New Account: ' + l.Company;
            defaultAccountOption.Account.Customer_Group__c = ''; 
            accountOptions.add(defaultAccountOption);
            List<Account> accountQueryResult = queryAccountsByLeadCompanyName();
            for (Account account : accountQueryResult) {
                AccountOption accountOption = new AccountOption(account);
                accountOptions.add(accountOption);
            }
        }
        
       
        
        return accountOptions;
    }
    
    public List<OpportunityOption> getLeadOpportunityOptions() {
        
        if(primaryLead!= null){
            List<OpportunityOption> opportunityOptions = new List<OpportunityOption>();
            
            OpportunityOption defaultOpportunityOption = new OpportunityOption();
            defaultOpportunityOption.IsSelected = true;
            //system.debug('primaryLead.Company::'+primaryLead.Company);
            //defaultOpportunityOption.Opportunity.Name = 'Create New Opportunity: ' + primaryLead.Company;
            //Start MCL-1326
            String accName = primaryLead.Company;
            if(selectedAccount != null && selectedAccount != ''){
                Account tempAcc = [SELECT Name FROM Account WHERE id =:selectedAccount];
                accName = tempAcc.Name;
            }
            selectedAccountName = accName;
            system.debug('selectedAccount::'+selectedAccount);
            system.debug('accName::'+accName);
            defaultOpportunityOption.Opportunity.Name = 'Create New Opportunity: ' + accName;
            //End MCL-1326
    
            opportunityOptions.add(defaultOpportunityOption);
            //Start MCL-1371
            List<Opportunity> opportunityQueryResult = new List<Opportunity>();
            if(this.selectedAccount != null && this.selectedAccount != ''){
                opportunityQueryResult = [SELECT Id,Name,StageName,Owner.name,OwnerId,Created_by_Role__c,CloseDate,Total_Incremental__c,Total_Renewal__c,createdDate,Status__c FROM Opportunity where accountid = :this.selectedAccount and Status__c <> 'Discarded' and StageName NOT IN ('0%','95%','100%') LIMIT :10 ];
            }
            //End MCL-1371
            //List<Opportunity> opportunityQueryResult = queryOpportunitiesByLeadCompanyName();
            for (Opportunity Opportunity : opportunityQueryResult) {
                OpportunityOption OpportunityOption = new OpportunityOption(Opportunity);
                OpportunityOptions.add(OpportunityOption);
                opportuntiyMap.put(Opportunity.id,Opportunity);
            }
            
            return OpportunityOptions;
        }
        else
        return new List<OpportunityOption>();
    }
    
      
   /* private List<Opportunity> queryOpportunitiesByLeadCompanyName() {
        return (List<Opportunity>)[FIND : (primaryLead.Company) IN NAME FIELDS RETURNING 
                                    Opportunity(Id
                                        ,Name
                                        ,stageName
                                        ,Owner.name
                                        ,OwnerId
                                        ,Created_by_Role__c
                                        ,CloseDate
                                        ,Total_Incremental__c
                                        ,Total_Renewal__c
                                        ,createdDate where accountid = :this.selectedAccount LIMIT :10) ] [0] ;

                                       
    }*/
    
    private List<Account> queryAccountsByLeadCompanyName() {
        return (List<Account>)[FIND : (primaryLead.company) IN NAME FIELDS RETURNING 
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
                                        , Customer_group__c
                                        , SubsTotal__c LIMIT :10)][0];
                                       
    }
    
    //public Map<Id,Lead> queryConvertedLeadsByLeadId(List<string> nonPrimaryLeadLst){
        
    //    return null;
    //}
    
    public class AccountOption {
        //Properties
        public boolean IsSelected {get;set;}
        public Account Account {get;set;}
        
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
    
    public class OpportunityOption {
        //Properties
        public boolean IsSelected {get;set;}
        public Opportunity Opportunity {get;set;}
        
        //Constructors
        public OpportunityOption() {
            this.IsSelected = false;
            this.Opportunity = new Opportunity();
        }
        
        public OpportunityOption(Opportunity oOpportunity) {
            this();
            this.Opportunity = oOpportunity;
        }
    }
    
    
    public pagereference prev(){
        isLeadSection = true;
        isAccountSection = false;
        isContactSection = false;
        isopportunitySection = false;
        isActivitySection = false;
        isAccSelected = false; //MCL-1891
        return null;
    }
    public pagereference prevOpportunity(){
        isLeadSection = false;
        isAccountSection = false;
        isContactSection = true;
        isopportunitySection = false;
        isActivitySection = false;
        isAccSelected = false; //MCL-1891
        return null;
    }
    
    public pagereference prevAccount(){
        isLeadSection = false;
        isAccountSection = true;
        isContactSection = false;
        isopportunitySection = false;
        isActivitySection = false;
        SelectedAccount = findExistingAccountId(primaryLead.MDBId__c, primaryLead.SAPAccountNumber__c);
        tempLd.Account__c = null;
        isAccSelected = false; //MCL-1891
        return null;
    }
    public pagereference prevActivity(){
        isLeadSection = false;
        isAccountSection = false; 
        isContactSection = false;
        isopportunitySection = true;
        isActivitySection = false;
        //Start MCL-1371
        List<OpportunityOption> oppOptions = getLeadOpportunityOptions();
        if(oppOptions != null && oppOptions.size() == 1){
            prevAccount();   
        }
        //End MCL-1371
        return null;
    }
    public pagereference Next(){
        return null;
    }
    //Start MCL- 1326
    //public void dummy(){} 
    public void clear(){
        //SelectedAccount = ''; //MCL-1891
        //from Standard
        tempLd.Account__c = null;
        //from Custom
        //accID = null;
        //accName = '';
    }
    //End MCL- 1326
    public void goToContactPage(){
       //Start MCL- 1326 
       //from Standard
       
       //newFetchAccountAndContactMatchNonPrimary();
       system.debug('tempLd.Account__c :'+tempLd.Account__c);
       if(tempLd.Account__c != null){
           SelectedAccount = tempLd.Account__c;
           system.debug('SelectedAccount :'+SelectedAccount);
       }
       /*
       //from Custom
       system.debug('accID :'+accID);
       if(accID != null){
           SelectedAccount = accID ;
           system.debug('SelectedAccount :'+SelectedAccount);
       }
       */
       //End MCL- 1326
       
       
       if(bError != true){ 
           isContactSection = true;
           isLeadSection = false;
           isAccountSection = false;
           isopportunitySection = false;
           isActivitySection = false;
       }
       else
           primaryLead.addError( Label.Lead_Convert_Error+' '+sErrorMsg+'.');

       /* PageReference contactPage= new pagereference('/apex/leadToContact');        
        contactPage.setRedirect(true);  
        string name ='harika'; 
        contactPage.getParameters().put('leadIds', name );
        return contactPage; */ 
    }
     public void goToOpportunityPage(){
       //Start MCL- 1326 
       system.debug('tempLd.Account__c :'+tempLd.Account__c);
       if(tempLd.Account__c != null){
           SelectedAccount = tempLd.Account__c;
           primaryContactId = null;
       }
       system.debug('SelectedAccount :'+SelectedAccount);
       if(SelectedAccount != null && SelectedAccount != '' && primaryLead.account__c != null && primaryLead.account__c != SelectedAccount){
           primaryContactId = null;
       }
       system.debug('primaryContactId :'+primaryContactId);
       
       //End MCL- 1326
       //if(SelectedAccount != null && SelectedAccount != '' && primaryLead!=null){
           //primaryContactId = null;
           //leadContactOptions = newFetchContactMatchsPrimary(primaryLead);
           //for(ContactOption co:leadContactOptions)
           //{
           //     if(co.contact.id != null)
           //         primaryContactId = co.contact.id;
           //}
       //}
       
       newFetchAccountAndContactMatchNonPrimary();
       system.debug('*****goToOpportunityPage');
       system.debug('***selectedLeadIdConIdsStrLst = strSelectedContactIds' + selectedLeadIdConIdsStrLst + strSelectedContactIds);
       isContactSection = false;
       isLeadSection = false;
       isAccountSection = false;
       isopportunitySection = true;
       isActivitySection = false;
       //Start MCL-1371
       List<OpportunityOption> oppOptions = getLeadOpportunityOptions();
       if(oppOptions != null && oppOptions.size() == 1){
           if(oppOptions[0] != null && oppOptions[0].Opportunity != null){
               SelectedOppId = oppOptions[0].Opportunity.Id;
               goToActivityPage();
           }
       }
       //End MCL-1371
    
    }
    
     public void goToActivityPage(){
       
       isContactSection = false;
       isLeadSection = false;
       isAccountSection = false;
       isopportunitySection = false;
       isActivitySection = true;
       if(SelectedOppId != null && SelectedOppId!= ''){
           selectedOppOwnerId = opportuntiyMap.get(SelectedOppId).ownerId;   
           
       }
       System.debug('*** SelectedOppId and oppOwner Id' + selectedOppId + selectedOppOwnerId );

    }
    
    @TestVisible
    private void createLeadHistory(){
      //List<LM_Lead_History__c> lHistoryList= new  List<LM_Lead_History__c>();
      LM_Lead_History__c lHisoty;
      if(nonPrimarySelctedLeads!= null && nonPrimarySelctedLeads.size()>0){
          for(Lead l: nonPrimarySelctedLeads){
            if(lHistoryMap != null && lHistoryMap.size() > 0 && lHistoryMap.get(l.ID) != null){
                lHisoty = lHistoryMap.get(l.ID);
            }else{
                lHisoty = new LM_Lead_History__c (); 
            }
            lHisoty.name= l.name;
            lHisoty.Status__c= convertedStatusLabel.MasterLabel;
            lHisoty.opportunity__c= convertedOpportunityId;
            lHisoty.contact__c= leadToContactMapAfterConversion.get(l.id);   
            lHisoty.Campaign_Cell__c = l.Campaign_Cell__c ;
            lHisoty.Campaign_Code__c= l.Campaign_Code__c;
            lHisoty.Acceptance_SLA_Violation__c = l.Acceptance_SLA_Violation__c;
            lHisoty.Accept_By__c = l.Accept_By_Date__c;
            lHisoty.Convert_By__c = l.Convert_By_Date__c;
            lHisoty.Account_Name__c = l.Company;
            lHisoty.Business_Org__c = l.Business_Org__c;
            lHisoty.Contact_ID__c = l.Contact__c;
            lHisoty.Contact_SAP_ID__c = l.Contact_SAP_ID__c;
            lHisoty.Convert_SLA_violation__c = l.Convert_SLA_violation__c;
            lHisoty.Discard_Reason__c = l.Discard_Reason__c;
            lHisoty.External_Contact_ID__c = l.External_Contact_ID__c;
            lHisoty.External_ID__c = l.External_ID__c;
            lHisoty.Lead_ID__c = l.id;
            lHisoty.LeadID18__c = l.LeadID18__c;
            lHisoty.Lead_Last_Modified_by__c = l.LastModifiedBy.Name;
            lHisoty.Lead_Owner__c = l.owner.name;
            lHisoty.Lead_Source__c= l.LeadSource;
            lHisoty.Lead_Type__c = l.Type__c;
            lHisoty.Name__c = l.Name;
            lHisoty.Primary_Campaign_Source__c = l.Primary_Campaign_Source__c;
            lHisoty.Priority__c = l.Priority__c;
            lHisoty.Source_Desc__c = l.Source_Desc__c;
            lHisoty.Source_Type__c = l.Source__c;
            lHisoty.Tracking_Code__c = l.Tracking_Code__c;
            lHisoty.Account_ID__c= convertedAccountId; 
            lHisoty.Lead__C = l.ID;        
            lHistoryMap.put(l.ID,lHisoty);
          }
      }
      system.debug('***LH'+selectedOppId );
      //Start MCL-1349
      //used for createing lead history for primary lead
        if(lHistoryMap != null && lHistoryMap.size() > 0 && lHistoryMap.get(primaryLead.ID) != null){
            lHisoty = lHistoryMap.get(primaryLead.ID);
        }else{
            lHisoty = new LM_Lead_History__c (); 
        }lHisoty.name= primaryLead.name;
        lHisoty.Status__c= convertedStatusLabel.MasterLabel;
        if(selectedOppId != null && selectedOppId != ''){
            lHisoty.opportunity__c= selectedOppId ;
        }else{
            lHisoty.opportunity__c= convertedOpportunityId;
        }
        lHisoty.contact__c= primaryContactId;
        lHisoty.Source_Type__c=primaryLead.Source__c;
        lHisoty.Source_Desc__c=primaryLead.Source_Desc__c;
        //lHisoty.Account_Name__c=primaryLeadselectedAccount;
        //lHisoty.Priority__c=primaryLead.Priority__c;
        //lHisoty.Lead_Type__c=primaryLead.Type__c;
        lHisoty.Campaign_Cell__c = primaryLead.Campaign_Cell__c ;
        lHisoty.Campaign_Code__c= primaryLead.Campaign_Code__c; 
        lHisoty.Acceptance_SLA_Violation__c = primaryLead.Acceptance_SLA_Violation__c;
        lHisoty.Accept_By__c = primaryLead.Accept_By_Date__c;
        lHisoty.Convert_By__c = primaryLead.Convert_By_Date__c;
        lHisoty.Account_Name__c = primaryLead.Company;
        lHisoty.Business_Org__c = primaryLead.Business_Org__c;
        lHisoty.Contact_ID__c = primaryLead.Contact__c;
        lHisoty.Contact_SAP_ID__c = primaryLead.Contact_SAP_ID__c;
        lHisoty.Convert_SLA_violation__c = primaryLead.Convert_SLA_violation__c;
        lHisoty.Discard_Reason__c = primaryLead.Discard_Reason__c;
        lHisoty.External_Contact_ID__c = primaryLead.External_Contact_ID__c;
        lHisoty.External_ID__c = primaryLead.External_ID__c;
        lHisoty.Lead_ID__c = primaryLead.id;
        lHisoty.LeadID18__c = primaryLead.LeadID18__c;
        lHisoty.Lead_Last_Modified_by__c = primaryLead.LastModifiedBy.Name;
        lHisoty.Lead_Owner__c = primaryLead.owner.name;
        lHisoty.Lead_Source__c= primaryLead.LeadSource;
        lHisoty.Lead_Type__c = primaryLead.Type__c;
        lHisoty.Name__c = primaryLead.Name;
        lHisoty.Primary_Campaign_Source__c = primaryLead.Primary_Campaign_Source__c;
        lHisoty.Priority__c = primaryLead.Priority__c;
        lHisoty.Source_Desc__c = primaryLead.Source_Desc__c;
        lHisoty.Source_Type__c = primaryLead.Source__c;
        lHisoty.Tracking_Code__c = primaryLead.Tracking_Code__c;
        lHisoty.Account_ID__c= convertedAccountId; 
        lHisoty.Lead__C = primaryLead.ID;   
        system.debug('@@lHisoty.contact__c::'+lHisoty.contact__c); 
        lHistoryMap.put(primaryLead.ID,lHisoty);
      //END MCL-1349
              
      try{
          upsert lHistoryMap.values();
          system.debug('*** LOG STATUS:: LM Lead History created');
      }catch(DMLException dmlEx){
          system.debug('*** create LM Lead History error:: '+dmlEx.getMEssage());
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMessage()));
      }
  }
  
  public pagereference createContactRole(List<OpportunityContactRole> tempRoleList, SET<string> conIdsSet){
      Set<String> existingRole = new Set<String>();
      for(OpportunityContactRole cRole : tempRoleList){
          existingRole.add(cRole.contactId);
      }  
      List<OpportunityContactRole> cRoleList= new List<OpportunityContactRole>();   
      for(string conId: conIdsSet){
          OpportunityContactRole cRole= new OpportunityContactRole();
          cRole.contactId = conId;
          cRole.OpportunityId = convertedOpportunityId;
          if(existingRole.contains(conId))
              continue;
          cRoleList.add(cRole);
      }
      system.debug('****cRoleList' +cRoleList);
      if(cRoleList != null && cRoleList.size() >0) {
          try{
              insert cRoleList;
              for(OpportunityContactRole cRole : cRoleList)tempRoleList.add(cRole);
              system.debug('*** LOG STATUS:: Contact Roles created');
          }catch(DMLException dmlEx){
          
              system.debug('*** createContactRole error:: '+dmlEx.getMEssage());
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
              return null;
          
          }
      }
      return null;
  }
  
    // This method is used in case if user selectedexisting opportunity to merge the leads. 
    @TestVisible
    private void createContactRoleForPrmaryLead(List<OpportunityContactRole> tempRoleList, string prmConId){
          system.debug('call createContactRoleForPrmaryLead : prmConId : '+prmConId);
          String tempPrimaryContactId = '';
            for(ContactOption co:leadContactOptions)
            {
                if(co.contact.id != null)
                    tempPrimaryContactId = co.contact.id;
            }
          Boolean primaryFlag = false;
          OpportunityContactRole tempRole = null;
          //code to check if contact is already present in Opp Contact Role then skip inserting new record
          try{
              //for(OpportunityContactRole tRole : [SELECT ID, contactId, IsPrimary FROM OpportunityContactRole WHERE OpportunityId = :convertedOpportunityId]){
              for(OpportunityContactRole tRole : tempRoleList){
                  if(tRole.contactId == prmConId){
                      tempRole = tRole;
                  }
                  if(tRole.IsPrimary == true && (delPrimaryContactId != null && delPrimaryContactId != '' && delPrimaryContactId != tRole.contactId)){
                      primaryFlag = true;
                  }
              }
              //tempRole = [SELECT ID FROM OpportunityContactRole WHERE contactId = :prmConId AND OpportunityId = :convertedOpportunityId LIMIT 1];
              if(tempRole != null){
                  if(primaryFlag == false){
                      tempRole.IsPrimary = true;
                      update tempRole;
                  }
                  return;
              }
          }catch(Exception e){}
          OpportunityContactRole cRole= new OpportunityContactRole();
          cRole.contactId = prmConId;
          cRole.OpportunityId = convertedOpportunityId;
          if(primaryFlag == false){
              cRole.IsPrimary = true;
          }
          try{
              insert cRole;
              tempRoleList.add(cRole);
              system.debug('createContactRoleForPrmaryLead : cRole : '+cRole);
          }catch(DMLException dmlEx){
          
              system.debug('*** createPrmialryLeadContactRole error:: '+dmlEx.getMEssage());
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
          
          }
    }
  List<Database.LeadConvert> leadConversions;
  String delPrimaryContactId = '';
  
    public PageReference convertLead() {
        PageReference pageReference = null;
        List<OpportunityContactRole> tempRoleList = new List<OpportunityContactRole>();
        createLeadHistory(); 
        fetchLeadActivities();
        string convertedPrmContactId;
        Boolean primaryContactDelete = false;           
        delPrimaryContactId = '';  
        try {
            Database.LeadConvertResult leadConvertResult = null;
            try{
                leadConvertResult = this.executeLeadConversion();
            }catch (Exception oException) {
                System.debug('oException : '+oException.getStacktraceString());
                if(oException.getMEssage().contains('INACTIVE_OWNER_OR_USER')){
                    String userId = (oException.getMEssage().split('User Id').size()>=2)?oException.getMEssage().split('User Id')[1]:'';
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'<b>ConvertLead failed</b>. Selected Account, Contact or Opportunity for Lead Convert process have INACTIVE_OWNER_OR_USER.'+((userId!=null && userId!='')?' User ID '+userId:' ')+' . To continue, please save them with Active Owners.'));
                }else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,oException.getMEssage()));
                }
                if(lHistoryMap.Values() != null && lHistoryMap.Values().size() > 0){
                    try{
                        List<LM_Lead_History__c> delHist = lHistoryMap.values();
                        delete delHist;
                        lHistoryMap.clear();
                    }catch(Exception e){}
                }
                return null;
            }  
            if (leadConvertResult.isSuccess() == true) { 
                convertedAccountId= leadConvertResult.getAccountId(); 
                
                String tempPrimaryContactId = '';
                for(ContactOption co:leadContactOptions)
                {
                    if(co.contact.id != null)
                        tempPrimaryContactId = co.contact.id;
                }
                system.debug('tempPrimaryContactId : '+tempPrimaryContactId+' leadConvertResult.getContactId() : '+leadConvertResult.getContactId()+' convertedPrmContactId : '+convertedPrmContactId);
                convertedPrmContactId= (tempPrimaryContactId != null && tempPrimaryContactId != '' && tempPrimaryContactId != leadConvertResult.getContactId())?tempPrimaryContactId:leadConvertResult.getContactId();
                system.debug('tempPrimaryContactId : '+tempPrimaryContactId+' leadConvertResult.getContactId() : '+leadConvertResult.getContactId()+' convertedPrmContactId : '+convertedPrmContactId);
                if(primaryLead != null && primaryLead.Account__c != null && convertedAccountId != null && convertedAccountId != '' && primaryLead.Account__c != convertedAccountId){
                    if(tempPrimaryContactId == null || tempPrimaryContactId == ''){
                        Contact con = new Contact(ID=leadConvertResult.getContactId(), AccountID=primaryLead.Account__c);
                        update con;
                    }else{
                        primaryContactDelete = true;
                        delPrimaryContactId = leadConvertResult.getContactId();
                    }
                }
                convertedOpportunityId = leadConvertResult.getOpportunityId();
                primaryContactId = convertedPrmContactId;
                if(SelectedOppId != null && SelectedOppId != ''){
                    convertedOpportunityId = SelectedOppId ; 
                    system.debug('***convertedOpportunityId ' + convertedOpportunityId ); 
                }
                try{
                    tempRoleList = [SELECT ID, contactId, IsPrimary FROM OpportunityContactRole WHERE OpportunityId = :convertedOpportunityId];
                }catch(Exception e){
                    tempRoleList = new List<OpportunityContactRole>();
                }
                if(tempPrimaryContactId != null && tempPrimaryContactId != '' && tempPrimaryContactId != leadConvertResult.getContactId()){
                    system.debug('call createContactRoleForPrmaryLead');
                    createContactRoleForPrmaryLead(tempRoleList, convertedPrmContactId);
                    //primaryContactDelete = true;
                    //delPrimaryContactId = leadConvertResult.getContactId();
                }else if(SelectedOppId != null && SelectedOppId != ''){
                    createContactRoleForPrmaryLead(tempRoleList, convertedPrmContactId);
                }
                
                system.debug('****MDB Issue start selected Account'+ this.selectedAccount);
                if(this.selectedAccount == null || this.selectedAccount == ''){
                    UpdateAccountfields(convertedAccountId);
                }
                
                if(selectedOppId == null || selectedOppId =='')
                    UpdateOpportunityfields(convertedOpportunityId);
                           
     
                leadToContactMapAfterConversion.put(leadConvertResult.getLeadId(),convertedPrmContactId); 
                if (this.CreateFollowUpTask == true) {
                    this.insertFollowUpTask(leadConvertResult);
                } 
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Lead converted successfully'));
            }  
       
            else {
                //throw new LeadConvertException(leadConvertResult.getErrors()[0].getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,leadConvertResult.getErrors()[0].getMessage()));
            }
        }
        catch (Exception oException) {
            //ApexPages.addMessages(oException);
            System.debug('oException : '+oException.getStacktraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,oException.getMEssage()));
        }      
        SET<string> NonPrmNewAndExistConIds =new SET<string>();   
        List<string> selectedContactIdsLst = new List<string>();
        SET<String> nonPrimLeadsWithNewConOption= new SET<String>();
        map<string,string> selectedleadContactMap = new map<string,string>();
         
        //set strSelectedContactIds with leadId:contactId and separate them with a comma
        
        selectedLeadIdConIdsStrLst = (strSelectedContactIds!=null && strSelectedContactIds!='')?strSelectedContactIds.split(','):null;
        //system.debug('****selectedContactids' + selectedLeadIdConIdsStrLst);
        if(selectedLeadIdConIdsStrLst != null && selectedLeadIdConIdsStrLst.size()>0){
            for(String s: selectedLeadIdConIdsStrLst){
                system.debug('***s' + s);
                List<string> tempstrLst= new List<string>();
                tempstrLst = s.split(':');
                system.debug('tempstrLst '+tempstrLst);
                system.debug('tempstrLst '+ tempstrLst.size());
                if(tempstrLst != null){
                     if(tempstrLst.size() >1){
                        
                        //tepstrLst[0] is lead and tempstrLst[1] is the contact if the contact exist
                        
                         selectedleadContactMap.put(tempstrLst[0],tempstrLst [1]);
                         NonPrmNewAndExistConIds.add(tempstrLst [1]);
                     }
                     else{                 
                         nonPrimLeadsWithNewConOption.add(tempstrLst[0]);
                         
                         //These are leads with new contact
                         selectedleadContactMap.put(tempstrLst[0],null);                     
                         system.debug('****nonPrimLeadsWithNewConOption' + nonPrimLeadsWithNewConOption);
                     }
                     
                 } 
                        
                                
             }
         }
        
        leadConversions = new List<Database.LeadConvert>();  
        if(selectedleadContactMap!= null){
            for(String s: selectedleadContactMap.keySet()){
                if(s != null && s!= ''){
                    try{
                        //When you pass the value here make suree the account id the correct account account id ...not the primariy account id
                        
                        executeNonPrimaryLeadConversion(s, selectedleadContactMap.get(s),convertedOpportunityId,selectednpleadAccountMap.get(s));  
                    }catch(Exception ex){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMEssage()));
                    
                    }  
                }       
                    
            }
        } 
        List<Database.LeadConvertResult> results;      
        try{
            results = Database.convertLead(leadConversions); 
            for(Database.LeadConvertResult lcr:results){
                if(lcr.issuccess()){
                    leadToContactMapAfterConversion.put(lcr.getLeadId(),lcr.getContactId());    
                }        
            }  
        
        }catch(Exception Ex){
              
              system.debug('*** createContactRole error:: '+ Ex.getMEssage());
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMEssage()));
          
        }
        createLeadHistory(); 
        List<LM_Lead_History__c> delHistNonPrim = new List<LM_Lead_History__c>();
        if(lHistoryMap.Values() != null && lHistoryMap.Values().size() > 0 && results != null && results.size() > 0){
                for(Database.LeadConvertResult lcr:results){
                    if(!lcr.issuccess()){
                        if(lHistoryMap.get(lcr.getLeadId()) != null){
                            delHistNonPrim.add(lHistoryMap.get(lcr.getLeadId()));
                            lHistoryMap.remove(lcr.getLeadId());
                        }
                    }
                }        
        }  
        if(delHistNonPrim != null && delHistNonPrim.size() > 0){
            try{
                delete delHistNonPrim;
            }catch(Exception e){}
        }
        List<Lead> nonPrmLeadsWithNewContConvMap = ([SELECT id,convertedOpportunityId,convertedContactId FROM LEAD WHERE id in: nonPrimLeadsWithNewConOption]);
        if(nonPrmLeadsWithNewContConvMap != null && nonPrmLeadsWithNewContConvMap .size() >0){
            for(Lead l: nonPrmLeadsWithNewContConvMap ){
                if(l.convertedContactId != null){
                    NonPrmNewAndExistConIds.add(l.convertedContactId);
                }
            }
        }
        createContactRole(tempRoleList, NonPrmNewAndExistConIds);
        createLeadTasksUnderOpp();
        createLeadEventsUnderOpp();
        try{
            if(primaryContactDelete == true && delPrimaryContactId != null && delPrimaryContactId != ''){
                //Contact con = [SELECT ID FROM CONTACT WHERE ID = :leadConvertResult.getContactId()];
                Contact con = new Contact(ID=delPrimaryContactId);
                delete con;
            }
        }catch(Exception e){
            System.debug('exception : '+e.getMessage());
            System.debug('exception trace : '+e.getStackTraceString());
        }
        
        pageReference  = new PageReference('/'+convertedOpportunityId);
        return pageReference ;
        
    }
    
    //Internal Classes
    public class LeadConvertException extends Exception {}
    private LeadStatus convertedStatusLabel= queryLeadStatusIsConverted(); 
    private LeadStatus queryLeadStatusIsConverted() {
        return  [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

    } 
    /*Start MCL-1387 fix
    public void resetLeadFields(String ldID, String accID){
        Lead ld = [SELECT ID, External_Contact_ID__c , Legacy_System_ID__c, MDBID__c, SAPAccountNumber__c, Account__c, Company FROM LEAD WHERE ID =:ldID];
        system.debug('resetLeadFields : accID: '+accID);
        system.debug('resetLeadFields : ld: '+ld);
        if(ld != null && ld.Account__c != null && ((accID == null || accID == '') || ld.Account__c != accID)){
            ld.External_Contact_ID__c = null;
            ld.Legacy_System_ID__c = null;
            ld.MDBID__c = null;
            ld.SAPAccountNumber__c = null;
            system.debug('resetLeadFields : updated ld: '+ld);
            update ld;
        }
    }
    //End MCL-1387 fix*/
    @TestVisible
    private Database.LeadConvertResult executeLeadConversion() {
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        system.debug('****Selected Account,Contact and Opportunity' + selectedAccount + ':' + primaryContactId  + ':' + SelectedOppId );
        system.debug('resetLeadFields : selectedAccount : '+selectedAccount);
        //resetLeadFields(selectedLead,selectedAccount);//MCL-1387 fix
        leadConvert.setLeadId(selectedLead);
        //leadConvert.setOwnerId(this.LeadAccount.OwnerId);
        if(selectedAccount != null && selectedAccount != ''){
            leadConvert.setAccountId(selectedAccount);
            if(primaryContactId !=null && primaryContactId != '')
                leadConvert.setContactId(primaryContactId);
        }
        leadConvert.setConvertedStatus(convertedStatusLabel.MasterLabel);
        if(SelectedOppId != null && SelectedOppId != ''){
            leadConvert.setDoNotCreateOpportunity(true);
        }else{
            String accName = primaryLead.Company;
            if(selectedAccount != null && selectedAccount != ''){
                //Account tempAcc = [SELECT Name FROM Account WHERE id =:selectedAccount];
                //accName = tempAcc.Name;
                accName = selectedAccountName;
            }
            primaryLead.Company = accName;
            update primaryLead;
        }
        if(SelectedOppId != null && SelectedOppId != ''){
            leadConvert.setOwnerId(selectedOppOwnerId);
        }
        else
            leadConvert.setOwnerId(UserInfo.getUserId()); 
            //Lead ld = [SELECT ID,External_Contact_ID__c FROM LEAD WHERE ID = :selectedLead];
            //System.debug('last try : '+ld);
        //try{       
            return Database.convertLead(leadConvert);
        //}Catch(Exception Ex){
           // system.debug('***Exception Occured while Converting primary lead:: '+ Ex.getMEssage());
           // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMEssage()));
           // return null;
            
        //}
    }

    
    // Converting non primary leads.
    @TestVisible
    private void executeNonPrimaryLeadConversion(String leadId, string contactId,string convertedOppoId,string convertedAccntId) {
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        system.debug('resetLeadFields : convertedAccntId : '+convertedAccntId);
        //resetLeadFields(leadId,convertedAccntId);//MCL-1387 fix
        leadConvert.setLeadId(leadId);
        if(convertedAccntId != null && convertedAccntId != '')
            leadConvert.setAccountId(convertedAccntId);
        if(contactId !=null && contactId != '')
            leadConvert.setContactId(contactId);
            
            
        leadConvert.setDoNotCreateOpportunity(true);        
        if(SelectedOppId != null && SelectedOppId != ''){
            leadConvert.setOwnerId(selectedOppOwnerId);
        }
        else
            leadConvert.setOwnerId(UserInfo.getUserId());
            
        leadConvert.setConvertedStatus(convertedStatusLabel.MasterLabel);       
        //Database.LeadConvertResult lc= Database.convertLead(leadConvert);   
        //leadToContactMapAfterConversion.put(lc.getLeadId(),lc.getContactId());
         
        leadConversions.add(leadConvert);

    }
    
    
    public List<LEAD> leadlst{get; set;}
    public List<ContactOption> leadContactOptions{get;set;}
        public Lead ControllerValue;
    public string selectedContact{get;set;}
    public List<string> selectedLeadIdConIdsStrLst{get;set;}
    public string strSelectedContactIds{get;set;}
    
    public String primaryContactId{get;set;}
    public Lead getControllerValue(){ return ControllerValue; }
    public void setControllerValue(lead s){
        ControllerValue= s;
    //    LeadConvertContactMatching();
    }
    public string radiobuttonCount{get;set;}
    public string getRadiobuttonCount(){ return radiobuttonCount; }
    public void setRadiobuttonCount(string s){
        radiobuttonCount= s;
    //    LeadConvertContactMatching();
    }
    
    public string selectedAccountAttribute{get;set;}
    public string getselectedAccountAttribute(){ return selectedAccountAttribute; }
    public void setselectedAccountAttribute(string s){
        selectedAccountAttribute= s;
    //    LeadConvertContactMatching();
    }
   
    
    
    //public void LeadConvertContactMatching() {        
       /* leadLst = [SELECT Name,company,Email FROM LEAD
                    WHERE id= :ControllerValue
                   ];
        System.debug('just ran query');
        if (leadLst.isEmpty()){
            system.debug( 'There are no pending appointments for this client: ');
        }*/
        //if(ControllerValue != null)
            //leadContactOptions = fetchContactMAtches(ControllerValue);
            
            //added by Daniel
            //leadContactOptions = newfetchContactMAtches(primaryLead);
    //}
//added by Daniel  

public string accountIdByDaniel{get;set;}

public List<AccountOption> npAccountOption {get;set;}
public List<ContactOption> npContactOptions {get;set;}


public void newFetchAccountAndContactMatchNonPrimary()
{
    System.debug('Inside Account Option method ');
    String AccountId;
    String ContactId;
    String LeadId;
    String AccountFiledName;
    String ContactFieldName;
    npAccountOption = new List<AccountOption>();
    npContactOptions = new List<ContactOption>();
    
    System.debug('non primary leand size '+ nonPrimarySelctedLeads.size());
    
    for(Lead npLead : nonPrimarySelctedLeads)
        {
            System.debug('npLead.Account__c ' + npLead.Account__c);
            System.debug('npLead.MDBId__c ' + npLead.MDBId__c);
            System.debug('npLead.SAPAccountNumber__c ' + npLead.SAPAccountNumber__c);
            System.debug('npLead.Legacy_System_ID__c ' + npLead.Legacy_System_ID__c);
            System.debug('npLead.Contact_SAP_ID__c ' + npLead.Contact_SAP_ID__c);
            System.debug('npLead.External_Contact_ID__c ' + npLead.External_Contact_ID__c);
        }
        
    System.debug('nonPrimary leads ' + nonPrimarySelctedLeads);
    for(Lead npLead : nonPrimarySelctedLeads)
    {   
          System.debug('Inside forloop ' + npLead.id);  
          System.debug('npLead.Account__c ' + npLead.Account__c);   
          AccountOption defaultAccountOption;
          ContactOption defaultContactOption;
        
          List<Account> accounts = new List<Account>();
          List<Contact> contact = new List<Contact>();
          
          if(npLead.Account__c != null )
          {
              System.debug('Inside first if statment ');
              AccountId = npLead.Account__c;
              AccountFiledName = 'Account__c';
              LeadId = npLead.id;
              accounts = [SELECT Id,Name FROM Account WHERE Id =: npLead.Account__c];
              if(accounts != null && accounts.size() > 0){
                  if(npLead.External_Contact_ID__c != null && npLead.External_Contact_ID__c != '')
                  {
                      ContactId = npLead.External_Contact_ID__c;
                      ContactFieldName = 'External_Contact_ID__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where External_ID__c =: npLead.External_Contact_ID__c AND Accountid = :accounts[0].id];
                  }
                  else if(npLead.Contact_SAP_ID__c != null && npLead.Contact_SAP_ID__c != '')
                  {
                      ContactId = npLead.Contact_SAP_ID__c;
                      ContactFieldName = 'Contact_SAP_ID__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where SAP_Contact_ID__c =: npLead.Contact_SAP_ID__c AND Accountid = :accounts[0].id];
                  }else if(npLead.Contact__c != null)
                  {
                      ContactId = npLead.Contact__c;
                      ContactFieldName = 'Contact__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where SAP_Contact_ID__c =: npLead.Contact__c AND Accountid = :accounts[0].id];
                  } 
              }
          }
          else if(npLead.MDBId__c != null && npLead.MDBId__c != '')
          {
              AccountId = npLead.MDBId__c;
              AccountFiledName = 'MDBId__c';
              LeadId = npLead.id;
              accounts = [SELECT Id,Name FROM Account WHERE MDBID__c =: npLead.MDBId__c];
              if(accounts != null && accounts.size() > 0){
                  if(npLead.External_Contact_ID__c != null && npLead.External_Contact_ID__c != '')
                  {
                      ContactId = npLead.External_Contact_ID__c;
                      ContactFieldName = 'External_Contact_ID__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where External_ID__c =: npLead.External_Contact_ID__c AND Accountid = :accounts[0].id];
                  }
                  else if(npLead.Contact_SAP_ID__c != null && npLead.Contact_SAP_ID__c != '')
                  {
                      ContactId = npLead.Contact_SAP_ID__c;
                      ContactFieldName = 'Contact_SAP_ID__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where SAP_Contact_ID__c =: npLead.Contact_SAP_ID__c AND Accountid = :accounts[0].id];
                      
                  }else if(npLead.Contact__c != null)
                  {
                      ContactId = npLead.Contact__c;
                      ContactFieldName = 'Contact__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where SAP_Contact_ID__c =: npLead.Contact__c AND Accountid = :accounts[0].id];
                  } 
              }
              //selectednpleadAccountMap.put(npLead.id,accounts[0].id);
          }
          else if(npLead.SAPAccountNumber__c != null && npLead.SAPAccountNumber__c != '')
          {
              AccountId = npLead.SAPAccountNumber__c;
              AccountFiledName = 'SAPAccountNumber__c';
              LeadId = npLead.id;
              accounts = [SELECT Id,Name FROM Account WHERE SAPAccountNumber__c =: npLead.SAPAccountNumber__c];
              if(accounts != null && accounts.size() > 0){
                  if(npLead.External_Contact_ID__c != null && npLead.External_Contact_ID__c != '')
                  {
                      ContactId = npLead.External_Contact_ID__c;
                      ContactFieldName = 'External_Contact_ID__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where External_ID__c =: npLead.External_Contact_ID__c AND Accountid = :accounts[0].id];
                  }
                  else if(npLead.Contact_SAP_ID__c != null && npLead.Contact_SAP_ID__c != '')
                  {
                      ContactId = npLead.Contact_SAP_ID__c;
                      ContactFieldName = 'Contact_SAP_ID__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where SAP_Contact_ID__c =: npLead.Contact_SAP_ID__c AND Accountid = :accounts[0].id];
                  }else if(npLead.Contact__c != null)
                  {
                      ContactId = npLead.Contact__c;
                      ContactFieldName = 'Contact__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where SAP_Contact_ID__c =: npLead.Contact__c AND Accountid = :accounts[0].id];
                  } 
              }
          }
          else if(npLead.Legacy_System_ID__c != null && npLead.Legacy_System_ID__c != '')
          {
              AccountId = npLead.Legacy_System_ID__c;
              AccountFiledName = 'Legacy_System_ID__c';
              LeadId = npLead.id;
              accounts = [SELECT Id,Name FROM Account WHERE Legacy_System_ID__c =: npLead.Legacy_System_ID__c];
              if(accounts != null && accounts.size() > 0){
                  if(npLead.External_Contact_ID__c != null && npLead.External_Contact_ID__c != '')
                  {
                      ContactId = npLead.External_Contact_ID__c;
                      ContactFieldName = 'External_Contact_ID__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where External_ID__c =: npLead.External_Contact_ID__c AND Accountid = :accounts[0].id];
                  }
                  else if(npLead.Contact_SAP_ID__c != null && npLead.Contact_SAP_ID__c != '')
                  {
                      ContactId = npLead.Contact_SAP_ID__c;
                      ContactFieldName = 'Contact_SAP_ID__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where SAP_Contact_ID__c =: npLead.Contact_SAP_ID__c AND Accountid = :accounts[0].id];
                  }else if(npLead.Contact__c != null)
                  {
                      ContactId = npLead.Contact__c;
                      ContactFieldName = 'Contact__c';
                      contact = [SELECT Id,FirstName, LastName From Contact where SAP_Contact_ID__c =: npLead.Contact__c AND Accountid = :accounts[0].id];
                  } 
              }
          }
          
        System.debug('accounts size ' + accounts.size());
        
        if(!accounts.isEmpty()){ 
            System.debug('Insided account if');       
            for (Account account : accounts) {
                defaultAccountOption = new AccountOption(account);
                defaultAccountOption.Account.Name = account.name;
                System.debug('Account Name ' + defaultAccountOption.Account.Name + ' ' + defaultAccountOption.Account.id);
                npAccountOption.add(defaultAccountOption);
              
                selectednpleadAccountMap.put(npLead.id,account.id);
                
                if(!contact.isEmpty()){
                    for(Contact con : contact)
                    {
                        defaultContactOption = new ContactOption(con);
                        npContactOptions.add(defaultContactOption);
                        //set strSelectedContactIds with leadId:contactId and separate them with a comma
                        if(strSelectedContactIds == null)
                            strSelectedContactIds = npLead.id + ':' + con.id +',';
                        else
                            strSelectedContactIds = strSelectedContactIds + npLead.id + ':' + con.id +',';
                    }
                 }
                 else
                 {
                    defaultContactOption = new ContactOption();
                    
                    defaultContactOption.Contact.FirstName= 'Create New Contact: ' + npLead.name;
                    defaultContactOption.Contact.email= 'sample@email.com';
        
                    npContactOptions.add(defaultContactOption);
                    if(strSelectedContactIds == null)
                        strSelectedContactIds = npLead.id+':'+',';
                    else
                        strSelectedContactIds = strSelectedContactIds + npLead.id+':'+',';
                 }
            }
        }else{
          System.debug('Insided account else'); 
            defaultAccountOption = new AccountOption();
            defaultAccountOption.Account.Name = 'Create New Account: ' + npLead.Company;
            defaultAccountOption.Account.Customer_Group__c = ''; 
            System.debug('Account Name ' + defaultAccountOption.Account.Name+ ' ' + defaultAccountOption.Account.id);
            npAccountOption.add(defaultAccountOption);
            
            defaultContactOption = new ContactOption();
                    
            defaultContactOption.Contact.FirstName= 'Create New Contact: ' + npLead.name;
            defaultContactOption.Contact.email= 'sample@email.com';        
            npContactOptions.add(defaultContactOption);
            
            selectednpleadAccountMap.put(npLead.id,defaultAccountOption.Account.id);
            if(strSelectedContactIds == null)
                strSelectedContactIds = npLead.id+':'+',';
            else
                strSelectedContactIds = strSelectedContactIds + npLead.id+':'+',';
        }  
    }
}  

public List<ContactOption> newFetchContactMatchsPrimary(lead l){

        List<ContactOption> contactOptions = new List<ContactOption>();
        map<string,List<Contact>> mapSAPContactId = new map<string,List<Contact>>();
        map<string,List<Contact>> mapExternalContactId = new map<string,List<Contact>>();
        map<string,List<Contact>> mapContactId = new map<string,List<Contact>>();
        List<contact> matchedContactsList= new List<contact>();
        
        
        
        string matchStringSAPContactId = l.Contact_SAP_ID__c;
        string matchStringExternalContactId = l.External_Contact_ID__c;
        string matchStringContactId = l.Contact__c;
        
        System.debug('nonPrimary leads ' + nonPrimarySelctedLeads);
        
        accountIdByDaniel = this.selectedAccount;
        
        if(this.selectedAccount != null && this.selectedAccount != ''){
            List<Contact> ContactQueryResult = [SELECT id,SAP_Contact_ID__c,External_ID__c, FirstName,LastName,name,Email,Title,Job_Function__c,Work_Direct__c,Phone,Contact_Type__c,SAP_Role__c,SAP_Account_Number__c,account.name FROM Contact 
                                                    WHERE accountid= : this.selectedAccount];
                                                    
            system.debug('***ContactQueryResult' +ContactQueryResult);
            
            matchedContactsList= new List<contact>();                                       
            for (Contact Contact : ContactQueryResult) {
                if(contact.SAP_Contact_ID__c != null && contact.SAP_Contact_ID__c != ''){
                    if(mapSAPContactId.ContainsKey(contact.SAP_Contact_ID__c))
                        mapSAPContactId.get(contact.SAP_Contact_ID__c).add(Contact);
                    else{
                        mapSAPContactId.put(contact.SAP_Contact_ID__c,new List<Contact>());
                        mapSAPContactId.get(contact.SAP_Contact_ID__c).add(Contact);
                    }
                }
                if(contact.External_ID__c != null && contact.External_ID__c != ''){ 
                
                    if(mapExternalContactId.ContainsKey(contact.External_ID__c))
                        mapExternalContactId.get(contact.External_ID__c).add(Contact);
                    else{
                        mapExternalContactId.put(contact.External_ID__c,new List<Contact>());
                        mapExternalContactId.get(contact.External_ID__c).add(Contact);
                    }
                }
                if(mapContactId.ContainsKey(contact.ID))
                    mapContactId.get(contact.ID).add(Contact);
                else{
                    mapContactId.put(contact.ID,new List<Contact>());
                    mapContactId.get(contact.ID).add(Contact);
                }
            }
            if(mapSAPContactId.containsKey(matchStringSAPContactId)){
                matchedContactsList = mapSAPContactId.get(matchStringSAPContactId);
                system.debug('***Maps:::map1');
            }
            else if(mapExternalContactId.containsKey(matchStringExternalContactId)){
                matchedContactsList = mapExternalContactId.get(matchStringExternalContactId);                    
                system.debug('***Maps:::map2');
            }else if(mapContactId.containsKey(matchStringContactId)){
                matchedContactsList = mapContactId.get(matchStringContactId);                    
                system.debug('***Maps:::map3');
            }
            system.debug('*****matchedContactsList' + matchedContactsList );
            for (Contact Contact : matchedContactsList) {
                ContactOption ContactOption = new ContactOption(Contact);
                contactOptions.add(ContactOption);    
            }  
            if(contactOptions.isEmpty())
            {
                ContactOption defaultContactOption = new ContactOption();
                defaultContactOption.IsSelected = true;
                defaultContactOption.Contact.FirstName= 'Create New Contact: ' + l.name;
                defaultContactOption.Contact.email= 'sample@email.com';
        
                contactOptions.add(defaultContactOption);
            }      
            
        }
        return contactOptions;
}
/*    
private List<ContactOption> fetchContactMAtches(lead l){
    
        List<ContactOption> contactOptions = new List<ContactOption>();
        map<string,List<Contact>> mapFNLNEmail= new map<string,List<Contact>>();
        map<string,List<Contact>> mapFNLNPhne= new map<string,List<Contact>>();
        map<string,List<Contact>> mapEmail= new map<string,List<Contact>>();
        map<string,List<Contact>> mapFNLN= new map<string,List<Contact>>();
        List<contact> matchedContactsList= new List<contact>();
        
        
        ContactOption defaultContactOption = new ContactOption();
        defaultContactOption.IsSelected = true;
        defaultContactOption.Contact.FirstName= 'Create New Contact: ' + l.name;
        defaultContactOption.Contact.email= ''; 

        ContactOptions.add(defaultContactOption);
        
        system.debug('****contactMatch' + selectedAccountAttribute + 'l.FirstName' + l.FirstName );
       
        string matchStringFNLNEmail= l.FirstName + l.LastName + l.Email;
        string matchStringFNLNPhne= l.FirstName + l.LastName + l.Phone;
        string matchStringEmail= l.Email;
        string matchStringFNLN= l.FirstName + l.LastName ;
        
        system.debug('***matchstrings' + matchStringFNLNEmail +'str2'+ matchStringFNLNPhne +'str3'+matchStringEmail+'str4' + matchStringFNLN);
        
        
        if(this.selectedAccountAttribute != null && this.selectedAccountAttribute != ''){
            List<Contact> ContactQueryResult = [SELECT id,FirstName,LastName,name,Email,Title,Job_Function__c,Work_Direct__c,Phone,Contact_Type__c,SAP_Role__c,SAP_Account_Number__c,account.name FROM Contact 
                                                    WHERE accountid= : this.selectedAccountAttribute];
                                                    
            system.debug('***ContactQueryResult' +ContactQueryResult);
            matchedContactsList= new List<contact>();                                       
            for (Contact Contact : ContactQueryResult) {
                if(contact.FirstName!= null && contact.LastName!= null && contact.Email!= null &&
                     contact.FirstName!= ''&& contact.LastName!= ''&& contact.Email!= ''){
                    if(mapFNLNEmail.ContainsKey(contact.FirstName+contact.LastName+contact.Email))
                        mapFNLNEmail.get(contact.FirstName+contact.LastName+contact.Email).add(Contact);
                    else{
                        mapFNLNEmail.put(contact.FirstName+contact.LastName+contact.Email,new List<Contact>());
                        mapFNLNEmail.get(contact.FirstName+contact.LastName+contact.Email).add(Contact);
                    }
                }
                
                if(contact.FirstName!= null && contact.LastName!= null && contact.Phone!= null &&
                     contact.FirstName!= ''&& contact.LastName!= ''&& contact.Phone!= ''){ 
                
                    if(mapFNLNPhne.ContainsKey(contact.FirstName+contact.LastName+contact.Phone))
                        mapFNLNPhne.get(contact.FirstName+contact.LastName+contact.Phone).add(Contact);
                    else{
                        mapFNLNPhne.put(contact.FirstName+contact.LastName+contact.Phone,new List<Contact>());
                        mapFNLNPhne.get(contact.FirstName+contact.LastName+contact.Phone).add(Contact);
                    }
                }
                if(contact.Email!= null && contact.Email != ''){
                    if(mapEmail.ContainsKey(contact.Email))
                        mapEmail.get(contact.Email).add(Contact);
                    else{
                        mapEmail.put(contact.Email,new List<Contact>());
                        mapEmail.get(contact.Email).add(Contact);
                    }
                }
                if(contact.FirstName!= null && contact.LastName!= null  &&
                     contact.FirstName!= ''&& contact.LastName!= ''){ 
                    if(mapFNLN.ContainsKey(contact.FirstName+contact.LastName))
                        mapFNLN.get(contact.FirstName+contact.LastName).add(Contact);
                    else{
                        mapFNLN.put(contact.FirstName+contact.LastName,new List<Contact>());
                        mapFNLN.get(contact.FirstName+contact.LastName).add(Contact);
                    }
                }
                
                system.debug('***Maps:::map1' + mapFNLNEmail +'map2' +  mapFNLNPhne +'map3' + mapEmail +'map4' + mapFNLN);
                if(mapFNLNEmail.containsKey(matchStringFNLNEmail)){
                    matchedContactsList = mapFNLNEmail.get(matchStringFNLNEmail);
                    system.debug('***Maps:::map1');
                }
                else if(mapFNLNPhne.containsKey(matchStringFNLNPhne)){
                    matchedContactsList = mapFNLNPhne.get(matchStringFNLNPhne);                    
                    system.debug('***Maps:::map2');
                }
                else if(mapEmail.containsKey(matchStringEmail)){
                    matchedContactsList = mapEmail.get(matchStringEmail);
                    system.debug('***Maps:::map3' + matchedContactsList );
                }
                else if(mapFNLN.containsKey(matchStringFNLN)){
                    matchedContactsList = mapFNLN.get(matchStringFNLN);                    
                    system.debug('***Maps:::map4');
                }
            
            }
                                                    
            system.debug('*****matchedContactsList' + matchedContactsList );
            for (Contact Contact : matchedContactsList) {
                ContactOption ContactOption = new ContactOption(Contact);
                ContactOptions.add(ContactOption);
            }        
            
        }
        return ContactOptions; 
        
    }
*/    
    
    public class ContactOption {
        //Properties
        public boolean IsSelected {get;set;}
        public Contact Contact {get;set;}
        
        //Constructors
        public ContactOption() {
            this.IsSelected = false;
            this.Contact = new Contact();
        }
        
        public ContactOption(Contact oContact) {
            this();
            this.Contact = oContact;
        }
    }
    
    public pagereference selectContact(){
        selectedContact = System.currentPagereference().getParameters().get('contactId');
        return null;
    }
    
    public pagereference selectPrimaryContact(){        
        primaryContactId = System.currentPagereference().getParameters().get('pcontactId');
        system.debug('*****primaryContactId' + primaryContactId );
        return null;
    }
    
    public void checkRequiredFields(){
        Schema.DescribeSObjectResult Opportunitydescresult = Schema.SObjectType.Lead;         
            if(primaryLead.Billing_Street__c==null && primaryLead.PO_Box__c==null){
              sErrorMsg += '  Billing Street or PO Box';
              bError = true;
            }
            for(String sfield : mapAccountfields.Keyset()){
               if(primaryLead.get(sfield)==null){ System.debug(sfield+'&&&&&');
                  //sErrorMsg += '  '+mapAccountfields.get(sfield) ;
                  sErrorMsg +=  '  '+Opportunitydescresult.fields.getMap().get(sfield).getDescribe().getlabel();
                  bError = true;
                }
            }        
            sErrorMsg =sErrorMsg.trim();
            sErrorMsg =sErrorMsg.replace('  ',', ');
            if(bError == true){
                
                //primaryLead.addError( 'Please navigate back to Lead and enter values for '+sErrorMsg+'.');
                primaryLead.addError( Label.Lead_Convert_Error+' '+sErrorMsg+'.');
                
            }
    }
    
    @TestVisible
    private boolean isValidPrimaryLead(){
        if(primaryLead.Status.toLowerCase() == 'Rejected' || primaryLead.Status.toLowerCase() == 'Discarded'){            
            return false;            
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Lead_Convert_Not_Valid_for_Reject_Discard));    
        }
        else
            return true;
    
    }
    
    @TestVisible
    private void insertFollowUpTask(Database.LeadConvertResult leadConvertResult) {
        Id accountId = leadConvertResult.getAccountId();
        String tempPrimaryContactId = '';
        for(ContactOption co:leadContactOptions)
        {
            if(co.contact.id != null)
                tempPrimaryContactId = co.contact.id;
        }
        Id contactId = (tempPrimaryContactId != null && tempPrimaryContactId != '' && tempPrimaryContactId != leadConvertResult.getContactId())?tempPrimaryContactId:leadConvertResult.getContactId();
        //Id contactId = leadConvertResult.getContactId();
        Id opportunityId = leadConvertResult.getOpportunityId();        
        FollowUpTask.WhoId = contactId;
        FollowUpTask.WhatId = (convertedOpportunityId == null ? accountId : convertedOpportunityId);   
        try{     
            insert FollowUpTask;
            system.debug('FollowUpTask : '+FollowUpTask);
            system.debug('*** LOG STATUS:: Followup Task Created Successfully');
        }catch(DMLException dmlEx){
          
              system.debug('*** create FollowUp Task error:: '+ dmlEx.getMEssage());
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
          
          }
    }
    
    
    @TestVisible
    private void createLeadTasksUnderOpp(){
        List<Task> tasksToUpdate = new List<Task>();
        system.debug('createLeadTasksUnderOpp : selectedLeads : '+selectedLeads);
        for(string lID: selectedLeads){
            system.debug('createLeadTasksUnderOpp : tasksForLeadMap : '+tasksForLeadMap);
            if(tasksForLeadMap!= null && tasksForLeadMap.get(lID) != null){
                for(Task t: tasksForLeadMap.get(lID)){
                    t.whatId = convertedOpportunityId;
                    string contactId = leadToContactMapAfterConversion.get(lId);
                    t.whoId= contactId;
                    tasksToUpdate.add(t);
                
                } 
            }
        }
        try{
            update tasksToUpdate;
            system.debug('createLeadTasksUnderOpp : tasksToUpdate : '+tasksToUpdate);
            System.debug('*** LOG STATUS:: Tasks created successfully under Oportunity');
        }catch(DMLException dmlEx){
          
              system.debug('*** createLeadTasksUnderOpp error:: dmlEx.getMEssage()');
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
          
          }
  
    }
    
    //MCL-1574
    @TestVisible
    private void createLeadEventsUnderOpp(){
        List<Event> EventsToUpdate = new List<Event>();
        system.debug('createLeadEventsUnderOpp : selectedLeads : '+selectedLeads);
        for(string lID: selectedLeads){
            system.debug('createLeadEventsUnderOpp : eventsForLeadMap : '+eventsForLeadMap);
            if(eventsForLeadMap!= null && eventsForLeadMap.get(lID) != null){
                for(Event e: eventsForLeadMap.get(lID)){
                    e.whatId = convertedOpportunityId;
                    string contactId = leadToContactMapAfterConversion.get(lId);
                    e.whoId= contactId;
                    EventsToUpdate.add(e);
                
                } 
            }
        }
        try{
            update eventsToUpdate;
            system.debug('createLeadEventsUnderOpp : eventsToUpdate : '+eventsToUpdate);
            System.debug('*** LOG STATUS:: Events created successfully under Oportunity');
        }catch(DMLException dmlEx){
          
              system.debug('*** createLeadEventsUnderOpp error:: dmlEx.getMEssage()');
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
          
          }
  
    }

    // Copy Leads tasks to Opportunity
    public void fetchLeadActivities(){   
        
        system.debug('***SelectedLeadIds' + SelectedLeads);
        TaskListforLeads = [SELECT id,callType,ActivityDate,Status,whoId,Subject,whatId,ownerId FROM TASK WHERE whoid IN : SelectedLeads];
        EventListforLeads = [SELECT id,Type,ActivityDate,Status__c,whoId,Subject,whatId,ownerId FROM EVENT WHERE whoid IN : SelectedLeads];
        for(Task t: taskListforLeads){
                if(tasksForLeadMap.ContainsKey(t.WhoId))
                    tasksForLeadMap.get(t.whoId).add(t);
                else{
                    tasksForLeadMap.put(t.whoId,new List<Task>());
                    tasksForLeadMap.get(t.WhoId).add(t);
                } 
        }
        //MCL-1574
        for(Event e: EventListforLeads){
                if(EventsForLeadMap.ContainsKey(e.WhoId))
                    EventsForLeadMap.get(e.whoId).add(e);
                else{
                    EventsForLeadMap.put(e.whoId,new List<Event>());
                    EventsForLeadMap.get(e.WhoId).add(e);
                } 
        }
        system.debug('**** newTasksToOpp' + newTasksToOpp);     
    }
    
    @testVisible
    private void UpdateAccountfields(Id AccId){
        Account oAccount = [Select BillingCity,BillingState,BillingStreet,BillingPostalCode from Account where Id =: convertedAccountId];
        system.debug('***oAccount' +oAccount);
        oAccount.BillingCity = primaryLead.Billing_City__c; 
        oAccount.BillingStreet = primaryLead.Billing_Street__c;
        oAccount.BillingPostalCode = primaryLead.Billing_Zip__c;
        oAccount.BillingState = primaryLead.Billing_State__c;
        oAccount.BillingCountry = primaryLead.Billing_Country__c;
       
        try{
            Update oAccount;
            system.debug('***oAccount after update' +oAccount);
        }catch(DMLException dmlEx){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
           }
   }   
  
    @testVisible
    private void UpdateOpportunityfields(Id OppId){
    
       // if(selectedOppid == null || selectedOppId == ''){
        
            Opportunity oOpportunity = [Select CampaignId,RecordTypeId ,description from Opportunity where Id =: OppId];
            oOpportunity.CampaignId = this.CampaignId;
            oOpportunity.description  = this.description;
            oOpportunity.Source__c = this.Source;
            oOpportunity.Type = this.LeadType;
            oOpportunity.Status__c = 'Converted';
            
             
           try{
               update oOpportunity;
               
           }catch(DMLException dmlEx){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,dmlEx.getMEssage()));
           }
      // }   
    
    }
    
    @TestVisible
    private Id findExistingAccountId(string mdbId, string sapId) {
        
        Id accountId = findExistingAccountIdByMDBId(mdbId);
        system.debug('****accountId step1MDB'+ accountId );
        if (accountId == null) {
            accountId = findExistingAccountIdBySAPId(sapId);
        }
        
        return accountId;
    }
    
    @TestVisible
    private Id findExistingAccountIdByMDBId(string mdbId) {
        Id accountId = null;
        
        if (AppUtil.isEmpty(mdbId) == false) {
            List<Account> accounts = [SELECT Id FROM Account WHERE MDBID__c = :mdbId];
            system.debug('****accounts step2MDB'+ accounts);
            if (accounts.isEmpty() == false) {
                accountId = accounts[0].Id;
                system.debug('****accountid step3MDB'+ accounts[0].Id);
            }
        }
        
        return accountId;
    }
    
    @TestVisible
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
    
}