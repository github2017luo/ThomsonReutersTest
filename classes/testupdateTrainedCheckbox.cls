@isTest
public class testupdateTrainedCheckbox
{
    public static testmethod void testupdateTrainedCheckbox()
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
            insert account;
        }
        else
        {
            account = listAccount[0];
        }
        
        Contact contact = new Contact();
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.AccountId = account.Id;
        insert contact;
        
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        insert testTrainingEvent;
        
        Training_Event_Contact__c tec = new Training_Event_Contact__c();
        tec.Training_Event__c = testTrainingEvent.Id;
        tec.Contact_Name__c = contact.Id;
        tec.User_trained_Date__c = date.parse('12/12/2011');
        insert tec;
        
        tec.User_trained_Date__c = null;
        update tec;
        
        tec.User_trained_Date__c = date.parse('12/12/2100');
        update tec;
    }
}