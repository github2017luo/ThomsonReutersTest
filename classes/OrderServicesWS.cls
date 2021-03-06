//Generated by wsdl2apex

public class OrderServicesWS {
    public class Order_v4_0Port {
        public String endpoint_x = 'http://crmrocketqa.int.westgroup.com/rocketdeploy/services/Order_v4_0Port';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/4.0/order', 'OrderServicesWS', 'http://west.thomson.com/crm/rocketxsd/4.0/order', 'OrderServicesWS'};
        public OrderServicesWS.Order[] GetOrderItems(String SystemId,Decimal[] AcctSapId,String CompanyCode,String SalesOrgCode,String DistChanCode,String DivisionCode,Date OrderBegDt,Date OrderEndDt,String[] OrderType) {
            OrderServicesWS.GetOrderItems_element request_x = new OrderServicesWS.GetOrderItems_element();
            OrderServicesWS.GetOrderItemsResponse_element response_x = new OrderServicesWS.GetOrderItemsResponse_element();
            request_x.SystemId = SystemId;
            request_x.AcctSapId = AcctSapId;
            request_x.CompanyCode = CompanyCode;
            request_x.SalesOrgCode = SalesOrgCode;
            request_x.DistChanCode = DistChanCode;
            request_x.DivisionCode = DivisionCode;
            request_x.OrderBegDt = OrderBegDt;
            request_x.OrderEndDt = OrderEndDt;
            request_x.OrderType = OrderType;
            Map<String, OrderServicesWS.GetOrderItemsResponse_element> response_map_x = new Map<String, OrderServicesWS.GetOrderItemsResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.Isrunningtest()){
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'GetOrderItems',
              'http://west.thomson.com/crm/rocketservices/4.0/order',
              'GetOrderItems',
              'http://west.thomson.com/crm/rocketservices/4.0/order',
              'GetOrderItemsResponse',
              'OrderServicesWS.GetOrderItemsResponse_element'}
            );
            }
            response_x = response_map_x.get('response_x');
            return response_x.Order;
        }
        public OrderServicesWS.OrderItem[] GetOrderDetail(String SystemId,Decimal AcctSapId,String CompanyCode,String SalesOrgCode,String DistChanCode,String DivisionCode,String OrderNumber,String OrderType) {
            OrderServicesWS.GetOrderDetail_element request_x = new OrderServicesWS.GetOrderDetail_element();
            OrderServicesWS.GetOrderDetailResponse_element response_x = new OrderServicesWS.GetOrderDetailResponse_element();
            request_x.SystemId = SystemId;
            request_x.AcctSapId = AcctSapId;
            request_x.CompanyCode = CompanyCode;
            request_x.SalesOrgCode = SalesOrgCode;
            request_x.DistChanCode = DistChanCode;
            request_x.DivisionCode = DivisionCode;
            request_x.OrderNumber = OrderNumber;
            request_x.OrderType = OrderType;
            Map<String, OrderServicesWS.GetOrderDetailResponse_element> response_map_x = new Map<String, OrderServicesWS.GetOrderDetailResponse_element>();
            response_map_x.put('response_x', response_x);
            If(!Test.IsRunningTest()){
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'GetOrderDetail',
              'http://west.thomson.com/crm/rocketservices/4.0/order',
              'GetOrderDetail',
              'http://west.thomson.com/crm/rocketservices/4.0/order',
              'GetOrderDetailResponse',
              'OrderServicesWS.GetOrderDetailResponse_element'}
            );
            }
            response_x = response_map_x.get('response_x');
            return response_x.OrderItem;
        }
    }
    public class TrackingItem {
        public String TrackingNumber;
        public String DeliveryCompany;
        public String Weight;
        public String WeightUnit;
        private String[] TrackingNumber_type_info = new String[]{'TrackingNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] DeliveryCompany_type_info = new String[]{'DeliveryCompany','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Weight_type_info = new String[]{'Weight','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] WeightUnit_type_info = new String[]{'WeightUnit','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketxsd/4.0/order','true','false'};
        private String[] field_order_type_info = new String[]{'TrackingNumber','DeliveryCompany','Weight','WeightUnit'};
    }
    public class OrderItem {
        public String DeliveryNumber;
        public String Description;
        public String MaterialNumber;
        public Integer QuantityShipped;
        public Integer QuantityOrdered;
        public Date DeliveryDate;
        public String ReferenceDocNum;
        public String referenceLineNum;
        public Decimal NetPrice;
        public OrderServicesWS.ShippingAddress ShipToAddress;
        public OrderServicesWS.TrackingItem[] Tracking;
        private String[] DeliveryNumber_type_info = new String[]{'DeliveryNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] MaterialNumber_type_info = new String[]{'MaterialNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] QuantityShipped_type_info = new String[]{'QuantityShipped','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] QuantityOrdered_type_info = new String[]{'QuantityOrdered','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] DeliveryDate_type_info = new String[]{'DeliveryDate','http://www.w3.org/2001/XMLSchema','date','0','1','false'};
        private String[] ReferenceDocNum_type_info = new String[]{'ReferenceDocNum','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] referenceLineNum_type_info = new String[]{'referenceLineNum','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] NetPrice_type_info = new String[]{'NetPrice','http://www.w3.org/2001/XMLSchema','decimal','0','1','false'};
        private String[] ShipToAddress_type_info = new String[]{'ShipToAddress','http://west.thomson.com/crm/rocketxsd/4.0/order','ShippingAddress','0','1','false'};
        private String[] Tracking_type_info = new String[]{'Tracking','http://west.thomson.com/crm/rocketxsd/4.0/order','TrackingItem','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketxsd/4.0/order','true','false'};
        private String[] field_order_type_info = new String[]{'DeliveryNumber','Description','MaterialNumber','QuantityShipped','QuantityOrdered','DeliveryDate','ReferenceDocNum','referenceLineNum','NetPrice','ShipToAddress','Tracking'};
    }
    public class GetOrderDetail_element {
        public String SystemId;
        public Decimal AcctSapId;
        public String CompanyCode;
        public String SalesOrgCode;
        public String DistChanCode;
        public String DivisionCode;
        public String OrderNumber;
        public String OrderType;
        private String[] SystemId_type_info = new String[]{'SystemId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] AcctSapId_type_info = new String[]{'AcctSapId','http://www.w3.org/2001/XMLSchema','decimal','1','1','false'};
        private String[] CompanyCode_type_info = new String[]{'CompanyCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] SalesOrgCode_type_info = new String[]{'SalesOrgCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] DistChanCode_type_info = new String[]{'DistChanCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] DivisionCode_type_info = new String[]{'DivisionCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] OrderNumber_type_info = new String[]{'OrderNumber','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] OrderType_type_info = new String[]{'OrderType','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/4.0/order','true','false'};
        private String[] field_order_type_info = new String[]{'SystemId','AcctSapId','CompanyCode','SalesOrgCode','DistChanCode','DivisionCode','OrderNumber','OrderType'};
    }
    public class ShippingAddress {
        public Decimal AcctSapId;
        public String Name1;
        public String Name2;
        public String Name3;
        public String Street;
        public String PoBox;
        public String City;
        public String Region;
        public String PostalCode;
        private String[] AcctSapId_type_info = new String[]{'AcctSapId','http://www.w3.org/2001/XMLSchema','decimal','0','1','false'};
        private String[] Name1_type_info = new String[]{'Name1','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Name2_type_info = new String[]{'Name2','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Name3_type_info = new String[]{'Name3','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Street_type_info = new String[]{'Street','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PoBox_type_info = new String[]{'PoBox','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] City_type_info = new String[]{'City','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Region_type_info = new String[]{'Region','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PostalCode_type_info = new String[]{'PostalCode','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketxsd/4.0/order','true','false'};
        private String[] field_order_type_info = new String[]{'AcctSapId','Name1','Name2','Name3','Street','PoBox','City','Region','PostalCode'};
    }
    public class GetOrderDetailResponse_element {
        public OrderServicesWS.OrderItem[] OrderItem;
        private String[] OrderItem_type_info = new String[]{'OrderItem','http://west.thomson.com/crm/rocketxsd/4.0/order','OrderItem','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/4.0/order','true','false'};
        private String[] field_order_type_info = new String[]{'OrderItem'};
    }
    public class GetOrderItems_element {
        public String SystemId;
        public Decimal[] AcctSapId;
        public String CompanyCode;
        public String SalesOrgCode;
        public String DistChanCode;
        public String DivisionCode;
        public Date OrderBegDt;
        public Date OrderEndDt;
        public String[] OrderType;
        private String[] SystemId_type_info = new String[]{'SystemId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] AcctSapId_type_info = new String[]{'AcctSapId','http://www.w3.org/2001/XMLSchema','decimal','0','-1','false'};
        private String[] CompanyCode_type_info = new String[]{'CompanyCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] SalesOrgCode_type_info = new String[]{'SalesOrgCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] DistChanCode_type_info = new String[]{'DistChanCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] DivisionCode_type_info = new String[]{'DivisionCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] OrderBegDt_type_info = new String[]{'OrderBegDt','http://www.w3.org/2001/XMLSchema','date','1','1','false'};
        private String[] OrderEndDt_type_info = new String[]{'OrderEndDt','http://www.w3.org/2001/XMLSchema','date','1','1','false'};
        private String[] OrderType_type_info = new String[]{'OrderType','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/4.0/order','true','false'};
        private String[] field_order_type_info = new String[]{'SystemId','AcctSapId','CompanyCode','SalesOrgCode','DistChanCode','DivisionCode','OrderBegDt','OrderEndDt','OrderType'};
    }
    public class Order {
        public Decimal AcctSapId;
        public String OrderNumber;
        public String OrderType;
        public Date OrderDate;
        public String Description;
        public String DeliveryNumber;
        public Date ShipDate;
        public String PurchaseOrderNumber;
        public String RevenueChannel;
        public String SubmittingRep;
        public Decimal NetValue;
        private String[] AcctSapId_type_info = new String[]{'AcctSapId','http://www.w3.org/2001/XMLSchema','decimal','0','1','false'};
        private String[] OrderNumber_type_info = new String[]{'OrderNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OrderType_type_info = new String[]{'OrderType','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OrderDate_type_info = new String[]{'OrderDate','http://www.w3.org/2001/XMLSchema','date','0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] DeliveryNumber_type_info = new String[]{'DeliveryNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ShipDate_type_info = new String[]{'ShipDate','http://www.w3.org/2001/XMLSchema','date','0','1','false'};
        private String[] PurchaseOrderNumber_type_info = new String[]{'PurchaseOrderNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RevenueChannel_type_info = new String[]{'RevenueChannel','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SubmittingRep_type_info = new String[]{'SubmittingRep','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] NetValue_type_info = new String[]{'NetValue','http://www.w3.org/2001/XMLSchema','decimal','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketxsd/4.0/order','true','false'};
        private String[] field_order_type_info = new String[]{'AcctSapId','OrderNumber','OrderType','OrderDate','Description','DeliveryNumber','ShipDate','PurchaseOrderNumber','RevenueChannel','SubmittingRep','NetValue'};
    }
    public class GetOrderItemsResponse_element {
        public OrderServicesWS.Order[] Order;
        private String[] Order_type_info = new String[]{'Order','http://west.thomson.com/crm/rocketxsd/4.0/order','Order','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/4.0/order','true','false'};
        private String[] field_order_type_info = new String[]{'Order'};
    }
}