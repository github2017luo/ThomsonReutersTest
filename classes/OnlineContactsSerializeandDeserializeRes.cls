global class OnlineContactsSerializeandDeserializeRes {
 // class to deserialize the Json response
    public class OnlineContactResponse {
        public List<onlineContact> onlineContact {get; set;}
        public ESIHeader ESIHeader {get; set;}
        public String moreResults{get; set;}
        
        public OnlineContactResponse() {
            onlineContact = new List<onlineContact>();
            ESIHeader = new ESIHeader();
            moreResults='false';
        }
    }
    public class onlineContact {
        public string sourceId {get; set;}
        public String endDate {get; set;}
        public string contactNumber {get; set;}
        public string allowContactEmails {get; set;}  
        public string onlineContactType {get; set;}
        public string onlineContactTypeDescription {get; set;}
        public List<entitlements> entitlements {get; set;}
        public Address address {get; set;}
        public Account account {get; set;}
        
        public onlineContact(){
        
            sourceId ='';
            enddate =null;
            entitlements  = new list<entitlements>();
            contactNumber = '';        
            allowContactEmails ='';
            onlineContactType ='';
            onlineContactTypeDescription ='';            
            address  = new Address();
            account  = new Account();            
        }       
    }
    
    public class entitlements {
        
        public string statusReason {get; set;}
        public string accessStartDate {get; set;}
        public string appUserGuid {get; set;}
        public string accessEndDate {get; set;}
        public string applicationId {get; set;}
        public string status {get; set;}
        
        public entitlements() {
            applicationId ='';
            status ='';
            appUserGuid ='';           
            accessStartDate =null;
            accessEndDate =null;
            statusReason ='';
        }        
    }
    
    public class address {        
        public string firstName {get; set;}
        public string lastName {get; set;}
        public string emailAddress {get; set;}
                
        public address() {
            firstName ='';
            lastName ='';
            emailAddress ='';           
        }        
    }
    
    public class account {        
        public string companyId {get; set;}
        public string accountNumber {get; set;}      
                
        public account() {
            companyId ='';
            accountNumber ='';
        }        
    }
    public class ESIHeader {        
        public string applicationId {get; set;}
                        
        public ESIHeader() {
            applicationId ='';
        }        
    }
        
    public class NotificationResponse {
        public list<Notification> Notification {get;set;}  
        public NotificationResponse() {
            Notification = new list<Notification>();
        }  
    }
    public class Notification {
        public String StatusCode {get;set;}
        public String StatusDescription {get;set;}
        public Notification() {
            StatusCode = '';
            StatusDescription = '';
        }
    }
 }