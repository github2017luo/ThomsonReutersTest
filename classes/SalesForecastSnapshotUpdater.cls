/**
 * Batchable and Schedulable class that updates sales forecast snapshot data
 *
 * @author  John De Santiago
 * @version  2012-09-05
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-09-05   John De Santiago        Created - Refactored to account for rollup calculations                                                                   
 * =============================================================================
 */
 
 //Commenting out as a part of removal of TM1.0 components
 global class SalesForecastSnapshotUpdater implements Database.Batchable<sObject>, Database.stateful {
//global class SalesForecastSnapshotUpdater implements Database.Batchable<sObject>, Schedulable {
  //Protected Members
  public static final string FiscalMonthFormat = 'MMM yyyy';
  private String Query;
  
  //Batch Methods
     
     /**
     * Executes at the start of the batch process and is responsible
     * for returning a QueryLocator containing the account records to batch process
     *
     * @param   bcContext   the context of the method execution.
     * @return  an QueryLocator instance containing the accounts to batch process
     */ 
    global Database.Querylocator start(Database.BatchableContext bcContext) {
       Query ='SELECT Id FROM Account limit 1';
        return Database.getQueryLocator(Query);
      
      /*return Database.getQueryLocator([SELECT 
                        Id 
                      FROM 
                        SalesForecast__c 
                      WHERE 
                        AutoRefreshSnapshot__c = true 
                        AND 
                        Status__c != 'Submitted']);*/
    }
    
    /**
     * Batchable interface method that synchronizes the account types
     * and territory team members
     *
     * @param   bcContext       the context of the method execution.
     * @param   listAccounts    the list of accounts to process.
     */
    global void execute(Database.BatchableContext oContext, List<sObject> listSObjects)
    {
      /*updateSalesForecastSnapshots(listSObjects[0].Id);*/
    }
    
    /**
     * Batchable interface method that executes at the end of the batch process.
     *
     * @param   bcContext   the context of the method execution.
     */
    global void finish(Database.BatchableContext bcContext) {}
    
    //Schedule Methods
    
  /**
     * Schedulable interface method that enables the SalesForecastSnapshotUpdater 
     * object to be scheduled for automatic execution.
     * <p>
     * For performance reasons the batch size is limited to 1 but this can be changed
     * as needed with adequate testing
     *
     * @param   scContext   the context of the method execution.
     */  
     /*global void execute(SchedulableContext oContext) {
       /*SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
       Database.executeBatch(oUpdater, 1);
     }*/
     
  //Public Methods
  
  /**
   * Initiates the process for updating salesforecast snapshots for the specified
   * SalesForecast__c object id
   *
   * @param  salesForecastId  a SalesForecast__c object id
   */
  /*public void updateSalesForecastSnapshots(Id salesForecastId) {
        Map<Id, SalesForecastSnapshot__c> mapCalculatedSnapshotsByUserId = new Map<Id, SalesForecastSnapshot__c>();

        //Get Sales Forecast
        SalesForecast__c oSalesForecast = querySalesForecast(salesForecastId);

        //Get Existing Sales Forecast Snapshots
        Map<Id, SalesForecastSnapshot__c> mapSalesForecastSnapshots = new Map<Id, SalesForecastSnapshot__c>(querySalesForecastSnapshots(salesForecastId));

        Map<Id, SalesForecastSnapshot__c> mapSalesForecastSnapshotsByUserId = new Map<Id, SalesForecastSnapshot__c>();
        for (SalesForecastSnapshot__c oSalesForecastSnapshot : mapSalesForecastSnapshots.values()) {
            mapSalesForecastSnapshotsByUserId.put(oSalesForecastSnapshot.User__c, oSalesForecastSnapshot);
        }
        
        //Get Forecast Owner Territories
        Map<Id, Territory2> mapTerritories = new Map<Id, Territory2>(queryTerritoriesByUserId(oSalesForecast.OwnerId));
        
        if (mapTerritories.isEmpty() == false) {
            //Get Level1 Territories
            Map<Id, Territory2> mapLevel1Territories = new Map<Id, Territory2>(queryChildTerritories(mapTerritories.keySet()));

            //Map Level 1 Territory Hierarchy
            TerritoryHierarchy oTerritoryHierarchy = new TerritoryHierarchy();
            
            Map<Id, TerritoryHierarchy.TerritoryNode> mapTerritoryHierarchy = new Map<Id, TerritoryHierarchy.TerritoryNode>();
            for (Id territoryId : mapLevel1Territories.keySet()) {
                TerritoryHierarchy.TerritoryNode oTerritoryNode = oTerritoryHierarchy.getTerritoryNode(territoryId);
                
                if (oTerritoryNode != null && oTerritoryNode.Members.isEmpty() == false) {
                    mapTerritoryHierarchy.put(territoryId, oTerritoryNode);
                }
            }
            
            //Map Second Level Users to Subordinate Users
            Map<Id, Set<Id>> mapLevel2UsersToSubordinates = new Map<Id, Set<Id>>();
            
            for (TerritoryHierarchy.TerritoryNode oTerritoryNode : mapTerritoryHierarchy.values()) {
                for (TerritoryHierarchy.TerritoryMember oTerritoryMember : oTerritoryNode.Members) {
                    Set<Id> setUserIds = new Set<Id>();
                    
                    setUserIds.add(oTerritoryMember.User.Id);
                    setUserIds.addAll(getAllChildTerritoryUserIds(oTerritoryNode));
                    
                    mapLevel2UsersToSubordinates.put(oTerritoryMember.User.Id, setUserIds);
                }
            }
            
            //Map Sales Forecast Snapshots and Create User to Snapshot User Index
            Map<Id, Id> mapUsersToSnapshotIndex = new Map<Id, Id>();
            
            for (Id userId : mapLevel2UsersToSubordinates.keySet()) {
                //Map Sales Forecast
                if(mapSalesForecastSnapshotsByUserId.containsKey(userId)) {
                    mapCalculatedSnapshotsByUserId.put(userId, mapSalesForecastSnapshotsByUserId.get(userId));
                }
                else {
                    SalesForecastSnapshot__c oSalesForecastSnapshot = new SalesForecastSnapshot__c();
                    oSalesForecastSnapshot.User__c = userId;
                    oSalesForecastSnapshot.SalesForecast__c = salesForecastId;

                    mapCalculatedSnapshotsByUserId.put(userId, oSalesForecastSnapshot);
                }
                
                //Map Subordinate User to Snapshot User
                for (Id subUserId : mapLevel2UsersToSubordinates.get(userId)) {
                    mapUsersToSnapshotIndex.put(subUserId, userId);
                }
            }

            if (mapCalculatedSnapshotsByUserId.isEmpty() == false) {
                string sFiscalYear = oSalesForecast.FiscalYear__c;
                integer iFiscalQuarter = integer.valueOf(oSalesForecast.FiscalQuarterPeriod__c);
                
                //Get Fiscal Period Data
                List<Period> listFiscalPeriods = getFiscalQuarterPeriods(sFiscalYear, iFiscalQuarter);
                
                //Reset Sales Data
                resetCalculatedSalesData(mapCalculatedSnapshotsByUserId.values(), listFiscalPeriods);

                //Calculate Sales Data
                calculateSalesData(mapCalculatedSnapshotsByUserId, mapUsersToSnapshotIndex, listFiscalPeriods);
            }
        }

        //Find and Delete Un-needed Sales Forecast Snapshots
        Set<Id> setSalesForecastSnapshotsToDelete = new Set<Id>();

        for (Id userId : mapSalesForecastSnapshotsByUserId.keySet()) {
            if (mapCalculatedSnapshotsByUserId.containsKey(userId) == false) {
                SalesForecastSnapshot__c oSalesForecastSnapshot = mapSalesForecastSnapshotsByUserId.get(userId);
                
                if (oSalesForecastSnapshot.Id != null) {
                    setSalesForecastSnapshotsToDelete.add(oSalesForecastSnapshot.Id);
                }
            }
        }

        if (setSalesForecastSnapshotsToDelete.isEmpty() == false) {
            Database.delete(new List<Id>(setSalesForecastSnapshotsToDelete));
        }

        //Save Sales Forecast Snapshots
        if (mapCalculatedSnapshotsByUserId.isEmpty() == false) {
            Database.upsert(mapCalculatedSnapshotsByUserId.values());
        }
        
        //Rollup Sales Forecast Totals
        SalesForecast__c oSalesForecastRollup = new SalesForecast__c(Id=salesForecastId);
        oSalesForecastRollup.NewSaleQuota__c = 0;
        oSalesForecastRollup.RenewalQuota__c = 0;
        oSalesForecastRollup.SnapshotLastUpdated__c = System.now();
        
        for (SalesForecastSnapshot__c oSalesForecastSnapshot : querySalesForecastSnapshots(salesForecastId)) {
            oSalesForecastRollup.NewSaleQuota__c += AppUtil.isNull(oSalesForecastSnapshot.NewSaleQuota__c, 0);
            oSalesForecastRollup.RenewalQuota__c += AppUtil.isNull(oSalesForecastSnapshot.RenewalQuota__c, 0);  
        }
        
        Database.update(oSalesForecastRollup);
    }

  //Private Methods
  
  /**
   * Retrieves a set of User ids that are related to the specified TerritoryNode
   * and children in the hierarchy.
   * <p>
   * Currently this method will walk down the full hierarchy. No limit to the number
   * of levels but it is expected that territories will go no deeper than 5 levels.
   *
   * @param  a TerritoryHierarchy.TerritoryNode object
   * @return  a set of User object ids
   */
  /*@TestVisible private Set<Id> getAllChildTerritoryUserIds(TerritoryHierarchy.TerritoryNode oTerritoryNode) {
    Set<Id> setUserIds = new Set<Id>();
    
    for (TerritoryHierarchy.TerritoryNode oChildTerritoryNode : oTerritoryNode.Children) {
      for (TerritoryHierarchy.TerritoryMember oTerritoryMember : oChildTerritoryNode.Members) {
        setUserIds.add(oTerritoryMember.User.Id);
      }
      
      setUserIds.addAll(getAllChildTerritoryUserIds(oChildTerritoryNode));
    }
    
    return setUserIds;
  }
  
  /**
   * Retrieves the fiscal Period objects for the specified fiscal year and quarter
   *
   * @param  sFiscalYear    the fiscal year
   * @param  iFiscalQuarter  the fiscal quarter period number
   */
  /*private List<Period> getFiscalQuarterPeriods(string sFiscalYear, integer iFiscalQuarter) {
    //Get Fiscal Quarter
    Period oFiscalQuarter = [SELECT Id, Number, StartDate, EndDate FROM Period WHERE Type='Quarter' AND FiscalYearSettings.Name = :sFiscalYear AND Number = :iFiscalQuarter LIMIT 1];
    
    //Get Fiscal Quarter Months
    return [SELECT Id, Number, StartDate, EndDate FROM Period WHERE Type = 'Month' AND (StartDate >= :oFiscalQuarter.StartDate AND EndDate <= :oFiscalQuarter.EndDate) ORDER By Number];
  }
  
  /**
   * Prepares the sales forecast snapshot data to be updated by reseting all calculated values
   * to zero
   *
   * @param  listSalesForecastSnapshots    a list of a SalesForecastSnapshot__c objects
   * @param  listFiscalPeriods        a list of Period objects
   */
  /*private void resetCalculatedSalesData(List<SalesForecastSnapshot__c> listSalesForecastSnapshots, List<Period> listFiscalPeriods) {
    
    //Get Fiscal Month Labels
      string sFiscalMonth1 = AppUtil.formatDate(listFiscalPeriods[0].StartDate, FiscalMonthFormat, '');
    string sFiscalMonth2 = AppUtil.formatDate(listFiscalPeriods[1].StartDate, FiscalMonthFormat, '');
    string sFiscalMonth3 = AppUtil.formatDate(listFiscalPeriods[2].StartDate, FiscalMonthFormat, '');

    for(SalesForecastSnapshot__c oSalesForecastSnapshot : listSalesForecastSnapshots) {
      //Set required label fields
      oSalesForecastSnapshot.M1_DisplayLabel__c = sFiscalMonth1;
      oSalesForecastSnapshot.M2_DisplayLabel__c = sFiscalMonth2;
      oSalesForecastSnapshot.M3_DisplayLabel__c = sFiscalMonth3;
      
      //Keep existing adjustments and reset nulls to zero
      oSalesForecastSnapshot.M1_NewSaleRiskUpsideAmount__c = AppUtil.isNull(oSalesForecastSnapshot.M1_NewSaleRiskUpsideAmount__c, 0);
      oSalesForecastSnapshot.M1_RenewalRiskUpsideAmount__c = AppUtil.isNull(oSalesForecastSnapshot.M1_RenewalRiskUpsideAmount__c, 0);
      oSalesForecastSnapshot.M2_NewSaleRiskUpsideAmount__c = AppUtil.isNull(oSalesForecastSnapshot.M2_NewSaleRiskUpsideAmount__c, 0);
      oSalesForecastSnapshot.M2_RenewalRiskUpsideAmount__c = AppUtil.isNull(oSalesForecastSnapshot.M2_RenewalRiskUpsideAmount__c, 0);
      oSalesForecastSnapshot.M3_NewSaleRiskUpsideAmount__c = AppUtil.isNull(oSalesForecastSnapshot.M3_NewSaleRiskUpsideAmount__c, 0);
      oSalesForecastSnapshot.M3_RenewalRiskUpsideAmount__c = AppUtil.isNull(oSalesForecastSnapshot.M3_RenewalRiskUpsideAmount__c, 0);
      
      //Reset all calculated fields
      oSalesForecastSnapshot.M1_NewSaleClosedAmount__c = 0;
      oSalesForecastSnapshot.M1_NewSaleCommitAmount__c = 0;
      oSalesForecastSnapshot.M1_NewSalePotentialAmount__c = 0;
      oSalesForecastSnapshot.M1_NewSalePipelineAmount__c = 0;
      oSalesForecastSnapshot.M1_NewSaleQuota__c = 0;
      
      oSalesForecastSnapshot.M1_RenewalClosedAmount__c = 0;
      oSalesForecastSnapshot.M1_RenewalCommitAmount__c = 0;
      oSalesForecastSnapshot.M1_RenewalPotentialAmount__c = 0;
      oSalesForecastSnapshot.M1_RenewalPipelineAmount__c = 0;
      oSalesForecastSnapshot.M1_RenewalQuota__c = 0;
      
      oSalesForecastSnapshot.M2_NewSaleClosedAmount__c = 0;
      oSalesForecastSnapshot.M2_NewSaleCommitAmount__c = 0;
      oSalesForecastSnapshot.M2_NewSalePotentialAmount__c = 0;
      oSalesForecastSnapshot.M2_NewSalePipelineAmount__c = 0;
      oSalesForecastSnapshot.M2_NewSaleQuota__c = 0;
      
      oSalesForecastSnapshot.M2_RenewalClosedAmount__c = 0;
      oSalesForecastSnapshot.M2_RenewalCommitAmount__c = 0;
      oSalesForecastSnapshot.M2_RenewalPotentialAmount__c = 0;
      oSalesForecastSnapshot.M2_RenewalPipelineAmount__c = 0;
      oSalesForecastSnapshot.M2_RenewalQuota__c = 0;
      
      oSalesForecastSnapshot.M3_NewSaleClosedAmount__c = 0;
      oSalesForecastSnapshot.M3_NewSaleCommitAmount__c = 0;
      oSalesForecastSnapshot.M3_NewSalePotentialAmount__c = 0;
      oSalesForecastSnapshot.M3_NewSalePipelineAmount__c = 0;
      oSalesForecastSnapshot.M3_NewSaleQuota__c = 0;
      
      oSalesForecastSnapshot.M3_RenewalClosedAmount__c = 0;
      oSalesForecastSnapshot.M3_RenewalCommitAmount__c = 0;
      oSalesForecastSnapshot.M3_RenewalCommitAmount__c = 0;
      oSalesForecastSnapshot.M3_RenewalPotentialAmount__c = 0;
      oSalesForecastSnapshot.M3_RenewalQuota__c = 0;
      
      //Reset Quotas
      oSalesForecastSnapshot.M1_NewSaleQuota__c = 0;
      oSalesForecastSnapshot.M1_RenewalQuota__c = 0;
      oSalesForecastSnapshot.M2_NewSaleQuota__c = 0;
      oSalesForecastSnapshot.M2_RenewalQuota__c = 0;
      oSalesForecastSnapshot.M3_NewSaleQuota__c = 0;
      oSalesForecastSnapshot.M3_RenewalQuota__c = 0;
    }
  }
  
  /**
   * Compiles all of the information to calculate a sales forecast snapshot
   * <p>
   * This method updates the specified SalesForecastSnapshot__c object directly and does
   * not perform any DML. It is expected that the calling method will handle any DML operations
   * if needed.
   *
   * @param  mapCalculatedSnapshotsByUserId    a map of user ids to SalesForecastSnapshot__c objects
   * @param  mapUsersToSnapshotIndex        a map of user ids to snapshot user ids
   * @param  listFiscalPeriods           a list of fiscal Period objects
   */
  /*private void calculateSalesData(Map<Id, SalesForecastSnapshot__c> mapCalculatedSnapshotsByUserId, Map<Id, Id> mapUsersToSnapshotIndex, List<Period> listFiscalPeriods) {
    Set<Id> setUserIds = mapUsersToSnapshotIndex.keySet();
      integer iFiscalMonth = 0;
      
      //Get User Quotas
      Map<Id, Map<string, UserQuota__c>> mapUserQuota = mapUserQuotasByUserIdAndFiscalMonth(setUserIds);
    
    //Get Fiscal Month Labels
      string sFiscalMonth1 = AppUtil.formatDate(listFiscalPeriods[0].StartDate, FiscalMonthFormat, '');
    string sFiscalMonth2 = AppUtil.formatDate(listFiscalPeriods[1].StartDate, FiscalMonthFormat, '');
    string sFiscalMonth3 = AppUtil.formatDate(listFiscalPeriods[2].StartDate, FiscalMonthFormat, '');
        
    for (Period oFiscalPeriod : listFiscalPeriods) {
        iFiscalMonth++;
        
        for (AggregateResult oAggregateResult : aggregateFiscalMonthSales(setUserIds, oFiscalPeriod)) {
          System.debug('Aggregate Result: ' + oAggregateResult);
          
          //Get Sales Data Owner Id
          Id ownerId = (Id)oAggregateResult.get('OwnerId');
          
          //Get Snapshot User Id
          Id userId = mapUsersToSnapshotIndex.get(ownerId);
          
          //Get Snapshot for Update
          SalesForecastSnapshot__c oSalesForecastSnapshot = mapCalculatedSnapshotsByUserId.get(userId);
          
          //Aggregate User Quotas
          if (mapUserQuota.containsKey(ownerId)) {
          Map<string, UserQuota__c> mapFiscalUserQuota = mapUserQuota.get(ownerId);
          
          UserQuota__c oM1_UserQuota = mapFiscalUserQuota.get(sFiscalMonth1);
          if (oM1_UserQuota != null && iFiscalMonth == 1) {
            oSalesForecastSnapshot.M1_NewSaleQuota__c += Math.round(AppUtil.isNull(oM1_UserQuota.New_Sale__c,0));
            oSalesForecastSnapshot.M1_RenewalQuota__c += Math.round(AppUtil.isNull(oM1_UserQuota.Renewal__c, 0));          
          }
          
          UserQuota__c oM2_UserQuota = mapFiscalUserQuota.get(sFiscalMonth2);
          if (oM2_UserQuota != null && iFiscalMonth == 2) {
            oSalesForecastSnapshot.M2_NewSaleQuota__c += Math.round(AppUtil.isNull(oM2_UserQuota.New_Sale__c, 0));
            oSalesForecastSnapshot.M2_RenewalQuota__c += Math.round(AppUtil.isNull(oM2_UserQuota.Renewal__c, 0));
          }
          
          UserQuota__c oM3_UserQuota = mapFiscalUserQuota.get(sFiscalMonth3);
          if (oM3_UserQuota != null && iFiscalMonth == 3) {
            oSalesForecastSnapshot.M3_NewSaleQuota__c += Math.round(AppUtil.isNull(oM3_UserQuota.New_Sale__c, 0));
            oSalesForecastSnapshot.M3_RenewalQuota__c += Math.round(AppUtil.isNull(oM3_UserQuota.Renewal__c, 0));
          }
        }
            
          //Get Aggregate Data
          object oTotalNewSaleAmount = oAggregateResult.get('TotalNewSaleAmount');
          object oTotalRenewalAmount = oAggregateResult.get('TotalRenewalAmount');
          
          decimal dNewSaleAmount = (oTotalNewSaleAmount != null ? (decimal) oTotalNewSaleAmount : 0);
          decimal dRenewalAmount = (oTotalRenewalAmount != null ? (decimal) oTotalRenewalAmount : 0);
          
          dNewSaleAmount =  Math.Round(dNewSaleAmount);
          dRenewalAmount =  Math.Round(dRenewalAmount);
          
          boolean isClosedCategory = oAggregateResult.get('ForecastCategoryName') == 'Closed';
          boolean isCommitCategory = oAggregateResult.get('ForecastCategoryName') == 'Commit';
          boolean isPotentialCategory = oAggregateResult.get('ForecastCategoryName') == 'Potential';
          boolean isPipelineCategory = oAggregateResult.get('ForecastCategoryName') == 'Pipeline';
        
          //Calculate Closed Category
          if (isClosedCategory) {
            if (iFiscalMonth == 1) {
              oSalesForecastSnapshot.M1_NewSaleClosedAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M1_RenewalClosedAmount__c += dRenewalAmount;
            }
            else if (iFiscalMonth == 2) {
              oSalesForecastSnapshot.M2_NewSaleClosedAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M2_RenewalClosedAmount__c += dRenewalAmount;
            }
            else if (iFiscalMonth == 3) {
              oSalesForecastSnapshot.M3_NewSaleClosedAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M3_RenewalClosedAmount__c += dRenewalAmount;
            }
          }
          
          //Calculate Commit Category
          if (isCommitCategory) {
            if (iFiscalMonth == 1) {
              oSalesForecastSnapshot.M1_NewSaleCommitAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M1_RenewalCommitAmount__c += dRenewalAmount;
            }
            else if (iFiscalMonth == 2) {
              oSalesForecastSnapshot.M2_NewSaleCommitAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M2_RenewalCommitAmount__c += dRenewalAmount;
            }
            else if (iFiscalMonth == 3) {
              oSalesForecastSnapshot.M3_NewSaleCommitAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M3_RenewalCommitAmount__c += dRenewalAmount;
            }
          }
          
          //Calculate Potential Category
          if (isPotentialCategory) {
            if (iFiscalMonth == 1) {
              oSalesForecastSnapshot.M1_NewSalePotentialAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M1_RenewalPotentialAmount__c += dRenewalAmount;
            }
            else if (iFiscalMonth == 2) {
              oSalesForecastSnapshot.M2_NewSalePotentialAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M2_RenewalPotentialAmount__c += dRenewalAmount;
            }
            else if (iFiscalMonth == 3) {
              oSalesForecastSnapshot.M3_NewSalePotentialAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M3_RenewalPotentialAmount__c += dRenewalAmount;
            }
          }
          
          //Calculate Pipeline Category
          if (isPipelineCategory) {
            if (iFiscalMonth == 1) {
              oSalesForecastSnapshot.M1_NewSalePipelineAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M1_RenewalPipelineAmount__c += dRenewalAmount;
            }
            else if (iFiscalMonth == 2) {
              oSalesForecastSnapshot.M2_NewSalePipelineAmount__c += dNewSaleAmount;
              oSalesForecastSnapshot.M2_RenewalPipelineAmount__c += dRenewalAmount;
            }
            else if (iFiscalMonth == 3) {
              oSalesForecastSnapshot.M3_NewSalePipelineAmount__c = dNewSaleAmount;
              oSalesForecastSnapshot.M3_RenewalPipelineAmount__c = dRenewalAmount;
            }
          }
        }
      }  
    }
  
  /**
   * Retrieves a map of Users that with a map of UserQuota__c objects by fiscal month
   *
   * @param  setUserIds  a set of User object ids
   * @return  a map of User ids to a map of fiscal months to UserQuota__c objects
   */
  /*private Map<Id, Map<string, UserQuota__c>> mapUserQuotasByUserIdAndFiscalMonth(Set<Id> setUserIds) {
      Map<Id, Map<string, UserQuota__c>> mapUserQuota = new Map<Id, Map<string, UserQuota__c>>();
      
      for(UserQuota__c oUserQuota : queryUserQuotas(setUserIds)) {
        if(mapUserQuota.containsKey(oUserQuota.User__c)) {
          mapUserQuota.get(oUserQuota.User__c).put(oUserQuota.Fiscal_Month__c, oUserQuota);
        }
        else {
          mapUserQuota.put(oUserQuota.User__c, new Map<string, UserQuota__c> { oUserQuota.Fiscal_Month__c => oUserQuota });
        }
      }  
      
      return mapUserQuota;
    }

  //Private Query Methods
  
  /**
   * Queries a SalesForecast__c object based on the specified id
   *
   * @param  salesForecastId  a SalesForecast__c object id
   * @return  a SalesForecast__c object
   */
  /*private SalesForecast__c querySalesForecast(Id salesForecastId) {
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
        FROM 
          SalesForecast__c 
        WHERE 
          Id = :salesForecastId];
  }

  /**
   * Queries all SalesForecastSnapshot__c objects associated to the specified
   * SalesForecast__c object id
   *
   * @param  salesForecastId  a SalesForecast__c object id
   * @return  a list of SalesForecastSnapshot__c objects
   */
  /*private List<SalesForecastSnapshot__c> querySalesForecastSnapshots(Id salesForecastId) {
    return [SELECT
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
          SalesForecastSnapshot__c
        WHERE  
          SalesForecast__c = :salesForecastId];
  }
  
  /**
   * Queries a list of all Territories that are associated with the 
   * specified User object id by way of the UserTerritory object
   *
   * @param  userId  a User object id
   * @return  a list of Territory objects
   */
  /*private List<Territory2> queryTerritoriesByUserId(Id userId) {
    return [SELECT 
          Id
          , Name 
          , ParentTerritory2Id
          , TMS_Market_Segment_Desc__c
          , TMS_Market_Segment_ID__c
          , TMS_Parent_Territory_ID__c
          , TMS_Rep_Function_Desc__c
          , TMS_Rep_Function_ID__c
          , TMS_Sales_Force_Desc__c
          , TMS_Sales_Force_ID__c
          , TMS_Terr_Num__c
          , TMS_Territory_ID__c
        FROM 
          Territory2
        WHERE
          Id IN (SELECT Territory2Id FROM UserTerritory2Association WHERE IsActive=true AND UserId = :userId)];
  }

  /**
   * Queries a list of all Territory objects that are children of the specified
   * set of Territory object ids
   *
   * @param  setTerritoryIds  a set of Territory object ids
   * @return  a list of Territory objects
   */
  /*private List<Territory2> queryChildTerritories(Set<Id> setTerritoryIds) {
    return [SELECT 
          Id
          , Name 
          , ParentTerritory2Id
          , TMS_Market_Segment_Desc__c
          , TMS_Market_Segment_ID__c
          , TMS_Parent_Territory_ID__c
          , TMS_Rep_Function_Desc__c
          , TMS_Rep_Function_ID__c
          , TMS_Sales_Force_Desc__c
          , TMS_Sales_Force_ID__c
          , TMS_Terr_Num__c
          , TMS_Territory_ID__c
        FROM 
          Territory2
        WHERE
          ParentTerritory2Id IN :setTerritoryIds];
  }

  /**
    * Queries all UserQuota__c objects associated with the specified set of User ids
   *
   * @param  setUserIds  a set of User object ids
   * @return  a list of UserQuota__c objects
   */
  /*private List<UserQuota__c> queryUserQuotas(Set<Id> setUserIds) {
    return [SELECT 
          Id
          , User__c
          , Fiscal_Month__c
          , New_Sale__c
          , Renewal__c 
        FROM 
          UserQuota__c 
        WHERE 
          User__c IN :setUserIds];
  }
  
  /**
     * Aggregates sales totals for Opportunity records based on the specified set of owner ids and fiscal quarter
     *
     * @param  setOwnerIds  a set of User object ids
     * @param  oFiscalQuarter  an instance of a Period object
     * @return  a list of AggregateResult objects
     */
    /*private AggregateResult[] aggregateFiscalMonthSales(Set<Id> setOwnerIds, Period oFiscalMonth) {
      return [SELECT 
            OwnerId
            , Owner.Name
            , ForecastCategoryName
            , SUM(Total_Incremental__c) TotalNewSaleAmount
            , SUM(Total_Renewal__c) TotalRenewalAmount 
          FROM 
            Opportunity 
          WHERE 
            OwnerId IN :setOwnerIds 
            AND 
            (CloseDate >= :oFiscalMonth.StartDate AND CloseDate <= :oFiscalMonth.EndDate)
          GROUP By 
            OwnerId
            , Owner.Name
            , ForecastCategoryName
          ORDER By
            OwnerId];
    }*/
}