public with sharing class APTS_ProposalLineItemTriggerHandler {
    
    public APTS_ProposalLineItemTriggerHandler() {
    }
    // Sreenu Changes Start for validating the Online/Master Contacs Flag on before insert - SOC-2337
    public void OnBeforeInsert(Apttus_Proposal__Proposal_Line_Item__c[] newObjects){
       //APTS_ProposalLineItemTriggerHelper.updateAutoNumber(newObjects, false);        
       APTS_ProposalLineItemTriggerHelper.validateOnlineMasterFlags(newObjects);
        APTS_ProposalLineItemTriggerHelper.updateContractAvailabilty(newObjects);
        APTS_ProposalLineItemTriggerHelper.populateProductVariant(newObjects);
    }
    // Sreenu Changes End
        //public void OnBeforeInsert(Apttus_Proposal__Proposal_Line_Item__c[] newObjects){
       //APTS_ProposalLineItemTriggerHelper.updateValidationFlag(newObjects);
   // }
   
    public void OnAfterInsert(Apttus_Proposal__Proposal_Line_Item__c[] newObjects){
        APTS_ProposalLineItemTriggerHelper.updateValidationFlag(newObjects);
        Tax_APTS_OnlineContactsController.taxUpdateAssetLineAfterPLIInsert(newObjects);
        APTS_ProposalLineItemTriggerHelper.populateProductVariant(newObjects);
    }    
   
    public void OnBeforeUpdate(Apttus_Proposal__Proposal_Line_Item__c[] newObjects){
        APTS_ProposalLineItemTriggerHelper.populateContractTermSubscription(newObjects); 
        APTS_ProposalLineItemTriggerHelper.populateContractDisplayFrench(newObjects);
        APTS_ProposalLineItemTriggerHelper.pupulateNetPrintProview(newObjects);
        APTS_ProposalLineItemTriggerHelper.updateOneTimeProducts(newObjects);
        APTS_ProposalLineItemTriggerHelper.updateLapseDate(newObjects);
    }
    
   public void OnAfterUpdate(Apttus_Proposal__Proposal_Line_Item__c[] newObjects){
        APTS_ProposalLineItemTriggerHelper.updateValidationFlag(newObjects);
    } 
    
    public void onBeforeDelete(Apttus_Proposal__Proposal_Line_Item__c[] listObjects){
        APTS_ProposalLineItemTriggerHelper.updateValidationFlag(listObjects);
        //APTS_ProposalLineItemTriggerHelper.updateContactValidationFlag(listObjects, 'delete');
    }
}