/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                Description
 * 2014-09-04   Nandita Shet        MCL-647 Sales Percentage cannot exceed 100%
                                    for Latam (method SalesPercentageValidation)
 *                                                
 * =============================================================================
 */


trigger OptyTeamMemberBeforeEventListener on OpportunityTeamMember (Before Update, Before Insert) {

    //LTS_6268 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}

 if(Boolean.valueOf(System.Label.LCRMGLIOpportunityLoadTriggerFlag) == False){//Added for CRM-14346
     List<OpportunityTeamMember> listOptySalesTeam = new List<OpportunityTeamMember>();   
    
    if(trigger.IsUpdate && !OptyTeamMemberTriggerHandler.bflag){
        OptyTeamMemberTriggerHandler.SyncUserQuota(trigger.new,false);
    }
    
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
    
        //DPS-19249 Opportunity Team - Users Cannot Assign Multiple Partner Users to the same Partner Role.
        OptyTeamMemberTriggerHandler.validateDuplicatePartnerRoles(trigger.isUpdate, trigger.new, trigger.OldMap);
        
    }

   if(Trigger.IsUpdate){
    for(OpportunityTeamMember OptySalesTeam : trigger.new){
      if(OptySalesTeam.Sales_Percentage__c!=null && OptySalesTeam.Sales_Percentage__c > 100){
       OptySalesTeam.addError('Sales Percentage must equal 100%.');
       
      }else if(OptySalesTeam.Sales_Percentage__c != trigger.oldmap.get(OptySalesTeam.Id).Sales_Percentage__c){
        listOptySalesTeam.add(OptySalesTeam);
      }
    
    }
    if(!listOptySalesTeam.IsEmpty()){
          OptyTeamMemberTriggerHandler.SalesPercentageValidation(listOptySalesTeam);
       } 
   
   }  
  /*for (OpportunityTeamMember OptySalesTeam : trigger.new){
      List<OpportunityTeamMember> OptySalesTeam = new List<OpportunityTeamMember>();   
      
      if(OpportunityTeamMember.Sales_Percentage__c != trigger.oldmap.get(OpportunityTeamMember.Sales_Percentage__c)){
          OptySalesTeam .add(OpportunityTeamMember);
      }
      
      if(!OptySalesTeam.IsEmpty()){
          OptyTeamMemberTriggerHandler.checkSalesPercentage(OptySalesTeam);
       } 
  }*/
 
 }

}