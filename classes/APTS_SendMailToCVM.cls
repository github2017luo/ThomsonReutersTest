/**********************************************************
Created by: Accenture
Created Date:Nov 23 2016
Description:Controller Class for VF page APTS_Send_Email_To_CVM
            Invoked on click on "Send For CVM" button 
            Used to update field "CVM Email Sent" 
            Mail is sent from workflow rule "APTS Send Mail To CVM"
Modified By:                Modified Date:          Description:
/**********************************************************/
public class APTS_SendMailToCVM {
    Id proposalId;
    public Apttus_Proposal__Proposal__c proposal{get;set;}
    public APTS_SendMailToCVM(){
        proposal = new Apttus_Proposal__Proposal__c();
        proposalId = ApexPages.currentPage().getParameters().get('id');
        if(!string.isBlank(proposalId)){
            proposal = [SELECT Id, APTS_CVM_Email_Address__c, APTS_CVM_Email_Sent__c FROM Apttus_Proposal__Proposal__c WHERE Id =: proposalId];   
        }
    }   
    public PageReference sendMail() {
        PageReference proposalPage = new PageReference('/'+proposal.Id);
        if(!string.isEmpty(proposal.Id) && !string.isEmpty(proposal.APTS_CVM_Email_Address__c)){
            try{
                proposal.APTS_CVM_Email_Sent__c = true;
                update proposal;
                return proposalPage;
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                return null;
            }            
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invalid Proposal'));
            return null;
        }
    }
}