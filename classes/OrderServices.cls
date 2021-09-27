public with sharing class OrderServices {
    //Constants
    public static final string WebServiceName = 'OrderServices';
    public static final string MockCalloutGetOrderItems = 'GetOrderItems';
    public static final string MockCalloutGetOrderDetail = 'GetOrderDetail';

    public static final string SystemId = '1';
    public list<Id> listId{get;set;}

    /**
    * Retrieves order info utilizing the Order web service.
    *
    * @paramdSAPCustomerNumberthe SAP unique customer number
    * @parambIncludeNameAddressindicates true to retrieve the address information
    * @returnan instance of a ContentOptimizerService.CustomerInfo object
    */
    public static list<OrderInfo> GetOrderInfo(OrderServices.OrderRequest oOrderRequest) {
        list<OrderInfo> oOrderInfo = new list<OrderInfo>(); 
        if (oOrderRequest.AcctSapId != null) {
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);
            OrderServicesWSv5.Order_v5_0Port oService = new OrderServicesWSv5.Order_v5_0Port();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.endpoint_x = oWebServiceSettings.Endpoint__c;
            oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            oService.outputHttpHeaders_x = new Map<String,String>();    
            list<OrderServicesWSv5.Order> outputOrder = new list<OrderServicesWSv5.Order>();
            if (Test.isRunningTest()) {
            //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutGetOrderItems);
                if (oMockResponse instanceof OrderServicesWSv5.Order) {
                    outputOrder = (list<OrderServicesWSv5.Order>) oMockResponse;
                }
            }
            else {
            //Execute Web Service Callout
                outputOrder = oService.getOrderItems(SystemId, oOrderRequest.AcctSapId, oOrderRequest.CompanyCode, oOrderRequest.SalesOrgCode, oOrderRequest.DistChanCode, oOrderRequest.DivisionCode, oOrderRequest.OrderBegDt, oOrderRequest.OrderEndDt, oOrderrequest.OrderType);
            }
            
            //oOrderInfo.parse(outputOrder);
            if(outputOrder != null){
                for (OrderServicesWSv5.order oOrderInfoList : outputOrder) {
                    orderservices.orderinfo oOrderdetail = new OrderServices.OrderInfo(oOrderInfoList);
                    oOrderInfo.add(oOrderdetail);       
                }
            }
        }
        else {
        throw new ContentOptimizerServiceException('Invalid SAP Customer Number');
        } 
        return oOrderInfo;
    }


    public static list<OrderItems> GetOrderDetail(OrderServices.OrderDetailRequest oOrderDetailRequest) {
        list<OrderItems> oOrderItem = new list<OrderItems>(); 
        if (oOrderDetailRequest.AcctSapId != null) {
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);
            OrderServicesWSv5.Order_v5_0Port oService = new OrderServicesWSv5.Order_v5_0Port();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.endpoint_x = oWebServiceSettings.Endpoint__c;
            oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            oService.outputHttpHeaders_x = new Map<String,String>();
            list<OrderServicesWSv5.OrderItem> outputOrderItem = new list<OrderServicesWSv5.OrderItem>();
            if (Test.isRunningTest()) {
                //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutGetOrderItems);
                if (oMockResponse instanceof OrderServicesWSv5.OrderItem) {
                    outputOrderItem = (list<OrderServicesWSv5.OrderItem>) oMockResponse;
                }
            }
            else {
            //Execute Web Service Callout
                outputOrderItem = oService.getOrderDetail(SystemId, oOrderDetailRequest.AcctSapId, oOrderDetailRequest.CompanyCode, oOrderDetailRequest.SalesOrgCode, oOrderDetailRequest.DistChanCode, oOrderDetailRequest.DivisionCode, oOrderDetailRequest.OrderNumber, oOrderDetailRequest.OrderType);
            }
            //oOrderInfo.parse(outputOrder);
            if(outputOrderItem != null){
                for (OrderServicesWSv5.orderItem oOrderItemList : outputOrderItem) {
                    orderservices.orderItems oOrderItemSingle = new OrderServices.OrderItems(oOrderItemList);                    
                    oOrderItem.add(oOrderItemSingle);                                                                                                 
                }
                getProducts(oOrderItem);
            }
        }
        else {
            throw new ContentOptimizerServiceException('Invalid SAP Customer Number');
        }
        return oOrderItem;
    }
    
    public static void getProducts(List<OrderItems> oOrderList){
        if(oOrderList != null){       
            List<string> materialNumList = new List<string>();
            List<product2> oProd = new list<product2>();
            Map<string,id> materialnumIdMap = new Map<string,id>();
            for(OrderItems oOrder: oOrderList){
                if(oOrder.MaterialNumber != null)  
                    materialNumList.add(oOrder.MaterialNumber); 
            }              
            //oProd= [select id,ProductCode from product2 where ProductCode in: materialNumList]; - Commented by SurajO on 7/23/2013 to list only active products
            oProd= [select id,ProductCode from product2 where ProductCode in: materialNumList and IsActive = true];
            for(product2 p:oProd ){
              materialnumIdMap.put(p.ProductCode,p.id);                           
            }
            for(OrderItems oOrder: oOrderList){
                if(oOrder.MaterialNumber != null) {
                    if(materialnumIdMap.containsKey(oOrder.MaterialNumber)) 
                        oOrder.productid=materialnumIdMap.get(oOrder.MaterialNumber); 
                }    
            }          
        }    
    }  


