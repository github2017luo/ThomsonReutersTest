/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class PricingWebService {
    global PricingWebService() {

    }
    webService static List<Integer> checkAndMarkDependentPricePending(Id configId, Decimal lineNumber) {
        return null;
    }
    global static Apttus_Config2__LineItem__c computeBasePriceForItem(Apttus_Config2.ProductConfiguration configMO, Id itemId, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate) {
        return null;
    }
    webService static Boolean computeBasePriceForItemColl(Id configId, Decimal lineNumber) {
        return null;
    }
    webService static List<Apttus_Config2__LineItem__c> computeBasicPriceForItemColl(Apttus_Config2__ProductConfiguration__c configSO, List<Apttus_Config2__LineItem__c> prodLineItems) {
        return null;
    }
    webService static Boolean computeNetPriceForItemColl(Id configId, Decimal lineNumber) {
        return null;
    }
    webService static Boolean computeTotalPriceForCart(Id configId) {
        return null;
    }
    global static Apttus_Config2.CustomClass.UsagePriceResult computeUsagePrice(Apttus_Config2.CustomClass.UsageInput input) {
        return null;
    }
    webService static List<Apttus_Config2__PriceListItem__c> convertPriceForPriceItems(Apttus_Config2__ProductConfiguration__c configSO, List<Apttus_Config2__PriceListItem__c> items) {
        return null;
    }
    webService static Boolean executeTotalPriceStepForCart(Id configId, String stepName) {
        return null;
    }
    webService static List<Integer> getLineNumbersAwaitingPrice(Id configId) {
        return null;
    }
    webService static List<Apttus_Config2.PricingWebService.LineItemDO> getSummaryLineItemsForConfiguration(Id configId) {
        return null;
    }
    global static void loadPriceMatrices(List<Id> matrixIds) {

    }
    webService static List<Apttus_Config2.UsagePriceTierDO> selectUsagePriceTiers(Id matrixId, List<Apttus_Config2.UsagePriceTierDO> usagePriceTiers, List<Apttus_Config2.Property> itemState) {
        return null;
    }
    global static Boolean updateManualAdjustmentsForCart(Id configId, Map<Id,List<Apttus_Config2__AdjustmentLineItem__c>> adjItemsByParentItem) {
        return null;
    }
    webService static Boolean updateNetPriceForItemColl(List<Apttus_Config2__LineItem__c> itemColl) {
        return null;
    }
    webService static Apttus_Config2.CPQStruct.PricePendingInfo updatePriceForCart(Id configId) {
        return null;
    }
global class LineItemDO {
    webService Id LineItemId {
        get;
    }
    webService Decimal LineNumber {
        get;
    }
    webService String LineStatus {
        get;
    }
}
}
