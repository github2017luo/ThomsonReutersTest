/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CriteriaUpdateJob implements Database.Batchable<SObject>, Database.Stateful {
    global Set<String> attrExtCriteriaFields;
    global Set<String> criteriaFields;
    global Set<String> extOrderCriteriaFields;
    global Set<String> hdrCriteriaFields;
    global List<String> jobSteps;
    global Set<String> jobStepSet;
    global Map<String,Set<String>> limitFields;
    global Set<String> orderCriteriaFields;
    global Map<String,Set<String>> orderLimitFields;
    global Set<String> orderMapFields;
    global List<Apttus_Config2__PriceListItem__c> pendingItems;
    global List<Apttus_Config2__PriceRuleset__c> pendingRules;
    global CriteriaUpdateJob(List<String> jobSteps) {

    }
    global void execute(Database.BatchableContext bc, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext bc) {

    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}
