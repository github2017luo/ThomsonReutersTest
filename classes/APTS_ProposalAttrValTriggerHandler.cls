public class APTS_ProposalAttrValTriggerHandler {
    
    public APTS_ProposalAttrValTriggerHandler(){ 
    
    }
    
    public void onBeforeInsert(List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstProposalAttributes){
    
    }
    
    public void onAfterInsert(List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstProposalAttributes){
        APTS_ProposalAttrValTriggerHelper.updateCPROValuesOnProposal(lstProposalAttributes);
    }

}