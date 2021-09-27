/**
 * @description class for SSO for CaseLines data
 */
public without sharing class CaseLines_DataUtil1 {
    /**
        * @description setUserData1
        * @param federationIdentifier
        * @param u
        * @param attributes
        */
        public static void setUserData1(string federationIdentifier,User u,Map<string,string> attributes){

            if(attributes.containsKey('User.Email')) {
                string randomNumber = string.valueof((Math.random() * 10));
                u.Username = attributes.get('User.Email').substringBefore('@') +randomNumber+'@'+attributes.get('User.Email').substringAfter('@') +'.customer';                
            
            }
            system.debug(LoggingLevel.WARN,'@@ username : ' + u.Username);
            //u.contactId = contactId;
                if(attributes.containsKey('User.FederationIdentifier')) {
                    u.FederationIdentifier = attributes.get('User.FederationIdentifier');
                } else {
                    u.FederationIdentifier = federationIdentifier;
                }
            
            Profile p ;
            if(Schema.sObjectType.Profile.isAccessible()){
               p = [SELECT Id FROM Profile WHERE Name=:System.Label.CaseLinesCommunityProfile];
            }
            
                String profileId = p.Id;
                system.debug(LoggingLevel.WARN,'profileId >>>'+profileId);
                
                
                    u.ProfileId = p.Id; 
                    if(attributes.containsKey('User.Email')) {
                        u.Email = attributes.get('User.Email');
                    }
                    if(attributes.containsKey('Contact.FirstName')) {
                        u.FirstName = attributes.get('Contact.FirstName');
                    }
                    if(attributes.containsKey('Contact.LastName')) {
                        u.LastName = attributes.get('Contact.LastName');
                    }    
                  
        }
         /**
        * @description getUserData2
        * @param create
        * @param u
        * @param attributes
        */
    public static void getUserData2(boolean create,User u,Map<string,string> attributes){

        if(attributes.containsKey('User.LocaleSidKey') && attributes.get('User.LocaleSidKey')!=null && attributes.get('User.LocaleSidKey')!='') {
            u.LocaleSidKey = attributes.get('User.LocaleSidKey');
        } 
        else if(create) {
            u.LocaleSidKey = 'en_US';
        }
        
        if(attributes.containsKey('User.LocaleSidKey') && attributes.get('User.LocaleSidKey')!=null && attributes.get('User.LocaleSidKey')!='') {
            system.debug(LoggingLevel.WARN,'@@ languagelocalekey 1' + attributes.get('User.LocaleSidKey'));
            u.LanguageLocaleKey = attributes.get('User.LocaleSidKey');
        } else if(create) {
            //system.debug(LoggingLevel.WARN,'@@ languagelocalekey 2' + attributes.get('User.LanguageLocaleKey'));
            u.LanguageLocaleKey = 'en_US';
        }
        
            u.EmailEncodingKey = 'UTF-8';
        
    }
}