/*
======================================================================================================================
CLASS NAME:  OrderDetails 
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Karthi                 Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public with sharing class OrderDetails {
    //properties
    public string sOrderDate {get;set;}
    public string sOrderType {get;set;}
    public string sOrderNumber {get;set;}
    public string sSubmittingRep {get;set;}
    public string sRevenueChannel {get;set;}
    public string sPONumber{get;set;}
    public string sShipDate{get;set;}
    public decimal dNetValue{get;set;}
    public string trackingRow{get;set;}
    public list<OrderServices.TrackingItem> Tracking {get;set;}
    public List<OrderServices.OrderItems> orderDetails {get;set;}
    public Account oAccount{get;set;}

    //Constructor 
    public OrderDetails(ApexPages.StandardController controller){
        oAccount = new account();
          //Added Test.isRunningTest() for S2E Optimisation Start
        if (Test.isRunningTest()) {
           oAccount= [select SapAccountNumber__c from account where id =:controller.getRecord().id]; 
        }
        else{        
          controller.addFields(new string[]{'SapAccountNumber__c'});
          oAccount = (account) controller.getRecord();
        }  
        //controller.addFields(new string[]{'SapAccountNumber__c'});
        //oAccount = (account) controller.getRecord();
        //Added Test.isRunningTest() for S2E Optimisation End
        Tracking=new list<OrderServices.TrackingItem>();
        sOrderType = AppUtil.getURLParam(ApexPages.currentPage(), 'OT', 'N/A'); //PageReference, UrlParamKey, Default Value
        sOrderDate = AppUtil.getURLParam(ApexPages.currentPage(), 'OD', ''); //PageReference, UrlParamKey, Default Value
        sOrderNumber = AppUtil.getURLParam(ApexPages.currentPage(), 'ON', '0'); //PageReference, UrlParamKey, Default Value
        sSubmittingRep = AppUtil.getURLParam(ApexPages.currentPage(), 'SR', 'N/A'); //PageReference, UrlParamKey, Default Value
        sRevenueChannel = AppUtil.getURLParam(ApexPages.currentPage(), 'RC', 'N/A'); //PageReference, UrlParamKey, Default Value
        sPONumber = AppUtil.getURLParam(ApexPages.currentPage(), 'PO', 'N/A'); //PageReference, UrlParamKey, Default Value
        sShipDate = AppUtil.getURLParam(ApexPages.currentPage(), 'SD', 'N/A'); //PageReference, UrlParamKey, Default Value
        dnetValue = decimal.valueOf(AppUtil.getURLParam(ApexPages.currentPage(), 'NETVAL', '0'));
        OrderServices oOrderServices = new OrderServices();
        OrderServices.OrderDetailRequest oOrderDetailRequest = new OrderServices.OrderDetailRequest();
        oOrderDetailRequest.AcctSapId = Decimal.valueof(oAccount.SapAccountNumber__c);
        oOrderDetailRequest.CompanyCode = '0010';
        oOrderDetailRequest.SalesOrgCode = 'WEST';
        oOrderDetailRequest.DistChanCode = 'W';
        oOrderDetailRequest.DivisionCode = 'W';
        oOrderDetailRequest.Ordernumber = sOrderNumber;
        oOrderDetailRequest.OrderType = sOrderType ;
        orderDetails = OrderServices.getOrderDetail(oOrderDetailRequest);
    }
}