@isTest
public class testTrainingEventContactUpdate
{
      
    public static testmethod void testTrainingEventConUpd()
    {
        Account account = UnitTest.getAccountInstance();
        account.Name = 'testAccount';
        account.Customer_Type__c = 'Induvidual';
        account.Customer_Group__c = 'ACADEMIC';
        account.Industry = 'Energy';
        account.SAPAccountNumber__c = '1000550771';
        insert account;
        
        Contact contact = UnitTest.getContactInstance(account.Id);
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        //contact.AccountId = account.Id;
        insert contact;
        
        Training_Event__c tEvnt = new Training_Event__c();
        tEvnt.Training_Name__c = 'Test Training Event';
        tEvnt.Training_Date__c = date.today();
        tEvnt.Status__c='Completed';
        tEvnt.Account__c =account.id;
        insert tEvnt;
        
        Training_Event_Contact__c tEvntCon = new Training_Event_Contact__c();
        tEvntCon.User_trained_Date__c =null;
        tEvntCon.Trained__c =false;
        tEvntCon.Training_Event__c =tEvnt.id;
        tEvntCon.Contact_Name__c = contact.id;
        insert tEvntCon;
        
        pageReference pgTrainingEventCon = page.updateTrainingContacts;
        Test.setCurrentPage(pgTrainingEventCon);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Training_Event__c(id=tEvnt.id));

        TrainingEventContactUpdate controller = new TrainingEventContactUpdate(sc);
        PageReference pgSave = controller.saveCon();
        
    }
}