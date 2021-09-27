trigger ContactUpdate on Apttus_Proposal__Proposal__c (after update, before update) {

  if(Trigger.isBefore && Trigger.isUpdate){
        for(Apttus_Proposal__Proposal__c proposal : Trigger.new){
            Apttus_Proposal__Proposal__c oldProposal = Trigger.oldmap.get(proposal.id);
            if(proposal.APTS_Order_Confirmation_Contact__c != oldProposal.APTS_Order_Confirmation_Contact__c)
                proposal.Previous_Order_Confirmation_Contact__c = oldProposal.APTS_Order_Confirmation_Contact__c;   
        }
    }

}