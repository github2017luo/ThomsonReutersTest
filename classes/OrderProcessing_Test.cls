/**
 * Validates the functionality provided by the OrderProcessing class.
 *
 * @author  Srikanth Kuruva
 * @version  2013-05-04
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-05-04   Srikanth Kuruva        Created                                                                   
 * =============================================================================
 */

@isTest(seeAllData=true)
public class OrderProcessing_Test{
    public static testmethod void OrderProcessing_Test(){
        Test.startTest(); 
        Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.Sales_Org__c = 'WEST';
        insert testAcc1;
        
        opportunity testOppty = UnitTest.getOpportunityInstance(testAcc1.id);
        testOppty.StageName = '50%';
        insert testOppty;
        
        PageReference oPageOrderProcessing = Page.OrderProcessing;
        Test.setCurrentPage(oPageOrderProcessing);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(testOppty);
        
        OrderProcessingController oController = new OrderProcessingController(oStandardController);
        
        PageReference oTestPageReference;
        oTestPageReference = oController.getAUSProdmanLink();
        oTestPageReference = oController.getNZProdmanLink();
        oTestPageReference = oController.CreateSAPCustomer();
        oTestPageReference = oController.CreateSAPQuote();        
        testOppty.Require_Manual_Trigger_for_Quote__c = true;
        update testOppty;
        oTestPageReference = oController.CreateSAPQuote();
        testOppty.StageName = '75%';
        update testOppty;
        oTestPageReference = oController.CreateSAPQuote();
        oTestPageReference = oController.getOrdermationLink();
        oTestPageReference = oController.getAUSProdmanLink(); 
         oTestPageReference = oController.getNZProdmanLink();        
         oTestPageReference = oController.getPIClink();  
         oTestPageReference = oController.getPICAMlink();   
         oTestPageReference = oController.getPICCorporatelink();  
         oTestPageReference = oController.createEReader();  
        Test.stopTest();
    }
}