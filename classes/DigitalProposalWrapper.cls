/**
* @description DigitalProposalWrapper
*/
public class DigitalProposalWrapper {
    public Apttus_Proposal__Proposal__c straightProposal;
    public Apttus_Proposal__Proposal__c bestProposal;
    public Apttus_Proposal__Proposal__c premiumProposal;
    public List<Apttus_Proposal__Proposal__c> manualProposals;
        /**
* @description DigitalProposalWrapper
*/
    public DigitalProposalWrapper(){
        manualProposals = new List<Apttus_Proposal__Proposal__c>();
    }
}