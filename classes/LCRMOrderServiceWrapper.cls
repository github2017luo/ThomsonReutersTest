/**
 * Wrapper Class generated using JSON payloads and supports the method to deserialize JSON response for LCRM_GetOrder Service.
 *
 * @author  Seema Nagdev
 * @version 2017-11-01
 */


public class LCRMOrderServiceWrapper {
    
    /** OrderService Request Wrapper Starts**/
     public class OrderReqWrapper {
        public EsiHeader esiHeader{get;set;}
        public String sourceSystem{get;set;}
        public String targetSystem{get;set;}
        public String business{get;set;}
        public String orderNumber{get;set;}
        public String productId{get;set;}
        public String deliveryNumber{get;set;}
        public String poNumber{get;set;}
        public String fromDate{get;set;}
        public String toDate{get;set;}
        public List<OrderTypes> orderTypes{get;set;}
        public List<Accounts> accounts{get;set;}
        public UserDetails userDetails{get;set;}
        public String language{get;set;}
        public List<ExtensibleAttributes> extensibleAttributes{get;set;}
        public OrderReqWrapper(){
            esiHeader = new EsiHeader() ;
            sourceSystem ='';
            targetSystem ='';
            business='';
            orderNumber='';
            productId='';
            deliveryNumber='';
            poNumber='';
            fromDate='';
            toDate='';
            orderTypes = new List<OrderTypes>();
            accounts = new List<Accounts>();
            userDetails = new UserDetails();
            language = '';
            extensibleAttributes = new List<ExtensibleAttributes>();
        }
    }
    
    public class EsiHeader {
        public String applicationId{get;set;}
        public String transactionId{get;set;}
        public String messageId{get;set;}
        public String messageHistory{get;set;}
        public String tracingId{get;set;}
        public String timeStamp{get;set;}
        public String instanceId{get;set;}
        public String companyId{get;set;}
        public String configGroup{get;set;}
        public String payloadVersion{get;set;}
        public String postBackURL{get;set;}
        public List<ExtensibleAttributes> extensibleAttributes{get;set;}
        
        public EsiHeader(){
            applicationId='';
            transactionId='';
            messageId='';
            messageHistory='';
            tracingId='';
            timeStamp='';
            instanceId='';
            companyId='';
            configGroup='';
            payloadVersion='';
            postBackURL='';
            extensibleAttributes = new List<ExtensibleAttributes>();
        }
    }
    
    public class ExtensibleAttributes {
        public String systemIdentifier{get;set;}
        public String key{get;set;}
        public String value{get;set;}
                
        public ExtensibleAttributes(){
            systemIdentifier= '';
            key='';
            value='';
        }
    }
    
    public class OrderTypes {
        public String orderType{get;set;}
        
        public OrderTypes(){
            orderType = '';    
        }
    }
        
    public class Accounts {
        public String accountNumber{get;set;}
        public String companyId{get;set;}
        public String industryCode{get;set;}
        public String accountType{get;set;}
        
        public Accounts(){
            accountNumber = '';
            companyId = '';
            industryCode='';
            accountType='';
         }
       
    }

    
    public class UserDetails {
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String middleName{get;set;}
        public String phone{get;set;}
        public String extension{get;set;}
        public String fax{get;set;}
        public String emailAddress{get;set;}
        public List<ExtensibleAttributes> extensibleAttributes{get;set;}
        public String locationAccount{get;set;}
        public String contactNumber{get;set;}
        public Integer contactType{get;set;}
        public String userType{get;set;}
        public String userId{get;set;}
        public String secondaryUUID{get;set;}
        public List<ExtensibleAttributes> settings{get;set;}
        
        public UserDetails(){
            firstName='';
            lastName='';
            middleName='';
            phone='';
            extension='';
            fax='';
            emailAddress='';
            extensibleAttributes = new List<ExtensibleAttributes>();
            locationAccount='';
            contactNumber='';
            contactType=null;
            userType='';
            userId='';
            secondaryUUID='';
            settings= new List<ExtensibleAttributes>();
        }
    }
     /** OrderService Request Wrapper Ends**/
    
     /** OrderService Response Wrapper Starts**/
    public class OrdResponseWrapper {
        public OrderList orderList{get; set;}
        
        public OrdResponseWrapper(){
            orderList = new OrderList();
        }
    }
    
    public class OrderList {
        public List<OrderItems> orderItems{get; set;}
        
        public OrderList(){
            orderItems = new List<OrderItems>();
        }
    }
    
    public class OrderItems {
        public String OrderNumber{get; set;}
        public String sourceOrTargetReferenceNumber{get; set;}
        public String orderType{get; set;}
        public String purchaseOrderNumber{get; set;}
        public String orderCurrency{get; set;}
        public List<OrderAddress> orderAddress{get; set;}
        public String applyDate{get; set;}
        public ShippingDetails shippingDetails{get; set;}
        public OrderRepresentative orderRepresentative{get; set;}
        public StatusDetail statusDetail{get; set;}
        public String orderDescription{get; set;}
        public String orderedBy{get; set;}
        public String revenueChannel{get; set;}
        public String orderAmount{get; set;}
        public String linePoNumber{get; set;}
        public String taxAmount{get; set;}
        public String scheduleLineDate{get; set;}
        public DeliveryDetails deliveryDetails{get; set;}
        public String netAmount{get; set;}
        
