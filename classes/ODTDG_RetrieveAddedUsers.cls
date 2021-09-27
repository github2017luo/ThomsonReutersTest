/********************************************************************************************************
*  @description ODTDG_RetrieveAddedUsers : to Retrieve already added users / Invited users in Trial
*********************************************************************************************************/
@RestResource(urlMapping='/ODTDGRetrieveAddedUsers/*')
global with sharing class ODTDG_RetrieveAddedUsers {
   
/********************************************************************************************************
*  @description ValidatecustomersData: This is the main method to validate the customer data with post data 
* @return ODTDG_CustomerData as a service response we will share the customer data along with error messages if any 
*********************************************************************************************************/ 
    @HTTPGet
    global static List<ODTDG_RetrieveAddedUsers.UserDetails> retrieveUsersData(){

            List<UserDetails> userDetails = new List<UserDetails>();
            
            System.debug(LoggingLevel.INFO,'ReqBody...............'+RestContext.request.params.tostring());
            
           // Map<String, Object> m =  (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.tostring());
            RestRequest newRequest = RestContext.request;
            Map<String,String> m = newRequest.params;
            
            String onePassId=m.get('onePassId');
            //String productCode=m.get('productCode');

            System.debug(LoggingLevel.INFO,'onePassId...............'+onePassId);
            //System.debug(LoggingLevel.INFO,'productCode...............'+productCode);

/*
        if(Schema.sObjectType.Trial_Product__c.isQueryable()){
            List<ID> trialIds=new List<ID>();
            List<Trial_product__c> products = [SELECT Id, Trial__c, Material_Number__c, Product_Name__c 
                                                FROM Trial_Contact__c 
                                                WHERE Product_Name__r.ProductCode=: productCode];
            
            for(Trial_Product__c p:products){
                trialIds.add(products.Trial__c);
            }
        }

*/

            
        if(Schema.sObjectType.Trial_Contact__c.isQueryable()){
            Trial_Contact__c cm = ODTDG_Helper.getTrialContact(onePassId);
            ID trialId = cm.Trials__c;
            //Boolean isPrimary=contact.Primary__c;

            List<Trial_Contact__c> contacts = [SELECT Id, Trials__c, Name, First_Name__c, Last_Name__c, Email__c, One_Pass_ID__c, Primary__c, lead__c, Status__c 
                                                FROM Trial_Contact__c 
                                                WHERE trials__c=:trialId and Primary__c=false and Id!= :cm.id];

        

            UserDetails user1 = new UserDetails();
            user1.isPrimary=cm.Primary__c;
            user1.emailAddress=cm.Email__c;
            user1.firstName=cm.First_Name__c;
            user1.lastName=cm.Last_Name__c;
            user1.userAuthId=cm.One_Pass_ID__c;
            user1.status=cm.Status__c;
            userDetails.add(user1);

            for(Trial_Contact__c c:contacts){
                UserDetails user = new UserDetails();
                user.isPrimary=c.Primary__c;
                user.emailAddress=c.Email__c;
                user.firstName=c.First_Name__c;
                user.lastName=c.Last_Name__c;
                user.userAuthId=c.One_Pass_ID__c;
                user.status=c.Status__c;
                userDetails.add(user);
            }

        }
        return userDetails;

    }


/********************************************************************************************************
*  @description CustomerDUserDetailsetails is the constructor for users details  
*********************************************************************************************************/ 
    global class UserDetails {
        public Boolean isPrimary;
        public String emailAddress;
        public String firstName;
        public String lastName;
        public String userAuthId;
        public String status;

    } 

}