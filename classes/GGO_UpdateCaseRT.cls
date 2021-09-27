public class GGO_UpdateCaseRT{
      @InvocableMethod(label='GGO RTI Calculation')
      public static void getCaseRTI(List<Case> cases){
    
        if(cases == null || cases.isEmpty())
            return;
        
        List<Case> lstupdatecase = new List<Case>();
         
        GGO_Case_SLA_Matrix__c initialMileStoneDataSet = GGO_Case_SLA_Matrix__c.getValues('MilestoneSLA');
        
            if(initialMileStoneDataSet != null){
                Integer SLAmins = Integer.valueOf(initialMileStoneDataSet.GGO_SLA__c);
                  
                for(Case c:cases){
                    Case cs = new Case();
                    cs.id=c.id;
                    cs.ESC_Response_Time__c= businesshours.add(c.BusinessHoursId,System.now(),SLAMins*60*1000L);
                    lstupdatecase.add(cs);
                }
      }
        if(lstupdatecase.size()>0)
            update lstupdatecase;
        
    }
 }