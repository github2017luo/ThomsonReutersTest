/**
     * CHANGE HISTORY
     * =============================================================================
     * Date         Name                    Description
     * 2013-10-15   Nandita Shet            Created
     * 2017-03-27   Karthi                  Optimized the code as per JIRA STORY: PS0-1
     * 2017-10-09   Seema                   Updated for CRM-6642
     * 2017-11-14   Harika Devi Kalidindi   Updated Contract description as per CRM -11167
     * 2020-4-3     Shyamsundar Shet        BMP-1594 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

     * =============================================================================
     */ 
    public with sharing class IncentivePasswordControllerOpty {
     //Protected Members
      public final ApexPages.StandardController oStandardController{get;set;}
      public final Opportunity oOpportunity{get;set;}
      public List<contact> addContactList{get;set;}
      public ApexPages.StandardController oStandardCntrllerContact{get{return new ApexPages.StandardController(oContact);} set;}   
      public Contact oContact{get;set;}
      private integer currentPage;
      private List<contact> WestlawContactList{get;set;}
      private List<contact> WestlawNextContactList{get;set;}  
      private List<contact> PublicRecordsContactList{get ;set;}
      private List<contact> BusinessLawResearchGSIContactList{get ;set;}
      public string currentTab{get;set;}
      private static List<IncentivePromotion> listWestlawPromotions;
      private static List<IncentivePromotion> listWestlawNextPromotions;
      private static List<IncentivePromotion> listPublicRecordsPromotions;
      private static List<IncentivePromotion> listBusinessLawResearchGSIPromotions;  
      public boolean HasMatchingContacts {get;set;}
      public boolean SkipContactMatching {get;set;}
      public List<MatchedContact> MatchedContacts {get;set;}
      public List<DataQualityUtil.ContactInfo> listMatchedContacts{get;set;}
      public Id OptyId {get;set;}
        //Properties
      public List<IncentivePromotion> IncentivePromotionHistory {get;set;}
      public Incentive_Promotion__c WestLawPromotion {get;set;}
      public Incentive_Promotion__c WestLawNextPromotion {get;set;}
      public Incentive_Promotion__c PublicRecordsPromotion {get;set;}
      public Incentive_Promotion__c BusinessLawResearchGSIPromotion {get;set;}
      public integer WestlawGenericPasswords {get;set;}
      public integer GSIGenericPasswords {get;set;}
      Public List<contactSet> contactSetList{get;set;}
      public List<IncentivePromotion> WestlawPromotions {get;set;}
      public List<IncentivePromotion> WestlawNextPromotions {get;set;}
      public List<IncentivePromotion> PublicRecordsPromotions {get;set;}
      public List<IncentivePromotion> BusinessLawResearchGSIPromotions {get;set;} 
      public string cName{get;set;}
      public string TabInFocus{get;set;}
      public Map<id,contact> contactsTemplateMap = new Map<id,contact>();
       
        //Added for CRM-6642  
       public static boolean sendEmailcheck = false;
       public Static boolean opptytask = false;
       public boolean trialIndicator{get;set;}
       public boolean automatedEmailCheckbox{get;set;}
       public static string LCRMSubBu{get;set;}
       public Contract contractObj{get;set;}
       public List<OpportunityLineItem> oliList{get;set;}
       public List<Contract_Line_Item__c> cliList{get;set;}
        public  List<Contract> contractList{get;set;} //Added for 6259
         
          

      //Constructors
      
      /**
       * Account Standard Controller Constructor
       */
      public IncentivePasswordControllerOpty(ApexPages.StandardController oController) {
    /*System.debug('%%%%'+TabInFocus);-- commented to reduce character for s2e optimization */
        try {
          System.debug('***OnLoad***');
          System.debug('***TabInFocus***'+TabInFocus);
           System.debug('***CurrentTab***'+currentTab);
          oStandardController = oController;
     //   if(oController.getRecord().Id!=null ){ 
              oOpportunity = (Opportunity) [Select Id,OwnerId,AccountId,Account.Name,Account.AccountNumber,Account.Phone,
                     Account.Industry,Account.BillingStreet,Account.BillingCity,Account.BillingState,
                    Account.BillingPostalCode,Account.BillingCountry,Account.ShippingStreet,
                    Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,
                    Account.ShippingPostalCode,Name from opportunity where Id =: oController.getRecord().Id];
              WestlawPromotion = new Incentive_Promotion__c();
              WestlawPromotion.Assigned_To__c = UserInfo.getUserId();
              WestlawNextPromotion = new Incentive_Promotion__c();
              WestlawNextPromotion.Assigned_To__c = UserInfo.getUserId();
              PublicRecordsPromotion = new Incentive_Promotion__c();
              PublicRecordsPromotion.Assigned_To__c = UserInfo.getUserId();
              BusinessLawResearchGSIPromotion = new Incentive_Promotion__c();
              BusinessLawResearchGSIPromotion.Assigned_To__c = UserInfo.getUserId();
              WestlawGenericPasswords = 0;
              GSIGenericPasswords = 0;
              WestlawPromotions = new List<IncentivePromotion>();
              WestlawNextPromotions = new List<IncentivePromotion>();
              PublicRecordsPromotions = new List<IncentivePromotion>();
              BusinessLawResearchGSIPromotions = new List<IncentivePromotion>();
              IncentivePromotionHistory = getIncentivePromotionHistory(oOpportunity.AccountId);  currentpage=1;
           //   if(ApexPages.currentPage().getParameters().get('FromContact')==null){
              cName='';
              currentTab='History';
              currentpage=1;
              WestlawContactList = new list<contact>();
              WestlawNextContactList = new list<contact>();
              PublicRecordsContactList = new list<contact>();
              BusinessLawResearchGSIContactList = new list<contact>();
              TabInFocus='tabHistory'; 
              oContact = new Contact();
        //  }
              addContactList =getAddContact(oOpportunity.AccountId,cName);
              HasMatchingContacts = false;
              this.Matchedcontacts = new List<Matchedcontact>();
              this.SkipContactMatching = false;
            
              //start:added for CRM-6642
              trialIndicator = true;
              automatedEmailCheckbox = false;
              sendEmailcheck = false;
             cliList = new List<Contract_Line_Item__c>();
              oliList = new List<OpportunityLineItem>();  
                  oliList  = [Select Id,Product2Id, LCRM_Product_Type__c, LCRM_Product_Category__c, LCRM_Action__c, LCRM_Current_ACV__c, LCRM_New_ACV_SalesPrice__c, LCRM_Incremental_Amount__c, LCRM_Source_Opportunity__c, LCRM_Units__c from OpportunityLineItem where OpportunityId = :oOpportunity.id];
            //End: Added for CRM-6642
            contractList = new List<Contract>(); // Added for CRM-6259
        }
        catch (Exception oException){
          ApexPages.addMessages(oException);
        }
      }
      
    
        //Public Methods  
      /**
       * Lazy loads the Westlaw open promotions
       */
      public void loadWestlawOpenPromotions() {
        try {
          currentTab='Westlaw';
          TabInFocus = 'tabWestlawRequest';
          searchContact();
          if (listWestlawPromotions == null) {
            listWestlawPromotions = new list<IncentivePromotion>();
            //listWestlawPromotions.addall(requestOpenPromotions('WESTLAW','WEST','WAMS',WestlawPromotion.Assigned_To__c));
             listWestlawPromotions.addall(requestOpenPromotions('Westlaw', WestlawPromotion.Assigned_To__c));
          }
          WestlawPromotions = listWestlawPromotions;
        }
        catch (Exception oException){
          ApexPages.addMessages(oException);
        }
      }
      
      
     // ******loadBusinessLawResearchGSIPromotions
        
      public void loadBusinessLawResearchGSIPromotions(){
        try {
          currentTab='BusinessLawResearchGSI';
           TabInFocus = 'tabBusinessLawResearchGSI';
          searchContact();
          if (listBusinessLawResearchGSIPromotions == null) {
            listBusinessLawResearchGSIPromotions = new list<IncentivePromotion>();       
            //listBusinessLawResearchGSIPromotions.addall(requestOpenPromotions('WESTLAW','GSI','WLB',BusinessLawResearchGSIPromotion.Assigned_To__c));
            listBusinessLawResearchGSIPromotions.addall(requestOpenPromotions('GSI', BusinessLawResearchGSIPromotion.Assigned_To__c));
          }
          BusinessLawResearchGSIPromotions  = listBusinessLawResearchGSIPromotions;
        }
        catch (Exception oException){
          ApexPages.addMessages(oException);
        }
      }
      
      
      
      /**
       * Lazy loads the WestlawNext open promotions
       */
      public void loadWestlawNextOpenPromotions(){
        try {
          currentTab='WestlawNext';
           TabInFocus = 'tabWestlawNextRequest';
          searchContact();
          if (listWestlawNextPromotions == null){
            //listWestlawNextPromotions = requestOpenPromotions('COBALT','WEST','WAMS',WestlawNextPromotion.Assigned_To__c);
            listWestlawNextPromotions = requestOpenPromotions('WestlawNext', WestlawNextPromotion.Assigned_To__c);
          }
          WestlawNextPromotions = listWestlawNextPromotions;
        }
        catch (Exception oException){
          ApexPages.addMessages(oException);
        }
      }
      
        
      /**
       * Lazy loads the PublicRecords open promotions
       */
      public void loadPublicRecordsOpenPromotions(){
        try {
          currentTab='PublicRecords';
          TabInFocus = 'tabPublicRecords';
          searchContact();
          if (listPublicRecordsPromotions == null){
            //listPublicRecordsPromotions = requestOpenPromotions('WESTLAW','WEST','PUBRECS',PublicRecordsPromotion.Assigned_To__c);
            listPublicRecordsPromotions = requestOpenPromotions('PublicRecords', PublicRecordsPromotion.Assigned_To__c);
          }
          PublicRecordsPromotions = listPublicRecordsPromotions;
        }
        catch (Exception oException){
          ApexPages.addMessages(oException);
        }
      }
      
       /**
       * Saves the Passwords record
       */
      public void saveHistory(){
        try {
            List<Incentive_Password__c> selectedPwds = new List<Incentive_Password__c>();
            for(IncentivePromotion hist:IncentivePromotionHistory ){
                for(PromotionPassword promoPwd:hist.PromotionPasswords){                
                        selectedPwds.add(promoPwd.Incentive);
                }
            }
            //system.debug('*****'+selectedPwds.size()+selectedPwds[0].contact__c);
            update selectedPwds;
        }
        catch (DmlException oException) {
          ApexPages.addMessages(oException);
        }
        IncentivePromotionHistory = getIncentivePromotionHistory(oOpportunity.AccountId);
      }
      
       /**
       *Returns string Url to Open
       
       */
        public string getUrlOpen(){
            string urlopen ='';      
            for(IncentivePromotion hist:IncentivePromotionHistory ){
                if(hist.IsSelected){
                    if(urlopen=='')               
                      urlopen ='/apex/IncentivePasswordDocument?Type=Promo&Pid='+hist.Promotion.id;
                }
            }
             for(IncentivePromotion hist:IncentivePromotionHistory ){
                for(PromotionPassword promoPwd:hist.PromotionPasswords){
                    if(promoPwd.IsSelected){
                        if(urlopen=='')
                          urlopen='apex/IncentivePasswordDocument?Type=Individual&Pid='+PromoPwd.Incentive.id; 
                    }   
                }
            }
            if(urlopen=='')
                urlopen='error';
         return urlopen;        
        }  
        
         public string getTrialPromoUrlOpen(){
        string urlopen ='';  
        for(IncentivePromotion hist:IncentivePromotionHistory ){
            if(hist.IsSelected){
                if(urlopen=='')          
                    urlopen ='/apex/LCRMNonTrialPromoDocument?Type=Promo&Indicator=trial&Pid='+hist.Promotion.id;
            }
        }
        for(IncentivePromotion hist:IncentivePromotionHistory ){
            for(PromotionPassword promoPwd:hist.PromotionPasswords){
                if(promoPwd.IsSelected){
                    if(urlopen=='')
                        urlopen='apex/LCRMNonTrialPromoDocument?Type=Individual&Indicator=trial&Pid='+PromoPwd.Incentive.id; 
                }
            }
        }
        if(urlopen=='')
            urlopen='error';
        return urlopen;        
    }
          
          /**
       * Contact standard set controller for adding contacts
       */
      public ApexPages.StandardSetController standardSetCon {
            get {
                if(standardSetCon == null) {
                    standardSetCon = new ApexPages.StandardSetController(addContactList);
                    // sets the number of records in each page set
                    standardSetCon .setPageSize(10);
                    standardSetCon.setpageNumber(currentPage);
                }
                return standardSetCon ;
            }
            set;
        }
     
        /**
       * Gets the current list for adding contacts
       *@return List of contactSet object
       */
        public List<contactSet> getCurrentList() {
           contactSetList = new List<contactSet>();       
            for (contact category : (List<contact>)standardSetCon.getRecords())
                contactSetList.add(new contactSet(category));
            return contactSetList;
        }
        
         /**
       * Gets the current list for selected contact for the selected tab
       *@return List of contact object
       */
        public List<Contact> getSelectedContact() {
           if(currentTab == 'Westlaw')
                return WestlawContactList;
            if(currentTab == 'WestlawNext')
                return WestlawNextContactList;
            if(currentTab == 'PublicRecords')
                return PublicRecordsContactList;
            if(currentTab == 'BusinessLawResearchGSI')
              return BusinessLawResearchGSIContactList;
          return(new List<contact>());    
        }
        
       
         /**
       *adds the contact to ContactList   
       */
        public void addContact() {
        try{
            List<contact> selectedContactList = new list<contact>();
            for(Contactset cs : contactSetList){
                if(cs.checked){                
                    selectedContactList.add(cs.oContact);
                }
            }
             if(selectedContactList.size()<= 50)
             {
            if(currentTab == 'Westlaw')
                WestlawContactList.addAll(selectedContactList);
            if(currentTab == 'BusinessLawResearchGSI')
                BusinessLawResearchGSIContactList.addAll(selectedContactList);
            if(currentTab == 'WestlawNext')
                WestlawNextContactList.addAll(selectedContactList);
            if(currentTab == 'PublicRecords')
                PublicRecordsContactList.addAll(selectedContactList);   
            currentPage= (standardSetCon.getHasNext()?standardSetCon.getPageNumber():(standardSetCon.getHasPrevious()?standardSetCon.getPageNumber()-1:standardSetCon.getPageNumber())); 
            standardSetCon = null;
            addContactList =getAddContact(oOpportunity.AccountId,cName);
         }
         else 
    {
    //throw new customException('No promotions have been selected');   //Replaced with Custom Label as part of S2E Optimization         
                    throw new customException(Label.Contact_and_Promotions_Limit);
    }
    
    }
    
    catch (Exception oException) {
            ApexPages.addMessages(oException);
        } 
       
        }
        
        /**
       *searches the contact in addContact   
       */
        public void searchContact() {
          standardSetCon = null;
          currentpage=1;
            addContactList =getAddContact(oOpportunity.AccountId,cName);  
        }
      
       /**
       *Removes the contacts from selectedContactList
       
       */
        public void removeContact(){ 
            integer intRemove = -1;
            List<contact> selectedContactList = new list<contact>();    
            id removeId=ApexPages.currentPage().getParameters().get('removeId');        
            selectedContactList=getSelectedContact();     
            for(integer count = 0;count<selectedContactList.size();count ++){
                if(removeId==selectedContactList.get(count).id){
                  intRemove = count;  
                }
            }
            if(intRemove != -1){
                selectedContactList.remove(intRemove);
            } 
            if(currentTab == 'Westlaw')
                WestlawContactList = selectedContactList;
          if(currentTab == 'BusinessLawResearchGSI')
              BusinessLawResearchGSIContactList = selectedContactList;
            if(currentTab == 'WestlawNext')
                WestlawNextContactList = selectedContactList;
            if(currentTab == 'PublicRecords')
                PublicRecordsContactList = selectedContactList; 
            searchContact();       
        }
        
        /**
       *Method to create contract:Added for CRM-6642
       
       */
      public Contract addContract(){
                Contract conObj = new Contract();
                conObj.Status = 'Draft';
                conObj.AccountId = oOpportunity.accountID;
                conObj.LCRM_Originating_Opportunity__c = oOpportunity.id;
                conObj.Description = 'Promo Password'; //Updated as per CRM -11167
                conObj.ownerid = oOpportunity.ownerid;
                conObj.LCRM_Transaction_Type__c = 'Unpaid Trial';
                conObj.LCRM_Trial_Channel__c = 'Trial Promo Password'; //Added as per CRM-6259
                System.debug('contractObj-->'+conObj);
                return conObj;
      }
      
      
       /**
       *Method to create Contract line Items:added for CRM-6642
        
       */
      public List<Contract_Line_Item__c> addCLI(List<OpportunityLineItem> oliList){
          System.debug('**Inside add CLI**');
          System.debug('oliList'+oliList.size());
          for(OpportunityLineItem oli : oliList){
                Contract_Line_Item__c tempCli = new Contract_Line_Item__c();
                tempCli.Price__c = 0;
                tempCli.Product__c = oli.Product2Id;
                tempCli.Units__c = 1;
                cliList.add(tempCli);     
          }
          return cliList;
      }
      
       /**
       *Returns westlaw Promotions
       
       */
        public pagereference SubmitWestlawRequest() {
            try{        
            if(WestlawContactList.size() != 0 || WestlawGenericPasswords != 0){
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:WestlawPromotions){
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0){
                  requestPassword(selectedPromotions,WestlawContactList,true);
                  IncentivePromotionHistory = getIncentivePromotionHistory(oOpportunity.AccountId);
                  WestlawContactList = new list<contact>();
                  CurrentTab='History';
                  return apexpages.currentpage();    
                }
                else{
                    // throw new customException('No promotions have been selected'); //Replaced with Custom Label as part of S2E Optimization
                    throw new customException(Label.NoPromoEx);            
                }   
            }
            else{            
                  // throw new customException('No Contacts have been selected or Generic Passwords Requested');  //Replaced with Custom Label as part of S2E Optimization
                 throw new customException(Label.NoContactEx);         
            }
           }
           catch (Exception oException){
              ApexPages.addMessages(oException);
            } 
            return null;
        }
        
        
         
       //*** Returns BusinessLawResearchGSI Promotions
       
         
        public pagereference SubmitBusinessLawResearchGSIRequest() {
            try{        
            if(BusinessLawResearchGSIContactList.size() != 0 || GSIGenericPasswords != 0){
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:BusinessLawResearchGSIPromotions){
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0){
                  requestPassword(selectedPromotions,BusinessLawResearchGSIContactList,true);
                  IncentivePromotionHistory = getIncentivePromotionHistory(oOpportunity.AccountId);
                  BusinessLawResearchGSIContactList = new list<contact>();
                  CurrentTab='History';
                  return apexpages.currentpage();    
                }
                else{
                    // throw new customException('No promotions have been selected'); //Replaced with Custom Label as part of S2E Optimization
                    throw new customException(Label.NoPromoEx);            
                }   
            }
            else{            
                  // throw new customException('No Contacts have been selected or Generic Passwords Requested');  //Replaced with Custom Label as part of S2E Optimization
                 throw new customException(Label.NoContactEx);         
            }
           }
           catch (Exception oException) {
              ApexPages.addMessages(oException);
            } 
            return null;
        }
      
      
        
         /**
       *Returns westlawnext Promotions
       
       */
        public pagereference SubmitWestlawNextRequest() { 
          try{
           if(WestlawNextContactList.size() != 0 ){
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:WestlawNextPromotions){
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0){
                  requestPassword(selectedPromotions,WestlawNextContactList,false);
                  IncentivePromotionHistory = getIncentivePromotionHistory(oOpportunity.AccountId);
                  WestlawNextContactList = new list<contact>();
                   CurrentTab='History';
                  return apexpages.currentpage();    
                }
                else{
                    // throw new customException('No promotions have been selected'); //Replaced with Custom Label as part of S2E Optimization
                     throw new customException(Label.NoPromoEx);            
                }   
            }
            else{            
                    // throw new customException(''No Contacts have been selected'); //Replaced with Custom Label as part of S2E Optimization
                    throw new customException(Label.NoContactEx1);          
            }
           }
           catch (Exception oException) {
              ApexPages.addMessages(oException);
            } 
            return null;
        }
        
         /**
       *Returns westlawnext Promotions for GLI: added for CRM-6642
       
       */
        public pagereference submitPromoPasswordRequest() { 
          try{
          
          System.debug('++InsidesubmitPromoPasswordRequest++');
          System.debug('automatedEmailCheckbox2--->'+automatedEmailCheckbox);
          system.debug('trialIndicator:: '+trialIndicator );
           automatedEmailCheckbox = true;
           if(WestlawNextContactList.size() != 0 ){
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:WestlawNextPromotions){
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0){
                if(selectedPromotions.size() == 1){
                  requestTrialPassword(selectedPromotions,WestlawNextContactList,false,trialIndicator);
                  IncentivePromotionHistory = getIncentivePromotionHistory(oOpportunity.AccountId);
                  WestlawNextContactList = new list<contact>();
                   CurrentTab='History';
                  return apexpages.currentpage();    
                }
                else{
                    // throw new customException('No promotions have been selected'); //Replaced with Custom Label as part of S2E Optimization
                     throw new customException(Label.Contact_and_Promotions_Limit);            
                }   
            }
                else{
                    // throw new customException('No promotions have been selected'); //Replaced with Custom Label as part of S2E Optimization
                     throw new customException(Label.NoPromoEx);            
                }   
            }
            else{            
                    // throw new customException(''No Contacts have been selected'); //Replaced with Custom Label as part of S2E Optimization
                    throw new customException(Label.NoContactEx1);          
            }
           }
           catch (Exception oException) {
              ApexPages.addMessages(oException);
            } 
            return null;
        }
        
         /**
       *Returns westlaw Promotions
       
       */
        public pagereference SubmitPublicRecordsRequest() {
          try{   
            if(PublicRecordsContactList.size() != 0 ){
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:PublicRecordsPromotions){
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0){
                  requestPassword(selectedPromotions,PublicRecordsContactList,false);
                  IncentivePromotionHistory = getIncentivePromotionHistory(oOpportunity.AccountId);
                  WestlawContactList = new list<contact>();
                   CurrentTab='History';
                  return apexpages.currentpage();    
                }
               else{
                    // throw new customException(''No promotions have been selected'); //Replaced with Custom Label as part of S2E Optimization
                    throw new customException(Label.NoPromoEx); 
                }
            }
            else{
                // throw new customException(''No Contacts have been selected'); //Replaced with Custom Label as part of S2E Optimization
                 throw new customException(Label.NoContactEx1); 
            }
           }
           catch (Exception oException){
              ApexPages.addMessages(oException);
            } 
            return null;
        }
        
       
      //Private Methods
      
      /**
       * Initiates a request to the Incentive Password Registration service to retreive open promotions
       *
       * @param  sDomainName    the domain name filter
       * @param  sCompanyCode  the company code name filter
       * @param  sType      the promotion type filter
       * @return  a list of IncentivePromotion objects
       */
      //private List<IncentivePromotion> requestOpenPromotions(string sDomainName, string sCompanyCode, string sType, id Assignedto) {
        private List<IncentivePromotion> requestOpenPromotions(string sTabName, id Assignedto){
            List<IncentivePromotion> listIncentivePromotions = new List<IncentivePromotion>();
            IncentivePasswordRegistration.OpenPromotionRequest oPromotionRequest = new IncentivePasswordRegistration.OpenPromotionRequest();
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('Incentive Passwords');       
            oPromotionRequest.endpoint= oWebServiceSettings.Endpoint__c;
            oPromotionRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            //oPromotionRequest.username=oWebServiceSettings.Username__c;
            //oPromotionRequest.password= oWebServiceSettings.Password__c;
            try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();
          oPromotionRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        } 
            IncentivePromoTypes__c oIncentivePromoTypes = IncentivePromoTypes__c.getInstance(sTabName);
            /* skg        
            oPromotionRequest.DomainName = oIncentivePromoTypes.CompanyCode__c;
            oPromotionRequest.CompanyCode = oIncentivePromoTypes.DomainName__c;*/
            oPromotionRequest.DomainName = oIncentivePromoTypes.DomainName__c;
            oPromotionRequest.CompanyCode = oIncentivePromoTypes.CompanyCode__c;
            oPromotionRequest.PromotionType = oIncentivePromoTypes.Type__c;
            /* oPromotionRequest.DomainName = sDomainName;
            oPromotionRequest.CompanyCode = sCompanyCode;
            oPromotionRequest.PromotionType = sType;*/
            IncentivePasswordRegistration oRegistrationService = new IncentivePasswordRegistration();
            List<IncentivePasswordRegistration.Promotion> listPromotions = oRegistrationService.requestOpenPromotions(oPromotionRequest);
            for (IncentivePasswordRegistration.Promotion oRegistrationPromotion : listPromotions) {
                Incentive_Promotion__c oPromotion = new Incentive_Promotion__c();
                oPromotion.Account__c = oOpportunity.AccountId;
                oPromotion.Opportunity__c = oOpportunity.Id;
                oPromotion.Assigned_To__c = Assignedto;
                oPromotion.Reason__c = PublicRecordsPromotion.Reason__c;
                oPromotion.Name = oRegistrationPromotion.PromotionId;
                oPromotion.Description__c = oRegistrationPromotion.Description;
                oPromotion.Promotion_Number__c = oRegistrationPromotion.PromotionNumber;
                oPromotion.Start_Date__c = oRegistrationPromotion.StartDate;
                oPromotion.End_Date__c = (oRegistrationPromotion.EndDate==date.valueof('9999-12-31')?date.valueof('2999-12-31'):oRegistrationPromotion.EndDate);
                oPromotion.Domain_name__c = oRegistrationPromotion.DomainName;
                oPromotion.Promotion_key__c = oRegistrationPromotion.Key;
                oPromotion.Promotion_type__c = oRegistrationPromotion.Type;
                oPromotion.title__c = oRegistrationPromotion.Title;
                oPromotion.Company_Code__c = oRegistrationPromotion.CompanyCode;
                IncentivePromotion oIncentivePromotion = new IncentivePromotion();
                oIncentivePromotion.Promotion = oPromotion;
                listIncentivePromotions.add(oIncentivePromotion);
            }
            return listIncentivePromotions;
        }
        
         /**
       * Initiates a request to the Incentive Password Registration service to retreive Passwords and inserts into database
       *
       * @param  selectedPromotions    List<Incentive_Promotion__c> which is selected by user
       * @param  selectedContactList  list<contact> selected bys user   * 
       * 
       */
        
        Private void requestPassword(List<Incentive_Promotion__c> selectedPromotions, list<contact> selectedContactList, boolean Westlaw){
            IncentivePasswordRegistration.PromotionPasswordRequest oPasswordRequest = new IncentivePasswordRegistration.PromotionPasswordRequest();
            list<Incentive_Password__c> ListIncentivePwds = new list<Incentive_Password__c>();
            for(Incentive_Promotion__c Promotion:selectedPromotions){
                oPasswordRequest.keys.add(Promotion.promotion_key__c);                  
            }                  
            for(contact con:selectedContactList){
                IncentivePasswordRegistration.PromotionUserContact cont = new IncentivePasswordRegistration.PromotionUserContact();
                cont.MdbContactId=(con.MDB_Contact_ID__c==null?string.valueof(con.id):con.MDB_Contact_ID__c);           
                oPasswordRequest.Contacts.add(cont);
            }
            if(westlaw){
                WestlawGenericPasswords = (WestlawGenericPasswords!=0? WestlawGenericPasswords :GSIGenericPasswords);
    /*System.debug('*****'+WestlawGenericPasswords);-- commented to reduce character for s2e optimization */
                for(integer count =0;count<WestlawGenericPasswords;count++){
                   IncentivePasswordRegistration.PromotionUserContact cont = new IncentivePasswordRegistration.PromotionUserContact();    
                    cont.OnlineId ='0';
                    oPasswordRequest.Contacts.add(cont); 
                }
            }
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('Incentive Passwords');       
            oPasswordRequest.endpoint= oWebServiceSettings.Endpoint__c;
            oPasswordRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            //oPasswordRequest.username=oWebServiceSettings.Username__c;
            //oPasswordRequest.password= oWebServiceSettings.Password__c;
            try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();
          oPasswordRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        } 
            IncentivePasswordRegistration oRegistrationService = new IncentivePasswordRegistration();        
                List<IncentivePasswordRegistration.PromotionPassword> listPasswords = oRegistrationService.requestPromotionPasswords(oPasswordRequest);
    /*system.debug('*******'+listPasswords.size()+ listPasswords[0].MdbContactId + '****' + listPasswords[0].PromoKey);-- commented to reduce character for s2e optimization */
                 list<incentive_promotion__c> incentivePromotions = new list<incentive_promotion__c>();
                 list<incentive_promotion__c> incentivePromotionsupd = new list<incentive_promotion__c>();             
                 Map<string,incentive_promotion__c> keyIdPair = new map<string,incentive_promotion__c>();
                 /*for(incentive_promotion__c ipc:[select id,promotion_key__c,last_request_date__c from incentive_promotion__c where Account__c=:oOpportunity.AccountId limit 5000]){
                     if(ipc.promotion_key__c != null)
                         keyIdPair.put(ipc.promotion_key__c,ipc); 
                 }*/
                 for(Incentive_Promotion__c Promotion:selectedPromotions){
                     promotion.Last_request_date__c=system.now(); 
                      if(currentTab=='Westlaw')
                            promotion.assigned_to__c=WestLawPromotion.assigned_to__c;
                     if(currentTab=='BusinessLawResearchGSI')
                       promotion.assigned_to__c=BusinessLawResearchGSIPromotion.assigned_to__c;
                   if(currentTab=='WestlawNext')
                            promotion.assigned_to__c=WestLawNextPromotion.assigned_to__c;
                 if(currentTab=='PublicRecords')
                            promotion.assigned_to__c=PublicRecordsPromotion.assigned_to__c;                            
                   //  if(!keyIdPair.containsKey(Promotion.promotion_key__c)){                                      
                         keyIdPair.put(Promotion.promotion_key__c,Promotion);
                         incentivePromotions.add(Promotion); 
                    // }
                    /* else{
                        incentive_promotion__c promo2 = keyIdPair.get(Promotion.promotion_key__c);
                        promo2.last_request_date__c=system.now();
                       
                         incentivePromotions.add(Promo2);
                     }  */          
                } 
                 
                 upsert incentivePromotions;   
                for(IncentivePasswordRegistration.PromotionPassword pwd:listPasswords){ 
                    Incentive_Password__c oIncentivePwd = new Incentive_Password__c();
                    for(contact con:selectedContactList){
                     if(con.mdb_contact_id__c != null){
                       if(con.mdb_contact_id__c==pwd.MdbContactId ){
                           oIncentivePwd.contact__c = con.id;
                       } 
                     }  
                     else{               
                        if(string.valueof(con.id)==pwd.MdbContactId){
                            oIncentivePwd.contact__c = con.id;
                        }
                     }                              
                    }
                    for(incentive_Promotion__c Promotion:selectedPromotions){
                        if(Promotion.promotion_key__c!= null && Promotion.promotion_key__c == pwd.PromoKey){
                            oIncentivePwd.Promotion__c=keyIdPair.get(Promotion.promotion_key__c).id;                           
                        }    
                    }
                    oIncentivePwd.name=pwd.IncentiveOnlineId;
                    oIncentivePwd.Password__c=pwd.IncentivePassword;
                    oIncentivePwd.Start_Date__c=pwd.IncentiveStartDate;
                    oIncentivePwd.End_Date__c=pwd.IncentiveEndDate;
                    ListIncentivePwds.add(oIncentivePwd);   
                }                                
    /*System.debug(ListIncentivePwds.size()+'&&&&&&&&&&&&');-- commented to reduce character for s2e optimization */
                insert ListIncentivePwds;
        }
        
     /**
       * Added for CRM-6642 :Initiates a request to the Incentive Password Registration service to retreive Passwords 
      */
    Private void requestTrialPassword(List <Incentive_Promotion__c> selectedPromotions, list <contact> selectedContactList, boolean Westlaw, boolean trialIndicator) {
        IncentivePasswordRegistration.PromotionPasswordRequest oPasswordRequest = new IncentivePasswordRegistration.PromotionPasswordRequest();
        list <Incentive_Password__c> ListIncentivePwds = new list <Incentive_Password__c> ();
        for (Incentive_Promotion__c Promotion: selectedPromotions) {
            oPasswordRequest.keys.add(Promotion.promotion_key__c);
        }
        for(contact con: selectedContactList){
            IncentivePasswordRegistration.PromotionUserContact cont = new IncentivePasswordRegistration.PromotionUserContact();
            //cont.MdbContactId=(con.MDB_Contact_ID__c==null?string.valueof(con.id):con.MDB_Contact_ID__c);           
            cont.USLContactId = string.valueof(con.id);
            oPasswordRequest.Contacts.add(cont);
        }
        /**if(westlaw){
            WestlawGenericPasswords = (WestlawGenericPasswords != 0 ? WestlawGenericPasswords : GSIGenericPasswords);
            for (integer count = 0; count < WestlawGenericPasswords; count++) {
                IncentivePasswordRegistration.PromotionUserContact cont = new IncentivePasswordRegistration.PromotionUserContact();
                cont.OnlineId = '0';
                oPasswordRequest.Contacts.add(cont);
            }
        }**/
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('Incentive Passwords');
        oPasswordRequest.endpoint = oWebServiceSettings.Endpoint__c;
        oPasswordRequest.timeout = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        //oPasswordRequest.username = oWebServiceSettings.Username__c;
        //oPasswordRequest.password = oWebServiceSettings.Password__c;
        try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();
          oPasswordRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        } 
        IncentivePasswordRegistration oRegistrationService = new IncentivePasswordRegistration();
        List <IncentivePasswordRegistration.PromotionPassword> listPasswords = oRegistrationService.requestPromotionPasswords(oPasswordRequest);
        /*system.debug('*******'+listPasswords.size()+ listPasswords[0].MdbContactId + '****' + listPasswords[0].PromoKey);-- commented to reduce character for s2e optimization */
        list<incentive_promotion__c > incentivePromotions = new list<incentive_promotion__c>();
        list<incentive_promotion__c > incentivePromotionsupd = new list<incentive_promotion__c>();
        Map<string, incentive_promotion__c > keyIdPair = new map<string, incentive_promotion__c>();
        /*for(incentive_promotion__c ipc:[select id,promotion_key__c,last_request_date__c from incentive_promotion__c where Account__c=:oOpportunity.AccountId limit 5000]){
            if(ipc.promotion_key__c != null)
                keyIdPair.put(ipc.promotion_key__c,ipc); 
        }*/
        //System.debug('listPasswords:-'+listPasswords);
        for(Incentive_Promotion__c Promotion: selectedPromotions){
            promotion.Last_request_date__c = system.now();
            if(currentTab == 'Westlaw')
                promotion.assigned_to__c = WestLawPromotion.assigned_to__c;
            if(currentTab == 'BusinessLawResearchGSI')
                promotion.assigned_to__c = BusinessLawResearchGSIPromotion.assigned_to__c;
            if(currentTab == 'WestlawNext')
                promotion.assigned_to__c = WestLawNextPromotion.assigned_to__c;
            if(currentTab == 'PublicRecords')
                promotion.assigned_to__c = PublicRecordsPromotion.assigned_to__c;
            //  if(!keyIdPair.containsKey(Promotion.promotion_key__c)){                                      
            keyIdPair.put(Promotion.promotion_key__c, Promotion);
            incentivePromotions.add(Promotion);
            // }
            /* else{
                incentive_promotion__c promo2 = keyIdPair.get(Promotion.promotion_key__c);
                promo2.last_request_date__c=system.now();
               
                 incentivePromotions.add(Promo2);
             }  */
        }

        upsert incentivePromotions;
        
        contractObj = addContract();
        if (contractObj != null) {
            try {
                //CRM-6259 startscontractList
                List <Contract> contractList = [Select Id, Status, LCRM_Transaction_Type__c, LCRM_Originating_Opportunity__c from Contract where LCRM_Originating_Opportunity__c =: oOpportunity.id and LCRM_Trial_Channel__c = 'Trial Promo Password'];
                System.debug('testcontractList.size()'+contractList.size());
                if (contractList.size() > 0) {
                    System.debug('testcontractList'+contractList);

                    for (Contract c: contractList) {
                        c.status = 'Expired';
                        c.TR_Retention__Contract_End_Date__c = System.TODAY();
                    }
                }
                update contractList;
                System.debug('update_contractList:'+contractList);
                //CRM-6259 ends  
                upsert contractObj;

                cliList = addCLI(oliList);
                System.debug('insertCLI-->' + cliList.size());
                System.debug('insertCLI:-'+cliList);
                if(cliList != null && cliList.size() > 0) {
                    for (Contract_Line_Item__c cli: cliList) {
                        cli.Contract__c = contractObj.ID;
                    }
                    insert cliList;
                }
                //System.debug('listPasswords--'+listPasswords);
                for(IncentivePasswordRegistration.PromotionPassword pwd: listPasswords){
                    Incentive_Password__c oIncentivePwd = new Incentive_Password__c();
                    oIncentivePwd.LCRM_Trial_Indicator__c = trialIndicator;
                    oIncentivePwd.LCRM_Automated_Email__c = automatedEmailCheckbox;
                    oIncentivePwd.LCRM_Contract__c = contractObj.ID;
                    for(contact con: selectedContactList){
                        if(string.valueof(con.id)==pwd.MdbContactId){
                            oIncentivePwd.contact__c = con.id;
                        }
                         
                        contactsTemplateMap.put(oIncentivePwd.contact__c, con);
                    }
                    for(incentive_Promotion__c Promotion: selectedPromotions){
                        if(Promotion.promotion_key__c != null && Promotion.promotion_key__c == pwd.PromoKey){
                            oIncentivePwd.Promotion__c = keyIdPair.get(Promotion.promotion_key__c).id;
                        }
                    }
                    oIncentivePwd.name = pwd.IncentiveOnlineId;
                    oIncentivePwd.Password__c = pwd.IncentivePassword;
                    oIncentivePwd.LCRM_Opportunity__c = oOpportunity.id;
                    oIncentivePwd.Start_Date__c = pwd.IncentiveStartDate;
                    oIncentivePwd.End_Date__c = pwd.IncentiveEndDate;
                    ListIncentivePwds.add(oIncentivePwd);
                }
                System.debug(ListIncentivePwds.size()+'&&&&&&&&&&&&');/*-- commented to reduce character for s2e optimization */
                insert ListIncentivePwds;
                //System.debug('ListIncentivePwds**'+ListIncentivePwds);
                //Updating Contract fields
                Date minStartDate = ListIncentivePwds[0].Start_Date__c;
                Date maxEndDate = ListIncentivePwds[0].End_Date__c;
                
                if(maxEndDate!=null &&minStartDate!=null ){
                    for(Incentive_Password__c ip: ListIncentivePwds) {
                        if(ip.Start_Date__c < minStartDate) {
                            minStartDate = ip.Start_Date__c;
                        }
                        if(ip.End_Date__c > maxEndDate) {
                            maxEndDate = ip.End_Date__c;
                        }
                    }
                System.debug('maxEndDate-->' + maxEndDate);
                System.debug('minStartDate-->' + minStartDate);
                //System.debug('diff' + maxEndDate.monthsBetween(minStartDate));
                
                    if(maxEndDate.monthsBetween(minStartDate) > 1) {
                        contractObj.ContractTerm = maxEndDate.monthsBetween(minStartDate);
                    } else{
                        contractObj.ContractTerm = 1;
                    }
                }
                
                contractObj.Status = 'Activated';
                contractObj.StartDate = minStartDate;
                contractObj.LCRM_Contract_End_Date__c = maxEndDate;
                update contractObj;
                sendEmailTemplateToPwdContact(ListIncentivePwds);
            } catch(Exception e) {
                System.debug('Exception : ' + e.getMessage());
                System.debug('Exception trace : ' + e.getStackTraceString());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                
            }
        }

    }
      
     
      /**
       * Method to send emails added for CRM-6642
       */
     public void sendEmailTemplateToPwdContact(List < Incentive_Password__c > ListIncentivePwds) {
        sendEmailcheck = true;
        if (automatedEmailCheckbox == true) {
        EmailTemplate trialtemplateId = [SELECT Id, Name, TemplateType FROM EmailTemplate WHERE Name = :Label.LCRM_Trial_EmailTemplateName];
        List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
        LCRMSubBu = LCRMGenericComponent.getUserBU();
        for (Incentive_Password__c pwdEmail: ListIncentivePwds) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Id contactId = pwdEmail.Contact__c;
            mail.setTargetObjectId(contactId);
            mail.setTemplateId(trialtemplateId.Id);
            mail.setWhatId(pwdEmail.Id);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSenderDisplayName(Label.LCRM_EmailSender_Name);
            opptytask = true; //Added as a part of CRM -11169 to invoke TaskBeforeEventListener trigger to upadte what id 
            mail.setSaveAsActivity(true);
            System.debug('mail' + mail);
            mailsList.add(mail);
        }
        Messaging.sendEmail(mailsList);
        }
    }
        
      /**
       * Retrieves a list of Incentive_Promotion__c objects and related Incentive_Password__c objects
       *
       * @param  accountId  the account id to retrieve incentive promotions for
       * @return  a list of Incentive_Promotion__c objects
       */
      private List<IncentivePromotion> getIncentivePromotionHistory(Id accountId) {
        List<IncentivePromotion> listPromotions = new List<IncentivePromotion>();
        for (Incentive_Promotion__c oPromotion : [SELECT Id, Account__c, Assigned_To__c, title__c, CreatedById, CreatedDate
                , Last_request_date__c, Description__c, End_Date__c, Name, product_type__c, Promotion_Number__c, Reason__c
                , Start_Date__c, (SELECT Id, Contact__c, CreatedById,LCRM_Trial_Indicator__c,LCRM_Automated_Email__c,CreatedDate, End_Date__c, Name, Password__c
                , Promotion__c, Start_Date__c,LCRM_Contract__c FROM Incentive_Passwords__r ORDER BY CreatedDate DESC )  FROM  Incentive_Promotion__c
                 WHERE Account__c =:accountId ORDER BY Last_request_date__c desc LIMIT 20 ]){
          IncentivePromotion oIncentivePromotion = new IncentivePromotion();
          oIncentivePromotion.Promotion = oPromotion;
          for (Incentive_Password__c oPassword : oPromotion.Incentive_Passwords__r) {
    /*System.debug(oPassword  + '$$$$$$$$$$');-- commented to reduce character for s2e optimization */
            PromotionPassword oPromotionPassword = new PromotionPassword();
            oPromotionPassword.Incentive = oPassword;
            oIncentivePromotion.PromotionPasswords.add(oPromotionPassword);
    /*System.debug(oPromotionPassword + '$$$$$$$$$$');-- commented to reduce character for s2e optimization */
          }
          listPromotions.add(oIncentivePromotion);
        }
        return listPromotions;
      }
      
      public pagereference cancel(){
          PageReference np;
          np = new PageReference('/apex/IncentivePasswordonOpty?id='+OptyId+'&FromContact=true');
       //   np.getParameters().put('OptyId', oOpportunity.id);
            np.setRedirect(false);
        return np;
      
      }
      
       public pageReference save(){
            pageReference oPageReference = null;
            //make a call out to IDQ to see if there are any matching contacts
    /*System.debug(oStandardCntrllerContact.getRecord()+'Savefucn ==>'+oContact);-- commented to reduce character for s2e optimization */
               oContact = (Contact)oStandardCntrllerContact.getRecord();
          if (this.SkipContactMatching == false){
                DataQualityUtil.ContactInfo oContactInfo = new DataQualityUtil.ContactInfo();
                //oContactInfo.MDBCustomerID = oContact.MDB_Account_Number__c;
                oContactInfo.Name = oContact.Firstname + ' ' + oContact.LastName;
                oContactInfo.email = oContact.Email;
                Account oAccount = queryAccount(oContact.accountid);
                oContactInfo.MDBCustomerID = oAccount.MDBID__c;
                listMatchedContacts = DataQualityUtil.matchContacts(new List<DataQualityUtil.ContactInfo>{ oContactInfo });
          }
          else{
            PageReference oSavePageReference = oStandardCntrllerContact.save();
            Contact oSavedContact = (Contact) [select name,id, SAP_Contact_ID__c,FirstName,Email,Phone,Lastname,class__c,SAP_Role__c,MDB_Contact_ID__c 
                FROM contact WHERE Id =:oSavePageReference.getUrl().removeStart('/')];
    /*System.debug('*****'+currentTab+oSavedContact.SAP_Role__c+'here');-- commented to reduce character for s2e optimization */
                if((currentTab=='Westlaw' || currentTab=='BusinessLawResearchGSI') && oSavedContact.SAP_Role__c!=null){
                   addContactList.add(oSavedContact);
               }else if(currentTab!='Westlaw' && currentTab!='BusinessLawResearchGSI'){
                   addContactList.add(oSavedContact);
               }
              
                   oPageReference = new Pagereference('/apex/IncentivePasswordonOpty?id='+OptyId);
               
             
             oPageReference.setRedirect(false);
                return oPageReference;
          } 
            //if there are matching contacts set the HasMatchingContacts to true
            if(!listMatchedContacts.isEmpty()){
                HasMatchingContacts =true;
    //Build Set of Matched Contact Ids
                Set<string> MDBIds = new Set<string>();
                for (DataQualityUtil.ContactInfo oContactMatchInfo : listMatchedContacts){
                    MDBIds.add(oContactMatchInfo.MDBContactID);
                }
                Map<string, Contact> mapMatchedContacts = new Map<string, Contact>();
                for (Contact oContact : this.queryContactsByMDBId(MDBIds)) {
                    mapMatchedContacts.put(oContact.MDB_Contact_ID__c, oContact);
                }
    /*system.debug('listmatchedcontacts:' + listmatchedcontacts);-- commented to reduce character for s2e optimization */
                for (DataQualityUtil.ContactInfo oContactMatchInfo : listMatchedContacts) {
                    MatchedContact oMatchedContact = new MatchedContact();
                    oMatchedContact.ContactInfo = oContactMatchInfo;
                    oMatchedContact.Contact = mapMatchedContacts.get(ocontactMatchInfo.MDBContactID);
                    oMatchedContact.Score = oContactMatchInfo.Score;
    /*system.debug('matchedcontact' + omatchedcontact);-- commented to reduce character for s2e optimization */
                    this.MatchedContacts.add(oMatchedContact);
                }
    //*******************************************************************************************            
                return null;
            }
            else{//else if no matching records are found create the contact and redirect to the detail
                PageReference oSavePageReference = oStandardCntrllerContact.save();
                Contact oSavedContact = (Contact) [select name,id, SAP_Contact_ID__c,FirstName,Email,Phone,Lastname,class__c,SAP_Role__c,MDB_Contact_ID__c 
                     FROM contact WHERE Id =:oSavePageReference.getUrl().removeStart('/')];
    /*System.debug((currentTab=='Westlaw' || currentTab=='BusinessLawResearchGSI') && oSavedContact.SAP_Role__c!=null+'*****'+currentTab);-- commented to reduce character for s2e optimization */           
              if((currentTab=='Westlaw' || currentTab=='BusinessLawResearchGSI') && oSavedContact.SAP_Role__c!=null){
                   addContactList.add(oSavedContact);
               }else if(currentTab!='Westlaw' && currentTab!='BusinessLawResearchGSI'){
                   addContactList.add(oSavedContact);
               }
              
                   oPageReference = new Pagereference('/apex/IncentivePasswordonOpty?id='+OptyId+'&FromContact=true');
               
              
              oPageReference.setRedirect(false);
                return oPageReference;
            }
        }
      
      public pageReference createcontact(){
         oContact = new Contact();
         oContact.AccountId = oOpportunity.AccountId;
         HasMatchingContacts = false;
         this.Matchedcontacts = new List<Matchedcontact>();
         this.SkipContactMatching = false;
         listMatchedContacts = new List<DataQualityUtil.ContactInfo>();
         PageReference np = new PageReference('/apex/ContactCreatefromIncentivePswd');
            np.getParameters().put('OptyId', oOpportunity.id);
            np.setRedirect(false);
        return np;
      }
      
        public PageReference continueSave(){
            //this.SkipAddressValidation = true;
            this.SkipContactMatching = true;
            return this.save();
        }
      /**
       * Retrieves a list of Contact objects
       *
       * @param  accountId  the account id to retrieve conatct
       * @param cName Contact name   
       * @return  a list of contact
       */
       private List<Contact> getAddContact(Id AccountId, String cName) {    
        if(cName == null){
            cName='';
        } 
        List<contact> selectedContactList = new list<contact>();                
        selectedContactList=getSelectedContact();
        cName ='%'+cName+'%';
        if(currentTab=='Westlaw' || currentTab=='BusinessLawResearchGSI'){
            return [select name,id, SAP_Contact_ID__c,FirstName,Email,Phone,Lastname,class__c,SAP_Role__c,MDB_Contact_ID__c  
               FROM contact WHERE Accountid =:AccountId and name like :cName and id not in :selectedContactList and SAP_Role__c!= null 
                Order by Name Limit 200];  
        }else{        
            return [select name,id, SAP_Contact_ID__c,FirstName,Email,Phone,Lastname,class__c,SAP_Role__c,MDB_Contact_ID__c 
                      FROM contact WHERE Accountid =:AccountId and id not in :selectedContactList Order by Name Limit 200];    
        }                         
      }
      
      //Internal Classes
      
      /**
       * Data structure representing a selectable Incentive_Promotion__c object
       */
      public class IncentivePromotion {
        public boolean IsSelected {get;set;}
        public Incentive_Promotion__c Promotion {get;set;}
        public List<PromotionPassword> PromotionPasswords {get;set;}
        public IncentivePromotion() {
          IsSelected = false;
          Promotion = new Incentive_Promotion__c();
          PromotionPasswords = new List<PromotionPassword>();
        }
      }
      
      /**
       * Data structure representing a selectable Incentive_Password__c object
       */
      public class PromotionPassword {
        public boolean IsSelected {get;set;}
        public Incentive_Password__c Incentive {get;set;}
        public PromotionPassword(){
          IsSelected = false;
          Incentive = new Incentive_Password__c();
        }
      }
      
      /**
       * Data structure representing a selectable contact
       */
       
        public class contactSet{ 
            public Boolean checked{ get; set; }
            public contact ocontact { get; set;} 
            public contactSet(){
                ocontact = new contact();
                checked = false;
            } 
            public contactSet(contact c){
                ocontact = c;
                checked = false;
            } 
        }
                
        /* custom Exception class */
        Public class customException extends Exception{}
        
        
         public class MatchedContact {
            public DataQualityUtil.ContactInfo ContactInfo {get;set;}
            public contact Contact {get;set;}
            public string Score {get;set;}
        }
        
        private static Account queryAccount(Id accountId) {
            return [SELECT Id, MDBID__c FROM Account WHERE Id = :accountId];
        }
        private List<Contact> queryContactsByMDBId(Set<string> ContactIds) {
            return [SELECT SAP_Contact_ID__c,FirstName,Email,Phone,Lastname,class__c, Id, MDB_Contact_ID__c ,Name, SAP_Role__c                
                    FROM Contact WHERE MDB_Contact_ID__c IN :ContactIds]; 
        }
    }