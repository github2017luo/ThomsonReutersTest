public with sharing class APTS_CreateQuoteWithDefaultCtrl {
    String accountId, proposalId;//, opportunityId;
    String action;
    public APTS_CreateQuoteWithDefaultCtrl() {
        Map<String, String> parameters = ApexPages.currentPage().getParameters();
        accountId = parameters.get('acctId');
        proposalId = parameters.get('proposalId');
        //opportunityId = parameters.get('opportunityId');
        //System.debug(String.isBlank(opportunityId));
    }

    public PageReference doAction(){
        PageReference returnPage;
        //Create action
        if(proposalId==null){
            Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
            if(!String.isBlank(accountId))
                proposal.Apttus_Proposal__Account__c=accountId;
            //if(!String.isBlank(opportunityId))
            //  proposal.Apttus_Proposal__Opportunity__c =opportunityId;
            insert proposal;
            returnPage = new PageReference('/'+proposal.Id+'/e?retURL='+proposal.Id+'&cancelURL=/apex/APTS_CreateQuoteWithApprovalSegment?proposalId='+proposal.Id+'%26acctId='+accountId);
                //+'%26opportunityId='+opportunityId);
        }
        //Delete action
        else{
            List<Apttus_Proposal__Proposal__c> proposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Id=: proposalId];
            if(proposal!=null && !proposal.isEmpty())
                delete proposal;
            //If opportunity wasn't specified, go to the account
            //if(String.isBlank(opportunityId))
                returnPage = new PageReference('/apex/AccountDetail?id='+accountId);
            /*//Otherwise go to the opportunity
            else{
                returnPage = new PageReference('/apex/OpportunityDetail?id='+opportunityId);
            }*/
        }
        return returnPage;
    }
}