Public class CampaignTriggerHandler{

    public static void UpdateOfferCode(List<Campaign> listCampaign){
    Map<Id, String> mapCampaignOfferCode = new Map<Id, String>();
    

    List<Opportunity> listOpportunity = [select id, Offer_Code__c,campaignid from Opportunity where campaignid IN :listCampaign];
    List<Training_Event__c> listTrainingEvent = [select id, Offer_Code__c,campaign_name__c  from Training_Event__c where campaign_name__c IN :listCampaign];
    
    for(Campaign ocampaign : listCampaign)
        {
             if(!mapCampaignOfferCode.containsKey(ocampaign.id))
                 {
                      mapCampaignOfferCode.put(ocampaign.id, ocampaign.Offer_Code__c);
                 }
        }
    
    for(Opportunity oppty: listOpportunity)
    {
        oppty.offer_code__c = mapCampaignOfferCode.get(oppty.campaignid);
    }
    update listOpportunity;
    
    for(Training_Event__c oTrainingEvent: listTrainingEvent)
        {
            oTrainingEvent.offer_code__c = mapCampaignOfferCode.get(oTrainingEvent.campaign_name__c);
        }
    update listTrainingEvent;
    
    
    
    }

}