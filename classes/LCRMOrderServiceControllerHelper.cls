/**
 * Helper  for LCRMOrderServiceController. This is used to fetch Orders from ESI using REST Webservice.
 *
 */

/**
 * @description
 * CHANGE HISTORY
 * =============================================================================
 * Date                 Description
 * 2021-02-15           Created for PMD Fixes                                                      
 * =============================================================================
 */

public with sharing class LCRMOrderServiceControllerHelper {
   /** 
     * @description ordPaginater
    */
   public Paginate ordPaginater {get;set;}

   /** 
     * @description genericDisplayOrders
    */
   public List<List<LCRMOrderServiceWrapper.OrderInfo>> genericDisplayOrders {get;set;}

   /** 
     * @description displayOrders
    */
   public List<LCRMOrderServiceWrapper.OrderInfo> displayOrders {get;set;}
   
   /** 
     * @description sTranslatedSelectOption
    */ 
   public string sTranslatedSelectOption {get;set;}

   /**
     * testCreateTeFromAccount 
     *
     * @description  parentIDNull
     * @param oAccount
     * @param setAcctId
     * @return
     */ 
   public static Set<ID> parentIDNull(Account oAccount, Set<ID> setAcctId)
    {
        System.debug(LoggingLevel.DEBUG, 'INSIDE PARENT ID IS NULL');
        Set<Id> setChildAccountIds = AccountDetailController.getChildAccountIds(oAccount.Id);
        List<Account> childAccList = getAccountsFromChildAccIds(setChildAccountIds); 
        for (Account acc : childAccList ){//[Select Id,ParentId,SAPAccountNumber__c FROM Account WHERE Id IN : setChildAccountIds]){ 
            setAcctId.add(acc.Id);
        }
        return setAcctId;
    }
    
    /**
     * @description  getAccountsFromChildAccIds
     * @param setChildAccountIds
     * @return
     */
    public static List<Account> getAccountsFromChildAccIds(Set<Id> setChildAccountIds)
    {
        List<Account> childAccList = new List<Account> ();
        if(Schema.sObjectType.Account.isQueryable() && !setChildAccountIds.isEmpty()){
            childAccList = [Select Id,ParentId,SAPAccountNumber__c FROM Account WHERE Id IN : setChildAccountIds];
        }
        return childAccList;
    }
    
    /**
     * @description  getTempSSDLists
     * @param ssdList
     * @return
     */
    public static List<Source_System_Detail__c> getTempSSDLists(List<Source_System_Detail__c> ssdList){
        List<Source_System_Detail__c> tempssdList = new List<Source_System_Detail__c>();
        for(Source_System_Detail__c ossd:ssdList){
            if(ossd.Source_System_Account_Number__c !=null){
                tempssdList.add(ossd);
            }
        }
        return tempssdList;
    }
    
    /**
     * @description  getSSDLists
     * @param setAcctId
     * @return
     */
     public static List<Source_System_Detail__c> getSSDLists(Set<ID> setAcctId){
        
        List<Source_System_Detail__c> ssdList=  new List<Source_System_Detail__c>();
        //List<String> strSubBuList = System.Label.LCRMstrSubBu.split(',');
        
        //KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMOrderSubscriptionUserSubBU');//Gets the SUBBU value from KeyValueListStore__c custom settings
        //String tempSubBuValues = tempObj.TextValue__c;
        
        if(Schema.sObjectType.Source_System_Detail__c.isQueryable()){
            /*if( (strSubBu == 'USL' || strSubBu == 'Findlaw' || strSubBu == 'LMS' || strSubBu == 'US' )){
            if(strSubBuList.contains(strSubBu)){ */   
            //if(String.isNotEmpty(tempSubBuValues) && String.isNotBlank(tempSubBuValues) && tempSubBuValues.contains(strSubBu)){  
            ssdList= [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :setAcctId and LCRM_Sales_Org__c!= null and LCRM_Sub_BU__c IN ('USL','LMS','Findlaw')];    
            system.debug(LoggingLevel.DEBUG,'@@@ssdList'+ssdList);
                //ssdList= [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :setAcctId and LCRM_Sales_Org__c!= null and LCRM_Sub_BU__c IN ('USL','LMS','Findlaw')]; 
            //}
            /*else{
                ssdList= [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :setAcctId  and LCRM_Sales_Org__c!= null];  
                
            }*/
        }
        return ssdList;
    }
    
    /**
     * @description  getAccount
     * @param oAccount
     * @return
     */
    public static Account getAccount(Account oAccount){
        //Account oAccount = new Account();
        if(Schema.sObjectType.Account.isQueryable()){
            oAccount = [Select Id,ParentId,SAPAccountNumber__c FROM Account WHERE Id =:oAccount.Id];
        }
        return oAccount;
    }
    
    
    /**
     * @description  getUser
     * @return
     */
    public static User getUser(){
        User sCurrentUser = new User();
        if(Schema.sObjectType.User.isQueryable()){
            sCurrentUser = [select LanguageLocaleKey,Sales_Org__c,Sub_Bu__c from User where id = :UserInfo.getUserId()];
        }
        return sCurrentUser;
    }
    
    /** 
     * translateSelectedViewOption method
     * @description Method to add pagination
     * @param displayOrdersList
     * @param pageSize
    */
    /*public void displaypaginator(List<LCRMOrderServiceWrapper.OrderInfo> displayOrdersList, Integer pageSize){
        
        this.ordPaginater = new Paginate(displayOrdersList.size(), pageSize );
        this.genericDisplayOrders = new List<List<LCRMOrderServiceWrapper.OrderInfo>>();
        this.displayOrders = new List<LCRMOrderServiceWrapper.OrderInfo>();
        System.debug(LoggingLevel.DEBUG, 'displayOrdersList.size():-'+displayOrdersList.size());
            
        if(displayOrdersList.size() > 0 || !displayOrdersList.isEmpty()){
            List<LCRMOrderServiceWrapper.OrderInfo> tempCC = new List<LCRMOrderServiceWrapper.OrderInfo>();
            Integer i = 0;
               for(LCRMOrderServiceWrapper.OrderInfo cc : displayOrdersList ){
                    tempCC.add(cc);
                    i++; 
                    if(i == pageSize){
                        this.genericDisplayOrders.add(tempCC);
                        tempCC = new List<LCRMOrderServiceWrapper.OrderInfo>();  
                        i = 0;
                    }
                } 
                System.debug(LoggingLevel.DEBUG, 'tempCC:-'+tempCC);
                if(!tempCC.isEmpty()){
                    this.genericDisplayOrders.add(tempCC);
                }
                //Gets the correct list of data to show on the page
                System.debug(LoggingLevel.DEBUG, '****index this.ordPaginater.index'+ this.ordPaginater.index);
                this.displayOrders = this.genericDisplayOrders.get(this.ordPaginater.index);
                System.debug(LoggingLevel.DEBUG, 'displayOrders-->'+displayOrders);
        }
            
    } */
    
    /** 
     * getOrderListOptions method
     * @description Returns list of values to be selected in the page
     * @param sCurrentUser
     * @return selectoption
    */
    public static List<selectoption> getOrderListOptionswithUser(User sCurrentUser){
        List<selectoption> listOrders = new List<selectoption>();
        map<String, OrderType__c> mapOrderType = OrderType__c.getAll();
        for(OrderType__c oOrderType : mapOrderType.values()){
            if(sCurrentUser.LanguageLocaleKey == 'es'){
               listOrders.add(new selectoption(oOrderType.Name, oOrderType.Spanish__c));
           }
           else if(sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                listOrders.add(new selectoption(oOrderType.Name, oOrderType.Portuguese__c));
            }
            else{
                listOrders.add(new selectoption(oOrderType.Name, oOrderType.Name));
            }
        }
     return listOrders; 
    }
    
    /** 
     * translateSelectedViewOption method
     * @description Translating the selectedOption into User's languages
     * @param sSelectedOption
     * @param sTranslatedSelectOption
     * @param sCurrentUser
     * @return
    */   
    public static string translateSelectedViewOption(String sSelectedOption, string sTranslatedSelectOption, User sCurrentUser){
        map<String, OrderType__c> mapOrderType = OrderType__c.getAll();
        sTranslatedSelectOption = '';
            if(sCurrentUser.LanguageLocaleKey == 'es'){
                 sTranslatedSelectOption = mapOrderType.get(sSelectedOption).Spanish__c;
                 }
            else if(sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                       sTranslatedSelectOption = mapOrderType.get(sSelectedOption).Portuguese__c; 
                 }
            else{
                    sTranslatedSelectOption = sSelectedOption;
             }
             return sTranslatedSelectOption;
    }
    
    /** 
     * ssdListNotEmpty method
     * @description ssdListNotEmpty method
     * @return List<LCRMOrderServiceWrapper.Accounts>
     * @param ssdList
     * @param orderAccList
    */
    public static List<LCRMOrderServiceWrapper.Accounts> ssdListNotEmpty(List<Source_System_Detail__c> ssdList, List<LCRMOrderServiceWrapper.Accounts> orderAccList)
    {
        for(Source_System_Detail__c ssd : ssdList){
            System.debug(LoggingLevel.DEBUG,'Inside FORSSD');
            LCRMOrderServiceWrapper.Accounts oAcc = new LCRMOrderServiceWrapper.Accounts();
            oAcc.accountNumber = ssd.Source_System_Account_Number__c;
            orderAccList.add(oAcc);   
        } 
        return orderAccList;
    }

}