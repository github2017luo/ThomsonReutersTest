/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ffasync_ProcessService {
    global static void addProcess(fferpcore.ffasync_ProcessService.ProcessExecutionContext ctxt, fferpcore.ffasync_Process process) {

    }
    global static void hasProcessCompleted(Id processRunId, fferpcore.ffasync_ProcessService.ICallback callBack) {

    }
    global static Id startChainedProcesses(fferpcore.ffasync_ChainedProcess cProcess) {
        return null;
    }
    global static Id startProcess(fferpcore.ffasync_Process process) {
        return null;
    }
global class AddProcess implements fferpcore.ffasync_IAction {
    global AddProcess(fferpcore.ffasync_Process process) {

    }
}
global interface ICallback {
    void run(Object param0);
}
global interface IProcessResult {
    String getDescription();
    Integer getErrorCount();
    Integer getPendingCount();
    Id getProcessRunId();
    Integer getSuccessCount();
    Integer getTotalCount();
    List<fferpcore__ProcessUserGroup__c> getUserGroups();
    Boolean useDetailedMonitoring();
}
global class NotificationData {
    global NotificationData(Set<Id> recipientUserIds) {

    }
    global NotificationData(Set<Id> recipientUserIds, String appName) {

    }
    global String getAppName() {
        return null;
    }
    global Set<Id> getRecipientUserIds() {
        return null;
    }
}
global class ProcessExecutionContext {
    global Id getParentRunId() {
        return null;
    }
    @Deprecated
    global List<Id> getRecordIds() {
        return null;
    }
    global Id getRunId() {
        return null;
    }
}
global class ProcessResponse {
    global ProcessResponse() {

    }
    global ProcessResponse(List<fferpcore.ffasync_ProcessService.RecordStatus> recordStatuses) {

    }
}
global class RecordStatus {
    global RecordStatus(Id recordId, Boolean isSuccessful) {

    }
    global RecordStatus(Id recordId, Boolean isSuccessful, Id relatedRecordId, String message) {

    }
}
}
