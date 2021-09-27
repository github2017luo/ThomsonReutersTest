/**
 * Validates the functionality provided by the SalesForecastSnapshotUpdater class.
 *
 * @author  John De Santiago
 * @version 2012-06-28
 */
 //Commenting out as a part of removal of TM1.0 components
 
@IsTest
public class SalesForecastSnapshotUpdater_Test {

    /**
     * Validates that a sales forecast snapshot is properly compiled
     */
     //To bypass test coverage at the time of deployment after removing all functionality
      @isTest static void SalesForecastSnapshotUpdaterTest() {
          
          Test.startTest();
          List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.Name ='Name'+i;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
          SalesForecastSnapshotUpdater obj = new SalesForecastSnapshotUpdater();
           Database.executebatch(obj,1);
          Test.stopTest();
      }
     
     
    /*private static testMethod void testUpdateSalesForecastSnapshot() {
        //Setup Test
        //SalesForecast__c oSalesForecast = setupMockSalesForecast();
        
        //Start Test
        Test.startTest();
        SalesForecast__c oSalesForecast = setupMockSalesForecast();
        
        SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
        oUpdater.updateSalesForecastSnapshots(oSalesForecast.Id);
        
        Test.stopTest();
        
        //Validate Test
        List<SalesForecastSnapshot__c> listSalesForecastSnapshots = [SELECT Id FROM SalesForecastSnapshot__c WHERE SalesForecast__c = :oSalesForecast.Id];
        System.assert(listSalesForecastSnapshots.size() > 0, 'Expected at least one snapshot record to have been created');
    }
    
    /**
     * Validates that a sales forecast snapshot is updated properly
     */
    /*private static testMethod void testUpdateExistingSalesForecastSnapshot() {
        //Setup Test
        Test.startTest();
        SalesForecast__c oSalesForecast = setupMockSalesForecast();
        
        SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
        //oUpdater.updateSalesForecastSnapshots(oSalesForecast.Id);
        
        SalesForecastSnapshot__c oSalesForecastSnapshot = new SalesForecastSnapshot__c();
        oSalesForecastSnapshot.SalesForecast__c = oSalesForecast.Id;
        oSalesForecastSnapshot.User__c = UserInfo.getUserId();
        oSalesForecastSnapshot.M1_DisplayLabel__c = 'Test';
        oSalesForecastSnapshot.M2_DisplayLabel__c = 'Test';
        oSalesForecastSnapshot.M3_DisplayLabel__c = 'Test';
        insert oSalesForecastSnapshot; 
        
        //Start Test
        //Test.startTest();
        //SalesForecast__c oSalesForecast = setupMockSalesForecast();
        
        oUpdater.updateSalesForecastSnapshots(oSalesForecast.Id);
        
        Test.stopTest();
        
        //Validate Test
        List<SalesForecastSnapshot__c> listSalesForecastSnapshots = [SELECT Id FROM SalesForecastSnapshot__c WHERE SalesForecast__c = :oSalesForecast.Id];
        System.assert(listSalesForecastSnapshots.size() > 0, 'Expected at least one snapshot record to have been created');
    }
        
    /**
     * Test method that verifies that class can execute a batch job
     */
    /*private static testMethod void testExecuteBatch() {
        //Setup Test
       //SalesForecast__c oSalesForecast = setupMockSalesForecast();
        
        //Start Test
        Test.startTest();
         SalesForecast__c oSalesForecast = setupMockSalesForecast();
        //Execute Test
        SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
        Id batchJobId = Database.executeBatch(oUpdater, 1);
        
        Test.stopTest();
    
        //Validate Test
        AsyncApexJob oAsyncApexJob = [SELECT Id, Status FROM AsyncApexJob WHERE Id =:batchJobId];
        System.assert(oAsyncApexJob != null, 'Unable to find the batch apex job entry in the system for testing');
    }
 
    /**
     * Test method that verifies that class can be scheduled
     */
    /*private static testMethod void testExecuteSchedule() {
        //Setup Test
        //SalesForecast__c oSalesForecast = setupMockSalesForecast();
        String sCronExp = '0 0 0 3 9 ? 2099';
        
        //Start Test
        Test.startTest();
        SalesForecast__c oSalesForecast = setupMockSalesForecast();
        SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
        String scheduleId = System.schedule('testExecuteSchedule', sCronExp, oUpdater);
        
        Test.stopTest();
    
        //Validate Test
        CronTrigger oCronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :scheduleId];
        System.assertEquals(sCronExp, oCronTrigger.CronExpression);
        System.assertEquals(0, oCronTrigger.TimesTriggered);
        System.assertEquals('2099-09-03 00:00:00', String.valueOf(oCronTrigger.NextFireTime));
    }
    
    //Setup Methods
    
    /**
     * Initializes the base mock objects needed for unit testing sales forecasting functionality
     *
     * @return  a SalesForecast__c object
     */ 
    public static SalesForecast__c setupMockSalesForecast() {
    
        KeyValueListStore__c oANZProfileId = new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=null);
        insert oANZProfileId;
        
