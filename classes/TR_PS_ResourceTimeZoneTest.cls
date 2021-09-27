@isTest
private class TR_PS_ResourceTimeZoneTest {
@isTest
    private static void testCase(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        UserRole psRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];// Updated this method to fix test class error for CRM-1324
        User u1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            u1 = new User(alias = 'newUser1', email='user12@mydomain12.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', timezonesidkey='America/Los_Angeles', username='usertest123@mydomain.com.prod',UserRoleId = psRole.Id);        
        insert u1;
        }
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.BillingStreet = '123 Unit Test Street';
        oAccount.BillingCity='Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '75006';
        oAccount.BillingCountry='US';
        insert oAccount;
        Contact con = new Contact(
          pse__Allow_Timecards_Without_Assignment__c = true,  // Allow Timecards Without Assignment
          pse__Is_Resource__c = true,                         // Is Resource
          pse__Is_Resource_Active__c = true,
          FirstName = 'Generic',
          LastName  = 'PS EXECUTIVE LEADER',
          pse__Salesforce_User__c = u1.id
          
      );
        test.startTest();
        insert con;
        Map<String, Object> params = new Map<String, Object>();
            params.put('contactId', con.id);
                 
            Flow.Interview.TR_PS_Enterprise_Update_Timezone_On_Contact calTimeZone = new Flow.Interview.TR_PS_Enterprise_Update_Timezone_On_Contact(params);
            calTimeZone.start();
        test.stopTest();
        
        contact conAfterUpdate = [select id,TR_PS_Enterprise_Resource_TimeZone__c from contact where id =: con.Id];
        System.assertEquals('America/Los_Angeles', conAfterUpdate.TR_PS_Enterprise_Resource_TimeZone__c);
        
     }
}