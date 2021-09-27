/*============================================================================================
    Name                : Digital_CohortWraooerrClass - wrapper class for Digital_Cohort_Initiation Class
    Description         : This class was created to fix PMD issues for Excessive Public Count

    DATE            DEVELOPER          CHANGE HISTORY
    31-12-2020      Brenda Shields     DLT-21098 Add option to run automation and post validation searately
==============================================================================================*/
public with sharing class Digital_CohortWrapperClass {

    // class wrapper for Digital_Cohort_Initiation
    // created to fix PMD ExcessivePublicCount
    public class CohortValidationWrapper {
      public String selName {get;set;}
      public String dsName {get;set;}
      public String selJob {get;set;}
      public String selSeg {get;set;}
      public String statusValue {get;set;}
      public Integer batchSize {get;set;}
      public list<Digital_Settings__c> dsSettingsList {get;set;}
      public list<SelectOption> digitalSettings{get;set;}
    }
    
}