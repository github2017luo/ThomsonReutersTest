/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AeServiceResponse {
    @WebService
    webService icrt.AeServiceResponse.AeErrorInfo errorInfo;
    @WebService
    webService icrt.AeServiceResponse.AeOnRollback onRollback;
    @WebService
    webService List<icrt.AeServiceResponse.AeServiceParameter> parameter;
    global AeServiceResponse() {

    }
    global void addErrorInfo(String aMessage) {

    }
    global icrt.AeServiceResponse.AeServiceParameter addParameter(String aName, Date aValue) {
        return null;
    }
    global icrt.AeServiceResponse.AeServiceParameter addParameter(String aName, Time aValue) {
        return null;
    }
    global icrt.AeServiceResponse.AeServiceParameter addParameter(String aName, Boolean aValue) {
        return null;
    }
    global icrt.AeServiceResponse.AeServiceParameter addParameter(String aName, Double aValue) {
        return null;
    }
    global icrt.AeServiceResponse.AeServiceParameter addParameter(String aName, Integer aValue) {
        return null;
    }
    global icrt.AeServiceResponse.AeServiceParameter addParameter(String aName, String aValue) {
        return null;
    }
    global icrt.AeServiceResponse.AeServiceParameter addParameter(String aName, Decimal aValue) {
        return null;
    }
    global icrt.AeServiceResponse.AeServiceParameter addParameter(String aName, Datetime aValue) {
        return null;
    }
    global static icrt.AeServiceResponse.AeInvalidData createInvalidData(String aName, String aReason) {
        return null;
    }
    global static icrt.AeServiceResponse.AeOnRollback createOnRollback(String aServiceName) {
        return null;
    }
    global static icrt.AeServiceResponse.AeServiceParameter createParameter(String aName, String aValue) {
        return null;
    }
global class AeErrorInfo {
    @WebService
    webService String errorMessage;
    @WebService
    webService List<icrt.AeServiceResponse.AeInvalidData> invalidData;
    global AeErrorInfo() {

    }
    global icrt.AeServiceResponse.AeInvalidData addInvalidData(String aName, String aReason) {
        return null;
    }
}
global class AeInvalidData {
    @WebService
    webService String errorReason;
    @WebService
    webService String parameterName;
    global AeInvalidData() {

    }
}
global class AeOnRollback {
    @WebService
    webService List<icrt.AeServiceResponse.AeServiceParameter> parameter;
    @WebService
    webService String runAsUser;
    @WebService
    webService String serviceName;
    global AeOnRollback() {

    }
    global void addParameter(String aName, String aValue) {

    }
}
global class AeServiceParameter {
    @WebService
    webService String name;
    @WebService
    webService String value;
    global AeServiceParameter() {

    }
}
}
