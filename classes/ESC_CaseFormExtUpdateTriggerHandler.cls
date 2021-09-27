/**
 * @description ESC_CaseFormExtUpdateTriggerHandler class
 */
public without sharing Class ESC_CaseFormExtUpdateTriggerHandler{ 
     /**
     * @description onBeforeUpdate
     * @param caseFormOldMap
     * @param caseFormNewMap
     */
    public static void onBeforeUpdate( Map<Id,ESC_Case_Form_Extension__c > caseFormOldMap, Map<Id,ESC_Case_Form_Extension__c > caseFormNewMap){
           ESC_CaseFormExtension.ValidateRequesttype(caseFormOldMap,caseFormNewMap);
        }  
      /**
     * @description onAfterUpdate
     * @param caseformList
     * @param caseFormOldMap
     */   
     public static void onAfterUpdate( List<ESC_Case_Form_Extension__c > caseformList, Map<Id,ESC_Case_Form_Extension__c > caseFormOldMap){
      if(MasterCaseTriggerRecursiveCheck.checkRecursiveForforms){
           ESC_CaseFormExtension.caseUpdUpdate(caseformList,caseFormOldMap);
      }     
           ESC_CaseFormExtension.ChargeCancellationChatter(caseformList,caseFormOldMap);
        }
       /**
     * @description onAfterUpdate2
     * @param caseFormNewMap
     * @param caseFormOldMap
     */     
     public static void onAfterUpdate2( Map<Id,ESC_Case_Form_Extension__c > caseFormNewMap, Map<Id,ESC_Case_Form_Extension__c > caseFormOldMap){
           
           if(MasterCaseTriggerRecursiveCheck.checkRecursiveForWriteOff)
        {
            ESC_CaseFormExtension.writeOffFormUpdate(caseFormNewMap,caseFormOldMap);
        }
            
        if(MasterCaseTriggerRecursiveCheck.checkRecursiveForCC )
        {
                ESC_CaseFormExtension.CCFormUpdate(caseFormNewMap,caseFormOldMap);
        }
        
        }   
           
              
    }