/**
 * @description class for SSO for CaseLines data
 */
public without sharing class CaseLines_DataUtil {
    /**
        * @description getBucketAccount
        * @return Account
    */
    public static Account getBucketAccount(){
        Account acc;
        if(Schema.sObjectType.Account.isAccessible()){
         acc = [SELECT id,name from Account where name=:System.Label.CaseLinesBucketAccount and LCRM_Integration_Source__c = 'Guest Bucket Account'];
        }  
         return acc;
     }

     /**
        * @description getSSD
        * @param attributes
        * @return Source_System_Detail__c
    */
     public static Source_System_Detail__c getSSD(Map<String, String> attributes){
        List<Source_System_Detail__c> ssdObj;
        if(attributes.containsKey('Source_System_Account_Number__c') && Schema.sObjectType.Source_System_Detail__c.isAccessible()){
            ssdObj = [SELECT Account_Name__c,Source_System_Account_Number__c from Source_System_Detail__c 
                      WHERE Source_System_Account_Number__c=:attributes.get('Source_System_Account_Number__c')];
        }
        if(ssdObj!=null && ssdObj.size() > 0){
            return ssdObj[0];
        }
        return null;
    }

    /**
        * @description searchContact
        * @param accountID
        * @param u
        * @param attributes
    */
    public static void searchContact(Id accountID,User u, Map<String, String> attributes){
        List<Contact> cList = conSearch(accountID,u,attributes);
        
        if(cList!=null && cList.size() >0){
            system.debug(LoggingLevel.WARN,'@@ existing contact : ' + cList[0]);
            boolean isPortalUser = isPortalEnabled(cList[0],attributes,u);
            if(!isPortalUser){

                Contact c = createContact(attributes,accountID);
                CaseLinesSAMLJITHandler.handleUser(true,u, attributes, c.email, true,c.Id);
            }
        }else{
            Contact c = createContact(attributes,accountID);
            CaseLinesSAMLJITHandler.handleUser(true,u, attributes, c.email, true,c.Id);
        }
    }
    /**
        * @description conSearch
        * @param accountID
        * @param u
        * @param attributes
        * @return List<Contact>
    */
    public static List<Contact> conSearch(Id accountID,User u, Map<String, String> attributes){
        List<Contact> cList = new List<contact>();
        if(Schema.sObjectType.contact.isAccessible() && accountID!=null  && attributes.containsKey('Contact.FirstName') && attributes.containsKey('Contact.LastName') && attributes.containsKey('Contact.Email') && Schema.sObjectType.Contact.isAccessible()){
            cList = [SELECT id,email,FirstName,LastName,accountid from contact where email=:attributes.get('Contact.Email') and FirstName=:attributes.get('Contact.FirstName')
                AND LastName=:attributes.get('Contact.LastName') and accountid=:accountID];
            
        }
        return cList;
    }

    /**
        * @description isPortalEnabled
        * @param con
        * @param attributes
        * @param u
        * @return boolean
    */
    public static boolean isPortalEnabled(Contact con,Map<string,string> attributes,User u){
        List<User> u1 = new List<User>();
       if(Schema.sObjectType.User.isAccessible()){
                u1 = [Select id,username,contactid,FederationIdentifier from User where IsPortalEnabled = true and contactid = :con.Id  ];
            }
            //system.debug('User u : ' + u[0]);
            if(u1!=null && u1.size() >0 ){
                if(Schema.sObjectType.User.isUpdateable() && u1[0].federationIdentifier!=null && u1[0].federationIdentifier ==con.email){
                   u1[0].federationIdentifier = '';
                    update u1[0];
                }
                CaseLinesSAMLJITHandler.handleUser(true,u, attributes, con.email, true,con.Id);
                return true;
            }
            return false;
        }

        /**
        * @description createContact
        * @param attributes
        * @param accountId
        * @return Contact
    */
        public static Contact createContact(Map<String, String> attributes,Id accountId){
        
            Contact c = new Contact();
                c.FirstName = attributes.get('Contact.FirstName');
                c.LastName = attributes.get('Contact.LastName');
                c.email = attributes.get('Contact.Email');
                c.title = attributes.get('Contact.Title');
                c.ESC_tocLanguage__c = attributes.get('Contact.LanguagePreference');
                c.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('GLI_Contact').getRecordTypeId();
                if(!attributes.containsKey('Source_System_Account_Number__c')|| attributes.get('Source_System_Account_Number__c') =='' || attributes.get('Source_System_Account_Number__c') ==null){
                    c.LCRM_Integration_Source__c = 'Guest Contact';
                }
                c.AccountId = accountId;
                 if(Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isCreateable()){
                    insert c;
                }
                return c;
        }
        
}