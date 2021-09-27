/**
 * Provides helper methods for creating unit tests
 * <p>
 * The purpose of this class is to centralize the instantiation of objects
 * that are utilized by unit tests. This will allow default values to be 
 * pre-populated and maintained at a central location easing the maintenance 
 * of unit test objects, which are affected by ongoing system configuration 
 * activities such as the creation of validation and workflow rules.
 *
 * @author          Mike Eaton
 * @version         2011-12-11
 * @dependencies    sObjects
 */
  
/** 
 * CHANGE HISTORY
 * --------------------------------------------------------------------------
 *  Date            Name                Description
 *  2011-12-11      Mike Eaton          Created
 *  2011-12-12      Shah Kadir          Added support to create the data records based on flag
 *  2012-01-04      Shah Kadir          Replaced XML data with JSON data
 *  2012-01-20      Shah Kadir          Incorporated enhanced list (go to list) functionality related changes.
 *  2012-03-09      Mike Eaton          Altered sample data to support custom TRBLUE Specific installation.
 *  2012-04-29      Shah Kadir          Commented out TRBLUE instance specific changes. Enhanced getAccount() & getContact() test methods
                                        to be independent of org specific validation rules/triggers  
 *  2012-07-12      Shah Kadir          Fixed test class related error
 *  2012-10-08      Shah Kadir          Modified custom setting SOQL to include two new fields 
 *                                              (Display_General_Error_Message__c, General_Error_Message__c)
 * 2013-08-19   Mike Eaton              Added support for Data_Sensitive_Display_Value__c field
 *  2014-09-11      David Sarbello      Modified initializeCustomSetting to include new Custom Settings entries
 * --------------------------------------------------------------------------
 */
public class CNUnitTest {
    //Read-Only Static Variables
    public static final Integer DEFAULT_BATCH_SIZE = 5;      

    //Protected Members
    private static CNUnitTest oUnitTest = new CNUnitTest(); 

    //Private Variables
    private Map<string, object> mapMockWebServiceResponse;
    
    //Properties
    public static Map<string, object> MockWebServiceResponse {
        get { return oUnitTest.mapMockWebServiceResponse; }
    }
    
    //Constructors
    
    /**
     * Default private constructor.
     */
    private CNUnitTest() {
        mapMockWebServiceResponse = new Map<string, object>();
    }

// -- Create Singleton Objects --   
    /**
     * Static method that generates an instance of an Account object
     * with its required field values pre-populated.
     *
     * @return  an instance of an Account that has not been committed
     *          to the database
     */
    public static Account getAccount(Boolean bCreateAccount) {
        Account oAccount = new Account();                   
        oAccount.Name = 'Unit Test';
        oAccount.Phone = '2036691234';
        oAccount.BillingStreet = '123 Main Street';
        oAccount.BillingCity='Clinton';
        oAccount.BillingState = 'GJ';
        oAccount.BillingPostalCode = '06413';
        oAccount.BillingCountry='IN';  
        //oAccount.Website = 'www.CNUnitTest.com';
        if (bCreateAccount) {
            System.debug('trying to insert a test account');
            Database.SaveResult mySaveResult = Database.insert(oAccount, false);
            if (mySaveResult.isSuccess()) {
                System.debug('test account created successfully: ' + oAccount.Id);
            }
        }   else {
                System.debug('test account creation failed. search for existing account');
                //Look for pre existing account record for which there is no webservice queue record
                oAccount = fetchRandomAccountHavingNoQueueRecord();             
        }
        return oAccount;
    }
    
