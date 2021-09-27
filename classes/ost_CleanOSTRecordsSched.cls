/**
 *  ost_CleanOSTRecordsSched
 *
 *  @description
 *      Schedulable class to clean old OST Time Log Records
 *
 *  @date - 19/JUNE/2015
 *  @author - Dan Reich: Traction on Demand
 */
global class ost_CleanOSTRecordsSched implements Schedulable {
    public static final String JOB_NAME = 'OST - CLEAN OLD RECORDS' + (Test.isRunningTest() ? ' TEST' : '');
    public static final String CRON_SCHED_NIGHTLY = '0 0 0 * * ?';
    public static final String CRON_SCHED_HOURLY = '0 0 * * * ?';
    private static final String SCHEDULED_JOB_TYPE_CODE = '7';
 
  
    public static Id scheduleNightly() {
        return System.schedule(JOB_NAME, CRON_SCHED_NIGHTLY, new ost_CleanOSTRecordsSched());
    }

    public static Id scheduleHourly() {
        return System.schedule(JOB_NAME, CRON_SCHED_HOURLY, new ost_CleanOSTRecordsSched());
    }


    public static Boolean isScheduled() {
        return getCronJobId() != null;
    }


    public static void unschedule() {
        Id cronJobId = getCronJobId();

        if(cronJobId != null) {
            system.abortJob(cronJobId);
        }
    }


    private static Id getCronJobId() {
        List<CronTrigger> cronJobs = [
            SELECT Id
            FROM CronTrigger
            WHERE CronJobDetail.Name = :JOB_NAME
              AND CronJobDetail.JobType = :SCHEDULED_JOB_TYPE_CODE
        ];

        if(cronJobs.isEmpty()) {
            return null;
        }

        return cronJobs[0].Id;
    }
    

    global void execute(SchedulableContext sc) {
        ost_DeleteClosedCaseOSTRecordsBatch.executeBatch();
    }
}