/*** Change History
 * Created By Divija Salla DLT-14203 Automation of Docusign
 *
 * DocuSign has a processing limit of 1,000 records per hour.  We have hit that limit during processing.  This job
 * was created to manage that limit.  It will process the quotes in batches of 999 and re-schedule this job for 
 * 1 hour intervals.  Processing 999 quotes each time.  When there are less then 999 quotes to process, 
 * this job will no longer be re-scheduled and the final run of the job will complete all the quotes to be processed.
 * Note: Not all quotes may be processed as some contain errors and are picked up each time the job runs.  
 *
 * Date         Name                    Description
 * 2019-02-14   Navleen Kaur            DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 2019-07-30   Brenda Shields          DLT-17319 - Do not schedule this job if there are less than 999 quotes to process 
 * 2019-09-19   Benjamin Her            DLT-17530 - Removed redundent call to DCQuote_Automation_Update() class
 * 2020-07-08   Brenda Shields          DLT-20312 - Created custom label to hold the number of envelopes we should create per hour
***/

public without sharing class Digital_DocusignSchedulable implements Schedulable{
    integer docusignjobhours = Integer.valueof(system.label.Digital_Docusign_Schedule.trim());
    // define how many DocuSign envelopes we can create per hour - currently limited to 700
    integer docusignEnvelopesPerHr = integer.valueof(system.label.Digital_DocuSign_Envelopes_Per_Hr.trim());
    integer iNumQuotes;
    
    public void execute(SchedulableContext scContext) {
        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addHours(docusignjobhours);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
            iNumQuotes = [Select count()
                          FROM Apttus_Proposal__Proposal__c WHERE is_Digital_Channel__c = true
                          AND APTS_Order_Confirmation_Contact_Name__c != null AND APTS_Order_Confirmation_Contact_Email__c != null  
                          AND APTS_Order_Confirmation_Contact__c != null AND DocuSign_Envelope_ID__c = ''
                          AND Apttus_Proposal__Approval_Stage__c = 'Generated' 
                          AND Digital_Quote_Automation__c = true
                          AND Digital_Quote_Type__c in ('Best Value','Best Value+Config','Premium','Straight Renewal')
                          AND Digital_Envelope_Created__c = false];
            } 
                               
        System.debug('Quote count: ' + iNumQuotes);
		// DocuSign has a limit that they can only process 1000 envelopes per hour
		// we need to schedule less than that in order to allow other processes to create envelopes 
        if (!Test.isRunningTest() && iNumQuotes > docusignEnvelopesPerHr) {
            // Schedule this class to run again in an hour to pick up the quotes over 999
            Id sId = System.schedule(Digital_DocusignSchedulable.class.getName() + '-' + now.format(), cronString, new Digital_DocusignSchedulable());
            system.debug('sId>>' + sId);
        }
        //Call to DCQuote_Automation_Update.AutomationrecordUpdate() is a redundent as DigitalDocusignEnvelopeCreation also calls this class.
        /* else { //if (iNumQuotes == 0) {
            system.debug('entered');
            // call the class to update the Quote_Automation_Cycle__c object
            // we don't want to call this class if wer are running multiple batches of quotes
            //DCQuote_Automation_Update.AutomationrecordUpdate();  
        }*/
       // String cronString = '0 120 * * * ? *'; 
        
        // Delete the current job as it's not needed
        if (scContext != NULL) {
            Id jobId = scContext.getTriggerId();
            System.abortJob(jobId);
        }
        
        // Run the job to process up to 999 quotes that need to go to DocuSign 
        //if (!Test.isRunningTest()) {
            DigitalDocuSignEnvelopeCreation ddc = new DigitalDocuSignEnvelopeCreation();
            Database.executeBatch(ddc, 15);
        //}
     }

}