    /**
     * Static method that generates an instance of a Contact object
     * with its required field values pre-populated.
     *
     * @param   accountId   the id of the master account record
     * @return  an instance of a Contact that has not been committed
     *          to the database
     */
    public static Contact getContact(Id accountId, Boolean bCreateContact) {
        Contact oContact = new Contact();
        oContact.AccountId = accountId;
        oContact.FirstName = 'John';
        oContact.LastName = 'Doe';
        oContact.MailingStreet = '123 Main Street';
        oContact.MailingCity = 'Clinton';
        oContact.MailingState = 'GJ';
        oContact.MailingPostalCode = '06413';
        oContact.MailingCountry = 'IN';
        oContact.Email = 'john.doe@CNUnitTest.com';
        oContact.Phone = '2036691234';

        if (bCreateContact) {
            System.debug('trying to create a test contact under account ' + accountId);
            Database.SaveResult mySaveResult = Database.insert(oContact, false);
            if (mySaveResult.isSuccess()) {
                System.debug('test contact created successfully: ' + oContact.Id);
            }
        }else{
            System.debug('test contact creation failed. search for existing contact.');
            oContact = fetchRandomContactHavingNoQueueRecord();
            if (oContact != null) {             
                oContact.Email = 'john.doe@CNUnitTest.com';
            }       
        }

//Shah 4/29: Commented out TRBLUE specific logic
/* TRBLUE Specific Test Data:   
        oContact.AccountId = accountId;
        oContact.Salutation = 'Mr';
        oContact.FirstName = 'John';
        oContact.LastName = 'Smith';
        oContact.MailingStreet = 'No.15,Bahai Bhavan Road';
        oContact.MailingCity = 'Bangalore';
        oContact.MailingState = 'GJ';
        oContact.MailingPostalCode = '560032';
        oContact.MailingCountry = 'IN';      
        oContact.Email = 'john.smith@CNUnitTest.com';
        oContact.Phone = '918040652';
        oContact.tocContactStatus__c = 'Prospect';
*/      
        System.debug('returning test contact: ' + oContact);        
        return oContact;
    }
    

// -- Create Batch Objects --   
    /**
     * Static method that generates numerous instances of a Contact object
     * with its required field values pre-populated.  Uses DEFAULT_BATCH_SIZE
     *
     * @param   accountId   the id of the master account record
     * @return  a List of Contacts that have not been committed
     *          to the database
     */
    public static List<Contact> getContacts(Id accountId, Boolean bCreateContacts) {    
        return CNUnitTest.getContacts(accountId, DEFAULT_BATCH_SIZE, bCreateContacts);
    }

    /**
     * Static method that generates numerous instances of a Contact object
     * with its required field values pre-populated.  Supports custom
     * batch size/
     *
     * @param   accountId   the id of the master account record
     * @param   iBatchSize  the number of records to be created in the batch
     * @return  a List of Contacts that have not been committed
     *          to the database
     */
    public static List<Contact> getContacts(Id accountId, Integer iBatchSize, Boolean bCreateContacts) {
        final String sEmailDomain1 = '@CNUnitTest.com';
        final String sEmailDomain2 = '@CNunitTestInc.com';
        final String sEmailDomain3 = '@CNunitTestCorp.com';
        
        List<Contact> listContacts = new List<Contact>();
        
        for (Integer iRec=1 ; iRec<= iBatchSize ; iRec++) {
            Contact oContact = CNUnitTest.getContact(accountId, true);
              
            // Add counter value to firstname for distinction
            oContact.FirstName = oContact.FirstName + iRec;
            
            // Add variation to email address to support DomainUtils
            //    related testMethods
            if (iRec < 5) {
                oContact.Email = oContact.FirstName + '.' + oContact.LastName + sEmailDomain1;
            } else if (iRec < 17) {
                oContact.Email = oContact.FirstName + '.' + oContact.LastName + sEmailDomain2;
            } else {
                oContact.Email = oContact.FirstName + '.' + oContact.LastName + sEmailDomain3;
            }
            listContacts.add(oContact);
        }
        
        if (bCreateContacts) {
            upsert listContacts;
        }
        return listContacts;
        
    }
    
    /**
     * Creates web service queue record which acts as the master record for relationships.
     *
     * @param sAcctId account id for which the queue is linked to
     * @param sContId contact id for which the queue is linked to
     * @param dtExpiration when the record should expire
     * @param bCreateQueue Decides if the queue should be created or not 
     * @return  web service queue object
     */
    public static CN_Webservice_Queue__c getWebserviceQueue(String sAcctId, String sContId, DateTime dtExpiration, Boolean bCreateQueue) {
        CN_Webservice_Queue__c oQueue = new CN_Webservice_Queue__c(Account__c=sAcctId, Contact__c=sContId, 
                    Unique_Id__c=(sAcctId != null ? sAcctId : sContId), Expiration_Date__c=dtExpiration, Company_CNID__c='124');
        
        if (bCreateQueue) {
            insert oQueue;
        }
        return oQueue;
    }   

    /**
     * Creates a collection of relationship records for a given queue record.
     *
     * @param sQueueId master record that represents the web service queue
     * @param iBatchSize how many relationships to be created
     * @param bCreatedRelationships decides if the relationships should be created or not 
     * @return  list of relationship cache records
     */
    public static List<CN_Relationship__c> getRelationships(String sQueueId, Integer iBatchSize, Boolean bCreateRelationships, Id recTypeId) {
        CN_Webservice_Queue__c oQueue = [Select Id, Account__c, Contact__c from CN_Webservice_Queue__c where Id=:sQueueId];
        
        List<CN_Relationship__c> listRels = new List<CN_Relationship__c>();
        for (Integer i=0; i<iBatchSize; i++) {
            CN_Relationship__c oRel = new CN_Relationship__c(CN_Webservice_Queue__c=oQueue.Id, Account__c=oQueue.Account__c, Contact__c=oQueue.Contact__c,
                    Firstname__c='Mike', Lastname__c='Eaton', 
                    Raw_Score__c=11.11, Normalized_Score__c=90, Source__c='IsEmail', Title__c='Test Title', All_Emails__c='test@test.com', First_Email__c='test@test.com',
                    CNID__c='111111', Company_CNID__c='22222', Fullname__c='Mike Eaton', Last_Modification_Time__c=System.now(), RecordTypeId=recTypeId);
            listRels.add(oRel);
        }
        
        if (bCreateRelationships) {
            insert listRels;
        }
        return listRels;
    }
    
