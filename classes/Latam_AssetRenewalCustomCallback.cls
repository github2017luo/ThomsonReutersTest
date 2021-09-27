/**
* Callback invoked to append asset filter expression to the renew asset line item query
* Filter expression should be created using asset line item fields only.
* @return the filter expression or null to use the default filter.
*/
global with sharing class Latam_AssetRenewalCustomCallback implements Apttus_Config2.CustomClass.IAssetRenewalCustomCallback {
    
    global String getAssetFilterExpr() {
        
        System.debug('Result');
        return ' Apttus_Config2__AssetStatus__c=\'Activated\'  AND Renewal_quote_created__c= False AND Apttus_Config2__EndDate__c != null '+
            ' AND (APTS_Proposal_Business_Unit__c = \'Canada\' AND APTS_Online_or_Proflex_Product__c != \'Non_Renewal\')';    
    }
    
    global List<Apttus_Config2.Property> getConfigProperties(SObject bObjectSO){
        List<Apttus_Config2.Property> configProps = new List<Apttus_Config2.Property>();
        configProps.add(new Apttus_Config2.Property('flow', 'ngFlow'));
        configProps.add(new Apttus_Config2.Property('useAdvancedApproval', 'false'));
        configProps.add(new Apttus_Config2.Property('useDealOptimizer', 'false'));
        return configProps;
    }
    
}