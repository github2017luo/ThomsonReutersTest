@IsTest

public class ContactCreateNewController_Test{
 
    public static testMethod void testSaveContact() {
        Account acc = new Account(Name='BANK OF MONTREAL', BillingCountry ='US', Phone = '91 80 67254199', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;       
        Contact con = new Contact(FirstName = 'Test', LastName = 'Test', Email = 'test@tcs.com', AccountID = acc.Id); 
        PageReference oPageContact = Page.ContactCreateNew;
        Test.setCurrentPage(oPageContact);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(con);
        ContactCreateNewController ccCon = new ContactCreateNewController(oStandardController);
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Name = 'DQ.ContactMatchingService';
        oWebServiceSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oWebServiceSettings.Timeout__c = 5;
        oWebServiceSettings.Active__c = true;
        oWebServiceSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oWebServiceSettings;
        
         WebServiceSettings__c oIDQContactCreateSettings = new WebServiceSettings__c();
        oIDQContactCreateSettings.Name = ContactCreateNewController.ContactPersonIdGen;
        oIDQContactCreateSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oIDQContactCreateSettings.Timeout__c = 5;
        oIDQContactCreateSettings.Active__c = true;
        oIDQContactCreateSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oIDQContactCreateSettings;
        WebServiceSettings__c oIDQContactCreateSettings1 = new WebServiceSettings__c();
        oIDQContactCreateSettings1.Name = ContactCreateNewController.ContactCreateinIDQ;
        oIDQContactCreateSettings1.Endpoint__c = 'https:\\thomsonreuters.com';
        oIDQContactCreateSettings1.Timeout__c = 5;
        oIDQContactCreateSettings1.Active__c = true;
        oIDQContactCreateSettings1.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oIDQContactCreateSettings1;
        
        ccCon .searchPerson();
        ccCon .save();        
        ccCon .saveWithPerson();
        ccCon .updateisContactNewPersonId();
        ccCon.fetchBU(acc);
        ccCon.personIdGeneration();
        ccCon.idqContactCreate();
        //ccCon .cancel();
        //ccCon .reset();
        
        ContactCreateNewController.CreatePagination cp = new ContactCreateNewController.CreatePagination();
        
        cp.initPaging();
        cp.movePrev();
        cp.moveNext();
        cp.splitRowsIntoPages();
        cp.getCurrentPage(5);
        integer I = cp.PageSize;
        boolean b = cp.AllowMoveNext;
        boolean bl = cp.AllowMovePrev;
        integer i1 = cp.CurrentPageRecordSize;
        integer i2 = cp.RecordStart;
        integer i3 = cp.RecordEnd;
        
        ContactCreateNewController.Person pers = new ContactCreateNewController.Person();
        pers.ID = '123';
        pers.MDBContactID = '123';
        pers.Name = 'test';
        pers.firstName = 'Test';
        pers.lastName = 'test';
        pers.phoneNo = '1234567891';
        pers.email = 'sreenu.d@tcs.com';
        pers.company = 'Name';
        pers.BU = 'Salesforce.com';
        pers.score = '1';
        pers.sel = True;
        pers.personID = '123';
        
    }
    
    public static testmethod void testIDQContactcreation() {
        Account acc = new Account(Name='BANK OF MONTREAL', Sales_Org__c = 'WEST', Source__c = 'Practical Law', BillingCountry ='US', Phone = '91 80 67254199', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert acc;  
        contact cons = new Contact(FirstName = 'Test', LastName = 'Test', Email = 'test@tcs.com', AccountID = acc.Id);
        insert cons;
        set<string> conIds = new set<string>();
        conIds.add(cons.Id);     
        Contact con = new Contact(FirstName = 'Test', LastName = 'Test', Email = 'test@tcs.com', AccountID = acc.Id); 
        
         WebServiceSettings__c oIDQContactCreateSettings = new WebServiceSettings__c();
        oIDQContactCreateSettings.Name = ContactCreateNewController.ContactCreateinIDQ;
        oIDQContactCreateSettings.Endpoint__c = 'https:\\thomsonreuters.com';
        oIDQContactCreateSettings.Timeout__c = 5;
        oIDQContactCreateSettings.Active__c = true;
        oIDQContactCreateSettings.Service_Unavailable_Message__c = 'Service is currently unavailable';
        insert oIDQContactCreateSettings;
        
        PageReference oPageContact = Page.ContactCreateNew;
        Test.setCurrentPage(oPageContact);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(con);
        ContactCreateNewController ccCon = new ContactCreateNewController(oStandardController); 
        ccCon.selectedPersonID = '123';
        ccCon .updateisContactNewPersonId();
        ccCon .saveWithPerson(); 
        ccCon .queryContactsByMDBId(conIds);
        ccCon.fetchBU(acc);
        ccCon.reset();
        
    }  
}