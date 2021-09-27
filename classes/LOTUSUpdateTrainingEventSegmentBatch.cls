global class LOTUSUpdateTrainingEventSegmentBatch implements Database.Batchable<sObject>{

   String Query;
   Map<Id, Account> accountIdSegmentMap;
   List<XREFAccountSegment__c> accountSegmentList;
   List<Training_Event__c> teList = new List<Training_Event__c>();
   Set<Id> accountIdSet = new Set<Id>();
    List<String> BuRegionList = new List<String>();
   public Set<String> BuRegionValueSet=new Set<String>();
   global LOTUSUpdateTrainingEventSegmentBatch (Map<Id, Account> accountIdSegmentMap, List<XREFAccountSegment__c> accountSegmentList){
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
      Query='SELECT Id, Account__c, BU_Segment__c,LCRM_Sub_BU__c FROM Training_Event__c WHERE LCRM_Is_GLI__c = TRUE AND LCRM_Sub_BU__c IN :BuRegionValueSet AND Account__c IN :accountIdSet';
      
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     for(sobject s : scope){
        Training_Event__c te = (Training_Event__c)s;
        teList.add(te);
     }
     if(!teList.isEmpty()){
        LOTUSChildObjectSegmentUpdate.trainingeventSegmentUpdate(teList, accountIdSegmentMap);
     }
    }

   global void finish(Database.BatchableContext BC){
       for(XREFAccountSegment__c XREFAccountSegment:accountSegmentList){
           XREFAccountSegment.Is_Processed__c = true;
       }
       if(accountSegmentList.size() > 0){
           Database.update(accountSegmentList);
       }
   }
}