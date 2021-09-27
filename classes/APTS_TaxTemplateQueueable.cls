public class APTS_TaxTemplateQueueable implements Queueable {
    public Id proposalId; 
    public APTS_TaxTemplateQueueable(Id proposalId) {
        this.proposalId = proposalId;
    }
    public void execute(QueueableContext context) {
        APTS_Tax_ProposalTriggerHelper.templatefieldupdate(proposalId);
    }
}