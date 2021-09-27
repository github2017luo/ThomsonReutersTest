trigger APTS_DocuSignEnvelRecpStatTrigger on Apttus_DocuApi__DocuSignEnvelopeRecipientStatus__c (after insert,after update) {

    APTS_DocuSignEnvelRecpStatTriggerHandler.exclusionframework(Trigger.new);
}