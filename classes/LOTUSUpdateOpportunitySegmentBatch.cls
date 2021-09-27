global class LOTUSUpdateOpportunitySegmentBatch implements Database.Batchable<sObject>{

   String Query;
   Map<Id, Account> accountIdSegmentMap;
   List<XREFAccountSegment__c> accountSegmentList;
   List<Opportunity> oppList = new List<Opportunity>();
   Set<Id> accountIdSet = new Set<Id>();
   List<String> BuRegionList = new List<String>();
   public Set<String> BuRegionValueSet = LCRMGenericComponent.getBuRegionValues();
          
       
   global LOTUSUpdateOpportunitySegmentBatch(Map<Id, Account> accountIdSegmentMap, List<XREFAccountSegment__c> accountSegmentList){
      /*KeyValueListStore__c BuRegionValueStore = KeyValueListStore__c.getValues('LTS_BURegion_Values');
      if(BuRegionValueStore !=null && BuRegionValueStore.TextValue__c !=null && BuRegionValueStore.TextValue__c != ''){
            BuRegionList = BuRegionValueStore.TextValue__c.split(',');
        } 
                     
        for(String BuRegion : BuRegionList){            
            BuRegionValueSet.add(BuRegion);
        }  */
        system.debug('accountIdSeg' +accountIdSegmentMap.size());
        system.debug('accountsegList' +accountSegmentList);
      if(accountIdSegmentMap.size()>0 && accountSegmentList!=null)
      {
      this.accountIdSegmentMap = accountIdSegmentMap;
      this.accountSegmentList = accountSegmentList;
      this.accountIdSet = accountIdSegmentMap.keySet();
      }
      this.Query='SELECT Id, AccountId,LCRM_Sub_BU__c, BU_Segment__c FROM Opportunity WHERE IsClosed = False AND Is_GLI__c = TRUE AND LCRM_Sub_BU__c IN :BuRegionValueSet AND AccountId IN :accountIdSet';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     for(sobject s : scope){
        Opportunity opp = (Opportunity)s;
        oppList.add(opp);
     }
     if(!oppList.isEmpty()){
        LOTUSChildObjectSegmentUpdate.opportunitySegmentUpdate(oppList, accountIdSegmentMap);
     }
    }

   global void finish(Database.BatchableContext BC){
   System.debug('@@@@@accountSegmentList'+accountSegmentList);
   System.debug('@@@@@accountIdSegmentMap'+accountIdSegmentMap);
       Database.executeBatch(New LOTUSUpdateLeadSegmentBatch(accountIdSegmentMap, accountSegmentList), 200);
   }
}