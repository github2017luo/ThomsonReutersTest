/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ProposalWebService {
    global ProposalWebService() {

    }
    webService static Boolean afterClone(Id originalId, Id cloneId) {
        return null;
    }
    webService static Boolean afterCreateFromAccount(Id proposalId) {
        return null;
    }
    webService static Boolean afterCreateFromOpportunity(Id proposalId) {
        return null;
    }
    global static Boolean afterCreateFromProposal(Apttus_Proposal__Proposal__c proposalSO, Apttus__APTS_Agreement__c agreementSO) {
        return null;
    }
    webService static Boolean afterEmailTemplateClone(Id originalId, Id cloneId) {
        return null;
    }
    webService static Boolean afterPresent(Id proposalId) {
        return null;
    }
    webService static String buildEmailAuthorPageURL(Id sObjectId, Id tempEmailTemplateId) {
        return null;
    }
    webService static Id cloneEmailTemplate(Id originalId) {
        return null;
    }
    webService static Apttus_Proposal__Proposal__c cloneProposal(Id originalId) {
        return null;
    }
    webService static Boolean copyAttachment(Id destParentId, Id attId) {
        return null;
    }
    webService static Apttus_Proposal__Proposal__c createProposalFromAccount(Id accountId, Id recordTypeId) {
        return null;
    }
    webService static Apttus_Proposal__Proposal__c createProposalFromOpportunity(Id opptyId, Id recordTypeId) {
        return null;
    }
    webService static Boolean deleteEmailTemplate(Id templateId) {
        return null;
    }
    global static String encryptText(String text) {
        return null;
    }
    webService static Apttus_Proposal__Proposal_Document_Output_Format__c getDefaultOutputFormat(Id profileId, Id recordTypeId) {
        return null;
    }
    webService static List<Apttus__APTS_Template__c> getTemplatesForProposal(Id proposalId, String proposalType) {
        return null;
    }
    webService static String selectFirstTemplateNameForProposal(Id proposalId) {
        return null;
    }
    webService static Boolean updateProposal(Apttus_Proposal__Proposal__c proposalSO) {
        return null;
    }
}
