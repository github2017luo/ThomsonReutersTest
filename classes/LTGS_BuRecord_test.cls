/* Class: LTGS_BuRecord_test
* Purpose: Test class for the Controller class LTGS_BuRecord
* Created: 25/3/2019
* Author: Samarpreet

* CHANGE HISTORY
* ==========================================================================================================
*  Date          Name                 Description
*  2019-03-07    Samarpreet            Initial Version
* ==========================================================================================================

*/
@isTest
public class LTGS_BuRecord_test {
    
    static testMethod void testData() {
        Profile p = [SELECT Id FROM profile WHERE name='GLI Helpdesk Agent'];   
        User user1 = new User(alias = 'newfg15', email='news2E1995@mydomain.com', 
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                              localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Infrequent_User__c=true,Infrequent_User_Timeout__c=2
                              , Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='newsS2e195@mydomain.com',Rep_Type_Description__c='test');        
        
        insert user1;
        
        Test.startTest();
        
        System.runAs(user1) {
            LTGS_BuRecord.UserProfileName();
            Boolean isGLI=LTGS_BuRecord.GLIServiceUserCheck(); 
        }
        Test.stopTest();  
        
    }
}