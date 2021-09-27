/**
     * @description Justdesc
     * 
     */
public without sharing class ESC_InvoiceSaveHelper1{
    ESC_AssociateInvoiceController invcon ;
    /**
     * @description Justdesc
     * @param pagiwrap
     * @param recid
     * @param showlinenumber
     * @return just
     */
    public List<ESC_Invoice_Item__c> createHANAOpenInvoiceList(ESC_InvoiceListWrapper.Pagiwrapper pagiwrap,string recid,boolean showlinenumber){        
        List<ESC_Invoice_Item__c> invoiceInsertlist = new List<ESC_Invoice_Item__c>();
        Map<String,ESC_Invoice_Item__c> invoicemap = new Map<String,ESC_Invoice_Item__c>();
        Case ca = new Case();
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(ca);
        invcon = new ESC_AssociateInvoiceController(stdcontroller);
        if(!showLineNumber){
            return new List<ESC_Invoice_Item__c>();
        }
        invoicemap = invcon.queryinvoicedata(showLineNumber,recid);
        
        for(List<ESC_InvoiceListWrapper.openwrapper> openlist:pagiwrap.openpagiwrap.openwrapperlist1){
            system.debug(LoggingLevel.DEBUG, 'open list11 is'+openlist+'**'+showLineNumber);
            for(ESC_InvoiceListWrapper.openwrapper open:openlist){                 
                system.debug(LoggingLevel.DEBUG , 'open lsit is'+open);
                if(open != null && open.isSelected && Invoicemap != null && showLineNumber && !Invoicemap.containskey(open.openlist.document.docNumber+open.openlist.lineNumber)){
                    ESC_Invoice_Item__c invoice = new ESC_Invoice_Item__c();
                    invoice.ESC_Short_description__c = open.openlist.shortDescription;
                    invoice.ESC_Billing_date__c = open.openlist.baselineDate;
                    invoice.ESC_Doc_Type__c = open.openlist.document.type;
                    invoice.ESC_Credit_Debit_Indicator__c = open.openlist.debitCreditInd;
                    invoice.esc_case__c = recid;
                    invoice.ESC_InvoiceNumber__c = open.openlist.document.docNumber;                    
                    setopeninvoicedata(invoice,open,showLineNumber);                    
                    
                    system.debug(LoggingLevel.DEBUG, 'invoicenumber is'+open.openlist.document.docNumber);
                    invoiceInsertlist.add(invoice);
                    
                }               
            }
        }
        return invoiceInsertlist;
    }   
    /**
     * @description Justdesc
     * @param pagiwrap
     * @param recid
     * @param showlinenumber
     * @return just
     */
    public List<ESC_Invoice_Item__c> createSAPOpenInvoiceList(ESC_InvoiceListWrapper.Pagiwrapper pagiwrap,string recid,boolean showlinenumber){        
        List<ESC_Invoice_Item__c> invoiceInsertlist = new List<ESC_Invoice_Item__c>();
        Map<String,ESC_Invoice_Item__c> invoicemap = new Map<String,ESC_Invoice_Item__c>();
        if(showLineNumber){
            return new List<ESC_Invoice_Item__c>();
        }
        invoicemap = invcon.queryinvoicedata(showLineNumber,recid);
        
        for(List<ESC_InvoiceListWrapper.openwrapper> openlist:pagiwrap.openpagiwrap.openwrapperlist1){
            for(ESC_InvoiceListWrapper.openwrapper open:openlist){                 
                
                if(open.isSelected && Invoicemap != null && !showLineNumber && !Invoicemap.containskey(open.openlist.document.docNumber)){
                    ESC_Invoice_Item__c invoice = new ESC_Invoice_Item__c();
                    invoice.ESC_InvoiceNumber__c = open.openlist.document.docNumber;
                    setopeninvoicedata(invoice,open,showLineNumber);                    
                    invoice.ESC_Short_description__c = open.openlist.shortDescription;
                    invoice.ESC_Billing_date__c = open.openlist.baselineDate;
                    invoice.ESC_Doc_Type__c = open.openlist.document.type;
                    invoice.ESC_Credit_Debit_Indicator__c = open.openlist.debitCreditInd;
                    invoice.esc_case__c = recid;
                    invoice.ESC_Dispute_Amount__c = open.openlist.disputeamount;                    
                    invoiceInsertlist.add(invoice);
                }
            }
        }
        return  invoiceInsertlist;       
    }
    void setOpenInvoiceData(ESC_Invoice_Item__c invoice,ESC_InvoiceListWrapper.openwrapper open,boolean showlinenumber){
        if(showLineNumber){
            invoice.ESC_Line_number__c = (open.openlist.lineNumber != null ? Integer.valueof(open.openlist.lineNumber) : 0);
        }        
        invoice.ESC_Net_Amount__c = (open.openlist.amount != null ? Decimal.valueof(open.openlist.amount) : 0.00);
        invoice.ESC_Net_arrears__c = (open.openlist.netArrers != null ? Decimal.valueof(open.openlist.netArrers) : 0.00);
    }
       /**
     * @description Justdesc
     * @param invoiceInsertlist
     * @param showlinenumber
     * @return just
     */                                                   
    public string setSAPinvoicenumber(List<ESC_Invoice_Item__c> invoiceInsertlist,boolean showlinenumber){
        string invoicenumber = '';
        for(ESC_Invoice_Item__c invitem : invoiceInsertlist){
            if(invoicenumber == ''){
                invoicenumber = invitem.ESC_InvoiceNumber__c  ;
            }
            else if(invoicenumber != ''){
                invoicenumber = invoicenumber + ',' + invitem.ESC_InvoiceNumber__c  ;
            }            
        }
        return invoicenumber;
    }
    /**
     * @description Justdesc
     * @param invoiceInsertlist
     * @param showlinenumber
     * @return just
     */

    public string setHANAinvoicenumber(List<ESC_Invoice_Item__c> invoiceInsertlist,boolean showlinenumber){
        string invoicenumber = '';
        for(ESC_Invoice_Item__c invitem : invoiceInsertlist){
            if(invoicenumber == ''){
                invoicenumber = invitem.ESC_InvoiceNumber__c + '-' + invitem.ESC_Line_number__c ;
            }
            else if(invoicenumber != ''){
                invoicenumber = invoicenumber + ',' + invitem.ESC_InvoiceNumber__c + '-' + invitem.ESC_Line_number__c ;
            }            
        }
        return invoicenumber;
    }
    
    
}