public class ESC_JSON2ApexWLBandingService{
      public onlineContact[] onlineContact;
      
   public class onlineContact {
        public String contactNumber;    
        public address address;
        public account account;
        public String sourceId; 
        public String endDate;  
        public entitlements[] entitlements;
        public String onlineContactType;    
        public String onlineContactTypeDescription;
        public boolean allowContactEmails;
        
        //public onlineContact(){}
        
    }
   //public List<onlineContact> onlineContact;
   public class address {
        public String firstName;    
        public String lastName; 
    }
   public class account {
        public String accountNumber;    
        public String companyId;    
    }
   public class entitlements {
        public String applicationId;    
        public String status;   
        public String appUserGuid;   
        public String accessStartDate;   
        public String accessEndDate;   
        public String statusReason; 
        public subscriptions[] subscriptions;    
        
    }
    public class subscriptions{
        public material[] material;   
    }
    public class material {
        public String materialNumber;  
        public extensibleAttributes[] extensibleAttributes;
    }
    public class extensibleAttributes {
        public String key;    
        public String value; 
    }
    public static ESC_JSON2ApexWLBandingService parse(String json) {
        return (ESC_JSON2ApexWLBandingService) System.JSON.deserialize(json, ESC_JSON2ApexWLBandingService.class);
    }
    }