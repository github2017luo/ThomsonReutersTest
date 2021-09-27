/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CPQ {
    global static String ITEMSOURCE_AGREEMENT_LINEITEM;
    @Deprecated
    global static String ITEMSOURCE_CUSTOMER_POITEM;
    @Deprecated
    global static String ITEMSOURCE_NONE;
    global static String ITEMSOURCE_ORDER_LINEITEM;
    global static String ITEMSOURCE_QUOTE_LINEITEM;
    global CPQ() {

    }
global class AbandonCartRequestDO {
    webService Id CartId {
        get;
        set;
    }
    global AbandonCartRequestDO() {

    }
}
global class AbandonCartResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class AddBundleRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService Apttus_CPQApi.CPQ.SelectedBundleDO SelectedBundle {
        get;
        set;
    }
    global AddBundleRequestDO() {

    }
}
global class AddBundleResponseDO {
    webService Decimal LineNumber {
        get;
    }
}
global class AddCustomBundleRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService Apttus_CPQApi.CPQ.LineItemCollDO LineItemColl {
        get;
        set;
    }
    global AddCustomBundleRequestDO() {

    }
}
global class AddCustomBundleResponseDO {
    webService Decimal LineNumber {
        get;
    }
}
global class AddMiscItemRequestDO {
    webService Boolean AllocateGroupAdjustment {
        get;
        set;
    }
    webService Boolean AllowRemoval {
        get;
        set;
    }
    webService Decimal Amount {
        get;
        set;
    }
    webService Id CartId {
        get;
        set;
    }
    webService String ChargeType {
        get;
        set;
    }
    webService String Description {
        get;
        set;
    }
    global AddMiscItemRequestDO() {

    }
}
global class AddMiscItemResponseDO {
    webService Apttus_Config2__LineItem__c MiscItem {
        get;
    }
}
global class AddMultiProductRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService List<Apttus_CPQApi.CPQ.SelectedProductDO> SelectedProducts {
        get;
        set;
    }
    global AddMultiProductRequestDO() {

    }
}
global class AddMultiProductResponseDO {
    webService List<Decimal> LineNumbers {
        get;
        set;
    }
}
global class AddOptionsResponseDO {
    webService List<Apttus_Config2__LineItem__c> addedOptionLineItems {
        get;
        set;
    }
}
global class AdjustLoyaltyPointsRequestDO {
    webService Apttus_Config2__LoyaltyPointAccrualAdjustmentItem__c AdjustmentItemSO {
        get;
        set;
    }
    webService Id EnrollmentId {
        get;
        set;
    }
    global AdjustLoyaltyPointsRequestDO() {

    }
}
global class AdjustLoyaltyPointsResponseDO {
    webService Apttus_Config2__LoyaltyPointAccrualSummary__c AccrualSummary {
        get;
    }
}
global class AdjustmentItemCollDO {
    webService List<Apttus_Config2__AdjustmentLineItem__c> AdjustmentItems {
        get;
        set;
    }
    webService Id LineItemId {
        get;
        set;
    }
    global AdjustmentItemCollDO() {

    }
}
global class AppliedActionDO {
    webService String ActionIntent {
        get;
        set;
    }
    webService String ActionType {
        get;
        set;
    }
    webService List<Integer> AffectedPrimaryNumbers {
        get;
        set;
    }
    webService List<Id> AffectedProductIds {
        get;
        set;
    }
    webService Id AppliedActionId {
        get;
    }
    webService Id AppliedRuleInfoId {
        get;
        set;
    }
    webService Id CartId {
        get;
    }
    webService Id ConstraintRuleActionId {
        get;
        set;
    }
    webService List<String> CriteriaFields {
        get;
        set;
    }
    webService Boolean IsAutoExecuted {
        get;
        set;
    }
    webService Boolean IsHideMessage {
        get;
        set;
    }
    webService Boolean IsIgnoredByUser {
        get;
        set;
    }
    webService Boolean IsPending {
        get;
        set;
    }
    webService Boolean IsShowPrompt {
        get;
        set;
    }
    webService Boolean IsTargetOptionProduct {
        get;
        set;
    }
    webService Boolean IsTargetPrimaryProduct {
        get;
        set;
    }
    webService String MatchCountRule {
        get;
        set;
    }
    webService String Message {
        get;
        set;
    }
    webService String MessageType {
        get;
        set;
    }
    webService List<Id> SuggestedProductIds {
        get;
        set;
    }
    webService Integer TargetBundleNumber {
        get;
        set;
    }
    webService List<Integer> TriggeringPrimaryNumbers {
        get;
        set;
    }
    webService List<Id> TriggeringProductIds {
        get;
        set;
    }
    global AppliedActionDO() {

    }
}
global class ApplyIncentivesRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService List<String> IncentiveCodes {
        get;
        set;
    }
    webService Apttus_CPQApi.CPQ.LineItemCollDO LineItemColl {
        get;
        set;
    }
    global ApplyIncentivesRequestDO() {

    }
}
global class ApplyIncentivesResponseDO {
    webService List<String> AppliedIncentiveCodes {
        get;
    }
}
global class ApplyRebatesRequestDO {
    webService Apttus_Config2.CustomClass.IncentiveAutoApplyRule AutoApplyRule {
        get;
        set;
    }
    webService List<String> IncentiveCodes {
        get;
        set;
    }
    webService Id OrderId {
        get;
        set;
    }
    global ApplyRebatesRequestDO() {

    }
}
global class ApplyRebatesResponseDO {
    webService Boolean HasPocketAdjustments {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.PocketAdjustmentCollDO> PocketAdjustments {
        get;
    }
}
global class AssetActionDO {
    webService Decimal AdjustmentAmount {
        get;
        set;
    }
    webService String AdjustmentType {
        get;
        set;
    }
    webService String AssetAction {
        get;
        set;
    }
    webService Id AssetLineItemId {
        get;
        set;
    }
    webService String Comments {
        get;
        set;
    }
    webService Apttus_Config2__LineItem__c CustomData {
        get;
        set;
    }
    webService List<String> CustomFields {
        get;
        set;
    }
    webService List<String> CustomUpgradeCancelledFields {
        get;
        set;
    }
    webService Date EndDate {
        get;
        set;
    }
    webService String Message {
        get;
        set;
    }
    webService Boolean Pending {
        get;
        set;
    }
    webService Decimal Quantity {
        get;
        set;
    }
    webService Decimal SellingTerm {
        get;
        set;
    }
    webService Date StartDate {
        get;
        set;
    }
    global AssetActionDO() {

    }
}
global class AssetSearchResultDO {
    webService List<Apttus_Config2__AssetLineItem__c> AssetItems {
        get;
    }
    webService Boolean HasAssetItems {
        get;
    }
}
global class BulkInitiateLoyaltyCycleRequestDO {
    webService Integer BatchSize {
        get;
        set;
    }
    webService List<Id> EnrollmentIds {
        get;
        set;
    }
    global BulkInitiateLoyaltyCycleRequestDO() {

    }
}
global class BulkInitiateLoyaltyCycleResponseDO {
    webService Id JobId {
        get;
    }
}
global class CategoryDO {
    webService Id CategoryId {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.CategoryDO> ChildCategories {
        get;
    }
    webService Boolean HasChildCategories {
        get;
    }
    webService String Name {
        get;
    }
    webService Id ParentCategoryId {
        get;
    }
    webService Integer ProductCount {
        get;
    }
}
global class CategorySearchResultDO {
    webService List<Apttus_CPQApi.CPQ.CategoryDO> Categories {
        get;
    }
    webService Boolean HasCategories {
        get;
    }
}
global class CloneLineItemsRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService List<Integer> PrimaryLineNumbers {
        get;
        set;
    }
    global CloneLineItemsRequestDO() {

    }
}
global class CloneLineItemsResponseDO {
    webService List<Apttus_CPQApi.CPQ.IntegerMapDO> OriginalToCloneMap {
        get;
    }
}
global class ComputeLoyaltyPointsRequestDO {
    webService Id EnrollmentId {
        get;
        set;
    }
    webService Integer OrderBatchSize {
        get;
        set;
    }
    webService Id OrderId {
        get;
        set;
    }
    global ComputeLoyaltyPointsRequestDO() {

    }
}
global class ComputeLoyaltyPointsResponseDO {
    webService List<Apttus_Config2__LoyaltyPointAccrualSummary__c> AccrualSummaries {
        get;
    }
    webService Boolean IsAsync {
        get;
    }
    webService Id JobId {
        get;
    }
}
global class ComputeNetPriceRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService Decimal LineNumber {
        get;
        set;
    }
    global ComputeNetPriceRequestDO() {

    }
}
global class ComputeNetPriceResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class ComputeShippingRequestDO {
    webService Id CartId {
        get;
        set;
    }
    global ComputeShippingRequestDO() {

    }
}
global class ComputeShippingResponseDO {
    global Map<Id,Apttus_Config2.CustomClass.ShippingResult> ShippingResults {
        get;
    }
    webService Apttus_Config2__LineItem__c TotalShippingItem {
        get;
    }
}
global class ComputeTaxRequestDO {
    webService Id CartId {
        get;
        set;
    }
    global ComputeTaxRequestDO() {

    }
}
global class ComputeTaxResponseDO {
    global Map<Id,Apttus_Config2.CustomClass.TaxResult> TaxResults {
        get;
    }
    webService Apttus_Config2__LineItem__c TotalTaxItem {
        get;
    }
}
global class ConstraintResultDO {
    webService Id CartId {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.AppliedActionDO> ConstraintRuleActions {
        get;
        set;
    }
    webService Boolean HasPendingError {
        get;
        set;
    }
    webService Boolean HasPendingWarning {
        get;
        set;
    }
    webService Boolean NeedMoreProcessing {
        get;
        set;
    }
    global ConstraintResultDO() {

    }
}
global class CreateCartRequestDO {
    webService List<Apttus_Config2.Property> Properties {
        get;
        set;
    }
    webService Id QuoteId {
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
global class CreateCriteriaRequestDO {
    webService Apttus_CPQApi.Criteria.SearchFilter CriteriaSpec {
        get;
        set;
    }
    global CreateCriteriaRequestDO() {

    }
}
global class CreateCriteriaResponseDO {
    webService String CriteriaFieldNames {
        get;
    }
    webService String CriteriaJSON {
        get;
    }
}
global class CreateDocumentForQuoteRequestDO {
    webService Id QuoteId {
        get;
        set;
    }
    webService List<Apttus_CPQApi.CPQ.QuoteOptionDO> QuoteOptions {
        get;
        set;
    }
    webService String ServerUrl {
        get;
        set;
    }
    webService String SessionId {
        get;
        set;
    }
    webService String TemplateName {
        get;
        set;
    }
    global CreateDocumentForQuoteRequestDO() {

    }
}
global class CreateDocumentForQuoteResponseDO {
    webService Id DocumentId {
        get;
    }
    webService String DocumentName {
        get;
    }
    webService String MIMEType {
        get;
    }
    webService String RelativeUrlToDocument {
        get;
    }
    webService Integer SizeInBytes {
        get;
    }
}
global class CreateOrderForPORequestDO {
    webService List<String> CustomFields {
        get;
        set;
    }
    webService Apttus_Config2__Order__c OrderInput {
        get;
        set;
    }
    webService List<Apttus_CPQApi.CPQ.SelectedPOItemDO> OrderItems {
        get;
    }
    webService List<Apttus_Config2.Property> Properties {
        get;
        set;
    }
    webService Id PurchaseOrderId {
        get;
        set;
    }
    webService List<String> SplitGroupFields {
        get;
        set;
    }
    global CreateOrderForPORequestDO() {

    }
}
global class CreateOrderForPOResponseDO {
    webService Id JobId {
        get;
    }
    webService Id OrderId {
        get;
    }
}
global class CreateOrderRequestDO {
    webService List<String> CustomFields {
        get;
        set;
    }
    webService Apttus_Config2__Order__c OrderInput {
        get;
        set;
    }
    webService List<Apttus_CPQApi.CPQ.SelectedProductDO> OrderItems {
        get;
    }
    webService String OrderItemSource {
        get;
        set;
    }
    webService List<Apttus_Config2.Property> Properties {
        get;
        set;
    }
    global CreateOrderRequestDO() {

    }
}
global class CreateOrderResponseDO {
    webService Id JobId {
        get;
    }
    webService Id OrderId {
        get;
    }
}
global class FeatureInfoRequestDO {
    webService List<Id> ProductIds {
        get;
        set;
    }
    global FeatureInfoRequestDO() {

    }
}
global class FeatureInfoResponseDO {
    webService List<Apttus_CPQApi.FeatureSupport.FeatureInfo> FeatureInfos {
        get;
    }
    webService Id ProductId {
        get;
    }
}
global class FinalizeCartRequestDO {
    webService Id CartId {
        get;
        set;
    }
    global FinalizeCartRequestDO() {

    }
}
global class FinalizeCartResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class GetAppliedIncentiveCodesForCartRequestDO {
    webService Id CartId {
        get;
        set;
    }
    global GetAppliedIncentiveCodesForCartRequestDO() {

    }
}
global class GetAppliedIncentiveCodesForCartResponseDO {
    webService List<String> IncentiveCodes {
        get;
    }
}
global class GetIncentivesForCartRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService Boolean InclCoupons {
        get;
        set;
    }
    global GetIncentivesForCartRequestDO() {

    }
}
global class GetIncentivesForCartResponseDO {
    webService List<Apttus_CPQApi.CPQ.AdjustmentItemCollDO> AppliedIncentives {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.IncentiveCouponCollDO> IncentiveCoupons {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.IncentiveItemCollDO> IncentiveItems {
        get;
    }
    webService List<Apttus_Config2__Incentive__c> Incentives {
        get;
    }
    global Map<Id,List<Apttus_Config2__AdjustmentLineItem__c>> getAppliedIncentivesByItem() {
        return null;
    }
    global Map<Id,List<Apttus_Config2__IncentiveCoupon__c>> getCouponsByIncentive() {
        return null;
    }
    global Map<Id,List<Apttus_Config2__Incentive__c>> getIncentivesByItem() {
        return null;
    }
}
global class GetLoyaltyLevelRequestDO {
    webService Id LoyaltyId {
        get;
        set;
    }
    webService Double Points {
        get;
        set;
    }
    global GetLoyaltyLevelRequestDO() {

    }
}
global class GetLoyaltyLevelResponseDO {
    webService String Level {
        get;
    }
}
global class GetPriceBreakupRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService Id LineItemId {
        get;
        set;
    }
    global GetPriceBreakupRequestDO() {

    }
}
global class GetPriceBreakupResponseDO {
    webService Boolean HasPriceBreakups {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.PriceBreakupCollDO> PriceBreakups {
        get;
    }
}
global class GetTotalAdjustedLoyaltyPointsRequestDO {
    webService Date EndDate {
        get;
        set;
    }
    webService Id EnrollmentId {
        get;
        set;
    }
    webService Date StartDate {
        get;
        set;
    }
    global GetTotalAdjustedLoyaltyPointsRequestDO() {

    }
}
global class GetTotalAdjustedLoyaltyPointsResponseDO {
    webService Double Points {
        get;
    }
}
global class IncentiveCouponCollDO {
    webService List<Apttus_Config2__IncentiveCoupon__c> Coupons {
        get;
        set;
    }
    webService Id IncentiveId {
        get;
        set;
    }
}
global class IncentiveItemCollDO {
    webService List<Apttus_Config2__Incentive__c> Incentives {
        get;
        set;
    }
    webService Id LineItemId {
        get;
        set;
    }
}
global class InitiateLoyaltyCycleRequestDO {
    webService Id EnrollmentId {
        get;
        set;
    }
    webService Integer OrderBatchSize {
        get;
        set;
    }
    global InitiateLoyaltyCycleRequestDO() {

    }
}
global class InitiateLoyaltyCycleResponseDO {
    webService Id JobId {
        get;
    }
}
global class IntegerMapDO {
    webService Integer Key {
        get;
    }
    webService Integer Value {
        get;
    }
}
global class LineItemCollDO {
    webService List<Apttus_Config2__LineItem__c> LineItems {
        get;
        set;
    }
    global LineItemCollDO() {

    }
}
global class MergeCriteriaRequestDO {
    webService String CriteriaExpr {
        get;
        set;
    }
    webService List<Apttus_CPQApi.Criteria.SearchFilter> CriteriaSpecs {
        get;
        set;
    }
    global MergeCriteriaRequestDO() {

    }
}
global class MergeCriteriaResponseDO {
    webService String CriteriaFieldNames {
        get;
    }
    webService String CriteriaJSON {
        get;
    }
}
global class ModifyAssetRequestDO {
    webService List<Apttus_CPQApi.CPQ.AssetActionDO> AssetActions {
        get;
        set;
    }
    webService Id CartId {
        get;
        set;
    }
    global ModifyAssetRequestDO() {

    }
}
global class ModifyAssetResponseDO {
    webService List<Apttus_CPQApi.CPQ.AssetActionDO> AssetActions {
        get;
        set;
    }
    webService List<Decimal> LineNumbers {
        get;
        set;
    }
}
global class OrderLineItemCollDO {
    webService List<Apttus_Config2__OrderLineItem__c> LineItems {
        get;
        set;
    }
    global OrderLineItemCollDO() {

    }
}
global class PocketAdjustmentCollDO {
    webService Id LineItemId {
        get;
    }
    webService List<Apttus_Config2__OrderPocketAdjustmentLineItem__c> PocketAdjItems {
        get;
    }
}
global class PriceBreakupCollDO {
    webService List<Apttus_Config2__PriceBreakup__c> BreakupItems {
        get;
    }
    webService Id LineItemId {
        get;
    }
}
global class PriceDO {
    webService String ChargeType {
        get;
    }
    webService Apttus_Config2__PriceListItem__c PriceItem {
        get;
    }
    webService Decimal Value {
        get;
    }
}
global class ProcessLoyaltyCycleRequestDO {
    webService List<Id> LoyaltyIds {
        get;
        set;
    }
    global ProcessLoyaltyCycleRequestDO() {

    }
}
global class ProcessLoyaltyCycleResponseDO {
    webService Id JobId {
        get;
    }
}
global class ProductDO {
    webService String ContentUrl {
        get;
    }
    webService String Description {
        get;
    }
    webService Boolean HasPrices {
        get;
    }
    webService Boolean HasProperties {
        get;
    }
    webService String ImageUrl {
        get;
    }
    webService String Name {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.PriceDO> Prices {
        get;
    }
    webService String ProductCode {
        get;
    }
    webService Id ProductId {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.PropertyDO> Properties {
        get;
    }
}
global class ProductOptionComponentDO {
    webService Id ComponentId {
        get;
    }
    webService Id ComponentProductId {
        get;
    }
    webService String Description {
        get;
    }
    webService Boolean HasPrices {
        get;
    }
    webService String ImageUrl {
        get;
    }
    webService Boolean IsDefault {
        get;
    }
    webService Boolean IsRequired {
        get;
    }
    webService String Name {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.PriceDO> Prices {
        get;
    }
    webService String ProductCode {
        get;
    }
}
global class ProductOptionGroupDO {
    webService List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> ChildOptionGroups {
        get;
    }
    webService Boolean HasChildOptionGroups {
        get;
    }
    webService Boolean HasOptionComponents {
        get;
    }
    webService String Label {
        get;
    }
    webService Integer MaxOptions {
        get;
    }
    webService Integer MinOptions {
        get;
    }
    webService String Name {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> OptionComponents {
        get;
    }
    webService Id ParentOptionGroupId {
        get;
    }
    webService Id ProductOptionGroupId {
        get;
    }
}
global class ProductOptionGroupSearchResultDO {
    webService Boolean HasOptionGroups {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> OptionGroups {
        get;
    }
}
global class ProductSearchResultDO {
    webService Boolean HasProducts {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.ProductDO> Products {
        get;
    }
}
global class PropertyDO {
    webService String Name {
        get;
    }
    webService String Value {
        get;
    }
}
global class QuoteLineItemCollDO {
    webService List<Apttus_Proposal__Proposal_Line_Item__c> LineItems {
        get;
        set;
    }
    global QuoteLineItemCollDO() {

    }
}
global class QuoteOptionDO {
    webService String Label {
        get;
        set;
    }
    webService String Name {
        get;
        set;
    }
    webService Boolean Value {
        get;
        set;
    }
    global QuoteOptionDO() {

    }
}
global class QuoteOptionSearchResultDO {
    webService Boolean HasOptions {
        get;
    }
    webService List<Apttus_CPQApi.CPQ.QuoteOptionDO> Options {
        get;
    }
}
global class RegisterLoyaltyMemberRequestDO {
    webService List<Apttus_Config2.Property> CustomData {
        get;
        set;
    }
    webService String CustomerType {
        get;
        set;
    }
    webService Date EligibilityStartDate {
        get;
        set;
    }
    webService Date EndDate {
        get;
        set;
    }
    webService Id IncentiveId {
        get;
        set;
    }
    webService Id MemberId {
        get;
        set;
    }
    webService String MemberIdOrName {
        get;
        set;
    }
    webService String PointAccrualLevel {
        get;
        set;
    }
    webService Date StartDate {
        get;
        set;
    }
    webService Boolean TermsAccepted {
        get;
        set;
    }
    global RegisterLoyaltyMemberRequestDO() {

    }
}
global class RegisterLoyaltyMemberResponseDO {
    webService Apttus_Config2__IncentiveLoyaltyEnrollment__c LoyaltyEnrollment {
        get;
    }
}
global class RemoveBundleRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService Decimal LineNumber {
        get;
        set;
    }
    global RemoveBundleRequestDO() {

    }
}
global class RemoveBundleResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class RemoveLineItemsRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService List<Integer> PrimaryLineNumbers {
        get;
        set;
    }
    global RemoveLineItemsRequestDO() {

    }
}
global class RemoveLineItemsResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class RemoveMultiBundlesRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService List<Decimal> LineNumbers {
        get;
        set;
    }
    global RemoveMultiBundlesRequestDO() {

    }
}
global class RemoveMultiBundlesResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class RemoveOptionsResponseDO {
    webService Boolean IsSuccess {
        get;
    }
    webService List<Id> RemovedIds {
        get;
    }
}
global class SelectedBundleDO {
    webService List<Apttus_CPQApi.CPQ.SelectedOptionDO> SelectedOptions {
        get;
        set;
    }
    webService Apttus_CPQApi.CPQ.SelectedProductDO SelectedProduct {
        get;
        set;
    }
    global SelectedBundleDO() {

    }
}
global class SelectedOptionDO {
    webService List<Apttus_Config2__ProductAttributeValue__c> AttributeValues {
        get;
        set;
    }
    webService String Comments {
        get;
        set;
    }
    webService Id ComponentId {
        get;
        set;
    }
    webService Id ComponentProductId {
        get;
        set;
    }
    webService Apttus_Config2__LineItem__c CustomData {
        get;
        set;
    }
    webService List<String> CustomFields {
        get;
        set;
    }
    webService Date EndDate {
        get;
        set;
    }
    webService Decimal Quantity {
        get;
        set;
    }
    webService List<Apttus_Config2__RelatedLineItem__c> RelatedLineItems {
        get;
        set;
    }
    webService Decimal SellingTerm {
        get;
        set;
    }
    webService Id SourceId {
        get;
        set;
    }
    webService Date StartDate {
        get;
        set;
    }
    global SelectedOptionDO() {

    }
}
global class SelectedPOItemDO {
    webService List<Apttus_Config2__ProductAttributeValue__c> AttributeValues {
        get;
        set;
    }
    webService String Comments {
        get;
        set;
    }
    webService Boolean CopyBundleConfigurationFromSource {
        get;
        set;
    }
    webService Apttus_Config2__LineItem__c CustomData {
        get;
        set;
    }
    webService List<String> CustomFields {
        get;
        set;
    }
    webService Date EndDate {
        get;
        set;
    }
    webService Id POItemId {
        get;
        set;
    }
    webService Id ProductId {
        get;
        set;
    }
    webService Decimal Quantity {
        get;
        set;
    }
    webService List<Apttus_Config2__RelatedLineItem__c> RelatedLineItems {
        get;
        set;
    }
    webService Decimal SellingTerm {
        get;
        set;
    }
    webService List<String> SourceFields {
        get;
        set;
    }
    webService Id SourceId {
        get;
        set;
    }
    webService Date StartDate {
        get;
        set;
    }
    global SelectedPOItemDO() {

    }
}
global class SelectedProductDO {
    webService List<Apttus_Config2__ProductAttributeValue__c> AttributeValues {
        get;
        set;
    }
    webService String Comments {
        get;
        set;
    }
    webService Boolean CopyBundleConfigurationFromSource {
        get;
        set;
    }
    webService Apttus_Config2__LineItem__c CustomData {
        get;
        set;
    }
    webService List<String> CustomFields {
        get;
        set;
    }
    webService Date EndDate {
        get;
        set;
    }
    webService Id ProductId {
        get;
        set;
    }
    webService Decimal Quantity {
        get;
        set;
    }
    webService List<Apttus_Config2__RelatedLineItem__c> RelatedLineItems {
        get;
        set;
    }
    webService Decimal SellingTerm {
        get;
        set;
    }
    webService List<String> SourceFields {
        get;
        set;
    }
    webService Id SourceId {
        get;
        set;
    }
    webService Date StartDate {
        get;
        set;
    }
    global SelectedProductDO() {

    }
}
global class SetIncentivesForCartRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService List<String> IncentiveCodes {
        get;
        set;
    }
    webService Id LineItemId {
        get;
        set;
    }
    global SetIncentivesForCartRequestDO() {

    }
}
global class SetIncentivesForCartResponseDO {
    webService Boolean IsSuccess {
        get;
    }
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
global class UnRegisterLoyaltyMemberRequestDO {
    webService Id IncentiveId {
        get;
        set;
    }
    webService Id MemberId {
        get;
        set;
    }
    webService String MemberIdOrName {
        get;
        set;
    }
    webService String PointAccrualLevel {
        get;
        set;
    }
    global UnRegisterLoyaltyMemberRequestDO() {

    }
}
global class UnRegisterLoyaltyMemberResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class UpdateManualAdjustmentsRequestDO {
    webService List<Apttus_CPQApi.CPQ.AdjustmentItemCollDO> AdjustmentItemColls {
        get;
        set;
    }
    webService Id CartId {
        get;
        set;
    }
    global UpdateManualAdjustmentsRequestDO() {

    }
}
global class UpdateManualAdjustmentsResponseDO {
    webService Boolean IsSuccess {
        get;
    }
}
global class UpdatePriceRequestDO {
    webService Id CartId {
        get;
        set;
    }
    global UpdatePriceRequestDO() {

    }
}
global class UpdatePriceResponseDO {
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
global class UpdateQuoteTermRequestDO {
    webService Date EndDate {
        get;
        set;
    }
    webService Apttus_CPQApi.CPQ.LineItemCollDO LineItemColl {
        get;
        set;
    }
    webService Id QuoteId {
        get;
        set;
    }
    webService Apttus_CPQApi.CPQ.QuoteLineItemCollDO QuoteLineItemColl {
        get;
        set;
    }
    webService Boolean ReCalcSellingTerm {
        get;
        set;
    }
    webService Decimal SellingTerm {
        get;
        set;
    }
    webService Date StartDate {
        get;
        set;
    }
    global UpdateQuoteTermRequestDO() {

    }
}
global class UpdateQuoteTermResponseDO {
    webService Id CartId {
        get;
    }
}
}
