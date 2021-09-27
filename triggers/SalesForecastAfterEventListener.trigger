trigger SalesForecastAfterEventListener on SalesForecast__c (after delete, after insert, after undelete, after update) {
    if (trigger.isUpdate) {
        SalesForecastUtil.afterUpdateSalesForecast(trigger.new, trigger.oldMap);
    }
}