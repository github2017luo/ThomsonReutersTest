@istest
public class USLARdetailwrapper_test {
    
    static testmethod void testmethod_1(){
      USLARInvoicedetailwrapper USLARtest = new USLARInvoicedetailwrapper();  
        
      USLARInvoicedetailwrapper.EsiHeader esi=new USLARInvoicedetailwrapper.EsiHeader('','','');
        esi.applicationId='';
        esi.companyId='';
        USLARInvoicedetailwrapper.ARrequest Arreq = new USLARInvoicedetailwrapper.ARrequest();
        arreq.esiHeader=esi;
        Arreq.invoiceNumberlist= new List<String>{'3456'};
            
      USLARInvoicedetailwrapper.cls_document clsdc= new USLARInvoicedetailwrapper.cls_document();
        clsdc.docnumber='';
      
      USLARInvoicedetailwrapper.cls_invoiceLines invce=new USLARInvoicedetailwrapper.cls_invoiceLines();
        invce.description='';
        invce.quantity='';
        invce.netPrice='';
        invce.taxAmount=''; 
        invce.lineNumber='';
        invce.netPerUnitDocCurr='';
        invce.taxPerUnitDocCurr='';
        invce.materialNumber='';
        invce.serviceDate='';
        invce.document=clsdc;
        invce.PONumber='';
        
     
        
      USLARInvoicedetailwrapper.cls_invoiceHeader invhead= new USLARInvoicedetailwrapper.cls_invoiceHeader();
        invhead.amount='';
        invhead.netAmount='';
        
      USLARInvoicedetailwrapper.cls_details detls= new USLARInvoicedetailwrapper.cls_details();
        detls.invoiceHeader=invhead;
      List<USLARInvoicedetailwrapper.cls_details> dtlist= new List<USLARInvoicedetailwrapper.cls_details>();
        dtlist.add(detls);
      USLARInvoicedetailwrapper.ARdetail adr= new USLARInvoicedetailwrapper.ARdetail();
        adr.details=dtlist;
        adr.processStatus=new USLARInvoicedetailwrapper.cls_processStatus();
        
        USLARInvoicedetailwrapper.responsewrapper rwr= new USLARInvoicedetailwrapper.responsewrapper();
        }
    
}