/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CreateRenewAssetsGroupJob implements Database.Batchable<SObject>, Database.Stateful {
    global Id accountId;
    global List<Apttus_Config2__AssetLineItem__c> assetLineItems;
    global Id defaultPriceListId;
    global List<String> groupFields;
    global Map<String,String> idNameMap;
    global Integer leadTime;
    global Integer maxRenewalLineItemPerCart;
    global CreateRenewAssetsGroupJob() {

    }
    global void execute(Database.BatchableContext bc, List<Apttus_Config2__AssetLineItem__c> scope) {

    }
    global void finish(Database.BatchableContext bc) {

    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}
