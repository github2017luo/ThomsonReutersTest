@isTest
public class testManageContacts
{
    public static testmethod void testManageContacts()
    {
        List<Account> listAccount = new List<Account>();
        listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000550771'];
        Account account = new Account();
        if(listAccount.isEmpty())
        {
            account.Name = 'testAccount';
            account.Customer_Type__c = 'Induvidual';
            account.Customer_Group__c = 'ACADEMIC';
            account.Industry = 'Energy';
            account.SAPAccountNumber__c = '1000550771';
            account.BillingCity = 'London';
            insert account;
        }
        else
        {
            account = listAccount[0];
        }
        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.MailingCity = 'London';
        insert contact;
        
        Contact contact2 = new Contact();
        contact2.AccountId = account.Id;
        contact2.LastName = 'testContact2';
        contact2.FirstName = 'testContact2';
        contact2.MailingCity = 'London';
        insert contact2;
        
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        testTrainingEvent.Account_Level__c = true;
        testTrainingEvent.Account__c = account.Id;
        insert testTrainingEvent;
        
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = account.Id;
        insert testTrainingEventAccount;
        
        Training_Event_Contact__c testTrainingEventContact= new Training_Event_Contact__c();
        testTrainingEventContact.Contact_Name__c = contact.Id;
        testTrainingEventContact.Training_Event__c = testTrainingEvent.Id;
        insert testTrainingEventContact;
        
        pageReference pgManageContacts = page.ManageContacts;
        Test.setCurrentPage(pgManageContacts);
        ApexPages.currentPage().getParameters().put('Id', testTrainingEvent.Id);
        ApexPages.currentPage().getParameters().put('AccId', account.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testTrainingEvent);
        
        ManageContacts controller = new ManageContacts(sc);
        list<SelectOption> liOptions = controller.getlistOperatorFields();
        liOptions = controller.getlistContactFields();
        PageReference pg = controller.enterAddContactsTab();
        pg = controller.AddtoTraining();
        controller.sSelectedField2 = 'Last Name';
        controller.sSelectedOperator2 = 'contains';
        controller.sSearchValue2 = 'test';
        controller.sSelectedField9 = 'City ';
        controller.sSelectedOperator9 = 'starts with';
        controller.sSearchValue9 = 'Lon';
        pg =  controller.findResults();
        try{
        controller.listMatchingContacts[0].bSelected = true; 
        }
        catch(exception ex){
        }
        pg = controller.AddtoTraining();
        
        pg = controller.enterExistingContactsTab();
        controller.sSelectedField3 = 'Last Name';
        controller.sSelectedOperator3 = 'contains';
        controller.sSearchValue3 = 'test';
        controller.sSelectedField4 = 'City ';
        controller.sSelectedOperator4 = 'starts with';
        controller.sSearchValue4 = 'Lon';
        pg = controller.searchExistingContacts();
        pg = controller.AddTopics();
        pg = controller.RemovefromTraining();
        try{
        controller.listExistingMatchingContacts[0].bSelected = true;
        }
        catch(exception ex){
        }
        pg = controller.AddTopics();
        pg = controller.RemovefromTraining();
        Boolean b = controller.oExistingContactsCustomSetCon.gethasNext();
        pg = controller.Next();
        b = controller.oExistingContactsCustomSetCon.gethasPrevious();
        pg = controller.Previous(); 
        
        pg = controller.enterAddContactsTab();
        controller.sSelectedField2 = 'SAP Account Number';
        controller.sSelectedOperator2 = 'equals';
        controller.sSearchValue2 = 'test';        
        pg =  controller.findResults();
        controller.sSelectedField2 = 'Last Name';
        controller.sSelectedOperator2 = 'contains';
        controller.sSearchValue2 = 'test';
        controller.sSelectedField9 = 'City ';
        controller.sSelectedOperator9 = 'starts with';
        controller.sSearchValue9 = 'Lon';
        pg =  controller.findResults();
        try{
        controller.listMatchingContacts[0].bSelected = true; 
        }
        catch(exception ex){
        }
        pg = controller.AddtoTraining();
        b = controller.oMatchingContactsCustomSetCon.gethasNext();
        pg = controller.Next();
        b = controller.oMatchingContactsCustomSetCon.gethasPrevious();
        pg = controller.Previous();       
        
    }
}