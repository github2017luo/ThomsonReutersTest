/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AnalysisMappingService {
    global AnalysisMappingService() {

    }
    global static fferpcore.AnalysisMappingService.EntriesOnSObjectResult getEntriesOnSObjects(List<Schema.SObjectType> targetSObjects) {
        return null;
    }
global interface DataFlow {
    void copyValue(SObject param0, SObject param1);
    Set<String> getAnalysisMappings();
    fferpcore.SObjectFieldPath getSourcePath();
    String getSourcePathString();
    Schema.SObjectField getTargetField();
    Boolean hasUserRequiredPermission();
    Object readValue(SObject param0);
    void writeValue(SObject param0, Object param1);
}
global interface EntriesOnSObjectResult {
    Set<String> getAnalysisMappings();
    List<fferpcore.AnalysisMappingService.DataFlow> getCopyableMappings(Schema.SObjectType param0, Schema.SObjectType param1);
    List<fferpcore.AnalysisMappingService.Entry> getEntries(Schema.SObjectType param0);
    fferpcore.AnalysisMappingService.Entry getEntry(String param0, Schema.SObjectType param1);
    Set<String> getFieldPathStrings(Schema.SObjectType param0);
    Set<Schema.SObjectType> getSObjectTypes();
}
global interface Entry {
    String getAnalysisMappingLabel();
    String getAnalysisMappingName();
    Schema.SObjectField getField();
    fferpcore.SObjectFieldPath getFieldPath();
    String getFieldPathString();
    Schema.SObjectType getSObjectType();
    Boolean isIndirect();
    Object readValue(SObject param0);
    void writeValue(SObject param0, Object param1);
}
}
