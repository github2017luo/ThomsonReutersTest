global class LOTUSUpdateEventSegmentBatch implements Database.Batchable<sObject>{

   String Query;
   Map<Id, Account> accountIdSegmentMap;
   List<XREFAccountSegment__c> accountSegmentList;
   List<Event> eventList = new List<Event>();
   Set<Id> accountIdSet = new Set<Id>();
   List<String> BuRegionList = new List<String>();
   public Set<String> BuRegionValueSet=new Set<String>();
   global LOTUSUpdateEventSegmentBatch(Map<Id, Account> accountIdSegmentMap, List<XREFAccountSegment__c> accountSegmentList){
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
      Query='SELECT Id, AccountId,LCRM_Sub_BU__c,BU_Segment__c FROM Event WHERE Account.IS_GLI__c = TRUE AND LCRM_Sub_BU__c IN :BuRegionValueSet AND AccountId IN :accountIdSet';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     for(sobject s : scope){
        Event e = (Event)s;
        eventList.add(e);
     }
     if(!eventList.isEmpty()){
        LOTUSChildObjectSegmentUpdate.eventSegmentUpdate(eventList, accountIdSegmentMap);
     }
    }

   global void finish(Database.BatchableContext BC){
    for(XREFAccountSegment__c XREFAccountSegment:accountSegmentList){
           XREFAccountSegment.Is_Processed_Activity__c = true;
       }
       if(accountSegmentList.size() > 0){
           Database.update(accountSegmentList);
       }
   }
}