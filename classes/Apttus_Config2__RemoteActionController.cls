/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RemoteActionController {
    global RemoteActionController(ApexPages.StandardController stdController) {

    }
    @RemoteAction
    global static Boolean applyOptionInclusionCriteria(Id configId, Id lineItemId) {
        return null;
    }
    @RemoteAction
    global static List<Id> getExcludedProductIds(Id configId, List<Id> contextProductIds) {
        return null;
    }
    @RemoteAction
    global static String getInclusionCriteriaExpr(String filterName) {
        return null;
    }
    @RemoteAction
    global static List<Integer> getLineNumbersAwaitingPrice(Id configId) {
        return null;
    }
    @RemoteAction
    global static System.PageReference getPricingPage(Id configId, Id requestId) {
        return null;
    }
    @RemoteAction
    global static Product2 getProductDescription(Id productId) {
        return null;
    }
    @RemoteAction
    global static List<Apttus_Config2.RemoteActionController.ProductInfo> getRecommendedProducts2(List<Id> SelectedProducts) {
        return null;
    }
    @RemoteAction
    global static List<Product2> getRecommendedProducts(List<Id> SelectedProducts) {
        return null;
    }
    @RemoteAction
    global static void saveSelectedComparision(Id selectedId) {

    }
    @RemoteAction
    global static Boolean toggleExpressionLock(String configId, Integer primaryLineNumber, Id fieldExpressionSOId) {
        return null;
    }
global class ProductInfo {
}
}
