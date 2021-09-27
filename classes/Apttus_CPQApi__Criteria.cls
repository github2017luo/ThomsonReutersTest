/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class Criteria {
    global Criteria() {

    }
global class Filter {
    global Filter() {

    }
    global void addPredicate(Apttus_CPQApi.Criteria.Predicate predicate) {

    }
    global String getConditionExpr() {
        return null;
    }
    global List<Apttus_CPQApi.Criteria.Predicate> getPredicates() {
        return null;
    }
    global Boolean hasConditionExpr() {
        return null;
    }
    global Boolean hasPredicates() {
        return null;
    }
    global Boolean isEmpty() {
        return null;
    }
    global void setConditionExpr(String condExpr) {

    }
}
global class Predicate {
    global String BoolOper {
        get;
        set;
    }
    global String CompOper {
        get;
        set;
    }
    global String FieldLabel {
        get;
        set;
    }
    global String FieldName {
        get;
        set;
    }
    global String FieldType {
        get;
        set;
    }
    global String FieldValue {
        get;
        set;
    }
    global Integer RowNum {
        get;
        set;
    }
    global Predicate() {

    }
}
global class SearchFilter {
    global SearchFilter() {

    }
    global Apttus_CPQApi.Criteria.Filter getFilter() {
        return null;
    }
    global String getSObjectLabel() {
        return null;
    }
    global String getSObjectName() {
        return null;
    }
    global void setFilter(Apttus_CPQApi.Criteria.Filter filter) {

    }
    global void setSObjectLabel(String sObjectLabel) {

    }
    global void setSObjectName(String sObjectName) {

    }
}
}
