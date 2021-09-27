/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CatalogService {
    global CatalogService() {

    }
    global static ApexPages.StandardSetController queryAssetsWithText(Id accountId, Set<Id> locationIds, String searchText, List<String> fieldNames, List<String> assetSearchScope, String staticFilter, String orderByFieldExpr) {
        return null;
    }
    global static ApexPages.StandardSetController queryProductsWithCategoryAndText(Apttus_Config2__ProductConfiguration__c configSO, List<Id> categoryIds, String searchText, List<String> fieldNames, List<String> productSearchScope, String staticFilter, String orderByFieldExpr) {
        return null;
    }
    global static ApexPages.StandardSetController queryProductsWithCategory(Apttus_Config2__ProductConfiguration__c configSO, List<Id> categoryIds, List<String> fieldNames, String staticFilter, String orderByFieldExpr) {
        return null;
    }
    global static ApexPages.StandardSetController queryProductsWithText(Apttus_Config2__ProductConfiguration__c configSO, String categoryName, String searchText, List<String> fieldNames, List<String> productSearchScope, String staticFilter, String orderByFieldExpr) {
        return null;
    }
    global static void rebuildCategoryHierachies(Set<Id> hierarchyIds) {

    }
}
