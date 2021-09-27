/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AeServiceRequest {
    @WebService
    webService String authToken;
    @WebService
    webService String objectId;
    @WebService
    webService String objectType;
    @WebService
    webService List<icrt.AeServiceRequest.AeServiceParameter> parameter;
    global AeServiceRequest() {

    }
    global icrt.AeServiceRequest.AeServiceParameter addParameter(String aName, String aValue) {
        return null;
    }
    global icrt.AeServiceResponse.AeErrorInfo checkRequiredFilled(Map<String,Object> aInput, List<icrt.AeServiceDescription.AeServiceParameterDesc> aInputDesc) {
        return null;
    }
    global static icrt.AeServiceRequest.AeServiceParameter createParameter(String aName, String aValue) {
        return null;
    }
    global Map<String,String> getParameterMap() {
        return null;
    }
    global Map<String,Object> getTypedParameterMap(Map<String,icrt.AeServiceDescription.AeServiceParameterDesc> aTypeMap) {
        return null;
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
