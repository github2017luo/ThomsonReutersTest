/*************************************************************
@Name:           LATAM_ScheduleBatchToCreateIndicatorTest
@Author:         Harshpreet Singh
@CreateDate:     12/1/2019
@Test Class For: LATAM_ScheduleBatchToCreateIndicator
************************************************************/
@isTest
private class LATAM_ScheduleBatchToCreateIndicatorTest
{    
    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';        
        // Create your test data
        Apttus_Config2__AssetLineItem__c AssetLI=new Apttus_Config2__AssetLineItem__c();
        AssetLI.name= 'test';
        AssetLI.Apttus_Config2__AssetStatus__c = 'Activated';
        insert AssetLI;
        
        Test.startTest();        
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new LATAM_ScheduleBatchToCreateIndicator());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();        
    }
}