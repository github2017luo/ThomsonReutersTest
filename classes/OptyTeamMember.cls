public with sharing class OptyTeamMember {

   
    // Get Opportunity Team members from Opportunity Ids
    public static Map<Id, list<OpportunityTeamMember>> getOppTeams(List<Id> oppIds){
        Map<Id, list<OpportunityTeamMember>> oppTeamMap = new Map<Id, list<OpportunityTeamMember>>();
        for(OpportunityTeamMember oppTeam: [Select id, OpportunityId, Hoopla_Secondry__c, Hoopla_Secondary__c from OpportunityTeamMember where OpportunityId IN: oppIds]){
            List<OpportunityTeamMember> oppTeamList ;
            if( oppTeamMap.get(oppTeam.OpportunityId) == null ){
                oppTeamList = new List<OpportunityTeamMember>();
            }else {
                oppTeamList = oppTeamMap.get(oppTeam.OpportunityId);
            }
            oppTeamList.add(oppTeam);
            oppTeamMap.put(oppTeam.OpportunityId, oppTeamList);
        }
        return oppTeamMap;
    }

    // Get Opportunity Pricing from Opportunities
    public static Map<Id, list<Opportunity_Product_Type__c>> getOppPriceList(List<Id> oppIds){
        Map<Id, list<Opportunity_Product_Type__c>> oppPriceMap = new Map<Id, list<Opportunity_Product_Type__c>>();
        for(Opportunity_Product_Type__c oppPrice: [Select id, Name, Opportunity__c, Hoopla_Secondary__c from Opportunity_Product_Type__c where Opportunity__c IN: oppIds]){
            List<Opportunity_Product_Type__c> oppPriceList ;
            if( oppPriceMap.get(oppPrice.Opportunity__c) == null ){
                oppPriceList = new List<Opportunity_Product_Type__c>();
            }else {
                oppPriceList = oppPriceMap.get(oppPrice.Opportunity__c);
            }
            oppPriceList.add(oppPrice);
            oppPriceMap.put(oppPrice.Opportunity__c, oppPriceList);
        }
        return oppPriceMap;
    }
}