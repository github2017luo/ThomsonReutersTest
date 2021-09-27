/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RevenueForecastVersionService {
    global static pse.RevenueForecastVersionService.CreateAsyncResponse createAsync(pse.RevenueForecastVersionService.CreateAsyncRequest request) {
        return null;
    }
global class CreateAsyncRequest {
    global CreateAsyncRequest() {

    }
}
global class CreateAsyncResponse {
    global List<pse.RevenueForecastVersionService.JobInfo> JobInfos {
        get;
        set;
    }
    global CreateAsyncResponse() {

    }
}
global class JobInfo {
    global Id ApexJobId {
        get;
        set;
    }
    global Id RevenueForecastVersionId {
        get;
        set;
    }
    global JobInfo() {

    }
}
}
