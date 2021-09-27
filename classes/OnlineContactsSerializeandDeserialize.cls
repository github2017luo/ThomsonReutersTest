global class OnlineContactsSerializeandDeserialize {
    //LOC-7114-Start Zakeer
    //Latam JSON serialization class to construct a request

    global class GetOCBySAPAccountRequest {
        public ESIHeader ESIHeader{get; set;}
        public ESIAccount account {get; set;}
        public string assetNumber {get; set;}
        
        public GetOCBySAPAccountRequest() {
           
            ESIHeader = new ESIHeader();
            account = new ESIAccount ();
            
        }
    }
        
        public class ESIHeader {
            public string applicationId {get;set;}  
            public ESIHeader() {
                applicationId = '';
            }          
        }
        public class ESIAccount {
        public string accountNumber {get; set;}
            public ESIAccount() {
                accountNumber = '';
            }
        } 
       
    //Latam JSON deserialization class t construct a response
    public class onlineContactResponse {
       
        public List<onlineContact> onlineContact {get; set;}
        
        public onlineContactResponse() {
            onlineContact = new List<onlineContact>();
        }
    }
    public class onlineContact {
        public string contactNumber {get; set;}
      //  public string userStatus {get; set;}
        public string onlineContactType {get; set;}
        public Address Address{get;set;} 
        public Account account{get; set;}
        public list<entitlements> entitlements {get; set;}
        public string contactType {get; set;} //Added by Poorva for tax proff
        public string status{get; set;} //Added by Poorva for tax proff 
          
        
    }
    public class Address {
        public string contactId {get; set;}
        public string firstName {get; set;}
        public string lastName {get; set;}
        public string middleName {get; set;}
        public string emailAddress {get; set;}
        public string phone {get; set;}
    }
    public class entitlements{
        public string applicationId {get; set;}
     //   public boolean status{get; set;}
        public string appUserGuid{get; set;}
        public string accessStartDate{get; set;}
        public string accessEndDate{get; set;}
        public list<subscriptions> subscriptions{get; set;}
       
    }
    public class subscriptions{
        public list<material> material{get; set;}
         public list<assets> assets{get; set;} //Added By Poorva Tax prof
    }
    public class material{
        public string materialNumber{get; set;}
        public string materialDescription{get; set;}
    }
    //LOC-7114-End Zakeer
    
    //Tax Proffression Poorva Code
      global class GetOCBySAPAccountRequest_Tax {
        public BOOMIHeader BOOMIHeader{get; set;}
        public account account {get; set;}
        
        public GetOCBySAPAccountRequest_Tax() {
           
            BOOMIHeader = new BOOMIHeader();
            account = new account();        
        }
    }
    global class GetOCBySAPAccountRequest_Tax_Asset {
        public BOOMIHeader BOOMIHeader{get; set;}
        public List<String> assetNumber {get; set;}
        
        public GetOCBySAPAccountRequest_Tax_Asset() {
           
            BOOMIHeader = new BOOMIHeader();
            assetNumber  = new List<String>();            
        }
    }
    
        
        public class BOOMIHeader{
            public string applicationId {get;set;}  
            public BOOMIHeader() {
                applicationId = '';
            }          
        }
        // deserialization Components 
        
        public class assets{
            public string assetId {get;set;} 
        }
       
    
    
    //Tax professional Poorva Code ends here
    
    
    global class OnlineContactsRequest {
        public GetOnlineContactsByAccountRequest GetOnlineContactsByAccountRequest {get; set;}
        
        public OnlineContactsRequest() {
            GetOnlineContactsByAccountRequest = new GetOnlineContactsByAccountRequest();
        }
    }
    global class GetOnlineContactsByAccountRequest {
        public context context {get; set;}
        public account account {get; set;}
        public filter filter {get; set;}
        
        public GetOnlineContactsByAccountRequest() {
            context  = new context ();
            account = new account ();
            filter = new filter();
        }
     }   
    public class context {
        public string companyId {get;set;}
        public string productId {get; set;}
        public string configGroup {get; set;}  
        
        public context() {
            companyId = '';
            productId = '';
            configGroup = '';
        }          
    }
    public class account {
        public string accountNumber {get; set;}
        
        public account() {
            accountNumber = '';
        }
    }
    public class filter {
        public List<string> applicationIdFilters {get; set;}
        public Boolean checkInactivatable {get; set;}
        public Boolean checkEntitlementDetails {get; set;}
        
        public filter() {
            applicationIdFilters = new List<string>();
            checkInactivatable  = False;    
            checkEntitlementDetails = False;
        }
    }
    
    // class to deserialize the Json response
    public class OnlineContactsResponse {
        public List<onlineContacts> onlineContacts {get; set;}
        
        public OnlineContactsResponse() {
            onlineContacts = new List<onlineContacts>();
        }
    }
    public class onlineContacts {
        public string contactId {get; set;}
        public string firstName {get; set;}
        public string lastName {get; set;}
        public string email {get; set;}
        public string phone {get; set;}
        public string contactType {get; set;}
        public string status {get; set;}
        public Date createDate {get; set;}
        public string companyId {get; set;}
        public string sourceId {get; set;}
        public string account {get; set;}        
        public List<entitlements> entitlements {get; set;}
        public string position {get; set;}
        public string initials {get; set;}
        public string unit {get; set;}
        public string activity {get; set;}
        public string onlineContactType {get; set;}
        public string onlineContactTypeDescription {get; set;}
        public string summerAssociateYear {get; set;}
        public string warningFlag {get; set;}
        public string allowContactEmails {get; set;}       
        
        public onlineContacts(){
            contactId = '';
            firstName = '';
            lastName = '';
            email = '';
            phone  = '';
            contactType ='';
            status = '';
            createDate = null;
            companyId ='';
            sourceId ='';
            account ='';
            entitlements  = new list<entitlements>();
            position = '';
            initials ='';
            unit ='';
            activity ='';
            onlineContactType ='';
            onlineContactTypeDescription ='';
            summerAssociateYear ='';
            warningFlag ='';
            allowContactEmails ='';
        } 
    }
   /* public class entitlements {
        public string applicationId {get; set;}
        public boolean inactivatable {get; set;}
        public string logonName {get; set;}
        public string status {get; set;}
        public string appUserId {get; set;}
        public string appUserPassword {get; set;}
        public string appUserRefId {get; set;}
        public string accessStartDate {get; set;}
        public string accessEndDate {get; set;}
        public Date lastLogonDate {get; set;}
        public boolean registered {get; set;}
        public boolean transparent {get; set;}
        public string authenticationSystem {get; set;}
        public string authId {get; set;}
        public string appUserRefIdNickName {get; set;}
        public string appUserRefIdPrimary {get; set;}
        public string authFirstName {get; set;}
        public string authLastName {get; set;}
        public string authEmail {get; set;}
        
        public entitlements() {
            applicationId ='';
            inactivatable =false;
            logonName  = '';
            status ='';
            appUserId ='';
            appUserPassword ='';
            appUserRefId ='';
            accessStartDate =null;
            accessEndDate =null;
            lastLogonDate = null;
            registered  = false;
            transparent =false;
            authenticationSystem = '';
            authId ='';
            appUserRefIdNickName ='';
            appUserRefIdPrimary ='';
            authFirstName ='';
            authLastName ='';
            authEmail ='';
        }
        
    }  */
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