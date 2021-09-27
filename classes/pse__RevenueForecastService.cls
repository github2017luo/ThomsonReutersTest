/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RevenueForecastService {
    global static pse.RevenueForecastService.RunForOpportunitiesAsyncResponse runForOpportunitiesAsync(pse.RevenueForecastService.RunForOpportunitiesAsyncRequest request) {
        return null;
    }
    global static pse.RevenueForecastService.RunForProjectsAsyncResponse runForProjectsAsync(pse.RevenueForecastService.RunForProjectsAsyncRequest request) {
        return null;
    }
global class RunForOpportunitiesAsyncRequest {
    global Set<Id> OpportunityIds {
        get;
        set;
    }
    global RunForOpportunitiesAsyncRequest() {

    }
    global RunForOpportunitiesAsyncRequest(Set<Id> opportunityIds) {

    }
}
global class RunForOpportunitiesAsyncResponse {
    global Map<Id,List<String>> ErrorsByOpportunityId {
        get;
        set;
    }
    global Boolean IsUsingUnsupportedRevManVersion {
        get;
        set;
    }
    global RunForOpportunitiesAsyncResponse() {

    }
    global Map<Id,List<String>> getAllErrorsByOpportunityId() {
        return null;
    }
    global List<String> getErrors(Id opportunityId) {
        return null;
    }
    global Boolean getSuccess(Id opportunityId) {
        return null;
    }
}
global class RunForProjectsAsyncRequest {
    global Set<Id> ProjectIds {
        get;
        set;
    }
    global RunForProjectsAsyncRequest() {

    }
    global RunForProjectsAsyncRequest(Set<Id> projectIds) {

    }
}
global class RunForProjectsAsyncResponse {
    global Map<Id,List<String>> ErrorsByProjectId {
        get;
        set;
    }
    global Boolean IsUsingUnsupportedRevManVersion {
        get;
        set;
    }
    global RunForProjectsAsyncResponse() {

    }
    global RunForProjectsAsyncResponse(Map<Id,List<String>> errorsByProjectId, Boolean usingUnsupportedRevManVersion) {

    }
    global Map<Id,List<String>> getAllErrorsByProjectId() {
        return null;
    }
    global List<String> getErrors(Id projectId) {
        return null;
    }
    global Boolean getSuccess(Id projectId) {
        return null;
    }
}
}
