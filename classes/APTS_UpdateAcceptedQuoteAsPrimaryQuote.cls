public without sharing class APTS_UpdateAcceptedQuoteAsPrimaryQuote{

  @InvocableMethod(label='Make accepted as primary' description='Makes the quote record as primary once it is accepted.')
  public static void makeAccepetedQuoteAsPrimary(List<Id> quoteId) {
    
    Apttus_Proposal__Proposal__c primaryProposal;
    List<Apttus_Proposal__Proposal__c> updateProposalList=new List<Apttus_Proposal__Proposal__c>();
     //SOC-9796 PMD Fix
    if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
     primaryProposal=[select id,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Primary__c from Apttus_Proposal__Proposal__c where id=:quoteId.get(0)];
    }
    for(Apttus_Proposal__Proposal__c proposal:[select id,Apttus_Proposal__Primary__c from Apttus_Proposal__Proposal__c  where Apttus_Proposal__Primary__c=:true and Apttus_Proposal__Opportunity__c=:primaryProposal.Apttus_Proposal__Opportunity__c]){
       
         proposal.Apttus_Proposal__Primary__c =false;
         updateproposalList.add(proposal);
         system.debug('entered for loop'+proposal);
       
    }
  
    if(primaryProposal.Apttus_Proposal__Primary__c!=true){
       primaryProposal.Apttus_Proposal__Primary__c=true;
       updateproposalList.add(primaryProposal);
    }
    if(!updateproposalList.isEmpty()){ 
      try{
         update updateproposalList;
         Apttus_QPConfig.QPConfigWebService.syncWithOpportunity(quoteId.get(0),true);
       }
       catch(system.dmlException ex){
        system.debug(ex.getMessage());
       }   
     }
       
  }
}