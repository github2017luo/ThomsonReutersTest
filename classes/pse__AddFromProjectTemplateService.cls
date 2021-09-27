/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AddFromProjectTemplateService {
    global static List<pse.AddFromProjectTemplateService.AddFromProjectResponse> addFromTemplates(List<pse.AddFromProjectTemplateService.AddFromProjectRequest> requests) {
        return null;
    }
    global static List<pse.AddFromProjectTemplateService.AddFromProjectResponse> addTasksFromTemplates(List<pse.AddFromProjectTemplateService.ProjectTaskRequest> requests) {
        return null;
    }
global class AddFromProjectError {
    global String Message;
}
global abstract class AddFromProjectRequest {
    global Id DestinationProjectId;
    global List<pse.SObjectCloneMapper> Mappers;
    global Date StartDate;
    global Id TemplateProjectId;
}
global class AddFromProjectResponse {
    global List<pse.AddFromProjectTemplateService.AddFromProjectError> Errors;
    global Id QueuedJobId;
    global pse.AddFromProjectTemplateService.AddFromProjectRequest Request;
    global Boolean isSuccess() {
        return null;
    }
}
global class MilestoneRequest extends pse.AddFromProjectTemplateService.AddFromProjectRequest {
    global Boolean CopyRisks;
    global MilestoneRequest(Id templateProjectId, Id destinationProjectId) {

    }
}
global class ProjectTaskRequest extends pse.AddFromProjectTemplateService.AddFromProjectRequest {
    global Boolean CopyMilestones;
    global Boolean CopyProjectTaskAssignments;
    global Date EndDate;
    global ProjectTaskRequest(Id templateProjectId, Id destinationProjectId) {

    }
}
global class ResourceRequestToProjectRequest extends pse.AddFromProjectTemplateService.AddFromProjectRequest {
    global Boolean CopyResourceSkillRequests;
    global ResourceRequestToProjectRequest(Id templateProjectId, Id destinationProjectId) {

    }
}
}
