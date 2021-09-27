/**
     * @description Corp_IP_AcceptanceTimeCalculator
     *
     */
    public without sharing class Corp_IP_AcceptanceTimeCalculator{
        @InvocableMethod(label='Corp IP Acceptance Time Calculator')
         /**
         * @description getCaseAcceptanceTime
         * @param cases
         */
        public static void getCaseAcceptanceTime(List<Case> cases){
            List<String> serverityList = new List<String>();
            List<String> supportList = new List<String>();        
            
            
            for(Case si:cases){            
                if(si.ESC_Severity__c == null || si.ESC_Severity__c == '' || si.ESC_Severity__c == '4 - Non-Service Affecting' || si.ESC_Case_Type__c == 'Request for Action'){
                    serverityList.add('Null');
                }
                else{
                    serverityList.add(si.ESC_Severity__c);
                }
                if(si.ESC_Support_Level__c == null || si.ESC_Support_Level__c == ''){
                    supportList.add('Standard');
                }
                else{
                    supportList.add(si.ESC_Support_Level__c);
                }
            }
            
            system.debug(LoggingLevel.WARN,'support list is'+supportlist+'*****'+serverityList);
            updateCase(supportList,serverityList,cases);
        }
        
        private static void updateCase(List<string> supportList,List<string> serverityList,List<case> cases){
            List<Case> lstupdatecase = new List<case>();
            List<Corp_IP_SLA_Matrix__c> sLAList = new List<Corp_IP_SLA_Matrix__c>();
            Integer sLAmins;
            if(Schema.sObjectType.Corp_IP_SLA_Matrix__c.isAccessible() || Schema.sObjectType.Corp_IP_SLA_Matrix__c.isQueryable())     {
                sLAList = [Select ESC_Acceptance_SLA__c from Corp_IP_SLA_Matrix__c where ESC_Severity__c IN:ServerityList and ESC_Support_Level__c IN:SupportList and ESC_Acceptance_SLA__c!=''];
            } 
            
                for(Corp_IP_SLA_Matrix__c sla : sLAList){
                    if(sla.ESC_Acceptance_SLA__c != null){
                        sLAmins = Integer.valueOf(sla.ESC_Acceptance_SLA__c);
                    }
                    
                }
                if(SLAList.size()>0 ){
                    for(Case c:cases){
                        Case cs=new Case();
                        cs.id=c.id;             
                        cs.GLI_First_Response_Time__c = businesshours.add(c.BusinessHoursId,c.createddate,SLAMins*60*1000L); 
                        cs.ESC_Case_Acceptance_Entry_Flag__c = true;                                                 
                        lstupdatecase.add(cs);
                    }
                }
                if(lstupdatecase.size()>0 && Schema.sObjectType.Case.isUpdateable() ){
                    update lstupdatecase;
                }
        }
    }