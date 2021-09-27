public without sharing class LOTUSChildObjSegmentUpdateInvocableClass  {
    @InvocableMethod(label='get Account Id and Segment' description='Gets Accounts ID and Segment from process builder')
    public static void getAccountInfo(List<Id> accIdList) {
        System.debug('@@@@@accIdList'+accIdList);
        updateChildObjectSegmentinFuture(accIdList);
    }
    
    @future
    public static void updateChildObjectSegmentinFuture(List<Id> accIdList){
        Set<String> BuRegionValueSet=LCRMGenericComponent.getBuRegionValues();
        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, AccountId,LCRM_Sub_BU__c, BU_Segment__c FROM Opportunity WHERE isClosed = false AND LCRM_Sub_BU__c IN :BuRegionValueSet AND AccountId IN :accIdList]);
        List<Case> caseList = new List<Case>([SELECT Id, AccountId,LCRM_Sub_BU__c,BU_Segment__c FROM Case WHERE isClosed = false AND LCRM_Sub_BU__c IN :BuRegionValueSet AND AccountId IN :accIdList]);
        List<Lead> leadList = new List<Lead>([SELECT Id, Account__c,LCRM_Sub_BU__c,BU_Segment__c FROM Lead WHERE LCRM_Sub_BU__c IN :BuRegionValueSet AND Account__c IN :accIdList]);
        List<training_Event__c> teList = new List<training_Event__c>([SELECT Id, Account__c,LCRM_Sub_BU__c, BU_Segment__c FROM training_Event__c WHERE LCRM_Sub_BU__c IN :BuRegionValueSet AND Account__c IN :accIdList]);
        List<Task> taskList = new List<Task>([SELECT Id, AccountId,LCRM_Sub_BU__c, BU_Segment__c FROM Task WHERE LCRM_Sub_BU__c IN :BuRegionValueSet AND AccountId IN :accIdList]);
        List<Event> eventList = new List<Event>([SELECT Id, AccountId,LCRM_Sub_BU__c, BU_Segment__c FROM Event WHERE LCRM_Sub_BU__c IN :BuRegionValueSet AND AccountId IN :accIdList]);
        Map<Id, Account> accountIdSegmentMap = new Map<Id, Account>([SELECT Id,BU_Region__c, BU_Segment__c FROM Account WHERE BU_Region__c IN :BuRegionValueSet AND Id IN : accIdList]);
       
        if(oppList.size() > 0)
        {
            System.debug('$$$$$$$$$$' +oppList.size());
            Boolean isOppUpdated = LOTUSChildObjectSegmentUpdate.opportunitySegmentUpdate(oppList, accountIdSegmentMap);
           
        }
        if(caseList.size() > 0)
        {
            Boolean isCaseUpdated = LOTUSChildObjectSegmentUpdate.caseSegmentUpdate(caseList, accountIdSegmentMap);
        }
        if(leadList.size() > 0){
            Boolean isLeadUpdated = LOTUSChildObjectSegmentUpdate.leadSegmentUpdate(leadList, accountIdSegmentMap);
        }
        if(teList.size() > 0){
            Boolean isTEUpdated = LOTUSChildObjectSegmentUpdate.trainingeventSegmentUpdate(teList, accountIdSegmentMap);
        }
        if(taskList.size() > 0){
            Boolean isTaskUpdated = LOTUSChildObjectSegmentUpdate.taskSegmentUpdate(taskList, accountIdSegmentMap);
        }
        if(eventList.size() > 0){
            Boolean isEventUpdated = LOTUSChildObjectSegmentUpdate.eventSegmentUpdate(eventList, accountIdSegmentMap);
        }
        
    }
}