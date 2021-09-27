/**
     * @description Justdesc
     
     */
public without sharing class ESC_InvoiceSaveHelper2{
    ESC_AssociateInvoiceController invcon ;
    /**
     * @description Justdesc
     * @param pagiwrap
     * @param recid
     * @param showlinenumber
     * @return just
     */
    public List<ESC_Invoice_Item__c> createHANAClearInvoiceList(ESC_InvoiceListWrapper.Pagiwrapper pagiwrap,string recid,boolean showlinenumber){
        List<ESC_Invoice_Item__c> invoiceInsertlist = new List<ESC_Invoice_Item__c>();
        Map<String,ESC_Invoice_Item__c> invoicemap = new Map<String,ESC_Invoice_Item__c>();
        Case ca = new Case();
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(ca);
        invcon = new ESC_AssociateInvoiceController(stdcontroller);
        if(!showLineNumber){
            return new List<ESC_Invoice_Item__c>();
        }
        invoicemap = invcon.queryinvoicedata(showLineNumber,recid);
        system.debug(LoggingLevel.DEBUG, 'showlinenumber before is'+showLineNumber);
        
        system.debug(LoggingLevel.DEBUG, 'showlinenumber after is'+showLineNumber);
        for(List<ESC_InvoiceListWrapper.clearedwrapper> clearlist : pagiwrap.clearpagiwrap.clearwrapperlist1){
            for(ESC_InvoiceListWrapper.clearedwrapper clear : clearlist){
                if(clear.isSelected && Invoicemap != null && showLineNumber && !Invoicemap.containskey(clear.clearlist.document.additionalPdfDocumentId+clear.clearlist.lineNumber)){
                    ESC_Invoice_Item__c invoice = new ESC_Invoice_Item__c();
                    invoice.ESC_InvoiceNumber__c = clear.clearlist.document.additionalPdfDocumentId;
                    setClearInvoiceData(invoice,clear,showLineNumber);
                    invoice.ESC_Short_description__c = clear.clearlist.shortDescription;
                    invoice.ESC_Billing_date__c = clear.clearlist.baselineDate;
                    invoice.esc_case__c = recid;
                    invoice.ESC_Doc_Type__c = clear.clearlist.document.type;
                    invoice.ESC_Credit_Debit_Indicator__c  = clear.clearlist.debitCreditInd;
                    InvoiceInsertlist.add(invoice);
                    system.debug(LoggingLevel.WARN,'Invoice list is'+InvoiceInsertlist);                        
                    
                } 
                                         
            }
        }
        return  invoiceInsertlist;
    }
    /**
     * @description Justdesc
     * @param pagiwrap
     * @param recid
     * @param showlinenumber
     * @return just
     */

    public List<ESC_Invoice_Item__c> createSAPClearInvoiceList(ESC_InvoiceListWrapper.Pagiwrapper pagiwrap,string recid,boolean showlinenumber){
        List<ESC_Invoice_Item__c> invoiceInsertlist = new List<ESC_Invoice_Item__c>();
        Map<String,ESC_Invoice_Item__c> invoicemap = new Map<String,ESC_Invoice_Item__c>();
        if(showLineNumber){
            return new List<ESC_Invoice_Item__c>();
        }
        invoicemap = invcon.queryinvoicedata(showLineNumber,recid);
        system.debug(LoggingLevel.DEBUG, 'invoicemap is'+invoicemap);
        for(List<ESC_InvoiceListWrapper.clearedwrapper> clearlist : pagiwrap.clearpagiwrap.clearwrapperlist1){
            for(ESC_InvoiceListWrapper.clearedwrapper clear : clearlist){
                if(clear.isSelected && Invoicemap != null && !showLineNumber && !Invoicemap.containskey(clear.clearlist.clearingDocumentNumber)){
                    ESC_Invoice_Item__c invoice = new ESC_Invoice_Item__c();
                    invoice.ESC_InvoiceNumber__c = clear.clearlist.clearingDocumentNumber;
                    setClearInvoiceData(invoice,clear,showLineNumber);                    
                    invoice.ESC_Short_description__c = clear.clearlist.shortDescription;
                    invoice.ESC_Billing_date__c = clear.clearlist.baselineDate;
                    invoice.esc_case__c = recid;
                    invoice.ESC_Doc_Type__c = clear.clearlist.document.type;
                    invoice.ESC_Credit_Debit_Indicator__c  = clear.clearlist.debitCreditInd;
                    invoice.ESC_Dispute_Amount__c = clear.clearlist.disputeamount;
                    InvoiceInsertlist.add(invoice);
                    system.debug(LoggingLevel.WARN, 'Invoice list is'+InvoiceInsertlist);                        
                    
                } 
            }
        }
        return  invoiceInsertlist;
    }
    void setClearInvoiceData(ESC_Invoice_Item__c invoice,ESC_InvoiceListWrapper.clearedwrapper clear,boolean showLineNumber){
        if(showLineNumber){
            invoice.ESC_Line_number__c = (clear.clearlist.lineNumber != null ? Integer.valueof(clear.clearlist.lineNumber) : 0);
        }        
        invoice.ESC_Net_Amount__c = (clear.clearlist.amount != null ? Decimal.valueof(clear.clearlist.amount) : 0.00 );                    
        invoice.ESC_Net_arrears__c = (clear.clearlist.netArrers != null ? Decimal.valueof(clear.clearlist.netArrers) : 0.00 );
    }   
}