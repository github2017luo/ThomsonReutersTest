/*****Change History *********************************************************************************************/
/*** JIRA           Created By     JIRA Description                                                            ***/
/*** DLT-11840     Bharat Bhushan   Delete Exception log older than 30 days job schedule test         ***/
/*****************************************************************************************************************/
@istest
private class Digital_DeleteDigiExLogSchedulable_Test {
    public static testmethod void ScheduleTest(){            
        
        DCTestData.createData();
        Test.StartTest();
        Digital_DeleteDigiExLogSchedulable sh1 = new Digital_DeleteDigiExLogSchedulable();      
        String sch = '0 0 23 * * ?';
        String jobid = system.schedule('Test check', sch, sh1);
        CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
        //For Assersion
        System.assertEquals(sch,ct.CronExpression);
        
        Test.stopTest();
        
    }
    
}