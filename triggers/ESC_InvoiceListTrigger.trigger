trigger ESC_InvoiceListTrigger on ESC_Invoice_Item__c (before delete) {
    ESC_UpdateInvoiceonCase.updateinvoice(trigger.old);

}