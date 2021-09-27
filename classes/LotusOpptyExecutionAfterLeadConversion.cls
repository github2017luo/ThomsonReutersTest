Public Without Sharing Class LotusOpptyExecutionAfterLeadConversion{
    
    //Method is used to add opportunity team member after lead conversion
    Public  static void addOpportunityMemberAfterLeadConversion(List<opportunity> opptyList){
        set<String> leadIdsSet = new set<String>();
        //set<Id> OppIdsSet = new set<Id>();
        // Map<String,Id>LeadOwnerMap = new Map<String,Id>();
        //Map<Id,Id>opptyownerMap = new Map<Id,Id>();
        List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
        for(Opportunity opp : opptyList){
            
            if(opp.is_gli__c == true && String.isnotblank(opp.Lead_ID__c)){
                
                //opptyownerMap.put(opp.Id,opp.ownerId):
                OpportunityTeamMember opptyteam = new OpportunityTeamMember();
                opptyteam.OpportunityId = opp.Id;
                opptyteam.UserId = opp.ownerId;
                opptyteam.TeamMemberRole = 'Sales Rep';
                opptyteam.OpportunityAccessLevel = 'Edit';
                opptyTeamMemberList.add(opptyteam);
                system.debug('opptyTeamMemberList'+opptyTeamMemberList.size());
                
                
            }
        }
        /* if(Schema.sObjectType.LM_Lead_History__c.isQueryable()){
for(LM_Lead_History__c lmRecord : [SELECT Id, Account_ID__c,
Contact_ID__c, LeadID18__c,Lead_ID__c,
Lead_Type__c, Lead__c,Opportunity_ID__c, Lead_Owner__c, 
Lead_Source__c FROM LM_Lead_History__c 
WHERE Lead_ID__c IN : leadIdsSet
]){

LeadOwnerMap.put(lmRecord.Lead_ID__c,lmRecord.Lead__r.ownerId);
system.debug('LeadOwnerMap'+LeadOwnerMap.size());
system.debug('LeadOwnerMap@@@@'+LeadOwnerMap);


}
}

for(Opportunity oppRec : opptyList){
if(leadIdsSet.contains(oppRec.Lead_ID__c) && LeadOwnerMap.containsKey(oppRec.Lead_ID__c)){
OpportunityTeamMember opptyteam = new OpportunityTeamMember();
opptyteam.OpportunityId = oppRec.Id;
opptyteam.UserId = LeadOwnerMap.get(oppRec.Lead_ID__c);
opptyteam.TeamMemberRole = 'Sales Rep';
opptyteam.OpportunityAccessLevel = 'Edit';
opptyTeamMemberList.add(opptyteam);
system.debug('opptyTeamMemberList'+opptyTeamMemberList.size());
}

} */
        if(opptyTeamMemberList.size() > 0 ){
            insert opptyTeamMemberList;
        }
        
        
        
    }
    Public  static void addCampaignDetails(Lead leadRec){
        
        List<opportunity> opptyList = new List<opportunity>();
        if(leadRec != null){
            if(leadRec.convertedopportunityId != null){
                opportunity opp = new opportunity();
            
                opp.id = leadRec.convertedopportunityId;
            
            
            if(String.isNotBlank(leadRec.leadSource)){
                opp.Source__c = leadRec.leadSource;
            }
            
            if(String.isNotBlank(leadRec.primary_campaign_source__c)){
                opp.CampaignID = leadRec.primary_campaign_source__c;
            }
            
               opptyList.add(opp);
            }
        }
          if(opptyList.size() > 0){ 
            update opptyList;
            
        
        }
                
    }
    
}