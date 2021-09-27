/**
 * ODT_OnePassErrorINC Description
 *  DLT-20639 - 18-09-202 - Refactored Code ,Solved PMD violations ,,Removed Limit Condition
 */
public class ODT_OnePassErrorINC implements DataBase.Batchable < sObject > , Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select ID, Source_System_Detail__c, Email__c, First_Name__c, Last_Name__c, Primary_User__c, Trial__c, SapContactId__c, Trial__r.ODT_SAP_Account_Number__c, User_Auth_ID__c, One_Pass_Identifier__c, Service_Count__c, Trial__r.Profile_Type__c,
            Trial__r.Contact_LeadId__c, Trial__r.Id, Trial__r.Contact_LeadId__r.Company, Trial__r.Trial_Source__c, Trial__r.Trial_End_Date__c, Trial__r.Is_Lapsed__c, Trial__r.Trial_Start_Date__c, Trial__r.Trial_Id__c, GUID__c FROM Invite_Colleagues__c where Trial_Status__c = 'Entitlement Error' AND Trial__r.InvitedDateTime__c>=LAST_N_DAYS:7]);
  }

    public void execute(Database.BatchableContext bc, List < Invite_Colleagues__c > scope) {
        for (Invite_Colleagues__c ic: scope) {
            ODT_OnePassErrorService.checkError(null, ic, 'IC');
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.Debug('Invited Colleagues Batch completed');
    }

}