global class CreditCheckSerializeandDeserializeRes {
global class SetCCBySAPAccountResponse {
    public BOOMIHeader BOOMIHeader;
    public CreditCheckResponse creditCheckResponse;
    }
 public class BOOMIHeader {
        public String applicationId {get;set;}
        public String transactionId {get;set;}
        public String messageId {get;set;}
        public String messageHistory {get;set;}
        public String tracingId {get;set;}
        public String timeStamp {get;set;}
        public String instanceId {get;set;}
        public String companyId {get;set;}
        public String configGroup {get;set;}
        public String payloadVersion {get;set;}
        public String postBackURL {get;set;}
        public String profileId {get;set;}
       //public CreditCheckResponse creditCheckResponse = new CreditCheckResponse ();
        public BOOMIHeader() {
        applicationId ='';
        transactionId ='';
        messageId ='';
        messageHistory ='';
        tracingId ='';
        timeStamp ='';
        instanceId ='';
        companyId ='';
        configGroup ='';
        payloadVersion ='';
        postBackURL ='';
        profileId ='';
        //creditCheckResponse = new CreditCheckResponse();
    }
    }
        public class CreditCheckResponse {
        public String segment {get;set;}
        public String creditStatus {get;set;}
        public String checkingDescription {get;set;}
        public String accountBlocked {get;set;}
        public String requireAttention {get;set;}
        public String endDate {get;set;}
        public String accountNumber {get;set;}
        public Rating rating {get;set;}
        public Rating riskClass {get;set;}
        public CreditLimit creditLimit = new CreditLimit ();
        public CreditExposure creditExposure = new CreditExposure ();
        public CreditCheckResponse() {
        segment ='';
        creditStatus ='';
        checkingDescription ='';
        accountBlocked ='';
        requireAttention ='';
        endDate ='';
        accountNumber ='';
        rating = new Rating();
        riskClass = new Rating();
        creditLimit = new CreditLimit();
        creditExposure = new CreditExposure();
    }
    }
   // public BOOMIHeader BOOMIHeader;
    

    public class Rating {
        public String code {get;set;}
        public String startDate {get;set;}
        public String endDate {get;set;}
        public Rating() {
        code ='';
        startDate ='';
        endDate ='';
    }
    }

    public class CreditLimit {
        public String currencyCode {get;set;}
        public String amount {get;set;}
        public String startDate {get;set;}
        public String endDate {get;set;}
    
        public CreditLimit() {
        currencyCode ='';
        amount ='';
        startDate ='';
        endDate ='';
    }
    }
    public class CreditExposure {
        public String currencyCode{get;set;}
        public String amount{get;set;}
        public CreditExposure() {
        currencyCode ='';
        amount ='';
    }
    }



    
   // public static CreditCheckSerializeandDeserializeRes parse(String json) {
    //    return (CreditCheckSerializeandDeserializeRes) System.JSON.deserialize(json, CreditCheckSerializeandDeserializeRes.class);
   // }
}