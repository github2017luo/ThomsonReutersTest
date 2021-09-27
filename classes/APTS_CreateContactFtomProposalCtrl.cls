/* APTS_CreateContactFtomProposalCtrl
 * Extension class for APTS_CreateContactFromProposal page.
 *
 * Developer: Akshay Mewada, APTTUS
 * Business Owner: 
 *
 * Scenario:
 * 
 * 
 *
   ***************************************************************************************************
   Modification Log:
   *
   *    Akshay Mewada, 11/17/2016 - Created.
   ***************************************************************************************************
*/  
public with sharing class APTS_CreateContactFtomProposalCtrl {
	Public Contact contactObj {get; set;}
	public Boolean isSaving {get; set;}
	Apttus_Proposal__Proposal__c proposalObj;
	ID proposalID;

	public APTS_CreateContactFtomProposalCtrl() {
		proposalID = ApexPages.currentPage().getParameters().get('Id');
		proposalObj = new Apttus_Proposal__Proposal__c(id=proposalID);
		contactObj = new Contact();
		isSaving = false;	
	}

	public void doAction()
	{
		proposalObj = [SELECT Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c WHERE ID = :proposalID];
		contactObj.AccountID = proposalObj.Apttus_Proposal__Account__c;
	}

	public PageReference doSave()
	{
		try
		{
			isSaving = true;
			insert contactObj;

			proposalObj.APTS_Order_Confirmation_Contact__c = contactObj.ID;
			update proposalObj;
			System.debug('APTS_CreateContactFtomProposalCtrl - contactObj: ' + contactObj);
			System.debug('APTS_CreateContactFtomProposalCtrl - proposalObj: ' + proposalObj);
			return new PageReference('/' + proposalID);
		}
		catch(Exception exc)
		{
			isSaving = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, exc.getMessage()));   
			return null;
		}
	}

	public PageReference doCancel()
	{
		System.Debug('APTS_CreateContactFtomProposalCtrl - proposalID: ' + proposalID);
		return new PageReference('/' + proposalID);
	}
}