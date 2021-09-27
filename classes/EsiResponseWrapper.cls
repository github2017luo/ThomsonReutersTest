/*============================================================================================
    Name                : EsiResponseWrapper
    Description         : This class is developed as part of CXD-ODT project and it is serving as helper class for contactsListCon class  
    Created Date        : 2/12/2018 
    Author              : TCS CXD ODT team
    Modification History: Optimizing the code by Harshitha
==============================================================================================*/
global class EsiResponseWrapper{
      public onlineContact[] onlineContact;
      
   public class onlineContact {
        public String contactNumber;    
        public address address;
        public account account;
        public String sourceId; 
        public String endDate;  
        public entitlements[] entitlements;
        public String onlineContactType;    
        public boolean allowContactEmails;
        
        public onlineContact(){}
        
    }
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
        public boolean registered;
        public boolean detailsIncomplete;
        public String authFirstName;     
        public String authLastName;  
        public String authEmail;     
        public String authId;    
        public String logonName;     
        public boolean appUserRefIdPrimary;
        public String appUserRefIdNickName;  
        public String lastPasswordChangeDate;    
        public String authenticationSystem;  
    }
    }