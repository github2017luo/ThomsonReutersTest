global class LOTUSUpdateLeadSegmentBatch implements Database.Batchable<sObject>{

   String Query;
   Map<Id, Account> accountIdSegmentMap;
   List<XREFAccountSegment__c> accountSegmentList;
   List<Lead> leadList = new List<Lead>();
   Set<Id> accountIdSet = new Set<Id>();
   List<String> BuRegionList = new List<String>();
   public Set<String> BuRegionValueSet=new Set<String>();
   global LOTUSUpdateLeadSegmentBatch(Map<Id, Account> accountIdSegmentMap, List<XREFAccountSegment__c> accountSegmentList){
       KeyValueListStore__c BuRegionValueStore = KeyValueListStore__c.getValues('LTS_BURegion_Values');
       if(BuRegionValueStore !=null && BuRegionValueStore.TextValue__c !=null && BuRegionValueStore.TextValue__c != ''){
            BuRegionList = BuRegionValueStore.TextValue__c.split(',');
        } 
                     
        for(String BuRegion : BuRegionList){            
            BuRegionValueSet.add(BuRegion);
        }   
      this.accountIdSegmentMap = accountIdSegmentMap;
      this.accountSegmentList = accountSegmentList;
      this.accountIdSet = accountIdSegmentMap.keySet();
      Query='SELECT Id, Account__c,LCRM_Sub_BU__c, BU_Segment__c FROM Lead WHERE Is_GLI__c = TRUE AND LCRM_Sub_BU__c IN :BuRegionValueSet AND Account__c IN :accountIdSet';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     for(sobject s : scope){
        Lead l = (Lead)s;
        leadList.add(l);
     }
     if(!leadList.isEmpty()){
        LOTUSChildObjectSegmentUpdate.leadSegmentUpdate(leadList, accountIdSegmentMap);
     }
    }

   global void finish(Database.BatchableContext BC){
       Database.executeBatch(New LOTUSUpdateCaseSegmentBatch(accountIdSegmentMap, accountSegmentList), 200);
   }
}