/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ffasync_Process {
    global ffasync_Process() {

    }
    global virtual String getDescription() {
        return null;
    }
    global virtual List<fferpcore.ffasync_IAction> getEndOfProcessActions() {
        return null;
    }
    global virtual fferpcore.ffasync_Process.LoggingRequirement getLoggingRequirement() {
        return null;
    }
    global abstract Database.QueryLocator getQueryLocator();
    global virtual Integer getScopeSize() {
        return null;
    }
    global abstract fferpcore.ffasync_Process.Step getStep();
global virtual class LoggingRequirement {
    global LoggingRequirement() {

    }
    global LoggingRequirement(fferpcore.ffasync_Process.MonitoringType monitoringType, Schema.SObjectField userField) {

    }
    global virtual fferpcore.ffasync_Process.MonitoringType getMonitoringType() {
        return null;
    }
    global virtual Schema.SObjectField getUserField() {
        return null;
    }
}
global enum MonitoringType {DETAILED, SIMPLE}
global abstract class Step {
    global Step() {

    }
    global virtual Boolean canRunParallel() {
        return null;
    }
    global virtual List<Schema.SObjectField> getExecutionGroupingFields() {
        return null;
    }
    global abstract fferpcore.ffasync_ProcessService.ProcessResponse run(fferpcore.ffasync_ProcessService.ProcessExecutionContext param0, List<Id> param1);
}
}
