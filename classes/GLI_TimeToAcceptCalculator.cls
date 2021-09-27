public without sharing class GLI_TimeToAcceptCalculator{
    @InvocableMethod(label='GLI_getCaseTimeToAcceptCalc')
    public static void getCaseTimeToAccept(List<id> idcases){
    Id casebusinesshrid;
    
      if(idcases == null || idcases.isEmpty())
            return;
        
      
      
       List<GLI_Case_SLA_Matrix__c> GLiCaseSLAMatrix = GLI_Case_SLA_Matrix__c.getall().values();
       List<Case> caseList= new List<Case>();
       for(Case si:[Select id,ESC_Case_Type__c,Priority,ESC_Response_Time__c,CreatedDate,GLI_Milestone_Reference_Date__c,BusinessHoursId from Case WHERE id IN:idcases]){
          for(GLI_Case_SLA_Matrix__c gcsm: GLiCaseSLAMatrix){
           Integer SLAmin;
           system.debug('ESC_Response_Time__c before***'+si.ESC_Response_Time__c);
           system.debug('CreatedDate ***'+si.CreatedDate);
            if(si.ESC_Case_Type__c == gcsm.Case_Type__c && si.Priority== gcsm.Priority__c){
            SLAmin = Integer.valueOf(gcsm.Accept_SLA__c)*60;
            casebusinesshrid = si.BusinessHoursId;                     
            system.debug('case casebusinesshrid &&&:'+casebusinesshrid);
            si.ESC_Response_Time__c=businesshours.add(casebusinesshrid,si.GLI_Milestone_Reference_Date__c,SLAmin*60*1000L);
            si.GLI_First_Response_Time__c=businesshours.add(casebusinesshrid,si.GLI_Milestone_Reference_Date__c,SLAmin*60*1000L);
            si.ESC_Case_Acceptance_Entry_Flag__c = true;
            caseList.add(si);
            system.debug('ESC_Response_Time__c after***'+si.ESC_Response_Time__c);
            break;
            }
         
         }
            
        }
        system.debug('CaseList***'+caseList);
       
        
       if(caseList.size()>0){
         if(Schema.sObjectType.case.isAccessible() || Schema.sObjectType.case.isUpdateable()){
            update caseList;
            }
       }
}

   


}