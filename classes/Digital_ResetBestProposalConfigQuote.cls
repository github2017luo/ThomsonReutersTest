/*
 * CHANGE HISTORY
 * =======================================================================================================================
 * Date                 Name                Story
 * 2020-07-27           Benjamin Her        DLT-20456 - Fixed PMD issue
 *
 */

public with sharing class Digital_ResetBestProposalConfigQuote {
    
    @InvocableMethod
    public static void resetQuote(List<Id> bestValQuoteIds)
    {
        map<String,String> mapOppIdWithQuote = new map<String,String>();
        List<String> bestValueIdSet = new List<String>();
        
        for(Apttus_Proposal__Proposal__c prop : [SELECT id,Apttus_Proposal__Opportunity__c 
                                                FROM Apttus_Proposal__Proposal__c 
                                                WHERE id IN : bestValQuoteIds]){
            
            mapOppIdWithQuote.put(prop.Apttus_Proposal__Opportunity__c,prop.id);
        }
        system.debug('@@@@@@@ mapOppIdWithQuote >>>>>>> : '+ mapOppIdWithQuote);
        for(Apttus_Proposal__Proposal__c prop :[SELECT id,Apttus_Proposal__Opportunity__c 
                                                FROM Apttus_Proposal__Proposal__c 
                                                WHERE Apttus_Proposal__Opportunity__c IN :mapOppIdWithQuote.keyset() 
                                                AND Digital_Quote_Type__c='Best Value']){
            
            system.debug('@@@@@@@ prop opty >>>>>>> : '+ prop.Apttus_Proposal__Opportunity__c);
            system.debug('@@@@@@@ mapOppIdWithQuote for prop >>>>>>> : '+ mapOppIdWithQuote.get(prop.Apttus_Proposal__Opportunity__c));
            
            if(mapOppIdWithQuote.get(prop.Apttus_Proposal__Opportunity__c) != null){
                
                DCConfiguratorControllerV2.resetToBestValue(mapOppIdWithQuote.get(prop.Apttus_Proposal__Opportunity__c), prop.id);
                bestValueIdSet.add(mapOppIdWithQuote.get(prop.Apttus_Proposal__Opportunity__c));                
            }
        }
        synchronize(bestValueIdSet);
    }
    
    @future(callout=true)
    public static void synchronize(List<String> bestValQuoteIdList){
        for(String bestValQuoteId: bestValQuoteIdList){
        DCConfiguratorControllerV2.synchronizeCart(bestValQuoteId);
        }
    }
}