    /**
    * Manages the 'CN App Setting' custom setting data by deleting & creating the necessary setup record. 
    * This data is critical for the entire integration to function properly.
    */
    public static CN_App_Settings__c initializeCustomSetting() {
        //Force delete (if any found) the existing custom setting record as we will not know the nature of the data present in the current environment.
        /*Original*/
        
            try {
                delete [Select Id from CN_APP_Settings__c where Name=:CNConstants.APP_SETTING_KEY];
            }
            catch(Exception ex) {}
            
            CN_App_Settings__c oCustomSetting = new CN_APP_Settings__c(Name=CNConstants.APP_SETTING_KEY, WS_Is_Active__c=true, Data_Cache_Size__c=10, 
                    Data_Display_Size__c=5, Error_Notification__c='test@test.com', Inner_Relationship_Data_Display_Size__c=10, 
                    WS_Endpoint__c='http://cn.salesforce.com', WS_Timeout__c=20, WS_Unavailable_Message__c='CN Service temporarily not available',
                    Enhanced_List_Data_Display_Size__c=10, Data_Expiration_Hours__c=1,
                    Display_General_Error_Message__c=false, General_Error_Message__c='Please try again later', Data_Sensitive_Display_Value__c='Unavailable',
                    Audit_Log_Expiration_Age_Days__c=30, Exclude_Sensitive_Audit_Log_Data__c=false, Support_Notification_Email__c='test@test.com');
            
            insert oCustomSetting;
        
            return oCustomSetting;
        
    }
    
    /**
    * Prepares a set of relationship nodes wrapped in 'ArrayOfContact' node
    * 
    * @param relationshipCount total number of relationship nodes to be included
    * @return String contains a single contact XML
    */
    public static String getArrayOfContactXML(Integer relationshipCount) {
        String jsonData = '[' + getContactXML(relationshipCount, false) + ']';
        System.debug('getArrayOfContactXML jsonData: ' + jsonData);
        return jsonData;        
    }
    
    /**
    * Prepares a set of relationship nodes wrapped in 'ArrayOfRelationship' node
    * 
    * @param relationshipCount total number of relationship nodes to be included
    * @return String contains the relationship XML
    */
    public static String getArrayOfRelationshipXML(Integer relationshipCount) {
        String xml = '[';
        for (Integer i=0; i<relationshipCount; i++) {
            if (i>0) {
                xml += ',';
            }           
            xml += getRelationshipXML();
        }
        xml += ']';
        return xml;     
    }

    /**
    * Prepares a a single company node which internally contains a set of colleague relationship nodes & contact relationship nodes
    * 
    * @param colleageCount total number of colleague relationship nodes to be included
    * @param contact total number of contact relationship nodes to be included
    * @return String contains the company XML
    */
    public static String getArrayOfCompanyXML(Integer colleagueCount, Integer contactCount) {
        return '[' + getCompanyXML(contactCount, colleagueCount, false) + ']';
    }
    
    /* PRIVATE METHODS */
    
    
    /**
    * Prepares a single contact in XML format.
    * 
    * @param relationshipCount total number of relationship nodes to be included
    * @return String contains contact information in XML form
    */
    private static String getContactXML(Integer relationshipCount, Boolean  includeTopNode) {
        String xml = '';
        if (includeTopNode) {
            xml = '"Contact":';
        }
        xml += '{"CNID":2272509' +
                ',' + getCompanyXML(0, 0, true) + 
                ',' + getEmailAddressesXML() + 
                ',"FirstName":"Jennie","LastModificationTime":"2011-11-15T00:00:00","LastName":"Samoska","NormalizedScore":"50"' + 
                ',' + getPhoneNumbersXML();
                
        if (relationshipCount == 0) {
            xml += ',"Relationships":null';
        }
        else {
            xml += ',"Relationships":[';
            for (Integer i=0; i<relationshipCount; i++) {
                if (i > 0) {
                    xml += ',';
                }
                xml += getRelationshipXML();
            }
            xml += ']';
        }
        
        xml += 
            ',"Score":"228.13350682050296"' + 
            ',' + getSourcesXML() +
            ',"Title":"Business Intelligence Manager"}';
        return xml;
    }
    
