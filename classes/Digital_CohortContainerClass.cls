/*============================================================================================
    Name                : Digital_CohortContainerClass - wrapper class for Digital_Cohort_Initiation Class
    Description         : This class was created to fix PMD issues for Excessive Public Count

    DATE            DEVELOPER          CHANGE HISTORY
    31-12-2020      Brenda Shields     DLT-21098 Add option to run automation and post validation searately
==============================================================================================*/
public with sharing class Digital_CohortContainerClass {

    // Fields used to display the status of the Digital Automation jobs
    public class JobsAutomation {
    
        public string jobName {get;set;}
        public string jobStatus {get;set;}
        public integer totalBatches {get;set;}
        public integer processedBatches {get;set;}
        public string createdDate {get;set;}
        public string createdName {get;set;}
        public string completedDate {get;set;}
        public string extStatus {get;set;}
        
        // constructor to build record
        public JobsAutomation(string name, AsyncApexJob oJob) {
            jobName = name;
            // set all values to help test class coverage
            jobStatus = '';
            totalBatches = null;
            processedBatches = null;
            createdDate = '';
            createdName = '';
            completedDate = '';
            extStatus = '';

            if (oJob != null) {
                jobStatus = oJob.Status;
                totalBatches = oJob.TotalJobItems;
                processedBatches = oJob.JobItemsProcessed;
                if (oJob.CreatedDate != null) {
                	createdDate = oJob.CreatedDate.format('MM/dd/yyyy HH:mm:ss a');
                }                	
                createdName = oJob.CreatedBy.Name;
                if (oJob.CompletedDate != null) {
                	completedDate = oJob.CompletedDate.format('MM/dd/yyyy HH:mm:ss a');
                }
                extStatus = oJob.ExtendedStatus;
            }
        } 
    }
    
}