/**
 * Validates the functionality provided by the SalesForecastEditController class.
 *
 * @author	John De Santiago
 * @version	2012-06-28
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-06-28   John De Santiago        Created                                                                   
 * =============================================================================
 */
 
@IsTest
private class SalesForecastEditController_Test {
	/**
     * Validates controller handling for a null standard controller
     */
    public static testMethod void testNullStandardController() {
        //Setup Test
        PageReference oPage = Page.SalesForecastEdit;
        Test.setCurrentPage(oPage);
        
        Test.startTest();
        
        SalesForecastEditController oController = new SalesForecastEditController(null);
        System.assert(ApexPages.hasMessages() == true, 'Expected error message when a null standard controller is used');
 
        Test.stopTest();
    }
    
    /**
     * Validates that an SalesForecast can be saved
     */
    private static testMethod void testSave() {
        //Setup Test
		SalesForecast__c oSalesForecast = new SalesForecast__c();
		oSalesForecast.Name = 'Unit Test Forecast';
		oSalesForecast.Status__c = 'Active';
		oSalesForecast.AutoRefreshSnapshot__c = true;
		
		PageReference oPage = Page.SalesForecastEdit;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oSalesForecast);
        
        //Execute Test
        Test.startTest();
        
        SalesForecastEditController oController = new SalesForecastEditController(oStandardController);
        PageReference oSavePageReference = oController.saveNew();
 		PageReference oSaveNewPageReference = oController.save();
 		
        Test.stopTest();
    }
}