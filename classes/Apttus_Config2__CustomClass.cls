/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CustomClass {
    global static String APPROVALCTX_CART;
    global static String APPROVALCTX_HEADER;
    global static String APPROVALCTX_LINEITEM;
    global static String APPROVALMODE_PREVIEW;
    global static String APPROVALMODE_SUBMIT;
    global static String ASSET_SEARCH_FOR_DISPLAY;
    global static String ASSET_SEARCH_FOR_RULE;
    global static String REVAL_CATEGORY_PRICING_CHANGE;
    global static String REVAL_CATEGORY_VERSION_CHANGE;
    global static String STATUS_ERROR;
    global static String STATUS_SUCCESS;
    global static String TASK_APPLYRULE;
    global static String TASK_SPLITCART;
    global static String TASK_SYNCCART;
    global static String TASK_UPDATEPRICE;
    global CustomClass() {

    }
global class ActionCallbackRequest {
    global List<Id> BundleLineItemIds {
        get;
        set;
    }
    global Id CartId {
        get;
        set;
    }
    global ActionCallbackRequest() {

    }
}
global class ActionCallbackResponse {
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global ActionCallbackResponse() {

    }
}
global class ActionParams {
    global Id AccountId {
        get;
        set;
    }
    global Set<Id> AccountIds {
        get;
        set;
    }
    global String ActionName {
        get;
        set;
    }
    global Boolean ActivateOrder {
        get;
        set;
    }
    global String ApprovalCtxType {
        get;
        set;
    }
    global String ApprovalMode {
        get;
        set;
    }
    global String ApprovalReason {
        get;
        set;
    }
    global String ApprovalType {
        get;
        set;
    }
    global List<Apttus_Config2__AssetLineItem__c> AssetLineItems {
        get;
        set;
    }
    global Id BundleId {
        get;
        set;
    }
    global List<Id> CartIds {
        get;
        set;
    }
    global Apttus_Config2.CustomClass.SyncMode CartSyncMode {
        get;
        set;
    }
    global Id ConfigurationId {
        get;
        set;
    }
    global String CurrentState {
        get;
        set;
    }
    global Map<String,String> CustomParams {
        get;
        set;
    }
    global String FinalizeClass {
        get;
        set;
    }
    global String Flow {
        get;
        set;
    }
    global Boolean IsAngular {
        get;
        set;
    }
    global Boolean IsDraft {
        get;
        set;
    }
    global String LaunchState {
        get;
        set;
    }
    global Set<Id> LineItemIds {
        get;
        set;
    }
    global Decimal LineNumber {
        get;
        set;
    }
    global Set<Id> LocationIds {
        get;
        set;
    }
    global String Method {
        get;
        set;
    }
    global String Mode {
        get;
        set;
    }
    global List<Apttus_Config2__OrderLineItem__c> OrderLineItems {
        get;
        set;
    }
    global Apttus_Config2__Order__c OriginalOrderSO {
        get;
        set;
    }
    global String OutputFormat {
        get;
        set;
    }
    global List<Id> ProductIDs {
        get;
        set;
    }
    global String ProtectionLevel {
        get;
        set;
    }
    global Id RequestId {
        get;
        set;
    }
    global Id ReturnId {
        get;
        set;
    }
    global String ReturnPage {
        get;
        set;
    }
    global String SessionId {
        get;
        set;
    }
    global String SessionUrl {
        get;
        set;
    }
    global String TemplateName {
        get;
        set;
    }
    global ActionParams() {

    }
}
global enum ActionType {ACTION_ACTIVATE, ACTION_CANCEL, ACTION_COMPLETE, ACTION_CREATE_FROM_AGREEMENT, ACTION_CREATE_FROM_QUOTE, ACTION_SPLIT}
global class Address {
    global String City {
        get;
        set;
    }
    global String Country {
        get;
        set;
    }
    global String CountryCode {
        get;
        set;
    }
    global String County {
        get;
        set;
    }
    global String PostalCode {
        get;
        set;
    }
    global String State {
        get;
        set;
    }
    global String StateCode {
        get;
        set;
    }
    global String Street {
        get;
        set;
    }
    global Address() {

    }
}
global enum AssetLineActionType {ACTION_TYPE_CANCEL, ACTION_TYPE_CHANGE, ACTION_TYPE_INFO}
global class AssetRenewalInput {
    global Id AccountId {
        get;
    }
    global String BusinessObjectType {
        get;
    }
    global Apttus_Config2.CustomClass.IAssetRenewalCustomCallback CustomCallback {
        get;
    }
    global String ExecMode {
        get;
    }
    global String GroupByValue {
        get;
    }
    global Id PriceBookId {
        get;
    }
    global Id PriceListId {
        get;
    }
    global Date RenewalEndDate {
        get;
    }
    global Date RenewalStartDate {
        get;
    }
    global Decimal RenewalTerm {
        get;
    }
    global Id SourceBusinessObjectId {
        get;
    }
}
global class AssetRenewalOutput {
    global Id BusinessObjectId {
        get;
        set;
    }
    global Id ConfigurationId {
        get;
        set;
    }
    global Id RequestId {
        get;
        set;
    }
    global AssetRenewalOutput() {

    }
}
global class BillingMetricsInput {
    global Apttus_Config2.CustomClass.AssetLineActionType ActionType {
        get;
        set;
    }
    global Apttus_Config2__AssetLineItem__c AssetLineItemSO {
        get;
        set;
    }
    global Date EffectiveDate {
        get;
        set;
    }
    global String NewBillingFrequency {
        get;
        set;
    }
    global Date NewEndDate {
        get;
        set;
    }
    global Decimal NewNetPrice {
        get;
        set;
    }
    global Decimal NewSellingTerm {
        get;
        set;
    }
    global Boolean ReturnEvaluatedBillingSchedules {
        get;
        set;
    }
    global BillingMetricsInput() {

    }
    global BillingMetricsInput(Apttus_Config2.CustomClass.AssetLineActionType actionType, Apttus_Config2__AssetLineItem__c assetLineItemSO, Date effectiveDate, Date newEndDate, Decimal newNetPrice, Decimal newSellingTerm, String newBillingFrequency, Boolean returnEvaluatedBillingSchedules) {

    }
}
global class BillingMetricsOutput {
    global Apttus_Config2__AssetLineItem__c AssetLineItemSO {
        get;
        set;
    }
    global Decimal CreditedAmount {
        get;
        set;
    }
    global Decimal CreditedInvoicedAmount {
        get;
        set;
    }
    global Decimal CreditedPendingBillingAmount {
        get;
        set;
    }
    global Decimal CurrentAssetCreditedInvoicedAmount {
        get;
        set;
    }
    global Decimal CurrentAssetInvoicedAmount {
        get;
        set;
    }
    global Decimal CurrentAssetPendingBillingAmount {
        get;
        set;
    }
    global Decimal CurrentAssetTCV {
        get;
        set;
    }
    global Decimal CurrentContractCreditedInvoicedAmount {
        get;
        set;
    }
    global Decimal CurrentContractInvoicedAmount {
        get;
        set;
    }
    global Decimal CurrentContractPendingBillingAmount {
        get;
        set;
    }
    global Decimal CurrentContractTCV {
        get;
        set;
    }
    global String ErrorMessage {
        get;
        set;
    }
    global List<SObject> EvaluatedBillingSchedules {
        get;
        set;
    }
    global Date InvoicedThroughDate {
        get;
        set;
    }
    global Decimal PaidAmount {
        get;
        set;
    }
    global Decimal TotalAssetTCV {
        get;
        set;
    }
    global Decimal TotalCancelledAmount {
        get;
        set;
    }
    global Decimal TotalInvoicedAmount {
        get;
        set;
    }
    global Decimal TotalPendingBillingAmount {
        get;
        set;
    }
    global BillingMetricsOutput() {

    }
}
global class CartHelper {
    global List<Id> getConfigOrPricingCartsFor(Id parentId) {
        return null;
    }
    global List<Id> getPricingCartsFor(Id parentId) {
        return null;
    }
}
global class FormulaPageInfo {
    global String NamespacePrefix {
        get;
    }
    global String PageName {
        get;
    }
    global FormulaPageInfo(String pageName, String nsPrefix) {

    }
}
global enum FormulaType {PRICE, QUANTITY}
global interface IActionCallback {
    Boolean afterFinalizeCart(Id param0);
    Boolean finalizeCart(Id param0);
    Id generateDoc(Id param0, Apttus_Config2.CustomClass.ActionParams param1);
    Boolean submitApproval(Id param0, Apttus_Config2.CustomClass.ActionParams param1);
}
global interface IActionCallback2 extends Apttus_Config2.CustomClass.IActionCallback {
    Boolean afterSyncCart(Id param0);
    Boolean syncCart(Id param0);
}
global interface IActionCallback3 {
    Apttus_Config2.CustomClass.ActionCallbackResponse beforeCopyBundleLineItems(Apttus_Config2.CustomClass.ActionCallbackRequest param0);
    Apttus_Config2.CustomClass.ActionCallbackResponse beforeDeleteBundleLineItems(Apttus_Config2.CustomClass.ActionCallbackRequest param0);
}
global interface IActionInvokerCallback {
    System.PageReference invokeAction(Apttus_Config2.ProductConfiguration param0, Apttus_Config2.CustomClass.ActionParams param1);
}
global interface IActionParamsCallback {
    Apttus_Config2.CustomClass.ActionParams createActionParams(Apttus_Config2.ProductConfiguration param0);
}
global interface IAdjustmentLineItemCallback {
    List<Apttus_Config2__AdjustmentLineItem__c> createAdjustmentLineItems(Apttus_Config2.LineItem param0);
    void finish();
    void start(Apttus_Config2.ProductConfiguration param0);
}
global interface IAdjustmentLineItemCallback2 extends Apttus_Config2.CustomClass.IAdjustmentLineItemCallback {
    Boolean beforeSaveAdjustmentLineItems(Apttus_Config2.LineItem param0, List<Apttus_Config2__AdjustmentLineItem__c> param1);
}
global interface IAdjustmentSpreadCallback {
    void finish();
    List<Apttus_Config2.LineItem> spreadBundleAdjustment(Apttus_Config2.LineItem param0, List<Apttus_Config2.LineItem> param1);
    List<Apttus_Config2.LineItem> spreadGroupAdjustment(Apttus_Config2.SummaryGroup param0, List<Apttus_Config2.LineItem> param1, Map<Id,List<Apttus_Config2.LineItem>> param2);
    void start(Apttus_Config2.ProductConfiguration param0);
}
global interface IAdvancedApprovalCallback {
    Boolean submitApproval(Id param0, Apttus_Config2.CustomClass.ActionParams param1);
}
global interface IAssetLineItemCallback {
    void finish();
    List<String> getAssetSearchScope();
    String getQueryFilter(Id param0);
    void start(Apttus_Config2.ProductConfiguration param0, String param1, List<String> param2);
}
global interface IAssetLineItemCallback2 {
    void finish();
    List<String> getAssetSearchScope();
    String getFilterExpr(Apttus_Config2.CustomClass.ActionParams param0);
    String getQueryFilter(Id param0);
    void start(Apttus_Config2.ProductConfiguration param0, String param1, List<String> param2);
}
global interface IAssetLineItemCallback3 extends Apttus_Config2.CustomClass.IAssetLineItemCallback2 {
    Boolean validateAssetTermination(Set<Id> param0, Set<Id> param1, Date param2);
}
global interface IAssetLineItemCallback4 extends Apttus_Config2.CustomClass.IAssetLineItemCallback3 {
    Date getAssetTerminationDate();
}
global interface IAssetRenewalCallback {
    Apttus_Config2.CustomClass.AssetRenewalOutput createRenewalCart(Apttus_Config2.CustomClass.AssetRenewalInput param0);
}
global interface IAssetRenewalCustomCallback {
    String getAssetFilterExpr();
    List<Apttus_Config2.Property> getConfigProperties(SObject param0);
}
global interface IBatchJobCallback {
    Id submitJob(Apttus_Config2.CustomClass.JobInput param0);
}
global interface IBillingFunctionsCallback {
    Decimal computeSellingTerm(Apttus_Config2__LineItem__c param0, Date param1, Date param2, Apttus_Config2__BillingPreference__c param3, Account param4);
    Boolean isSameDayCancellation();
}
global interface IBillingMetricsCallback {
    List<Apttus_Config2.CustomClass.BillingMetricsOutput> retrieveBillingMetrics(List<Apttus_Config2.CustomClass.BillingMetricsInput> param0);
}
global interface IBulkLoyaltyPointCallback {
    String getOrderItemFilterExpr(Apttus_Config2__Incentive__c param0, Apttus_Config2__IncentiveLoyaltyEnrollment__c param1);
}
global interface ICartApprovalCallback {
    Boolean checkApproval(Id param0);
    System.PageReference viewApproval(Id param0, Apttus_Config2.CustomClass.ActionParams param1);
}
global interface ICartApprovalCallback2 {
    Boolean checkApproval(Id param0, Apttus_Config2.CustomClass.ActionParams param1);
    System.PageReference viewApproval(Id param0, Apttus_Config2.CustomClass.ActionParams param1);
}
global interface IConfigureProductsCallback {
    Id createConfigurationRequest(Id param0, List<Apttus_Config2.Property> param1);
    System.PageReference startConfiguration(Id param0, List<Apttus_Config2.Property> param1);
}
global interface IDealOptimizerCallback {
    System.PageReference analyzeDeal(Id param0, Apttus_Config2.CustomClass.ActionParams param1);
}
global interface IDealOptimizerCallback2 {
    System.PageReference analyzeDeal(Id param0, Apttus_Config2.CustomClass.ActionParams param1);
    Map<Id,List<Apttus_Config2.PricingGuidance>> getPricingGuidance(Id param0, List<Apttus_Config2__LineItem__c> param1);
}
global interface IDisplayActionCallback {
    void setActionProperties(Apttus_Config2.CustomClass.ActionParams param0);
    void start(Apttus_Config2.ProductConfiguration param0, List<Apttus_Config2.DisplayActionInfo> param1);
}
global interface IFormulaCallback {
    System.PageReference getFormulaPage(Schema.SObjectType param0, String param1, Apttus_Config2.CustomClass.FormulaType param2);
    List<Apttus_Config2.CustomClass.FormulaPageInfo> getFormulaPageInfos(Schema.SObjectType param0, Apttus_Config2.CustomClass.FormulaType param1);
}
global interface ILoyaltyCycleCallback {
    String getEnrollmentFilterExpr(Apttus_Config2__Incentive__c param0);
}
global interface ILoyaltyPointCallback {
    String getOrderFilterExpr(Apttus_Config2__IncentiveLoyaltyEnrollment__c param0);
}
global interface IMetadataCallback {
    Schema.SObjectType getSObjectType(String param0);
}
global interface IMilestoneUpdateCallback {
    void updateDependents(Apttus_Config2.CustomClass.MilestoneInfo param0);
}
global interface IOptionFilterCallback {
    List<Id> getExcludedOptionIds(Apttus_Config2.CustomClass.ActionParams param0);
}
global interface IOrderLifecycleCallback {
    void afterOrderAction(Apttus_Config2__Order__c param0, Apttus_Config2.CustomClass.ActionType param1, Apttus_Config2.CustomClass.ActionParams param2);
}
global interface IOrderLifecycleCallback2 extends Apttus_Config2.CustomClass.IOrderLifecycleCallback {
    void afterReadyForBilling(Apttus_Config2__Order__c param0, Apttus_Config2.CustomClass.ActionParams param1);
}
global interface IPrestoCallback {
    Apttus_Config2.CustomClass.PrestoResult call(Apttus_Config2.CustomClass.PrestoInput param0);
}
global interface IPricingCallback {
    void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl param0);
    void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl param0);
    void finish();
    void start(Apttus_Config2.ProductConfiguration param0);
}
global interface IPricingCallback2 {
    void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl param0);
    void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl param0, Apttus_Config2.LineItem param1);
    void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl param0);
    void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl param0, Apttus_Config2.LineItem param1);
    void finish();
    void setMode(Apttus_Config2.CustomClass.PricingMode param0);
    void start(Apttus_Config2.ProductConfiguration param0);
}
global interface IPricingCallback3 extends Apttus_Config2.CustomClass.IPricingCallback2 {
    void onPriceItemSet(Apttus_Config2__PriceListItem__c param0, Apttus_Config2.LineItem param1);
}
global interface IPricingExtensionCallback {
    Apttus_Config2.CustomClass.PricingExtensionResult afterPricing(Apttus_Config2.ProductConfiguration param0, Apttus_Config2.CustomClass.CartHelper param1);
    Apttus_Config2.CustomClass.PricingExtensionResult beforePricing(Apttus_Config2.ProductConfiguration param0, Apttus_Config2.CustomClass.CartHelper param1);
    Boolean isAfterPricingEnabled();
    Boolean isBeforePricingEnabled();
}
global interface IProductAttributeCallback {
    void finish();
    void setDefaults(Apttus_Config2.LineItem param0, Apttus_Config2__ProductAttributeValue__c param1);
    void start(Apttus_Config2.ProductConfiguration param0);
}
global interface IProductFilterCallback {
    String getOptionFilterExpr(Apttus_Config2.CustomClass.ActionParams param0);
    String getProductFilterExpr(Apttus_Config2.CustomClass.ActionParams param0);
}
global interface IRecommendationCallback {
    List<Apttus_Config2.CustomClass.RecommendationInfo> getRecommendedProducts(Apttus_Config2.ProductConfiguration param0);
}
global interface IRelatedPricingCallback {
    Apttus_Config2.CustomClass.RelatedPriceResult computeBasePrice(Apttus_Config2.ProductConfiguration param0, Apttus_Config2.LineItem param1, List<Apttus_Config2__PriceBreakup__c> param2);
}
global interface IRevalidationCallback {
    Apttus_Config2.CustomClass.RevalidationResponse getRevalidations(Apttus_Config2.CustomClass.RevalidationRequest param0);
    void setRevalidations(Apttus_Config2.CustomClass.RevalidationRequest param0);
    void setVersionNumber(Id param0, List<Apttus_Config2__LineItem__c> param1);
}
global interface IShippingCallback {
    List<Apttus_Config2.CustomClass.ShippingResult> computeShippingMultiple(List<Apttus_Config2.CustomClass.ShippingInput> param0);
}
global interface ITaskStatusCallback {
    void afterComplete(String param0, String param1, Boolean param2);
}
global interface ITaxCallback {
    Apttus_Config2.CustomClass.TaxResult computeTax(Apttus_Config2.CustomClass.TaxInput param0);
}
global interface ITaxCallback2 extends Apttus_Config2.CustomClass.ITaxCallback {
    List<Apttus_Config2.CustomClass.TaxResult> computeTaxMultiple(List<Apttus_Config2.CustomClass.TaxInput> param0);
}
global interface IValidationCallback {
    Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration param0);
    Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration param0, List<Apttus_Config2.LineItem> param1);
}
global interface IValidationCallback2 {
    Apttus_Config2.CustomClass.ValidationResult validateAssetItems(Apttus_Config2.ProductConfiguration param0, List<Apttus_Config2__TempRenew__c> param1);
    Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration param0);
    Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration param0, List<Apttus_Config2.LineItem> param1);
}
global interface IValidationCallback3 {
    Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.CustomClass.ActionParams param0, Apttus_Config2.ProductConfiguration param1);
    Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.CustomClass.ActionParams param0, Apttus_Config2.ProductConfiguration param1, List<Apttus_Config2.LineItem> param2);
}
global enum IncentiveAutoApplyRule {DISABLE, ENABLE, RESTRICT}
global class JobInput {
    global Apttus_Config2__BatchJob__c JobSO {
        get;
    }
    global Apttus_Config2.CustomClass.IBatchJobCallback NextJobCallback {
        get;
    }
    global Apttus_Config2.CustomClass.ActionParams Params {
        get;
    }
    global JobInput() {

    }
}
global class MilestoneInfo {
    global List<Id> CompletedMilestoneIds {
        get;
    }
    global List<String> DependentFieldNames {
        get;
    }
    global String DependentSObjectName {
        get;
    }
}
global class PrestoInput {
    global String AppId {
        get;
        set;
    }
    global Id CartId {
        get;
        set;
    }
    global PrestoInput() {

    }
}
global class PrestoResult {
    global Boolean IsSuccess {
        get;
        set;
    }
    global PrestoResult(Boolean isSuccess) {

    }
}
global class PricingExtensionResult {
    global Exception Error {
        get;
        set;
    }
    global Boolean IsError {
        get;
        set;
    }
    global Boolean IsPending {
        get;
    }
    global PricingExtensionResult() {

    }
}
global enum PricingMode {ADJUSTMENT, BASEPRICE, ROLLDOWN}
global class RecommendationInfo {
    global Id ProductId {
        get;
    }
    global List<Id> RelatedProductIds {
        get;
    }
    global String Relevance {
        get;
    }
    global RecommendationInfo(Id productId, String relevance) {

    }
}
global class RelatedPriceResult {
    global Decimal BasePrice {
        get;
        set;
    }
    global RelatedPriceResult() {

    }
}
global class RevalidationRequest {
    global String CartId {
        get;
        set;
    }
    global Map<String,List<Apttus_Config2__LineItem__c>> LineItemSOsByRevalCategory {
        get;
        set;
    }
    global RevalidationRequest() {

    }
}
global class RevalidationResponse extends Apttus_Config2.RemoteCPQ.ResponseDO {
    global Boolean IsHardRevalidationNeeded {
        get;
        set;
    }
    global Boolean IsRevalidationNeeded {
        get;
        set;
    }
    global Map<String,List<Apttus_Config2__LineItem__c>> LineItemSOsByRevalCategory {
        get;
        set;
    }
    global RevalidationResponse() {

    }
}
global class ShippingInput {
    global Object Handback {
        get;
        set;
    }
    global SObject Item {
        get;
        set;
    }
    global Apttus_Config2.CustomClass.Address ShippingAddress {
        get;
        set;
    }
    global ShippingInput() {

    }
}
global class ShippingResult {
    global Object Handback {
        get;
        set;
    }
    global Decimal ShippingCharge {
        get;
        set;
    }
    global ShippingResult() {

    }
}
global class SplitCartInfo {
    global List<String> SplitCriteriaFields {
        get;
    }
    global Integer SplitThreshold {
        get;
        set;
    }
    global SplitCartInfo() {

    }
}
global enum SyncMode {FINALIZE, SYNC}
global class TaxInput {
    global Object Handback {
        get;
        set;
    }
    global SObject Item {
        get;
        set;
    }
    global Decimal TaxableAmount {
        get;
        set;
    }
    global Apttus_Config2.CustomClass.Address TaxAddress {
        get;
        set;
    }
    global String TaxCode {
        get;
        set;
    }
    global TaxInput() {

    }
}
global class TaxResult {
    global Object Handback {
        get;
        set;
    }
    global Decimal TaxAmount {
        get;
        set;
    }
    global List<Apttus_Config2__TaxBreakup__c> TaxBreakups {
        get;
        set;
    }
    global TaxResult() {

    }
}
global class UsageInput {
    global List<Apttus_Config2.Property> ItemState {
        get;
        set;
    }
    global Decimal ListPrice {
        get;
        set;
    }
    global Id MatrixId {
        get;
        set;
    }
    global Decimal PrevQuantity {
        get;
        set;
    }
    global String PriceMethod {
        get;
        set;
    }
    global Decimal Quantity {
        get;
        set;
    }
    global Date TxnDate {
        get;
        set;
    }
    global List<Apttus_Config2.UsagePriceTierDO> UsageTiers {
        get;
        set;
    }
    global UsageInput() {

    }
}
global class UsagePriceResult {
    global Decimal UsagePrice {
        get;
    }
}
global class ValidationResult {
    global Boolean HasMessages {
        get;
    }
    global Boolean IsSuccess {
        get;
        set;
    }
    global List<ApexPages.Message> Messages {
        get;
    }
    global ValidationResult(Boolean isSuccess) {

    }
}
}
