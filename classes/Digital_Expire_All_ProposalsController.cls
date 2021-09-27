/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2017-12-27   Brenda Shields          DLT-6920 - When expiring proposals - include setting the status to voided in ALL DocuSign Envelope records realted to the opp/Proposal  
 * 2018-01-17   Brenda Shields          DLT-7189 - When expiring proposals - Do not update the Opportunity
 * 2018-06/26   Brenda Shields          DLT-10738 - Exclude manual quotes when expiring proposals
 * 2018-12-26   Bishanka Dassarma       DLT-14156 - Fix Code Scan Security Issues
 * ==================================================================================================================================   
 */
 
public without sharing class Digital_Expire_All_ProposalsController {
    Id OpportunityId;
    Id OpportunityOwnerId;
    string OppOwnerId;
    string CurrentUserId;
    
    public Boolean bNotOwnerFlag {get;set;}
    public Boolean bNoWork {get;set;}
    public Boolean bError {get;set;}
    public Boolean bContinue {get;set;}

    public Opportunity opp{get;set;}
    list<Apttus_Proposal__Proposal__c> listQuotes = new list<Apttus_Proposal__Proposal__c>();
    Set<Id> setQuoteIds = new Set<Id>();
    
    public Digital_Expire_All_ProposalsController() {
        
        OpportunityId = ApexPages.currentPage().getParameters().get('id');
        opp = new Opportunity();
        opp.id = OpportunityId;
        
        // get a list of all the proposals that can be expired
        if(!string.isBlank(OpportunityId)) { 
            if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
            listQuotes = [SELECT Id, Apttus_Proposal__Opportunity__r.ownerid,  
            Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c 
            where Apttus_Proposal__Opportunity__c =: OpportunityId AND is_Digital_Channel__c = TRUE AND 
            Apttus_Proposal__Approval_Stage__c != 'Expired' AND Apttus_Proposal__Approval_Stage__c != 'Accepted' AND 
            Apttus_Proposal__Approval_Stage__c != 'Denied' AND Digital_Quote_Type__c != 'Manual']; 
            }
            System.debug('&&&&'+listQuotes );  
            if(!listQuotes.isEmpty() ) {
            System.debug('&&&&'+listQuotes[0].Apttus_Proposal__Opportunity__r.ownerid);
            System.debug('&&&&'+(String)UserInfo.getUserId());
                OpportunityOwnerId = listQuotes[0].Apttus_Proposal__Opportunity__r.ownerid; 
                OppOwnerId = Id.valueOf(OpportunityOwnerId); 
                CurrentUserId = (String)UserInfo.getUserId();
                system.debug('Opp Owner: ' + OppOwnerId + ' Current User: ' + CurrentUserId);
            }
        } //String userId = (String)UserInfo.getUserId(); 
        
        bError = false;
        bNotOwnerFlag = false;
        bContinue = false;
        bNoWork = false;
    }
    
    public PageReference Expire() {
        
        // error if the current user is not the opportunity owner
        if (OppOwnerId <> CurrentUserId) {
            bNotOwnerFlag = true;
            bError = true;
            system.debug('Not Opp Onwer Error : ' + bNotOwnerFlag);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'TEST error message'));
            //Pagereference currentRecUrl = new PageReference('/' + OpportunityId);
            //return currentRecUrl;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Test message'));
            return Page.Digital_Expire_All_Proposals_Messages;
        }
        
        // Let them know there is no work to do
        if (listQuotes == null || listQuotes.size() == 0) {
            bNoWork = true;
            bError = true;
            system.debug('No work Error : ' + bNoWork);
            return Page.Digital_Expire_All_Proposals_Messages;
        }
        
        // check to see if they really want to expire documents
        if (!bContinue) {
            bContinue = true;
            system.debug('Continue : ' + bContinue);
            return Page.Digital_Expire_All_Proposals_Messages;
        }
        
        try {
            // loop through all quotes
            if (listQuotes != null && listQuotes.size() >0) {
                // update all Quotes
                for(Apttus_Proposal__Proposal__c oQuote : listQuotes) {
                    // add to quote list to expire envelopes
                    setQuoteIds.add(oQuote.Id);
                    // update status
                    oQuote.Apttus_Proposal__Approval_Stage__c = 'Expired';              
                }
                if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                update listQuotes;
                }
            }                
                
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
        
        // Void all apprporiate DocuSign Envelopes
        list<Apttus_DocuApi__DocuSignEnvelope__c> envList = new list<Apttus_DocuApi__DocuSignEnvelope__c>();
        
        if (!Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isAccessible()){
        envList = [select id, APTTUS_DOCUAPI__STATUS__C from Apttus_DocuApi__DocuSignEnvelope__c 
                        where APTTUS_DOCUAPI__STATUS__C = 'sent' 
                        AND Apttus_QPDSign__QuoteProposal__c =: setQuoteIds];
        }
        if(envList.size() > 0 && envList != Null){
            for(Apttus_DocuApi__DocuSignEnvelope__c oEnvUpdate : envList){
                // update status to voided
                oEnvUpdate.APTTUS_DOCUAPI__STATUS__C = 'voided';                
                system.debug('Envelope - moving status to voided for id: ' + oEnvUpdate.Id);    
            }
        }
        // Update Envelope records
        try{ 
            if(envList != null && envList.size() >0) {
                if (Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isUpdateable()){
                update envList;
                }
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
        
        Pagereference currentRecUrl = new PageReference('/' + OpportunityId);
        return currentRecUrl;
    }
    
    public PageReference ContinueExpire() {
        return Expire();
    }
    
    public PageReference ReturnToOpp() {
        Pagereference currentRecUrl = new PageReference('/' + OpportunityId);
        return currentRecUrl;       
    }    
}