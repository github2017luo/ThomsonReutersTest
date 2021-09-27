/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CPQAdminStruct2 {
    global CPQAdminStruct2() {

    }
global class AttachmentRequestDO {
    global String AttachmentBody;
    global String AttachmentName;
    global Attachment AttachmentSO;
    global Id Id;
    global Id ParentId;
    global AttachmentRequestDO() {

    }
    global AttachmentRequestDO(Id parentId, String attachmentName, String attachmentBody) {

    }
    global AttachmentRequestDO(Id attachmentId, Id parentId, String attachmentName, String attachmentBody) {

    }
}
global class AttributeDO {
    global String AttributeFieldLabel {
        get;
        set;
    }
    global String FieldType {
        get;
        set;
    }
    global Boolean IsFieldCalculated {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PicklistValues {
        get;
        set;
    }
    global Apttus_Config2__ProductAttribute__c ProductAttributeSO {
        get;
        set;
    }
    global AttributeDO() {

    }
    global AttributeDO(Apttus_Config2__ProductAttribute__c productAttributeSO, String name, List<Schema.PicklistEntry> picklistValues) {

    }
    global AttributeDO(Apttus_Config2__ProductAttribute__c productAttributeSO, String name, List<Schema.PicklistEntry> picklistValues, String fieldType) {

    }
    global AttributeDO(Apttus_Config2__ProductAttribute__c productAttributeSO, String name, List<Schema.PicklistEntry> picklistValues, String fieldType, Boolean isFormulaField) {

    }
}
global class AttributeGroupDO {
    global Apttus_Config2__ProductAttributeGroup__c AttributeGroupSO {
        get;
        set;
    }
    global List<Apttus_Config2__FieldExpression__c> FieldExpressionSOs {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.AttributeDO> ProductAttributeDOs {
        get;
        set;
    }
    global List<Id> ProductAttributeGroupIds {
        get;
        set;
    }
    global List<Id> ProductAttributeGroupMemberIds {
        get;
        set;
    }
    global Apttus_Config2__ProductAttributeGroupMember__c ProductAttributeGroupMemberSO {
        get;
        set;
    }
    global List<Id> ProductAttributeIds {
        get;
        set;
    }
    global List<Apttus_Config2__ProductAttribute__c> ProductAttributeSOs {
        get;
        set;
    }
    global AttributeGroupDO() {

    }
    global AttributeGroupDO(Apttus_Config2__ProductAttributeGroup__c attributeGroupSO) {

    }
    global AttributeGroupDO(Apttus_Config2__ProductAttributeGroup__c attributeGroupSO, List<Apttus_Config2.CPQAdminStruct2.AttributeDO> productAttributeDOs) {

    }
}
global class AttributeGroupRequestDO {
    global List<Id> AttributeGroupIds {
        get;
        set;
    }
    global List<Id> AttributeGroupMemberIds {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.AttributeGroupDO> AttributeGroups {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer MaxNumberOfAttributesPerGroup {
        get;
        set;
    }
    global Integer NumberOfAttributeGroupsPerChunk {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global AttributeGroupRequestDO() {

    }
    global AttributeGroupRequestDO(List<Apttus_Config2.CPQAdminStruct2.AttributeGroupDO> attributeGroups, Integer groupsPerChunk) {

    }
    global AttributeGroupRequestDO(Integer chunkNumber, Integer groupsPerChunk, String searchString) {

    }
}
global class AttributeGroupResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.AttributeGroupDO> AttributeGroupDOs {
        get;
        set;
    }
    global Integer NumberOfAttributeGroupsInChunk {
        get;
        set;
    }
    global AttributeGroupResponseDO() {

    }
    global AttributeGroupResponseDO(List<Apttus_Config2.CPQAdminStruct2.AttributeGroupDO> attributeGroupDOs, Integer groupsPerChunk) {

    }
}
global class AttributeValueMatrixDO {
    global List<Apttus_Config2__AccountLocation__c> AccountLocationSOsInScope {
        get;
        set;
    }
    global List<String> AttributeFieldNames {
        get;
        set;
    }
    global List<String> AttributeFieldNamesToAdd {
        get;
        set;
    }
    global List<String> AttributeFieldNamesToRemove {
        get;
        set;
    }
    global List<Apttus_Config2__AttributeValueMatrixEntry__c> AttributeValueMatrixEntrySOs {
        get;
        set;
    }
    global Id AttributeValueMatrixId {
        get;
        set;
    }
    global Apttus_Config2__AttributeValueMatrix__c AttributeValueMatrixSO {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfEntriesInChunk {
        get;
        set;
    }
    global Integer NumberOfEntriesPerChunk {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.AttributeGroupDO ProductAttributeGroupDO {
        get;
        set;
    }
    global List<Apttus_Config2__ProductAttributeMatrixView__c> ProductAttributeMatrixViewSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroup__c> ProductGroupSOsInScope {
        get;
        set;
    }
    global List<Product2> ProductSOsInScope {
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
    global AttributeValueMatrixDO() {

    }
    global AttributeValueMatrixDO(Apttus_Config2__AttributeValueMatrix__c attrValueMatrixSO) {

    }
}
global class AutoCompleteItem implements System.Comparable {
    global String fieldName {
        get;
        set;
    }
    global String fieldNameReference {
        get;
        set;
    }
    global String fieldType {
        get;
        set;
    }
    global Boolean isFieldCalculated {
        get;
        set;
    }
    global String label {
        get;
        set;
    }
    global List<Schema.PicklistEntry> picklistValues {
        get;
        set;
    }
    global String sObjectName {
        get;
        set;
    }
    global String value {
        get;
        set;
    }
    global AutoCompleteItem() {

    }
    global AutoCompleteItem(String label, String value) {

    }
    global Integer compareTo(Object fItem) {
        return null;
    }
}
global class CartViewDO {
    global String CartViewName {
        get;
        set;
    }
    global String CartViewType {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ColumnDO> Columns {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.FilterCriteriaDO FilterCriteriaDO {
        get;
        set;
    }
    global String FlowName {
        get;
        set;
    }
    global String GroupBy {
        get;
        set;
    }
    global Boolean IsDefault {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ColumnDO> LeftColumns {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ColumnDO> MiddleColumns {
        get;
        set;
    }
    global List<Profile> ProfileSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ColumnDO> RightColumns {
        get;
        set;
    }
    global List<UserRole> RoleSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.SearchRowDO> SearchRowDOs {
        get;
        set;
    }
    global List<User> UserSO {
        get;
        set;
    }
    global CartViewDO() {

    }
    global CartViewDO(String cartViewName, String groupBy, List<Apttus_Config2.CPQAdminStruct2.ColumnDO> leftColumns, List<Apttus_Config2.CPQAdminStruct2.ColumnDO> middleColumns, List<Apttus_Config2.CPQAdminStruct2.ColumnDO> rightColumns, String cartViewType, String flowName, Boolean isDefault) {

    }
    global CartViewDO(String cartViewName, String groupBy, List<Apttus_Config2.CPQAdminStruct2.ColumnDO> leftColumns, List<Apttus_Config2.CPQAdminStruct2.ColumnDO> middleColumns, List<Apttus_Config2.CPQAdminStruct2.ColumnDO> rightColumns, String cartViewType, String flowName, List<User> userSO, Boolean isDefault) {

    }
}
global class CartViewFieldDO {
    global String FieldType {
        get;
        set;
    }
    global Boolean IsEditable {
        get;
        set;
    }
    global String Label {
        get;
        set;
    }
    global Integer Sequence {
        get;
        set;
    }
    global String Value {
        get;
        set;
    }
    global CartViewFieldDO() {

    }
    global CartViewFieldDO(String label, String value) {

    }
    global CartViewFieldDO(String label, String value, String fieldtype) {

    }
}
global class CartViewRequestDO {
    global Id ConfigRequestId {
        get;
        set;
    }
    global String FlowName {
        get;
        set;
    }
    global String RequestFrom {
        get;
        set;
    }
    global String SourceObject {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.CartViewDO ViewRecordDO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.CartViewDO> ViewRecordsDO {
        get;
        set;
    }
    global CartViewRequestDO(Apttus_Config2.CPQAdminStruct2.CartViewDO viewRecordDO) {

    }
    global CartViewRequestDO(Apttus_Config2.CPQAdminStruct2.CartViewDO viewRecordDO, String requestFrom) {

    }
    global CartViewRequestDO(Id configRequestId, Apttus_Config2.CPQAdminStruct2.CartViewDO viewRecordDO) {

    }
    global CartViewRequestDO(String flowName, String requestFrom) {

    }
}
global class CartViewResponseDO {
    global Boolean hasErrors {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.CartViewDO> ListViewDO {
        get;
        set;
    }
    global String UserDefaultView {
        get;
        set;
    }
    global CartViewResponseDO() {

    }
    global CartViewResponseDO(List<Apttus_Config2.CPQAdminStruct2.CartViewDO> listviewDO) {

    }
    global CartViewResponseDO(List<Apttus_Config2.CPQAdminStruct2.CartViewDO> listviewDO, String userDefaultView) {

    }
}
global class CategoryNodeDO {
    global List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> ChildCategoryDOs {
        get;
        set;
    }
    global Apttus_Config2__ClassificationHierarchy__c ClsHierarchySO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> FieldMetadata {
        get;
        set;
    }
    global List<Product2> ProductSOs {
        get;
        set;
    }
    global CategoryNodeDO() {

    }
    global CategoryNodeDO(Apttus_Config2__ClassificationHierarchy__c hierarchySO) {

    }
    global CategoryNodeDO(Apttus_Config2__ClassificationHierarchy__c hierarchySO, List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> childCategorySOs) {

    }
    global void addChild(Apttus_Config2.CPQAdminStruct2.CategoryNodeDO childWrapper) {

    }
}
global class CategoryRequestDO {
    global Id CategoryToMoveId {
        get;
        set;
    }
    global Id NewLocationCategoryId {
        get;
        set;
    }
    global CategoryRequestDO() {

    }
}
global class CategoryResponseDO {
    global List<Apttus_Config2__ClassificationHierarchy__c> CategoryHierarchySOs {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> CategoryNodeDOs {
        get;
        set;
    }
    global CategoryResponseDO() {

    }
}
global class ColumnDO {
    global String ColumnName {
        get;
        set;
    }
    global String ColumnSequence {
        get;
        set;
    }
    global ColumnDO(String columnName, String columnSequence) {

    }
}
global class ConstraintRuleActionDO {
    global List<Apttus_Config2__ConstraintRuleActionExpression__c> ConstraintRuleActionExpressionSOs {
        get;
        set;
    }
    global Apttus_Config2__ConstraintRuleAction__c ConstraintRuleActionSO {
        get;
        set;
    }
    global ConstraintRuleActionDO() {

    }
    global ConstraintRuleActionDO(Apttus_Config2__ConstraintRuleAction__c ruleActionSO) {

    }
    global ConstraintRuleActionDO(Apttus_Config2__ConstraintRuleAction__c ruleActionSO, List<Apttus_Config2__ConstraintRuleActionExpression__c> ruleActionExpressionSOs) {

    }
}
global class ConstraintRuleDO {
    global List<Apttus_Config2.CPQAdminStruct2.ConstraintRuleActionDO> ConstraintRuleActionDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ConstraintRuleAction__c> ConstraintRuleActionSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ConstraintRuleCondition__c> ConstraintRuleConditionSOs {
        get;
        set;
    }
    global Apttus_Config2__ConstraintRule__c ConstraintRuleSO {
        get;
        set;
    }
    global ConstraintRuleDO() {

    }
    global ConstraintRuleDO(Apttus_Config2__ConstraintRule__c constraintRuleSO) {

    }
    global ConstraintRuleDO(Apttus_Config2__ConstraintRule__c constraintRuleSO, List<Apttus_Config2__ConstraintRuleCondition__c> ruleConditionSOs, List<Apttus_Config2.CPQAdminStruct2.ConstraintRuleActionDO> ruleActionSOs) {

    }
}
global class CriteriaFieldDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> FilterDO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> InclusionDO {
        get;
        set;
    }
    global CriteriaFieldDO(List<Apttus_Config2.CPQAdminStruct2.FieldDO> inclusionDO, List<Apttus_Config2.CPQAdminStruct2.FieldDO> filterDO) {

    }
}
global class EdgeDO {
    global Integer FromNode {
        get;
        set;
    }
    global Integer ToNode {
        get;
        set;
    }
    global EdgeDO() {

    }
    global EdgeDO(Integer fromNode, Integer toNode) {

    }
}
global class FavoriteConfigSettingsRequestDO {
    global Apttus_Config2__ConfigSelectConfigProductsSettings__c ConfigProductsSettingsSO {
        get;
        set;
    }
    global Apttus_Config2__ConfigSystemProperties__c ConfigSystemPropertiesSO {
        get;
        set;
    }
    global FavoriteConfigSettingsRequestDO() {

    }
}
global class FavoriteConfigSettingsResponseDO {
    global Apttus_Config2__ConfigSelectConfigProductsSettings__c ConfigProductsSettingsSO {
        get;
        set;
    }
    global Apttus_Config2__ConfigSystemProperties__c ConfigSystemPropertiesSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> FieldMetadata {
        get;
        set;
    }
    global FavoriteConfigSettingsResponseDO() {

    }
}
global class FeatureSetDO {
    global Apttus_Config2__FeatureSet__c FeatureSetSO {
        get;
        set;
    }
    global List<Apttus_Config2__ProductFeatureValue__c> ProductFeatureValueSOs {
        get;
        set;
    }
    global FeatureSetDO() {

    }
}
global class FieldDO {
    global String FieldLabel {
        get;
        set;
    }
    global String FieldName {
        get;
        set;
    }
    global Boolean IsEditable {
        get;
        set;
    }
    global Boolean IsExternalID {
        get;
        set;
    }
    global Boolean IsRequired {
        get;
        set;
    }
    global Boolean IsRichText {
        get;
        set;
    }
    global Integer Length {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PicklistValues {
        get;
        set;
    }
    global Integer Precision {
        get;
        set;
    }
    global String ReferenceTo {
        get;
        set;
    }
    global String RelationshipFieldName {
        get;
        set;
    }
    global Integer Scale {
        get;
        set;
    }
    global String Type {
        get;
        set;
    }
    global String Value {
        get;
        set;
    }
    global FieldDO() {

    }
    global FieldDO(Schema.FieldSetMember fieldSetMember) {

    }
    global FieldDO(String fieldName, String fieldLabel, String type, String value, Boolean isRequired, Boolean isEditable, Boolean isRichText, List<Schema.PicklistEntry> picklistValues) {

    }
    global FieldDO(String fieldName, String fieldLabel, String type, String value, Boolean isRequired, Boolean isEditable, Boolean isRichText, List<Schema.PicklistEntry> picklistValues, String relationshipName) {

    }
    global FieldDO(String fieldName, String fieldLabel, String type, String value, Boolean isRequired, Boolean isEditable, Boolean isRichText, List<Schema.PicklistEntry> picklistValues, String relationshipName, Integer length, Integer precision, Integer scale, String referenceTo) {

    }
}
global class FieldExpressionDetailResponse {
    global Apttus_Config2__FieldExpression__c fieldExpression {
        get;
        set;
    }
    global FieldExpressionDetailResponse() {

    }
}
global class FieldExpressionRequest {
    global Integer chunkNumber {
        get;
        set;
    }
    global String expressionType {
        get;
        set;
    }
    global Integer numberOfRecordsPerChunk {
        get;
        set;
    }
    global String searchString {
        get;
        set;
    }
    global String sortDirection {
        get;
        set;
    }
    global String sortField {
        get;
        set;
    }
    global FieldExpressionRequest() {

    }
}
global class FieldExpressionResponse {
    global List<Apttus_Config2__FieldExpression__c> fieldExpressions {
        get;
        set;
    }
    global Integer numberOfSearchFiltersInChunk {
        get;
        set;
    }
    global FieldExpressionResponse() {

    }
}
global class FilterCriteriaDO {
    global Boolean IsMatchParentLinesOnly {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.SearchRowDO> SearchRowDOs {
        get;
        set;
    }
    global FilterCriteriaDO() {

    }
}
global class FootnoteDO {
    global Apttus_Config2__Footnote__c FootnoteSO {
        get;
        set;
    }
    global Id ProductFootnoteId {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global Integer SequenceNumber {
        get;
        set;
    }
    global FootnoteDO() {

    }
}
global class FormulaFieldRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global String SearchString {
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
    global FormulaFieldRequestDO() {

    }
}
global class FormulaFieldResponseDO {
    global List<Apttus_Config2__FormulaField__c> FormulaFieldSOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global FormulaFieldResponseDO() {

    }
}
global class GenericRuleDO implements System.Comparable {
    global Id Id {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global String RuleType {
        get;
        set;
    }
    global GenericRuleDO() {

    }
    global GenericRuleDO(Id ruleId, String name, String ruleType) {

    }
    global Integer compareTo(Object genericRuleObj) {
        return null;
    }
}
global class GetAttributeRequestDO {
    global Id AttributeGroupId {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global GetAttributeRequestDO() {

    }
    global GetAttributeRequestDO(Id pagId, Integer attributesPerChunk, Integer chunkNumber) {

    }
}
global class GetAttributeResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.AttributeDO> AttributeDOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global GetAttributeResponseDO() {

    }
    global GetAttributeResponseDO(List<Apttus_Config2.CPQAdminStruct2.AttributeDO> attributeDOs, Integer attributesPerChunk) {

    }
}
global class GetAttributeValueMatrixRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean IncludeRulesForBundleOptions {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetAttributeValueMatrixRequestDO() {

    }
    global GetAttributeValueMatrixRequestDO(Integer chunkNumber, Integer numOfRecordsPerChunk, Id productId, String searchString) {

    }
}
global class GetAttributeValueMatrixResponseDO {
    global List<Apttus_Config2__AttributeValueMatrix__c> AttributeValueMatrixSOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global GetAttributeValueMatrixResponseDO() {

    }
    global GetAttributeValueMatrixResponseDO(List<Apttus_Config2__AttributeValueMatrix__c> avmSOs, Integer numOfRecords) {

    }
}
global class GetAutoCompleteItemsRequest {
    global Boolean GetExtraReferenceDotNameFields {
        get;
        set;
    }
    global Boolean IncludeNormalReferenceFields {
        get;
        set;
    }
    global Boolean IncludeTextAreaFields {
        get;
        set;
    }
    global String SObjectName {
        get;
        set;
    }
    global GetAutoCompleteItemsRequest() {

    }
}
global class GetAutoCompleteItemsResponse {
    global List<Apttus_Config2.CPQAdminStruct2.AutoCompleteItem> FieldItems {
        get;
        set;
    }
    global GetAutoCompleteItemsResponse() {

    }
}
global class GetCategoryRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean HasZeroProductCount {
        get;
        set;
    }
    global Boolean IsCategoryHierarchyRetrieval {
        get;
        set;
    }
    global Integer NumberOfCategoriesPerChunk {
        get;
        set;
    }
    global Id PriceListId {
        get;
        set;
    }
    global String SearchString {
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
    global List<String> Types {
        get;
        set;
    }
    global GetCategoryRequestDO() {

    }
    global GetCategoryRequestDO(Integer chunkNumber, Integer numberOfCategoriesPerChunk, String searchString) {

    }
    global GetCategoryRequestDO(Integer chunkNumber, Integer numberOfCategoriesPerChunk, String searchString, Id priceListId) {

    }
}
global class GetCategoryResponseDO {
    global List<Apttus_Config2__ClassificationHierarchy__c> CategoryHierarchySOs {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> CategoryNodeDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ClassificationName__c> CategorySOs {
        get;
        set;
    }
    global Integer NumberOfCategoriesInChunk {
        get;
        set;
    }
    global GetCategoryResponseDO() {

    }
    global GetCategoryResponseDO(List<Apttus_Config2__ClassificationName__c> categorySOs, Integer numberOfCategoriesInChunk) {

    }
    global GetCategoryResponseDO(Integer numberOfCategoriesInChunk, List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> categoryNodeDOs) {

    }
}
global class GetConstraintRuleRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean IncludeRulesForBundleOptions {
        get;
        set;
    }
    global Integer NumberOfConstraintRulesPerChunk {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetConstraintRuleRequestDO() {

    }
    global GetConstraintRuleRequestDO(Integer chunkNumber, Integer numberOfConstraintRulesPerChunk, List<Id> productIds, String searchString) {

    }
}
global class GetConstraintRuleResponseDO {
    global List<Apttus_Config2__ConstraintRuleCondition__c> ConstraintRules {
        get;
        set;
    }
    global List<Apttus_Config2__ConstraintRule__c> ConstraintRuleSOs {
        get;
        set;
    }
    global Integer NumberOfConstraintRulesInChunk {
        get;
        set;
    }
    global GetConstraintRuleResponseDO() {

    }
    global GetConstraintRuleResponseDO(List<Apttus_Config2__ConstraintRule__c> constraintRules, Integer numberOfRulesInChunk) {

    }
    global GetConstraintRuleResponseDO(Integer numberOfConstraintRulesInChunk, List<Apttus_Config2__ConstraintRuleCondition__c> constraintRules) {

    }
}
global class GetGenericRulesRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean IncludeRulesForBundleOptions {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetGenericRulesRequestDO() {

    }
    global GetGenericRulesRequestDO(Integer chunkNumber, Integer numOfRecordsPerChunk, Id productId, String searchString) {

    }
}
global class GetGenericRulesResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.GenericRuleDO> GenericRuleDOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global GetGenericRulesResponseDO() {

    }
    global GetGenericRulesResponseDO(List<Apttus_Config2.CPQAdminStruct2.GenericRuleDO> ruleDOs, Integer numOfRecsInChunk) {

    }
}
global class GetGenericSObjectRequestDO {
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
    global GetGenericSObjectRequestDO() {

    }
}
global class GetGenericSObjectResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global String SObjectRecordsJsonString {
        get;
        set;
    }
    global GetGenericSObjectResponseDO(String sObjRecsStr, Integer numOfRecords) {

    }
}
global class GetOptionGroupRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean HasZeroProductCount {
        get;
        set;
    }
    global Boolean IsProductOptionGroupRetrieval {
        get;
        set;
    }
    global Integer NumberOfOptionGroupsPerChunk {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetOptionGroupRequestDO() {

    }
    global GetOptionGroupRequestDO(Integer chunkNumber, Integer numberOfOptionGroupsPerChunk, String searchString) {

    }
}
global class GetOptionGroupResponseDO {
    global Integer NumberOfOptionGroupsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> OptionGroupDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductOptionGroup__c> ProductOptionGroupSOs {
        get;
        set;
    }
    global GetOptionGroupResponseDO() {

    }
    global GetOptionGroupResponseDO(Integer numberOfOptionGroupsInChunk, List<Apttus_Config2.CPQAdminStruct2.CategoryNodeDO> optionGroupDOs) {

    }
}
global class GetPriceDimensionRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean GetCumulativeDimensionsOnly {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global List<Id> PriceDimensionIds {
        get;
        set;
    }
    global String SearchString {
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
    global GetPriceDimensionRequestDO() {

    }
    global GetPriceDimensionRequestDO(String searchString) {

    }
}
global class GetPriceDimensionResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceDimensionDO> PriceDimensionDOs {
        get;
        set;
    }
    global List<Apttus_Config2__PriceDimension__c> PriceDimensionSOs {
        get;
        set;
    }
    global GetPriceDimensionResponseDO() {

    }
    global GetPriceDimensionResponseDO(List<Apttus_Config2__PriceDimension__c> priceDimensionSOs, Integer numOfRecords) {

    }
}
global class GetPriceListItemRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Id PriceListId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetPriceListItemRequestDO() {

    }
    global GetPriceListItemRequestDO(Id priceListId, Integer chunkNumber, Integer numberOfRecordsPerChunk, String searchString) {

    }
}
global class GetPriceListItemResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceListItemDO> PriceListItemDOs {
        get;
        set;
    }
    global List<Apttus_Config2__PriceListItem__c> PriceListItemSOs {
        get;
        set;
    }
    global GetPriceListItemResponseDO() {

    }
    global GetPriceListItemResponseDO(Integer numberOfRecordsInChunk, List<Apttus_Config2__PriceListItem__c> priceListItemSOs) {

    }
}
global class GetPriceListRequestDO {
    global Id CategoryId {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetPriceListRequestDO() {

    }
    global GetPriceListRequestDO(Integer chunkNumber, Integer numberOfRecordsPerChunk, String searchString) {

    }
    global GetPriceListRequestDO(Integer chunkNumber, Integer numberOfRecordsPerChunk, String searchString, Id categoryId) {

    }
}
global class GetPriceListResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceListDO> PriceListDOs {
        get;
        set;
    }
    global GetPriceListResponseDO() {

    }
    global GetPriceListResponseDO(List<Apttus_Config2.CPQAdminStruct2.PriceListDO> priceListDOs, Integer numberOfRecordsInChunk) {

    }
}
global class GetPriceMatrixRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfEntriesPerChunk {
        get;
        set;
    }
    global Id PriceMatrixId {
        get;
        set;
    }
    global GetPriceMatrixRequestDO() {

    }
}
global class GetPriceMatrixResponseDO {
    global Integer NumberOfEntriesInChunk {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.PriceMatrixDO PriceMatrixDO {
        get;
        set;
    }
    global GetPriceMatrixResponseDO() {

    }
    global GetPriceMatrixResponseDO(Apttus_Config2.CPQAdminStruct2.PriceMatrixDO priceMatrixDO, Integer numberOfEntriesInChunk) {

    }
}
global class GetPriceRuleRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfEntriesPerChunk {
        get;
        set;
    }
    global Id PriceRuleId {
        get;
        set;
    }
    global GetPriceRuleRequestDO() {

    }
}
global class GetPriceRuleResponseDO {
    global Integer NumberOfEntriesInChunk {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.PriceRuleDO PriceRuleDO {
        get;
        set;
    }
    global GetPriceRuleResponseDO() {

    }
    global GetPriceRuleResponseDO(Apttus_Config2.CPQAdminStruct2.PriceRuleDO priceRuleDO, Integer numOfEntries) {

    }
}
global class GetPriceRulesetRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean IncludeMetadataForPriceRule {
        get;
        set;
    }
    global Boolean IncludeMetadataForPriceRuleEntry {
        get;
        set;
    }
    global Boolean IncludeMetadataForPriceRuleset {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global List<Id> PriceRulesetIds {
        get;
        set;
    }
    global String SearchString {
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
    global GetPriceRulesetRequestDO() {

    }
    global GetPriceRulesetRequestDO(List<Id> priceRulesetIds) {

    }
}
global class GetPriceRulesetResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> PriceRuleEntryMetadata {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> PriceRuleMetadata {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceRulesetDO> PriceRulesetDOs {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> PriceRulesetMetadata {
        get;
        set;
    }
    global GetPriceRulesetResponseDO() {

    }
    global GetPriceRulesetResponseDO(List<Apttus_Config2.CPQAdminStruct2.PriceRulesetDO> priceRulesetDOs) {

    }
}
global class GetProductAttributeRuleRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Boolean IncludeRulesForBundleOptions {
        get;
        set;
    }
    global Integer NumberOfAttributeRulesPerChunk {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetProductAttributeRuleRequestDO() {

    }
    global GetProductAttributeRuleRequestDO(Integer chunkNumber, Integer numberOfAttributeRulesPerChunk, List<Id> productIds, String searchString) {

    }
}
global class GetProductAttributeRuleResponseDO {
    global List<Apttus_Config2__ProductAttributeRule__c> AttributeRuleSOs {
        get;
        set;
    }
    global Integer NumberOfAttributeRulesInChunk {
        get;
        set;
    }
    global GetProductAttributeRuleResponseDO() {

    }
    global GetProductAttributeRuleResponseDO(Integer numberOfAttributeRulesInChunk, List<Apttus_Config2__ProductAttributeRule__c> attributeRuleSOs) {

    }
}
global class GetProductGroupRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Id ProductGroupId {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global GetProductGroupRequestDO() {

    }
    global GetProductGroupRequestDO(Integer chunkNumber, Integer numberOfRecordsPerChunk, String searchString) {

    }
}
global class GetProductGroupResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ProductGroupDO> ProductGroupDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroupMember__c> ProductGroupMemberSOs {
        get;
        set;
    }
    global GetProductGroupResponseDO() {

    }
    global GetProductGroupResponseDO(List<Apttus_Config2.CPQAdminStruct2.ProductGroupDO> productGroupDOs, Integer numberOfRecordsInChunk) {

    }
}
global class GetProductRequestDO {
    global Id CategoryId {
        get;
        set;
    }
    global Integer ChunkNumber {
        get;
        set;
    }
    global String ConfigType {
        get;
        set;
    }
    global List<String> ConfigTypes {
        get;
        set;
    }
    global Integer NumberOfProductsPerChunk {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.SearchRowDO> SearchRowDOs {
        get;
        set;
    }
    global String SearchString {
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
    global String ViewName {
        get;
        set;
    }
    global GetProductRequestDO() {

    }
    global GetProductRequestDO(Integer chunkNumber, Integer numberOfProductsPerChunk, String viewName, String searchString, String configType, String sortField, String sortDirection) {

    }
    global GetProductRequestDO(Integer chunkNumber, Integer numberOfProductsPerChunk, String viewName, String searchString, String configType, String sortField, String sortDirection, List<String> configTypes) {

    }
}
global class GetProductResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> DisplayColumns {
        get;
        set;
    }
    global Integer NumberOfProductsInChunk {
        get;
        set;
    }
    global List<Apttus_Config2__ProductClassification__c> ProductClassificationSOs {
        get;
        set;
    }
    global List<Product2> ProductSOs {
        get;
        set;
    }
    global GetProductResponseDO() {

    }
    global GetProductResponseDO(Integer numberOfProductsInChunk, List<Product2> products, List<Apttus_Config2.CPQAdminStruct2.FieldDO> displayColumns) {

    }
}
global class HierarchyDO2 {
    global Id ChildOptionGroupId {
        get;
        set;
    }
    global Id ChildProductId {
        get;
        set;
    }
    global Id ParentOptionGroupId {
        get;
        set;
    }
    global Id ParentProductId {
        get;
        set;
    }
    global HierarchyDO2() {

    }
    global HierarchyDO2(Id parentProductId, Id childProductId, Id parentOptionGroupId, Id childOptionGroupId) {

    }
}
global class HierarchyRequestDO2 {
    global List<Apttus_Config2.CPQAdminStruct2.HierarchyDO2> HierarchyDOs {
        get;
        set;
    }
    global Id OptionGroupId {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global HierarchyRequestDO2() {

    }
}
global class IncentiveExclusionDO {
    global List<Account> AccountScope {
        get;
        set;
    }
    global Apttus_Config2__IncentiveExclusion__c IncentiveExclusionSO {
        get;
        set;
    }
    global List<Apttus_Config2__PriceList__c> PriceListScope {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroup__c> ProductGroupScope {
        get;
        set;
    }
    global List<Product2> ProductScope {
        get;
        set;
    }
    global IncentiveExclusionDO() {

    }
    global IncentiveExclusionDO(Apttus_Config2__IncentiveExclusion__c incentiveExclusionSO) {

    }
}
global class IncentiveExclusionRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Id IncentiveExclusionId {
        get;
        set;
    }
    global List<Id> IncentiveExclusionIds {
        get;
        set;
    }
    global List<Apttus_Config2__IncentiveExclusion__c> IncentiveExclusionSOs {
        get;
        set;
    }
    global Boolean IncludeMetadata {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global IncentiveExclusionRequestDO() {

    }
}
global class IncentiveExclusionResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> FieldMetadata {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.IncentiveExclusionDO IncentiveExclusionDO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.IncentiveExclusionDO> IncentiveExclusionDOs {
        get;
        set;
    }
    global List<Apttus_Config2__IncentiveExclusion__c> IncentiveExclusionSOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global Boolean Success {
        get;
        set;
    }
    global IncentiveExclusionResponseDO() {

    }
}
global class LookupFieldSettingsRequestDO {
    global List<Id> LookupFieldSettingIds {
        get;
        set;
    }
    global String LookupFieldSettingName {
        get;
        set;
    }
    global List<Apttus_Config2__LookupFieldSettings__c> LookupFieldSettingSOs {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global LookupFieldSettingsRequestDO() {

    }
}
global class LookupFieldSettingsResponseDO {
    global String ErrorMessage {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> FieldMetadata {
        get;
        set;
    }
    global Apttus_Config2__LookupFieldSettings__c LookupFieldSettingSO {
        get;
        set;
    }
    global List<Apttus_Config2__LookupFieldSettings__c> LookupFieldSettingSOs {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global Boolean Success {
        get;
        set;
    }
    global LookupFieldSettingsResponseDO() {

    }
}
global class NodeDO {
    global Integer Id {
        get;
        set;
    }
    global String Label {
        get;
        set;
    }
    global String Type {
        get;
        set;
    }
    global NodeDO() {

    }
    global NodeDO(Integer id, String type, String label) {

    }
}
global class ObjectSummarySettingsRequestDO {
    global List<Id> ObjectSummarySettingsIds {
        get;
        set;
    }
    global String ObjectSummarySettingsName {
        get;
        set;
    }
    global List<Apttus_Config2__ObjectSummarySettings__c> ObjectSummarySettingsSOs {
        get;
        set;
    }
    global String SearchString {
        get;
        set;
    }
    global ObjectSummarySettingsRequestDO() {

    }
}
global class ObjectSummarySettingsResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> FieldMetadata {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global Apttus_Config2__ObjectSummarySettings__c ObjectSummarySettingsSO {
        get;
        set;
    }
    global List<Apttus_Config2__ObjectSummarySettings__c> ObjectSummarySettingsSOs {
        get;
        set;
    }
    global Boolean Success {
        get;
        set;
    }
    global ObjectSummarySettingsResponseDO() {

    }
}
global class PriceDimensionDO {
    global Apttus_Config2.CPQAdminStruct2.FieldDO FieldDO {
        get;
        set;
    }
    global Apttus_Config2__PriceDimension__c PriceDimensionSO {
        get;
        set;
    }
    global PriceDimensionDO() {

    }
}
global class PriceDimensionRequestDO {
    global List<Apttus_Config2__PriceDimension__c> PriceDimensionSOs {
        get;
        set;
    }
    global PriceDimensionRequestDO() {

    }
}
global class PriceDimensionResponseDO {
    global List<Apttus_Config2__PriceDimension__c> PriceDimensionSOs {
        get;
        set;
    }
    global PriceDimensionResponseDO() {

    }
    global PriceDimensionResponseDO(List<Apttus_Config2__PriceDimension__c> priceDimensionSOs) {

    }
}
global class PriceListDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> FieldMetadata {
        get;
        set;
    }
    global Id PriceListId {
        get;
        set;
    }
    global Integer PriceListItemCount {
        get;
        set;
    }
    global List<Apttus_Config2__PriceListItem__c> PriceListItemSOs {
        get;
        set;
    }
    global Apttus_Config2__PriceList__c PriceListSO {
        get;
        set;
    }
    global PriceListDO() {

    }
    global PriceListDO(Apttus_Config2__PriceList__c priceListSO) {

    }
    global PriceListDO(Apttus_Config2__PriceList__c priceList, List<Apttus_Config2__PriceListItem__c> priceListItems) {

    }
}
global class PriceListItemDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> FieldMetadata {
        get;
        set;
    }
    global Apttus_Config2__PriceListItem__c PriceListItemSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceMatrixDO> PriceMatrixDOs {
        get;
        set;
    }
    global List<Apttus_Config2__RelatedPriceListItem__c> RelatedPriceListItemSOs {
        get;
        set;
    }
    global PriceListItemDO() {

    }
    global PriceListItemDO(Apttus_Config2__PriceListItem__c pliSO) {

    }
}
global class PriceMatrixDO {
    global List<Apttus_Config2.CPQAdminStruct2.PriceDimensionDO> PriceDimensionDOs {
        get;
        set;
    }
    global List<Apttus_Config2__PriceMatrixEntry__c> PriceMatrixEntrySOs {
        get;
        set;
    }
    global Apttus_Config2__PriceMatrix__c PriceMatrixSO {
        get;
        set;
    }
    global PriceMatrixDO() {

    }
    global PriceMatrixDO(Apttus_Config2__PriceMatrix__c priceMatrixSO) {

    }
}
global class PriceRuleDO {
    global List<Apttus_Config2.CPQAdminStruct2.PriceDimensionDO> PriceDimensionDOs {
        get;
        set;
    }
    global List<Apttus_Config2__PriceRuleEntry__c> PriceRuleEntrySOs {
        get;
        set;
    }
    global Apttus_Config2__PriceRule__c PriceRuleSO {
        get;
        set;
    }
    global PriceRuleDO() {

    }
    global PriceRuleDO(Apttus_Config2__PriceRule__c priceRuleSO) {

    }
}
global class PriceRulesetDO {
    global Apttus_Config2__ClassificationHierarchy__c CategoryHierarchySO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceRuleDO> PriceRuleDOs {
        get;
        set;
    }
    global Apttus_Config2__PriceRuleset__c PriceRulesetSO {
        get;
        set;
    }
    global PriceRulesetDO() {

    }
    global PriceRulesetDO(Apttus_Config2__PriceRuleset__c pliSO) {

    }
}
global class PriceRulesetRequestDO {
    global List<Id> PriceRuleEntryIds {
        get;
        set;
    }
    global List<Id> PriceRuleIds {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.PriceRulesetDO> PriceRulesetDOs {
        get;
        set;
    }
    global List<Id> PriceRulesetIds {
        get;
        set;
    }
    global PriceRulesetRequestDO() {

    }
}
global class PriceRulesetResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.PriceRulesetDO> PriceRulesetDOs {
        get;
        set;
    }
    global Boolean Success {
        get;
        set;
    }
    global PriceRulesetResponseDO() {

    }
}
global class PricingDO {
    global List<Id> PriceDimensionIds {
        get;
        set;
    }
    global List<Id> PriceListIds {
        get;
        set;
    }
    global List<Id> PriceListItemIds {
        get;
        set;
    }
    global List<Id> PriceMatrixEntryIds {
        get;
        set;
    }
    global List<Id> PriceMatrixIds {
        get;
        set;
    }
    global List<Id> ProductOptionPriceIds {
        get;
        set;
    }
    global List<Id> RelatedPriceListItemIds {
        get;
        set;
    }
    global PricingDO() {

    }
}
global class PricingMetadataDO {
    global List<Schema.PicklistEntry> ChargeTypes {
        get;
        set;
    }
    global List<Schema.PicklistEntry> Frequency {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PriceMethods {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PriceTypes {
        get;
        set;
    }
    global List<Schema.PicklistEntry> PriceUoms {
        get;
        set;
    }
    global PricingMetadataDO() {

    }
    global PricingMetadataDO(List<Schema.PicklistEntry> chargeTypes, List<Schema.PicklistEntry> priceUoms, List<Schema.PicklistEntry> priceTypes, List<Schema.PicklistEntry> priceMethods, List<Schema.PicklistEntry> frequency) {

    }
}
global class ProductAttributeRuleDO {
    global List<Apttus_Config2__ProductAttributeRuleAction__c> ProductAttributeRuleActionSOs {
        get;
        set;
    }
    global Apttus_Config2__ProductAttributeRule__c ProductAttributeRuleSO {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroup__c> ProductGroupSOsInScope {
        get;
        set;
    }
    global List<Product2> ProductSOsInScope {
        get;
        set;
    }
    global ProductAttributeRuleDO() {

    }
    global ProductAttributeRuleDO(Apttus_Config2__ProductAttributeRule__c attributeRuleSO) {

    }
    global ProductAttributeRuleDO(Apttus_Config2__ProductAttributeRule__c attributeRuleSO, List<Apttus_Config2__ProductAttributeRuleAction__c> attributeRuleActionSOs) {

    }
}
global class ProductCloneDO {
    global Boolean AttributesFlag {
        get;
        set;
    }
    global Boolean AttributeValueMatricesFlag {
        get;
        set;
    }
    global Boolean CategoriesFlag {
        get;
        set;
    }
    global Boolean CollateralFlag {
        get;
        set;
    }
    global Boolean ConstraintRulesFlag {
        get;
        set;
    }
    global Boolean DetailsFlag {
        get;
        set;
    }
    global String ExternalID {
        get;
        set;
    }
    global String FieldSetName {
        get;
        set;
    }
    global Boolean OptionsFlag {
        get;
        set;
    }
    global Boolean PricingFlag {
        get;
        set;
    }
    global Boolean ProductAttributeRulesFlag {
        get;
        set;
    }
    global Boolean ProductGroupsFlag {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global String ProductName {
        get;
        set;
    }
    global Product2 ProductSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> RequiredUniqueFields {
        get;
        set;
    }
    global Boolean RulesFlag {
        get;
        set;
    }
    global String SObjectName {
        get;
        set;
    }
    global ProductCloneDO() {

    }
    global ProductCloneDO(Id productId, String productName, Boolean detailsFlag, Boolean categoriesFlag, Boolean attributesFlag, Boolean optionsFlag, Boolean pricingFlag, Boolean collateralFlag) {

    }
    global ProductCloneDO(Id productId, String productName, Boolean detailsFlag, Boolean categoriesFlag, Boolean attributesFlag, Boolean optionsFlag, Boolean pricingFlag, String externalId, Boolean collateralFlag) {

    }
}
global class ProductDO2 {
    global Id CategoryId {
        get;
        set;
    }
    global Product2 ProductSO {
        get;
        set;
    }
    global Integer Sequence {
        get;
        set;
    }
    global ProductDO2() {

    }
    global ProductDO2(Product2 productSO, Id categoryId) {

    }
}
global class ProductGraphRequestDO {
    global Id ProductId {
        get;
        set;
    }
    global ProductGraphRequestDO() {

    }
    global ProductGraphRequestDO(Id productId) {

    }
}
global class ProductGraphResponseDO {
    global List<Apttus_Config2.CPQAdminStruct2.EdgeDO> Edges {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.NodeDO> Nodes {
        get;
        set;
    }
    global String ProductGraphJSON {
        get;
        set;
    }
    global ProductGraphResponseDO() {

    }
    global ProductGraphResponseDO(List<Apttus_Config2.CPQAdminStruct2.NodeDO> nodes, List<Apttus_Config2.CPQAdminStruct2.EdgeDO> edges) {

    }
}
global class ProductGroupDO {
    global List<Apttus_Config2__AttributeValueMatrix__c> AttributeValueMatrixSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ConstraintRule__c> ConstraintRuleSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductAttributeRule__c> ProductAttributeRuleSOs {
        get;
        set;
    }
    global Id ProductGroupId {
        get;
        set;
    }
    global List<Id> ProductGroupMemberIds {
        get;
        set;
    }
    global List<Apttus_Config2__ProductGroupMember__c> ProductGroupMemberSOs {
        get;
        set;
    }
    global Apttus_Config2__ProductGroup__c ProductGroupSO {
        get;
        set;
    }
    global List<Id> ProductIds {
        get;
        set;
    }
    global List<Product2> ProductSOs {
        get;
        set;
    }
    global ProductGroupDO() {

    }
    global ProductGroupDO(Apttus_Config2__ProductGroup__c productGroupSO) {

    }
    global ProductGroupDO(Apttus_Config2__ProductGroup__c productGroupSO, List<Id> productIds) {

    }
    global ProductGroupDO(Apttus_Config2__ProductGroup__c productGroupSO, List<Product2> productSOs) {

    }
}
global class ProductInformationDO {
    global String FileName {
        get;
        set;
    }
    global Apttus_Config2__ProductInformation__c ProductInformationSO {
        get;
        set;
    }
    global ProductInformationDO() {

    }
    global ProductInformationDO(Apttus_Config2__ProductInformation__c productInformationSO, String fileName) {

    }
}
global class ProductOptionComponentDO {
    global Apttus_Config2__FieldExpression__c DefaultQuantityExpressionSO {
        get;
        set;
    }
    global Apttus_Config2__FieldExpression__c MaxQuantityExpressionSO {
        get;
        set;
    }
    global Apttus_Config2__FieldExpression__c MinQuantityExpressionSO {
        get;
        set;
    }
    global Apttus_Config2__ProductOptionComponent__c ProductOptionComponentSO {
        get;
        set;
    }
    global ProductOptionComponentDO() {

    }
    global ProductOptionComponentDO(Apttus_Config2__ProductOptionComponent__c pocSO) {

    }
}
global class ProductOptionGroupDO {
    global List<Apttus_Config2.CPQAdminStruct2.ProductOptionGroupDO> ChildOptionGroupDOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductOptionGroup__c> ChildProductOptionGroupSOs {
        get;
        set;
    }
    global List<Apttus_Config2__ProductOptionComponent__c> ComponentSOs {
        get;
        set;
    }
    global Apttus_Config2__FieldExpression__c MaxTotalQuantityExpressionSO {
        get;
        set;
    }
    global Apttus_Config2__FieldExpression__c MinTotalQuantityExpressionSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ProductOptionComponentDO> ProductOptionComponentDOs {
        get;
        set;
    }
    global Apttus_Config2__ProductOptionGroup__c ProductOptionGroupSO {
        get;
        set;
    }
    global ProductOptionGroupDO() {

    }
    global ProductOptionGroupDO(Apttus_Config2__ProductOptionGroup__c pogSO) {

    }
    global ProductOptionGroupDO(Apttus_Config2__ProductOptionGroup__c productOptionGroupSO, List<Apttus_Config2__ProductOptionComponent__c> components) {

    }
    global ProductOptionGroupDO(Apttus_Config2__ProductOptionGroup__c productOptionGroupSO, List<Apttus_Config2__ProductOptionComponent__c> components, List<Apttus_Config2.CPQAdminStruct2.ProductOptionGroupDO> childOptionGroupDOs) {

    }
}
global class ProductOptionPriceDO {
    global String OptionGroupName {
        get;
        set;
    }
    global Id PriceListId {
        get;
        set;
    }
    global Apttus_Config2__PriceListItem__c PriceListItemSO {
        get;
        set;
    }
    global Id ProductId {
        get;
        set;
    }
    global Apttus_Config2__ProductOptionPrice__c ProductOptionPriceSO {
        get;
        set;
    }
    global ProductOptionPriceDO() {

    }
    global ProductOptionPriceDO(Apttus_Config2__ProductOptionPrice__c productOptionPriceSO) {

    }
    global ProductOptionPriceDO(Apttus_Config2__ProductOptionPrice__c optionPriceSO, Apttus_Config2__PriceListItem__c pliSO, String optionGroupName) {

    }
}
global class ProductRecordDetailsDO {
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> DisplayFields {
        get;
        set;
    }
    global Boolean IsBundleMaintenanceNeeded {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.FieldDO> ProductFields {
        get;
        set;
    }
    global Product2 ProductSO {
        get;
        set;
    }
    global ProductRecordDetailsDO() {

    }
    global ProductRecordDetailsDO(List<Apttus_Config2.CPQAdminStruct2.FieldDO> productFields, List<Apttus_Config2.CPQAdminStruct2.FieldDO> displayFields) {

    }
}
global class ProductRequestDO2 {
    global List<Apttus_Config2__ProductClassification__c> ProductClassificationSOs {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.ProductDO2> ProductDOs {
        get;
        set;
    }
    global ProductRequestDO2() {

    }
}
global class SavedSearchDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.GetProductRequestDO ProductsRequestDO {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.GetProductResponseDO ProductsResponseDO {
        get;
        set;
    }
    global Id SavedSearchId {
        get;
        set;
    }
    global List<Id> SavedSearchIds {
        get;
        set;
    }
    global List<Apttus_Config2__SavedSearch__c> SavedSearchSOs {
        get;
        set;
    }
    global String SearchContext {
        get;
        set;
    }
    global SavedSearchDO() {

    }
    global SavedSearchDO(List<Apttus_Config2__SavedSearch__c> savedSearchSOs) {

    }
    global SavedSearchDO(List<Apttus_Config2__SavedSearch__c> savedSearchSOs, Integer numOfRecsInChunk) {

    }
}
global class SearchFilterDO {
    global String AdvOptions {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.Predicate> FilterCriteriaDO {
        get;
        set;
    }
    global Apttus_Config2__SearchFilter__c FilterSO {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.Predicate> InclusionCriteriaDO {
        get;
        set;
    }
    global SearchFilterDO() {

    }
}
global class SearchFilterPickListDO {
    global List<Apttus_Config2.CPQAdminStruct2.CartViewFieldDO> BusinessObjectDO {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminStruct2.CartViewFieldDO FilterType {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.CartViewFieldDO> ValueObjectDO {
        get;
        set;
    }
    global SearchFilterPickListDO(Apttus_Config2.CPQAdminStruct2.CartViewFieldDO filterType, List<Apttus_Config2.CPQAdminStruct2.CartViewFieldDO> businessObjectDO, List<Apttus_Config2.CPQAdminStruct2.CartViewFieldDO> valueObjectDO) {

    }
}
global class SearchFilterRequestDO {
    global Integer ChunkNumber {
        get;
        set;
    }
    global Integer NumberOfRecordsPerChunk {
        get;
        set;
    }
    global List<Id> SearchFilterIds {
        get;
        set;
    }
    global List<Apttus_Config2.CPQAdminStruct2.SearchRowDO> SearchRowDOs {
        get;
        set;
    }
    global String SearchString {
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
    global SearchFilterRequestDO() {

    }
    global SearchFilterRequestDO(String searchString) {

    }
}
global class SearchFilterResponseDO {
    global Integer NumberOfRecordsInChunk {
        get;
        set;
    }
    global Apttus_Config2__SearchFilter__c SearchFilterSO {
        get;
        set;
    }
    global List<Apttus_Config2__SearchFilter__c> SearchFilterSOs {
        get;
        set;
    }
    global SearchFilterResponseDO() {

    }
    global SearchFilterResponseDO(Apttus_Config2__SearchFilter__c searchFilterSO) {

    }
    global SearchFilterResponseDO(List<Apttus_Config2__SearchFilter__c> searchFilterSOs, Integer numOfRecords) {

    }
}
global class SearchRowDO {
    global String evalCriteria {
        get;
        set;
    }
    global String field {
        get;
        set;
    }
    global String function {
        get;
        set;
    }
    global String operator {
        get;
        set;
    }
    global Integer sequence {
        get;
        set;
    }
    global String value {
        get;
        set;
    }
    global SearchRowDO(String field, String function, String value, String operator) {

    }
}
global class sObjectTreeView {
    global String apiDisplayName;
    global String apiName;
    global List<Apttus_Config2.CPQAdminStruct2.sObjectTreeView> fields;
    global String fieldType;
    global Boolean isExtension;
    global Boolean isRef;
    global String label;
    global String refSObjectName;
    global String sObjectName;
    global sObjectTreeView() {

    }
}
}
