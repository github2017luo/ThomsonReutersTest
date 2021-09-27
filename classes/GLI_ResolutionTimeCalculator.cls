public without sharing class GLI_ResolutionTimeCalculator{

   @InvocableMethod(label='GLI_getCaseResolutionTimeCalc')
    public static void getCaseResolutionTime(List<id> idcases){
    Id casebusinesshrid;
      if(idcases == null || idcases.isEmpty())
            return;
            
       List<GLI_Case_SLA_Matrix__c> GLiCaseSLAMatrix = GLI_Case_SLA_Matrix__c.getall().values();
       List<Case> caseList= new List<Case>();
      for(Case si:[Select GLI_Milestone_Reference_Date__c,GLI_Resolution_Response_Time_Flag__c,ESC_Reopen_Case__c,id,ESC_Case_Type__c,Priority,BusinessHoursId,GGO_Case_Response_Time__c,CreatedDate from Case WHERE id IN:idcases]){
          for(GLI_Case_SLA_Matrix__c gcsm: GLiCaseSLAMatrix){
           Integer SLAmin;
            if(si.ESC_Case_Type__c == gcsm.Case_Type__c && si.Priority== gcsm.Priority__c){
            SLAmin = Integer.valueOf(gcsm.Resolution_SLA__c)*60;
            Decimal usedTime=0;
             //if(si.ESC_Reopen_Case__c== False){
              casebusinesshrid = si.BusinessHoursId;
              if(si.GLI_Milestone_Reference_Date__c!= null){
                system.debug('case casebusinesshrid &&&:'+casebusinesshrid);
                si.GGO_Case_Response_Time__c =businesshours.add(casebusinesshrid,si.GLI_Milestone_Reference_Date__c,SLAmin*60*1000L);
              }
              else
              {
                si.GGO_Case_Response_Time__c =businesshours.add(casebusinesshrid,si.CreatedDate,SLAmin*60*1000L);
              }
             // }
          
               if( si.GLI_Resolution_Response_Time_Flag__c != true)
               si.GLI_Resolution_Response_Time_Flag__c =true;
               caseList.add(si);
               break;
            }
         
         }
            
        }
        
       if(caseList.size()>0){
            update caseList;
       }
}

public static void CaseResolutionTimefromTrigger(Map<id,Case> oldMAp,Map<id,Case> newMap){
    List<Case> caslist = new List<Case>();
    List<id> idcases = new List<Id>();
    Id casebusinesshrid;
    for(id csid: newMap.keySet()){
       if(newMap.get(csid).IS_ESC_Case__c== True && newMap.get(csid).LCRM_Sub_BU__c== 'UKI' && newMap.get(csid).IS_GLI__c== True && oldMap.get(csid).Status == 'New' && newMap.get(csid).Status == 'Work In Progress' && newMap.get(csid).GGO_Case_Response_Time__c == null){
         caslist.add(newMap.get(csid));
       }
     
     }
     
      if(casList.size()>0) { 
      
       List<GLI_Case_SLA_Matrix__c> GLiCaseSLAMatrix = GLI_Case_SLA_Matrix__c.getall().values();
       List<Case> caseList= new List<Case>();
        for(Case si:caslist){
          for(GLI_Case_SLA_Matrix__c gcsm: GLiCaseSLAMatrix){
           Integer SLAmin;
            if(si.ESC_Case_Type__c == gcsm.Case_Type__c && si.Priority== gcsm.Priority__c){
             SLAmin = Integer.valueOf(gcsm.Resolution_SLA__c)*60;
             casebusinesshrid = si.BusinessHoursId;
              if(si.GLI_Milestone_Reference_Date__c!= null){
                 si.GGO_Case_Response_Time__c =businesshours.add(casebusinesshrid,si.GLI_Milestone_Reference_Date__c,SLAmin*60*1000L);
                 system.debug('si.GGO_Case_Response_Time__c***trigger***'+si.GGO_Case_Response_Time__c);
              }
              else
              {
               si.GGO_Case_Response_Time__c =businesshours.add(casebusinesshrid,si.CreatedDate,SLAmin*60*1000L);
              }
               if( si.GLI_Resolution_Response_Time_Flag__c != true)
               si.GLI_Resolution_Response_Time_Flag__c =true;
               system.debug('si.GGO_Case_Response_Time__c****'+si.GGO_Case_Response_Time__c);
               break;
               
            }
         
         }
            
        }
       }
        
      
}



}