/********************************************************************************
 Class Name  : Digital_Cohort_DcCreation
 Description : Creates Digital Customer records based on Digital Subscription Data

 CHANGE HISTORY
 ==============================================================================
 Date            Name                    Jira             Description
 31-05-2020      Rahul Natarajan         DLT-18904        Created For CXD Project
 *********************************************************************************/
public without sharing class Digital_Cohort_DcCreation{
    @AuraEnabled
    public static Boolean dsCreation(String dsId, List<Product_Account_Detail__c> dsDataList){
        Boolean result = false;
        try{
            final String dataRecordType = 'Cohorts';
            final String createdJobStatus = 'Created';
            final String startedJobStatus = 'Started';
            final String inProgressJobStatus = 'In Progress';
            final String dataLoadDataStatus = 'Data Load';
            final String postCohortsDataStatus = 'Post-CohortsJob';
            final String preCohortsDataStatus = 'Pre-CohortsJob';
            List<Digital_Settings__c> dsSettingsList = new List<Digital_Settings__c>();
            Digital_Settings__c ds = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c
                                      from Digital_Settings__c
                                      where Id = :dsId and RecordTypeId = :Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get(dataRecordType).getRecordTypeId()][0];
            //DS data can also be sent from List button from DS Data Object List,if its not sent, it will consider to take all DS records satisifying below condition and checks Segment as well
            if (dsDataList == null){
                dsDataList = [SELECT Bypass_Automation__c, Id, Renewal_Date__c, ZP_Cust_Number__c
                              FROM Product_Account_Detail__c
                              WHERE Renewal_Date__c > Today AND Bypass_Automation__c = False AND Digital_Firm__c = :ds.Segment__c];
            } else{
                for (Product_Account_Detail__c dsData : dsDataList){
                    if (dsData.Digital_Firm__c != ds.Segment__c){
                        dsDataList.remove(dsDataList.indexOf(dsData));
                    }
                }
            }
            // Checks Digital Settings records,if any other job is in progress
            if (Schema.sObjectType.Digital_Settings__c.isQueryable()){
                dsSettingsList = [Select Id, Name, Class__c, Batch_Size__c, Batch_Id__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c
                                  from Digital_Settings__c
                                  where Id != :dsId and (Job_Status__c = :startedJobStatus or Job_Status__c = :inProgressJobStatus) and RecordTypeId = :Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get(dataRecordType).getRecordTypeId()];
            }
            // If current DS seetings record is not created and If any other Digital Settings Status is in Progress, it wont be triggered
            if ((ds.Job_Status__c == createdJobStatus) && (dsSettingsList.isEmpty())){
                result = true;
                if (ds.Data_Status__c == dataLoadDataStatus){
                     if(!test.isrunningtest()){ ds.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_SSDCheck(ds), Integer.valueOf(ds.Batch_Size__c)));}
                } else if (ds.Data_Status__c == postCohortsDataStatus){
                 if(!test.isrunningtest()){ dcCreation(dsId, dsDataList); Database.executeBatch(new Digital_OpportunityDigitalFlagSync(), 1); }
                } else if (ds.Data_Status__c == preCohortsDataStatus){
                   dcCreation(dsId, dsDataList);
                 if(!test.isrunningtest()){  ds.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_SSDCheck(ds), Integer.valueOf(ds.Batch_Size__c))); }
                }
                if (Schema.sObjectType.Digital_Settings__c.isUpdateable()){
                    ds.Completion__c = 1;
                    ds.Start_Time__c = Datetime.now();
                    ds.Job_Status__c = startedJobStatus;
                    update ds;
                }
            }
        } catch (Exception e){
            if (Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
                Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
                ex.Exception_Message__c = e.getMessage();
                ex.Exception_Type__c = e.getStackTraceString();
                ex.Additional_Information__c = String.valueof(e.getLineNumber());
                ex.User_Message__c = String.valueof(e.getCause());
                ex.Class_Reference__c = 'Digital_Cohort_DcCreation > Execute';
                insert ex;
            }
        }
        return result;
    }

    @AuraEnabled
    public static void dcCreation(String dsId, List<Product_Account_Detail__c> dsList){
        //Takes Unique ZP Customer numbrs from all DS data and creates Digital Customers
        Set<String> sapnumbers = new Set<String>();
        List<Digital_Customer__c> dclist = new List<Digital_Customer__c>();
        for (Product_Account_Detail__c ds : dslist){
            sapnumbers.add(ds.ZP_Cust_Number__c);
        }
        for (String sapnumber : sapnumbers){
            dclist.add(new Digital_Customer__c(Digital_Settings__c = dsId, SAP_Number__c = sapnumber, Has_DSdata__c = true));
        }
        if (Schema.sObjectType.Digital_Customer__c.isCreateable()){
            insert dclist;
        }
    }
}