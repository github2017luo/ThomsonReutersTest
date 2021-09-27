public class ESC_JSON2ApexSubscriptionPostBack {

   public cls_BOOMIHeader BOOMIHeader;
    public List<cls_caseResponse> caseResponse;
    public class cls_BOOMIHeader {
        public String applicationId;    
        public String companyId;    
    }
    public class cls_caseResponse {
        public String referenceNumber;  
        public String accountNumber;    
        public List<cls_item> item;
    }
    public class cls_item {
        public String actionCode;  
        public String assetId;  
        public String effectiveDate;    
        public String contractNumber;   
        public String entitlementStatus;  
        public String entitlementStatusMessage;
        public String billingStatus;  
        public String billingStatusMessage;
        public String entitlementCompletionDate; 
    }
    
    public static ESC_JSON2ApexSubscriptionPostBack parse(String json) {
        return (ESC_JSON2ApexSubscriptionPostBack) System.JSON.deserialize(json, ESC_JSON2ApexSubscriptionPostBack.class);
    }
    
    static testMethod void testParse() {
        String json=        '  {'+
        '                "BOOMIHeader": {'+
        '                                "applicationId": "ESCH",'+
        '                                "companyId": "S100"'+
        '                },'+
        '                "caseResponse": ['+
        '                                {'+
        '                                                "referenceNumber": "1234",'+
        '                                                "accountNumber": "20000167812",'+
        '                                                '+
        '                                                '+
        '                                                "item": ['+
        '                                                                {'+
        '                                                                                "actionCode":" Lapse Subscription",'+
        '                                                                                "assetId": "ALI-003336",'+
        '                                                                                "effectiveDate":"2022-11-30",'+
        '                                                                                "contractNumber": "",'+
        '                                                                                "entitlementStatus": "",'+
        '                                                                                "entitlementStatusMessage": "",'+
        '                                                                                "billingStatus": "",'+
        '                                                                                "billingStatusMessage": "",'+
        '                                                                                "entitlementCompletionDate":""'+
        '                                                                                '+
        '                                                                }'+
        '                                                ]'+
        '                                }'+
        '                ]'+
        '}'+
        '';
        ESC_JSON2ApexSubscriptionPostBack obj = parse(json);
        System.assert(obj != null);
    }

}