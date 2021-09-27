/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GenericCriteriaComponentController {
    global String CondExpr {
        get;
        set;
    }
    global String DataSourceSOName {
        get;
        set;
    }
    global String DestinationField {
        get;
        set;
    }
    global Id DestinationSOId {
        get;
        set;
    }
    global Apttus_Config2__Incentive__c IncentiveSO {
        get;
        set;
    }
    global List<Apttus_Config2.GenericCriteriaComponentController.Predicate> Predicates {
        get;
        set;
    }
    global Apttus_Config2__PriceRuleset__c PriceRuleSetSO {
        get;
        set;
    }
    global Boolean ReturnToPrevPage {
        get;
        set;
    }
    global GenericCriteriaComponentController() {

    }
    global void loadFilter() {

    }
    @RemoteAction
    global static List<SObject> searchFieldValue(String objectName, String searchField, String searchTerm) {
        return null;
    }
}
