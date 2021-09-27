/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class CPQAsset {
    global CPQAsset() {

    }
global abstract class ABOActionRequestDO {
    webService List<Id> AssetIds {
        get;
        set;
    }
    webService Id CartId {
        get;
        set;
    }
    global ABOActionRequestDO() {

    }
}
global abstract class ABOActionResponseDO extends Apttus_CPQApi.CPQAsset.APIResponseDO {
    webService List<Apttus_CPQApi.CPQAsset.LineItemEntryDO> LineItemMap {
        get;
    }
}
global abstract class APIResponseDO {
    webService List<String> Errors {
        get;
    }
}
global class CancelAssetsRequestDO extends Apttus_CPQApi.CPQAsset.ABOActionRequestDO {
    webService Date CancelDate {
        get;
        set;
    }
    global CancelAssetsRequestDO() {

    }
}
global class CancelAssetsResponseDO extends Apttus_CPQApi.CPQAsset.ABOActionResponseDO {
}
global class ChangeAssetsRequestDO extends Apttus_CPQApi.CPQAsset.ABOActionRequestDO {
    global ChangeAssetsRequestDO() {

    }
}
global class ChangeAssetsResponseDO extends Apttus_CPQApi.CPQAsset.ABOActionResponseDO {
}
global class LineItemEntryDO {
    webService Id LineItemId {
        get;
    }
    webService Apttus_Config2__LineItem__c LineItemSO {
        get;
    }
}
global class QueryAssetsRequestDO {
    webService List<Id> AccountIds {
        get;
        set;
    }
    webService String CustomFilter {
        get;
        set;
    }
    webService Boolean Descending {
        get;
        set;
    }
    webService List<String> FieldNames {
        get;
        set;
    }
    webService Integer Nrecord {
        get;
        set;
    }
    webService Integer Offset {
        get;
        set;
    }
    webService List<String> SortFields {
        get;
        set;
    }
    global QueryAssetsRequestDO() {

    }
}
global class QueryAssetsResponseDO extends Apttus_CPQApi.CPQAsset.APIResponseDO {
    webService Integer AssetCount {
        get;
    }
    webService List<Apttus_Config2__AssetLineItem__c> AssetLineItems {
        get;
    }
}
global class RecommendationRequestDO {
    webService Id CartId {
        get;
        set;
    }
    webService List<Id> ProductIds {
        get;
        set;
    }
    global RecommendationRequestDO() {

    }
}
global class RecommendationResponseDO extends Apttus_CPQApi.CPQAsset.APIResponseDO {
    webService List<Id> ProductIds {
        get;
    }
}
global class RenewAssetsRequestDO extends Apttus_CPQApi.CPQAsset.ABOActionRequestDO {
    webService Boolean FarthestAssetEndDate {
        get;
        set;
    }
    webService Date RenewEndDate {
        get;
        set;
    }
    webService Decimal RenewTerm {
        get;
        set;
    }
    global RenewAssetsRequestDO() {

    }
}
global class RenewAssetsResponseDO extends Apttus_CPQApi.CPQAsset.ABOActionResponseDO {
}
global class SwapAssetsRequestDO extends Apttus_CPQApi.CPQAsset.ABOActionRequestDO {
    webService Date NewStartDate {
        get;
        set;
    }
    webService List<Id> ProductIds {
        get;
        set;
    }
    global SwapAssetsRequestDO() {

    }
}
global class SwapAssetsResponseDO extends Apttus_CPQApi.CPQAsset.ABOActionResponseDO {
}
}
