/**
 * Helper extn  for LCRMOrderServiceController. This is used to fetch Orders from ESI using REST Webservice.
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

public with sharing class LCRMOrderServiceControllerHelperExtn {
   
    /**
     * public oOrderInfo method
     * @description : public oOrderInfo getter setter method
     */ 
    public List<LCRMOrderServiceWrapper.OrderInfo> oOrderInfo {get;set;} 
    
    /**
     * public oOrderInfo method
     * @description : public oOrderInfo getter setter method
     */ 
    //public List<LCRMOrderServiceWrapper.OrderInfo> oOrderInfo {get;set;} 
    /**
     * public exceptionMesginfo method
     * @description : public exceptionMesginfo getter setter method
     */
    public static OrderServiceExceptions.StatusDetail exceptionMesginfo{get;set;}
    
    
    /** 
     * orderBeginEndDateNotNull method
     * @description orderBeginEndDateNotNull method
     * @param orderBeginDate
     * @param orderEndDate
     * @param sOrderType
    */
    public static void orderBeginEndDateNotNull(Date orderBeginDate,Date orderEndDate,string sOrderType){
        if(orderBeginDate != null ||  orderEndDate != null)
        {
            if(orderBeginDate > orderEndDate){
                throw new AppUtil.AppException(Label.LCRMOrdersEndDateCheck);}
            if(sOrderType =='All' && orderBeginDate.daysbetween(orderEndDate)>31){
                throw new AppUtil.AppException(Label.LCRMOrdersDateRangecheck);}
        } 
    }
    
    /** 
     * newsOrderType method
     * @description onewsOrderType method
     * @return List<LCRMOrderServiceWrapper.OrderTypes>
     * @param sOrderType
    */
    public static List<LCRMOrderServiceWrapper.OrderTypes> newsOrderType(string sOrderType)
    {
        List<LCRMOrderServiceWrapper.OrderTypes> orderTypeList = new List<LCRMOrderServiceWrapper.OrderTypes>();
        LCRMOrderServiceWrapper.OrderTypes reqOT = new LCRMOrderServiceWrapper.OrderTypes();
        for(OrderType__c ot : [Select values__c from OrderType__c where Name = :sOrderType] ){
            reqOT.orderType = ot.Values__c;
            orderTypeList.add(reqOT);
        }
        return orderTypeList;
    }
    
        /** 
     * allsOrderType method
     * @description allsOrderType method
     * @return List<LCRMOrderServiceWrapper.OrderTypes>
     * @param ordTypeptValues
     * @param oAccount
    */
    public static List<LCRMOrderServiceWrapper.OrderTypes> allsOrderType(List<String> ordTypeptValues,Account oAccount)
    {   
        List<LCRMOrderServiceWrapper.OrderTypes> orderTypeList = new List<LCRMOrderServiceWrapper.OrderTypes>();
        ordTypeptValues = new List<String>();
        ordTypeptValues.addAll(OAccount.order_type__c.split(';'));
        System.debug(LoggingLevel.DEBUG,'ordTypeptValues-->'+ordTypeptValues);
                
        if(!ordTypeptValues.isEmpty()){
            for(String ordType : ordTypeptValues ){
                LCRMOrderServiceWrapper.OrderTypes reqOT = new LCRMOrderServiceWrapper.OrderTypes();
                reqOT.orderType  = ordType;
                orderTypeList.add(reqOT);
            }
        }
        return orderTypeList;
    }
    
    
    /** 
     * formatDate method
     * @description : Set the Date format
     * @return formatteddate
     * @param d
    */
    public static String formatDate(Date d) {
        String formatteddate;
        String datemonth = String.valueOf(d.month());
        System.debug(LoggingLevel.DEBUG,'d.month().length()-->'+datemonth.length());
        if(datemonth.length() == 1)
            {formatteddate= d.year() + '-0' + d.month() + '-' + d.day(); }
        else
            {formatteddate= d.year() + '-' + d.month() + '-' + d.day(); }
        return formatteddate;
    }
    
    

    /** 
     * fetchOrdersoOrderInfo method
     * @description fetchOrdersoOrderInfo method
     * @return oOrderInfo
     * @param oOrderRequest
    */
    public static List<LCRMOrderServiceWrapper.OrderInfo> fetchOrdersoOrderInfo(LCRMOrderServiceWrapper.OrderReqWrapper oOrderRequest)
    {
        List<LCRMOrderServiceWrapper.OrderInfo> oOrderInfo = new List<LCRMOrderServiceWrapper.OrderInfo>();
        final string wEBSERVICENAME = 'LCRM_GetOrder';
        String error;
        LCRMCredentialInfoHelper credentialHelper = new LCRMCredentialInfoHelper();
        try{
        //LCRMOrderServiceWrapper.OrderReqWrapper oOrderRequest = new LCRMOrderServiceWrapper.OrderReqWrapper();
                String strBody = JSON.serialize(oOrderRequest);
                System.debug(LoggingLevel.DEBUG,'strBody...'+strBody);
                Http http = new Http();
                HttpRequest request = new HttpRequest();               
                request = credentialHelper.getHttpRequestCred(wEBSERVICENAME,strBody);
                HttpResponse response = http.Send(request);
                System.debug(LoggingLevel.DEBUG,'response:-'+response);
                String orderRes=response.getBody();
                
                system.debug(LoggingLevel.DEBUG,'orderRes-->'+orderRes);
                
                if(response.getStatusCode() == 200 ){
                    //getStatusCode200(orderRes,wEBSERVICENAME);
                      //if(!orderRes.contains('"orderList" : null')){
                        if(!orderRes.contains('"orderList" : null') && LCRMOrderServiceWrapper.getMatchedValues(orderRes).size()>0){
                        //if(LCRMOrderServiceWrapper.getMatchedValues(orderRes).size()>0){
                            oOrderInfo = LCRMOrderServiceWrapper.getMatchedValues(orderRes);
                             System.debug(LoggingLevel.DEBUG,'oOrderInfo:-'+oOrderInfo);
                         } 
                          else if(!orderRes.contains('"orderList" : null') && OrderServiceExceptions.getExceptionMesg(orderRes)!=null){
                          //else if(OrderServiceExceptions.getExceptionMesg(orderRes)!=null){
                            exceptionMesginfo = OrderServiceExceptions.getExceptionMesg(orderRes);
                             OrderServiceExceptions.handleException(exceptionMesginfo,WebServiceName);
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
            }
            
            return oOrderInfo;
    }
    
    

}