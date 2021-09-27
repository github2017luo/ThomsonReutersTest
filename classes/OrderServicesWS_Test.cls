@IsTest(seeAllData=true)
public class OrderServicesWS_Test{

   public static testmethod void testOrderServicesWS(){
        OrderServicesWS.Order_v4_0Port testPort = new OrderServicesWS.Order_v4_0Port();
        testPort.GetOrderItems('test',new Decimal[] {0},'test','test','test','test',System.today(),System.today()+2,new String[] {'test'});
        testPort.GetOrderDetail('test',0,'test','test','test','test','test','test');
        OrderServicesWS.TrackingItem testobj = new OrderServicesWS.TrackingItem();
        OrderServicesWS.Order testobj1 = new OrderServicesWS.Order();
        OrderServicesWS.OrderItem testobj2 = new OrderServicesWS.OrderItem();
        OrderServicesWS.ShippingAddress testobj3 = new OrderServicesWS.ShippingAddress ();
  
    }

 
}