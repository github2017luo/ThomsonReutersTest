//This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.
global class SalesforceLicenseManagerJITHandler implements Auth.SamlJitHandler 
{
    private class JitException extends Exception{}

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) 
    {
        return null;
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) 
    {
        System.debug('## userId : ' + userId);
        System.debug('## samlSsoProviderId : ' + samlSsoProviderId);
        System.debug('## communityId : ' + communityId);
        System.debug('## portalId : ' + portalId);
        System.debug('## federationIdentifier : ' + federationIdentifier);
        System.debug('## attributes : ' + attributes);
        System.debug('## assertion : ' + assertion);
        
        // find the user using user Id
        User usr = [SELECT Id, IsActive, InFrequent_User__c, Infrequent_User_Timeout__c FROM User WHERE Id=:userId];
        
        System.debug('## usr : ' + usr);
        
        // check if user found and if the user is InFrequent User
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