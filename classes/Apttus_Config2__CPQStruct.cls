/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CPQStruct {
    global CPQStruct() {

    }
global abstract class ABOActionRequestDO {
    global List<Id> AssetIds {
        get;
        set;
    }
    global Id CartId {
        get;
        set;
    }
    global ABOActionRequestDO() {

    }
}
global abstract class ABOActionResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
    global Map<Id,Apttus_Config2__LineItem__c> LineItemMap {
        get;
        set;
    }
}
global abstract class APIResponseDO {
    global List<String> Errors {
        get;
        set;
    }
}
global class AcceptCustomerPORequestDO {
    webService Id CustomerPOId {
        get;
        set;
    }
    global AcceptCustomerPORequestDO() {

    }
}
global class AcceptCustomerPOResponseDO {
    webService Apttus_Config2__CustomerPurchaseOrder__c CustomerPurchaseOrderSO {
        get;
    }
    webService Boolean IsSuccess {
        get;
    }
}
global class AcceptOrderRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global AcceptOrderRequestDO() {

    }
}
global class AcceptOrderResponseDO {
    webService List<Apttus_Config2__AssetLineItem__c> AssetItems {
        get;
    }
    webService Boolean IsSuccess {
        get;
    }
}
global class AddRampLineItemRequestDO extends Apttus_Config2.CPQStruct.ChangeConfigurationRequestDO {
}
global class AddRampLineItemResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class AgreementPriceDO {
    global String ContractItemNumber {
        get;
        set;
    }
    global Apttus_Config2__LineItem__c PriceDataSO {
        get;
        set;
    }
    global List<Apttus_Config2__UsagePriceTier__c> PriceTiers {
        get;
        set;
    }
    global AgreementPriceDO() {

    }
}
global class AmendCustomerPORequestDO {
    webService String Action {
        get;
        set;
    }
    webService Id CustomerPOId {
        get;
        set;
    }
    webService List<Apttus_Config2__CustomerPOItem__c> CustomerPOItems {
        get;
        set;
    }
    global AmendCustomerPORequestDO() {

    }
}
global class AmendCustomerPOResponseDO {
    webService Apttus_Config2__CustomerPurchaseOrder__c AmendCustomerPOSO {
        get;
    }
    webService List<Apttus_Config2__CustomerPOItem__c> AmendedCustomerPOItems {
        get;
    }
}
global class AmendOrderRequestDO {
    webService String Action {
        get;
        set;
    }
    webService Id OrderId {
        get;
        set;
    }
    webService List<Apttus_Config2__OrderLineItem__c> OrderItems {
        get;
        set;
    }
    global AmendOrderRequestDO() {

    }
}
global class AmendOrderResponseDO {
    webService List<Apttus_Config2__OrderLineItem__c> AmendedOrderItems {
        get;
    }
    webService Apttus_Config2__Order__c AmendOrderSO {
        get;
    }
}
global class BillingInfo {
    global Id BillingPlanId {
        get;
        set;
    }
    global BillingInfo() {

    }
}
global class CancelAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global Date CancelDate {
        get;
        set;
    }
    global CancelAssetsRequestDO() {

    }
}
global class CancelAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class CancelCustomerPORequestDO {
    webService Id CustomerPOId {
        get;
        set;
    }
    global CancelCustomerPORequestDO() {

    }
}
global class CancelCustomerPOResponseDO {
    webService Apttus_Config2__CustomerPurchaseOrder__c CancelCustomerPOSO {
        get;
    }
}
global class CancelOrderRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global CancelOrderRequestDO() {

    }
}
global class CancelOrderResponseDO {
    webService Apttus_Config2__Order__c CancelOrderSO {
        get;
    }
}
global class ChangeAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global ChangeAssetsRequestDO() {

    }
}
global class ChangeAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class CloneCustomerPORequestDO {
    webService String Action {
        get;
        set;
    }
    webService Id CustomerPOId {
        get;
        set;
    }
    global CloneCustomerPORequestDO() {

    }
}
global class CloneCustomerPOResponseDO {
    webService Apttus_Config2__CustomerPurchaseOrder__c CloneCustomerPurchaseOrderSO {
        get;
    }
    webService List<Apttus_Config2__CustomerPOItem__c> ClonePurchaseOrderItems {
        get;
    }
}
global class CloneOrderRequestDO {
    webService String Action {
        get;
        set;
    }
    webService Id OrderId {
        get;
        set;
    }
    global CloneOrderRequestDO() {

    }
}
global class CloneOrderResponseDO {
    webService List<Apttus_Config2__OrderLineItem__c> CloneOrderItems {
        get;
    }
    webService Apttus_Config2__Order__c CloneOrderSO {
        get;
    }
}
global class CommitIncentiveBenefitDataRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global CommitIncentiveBenefitDataRequestDO() {

    }
}
global class CommitIncentiveBenefitDataResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class CommitIncentiveDataRequestDO {
    webService Boolean CommitBenefitData {
        get;
        set;
    }
    webService Boolean CommitCouponData {
        get;
        set;
    }
    webService Boolean CommitLimitData {
        get;
        set;
    }
    webService Boolean CommitRollupData {
        get;
        set;
    }
    webService Id OrderId {
        get;
        set;
    }
    global CommitIncentiveDataRequestDO() {

    }
}
global class CommitIncentiveDataResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class CommitIncentiveLimitDataRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global CommitIncentiveLimitDataRequestDO() {

    }
}
global class CommitIncentiveLimitDataResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class CommitRollupDataRequestDO {
    webService Id ExtOrderId {
        get;
        set;
    }
    global List<Id> ExtOrderIds {
        get;
    }
    webService Id OrderId {
        get;
        set;
    }
    global List<Id> OrderIds {
        get;
    }
    global CommitRollupDataRequestDO() {

    }
}
global class CommitRollupDataResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class CreateAssetRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global CreateAssetRequestDO() {

    }
}
global class CreateAssetResponseDO {
    webService List<Apttus_Config2__AssetLineItem__c> AssetItems {
        get;
    }
}
global class CreateCartRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    webService List<Apttus_Config2.Property> Properties {
        get;
        set;
    }
    global CreateCartRequestDO() {

    }
}
global class CreateCartResponseDO {
    webService Id CartId {
        get;
    }
}
global class CreateOrderRequestDO {
    webService Id AccountId {
        get;
        set;
    }
    webService Datetime OrderDate {
        get;
        set;
    }
    webService Date OrderEndDate {
        get;
        set;
    }
    webService Date OrderStartDate {
        get;
        set;
    }
    webService Id PriceListId {
        get;
        set;
    }
    webService Datetime PricingDate {
        get;
        set;
    }
    webService List<Apttus_Config2.Property> Properties {
        get;
        set;
    }
    webService Id PurchaseOrderId {
        get;
        set;
    }
    webService Id RecordTypeId {
        get;
        set;
    }
    global CreateOrderRequestDO() {

    }
}
global class CreateOrderResponseDO {
    webService Apttus_Config2__Order__c OrderSO {
        get;
    }
}
global class CreatePriceRulesRequestDO {
    global SObject BusinessObjectSO {
        get;
        set;
    }
    global String ContractNumber {
        get;
        set;
    }
    global String CurrencyCode {
        get;
        set;
    }
    global List<Apttus_Config2.CPQStruct.AgreementPriceDO> Inputs {
        get;
        set;
    }
    global Date PricingDate {
        get;
        set;
    }
    global String RuleStatus {
        get;
        set;
    }
    global CreatePriceRulesRequestDO() {

    }
}
global class CreatePriceRulesResponseDO {
    global List<Apttus_Config2__AgreementPriceRule__c> PriceRules {
        get;
    }
}
global class CreateRollupDataRequestDO {
    webService Id ExtOrderId {
        get;
        set;
    }
    global List<Id> ExtOrderIds {
        get;
    }
    webService Id OrderId {
        get;
        set;
    }
    global List<Id> OrderIds {
        get;
    }
    webService Boolean Rebuild {
        get;
        set;
    }
    webService List<Id> RollupIds {
        get;
        set;
    }
    global CreateRollupDataRequestDO() {

    }
}
global class CreateRollupDataResponseDO {
    webService List<Apttus_Config2__ExternalOrderRollupData__c> ExtOrderRollupData {
        get;
    }
    webService List<Apttus_Config2__OrderRollupData__c> OrderRollupData {
        get;
    }
}
global class DataValidateEnrichResult {
    global Boolean IsSuccess {
        get;
    }
    global List<Apttus_Config2__CustomerPOIssueLog__c> IssueLogs {
        get;
    }
    global Map<Id,Integer> NumErrorsByObject {
        get;
    }
    global Map<Id,Integer> NumWarningsByObject {
        get;
    }
}
global class DeleteRollupDataRequestDO {
    global Date PeriodEndDate {
        get;
        set;
    }
    global Date PeriodStartDate {
        get;
        set;
    }
    global List<Id> RollupIds {
        get;
        set;
    }
    global DeleteRollupDataRequestDO() {

    }
}
global class DeleteRollupDataResponseDO {
    global Boolean IsSuccess {
        get;
    }
}
global class ExecOrderWorkflowRequestDO {
    global Apttus_Config2.CustomClass.IBatchJobCallback JobCallback {
        get;
        set;
    }
    global Id OrderFulfillmentId {
        get;
        set;
    }
    global Id OrderId {
        get;
        set;
    }
    global String TriggerEvent {
        get;
        set;
    }
    global ExecOrderWorkflowRequestDO() {

    }
}
global class ExecOrderWorkflowResponseDO {
    global Boolean IsSuccess {
        get;
    }
    global Id JobId {
        get;
    }
}
global class IOParams {
    global Map<Id,Map<Id,Double>> TxnQuantityByProductRule {
        get;
        set;
    }
    global IOParams() {

    }
}
global class IncentiveResult {
    global Map<Id,List<Apttus_Config2__AdjustmentLineItem__c>> AppliedIncentivesByItem {
        get;
    }
    global Map<Id,List<Apttus_Config2__IncentiveCoupon__c>> CouponsByIncentive {
        get;
    }
    global List<Apttus_Config2__Incentive__c> Incentives {
        get;
    }
    global Map<Id,List<Apttus_Config2__Incentive__c>> IncentivesByItem {
        get;
    }
}
global class IncrementAssetDO {
    global Id AssetId {
        get;
        set;
    }
    global String LineAction {
        get;
        set;
    }
    global Date NewEndDate {
        get;
        set;
    }
    global Date NewStartDate {
        get;
        set;
    }
    global Integer Quantity {
        get;
        set;
    }
    global IncrementAssetDO() {

    }
}
global class IncrementAssetRequestDO {
    global Id cartId {
        get;
        set;
    }
    global List<Apttus_Config2.CPQStruct.IncrementAssetDO> IncrementAssetDOs {
        get;
        set;
    }
    global IncrementAssetRequestDO() {

    }
}
global class IncrementAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class MergeAssetDO {
    global Date EndDate {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global Integer Quantity {
        get;
        set;
    }
    global Date StartDate {
        get;
        set;
    }
    global MergeAssetDO() {

    }
}
global class MergeAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global Apttus_Config2.CPQStruct.MergeAssetDO MergeAssetItemDO {
        get;
    }
    global MergeAssetsRequestDO() {

    }
}
global class MergeAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class PlaceOrderRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global PlaceOrderRequestDO() {

    }
}
global class PlaceOrderResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class PricePendingInfo {
    webService List<Integer> CompletedLineNumbers {
        get;
    }
    webService List<Integer> ErrorLineNumbers {
        get;
    }
    webService Boolean IsPostPricePending {
        get;
    }
    webService Boolean IsPrePricePending {
        get;
    }
    webService Boolean IsPricePending {
        get;
    }
    webService Boolean IsTotalPricePending {
        get;
    }
    webService List<Integer> PendingLineNumbers {
        get;
    }
}
global class ProductBundleDO {
    global Apttus_Config2.CPQStruct.ProductLineItemDO BundleProduct {
        get;
    }
    global Boolean HasOptionProducts {
        get;
    }
    global List<Id> OptionProductIds {
        get;
    }
    global List<Apttus_Config2.CPQStruct.ProductLineItemDO> OptionProducts {
        get;
    }
    global ProductBundleDO(Apttus_Config2.CPQStruct.ProductLineItemDO bundle, List<Apttus_Config2.CPQStruct.ProductLineItemDO> optItems) {

    }
}
global class ProductCollDO {
    global Boolean HasProducts {
        get;
    }
    global List<Id> ProductIds {
        get;
    }
    global List<Apttus_Config2.CPQStruct.ProductLineItemDO> Products {
        get;
    }
    global ProductCollDO(List<Apttus_Config2.CPQStruct.ProductLineItemDO> prodItems) {

    }
}
global class ProductLineItemDO {
    global String AddedBy {
        get;
    }
    global String Comments {
        get;
    }
    global Apttus_Config2__LineItem__c CustomData {
        get;
        set;
    }
    global List<String> CustomFields {
        get;
    }
    global Date EndDate {
        get;
    }
    global Id productOptionComponentId {
        get;
    }
    global Product2 ProductSO {
        get;
    }
    global Decimal Quantity {
        get;
    }
    global Decimal SellingTerm {
        get;
    }
    global Date StartDate {
        get;
    }
    global ProductLineItemDO(Product2 productSO, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate, String comments) {

    }
    global ProductLineItemDO(Product2 productSO, String addedBy, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate, String comments) {

    }
    global ProductLineItemDO(Product2 productSO, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate, String comments, Id productOptionComponentId) {

    }
}
global class PurchaseOrderInfo {
    global Id POItemId {
        get;
        set;
    }
    global Id POItemSourceId {
        get;
        set;
    }
    global Id PurchaseOrderId {
        get;
        set;
    }
    global Id PurchaseOrderSourceId {
        get;
        set;
    }
    global PurchaseOrderInfo() {

    }
}
global class PurchaseOrderRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global List<String> OtherFields {
        get;
        set;
    }
    global Id priceListId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global String SObjectName {
        get;
        set;
    }
    global String SortDirection {
        get;
        set;
    }
    global String SortField {
        get;
        set;
    }
    global PurchaseOrderRequestDO() {

    }
}
global class PurchaseOrderResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global String SObjectRecordsJsonString {
        get;
        set;
    }
    global PurchaseOrderResponseDO(String sObjRecsStr, Integer numOfRecords) {

    }
}
global class QueryAssetsRequestDO {
    global List<Id> AccountIds {
        get;
        set;
    }
    global String CustomFilter {
        get;
        set;
    }
    global Boolean Descending {
        get;
        set;
    }
    global List<String> FieldNames {
        get;
        set;
    }
    global Integer Nrecord {
        get;
        set;
    }
    global Integer Offset {
        get;
        set;
    }
    global List<String> SortFields {
        get;
        set;
    }
    global QueryAssetsRequestDO() {

    }
}
global class QueryAssetsResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
    global Integer AssetCount {
        get;
        set;
    }
    global List<Apttus_Config2__AssetLineItem__c> AssetLineItems {
        get;
        set;
    }
}
global class QueryCartRequestDO {
}
global class QueryCartResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class RebateInput {
    global List<Apttus_Config2__ExternalOrderSummaryItem__c> ExternalOrderSummaryItems {
        get;
        set;
    }
    global List<Apttus_Config2__Milestone2__c> MilestoneItems {
        get;
        set;
    }
    global List<Apttus_Config2__OrderLineItem__c> OrderLineItems {
        get;
        set;
    }
    global Apttus_Config2.CPQStruct.IOParams Params {
        get;
        set;
    }
    global Date PeriodEndDate {
        get;
        set;
    }
    global String PeriodSource {
        get;
        set;
    }
    global Date PeriodStartDate {
        get;
        set;
    }
    global List<Id> RebateIds {
        get;
        set;
    }
    global List<Id> RollupIds {
        get;
        set;
    }
    global RebateInput() {

    }
}
global class RebateResult {
    global Map<Id,Apttus_Config2__PriceRuleEntry__c> BenefitEntryLookup {
        get;
    }
    global Map<Id,Apttus_Config2__PriceRule__c> BenefitLookup {
        get;
    }
    global List<Apttus_Config2__ExternalOrderAdjustmentItem__c> ExternalOrderAdjItems {
        get;
    }
    global List<Apttus_Config2__IncentiveAdjustmentItem__c> IncentiveAdjItems {
        get;
    }
    global List<Apttus_Config2__MilestoneAdjustmentItem__c> MilestoneAdjItems {
        get;
    }
    global List<Apttus_Config2__OrderPocketAdjustmentLineItem__c> OrderAdjItems {
        get;
    }
    global Apttus_Config2.CPQStruct.IOParams Params {
        get;
        set;
    }
}
global class RecommendationRequestDO {
    global Id CartId {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global RecommendationRequestDO() {

    }
}
global class RecommendationResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
    global List<Id> ProductIds {
        get;
        set;
    }
}
global class RemoveOptionLineItemRequestDO extends Apttus_Config2.CPQStruct.ChangeConfigurationRequestDO {
}
global class RemoveOptionLineItemResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class RemoveRampLineItemRequestDO extends Apttus_Config2.CPQStruct.ChangeConfigurationRequestDO {
}
global class RemoveRampLineItemResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class RenewAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global Boolean FarthestAssetEndDate {
        get;
        set;
    }
    global Date RenewEndDate {
        get;
        set;
    }
    global Decimal RenewTerm {
        get;
        set;
    }
    global RenewAssetsRequestDO() {

    }
}
global class RenewAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class SplitAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global Date NewStartDate {
        get;
        set;
    }
    global Integer NumberOfAssetItems {
        get;
        set;
    }
    global SplitAssetsRequestDO() {

    }
}
global class SplitAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class SplitOrderRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    webService List<Integer> OrderLineNumbers {
        get;
        set;
    }
    webService List<String> SplitCriteriaFields {
        get;
        set;
    }
    global SplitOrderRequestDO() {

    }
}
global class SplitOrderResponseDO {
    webService Apttus_Config2__Order__c SplitOrderSO {
        get;
    }
}
global class SwapAssetsRequestDO extends Apttus_Config2.CPQStruct.ABOActionRequestDO {
    global Date NewStartDate {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global SwapAssetsRequestDO() {

    }
}
global class SwapAssetsResponseDO extends Apttus_Config2.CPQStruct.ABOActionResponseDO {
}
global class SynchronizeCartRequestDO {
    webService Id CartId {
        get;
        set;
    }
    global SynchronizeCartRequestDO() {

    }
}
global class SynchronizeCartResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class UndoAmendCustomerPORequestDO {
    webService Id CustomerPOId {
        get;
        set;
    }
    global UndoAmendCustomerPORequestDO() {

    }
}
global class UndoAmendCustomerPOResponseDO {
    webService Apttus_Config2__CustomerPurchaseOrder__c PreviousCustomerPurchaseOrderSO {
        get;
    }
}
global class UndoAmendOrderRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global UndoAmendOrderRequestDO() {

    }
}
global class UndoAmendOrderResponseDO {
    webService Apttus_Config2__Order__c PreviousOrderSO {
        get;
    }
}
global class UndoCancelCustomerPORequestDO {
    webService Id CustomerPOId {
        get;
        set;
    }
    global UndoCancelCustomerPORequestDO() {

    }
}
global class UndoCancelCustomerPOResponseDO {
    webService Apttus_Config2__CustomerPurchaseOrder__c PreviousCustomerPurchaseOrderSO {
        get;
    }
}
global class UndoCancelOrderRequestDO {
    webService Id OrderId {
        get;
        set;
    }
    global UndoCancelOrderRequestDO() {

    }
}
global class UndoCancelOrderResponseDO {
    webService Apttus_Config2__Order__c PreviousOrderSO {
        get;
    }
}
global class UpdateCustomerPOItemRollupsRequestDO {
    global List<Apttus_Config2__OrderLineItem__c> NewOrderItems {
        get;
    }
    global List<Apttus_Config2__OrderLineItem__c> OldOrderItems {
        get;
    }
    global UpdateCustomerPOItemRollupsRequestDO() {

    }
}
global class UpdateCustomerPOItemRollupsResponseDO {
    global Boolean IsSuccess {
        get;
    }
}
global class UpdateLineItemRequestDO extends Apttus_Config2.CPQStruct.ChangeConfigurationRequestDO {
}
global class UpdateLineItemResponseDO extends Apttus_Config2.CPQStruct.APIResponseDO {
}
global class ValidateCustomerPurchaseOrderDataRequestDO {
    global List<Apttus_Config2__CustomerPOItem__c> CustomerPOItems {
        get;
        set;
    }
    global Apttus_Config2__CustomerPurchaseOrder__c CustomerPurchaseOrderSO {
        get;
        set;
    }
    global ValidateCustomerPurchaseOrderDataRequestDO() {

    }
}
global class ValidateCustomerPurchaseOrderDataResponseDO {
    global Boolean IsSuccess {
        get;
    }
}
}
