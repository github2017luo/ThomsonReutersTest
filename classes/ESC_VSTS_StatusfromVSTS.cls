public class ESC_VSTS_StatusfromVSTS{
    
    /*
    This method will be invoked by VSTS Staging object when the Last status in Staging table is updated by ESI/VSTS
    */
    
    @InvocableMethod(label='VSTS Status Update' description='VSTS Status Update Chatter Update SF')
    public static void VSTSStatusUpdate(List<ESC_VSTS_Staging__c> VSTSStaging)
    {
        system.debug('inside 34');
        //if list is empty lets keep it nothing
        if(VSTSStaging == null || VSTSStaging.isEmpty())
            return;
        List<String> caseIdList = new List<String>();
        Map<String,Case> CaseMap= new Map<String,Case>();
        Map<String,List<ESC_Case_Collaborator__c>> RefMap= new Map<String,List<ESC_Case_Collaborator__c>>();
        List<ESC_Case_Collaborator__c> ReferUPDlist = new List<ESC_Case_Collaborator__c>();
        List<Case> caseUpdList= new List<Case>();
        
        for(ESC_VSTS_Staging__c vi:VSTSStaging){
                caseIdList.add(vi.ESC_Case_Number__c);
            }
        
         if(caseIdList.size()>0){
        
            for(Case cs: [select id,CaseNumber,Status,ESC_VSTS_Id__c,GGO_VSTS_ReferralClosed__c,(select id,name,ESC_Case__c,ESC_Referral_Status__c,OwnerId,Owner.Name from Case_Collaborations__r where Owner.Name IN :Label.ESC_VSTS_QueueName.Split(',') and ESC_Referral_Status__c != 'Completed') from Case where CaseNumber IN :caseIdList])
                {  
                    CaseMap.put(cs.CaseNumber,cs);
                    RefMap.put(cs.CaseNumber,cs.Case_Collaborations__r);
                }
        }
        
       List<String> resolvedStatus = System.Label.ESC_VSTS_Status.split(',');
       if(resolvedStatus.size()>0){
         for(ESC_VSTS_Staging__c VSTS:VSTSStaging){
                if(resolvedStatus.contains(VSTS.ESC_Last_Statusfrom_VSTS__c)){
                    system.debug(vsts.ESC_Case_Number__c);
                    for(ESC_Case_Collaborator__C ref: RefMap.get(vsts.ESC_Case_Number__c)){
                     ref.ESC_Referral_Status__c = 'Completed';
                     ReferUPDlist.add(ref);
                    }
                    Case cs1=CaseMap.get(vsts.ESC_Case_Number__c); 
                    cs1.GGO_VSTS_ReferralClosed__c=true;
                    caseUpdList.add(cs1);
                }
            } 
        }
        
    
    
      if(ReferUPDlist.size()>0)
      update ReferUPDlist;
      
      if(caseUpdList.size()>0)
      update caseUpdList;
       
}
    
}