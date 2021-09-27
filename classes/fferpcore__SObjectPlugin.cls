/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class SObjectPlugin implements fferpcore.UserInformationPlugin.Work {
    global SObjectPlugin() {

    }
    global abstract SObject createTarget(Id param0, SObject param1);
    global abstract String getLinkedObjectData(SObject param0);
    global abstract List<SObject> getLinkedObjects(Set<String> param0);
    global abstract String getTargetLinkedData(SObject param0);
    global abstract Schema.SObjectType getTargetObjectType();
    global abstract List<SObject> getTargetObjects(Set<Id> param0, Set<String> param1);
    global abstract Id getTargetUserId(SObject param0);
    global abstract String hasAccess();
}
