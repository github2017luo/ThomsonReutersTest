/**
 * Controller for the SalesForecastClone.page that extends the 
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
public with sharing class SalesForecastCloneController {
	private final ApexPages.StandardController oStandardController;
	private final SalesForecast__c oSalesForecast;
	
	/**
	 * SalesForecast__c Standard Controller Constructor
	 *
	 * @param	oController	an instance of an ApexPages.StandardController object
	 */
	public SalesForecastCloneController(ApexPages.StandardController oController) {
		try {
			oStandardController = oController;
			oSalesForecast = (SalesForecast__c) oController.getRecord();
		}	
		catch (Exception oException) {
			ApexPages.addMessages(oException);
		}
	}
	
	/**
	 * Overrides the native clone process with a method that can perform a deep clone of
	 * a SalesForecast__c object with it's related SalesForecastSnapshot__c objects
	 */
	public PageReference cloneSalesForecast() {
		PageReference oPageReference = null;
		
		try {
			SalesForecast__c oSalesForecastClone = SalesForecastUtil.deepCloneSalesForecast(oSalesForecast.Id);
			string sEditUrl = String.format('/{0}/e?retURL=/{0}', new List<string>{ oSalesForecastClone.Id });
			
			oPageReference = new PageReference(sEditUrl);
		}
		catch (Exception oException) {
			ApexPages.addMessages(oException);
		}
		
		return oPageReference;
	}
}