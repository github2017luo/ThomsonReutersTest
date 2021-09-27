public class ESC_AssetSubscriptionWrapper{
    public cls_BOOMIHeader BOOMIHeader;
    public cls_case[] casedetail;
    public class cls_BOOMIHeader {
        public String applicationId;    //ESCH
        public String companyId;    //S100
    }
    public class cls_case {
        public String referenceNumber;  //1234
        public String referenceid;
        public String accountNumber;    //20000167812
        public cls_requestorInfo requestorInfo;
        public cls_contact contact;
        public cls_item[] item;
    }
    public class cls_requestorInfo {
        public String requestorNumber;  //18 digit case Owner
        public String requestorName;    //
        public String emailAddress; //
    }
    public class cls_contact {
        public cls_address address;
    }
    public class cls_address {
        public String firstName;    //SrikaraWp_350
        public String lastName; //KLFe_664
        public String emailAddress; //testcorpoc@outlook.com
    }
    public class cls_item {
        public String dateIdentifierFlag;
        public String actionCode;   //SUSPEND
        public String reasonCode;   //1234
        public String effectiveDate;    //2022-11-30
        public String endDate;  //2022-11-30
        public String assetId;  //ALI-003336
        public String poNumber;
        public String amount;   //12345
        public String contractNumber;   //103434
        public cls_onlineContacts[] onlineContacts;
    }
    public class cls_onlineContacts {
        public String firstName;    //string
        public String lastName; //string
        public String emailId;  //string
        public String contactNumber;    //
    }
    
    public static ESC_AssetSubscriptionWrapper parse(String json) {
        return (ESC_AssetSubscriptionWrapper) System.JSON.deserialize(json,ESC_AssetSubscriptionWrapper.class);
    }
    
    
    static testMethod void testESC_AssetSubscriptionWrapper() {
        String json=        '{'+
        '  "BOOMIHeader": {'+
        '    "applicationId": "ESC",'+
        '    "companyId": "S100"'+
        '  },'+
        '  "casedetail": ['+
        '    {'+
        '      "referenceNumber": "1234",'+
        '      "accountNumber": "",'+
        '      "referenceId": "1213524556",'+
        '      "requestorInfo": {'+
        '        "requestorNumber": "X999999",'+
        '        "requestorName": "",'+
        '        "emailAddress": ""'+
        '      },'+
        '      "contact": {'+
        '        "address": {'+
        '          "firstName": "SrikaraWp_350",'+
        '          "lastName": "KLFe_664",'+
        '          "emailAddress": "testcorpoc@outlook.com"'+
        '        }'+
        '      },'+
        '      "item": ['+
        '        {'+
        '          "actionCode": "Reinstate Subscription",'+
        '          "reasonCode": "Billing Pending",'+
        '          "effectiveDate": "2022-11-30",'+
        '          "endDate": "2022-11-30",'+
        '          "assetId": "SBI-9003317",'+
        '          "amount": "12345",'+
        '          "contractNumber": "103434",'+
        '          "onlineContacts": ['+
        '            {'+
        '              "firstName": "",'+
        '              "lastName": "",'+
        '              "emailId": "",'+
        '              "contactNumber": ""'+
        '            }'+
        '          ]'+
        '        }'+
        '      ]'+
        '    }'+
        '  ]'+
        '}';
        ESC_AssetSubscriptionWrapper obj = parse(json);
        //System.assert(obj != null);
    }
    
}