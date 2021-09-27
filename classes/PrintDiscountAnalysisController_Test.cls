/**
 * ====================================================================================================================
 * TEST CLASS NAME: PrintDiscountAnalysisController_Test
 * ======================================================================================================================
 * PURPOSE:   Provides static unit testing specific helper methods for PrintDiscountAnalysis class.

 * CHANGE HISTORY
 * ===================================================================================================================
 * Date         Name                    Description
 * 2012-09-06  Srikanth Kuruva          Created   
 * 2017-03-31  Karthi                   Optimized the coverage as per JIRA STORY: PS0-1
 * ===================================================================================================================
 */
  
 @isTest (seeAllData=false)
public class PrintDiscountAnalysisController_Test
{
    
    public static testmethod void PrintDiscountAnalysisController_Testmethod1()
    {        
        UnitTest.createOptiTestData();//Added as a part of S2E Optimisation         
        List<Account> listTestAccounts = new List<Account>();
        listTestAccounts = [select Name,Sales_Org__c,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000053413'];
        Account oTestAccount = new Account();
        
        if(listTestAccounts.isEmpty())
        {
            oTestAccount = UnitTest.getAccountInstance();
            insert oTestAccount;
        }
        else
        {
            oTestAccount = listTestAccounts[0];
        }
  
        IXOSCodeMap__c oTestIXOSCodeMap = new IXOSCodeMap__c();
        oTestIXOSCodeMap.Company_Code__c = '0010';
        oTestIXOSCodeMap.Dist_Chan_Code__c = 'W';
        oTestIXOSCodeMap.Division_Code__c = 'W';
        oTestIXOSCodeMap.Sales_Org_Code__c = 'WEST';
        oTestIXOSCodeMap.Name = 'WEST';
        insert oTestIXOSCodeMap;
        //scenario 1 -- with out sales org
        Test.startTest();
        //oTestAccount.Sales_Org__c = null;
        //update oTestAccount;
        pageReference pgPrintDiscountAnalysis = page.PrintDiscountAnalysis;
        Test.setCurrentPage(pgPrintDiscountAnalysis);
        //ApexPages.currentPage().getParameters().put('Id', oTestAccount.Id);        
        //ApexPages.StandardController sc = new ApexPages.StandardController(oTestAccount);

        //PrintDiscountAnalysisController controller = new PrintDiscountAnalysisController(sc);        
        

        //scenario 2 -- with sales org
        oTestAccount.Sales_Org__c = 'WEST';
        update oTestAccount;
        
        Test.setCurrentPage(pgPrintDiscountAnalysis);
        ApexPages.currentPage().getParameters().put('Id', oTestAccount.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(oTestAccount);
        PrintDiscountAnalysisController controller = new PrintDiscountAnalysisController(sc);
        List<SelectOption> listDiscountValues = controller.getlistDiscountValues();
        boolean bToggle = true;
        for(PrintDiscountAnalysisController.wrapPDASubItems oTestWrapPDASubItem : controller.listPDASubItems)
        {
            oTestWrapPDASubItem.bPDAselected = bToggle;
            bToggle = (!bToggle);
        }
        //calculate pda functionality
        controller.sDiscount = '20';
        pgPrintDiscountAnalysis = controller.CalculatePDA();
        //clear selections functionality
        pgPrintDiscountAnalysis = controller.clearSelections();
        //multiple accounts fucntionality
        pgPrintDiscountAnalysis = controller.showMultipleAccounts();
        pgPrintDiscountAnalysis = controller.hideMultipleAccounts();
        
        //Export functionality
        for(PrintDiscountAnalysisController.wrapPDASubItems oTestWrapPDASubItem : controller.listPDASubItems)
        {
            oTestWrapPDASubItem.bPDAselected = bToggle;
            bToggle = (!bToggle);
        }
        controller.sDiscount = '40';
        pgPrintDiscountAnalysis = controller.CalculatePDA();
        List<PrintDiscountAnalysisController.wrapExportResult> listTestwrapExportResult = controller.getlistSelectedVal();
        String sHeader = controller.getHeaderVal();
        controller.sExportFormat = 'PDF';
        pgPrintDiscountAnalysis = controller.Export();
        controller.sExportFormat = 'Excel';
        pgPrintDiscountAnalysis = controller.Export();
        controller.sExportFormat = 'Word';
        pgPrintDiscountAnalysis = controller.Export();

        
        //Test.setCurrentPage(pgPrintDiscountAnalysis);
        //ApexPages.currentPage().getParameters().put('Id', oTestAccount.Id);        
        //sc = new ApexPages.StandardController(oTestAccount);
        //controller = new PrintDiscountAnalysisController(sc);        
        
        Test.stopTest();

    }
   
}