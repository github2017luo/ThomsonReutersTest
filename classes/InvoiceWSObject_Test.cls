/**
 * Validates the functionality provided by the InvoiceWSObject class.
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

public class InvoiceWSObject_Test{
    
    public static testmethod void testInvoiceWSObject(){
        InvoiceWSObject oInvoiceWSObject = new InvoiceWSObject();
        InvoiceWSObject.OpenClearedItems oOpenClearedItems = new InvoiceWSObject.OpenClearedItems();
        InvoiceWSObject.Document oDocument = new InvoiceWSObject.Document();
        InvoiceWSObject.DocumentUrl oDocumentUrl = new InvoiceWSObject.DocumentUrl();
        InvoiceWSObject.OpenItem oOpenItem = new InvoiceWSObject.OpenItem();
        InvoiceWSObject.InvoiceItem oInvoiceItem = new InvoiceWSObject.InvoiceItem();
        InvoiceWSObject.InvoiceDetail oInvoiceDetail = new InvoiceWSObject.InvoiceDetail();
        InvoiceWSObject.ClearedItem oClearedItem = new InvoiceWSObject.ClearedItem();       
    }
}