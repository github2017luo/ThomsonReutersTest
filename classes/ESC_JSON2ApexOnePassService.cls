public class ESC_JSON2ApexOnePassService {
    
    public class PrismUser {
        public String Guid;
        public String UserId;
        public String Password;
        public String PwdSecEffDt;
        public String PwdSecEndDt;
        public String PwdSecReasonCode;
        public String IsNewUser;
    }
    
    public class FederatedIdentity {
        public String OnePassUserName;
        public String Product;
        public String RegistrationKey;
        public String IsMigrated;
        public String IsPreferred;
        public String NickName;
        public String LastLoginTS;
        public String Email;
    }
    
    public class OnlineUser {
        public FederatedIdentity FederatedIdentity;
        public Contact Contact;
        public PrismUser PrismUser;
    }
    
    public List<OnlineUser> OnlineUser;
    
    public class Contact {
        public String AcctSapId;
        public String CompanyCode;
        public String SalesOrgCode;
        public String DistChanCode;
        public String DivisionCode;
        public String ContactSapId;
        public String MdbContactId;
        public String Domain;
        public String OnlineId;
        public String StatusId;
        public String StatusDesc;
        public String FirstName;
        public String LastName;
    }
    
    
    public static ESC_JSON2ApexOnePassService parse(String json) {
        return (ESC_JSON2ApexOnePassService) System.JSON.deserialize(json, ESC_JSON2ApexOnePassService.class);
    }
}