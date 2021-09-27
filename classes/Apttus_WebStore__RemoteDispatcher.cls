/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/dc/*')
global class RemoteDispatcher {
    global RemoteDispatcher() {

    }
    global static Apttus_WebStore.RemoteDispatcher.DispatchResponse handlePost(String d) {
        return null;
    }
    @HttpPost
    global static String onPost(String d) {
        return null;
    }
    @RemoteAction
    global static String onRemotePost(String d) {
        return null;
    }
global interface DispatchFilter {
    String queryFilter();
    String validateQuery(String param0);
    String validateResponse(List<SObject> param0);
}
global interface DispatchInterface {
    Apttus_WebStore.RemoteDispatcher.DispatchResponse dispatch(String param0, Object param1);
}
global class DispatchResponse {
    global String data {
        get;
        set;
    }
    global Boolean success {
        get;
        set;
    }
    global DispatchResponse(Boolean success) {

    }
    global DispatchResponse(Boolean success, Object data) {

    }
    global DispatchResponse(Boolean success, String data) {

    }
}
}
