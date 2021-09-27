/*
======================================================================================================================
CLASS NAME:    ESC_AccountSupportHandler
Test Class: LCRMRestrictRecordDeletion_test
======================================================================================================================
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                           DESC
2021-9-06        Kumaraswamy Emdarapu       Updating ESC_Support_Level__c object field ESC_Is_Merged__c with True before deleting the Account
======================================================================================================================
*/
  
    /**
     * @description ESC_AccountSupportHandler class
     */
public without sharing class ESC_AccountSupportHandler {
      
    /**
     * @description updateEscSupportObjectMergeField method
     * @param accountIds
     */
    public static void updateEscSupportObjectMergeField(set<id> accountIds){  
        if(accountIds != null && accountIds.size() > 0){
            list<ESC_Support_Level__c> listOfSupportRecords = new list<ESC_Support_Level__c>();
            if(Schema.sObjectType.ESC_Support_Level__c.isAccessible() || Schema.sObjectType.ESC_Support_Level__c.isQueryable()){
            listOfSupportRecords = [select id, ESC_Is_Merged__c, Account__c from ESC_Support_Level__c where Account__c in : accountIds];
            }
            if(listOfSupportRecords.size() > 0){
                for(ESC_Support_Level__c support : listOfSupportRecords){
                    support.ESC_Is_Merged__c = true;
                }
            }
            System.debug('listOfSupportRecords'+listOfSupportRecords);
            if(listOfSupportRecords != null && listOfSupportRecords.size() > 0 && (
               Schema.sObjectType.ESC_Support_Level__c.isAccessible() || Schema.sObjectType.ESC_Support_Level__c.isUpdateable())){              
                   update listOfSupportRecords;
               }                       
        }                  
    }
    
}