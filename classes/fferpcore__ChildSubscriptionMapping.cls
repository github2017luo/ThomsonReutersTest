/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ChildSubscriptionMapping implements fferpcore.CustomizableWithMappings, fferpcore.CustomizableWithMappings2, fferpcore.SubscriptionMapping {
    global ChildSubscriptionMapping(String childKey, List<String> messageKey) {

    }
    global ChildSubscriptionMapping(String childKey, List<String> messageKey, fferpcore.ChildCorrelationStrategy childCorrelationStrategy) {

    }
    global fferpcore.AddMappingsResult addMappings(List<fferpcore.SubscriptionMapping> mappings) {
        return null;
    }
    global fferpcore.AddMappingsResult addMappings(String targetChildType, List<fferpcore.SubscriptionMapping> mappings) {
        return null;
    }
    global Boolean canHaveChildren() {
        return null;
    }
    global void disableOutputTo(Set<String> output) {

    }
    global List<fferpcore.SubscriptionMapping> getChildren() {
        return null;
    }
    global List<fferpcore.SubscriptionMapping> getMappings() {
        return null;
    }
    global List<fferpcore.SubscriptionMapping> getMappings(String targetChildType) {
        return null;
    }
    global List<List<String>> getMessageKeys() {
        return null;
    }
    global Set<String> getTargetFields() {
        return null;
    }
    global String getTransformTableId() {
        return null;
    }
    global Boolean isDeclarative() {
        return null;
    }
    global Boolean isDisabled() {
        return null;
    }
    global void performBulkActions() {

    }
    global void performImmediateActions(fferpcore.ApplyMappingRequest2 request) {

    }
    global void prepare(fferpcore.DataTarget dataTarget) {

    }
    global void setDeclarative(Boolean value) {

    }
    global fferpcore.ChildSubscriptionMapping withFilter(fferpcore.ChildMappingMatcher filter) {
        return null;
    }
    global fferpcore.ChildSubscriptionMapping withMapping(String targetChildType, fferpcore.SubscriptionMapping mapping) {
        return null;
    }
    global fferpcore.ChildSubscriptionMapping withMappings(String targetChildType, List<fferpcore.SubscriptionMapping> mappings) {
        return null;
    }
}
