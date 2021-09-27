/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ScheduleService {
    global ScheduleService() {

    }
    global static Map<Id,pse.ScheduleService.HoursDetail> getScheduledHoursForDates(Set<Id> scheduleIds, Date startDate, Date endDate) {
        return null;
    }
    global static List<pse.ScheduleService.UpdateScheduleResponse> updateSchedules(List<pse.ScheduleService.UpdateScheduleRequest> requests) {
        return null;
    }
global class HoursDetail {
    global Map<Date,Decimal> dateToHours;
    global Date scheduleEnd;
    global Date scheduleStart;
    global HoursDetail() {

    }
}
global class UpdateScheduleRequest {
    global Map<Date,Decimal> Hours;
    global Id ScheduleId;
    global UpdateScheduleRequest() {

    }
}
global class UpdateScheduleResponse {
    global List<String> Errors;
    global Id ScheduleId;
    global Boolean Success;
}
}
