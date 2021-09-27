/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ViewConfigController {
    global Id appliedActionInfoId {
        get;
        set;
    }
    global Product2 ctxProduct {
        get;
    }
    global String ctxProductId {
        get;
        set;
    }
    global String curTabSelection {
        get;
        set;
    }
    global String fromBizTitle {
        get;
    }
    global String fromBizType {
        get;
    }
    global Decimal lineItemLineNbr {
        get;
        set;
    }
    global String lineItemSOId {
        get;
        set;
    }
    global Boolean showFinalize {
        get;
    }
    global Boolean showLineItemEdit {
        get;
    }
    global Boolean showView {
        get;
    }
    global ViewConfigController(ApexPages.StandardController stdController) {

    }
    global Apttus_Config2.LineItem copyAndInsertLineItem(Id lineItemId) {
        return null;
    }
    global System.PageReference doAbandon() {
        return null;
    }
    global void doAddAdjustmentRow() {

    }
    global void doAddAdjustmentRowForLineItem(Id lineItemId) {

    }
    global void doAddMiscLineItem() {

    }
    global System.PageReference doAddProducts() {
        return null;
    }
    global System.PageReference doApplyAdjustments() {
        return null;
    }
    @RemoteAction
    global static Decimal doClonePrimaryItemColl(Id configId, Decimal lineNumber) {
        return null;
    }
    @RemoteAction
    global static Boolean doComputeBasePriceForNextItemColl(Id configId) {
        return null;
    }
    @RemoteAction
    global static Boolean doComputeNetPriceForItemColl(Id configId, Decimal lineNumber) {
        return null;
    }
    @RemoteAction
    global static Boolean doComputeTotalPriceForCart(Id configId) {
        return null;
    }
    global System.PageReference doConfigure() {
        return null;
    }
    global void doCopyAndInsertLineItem() {

    }
    global void doDeleteAdjustmentRow() {

    }
    global void doDeleteAdjustmentRowsForLineItem(Id lineItemId) {

    }
    global void doDeleteCustomLineItem() {

    }
    global void doDeleteLineItem() {

    }
    global System.PageReference doEditProperties() {
        return null;
    }
    global System.PageReference doFinalize() {
        return null;
    }
    global void doGetCtxProductDetail() {

    }
    global void doHideMessage() {

    }
    global void doLoad() {

    }
    global void doMoveDownAdjustmentRow() {

    }
    global void doMoveUpAdjustmentRow() {

    }
    global void doPricing() {

    }
    global void doProcessMoreRules() {

    }
    global System.PageReference doRefreshPage() {
        return null;
    }
    global void doReload() {

    }
    global void doRepriceLineItem() {

    }
    global void doSaveAll() {

    }
    global System.PageReference doSaveAndNext() {
        return null;
    }
    global void doToggleDuration() {

    }
    global String getBOLookupFieldName() {
        return null;
    }
    global String getClassName() {
        return null;
    }
    global Apttus_Config2__ProductConfiguration__c getConfigSO() {
        return null;
    }
    global String getConfigStatusPending() {
        return null;
    }
    global Id getConfigurationId() {
        return null;
    }
    global List<Apttus_Config2.LineItem> getDetailLineItemList() {
        return null;
    }
    global Boolean getHasErrors() {
        return null;
    }
    global Boolean getIsActionAddMiscItemEnabled() {
        return null;
    }
    global Boolean getIsActionShowDurationEnabled() {
        return null;
    }
    global Boolean getIsAdHocSummary() {
        return null;
    }
    global Boolean getIsAdjustmentsPending() {
        return null;
    }
    global Boolean getIsAssetEnabled() {
        return null;
    }
    global Boolean getIsCategorySummary() {
        return null;
    }
    global Boolean getIsColumnAdjustedPriceEnabled() {
        return null;
    }
    global Boolean getIsColumnAdjustmentAmountEnabled() {
        return null;
    }
    global Boolean getIsColumnAdjustmentTypeEnabled() {
        return null;
    }
    global Boolean getIsColumnBasePriceEnabled() {
        return null;
    }
    global Boolean getIsColumnChargeTypeEnabled() {
        return null;
    }
    global Boolean getIsColumnFrequencyEnabled() {
        return null;
    }
    global Boolean getIsColumnGroupAdjustmentPercentEnabled() {
        return null;
    }
    global Boolean getIsColumnNetAdjustmentPercentEnabled() {
        return null;
    }
    global Boolean getIsColumnOptionPriceEnabled() {
        return null;
    }
    global Boolean getIsColumnQuantityEnabled() {
        return null;
    }
    global Boolean getIsColumnTermEnabled() {
        return null;
    }
    global Boolean getIsColumnTotalingGroupEnabled() {
        return null;
    }
    global Boolean getIsColumnUOMEnabled() {
        return null;
    }
    global Boolean getIsMultiAdjustmentEnabled() {
        return null;
    }
    global Boolean getIsMultiCurrency() {
        return null;
    }
    global Boolean getIsPricePending() {
        return null;
    }
    global List<Apttus_Config2.ViewConfigController.LineItemAdjInfo> getLineItemAdjustments() {
        return null;
    }
    global String getLineTypeGrandTotal() {
        return null;
    }
    global String getLineTypeOption() {
        return null;
    }
    global String getLineTypeProduct() {
        return null;
    }
    global Integer getMaxAdjustmentLines() {
        return null;
    }
    global List<System.SelectOption> getMiscChargeTypeItems() {
        return null;
    }
    global Apttus_Config2__LineItem__c getMiscLineItemSO() {
        return null;
    }
    global Integer getNumOfLineItemsAwaitingPrice() {
        return null;
    }
    global String getPriceTypeIncludedUsage() {
        return null;
    }
    global String getPriceTypeRecurring() {
        return null;
    }
    global String getPriceTypeUsage() {
        return null;
    }
    @RemoteAction
    global static Product2 getProductDescription(Id productId) {
        return null;
    }
    global Id getRequestId() {
        return null;
    }
    global String getRuleActionMessages() {
        return null;
    }
    global Boolean getShowBOLookupField() {
        return null;
    }
    global Boolean getShowBOTitle() {
        return null;
    }
    global Boolean getShowDuration() {
        return null;
    }
    global Boolean getShowHeader() {
        return null;
    }
    global Boolean getSkipReview() {
        return null;
    }
    global List<Apttus_Config2.LineItem> getSummaryLineItemList() {
        return null;
    }
    global List<System.SelectOption> getTotalingGroupItems() {
        return null;
    }
    global List<Apttus_Config2.SummaryGroup> getTotalsLineItemList() {
        return null;
    }
    global void setAdjustmentRowsForLineItem(Id lineItemId, List<Apttus_Config2__AdjustmentLineItem__c> adjLineItems) {

    }
global class LineItemAdjInfo {
    global Apttus_Config2__LineItem__c lineItemSO {
        get;
    }
    global Integer seqNumber {
        get;
    }
    global List<Apttus_Config2__AdjustmentLineItem__c> getAdjustments() {
        return null;
    }
    global Double getLastAdjustmentRowSequence() {
        return null;
    }
}
}