    /**
    * Prepares company information in XML format.
    * 
    * @param contactCount Total number of contact nodes to be included
    * @param relationshipCount Total number of relationship nodes to be included
    * @return String contains company information in XML form
    */
    private static String getCompanyXML(Integer contactCount, Integer relationshipCount, Boolean includeTopNode) {
        String xml =  '';
        if (includeTopNode) {
            xml = '"Company":';
        }
        xml += '{"CNID":77021491';
        if (contactCount == 0) {
            xml += ',"Contacts":null';
        }
        else {
            xml += ',"Contacts":[';
            for (Integer i=0; i<contactCount; i++) {
                if (i > 0) {
                    xml += ',';
                }
                xml += getContactXML(0, false);
            }
            xml += ']';
        }
        
        xml+=   
            ',"HasRelationship":true,"Identifiers":["bd1342","77021491"],"IsClient":true,"IsDeleted":false,"Name":"Holland &amp; Knight"';
        
        if (relationshipCount == 0) {
            xml += ',"Relationships":null';
        }
        else {
            xml += ',"Relationships":[';
            for (Integer i=0; i<relationshipCount; i++) {
                if (i > 0) {
                    xml += ',';
                }
                xml += getRelationshipXML();
            }
            xml += ']';
        }
        
        xml +=  '}';
        return xml;
    }

    /**
    * Prepares a single relationship XML betweeen a colleague & contact
    * 
    * @return String contains the relationship XML
    */
    private static String getRelationshipXML() {
        return 
            '{' +
            getColleagueXML() +
            ',"Company":null' + 
            ',' + getContactXML(0, true) + 
            ',"Industry":null,"NormalizedScore":50,"ScoreValue":140.4470265329872' +
            ',' + getSourcesXML() +
            ',"Type":"toContact"' +
            '}';        
    }   
        
    /**
    * Prepares a collection of sample phone numbers in XML format.
    * 
    * @return String contains a collection of phone numbers in XML form
    */
    private static String getPhoneNumbersXML() {
        return '"PhoneNumbers":[{"Number":"617.854.1478","Type":"pref"},{"Number":"617.523.6850","Type":"fax"},{"Number":"617.854.1478","Type":"work"}]';
    }
    
    /**
    * Prepares a collection of sample sources in XML format.
    * 
    * @return String contains a collection of sources in XML form
    */
    private static String getSourcesXML() {
        return '"Sources":["IsEmail","IsAddressBook","IsPhone","IsInterAction","IsTimeAndBilling"]'; 
    } 

    /**
    * Prepares a collection of sample email addresses in XML format.
    * 
    * @return String contains a collection of email addresses in XML form
    */
    private static String getEmailAddressesXML() {
        return '"EmailAddresses":["jennie.samoska@hklaw.com","j.samoska@hklaw.com","jennie.s@hklaw.com"]';
    } 
     
    /**
    * Prepares colleague information in XML format.
    * 
    * @return String contains colleague information in XML form
    */
    private static String getColleagueXML() {
        return 
            '"Colleague":{"CNID":15963,"Department":"Legal Hubbard One"' +
            ',' + getEmailAddressesXML() + 
            ',"FirstName":"Meera","LastName":"Murthy","Location":"22 Thomson Place"' +
            ',' + getPhoneNumbersXML() + 
            ',"Relationships":null,"Title":"Client Solutions Lead"}';
    }
    
    /**
    * Fetches a random account record from database for which there is no webservice queue record.
    */
    private static Account fetchRandomAccountHavingNoQueueRecord() {
        List<Account> listAccts = [Select Id, Name, Phone, BillingStreet, BillingCity, BillingState, 
                            BillingPostalCode, BillingCountry, Website
                            from Account limit 1];
        Account acct = null;
        if (listAccts.size() == 1) {
            acct = listAccts.get(0);
            List<CN_Webservice_Queue__c> existingQueues = [Select Id from CN_Webservice_Queue__c where 
                            Account__c = :acct.Id];  //it should return max one record only
            delete existingQueues;                          
        }
        return acct;
    }   
    
    /**
    * Fetches a random contact record from database for which there is no webservice queue record.
    */
    private static Contact fetchRandomContactHavingNoQueueRecord() {
        List<Contact> listConts = [Select Id, AccountId, FirstName, LastName, MailingStreet, MailingCity, MailingState, MailingPostalCode,
                MailingCountry, Email, Phone from Contact where Email != null and Firstname != null 
                and Lastname != null limit 1];
        Contact cont = null;
        if (listConts.size() == 1) {
            cont = listConts.get(0);
            List<CN_Webservice_Queue__c> existingQueues = [Select Id from CN_Webservice_Queue__c where 
                            Contact__c = :cont.Id];  //it should return max one record only
            delete existingQueues;                          
        }
        return cont;
    }   

    
}