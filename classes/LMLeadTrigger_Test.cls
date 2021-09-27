@isTest
public class LMLeadTrigger_Test {
  static testMethod void excecuteTestclass(){ 
        Test.startTest();
        Account acc=new Account(Name= 'xyz',Country__c='AL');
        
        Lead leadRec = new Lead(Account__c = acc.id, firstName = 'John', company = 'Test Company', lastName = 'Smith', status = 'Marketing Qualified', ownerId = UserInfo.getUserId(), Country = 'USA');
        
 
        insert leadRec; 
        LTS_Disable_Application_Automation__c LTS= new LTS_Disable_Application_Automation__c();
        LTS.LTS_Disable_Triggers__c= true;
        insert LTS;
        update leadRec;
         Profile p = [SELECT Id FROM Profile WHERE Name='Eloqua Marketing']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', FirstName='SL',
            EmailEncodingKey='UTF-8', LastName='ELOQUA', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg11WE.com');
        
        System.runAs(u) {
      update leadRec;
        }
        Test.stopTest();

    }
}