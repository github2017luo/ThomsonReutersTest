/**
     * @description Justdesc
     *
     */
public without sharing class ESC_Invoicehelper{
    Map<String,ESC_Invoice_Item__c> invoicemap;
    List<ESC_Invoice_Item__c> invoiceInsertlist;
    String invoicenumber;
    /**
     * @description Justdesc
     * @return just
     */
    public class Openinvpagiwrapper{
        /**
     * @description Justdesc
     * @return just
     */
        public list<ESC_InvoiceListWrapper.openwrapper> openwrapperlist2{get;set;}
        /**
     * @description Justdesc
     * @return just
     */
        public paginate paginater{get;set;}
        /**
     * @description Justdesc
     * @return just
     */
        public List<list<ESC_InvoiceListWrapper.openwrapper>> openwrapperlist1{get;set;}
        /**
     * @description Justdesc
     * @param openwrapperlist2
     * @param paginater
     * @param openwrapperlist1
     * 
     */
        public openinvpagiwrapper(list<ESC_InvoiceListWrapper.openwrapper> openwrapperlist2,paginate paginater,List<list<ESC_InvoiceListWrapper.openwrapper>> openwrapperlist1){
            this.openwrapperlist2 = openwrapperlist2;
            this.paginater = paginater;
            this.openwrapperlist1 = openwrapperlist1;
        }
    }
    /**
     * @description Justdesc
     * @return just
     */
    public class Clearinvpagiwrapper{
        /**
     * @description Justdesc
     * @return just
     */
        public list<ESC_InvoiceListWrapper.clearedwrapper> clearwrapperlist2{get;set;}
        /**
     * @description Justdesc
     * @return just
     */
        public paginate clearpaginater{get;set;}
        /**
     * @description Justdesc
     * @return just
     */
        public List<list<ESC_InvoiceListWrapper.clearedwrapper>> clearwrapperlist1{get;set;}      
          /**
     * @description Justdesc
     * @param clearwrapperlist2
     * @param clearpaginater
     * @param clearwrapperlist1
     */
        public clearinvpagiwrapper(list<ESC_InvoiceListWrapper.clearedwrapper> clearwrapperlist2,paginate clearpaginater,List<list<ESC_InvoiceListWrapper.clearedwrapper>> clearwrapperlist1){
            this.clearwrapperlist2= clearwrapperlist2;
            this.clearpaginater = clearpaginater;
            this.clearwrapperlist1 = clearwrapperlist1;
        }
    }
    
    void queryinvoicedata(boolean showlinenumber,String caseid){
        invoicemap = new Map<String,ESC_Invoice_Item__c>();
        if (Schema.sObjectType.ESC_Invoice_Item__c.isAccessible()){
            for(ESC_Invoice_Item__c invitem : [Select ESC_InvoiceNumber__c,ESC_Line_number__c,ESC_Net_Amount__c from ESC_Invoice_Item__c where ESC_Case__c =:caseid]){
                
                system.debug(LoggingLevel.DEBUG,'invitem is'+invitem+'***'+showlinenumber);
                if(showLineNumber){
                    Invoicemap.put(invitem.ESC_InvoiceNumber__c+string.valueof(invitem.ESC_Line_number__c),invitem);
                }
                else{
                    system.debug(LoggingLevel.DEBUG,'in else'+invitem.ESC_InvoiceNumber__c);
                    Invoicemap.put(invitem.ESC_InvoiceNumber__c,invitem);
                }
            }
        }
    }
    
    boolean validate(ESC_InvoiceListWrapper.Pagiwrapper pagiwrap){
        boolean isselected = false;
        for(List<ESC_InvoiceListWrapper.openwrapper> openlist:pagiwrap.openpagiwrap.openwrapperlist1){
        for(ESC_InvoiceListWrapper.openwrapper open:openlist){
            if(open.isSelected){
                isselected = true;
            }
        }
        }
        
        for(List<ESC_InvoiceListWrapper.clearedwrapper> clearlist : pagiwrap.clearpagiwrap.clearwrapperlist1){
            for(ESC_InvoiceListWrapper.clearedwrapper clear:clearlist){
            if(clear.isSelected){
                isselected = true;
            }
            }
        }
         
        if(isselected == false){
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_Noinvoiceerror));
            return false;
        }   
        return true;
    }
    /**
     * @description Justdesc
     @param recid
     * @param showlinenumber
     * @param pagiwrap
     * @return yo
     */
    public boolean saveInvoices(String recid,boolean showlinenumber,ESC_InvoiceListWrapper.Pagiwrapper pagiwrap){
        String invoicenumber = '';
        String newinvoicenumber = '';
        Case caseAcc;
        boolean issuccess = false;        
        ESC_InvoiceSaveHelper1 invhelper1 = new ESC_InvoiceSaveHelper1();
        
        queryinvoicedata(showlinenumber,recid);
        if (Schema.sObjectType.Case.isAccessible()){         
            caseAcc = [Select Id,CaseNumber,BU_Segment__c,LCRM_Sub_BU__c,USL_SAP_Account_Number__c,ESC_Invoice_Numbers__c FROM Case where id =:recid];
        }
        invoicenumber = caseAcc.ESC_Invoice_Numbers__c ;        
        system.debug(LoggingLevel.DEBUG,'invoice number before adding'+invoicenumber);                        
        issuccess = setInvoicelist(recid,showLineNumber,pagiwrap);
        system.debug(LoggingLevel.DEBUG,'is success'+issuccess);
        if(!issuccess ){
            return false;
        }
        if(Schema.sObjectType.ESC_Invoice_Item__c.isCreateable() && InvoiceInsertlist.size() > 0){                
            database.insert(InvoiceInsertlist,false);
        }
        if(!showlinenumber){
            newinvoicenumber = invhelper1.setSAPinvoicenumber(InvoiceInsertlist,showlinenumber);
        }
        else{ 
        newinvoicenumber = invhelper1.setHANAinvoicenumber(InvoiceInsertlist,showlinenumber);
        }
        system.debug(LoggingLevel.DEBUG,'invoice number is'+invoicenumber+'****'+newinvoicenumber);
        if(invoicenumber == '' || invoicenumber == null){
            invoicenumber = newinvoicenumber;
            system.debug(LoggingLevel.DEBUG,'in if');
        }
        else{
            invoicenumber = invoicenumber +','+ newinvoicenumber;
        }
        Case caseupd = new Case();
        caseupd.id = recid;
        system.debug(LoggingLevel.DEBUG,'invoicenumbers are'+invoicenumber);
        caseupd.ESC_Invoice_Numbers__c = invoicenumber;
        if(Schema.sObjectType.Case.isUpdateable()){
            update caseupd;
        }
        issuccess = true;
        return issuccess;
    } 
    
    boolean setInvoicelist(String recid,boolean showlinenumber,ESC_InvoiceListWrapper.Pagiwrapper pagiwrap){
        ESC_InvoiceSaveHelper1 invhelper1 = new ESC_InvoiceSaveHelper1();
        ESC_InvoiceSaveHelper2 invhelper2 = new ESC_InvoiceSaveHelper2();
        invoiceInsertlist = new List<ESC_Invoice_Item__c> ();
        if(validate(pagiwrap)){
            if(invhelper1.createHANAOpenInvoiceList(pagiwrap,recid,showLineNumber) != null) {           
                invoiceInsertlist.addall(invhelper1.createHANAOpenInvoiceList(pagiwrap,recid,showLineNumber));
            }
            if(invhelper1.createSAPOpenInvoiceList(pagiwrap,recid,showLineNumber) != null){
                invoiceInsertlist.addall(invhelper1.createSAPOpenInvoiceList(pagiwrap,recid,showLineNumber));
            }
            system.debug(LoggingLevel.DEBUG,'test 33');
            if(invhelper2.createHANAClearInvoiceList(pagiwrap,recid,showLineNumber)!= null){
                invoiceInsertlist.addall(invhelper2.createHANAClearInvoiceList(pagiwrap,recid,showLineNumber)); 
            }
            system.debug(LoggingLevel.DEBUG,'test 11');
            if(invhelper2.createSAPClearInvoiceList(pagiwrap,recid,showLineNumber) != null){
                invoiceInsertlist.addall(invhelper2.createSAPClearInvoiceList(pagiwrap,recid,showLineNumber));
            }
            system.debug(LoggingLevel.DEBUG,'test 22');
            return true;
        }
        else{
            return false;
        }
        
    }
}