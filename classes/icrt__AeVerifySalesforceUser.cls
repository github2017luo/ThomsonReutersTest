/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AeVerifySalesforceUser {
    global AeVerifySalesforceUser() {

    }
    webService static icrt.AeVerifySalesforceUser.AeUserResponse verifyUser(icrt.AeVerifySalesforceUser.AeUserRequest request) {
        return null;
    }
global class AeUserRequest {
    @WebService
    webService String b64EncryptedToken;
    global AeUserRequest() {

    }
}
global class AeUserResponse {
    @WebService
    webService String contextToken;
    @WebService
    webService String displayName;
    @WebService
    webService String isValid;
    @WebService
    webService String organizationId;
    @WebService
    webService String packageVersion;
    @WebService
    webService String userId;
    @WebService
    webService String userName;
    global AeUserResponse() {

    }
}
}
