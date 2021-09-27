public without sharing class ESC_CaseFormExtensionRequestWrapper{
        
        public ESC_CaseFormExtensionRequestWrapper(){}
        public BOOMIHeader BOOMIHeader;
        public InvoiceDetail InvoiceDetail;

    public class BOOMIHeader {
        public String applicationId;    //
        public String transactionId;    //
        public String messageId;    //
        public String messageHistory;   //
        public String tracingId;    //
        public String timeStamp;    //2008-09-29T01:49:45
        public String instanceId;   //
        public String companyId;    //
        public String configGroup;  //
        public String payloadVersion;   //
        public String postBackURL;  //
        public String profileId;    //
        public extensibleAttributes[] extensibleAttributes;
    }
    public class extensibleAttributes {
        public String systemIdentifier; //
        public String key;  //
        public String value;    //
        public String description;  //
    }
    public class InvoiceDetail {
        public String documentName; //
        public boolean openItemsRequested;
        public boolean clearedItemsRequested;
        public boolean additionalTextRequested;
        public String documentType; //
        public String documentNumber;   //
        public String writeOffReferenceNumber;  //
        public String writeOffreason;   //
        public String applicationArea;  //
        public String currency_x; //
        public String sort_x; //
        public String isPendingStatus;  //
        public String status;   //
        public account account;
        public String accountFilter;    //
        public String searchFilter; //
        public documentDetails[] documentDetails;
        public statusDetails[] statusDetails;
    }
    public class account {
        public String accountNumber;    //2000000418
        public String accountName;  //
        public String companyId;    //
        public String companyName;  //
        public String accountType;  //
        public String preferredLanguage;    //
        public String ultimateParentAccountNumber;  //
        public String accountClassification;    //
        public String industry; //
        public String businessUnit; //
        public String businessChannel;  //
        public String parentAccountNumber;  //
        public String ownerId;  //
        public String ownerName;    //
        public String locationCountry;  //
        public String industryCode; //
        public String isInsight;    //
        public boolean isPrimary;
        public boolean isActive;
        public String action;   //
        public String companySize;  //
        public String sourceOrTargetReferenceNumber;    //
        public String TerritoryNumber;  //
        public String locationAccountNumber;    //
        public boolean isAdminContactsOnly;
        public extensibleAttributes[] extensibleAttributes;
        public String accountSSDId; //
        public String accountSSDName;   //
        public String accountSSDNumber; //
        public String language; //
        public String currency_x; //
        public String legalStatus;  //
        public String salesOrg; //
        public String distributionChannel;  //
        public String companyCode;  //
        public String division; //
        public String externalAccountId;    //
        public String accountCustomerAddressID; //
        public String accountStatus;    //
    }
    public class documentDetails {
        public String documentType; //
        public String documentNumber;   //79000000140
        public String writeOffreason;   //WB
        public String contractAccount;  //
        public String amount;   //100
        public String taxAmount;
        public String lineNumber;
        public String reasonCode;
        public String currency_x;
    }
    public class statusDetails {
        public String statusCode;   //
        public String statusDescription;    //
        public String statusMssage; //
    }
}