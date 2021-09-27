/**
 * Controller for Orders page. This is used to fetch Orders from ESI using REST Webservice.
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date                 Name                         Description
 * 2020-06-04       Shyamsundar shet                Modified for BMP-1969                                                     
 * =============================================================================
 */

public with sharing class Orders {
    public Account oAccount{get;set;}
    public string sSelectedOption{get;set;} 
    public string newBegindt{get;set;}    
    public string newEnddt{get;set;}
    public string allBegindt{get;set;} 
    public string allEnddt{get;set;} 
    public String strSalesOrgCode{get;set;}
    
    public List<LCRMOrderServiceWrapper.Accounts> orderAccList{get;set;} 
    public User sCurrentUser{get;set;}
    public string sTranslatedSelectOption {get;set;}   
    public Set<ID> setAcctId{get;set;}
    public List<Source_System_Detail__c> ssdList{get;set;}
    public List<Source_System_Detail__c> tempssdList;
    public List<LCRMOrderServiceWrapper.OrderInfo> oOrderInfo {get;set;}  
    public List<LCRMOrderServiceWrapper.OrderInfo> DisplayOrdersList {get;set;}
    public List<LCRMOrderServiceWrapper.OrderInfo> AllOrders {get;set;}
    public List<LCRMOrderServiceWrapper.OrderInfo> NewOrders {get;set;}
    public OrderServiceExceptions.StatusDetail ExceptionMesginfo{get;set;}
    public List<String> ordTypeptValues {get; set;}
    public String strSubBu{get;set;} //added for CRM-13579
    //Pagination Paramters
    public List<LCRMOrderServiceWrapper.OrderInfo> DisplayOrders {get;set;}
    public List<List<LCRMOrderServiceWrapper.OrderInfo>> GenericDisplayOrders {get;set;}
    public Paginate ordPaginater {get;set;}
    public Integer pageSize {get;set;}

    //Integration Logger Paramters
    public String error;
    public String strBody;

    //Constants
    public static final string WebServiceName = 'LCRM_GetOrder';

      public Orders(ApexPages.StandardController controller){
        try{
            sCurrentUser = [select LanguageLocaleKey,Sales_Org__c,Sub_Bu__c from User where id = :UserInfo.getUserId()]; 
            System.debug('sCurrentUser-->'+sCurrentUser); 
           
            oAccount = new account();
            oAccount = (account) controller.getRecord(); 
            oAccount = [Select Id,Sales_Org__c,ParentId,SAPAccountNumber__c FROM Account WHERE Id =:oAccount.Id];
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
                System.debug('INSIDE PARENT ID IS NULL');
                Set<Id> setChildAccountIds = AccountDetailController.getChildAccountIds(oAccount.Id); 
                for (Account acc : [Select Id,ParentId,SAPAccountNumber__c FROM Account WHERE Id IN : setChildAccountIds]){ 
                     setAcctId.add(acc.Id);
                }
            }
           
            //End: Updated for CRM-13579
            
        }catch(Exception oException){
            ApexPages.addMessages(oException);
      }
    }
    /* -------------------------------------------------------------------------------    
    Retrieve order items based on the select list value
    --------------------------------------------------------------------------------*/  
    public void changeDisplayOrdersGo(){
        System.debug('sSelectedOption-->'+sSelectedOption);
        map<String, OrderType__c> mapOrderType = OrderType__c.getAll();
        sTranslatedSelectOption = '';
        System.debug('newBegindt-->'+Date.parse(newBegindt));
        System.debug('newEnddt-->'+Date.parse(newEnddt));
        try{
            if(sSelectedOption == 'All'){
                System.debug('insideaall');
                AllOrders = fetchOrders(Date.parse(allBegindt),Date.parse(allEnddt),'All');
                DisplayOrdersList = AllOrders;
            }   
            if(sSelectedOption =='New'){
                System.debug('inside new');
                NewOrders = fetchOrders(Date.parse(newBegindt),Date.parse(newEnddt),'New');
                DisplayOrdersList = NewOrders;
            }    
            
            displaypaginator(DisplayOrdersList);
            translateSelectedViewOption(sSelectedOption);
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
         if(DisplayOrdersList == null){
            DisplayOrdersList= new List<LCRMOrderServiceWrapper.OrderInfo>() ; 
        }  
    }

    public PageReference changeDisplayOrders(){
        System.debug('ssdList-->'+ssdList);
        System.debug('sSelectedOption-->'+sSelectedOption);
        map<String, OrderType__c> mapOrderType = OrderType__c.getAll();
        sTranslatedSelectOption = '';
        try{
           //if(!ssdList.isEmpty() && !tempssdList.isEmpty()){
            if(sSelectedOption == 'All'){
                System.debug('insideaall');
                if( AllOrders == null){
                   AllOrders =fetchOrders(Date.parse(allBegindt),Date.parse(allEnddt),'All');
                }
                DisplayOrdersList = AllOrders;
            }
            if(sSelectedOption =='New'){
                System.debug('inside new');
                if(NewOrders == null){
                    System.debug('insdide if');
                    NewOrders = fetchOrders(Date.parse(newBegindt),Date.parse(newEnddt),'New');
                }
                DisplayOrdersList = NewOrders;
            } 
           
                displaypaginator(DisplayOrdersList);
                translateSelectedViewOption(sSelectedOption);
        
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
        if(DisplayOrdersList == null){
            DisplayOrdersList= new List<LCRMOrderServiceWrapper.OrderInfo>() ; 
        }  
        return null; 
    }

    /* -------------------------------------------------------------------------------    
    Set the Date format
    --------------------------------------------------------------------------------*/  
    public static String formatDate(Date d) {
        String formatteddate;
        String datemonth = String.valueOf(d.month());
        System.debug('d.month().length()-->'+datemonth.length());
        if(datemonth.length() == 1)
            formatteddate= d.year() + '-0' + d.month() + '-' + d.day(); 
        else
            formatteddate= d.year() + '-' + d.month() + '-' + d.day();
        return formatteddate;
    }

    /* -------------------------------------------------------------------------------    
    Retrieves order info utilizing the Order web service.
    --------------------------------------------------------------------------------*/  
    public List<LCRMOrderServiceWrapper.OrderInfo>  fetchOrders(Date orderBeginDate,Date orderEndDate, string sOrderType){
        try{
            System.debug('orderBeginDate-->'+orderBeginDate);
            System.debug('orderEndDate-->'+orderEndDate);
            System.debug('Inside  fetchOrder');
            if(orderBeginDate != null ||  orderEndDate != null){
                if(orderBeginDate > orderEndDate)
                    throw new AppUtil.AppException(Label.LCRMOrdersEndDateCheck);
                if(sOrderType =='All'){
                     if(orderBeginDate.daysbetween(orderEndDate)>31)
                        throw new AppUtil.AppException(Label.LCRMOrdersDateRangecheck);
                    
                }
            } 
            LCRMOrderServiceWrapper.OrderReqWrapper oOrderRequest = new LCRMOrderServiceWrapper.OrderReqWrapper();
            oOrderRequest.fromDate =  formatDate(orderBeginDate);
            oOrderRequest.toDate =  formatDate(orderEndDate);
            orderAccList = new  List<LCRMOrderServiceWrapper.Accounts>();
            //if(!ssdList.isEmpty()){
                //strSalesOrgCode = ssdList[0].LCRM_Sales_Org__c; //added for CRM-13579
                strSalesOrgCode = oAccount.Sales_Org__c;
               //for(Source_System_Detail__c ssd : ssdList){
                    System.debug('Inside FORSSD');
                    LCRMOrderServiceWrapper.Accounts oAcc = new LCRMOrderServiceWrapper.Accounts();
                    //oAcc.accountNumber = ssd.Source_System_Account_Number__c;
                    oAcc.accountNumber = oAccount.SAPAccountNumber__c;
                    orderAccList.add(oAcc);   
                //} 
                oOrderRequest.accounts = orderAccList;
            
            
            oOrderRequest.EsiHeader.companyId = strSalesOrgCode;
            //}
            List<LCRMOrderServiceWrapper.OrderTypes> orderTypeList = new List<LCRMOrderServiceWrapper.OrderTypes>();
            
            if(sOrderType == 'New'){
                LCRMOrderServiceWrapper.OrderTypes reqOT = new LCRMOrderServiceWrapper.OrderTypes();
                for(OrderType__c ot : [Select values__c from OrderType__c where Name = :sOrderType] ){
                reqOT.orderType = ot.Values__c;
                orderTypeList.add(reqOT);
                }
            }
            else if(sOrderType == 'All') {
                 ordTypeptValues = new List<String>();
                 ordTypeptValues.addAll(OAccount.order_type__c.split(';'));
                 System.debug('ordTypeptValues-->'+ordTypeptValues);
               
                if(!ordTypeptValues.isEmpty()){
                    for(String ordType : ordTypeptValues ){
                         LCRMOrderServiceWrapper.OrderTypes reqOT = new LCRMOrderServiceWrapper.OrderTypes();
                         reqOT.orderType  = ordType;
                         orderTypeList.add(reqOT);
                    }
                }
            }
            oOrderRequest.orderTypes = orderTypeList;
            System.debug('ordertypw-->'+oOrderRequest.orderTypes); 
            oOrderRequest.EsiHeader.applicationId = 'GLI';
            
            //Execute the Callout
            String strBody = JSON.serialize(oOrderRequest);
            System.debug('strBody...'+strBody);
            Http http = new Http();
            HttpRequest request = new HttpRequest();               
            request = getHttpRequestCred(WebServiceName,strBody);
            HttpResponse Response = http.Send(request);
            System.debug('Response:-'+Response);
            
            String orderRes=Response.getBody();
            oOrderInfo = new List<LCRMOrderServiceWrapper.OrderInfo>();
            system.debug('orderRes-->'+orderRes);
            
            if(Response.getStatusCode() == 200 ){
                if(!orderRes.contains('"orderList" : null')){
                     if(LCRMOrderServiceWrapper.getMatchedValues(orderRes).size()>0){
                        oOrderInfo = LCRMOrderServiceWrapper.getMatchedValues(orderRes);
                         System.debug('oOrderInfo:-'+oOrderInfo);
                     } else if(OrderServiceExceptions.getExceptionMesg(orderRes)!=null){
                        ExceptionMesginfo = OrderServiceExceptions.getExceptionMesg(orderRes);
                         OrderServiceExceptions.handleException(ExceptionMesginfo,WebServiceName);
                        }
                } else{
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebserviceNoResponse));
                }
            } else if(OrderServiceExceptions.getExceptionMesg(orderRes)!=null){
                ExceptionMesginfo = OrderServiceExceptions.getExceptionMesg(orderRes);
                OrderServiceExceptions.handleException(ExceptionMesginfo,WebServiceName);
            } else {
                    strBody = 'Exception received.';
                    error = 'Response Status Code:-'+Response.getStatusCode()+' Response Status:- '+Response.getStatus();
                    System.debug('strBody'+strBody+'error'+error);
                    OrderServiceExceptions.logException(strBody, error, WebServiceName);
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
            } 
        }catch(Exception oException){
                ApexPages.addMessages(oException);
        }
        System.debug('oOrderInfo final'+oOrderInfo.size());
        return oOrderInfo;
    }

    /* -------------------------------------------------------------------------------    
    Translating the selectedOption into User's languages
    --------------------------------------------------------------------------------*/   
    public void translateSelectedViewOption(String sSeletedOption){
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
    }
    
    /* -------------------------------------------------------------------------------    
    Returns list of values to be selected in the page
    --------------------------------------------------------------------------------*/
    public List<selectoption> getOrderListOptions(){
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

     
     /*-------------------------------------------------------------------------------    
        Method to add pagination
    --------------------------------------------------------------------------------*/
    public void displaypaginator(List<LCRMOrderServiceWrapper.OrderInfo> DisplayOrdersList){
        
        this.ordPaginater = new Paginate(DisplayOrdersList.size(), pageSize );
        this.GenericDisplayOrders = new List<List<LCRMOrderServiceWrapper.OrderInfo>>();
        this.DisplayOrders = new List<LCRMOrderServiceWrapper.OrderInfo>();
        System.debug('DisplayOrdersList.size():-'+DisplayOrdersList.size());
            
        if(DisplayOrdersList.size() > 0){
            List<LCRMOrderServiceWrapper.OrderInfo> tempCC = new List<LCRMOrderServiceWrapper.OrderInfo>();
            Integer i = 0;
            if(!DisplayOrdersList.isEmpty()){
               for(LCRMOrderServiceWrapper.OrderInfo cc : DisplayOrdersList ){
                 tempCC.add(cc);
                i++;
                    
                if(i == pageSize){
                    this.GenericDisplayOrders.add(tempCC);
                    tempCC = new List<LCRMOrderServiceWrapper.OrderInfo>();  
                    i = 0;
                    }
                } 
            
                System.debug('tempCC:-'+tempCC);
                if(!tempCC.isEmpty()){
                    this.GenericDisplayOrders.add(tempCC);
                }
                 
                //Gets the correct list of data to show on the page
                System.debug('****index this.ordPaginater.index'+ this.ordPaginater.index);
                this.DisplayOrders = this.GenericDisplayOrders.get(this.ordPaginater.index);
                System.debug('DisplayOrders-->'+DisplayOrders);
            }
        }
            
    }   
    
    
    Public HttpRequest getHttpRequestCred(String WebServiceName,String jsonString){
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);      
        System.debug('oWebServiceSettings:-'+oWebServiceSettings);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(oWebServiceSettings.Endpoint__c);
        request.setMethod('GET');
        String HeaderVal = 'Authorization';
        // Specify the required user name and password to access the endpoint 
        // As well as the header and header information 
        Blob headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        request.setHeader('Content-Type', 'application/json');
        // Header info with remote server user name and password
        request.setHeader(string.escapeSingleQuotes(HeaderVal), authorizationHeader);
        // timeout in milliseconds       
        request.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
        System.debug('jsonString:-'+jsonString);
        if(String.IsNotBlank(jsonString)){
            request.setBody(jsonString);
            System.debug('request:-'+request);
        }
        return request; 
    
    }
    
     /*-------------------------------------------------------------------------------    
        Pagination Methods
    --------------------------------------------------------------------------------*/        
    public PageReference previousPage(){
        System.debug('**previousPage**');
        this.ordPaginater.decrement();
        return changeData();
    }

    public PageReference nextPage(){
        System.debug('**nextPage**');
        this.ordPaginater.increment();
        return changeData();
    }

    public PageReference updatePage(){
        System.debug('**call updatePage**');
        this.ordPaginater.updateNumbers();
        return changeData();
    }

    public PageReference changeData(){
        System.debug('**changeData:-**');
        this.DisplayOrders = this.GenericDisplayOrders.get(this.ordPaginater.index);
        return null;
    }
}