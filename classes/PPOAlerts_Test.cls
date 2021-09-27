/*
======================================================================================================================
TEST CLASS NAME: PPOAlerts_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the PPOAlerts class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@isTest

public class PPOAlerts_Test{

  public testmethod static void testPPOAlerts(){
   List<sobject> listKeyValues = new List<sobject>();
   
   listKeyValues.add(new KeyValueListStore__c(Name = 'PPOAlerts_LastRun',TextValue__c = String.valueof(System.now().addDays(-2))));
   listKeyValues.add(new KeyValueListStore__c(Name ='ANZUsersProfileId',TextValue__c ='00e30000001ZUki'));
   listKeyValues.add(new RecordtypeIds__c(Name='Pipeline Opportunities', recTypeId__c='01230000001MA4g'));
   listKeyValues.add(new RecordtypeIds__c(Name='Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4h'));
   insert listKeyValues;
    
   Account otestAcc = UnitTest.getAccountInstance();
   insert otestAcc;
   
   List<Opportunity> listOpportunities = new List<Opportunity>();
   Opportunity testPPO1 = UnitTest.getOpportunityInstance(otestAcc.Id);
   testPPO1.RecordTypeId='01230000001MA4h';
   
   Opportunity testPPO2 = UnitTest.getOpportunityInstance(otestAcc.Id);
   testPPO2.RecordTypeId='01230000001MA4h';
   
   listOpportunities.add(testPPO1);
   listOpportunities.add(testPPO2);
   
   Test.StartTest();
   insert listOpportunities; 
   PPOAlerts oPPOAlerts  = new PPOAlerts();
   database.executeBatch(oPPOAlerts);
       Test.StopTest();
   String teststr = [Select Id,TextValue__c from KeyValueListStore__c where Name = 'PPOAlerts_LastRun'].TextValue__c;
   System.assertEquals(Date.valueof(teststr),Date.valueof(System.today()),'Error' );

  
  }
  
  public testmethod  static void testscheduler(){
   List<sobject> listKeyValues = new List<sobject>();
   
   listKeyValues.add(new KeyValueListStore__c(Name = 'PPOAlerts_LastRun',TextValue__c = String.valueof(System.now().addDays(-2))));
   listKeyValues.add(new RecordtypeIds__c(Name='Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4h'));
   insert listKeyValues;
    Test.StartTest();
    PPOAlerts oPPOAlerts  = new PPOAlerts();
     SchedulableContext sc;
        oPPOAlerts.execute(sc);
           Test.StopTest();
  }
  

   public testmethod static void testPPOemails(){
    List<sobject> listKeyValues = new List<sobject>();
   
   listKeyValues.add(new KeyValueListStore__c(Name = 'PPOAlerts_LastRun',TextValue__c = String.valueof(System.now().addDays(-2))));
   listKeyValues.add(new KeyValueListStore__c(Name ='ANZUsersProfileId',TextValue__c ='00e30000001ZUki'));
   listKeyValues.add(new RecordtypeIds__c(Name='Pipeline Opportunities', recTypeId__c='01230000001MA4g'));
   listKeyValues.add(new RecordtypeIds__c(Name='Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4h'));
   insert listKeyValues; 
   User u1 = new User(alias = 'newTest1', email='userTest1@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='es', 
            localesidkey='es', profileid ='00e30000001gFez', employeenumber='01442222',
            timezonesidkey='America/Los_Angeles', username='userTest1@mydomain.com');        
   insert u1; 
   
   User u2 = new User(alias = 'newTest2', email='userTest2@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='pt_BR', 
            localesidkey='pt_BR', profileid ='00e30000001gFez', employeenumber='01442222',
            timezonesidkey='America/Los_Angeles', username='userTest2@mydomain.com');        
   insert u2; 
   
   
       Account otestAcc = UnitTest.getAccountInstance();
       insert otestAcc;
       
       List<Opportunity> listOpportunities = new List<Opportunity>();
       Opportunity testPPO1 = UnitTest.getOpportunityInstance(otestAcc.Id);
       testPPO1.RecordTypeId='01230000001MA4h';
       testPPO1.OwnerId = u1.Id;

       
       Opportunity testPPO2 = UnitTest.getOpportunityInstance(otestAcc.Id);
       testPPO2.RecordTypeId='01230000001MA4h';
       testPPO2.OwnerId = u2.Id;
       listOpportunities.add(testPPO1);
       listOpportunities.add(testPPO2);
       insert listOpportunities;
       
     
      Test.StartTest();
      
      PPOAlerts oPPOAlerts  = new PPOAlerts();
      database.executeBatch(oPPOAlerts);
      
      Test.StopTest();
      String teststr = [Select Id,TextValue__c from KeyValueListStore__c where Name = 'PPOAlerts_LastRun'].TextValue__c;
      System.assertEquals(Date.valueof(teststr),Date.valueof(System.today()),'Error' );

   
   }
   
}