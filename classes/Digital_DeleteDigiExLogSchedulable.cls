/*
 * This class is designed to be utilized as a schedulable routine which is expected to run weekly once over the weekend.
 * This job delete all Digital Exception Logs which are older than 30 days.
 */
/**
 * CHANGE HISTORY
 * =============================================================================================================
 * Jira Story#: DLT-11840
 * Date         Name                    Description
 * 2018-08-27   Bharat Bhushan          Scheduled Job which runs weekly once in the weekend (Every Saturday)
                                        Triggers Digital_DeleteDigitalExceptionLogs Batch job 
 * =============================================================================================================
 */
global class Digital_DeleteDigiExLogSchedulable implements Schedulable {
    Integer intervalDays = Integer.valueof(System.label.Digital_Delete_Log_Schedule_Time.trim());
    global void execute(SchedulableContext scContext){
        DateTime now  = DateTime.now();        
        DateTime nextRunTime = now.addHours(intervalDays);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        if(!Test.isRunningTest()){
            System.schedule(Digital_DeleteDigiExLogSchedulable.class.getName() + '-' + now.format(), cronString, new Digital_DeleteDigiExLogSchedulable());
        }          
           
        // Abort the current job
        if(scContext != NULL){
            Id jobId = scContext.getTriggerId();
            System.abortJob(jobId);
        }
        
        Digital_DeleteDigitalExceptionLogs dlog = new Digital_DeleteDigitalExceptionLogs();
        Database.executeBatch(dlog, 1);
     }

}