        public OrderItems(){
            OrderNumber = '';
            sourceOrTargetReferenceNumber = '';
            orderType = '';
            purchaseOrderNumber = '';
            orderCurrency = '';
            orderAddress = new List<OrderAddress>();
            applyDate = '';
            shippingDetails = new ShippingDetails();
            orderRepresentative = new OrderRepresentative();
            statusDetail = new StatusDetail();
            orderDescription = '';
            orderedBy = '';
            revenueChannel = '';
            orderAmount = '';
            linePoNumber = '';
            taxAmount = '';
            scheduleLineDate = '';
            deliveryDetails = new DeliveryDetails();
            netAmount = '';
        }
    }

    
    public class OrderRepresentative {
        public String representativeNumber{get; set;}
        public String representativeName{get; set;}
        
        public OrderRepresentative(){
             representativeNumber = '';
             representativeName = '';
        }
    }

    public class ShippingDetails {
        public Double shippingAmount{get; set;}
        public Account_Z account{get; set;}
        
        public ShippingDetails(){
            Double shippingAmount = null;
            account = new Account_Z();
        }
    }

    public class Account_Z {
        public String accountNumber{get; set;}
        
        public Account_Z(){
            accountNumber = '';
      }
    }

    public class StatusDetail {
        public String statusDescription{get; set;}
        
        public StatusDetail(){
           statusDescription = ''; 
        }
    }

    public class DeliveryDetails {
        public String deliveryNumber{get; set;}
        public String deliveryCompany{get; set;}
        public String shippingMethod{get; set;}
        public String shippingDate{get; set;}
        
        public DeliveryDetails(){
            deliveryNumber = '';
            deliveryCompany = '';
            shippingMethod = '';
            shippingDate = '';
        }
    }

    public class OrderAddress {
        public Account account{get; set;}
        
        public OrderAddress(){
            account = new Account();
        }
    }
    
    public class Account {
        public String applyDate{get; set;}
        
        public Account(){
            applyDate='';
        }
    }
    /** OrderService Response Wrapper Ends**/
    
     /**Wrapper Used for displaying on VF**/
    public class OrderInfo{
        //public Date StrOrderDate {get; set;}
        public String OrderDate {get; set;}
        public String OrderType {get; set;}
        public String OrderNo   {get; set;}
        public String MaterialDesc {get; set;}
        public String purchaserName {get; set;}
        public String netValue {get; set;}
        public String submittingRep {get; set;}
        public String revenueChannel {get; set;}
        public String poNo {get; set;}
        public String ShipDate {get; set;}
        public String accSAPNo {get; set;}
        public String DeliveryNum {get; set;}
        
        public OrderInfo(OrderItems oOrd){
            System.debug('start' +oOrd);
            //OrderDate = formatDate(Date.valueof(oOrd.applyDate));
            OrderDate = formatDate(oOrd.applyDate);
            OrderType = oOrd.orderType;
            OrderNo  =  oOrd.OrderNumber;
            purchaserName = oOrd.orderedBy;  
            netValue = oOrd.netAmount;  
            if(oOrd.orderRepresentative!=null){
                submittingRep = oOrd.orderRepresentative.representativeName; 
            }
            revenueChannel = oOrd.revenueChannel;
            poNo = oOrd.linePoNumber; 
            if(oOrd.deliveryDetails!=null){
            //ShipDate =formatDate(Date.valueOf(oOrd.deliveryDetails.shippingDate));
            ShipDate =formatDate(oOrd.deliveryDetails.shippingDate);
            DeliveryNum = oOrd.deliveryDetails.DeliveryNumber;
            }
            MaterialDesc = oOrd.orderDescription;
            if(oOrd.shippingDetails!=null){
                accSAPNo = oOrd.shippingDetails.account.accountNumber;
            }
        }
       
    }
    /** End of display Wrapper **/
    
 /*-------------------------------------------------------------------------------    
        Method to deserialize the response
    --------------------------------------------------------------------------------*/
    public static List<OrderInfo> getMatchedValues(String jsonResponse){
        System.debug('Inside matchedvalues');
        List<OrderInfo> ordItemlst = new List<OrderInfo>();
        OrdResponseWrapper ordResWrap = new OrdResponseWrapper();
        LCRMOrderServiceWrapper.OrderItems resOItem = new LCRMOrderServiceWrapper.OrderItems();
        try{
            OrdResWrap = (OrdResponseWrapper)System.JSON.deserialize(jsonResponse,OrdResponseWrapper.class);
            if(OrdResWrap.orderList != null){
               System.debug('OrdResWrap.orderList.orderItems-->'+OrdResWrap.orderList.orderItems.size());
                for(OrderItems oitem:OrdResWrap.orderList.orderItems){
                    ordItemlst.add(new OrderInfo(oitem));
                }
            }  
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+e.getMessage()));
        }
        return ordItemlst;
    }
      /*-------------------------------------------------------------------------------    
        Method to set the Date format to display on VF
    --------------------------------------------------------------------------------*/    
    
    public static String formatDate(String d) {
        String[] formateddate = d.split('-');
        System.debug('formateddate'+formateddate  );
        //return d.month() + '/' + d.day() + '/' + d.year();   
        return  formateddate[1] + '/' +formateddate[2]+'/'+formateddate[0];
    }
   
}