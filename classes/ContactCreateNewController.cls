/**
 * Controller for the ContactCreateNew.page that extends the 
 * Contact standard controller
 *
 * @author  TCS
 * @version 2015-09-01
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2015-09-01   TCS                     Created                                                                   
 * =============================================================================
 */
 public class ContactCreateNewController{
     private final ApexPages.StandardController oStandardController;
     public boolean displayInputBlock{get;set;}
     public boolean searchClicked{get;set;}
     public Contact oContact{get;set;}
     //public boolean displayNoResBlock{get;set;}
     //public boolean displayResBlock{get;set;}
     public boolean HasMatchingSFDCContacts{get;set;}
     public Integer matchingSFDCContactsCount{get;set;}
     //public List<Person> respSfdcList{get;set;}
     public CreatePagination respSfdcResults {get;set;} 
     public boolean HasMatchingNonSFDCContacts{get;set;}
     public Integer matchingNonSFDCContactsCount{get;set;}
     //public List<Person> respNonSfdcList{get;set;}
     public CreatePagination respNonSfdcResults {get;set;} 
     public String selectedPersonID{get;set;}
     public String selectedPersonIDTemp{get;set;}
     //Added by Sreenu
     public boolean isContactNewPersonId {get; set;}
     public boolean isContactOldPersonId {get; set;}
     public static final string ContactCreateinIDQ = 'DQ.ContactCreateinIDQ';
     public static final string ContactPersonIdGen = 'DQ.ContactPersonIdGen';
     public Account oAccount; 
     public string businessUnit; 
     
     public ContactCreateNewController(ApexPages.StandardController controller){
         oStandardController = controller;
         oContact = (Contact)controller.getRecord();
         displayInputBlock = true;
         respSfdcResults = new CreatePagination();
         respNonSfdcResults = new CreatePagination();
         HasMatchingSFDCContacts = false;
         HasMatchingNonSFDCContacts = false;
         matchingSFDCContactsCount = 0;
         matchingNonSFDCContactsCount = 0;
         isContactNewPersonId = false;
         isContactOldPersonId = false;
         system.debug('selectedPersonID..'+selectedPersonID);
     }
     
     public void searchPerson(){
        //Business Unit Logic start query
        oAccount = new Account();
       // if(oContact.AccountID != null && oContact.AccountID != '') {
            oAccount = [Select Id, Name, Sales_Org__c, Source__C From Account Where Id =:oContact.AccountID];
            system.debug(oAccount);
       // }
        // Business unit logic end
        searchClicked = true;
        HasMatchingSFDCContacts = false;
        HasMatchingNonSFDCContacts = false;
        matchingSFDCContactsCount = 0;
        matchingNonSFDCContactsCount = 0;
        //sortDirectionSfdc = 'ASC';
        //sortExpSfdc = 'fName';
        //sortDirectionNonSfdc = 'ASC';
        //sortExpNonSfdc = 'fName';
        List<Person> respSfdcList = new List<Person>();
        respSfdcResults = new CreatePagination();
        respSfdcResults.listMatched =  respSfdcList;
        
        List<DataQualityUtil.ContactInfo> listMatchedContacts = new List<DataQualityUtil.ContactInfo>();
        
        //make a call out to IDQ to see if there are any matching contacts
        DataQualityUtil.ContactInfo oContactInfo = new DataQualityUtil.ContactInfo();
        oContactInfo.Name = oContact.Firstname + ' ' + oContact.LastName;
        oContactInfo.email = oContact.Email;
        Account oAccount = queryAccount(oContact.accountid);
        oContactInfo.MDBCustomerID = oAccount.MDBID__c;
        try{
            if(Test.isRunningTest()) {
                listMatchedContacts = MockWebserviceResponses.getContactInfoResponse();
            }
            else {
                listMatchedContacts = DataQualityUtil.matchContacts(new List<DataQualityUtil.ContactInfo>{ oContactInfo });
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            system.debug('exception in old : '+e.getMessage());
            searchClicked = false;
        }
        
        if(!listMatchedContacts.isEmpty()){
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
                //Person per = new Person('1', 'MDBContactID', 'Name', 'firstName1', 'lastName2', 'phoneNo1', 'email2', 'company1', 'BU2', 'score1', false);
                Person per = new Person();
                per.ID = mapMatchedContacts.get(ocontactMatchInfo.MDBContactID).ID;
                per.MDBContactID = oContactMatchInfo.MDBContactID;
                per.Name = oContactMatchInfo.Name;
                per.Email = oContactMatchInfo.Email;
                per.Score = oContactMatchInfo.Score;
                respSfdcList.add(per);
            }
        }
        if(respSfdcList != null && respSfdcList.size() != 0){
            HasMatchingSFDCContacts = true;
            matchingSFDCContactsCount = respSfdcList.size();
            // Initialize the result list & init paging            
            respSfdcResults.listMatched =  respSfdcList;
            System.Debug('respSfdcResults.listMatched : '+respSfdcResults.listMatched);
            this.respSfdcResults.initPaging();
        }
        
        List<Person> respNonSfdcList = new List<Person>();
        respNonSfdcResults = new CreatePagination();
        respNonSfdcResults.listMatched =  respNonSfdcList;        
        
        List<DataQualityUtil.ContactInfoNonSfdc> listMatchedContactsNonSfdc = new List<DataQualityUtil.ContactInfoNonSfdc>();
        DataQualityUtil.ContactInfoNonSfdc oContactNonSfdcInfo = new DataQualityUtil.ContactInfoNonSfdc();
        oContactNonSfdcInfo.firstName = oContact.Firstname;
        oContactNonSfdcInfo.lastName = oContact.LastName;
        oContactNonSfdcInfo.phoneNo = oContact.Work_Direct__c;
        oContactNonSfdcInfo.email = oContact.Email;
        Account oAccount2 = queryAccount(oContact.accountid);
        oContactNonSfdcInfo.accountName = oAccount.Name;
        try{
            if(Test.isRunningTest()) {
                listMatchedContactsNonSfdc =  MockWebserviceResponses.getmatchedIDQContacts();
            }
            else {
                listMatchedContactsNonSfdc = DataQualityUtil.matchContactsNonSfdc(new List<DataQualityUtil.ContactInfoNonSfdc>{oContactNonSfdcInfo});
                system.debug('listMatchedContactsNonSfdc : '+listMatchedContactsNonSfdc);
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            system.debug('exception in new : '+e.getMessage());
            searchClicked = false;
        }
        system.debug('listMatchedContactsNonSfdc : '+listMatchedContactsNonSfdc);
        if(!listMatchedContactsNonSfdc.isEmpty()){
            for (DataQualityUtil.ContactInfoNonSfdc oContactMatchInfo : listMatchedContactsNonSfdc) {
                //Person per = new Person('1', 'MDBContactID', 'Name', 'firstName1', 'lastName2', 'phoneNo1', 'email2', 'company1', 'BU2', 'score1', false);
                Person per = new Person();
                per.firstName = oContactMatchInfo.FirstName;
                per.lastName = oContactMatchInfo.lastName;
                per.Email = oContactMatchInfo.Email;
                per.phoneNo = oContactMatchInfo.phoneNo;
                per.Company = oContactMatchInfo.AccountName;
                per.Score = oContactMatchInfo.Score;
                per.personID = oContactMatchInfo.personID;
                per.BU = oContactMatchInfo.BU;
                respNonSfdcList.add(per);
            }
            
        }
        system.debug('selectedPersonID..'+selectedPersonID);
        system.debug('respNonSfdcList : '+respNonSfdcList);
        if(respNonSfdcList != null && respNonSfdcList.size() != 0){
            HasMatchingNonSFDCContacts = true;
            matchingNonSFDCContactsCount = respNonSfdcList.size();
            // Initialize the result list & init paging            
            respNonSfdcResults.listMatched =  respNonSfdcList;
            System.Debug('respNonSfdcResults.listMatched : '+respNonSfdcResults.listMatched);
            this.respNonSfdcResults.initPaging();
        }
            
        //when no results found
        if(HasMatchingSFDCContacts == false && HasMatchingNonSFDCContacts == false){
            displayInputBlock = true;
        }
        else{
            displayInputBlock = false;
        }
    }
    
    /**
     * Queries the database for and account filtered by the specified account id
     *
     * @param   accountId   the account id to filter by
     * @return  an instance of an Account object
     */
    @testVisible
    private static Account queryAccount(Id accountId) {
        return [SELECT 
                    Id, Name, MDBID__c
                FROM
                    Account
                WHERE
                    Id = :accountId];
    }
    
    @testVisible
    private List<Contact> queryContactsByMDBId(Set<string> ContactIds) {
        return [SELECT 
                    Id,
                    MDB_Contact_ID__c                    
                FROM 
                    Contact 
                WHERE 
                    MDB_Contact_ID__c IN :ContactIds]; 
    }
 
 // Added by Sreenu 
 // method is used in action function to render the buttons  
    public void updateisContactNewPersonId () {
        system.debug('isContactOldPersonId..'+isContactOldPersonId);
        if(selectedPersonID == null || selectedPersonID == '') {
            isContactNewPersonId = true;
            isContactOldPersonId = false;
            system.debug('isContactOldPersonId..'+isContactOldPersonId);
        } else {
            isContactOldPersonId = true;
            isContactNewPersonId = false;
            system.debug('isContactOldPersonId..'+isContactOldPersonId);
        }
    }
    
    
 // method will call when no maches found and to get the new person Id will call the Person Id Genaraion method  
    public PageReference save(){
       
       try {
        insert oContact;
        system.debug('oContact..'+oContact);
        return null;
        }
       catch(exception ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
                system.debug('exception in new : '+ex.getMessage());
                return null;
       }          
        
    }
// method will call when maches found and to get the new person Id will call the Person Id Genaraion method  else Record with save 
// with existing person Id and call idqContact create method   
    public pageReference saveWithPerson(){
       system.debug('selectedPersonID..'+selectedPersonID);
       pageReference oPageReference1;
       if(selectedPersonID == null || selectedPersonID == '') {
           try {
               insert oContact;          
               oPageReference1 = null;
               return oPageReference1;
           }
           catch(exception ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
                system.debug('exception in new : '+ex.getMessage());
                return null;
           }         
       }
       else {
           oContact.Person_ID__c = String.valueOF(selectedPersonID);        
           system.debug('oContact.Person_ID__c..'+oContact.Person_ID__c);
          
           try {
               insert oContact;              
               oPageReference1= null;
           }
           catch(exception ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
                system.debug('exception in new : '+ex.getMessage());
                return null;
           }
       }     
       system.debug('yes..'+oPageReference1);
       return oPageReference1; 
    }
    
    // Metod to get the New Person Id and Callout Made to Informatica Contact Store
    public Pagereference personIdGeneration() {
        try {
            
            ContactPersonIDWSDL.wf_m_MCM_GERATE_PERSON_ID_NEWPort personIDRequest= new ContactPersonIDWSDL.wf_m_MCM_GERATE_PERSON_ID_NEWPort ();
            //Setting a endpoint values
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(ContactCreateNewController.ContactPersonIdGen);
            personIDRequest.endpoint_x = oWebServiceSettings.Endpoint__c;
            personIDRequest.inputHttpHeaders_x = new Map<String, String>();
            personIDRequest.timeout_x = Integer.valueof((oWebServiceSettings.Timeout__c * 1000)); //Convert seconds to milliseconds           
            personIDRequest.outputHttpHeaders_x = new Map<String,String>();    
            
            ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestElement_element personIDRequestData = new ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestElement_element ();
            personIDRequestData .FIRST_NAME = oContact.FirstName;
            personIDRequestData .LAST_NAME = oContact.LastName;
            personIDRequestData .EMAIL = oContact.Email;
            personIDRequestData .PHONE = oContact.Work_Direct__c;
            //accountName = [SELECT Id, Name FROM Account WHERE ID = :oContact.AccountID LIMIT 1].Name;
            personIDRequestData .ACCOUNT_NAME = oAccount.Name; // [SELECT Id, Name FROM Account WHERE ID = :oContact.AccountID LIMIT 1].Name;
            personIDRequestData .BUSINESS_UNIT = fetchBU(OAccount); //get the Business Unit
            personIDRequestData .CONTACT_ID = oContact.Id;
            personIDRequestData .ACCOUNT_ID = oContact.AccountID;
            system.debug('personIDRequestData ..'+personIDRequestData );
            ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseElement_element PersonIDResp = new ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseElement_element ();  
        
            if(Test.isRunningTest())
            {
                PersonIDResp = MockWebserviceResponses.getPersonIDresponse();    
            }
            else {
                PersonIDResp = personIDRequest.wf_m_MCM_GERATE_PERSON_ID_NEWOperation(personIDRequestData);
                System.debug('PersonIDResp...: '+PersonIDResp);
            }
            oContact.Person_ID__c = String.valueOF(PersonIDResp.PERSON_ID);
            system.debug('oContact.Person_ID__c..'+oContact.Person_ID__c);
            system.debug('oContact..'+oContact);
            
            update oContact;
            system.debug('oContact..'+oContact);
            pageReference oPageReference = new pageReference('/'+oContact.Id);
            return oPageReference;
            }
            catch(exception ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
                system.debug('exception in new : '+ex.getMessage());
                return null;
            }         
    }
    // call to IDQ and contact will be created in that
    public PageReference idqContactCreate() {
        pageReference oPageReference;
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(ContactCreateNewController.ContactCreateinIDQ);
        //class to call the response
        IDQContactCreate.wf_m_MCM_EXISTING_CONTACT_CREATEPort conCreate = new IDQContactCreate.wf_m_MCM_EXISTING_CONTACT_CREATEPort ();
        conCreate.inputHttpHeaders_x = new Map<String,String>();
        conCreate.outputHttpHeaders_x = new Map<String,String>();
        conCreate.endpoint_x = oWebServiceSettings.Endpoint__c;
        conCreate.timeout_x = Integer.valueof((oWebServiceSettings.Timeout__c * 1000)); //Convert seconds to milliseconds
        system.debug('conCreate..'+conCreate);
        // Construct the request
        IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTRequestElement_element oRequest = new IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTRequestElement_element ();
        oRequest.FIRST_NAME = oContact.FirstName;
        oRequest.LAST_NAME = oContact.LastName;
        oRequest.EMAIL = oContact.Email;
        oRequest.PHONE = oContact.Work_Direct__c;
        oRequest.ACCOUNT_NAME = OAccount.Name; //[SELECT Id, Name FROM Account WHERE ID = :oContact.AccountID LIMIT 1].Name;
        oRequest.BUSINESS_UNIT = fetchBU(OAccount); //get the Business Unit
        oRequest.PERSON_ID = string.valueof(oContact.Person_ID__C);
        oRequest.CONTACT_ID = oContact.Id;
        oRequest.ACCOUNT_ID = oContact.AccountID;
        system.debug('oRequest..'+oRequest);
        // construct for response
        IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTResponseElement_element oResponse = new IDQContactCreateObjects.WS_CREATE_EXISTING_CONTACTResponseElement_element ();
        
        // callout
        try {
            if(Test.isRunningTest()) {
                oresponse.PERSON_ID = '123';
            }
            else { 
                oResponse = conCreate.wf_m_MCM_EXISTING_CONTACT_CREATEOperation(oRequest);
                system.debug('oResponse ..'+oResponse);
                }
            if(oResponse.PERSON_ID != null) {
                oPageReference = new pageReference('/'+oContact.Id);
                return oPageReference;
               }
               else {
                   oPageReference = null;
                   return oPageReference;
               }
        }
        catch(Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            system.debug('exception in new : '+ex.getMessage());
            oPageReference = null;
        }    
        return oPageReference;     
    }
    
    //Method to get the Business Unit based on the Account
    public string fetchBU(Account acc) {
    
        if(acc != null) {
            if(acc.Sales_Org__c == 'WEST') {
                if(acc.Source__c == 'Practical Law') {
                    businessUnit = 'Practical Law';                                     
                }
                 else If(acc.Source__c == 'Legal Managed Services') {
                     businessUnit = 'P3';  
                 }
                 else {
                     businessUnit = 'WEST';
                 }   
            }
            else {
                businessUnit = 'S2E Not West salesOrg';
            }
        }
       system.debug('businessUnit..'+businessUnit);   
       return businessUnit;   
    }   
      
    public void reset(){
    
         displayInputBlock = true;
        //displayResBlock = false;
        //displayNoResBlock = false;
        searchClicked = false;
        respSfdcResults = new CreatePagination();
        respNonSfdcResults = new CreatePagination();
   }
   
    
    /*********Sorting Methods Start*************/ 
    //private String sortDirectionSfdc = 'ASC';
    //private String sortExpSfdc = 'fName';
    //private String sortDirectionNonSfdc = 'ASC';
    //private String sortExpNonSfdc = 'fName';
    
    /*
    public String sortExpressionSfdc{
        get{
            return sortExpSfdc;
        }
        set{
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExpSfdc)
                sortDirectionSfdc = (sortDirectionSfdc == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirectionSfdc = 'ASC';
            sortExpSfdc = value;
        }
    }
    
    
    public String getSortDirectionSfdc()    {
        //if not column is selected 
       if (sortExpressionSfdc == null || sortExpressionSfdc == '')
          return 'ASC';
       else
          return sortDirectionSfdc;
    }
    */
    /*
    public String sortExpressionNonSfdc{
        get{
            return sortExpNonSfdc;
        }
        set{
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExpNonSfdc)
                sortDirectionNonSfdc = (sortDirectionNonSfdc == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirectionNonSfdc = 'ASC';
            sortExpNonSfdc = value;
        }
    }
    
    
    public String getSortDirectionNonSfdc()    {
        //if not column is selected 
       if (sortExpressionNonSfdc == null || sortExpressionNonSfdc == '')
          return 'ASC';
       else
          return sortDirectionNonSfdc;
    }

    public void dummyMethod(){  
    }
    */
     
    /*********Sorting Methods End*************/
    
    /*Pagination Code Starts*/
    public class CreatePagination{
        //Protected Members
        private final integer DefaultPageSize = 25;
        private integer iPageSize;  
    
    
        //Properties  
        public integer PageIndex{get;set;}
    
        public List<ContactCreateNewController.Person> listMatched{get;set;}
    
        public List<List<ContactCreateNewController.Person>> Pages {get; private set;}
    
        public integer PageSize {
            get { return this.iPageSize; }
        }
    
        public boolean AllowMoveNext {
            get{ return ((PageIndex + 1) < NumOfPages); }
        }
    
        public boolean AllowMovePrev {
            get{ return (PageIndex > 0); }
        }
    
        public integer NumOfPages {
            get{ return Pages.isEmpty() ? 1 : Pages.size(); }
        }
    
        public List<ContactCreateNewController.Person> CurrentPage {
            get { return getCurrentPage(PageIndex); }
        }
    
        public integer CurrentPageRecordSize {
            get { return getCurrentPage(PageIndex).size(); }
        }
    
        public integer RecordStart {
            get { return PageIndex*PageSize+1; }
        } 
    
        public integer RecordEnd {
            get { return (this.PageIndex + 1) == this.NumOfPages ? (PageIndex*PageSize)+CurrentPageRecordSize : (PageIndex+1)*CurrentPageRecordSize;}
        } 
    
        //Constructors
        public CreatePagination() {
            this.iPageSize = this.DefaultPageSize;
            
            this.PageIndex = 0;   
            this.listMatched = new List<ContactCreateNewController.Person>();
            this.Pages = new List<List<ContactCreateNewController.Person>>();
        }
    
        //Public Methods
    
        public void initPaging() {
            this.splitRowsIntoPages();
        }
    
        public void movePrev() {
            try {
                this.PageIndex = this.PageIndex -1;
            
                if (this.PageIndex < 0) {  
                    this.PageIndex = 0;
                }
            }
            catch(Exception oException) {
                ApexPages.addMessages(oException);
            }
        }
    
        public void moveNext() {
            try {
                this.PageIndex = this.PageIndex +1;
                
                if ((this.PageIndex + 1) > this.NumOfPages) {
                    this.PageIndex = (this.NumOfPages - 1);
                }
            }
            catch(Exception oException) {
                ApexPages.addMessages(oException);
            }
        }
    
    
        //Private Methods
        @testVisible
        private void splitRowsIntoPages() {
            this.Pages = new List<List<ContactCreateNewController.Person>>();
            this.PageIndex = 0;
            integer pageIndex = -1;
            for (ContactCreateNewController.Person oMatched : this.listMatched) {
                if (pageIndex == -1 || this.Pages[pageIndex].size() == this.iPageSize) {
                    pageIndex++;
                    this.Pages.add(new List<ContactCreateNewController.Person>());
                }
                this.Pages[pageIndex].add(oMatched);  
            }
        }
    
         @testVisible
        private List<ContactCreateNewController.Person> getCurrentPage(integer iPageIndex) {
            List<ContactCreateNewController.Person> listPage = new List<ContactCreateNewController.Person>();
            if (this.listMatched.isEmpty() == false && iPageIndex >= 0 && iPageIndex <= NumOfPages) {
                listPage = this.Pages[iPageIndex];
            }
            return listPage;
        }
    
    }
    /*Pagination Code Ends***/
    
    
    
    public class Person{
        public String ID{get;set;}
        public String MDBContactID{get;set;}
        public String Name{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String phoneNo{get;set;}
        public String email{get;set;}
        public String company{get;set;}
        public String BU{get;set;}
        public String score{get;set;}
        public Boolean sel{get;set;}
        public string personID{get; set;}
    }
 
 }