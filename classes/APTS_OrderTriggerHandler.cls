/**
* @description Handler class for Order Trigger
*/
public without sharing class APTS_OrderTriggerHandler {
    public static integer ordercount = 0;

    /**
     * @description Method to invoke Helper class
    */
    public static Boolean isInsert = false;

    /**
     * @description Method to handle exclusion framework
     * @param newObjects of type Apttus_Config2__Order__c[]
     * @param oldObjects of type Map<Id,Apttus_Config2__Order__c>
    */
    public static void exclusionframework(Apttus_Config2__Order__c[] newObjects,Map<Id,Apttus_Config2__Order__c> oldObjects){
        Boolean isBulkLoad = false;
        Boolean isTestrun = false;
        
        //Added by Tejaswi (GLI-OC) to deactive triggers during data load
        GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());        
        if(loadValues!=null && (loadValues.APTS_Disable_Triggers__c)){
            isBulkLoad=true;
        }
        if(!Test.isRunningTest()){
            isTestrun=false;
        }else{    
            isTestrun=true;  
        }
        //End of trigger Deactivate logic
        if(isTestrun || (isTestrun== false && isBulkLoad ==false)){
            System.debug(LoggingLevel.DEBUG,'inside trigger execution');
            handler(newObjects,oldObjects);       
        }
    }
    
    /**
     * @description Method to invoke Helper class
     * @param newObjects of type Apttus_Config2__Order__c[]
     * @param oldObjects of type Map<Id,Apttus_Config2__Order__c>
    */
    public static void handler(Apttus_Config2__Order__c[] newObjects,Map<Id,Apttus_Config2__Order__c> oldObjects){
        system.debug(LoggingLevel.Debug,'inside handler');
        Boolean runOldOrderProcess = false;
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        if(keyValueListRec !=NULL){
            runOldOrderProcess = TRUE;
        }
        if(Trigger.isInsert && Trigger.isAfter){
            APTS_OrderTriggerHelper.updateRelatedProposal(newObjects);
            APTS_OrderTriggerHelper.updateRelatedOpp(newObjects);
            isInsert = true;
            system.debug(LoggingLevel.DEBUG,'##############3 in');
        }else if(Trigger.isUpdate && Trigger.isAfter){
            APTS_OrderTriggerHelper.updateOpportunity(newObjects);
            APTS_OrderTriggerHelper.databaseEntitlement(newObjects,oldObjects);
            APTS_OrderTriggerHelper.updatetaxprofdates(newObjects,oldObjects);
            System.debug(LoggingLevel.DEBUG, 'runOldOrderProcess : ' + runOldOrderProcess + ' orderRecursiveCheck : '+ APTS_OrderTriggerHelper1.orderRecursiveCheck + ' isInsert : '+ isInsert);
            if(runOldOrderProcess==false && APTS_OrderTriggerHelper1.orderRecursiveCheck == false && (isInsert==false || runordersubmission() >= 2)){
                system.debug(LoggingLevel.DEBUG,'start ordersubmission');
                APTS_OrderTriggerHelper1.ordersubmission(newObjects);
            }
            system.debug(LoggingLevel.DEBUG,'##############3 in');
        }else if(checkBeforeUpdate()){
            APTS_OrderTriggerHelper.activateOrder(newObjects);
            system.debug(LoggingLevel.DEBUG,'##############3 in');
        }
    } 
    
    /**
     * @description Method to invoke Helper class
     * @return integer type
    */
    public static integer runordersubmission(){
        ordercount = ordercount + 1;
        System.debug(LoggingLevel.Debug,'inside runordersubmission : ' + ordercount);
        return ordercount;
    } 

    @testvisible
    static private Boolean checkBeforeUpdate(){
        Boolean flag = false;
        if(Trigger.isUpdate && Trigger.isBefore){
            flag = true;
        }
        return flag;
    }
  
}