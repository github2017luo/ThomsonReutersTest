public class GGO_ResponseTimeCalculator{

    @InvocableMethod(label='GGO Case Entitlment Respones Time Calc_1234')
    public static void getCaseResponseTime(List<Case> cases){
    
        if(cases == null || cases.isEmpty())
            return;
            
        List<String> Diagnosislst= new List<String>(); 
        List<String> ServerityList = new List<String>();
        List<Case> lstupdatecase = new List<case>();
        List<String> ReferralQueuelst = new List<String>();
        List<Boolean> IsReferalFlag = new List<Boolean>();
        List<GGO_Case_SLA_Matrix__c> lstvs;    
        Id referralbusinesshrid;
        Id closurebusinesshrid;
        
        system.debug('CaseList'+cases);
        for(Case si:cases){
               Diagnosislst.add(si.ESC_Diagnosis_Summary__c);
               if(si.ESC_Severity__c == null || si.ESC_Severity__c == ''){
               ServerityList.add('Null');
               }
               else{
               ServerityList.add(si.ESC_Severity__c);
               }
               
            if(si.GGOIsReferralFlag__c){
               ReferralQueuelst.add(si.GGO_Referral_Milestone_Type__c);
               IsReferalFlag.add(si.GGOIsReferralFlag__c);
            }
        }
        
        if(ServerityList.size()>0 && Diagnosislst.size()>0){
            if(IsReferalFlag.Size()>0){
          
            lstvs = [select GGO_SLA__c from GGO_Case_SLA_Matrix__c where GGO_Diagnosis__c IN :ReferralQueuelst and SeverityType__c IN :ServerityList];
            system.debug('lstvs is'+lstvs);
         }
        else{
            lstvs = [select GGO_SLA__c from GGO_Case_SLA_Matrix__c where GGO_Diagnosis__c IN :Diagnosislst and SeverityType__c IN :ServerityList];
        }                
        Integer SLAmins;
        for(GGO_Case_SLA_Matrix__c SLA:lstvs){
            if(SLA.GGO_SLA__c!=null){
                SLAmins = Integer.valueOf(SLA.GGO_SLA__c);
            }
        }
        system.debug('SLA mins is'+SLAMins);
        

        if(lstvs.size()>0){
             for(Case c:cases){
                Case cs=new Case();
                 cs.id=c.id;
                 if(IsReferalFlag.Size()>0){
                     referralbusinesshrid = c.BusinessHoursId;
                     system.debug('referral business id'+referralbusinesshrid);                
                     cs.GGO_Referral_Response_Time__c = businesshours.add(referralbusinesshrid,System.now(),SLAMins*60*1000L);
                     //cs.GGO_Referral_Response_Time__c=c.CreatedDate.addMinutes(SLADays);
                 }
                 else {
                     closurebusinesshrid = c.BusinessHoursId;                     
                     system.debug('case ckosure business id'+closurebusinesshrid );
                     cs.GGO_Case_Response_Time__c=businesshours.add(closurebusinesshrid,c.CreatedDate,SLAMins*60*1000L);
                     //cs.GGO_Case_Response_Time__c=c.CreatedDate.addMinutes(SLAMins);
                     cs.ESC_CustHoldTimeCheck__c=true;
                    }
                lstupdatecase.add(cs);
            }
        }
    }
    if(lstupdatecase.size()>0){
        update lstupdatecase;
    }
}
}