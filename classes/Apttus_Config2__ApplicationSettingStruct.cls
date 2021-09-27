/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ApplicationSettingStruct {
    global ApplicationSettingStruct() {

    }
global class ApplicationFeatureDO {
    global Apttus_Config2__ApplicationFeature__c ApplicationFeatureSO;
    global List<Apttus_Config2.ApplicationSettingStruct.SettingGroupDO> SettingGroupDOs;
    global ApplicationFeatureDO() {

    }
}
global class ApplicationSettingDO {
    global String action;
    global Apttus_Config2__ApplicationSetting__c ApplicationSettingSO;
    global Map<String,String> availableOptionValues;
    global List<Apttus_Config2.FieldMetadata> FieldMetadata;
    global List<String> FieldNames;
    global Map<String,String> selectedOptionValues;
    global List<Object> SettingList;
    global String SettingListJSON;
    global ApplicationSettingDO() {

    }
    global ApplicationSettingDO(Apttus_Config2__ApplicationSetting__c appSettingSO) {

    }
}
global class ApplicationSettingsByGroupsRequestDO {
    global List<Id> SettingGroupIdList {
        get;
        set;
    }
    global ApplicationSettingsByGroupsRequestDO() {

    }
}
global class ApplicationSettingsByGroupsResponseDO {
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global List<Apttus_Config2.ApplicationSettingStruct.SettingGroupDO> SettingGroupList {
        get;
        set;
    }
    global ApplicationSettingsByGroupsResponseDO() {

    }
}
global class ApplicationSettingsRequestDO {
    global String ApplicationName {
        get;
        set;
    }
    global ApplicationSettingsRequestDO() {

    }
}
global class ApplicationSettingsResponseDO {
    global List<Apttus_Config2.ApplicationSettingStruct.ApplicationFeatureDO> ApplicationFeatureDOs {
        get;
        set;
    }
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global ApplicationSettingsResponseDO() {

    }
}
global class CreateSettingGroupRequestDO {
    global List<Apttus_Config2.ApplicationSettingStruct.ApplicationSettingDO> ApplicationSettingList {
        get;
        set;
    }
    global Id ExistingSettingGroupId {
        get;
        set;
    }
    global Apttus_Config2__SettingGroup__c SettingGroupSO {
        get;
        set;
    }
    global CreateSettingGroupRequestDO() {

    }
}
global class CreateSettingGroupResponseDO {
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global Id SettingGroupId {
        get;
        set;
    }
    global CreateSettingGroupResponseDO() {

    }
}
global class DeleteSettingGroupRequestDO {
    global List<Id> SettingGroupIDList {
        get;
        set;
    }
    global DeleteSettingGroupRequestDO() {

    }
}
global class FlowDO {
    global Id ExistingFlowId {
        get;
        set;
    }
    global Apttus_Config2__ConfigFlow__c FlowSO {
        get;
        set;
    }
    global FlowDO() {

    }
}
global class ResponseDO {
    global String ExceptionMsg {
        get;
        set;
    }
    global Boolean IsSuccess {
        get;
        set;
    }
    global ResponseDO() {

    }
}
global class SettingGroupDO {
    global List<Apttus_Config2.ApplicationSettingStruct.ApplicationSettingDO> ApplicationSettingDOs;
    global Apttus_Config2__SettingGroup__c SettingGroupSO;
    global SettingGroupDO() {

    }
    global SettingGroupDO(Apttus_Config2__SettingGroup__c settingGroupSO) {

    }
}
global class UpdateApplicationSettingsGroupsRequestDO {
    global List<Apttus_Config2.ApplicationSettingStruct.SettingGroupDO> SettingGroupList {
        get;
        set;
    }
    global UpdateApplicationSettingsGroupsRequestDO() {

    }
}
global class UpdateSettingGroupRequestDO {
    global List<Apttus_Config2.ApplicationSettingStruct.ApplicationSettingDO> ApplicationSettingList {
        get;
        set;
    }
    global Apttus_Config2__SettingGroup__c SettingGroupSO {
        get;
        set;
    }
    global UpdateSettingGroupRequestDO() {

    }
}
}
