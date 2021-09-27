/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SearchAttributeDefaultController extends Apttus_Config2.PageControllerBase implements Apttus_Config2.PageControllerBase.ISearchController {
    global Boolean allRulesProcessed {
        get;
        set;
    }
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
    global String orderByClause;
    global Integer pageSize {
        get;
        set;
    }
    global String relationFilter;
    global List<System.SelectOption> rowsPerPageList {
        get;
    }
    global Id ruleActionId {
        get;
        set;
    }
    global Boolean selectAll {
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
    global SearchAttributeDefaultController(ApexPages.StandardController stdController, Boolean isSearchOnLoad) {

    }
    global void addAttributeField(String fieldName) {

    }
    global void addProductField(String fieldName) {

    }
    global System.PageReference doAbandon() {
        return null;
    }
    global void doCloseResultset() {

    }
    global void doGetCtxProductDetail() {

    }
    global System.PageReference doNext() {
        return null;
    }
    global System.PageReference doPrevious() {
        return null;
    }
    global void doRemoveProduct() {

    }
    global void doReset() {

    }
    global System.PageReference doSearch(Apttus_Config2.SearchFilter searchFilter) {
        return null;
    }
    global void doSearch() {

    }
    global System.PageReference doSelectProducts() {
        return null;
    }
    global System.PageReference doViewCart() {
        return null;
    }
    global void firstPage() {

    }
    global String getAttributeGroupName(Integer groupNbr) {
        return null;
    }
    global Apttus_Config2__SearchAttributeValue__c getAttributeValueSO() {
        return null;
    }
    global String getBOLookupFieldName() {
        return null;
    }
    global String getCartSummaryInfo() {
        return null;
    }
    global String getClassName() {
        return null;
    }
    global Apttus_Config2__ProductConfiguration__c getConfigSO() {
        return null;
    }
    global Id getConfigurationId() {
        return null;
    }
    global Integer getCurrentPageNumber() {
        return null;
    }
    global List<System.SelectOption> getFamilyItems() {
        return null;
    }
    global List<String> getFamily() {
        return null;
    }
    global String getFieldNamesForGroup(Integer groupNbr) {
        return null;
    }
    global Boolean getHasErrors() {
        return null;
    }
    global Boolean getHasNextPage() {
        return null;
    }
    global Boolean getHasPreviousPage() {
        return null;
    }
    global Boolean getHasSearchedProducts() {
        return null;
    }
    global Boolean getIsAttributeGroupEnabled(Integer groupNbr) {
        return null;
    }
    global Boolean getIsCallerSelectionPage() {
        return null;
    }
    global Boolean getIsCallerViewCartPage() {
        return null;
    }
    global List<System.SelectOption> getOptions(String fieldName) {
        return null;
    }
    global Integer getPageEndIndex() {
        return null;
    }
    global Integer getPageStartIndex() {
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
    global String getProductCode() {
        return null;
    }
    @RemoteAction
    global static Product2 getProductDescription(Id productId) {
        return null;
    }
    global Id getRequestId() {
        return null;
    }
    global List<Apttus_Config2.SearchAttributeDefaultController.SearchedProductInfo> getSearchedProducts() {
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
    global Integer getTotalPages() {
        return null;
    }
    global Integer getTotalRecords() {
        return null;
    }
    global void initTransient() {

    }
    global void lastPage() {

    }
    global void loadPage() {

    }
    global void nextPage() {

    }
    global void previousPage() {

    }
    global void queryProducts() {

    }
    global void resetPreFilterXml(String filterXml) {

    }
    global void setCurrentPageNumber(Integer pageNumber) {

    }
    global void setFamily(List<String> values) {

    }
    global void setProductCode(String value) {

    }
    global System.PageReference showCart() {
        return null;
    }
    global System.PageReference showProductSelection() {
        return null;
    }
    global String toMultiPicklistValue(List<String> values) {
        return null;
    }
    global List<String> toSelectValues(String multiValue) {
        return null;
    }
global class SearchedProductInfo {
}
}
