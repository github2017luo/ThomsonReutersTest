public with sharing class APTS_GroupTriggerHelper {
    
    //This method will update Group Apporval Required field on product configuration for 'West Complete Library Sub' 
    public static void updateGroupRequired(List<APTS_Group__c> grouplist){
        
        Map<id,Apttus_Config2__ProductConfiguration__c> pcMap = new Map<id,Apttus_Config2__ProductConfiguration__c>();        
        Apttus_Config2__ProductConfiguration__c pc;        
        for(APTS_Group__c gr : grouplist) {
            if(gr.APTS_Primary_Material__c == 'West Complete Library Sub' && gr.APTS_ProductConfiguration__c != null) {
                if(gr.Group_Approval_Required__c && (!pcMap.keySet().contains(gr.APTS_ProductConfiguration__c) || (pcMap.keySet().contains(gr.APTS_ProductConfiguration__c) && pcMap.get(gr.APTS_ProductConfiguration__c).Group_Approval_Required__c==false))) {
                    System.debug('Inside if'+gr.APTS_ProductConfiguration__c);
                    pc = new Apttus_Config2__ProductConfiguration__c(id=gr.APTS_ProductConfiguration__c, Group_Approval_Required__c = True);
                    pcMap.put(gr.APTS_ProductConfiguration__c, pc);                    
                    System.debug('Inside if pcMap'+pcMap);                    
                } 
                else {
                    if(!pcMap.keySet().contains(gr.APTS_ProductConfiguration__c)){
                    pc = new Apttus_Config2__ProductConfiguration__c(id=gr.APTS_ProductConfiguration__c, Group_Approval_Required__c = False);
                    pcMap.put(gr.APTS_ProductConfiguration__c, pc);                    
                    System.debug('Inside if pcMap'+pcMap);                    
                    }
                    
                }
            }
        }
        
        
        
        if(pcMap.Size()>0) {
            update pcMap.values();
        }
    }
}