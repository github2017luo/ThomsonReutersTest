/*****Change History *********************************************************************************************/
/*** JIRA           Created By     JIRA Description                                                            ***/
/*** DLT-10575      Harika Sai P   Duplicate automation jobs in Production if it run for more than day         ***/
/*** DLT-21366      Kavya S        PMD Fix     ***/
/*****************************************************************************************************************/
 /** 
 * @description : A test class for Digital_ProposalAutomationSchedulable
 */
@istest
private class Digital_PropAutomationSchedulable_Test{
/** 
     * @description :scheduletest
     */
    public static testmethod void scheduletest(){            
    DCTestData.createData();
    Test.StartTest();
    Digital_ProposalAutomationSchedulable sh1 = new Digital_ProposalAutomationSchedulable();      
    String sch = '0 0 23 * * ?';
    String jobid = system.schedule('Test check', sch, sh1);
    CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
    //For Assersion
    System.assertEquals(sch,ct.CronExpression,'Expected value');

    Test.stopTest();
    
    }
}