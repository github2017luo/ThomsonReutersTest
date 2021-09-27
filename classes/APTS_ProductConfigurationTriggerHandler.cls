public with sharing class APTS_ProductConfigurationTriggerHandler {
    public static boolean afterUpdate = false;
    public static boolean afterInsert = false;
    public static boolean beforeUpdate = false;
    
    public static void OnAfterUpdate(Map<Id, Apttus_Config2__ProductConfiguration__c> mapOldObjects, List<Apttus_Config2__ProductConfiguration__c> listNewObjects, Map<Id, Apttus_Config2__ProductConfiguration__c> mapNewObjects){
        
        //if(!afterUpdate){
        //    afterUpdate=true;
        if(checkRecursive.runAfterUpdateOnce()){
            List<Apttus_Config2__ProductConfiguration__c> recs1 = new List<Apttus_Config2__ProductConfiguration__c>();
            List<Apttus_Config2__ProductConfiguration__c> prdList = new List<Apttus_Config2__ProductConfiguration__c>();
            for (Apttus_Config2__ProductConfiguration__c config: listNewObjects) {
                if (config.Apttus_Config2__Status__c == 'Finalized')
                    recs1.add(config);
            }
            
            if (recs1.size() > 0){
                APTS_ProductConfigurationTriggerHelper.updateTally(recs1); //Added by Chirag
            }
            APTS_ProductConfigurationTriggerHelper.createDynamicBundles(mapOldObjects, mapNewObjects);
        }
           
    }
    
    public static void onBeforeUpdate(List<Apttus_Config2__ProductConfiguration__c> listNewObjects){
        //Added check recurssion
            APTS_ProductConfigurationTriggerHelper.ProdConfigApproval(listNewObjects);
    }//Added this method to fix Incremental Growth issue (Oct 10 2017) 

}