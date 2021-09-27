/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CPQAdminStruct {
    global CPQAdminStruct() {

    }
global class CategoryDO {
    webService Apttus_Config2__ClassificationName__c CategorySO {
        get;
        set;
    }
    webService Id HierarchyId {
        get;
        set;
    }
    webService String Label {
        get;
        set;
    }
    webService String Name {
        get;
        set;
    }
    webService List<Apttus_Config2.CPQAdminStruct.MapDO> OptionalFields {
        get;
        set;
    }
    webService String Type {
        get;
        set;
    }
    global CategoryDO() {

    }
}
global class CategoryRequestDO {
    webService List<Apttus_Config2.CPQAdminStruct.CategoryDO> CategoryDOs {
        get;
        set;
    }
    webService Apttus_Config2__ClassificationHierarchy__c CategoryHierarchySO {
        get;
        set;
    }
    global CategoryRequestDO() {

    }
}
global class CategoryResponseDO {
    webService List<Apttus_Config2.CPQAdminStruct.CategoryDO> CategoryDOs {
        get;
        set;
    }
    webService List<Apttus_Config2.CPQAdminStruct.MapDO> CategoryResponseMap {
        get;
        set;
    }
    global CategoryResponseDO() {

    }
}
global class HierarchyDO {
    webService Id ChildOptionGroupId {
        get;
        set;
    }
    webService Id ChildProductId {
        get;
        set;
    }
    webService Id ParentOptionGroupId {
        get;
        set;
    }
    webService Id ParentProductId {
        get;
        set;
    }
    global HierarchyDO() {

    }
}
global class HierarchyRequestDO {
    webService List<Apttus_Config2.CPQAdminStruct.HierarchyDO> HierarchyDOs {
        get;
        set;
    }
    webService Boolean isCascadeGroupChanges {
        get;
        set;
    }
    webService Id OptionGroupId {
        get;
        set;
    }
    webService List<Id> OptionGroupIds {
        get;
        set;
    }
    webService Id ProductId {
        get;
        set;
    }
    webService List<Id> ProductIds {
        get;
        set;
    }
    global HierarchyRequestDO() {

    }
}
global class HierarchyResponseDO {
    webService Apttus_Config2.CPQAdminStruct2.GetOptionGroupResponseDO OptionGroupDOs {
        get;
        set;
    }
    webService List<Id> OptionGroupIds {
        get;
        set;
    }
    webService Apttus_Config2.CPQAdminStruct2.ProductOptionGroupDO ProductOptionGroupDO {
        get;
        set;
    }
    webService List<Apttus_Config2.CPQAdminStruct.MapDO> ProductStructureJSONs {
        get;
        set;
    }
    webService Boolean Success {
        get;
        set;
    }
    global HierarchyResponseDO() {

    }
}
global class MapDO {
    webService String Key {
        get;
        set;
    }
    webService String Value {
        get;
        set;
    }
    global MapDO() {

    }
    global MapDO(String key, String value) {

    }
}
global class ProductAttributeDO {
    webService Boolean Action {
        get;
        set;
    }
    webService Id AttributeGroupId {
        get;
        set;
    }
    webService String AttributeGroupName {
        get;
        set;
    }
    webService List<String> ProductAttributesToAdd {
        get;
        set;
    }
    webService List<String> ProductAttributesToRemove {
        get;
        set;
    }
    webService Id ProductId {
        get;
        set;
    }
    global ProductAttributeDO() {

    }
}
global class ProductAttributeRequestDO {
    webService List<Apttus_Config2.CPQAdminStruct.ProductAttributeDO> ProductAttributeDOs {
        get;
        set;
    }
    webService List<Apttus_Config2__ProductAttributeGroupMember__c> ProductAttributeGroupMemberSOs {
        get;
        set;
    }
    global ProductAttributeRequestDO() {

    }
}
global class ProductAttributeResponseDO {
    webService List<Apttus_Config2__ProductAttributeGroupMember__c> ProductAttributeGroupMemberSOs {
        get;
        set;
    }
    webService List<Apttus_Config2.CPQAdminStruct.MapDO> ProductAttributeGroupResponseMap {
        get;
        set;
    }
    webService Boolean Success {
        get;
        set;
    }
    global ProductAttributeResponseDO() {

    }
}
global class ProductDO {
    webService Id CategoryId {
        get;
        set;
    }
    webService String ConfigType {
        get;
        set;
    }
    webService Boolean IsActive {
        get;
        set;
    }
    webService String Name {
        get;
        set;
    }
    webService List<Apttus_Config2.CPQAdminStruct.MapDO> OptionalFields {
        get;
        set;
    }
    webService Id ProductId {
        get;
        set;
    }
    global ProductDO() {

    }
}
global class ProductRequestDO {
    webService List<Apttus_Config2.CPQAdminStruct.ProductDO> ProductDOs {
        get;
        set;
    }
    global ProductRequestDO() {

    }
}
global class ProductResponseDO {
    webService List<Apttus_Config2.CPQAdminStruct.MapDO> ProductStructureJSON {
        get;
        set;
    }
    global ProductResponseDO() {

    }
}
}
