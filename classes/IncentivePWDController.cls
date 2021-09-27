/*CHANGE HISTORY
 * =============================================================================
 * Date        Name                         Description

   2020-4-3     Shyamsundar Shet           BMP-1594 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration
 * =============================================================================
*/

public with sharing class IncentivePWDController{

  //Protected Members
  private final ApexPages.StandardController oStandardController;
  private final Training_Event__c oTrainingEvent;  
  public Training_Event__c teIncentivePWD;
  private List<contact> addContactList;

  
  private integer currentPage;
  private List<contact> WestlawContactList{get;set;}
  private List<contact> WestlawNextContactList{get;set;}  
  private List<contact> PublicRecordsContactList{get ;set;}
  private List<contact> BusinessLawResearchGSIContactList{get ;set;}
  public string currentTab{get;set;}
  public string selectedTab{get;set;}
  
  private static List<IncentivePromotion> listWestlawPromotions;
  private static List<IncentivePromotion> listWestlawNextPromotions;
  private static List<IncentivePromotion> listPublicRecordsPromotions;
  private static List<IncentivePromotion> listBusinessLawResearchGSIPromotions;
  
  //Properties
  public List<IncentivePromotion> IncentivePromotionHistory {get;set;}
  public Incentive_Promotion__c WestLawPromotion {get;set;}
  public Incentive_Promotion__c WestLawNextPromotion {get;set;}
  public Incentive_Promotion__c PublicRecordsPromotion {get;set;}
  public Incentive_Promotion__c BusinessLawResearchGSIPromotion {get;set;}
  public integer WestlawGenericPasswords {get;set;}
  public integer GSIGenericPasswords {get;set;}
  Public List<contactSet> contactSetList;
  public List<IncentivePromotion> WestlawPromotions {get;set;}
  public List<IncentivePromotion> WestlawNextPromotions {get;set;}
  public List<IncentivePromotion> PublicRecordsPromotions {get;set;}
  public List<IncentivePromotion> BusinessLawResearchGSIPromotions {get;set;}
  public string cName{get;set;}
  public string TabInFocus{get;set;}
  public string incentivePassword;     
  
  List<Training_Event__c> listTrainingEvent = new List<Training_Event__c >();
  List<Training_Event__c> listSelectedTrainingEvents= new List<Training_Event__c >();
  public boolean isRecords{get;set;}  
 
  
  //Constructors
  
  /**
   * Account Standard Controller Constructor
   */
  public IncentivePWDController(ApexPages.StandardController oController) {
   
    try {
    
         
      oStandardController = oController;
      oTrainingEvent = (Training_Event__c) oController.getRecord();
      
      WestlawPromotion = new Incentive_Promotion__c();
      WestlawPromotion.Assigned_To__c = UserInfo.getUserId();
      
      WestlawNextPromotion = new Incentive_Promotion__c();
      WestlawNextPromotion.Assigned_To__c = UserInfo.getUserId();
      
      PublicRecordsPromotion = new Incentive_Promotion__c();
      PublicRecordsPromotion.Assigned_To__c = UserInfo.getUserId();
      
      BusinessLawResearchGSIPromotion = new Incentive_Promotion__c();
     
      BusinessLawResearchGSIPromotion.Assigned_To__c = UserInfo.getUserId();
      
      WestlawGenericPasswords = 0;
      
      WestlawPromotions = new List<IncentivePromotion>();
      WestlawNextPromotions = new List<IncentivePromotion>();
      PublicRecordsPromotions = new List<IncentivePromotion>();
      BusinessLawResearchGSIPromotions = new List<IncentivePromotion>();
      
      IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
      
      cName='';
     
      selectedTab='tabWestlawNextRequest';
      currentpage=1;
      
      WestlawContactList = new list<contact>();
      WestlawNextContactList = new list<contact>();
      PublicRecordsContactList = new list<contact>();
      BusinessLawResearchGSIContactList = new list<contact>();
       
      TabInFocus='tabWestlawRequest';
      
      addContactList =getAddContact(oTrainingEvent.Id,cName);

      loadWestlawNextOpenPromotions();
     
    }
    catch (Exception oException) {
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
      searchContact();
      if (listWestlawPromotions == null) {
        listWestlawPromotions = new list<IncentivePromotion>();
        //listWestlawPromotions.addall(requestOpenPromotions('WESTLAW','WEST','WAMS',WestlawPromotion.Assigned_To__c));
        listWestlawPromotions.addall(requestOpenPromotions('Westlaw', WestlawPromotion.Assigned_To__c));
      }
      
      WestlawPromotions = listWestlawPromotions;

    }
    catch (Exception oException) {
      ApexPages.addMessages(oException);
    }
  }
  
  //*** loadBusinessLawResearchGSIPromotions ***
 
  public void loadBusinessLawResearchGSIPromotions() {
    try {
      currentTab='BusinessLawResearchGSI';
      searchContact();
      if (listBusinessLawResearchGSIPromotions == null) {    
         listBusinessLawResearchGSIPromotions = new list<IncentivePromotion>();
        // listBusinessLawResearchGSIPromotions.addall(requestOpenPromotions('WESTLAW','GSI','WLB',BusinessLawResearchGSIPromotion.Assigned_To__c));
         listBusinessLawResearchGSIPromotions.addall(requestOpenPromotions('GSI', BusinessLawResearchGSIPromotion.Assigned_To__c));
      }
      
      BusinessLawResearchGSIPromotions  = listBusinessLawResearchGSIPromotions;
      system.debug('BusinessLawResearchGSIPromotions:'+BusinessLawResearchGSIPromotions[0]);

    }
    catch (Exception oException) {
      ApexPages.addMessages(oException);
    }
  }
  
  /**
   * Lazy loads the WestlawNext open promotions
   */
  public void loadWestlawNextOpenPromotions() {
    try {
      currentTab='WestlawNext';
      searchContact();  
      if (listWestlawNextPromotions == null) {
        //listWestlawNextPromotions = requestOpenPromotions('COBALT','WEST','WAMS',WestlawNextPromotion.Assigned_To__c);
        listWestlawNextPromotions = requestOpenPromotions('WestlawNext', WestlawNextPromotion.Assigned_To__c);
      }     
      
      WestlawNextPromotions = listWestlawNextPromotions;
      
    }
    catch (Exception oException) {
      ApexPages.addMessages(oException);
    }
  }
  
    
  /**
   * Lazy loads the PublicRecords open promotions
   */
  public void loadPublicRecordsOpenPromotions() {
    try {
      currentTab='PublicRecords';
      searchContact();  
      if (listPublicRecordsPromotions == null) {
        //listPublicRecordsPromotions = requestOpenPromotions('WESTLAW','WEST','PUBRECS',PublicRecordsPromotion.Assigned_To__c);
        listPublicRecordsPromotions = requestOpenPromotions('PublicRecords', PublicRecordsPromotion.Assigned_To__c);
      }
      
      PublicRecordsPromotions = listPublicRecordsPromotions;
      
    }
    catch (Exception oException) {
      ApexPages.addMessages(oException);
    }
  }
  
  /**
   * Saves the Passwords record
   */
  public void saveHistory() {
    try {
     
        
        List<Incentive_Password__c> selectedPwds = new List<Incentive_Password__c>();
        for(IncentivePromotion hist:IncentivePromotionHistory ){
            for(PromotionPassword promoPwd:hist.PromotionPasswords){
                
                    selectedPwds.add(promoPwd.Incentive);
                 
            }
        }
       
        update selectedPwds;
         
    }
    catch (DmlException oException) {
      ApexPages.addMessages(oException);
    }
    IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
  }
  
   /**
   *Returns string Url to Open
   
   */
    public string getUrlOpen() {
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
        List<contact> selectedContactList = new list<contact>();
        for(Contactset cs : contactSetList){
            if(cs.checked){                
                selectedContactList.add(cs.oContact);
            }
        }
        if(currentTab == 'Westlaw')
            WestlawContactList.addAll(selectedContactList);
        if(currentTab == 'WestlawNext')
            WestlawNextContactList.addAll(selectedContactList);
        if(currentTab == 'PublicRecords')
            PublicRecordsContactList.addAll(selectedContactList);   
        if(currentTab == 'BusinessLawResearchGSI')
        BusinessLawResearchGSIContactList.addAll(selectedContactList); 
        
        currentPage= (standardSetCon.getHasNext()?standardSetCon.getPageNumber():(standardSetCon.getHasPrevious()?standardSetCon.getPageNumber()-1:standardSetCon.getPageNumber())); 
        standardSetCon = null;
        addContactList =getAddContact(oTrainingEvent.Id,cName);
     }
    
    /**
   *searches the contact in addContact   
   */
    public void searchContact() {
      standardSetCon = null;
      currentpage=1;
        addContactList =getAddContact(oTrainingEvent.Id,cName);  
    }
  
   /**
   *Removes the contacts from selectedContactList
   
   */
    public void removeContact() { 
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
        if(currentTab == 'WestlawNext')
            WestlawNextContactList = selectedContactList;
        if(currentTab == 'PublicRecords')
            PublicRecordsContactList = selectedContactList; 
        if(currentTab == 'BusinessLawResearchGSI')
           BusinessLawResearchGSIContactList = selectedContactList;
           
        searchContact();       
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
              IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
              /*
              teIncentivePWD = [select Incentive_Password__c from Training_Event__c where id=: oTrainingEvent.Id]; 
              teIncentivePWD.Incentive_Password__c = true;
              update teIncentivePWD;           
             */
              
              WestlawContactList = new list<contact>();
              selectedTab='tabHistory';
              CurrentTab='History';
              return apexpages.currentpage();    
            }
            else{
                throw new customException('No promotions have been selected');            
            }   
        }
        else{            
              throw new customException('No Contacts have been selected or Generic Passwords Requested');         
        }
       }
       catch (Exception oException) {
          ApexPages.addMessages(oException);
        } 
        
        return null;
    }
    /* *
   *Returns BusinessLawResearchGSI Promotions
   
   */  
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
              IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
              BusinessLawResearchGSIContactList = new list<contact>();
              selectedTab='tabHistory';
              CurrentTab='History';
              return apexpages.currentpage();    
            }
            else{
                throw new customException('No promotions have been selected');            
            }   
        }
        else{            
              throw new customException('No Contacts have been selected or Generic Passwords Requested');         
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
              IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);             
              WestlawNextContactList = new list<contact>();
              selectedTab='tabHistory';
              CurrentTab='History';
              return apexpages.currentpage();    
            }
            else{
                throw new customException('No promotions have been selected');            
            }   
        }
        else{            
                throw new customException('No Contacts have been selected');         
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
              IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
             
              WestlawContactList = new list<contact>();
               selectedTab='tabHistory';
               CurrentTab='History';
              return apexpages.currentpage();    
            }
           else{
                throw new customException('No promotions have been selected');
            
            }   
        }
        else{
            throw new customException('No Contacts have been selected');
         
        }
       }
       catch (Exception oException) {
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
 // private List<IncentivePromotion> requestOpenPromotions(string sDomainName, string sCompanyCode, string sType, id Assignedto) {
    private List<IncentivePromotion> requestOpenPromotions(string sTabName, id Assignedto) {
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
        
        /* SKG oPromotionRequest.DomainName = oIncentivePromoTypes.CompanyCode__c;
        oPromotionRequest.CompanyCode = oIncentivePromoTypes.DomainName__c;
        */
        oPromotionRequest.DomainName = oIncentivePromoTypes.DomainName__c;
        oPromotionRequest.CompanyCode = oIncentivePromoTypes.CompanyCode__c;

        oPromotionRequest.PromotionType = oIncentivePromoTypes.Type__c;
        
        /*
        oPromotionRequest.DomainName = sDomainName;
        oPromotionRequest.CompanyCode = sCompanyCode;
        oPromotionRequest.PromotionType = sType;
        */
        IncentivePasswordRegistration oRegistrationService = new IncentivePasswordRegistration();
        List<IncentivePasswordRegistration.Promotion> listPromotions = oRegistrationService.requestOpenPromotions(oPromotionRequest);
        for (IncentivePasswordRegistration.Promotion oRegistrationPromotion : listPromotions) {
            Incentive_Promotion__c oPromotion = new Incentive_Promotion__c();
            oPromotion.Training_Event__c= oTrainingEvent.Id;
            oPromotion.Account__c = oTrainingEvent.Account__c;
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
        list<incentive_promotion__c> incentivePromotionsupd = new list<incentive_promotion__c>(); 
        
        for(Incentive_Promotion__c Promotion:selectedPromotions){
            oPasswordRequest.keys.add(Promotion.promotion_key__c);
            Map<Id,incentive_promotion__c> MapAccIncpromo = new Map<Id,incentive_promotion__c>();
            for(contact con:selectedContactList){
            
             if(Promotion.Account__c != con.AccountId && !MapAccIncpromo.containskey(con.AccountId)){
                 Incentive_Promotion__c testpromo = Promotion.clone(false,true,false,false);
                 testpromo.Account__c = con.AccountId;
                 incentivePromotionsupd.add(testpromo);
                 MapAccIncpromo.put(con.AccountId,testpromo);
             }
            
            }                 
        }          
        selectedPromotions.addAll(incentivePromotionsupd);        
       
        for(contact con:selectedContactList){
            IncentivePasswordRegistration.PromotionUserContact cont = new IncentivePasswordRegistration.PromotionUserContact();
            cont.MdbContactId=(con.MDB_Contact_ID__c==null?string.valueof(con.id):con.MDB_Contact_ID__c);           
            oPasswordRequest.Contacts.add(cont);
        }
        if(westlaw){
            WestlawGenericPasswords = (WestlawGenericPasswords!=0? WestlawGenericPasswords :GSIGenericPasswords);
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
            //system.debug('*******'+listPasswords.size()+ listPasswords[0].MdbContactId + '****' + listPasswords[0].PromoKey);
             list<incentive_promotion__c> incentivePromotions = new list<incentive_promotion__c>();
                         
             Map<string,incentive_promotion__c> keyIdPair = new map<string,incentive_promotion__c>();
             
             
             for(Incentive_Promotion__c Promotion:selectedPromotions){
                 promotion.Last_request_date__c=system.now(); 
                  if(currentTab=='Westlaw')
                        promotion.assigned_to__c=WestLawPromotion.assigned_to__c;
                    if(currentTab=='WestlawNext')
                        promotion.assigned_to__c=WestLawNextPromotion.assigned_to__c;
                    if(currentTab=='PublicRecords')
                        promotion.assigned_to__c=PublicRecordsPromotion.assigned_to__c;   
                        
                    if(currentTab=='BusinessLawResearchGSI')
                        promotion.assigned_to__c=BusinessLawResearchGSIPromotion.assigned_to__c;    
                                             
                        //System.debug('*****'+Promotion.promotion_key__c+Promotion.Account__c);  
                                          
                        keyIdPair.put(Promotion.promotion_key__c+Promotion.Account__c,Promotion);
                        
                        incentivePromotions.add(Promotion);
            } 
             
             upsert incentivePromotions;   
         /*   for(IncentivePasswordRegistration.PromotionPassword pwd:listPasswords){
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
                         System.debug('&&&&'+keyIdPair.get(Promotion.promotion_key__c+Promotion.Account__c).id);
                        oIncentivePwd.Promotion__c=keyIdPair.get(Promotion.promotion_key__c+Promotion.Account__c).id;                           
                    }    
                }
                oIncentivePwd.name=pwd.IncentiveOnlineId;
                oIncentivePwd.Password__c=pwd.IncentivePassword;
                oIncentivePwd.Start_Date__c=pwd.IncentiveStartDate;
                oIncentivePwd.End_Date__c=pwd.IncentiveEndDate;

                ListIncentivePwds.add(oIncentivePwd);   
            }    */ 
            
            
            for(incentive_Promotion__c Promotion:selectedPromotions){
                
                for(IncentivePasswordRegistration.PromotionPassword pwd:listPasswords){
                    Incentive_Password__c oIncentivePwd = new Incentive_Password__c();
                    if(Promotion.promotion_key__c!= null && Promotion.promotion_key__c == pwd.PromoKey){
                        oIncentivePwd.Promotion__c=keyIdPair.get(Promotion.promotion_key__c+Promotion.Account__c).id;                           
                    }    
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
                
                oIncentivePwd.name=pwd.IncentiveOnlineId;
                oIncentivePwd.Password__c=pwd.IncentivePassword;
                oIncentivePwd.Start_Date__c=pwd.IncentiveStartDate;
                oIncentivePwd.End_Date__c=pwd.IncentiveEndDate;

                ListIncentivePwds.add(oIncentivePwd);   
                }
                    
                
            }                           
            
            teIncentivePWD = [select Incentive_Password__c from Training_Event__c where id=: oTrainingEvent.Id]; 
            teIncentivePWD.Incentive_Password__c = true;
            update teIncentivePWD;    
            
            insert ListIncentivePwds;       
            
        
    }
  
  /**
   * Retrieves a list of Incentive_Promotion__c objects and related Incentive_Password__c objects
   *
   * @param  accountId  the account id to retrieve incentive promotions for
   * @return  a list of Incentive_Promotion__c objects
   */
  private List<IncentivePromotion> getIncentivePromotionHistory(Id accountId) {
    List<IncentivePromotion> listPromotions = new List<IncentivePromotion>();
    
    for (Incentive_Promotion__c oPromotion : [SELECT 
                          Id
                          , Training_Event__c
                          , Assigned_To__c
                          , title__c
                          , CreatedById
                          , CreatedDate
                          , Last_request_date__c
                          , Description__c
                          , End_Date__c
                          , Name
                          , product_type__c
                          , Promotion_Number__c
                          , Reason__c
                          , Start_Date__c
                          , (SELECT 
                              Id
                              , Contact__c
                              , CreatedById
                              , CreatedDate
                              , End_Date__c
                              , Name
                              , Password__c
                              , Promotion__c
                              , Start_Date__c 
                            FROM 
                              Incentive_Passwords__r
                            ORDER BY
                               CreatedDate DESC
                                 ) 
                        FROM 
                          Incentive_Promotion__c
                        WHERE
                          Training_Event__c=:accountId
                        ORDER BY
                          Last_request_date__c desc
                        LIMIT 20  ]) {
            
      IncentivePromotion oIncentivePromotion = new IncentivePromotion();
      oIncentivePromotion.Promotion = oPromotion;
      
      for (Incentive_Password__c oPassword : oPromotion.Incentive_Passwords__r) {
        PromotionPassword oPromotionPassword = new PromotionPassword();
        oPromotionPassword.Incentive = oPassword;
        
        oIncentivePromotion.PromotionPasswords.add(oPromotionPassword);
      }
      
      listPromotions.add(oIncentivePromotion);
    }
    
    return listPromotions;
  }
  
  /**
   * Retrieves a list of Contact objects
   *
   * @param  accountId  the account id to retrieve conatct
   * @param cName Contact name   
   * @return  a list of contact
   */
   private List<Contact> getAddContact(Id trainingEventId, String cName) {    
    if(cName == null){
        cName='';
    } 
    List<contact> selectedContactList = new list<contact>();                
    selectedContactList=getSelectedContact();  
    cName ='%'+cName+'%';
    List<contact> TrainingEventContactList = new List<contact>();
    system.debug('currentTab:' +currentTab);
    if(currentTab=='Westlaw'|| currentTab=='BusinessLawResearchGSI'){
        for(Training_Event_Contact__c TE: [SELECT Contact_Name__c,Contact_Name__r.name,Contact_Name__r.AccountId, Training_Event__c  ,name,id, Contact_Name__r.SAP_Contact_ID__c,Contact_Name__r.FirstName,Contact_Name__r.Email,Contact_Name__r.Phone,Contact_Name__r.Lastname,Contact_Name__r.class__c,Contact_Name__r.SAP_Role__c,Contact_Name__r.MDB_Contact_ID__c  
                        FROM 
                            Training_Event_Contact__c
                        WHERE
                          Training_Event__c =:trainingEventId and Contact_Name__r.name like :cName and Contact_Name__r.id not in :selectedContactList and Contact_Name__r.SAP_Role__c!= null 
                        Order by
                          Name
                        Limit 200]){
                        
            TrainingEventContactList.add(TE.Contact_Name__r);           
        }
        return  TrainingEventContactList;
    }else{        
        for(Training_Event_Contact__c TE: [SELECT Contact_Name__c,Contact_Name__r.name,Contact_Name__r.AccountId, Training_Event__c  ,name,id, Contact_Name__r.SAP_Contact_ID__c,Contact_Name__r.FirstName,Contact_Name__r.Email,Contact_Name__r.Phone,Contact_Name__r.Lastname,Contact_Name__r.class__c,Contact_Name__r.SAP_Role__c,Contact_Name__r.MDB_Contact_ID__c  
                        FROM 
                            Training_Event_Contact__c
                        WHERE
                          Training_Event__c =:trainingEventId and Contact_Name__r.name like :cName and Contact_Name__r.id not in :selectedContactList
                        Order by
                          Name
                        Limit 200]){
                        
            TrainingEventContactList.add(TE.Contact_Name__r);           
        }
        return  TrainingEventContactList;                   
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
    
    public PromotionPassword() {
      IsSelected = false;
      Incentive = new Incentive_Password__c();
     
    }
  }
  
  /**
   * Data structure representing a selectable contact
   */
   
    public class contactSet { 
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
    Public class customException extends Exception{
    }
}