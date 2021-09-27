/*
 * This class is designed to be utilized as a schedulable routine which is expected to run daily once.
 * This job creates DocuSign Envelopes for Quotes that meet specific criteria.
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Jira Story #: DLT-1514
 * Date         Name                    Description
 * 2017-07-11   Dinesh Kumar            Scheduled Job which runs once in a day
                                        Triggers DigitalDocuSignEnvelopeCreation Batch job 
 * =============================================================================
 */
global without sharing class DigitalDocuSignEnvelopeSchedulable implements Schedulable{
    Integer intervalHours = Integer.valueof(System.label.Digital_Envelope_Schedule_Time.trim());
     global void execute(SchedulableContext scContext) {
        DateTime now  = DateTime.now();        
        DateTime nextRunTime = now.addHours(intervalHours);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        if(!Test.isRunningTest()){
            System.schedule(DigitalDocuSignEnvelopeSchedulable.class.getName() + '-' + now.format(), cronString, new DigitalDocuSignEnvelopeSchedulable());
        }          
           
        // Abort the current job
        if(scContext != NULL){
            Id jobId = scContext.getTriggerId();
            System.abortJob(jobId);
        }
        
        DigitalDocuSignEnvelopeCreation dc = new DigitalDocuSignEnvelopeCreation();
        Database.executeBatch(dc, 1);
     }
}