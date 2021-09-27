/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                     Name                                          Description
 * 2019-02-13   Shiva Sri Arun Koralla         DLT-15150 [NSE ALL][Tech Story] Salesforce service to get pricing for Materials
 * ==================================================================================================================================   
 */
global class Ecom_GetProductDetails_Request
{    
     public String storeName;
     public cls_products[] products;
     
    public class cls_products 
    {
        public String materialNumber;    
        public String subscriptionNumber;
        public String name;
    }
    
    public Ecom_GetProductDetails_Request(String storeName,cls_products[] products) {
        this.storeName = storeName;
        this.products = products;
    }  
}