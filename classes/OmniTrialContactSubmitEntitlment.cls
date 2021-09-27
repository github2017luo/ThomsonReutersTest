/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-19-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public without sharing class OmniTrialContactSubmitEntitlment {
    
    /**
     * @description to submit the contact for Trial
     * @param recId
     * @return message
     * 
     */
    @auraEnabled 
    public static string processRec(string recId){
        string message ;
        list<id> trialContIds = new list<id>();
        list<id> trialPrdIds = new list<id>();
        list<Trial_Contact__c> trlContacts;
        if(Schema.sObjectType.Trial_Contact__c.isAccessible()){
            trlContacts = [ SELECT Trials__c, Id, Status__c FROM Trial_Contact__c where id = :recId and Status__c in ('Rep Initiated','Accepted')];
        }
        //system.debug(trlContacts);
        if(trlContacts == null || trlContacts.size() == 0){
            message = label.OmniContactSubmitTrialValidaionMsg;
        }
        else{
            trialContIds.add(trlContacts[0].id);
            Map<id,trial_Product__c> trialProducts = new Map<id,trial_Product__c>([select Id,trial__c from Trial_Product__c where trial__c = :trlContacts[0].Trials__c]);
            set<id> productIdset = trialProducts.keyset();
            trialPrdIds.addAll(productIdset);
            boolean response =   OmniCalltoSubmitEntitlement.callToSubmitEntitlement(trlContacts[0].Trials__c,  trialContIds,trialPrdIds) ;
            if(response){
                trlContacts[0].Status__c = 'Accepted';
                message =label.OmniContactSubmitTrialSuccess;
                updateContactStatus(trlContacts);
            }else{
                message = label.OmniContactSubmitTrialError;  
            }
        } 
        return message;
    }
    
     @testVisible
    private static void updateContactStatus(list<Trial_Contact__c> trlContacts){
     if(Trial_Contact__c.SobjectType.getDescribe().isCreateable() && 
        Trial_Contact__c.SobjectType.getDescribe().isUpdateable() && 
        trlContacts.size()>0){
            update trlContacts;
        }
    }
}