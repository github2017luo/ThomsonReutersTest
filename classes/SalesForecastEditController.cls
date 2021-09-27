/**
 * Controller for the SalesForecastEdit.page that extends the 
 * SalesForecast__c standard controller
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
public with sharing class SalesForecastEditController {
    //Protected Members
    private final ApexPages.StandardController oStandardController;
    private SalesForecast__c oSalesForecast;
    
    //Constructors
    
    /**
     * SalesForecast__c Standard Controller Constructor
     *
     * @param   oController an instance of an ApexPages.StandardController object
     */
    public SalesForecastEditController(ApexPages.StandardController oController) {
        try {
            oStandardController = oController;
            oSalesForecast = (SalesForecast__c) oStandardController.getRecord();
            
            oSalesForecast.OwnerId = AppUtil.isNull(oSalesForecast.OwnerId, UserInfo.getUserId());
            oSalesForecast.FiscalYear__c = AppUtil.isNull(oSalesForecast.FiscalYear__c, string.valueOf(System.today().year()));
            oSalesForecast.FiscalQuarter__c = AppUtil.isNUll(oSalesForecast.FiscalQuarter__c, getCurrentFiscalQuarter());
        }
        catch (Exception oException) {ApexPages.addMessages(oException);}
    }
    
    //Public Methods
    
    /**
     * Saves the current record and redirects the user to the new detail screen
     * if save is successful
     *
     * @return  a PageReference object
     */
    public PageReference save() {
        PageReference oPageReference = null;
        
        try {
            boolean bIsInsert = (oSalesForecast.Id == null);
            PageReference oSavePageReference = oStandardController.save();
            
            if (oSavePageReference != null && bIsInsert && SalesForecastUtil.isAutoRefreshEnabled(oSalesForecast)) {
                Id salesForecastId = oStandardController.getId();
                    
                /*SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
                oUpdater.updateSalesForecastSnapshots(salesForecastId);*/
            }
            oPageReference = oSavePageReference;        
        }
        catch (Exception oException) { ApexPages.addMessages(oException);}
        
        return oPageReference;
    }
    
    /**
     * Saves the current record and redirects the user to the new edit screen
     * if save is successful
     *
     * @return  a PageReference object
     */
    public PageReference saveNew() {
        PageReference oPageReference = null;
        
        try {
            oPageReference = save();
            
            if (oPageReference != null) {
                string sNewRecordId = '/' + oStandardController.getId();
                
                string sPrefix = Schema.SObjectType.SalesForecast__c.getKeyPrefix();
                string sNewURL = String.format('/{0}/e', new string[]{ sPrefix });
                string sRetURL = String.format('/{0}', new string[]{ sNewRecordId });
                
                 if(sNewURL.startsWith('/')){
                    sNewURL=sNewURL.replaceFirst('/','');
                    }
                oPageReference = new PageReference('/'+sNewURL);
                oPageReference.setRedirect(true);
                oPageReference.getParameters().put('retURL', sRetURL);
            }
        }
        catch (Exception oException) {ApexPages.addMessages(oException);}
        
        return oPageReference;
    }
    
    //Private Methods
    
    /**
     * Identifies and returns the current fiscal quarter
     *
     * @return  a string representing the current fiscal quarter using the format Q(n)
     */
    private string getCurrentFiscalQuarter() {
        string sFiscalQuarter = 'Q1';
        
        List<Period> listFiscalMonths = [SELECT Id, Number, StartDate, EndDate FROM Period WHERE Type = 'Quarter' AND (StartDate <= :System.today() AND EndDate >= :System.today()) ORDER By Number];
        if (listFiscalMonths.isEmpty() == false) {
            sFiscalQuarter = 'Q' + string.valueOf(listFiscalMonths[0].Number);
        }
        
        return sFiscalQuarter;
    }
}