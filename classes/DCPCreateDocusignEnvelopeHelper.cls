/**
    @description Docusign envelope creation helper class for DCP
    CHANGE HISTORY
    ==========================================================================================
    Date                Developer                   Description
    2021-05-19          Benjamin Her                DCP-1548 Initial creation

 */
public without sharing class DCPCreateDocusignEnvelopeHelper{

    /**
        @description Creates Docusign envelope record
        @param proposalToDocumentMap Map of proposal id to order form
        @param proposalToRequestMap Map of proposal id to Docusign request
        @param proposalToEnvelopeId Map of proposal id to Docusign envelope id
     */
    public static void createSalesforceDocusignRecord(Map<id,ContentDocumentLink> proposalToDocumentMap,
        Map<id,String> proposalToRequestMap,Map<id,String> proposalToEnvelopeId){
        
        List<Apttus_DocuApi__DocuSignEnvelope__c> docusignEnvelopes = new List<Apttus_DocuApi__DocuSignEnvelope__c>();

        for(Id proposalId : proposalToEnvelopeId.keySet()){
            
            if(String.isNotBlank(proposalToEnvelopeId.get(proposalId))
                && proposalToDocumentMap.containsKey(proposalId)
                && proposalToRequestMap.containsKey(proposalId)){
                    
                Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
                envelope.Apttus_DocuApi__DocumentName__c = proposalToDocumentMap.get(proposalId).ContentDocument.LatestPublishedVersion.Title;
                envelope.Apttus_DocuApi__EnvelopeContent__c = proposalToRequestMap.get(proposalId).left(32768);
                envelope.Name = proposalToEnvelopeId.get(proposalId);
                envelope.Apttus_DocuApi__EnvelopeId__c = proposalToEnvelopeId.get(proposalId);
                envelope.Apttus_DocuApi__NumberOfDocuments__c = 1; //Set to 1, Current Code only attaches one document
                envelope.Apttus_DocuApi__ParentId__c = proposalId;
                envelope.Apttus_DocuApi__StatusChangeDateTime__c = System.today();
                envelope.Apttus_DocuApi__Status__c = 'sent';
                envelope.Apttus_QPDSign__QuoteProposal__c = proposalId;
                docusignEnvelopes.add(envelope);
            }
        }

        if(!docusignEnvelopes.isEmpty() && Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isCreateable()){
            insert docusignEnvelopes;
        }
    }

    /**
        @description Updates opportunity record
        @param proposalList List of proposal that needs opportunities to be updated
        @param proposalToEnvelopeId Map of proposal id to Docusign envelope id
     */
    public static void updateOpportunity(List<Apttus_Proposal__Proposal__c> proposalList,Map<id,String> proposalToEnvelopeId){
        List<Opportunity> updateOppList = new List<Opportunity>();

        for(Apttus_Proposal__Proposal__c proposal : proposalList){
            String strOppPriorStage = proposal.Apttus_Proposal__Opportunity__r.Digital_PreviousStageName__c;
            List<String> validPriorOppStage = new List<String>{'Contract Signed','Order Complete'};
            if(proposalToEnvelopeId.containsKey(proposal.id) && String.isNotBlank(proposalToEnvelopeId.get(proposal.id))
                && (validPriorOppStage.contains(strOppPriorStage) ||
                String.isBlank(strOppPriorStage))){
    
                Opportunity opp = new Opportunity();
                opp.id = proposal.Apttus_Proposal__Opportunity__c;
                opp.StageName = 'Appointment Scheduled';
                
                //Proposals and look up to the same opportunity. Check if a similar opportunity object has been added to the list.
                if(!updateOppList.contains(opp)){
                    updateOppList.add(opp);
                }
            }
        }

        if(!updateOppList.isEmpty() && Schema.sObjectType.Opportunity.isUpdateable()){
            update updateOppList;
        }
    }

    /**
        @description Updates proposal record
        @param proposalList List of proposal that needs to be updated
        @param proposalToEnvelopeId Map of proposal id to Docusign envelope id
     */
    public static void updateProposal(List<Apttus_Proposal__Proposal__c> proposalList,Map<id,String> proposalToEnvelopeId){

        List<Apttus_Proposal__Proposal__c> updateProposalList = new List<Apttus_Proposal__Proposal__c>();

        for(Apttus_Proposal__Proposal__c proposal : proposalList){
            if(proposalToEnvelopeId.containsKey(proposal.id) && String.isNotBlank(proposalToEnvelopeId.get(proposal.id))){
                proposal.DocuSign_Envelope_ID__c = proposalToEnvelopeId.get(proposal.id);
                proposal.Apttus_Proposal__Approval_Stage__c = 'Presented';
                proposal.Digital_Envelope_Created__c = true;
                proposal.DC_Contract_Not_In_Sync__c = false;
                updateProposalList.add(proposal);
            }
        }
        
        if(!updateProposalList.isEmpty() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
            update updateProposalList;
        }
    }

}