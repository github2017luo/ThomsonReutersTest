trigger TaxDocumentTrigger on Tax_Document__c (after delete) {

    TaxDocumentTriggerHandler.updateTaxDocumentType(trigger.old);    
}