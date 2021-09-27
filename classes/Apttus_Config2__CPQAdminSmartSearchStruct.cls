/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CPQAdminSmartSearchStruct {
    global CPQAdminSmartSearchStruct() {

    }
global class DisplayColumnsRequestDO {
    global String ApiUserKey {
        get;
        set;
    }
    global List<Apttus_Config2__ConfigSmartSearchSettings__c> DisplayColumns {
        get;
        set;
    }
    global String EnhancedSearchUrl {
        get;
        set;
    }
    global String Flow {
        get;
        set;
    }
    global DisplayColumnsRequestDO() {

    }
}
global class DisplayColumnsResponseDO {
    global String ApiUserKey {
        get;
        set;
    }
    global List<Apttus_Config2__ConfigSmartSearchSettings__c> DisplayColumns {
        get;
        set;
    }
    global String EnhancedSearchUrl {
        get;
        set;
    }
    global String Flow {
        get;
        set;
    }
    global DisplayColumnsResponseDO() {

    }
}
global class GetDisplayColumnsRequestDO {
    global String Flow {
        get;
        set;
    }
    global GetDisplayColumnsRequestDO() {

    }
}
global class GetDisplayColumnsResponseDO {
    global String ApiUserKey {
        get;
        set;
    }
    global List<Apttus_Config2__ConfigSmartSearchSettings__c> DisplayColumns {
        get;
        set;
    }
    global String EnhancedSearchUrl {
        get;
        set;
    }
    global List<String> FlowItems {
        get;
        set;
    }
    global List<String> ProductFieldNames {
        get;
        set;
    }
    global Apttus_Config2.CPQAdminSmartSearchStruct.SyncStatusDO SyncStatus {
        get;
        set;
    }
    global String UrlFieldHelpText {
        get;
        set;
    }
    global GetDisplayColumnsResponseDO() {

    }
    global GetDisplayColumnsResponseDO(List<Apttus_Config2__ConfigSmartSearchSettings__c> displayColumns) {

    }
}
global class SyncRequestDO {
    global SyncRequestDO() {

    }
}
global class SyncResponseDO {
    global Apttus_Config2.CPQAdminSmartSearchStruct.SyncStatusDO SyncStatus {
        get;
        set;
    }
    global SyncResponseDO() {

    }
}
global class SyncStatusDO {
    global String Action {
        get;
        set;
    }
    global Boolean IsActivateDisabled {
        get;
        set;
    }
    global Boolean IsDeactivateDisabled {
        get;
        set;
    }
    global Boolean IsResyncDisabled {
        get;
        set;
    }
    global Boolean IsSmartSearchActived {
        get;
        set;
    }
    global String LastAttemptedSync {
        get;
        set;
    }
    global String LastSuccessfulSync {
        get;
        set;
    }
    global String Message {
        get;
        set;
    }
    global String StatusCode {
        get;
        set;
    }
    global SyncStatusDO() {

    }
}
}
