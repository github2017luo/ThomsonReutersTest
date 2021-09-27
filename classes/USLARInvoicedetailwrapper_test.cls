/**********************************
Class Name: USLARInvoicedetailwrapper_test
**********************************/
/**
 * @description USLARInvoicedetailwrapper test class
 */
@istest()
public class USLARInvoicedetailwrapper_test{
    
    static testmethod void testmethod_1(){      
    USLARInvoicedetailwrapper.EsiHeader  esiHeadertest= new USLARInvoicedetailwrapper.EsiHeader('test','test','test');
    USLARInvoicedetailwrapper.ARrequest arRequestTest = new USLARInvoicedetailwrapper.ARrequest();
    USLARInvoicedetailwrapper.ARdetail   arDetailtest = new USLARInvoicedetailwrapper.ARdetail();  
    USLARInvoicedetailwrapper.cls_details    cls_detailsTest = new USLARInvoicedetailwrapper.cls_details();  
    USLARInvoicedetailwrapper.cls_invoiceHeader  cls_invoiceHeaderTest = new USLARInvoicedetailwrapper.cls_invoiceHeader();  
    USLARInvoicedetailwrapper.cls_invoiceLines   cls_invoiceLinesTest = new USLARInvoicedetailwrapper.cls_invoiceLines();  
    USLARInvoicedetailwrapper.cls_document    cls_documenttest = new USLARInvoicedetailwrapper.cls_document();  
    cls_documenttest.type='YW';
    cls_documenttest .docNumber='6118005220';  
    USLARInvoicedetailwrapper.responsewrapper    responsewrapperTest = new USLARInvoicedetailwrapper.responsewrapper();  
    USLARInvoicedetailwrapper.cls_processStatus    cls_processStatusTest = new USLARInvoicedetailwrapper.cls_processStatus();  
    List<String> invoiceListTest = new List<String>();
    List<USLARInvoicedetailwrapper.cls_invoiceLines> invoiceLinesListTest = new List<USLARInvoicedetailwrapper.cls_invoiceLines>(); 
    List<USLARInvoicedetailwrapper.cls_details>  arDetailsListTest = new   List<USLARInvoicedetailwrapper.cls_details>();
        
    cls_invoiceHeaderTest.referencekey = '0837758008';
    cls_invoiceHeaderTest.amount ='198';
    cls_invoiceHeaderTest.netAmount='';
    cls_invoiceHeaderTest.taxAmount ='';    
    system.assertEquals( cls_invoiceHeaderTest.referencekey, '0837758008', 'Invalid Reference');
        
    cls_invoiceLinesTest.description='';
    cls_invoiceLinesTest.quantity='';
    cls_invoiceLinesTest.netPrice='';
    cls_invoiceLinesTest.taxAmount='10';
    cls_invoiceLinesTest.PONumber='';
    cls_invoiceLinesTest.lineNumber='';
    cls_invoiceLinesTest.document=cls_documenttest ;
    cls_invoiceLinesTest.netPerUnitDocCurr='';
    cls_invoiceLinesTest.taxPerUnitDocCurr='';
    cls_invoiceLinesTest.materialNumber='';
    cls_invoiceLinesTest.serviceDate=''; 
    cls_invoiceLinesTest.invListNumber='';     
    system.assertEquals(cls_invoiceLinesTest.taxAmount, '10', 'Incorrect Tax Amount');
        
    cls_processStatusTest.statusCode='';
    cls_processStatusTest.statusDescription='';
    cls_processStatusTest.statusDetailMessage='';    
    
    responsewrapperTest.responseBodyJSON='';
    responsewrapperTest.isSuccess=False;
    responsewrapperTest.errorMessage='';  
    
    arRequestTest.esiHeader = esiHeadertest;
    arRequestTest.invoiceNumberList = invoiceListTest;
     
    arDetailtest.details = arDetailsListTest ;
    arDetailtest.processStatus = cls_processStatusTest;
    
    cls_detailsTest.invoiceHeader= cls_invoiceHeaderTest ; 
    cls_detailsTest.invoiceLines=invoiceLinesListTest;    
       
    
  }

}