/**
 * @description APTS_DocuSignEnvelRecpStatTriggerHandler
 */
public with sharing class APTS_DocuSignEnvelRecpStatTriggerHandler {
    /**
     * @description onAfterInsertUpdate
     * @param  docuSignEnvelopeRS
     */
    public static void adminAcceptprocess(List < Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c > docuSignEnvelopeRS) {
        List < Apttus_Proposal__Proposal__c > proposal = new List < Apttus_Proposal__Proposal__c > ();
        List < String > docuSignEnvelopeID = new List < String > ();
        List < Apttus_Proposal__Proposal__c > updateproposals = new List < Apttus_Proposal__Proposal__c > ();

        for (Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c docuSignE: docuSignEnvelopeRS) {
            if (docuSignE.Apttus_DocuApi__Status__c == 'Completed') {
                docuSignEnvelopeID.add(docuSignE.Apttus_DocuApi__EnvelopeParentId__c);
            }
        }
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()) {
            proposal = [SELECT id, Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__Proposal__c WHERE DocuSign_Envelope_ID__c IN: docuSignEnvelopeID];
        }
        for (Apttus_Proposal__Proposal__c pro: proposal) {
            //if(pro.Apttus_Proposal__Approval_Stage__c=='Presented')
            // {
            pro.APTS_DocuSign_Envelope_completed__c = true;
            updateproposals.add(pro);
            //}
        }
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable() && updateproposals != null) {
            update updateproposals;
        }
    }
    /**
     * @description exclusionframework
     * @param  docuSignEnvelopeRS
     */
    public static void exclusionframework(List < Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c > docuSignEnvelopeRS) {
        Boolean isBulkLoad = false;
        Boolean isTestrun = false;
           GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());
          if (loadValues != null && (loadValues.APTS_Disable_Triggers__c)) {
                isBulkLoad = true;
            }
        if (!Test.isRunningTest()) {
           isTestrun = false;
       //     GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());
            
        } else {
            isTestrun = true;
        }
        if (isTestrun || (isTestrun == false && isBulkLoad == false)) {
           APTS_DocuSignEnvelRecpStatTriggerHandler.adminAcceptprocess(docuSignEnvelopeRS);
        }
    }
}