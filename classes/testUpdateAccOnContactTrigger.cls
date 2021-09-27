@isTest
public class testUpdateAccOnContactTrigger
{
    public static testmethod void testUpdateAccOnContactTrigger()
    {
        Account account = UnitTest.getAccountInstance();       
        account.Name = 'testAccount';
        account.Customer_Type__c = 'Induvidual';
        account.Customer_Group__c = 'ACADEMIC';
        account.Industry = 'Energy';
        account.SAPAccountNumber__c = '8888888888';
        insert account;
        
        Contact contact = new Contact();
        contact.LastName = 'testContact';
        contact.FirstName = 'testContact';
        //contact.AccountId = account.Id;
        insert contact;
        
        Course__c tCourse = new Course__c();
        tCourse.Account_Name__c =account.id;
        //tCourse.name= 'testCourse';
        tCourse.Contact_Name__c = contact.id;
        
        insert tCourse;
        
        }
}