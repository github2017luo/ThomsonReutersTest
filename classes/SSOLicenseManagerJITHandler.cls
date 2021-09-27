/*******************************************************

Class name   : SSOLicenseManagerJITHandler

Purpose      : For DPS-7686 [Creation of Registration Handler (JIT- dynamic licensing)]

Developed By : Niket Kapasi

Date         : 09-10-2019
********************************************************/

global class SSOLicenseManagerJITHandler  implements Auth.RegistrationHandler {    
    
    //Exception class to handle exceptions
     private class JitException extends Exception{}

    /**
    @Method Name :createuser

    Purpose : This method is included as a part of interface Auth.RegistrationHandler. We do not create user using this method.
     */
     global User createUser(Id portalId, Auth.UserData data){
        
        system.debug('Create:'+data);
        User usr=[select id, name,Infrequent_User__c,Infrequent_User_Timeout__c,IsActive from User where federationIdentifier= :data.identifier];
        
        system.debug('usr:'+usr);
        
        
            if(usr != null && usr.InFrequent_User__c == true)
        {
            // if user is inactive, then activate user
            if(usr.IsActive == false)
            {
                usr.IsActive = true;
                update usr;
            }
            
            // create user activation log for the user. 
            // Need to do this asynchronously as cannot modify setup and non-setup object in same transaction
            asynchUpsertUserLicenseActivationLog(usr.Id, usr.Infrequent_User_Timeout__c);
        }
        
        
        return usr;
    }
    /**
    @Method Name :updateUser

    Purpose : This method is used to dynamically activate and deactivate the user in salesforce org.
              Whenever users tries to login with their federation id then this method checks whether user is present in org or not.
              If not then it shows an customized error.

     */
    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        system.debug('Update:'+data);
        system.debug('userId:'+userId);
        system.debug('Number*** '+data.attributeMap.get('employeeNumber'));
        system.debug('DATA*** '+data);
        User usr;
        try{
        usr=[select id,IsActive,Infrequent_User__c,Infrequent_User_Timeout__c,name from User where federationIdentifier= :data.identifier 
         limit 1];
        }
        Catch(Exception e){
            throw new JitException ('Cannot find the user with Federation Id. For help, contact your salesforce crm support team on West.crmsupport@thomsonreuters.com');
        }
         
        userId=usr.id;
        System.debug('USER***'+usr);
        /**
        Below are the two purposes of the If loop:        

        1] If user is not frequent user then this loop activates the user during SSO.

        2] Once the infrequent user is activated then by help of asynchUpsertUserLicenseActivationLog method new record is 
        created in 'User_License_Activation_Log__c' object. The record created is further used to deacivate the infrequent user using
        InFrequent_User__c,Infrequent_User_Timeout__c user fields .

         */
         if(usr != null && usr.InFrequent_User__c == true)
        {
            // if user is inactive, then activate user
            if(usr.IsActive == false)
            {
                usr.IsActive = true;
                update usr;
            }
            
            // create user activation log for the user. 
            // Need to do this asynchronously as cannot modify setup and non-setup object in same transaction
            asynchUpsertUserLicenseActivationLog(usr.Id, usr.Infrequent_User_Timeout__c);
        }
    }


     @future
    public static void asynchUpsertUserLicenseActivationLog(Id usrId, decimal sessionTimeoutLengthInHours)
    {
        System.debug('## asynchUpsertUserLicenseActivationLog : ' + usrId);
        
        User_License_Activation_Log__c ulal = new User_License_Activation_Log__c();
        ulal.User__c = usrId;
        ulal.Unique_Id__c = usrId;
        ulal.Deactivation_Date__c = Datetime.now().addMinutes(Integer.valueOf(sessionTimeoutLengthInHours*60));
        ulal.Deactivate_User__c = false;
        ulal.Status__c = '';
        upsert ulal Unique_Id__c;
        
        System.debug('## ulal : ' + ulal);
    } 
}