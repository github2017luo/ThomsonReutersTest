/**
 * ODT_OnePassQueueable Description
 *  DLT-20639 - 18-09-202 - Refactored Code ,Solved PMD violations ,Removed Limit Condition
 */
public class ODT_OnePassQueueable implements DataBase.Batchable < sObject > , Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select Id, Source_System_Detail__c, Profile_Type__c, Profile_ID__c, SAP_Promotion_Code__c, Lapsed_Reason_Code__c, Is_Lapsed__c, ODT_Email__c, Trial_Initiated_Account_Number__c, One_Pass_Identifier__c, User_Auth_ID__c,
            Source_System_Detail__r.Account_Name__c, Source_System_Detail__r.Account_Name__r.Name, Contact_id_SAP__c, Contact_LeadId__c, ODT_SAP_Account_Number__c, Trial_Id__c, ODT_Product_Bundle__c, ODT_Trial_Product_Category__c, Trial_Status__c,
            Trial_Source__c, Primary_User_First_Name__c, Primary_User_Last_Name__c, Service_Count__c, Contact_LeadId__r.Company, Trial_End_Date__c, Trial_Start_Date__c, GUID__c FROM Trial__c where trial_Status__C = 'Entitlement Error' AND InvitedDateTime__c>=LAST_N_DAYS:7]);
    }

    public void execute(Database.BatchableContext bc,List < Trial__c > scope) {
        for (Trial__c t: scope) {
            ODT_OnePassErrorService.checkError(t, null, 'Trial');
        }
    }

    public void finish(Database.BatchableContext bc) {
         DataBase.executeBatch(new ODT_OnePassErrorINC(), 1);
    }
}