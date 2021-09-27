trigger APTS_ContentDocumenLinkTrigger on ContentDocumentLink (after insert) {
    APTS_ContentDocumenLinkTriggerHandler.onAfterInsertContentDocuLink(Trigger.isAfter, Trigger.isInsert,Trigger.NewMap);  
}