/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ConstraintWebService2 {
    global ConstraintWebService2() {

    }
    global static void applyConstraintRules(Id cartId, Boolean checkOnFinalization) {

    }
    webService static Apttus_Config2.ConstraintWebService2.ConstraintResult2 applyConstraintRulesOnAddAll(Id cartId) {
        return null;
    }
    webService static Apttus_Config2.ConstraintWebService2.ConstraintResult2 applyConstraintRulesOnAddBundle(Id cartId, Decimal lineNumber) {
        return null;
    }
    global static void applyConstraintRulesOnDelete(Id cartId, List<Id> deletedProductIds) {

    }
    webService static Boolean associateConstraintRulesForProducts(Id cartId, List<Id> productIds) {
        return null;
    }
    global static void associateConstraintRules(Id cartId, Set<Integer> existingPrimaryNumbers) {

    }
    webService static List<List<Id>> getAutoIncludedProductIdsForCart(Id cartId) {
        return null;
    }
global class ConstraintResult2 {
    webService Boolean IsSuccess {
        get;
    }
}
}
