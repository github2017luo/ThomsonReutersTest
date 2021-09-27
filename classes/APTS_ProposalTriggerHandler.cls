public with sharing class APTS_ProposalTriggerHandler {
    public static boolean beforeUpdate = false;
    public static boolean beforeInsert = false;
    public static boolean beforeDelete = false;
    public static boolean afterUpdate = false;
    public static boolean afterInsert = false;
    public static boolean afterDelete = false; 
	public static boolean taxPaymentBeforeUpdate = false; 
    public APTS_ProposalTriggerHandler() {
    }
    
    public void OnBeforeInsert(Apttus_Proposal__Proposal__c[] newObjects){
        if(!beforeInsert){
        APTS_ProposalTriggerHelper.UpdatePriceList(newObjects);
        APTS_ProposalTriggerHelper.UpdateBillToAndShipTo(newObjects);
		APTS_Tax_ProposalTriggerHelper.updatePaymentDetailsforExisting(newObjects,null); 
        //APTS_ProposalTriggerHelper.updateAddressFeilds(newObjects);
        //APTS_ProposalTriggerHelper.defaultApprovalSegment(newObjects);
        }
    }
    
    public void OnBeforeUpdate(Map<Id, Apttus_Proposal__Proposal__c> mapOldObjects,Apttus_Proposal__Proposal__c[] newObjects,Map<Id, Apttus_Proposal__Proposal__c> mapNewObjects){
        if(!beforeUpdate){
        beforeUpdate = true;
        APTS_ProposalTriggerHelper.updateAddressFeilds(newObjects); 
		//APTS_ProposalTriggerHelper.updateProposal(newObjects);//DOC-8284
        APTS_ProposalTriggerHelper.updateTmpOrderConfirmationContact(newObjects);
        // Update quote/proposal fields for the CX Digital project  2017-07-24  Brenda Shields  DLT-1848
        APTS_ProposalTriggerHelper.DigitalUpdateToProposal(newObjects);
        APTS_ProposalTriggerHelper.populateApprovalDashBoard(mapOldObjects, newObjects); //DOC- 6335
        APTS_ProposalTriggerHelper.ValidateQuoteStageUpdate(mapOldObjects,mapNewObjects);//DOC-3658 changes
		//APTS_Tax_ProposalTriggerHelper.graceDateUpdation(mapOldObjects,mapNewObjects); //GracePeriodforTax Prof
		APTS_Tax_ProposalTriggerHelper.updateWinLostReason(mapOldObjects,mapNewObjects);
        }
		 if(!taxPaymentBeforeUpdate){
            taxPaymentBeforeUpdate = true;
            APTS_Tax_ProposalTriggerHelper.updatePaymentDetailsforExisting(newObjects,mapOldObjects);//DOC-10572
        }
    }
    
    public void OnAfterUpdate(Map<Id, Apttus_Proposal__Proposal__c> mapOldObjects, Apttus_Proposal__Proposal__c[] listNewObjects, Map<Id, Apttus_Proposal__Proposal__c> mapNewObjects){
        if(!afterUpdate){
        APTS_ProposalTriggerHelper.UpdateOpportunityStage(mapOldObjects, listNewObjects, mapNewObjects);
		//APTS_Tax_ProposalTriggerHelper.GraceManagerApproval(mapOldObjects,mapNewObjects);
        APTS_ProposalTriggerHelper.createOrderAndAssetLineItems(mapOldObjects, listNewObjects, mapNewObjects);
        //APTS_ProposalTriggerHelper.Digital_SecondaryQuoteExpiration(mapOldObjects, listNewObjects, mapNewObjects);
        //Merged as part of SOC-6701 Start--Zakeer
        APTS_ProposalTriggerHelper.updateLegalLanguage(listNewObjects);   //update legal language field- added by gayatri  
        //SOC-6701 End
        //CRM-12065
        APTS_ProposalTriggerHelper.UpdateApprovalSegment(mapOldObjects, listNewObjects, mapNewObjects);
        
        }
    }
    
    public void OnAfterInsert(Map<Id, Apttus_Proposal__Proposal__c> mapOldObjects, Apttus_Proposal__Proposal__c[] listNewObjects, Map<Id, Apttus_Proposal__Proposal__c> mapNewObjects){
        if(!afterInsert){
        //CRM-12065 
        System.debug('in after insert for proposal trigger handler!!!!!!');
       // APTS_ProposalTriggerHelper.UpdateApprovalSegment(mapOldObjects, listNewObjects, mapNewObjects);
        }
    } 
    //DOC-5003 Starts       
    public void OnBeforeDelete(Apttus_Proposal__Proposal__c[] proposals){       
        if(!beforeDelete){      
        APTS_ProposalTriggerHelper.validateQuoteStageforDelete(proposals);      
                
        }       
    }       
    //DOC-5003 Ends     
    
    
}