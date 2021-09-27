/**
 * comment: UpdateLeadConvertDetails Description
 * @description : This class updates description on opportunity after lead conversion
 *
 */
public without sharing class UpdateLeadConvertDetails {

    public static boolean updateConvertDetails = true;
    public static boolean isInSalesforceLightning = false;

    /**
     * comment : updateDetails description
     * @description : This method updates description on opportunity after lead conversion
     * @param newLeadMap (Map<IdLead>): newLeadMap
     */
    public static void updateDetails(Map<Id,Lead> newLeadMap){
        updateConvertDetails = false;
        Set<id> convertedOpportunityIdSet = new set<Id>();
        Map<ID,ID> leadOpptyIdMap = new Map<ID,ID>();
        Map<ID,String> leadStringDescriptionMap = new Map<Id,String>();
        Map<ID,String> oppStringDescriptionMap = new Map<Id,String>();
        //if(newLeadMap.size() > 0 ){
            for(Lead lc : newLeadMap.values()){
                
                if(lc.IsConverted == true && lc.ConvertedOpportunityId != null){
                    convertedOpportunityIdSet.add(lc.ConvertedOpportunityId);
                    leadOpptyIdMap.put(lc.Id,lc.ConvertedOpportunityId);
                    leadStringDescriptionMap.put(lc.id,lc.Description);
                }
                /*if(String.isnotBlank(lc.Description)){
                    leadStringDescriptionMap.put(lc.id,lc.Description);
                }*/
                
            }
        //}
        if(convertedOpportunityIdSet.size() > 0 ){
            for(Opportunity opp : [Select id,description FROM Opportunity WHERE ID IN:convertedOpportunityIdSet ]){
                if(String.isnotBlank(opp.Description)){
                    oppStringDescriptionMap.put(opp.id,opp.Description);
                }
                
            }
        }
        //iterate scenarios
        updateOpportunity(newLeadMap,leadStringDescriptionMap,oppStringDescriptionMap);
       
    }
    /**
     * comment : updateOpportunity description
     * @description : updates description
     * @param newLeadMap (Map<IdLead>): newLeadMap
     * @param leadStringDescriptionMap (Map<IDString>): leadStringDescriptionMap
     * @param oppStringDescriptionMap (Map<IDString>): oppStringDescriptionMap
     */
    public static void updateOpportunity(Map<Id,Lead>newLeadMap ,Map<ID,String> leadStringDescriptionMap, Map<ID,String> oppStringDescriptionMap ){
        Map<Id,Opportunity> opportunityToUpdate = new Map<Id,Opportunity>();
        for(Lead lc1 : newLeadMap.values()){
            //system.debug('leadStringDescriptionMap.get(lc1.id) ::'+leadStringDescriptionMap.get(lc1.id));
            //system.debug('oppStringDescriptionMap.get(lc1.ConvertedOpportunityId) ::'+oppStringDescriptionMap.get(lc1.ConvertedOpportunityId));
            Opportunity opp = new Opportunity();
            if(lc1.IsConverted == true   && String.isNotBlank(leadStringDescriptionMap.get(lc1.id)) && 
               String.isNotBlank(oppStringDescriptionMap.get(lc1.ConvertedOpportunityId))){
                   //system.debug('leadStringDescriptionMap.get(lc1.id) ::'+leadStringDescriptionMap.get(lc1.id));
                   //system.debug('oppStringDescriptionMap.get(lc1.ConvertedOpportunityId) ::'+oppStringDescriptionMap.get(lc1.ConvertedOpportunityId));
                   // Oppty.desc + ', Converted Lead Desc:' + Lead.Desc
                   opp.ID = lc1.ConvertedOpportunityId;
                   //opp.Description = leadStringDescriptionMap.get(lc1.id) +' '+oppStringDescriptionMap.get(lc1.ConvertedOpportunityId);
                   opp.Description=oppStringDescriptionMap.get(lc1.ConvertedOpportunityId)+System.Label.Lightning_Lead_Convert_Description+' '+leadStringDescriptionMap.get(lc1.id);
                   opportunityToUpdate.put(opp.ID,opp);
               }
            else if(lc1.IsConverted == true   && String.isNotBlank(leadStringDescriptionMap.get(lc1.id)) &&
                    !String.isNotBlank(oppStringDescriptionMap.get(lc1.ConvertedOpportunityId))){
                        //system.debug('leadStringDescriptionMap.get(lc1.id) ::'+leadStringDescriptionMap.get(lc1.id));
                        //system.debug('oppStringDescriptionMap.get(lc1.ConvertedOpportunityId) ::'+oppStringDescriptionMap.get(lc1.ConvertedOpportunityId));
                        
                        opp.ID = lc1.ConvertedOpportunityId;  
                        opp.Description = leadStringDescriptionMap.get(lc1.id);
                        opportunityToUpdate.put(opp.ID,opp);
                    }
        }
        if(opportunityToUpdate.size() > 0){
            update opportunityToUpdate.values();
        }

    }
    
}