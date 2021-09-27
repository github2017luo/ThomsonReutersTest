/***************************************************************************************************
    Trigger Name  : Digital_Cohort_SettingsCleanUp
    DESCRIPTION   : Triggers Functions needed to be done before deleting Digital Validation settings Records
====================================================================================================
    CUSTOM Functions ADDED
    1. Before Deletion it will delete all it related child records
    2. Before Deletion it will abort running jobs related to its record
====================================================================================================*/

trigger Digital_Cohort_SettingsCleanUp on Digital_Settings__c(before Delete) {

    public List < Digital_Customer__c > dcList = new List < Digital_Customer__c > ();
    public List < Digital_Message__c > dmList = new List < Digital_Message__c > ();

    if (trigger.isBefore && trigger.isDelete) {

        for (Digital_Settings__c ds: trigger.old) {

            // Stops Running Job related to this record
            if (ds.Batch_Id__c != null) {  System.abortJob(ds.Batch_Id__c);  }

            // Deletes its child records
            dcList = [Select Id from Digital_Customer__c where Digital_Settings__c =: ds.Id];
            dmList = [Select Id from Digital_Message__c where Digital_Settings__c =: ds.Id];
            if (!dcList.isEmpty()){
                Database.executeBatch(new Digital_Cohort_DeleteDigitalMessages(dcList, dmList));
            }
        }
    }
}