/********************************************************************************
Class Name : MTRUMSAPIClass
@description : This is an API class for UserManagement Service
********************************************************************************/
public class MTRUMSAPIClass{
      
     /********************************************************************************
   @description : Defines the request structure of the service
   *********************************************************************************/ 
    public class UserDetailsWrapper{
       
        public string sapContactID;
        public String firstName;
        public String lastName;
        public String email;
        public boolean isGLIAdminContact;
        public string s2EContactRole;
         /** @description sap account number */
        public string sAPAccountNumber{get;set;}
    }//end of UserDetailsWrapper    

}