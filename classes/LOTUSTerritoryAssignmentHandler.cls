/********************************************
@Class Name : LOTUSTerritoryAssignmentHandler

@Purpose : The below class receives sobject records from before insert/update opportunity trigger and pass it 
to the LOTUSTerritoryAssignment apex class.

Created by : Niket Kapasi
*********************************************/
public with sharing class LOTUSTerritoryAssignmentHandler {
    
    public static void assignTerritory(List<sobject> sobjectList){
        SYSTEM.debug('sobjectList ==> '+sobjectList);
        String objectName= sobjectList[0].getSObjectType().getDescribe().getName();
        System.System.debug('@@ObjectName'+objectName);
        LOTUSTerritoryAssignment terrIns = new LOTUSTerritoryAssignment();
        List<sobject> sobjectOwnerChangedList = new List<sobject>();        
        if(objectName == 'Opportunity'){
            if(Trigger.isUpdate){                
                for(sobject sobjRec : sobjectList){
                    Opportunity oppRec = (Opportunity)sobjRec;
                    Opportunity oldOppRec = (Opportunity)Trigger.oldmap.get(oppRec.id);
                    if(oppRec.ownerId != oldOppRec.ownerId || oppRec.StageName != oldOppRec.StageName){
                        oppRec.territory2Id = null;
                        system.debug('Owner id is changed');
                        sobjectOwnerChangedList.add(sobjRec);
                    }                    
                }
                if(sobjectOwnerChangedList.size() > 0){
                    terrIns.populateTerritoryId(sobjectOwnerChangedList,objectName);
                }               
                
            }
            else if (Trigger.isInsert){
                SYSTEM.debug('sobjectList ==> '+sobjectList);
                SYSTEM.debug('objectName ==> '+objectName);
                if(sobjectList.size() > 0 && String.isNotBlank(objectName)){
                    SYSTEM.debug('sobjectList ==> '+sobjectList);
                    SYSTEM.debug('objectName ==> '+objectName);
                    terrIns.populateTerritoryId(sobjectList,objectName);
                }else{
                    System.debug('Trigger.New/Object Name is Empty');                    
                }                
            }        
        }        
    }
    
    /**
@Method Name: getOpptyStatus
@Purpose : Fetches the unwanted opportunity stages where territory2id is not populated.
The stage values are  stored in custom setting named 'KeyValueListStore__c'(i.e 'LCRMOpptyTerritoryStageValues')
*/
    public static set<String> getOpptyStatus(){        
        List<String> stageList = new List<String>();
        Set<String> stageSet = new Set<String>();        
        //custom setting to store opportunity stage(stagename) values
        KeyValueListStore__c tempStageValueStore = KeyValueListStore__c.getValues('LCRMOpptyTerritoryStageValues');        
        if(tempStageValueStore !=null && tempStageValueStore.TextValue__c !=null && tempStageValueStore.TextValue__c !=''){
            stageList = tempStageValueStore.TextValue__c.split(',');
        }        
        if(!stageList.isEmpty()){
            for(String stageins : stageList){                
                stageSet.add(stageins);
            }            
        }
        return stageSet;        
    }
}