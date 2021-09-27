public without sharing class LOTUSChildObjectSegmentUpdate{
    static List<Opportunity> updatedOpportunityList = new List<Opportunity>();
    static List<Case> updatedCaseList = new List<Case>();
    static List<lead> updatedLeadList = new List<lead>();
    static List<Training_Event__c> updatedTEList = new List<Training_Event__c>();
    static List<Task> updatedTaskList = new List<Task>();
    static List<Event> updatedEventList = new List<Event>();
    public static Set<String> BuRegionValueSet=LCRMGenericComponent.getBuRegionValues();
    
    public static boolean opportunitySegmentUpdate(List<Opportunity> oppList, Map<Id, Account>accountIdSegmentMap){
        for(opportunity opp: oppList){
            if((BuRegionValueSet.Contains(opp.LCRM_Sub_BU__c))){
                if(opp.BU_Segment__c != accountIdSegmentMap.get(opp.AccountId).Bu_Segment__c){
                updatedOpportunityList.add(new Opportunity(Id = opp.Id, BU_Segment__c = accountIdSegmentMap.get(opp.AccountId).Bu_Segment__c));
                }
            }
        }
        if(updatedOpportunityList.size() >0){
            List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
            List<Database.SaveResult> results = Database.update(updatedOpportunityList, false);
            for(Integer i=0;i<results.size();i++){
                if(!results.get(i).isSuccess()){
                    exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),updatedOpportunityList.get(i).Id));
                }
            }
            if(exceptionList != null && exceptionList.size() > 0 && (Schema.sObjectType.LCRM_Exception_Log__c.isCreateable())){
                insert exceptionList ;
            }
        }
    return true;
    }
    public static boolean caseSegmentUpdate(List<Case> caseList, Map<Id, Account>accountIdSegmentMap){
        for(Case c: caseList){
            if((BuRegionValueSet.Contains(c.LCRM_Sub_BU__c))){
                if(c.BU_Segment__c != accountIdSegmentMap.get(c.AccountId).Bu_Segment__c){
                updatedCaseList.add(new Case(Id = c.Id, BU_Segment__c = accountIdSegmentMap.get(c.AccountId).Bu_Segment__c));
                }
             }
        }
        if(updatedCaseList.size() >0){
            List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
            List<Database.SaveResult> results = Database.update(updatedCaseList, false);
            for(Integer i=0;i<results.size();i++){
                if(!results.get(i).isSuccess()){
                    exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),updatedCaseList.get(i).Id));
                }
            }
            if(exceptionList != null && exceptionList.size() > 0 && (Schema.sObjectType.LCRM_Exception_Log__c.isCreateable())){
                insert exceptionList ;
            }
        }
    return true;
    }
    public static boolean leadSegmentUpdate(List<Lead> leadList, Map<Id, Account>accountIdSegmentMap){
        for(Lead l: leadList){
            if((BuRegionValueSet.Contains(l.LCRM_Sub_BU__c))){
                if(l.BU_Segment__c != accountIdSegmentMap.get(l.Account__c).Bu_Segment__c){
                updatedLeadList.add(new Lead(Id = l.Id, BU_Segment__c = accountIdSegmentMap.get(l.Account__c).Bu_Segment__c));
                }
             }
        }
        if(updatedLeadList.size() >0){
            List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
            List<Database.SaveResult> results = Database.update(updatedLeadList, false);
            for(Integer i=0;i<results.size();i++){
                if(!results.get(i).isSuccess()){
                    exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),updatedLeadList.get(i).Id));
                }
            }
            if(exceptionList != null && exceptionList.size() > 0 && (Schema.sObjectType.LCRM_Exception_Log__c.isCreateable())){
                insert exceptionList ;
            }
        }
    return true;
    }
    public static boolean trainingeventSegmentUpdate(List<Training_Event__c> trainingeventList, Map<Id, Account>accountIdSegmentMap){
        for(Training_Event__c te: trainingeventList){
            if((BuRegionValueSet.Contains(te.LCRM_Sub_BU__c))){
                if(te.BU_Segment__c != accountIdSegmentMap.get(te.Account__c).Bu_Segment__c){
                updatedTEList.add(new Training_Event__c(Id = te.Id, BU_Segment__c = accountIdSegmentMap.get(te.Account__c).Bu_Segment__c));
                }
             }
        }
        if(updatedTEList.size() >0){
            List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
            List<Database.SaveResult> results = Database.update(updatedTEList, false);
            for(Integer i=0;i<results.size();i++){
                if(!results.get(i).isSuccess()){
                    exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),updatedTEList.get(i).Id));
                }
            }
            if(exceptionList != null && exceptionList.size() > 0 && (Schema.sObjectType.LCRM_Exception_Log__c.isCreateable())){
                insert exceptionList ;
            }
        }
    return true;
    }
    public static boolean taskSegmentUpdate(List<Task> taskList, Map<Id, Account>accountIdSegmentMap){
        for(Task t: taskList){
            if((BuRegionValueSet.Contains(t.LCRM_Sub_BU__c))){
            if(t.BU_Segment__c != accountIdSegmentMap.get(t.AccountId).Bu_Segment__c){
                updatedTaskList.add(new Task(Id = t.Id, BU_Segment__c = accountIdSegmentMap.get(t.AccountId).Bu_Segment__c));
                }
            }
        }
        if(updatedTaskList.size() >0){
            List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
            List<Database.SaveResult> results = Database.update(updatedTaskList, false);
            for(Integer i=0;i<results.size();i++){
                if(!results.get(i).isSuccess()){
                    exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),updatedTaskList.get(i).Id));
                }
            }
            if(exceptionList != null && exceptionList.size() > 0){
                insert exceptionList ;
            }
        }
    return true;
    }
    public static boolean eventSegmentUpdate(List<Event> eventList, Map<Id, Account>accountIdSegmentMap){
        for(Event e: eventList){
            if(BuRegionValueSet.Contains(e.LCRM_Sub_BU__c)){
                if(e.BU_Segment__c != accountIdSegmentMap.get(e.AccountId).Bu_Segment__c){
                updatedEventList.add(new Event(Id = e.Id, BU_Segment__c = accountIdSegmentMap.get(e.AccountId).Bu_Segment__c));
                }
            }
        }
        if(updatedEventList.size() >0){
            List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
            List<Database.SaveResult> results = Database.update(updatedEventList, false);
            for(Integer i=0;i<results.size();i++){
                if(!results.get(i).isSuccess()){
                    exceptionList.add(createExceptionLog(results.get(i).getErrors().get(0).getMessage(),updatedEventList.get(i).Id));
                }
            }
            if(exceptionList != null && exceptionList.size() > 0){
                insert exceptionList ;
            }
        }
    return true;
    }
    
    @TestVisible
    private static LCRM_Exception_Log__c createExceptionLog(String errorMessage, String recordId){
        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c= errorMessage;
        excepObj.LCRM_Record_Ids__c= recordId;
        excepObj.LCRM_Exception_Type__c = 'BU_Segment_Update_Failure';
        return excepObj;
    }

}