/* -----------------------------------------------------------Internal Classes --------------------------------------------------------------*/

    /**
    * Custom Exception thrown a web service callout fails
    */
    public class ContentOptimizerServiceException extends Exception {}

    /**
    * Data structure representing customer information
    */

    public class OrderInfo {
        public String OrderNumber {get;set;}
        public String OrderType {get;set;}
        public Date OrderDate {get;set;}
        public String Description {get;set;}
        public String DeliveryNumber {get;set;}
        public Date ShipDate {get;set;}
        public String PurchaseOrderNumber {get;set;}
        public String POName {get;set;}  
        public String RevenueChannel {get;set;}
        public String SubmittingRep {get;set;}
        public Decimal NetValue {get;set;}
        public OrderInfo(OrderServicesWSv5.order oOrderInfoList){         
            OrderNumber = oOrderInfoList.OrderNumber;
            OrderType = oOrderInfoList.OrderType;
            OrderDate = oOrderInfoList.OrderDate;
            Description = oOrderInfoList.Description;
            DeliveryNumber = oOrderInfoList.DeliveryNumber;
            ShipDate = oOrderInfoList.ShipDate;
            PurchaseOrderNumber = oOrderInfoList.PurchaseOrderNumber;
            POName = oOrderInfoList.POName;
            RevenueChannel = oOrderInfoList.RevenueChannel;
            SubmittingRep = oOrderInfoList.SubmittingRep;
            NetValue = oOrderInfoList.NetValue;
        } 
    }

    public class OrderItems {
        public String DeliveryNumber {get;set;}
        public String Description {get;set;}
        public String MaterialNumber {get;set;}
        public Integer QuantityShipped {get;set;}
        public Integer QuantityOrdered {get;set;}
        public Date DeliveryDate {get;set;}
        public String ReferenceDocNum {get;set;}
        public String referenceLineNum {get;set;}
        public Decimal NetPrice {get;set;}
        public id Productid{get;set;}
        public OrderServices.ShippingAddress ShipToAddress {get;set;}
        public OrderServices.TrackingItem[] Tracking {get;set;}
        public orderItems(OrderServicesWSv5.orderItem oOrderItemList){
            DeliveryNumber = oOrderItemList.DeliveryNumber;
            Description = oOrderItemList.Description;
            MaterialNumber = String.valueof(integer.valueof(oOrderItemList.MaterialNumber));
            QuantityShipped = oOrderItemList.QuantityShipped;
            QuantityOrdered = oOrderItemList.QuantityOrdered;
            DeliveryDate = oOrderItemList.DeliveryDate;
            ReferenceDocNum = oOrderItemList.ReferenceDocNum;
            referenceLineNum = oOrderItemList.referenceLineNum;
            NetPrice = oOrderItemList.NetPrice;
           /* if(oOrderItemList.ShipToAddress == null){
                ShipToAddress = new ShippingAddress();
            }
            else{
                ShipToAddress = new ShippingAddress(oOrderItemList.ShipToAddress);
            }
            Tracking = new List<TrackingItem>();
            if(oOrderItemList.Tracking != null){           
                for(OrderServicesWSv5.TrackingItem tItem : oOrderItemList.Tracking){
                    Tracking.add(new TrackingItem(tItem));
                }
            }    Currently not needed */
            //List<product2> oProd = new list<product2>();
            //MaterialNumber = 'Test123';
            //oOrderItemSingle.Productid = [select id from product2 where ProductCode = OOrderItemSingle.MaterialNumber];
            //oProd = [select Id from product2 where Product2.ProductCode =: OOrderItemSingle.MaterialNumber];
        } 
    }

    public class ShippingAddress {
        public Decimal AcctSapId{get;set;}
        public String Name1{get;set;}
        public String Name2{get;set;}
        public String Name3{get;set;}
        public String Street{get;set;}
        public String PoBox{get;set;}
        public String City{get;set;}
        public String Region{get;set;}
        public String PostalCode{get;set;}
        public ShippingAddress(){}
        public ShippingAddress(OrderServicesWSv5.ShippingAddress sAddress){
            AcctSapId=sAddress.AcctSapId;
            Name1=sAddress.Name1;
            Name2=sAddress.Name2;
            Name3=sAddress.Name3;
            Street=sAddress.Street;
            PoBox=sAddress.PoBox;
            City=sAddress.City;
            Region=sAddress.Region;
            PostalCode=sAddress.PostalCode;
        }
    }

    public class TrackingItem {
        public String TrackingNumber{get;set;}
        public String DeliveryCompany{get;set;}
        public String Weight{get;set;}
        public String WeightUnit{get;set;}
        public TrackingItem(OrderServicesWSv5.TrackingItem tItem){
            TrackingNumber = tItem.TrackingNumber;
            DeliveryCompany = tItem.DeliveryCompany;
            Weight = tItem.Weight;
            WeightUnit = tItem.WeightUnit;
        }
    }

    public class OrderRequest { 
        public Decimal[] AcctSapId {get;set;}
        public String CompanyCode {get;set;}
        public String SalesOrgCode{get;set;}
        public String DistChanCode {get;set;}
        public String DivisionCode {get;set;}
        public date OrderBegDt {get;set;}
        public date OrderEndDt {get;set;}
        public string[] OrderType {get;set;}
    }
    
    public class OrderDetailRequest { 
        public Decimal AcctSapId {get;set;}
        public String CompanyCode {get;set;}
        public String SalesOrgCode{get;set;}
        public String DistChanCode {get;set;}
        public String DivisionCode {get;set;}
        public string OrderNumber {get;set;}
        public string OrderType {get;set;}
    }
}