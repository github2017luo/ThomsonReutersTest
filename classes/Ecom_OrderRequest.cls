/*
* CHANGE HISTORY
* ==================================================================================================================================
* 2018-08-20   Shiva Sri Arun        DLT-11546 [TECH STORY- SFDC] - Update calls as per new UI for checkout
* ==================================================================================================================================   
*/
global class Ecom_OrderRequest{
    
    public cls_storeOrder storeOrder;
    public cls_References references;
    public cls_ActionParams actionParams;
    
    public class cls_storeOrder {
        public String storeName;    //Small Law
        public Decimal totalPrice;
        public Decimal planPrice;
        public String plan;
        public String planId;
        public boolean isAbandonedLead;
        public boolean isExistingCustomer;
        public String promoCode;
        public String promotionId;
        public Integer numberOfAttorneys;
        public String jurisdiction;
        public String purchaseOrderNum; 
        public boolean isJourneyEnded;
        public boolean isHouseDetaineesOrg;
        public cls_customerDetails customerDetails;
        public cls_selectedProducts[] selectedProducts;
        public cls_additionalInfo additionalInfo;
       
    }
    
    public class cls_additionalInfo {
       public String campaignId;
       public string reasonToEndJourney;
       public Boolean isGetQuoteClicked;   
       public String trackingCodeCID; 
       public String paymentDetails;
       public Boolean isBillToAccount;
       public Boolean isEbillingChecked; 
       public Boolean forwardCart;
       public String activityDesc;
       public String existSSDAccNumber;
       public String existCreditRiskCategory;
       public String buildPlanDetails;
       public String leadDescription;
    }
    
    public class cls_customerDetails {
        public String firstName;    //Jessica
        public String lastName; //Page
        public String organizationName; //Acelaw Ltd
        public String businessEmail;    //jessica.page@123.com
        public String phoneNumber;  //
        public String phoneExtension;
        public Boolean isPhysicalSameAsBillingAddress = true;
        public cls_address address;
        public cls_recipients  recipients;
        public cls_address physicalAddress;
      
    }
    public class cls_address {
        public String addressLine1; //610 Opperman Dr
        public String city; //Eagan
        public String state;    //MN
        public String zipCode;  //55123
        public String country;  //US
        public String county;
    }
    public class cls_recipients {
        public String mail1; 
        public String mail2; 
        public String mail3;   
        public String mail4;  
        public String mail5;  
    }
    public class cls_selectedProducts {
        public String productId;    //01t30000003ilMI
        public Integer quantity;    //2
        public String contractTerm; //3 Years
        public String combinationId; //DLT-15568
        public Integer assignedUsers;
        public String isRecommendedProduct;
        public String cType;
    }
    
     public class cls_ActionParams {
        public String orderAction;
        public String leadAction;
        public String accountAction;
        public String contactAction;
        public String opportunityAction;
        public String proposalAction;
        public Boolean generatePaymentURL;
        public String cartAction;
        public Boolean repriceCart;
        public Boolean placeOrder;
        
          
    }
    
    public class cls_References {
        public String orderId;
        public String leadId;
        public String accountId;
        public String accountSSDId;
        public String contactId;
        public String opportunityId;
        public String proposalId;
        public String cartId;
        public String orderNumber;
        public String proposalNumber;
        public Boolean repricePending;
        
    } 

    public static Ecom_OrderRequest parse(String json){
        return (Ecom_OrderRequest) System.JSON.deserialize(json, Ecom_OrderRequest.class);
    }

    public static Ecom_OrderRequest testParse() {
        String json=        '{'+
        '  "storeOrder": {'+
        '    "storeName": "Small Law",'+
            ' "isAbandonedLead":true,'+
            ' "purchaseOrderNum":"245432",'+
            ' "jurisdiction":"Ohio",'+
            ' "promoCode":"BAR2018",'+
            ' "isJourneyEnded":false,'+
            ' "isExistingCustomer":false,'+
            '    "additionalInfo": {'+
            '        "trackingCodeCID": "610000",'+
            '        "isGetQuoteClicked": true,'+
            '        "forwardCart": true, '+
            '        "buildPlanDetails": "plan details", '+
            '        "existSSDAccNumber": "19848032199", '+
            '        "existCreditRiskCategory": "No risk customer", '+
            '        "leadDescription": "Plan:Premium Profile; # of seats:22; State:Alaska; Add On:null; Customer Forwarded Cart to others:false See Activity for details:false, Promo Code:null", '+
            '        "activityDesc": "Cart Forwarded",'+
            '        "isEbillingChecked": true,'+
            '        "isBillToAccount" : true'+
            '    },'+  
        '    "customerDetails": {'+
        '      "firstName": "Jessica",'+
        '      "lastName": "Page",'+
        '      "organizationName": "Acelaw Ltd",'+
        '      "businessEmail": "jessica.page@acelaw.com",'+
        '      "phoneNumber": "3036966478",'+
            '      "isPhysicalSameAsBillingAddress" : true,'+
            '      "phoneExtension": "303",'+ 
        '      "address": {'+
        '        "addressLine1": "610 Opperman Dr",'+
        '        "city": "Eagan",'+
            '        "state": "New York",'+
            '        "zipCode": "55123",'+
            '        "country": "United States"'+
            '      },'+
            '      "recipients": {'+
            '        "mail1": "testemail1@thomsonreuters.com",'+
            '        "mail2": "testemail2@thomsonreuters.com",'+
            '        "mail3": "testemail3@thomsonreuters.com",'+
            '        "mail4": "testemail4@thomsonreuters.com",'+
            '        "mail5": "testemail5@thomsonreuters.com"'+
            '      },'+
            '      "physicalAddress": {'+
            '        "addressLine1": "610 Opperman Dr",'+
            '        "city": "Eagan",'+
            '        "state": "New York",'+
        '        "zipCode": "55123",'+
            '        "country": "United States"'+
        '      }'+
        '    },'+
        '    "selectedProducts": ['+
        '      {'+
        '        "productId": "01t130000067SxP",'+
        '        "quantity": 2,'+
        '        "contractTerm": "3 Years",'+
        '        "assignedUsers": null'+
        '      },'+
        '      {'+
        '        "productId": "01t130000067SxV",'+
        '        "quantity": 2,'+
        '        "contractTerm": "3 Years",'+
        '        "assignedUsers": null'+
        '      }'+
        '    ]'+
        '  }'+
        '}';
        Ecom_OrderRequest obj = parse(json);
        return obj;
    }
    
    
}