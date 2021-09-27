/**
 * ====================================================================================================================
 * TEST CLASS NAME: InvoiceController_Test
 * ======================================================================================================================
 * PURPOSE:   Validates the functionality provided by the InvoiceController class.

 * CHANGE HISTORY
 * ===================================================================================================================
 * Date         Name                    Description
 * 2013-07-15  Sudhir Kumar              Created   
 * 2017-03-31  Karthi                    Optimized the coverage as per JIRA STORY: PS0-1
 * ===================================================================================================================
 */

@isTest(seeAllData=true)

public class InvoiceController_Test{
 
    public static testmethod void testInvoiceController(){
        
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '1234';
        testAcc1.Sales_Org__c = 'WEST';
        insert testAcc1;
        
        Test.StartTest();
        
                 
        ApexPages.standardController oStandardController  = new ApexPages.standardController(testAcc1);
        InvoiceController oInvoiceController  = new InvoiceController(oStandardController);
        Test.setCurrentPageReference(Page.OpenClearedItemsPage);     
        
        // Coverage for Cleared Items   
        oInvoiceController.sSelectedOption = 'Cleared' ;            
        oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009'); 
        
        // Coverage for Open Items
        oInvoiceController.sSelectedOption = 'Open' ;    
        oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009');  
        
        
        // Coverage for All: Open and Cleared Items
        //oInvoiceController.sSelectedOption = 'All';
        //Positive Testing: Invoice Begin Date < Invoice End Date 
        oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2009');  
        //Negative Testing: Invoice Begin Date > Invoice End Date
        oInvoiceController.getInvoiceItemList('12/27/2009', '06/27/2009');    
        //Negative Testing: Date Range filter > 180 days
        oInvoiceController.getInvoiceItemList('06/27/2009', '12/27/2010');    
        oInvoiceController.getDocUrl();
        oInvoiceController.setInvoiceDateRange();
        oInvoiceController.getInvoiceItemType();
        
        
        Test.StopTest();


    }
}