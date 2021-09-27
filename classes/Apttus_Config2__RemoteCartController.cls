/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RemoteCartController {
    global RemoteCartController(ApexPages.StandardController stdController) {

    }
    @RemoteAction
    global static Decimal doClonePrimaryItemColl(Id configId, Decimal lineNumber) {
        return null;
    }
    @RemoteAction
    global static Boolean doComputeBasePriceForItemColl(Id configId, Decimal lineNumber) {
        return null;
    }
    @RemoteAction
    global static Boolean doComputeBasePriceForNextItemColl(Id configId) {
        return null;
    }
    @RemoteAction
    global static Boolean doComputeNetPriceForItemColl(Id configId, Decimal lineNumber) {
        return null;
    }
    @RemoteAction
    global static Boolean doComputeTotalPriceForCart(Id configId) {
        return null;
    }
    @RemoteAction
    global static Boolean doExecuteTotalPriceStepForCart(Id configId, String stepName) {
        return null;
    }
    @RemoteAction
    global static Apttus_Config2.RemoteCartController.PricePendingInfo doGetPricePendingInfo(Id configId) {
        return null;
    }
    @RemoteAction
    global static Apttus_Config2.CPQStruct.PricePendingInfo doUpdatePriceForCart(Id configId) {
        return null;
    }
    @RemoteAction
    global static Apttus_Config2.CPQStruct.PricePendingInfo doUpdatePriceWithBundle(Id configId, Integer contextBundleNumber) {
        return null;
    }
    global String getClassName() {
        return null;
    }
    @RemoteAction
    global static Apttus_Config2__LineItem__c getLineItemDetail(Id lineItemId) {
        return null;
    }
    @RemoteAction
    global static Product2 getProductDescription(Id productId) {
        return null;
    }
global class PricePendingInfo {
    global PricePendingInfo() {

    }
}
}
