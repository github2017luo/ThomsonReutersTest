/**
 * Controller for LCRMOrderService page. This is used to fetch Orders from ESI using REST Webservice.
 *
 * @author  Seema Nagdev
 * @version 2017-11-01
 */

/**
 * @description
 * CHANGE HISTORY
 * =============================================================================
 * Date                 Name                         Description
 * 2017-11-01       Seema Nagdev                Created for CRM-7958    
 * 2018-27-02       Seema Nagdev                Updated for CRM-13579                                                    
 * =============================================================================
 */

public without sharing class LCRMOrderServiceController {
    /**
     * public Account method
     * @description : public Account getter setter method
     */
    public Account oAccount{get;set;}
    /**
     * public sSelectedOption method
     * @description : public sSelectedOption getter setter method
     */
    public string sSelectedOption{get;set;} 
    /**
     * public newBegindt method
     * @description : public newBegindt getter setter method
     */
    public string newBegindt{get;set;}  
    /**
     * public newEnddt method
     * @description : public newEnddt getter setter method
     */  
    public string newEnddt{get;set;}
    /**
     * public allBegindt method
     * @description : public allBegindt getter setter method
     */ 
    public string allBegindt{get;set;}
    /**
     * public allEnddt method
     * @description : public allEnddt getter setter method
     */ 
    public string allEnddt{get;set;} 
    /**
     * public strSalesOrgCode method
     * @description : public strSalesOrgCode getter setter method
     */
    public String strSalesOrgCode{get;set;}
    /**
     * public orderAccList method
     * @description : public orderAccList getter setter method
     */
    public List<LCRMOrderServiceWrapper.Accounts> orderAccList{get;set;}
    /**
     * public sCurrentUser method
     * @description : public sCurrentUser getter setter method
     */ 
    public User sCurrentUser{get;set;}
    /**
     * public sTranslatedSelectOption method
     * @description : public sTranslatedSelectOption getter setter method
     */ 
    public string sTranslatedSelectOption {get;set;}
    /**
     * public setAcctId method
     * @description : public setAcctId getter setter method
     */    
    public Set<ID> setAcctId{get;set;}
    /**
     * public ssdList method
     * @description : public ssdList getter setter method
     */ 
    public List<Source_System_Detail__c> ssdList{get;set;}
    /**
     * public oOrderInfo method
     * @description : public oOrderInfo getter setter method
     */ 
    public List<LCRMOrderServiceWrapper.OrderInfo> oOrderInfo {get;set;} 
    /**
     * public displayOrdersList method
     * @description : public displayOrdersList getter setter method
     */  
    public List<LCRMOrderServiceWrapper.OrderInfo> displayOrdersList {get;set;}
    /**
     * public allOrders method
     * @description : public allOrders getter setter method
     */ 
    public List<LCRMOrderServiceWrapper.OrderInfo> allOrders {get;set;}
    /**
     * public newOrders method
     * @description : public newOrders getter setter method
     */
    public List<LCRMOrderServiceWrapper.OrderInfo> newOrders {get;set;}
    /**
     * public exceptionMesginfo method
     * @description : public exceptionMesginfo getter setter method
     */
    public OrderServiceExceptions.StatusDetail exceptionMesginfo{get;set;}
    /**
     * public ordTypeptValues method
     * @description : public ordTypeptValues getter setter method
     */
    public List<String> ordTypeptValues {get; set;}
    /**
     * public strSubBu method
     * @description : public strSubBu getter setter method
     */
    public String strSubBu{get;set;} //added for CRM-13579
    /**
     * Pagination Paramters
     * @description : public displayOrders getter setter method
     */
    public List<LCRMOrderServiceWrapper.OrderInfo> displayOrders {get;set;}
    /**
     * Pagination Paramters
     * @description : public genericDisplayOrders getter setter method
     */
    public List<List<LCRMOrderServiceWrapper.OrderInfo>> genericDisplayOrders {get;set;}
    /**
     * Pagination Paramters
     * @description : public ordPaginater getter setter method
     */
    public Paginate ordPaginater {get;set;}
    /**
     * Pagination Paramters
     * @description : public pageSize getter setter method
     */
    public Integer pageSize {get;set;}
    //Integration Logger Paramters
    //public String error;
    //public String strBody;
     /**
     * Integration Logger Paramters
     * @description : public credentialHelper getter setter method
     */
    public LCRMCredentialInfoHelper credentialHelper {get;set;}
    /**
     * Integration Logger Paramters
     * @description : public tempssdList getter setter method
     */
    public List<Source_System_Detail__c> tempssdList {get;set;}

    /**
     * LCRMOrderServiceController 
     * @description : LCRMOrderServiceController constructor
     * @param controller
     */
    public LCRMOrderServiceController(ApexPages.StandardController controller){  
        try{
            /*if(Schema.sObjectType.User.isQueryable())
            {sCurrentUser = [select LanguageLocaleKey,Sales_Org__c,Sub_Bu__c from User where id = :UserInfo.getUserId()]; }
            */
            sCurrentUser = LCRMOrderServiceControllerHelper.getUser();
            System.debug(LoggingLevel.DEBUG,'sCurrentUser-->'+sCurrentUser); 
            credentialHelper = new LCRMCredentialInfoHelper();
            oAccount = new account();
            oAccount = (account) controller.getRecord(); 
            /*if(Schema.sObjectType.Account.isQueryable())
            {oAccount = [Select Id,ParentId,SAPAccountNumber__c FROM Account WHERE Id =:oAccount.Id];}*/
            oAccount = LCRMOrderServiceControllerHelper.getAccount(oAccount);
            
            newEnddt=allEnddt=system.today().format();
            newBegindt=system.today().addMonths(-36).format();
            allBegindt=system.today().addMonths(-1).format();
            sSelectedOption = 'New';
            oAccount.Order_Type__c  = OrderType__c.getValues('All').values__c;
            setAcctId = new Set<ID>(); 
            ssdList = new List<Source_System_Detail__c>();
            tempssdList = new List<Source_System_Detail__c>();
            oOrderInfo = new List<LCRMOrderServiceWrapper.OrderInfo>();
            strSubBu =sCurrentUser.Sub_Bu__c;
            //strSalesOrgCode = sCurrentUser.Sales_Org__c;
            pageSize = 15;
            
            if (oAccount.ParentId != null){
                setAcctId.add(oAccount.id);
            } else{
                setAcctId.addAll(LCRMOrderServiceControllerHelper.parentIDNull(oAccount,setAcctId ));
                 /*System.debug('INSIDE PARENT ID IS NULL');
                Set<Id> setChildAccountIds = AccountDetailController.getChildAccountIds(oAccount.Id); 
                for (Account acc : [Select Id,ParentId,SAPAccountNumber__c FROM Account WHERE Id IN : setChildAccountIds]){ 
                     setAcctId.add(acc.Id);}*/
            }
            //Start: Updated for CRM-13579
           
            if(String.isnotblank(strSubBu) ){
                /*if( (strSubBu == 'USL' || strSubBu == 'Findlaw' || strSubBu == 'LMS' || strSubBu == 'US' && Schema.sObjectType.Source_System_Detail__c.isQueryable())){
                    ssdList= [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :setAcctId  and LCRM_Sales_Org__c!= null and  LCRM_Sub_BU__c IN ('USL','LMS','Findlaw', 'US')]; 
                }else{
                    ssdList= [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :setAcctId  and LCRM_Sales_Org__c!= null and  LCRM_Sub_BU__c =:strSubBu];  
                    
                }*/
                ssdList = LCRMOrderServiceControllerHelper.getSSDLists(setAcctId);
                
                System.debug(LoggingLevel.DEBUG, 'ssdList-->'+ssdList);
                if(ssdList.isEmpty()){
                 //throw new AppUtil.AppException(Label.LCRMNoSSDFoundError+' '+strSalesOrgCode);
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMNoSubBUError));} 
                else{
                    
                    /*for(Source_System_Detail__c ossd:ssdList){
                        if(ossd.Source_System_Account_Number__c !=null){
                            tempssdList.add(ossd);
                        }
                    }*/
                    tempssdList = LCRMOrderServiceControllerHelper.getTempSSDLists(ssdList);
                    if(tempssdList.isEmpty()){
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMSAPAccNumberError));}
                }
            }else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMCurrentUsersSub_BU));}
            //End: Updated for CRM-13579
        }catch(Exception oException){ ApexPages.addMessages(oException);}
    }
    /** 
     * changeDisplayOrdersGo method
     * @description : Retrieve order items based on the select list value
    */  
    public void changeDisplayOrdersGo(){
        System.debug(LoggingLevel.DEBUG, 'sSelectedOption-->'+sSelectedOption);
        map<String, OrderType__c> mapOrderType = new map<String, OrderType__c>();
        mapOrderType = OrderType__c.getAll();
        sTranslatedSelectOption = '';
        System.debug(LoggingLevel.DEBUG, 'newBegindt-->'+Date.parse(newBegindt)+'newEnddt-->'+Date.parse(newEnddt));
        try{
            if(sSelectedOption == 'All'){
                System.debug(LoggingLevel.DEBUG,'insideaall');
                allOrders = fetchOrders(Date.parse(allBegindt),Date.parse(allEnddt),'All');
                displayOrdersList = allOrders;
            }   
            if(sSelectedOption =='New'){
                System.debug(LoggingLevel.DEBUG,'inside new');
                newOrders = fetchOrders(Date.parse(newBegindt),Date.parse(newEnddt),'New');
                displayOrdersList = newOrders;
            }    
            
            /*LCRMOrderServiceControllerHelper help = new LCRMOrderServiceControllerHelper();
            help.displaypaginator(displayOrdersList,pageSize);*/
            displaypaginator(displayOrdersList);
            LCRMOrderServiceControllerHelper.translateSelectedViewOption(sSelectedOption,sTranslatedSelectOption,sCurrentUser);
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
         if(displayOrdersList == null){
            displayOrdersList= new List<LCRMOrderServiceWrapper.OrderInfo>() ; 
        }  
    }

    /** 
     * changeDisplayOrders method
     * @description : page reference method
     * @return value
    */
    public PageReference changeDisplayOrders(){
        System.debug(LoggingLevel.DEBUG,'ssdList-->'+ssdList);
        System.debug(LoggingLevel.DEBUG,'sSelectedOption-->'+sSelectedOption);
        map<String, OrderType__c> mapOrderType = new map<String, OrderType__c>();
        mapOrderType = OrderType__c.getAll();
        sTranslatedSelectOption = '';
        try{
           if(!ssdList.isEmpty() && !tempssdList.isEmpty()){
            if(sSelectedOption == 'All' && allOrders == null){
                System.debug(LoggingLevel.DEBUG,'insideaall');
                //if( allOrders == null){
                   allOrders =fetchOrders(Date.parse(allBegindt),Date.parse(allEnddt),'All');
                displayOrdersList = allOrders;
            }
            if(sSelectedOption =='New' && newOrders == null){
                System.debug(LoggingLevel.DEBUG,'inside new');
               // if(newOrders == null){
                    System.debug(LoggingLevel.DEBUG,'insdide if');
                    newOrders = fetchOrders(Date.parse(newBegindt),Date.parse(newEnddt),'New');
                displayOrdersList = newOrders;
            } 
                
               /*LCRMOrderServiceControllerHelper help = new LCRMOrderServiceControllerHelper();
               help.displaypaginator(displayOrdersList,pageSize);*/
               displaypaginator(displayOrdersList);
               LCRMOrderServiceControllerHelper.translateSelectedViewOption(sSelectedOption,sTranslatedSelectOption,sCurrentUser);
        }
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
        if(displayOrdersList == null){
            displayOrdersList= new List<LCRMOrderServiceWrapper.OrderInfo>() ; 
        }  
        return null; 
    }


    /** 
     * @description Retrieves order info utilizing the Order web service.
     * @return List<LCRMOrderServiceWrapper.OrderInfo> formatteddate
     * @param orderBeginDate
     * @param orderEndDate
     * @param sOrderType
    */ 
    public List<LCRMOrderServiceWrapper.OrderInfo>  fetchOrders(Date orderBeginDate,Date orderEndDate, string sOrderType){
        //Constants
        //final string wEBSERVICENAME = 'LCRM_GetOrder';
        //String error;
        //String strBody;
        try{
            System.debug(LoggingLevel.DEBUG,'orderBeginDate-->'+orderBeginDate+'orderEndDate-->'+orderEndDate+'Inside  fetchOrder');
            LCRMOrderServiceControllerHelperExtn.orderBeginEndDateNotNull(orderBeginDate,orderEndDate,sOrderType); 
            
            LCRMOrderServiceWrapper.OrderReqWrapper oOrderRequest = new LCRMOrderServiceWrapper.OrderReqWrapper();
            oOrderRequest.fromDate =  LCRMOrderServiceControllerHelperExtn.formatDate(orderBeginDate);
            oOrderRequest.toDate =  LCRMOrderServiceControllerHelperExtn.formatDate(orderEndDate);
            orderAccList = new  List<LCRMOrderServiceWrapper.Accounts>();
            if(!ssdList.isEmpty()){
                strSalesOrgCode = ssdList[0].LCRM_Sales_Org__c; //added for CRM-13579
                oOrderRequest.accounts = LCRMOrderServiceControllerHelper.ssdListNotEmpty(ssdList,orderAccList);
                oOrderRequest.EsiHeader.companyId = strSalesOrgCode;
            }
            List<LCRMOrderServiceWrapper.OrderTypes> orderTypeList = new List<LCRMOrderServiceWrapper.OrderTypes>();
            
            if(sOrderType == 'New'){
                orderTypeList = LCRMOrderServiceControllerHelperExtn.newsOrderType(sOrderType);
            }
            else if(sOrderType == 'All') {
                orderTypeList = LCRMOrderServiceControllerHelperExtn.allsOrderType(ordTypeptValues,oAccount);
            }
            oOrderRequest.orderTypes = orderTypeList;
            System.debug(LoggingLevel.DEBUG,'ordertypw-->'+oOrderRequest.orderTypes); 
            oOrderRequest.EsiHeader.applicationId = 'GLI';
            oOrderInfo = LCRMOrderServiceControllerHelperExtn.fetchOrdersoOrderInfo(oOrderRequest);
            //Execute the Callout
            /*strBody = JSON.serialize(oOrderRequest);
            System.debug(LoggingLevel.DEBUG,'strBody...'+strBody);
            Http http = new Http();
            HttpRequest request = new HttpRequest();               
            request = credentialHelper.getHttpRequestCred(wEBSERVICENAME,strBody);
            HttpResponse response = http.Send(request);
            System.debug(LoggingLevel.DEBUG,'response:-'+response);
            
            String orderRes=response.getBody();
            oOrderInfo = new List<LCRMOrderServiceWrapper.OrderInfo>();
            system.debug(LoggingLevel.DEBUG,'orderRes-->'+orderRes);
            
            if(response.getStatusCode() == 200 ){
                //getStatusCode200(orderRes,wEBSERVICENAME);
                  //if(!orderRes.contains('"orderList" : null')){
                     if(!orderRes.contains('"orderList" : null') && LCRMOrderServiceWrapper.getMatchedValues(orderRes).size()>0){
                        oOrderInfo = LCRMOrderServiceWrapper.getMatchedValues(orderRes);
                         System.debug(LoggingLevel.DEBUG,'oOrderInfo:-'+oOrderInfo);
                     } else if(!orderRes.contains('"orderList" : null') && OrderServiceExceptions.getExceptionMesg(orderRes)!=null){
                        ExceptionMesginfo = OrderServiceExceptions.getExceptionMesg(orderRes);
                         OrderServiceExceptions.handleException(ExceptionMesginfo,WebServiceName);
                        }
                        //}
            }
            else if(OrderServiceExceptions.getExceptionMesg(orderRes)!=null){
                exceptionMesginfo = OrderServiceExceptions.getExceptionMesg(orderRes);
                OrderServiceExceptions.handleException(exceptionMesginfo,wEBSERVICENAME);
            } 
            else {
                    strBody = 'Exception received.';
                    error = 'response Status Code:-'+response.getStatusCode()+' response Status:- '+response.getStatus();
                    System.debug(LoggingLevel.DEBUG,'strBody'+strBody+'error'+error);
                    OrderServiceExceptions.logException(strBody, error, wEBSERVICENAME);
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
            } 
        }catch(Exception oException){
                ApexPages.addMessages(oException);
        }*/
        //System.debug(LoggingLevel.DEBUG,'oOrderInfo final'+oOrderInfo.size());
    
    }catch(Exception oException){
                ApexPages.addMessages(oException);
        }
        return oOrderInfo;
    }


    /** 
     * getOrderListOptions method
     * @description Returns list of values to be selected in the page
     * @return selectoption
    */
    public List<selectoption> getOrderListOptions(){
        return LCRMOrderServiceControllerHelper.getOrderListOptionswithUser(sCurrentUser); 
    }
    

    /** 
     * displaypaginator method
     * @description displaypaginator Methods
     * @param displayOrdersList
    */
    public void displaypaginator(List<LCRMOrderServiceWrapper.OrderInfo> displayOrdersList){
        
        this.ordPaginater = new Paginate(displayOrdersList.size(), pageSize );
        this.GenericDisplayOrders = new List<List<LCRMOrderServiceWrapper.OrderInfo>>();
        this.DisplayOrders = new List<LCRMOrderServiceWrapper.OrderInfo>();
        System.debug(LoggingLevel.DEBUG,'displayOrdersList.size():-'+displayOrdersList.size());
            
        if(displayOrdersList.size() > 0 && !displayOrdersList.isEmpty() ){
            List<LCRMOrderServiceWrapper.OrderInfo> tempCC = new List<LCRMOrderServiceWrapper.OrderInfo>();
            Integer i = 0;
            //if(!displayOrdersList.isEmpty()){
               for(LCRMOrderServiceWrapper.OrderInfo cc : displayOrdersList ){
                 tempCC.add(cc);
                i++;
                    
                if(i == pageSize){
                    this.GenericDisplayOrders.add(tempCC);
                    tempCC = new List<LCRMOrderServiceWrapper.OrderInfo>();  
                    i = 0;
                    }
                } 
            
                System.debug(LoggingLevel.DEBUG,'tempCC:-'+tempCC);
                if(!tempCC.isEmpty()){
                    this.GenericDisplayOrders.add(tempCC);
                }
                 
                //Gets the correct list of data to show on the page
                System.debug(LoggingLevel.DEBUG,'****index this.ordPaginater.index'+ this.ordPaginater.index);
                this.DisplayOrders = this.GenericDisplayOrders.get(this.ordPaginater.index);
                System.debug(LoggingLevel.DEBUG,'DisplayOrders-->'+DisplayOrders);
            //}
        }
            
    } 
      
    
    /** 
     * previousPage method
     * @description Pagination Methods
     * @return PageReference
    */       
    public PageReference previousPage(){
        System.debug(LoggingLevel.DEBUG, '**previousPage**');
        this.ordPaginater.decrement();
        return changeData();
    }

    /** 
     * previousPage method
     * @description nextPage Methods
     * @return PageReference
    */ 
    public PageReference nextPage(){
        System.debug(LoggingLevel.DEBUG, '**nextPage**');
        System.debug(LoggingLevel.DEBUG,'this.ordPaginater'+this.ordPaginater);
        this.ordPaginater.increment();
        return changeData();
    }

    /** 
     * updatePage method
     * @description updatePage Methods
     * @return PageReference
    */
    public PageReference updatePage(){
        System.debug(LoggingLevel.DEBUG, '**call updatePage**');
        this.ordPaginater.updateNumbers();
        return changeData();
    }

    /** 
     * changeData method
     * @description changeData Methods
     * @return PageReference
    */
    public PageReference changeData(){
        System.debug(LoggingLevel.DEBUG, '**changeData:-**');
        this.displayOrders = this.genericDisplayOrders.get(this.ordPaginater.index);
        return null;
    }
}