trigger OptyTeamMemberBeforeInsertUpdate on OpportunityTeamMember (before insert, before update) {

    //LTS_6268 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
      
     if(Boolean.valueOf(System.Label.LCRMGLIOpportunityLoadTriggerFlag) == False){//Added for CRM-14346
        if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
      if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        List<Id> opportunityIds = new List<Id>();
        List<Id> userIds = new List<Id>();
        for(OpportunityTeamMember opTeam: Trigger.New){
            opportunityIds.add(opTeam.OpportunityId);
            userIds.add(opTeam.UserId);
        }
        
        Map<Id, User> userMap = new Map<Id, User>([Select id, Name from User where Id IN: userIds]);
        
        // Get All Opportunity Team members from Opportunity
        Map<Id, list<OpportunityTeamMember>> oppTeamsMap = new Map<Id, list<OpportunityTeamMember>>();
        oppTeamsMap = OptyTeamMember.getOppTeams(opportunityIds);

        // Get All Opportunity Price List from Opportunity
        Map<Id, list<Opportunity_Product_Type__c>> oppPriceMap = new Map<Id, list<Opportunity_Product_Type__c>>();
        oppPriceMap = OptyTeamMember.getOppPriceList(opportunityIds);

        List<Opportunity_Product_Type__c> oppPriceList = new List<Opportunity_Product_Type__c>();

        for(OpportunityTeamMember opTeam: Trigger.New){
            oppPriceList = oppPriceMap.get(opTeam.OpportunityId);

            if(opTeam.Hoopla_Secondry__c == true){
                List<OpportunityTeamMember> oppTeams = oppTeamsMap.get(opTeam.OpportunityId);
                boolean hooplaSecCheck = false;
                if(oppTeams != NULL){
                    for(OpportunityTeamMember oppTeam: oppTeams){
                        if(oppTeam.Hoopla_Secondry__c == true){
                            hooplaSecCheck = true;
                        }
                    }
                }
                if(hooplaSecCheck == true){
                    opTeam.addError('ONLY ONE HOOPLA TEAM MEMBER CAN BE ADDED');
                }else{
                    String selectedUser = userMap.get(opTeam.UserId).Name + ' ' + string.valueOf((opTeam.LastModifiedDate).format()) ;
                    opTeam.Hoopla_Secondary__c = selectedUser;                   
                    if( oppPriceList != NULL ){
                        for(Opportunity_Product_Type__c opprice: oppPriceList){
                            opprice.Hoopla_Secondary__c = selectedUser;
                        }
                    }
                }
            }else{
                opTeam.Hoopla_Secondary__c = NULL;
                if( oppPriceList != NULL ){
                    for(Opportunity_Product_Type__c opprice: oppPriceList){
                        opprice.Hoopla_Secondary__c = NULL;
                    }
                }
            }   
        }
        if(oppPriceList != NULL){
            update oppPriceList;
        }
    }
     }
   }
}