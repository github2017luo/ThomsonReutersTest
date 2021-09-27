global class CreditCheckSerializeandDeserializeReq {
    public BOOMIHeader BOOMIHeader;
     public List<CreditCheckRequest> creditCheckRequest;
    public CreditCheckSerializeandDeserializeReq() {
        BOOMIHeader = new BOOMIHeader();
        creditCheckRequest = new List<CreditCheckRequest>();
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
       // public List<CreditCheckRequest> creditCheckRequest {get; set;}
        public BOOMIHeader() {
        applicationId = '';
        transactionId = '';
        messageId = '';
        messageHistory = '';
        tracingId = '';
        timeStamp = '';
        instanceId = '';
        companyId = '';
        configGroup = '';
        payloadVersion = '';
        postBackURL = '';
        profileId = '';
      //  creditCheckRequest = new List<CreditCheckRequest>();
    }
    }
    public class CreditCheckRequest {
        public List<Account> account {get; set;}
        public List<DocumentInfo> documentInfo {get; set;}
        public CreditCheckInfo creditCheckInfo {get; set;}
        public CreditCheckRequest() {
        account = new List<Account>();
        documentInfo = new List<DocumentInfo> ();
        creditCheckInfo = new creditCheckInfo();
        //account = new List<Account>();
        }
    }
   public class Account {
        public String accountNumber {get;set;}
        public String partyType {get;set;}
        public String customerSegment {get;set;}
        public Account() {
        accountNumber = '';
        partyType = '';
        customerSegment = '';
    }
    }
    public class DocumentInfo {
        public String documentNumber {get;set;}
        public List<DocItems> docItems;
        public DocumentInfo() {
        documentNumber = '';
        docItems = new List<DocItems>();
    }
    }
    public class DocItems {
        public String itemNumber {get;set;}
    
    public DocItems() {
        itemNumber = '';
    }
 }
    public class CreditCheckInfo {
        public String currencyCode {get;set;}
        public String amount {get;set;}
        public String retrievalPermission {get;set;}
        public String creditRuleCode {get;set;}
        public String severityCode {get;set;}
        public List<CheckingSchedule> checkingSchedule {get;set;}
        public List<CheckingSchedule> groupCheckingSchedule {get;set;}
        public CreditCheckInfo() {
        currencyCode = '';
        amount = '';
        retrievalPermission = '';
        creditRuleCode = '';
        severityCode = '';
        checkingSchedule = new  List<CheckingSchedule> ();
        groupCheckingSchedule =new List<CheckingSchedule> ();
    }
    }
    public class CheckingSchedule {
        public String valuationDate {get;set;}
        public String segment {get;set;}
        public String currencyCode {get;set;}
        public String amount {get;set;}
        public CheckingSchedule() {
        valuationDate = '';
        segment = '';
        currencyCode = '';
        amount = '';
    }
    } 
    



   // public static CreditCheckSerializeandDeserializeReq parse(String json) {
    //    return (CreditCheckSerializeandDeserializeReq) System.JSON.deserialize(json, CreditCheckSerializeandDeserializeReq.class);
   // }
}