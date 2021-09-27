@isTest(SeeAllData=false)
public class ESC_ServiceNowStagingScheduler_Test{

  testMethod static void Method2(){
      test.startTest();
      ESC_ServiceNow_Scheduler_Settings__c objcus= new ESC_ServiceNow_Scheduler_Settings__c();
      objcus.Name='ServiceNowSettings';
      
      ESC_ServiceNowStagingBatch snowstag = new ESC_ServiceNowStagingBatch();
      
    list<ApexClass> c=[SELECT id FROM ApexClass WHERE Name = 'ESC_ServiceNowStagingBatch' AND (Status IN ('Queued','Processing','Preparing','Holding','Active')) Limit 1];
    
    System.debug('c@@'+c);
    
       ESC_ServiceNowStagingScheduler obj1 = new ESC_ServiceNowStagingScheduler();
       String schedule = '0 0 23 * * ?';
      system.schedule('Daily Schedule' , schedule, obj1);
      test.stopTest();
 }
}