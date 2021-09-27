/* 
 * This batch class expires all auto-generated digital proposals if their subscriptions are renewed. When a subscription is renewed, all proposals, 
 *  regardless of the associated opportunity, are Expired. 
 *  Scheduled on a daily basis. 
 */
/*
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2019-04-19   Saleh Asadallahi        DLT-14808 - Expire Digital Proposals if any subscriptions have been renewed via different Opp
 * 2019-05-28   Benjamin Her            DLT-16539 - Expire proposals if assets are cancelled or already renewed
 * 2019-07-19   Benjamin Her            DLT-17197 - Expire proposals if an order was placed after automated proposals are created.
 * 2019-08-14   Navleen Kaur                        Removing reference of Digital_Mid_Contract__c
 * 2020-04-21   Benjamin Her            DLT-19879 - Updated code to check for other digital offers on the account
 * 2020-10-27   Brenda Shields          DLT-21009 - remove dependency on 'contract type' and expire all Digital offers (Ineligible 3 offers/Mid contract/New mid contract)
 *                                                  Updated for PMD violations
 * =============================================================================
 */
public with sharing class Digital_ExpireRenewalsSync implements Database.Batchable<Apttus_Proposal__Proposal_Line_Item__c>{

    private static final Integer INTERVAL = 7;
    private static final String EXPIRED_STAGE = 'Expired';
    private static final String DOCUSIGN_VOID = 'voided';
    private static final String CANCELLED_STATUS = 'Cancelled';
    
    public static list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
    public static Set<Id> expiringOppSet = new Set<Id>();
    public static Set<Id> renewedProposalIDSet = new Set<Id>();
    
    
    /* collect all the proposal line items along with their the opportunity and asset line item and proposals
        comparison between opportunity renewal date and asset line item renewal date determines whether 
        subscription is renewed or not. */ 
    public Iterable<Apttus_Proposal__Proposal_Line_Item__c> start(Database.BatchableContext bc) {
    	
		// DLT-21009 - remove Contract Type - Apttus_Proposal__Proposal__r.Contract_Type__c = '' AND 
        list<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItems = [
        		SELECT id, Apttus_Proposal__Proposal__c, Apttus_QPConfig__AssetLineItemId__c, 
            		Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c,
		            Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Id,
		            Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c,
        		    Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.Id,
   			        Apttus_Proposal__Proposal__r.CreatedDate,
 		            Apttus_QPConfig__AssetLineItemId__r.APTS_Info_RenewalDate__c,
 		            Apttus_QPConfig__AssetLineItemId__r.Apttus_Config2__AssetStatus__c,
 		            Apttus_QPConfig__AssetLineItemId__r.Apttus_QPConfig__ProposalId__c,
 		            Apttus_Proposal__Proposal__r.Digital_Quote_Type__c
 		         FROM Apttus_Proposal__Proposal_Line_Item__c 
   		         WHERE  Apttus_Proposal__Proposal__r.is_Digital_Channel__c = true AND 
     		       Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Presented' AND 
     		       Apttus_Proposal__Proposal__r.Digital_Quote_Type__c IN ('Straight Renewal', 'Manual') AND 
            	   Apttus_QPConfig__AssetLineItemId__r.Apttus_Config2__AssetStatus__c IN ('Activated', 'Cancelled')
        ];

        return proposalLineItems;
    }
    
    /*
     * Expires proposals that contain recently renewed or cancelled assets
     */
    public void execute(Database.BatchableContext bc, List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList) {
        //Contain all logic for selecting and expiring proposals
        try {
            digitalExpireProposals(proposalLineItemList);
        } catch(Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Exception: ' + ex);
            System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
        }           
    }
    
    
    // finish method - write any Digital Exception errors
    public void finish(Database.BatchableContext bc) {
        //log errors, if any
        try {
            if (exList.size() > 0) {
                insert exList;
            }
        } catch(Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Exception' + ex);
        }
    }


    //digitalExpireProposals()
    //Expires quotes should any of the line items meets the criteria for expiration.
    public static void digitalExpireProposals(List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList){
        
        //check for CRUD access
        if(!(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()
            && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()
            && Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isCreateable()
            && Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()
            && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible()
            && Schema.sObjectType.Apttus_Proposal__Proposal__c.isCreateable()
            && Schema.sObjectType.Opportunity.isAccessible())) {
            
            throw new DCCustomException('Digital_ExpireRenewalsSync ::: User does not have all the required access to call this class');
        }
        
        //Set<Id> expiringOppSet = new Set<Id>();
        //Set<Id> renewedProposalIDSet = new Set<Id>();
        map<Id, Apttus_Proposal__Proposal_Line_Item__c> renewedProposalQuoteLineItemMap = new map<Id, Apttus_Proposal__Proposal_Line_Item__c>();
        
        // get the opportunity ids for expiring propsals only based on 'Straight Renewal'
        for (Apttus_Proposal__Proposal_Line_Item__c pLineItem : proposalLineItemList) {
            //Analyze for cancelled assets and assests previously renewed.
            if (pLineItem.Apttus_Proposal__Proposal__r.Digital_Quote_Type__c == 'Straight Renewal') {
                //analyzeLineItem(pLineItem, expiringOppSet,renewedProposalIDSet,renewedProposalQuoteLineItemMap);
                analyzeLineItem(pLineItem, renewedProposalQuoteLineItemMap);
            }
        }

        //Analyze quote order of previously renewed assets
        analyzeQuoteOrder(expiringOppSet,renewedProposalIDSet,renewedProposalQuoteLineItemMap);

        //Analyze whether another digital offer was accepted
        analyzeOtherDigitalOffer(expiringOppSet,proposalLineItemList);

        //Contains logic to update expiring proposal's relevant fields
        digitalExpireProposalsHelper(expiringOppSet);

    }//end of digitalExpireProposals() method

    //analyzeOtherDigitalOffer() method
    //Checks for digital offers and if any offer renewed the same assets and was accepted, expire non-accepted offer
    //Added DLT-19879
    private static void analyzeOtherDigitalOffer(Set<Id> expiringOppSet, List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList){

        Set<Id> sourceSystemDetailSet = new Set<Id>();
        Set<Id> opportunitySet = new Set<Id>();

        for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : proposalLineItemList){
            sourceSystemDetailSet.add(proposalLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.Id);
            opportunitySet.add(proposalLineItem.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Id);
        }
        // DLT-21009 - the Opp that is renewing the assets does not need to be Digital
        //            AND Apttus_Proposal__Proposal__r.is_Digital_Channel__c = TRUE
        //Queries all accepted, renewed, digital Proposal Line Item from different opportunities but within the same SSDs
        List<Apttus_Proposal__Proposal_Line_Item__c> differentProposalLineItemList = 
            [SELECT id, Apttus_QPConfig__AssetLineItemId__c, Apttus_Proposal__Proposal__r.Digitally_Signed_Date__c
            FROM Apttus_Proposal__Proposal_Line_Item__c
            WHERE Apttus_QPConfig__LineStatus__c = 'Renewed'
            AND Apttus_Proposal__Proposal__r.Digital_Quote_Type__c IN ('Straight Renewal','Manual')
            AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Accepted'
            AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__c NOT IN: opportunitySet
            AND Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__c IN: sourceSystemDetailSet];
        System.debug(LoggingLevel.INFO, 'differentProposalLineItemList:::'+differentProposalLineItemList);

        //Iterates over all proposal line items from automated batched proposal line items
        for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : proposalLineItemList){

            if(expiringOppSet.contains(proposalLineItem.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Id)){
                continue;
            }
            
            //Iterates over all proposal ilne items from the other opporutunities
            for(Apttus_Proposal__Proposal_Line_Item__c differentProposalLineItem : differentProposalLineItemList){
                //If assets are the same between the two proposal line items and the accepted digital proposal has a
                //digitally signed date more recent than the created date of the batched proposal, store opportunity of automated offer
                if(differentProposalLineItem.Apttus_QPConfig__AssetLineItemId__c == proposalLineItem.Apttus_QPConfig__AssetLineItemId__c
                    && differentProposalLineItem.Apttus_Proposal__Proposal__r.Digitally_Signed_Date__c > proposalLineItem.Apttus_Proposal__Proposal__r.CreatedDate){
                    
                    //Add opportunity to expired to expiringOppSet
                    expiringOppSet.add(proposalLineItem.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Id);
                    
                    break;
                }
            }
        }

    }//end of analyzeOtherDigitalOffer() method
    

    //analyzeLineItem()
    //Assists in determining which proposals meets the criteria to be expired by analyzing line items
    //private static void analyzeLineItem(Apttus_Proposal__Proposal_Line_Item__c pLineItem, Set<Id> expiringOppSet, Set<ID> renewedProposalIDSet, Map<ID,Apttus_Proposal__Proposal_Line_Item__c> renewedProposalQuoteLineItemMap) {
    private static void analyzeLineItem(Apttus_Proposal__Proposal_Line_Item__c pLineItem, Map<ID,Apttus_Proposal__Proposal_Line_Item__c> renewedProposalQuoteLineItemMap) {
        
        Apttus_Config2__AssetLineItem__c assetLineItem = pLineItem.Apttus_QPConfig__AssetLineItemId__r;
        Apttus_Proposal__Proposal__c proposal = pLineItem.Apttus_Proposal__Proposal__r;
        Opportunity opp = proposal.Apttus_Proposal__Opportunity__r;

        if(assetLineItem == null || opp == null){
            return;
        }
        if(opp.Renewal_Date__c == null){
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = 'No Opportunity Renewal Date';
            ex.Exception_Type__c = 'Record Update Error: Id - ' + opp.id; 
            ex.Class_Reference__c = 'Digital_ExpireProposalRenewd - Opportunity Date' ;
            exList.add(ex);
            return;             
        }
        
        //DLT-16539 - Line items with Cancelled assets are to be expired.
        if(pLineItem.Apttus_QPConfig__AssetLineItemId__r.Apttus_Config2__AssetStatus__c == CANCELLED_STATUS){
            expiringOppSet.add(opp.id);
            return;
        }
        
        //Line items that up for renewal and associated with a proposals are stored for further processing
        if(assetLineItem.APTS_Info_RenewalDate__c > opp.Renewal_Date__c + INTERVAL 
            && assetLineItem.Apttus_QPConfig__ProposalId__c != null){ // Sometimes there is one day difference between the two dates

            //DLT-16539 - Store renewed asset's Proposal ID and map old renewed Proposal ID to new Proposal Line Item  
            //Mapped proposal line item will be used to reference Straight Proposal
            renewedProposalIDSet.add(assetLineItem.Apttus_QPConfig__ProposalId__c);
            renewedProposalQuoteLineItemMap.put(assetLineItem.Apttus_QPConfig__ProposalId__c, pLineItem);            

        }
    }//end of analyzeLineItem() method

    
    private static void analyzeQuoteOrder(Set<Id> expiringOppSet,Set<ID> renewedProposalIDSet,Map<ID,Apttus_Proposal__Proposal_Line_Item__c> renewedProposalQuoteLineItemMap){

        if(renewedProposalIDSet == null || renewedProposalIDSet.isEmpty()){
            return;
        }

        //Queries grabs the most recently created Order from each old Proposals
        List<Apttus_Proposal__Proposal__c> proposalList = [SELECT id, Apttus_Proposal__Opportunity__r.Renewal_Date__c, 
                                                                (SELECT id, Apttus_Config2__OrderDate__c
                                                                FROM Apttus_QPConfig__Orders__r
                                                                ORDER BY CreatedDate DESC
                                                                LIMIT 1)
                                                            FROM Apttus_Proposal__Proposal__c
                                                            WHERE id IN: renewedProposalIDSet];
        
        for(Apttus_Proposal__Proposal__c prop : proposalList){
            for(Apttus_Config2__Order__c order : prop.Apttus_QPConfig__Orders__r){
                if(order.Apttus_Config2__OrderDate__c.date() > renewedProposalQuoteLineItemMap.get(prop.id).Apttus_Proposal__Proposal__r.CreatedDate){
                    expiringOppSet.add(renewedProposalQuoteLineItemMap.get(prop.id).Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.id);
                }
            }
        }

    }

    //expiringProposalsFieldUpdate() method
    //Gets all proposals to be expired and updates the relevant fields
    private static void digitalExpireProposalsHelper(Set<Id> expiringOppSet){

        //get all of the exiring proposals 
        map<Id, Apttus_Proposal__Proposal__c> expiringProposalMap = new map<Id, Apttus_Proposal__Proposal__c>(
            [
            SELECT id, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Approval_Stage__c, Digital_Quote_Type__c
            FROM Apttus_Proposal__Proposal__c 
            WHERE is_Digital_Channel__c = TRUE AND 
            Apttus_Proposal__Approval_Stage__c = 'Presented' AND
            Apttus_Proposal__Opportunity__c IN: expiringOppSet
            ]
        );
        
        // get the DocusignEnvelpe for all expiring opportunities
        list<Apttus_DocuApi__DocuSignEnvelope__c> envList = [
            SELECT id, APTTUS_DOCUAPI__STATUS__C 
            FROM Apttus_DocuApi__DocuSignEnvelope__c 
            WHERE APTTUS_DOCUAPI__STATUS__C = 'sent' AND APTTUS_DOCUAPI__PARENTID__C IN :expiringProposalMap.keySet()
        ];
        
        // Expire proposals     
        for(Id key : expiringProposalMap.keySet()){
            expiringProposalMap.get(key).Apttus_Proposal__Approval_Stage__c = EXPIRED_STAGE;    
        }
        
        // Void envelops
        for(Apttus_DocuApi__DocuSignEnvelope__c envelope : envList){
            envelope.APTTUS_DOCUAPI__STATUS__C = DOCUSIGN_VOID;
        }
        
        //update the proposals; changes the stage to expired
        updateProposals(expiringProposalMap.values());

        
        //update the envelopes; voids the Docusign envelopes
        if(envList.size() > 0){
            Database.SaveResult[] srList = Database.update(envList, false);
            for(Integer i = 0; i< srList.size(); ++i){
                if(!srList[i].isSuccess()){
                    handleException(srList[i], envList[i].id, false);
                }
            }   
        }       
    }//end of digitalExpireProposalsHelper() method

    //updateProposals()
    public static void updateProposals(List<Apttus_Proposal__Proposal__c> expiringProposalList){    
        if(expiringProposalList.size() > 0){
            Database.SaveResult[] srList = Database.update(expiringProposalList, false);
            for(Integer i = 0; i< srList.size(); ++i){
                if(!srList[i].isSuccess()){
                    handleException(srList[i], expiringProposalList[i].id, true);
                }
            }       
        }
    }//end of updateProposals() method
        
    public static void handleException (Database.saveresult sr, Id updatedRecordId, Boolean isProposal) {
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        Database.Error error = sr.getErrors().get(0);
        ex.Exception_Message__c = error.getMessage(); //failedDML;
        ex.Exception_Type__c = 'Record Update Error: Id - ' + updatedRecordId; //failed record from the list
        ex.Class_Reference__c = isProposal ? 'Digital_ExpireProposalRenewd - Proposal Update' : 'Digital_ExpireProposalRenewd - Envelope Update';
        exList.add(ex);   
    }  



    
}