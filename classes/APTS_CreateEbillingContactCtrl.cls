/* APTS_CreateEbillingContactCtrl
 * Extension class for APTS_CreateEbillingContactFromProposal page.
 *
 * Developer: Bijeta Lenka
 * Business Owner: 
 *
 * Scenario:
 * 
 * 
 *
   ***************************************************************************************************
   Modification Log:
   *
   *    Bijeta Lenka, 10/31/2017 - Created for Jira SOC- 4320 FEB-2018 release
   ***************************************************************************************************
*/  
public with sharing class APTS_CreateEbillingContactCtrl {
  Public Contact contactObj {get; set;}
  public Boolean isSaving {get; set;}
  Apttus_Proposal__Proposal__c proposalObj;
  ID proposalID;

  public APTS_CreateEbillingContactCtrl() {
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

      proposalObj.APTS_Ebilling_contact__c = contactObj.ID;
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
    System.Debug('APTS_CreateEbillingContactCtrl - proposalID: ' + proposalID);
    return new PageReference('/' + proposalID);
  }
}