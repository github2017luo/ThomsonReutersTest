@isTest
public class testManageTopics
{
    public static testmethod void testManageTopics()
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
        
        List<Training_Topic__c> testlistTrainingTopics = new List<Training_Topic__c>();
        Training_Topic__c testTrainingTopic = new Training_Topic__c();
        testTrainingTopic.Category__c = 'BIGX';
        testTrainingTopic.Topic__c = 'BIGX';
        testlistTrainingTopics.add(testTrainingTopic);
        testTrainingTopic = new Training_Topic__c();
        testTrainingTopic.Category__c = 'NAL PRODUCTS';
        testTrainingTopic.Topic__c = 'PROV - PROVIEW';
        testlistTrainingTopics.add(testTrainingTopic);
        insert testlistTrainingTopics;
        
        pageReference pgManageTopics = page.ManageTopics;
        Test.setCurrentPage(pgManageTopics);
        ApexPages.currentPage().getParameters().put('Id', testTrainingEvent.Id);
        ApexPages.currentPage().getParameters().put('TECIds', testTrainingEventContact.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testTrainingEvent);
        
        ManageTopics controller = new ManageTopics(sc);
        list<SelectOption> liOptions = controller.getlistOperatorFields();
        liOptions = controller.getlistTrainingTopicFields();
        liOptions = controller.getlistCategories();
        PageReference pg = controller.findResults();
        //controller.sSelectedField5 = 'Category';
        //controller.sSelectedOperator5 = 'contains';
        controller.sSearchValue5 = 'NAL';
        controller.sSelectedField6 = 'Topic';
        controller.sSelectedOperator6 = 'starts with';
        controller.sSearchValue6 = 'PR';
        pg = controller.findResults();
        controller.listMatchingTopics[0].bSelected = true;
        pg = controller.AddTopicstoTraining();
        pg = controller.enterSelectedTopicsTab();
        pg = controller.enterAddTopicsTab();
        //pg = controller.RemovefromTraining();
    }
}