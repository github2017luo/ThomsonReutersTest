/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AeServiceDescription {
    @WebService
    webService String description;
    @WebService
    webService String displayName;
    @WebService
    webService List<icrt.AeServiceDescription.AeServiceParameterDesc> inputParameter;
    @WebService
    webService String name;
    @WebService
    webService String namespaceQualifier;
    @WebService
    webService List<icrt.AeServiceDescription.AeServiceParameterDesc> outputParameter;
    @WebService
    webService String serviceType;
    @WebService
    webService List<String> showForObject;
    global AeServiceDescription() {

    }
    global icrt.AeServiceDescription.AeServiceParameterDesc addInputParameterDesc(String aName, String aType, Boolean aRequired) {
        return null;
    }
    global icrt.AeServiceDescription.AeServiceParameterDesc addOutputParameterDesc(String aName, String aType) {
        return null;
    }
    global void addShowForObject(String aType) {

    }
    global static icrt.AeServiceDescription.AeServiceParameterDesc createParameterDesc(String aName, String aType, Boolean aRequired) {
        return null;
    }
    global static icrt.AeServiceDescription.AeParameterOption createParameterOption(String aName, String aValue) {
        return null;
    }
    global Map<String,icrt.AeServiceDescription.AeServiceParameterDesc> getInputParameterMap() {
        return null;
    }
    global static String getNamespacePrefixForClass(String aClassName) {
        return null;
    }
global class AeParameterOption {
    @WebService
    webService String name;
    @WebService
    webService String value;
    global AeParameterOption() {

    }
}
global class AeServiceParameterDesc {
    @WebService
    webService String name;
    @WebService
    webService List<icrt.AeServiceDescription.AeParameterOption> options;
    @WebService
    webService String parameterType;
    @WebService
    webService Boolean required;
    global AeServiceParameterDesc() {

    }
    global icrt.AeServiceDescription.AeParameterOption addParameterOption(String aName, String aValue) {
        return null;
    }
}
}
