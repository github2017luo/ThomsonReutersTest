/**
     * @description Corp_IP_ResponseTimeCalculator
     *
     */
    public without sharing class Corp_IP_ResponseTimeCalculator{
        @InvocableMethod(label='Corp IP Response Time Calculator')
        /**
         * @description getCaseResponseTime
         * @param cases
         */
        public static void getCaseResponseTime(List<Case> cases){
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
            if(Schema.sObjectType.Corp_IP_SLA_Matrix__c.isAccessible() || Schema.sObjectType.Corp_IP_SLA_Matrix__c.isQueryable())   
                {
                    sLAList = [Select ESC_Closure_SLA__c from Corp_IP_SLA_Matrix__c where ESC_Severity__c IN:ServerityList and ESC_Support_Level__c IN:supportList and ESC_Acceptance_SLA__c !=''];
                }
            
                for(Corp_IP_SLA_Matrix__c sla : sLAList){
                    if(sla.ESC_Closure_SLA__c != null){
                        sLAmins = Integer.valueOf(sla.ESC_Closure_SLA__c);
                    }
                    
                }
                if(sLAList.size()>0){
                    for(Case c:cases){
                        Case cs=new Case();
                        cs.id=c.id;             
                        cs.GGO_Case_Response_Time__c = businesshours.add(c.BusinessHoursId,c.createddate,SLAMins*60*1000L); 
                        cs.USL_Case_closure_flag__c = true;                                                 
                        lstupdatecase.add(cs);
                    }
                }
                if(lstupdatecase.size()>0 && Schema.sObjectType.Case.isUpdateable() ){
                    update lstupdatecase;
                }
        }
    }