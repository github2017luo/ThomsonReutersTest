@isTest(SeeAllData=false)
public class ESC_VSTSStagingScheduler_Test
{
    static testMethod void Method1()
    {
        test.startTest();
      ESC_ServiceNow_Scheduler_Settings__c sn= new ESC_ServiceNow_Scheduler_Settings__c();
      sn.Name='VSTS Scheduler Settings';
      
      ESC_VSTS_StagingBatch VSTSStag = new ESC_VSTS_StagingBatch();
      
    list<ApexClass> c=[SELECT id FROM ApexClass WHERE Name = 'ESC_VSTS_StagingBatch' AND (Status IN ('Queued','Processing','Preparing','Holding','Active')) Limit 1];
    
    System.debug('c@@'+c);
    
       ESC_VSTSStagingScheduler obj = new ESC_VSTSStagingScheduler();
       String schedule = '0 0 23 * * ?';
      system.schedule('Daily Schedule' , schedule, obj);
      test.stopTest();
    }
 }