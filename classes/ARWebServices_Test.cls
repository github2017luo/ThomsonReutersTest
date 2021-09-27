@isTest//(seeAllData=true)
public class ARWebServices_Test{
     public static testmethod void testARWebServices(){
         Test.startTest();
             ARWebServices arSerObj = new ARWebServices();
             ARWebServices.context_element conEleObj = new ARWebServices.context_element();
             ARWebServices.ClearedItemsOutList clearOitemOutListObj = new ARWebServices.ClearedItemsOutList();
             ARWebServices.OpenItemsOutList openItemOutListObj = new ARWebServices.OpenItemsOutList();
             ARWebServices.ARService_element arSerEleObj = new ARWebServices.ARService_element();
             ARWebServices.InvoiceTexttab invTestTabObj = new ARWebServices.InvoiceTexttab();
             ARWebServices.getInvoiceItems_element invItemEleObj = new ARWebServices.getInvoiceItems_element();
             ARWebServices.TexttabList texttabListObj = new ARWebServices.TexttabList();
             ARWebServices.InvoiceClearedItemsOut invClearedItemOutObj = new ARWebServices.InvoiceClearedItemsOut();
             ARWebServices.getInvoiceItemsResponse_element invItemsRespEleObj = new ARWebServices.getInvoiceItemsResponse_element();
             ARWebServices.InvoiceItems invItemObj = new ARWebServices.InvoiceItems();
             ARWebServices.GetInvoiceItemsRequest invItemsReqObj = new ARWebServices.GetInvoiceItemsRequest();
             ARWebServices.InvoiceOpenItemsOut invOpenItemsOutObj = new ARWebServices.InvoiceOpenItemsOut();
             ARWebServices.ARServiceV01 arSerV01Obj = new ARWebServices.ARServiceV01();
         Test.stopTest();
     }
}