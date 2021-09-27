public class LCRMCancelEmailTemplateController {
    public Id opptyId {get;set;}
    public integer NoOfDays{get;set;}
    public String templateFrom {get;set;}
    public string url{get;set;}
    public boolean approvalTemplate {get;set;}
    public boolean chkStartDate{get;set;}
    public boolean chkEndDate{get;set;}
    public boolean chkExpDate{get;set;}
    //List<Opportunity> oppty = new List<Opportunity>();
    public List<Opportunity> getoppty()
    {
        List<Opportunity> oppty;
        oppty = [SELECT Id, Name, Owner.Manager.Name, Owner.Name,Account.Name, StageName, LCRM_Transaction_Type__c, 
                 Expected_End_Date__c, Expected_Start_Date__c, LCRM_Total_Current_ACV__c,
                 Expiration_Date__c, LCRM_Incremental_percent__c,(select id, name from OpportunityLineItems)
                 FROM Opportunity WHERE id =: opptyId];
        
       if(oppty[0].Expiration_Date__c <> null){
           NoOfDays = date.today().daysBetween(oppty[0].Expiration_Date__c);
           chkExpDate=true;
       }else{
           chkExpDate=false;
       }
        
        
        if(oppty[0].Expected_Start_Date__c<> null){
            chkStartDate = true;
        }else{
            chkStartDate = false;
        }
        
        if(oppty[0].Expected_End_Date__c <> null){
            chkEndDate=true;
        }else{
            chkEndDate=false;
        }
        if(templateFrom == 'Approval'){
            approvalTemplate = true;
        }else{
            approvalTemplate = false;
        }
        
     List<ProcessInstanceWorkitem> workItemLst =   
        [  SELECT id  
      FROM ProcessInstanceWorkitem  
      WHERE processInstance.TargetObjectId=:opptyId];   
        
      if(workItemLst.size() > 0)  
      {  
         
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost() +   
         '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + workItemLst[0].id;      
     }  
       
    system.debug('@@ URL' + url);

        
        return oppty;
    }
    
     /* public OpportunityLineItem[] getSorted() {
        if (oppty == null || oppty.opportunityLineItems== null) {
            return null;
        }
        
        // TODO: Add your sorting logic here (demo just reverses the list)
        OpportunityLineItem[] result = new OpportunityLineItem[1];
        for (OpportunityLineItem item : oppty.opportunityLineItems) {
            result.add(0, item);
        }
        
        return result;
   }*/

}