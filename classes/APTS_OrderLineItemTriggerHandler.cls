/**
 * @description handler class for orderlineitem trigger
 */
@SuppressWarnings('PMD.AvoidGlobalModifier,PMD.ApexSharingViolations,PMD.ApexCRUDViolation')
public class APTS_OrderLineItemTriggerHandler{
    public static boolean afterUpdateRun = FALSE;
    /**
     * @description hanlder method for after update of orderlineitem trigger
     * @param newList
     * @param oldMap
     */
    public static void doAfterUpdate(List<Apttus_Config2__OrderLineItem__c> newList, Map<Id,Apttus_Config2__OrderLineItem__c> oldMap){
        if(!afterUpdateRun){
            List<Apttus_Config2__Order__c> oList = new List<Apttus_Config2__Order__c>();
            Set<ID> oIDSet = new Set<ID>();
            for(Apttus_Config2__OrderLineItem__c oli : newList){
                System.debug(LoggingLevel.DEBUG, 'Apttus_Config2__AttributeValueId__c new : '+oli.Apttus_Config2__AttributeValueId__c);
                System.debug(LoggingLevel.DEBUG, 'Apttus_Config2__AttributeValueId__c old : '+oldMap.get(oli.Id).Apttus_Config2__AttributeValueId__c);
                if(oli.Apttus_Config2__AttributeValueId__c != 
                    oldMap.get(oli.Id).Apttus_Config2__AttributeValueId__c){oIDSet.add(oli.Apttus_Config2__OrderId__c);}
            }
            System.debug(LoggingLevel.DEBUG, 'oIDSet : '+oIDSet);
            for(Id oID : oIDSet){
                Apttus_Config2__Order__c oRec = new Apttus_Config2__Order__c(ID=oID); oList.add(oRec);
            }
            System.debug(LoggingLevel.DEBUG, 'oList : '+oList);
            if(oList.size()>0){
                update oList;
                afterUpdateRun = TRUE;
            }
            
        }
    }


}