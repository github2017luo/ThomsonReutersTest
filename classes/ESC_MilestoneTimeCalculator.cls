/********************************************************************
Apex Class:ESC_MilestoneTimeCalculator 
Description : Updates the caseMilestone record with dynamically calculated target date.
Author: Shounak M
Comment: Class will be used in calculating remaining time in Mins for Dynamice Milestones. 
        This will consider Business hours associated to case in the below hierarchy:
            1. Entitlement Process
            2. Entitlement
            3. Case
        
*******************************************************************/

global without sharing class ESC_MilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator {   
    public Static List<Entitlement> entitleList = new List<Entitlement>();
    public Static List<Milestonetype> milestonetypelist = new List<Milestonetype> ();
    
    global Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId){
        try{
            Integer targetTimeInMins = 0;
            list<Case> caseRecordList = new List<Case>();
            DateTime mileStoneTime;
            List<CaseMilestone> existingMS = new List<CaseMilestone>();
            map<String,String> milestonemap = new map<String,String>();
            Id bushrsId;
            Id entbushrs;
            Id casebushrs;
            Id caseentid;
            if(milestonetypelist.isempty()){
                milestonetypelist = [select id,name from MilestoneType];
            }
            
            if(milestonetypelist != null && milestonetypelist.size() > 0){
                for(Milestonetype mlstn : milestonetypelist ){
                    milestonemap.put((String.valueof(mlstn.id)).substring(0,15),mlstn.name);
                }
            }
            String strMilestoneName;
            if(milestonemap.containsKey(milestonetypeid)){
                strMilestoneName = milestonemap.get(milestoneTypeId);
                }
                if(Schema.sObjectType.CaseMilestone.isAccessible() || Schema.sObjectType.CaseMilestone.isQueryable()){
            existingMS = [select TargetResponseInMins FROM CaseMilestone
                                                 where MilestoneTypeId=: milestoneTypeId and IsCompleted=false and caseId =: caseId];  
                }          
                                                             
            // querying milestone field API name from custom setting 
            ESC_MilestoneIdentifierSetting__c mileStoneFieldDataSet = ESC_MilestoneIdentifierSetting__c.getValues(strMilestoneName);
            string msIdetifierFieldName = mileStoneFieldDataSet.FieldAPIName__c;
            
            system.debug('mileStoneFieldList :' +msIdetifierFieldName);

           // preparing dynamic query and getting milestone identifier time field value
           if(caseId != null && msIdetifierFieldName != null){
               string dQuery =  'select Id, EntitlementId,BusinessHoursId,'+string.escapesinglequotes(msIdetifierFieldName)+' from Case where Id = \''+string.escapesinglequotes(caseID)+'\'';
               caseRecordList = Database.query(dQuery);
               system.debug(caseRecordList);
            //   system.debug('caseRecordList[0].GLI_First_Response_Time__c****'+caseRecordList[0].GLI_First_Response_Time__c);

           }
           if(!caseRecordList.isEmpty()){
               mileStoneTime = (DateTime)caseRecordList[0].get(msIdetifierFieldName);
               casebushrs = caseRecordList[0].BusinessHoursId;
               caseentid = caseRecordList[0].EntitlementId;
           }
           if(caseentid!=null){
                if(entitleList.isempty()){
           entitleList = [select Id, slaProcess.BusinessHoursId,BusinessHoursId from Entitlement where id =:caseentid];
}
           if(entitleList.size()>0){
                if(entitleList[0].slaProcess.BusinessHoursId!=null){
                    entbushrs = entitleList[0].slaProcess.BusinessHoursId;
                }
                else{
                    entbushrs = entitleList[0].BusinessHoursId;
                }
                
           }
           }
           bushrsId = (entbushrs!=null)?entbushrs:casebushrs;

            if(mileStoneTime != null){
                system.debug('BH:'+casebushrs);
                Double timeInMillis = BusinessHours.diff(bushrsId, Datetime.now(), mileStoneTime);
                targetTimeInMins = (Integer)((timeInMillis /60000) + 0.5); 
                system.debug('milestone time is'+milestonetime+'targettime in mins is'+targettimeinmins);
            }
            system.debug('existingmilestone is'+existingMS);
            if(targetTimeInMins>0 && existingMS.isEmpty() ){ 
               return Integer.valueOf(TargetTimeInMins);     
            }
            else if(!existingMS.isEmpty()){
                 return Integer.valueOf(existingMS[0].TargetResponseInMins);
            }
            else{
                return 1;
            }
        }
        catch(exception ex){
            System.debug('exception'+ex);
            return 1;
        }
    }
}