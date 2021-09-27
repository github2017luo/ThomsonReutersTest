/**
 * Provides methods helper methods for working with Contacts
 *
 * @author  John De Santiago - Thomson Reuters Code Share
 * @version 2012-05-02
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-05-02   John De Santiago        Created   
 * 2013-03-28   Shawn Gray              Added system.isBatch() ==false to executeMDBContactUpsertService method    
 * 2017-01-11   Shovon Bera             Suppressing executeMDBContactUpsertService and validateAccountApprovedReservation methods for GLI as part of Legal CRM May-2017 release 
 * =============================================================================
 */
public without sharing class ContactUtil {

    //Public Methods
    
    /**
     * Helper method that returns an DataQualityUtil.Address object that has been populated
     * from the specified Contact's Mailing address fields
     *
     * @param   oContact    a reference to an Contact object
     * @return  a instance of an DataQualityUtil.Address object
     */
    public static DataQualityUtil.Address getMailingAddress(Contact oContact) {
        DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
        
        if (oContact != null) {
            Contact clonedContact = oContact.clone(); //Work with copy to prevent error on fields not queried but referenced.
            
            oAddress.Name = clonedContact.Name;
            oAddress.Street = clonedContact.MailingStreet;
            oAddress.City = clonedContact.MailingCity;
            oAddress.State = clonedContact.MailingState;
            oAddress.PostalCode = clonedContact.MailingPostalCode;
            oAddress.Country = clonedContact.MailingCountry;
        }
        
        return oAddress;
    }
    
    public static string getProfileName(){
        //string strProfileNAme= (string)[SELECT name from Profile WHERE id= : userInfo.getProfileId() LIMIT 1].Name;
        //system.debug('**profile Name' +strProfileNAme);
        //return strProfileNAme;
        string strProfileNAme = AppUtil.getProfileName(userInfo.getProfileId());
        system.debug('**profile Name' +strProfileNAme);
        return strProfileNAme;
    }
    
    /**
     * Helper method that sets the specified Contact's Mailing address fields 
     * based on the specified DataQualityUtil.Address object
     *
     * @param   oContact    a reference to an Contact object
     * @param   oAddress    a reference to an DataQualityUtil.Address object
     */
    public static void setMailingAddress(Contact oContact, DataQualityUtil.Address oAddress) {
        if (oContact != null && oAddress != null) {
            oContact.MailingStreet = oAddress.Street;
            oContact.MailingCity = oAddress.City;
            oContact.MailingState = oAddress.State;
            oContact.MailingPostalCode = oAddress.PostalCode;
            oContact.MailingCountry = oAddress.Country;
        }
    }
    
    /**
     * Helper method that identifies if an contact should be submitted
     * to MDB based on specified list of contacts
     *
     * @param   listContacts    a list of Contact objects to process
     */
    public static void executeMDBContactUpsertService(List<Contact> listContacts) {
        boolean submitContact = (listContacts.size() == 1 && System.isFuture() == false && system.isBatch() ==false);
        
        if (submitContact) {
            Contact oContact = listContacts[0]; //queryContact(listContacts[0].Id);
            string sSubmissionToken = MDBIntegrationUtil.generateMDBSubmissionToken(oContact.Id);
            
            if (oContact.LCRM_Is_GLI__c != TRUE && oContact.MDB_Contact_ID__c != sSubmissionToken) {
                if (AppUtil.isEmpty(oContact.MDB_Contact_ID__c)) {
                    update new Contact(Id = oContact.Id, MDB_Contact_ID__c = sSubmissionToken);
                }
                
                ContactUtil.upsertMDBContactAsync(oContact.Id);
            }
        }
    }
    
    /**
     * Executes the upsertMDBContact method as an asynchronous transaction
     *
     * @param   contactId   the contact id to submit to MDB
     */
    @future(callout=true)
    public static void upsertMDBContactAsync(Id contactId) {
        upsertMDBContact(contactId);
    }
    
    /**
     * Initiates a web service command to submit the specified contact to 
     * MDB for upsert
     *
     * @param   contactId   the contact id to submit to MDB
     */
    public static void upsertMDBContact(Id contactId) {
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(MDBIntegrationUtil.UpsertContactServiceName);
        
        Contact oContact = queryContact(contactId);
        string sSubmissionToken = MDBIntegrationUtil.generateMDBSubmissionToken(contactId);
        
        MDBIntegrationUtil.UpsertContactRequest oRequest = new MDBIntegrationUtil.UpsertContactRequest();
        oRequest.EndPoint = oWebServiceSettings.Endpoint__c;
        oRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
        oRequest.FirstName = oContact.FirstName;
        oRequest.LastName = oContact.LastName;
        oRequest.MDBContactId = (oContact.MDB_Contact_ID__c == sSubmissionToken ? null : oContact.MDB_Contact_ID__c); //Prevents submission token from being sent to MDB
        oRequest.MDBAccountId = oContact.Account.MDBID__c;
        oRequest.Phone = oContact.Phone;
        oRequest.FAx = oContact.Fax;
        oRequest.Title = oContact.Title;
        oRequest.Email = oContact.Email;
        oRequest.Department = oContact.Department__c;
        oRequest.OnlineFlag = (oContact.Class__c == 'ONLINE' ? '1' : '0');
        oRequest.JobFunction =oContact.Job_Function__c;
        oRequest.ContactId = oContact.Id;
        oRequest.ContactType = oContact.Contact_Type__c;
        oRequest.WorkDirect = oContact.Work_Direct__c;
        oRequest.HomePhone = oContact.HomePhone;
        oRequest.WorkFax = oContact.Work_Fax__c;
        oRequest.AssistantPhone = oContact.AssistantPhone;
        oRequest.Mobile = oContact.MobilePhone;
        
        MDBIntegrationUtil.UpsertContactResponse oResponse = MDBIntegrationUtil.upsertContact(oRequest);
        if (oResponse.IsSuccess == true) {
            //update new Contact(Id=oContact.Id, MDB_Contact_ID__c = oResponse.MDBContactId);
            update new Contact(Id=oContact.Id, MDB_Contact_ID__c = oResponse.MDBContactId, ID__c = oResponse.MDBContactId);
        }
        else {
            if (oContact.MDB_Contact_ID__c == sSubmissionToken) {
                update new Contact(Id=oContact.Id, MDB_Contact_ID__c = null); //Reset MDBID to null if token is specified. This will allow the contact to be processed again on future updates
            }
        }
    }
    
    
    /* /**
    * Throw Error MEssage during contact create if any account reservation is not approved.
    * * / */
    public static void validateAccountApprovedReservation(LIST<Contact> newConList) {
        map<Id, Contact> MapContact;
        SET<string> conAccountIds= new SET<string>();
            
        for(contact con: newConList){  
            if(con.LCRM_Is_GLI__c != TRUE){ // Suppressing for Legal CRM GLI profile
                conAccountIds.add(con.AccountId);  
            }
        }  
        string strprfName= getProfileName();          
        if(strprfName == Label.Partner_Portal_Profile){
            
            MAP<string,boolean> accountResrvationMap= new MAP<string,boolean>();
            SET<string> acctsWithApprvdResrvtns = new SET<string>();
            List<RESERVATION__c> resrvtnLst= new List<RESERVATION__c>();
            resrvtnLst=[SELECT Id, Account__c FROM RESERVATION__c WHERE Approval_Status__c = 'Approved' AND Account__c IN : conAccountIds];
            system.debug('***resrvtnLst' +resrvtnLst);
            for(Reservation__c r:resrvtnLst){
                acctsWithApprvdResrvtns.add(r.Account__c);
            }
            system.debug('***acctsWithApprvdResrvtns' +acctsWithApprvdResrvtns);
            
            //Get Opportunity Fields to validate
            MapContact = new map<Id, Contact>([select Id, Opportunity__r.Partner_Portal_User__c, Opportunity__r.PartnerAccountid
                                                    from Contact where AccountId IN: conAccountIds]);   
           
            for(contact con: newConList){  
            System.Debug('****'+MapContact.get(con.Id));
              if(MapContact.get(con.Id) == null) continue;
              string sPartnerUser = MapContact.get(con.Id).Opportunity__r.Partner_Portal_User__c;
              string sPartnerAccount = MapContact.get(con.Id).Opportunity__r.PartnerAccountId;
              system.debug('***con ID: ' + con.Id + ', opp ID: ' + con.Opportunity__c + ', opp Partner User: ' + sPartnerUser + ', opp Partner Account: ' + sPartnerAccount);
                
//            if(con.Is_Lead_Convert__c == false  && (con.Opportunity__c == null || con.Opportunity__c == '') && (con.Opportunity__r.Partner_Portal_User__c == '' || 
//               con.Opportunity__r.Partner_Portal_User__c == null || con.Opportunity__r.PartnerAccount.Id =='' || con.Opportunity__r.PartnerAccount.Id == null)){
//              if(con.Is_Lead_Convert__c == false && ((con.Opportunity__c == null || con.Opportunity__c == '') || ((con.Opportunity__r.Partner_Portal_User__c == '' ||  
//                 con.Opportunity__r.Partner_Portal_User__c == null || con.Opportunity__r.PartnerAccountId =='' || con.Opportunity__r.PartnerAccountId == null))))
                 
              if(con.Is_Lead_Convert__c == false && ((con.Opportunity__c == null) || 
                (sPartnerUser == null || sPartnerAccount == null))) 
                 {  
                    if(!acctsWithApprvdResrvtns.Contains(con.AccountId)){
                        con.AddError(System.Label.Reservation_Error);
                    }                
                 }
            } 
            
        } 
       
     
    }
    
    
    
    //Private Methods
    
    /**
     * Queries the database for and contact filtered by the specified contact id
     *
     * @param   contactId   the contact id to filter by
     * @return  an instance of an Contact object
     */
    private static Contact queryContact(Id contactId) {
        return [SELECT 
                    Id
                    , FirstName
                    , LastName
                    , MDB_Contact_ID__c
                    , SAP_Contact_ID__c
                    , Account.MDBID__c
                    , Account.SAPAccountNumber__c
                    , MDB_Account_Number__c
                    , Phone
                    , Work_Direct__c
                    , Fax
                    , Title
                    , Email
                    , Class__c
                    , Department
                    , Department__c
                    , Job_Function__c
                    , Contact_Type__c
                    , HomePhone
                    , Work_Fax__c
                    , AssistantPhone
                    , MobilePhone
                FROM
                    Contact
                WHERE
                    Id = :contactId];
    }
    
//Ravi H - Opportunity stage should not be allowed > 75% when Pricing approval & isSyncing fields are True
  public static void validateOppStage(List<Opportunity> OpptyList)
  { 
     String ProfileName = getProfileName();   
     If(ProfileName == 'LatAm User' || ProfileName == 'Partner Portal User')        
     {
        list<Quote> oppQuoteIds = new list<Quote>();
        set<String> opportunityIdSet = new set<String> ();
        if(!OpptyList.isEmpty()) {             
               oppQuoteIds = [Select Id, OpportunityId from Quote where Pricing_Approval_Required__c = TRUE and Pricing_Approval_Complete__c = False and IsSyncing =true and OpportunityId in: OpptyList]; 
               system.debug('quote Ids *****'+oppQuoteIds);
               if(!oppQuoteIds.IsEmpty()) {
                 for(Quote qt :oppQuoteIds){
                     opportunityIdSet.add(qt.OpportunityId); 
                 }
               }
          }
        system.debug('Quote opportunityIdSet Ids *****'+opportunityIdSet);                   
                    
        for(Opportunity opp  : OpptyList)
         {                                  
           If(!opportunityIdSet.IsEmpty() && opportunityIdSet.contains(opp.id))
           {
            opp.addError(System.label.OppPricingApprvlErrorMessage);            
           } 
         }
      }                
   }
            
    
    public static void updateLeadEmail(List<Contact> listContact,Map<Id,Contact> MapNewContact){
        Map<Id,Lead> MapLeadContact =  new Map<Id,Lead>();
        Map<String,Contact> MapExternalIdContact = new Map<String,Contact>();
        List<Lead> listLead = new List<Lead>();
        List<Lead> listLeadtoUpd = new List<Lead>();
        set<string> setExternalIds = new set<String>();
        String LeadsQuery = 'Select Email,Title,Contact__c,Job_Function__c,External_Contact_ID__c from Lead where IsConverted=false and ';

        
        for(Contact oContact : listContact){
            if(oContact.External_Id__c!=null){
              if(!MapExternalIdContact.containskey(String.valueof(oContact.External_Id__c))){
                MapExternalIdContact.put(String.valueof(oContact.External_Id__c),oContact);
                
               }
            }
        }
        
                
        setExternalIds = MapExternalIdContact.keyset();
        
       
        if(!listContact.IsEmpty()){
          LeadsQuery += '(Contact__c IN : listContact';
             
          if(!MapExternalIdContact.IsEmpty()){  
              LeadsQuery += ' OR External_Contact_ID__c IN : setExternalIds)';
//              LeadsQuery += ' OR External_Contact_ID__c IN '+exterIds+')';
                
          }else{
              LeadsQuery += ')';
          }
       }else if(!MapExternalIdContact.IsEmpty()){
            LeadsQuery += 'External_Contact_ID__c IN : setExternalIds';
           //LeadsQuery += 'External_Contact_ID__c IN '+exterIds;
        }
        
        
        try{
            if(!listContact.IsEmpty() || !MapExternalIdContact.IsEmpty())
                listLead = Database.query(LeadsQuery);
            
            for(Lead oLead : listLead){
                if(MapNewContact.containsKey(oLead.Contact__c)){
                //MCL-1762 : Update lead Email only when it's null
                    If(oLead.Email==null || oLead.Email==''){
                        if(MapNewContact.get(oLead.Contact__c).SAP_Email_1__c!=null || MapNewContact.get(oLead.Contact__c).SAP_Email_1__c!=''){
                          oLead.Email = MapNewContact.get(oLead.Contact__c).SAP_Email_1__c;
                        }
                        else if(MapNewContact.get(oLead.Contact__c).Email!=null || MapNewContact.get(oLead.Contact__c).Email!=''){
                                oLead.Email = MapNewContact.get(oLead.Contact__c).Email;
                             
                        }else{
                            oLead.Email = MapNewContact.get(oLead.Contact__c).WLEC_Email_Address_1__c ;
                        }
                     }   
                        oLead.Title= MapNewContact.get(oLead.Contact__c).Title;
                        oLead.Job_Function__c = MapNewContact.get(oLead.Contact__c).Job_Function__c;
                        listLeadtoUpd.add(oLead);
                     }else if(MapExternalIdContact.containskey(String.valueof(oLead.External_Contact_ID__c))){
                     
                        oLead.Title= MapExternalIdContact.get(String.valueof(oLead.External_Contact_ID__c)).Title;
                        oLead.Job_Function__c = MapExternalIdContact.get(String.valueof(oLead.External_Contact_ID__c)).Job_Function__c;
                        oLead.Contact__c = MapExternalIdContact.get(String.valueof(oLead.External_Contact_ID__c)).Id;
                        listLeadtoUpd.add(oLead);
                     
                     }
                    
            }
            update listLeadtoUpd;
          }catch(Exception ex){}
          
       }
}