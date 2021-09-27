@isTest(seealldata=true)

public class OrderServices_Test{
    
    public static testmethod void testOrderServices(){
        OrderServices testobj = new OrderServices();
        OrderServices.OrderDetailRequest oOrderDetailRequest = new OrderServices.OrderDetailRequest();
        oOrderDetailRequest.AcctSapId = 00001;
        oOrderDetailRequest.CompanyCode = 'test';
        oOrderDetailRequest.SalesOrgCode = 'test';
        oOrderDetailRequest.DistChanCode = 'test';
        oOrderDetailRequest.DivisionCode = 'test';
        oOrderDetailRequest.OrderNumber = '1';
        oOrderDetailRequest.OrderType = 'test';

        OrderServices.GetOrderDetail(oOrderDetailRequest);
        
        OrderServices.OrderRequest oOrderRequest = new OrderServices.OrderRequest();
        oOrderRequest.AcctSapId = new Decimal[]{0};
        oOrderRequest.SalesOrgCode = 'test';
        oOrderRequest.DistChanCode = 'test';
        oOrderRequest.DivisionCode = 'test';
        oOrderRequest.OrderBegDt = System.today();
        oOrderRequest.OrderEndDt = System.today()+2;
        oOrderRequest.OrderType = new String[] {'test'};

        OrderServices.GetOrderInfo(oOrderRequest);
        OrderServices.getProducts(new List<OrderServices.OrderItems>());
        OrderServices.TrackingItem testobject = new OrderServices.TrackingItem( new OrderServicesWSv5.TrackingItem());
        OrderServices.OrderInfo testobj1 = new OrderServices.OrderInfo (new OrderServicesWSv5.order());
        OrderServicesWSv5.orderItem testItem = new OrderServicesWSv5.orderItem();
        testItem.MaterialNumber = '1245';
        OrderServices.OrderItems testobj2 = new OrderServices.OrderItems(testItem);
        OrderServices.ShippingAddress testobj3 = new OrderServices.ShippingAddress( new OrderServicesWSv5.ShippingAddress());
    
    }

}