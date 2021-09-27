/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2012-01-04   JDS                     Created
* 2012-02-02   Partha                  Modified 
* 2017-03-31   Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
* 2017-10-27    Niket Kapasi            Developed functionality for CRM-6243 
* 2017-11-02   Harika Devi Kalidindi   Developed functionality for CRM-3257 to generate non trail password from Training Event detail page.
* 2017-11-15   Harika Devi Kalidindi   Modified as part of  CRM-11169 to have generic class for "Create Non Trial Password" button in Account and Training Event 
  2020-4-3     Shyamsundar Shet        BMP-1594 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

* =============================================================================
*/ 
public with sharing class IncentivePasswordController 
{
    //Protected Members
    private final ApexPages.StandardController oStandardController;
    private final Account oAccount;  
    private final Training_Event__c oTrainingEvent;
    public Training_Event__c teIncentivePWD;
    private List<contact> addContactList;  
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
    List<Training_Event__c> listTrainingEvent = new List<Training_Event__c >();
    List<Training_Event__c> listSelectedTrainingEvents= new List<Training_Event__c >();
    
    public boolean automatedEmailCheckbox{get;set;}
    public boolean trialIndicator{get;set;}
    public static boolean Trainingeventtask =false;
    public static boolean Accounttask =false;
    //public boolean displayPopup {get; set;}
    public Map<id,contact> contactsTemplateMap = new Map<id,contact>();
    
    public static boolean sendEmailcheck = false;
    public string strObjId;
    public Id strAccId;
    public Id strTEId;
    public static string LCRMSubBu{get;set;}
    
    
    //Constructors
    
   /**
    * Account Standard Controller Constructor
    */
    public IncentivePasswordController(ApexPages.StandardController oController) {
        try {
            oStandardController = oController;
            strObjId = ApexPages.currentPage().getParameters().get('id');
            String ObjectName= oController.getRecord().getSObjectType().getDescribe().getName();
            //Checks whether the button is clicked from  Account
            if(ObjectName == 'Account')
            {
                
                //assigns Account Salesforce Id to strAccId 
                strAccId = Id.valueof(strObjId);
            }
            else
            {
                //assigns Training event Salesforce Id to strTEId 
                strTEId = Id.valueof(strObjId);
            }
            System.debug('strAccId : '+strAccId);
            System.debug('strTEId : '+strTEId);
            
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
            
            cName='';
            currentTab='History';
            currentpage=1;
            WestlawContactList = new list<contact>();
            WestlawNextContactList = new list<contact>();
            PublicRecordsContactList = new list<contact>();
            BusinessLawResearchGSIContactList = new list<contact>();
            TabInFocus='tabHistory';
            System.debug('strAccId : '+strAccId);
            if(strAccId != null)
            {
                oAccount = (Account) oController.getRecord();
                addContactList =getAddContact(oAccount.Id,cName);
                IncentivePromotionHistory = getIncentivePromotionHistory(oAccount.Id);
            
            }
            else if(strTEId != null)
            {
                oTrainingEvent = (Training_Event__c) oController.getRecord();
                addContactList =getAddContact(oTrainingEvent.Id,cName);
                IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
            
            }
            
            trialIndicator = false;
            automatedEmailCheckbox = true;
            sendEmailcheck = false;
            
        }
        catch (Exception oException)
        {
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
            if (listWestlawPromotions == null) 
            {
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
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
    }
    
    
   /**
    * Lazy loads the WestlawNext open promotions.This also used by CRM-6243 to load the list of open promotions
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
        catch (Exception oException) {
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
            } //system.debug('*****'+selectedPwds.size()+selectedPwds[0].contact__c);
            update selectedPwds;
        }
        catch (DmlException oException){
            ApexPages.addMessages(oException);
        }
        if(strAccId != null)
        {
            IncentivePromotionHistory = getIncentivePromotionHistory(oAccount.Id);
        }
        else if(strTEId != null)
        {
            IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);

        }
            
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
    
   /*CRM-8602
    *Desc : Method 'getPromoUrlOpen' is used to redirect to 'LCRMNonTrialPromoDocument' visualforce page 
    *which is rendered as document and downloaded when download selected is clicked on 'PromoPassword' page.
    */
    
    public string getPromoUrlOpen(){
        string urlopen ='';  
        for(IncentivePromotion hist:IncentivePromotionHistory ){
            if(hist.IsSelected){
                if(urlopen=='')          
                    urlopen ='/apex/LCRMNonTrialPromoDocument?Type=Promo&Indicator=nontrial&Pid='+hist.Promotion.id;
            }
        }
        for(IncentivePromotion hist:IncentivePromotionHistory ){
            for(PromotionPassword promoPwd:hist.PromotionPasswords){
                if(promoPwd.IsSelected){
                    if(urlopen=='')
                        urlopen='apex/LCRMNonTrialPromoDocument?Type=Individual&Indicator=nontrial&Pid='+PromoPwd.Incentive.id; 
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
    public ApexPages.StandardSetController standardSetCon{
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
    public List<contactSet> getCurrentList(){
        contactSetList = new List<contactSet>();       
        for (contact category : (List<contact>)standardSetCon.getRecords())
            contactSetList.add(new contactSet(category));
        return contactSetList;
    }
    
   /**
    * Gets the current list for selected contact for the selected tab
    *@return List of contact object
    */
    public List<Contact> getSelectedContact(){
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
    public void addContact(){
        try
        {
            List<contact> selectedContactList = new list<contact>();
            system.debug('contactSetList : '+contactSetList.size());
            for(Contactset cs : contactSetList)
            {
                if(cs.checked)
                {                
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
                if(strAccId != null)
                {
                    addContactList =getAddContact(oAccount.Id,cName);
                }
                else if(strTEId != null)
                {
                    addContactList =getAddContact(oTrainingEvent.Id,cName);
                }
            }
    
            else 
            {
                //throw new customException('No promotions have been selected');   //Replaced with Custom Label as part of S2E Optimization         
                throw new customException(Label.Contact_and_Promotions_Limit);
            }
    
        }
    
        catch (Exception oException) 
        {
            ApexPages.addMessages(oException);
        } 
       
    }
    
   /**
    *searches the contact in addContact   
    */
    public void searchContact()
    {
        standardSetCon = null;
        currentpage=1;
        if(strAccId != null)
        {
            addContactList =getAddContact(oAccount.Id,cName);
        }
        else if(strTEId != null)
        {
            addContactList =getAddContact(oTrainingEvent.Id,cName);
        }  
    }
    
   /**
    *Removes the contacts from selectedContactList
    */
    public void removeContact()
    { 
        integer intRemove = -1;
        List<contact> selectedContactList = new list<contact>();    
        id removeId=ApexPages.currentPage().getParameters().get('removeId');        
        selectedContactList=getSelectedContact();     
        for(integer count = 0;count<selectedContactList.size();count ++)
        {
            if(removeId==selectedContactList.get(count).id)
            {
                intRemove = count;  
            }
        }
        if(intRemove != -1)
        {
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
    *Returns westlaw Promotions
    */
    public pagereference SubmitWestlawRequest() 
    {
        try
        {        
            if(WestlawContactList.size() != 0 || WestlawGenericPasswords != 0)
            {
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:WestlawPromotions)
                {
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0)
                {
                    requestPassword(selectedPromotions,WestlawContactList,true);
                    if(strAccId != null)
                    {
                        IncentivePromotionHistory = getIncentivePromotionHistory(oAccount.Id);
                    }
                    else if(strTEId != null)
                    {
                        IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
        
                    }
                    WestlawContactList = new list<contact>();
                    CurrentTab='History';
                    return apexpages.currentpage();    
                }
                else
                {
                    //throw new customException('No promotions have been selected');   //Replaced with Custom Label as part of S2E Optimization         
                    throw new customException(Label.NoPromoEx);
                }
            }
            else
            {
                //  throw new customException('No Contacts have been selected or Generic Passwords Requested'); //Replaced with Custom Label as part of S2E Optimization 
                throw new customException(Label.NoContactEx);
            }
        }
        catch (Exception oException) 
        {
            ApexPages.addMessages(oException);
        } 
        return null;
    }
    
    
    
    //*** Returns BusinessLawResearchGSI Promotions
     public pagereference SubmitBusinessLawResearchGSIRequest()
     {
        try
        {        
            if(BusinessLawResearchGSIContactList.size() != 0 || GSIGenericPasswords != 0)
            {
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:BusinessLawResearchGSIPromotions)
                {
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0)
                {
                    requestPassword(selectedPromotions,BusinessLawResearchGSIContactList,true);
                    if(strAccId != null)
                    {
                        IncentivePromotionHistory = getIncentivePromotionHistory(oAccount.Id);
                    }
                    else if(strTEId != null)
                    {
                        IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
                
                    }
                    
                    BusinessLawResearchGSIContactList = new list<contact>();
                    CurrentTab='History';
                    return apexpages.currentpage();
                }
                else
                {
                    //throw new customException('No promotions have been selected');   //Replaced with Custom Label as part of S2E Optimization         
                    throw new customException(Label.NoPromoEx);
                    
                }   
            }
            else
            {            
                // throw new customException('No Contacts have been selected or Generic Passwords Requested');  //Replaced with Custom Label as part of S2E Optimization
                throw new customException(Label.NoContactEx);
            }
        }
        catch (Exception oException) 
        {
            ApexPages.addMessages(oException);
        } 
        return null;
    }
    
    
    
   /**
    *Returns westlawnext Promotions
    */
    public pagereference SubmitWestlawNextRequest() 
    {       
        try
        {
            system.debug('automatedEmailCheckbox::: '+automatedEmailCheckbox );      
            if(WestlawNextContactList.size() != 0 )
            {
                
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:WestlawNextPromotions)
                {
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0)
                {
                    requestPassword(selectedPromotions,WestlawNextContactList,false);
                    if(strAccId != null)
                    {
                        IncentivePromotionHistory = getIncentivePromotionHistory(oAccount.Id);
                    }
                    else if(strTEId != null)
                    {
                        IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
        
                    }
                    System.debug('IncentivePromotionHistory@@@ '+IncentivePromotionHistory);
                    WestlawNextContactList = new list<contact>();
                    CurrentTab='History';
                    return apexpages.currentpage();    
                }
                else
                {
                    //throw new customException('No promotions have been selected');   //Replaced with Custom Label as part of S2E Optimization         
                    throw new customException(Label.NoPromoEx);
                    
                }   
            }
            else
            {            
                //throw new customException('No Contacts have been selected');//Replaced with Custom Label as part of S2E Optimization
                throw new customException(Label.NoContactEx1);         
            }
        }
        catch (Exception oException) 
        {
            ApexPages.addMessages(oException);
        } 
        return null;
    }
    
   /**
    *Returns westlaw Promotions
    */
    public pagereference SubmitPublicRecordsRequest() 
    {
        try{   
            if(PublicRecordsContactList.size() != 0 ){
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                for(IncentivePromotion promo:PublicRecordsPromotions)
                {
                    if(promo.isSelected)
                        selectedPromotions.add(promo.Promotion);
                }
                if(selectedPromotions.size() != 0)
                {
                    requestPassword(selectedPromotions,PublicRecordsContactList,false);
                    if(strAccId != null)
                    {
                        IncentivePromotionHistory = getIncentivePromotionHistory(oAccount.Id);
                    }
                    else if(strTEId != null)
                    {
                        IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
        
                    }
                    WestlawContactList = new list<contact>();
                    CurrentTab='History';
                    return apexpages.currentpage();    
                }
                else
                {
                    //throw new customException('No promotions have been selected');   //Replaced with Custom Label as part of S2E Optimization         
                    throw new customException(Label.NoPromoEx);
                    
                }   
            }
            else
            {
                //throw new customException('No Contacts have been selected');//Replaced with Custom Label as part of S2E Optimization
                throw new customException(Label.NoContactEx1);
            }
        }
        catch (Exception oException) 
        {
            ApexPages.addMessages(oException);
        } 
        return null;
    }
    
   /*
    CRM -6243 Method 
    Description : 'submitLCRMPromoPasswordRequest' method is invoked when user clicks on 'Submit Request' button on promopassword page
    CRM -3257 Modified to work when the class is called from  both PromoPasswordonTrainingEvent  and PromoPassword pages
    */ 
    
    public pagereference submitLCRMPromoPasswordRequest() { 
        
        try{
            system.debug('automatedEmailCheckbox::: '+automatedEmailCheckbox );
            system.debug('trialIndicator:: '+trialIndicator );
            
            if(!WestlawNextContactList.isEmpty()){
                
                List<Incentive_Promotion__c> selectedPromotions = new list<Incentive_Promotion__c>();
                if(!WestlawNextPromotions.isEmpty())
                {
                    for(IncentivePromotion promo:WestlawNextPromotions){
                        if(promo.isSelected)
                            selectedPromotions.add(promo.Promotion);
                    }
                }
                if(selectedPromotions.size() != 0)
                {
                    if(selectedPromotions.size() == 1)
                    {
                        requestNonTrialPassword(selectedPromotions,WestlawNextContactList,false,trialIndicator);
                        if(strAccId != null)
                        {
                            IncentivePromotionHistory = getIncentivePromotionHistory(oAccount.Id);
                        }
                        else if(strTEId != null)
                        {
                            IncentivePromotionHistory = getIncentivePromotionHistory(oTrainingEvent.Id);
                            teIncentivePWD = [select Incentive_Password__c from Training_Event__c where id=: oTrainingEvent.Id]; 
                            if(!teIncentivePWD.Incentive_Password__c)
                            {
                                teIncentivePWD.Incentive_Password__c= true;
                                update teIncentivePWD;
                            }
                        }
                        WestlawNextContactList = new list<contact>();
                        CurrentTab='History';
                        return apexpages.currentpage();    
                    }
                
                    else
                    {
                        //throw new customException('No promotions have been selected');   //Replaced with Custom Label as part of S2E Optimization         
                        throw new customException(Label.Contact_and_Promotions_Limit);
                    
                    }
                }
                else
                {
                    //throw new customException('No promotions have been selected');   //Replaced with Custom Label as part of S2E Optimization         
                    throw new customException(Label.NoPromoEx);
                    
                }   
            }
            else
            {            
                //throw new customException('No Contacts have been selected');//Replaced with Custom Label as part of S2E Optimization
                throw new customException(Label.NoContactEx1);         
            }
        }
        catch (Exception oException) 
        {
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
        for (IncentivePasswordRegistration.Promotion oRegistrationPromotion : listPromotions)
        {
            Incentive_Promotion__c oPromotion = new Incentive_Promotion__c();
            if(strAccId != null)
            {
                oPromotion.Account__c = oAccount.Id;
            }
            else if(strTEId != null)
            {
                oPromotion.Training_Event__c= oTrainingEvent.Id;
                oPromotion.Account__c = oTrainingEvent.Account__c;
            }
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
        for(Incentive_Promotion__c Promotion:selectedPromotions)
        {
            oPasswordRequest.keys.add(Promotion.promotion_key__c);
            
        }                  
        for(contact con:selectedContactList)
        {
            IncentivePasswordRegistration.PromotionUserContact cont = new IncentivePasswordRegistration.PromotionUserContact();
            cont.MdbContactId=(con.MDB_Contact_ID__c==null?string.valueof(con.id):con.MDB_Contact_ID__c);  
            oPasswordRequest.Contacts.add(cont);
        }
        
        system.debug('@@oPasswordRequestCon'+oPasswordRequest.Contacts);
        if(westlaw)
        {
            WestlawGenericPasswords = (WestlawGenericPasswords!=0? WestlawGenericPasswords :GSIGenericPasswords);
            /*System.debug('*****'+WestlawGenericPasswords);-- commented to reduce character for s2e optimization */
            for(integer count =0;count<WestlawGenericPasswords;count++)
            {
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
        system.debug('@@oPasswordRequestCon'+oPasswordRequest.Contacts);    
         //system.debug('@@oPasswordRequest'+oPasswordRequest);    
        List<IncentivePasswordRegistration.PromotionPassword> listPasswords = oRegistrationService.requestPromotionPasswords(oPasswordRequest);
        /* system.debug('*******'+listPasswords.size()+ listPasswords[0].MdbContactId + '****' + listPasswords[0].PromoKey); -- commented to reduce character for s2e optimization */
        
        list<incentive_promotion__c> incentivePromotions = new list<incentive_promotion__c>();
        list<incentive_promotion__c> incentivePromotionsupd = new list<incentive_promotion__c>();             
        Map<string,incentive_promotion__c> keyIdPair = new map<string,incentive_promotion__c>();
        /*for(incentive_promotion__c ipc:[select id,promotion_key__c,last_request_date__c from incentive_promotion__c where Account__c=:oAccount.id limit 5000]){
        if(ipc.promotion_key__c != null)
        keyIdPair.put(ipc.promotion_key__c,ipc); }*/
        for(Incentive_Promotion__c Promotion:selectedPromotions)
        {
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
            /*   }else{
            incentive_promotion__c promo2 = keyIdPair.get(Promotion.promotion_key__c);
            promo2.last_request_date__c=system.now();

                incentivePromotions.add(Promo2);
            }  */          
        } 
        upsert incentivePromotions;   
        for(IncentivePasswordRegistration.PromotionPassword pwd:listPasswords){ 
            Incentive_Password__c oIncentivePwd = new Incentive_Password__c();
            
            for(contact con:selectedContactList){
                if(con.mdb_contact_id__c != null && con.mdb_contact_id__c != '')
                {
                    if(con.mdb_contact_id__c==pwd.MdbContactId )
                    {
                        oIncentivePwd.contact__c = con.id;
                    } 
                }  
                else
                {               
                    if(string.valueof(con.id)==pwd.MdbContactId)
                    {
                        oIncentivePwd.contact__c = con.id;
                    }
                }                              
            }
            for(incentive_Promotion__c Promotion:selectedPromotions)
            {
                
                if(Promotion.promotion_key__c!= null && Promotion.promotion_key__c == pwd.PromoKey)
                {
                    
                    oIncentivePwd.Promotion__c=keyIdPair.get(Promotion.promotion_key__c).id; 
                    
                }    
            }
            oIncentivePwd.name=pwd.IncentiveOnlineId;
            oIncentivePwd.Password__c=pwd.IncentivePassword;
            {
            
                oIncentivePwd.Start_Date__c=pwd.IncentiveStartDate;
                oIncentivePwd.End_Date__c=pwd.IncentiveEndDate;
                ListIncentivePwds.add(oIncentivePwd);   
            }                                
            /*System.debug(ListIncentivePwds.size()+'&&&&&&&&&&&&');-- commented to reduce character for s2e optimization */
            //insert ListIncentivePwds;
        
        }
         insert ListIncentivePwds;
    }
   /**
    * CRM-6243 Initiates a request to the Incentive Password Registration service to retreive Passwords and inserts into database
    *CRM -3257 Modified to work when the class is called from  both PromoPasswordonTrainingEvent  and PromoPassword pages
    * @param  selectedPromotions    List<Incentive_Promotion__c> which is selected by user
    * @param  selectedContactList  list<contact> selected bys user   * 
    * @param  Westlaw              Boolean to check if its westlaw
    * @param  trialindicator       Boolean Indicator to check if its trial or non-trial
    */   
    
    Private void requestNonTrialPassword(List<Incentive_Promotion__c> selectedPromotions, list<contact> selectedContactList, boolean Westlaw,boolean trialIndicator)
    {
        IncentivePasswordRegistration.PromotionPasswordRequest oPasswordRequest = new IncentivePasswordRegistration.PromotionPasswordRequest();
        list<Incentive_Password__c> ListIncentivePwds = new list<Incentive_Password__c>();
        for(Incentive_Promotion__c Promotion:selectedPromotions)
        {
            oPasswordRequest.keys.add(Promotion.promotion_key__c);                  
        }                  
        for(contact con:selectedContactList)
        {
            IncentivePasswordRegistration.PromotionUserContact cont = new IncentivePasswordRegistration.PromotionUserContact();
            
            //cont.MdbContactId=(con.MDB_Contact_ID__c==null?string.valueof(con.id):con.MDB_Contact_ID__c);   
            cont.USLContactId=string.valueof(con.id);  //modified as a part of CRM -11167
            oPasswordRequest.Contacts.add(cont);
        }
        if(westlaw)
        {
            WestlawGenericPasswords = (WestlawGenericPasswords!=0? WestlawGenericPasswords :GSIGenericPasswords);
            /*System.debug('*****'+WestlawGenericPasswords);-- commented to reduce character for s2e optimization */
            for(integer count =0;count<WestlawGenericPasswords;count++)
            {
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
        
        list<incentive_promotion__c> incentivePromotions = new list<incentive_promotion__c>();
        list<incentive_promotion__c> incentivePromotionsupd = new list<incentive_promotion__c>();             
        Map<string,incentive_promotion__c> keyIdPair = new map<string,incentive_promotion__c>();
        
        for(Incentive_Promotion__c Promotion:selectedPromotions)
        {
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
        } 
        upsert incentivePromotions;   
        for(IncentivePasswordRegistration.PromotionPassword pwd:listPasswords)
        { 
            
            if(trialindicator == false)
            {
                Incentive_Password__c oIncentivePwd = new Incentive_Password__c();
                //Set trial indicator          
                oIncentivePwd.LCRM_Trial_Indicator__c  = trialIndicator;
                oIncentivePwd.LCRM_Automated_Email__c = automatedEmailCheckbox;
                for(contact con:selectedContactList)
                {
                    if(string.valueof(con.id)==pwd.MdbContactId)
                    {
                        oIncentivePwd.contact__c = con.id;
                    }
                    
                    contactsTemplateMap.put(oIncentivePwd.contact__c,con);
                }
                for(incentive_Promotion__c Promotion:selectedPromotions)
                {
                    if(Promotion.promotion_key__c!= null && Promotion.promotion_key__c == pwd.PromoKey)
                    {
                        
                        oIncentivePwd.Promotion__c=keyIdPair.get(Promotion.promotion_key__c).id; 
                        
                    }    
                }
                oIncentivePwd.name=pwd.IncentiveOnlineId;
                oIncentivePwd.Password__c=pwd.IncentivePassword;
                oIncentivePwd.Start_Date__c=pwd.IncentiveStartDate;
                oIncentivePwd.End_Date__c=pwd.IncentiveEndDate;
                if(strAccId != null)
                {
                    oIncentivePwd.LCRM_Account__c= oAccount.Id; //Passes the Account Id in  LCRM_Account__c field of Incentive password
                }
                else if(strTEId != null)
                {
                    oIncentivePwd.LCRM_Training_Event__c= oTrainingEvent.Id; //Passes the TrainingId in  LCRM_Training_Event__c  field of Incentive password
                }
                ListIncentivePwds.add(oIncentivePwd);   
            }  
        }
        
        /*System.debug(ListIncentivePwds.size()+'&&&&&&&&&&&&');-- commented to reduce character for s2e optimization */
        insert ListIncentivePwds;
        sendEmailTemplateToPwdContact(contactsTemplateMap,ListIncentivePwds);
        
    }
    
   /**
    * CRM-6243: sendEmailTemplateToPwdContact method sends email to the contact using visualforce template.Also it stores the activity  associated to it 
    *CRM -3257 Modified to work when the class is called from  both PromoPasswordonTrainingEvent  and PromoPassword pages 
    * @param  sendEmailTemplateToPwdContact    Map of contacts whom we are sending the email  
    * @param  ListIncentivePwds                List of passwords which we are sending to contact
    */ 
    
    public void sendEmailTemplateToPwdContact(Map<id,Contact>sendEmailTemplateToPwdContact,List<Incentive_Password__c>ListIncentivePwds){
        sendEmailcheck = true;
        //System.debug('sendEmailTemplateToPwdContact*** '+sendEmailTemplateToPwdContact);
        //System.debug('sendEmailTemplateToPwdContact.keySet()***'+sendEmailTemplateToPwdContact.keySet()); 
        //System.debug('sendEmailTemplateToPwdContact Size*** '+sendEmailTemplateToPwdContact.values().size());
        //System.debug('ListIncentivePwds'+ListIncentivePwds.size());
        if(automatedEmailCheckbox == true)
        {
            EmailTemplate nontrialtemplateId = [SELECT Id, Name, TemplateType FROM EmailTemplate WHERE Name =: Label.LCRM_NonTrial_EmailTemplateName];
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            //for(Contact con : sendEmailTemplateToPwdContact.values()){
            LCRMSubBu =LCRMGenericComponent.getUserBU();
            for(Incentive_Password__c pwdEmail : ListIncentivePwds)
            {                    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                // Who you are sending the email to
                Id contactId = pwdEmail.Contact__c;
                mail.setTargetObjectId(contactId);    
                // The email template ID used for the email 
                mail.setTemplateId(nontrialtemplateId.Id); 
                mail.setWhatId(pwdEmail.Id); 
                mail.setBccSender(false); 
                mail.setUseSignature(false); 
                //mail.setReplyTo('recruiting@acme.com'); 
                mail.setSenderDisplayName(Label.LCRM_EmailSender_Name); 
                if(strAccId != null)
                {
                    Accounttask = true; //Added as a part of CRM -11169 to invoke TaskBeforeEventListener trigger
                }
                else if(strTEId != null)
                {
                    Trainingeventtask = true; //Added as a part of CRM -11169 to invoke TaskBeforeEventListener trigger
                }
                mail.setSaveAsActivity(true); 
                System.debug('mail'+mail);
                mailsList.add(mail);
                //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });            
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
    private List<IncentivePromotion> getIncentivePromotionHistory(Id recordId) {
        List<IncentivePromotion> listPromotions = new List<IncentivePromotion>();
        if(strAccId !=null)
        {
            for (Incentive_Promotion__c oPromotion : [SELECT Id, Account__c, Assigned_To__c, title__c, CreatedById, CreatedDate,
                                                  Last_request_date__c, Description__c, End_Date__c, Name, product_type__c, Promotion_Number__c, Reason__c,
                                                  Start_Date__c, (SELECT Id, Contact__c, CreatedById,LCRM_Trial_Indicator__c,LCRM_Automated_Email__c,CreatedDate, End_Date__c, Name, Password__c, Promotion__c,
                                                                  Start_Date__c FROM Incentive_Passwords__r ORDER BY CreatedDate DESC ) FROM Incentive_Promotion__c
                                                  WHERE Account__c =:recordId ORDER BY Last_request_date__c desc LIMIT 20])
            {
                IncentivePromotion oIncentivePromotion = new IncentivePromotion();
                oIncentivePromotion.Promotion = oPromotion;
                for (Incentive_Password__c oPassword : oPromotion.Incentive_Passwords__r)
                {
                    /*System.debug(oPassword  + '$$$$$$$$$$');-- commented to reduce character for s2e optimization */
                    PromotionPassword oPromotionPassword = new PromotionPassword();
                    oPromotionPassword.Incentive = oPassword;
                    oIncentivePromotion.PromotionPasswords.add(oPromotionPassword);
                    /*System.debug(oPromotionPassword + '$$$$$$$$$$');-- commented to reduce character for s2e optimization */
                }
            listPromotions.add(oIncentivePromotion);
            }
        }
        else if(strTEId != null)
        {
            for (Incentive_Promotion__c oPromotion : [SELECT Id, Training_Event__c, Assigned_To__c , title__c, CreatedById, CreatedDate , Last_request_date__c, Description__c, End_Date__c, Name , product_type__c, Promotion_Number__c, Reason__c, Start_Date__c
                          , (SELECT Id, Contact__c , CreatedById, CreatedDate , End_Date__c, Name, Password__c , Promotion__c, Start_Date__c FROM Incentive_Passwords__r ORDER BY CreatedDate DESC ) FROM Incentive_Promotion__c WHERE Training_Event__c=:recordId ORDER BY Last_request_date__c desc LIMIT 20  ]) 
            {
                IncentivePromotion oIncentivePromotion = new IncentivePromotion();
                oIncentivePromotion.Promotion = oPromotion;
      
                for (Incentive_Password__c oPassword : oPromotion.Incentive_Passwords__r) 
                {
                    PromotionPassword oPromotionPassword = new PromotionPassword();
                    oPromotionPassword.Incentive = oPassword;
        
                    oIncentivePromotion.PromotionPasswords.add(oPromotionPassword);
                }
              
                listPromotions.add(oIncentivePromotion);
            }
                                                  
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
    private List<Contact> getAddContact(Id recordid, String cName) 
    {    
        if(cName == null){
            cName='';
        } 
        List<contact> selectedContactList = new list<contact>();                
        selectedContactList=getSelectedContact();
        List<contact> selContactList = new List<contact>();  
        cName ='%'+cName+'%';
        if(strAccId != null)
        {
        
            if(currentTab=='Westlaw' || currentTab=='BusinessLawResearchGSI')
            {
        
                selContactList =  [select name,id, SAP_Contact_ID__c,FirstName,Email,Phone,Lastname,class__c,SAP_Role__c,MDB_Contact_ID__c  
                    FROM contact WHERE Accountid =:recordid and name like :cName and id not in :selectedContactList and SAP_Role__c!= null 
                    Order by Name Limit 200];  
            }
            else
            {        
                selContactList = [select name,id, SAP_Contact_ID__c,FirstName,Email,Phone,Lastname,class__c,SAP_Role__c,MDB_Contact_ID__c 
                    FROM contact WHERE Accountid =:recordid and name like :cName and id not in :selectedContactList
                    Order by Name Limit 200];    
            }
        } 
        else if(strTEId != null)
        {
        
            if(currentTab=='Westlaw'|| currentTab=='BusinessLawResearchGSI')
            {
                for(Training_Event_Contact__c TE: [SELECT Contact_Name__c,Contact_Name__r.name,Contact_Name__r.AccountId, Training_Event__c  ,name,id, Contact_Name__r.SAP_Contact_ID__c,Contact_Name__r.FirstName,Contact_Name__r.Email,Contact_Name__r.Phone,Contact_Name__r.Lastname,Contact_Name__r.class__c,Contact_Name__r.SAP_Role__c,Contact_Name__r.MDB_Contact_ID__c  
                        FROM Training_Event_Contact__c WHERE Training_Event__c =:recordid  and Contact_Name__r.name like :cName and Contact_Name__r.id not in :selectedContactList and Contact_Name__r.SAP_Role__c!= null Order by Name Limit 200])
                {
                        
                        selContactList .add(TE.Contact_Name__r);           
                }
       
            }
            else
            {        
                for(Training_Event_Contact__c TE: [SELECT Contact_Name__c,Contact_Name__r.name,Contact_Name__r.AccountId, Training_Event__c  ,name,id, Contact_Name__r.SAP_Contact_ID__c,Contact_Name__r.FirstName,Contact_Name__r.Email,Contact_Name__r.Phone,Contact_Name__r.Lastname,Contact_Name__r.class__c,Contact_Name__r.SAP_Role__c,Contact_Name__r.MDB_Contact_ID__c  
                            FROM Training_Event_Contact__c WHERE Training_Event__c =:recordid  and Contact_Name__r.name like :cName and Contact_Name__r.id not in :selectedContactList Order by Name Limit 200])
                {
                        
                    selContactList .add(TE.Contact_Name__r);           
                }
            }                        
        }
        return selContactList ;
    }
    
    //Internal Classes
    
   /**
    * Data structure representing a selectable Incentive_Promotion__c object
    */
    public class IncentivePromotion 
    {
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
    public class PromotionPassword
    {
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
    
    public class contactSet
    {
        public Boolean checked{ get; set; }
        public contact ocontact { get; set;} 
        public contactSet()
        {
            ocontact = new contact();
            checked = false;
        }
        public contactSet(contact c)
        {
            ocontact = c;
            checked = false;
        }
    }
    
    /* custom Exception class */
    Public class customException extends Exception
    {
    }
    
}