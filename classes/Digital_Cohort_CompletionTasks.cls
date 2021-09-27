/***************************************************************************************************
 CLASS NAME  : Digital_Cohort_CompletionTasks
 DESCRIPTION : Does Completion Tasks after Cohort Execution Done
 ====================================================================================================
 CUSTOM TASKS ADDED
 ====================================================================================================
 S.NO      TASK
 1         Sends One List of Digital Messages, Digital Exception Logs in Mail
 2         Creates One Attachment Of Digital Messages,Digital Exception Logs on its Digital Settings on Attachments Related List
 4         Enables Completion Check on DigitalSettings , DigitalCustomer, DigitalMessages Object
 5         Deletes DigitalCustomer & Digital Messages of digital Settings records other than last 3 created ones
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 ====================================================================================================
 ***************************************************************************************************/
public without sharing class Digital_Cohort_CompletionTasks{
    String dsId;
    //Creates Cohort Result and Digital Exception Log Attachment and Sends in Mail
    public void sendcompletionemail(String dsSettingsId){
        this.dsId = dsSettingsId;
        Digital_Settings__c dso = [Select Id, OwnerId, Name, Start_Time__c, End_Time__c
                                   from Digital_Settings__c
                                   where Id = :dsId][0];
        try{
            String templateId = [SELECT Id
                                 FROM EmailTemplate
                                 where DeveloperName = 'Digital_Cohort_EmailTemplate' and isActive = true].id;
            List<Digital_Message__c> dmMessages = [Select Id, Email_Sent__c, Name, Digital_Customer__c, Digital_Settings__c, Message__c, URL_1__c, URL_2__c, Digital_Customer__r.SAP_Number__c, Digital_Customer__r.Total_Messages__c, Digital_Customer__r.Customer_SSD__r.Name, Digital_Settings__r.Name, Digital_Settings__r.Data_Status__c, Digital_Settings__r.Total_Customers__c, Digital_Settings__r.Total_Messages__c
                                                   from Digital_Message__c
                                                   where Digital_Settings__c = :dsId and Email_Sent__c = false and CreatedById = :dso.OwnerId
                                                   ORDER BY Digital_Customer__r.Total_Messages__c DESC
                                                   NULLS LAST];
            List<Digital_Exception_Log__c> deLogs = [Select Id, Name, Exception_Message__c, Additional_Information__c, Exception_Type__c, User_Message__c, Class_Reference__c, Object__c, Record_Id__c
                                                     from Digital_Exception_Log__c
                                                     where CreatedById = :dso.OwnerId and CreatedDate > :dso.Start_Time__c and CreatedDate < :dso.End_Time__c
                                                     ORDER BY Name ASC
                                                     NULLS LAST];
            List<Attachment> attachmentList = new List<Attachment>();
            List<String> mailToAddresses = new List<String>();
            List<User> users = [SELECT Email
                                FROM User
                                WHERE Id IN (
                                SELECT UserOrGroupId
                                FROM GroupMember
                                WHERE Group.Name = 'CX Digital Support') and ( NOT Email LIKE '%invalid%')];
            for (User u : users){
                mailToAddresses.add(u.email);
            }
            if (!dmMessages.isEmpty()){
                String header = 'SAP NUMBER, SSD NAME, OBJECT, MESSAGE, URL 1, URL 2\n';
                String finalStr = header;
                for (Digital_Message__c dm : dmMessages){
                    String record = dm.Digital_Customer__r.SAP_Number__c + ',' + dm.Digital_Customer__r.Customer_SSD__r.Name + ',' + dm.Name + ',' + dm.Message__c + ',' + dm.URL_1__c + ',' + dm.URL_2__c + '\n';
                    finalStr = finalStr + record;
                }
                Map<String, String> attachFiles = new Map<String, String>();
                attachFiles.put(dso.Name + '-Digital Cohort Report', finalstr);
                for (String name : attachFiles.keySet()){
                    blob csvBlob = Blob.valueOf(attachFiles.get(name));
                    Attachment a = new Attachment();
                    a.Body = csvBlob;
                    a.ParentId = dsId;
                    a.Name = dso.Name + '-Digital Cohort Report.csv';
                    a.ContentType = 'text/csv';
                    attachmentList.add(a);
                }
            }
            if (!deLogs.isEmpty()){
                String header = 'Id ,Name ,Exception Message ,Additional Information ,Exception Type ,User Message ,Class Reference ,Object Type ,Record Id\n';
                String finalStr = header;
                for (Digital_Exception_Log__c de : deLogs){
                    String record = de.Id + ',' + de.Name + ',' + de.Exception_Message__c + ',' + de.Additional_Information__c + ',' + de.Exception_Type__c + ',' + de.User_Message__c + ',' + de.Class_Reference__c + ',' + de.Object__c + ',' + de.Record_Id__c + '\n';
                    finalStr = finalStr + record;
                }
                Map<String, String> attachFiles = new Map<String, String>();
                attachFiles.put(dso.Name + '-Digital Exception Logs', finalstr);
                for (String name : attachFiles.keySet()){
                    blob csvBlob = Blob.valueOf(attachFiles.get(name));
                    Attachment a = new Attachment();
                    a.Body = csvBlob;
                    a.ParentId = dsId;
                    a.Name = dso.Name + '-Digital Exception Logs.csv';
                    a.ContentType = 'text/csv';
                    attachmentList.add(a);
                }
            }


            OrgWideEmailAddress owa = new OrgWideEmailAddress();
            owa = [select id, DisplayName, Address
                   from OrgWideEmailAddress
                   where Address = 'tcs-cxd-appsupport@thomsonreuters.com'];
            Messaging.SingleEmailMessage cohortMessage = new Messaging.SingleEmailMessage();
            cohortMessage.setCcAddresses(mailToAddresses);
            List<string> toemailaddress = new List<string>();
            toemailaddress.add(Userinfo.getUserEmail());
            cohortMessage.setToAddresses(toemailaddress);
            cohortMessage.setTemplateId(templateId);
            cohortMessage.setTargetObjectId(dso.OwnerId);
            cohortMessage.setWhatId(dsId);
            cohortMessage.setOrgWideEmailAddressId(owa.id);
            cohortMessage.setSaveAsActivity(false);
            if (!attachmentList.isEmpty()){
                insert attachmentList;
                List<Messaging.EmailFileAttachment> cohortemailattachments = new List<Messaging.EmailFileAttachment>();
                for (Attachment acs : attachmentList){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(acs.Name);
                    efa.setBody(acs.Body);
                    efa.setContentType(acs.ContentType);
                    cohortemailattachments.add(efa);
                }
                cohortMessage.setFileAttachments(cohortemailattachments);
            }
            cohortMessage.setUseSignature(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{cohortMessage});
            enableCompletionchecks(dsId);
            deleteOldDigitalData();
        } catch (Exception e){ Digital_Exception_Log__c ex = new Digital_Exception_Log__c();  ex.Exception_Message__c = e.getMessage();   ex.Exception_Type__c = e.getStackTraceString();  ex.Additional_Information__c = String.valueof(e.getLineNumber());   ex.User_Message__c = String.valueof(e.getCause()); ex.Class_Reference__c = 'Digital_Cohort_CompletionTasks > Execute'; insert ex; }
    }

    // Changes Boolean flag on records as completed
    public void enableCompletionchecks(String dsId){
        List<Digital_Customer__c> dsCustomers = [Select Id, Cohort_Execution__c
                                                 from Digital_Customer__c
                                                 where Digital_Settings__c = :dsId];
        if (!dsCustomers.isEmpty()){
            for (Digital_Customer__c ds : dsCustomers){
                ds.Cohort_Execution__c = true;
            }
            update dsCustomers;
        }
        List<Digital_Message__c> dsMessages = [Select Id, Email_Sent__c
                                               from Digital_Message__c
                                               where Digital_Settings__c = :dsId];
        if (!dsMessages.isEmpty()){
            for (Digital_Message__c ds : dsMessages){
                ds.Email_Sent__c = true;
            }
            update dsMessages;
        }
    }

    //Delete Digital Records not related to last 3 created settings records
    public void deleteOldDigitalData(){
        List<Digital_Settings__c> dsList = [SELECT Id
                                            FROM Digital_Settings__c
                                            ORDER BY CreatedDate DESC
                                            NULLS LAST];
        if (dsList.size() > 2){
            List<String> dsIds = new List<String>();
            List<Digital_Customer__c> dcDeleteList = new List<Digital_Customer__c>();
            List<Digital_Message__c> dmDeleteList = new List<Digital_Message__c>();
            for (Integer i = 3; i < dsList.size(); i++){
                dsIds.add(dsList[i].Id);
            }
            if (!dsIds.isEmpty()){
                for (String dsI : dsIds){
                    List<Digital_Customer__c> deleteDc = [Select Id
                                                          from Digital_Customer__c
                                                          where Digital_Settings__c = :dsI];
                    List<Digital_Message__c> deleteDm = [Select Id
                                                         from Digital_Message__c
                                                         where Digital_Settings__c = :dsI];
                    if (!deleteDc.isEmpty()){
                        for (Digital_Customer__c dDc : deleteDc){
                            dcDeleteList.add(dDc);
                        }
                    }
                    if (!deleteDm.isEmpty()){
                        for (Digital_Message__c dDc : deleteDm){
                            dmDeleteList.add(dDc);
                        }
                    }
                }
                if (!dcDeleteList.isEmpty()){
                    Database.executeBatch(new Digital_Cohort_DeleteDigitalMessages(dcDeleteList, dmDeleteList));
                }
            }
        }
    }
}