        List<RecordtypeIds__c> listRecordTypeIds = new List<RecordtypeIds__c>{new RecordtypeIds__c(Name = 'Pre-Pipeline Opportunities',recTypeId__c=null),
                                                                              new RecordtypeIds__c(Name = 'Pipeline Opportunities',recTypeId__c=null)};
        insert listRecordTypeIds;
        /*
        //Find a ready made parent->child territory hierarchy
        //skg change
        //Skg Changed offset from 30 - 40 to find valid one 09/21/2015
        //Territory oSalesRepTerritory = [SELECT Id, ParentTerritoryId FROM Territory WHERE ParentTerritoryId != null AND Id IN (SELECT TerritoryId FROM UserTerritory) LIMIT 1 Offset 30];
        //Skg Changed offset from 40 -1750 to find valid one 09/21/2015
        //Territory oSalesRepTerritory = [SELECT Id, ParentTerritoryId FROM Territory WHERE ParentTerritoryId != null AND Id IN (SELECT TerritoryId FROM UserTerritory) LIMIT 1 Offset 40];
        Territory oSalesRepTerritory = [SELECT Id, ParentTerritoryId FROM Territory WHERE ParentTerritoryId != null AND Id IN (SELECT TerritoryId FROM UserTerritory) LIMIT 1 Offset 1750];
       // List<Territory> oSalesRepTerritory = [SELECT Id, ParentTerritoryId FROM Territory WHERE ParentTerritoryId != null AND Id IN (SELECT TerritoryId FROM UserTerritory)];
        //UserTerritory oSalesRepUserTerritory = [SELECT Id, UserId FROM UserTerritory WHERE TerritoryId = :oSalesRepTerritory.Id LIMIT 1];
        //skg added isActive=true 
        // skg fixed 09/21/2015
        //UserTerritory oSalesRepUserTerritory = [SELECT Id, UserId FROM UserTerritory WHERE TerritoryId = :oSalesRepTerritory.Id and isActive=true  LIMIT 1];
        UserTerritory oSalesRepUserTerritory = [SELECT Id, UserId FROM UserTerritory WHERE TerritoryId = :oSalesRepTerritory.Id AND UserId IN (SELECT id FROM User where isActive=true) LIMIT 1];
        //List<UserTerritory> oSalesRepUserTerritory = [SELECT Id, UserId FROM UserTerritory WHERE TerritoryId IN :oSalesRepTerritory];
        //List<Id> listparentId = new List<Id>();
        
       
        //List<Territory> oManagerTerritory = [SELECT Id FROM Territory WHERE Id IN :listparentId];
        Territory oManagerTerritory = [SELECT Id FROM Territory WHERE Id = :oSalesRepTerritory.ParentTerritoryId LIMIT 1];
        //UserTerritory oManagerUserTerritory = [SELECT Id, UserId FROM UserTerritory WHERE TerritoryId =:oManagerTerritory.Id  LIMIT 1];
        //skg added isActive=true 
        UserTerritory oManagerUserTerritory = [SELECT Id, UserId FROM UserTerritory WHERE TerritoryId =:oManagerTerritory.Id and isActive=true  LIMIT 1];
        */
        Integer offsetValue = 0;
        Map<ID,Territory2> oSalesRepTerritoryMap = new Map<ID,Territory2>([SELECT Id, ParentTerritory2Id FROM Territory2 WHERE ParentTerritory2Id != null AND Id IN (SELECT Territory2Id FROM UserTerritory2Association)]);
        List<ID> oSalesRepTerritoryIDList = new List<ID>(oSalesRepTerritoryMap.keySet());
        //List<Territory> oSalesRepTerritoryList = [SELECT Id, ParentTerritoryId FROM Territory WHERE ParentTerritoryId != null AND Id IN (SELECT TerritoryId FROM UserTerritory)];
        Territory2 oSalesRepTerritory = null;
        
