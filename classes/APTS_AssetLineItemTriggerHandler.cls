public class APTS_AssetLineItemTriggerHandler 
{   
   
    public static void onBeforeInsert(List<Apttus_Config2__AssetLineItem__c> newAssetsList,Map<ID, Apttus_Config2__AssetLineItem__c> mapOfOldAssetLis) 
    {
        System.debug('Kh**AfterMERGE Method Entry onBeforeInsert '+Limits.getQueries());
        /*if(newAssetsList != null)
        {
            APTS_AssetLineItemTriggerHelper.updateAutoNumber(newAssetsList);
        } */   
        System.debug('Kh**AfterMERGE Method Exit onBeforeInsert '+Limits.getQueries());
    }

    public static void onBeforeUpdate(List<Apttus_Config2__AssetLineItem__c> listOfAssetLis,Map<ID, Apttus_Config2__AssetLineItem__c> mapOfOldAssetLis)
    {
        System.debug('Kh***URQCF updateRenewalQuoteCreatedFlag METHOD ENTRY*** '+Limits.getQueries());
        System.debug('Kh***URQCF List of Asset Lis===> ' + listOfAssetLis);
        System.debug('Kh***URQCF Map of Old Asset Lis===>' + mapOfOldAssetLis);

        if(listOfAssetLis != null && mapOfOldAssetLis != null)
        {
            APTS_AssetLineItemTriggerHelper.updateRenewalQuoteCreatedFlag(listOfAssetLis,mapOfOldAssetLis);
            APTS_AssetLineItemTriggerHelper.populateRenewalDate(listOfAssetLis,mapOfOldAssetLis); //Added by Kruti Shah
        }
        if(listOfAssetLis != null)
        {
            APTS_AssetLineItemTriggerHelper.updateAutoNumber(listOfAssetLis);
        } 
        System.debug('Kh***URQCF updateRenewalQuoteCreatedFlag METHOD EXIT*** '+Limits.getQueries());
    }
  
}