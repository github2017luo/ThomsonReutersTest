@isTest
public class testMassEditTrainingContacts
{
    public static testmethod void testMassEditTrainingContacts()
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
            insert account;
        }
        else
        {
            account = listAccount[0];
        }
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.AccountId = account.Id;
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.MailingCity = 'London';
        insert contact;
        
        Contact contact2 = UnitTest.getContactInstance(account.Id);
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
        testTrainingEvent.Notes__c = 'test notes'; 
        testTrainingEvent.Training_Duration__c =2;
        insert testTrainingEvent;
        
               
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = account.Id;
        insert testTrainingEventAccount;
        
        List<Training_Event_Contact__c> listTrainingEventContact = new List<Training_Event_Contact__c>();
        Training_Event_Contact__c testTrainingEventContact = new Training_Event_Contact__c();
        testTrainingEventContact.Contact_Name__c = contact.Id;
        testTrainingEventContact.Training_Event__c = testTrainingEvent.Id;
        insert testTrainingEventContact;
        listTrainingEventContact.add(testTrainingEventContact);
        
        Training_Event_Contact__c testTrainingEventContact2 = new Training_Event_Contact__c();
        testTrainingEventContact2.Contact_Name__c = contact2.Id;
        testTrainingEventContact2.Training_Event__c = testTrainingEvent.Id;
        insert testTrainingEventContact2;
        listTrainingEventContact.add(testTrainingEventContact2);
        
        
        List<Training_Topic__c> testlistTrainingTopics = new List<Training_Topic__c>();
        Training_Topic__c testTrainingTopic = new Training_Topic__c();
        testTrainingTopic.Category__c = 'BIGX';
        testTrainingTopic.Topic__c = 'BIGX';
        testlistTrainingTopics.add(testTrainingTopic);
        testTrainingTopic = new Training_Topic__c();
        testTrainingTopic.Category__c = 'NAL PRODUCTS';
        testTrainingTopic.Topic__c = 'PROV - PROVIEW';
        testlistTrainingTopics.add(testTrainingTopic);
        testTrainingTopic = new Training_Topic__c();
        testTrainingTopic.Category__c = '1Point Online';
        testTrainingTopic.Topic__c = 'General Functionality';
        testlistTrainingTopics.add(testTrainingTopic);
        insert testlistTrainingTopics;        
        
        Training_Topic__c topc = new Training_Topic__c();
        topc.Topic__c ='1Point Online';
        topc.Category__c ='ANZ';
        insert topc;
        
        Training_Event_Topic__c tTopicCont = new Training_Event_Topic__c();
        tTopicCont.Training_Topic__c = topc.id;
        tTopicCont.Training_Event_Contact__c = testTrainingEventContact.id;
        insert tTopicCont;
        
        List<Training_Event_Contact__c> listTrainingEventContact1 = new List<Training_Event_Contact__c>();        
        
        pageReference pgMassEditTrainingContacts = page.massEditTrainingEventContacts;
        Test.setCurrentPage(pgMassEditTrainingContacts);
        ApexPages.currentPage().getParameters().put('id', testTrainingEvent.Id);
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(listTrainingEventContact1);
        sc1.setSelected(listTrainingEventContact1);              
        MassEditTrainingContacts controller1 = new MassEditTrainingContacts(sc1);
        controller1.toggleSort();
        
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listTrainingEventContact);
        sc.setSelected(listTrainingEventContact);                
        MassEditTrainingContacts controller = new MassEditTrainingContacts(sc);
        
        list<SelectOption> topicCategory= controller.getlistCategories();
        Test.StartTest();
        controller.setBool();
        controller.oPagingContacts.moveNext(); 
        controller.oPagingContacts.movePrev(); 
        String trngId= controller.getTrngEvntId();  
        PageReference pg1= controller.saveTopics();      
        controller.sSearchValue5= 'BIGX';
        controller.selTopics ='PROV - PROVIEW';
        controller.selTopicsList();
        PageReference pg2= controller.findResults();
        controller.listTrainingEventContacts[0].bSelected = true;
        //PageReference pg3= controller.saveTopics();
        controller.selTopics ='General Functionality';
        PageReference pg4= controller.saveTopics();
        controller.toggleSort();        
        date myDate = date.parse(controller.dTrainedDate);
        controller.listTrainingEventContacts[0].oTrainingEventContact.User_trained_Date__c=myDate ;
        controller.SaveAndReturn();
        controller.Save();
        controller.SaveMassDate();
        controller.tTopicDel ='BIGX';
        controller.tContactDel =testTrainingEventContact.id;
        controller.RemoveTrainingContactTopic();
        controller.RemoveSelected();
        Test.Stoptest();        
    }
    // added to cover lightning theme4d
     public static testmethod void testMassEditTrainingContacts1()
     
    {   
    User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserPreferencesLightningExperiencePreferred =true
            );
            insert u;
            
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
            insert account;
        }
        else
        {
            account = listAccount[0];
        }
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.AccountId = account.Id;
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.MailingCity = 'London';
        insert contact;
        
        Contact contact2 = UnitTest.getContactInstance(account.Id);
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
        testTrainingEvent.Notes__c = 'test notes';
        testTrainingEvent.Training_Duration__c =2;
        insert testTrainingEvent;
        
               
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = account.Id;
        insert testTrainingEventAccount;
        
        List<Training_Event_Contact__c> listTrainingEventContact = new List<Training_Event_Contact__c>();
        Training_Event_Contact__c testTrainingEventContact = new Training_Event_Contact__c();
        testTrainingEventContact.Contact_Name__c = contact.Id;
        testTrainingEventContact.Training_Event__c = testTrainingEvent.Id;
        insert testTrainingEventContact;
        listTrainingEventContact.add(testTrainingEventContact);
        
        Training_Event_Contact__c testTrainingEventContact2 = new Training_Event_Contact__c();
        testTrainingEventContact2.Contact_Name__c = contact2.Id;
        testTrainingEventContact2.Training_Event__c = testTrainingEvent.Id;
        insert testTrainingEventContact2;
        listTrainingEventContact.add(testTrainingEventContact2);
        
        List<Training_Event_Contact__c> listTrainingEventContact1 = new List<Training_Event_Contact__c>();        
        
        pageReference pgMassEditTrainingContacts = page.massEditTrainingEventContacts;
        Test.setCurrentPage(pgMassEditTrainingContacts);
        ApexPages.currentPage().getParameters().put('id', testTrainingEvent.Id);
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(listTrainingEventContact1);
        sc1.setSelected(listTrainingEventContact1);              
        MassEditTrainingContacts controller1 = new MassEditTrainingContacts(sc1);
        controller1.toggleSort();
        
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listTrainingEventContact);
        sc.setSelected(listTrainingEventContact);                
        MassEditTrainingContacts controller = new MassEditTrainingContacts(sc);
        controller.RemoveSelected(); 
         
        PageReference pg4= controller.saveTopics();
        
        controller.toggleSort(); 
        
         system.runAs(u){
                MassEditTrainingContacts.isTheme4d = true;
                Test.startTest();
                controller.SaveAndReturn();
                Test.stopTest();

            }
    }
    
    // added to cover negative scenario 
     public static testmethod void testMassEditTrainingContacts3()
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
            insert account;
        }
        else
        {
            account = listAccount[0];
        }
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.AccountId = account.Id;
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.MailingCity = 'London';
        insert contact;
        
        Contact contact2 = UnitTest.getContactInstance(account.Id);
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
        testTrainingEvent.Notes__c = 'test notes';
        testTrainingEvent.Training_Duration__c =2;
        insert testTrainingEvent;
        
               
        Training_Event_Account__c testTrainingEventAccount = new Training_Event_Account__c();
        testTrainingEventAccount.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventAccount.Account__c = account.Id;
        insert testTrainingEventAccount;
        
        List<Training_Event_Contact__c> listTrainingEventContact = new List<Training_Event_Contact__c>();
        Training_Event_Contact__c testTrainingEventContact = new Training_Event_Contact__c();
        testTrainingEventContact.Contact_Name__c = contact.Id;
        testTrainingEventContact.Training_Event__c = testTrainingEvent.Id;
        insert testTrainingEventContact;
        listTrainingEventContact.add(testTrainingEventContact);
        
        Training_Event_Contact__c testTrainingEventContact2 = new Training_Event_Contact__c();
        testTrainingEventContact2.Contact_Name__c = contact2.Id;
        testTrainingEventContact2.Training_Event__c = testTrainingEvent.Id;
        insert testTrainingEventContact2;
        listTrainingEventContact.add(testTrainingEventContact2);
        
        
        List<Training_Topic__c> testlistTrainingTopics = new List<Training_Topic__c>();
        Training_Topic__c testTrainingTopic = new Training_Topic__c();
        testTrainingTopic.Category__c = 'BIGX';
        testTrainingTopic.Topic__c = 'BIGX:';
        testlistTrainingTopics.add(testTrainingTopic);
        testTrainingTopic = new Training_Topic__c();
        testTrainingTopic.Category__c = 'NAL PRODUCTS';
        testTrainingTopic.Topic__c = 'PROV - PROVIEW';
        testlistTrainingTopics.add(testTrainingTopic);
        testTrainingTopic = new Training_Topic__c();
        testTrainingTopic.Category__c = '1Point Online';
        testTrainingTopic.Topic__c = 'General Functionality';
        testlistTrainingTopics.add(testTrainingTopic);
        insert testlistTrainingTopics;        
        
        Training_Topic__c topc = new Training_Topic__c();
        topc.Topic__c ='1Point Online';
        topc.Category__c ='ANZ';
        insert topc;
        
        Training_Event_Topic__c tTopicCont = new Training_Event_Topic__c();
        tTopicCont.Training_Topic__c = topc.id;
        tTopicCont.Training_Event_Contact__c = testTrainingEventContact.id;
        insert tTopicCont;
        
        List<Training_Event_Contact__c> listTrainingEventContact1 = new List<Training_Event_Contact__c>();        
        
        pageReference pgMassEditTrainingContacts = page.massEditTrainingEventContacts;
        Test.setCurrentPage(pgMassEditTrainingContacts);
        ApexPages.currentPage().getParameters().put('id', testTrainingEvent.Id);
        
        ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(listTrainingEventContact1);
        sc1.setSelected(listTrainingEventContact1);              
        MassEditTrainingContacts controller1 = new MassEditTrainingContacts(sc1);
        controller1.toggleSort();
        
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listTrainingEventContact);
        sc.setSelected(listTrainingEventContact);                
        MassEditTrainingContacts controller = new MassEditTrainingContacts(sc); 
        
        list<SelectOption> topicCategory= controller.getlistCategories();
        Test.startTest();
        controller.setBool();
        controller.oPagingContacts.moveNext(); 
        controller.oPagingContacts.movePrev(); 
        String trngId= controller.getTrngEvntId();  
        PageReference pg1= controller.saveTopics();      
        controller.sSearchValue5= 'BIGX';
        controller.selTopics ='PROV - PROVIEW';
        controller.selTopicsList();
        PageReference pg2= controller.findResults();
        controller.listTrainingEventContacts[0].bSelected =false;
        controller.tTopicDel ='BIGX';
        controller.tContactDel =testTrainingEventContact.id;
        controller.RemoveTrainingContactTopic();
        controller.RemoveSelected();       
        Test.stopTest();
    } 
}