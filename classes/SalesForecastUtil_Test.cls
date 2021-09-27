/**
* Validates the functionality provided by the SalesForecastUtil class.
*
* @author  John De Santiago
* @version 2012-06-28
*/
@IsTest
private class SalesForecastUtil_Test {

    /**
     * Validates after insert events
     */
    private static testMethod void testAfterInsertSalesForecast() {
        //Setup Test
        SalesForecast__c oSalesForecast = SalesForecastSnapshotUpdater_Test.setupMockSalesForecast();
        SalesForecast__c oSalesForecastTest = oSalesForecast.clone();
        
        //Start Test
        Test.startTest();
        
        insert oSalesForecastTest;
        SalesForecastUtil.afterInsertSalesForecast(new List<SalesForecast__c> { oSalesForecastTest });
        
        Test.stopTest();
        
        //Validate Test
       // List<SalesForecastSnapshot__c> listSalesForecastSnapshots = [SELECT Id FROM SalesForecastSnapshot__c WHERE SalesForecast__c = :oSalesForecastTest.Id];
        //skg
       // System.assert(listSalesForecastSnapshots.size() > 0, 'Expected at least one snapshot record to have been created');
    }
    
    /**
     * Validates after update events
     */
    private static testMethod void testAfterUpdateSalesForecast() {
        //Setup Test
        SalesForecast__c oSalesForecast = SalesForecastSnapshotUpdater_Test.setupMockSalesForecast();
        SalesForecast__c oSalesForecastTest = new SalesForecast__c();
        
        Map<Id, SalesForecast__c> oldMap = new Map<Id, SalesForecast__c>();
        oldMap.put(oSalesForecast.Id, oSalesForecastTest);
        
        //Start Test
        Test.startTest();
        
        oSalesForecast.FiscalYear__c = '2000';
        oSalesForecast.AutoRefreshSnapshot__c = true;
        SalesForecastUtil.afterUpdateSalesForecast(new List<SalesForecast__c> { oSalesForecast }, oldMap);
        
        oSalesForecast.FiscalYear__c = '2004';
        update oSalesForecast;
        Test.stopTest();
        
        //Validate Test
        //List<SalesForecastSnapshot__c> listSalesForecastSnapshots = [SELECT Id FROM SalesForecastSnapshot__c WHERE SalesForecast__c = :oSalesForecast.Id];
        //skg
        //System.assert(listSalesForecastSnapshots.size() > 0, 'Expected at least one snapshot record to have been created');
    }
    
    /**
     * Validates the helper method that determines if auto-refresh is enabled
     */
    private static testMethod void testIsAutoRefreshEnabled() {
        //Setup Test
        SalesForecast__c oSalesForecast = SalesForecastSnapshotUpdater_Test.setupMockSalesForecast();
        
        //Start Test
        Test.startTest();
        
        oSalesForecast.AutoRefreshSnapshot__c = false;
        oSalesForecast.Status__c = 'Active';
        System.assertEquals(false, SalesForecastUtil.isAutoRefreshEnabled(oSalesForecast));
        
        oSalesForecast.AutoRefreshSnapshot__c = true;
        oSalesForecast.Status__c = 'Submitted';
        System.assertEquals(false, SalesForecastUtil.isAutoRefreshEnabled(oSalesForecast));
        
        oSalesForecast.AutoRefreshSnapshot__c = true;
        oSalesForecast.Status__c = 'Active';
        System.assertEquals(true, SalesForecastUtil.isAutoRefreshEnabled(oSalesForecast));
        
        Test.stopTest();
        
        //Validate Test
        //List<SalesForecastSnapshot__c> listSalesForecastSnapshots = [SELECT Id FROM SalesForecastSnapshot__c WHERE SalesForecast__c = :oSalesForecast.Id];
        //skg
        //System.assert(listSalesForecastSnapshots.size() > 0, 'Expected at least one snapshot record to have been created');
    }
    
    /**
     * Validates a deep clone of a SalesForecast__c object
     */
    private static testMethod void testDeepCloneSalesForecast() {
        //Setup Test
        SalesForecast__c oSalesForecast = SalesForecastSnapshotUpdater_Test.setupMockSalesForecast();
        
        //Start Test
        Test.startTest();
        
        SalesForecast__c oSalesForecastClone = SalesForecastUtil.deepCloneSalesForecast(oSalesForecast.Id);
        
        Test.stopTest();
        
        //Validate Test
        //List<SalesForecastSnapshot__c> listSalesForecastSnapshots = [SELECT Id FROM SalesForecastSnapshot__c WHERE SalesForecast__c = :oSalesForecastClone.Id];
        //skg
        //System.assert(listSalesForecastSnapshots.size() > 0, 'Expected at least one snapshot record to have been created');
    }
            
    /**
     * Validates that a SalesForecast__c and it's related SalesForecastSnapshot__c records
     */
    private static testMethod void querySalesForecastAndSnapshots() {
        //Setup Test
        SalesForecast__c oSalesForecast = SalesForecastSnapshotUpdater_Test.setupMockSalesForecast();
        
        //Start Test
        Test.startTest();
        
        SalesForecast__c oSalesForecastResult = SalesForecastUtil.querySalesForecastAndSnapshots(oSalesForecast.Id);
        
        Test.stopTest();
        
       
    } 
    
    
}