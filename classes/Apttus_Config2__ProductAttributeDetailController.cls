/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ProductAttributeDetailController implements Apttus_Config2.LineItemPaginator.IPagingController {
    global Boolean allRulesProcessed {
        get;
        set;
    }
    global Id appliedActionInfoId {
        get;
        set;
    }
    global String fromBizTitle {
        get;
    }
    global String fromBizType {
        get;
    }
    global Id ignoreActionId {
        get;
        set;
    }
    global Boolean IsPricingEnabled {
        get;
        set;
    }
    global Decimal lineItemLineNbr {
        get;
        set;
    }
    global Apttus_Config2.LineItemPaginator lineItemPaging {
        get;
    }
    global Set<Decimal> pricePendingLines {
        get;
        set;
    }
    global Boolean proceedToConfig {
        get;
        set;
    }
    global Boolean proceedToPricing {
        get;
        set;
    }
    global Boolean proceedToSelect {
        get;
        set;
    }
    global Id ruleActionId {
        get;
        set;
    }
    global Id selectedProductId {
        get;
        set;
    }
    global String stageConfigure {
        get;
    }
    global String stageConfigureProduct {
        get;
    }
    global String stageFinalize {
        get;
    }
    global String stagePrice {
        get;
    }
    global String stageSelect {
        get;
    }
    global ProductAttributeDetailController(ApexPages.StandardController stdController) {

    }
    global System.PageReference doAbandon() {
        return null;
    }
    global System.PageReference doConfigureOptions() {
        return null;
    }
    global System.PageReference doDeleteLineItem() {
        return null;
    }
    global void doHideMessage() {

    }
    global System.PageReference doIgnoreAction() {
        return null;
    }
    global void doProcessMoreRules() {

    }
    global System.PageReference doProcessMoreRules2() {
        return null;
    }
    global System.PageReference doProductSelection() {
        return null;
    }
    global System.PageReference doRemoveItem() {
        return null;
    }
    global System.PageReference doRemoveProduct() {
        return null;
    }
    global System.PageReference doSelectProduct() {
        return null;
    }
    global System.PageReference doUpdateCart() {
        return null;
    }
    global System.PageReference doViewCart() {
        return null;
    }
    global List<Apttus_Config2__LineItem__c> getAddedLineItems() {
        return null;
    }
    global String getAttributeGroup1Name() {
        return null;
    }
    global String getAttributeGroup2Name() {
        return null;
    }
    global String getAttributeGroup3Name() {
        return null;
    }
    global String getAttributeGroup4Name() {
        return null;
    }
    global String getAttributeGroup5Name() {
        return null;
    }
    global String getAttributeNamesStringForGroup1() {
        return null;
    }
    global String getAttributeNamesStringForGroup2() {
        return null;
    }
    global String getAttributeNamesStringForGroup3() {
        return null;
    }
    global String getAttributeNamesStringForGroup4() {
        return null;
    }
    global String getAttributeNamesStringForGroup5() {
        return null;
    }
    global Apttus_Config2__ProductAttributeValue__c getAttributeValueSO() {
        return null;
    }
    global String getBOLookupFieldName() {
        return null;
    }
    global String getCartSummaryInfo() {
        return null;
    }
    global String getChoicePanelDisplayScript() {
        return null;
    }
    global Apttus_Config2__ProductConfiguration__c getConfigSO() {
        return null;
    }
    global Id getConfigurationId() {
        return null;
    }
    global Boolean getHasErrors() {
        return null;
    }
    global Boolean getHasOptionGroups() {
        return null;
    }
    global Boolean getHasSelectedProductLines() {
        return null;
    }
    global Boolean getHasSelectedProducts() {
        return null;
    }
    global Boolean getIsAttributeGroup1Enabled() {
        return null;
    }
    global Boolean getIsAttributeGroup2Enabled() {
        return null;
    }
    global Boolean getIsAttributeGroup3Enabled() {
        return null;
    }
    global Boolean getIsAttributeGroup4Enabled() {
        return null;
    }
    global Boolean getIsAttributeGroup5Enabled() {
        return null;
    }
    global Boolean getIsCallerInstalledProductsPage() {
        return null;
    }
    global Boolean getIsCallerSelectionPage() {
        return null;
    }
    global Boolean getIsCallerViewCartPage() {
        return null;
    }
    global Apttus_Config2__LineItem__c getLineItemSO() {
        return null;
    }
    global String getPendingPriceScript() {
        return null;
    }
    global String getPriceTypeRecurring() {
        return null;
    }
    global String getPriceTypeUsage() {
        return null;
    }
    global String getRuleActionMessages() {
        return null;
    }
    global Apttus_Config2.ProductAttributeDetailController.RuleResult getRuleResult() {
        return null;
    }
    global System.PageReference getSelectProductPage() {
        return null;
    }
    global List<Apttus_Config2__SearchAttributeValue__c> getSelectedProductLines() {
        return null;
    }
    global Boolean getShowBOLookupField() {
        return null;
    }
    global Boolean getShowBOTitle() {
        return null;
    }
    global Boolean getShowHeader() {
        return null;
    }
    global String getValueTypeCategory() {
        return null;
    }
    global String getValueTypeDefault() {
        return null;
    }
    global String getValueTypeProduct() {
        return null;
    }
    global System.PageReference gotoSearchDefault() {
        return null;
    }
    global System.PageReference gotoSearchProduct() {
        return null;
    }
    global void initTransient() {

    }
    global void nextLineItemPage() {

    }
    global void previousLineItemPage() {

    }
global class RuleResult {
    global Integer includeMaxCount {
        get;
    }
    global Boolean isEmpty {
        get;
    }
    global Boolean isError {
        get;
    }
    global Boolean isRemove {
        get;
    }
    global Boolean isSelect {
        get;
    }
    global Boolean isShowMessage {
        get;
    }
    global String Message {
        get;
    }
    global Integer requiredMin {
        get;
    }
    global Id ruleActionId {
        get;
    }
    global Id ruleId {
        get;
    }
    global void addProduct(Product2 productSO) {

    }
    global Boolean getHasProduct() {
        return null;
    }
    global List<Product2> getProducts() {
        return null;
    }
    global Id getRuleActionId() {
        return null;
    }
    global String getTableStyle() {
        return null;
    }
    global Boolean isRequireMore(Set<Id> selectedIds) {
        return null;
    }
}
}
