/**
 * Validates the functionality provided by the SalesForecastCloneController class.
 *
 * @author  John De Santiago
 * @version 2012-06-28
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-06-28   John De Santiago        Created                                                                   
 * =============================================================================
 */
@IsTest
public class SalesForecastCloneController_Test {
    /**
     * Validates controller handling for a null standard controller
     */
    public static testMethod void testNullStandardController() {
        //Setup Test
        PageReference oPage = Page.SalesForecastClone;
        Test.setCurrentPage(oPage);
        
        Test.startTest();
        
        SalesForecastCloneController oController = new SalesForecastCloneController(null);
        System.assert(ApexPages.hasMessages() == true, 'Expected error message when a null standard controller is used');
 
        Test.stopTest();
    }
    
    /**
     * Validates that an SalesForecast can be cloned
     */
    private static testMethod void testCloneSalesForecast() {
        //Setup Test
        SalesForecast__c oSalesForecast = SalesForecastSnapshotUpdater_Test.setupMockSalesForecast();
        
        PageReference oPage = Page.SalesForecastClone;
        Test.setCurrentPage(oPage);
        
        ApexPages.StandardController oStandardController = new ApexPages.StandardController(oSalesForecast);
        
        //Execute Test
        Test.startTest();
        
        SalesForecastCloneController oController = new SalesForecastCloneController(oStandardController);
        PageReference oSavePageReference = oController.cloneSalesForecast();
        
        Test.stopTest();
        
        //Validate Test
        System.assertNotEquals(null, oSavePageReference);
    }
}