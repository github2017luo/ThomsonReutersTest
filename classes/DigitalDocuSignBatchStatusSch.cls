/**
 * This class is designed to be utilized as a schedulable routine which is expected to run daily once.
 * This job creates DocuSign Envelopes for Quotes that meet specific criteria.
 */
/**
 * CHANGE HISTORY
 * =================================================================================================================
 * Date         Name                    Description
 * 2018-04-03   Brenda Shields          Scheduled Job to sync DocuSign Status for Voided envelopes to Salesforce
 * 2018-12-26   Bishanka Dassarma       DLT-14156- Fix Code Scan Security Issues
 * =================================================================================================================
 *
 * To schedule this job - run the following from the developer console - it will run every 6 hours
 *
 * DigitalDocuSignBatchStatusSch sch = new DigitalDocuSignBatchStatusSch();
 * sch.execute(null);
 * 
 */
global without sharing class DigitalDocuSignBatchStatusSch implements Schedulable{
  Integer intervalHours = Integer.valueof(System.label.Digital_Envelope_Schedule_Time.trim());

  global void execute(SchedulableContext sc) {
    DateTime now  = DateTime.now();        
        DateTime nextRunTime = now.addHours(intervalHours);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        if(!Test.isRunningTest()){
            //System.schedule(DigitalDocuSignBatchStatusSch.class.getName() + '-' + now.format(), cronString, new DigitalDocuSignBatchStatusSch());
        } 
    // when this job run, it will submit the batch job then delete this job
    // the batch job will re-submit itself to run in 15 minutes when it has finished processing
    // this causes the job to run every 15 minutes.    
        DigitalDocuSignBatchStatus dc = new DigitalDocuSignBatchStatus();
        Database.executeBatch(dc, 20);

        // Abort the current job
        if(sc != NULL){
            Id jobId = sc.getTriggerId();
            System.abortJob(jobId);
        }
     }
     
}