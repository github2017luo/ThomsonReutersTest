/**
 * Provides methods helper methods for working with SalesForecast__c objects
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
public without sharing class SalesForecastUtil {
    
    /**
     * Trigger helper method to be executed after a SalesForecast object has been inserted
     * <p>
     * Auto-creates snapshots auto-refresh is enabled. Does not support bulk updates.
     *
     * @param   listSalesForecasts  a list of SalesForecast__c objects
     */
    public static void afterInsertSalesForecast(List<SalesForecast__c> listSalesForecasts) {
        if (listSalesForecasts.size() == 1) {
            SalesForecast__c oSalesForecast = listSalesForecasts[0];
            
            if (isAutoRefreshEnabled(oSalesForecast) && oSalesForecast.ClonedFrom__c == null) {
                /*SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
                oUpdater.updateSalesForecastSnapshots(oSalesForecast.Id);*/
            }
        }
    } 
    
    /**
     * Trigger helper method to be executed after a SalesForecast object has been updated
     * <p>
     * Auto-updates snapshots if key info has changed and auto-refresh is enabled. Does not support bulk updates.
     *
     * @param   listSalesForecasts  a list of SalesForecast objects
     * @param   oldMap              a map of SalesForecast objects in their pre-update state
     */
    public static void afterUpdateSalesForecast(List<SalesForecast__c> listSalesForecasts, Map<Id, SalesForecast__c> oldMap) {
        if (listSalesForecasts.size() == 1) {
            SalesForecast__c oSalesForecast = listSalesForecasts[0];
            
            if (isAutoRefreshEnabled(oSalesForecast) == true) {
                //Check if key info has changed 
                boolean hasOwnerChanged = false;
                boolean hasYearChanged = false;
                boolean hasQuarterChanged = false;
                
                if (oldMap.containsKey(oSalesForecast.Id)) {
                    SalesForecast__c oSalesForecastOld = oldMap.get(oSalesForecast.Id);
                    
                    hasOwnerChanged = (oSalesForecast.OwnerId != oSalesForecastOld.OwnerId);
                    hasYearChanged = (oSalesForecast.FiscalYear__c != oSalesForecastOld.FiscalYear__c);
                    hasQuarterChanged = (oSalesForecast.FiscalQuarter__c != oSalesForecastOld.FiscalQuarter__c);        
                }
                
                //Update Snapshot if key information has changed
                if (hasOwnerChanged || hasYearChanged || hasQuarterChanged) {
                    /*SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
                    oUpdater.updateSalesForecastSnapshots(oSalesForecast.Id);*/
                }
            }
        }
    }
    
    
    /**
     * Helper method that tests if the specified SalesForeact object has auto-refreshes enabled
     *
     * @param   oSalesForecast  a SalesForecast__c object
     * @return  true if auto-rerefresh is enabled, otherwise returns false
     */
    public static boolean isAutoRefreshEnabled(SalesForecast__c oSalesForecast) {
        return (oSalesForecast.AutoRefreshSnapshot__c == true && oSalesForecast.Status__c != 'Submitted');
    }
    
    /**
     * Helper method that performs of a deep clone of the specified SalesForecast__c object id
     * <p>
     * Method does not perform any DML operations
     * 
     * @param   salesForecastId a SalesForecast__c object id
     * @return  a reference to the SalesForecast__c object created in the clone process
     */
    public static SalesForecast__c deepCloneSalesForecast(Id salesForecastId) {
        SalesForecast__c oSalesForecast = querySalesForecastAndSnapshots(salesForecastId);
        
        //Clone Forecast
        SalesForecast__c oSalesForecastClone = oSalesForecast.clone();
        oSalesForecastClone.ClonedFrom__c = salesForecastId;
        oSalesForecastClone.Name += ' (Clone)';
        oSalesForecastClone.Status__c = 'Active';
        oSalesForecastClone.AutoRefreshSnapshot__c = true;
        oSalesForecastClone.SubmittedTo__c = '';
        oSalesForecastClone.SubmittedDate__c = null;
        oSalesForecastClone.SubmittedToEmail__c = '';
        oSalesForecastClone.SnapshotLastUpdated__c = null;
        insert oSalesForecastClone;
        
        //Clone Snapshots
        if (oSalesForecast.SalesForecastSnapshots__r != null) {
            List<SalesForecastSnapshot__c> listSalesForecastSnapshotClones = new List<SalesForecastSnapshot__c>();
            
            for (SalesForecastSnapshot__c oSalesForecastSnapshot : oSalesForecast.SalesForecastSnapshots__r) {
                SalesForecastSnapshot__c oSalesForecastSnapshotClone = oSalesForecastSnapshot.clone();
                oSalesForecastSnapshotClone.SalesForecast__c = oSalesForecastClone.Id;
                
                listSalesForecastSnapshotClones.add(oSalesForecastSnapshotClone);
            }
            
            if (listSalesForecastSnapshotClones.isEmpty() == false) {
                insert listSalesForecastSnapshotClones;
            }
        }
        
        //Refresh Snapshot
        /*SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
        oUpdater.updateSalesForecastSnapshots(oSalesForecastClone.Id);*/
        
        return oSalesForecastClone;
    }
    
    
    /**
     * Queries a SalesForecast__c object and any related SalesForecastSnapshots__c objects
     * based on the specified id
     *
     * @param   salesForecastId a SalesForecast__c object id
     * @return  a SalesForecast__c object
     */
    public static SalesForecast__c querySalesForecastAndSnapshots(Id salesForecastId) {
        return [SELECT  
                    Id
                    , AutoRefreshSnapshot__c
                    , FiscalQuarter__c
                    , FiscalQuarterPeriod__c
                    , FiscalYear__c
                    , Name
                    , NewSaleAdjustedAmount__c
                    , NewSaleClosedAmount__c
                    , NewSaleCommitAmount__c
                    , NewSalePotentialAmount__c
                    , NewSalePipelineAmount__c
                    , NewSaleNonPipelineRiskUpside__c
                    , NewSaleQuota__c
                    , NewSaleQuotaGap__c
                    , NewSaleQuotaPercentage__c
                    , OwnerId
                    , RenewalAdjustedAmount__c
                    , RenewalClosedAmount__c
                    , RenewalCommitAmount__c
                    , RenewalPotentialAmount__c
                    , RenewalPipelineAmount__c
                    , RenewalNonPipelineRiskUpside__c
                    , RenewalQuota__c
                    , RenewalQuotaGap__c
                    , RenewalQuotaPercentage__c
                    , SnapshotLastUpdated__c
                    , Status__c
                    , SubmittedDate__c
                    , SubmittedTo__c
                    , SubmittedToEmail__c
                    , (SELECT 
                        Id 
                        , M1_DisplayLabel__c
                        , M1_NewSaleAdjustedAmount__c
                        , M1_NewSaleClosedAmount__c
                        , M1_NewSaleCommitAmount__c
                        , M1_NewSalePotentialAmount__c
                        , M1_NewSalePipelineAmount__c
                        , M1_NewSaleQuota__c
                        , M1_NewSaleQuotaGap__c
                        , M1_NewSaleQuotaPercentage__c
                        , M1_NewSaleRiskUpsideAmount__c
                        , M1_RenewalAdjustedAmount__c
                        , M1_RenewalClosedAmount__c
                        , M1_RenewalCommitAmount__c
                        , M1_RenewalPotentialAmount__c
                        , M1_RenewalPipelineAmount__c
                        , M1_RenewalQuota__c
                        , M1_RenewalQuotaGap__c
                        , M1_RenewalQuotaPercentage__c
                        , M1_RenewalRiskUpsideAmount__c
                        , M2_DisplayLabel__c
                        , M2_NewSaleAdjustedAmount__c
                        , M2_NewSaleClosedAmount__c
                        , M2_NewSaleCommitAmount__c
                        , M2_NewSalePotentialAmount__c
                        , M2_NewSalePipelineAmount__c
                        , M2_NewSaleQuota__c
                        , M2_NewSaleQuotaGap__c
                        , M2_NewSaleQuotaPercentage__c
                        , M2_NewSaleRiskUpsideAmount__c
                        , M2_RenewalAdjustedAmount__c
                        , M2_RenewalClosedAmount__c
                        , M2_RenewalCommitAmount__c
                        , M2_RenewalPotentialAmount__c
                        , M2_RenewalPipelineAmount__c
                        , M2_RenewalQuota__c
                        , M2_RenewalQuotaGap__c
                        , M2_RenewalQuotaPercentage__c
                        , M2_RenewalRiskUpsideAmount__c
                        , M3_DisplayLabel__c
                        , M3_NewSaleAdjustedAmount__c
                        , M3_NewSaleClosedAmount__c
                        , M3_NewSaleCommitAmount__c
                        , M3_NewSalePotentialAmount__c
                        , M3_NewSalePipelineAmount__c
                        , M3_NewSaleQuota__c
                        , M3_NewSaleQuotaGap__c
                        , M3_NewSaleQuotaPercentage__c
                        , M3_NewSaleRiskUpsideAmount__c
                        , M3_RenewalAdjustedAmount__c
                        , M3_RenewalClosedAmount__c
                        , M3_RenewalCommitAmount__c
                        , M3_RenewalPotentialAmount__c
                        , M3_RenewalPipelineAmount__c
                        , M3_RenewalQuota__c
                        , M3_RenewalQuotaGap__c
                        , M3_RenewalQuotaPercentage__c
                        , M3_RenewalRiskUpsideAmount__c
                        , NewSaleQuota__c
                        , RenewalQuota__c
                        , Name
                        , SalesForecast__c
                        , User__c
                    FROM 
                        SalesForecastSnapshots__r)
                FROM 
                    SalesForecast__c 
                WHERE 
                    Id = :salesForecastId];
    }
}