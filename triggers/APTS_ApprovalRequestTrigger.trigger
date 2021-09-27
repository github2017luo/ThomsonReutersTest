/* APTS_ApprovalRequestTrigger
 * Trigger on Apttus_Approval__Approval_Request__c
 *
 * Developer: Akshay Mewada, APTTUS
 * Business Owner: 
 *
 * Scenario:
 * 
 * 
 *
 * History:
 
 * 08/11/2016, Akshay Mewada, APTTUS - created APTS_ApprovalRequestTrigger.
 */
trigger APTS_ApprovalRequestTrigger on Apttus_Approval__Approval_Request__c (before insert, before update) {
    public static boolean beforeUpdate = false;
    public static boolean beforeinsert = false;
    APTS_ApprovalRequestTriggerHelper helper = new APTS_ApprovalRequestTriggerHelper();

    if(Trigger.isBefore && Trigger.isInsert)
    {
        if (!beforeinsert){
            beforeinsert = True;
            helper.populateQuoteOnApprovalRequest(Trigger.new);
            helper.updateOnHold(Trigger.new);
        }
    }
    if(Trigger.isBefore && Trigger.isUpdate)
    {
         if (!beforeUpdate){
            beforeUpdate = True;
            helper.populateQuoteOnApprovalRequest(Trigger.new);
            helper.updateOnHold(Trigger.new);
         }
    }
}