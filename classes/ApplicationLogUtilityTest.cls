@isTest
public class ApplicationLogUtilityTest {

   public static testMethod void loggingTest() {
    
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
     User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='user@mydomain.com',Rep_Type_Description__c='test');        
        insert u1;
        
     
     system.runAs(u1){
         Account a = new Account(Name = 'Test Account');
         insert a;
         system.assertEquals(a.Name,'Test Account');
         test.startTest();
         ApplicationLogUtility.logException('Test Application','Test Class','Test Method','','','Testing Logging Framework','Calling Log exception method with all parameters','Application','',a.id);
         ApplicationLogUtility.logBatch('Test Batch Application','Test Batch Class','Test Batch Method','Testing Logging Framework','Calling logBatch method');
         ApplicationLogUtility.logCallout('Test Batch Application','Test Batch Class','Test Batch Method','Test Web Service','https;//www.google.com','Testing Logging Framework','Calling logcallout method'); 
         test.stopTest();
     }
  }
    
    public static testMethod void logExceptionTest() {
    
     Exception exp;
     Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
     User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', Sub_Bu__c = 'Elite',timezonesidkey='America/Los_Angeles', username='user@mydomain.com',Rep_Type_Description__c='test');        
        insert u1;
        
     
     system.runAs(u1){
         try{
             Account a = [Select id,Name from Account];
             
         }catch(Exception ex){
             exp=ex;
         }
         system.assertNotEquals(exp,null);
         ApplicationLogUtility.logException('Test Application','Test Class','Test Method',exp);
         ApplicationLogUtility.logBatchException('Test Application','Test Class','Test Method',exp);
         ApplicationLogUtility.logCalloutException('Test Application','Test Class','Test Method','Test Web Service','https;//www.google.com',exp);
         ApplicationLogUtility.logExceptionWithTag('Test Application','Test Class','Test Method',exp,'Calling Tags method');
        }
    }
    
 
}