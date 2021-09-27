@isTest
public class testTrainingEventDetailController
{
    public static testmethod void testTrainingEventDetailController()
    {
        Test.startTest();
        List<Account> listAccount = new List<Account>();
        listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000550771'];
        Account account = UnitTest.getAccountInstance();
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
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.MailingCity = 'London';
        insert contact;
        
        Contact contact2 = UnitTest.getContactInstance(account.Id);
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
        testTrainingEvent.Notes__c = 'test notes'; 
        testTrainingEvent.Training_Duration__c =2;
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
        Test.stopTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testTrainingEvent);
        
        TrainingEventDetailController controller = new TrainingEventDetailController(sc);
        
        controller.TrainingEventId =testTrainingEvent.id;
        Boolean teaccess =controller.Trainingeventrecordaccess();
        System.assertEquals(teaccess,true); 
        controller.activePswd = false;
        list<SelectOption> filterOption= controller.getlistOperatorFields();
        filterOption = controller.getlistContactFields();
        list<SelectOption> topicCategory= controller.getlistCategories();
        PageReference pg1= controller.AddtoTraining();
        controller.sSearchKey = 'testContact2';      
        controller.selTopics = 'BIGX';
        controller.sSearchValue5= 'BIGX';
        PageReference pg2=  controller.findContacts();
        PageReference pg3=  controller.findResults();
        if(controller.listMatchingContacts[0]!=null){
        controller.listMatchingContacts[0].bSelected = true;
        }
        PageReference pg4= controller.AddtoTraining();       
        
        controller.ListSelectedfilter[0].sSelectedField ='First Name';
        controller.ListSelectedfilter[0].sSelectedOperator ='contains';
        controller.ListSelectedfilter[0].sSelectedValue ='test';
        PageReference pg5=  controller.findContacts();
          
        
        PageReference pg6=  controller.addTask();
        PageReference pg7=  controller.addEvent();
        //controller.toggleSort();
        PageReference pg8=  controller.addFilter();
        controller.oPagingContacts.moveNext(); 
        controller.oPagingContacts.movePrev(); 
       
        
    }
    public static testmethod void testTrainingEventrecordaccess()
    {
        Profile p = [SELECT Id FROM Profile WHERE  Name='GLI Sales User'];
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users']; 
        User u = new User(Alias = 'test', Email='testuser@thomsonreuters.com',EmailEncodingKey ='UTF-8', LastName ='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',UserName='testuser@trpcorelegal.com');
        insert u;
         PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = trainingPermissionSet.Id, AssigneeId = u.Id);
        insert psa; 
       
        system.runas(u)
        {
        List<Account> listAccount = new List<Account>();
        listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000550771'];
        Account account = UnitTest.getAccountInstance();
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
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.MailingCity = 'London';
        insert contact;
        
        Contact contact2 = UnitTest.getContactInstance(account.Id);
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
        testTrainingEvent.Notes__c = 'test notes'; 
        testTrainingEvent.Training_Duration__c =2;
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
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testTrainingEvent);
        
        TrainingEventDetailController controller = new TrainingEventDetailController(sc);
        
        controller.TrainingEventId =testTrainingEvent.id;
        Boolean teaccess =controller.Trainingeventrecordaccess();
        System.assertEquals(teaccess,true); 
        
       
        
    }
    }
}