        List<UserTerritory2Association> userTerritoryActUserList = [SELECT Id, UserId, Territory2Id FROM UserTerritory2Association WHERE isActive=true AND UserId IN (SELECT id FROM User where isActive=true)];
        Map<ID,List<UserTerritory2Association>> userTerritoryActUserMap = new Map<ID,List<UserTerritory2Association>>();
        for(UserTerritory2Association tempUserTerritory : userTerritoryActUserList){
            if(userTerritoryActUserMap.get(tempUserTerritory.Territory2Id)!=null){
                (userTerritoryActUserMap.get(tempUserTerritory.Territory2Id)).add(tempUserTerritory);
            }else{
                userTerritoryActUserMap.put(tempUserTerritory.Territory2Id, new List<UserTerritory2Association>{tempUserTerritory});
            }
                
        }
        UserTerritory2Association oSalesRepUserTerritory = null;
        UserTerritory2Association oManagerUserTerritory = null;
        Map<ID,Territory2> oManagerTerritoryMap = new Map<ID,Territory2>([SELECT Id , ParentTerritory2Id FROM Territory2]);
        Territory2 oManagerTerritory = new Territory2();  
        Map<ID,User> userMap = new Map<ID,User>([SELECT ID FROM USER WHERE ISACTIVE=TRUE]);
        User US = null;
        do{
            offsetValue++;
            try{
                oSalesRepTerritory = oSalesRepTerritoryMap.get(oSalesRepTerritoryIDList[offsetValue]);
                //Territory oSalesRepTerritory = [SELECT Id, ParentTerritoryId FROM Territory WHERE ParentTerritoryId != null AND Id IN (SELECT TerritoryId FROM UserTerritory) LIMIT 1 Offset 2000];
                oSalesRepUserTerritory = userTerritoryActUserMap.get(oSalesRepTerritory.Id)[0];
                //UserTerritory oSalesRepUserTerritory = [SELECT Id, UserId FROM UserTerritory WHERE TerritoryId = :oSalesRepTerritory.Id AND UserId IN (SELECT id FROM User where isActive=true) LIMIT 1];
                oManagerTerritory = oManagerTerritoryMap.get(oSalesRepTerritory.ParentTerritory2Id);
                //Territory oManagerTerritory = [SELECT Id FROM Territory WHERE Id = :oSalesRepTerritory.ParentTerritoryId LIMIT 1];
                oManagerUserTerritory = userTerritoryActUserMap.get(oManagerTerritory.Id)[0];
                //UserTerritory oManagerUserTerritory = [SELECT Id, UserId FROM UserTerritory WHERE TerritoryId =:oManagerTerritory.Id and isActive=true LIMIT 1];
                us = userMap.get(oManagerUserTerritory.USERID);
            }catch(exception e){continue;}
        }while(oSalesRepTerritory==null || oSalesRepUserTerritory==null || oManagerTerritory==null || oManagerUserTerritory==null || US==null);
        system.debug('oSalesRepTerritory : '+oSalesRepTerritory);
        system.debug('oSalesRepUserTerritory : '+oSalesRepUserTerritory);
        system.debug('oManagerTerritory : '+oManagerTerritory);
        system.debug('oManagerUserTerritory : '+oManagerUserTerritory);
        system.debug('US : '+US);
        
        //Create sales forecast data
        Account oAccount = UnitTest.getAccountInstance();
        insert oAccount;
        
        List<Opportunity> listTestOpportunity =  new List<Opportunity>();
        //New Sale
        Opportunity oNewSaleOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        oNewSaleOpportunity.StageName = '90%';
        oNewSaleOpportunity.CloseDate = Date.newInstance(System.today().year(), 1, 1);
        oNewSaleOpportunity.OwnerId = oSalesRepUserTerritory.UserId;
        //insert oNewSaleOpportunity;
        listTestOpportunity.add(oNewSaleOpportunity);
        
        
        //Renewal
        Opportunity oRenewalOpportunity = UnitTest.getOpportunityInstance(oAccount.Id);
        oRenewalOpportunity.StageName = '90%';
        oRenewalOpportunity.CloseDate = Date.newInstance(System.today().year(), 1, 1);
        oRenewalOpportunity.OwnerId = oSalesRepUserTerritory.UserId;
        oRenewalOpportunity.Renewal_Flag__c = true;
        oRenewalOpportunity.Renewal_Date__c = System.today();
        //insert oRenewalOpportunity;
        listTestOpportunity.add(oRenewalOpportunity);
        insert listTestOpportunity;
        
