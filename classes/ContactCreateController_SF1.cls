/**
 * Controller for the ContactCreate.page that extends the 
 * Contact standard controller
 *
 * @author  Srikanth Kuruva
 * @version 2013-06-28
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-06-28   Srikanth Kuruva        Created                                                                   
 * =============================================================================
 */
 public class ContactCreateController_SF1{

    public ContactCreateController_SF1() {
        oContact = new Contact();
        oStandardController = new ApexPages.StandardController(oContact);
        //oContact = [select salutation, FirstName, LastName, Email, accountId from Contact where Id=:oContact.Id];
        HasMatchingContacts = false;
        this.Matchedcontacts = new List<Matchedcontact>();
        this.SkipContactMatching = false;
    }

    
    private ApexPages.StandardController oStandardController;
    public Contact oContact{get;set;}
    public boolean HasMatchingContacts {get;set;}
    public boolean SkipContactMatching {get;set;}
    public List<MatchedContact> MatchedContacts {get;set;}
    public List<DataQualityUtil.ContactInfo> listMatchedContacts{get;set;}
    public Account oAccount {get;set;}
    
    
    public ContactCreateController_SF1(ApexPages.StandardController controller) {
        oStandardController = controller;
        oAccount = (Account)controller.getRecord();
        oContact = new Contact(AccountId = oAccount.Id);
        //oContact = [select salutation, FirstName, LastName, Email, accountId from Contact where Id=:oContact.Id];
        HasMatchingContacts = false;
        this.Matchedcontacts = new List<Matchedcontact>();
        this.SkipContactMatching = false;
    }


    public PageReference continueSave() {
        //this.SkipAddressValidation = true;
        this.SkipContactMatching = true;
        
        return this.save();
    }

    public pageReference save(){
        pageReference oPageReference = null;
        //make a call out to IDQ to see if there are any matching contacts
    
      if (this.SkipContactMatching == false){
            DataQualityUtil.ContactInfo oContactInfo = new DataQualityUtil.ContactInfo();
            //oContactInfo.MDBCustomerID = oContact.MDB_Account_Number__c;
            oContactInfo.Name = oContact.Firstname + ' ' + oContact.LastName;
            oContactInfo.email = oContact.Email;
            Account oAccount = queryAccount(oContact.accountid);
            oContactInfo.MDBCustomerID = oAccount.MDBID__c;
            if(!Test.isRunningTest()){
                listMatchedContacts = DataQualityUtil.matchContacts(new List<DataQualityUtil.ContactInfo>{ oContactInfo });
            }
      }
      else {
            insert oContact;
            return null;
      } 
        //if there are matching contacts set the HasMatchingContacts to true
        if(!listMatchedContacts.isEmpty()){
            HasMatchingContacts =true;
            
//****************************************************

//Build Set of Matched Contact Ids
            Set<string> MDBIds = new Set<string>();
            for (DataQualityUtil.ContactInfo oContactMatchInfo : listMatchedContacts) {
                MDBIds.add(oContactMatchInfo.MDBContactID);
            }
            
            Map<string, Contact> mapMatchedContacts = new Map<string, Contact>();
            for (Contact oContact : this.queryContactsByMDBId(MDBIds)) {
                mapMatchedContacts.put(oContact.MDB_Contact_ID__c, oContact);
            }
            system.debug('listmatchedcontacts:' + listmatchedcontacts);
            for (DataQualityUtil.ContactInfo oContactMatchInfo : listMatchedContacts) {
                MatchedContact oMatchedContact = new MatchedContact();
                oMatchedContact.ContactInfo = oContactMatchInfo;
                oMatchedContact.Contact = mapMatchedContacts.get(ocontactMatchInfo.MDBContactID);
                oMatchedContact.Score = oContactMatchInfo.Score;
                system.debug('matchedcontact' + omatchedcontact); 
                this.MatchedContacts.add(oMatchedContact);
            }

//*******************************************************************************************            

            return null;
        }
        else{//else if no matching records are found create the contact and redirect to the detail

            insert oContact;
            return null;
        }
    }
    
   // public class MatchedContact{
    
   // }
    
    /**
     * Queries the database for and account filtered by the specified account id
     *
     * @param   accountId   the account id to filter by
     * @return  an instance of an Account object
     */
    private static Account queryAccount(Id accountId) {
        return [SELECT 
                    Id
                    , MDBID__c
                FROM
                    Account
                WHERE
                    Id = :accountId];
    }
    private List<Contact> queryContactsByMDBId(Set<string> ContactIds) {
        return [SELECT 
                    Id,
                    MDB_Contact_ID__c,
                    Account.Name
                FROM 
                    Contact 
                WHERE 
                    MDB_Contact_ID__c IN :ContactIds]; 
    }
    public class MatchedContact {
        public DataQualityUtil.ContactInfo ContactInfo {get;set;}
        public contact Contact {get;set;}
        public string Score {get;set;}
    }
 }