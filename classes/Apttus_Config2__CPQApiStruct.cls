/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CPQApiStruct {
    global CPQApiStruct() {

    }
global class CreateOrderForPORequestDO {
    global List<String> CustomFields {
        get;
    }
    global Apttus_Config2__Order__c OrderInput {
        get;
        set;
    }
    global List<Apttus_Config2.CPQApiStruct.SelectedPOItemDO> OrderItems {
        get;
    }
    global List<Apttus_Config2.Property> Properties {
        get;
    }
    global Id PurchaseOrderId {
        get;
        set;
    }
    global List<String> SplitGroupFields {
        get;
    }
    global CreateOrderForPORequestDO() {

    }
}
global class CreateOrderForPOResponseDO {
    global Id JobId {
        get;
        set;
    }
    global Id OrderId {
        get;
        set;
    }
    global CreateOrderForPOResponseDO() {

    }
}
global class CreateOrderRequestDO {
    global List<String> CustomFields {
        get;
    }
    global Apttus_Config2__Order__c OrderInput {
        get;
        set;
    }
    global List<Apttus_Config2.CPQApiStruct.SelectedProductDO> OrderItems {
        get;
    }
    global String OrderItemSource {
        get;
        set;
    }
    global List<Apttus_Config2.Property> Properties {
        get;
    }
    global CreateOrderRequestDO() {

    }
}
global class CreateOrderResponseDO {
    global Id JobId {
        get;
        set;
    }
    global Id OrderId {
        get;
        set;
    }
    global CreateOrderResponseDO() {

    }
}
global class FilterDO {
    global String ConditionExpr {
        get;
        set;
    }
    global List<Apttus_Config2.CPQApiStruct.PredicateDO> Predicates {
        get;
    }
    global String SObjectName {
        get;
        set;
    }
    global FilterDO() {

    }
}
global class GetPriceAgreementItemsRequestDO {
    global Apttus_Config2.CPQApiStruct.FilterDO Criteria {
        get;
        set;
    }
    global List<String> Fields {
        get;
    }
    global List<String> PriceAgreementNumbers {
        get;
    }
    global String PriceAgreementType {
        get;
        set;
    }
    global GetPriceAgreementItemsRequestDO() {

    }
}
global class GetPriceAgreementItemsResponseDO {
    global List<SObject> PriceAgreementItems {
        get;
    }
    global GetPriceAgreementItemsResponseDO() {

    }
}
global class GetPriceAgreementsRequestDO {
    global List<Id> AccountIds {
        get;
    }
    global Apttus_Config2.CPQApiStruct.FilterDO Criteria {
        get;
        set;
    }
    global List<String> Fields {
        get;
    }
    global String PriceAgreementType {
        get;
        set;
    }
    global GetPriceAgreementsRequestDO() {

    }
}
global class GetPriceAgreementsResponseDO {
    global List<SObject> PriceAgreements {
        get;
    }
    global GetPriceAgreementsResponseDO() {

    }
}
global interface IOrderApiCallback {
    Apttus_Config2.CPQApiStruct.CreateOrderResponseDO createOrder(Apttus_Config2.CPQApiStruct.CreateOrderRequestDO param0);
    Apttus_Config2.CPQApiStruct.CreateOrderForPOResponseDO createOrderForPO(Apttus_Config2.CPQApiStruct.CreateOrderForPORequestDO param0);
}
global interface IPriceAgreementApiCallback {
    Apttus_Config2.CPQApiStruct.GetPriceAgreementItemsResponseDO getPriceAgreementItems(Apttus_Config2.CPQApiStruct.GetPriceAgreementItemsRequestDO param0);
    Apttus_Config2.CPQApiStruct.GetPriceAgreementsResponseDO getPriceAgreements(Apttus_Config2.CPQApiStruct.GetPriceAgreementsRequestDO param0);
}
global class PredicateDO {
    global String CompOper {
        get;
        set;
    }
    global String FieldLabel {
        get;
    }
    global String FieldName {
        get;
        set;
    }
    global String FieldType {
        get;
        set;
    }
    global String FieldValue {
        get;
        set;
    }
    global Integer RowNum {
        get;
        set;
    }
    global PredicateDO() {

    }
}
global class SelectedPOItemDO {
    global List<Apttus_Config2__ProductAttributeValue__c> AttributeValues {
        get;
    }
    global String Comments {
        get;
        set;
    }
    global Boolean CopyBundleConfigurationFromSource {
        get;
        set;
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
        set;
    }
    global Id POItemId {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global Decimal Quantity {
        get;
        set;
    }
    global List<Apttus_Config2__RelatedLineItem__c> RelatedLineItems {
        get;
    }
    global Decimal SellingTerm {
        get;
        set;
    }
    global List<String> SourceFields {
        get;
    }
    global Id SourceId {
        get;
        set;
    }
    global Date StartDate {
        get;
        set;
    }
    global SelectedPOItemDO(Id poItemId, Id productId, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate, String comments) {

    }
}
global class SelectedProductDO {
    global List<Apttus_Config2__ProductAttributeValue__c> AttributeValues {
        get;
    }
    global String Comments {
        get;
        set;
    }
    global Boolean CopyBundleConfigurationFromSource {
        get;
        set;
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
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global Decimal Quantity {
        get;
        set;
    }
    global List<Apttus_Config2__RelatedLineItem__c> RelatedLineItems {
        get;
    }
    global Decimal SellingTerm {
        get;
        set;
    }
    global List<String> SourceFields {
        get;
    }
    global Id SourceId {
        get;
        set;
    }
    global Date StartDate {
        get;
        set;
    }
    global SelectedProductDO(Id productId, Decimal quantity, Decimal sellingTerm, Date startdate, Date endDate, String comments) {

    }
}
}
