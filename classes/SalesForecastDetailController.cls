/**
 * Controller for the SalesForecastDetail.page that extends the 
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
public with sharing class SalesForecastDetailController {
    //Protected Members
    private final ApexPages.StandardController oStandardController;
    private SalesForecast__c oSalesForecast;
    
    public static final string FiscalMonthParam = 'view';
    
    //Properties
    public boolean IsLocked {get;set;}
    public List<SalesForecastSnapshot__c> SalesForecastSnapshots {get;set;}
    public string SelectedView {get;set;}
    public List<SelectOption> ViewOptions {get; set;} 
    
    //Constructors
    
    /**
     * SalesForecast__c Standard Controller Constructor
     *
     * @param   oController an instance of an ApexPages.StandardController object
     */
    public SalesForecastDetailController(ApexPages.StandardController oController) {
        try {
            oStandardController = oController;
            oSalesForecast = [SELECT Id, FiscalYear__c, FiscalQuarter__c , FiscalQuarterPeriod__c, Status__c, name, Owner.name FROM SalesForecast__c WHERE Id =: oController.getId()];
        
            this.SalesForecastSnapshots = querySalesForecastSnapshotsBySalesForecastId(oSalesForecast.Id);
            this.SelectedView = AppUtil.getURLParam(ApexPages.CurrentPage(), FiscalMonthParam, '0');
            this.ViewOptions = getViewOptions();
            
            this.IsLocked = (oSalesForecast.Status__c == 'Submitted');
            
            if (this.IsLocked == false) {
                UserRecordAccess oUserRecordAccess = [SELECT RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =: oSalesForecast.Id];
                if (oUserRecordAccess.HasEditAccess == false) {
                    this.isLocked = true;
                }
            }
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
    }
    
    //Public Methods

    /**
     * Initiates the process to submit the forecast and redirects the user to the detail view
     *
     * @return  a PageReference object referencing the SalesForecast__c object detail view
     */
    public PageReference submitForecast() {
        PageReference oPageReference = null;
        
        try {
            Messaging.SingleEmailMessage oEmail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new String[] {'TLR.salesforce.com-forecast@thomsonreuters.com'};
            //String[] toAddresses = new String[] {'TLR.salesforce.com-forecast@thomsonreuters.com','emily.weir@thomsonreuters.com'};
            //String[] toAddresses = new String[] {'TLR.salesforce.com-forecast@thomsonreuters.com','shawn.gray@thomsonreuters.com'};
            //String[] toAddresses = new String[] {'emily.weir@thomsonreuters.com'};
            //String[] toAddresses = new String[] {'shawn.gray@thomsonreuters.com'};  
            oEmail.setToAddresses(toAddresses);
            oEmail.setSenderDisplayName('Sales Forecast');
            oEmail.setSubject(oSalesForecast.Name + ' is submited by ' + oSalesForecast.owner.name);
            oEmail.setPlainTextBody(osalesforecast.owner.name + ' submited a forecast.');
            
            /*
            oEmail.setSubject('Sales Forecast');
            oEmail.setSubject(oSalesForecast.Name);
            oEmail.setPlainTextBody('Your Forecast: ' + oSalesForecast.name +' has been Submitted.');*/


            //Attach Document
            PageReference oForecastExportPageReference = Page.SalesForecastExport;
            oForecastExportPageReference.setRedirect(false);
            
            Blob blobData;
            
            Blob st = Blob.ValueOf('Rm9yZWNhc3QgT3duZXIJTmV3IFNhbGUvUmVuZXdhbAlGaXNjYWwgTW9udGgJTm9uLVBpcGVsaW5lIFJpc2svVXBzaWRlCUNvbW1pdCBGb3JlY2FzdAlDbG9zZWQgRm9yZWNhc3QJQWRqdXN0ZWQgRm9yZWNhc3QJUXVvdGEJJSBRdW90YQlHQVAKU2F0ZWVzaAlOZXcgU2FsZXMJTWF5CU5vCVllcwlObwkxMCUJNTAlCTEwJQkK');
            blobData = (Test.IsRunningTest())?st:oForecastExportPageReference.getContent();
            
            
            Messaging.EmailFileAttachment oAttachment = new Messaging.EmailFileAttachment();
            oAttachment.setFileName('sales_forecast_export.xls');
            oAttachment.setBody(blobData);

            oEmail.setFileAttachments(new Messaging.EmailFileAttachment[]{ oAttachment });






            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { oEmail });
            
            oSalesForecast.SubmittedDate__c = system.today(); 
            oSalesForecast.SubmittedToEmail__c = toAddresses[0]; 
            oSalesForecast.Status__c = 'Submitted';
            update oSalesForecast;
            
            oPageReference = oStandardController.view();
            oPageReference.getParameters().put(FiscalMonthParam, SelectedView);
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
        
        return oPageReference;      
    }
    /**
     * Initiates a request to download the current sales forecast details
     *
     * @return  a PageReference object
     */
    public PageReference exportSalesForecast() {
        PageReference oPageReference = Page.SalesForecastExport;
        oPageReference.setRedirect(false);
        
        return oPageReference;  
    }
        
    /**
     * Initiates the process to save the snapshot for the current sales forecast
     * and redirects the user to the detail view
     *
     * @return  a PageReference object referencing the SalesForecast__c object detail view
     */
    public PageReference saveSnapshot() {
        PageReference oPageReference = null;
        
        try {
            update SalesForecastSnapshots;
            oPageReference = oStandardController.view();
            oPageReference.getParameters().put(FiscalMonthParam, SelectedView);
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
        
        return oPageReference;
    }
    
    /**
     * Initiates the process to refresh the snapshot for the current sales forecast
     * and redirects the user to the detail view
     *
     * @return  a PageReference object referencing the SalesForecast__c object detail view
     */
    public PageReference refreshSnapshot() {
        PageReference oPageReference = null;
        
        try {
            update SalesForecastSnapshots;
            
            SalesForecastSnapshotUpdater oUpdater = new SalesForecastSnapshotUpdater();
            //oUpdater.updateSalesForecastSnapshots(oSalesForecast.Id);
        
            oPageReference = oStandardController.view();
            oPageReference.getParameters().put(FiscalMonthParam, SelectedView);
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }
        
        return oPageReference;
    }
    
    //Private Methods
    
    private List<SelectOption> getViewOptions() {
        List<SelectOption> listSelectOptions = new List<SelectOption>();
                
        //Get Fiscal Quarter
        Period oFiscalQuarter = [SELECT Id, Number, StartDate, EndDate FROM Period WHERE Type='Quarter' AND FiscalYearSettings.Name = :oSalesForecast.FiscalYear__c AND Number = :integer.valueOf(oSalesForecast.FiscalQuarterPeriod__c) LIMIT 1];
        
        //Get Fiscal Quarter Months
        List<Period> listFiscalMonths = [SELECT Id, Number, StartDate, EndDate FROM Period WHERE Type = 'Month' AND (StartDate >= :oFiscalQuarter.StartDate AND EndDate <= :oFiscalQuarter.EndDate) ORDER By Number];
        
        string sDateFormat = SalesForecastSnapshotUpdater.FiscalMonthFormat;
        string sFiscalMonth1 = AppUtil.formatDate(listFiscalMonths[0].StartDate, sDateFormat, '');
        string sFiscalMonth2 = AppUtil.formatDate(listFiscalMonths[1].StartDate, sDateFormat, '');
        string sFiscalMonth3 = AppUtil.formatDate(listFiscalMonths[2].StartDate, sDateFormat, '');
        
        listSelectOptions.add(new SelectOption('1', sFiscalMonth1));
        listSelectOptions.add(new SelectOption('2', sFiscalMonth2));
        listSelectOptions.add(new SelectOption('3', sFiscalMonth3));
        listSelectOptions.add(new SelectOption('0', 'View All'));
        
        return listSelectOptions;
    }
    
    /**
     * Queries the database for SalesForecastSnaphot__c records by the specified SalesForecast__c object id
     *
     * @param   salesForecastId a SalesForecast__c object id
     * @return  a list of SalesForecastSnapshot__c objects
     */
    private List<SalesForecastSnapshot__c> querySalesForecastSnapshotsBySalesForecastId(Id salesForecastId) {
        return  [SELECT 
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
                    , Name
                    , SalesForecast__c
                    , User__c
                    , User__r.Name
                FROM 
                    SalesForecastSnapshot__c
                WHERE
                    SalesForecast__c = :salesForecastId
                ORDER BY
                    User__r.Name];
    }
}