public without sharing class Elite_EBH_AcceptanceTimeCalculator{
    @InvocableMethod(label='Elite EBH Acceptance Time Calculator')
    public static void getCaseAcceptanceTime(List<Case> cases){
    
        List<String> ServerityList = new List<String>();
        List<Case> lstupdatecase = new List<case>();
        List<Corp_IP_SLA_Matrix__c> SLAList = new List<Corp_IP_SLA_Matrix__c>();
        Integer SLAmins;
        
        for(Case si:cases){            
            if(si.ESC_Severity__c == null || si.ESC_Severity__c == '' || si.ESC_Severity__c == '4 - Non-Service Affecting'){
                ServerityList.add('Null');
            }
            else{
                ServerityList.add(si.ESC_Severity__c);
            }
            
        }
        
        system.debug('support list is'+'*****'+ServerityList);
        if(Schema.sObjectType.Corp_IP_SLA_Matrix__c.isAccessible() || Schema.sObjectType.Corp_IP_SLA_Matrix__c.isQueryable())        
        SLAList = [Select ESC_Acceptance_SLA__c from Corp_IP_SLA_Matrix__c where ESC_Severity__c IN:ServerityList and ESC_Support_Level__c =''];
        for(Corp_IP_SLA_Matrix__c sla : SLAList){
            if(sla.ESC_Acceptance_SLA__c != null)
            SLAmins = Integer.valueOf(sla.ESC_Acceptance_SLA__c);
        }
        if(SLAList.size()>0){
            for(Case c:cases){
                Case cs=new Case();
                cs.id=c.id;             
                cs.GLI_First_Response_Time__c = businesshours.add(c.BusinessHoursId,c.createddate,SLAMins*60*1000L); 
                cs.ESC_Case_Acceptance_Entry_Flag__c = true;                                                 
                lstupdatecase.add(cs);
            }
        }
        if(lstupdatecase.size()>0 ){
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable()){
            update lstupdatecase;
        }
            
        }
    }
}