/*
@Comment Apex class : Test_PB_Training_Event_Send_Survey is used to test process builder named 'Training Event Send Survey'
@description Apex class : Test_PB_Training_Event_Send_Survey is used to test process builder named 'Training Event Send Survey'
*/
@istest
public class Test_PB_Training_Event_Send_Survey {
    
    /*
@Comment Apex Method : Exclusion method
@description Apex Method : Exclusion method
*/
    @istest static void testExclusion(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp_PB';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Account  account = new Account();
        account.Name = 'testAccount';
        account.Customer_Type__c = 'Induvidual';
        account.Customer_Group__c = 'ACADEMIC';
        account.Industry = 'Energy';
        account.SAPAccountNumber__c = '1000550771';
        account.Is_GLI__c = true;
        insert account;
        
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
        
        system.assertEquals(contact2!=null, true, 'Contact Id is created');        
        Training_Event__c testTrainingEvent = new Training_Event__c();
        testTrainingEvent.Training_Name__c = 'testTrainingEvent';
        testTrainingEvent.Training_Date__c = System.Today();
        testTrainingEvent.Status__c = 'Pending';
        testTrainingEvent.Account_Level__c = true;
        testTrainingEvent.Account__c = account.Id;        
        testTrainingEvent.Notes__c = 'test notes'; 
        testTrainingEvent.Training_Duration__c =2;
        testTrainingEvent.LCRM_Is_GLI__c = true;
        insert testTrainingEvent;   
        
        
        
        Training_Event_Contact__c testTrainingEventContact = new Training_Event_Contact__c();
        testTrainingEventContact.Contact_Name__c = contact.Id;
        testTrainingEventContact.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventContact.LCRM_Send_Survey__c = true;
        insert testTrainingEventContact;
        
        
        Training_Event_Contact__c testTrainingEventContact2 = new Training_Event_Contact__c();
        testTrainingEventContact2.Contact_Name__c = contact2.Id;
        testTrainingEventContact2.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventContact.LCRM_Send_Survey__c = true;
        insert testTrainingEventContact2;
    }
    /*
@Comment Apex Method : survey method
@description Apex Method : survey method
*/
    @istest static void testTrainingEventContactProcessBuilder(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp_PB';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        
        Account  account = new Account();
        account.Name = 'testAccount';
        account.Customer_Type__c = 'Induvidual';
        account.Customer_Group__c = 'ACADEMIC';
        account.Industry = 'Energy';
        account.SAPAccountNumber__c = '1000550771';
        account.Is_GLI__c = true;
        insert account;
        
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.AccountId = account.Id;
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        contact.MailingCity = 'London';
        insert contact;
        system.assertEquals(contact!=null, true, 'Contact Id is created');   
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
        testTrainingEvent.LCRM_Is_GLI__c = true;
        insert testTrainingEvent;   
        
        
        
        Training_Event_Contact__c testTrainingEventContact = new Training_Event_Contact__c();
        testTrainingEventContact.Contact_Name__c = contact.Id;
        testTrainingEventContact.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventContact.LCRM_Send_Survey__c = true;
        insert testTrainingEventContact;
        
        
        Training_Event_Contact__c testTrainingEventContact2 = new Training_Event_Contact__c();
        testTrainingEventContact2.Contact_Name__c = contact2.Id;
        testTrainingEventContact2.Training_Event__c = testTrainingEvent.Id;
        testTrainingEventContact.LCRM_Send_Survey__c = true;
        insert testTrainingEventContact2;
    }
    
    
}