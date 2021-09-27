/**
 * Validates the functionality provided by the InvoiceWS class.
 *
 * @author  Sudhir Kumar
 * @version  2013-07-15
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-15  Sudhir Kumar              Created                                                                   
 * =============================================================================
 */


@isTest

public class InvoiceWS_Test{
    public static testmethod void testInvoiceWS(){
    
        InvoiceWS oInvoiceWS = new InvoiceWS ();
        InvoiceWS.Invoice_v4_0Port oInvoice_v4_0Port = new InvoiceWS.Invoice_v4_0Port();
        InvoiceWS.EmailInvoiceDocumentResponse_element oEmailInvoiceDocumentResponse_element  = new InvoiceWS.EmailInvoiceDocumentResponse_element();
        InvoiceWS.GetInvoiceDetail_element oGetInvoiceDetail_element = new InvoiceWS.GetInvoiceDetail_element();
        InvoiceWS.GetInvoiceItems_element oGetInvoiceItems_element = new InvoiceWS.GetInvoiceItems_element();
        InvoiceWS.FaxInvoiceDocumentResponse_element oFaxInvoiceDocumentResponse_element = new InvoiceWS.FaxInvoiceDocumentResponse_element();
        InvoiceWS.GetInvoiceItemsResponse_element oGetInvoiceItemsResponse_element = new InvoiceWS.GetInvoiceItemsResponse_element();
        InvoiceWS.GetInvoiceDocument_element oGetInvoiceDocument_element = new InvoiceWS.GetInvoiceDocument_element();
        InvoiceWS.GetInvoiceDocumentResponse_element oGetInvoiceDocumentResponse_element = new InvoiceWS.GetInvoiceDocumentResponse_element();
        InvoiceWS.FaxInvoiceDocument_element oFaxInvoiceDocument_element = new InvoiceWS.FaxInvoiceDocument_element();
        InvoiceWS.EmailInvoiceDocument_element oEmailInvoiceDocument_element = new InvoiceWS.EmailInvoiceDocument_element();
        InvoiceWS.GetInvoiceDetailResponse_element oGetInvoiceDetailResponse_element = new InvoiceWS.GetInvoiceDetailResponse_element();
  
        
        List<String> listDocumentType = new List<String>();
        listDocumentType.add('ZONLCOMPL');
        listDocumentType.add('ZINVLIST'); 
        
        Test.startTest();
        oInvoice_v4_0Port.GetInvoiceItems(Decimal.valueof('123'),'test','test','test','test',date.parse('12/27/2009'),date.parse('06/27/2009'),true,true,true);
        oInvoice_v4_0Port.GetInvoiceDocument(Decimal.valueof('123'), '01234', 'test','test','test','test', listDocumentType);
        oInvoice_v4_0Port.GetInvoiceDocumentUrl(Decimal.valueof('123'), '01234', 'test','test','test','test', listDocumentType);
        oInvoice_v4_0Port.GetInvoiceDetail('123');
        
        
        oInvoice_v4_0Port.FaxInvoiceDocument(Decimal.valueof('123'), '01234', 100, 'test','test','test','test','test', listDocumentType);
        
      
        oInvoice_v4_0Port.EmailInvoiceDocument(Decimal.valueof('123'), '01234', 'test', 'test','test','test','test','test', listDocumentType);
        
        Test.stopTest();
    }
}