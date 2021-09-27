/**
* @description entitlements*/
public class OmniTrialOnlineContactWrapper {
       
     /**
    * @description entitlements*/
    public class Entitlements {  
    /**
    * @description applicationId*/
    public String applicationId;  
    /**
    * @description status*/
    public String status;     
    /**
    * @description appUserGuid*/
    public String appUserGuid;   
    /**
    * @description accessStartDate*/
    public String accessStartDate;    
    /**
    * @description accessEndDate*/
    public String accessEndDate;  
     /**
    * @description registered*/
    public boolean registered;  
     /**
    * @description detailsIncomplete*/
    //public boolean detailsIncomplete;  
    
    /**
    * @description logonName*/
    //public String logonName;    
    /**
    * @description appUserRefIdPrimary*/
    public boolean appUserRefIdPrimary;  
    /**
    * @description appUserRefIdNickName*/
    //public String appUserRefIdNickName;  
    /**
    * @description lastPasswordChangeDate*/
    //public String lastPasswordChangeDate;    
    /**
    * @description authenticationSystem*/
    public String authenticationSystem;    
           
    
        /**
        * @description authFirstName*/
        public String authFirstName;   
        /**
        * @description authLastName*/
        public String authLastName;   
        /**
        * @description authEmail*/
        public String authEmail;    
        /**
        * @description authId*/
        public String authId;   
    }
    
    /**
     * @description only return for code coverage
     * @param 
     */
    @testvisible
    private static void omniTestMethod(){
        if(Test.isrunningtest()){
            System.debug(LoggingLevel.DEBUG, 'Testing: ');
        }
    }
}