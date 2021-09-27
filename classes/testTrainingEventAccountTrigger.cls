@isTest (seealldata = true)
public class testTrainingEventAccountTrigger
{
    public static testmethod void testTaskTriggerandEventTrigger()
    {
        //List<Account> listAccount = new List<Account>();
        //listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000550771'];
        Account account = new Account();       
        account.Name = 'testAccount';
        account.Customer_Type__c = 'Induvidual';
        account.Customer_Group__c = 'ACADEMIC';
        account.Industry = 'Energy';
        account.SAPAccountNumber__c = '8888888888';
        insert account;
        
        Account account2 = new Account();       
        account2.Name = 'testAccount';
        account2.Customer_Type__c = 'Induvidual';
        account2.Customer_Group__c = 'ACADEMIC';
        account2.Industry = 'Energy';
        account2.SAPAccountNumber__c = '9999999999';
        insert account2;
        
        Contact contact = new Contact();
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.AccountId = account.Id;
        insert contact;
        
        Contact contact2 = new Contact();
        contact2.LastName = 'testContact';
        contact2.FirstName = 'testContact';
        contact2.AccountId = account2.Id;
        insert contact2;
        
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        
        /*Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = account.Id;
        insert testTrainingEventAccount;*/
        List<Training_Event_Contact__c> testlistTrainingEventContact = new List<Training_Event_Contact__c>();
        Training_Event_Contact__c testTrainingEventContact= new Training_Event_Contact__c();
        testTrainingEventContact.Contact_Name__c = contact.Id;
        testTrainingEventContact.Training_Event__c = testTrainingEvent.Id;
        testlistTrainingEventContact.add(testTrainingEventContact);
        Training_Event_Contact__c testTrainingEventContact2 = new Training_Event_Contact__c();
        testTrainingEventContact2.Contact_Name__c = contact2.Id;
        testTrainingEventContact2.Training_Event__c = testTrainingEvent.Id;
        testlistTrainingEventContact.add(testTrainingEventContact2);
        insert testlistTrainingEventContact;
        
        delete testTrainingEventContact;
        delete testTrainingEventContact2;
    }
}