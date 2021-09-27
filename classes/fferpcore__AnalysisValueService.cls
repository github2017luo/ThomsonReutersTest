/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AnalysisValueService {
    global AnalysisValueService() {

    }
    global static List<fferpcore.AnalysisValueService.ValidationResult> validate(List<SObject> records) {
        return null;
    }
global class ValidationError {
    global ValidationError(Schema.SObjectField field, String message) {

    }
    global Schema.SObjectField getField() {
        return null;
    }
    global String getMessage() {
        return null;
    }
}
global interface ValidationResult {
    List<fferpcore.AnalysisValueService.ValidationError> getErrors();
    Id getId();
    Boolean isSuccess();
}
}
