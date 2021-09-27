trigger OptyProdTypeBeforeInsert on Opportunity_Product_Type__c (before insert) {

    if(Trigger.isBefore && Trigger.isInsert ){
        List<Id> opportunityIds = new List<Id>();
        for(Opportunity_Product_Type__c opPrice: Trigger.New){
            opportunityIds.add(opPrice.Opportunity__c);
        }

        // Get All Opportunity Team members from Opportunity
        Map<Id, list<OpportunityTeamMember>> oppTeamsMap = new Map<Id, list<OpportunityTeamMember>>();
        oppTeamsMap = OptyTeamMember.getOppTeams(opportunityIds);

        for(Opportunity_Product_Type__c opPrice: Trigger.New){
            List<OpportunityTeamMember> oppTeams = oppTeamsMap.get(opPrice.Opportunity__c);
            if(oppTeams != NULL){
                for(OpportunityTeamMember oppTeam: oppTeams){
                    if(oppTeam.Hoopla_Secondry__c == true){
                        opPrice.Hoopla_Secondary__c = oppTeam.Hoopla_Secondary__c;
                    }
                }
            }
        }
    }
}