/**
 * @description class for SSO for CaseLines
 */
global without sharing class CaseLinesSAMLJITHandler implements Auth.SamlJitHandler {

    private class JitException extends Exception{}
    
    /**
        * @description createUser
        * @param samlSsoProviderId
        * @param communityId
        * @param portalId
        * @param federationIdentifier
        * @param attributes
        * @param assertion
        * @return user
    */
    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) 
    {
        User u = new User();
        List<User> existingUsr;
        system.debug(LoggingLevel.WARN,'attributes in createuser>>>'+attributes + federationIdentifier);
        //system.debug('UserName :'+attributes.get('User.Username'));
        if(Schema.sObjectType.User.isAccessible()){
            existingUsr = [SELECT Id,UserName,contactId FROM User Where federationIdentifier=: attributes.get('User.Email') and isActive=true and IsPortalEnabled=true and contactId!=null];
        }
        
        if(!existingUsr.isEmpty()) 
        {
            system.debug(LoggingLevel.WARN,'@@ existing user : ' + existingUsr[0]);
            u.Id = existingUsr[0].Id;
            u.UserName = existingUsr[0].UserName;
            //handleUser(false, u,attributes,federationIdentifier,true);        
        }else{ 
            handleJit(true, u, attributes);
            }
        return u;
    }
    
    private void handleJit(boolean create, User u, Map<String, String> attributes) {
        Source_System_Detail__c ssdObj;
        Account acc;
        system.debug(LoggingLevel.WARN,'Source system account number : '+ attributes.get('Source_System_Account_Number__c'));
        
        if(!attributes.containsKey('Source_System_Account_Number__c') || (attributes.containsKey('Source_System_Account_Number__c') && (string.isBlank(attributes.get('Source_System_Account_Number__c')) || attributes.get('Source_System_Account_Number__c')==null))){
            acc = CaseLines_DataUtil.getBucketAccount();
            CaseLines_DataUtil.searchContact(acc.id,u,attributes);
        }else{
            ssdObj = CaseLines_DataUtil.getSSD(attributes);
            if(ssdObj!=null  && ssdObj.Account_Name__c!=null){
                CaseLines_DataUtil.searchContact(ssdObj.Account_Name__c,u,attributes);
            }else {
                acc = CaseLines_DataUtil.getBucketAccount();
                CaseLines_DataUtil.searchContact(acc.id,u,attributes);
        
            
            }
        
        }
        
    }
    
     private static string getTimezone(string productDomain){
        List<CaseLines_TimeZone_Mapping__c> csMapping = CaseLines_TimeZone_Mapping__c.getAll().values();
        for(CaseLines_TimeZone_Mapping__c cs:csMapping){
            if(cs.ESC_ProductDomain__c.containsIgnoreCase(productDomain)){
                return cs.ESC_TimeZone__c;
            }
        
        }
        return null;
    }
    
   private static void setUserAlias(boolean create,User u,Map<string,string> attributes){
        if(create) {
            String alias = '';
            if(attributes.get('Contact.FirstName')== null || attributes.get('Contact.FirstName') =='') {
                alias = attributes.get('Contact.LastName');
            } 
            else {
                alias = attributes.get('Contact.FirstName').charAt(0) + attributes.get('Contact.LastName');
            }
            if(alias.length() > 5) {
                alias = alias.substring(0, 5);
            }
            u.Alias = alias;
        }
   }
    private static void setUserdata3(boolean create,User u,Map<string,string> attributes){

        /*if(attributes.containsKey('User.Alias') && attributes.get('User.Alias')!=null && attributes.get('User.Alias')!='') {
            u.Alias = attributes.get('User.Alias');
        } */
        
        if(attributes.containsKey('User.TimeZoneSidKey') && attributes.get('User.TimeZoneSidKey')!=null && attributes.get('User.TimeZoneSidKey')!='') {
            system.debug(LoggingLevel.WARN,'@@ TimeZoneSidKey 1' + attributes.get('User.TimeZoneSidKey'));
            u.TimeZoneSidKey = attributes.get('User.TimeZoneSidKey');
        } 
        else if(create) {
        system.debug(LoggingLevel.WARN,'@@ TimeZoneSidKey 2' + attributes.get('User.TimeZoneSidKey'));
            u.TimeZoneSidKey = getTimezone(attributes.get('User.ProductDomain'))!=null?getTimezone(attributes.get('User.ProductDomain')):'GMT';
        }
        
         system.debug(LoggingLevel.WARN,'@@ user details :' + u.LanguageLocaleKey + u.TimeZoneSidKey );
    }
     /**
        * @description handleUser
        * @param create
        * @param u
        * @param attributes
        * @param federationIdentifier
        * @param isStandard
        * @param contactId
        */
    public static void handleUser(boolean create, User u, Map<String, String> attributes,
        String federationIdentifier, boolean isStandard,Id contactId) {
        try{        
          system.debug(LoggingLevel.WARN,'@@ contactid ' + contactId + create);
          CaseLines_DataUtil1.getUserData2(create,u,attributes);           
            setUserData3(create,u,attributes);
            setUserAlias(create,u,attributes);
              if(create){
              u.contactId = contactId;
              u.Division = 'CaseLines';
              u.Segment__c = 'Professional Legal';
              u.Sub_Bu__c = 'US';
              u.Sales_Org__c = 'GLI';
                  CaseLines_DataUtil1.setUserData1(federationIdentifier,u,attributes);
                  if(Schema.sObjectType.User.isCreateable()){
                    insert u;
                }
                //permissionSetAssignment(u.Id);
              }else{
                    if(Schema.sObjectType.User.isUpdateable()){
                        update u;
                    }
                } 
          
                      
            system.debug(LoggingLevel.WARN,'user contact'+u.contactId);          
            system.debug(LoggingLevel.WARN,'handle user'+u);
        }catch(Exception ex){
            system.debug(LoggingLevel.WARN,'@@ exception : ' + ex.getmessage() + ex.getlinenumber());
        }
        
    
    }
   
   /**
        * @description updateUser
        * @param userId
        * @param samlSsoProviderId
        * @param communityId
        * @param portalId
        * @param federationIdentifier
        * @param attributes
        * @param assertion
    
        */
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
        system.debug(LoggingLevel.WARN,'attributes in update user>>>'+attributes);
        //createUser(samlSsoProviderId,communityId,portalId,federationIdentifier,attributes,assertion);
        List<User> existUsr;
        
        if(Schema.sObjectType.User.isAccessible()){
            existUsr = [SELECT Id,UserName,contactId,LocaleSidKey FROM User Where federationIdentifier=: attributes.get('User.Email') and isActive=true and IsPortalEnabled=true and contactId!=null];
        }
        
        if(!existUsr.isEmpty() && (existUsr[0].LocaleSidKey != attributes.get('User.LocaleSidKey')))
        {
            system.debug(LoggingLevel.WARN,'attributes in query user>>>'+existUsr);
            existUsr[0].LocaleSidKey = attributes.get('User.LocaleSidKey');
            existUsr[0].LanguageLocaleKey = attributes.get('User.LocaleSidKey');
            if(Schema.sObjectType.User.isUpdateable()){
                update existUsr;
            }
        }
        
        
    }
}