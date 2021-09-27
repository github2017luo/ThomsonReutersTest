/**
     * @description Justdesc
     *
     */
public without sharing class CaseLines_Closure_Time_Calculator{

 @InvocableMethod(label='CaseLines Closure Time Calculator')
 /**
     * @description Justdesc
     * @param cases
     */
    public static void getCaseClosureTime(List<Case> cases){
        List<String> serverityList = new List<String>();
        List<String> supportList = new List<String>();        
        
        for(Case si:cases){            
            if(si.ESC_Severity__c == null || si.ESC_Severity__c == '' || si.ESC_Severity__c == '4 - Non-Service Affecting' || si.ESC_Case_Type__c == 'Request for Action'){
                ServerityList.add('Null');
            }
            else{
                ServerityList.add(si.ESC_Severity__c);
            }
            
        }
        supportList = getSupportList(cases);
        updateSLAOnCase(serverityList,supportList,cases);
    }
    private static List<string> getSupportList(List<case> cases){
    List<String> supportList = new List<String>(); 
    ESC_CaseLinesSupportLevel__c suppLevel;
        for(Case si:cases){
        if(si.suppliedEmail!=null){
            suppLevel= ESC_CaseLinesSupportLevel__c.getInstance(si.suppliedEmail.toLowerCase().subStringBefore('@'));
         }
            if(suppLevel!=null && si.origin =='Email'){
                supportList.add(suppLevel.ESC_Support_Level__c);
            }
            else if(si.ESC_Support_Level__c == null || si.ESC_Support_Level__c == ''){
                SupportList.add('Standard');
            }
            else{
                SupportList.add(si.ESC_Support_Level__c);
            }
        }
        
        return supportList;
    }
    private static void updateSLAOnCase(List<string> serverityList,List<string> supportList,List<case> cases){

        List<Case> lstupdatecase = new List<case>();
        List<Corp_IP_SLA_Matrix__c> sLAList = new List<Corp_IP_SLA_Matrix__c>();
        Integer sLAmins;
        if(Schema.sObjectType.Corp_IP_SLA_Matrix__c.isAccessible() || Schema.sObjectType.Corp_IP_SLA_Matrix__c.isQueryable())        
        {
            SLAList = [Select ESC_Closure_SLA__c from Corp_IP_SLA_Matrix__c where ESC_Acceptance_SLA__c='' AND ESC_Severity__c IN:ServerityList and ESC_Support_Level__c IN:SupportList];
        
        }
            for(Corp_IP_SLA_Matrix__c sla : SLAList){
            if(sla.ESC_Closure_SLA__c!= null){
                SLAmins = Integer.valueOf(sla.ESC_Closure_SLA__c);
            }
        }
        for(Case c:cases){
                Case cs=new Case();
                cs.id=c.id;             
                cs.GGO_Case_Response_Time__c = businesshours.add(c.BusinessHoursId,c.createddate,SLAMins*60*1000L); 
                cs.USL_Case_closure_flag__c = true;                                                 
                lstupdatecase.add(cs);
            }
        
        if(lstupdatecase.size()>0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
            update lstupdatecase;
        }
    }

}