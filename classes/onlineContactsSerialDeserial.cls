public class onlineContactsSerialDeserial{
    public class OnlineContact {
        public String contactNumber;
        public Address address;
        public Account account;
        public List<Entitlements> entitlements;
        public List<String> userStatus;
        public String onlineContactType;
        public String contactType;
        public String jobRole;
        public String userName;
        
        public OnlineContact(){
            jobRole = '';
            userName = '';
        }
    }

    public class Account {
        public String accountNumber;
    }

    public List<OnlineContact> onlineContact;

    public class Address {
        public String firstName;
        public String lastName;
        public Object middleName;
        public Object phone;
        public String emailAddress;
    }

    public class Entitlements {
        public String applicationId;
        public String status;
        public String appUserGuid;
        public String accessStartDate;
        public String accessEndDate;
        public List<Subscriptions> subscriptions;
    }
    
    public class Subscriptions {
        public List<Material> material;
        public List<Assets> assets;
        
        public Subscriptions(){
            assets = new List<assets>();
            
        }
    }
    public class Assets{
        public String assetId;
        public Assets(){
            assetId = '';
        }
    }
    public class Material {
        public String materialNumber;
        public String materialDescription;
    }
    
    //Variables for Order postback status
    
    
        public EsiHeader esiHeader;
    
        public class EsiHeader {
            public String applicationId;
        }
    
}