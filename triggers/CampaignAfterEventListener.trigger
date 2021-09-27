trigger CampaignAfterEventListener on Campaign (after update){
    /*List<Campaign> listCampaigns = new List<Campaign>();
   
   for(Campaign oCampaign : trigger.new){
       if(oCampaign.Offer_Code__c!=trigger.oldmap.get(oCampaign.Id).Offer_Code__c){
            listCampaigns.add(oCampaign);
       }
   }*/
    //LTS_5227 : Exclusion framework
    System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
    If(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){
    return;
    }
   List<Campaign> campaignList = [select Id, Name, Program_Type__c, Operating_Unit__c, Campaign_Level__c, Campaign_Theme__c from Campaign where Id IN :Trigger.new];
   
   List<Campaign> campaignList2 = [select Id, Name, Program_Type__c, Operating_Unit__c, Campaign_Level__c, Campaign_Theme__c, Parent.Id from Campaign where Parent.Id IN :Trigger.new];
   
   List<Campaign> campaignList3 = [select Id, Name, Program_Type__c, Operating_Unit__c, Campaign_Level__c, Campaign_Theme__c, Parent.Parent.Id from Campaign where Parent.Parent.Id IN :Trigger.new];
   
   List<Campaign> updateCampaignList = new List<Campaign>();
   
   if(campaignList!=null) {
        for(Campaign campaign : campaignList){
           /*Scenario 1:If Campaign Level = Tactic and the Program Type field is blank in the child Campaign record(level 3), When values are set at the parent (Level 2)
             campaign (program type) record, they need to flow down to the child campaign record(level 3)*/
           if(campaignList2!=null && (Trigger.oldMap.get(campaign.Id).Program_Type__c != Trigger.newMap.get(campaign.Id).Program_Type__c)){
                for(Campaign campaign2 : campaignList2){
                    if(campaign2.Parent.Id.equals(campaign.Id) && campaign2.Campaign_Level__c == 'Tactic' && campaign2.Program_Type__c == null){
                        campaign2.Program_Type__c = campaign.Program_Type__c;
                        updateCampaignList.add(campaign2);
                    }
                }
           }
           //Scenario 2 & 3 combined
           if(campaignList3!=null && (Trigger.oldMap.get(campaign.Id).Campaign_Theme__c != Trigger.newMap.get(campaign.Id).Campaign_Theme__c) && (Trigger.oldMap.get(campaign.Id).Operating_Unit__c != Trigger.newMap.get(campaign.Id).Operating_Unit__c)){
                for(Campaign campaign3 : campaignList3){
                    if(campaign3.Parent.Parent.Id.equals(campaign.Id) && campaign3.Campaign_Level__c == 'Tactic' && campaign3.Campaign_Theme__c == null){
                        campaign3.Campaign_Theme__c = campaign.Campaign_Theme__c;
                        campaign3.Operating_Unit__c = campaign.Operating_Unit__c;
                        updateCampaignList.add(campaign3);
                    }
                }
           }
           /*Scenario 2:If Campaign Level = Tactic and the Campaign Theme is blank in the child Campaign record(level 3) , When values are set at the grandparent campaign
            (level 1)(campaign Theme), they need to flow down to the child record(Level 3)*/
           if(campaignList3!=null && (Trigger.oldMap.get(campaign.Id).Campaign_Theme__c != Trigger.newMap.get(campaign.Id).Campaign_Theme__c)){
                for(Campaign campaign3 : campaignList3){
                    if(campaign3.Parent.Parent.Id.equals(campaign.Id) && campaign3.Campaign_Level__c == 'Tactic' && campaign3.Campaign_Theme__c == null){
                        campaign3.Campaign_Theme__c = campaign.Campaign_Theme__c;
                        updateCampaignList.add(campaign3);
                    }
                }
           }
           /*Scenario 3:If Campaign Level = Tactic and the Operating Unit is blank in the child Campaign record (level 3), When values are set at the grandparent campaign
            (level 1)(Operating Unit), they need to flow down to the child record (Level 3)*/
           if(campaignList3!=null && (Trigger.oldMap.get(campaign.Id).Operating_Unit__c != Trigger.newMap.get(campaign.Id).Operating_Unit__c)){
                for(Campaign campaign3 : campaignList3){
                    if(campaign3.Parent.Parent.Id.equals(campaign.Id) && campaign3.Campaign_Level__c == 'Tactic' && campaign3.Operating_Unit__c == null){
                        campaign3.Operating_Unit__c = campaign.Operating_Unit__c;
                        updateCampaignList.add(campaign3);
                    }
                }
           }
        }
   }
      
   if(updateCampaignList.size()>0)
        update updateCampaignList;
   
 /* CampaignOfferCodeUpdateonTE oCampaignOfferCodeUpdateonTE = new CampaignOfferCodeUpdateonTE(listCampaigns);
     database.executeBatch(oCampaignOfferCodeUpdateonTE);
     
  
  CampaignOfferCodeUpdateonOpp oCampaignOfferCodeUpdateonOpp = new CampaignOfferCodeUpdateonOpp(listCampaigns);
     database.executeBatch(oCampaignOfferCodeUpdateonOpp);*/
}