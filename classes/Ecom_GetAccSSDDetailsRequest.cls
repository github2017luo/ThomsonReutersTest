/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                     Name                                          Description
 * 2018-11-12   Shiva Sri Arun Koralla         DLT-13160 [NSE ALL][Tech Story] Bill to Account Login service
 * 2018-11-22   Ramesh Reddy                   DLT-12983 [NSE ALL] Create Lead for Customers Not Allowed to Purchase (From Log In)
 * ==================================================================================================================================   
 */
global class Ecom_GetAccSSDDetailsRequest {
    
     public cls_GetAccSSDDetailsRequest params;
     public cls_validations validations;

    public class cls_GetAccSSDDetailsRequest {
        public String AccountNumber;    
        public String zipCode;
        public String storeName;
    }
     public class cls_validations {
        public Boolean creditCheck;
        public Boolean activeOnlineSubsCheck;
        public Boolean inactiveOnlineSubsCheck;      
     }
     
     public Ecom_GetAccSSDDetailsRequest(cls_GetAccSSDDetailsRequest params,cls_validations validations) {
         this.params = params;
         this.validations = validations;
     } 
}