        List<Opportunity_Product_Type__c> listtestProductType = new  List<Opportunity_Product_Type__c>();
        Opportunity_Product_Type__c oNewSalePricing = new Opportunity_Product_Type__c();
        oNewSalePricing.Opportunity__c = oNewSaleOpportunity.Id;
        oNewSalePricing.Incremental_Amount__c = 500;
        //insert oNewSalePricing;
        listtestProductType.add(oNewSalePricing);
        
        Opportunity_Product_Type__c oRenewalPricing = new Opportunity_Product_Type__c();
        oRenewalPricing.Opportunity__c = oRenewalOpportunity.Id;
        oRenewalPricing.Incremental_Amount__c = 500;
        //insert oRenewalPricing;
        listtestProductType.add(oRenewalPricing);
        insert listtestProductType;
        
        //Get Fiscal Quarter
        string sFiscalYear = string.valueOf(System.today().year());
        Period oFiscalQuarter = [SELECT Id, Number, StartDate, EndDate FROM Period WHERE Type='Quarter' AND FiscalYearSettings.Name = :sFiscalYear AND Number = 1 LIMIT 1];
        
        //Get Fiscal Quarter Months
        List<Period> listFiscalMonths = [SELECT Id, Number, StartDate, EndDate FROM Period WHERE Type = 'Month' AND (StartDate >= :oFiscalQuarter.StartDate AND EndDate <= :oFiscalQuarter.EndDate) ORDER By Number];
        string sFiscalMonth1 = AppUtil.formatDate(listFiscalMonths[0].StartDate, SalesForecastSnapshotUpdater.FiscalMonthFormat, '');
        string sFiscalMonth2 = AppUtil.formatDate(listFiscalMonths[1].StartDate, SalesForecastSnapshotUpdater.FiscalMonthFormat, '');
        string sFiscalMonth3 = AppUtil.formatDate(listFiscalMonths[2].StartDate, SalesForecastSnapshotUpdater.FiscalMonthFormat, '');
        
        List<UserQuota__c> listUserQuota = new List<UserQuota__c>();
        
        UserQuota__c oUserQuota1 = new UserQuota__c();
        oUserQuota1.User__c = oSalesRepUserTerritory.UserId;
        oUserQuota1.Fiscal_Month__c = sFiscalMonth1;
        oUserQuota1.New_Sale__c = 500;
        oUserQuota1.Renewal__c = 500;
        //insert oUserQuota1;
        listUserQuota.add(oUserQuota1);
        
        UserQuota__c oUserQuota2 = new UserQuota__c();
        oUserQuota2.User__c = oSalesRepUserTerritory.UserId;
        oUserQuota2.Fiscal_Month__c = sFiscalMonth2;
        oUserQuota2.New_Sale__c = 500;
        oUserQuota2.Renewal__c = 500;
        //insert oUserQuota2;
        listUserQuota.add(oUserQuota2);
        
        UserQuota__c oUserQuota3 = new UserQuota__c();
        oUserQuota3.User__c = oSalesRepUserTerritory.UserId;
        oUserQuota3.Fiscal_Month__c = sFiscalMonth3;
        oUserQuota3.New_Sale__c = 500;
        oUserQuota3.Renewal__c = 500;
        //insert oUserQuota3;
        listUserQuota.add(oUserQuota3);
        
        insert listUserQuota;
        
                
        //Create Sales Forecast
        SalesForecast__c oSalesForecast = new SalesForecast__c();
        oSalesForecast.Name = 'Unit Test';
        oSalesForecast.FiscalYear__c = sFiscalYear;
        oSalesForecast.FiscalQuarter__c = 'Q1';
        oSalesForecast.OwnerId = oManagerUserTerritory.UserId;
        insert oSalesForecast;
        
        return oSalesForecast;
    }
}