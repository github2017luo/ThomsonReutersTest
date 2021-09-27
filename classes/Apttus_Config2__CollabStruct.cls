/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CollabStruct {
    global CollabStruct() {

    }
global class AddProductCRRequestDO {
    global Id collaborationRequestId {
        get;
        set;
    }
    global List<Id> lineItemIds {
        get;
        set;
    }
    global AddProductCRRequestDO() {

    }
}
global class AddProductCRResponseDO {
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean hasErrors {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global AddProductCRResponseDO() {

    }
}
global class CreateCRRequestDO {
    global Apttus_Config2__CollaborationRequest__c collaborationRequestSO {
        get;
        set;
    }
    global Id parentConfigId {
        get;
        set;
    }
    global List<Id> parentLineItemIds {
        get;
        set;
    }
    global CreateCRRequestDO() {

    }
}
global class CreateCRResponseDO {
    global Apttus_Config2__CollaborationRequest__c collaborationRequestSO {
        get;
        set;
    }
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean hasErrors {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global CreateCRResponseDO() {

    }
}
global class GetCRRequestDO {
    global Id collaborationRequestID {
        get;
        set;
    }
    global Id configId {
        get;
        set;
    }
    global GetCRRequestDO() {

    }
}
global class GetCRResponseDO {
    global List<Apttus_Config2__CollaborationRequest__c> collaborationRequestSOs {
        get;
        set;
    }
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean hasErrors {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global GetCRResponseDO() {

    }
}
global class MergeCRRequestDO {
    global Id collaborationRequestID {
        get;
        set;
    }
    global MergeCRRequestDO() {

    }
}
global class MergeCRResponseDO {
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean hasErrors {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global MergeCRResponseDO() {

    }
}
global class SubmitForMergeRequestDO {
    global Id collaborationRequestID {
        get;
        set;
    }
    global SubmitForMergeRequestDO() {

    }
}
global class SubmitForMergeResponseDO {
    global Apttus_Config2__CollaborationRequest__c collaborationRequestSO {
        get;
        set;
    }
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean hasErrors {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global SubmitForMergeResponseDO() {

    }
}
global class UpdateCRRequestDO {
    global Apttus_Config2__CollaborationRequest__c collaborationRequestSO {
        get;
        set;
    }
    global UpdateCRRequestDO() {

    }
}
global class UpdateCRResponseDO {
    global Apttus_Config2__CollaborationRequest__c collaborationRequestSO {
        get;
        set;
    }
    global List<String> errorMessages {
        get;
        set;
    }
    global Boolean hasErrors {
        get;
        set;
    }
    global Boolean isSuccess {
        get;
        set;
    }
    global UpdateCRResponseDO() {

    }
}
}
