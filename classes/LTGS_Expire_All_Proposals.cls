/* Class: LTGS_Take_Ownership
 * Purpose:Controller class to fetch list of proposals related to an opportunity to expire them and update the opportunity as well.
 * Created: 4/9/2019
 * Author: Ankit Raj 
 
 * CHANGE HISTORY
 * ==========================================================================================================
 *  Date          Name                 Description
 *  2019-04-09    Ankit                Initial Version
 * ==========================================================================================================
 
 */
public without sharing class LTGS_Expire_All_Proposals {
    /****************************************************************************************************************************
                getProposal() fetches list of proposals related to opportunity
    *****************************************************************************************************************************/ 
     
    @auraEnabled
    public static List<Apttus_Proposal__Proposal__c> getProposal(Id recordId)
    {
        List<Apttus_Proposal__Proposal__c> proposal;
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable())
        proposal=[Select Apttus_Proposal__Opportunity__r.OwnerId,Apttus_Proposal__Opportunity__r.Owner.Name, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =:recordId AND is_Digital_Channel__c = TRUE AND (Apttus_Proposal__Approval_Stage__c != 'Expired' AND Apttus_Proposal__Approval_Stage__c != 'Accepted' AND Apttus_Proposal__Approval_Stage__c != 'Denied')]; 
       return proposal;
    }
     
    /****************************************************************************************************************************
                updateSuccess() expires all proposal and update opportunity
    *****************************************************************************************************************************/ 
     
    @auraEnabled
    public static Integer updateSuccess(List<Apttus_Proposal__Proposal__c> listProposal,Id recordId)
    {
       
       Integer status=0;
        //String msg;
        try{
           
        List<Apttus_Proposal__Proposal__c> childQuotes= new List<Apttus_Proposal__Proposal__c>();
        
        for(Integer i = 0; i < listProposal.size(); i++){		
	  Apttus_Proposal__Proposal__c cProposal = new Apttus_Proposal__Proposal__c();	  
	  cProposal.Id = listProposal[i].Id;
	  cProposal.Apttus_Proposal__Approval_Stage__c = 'Expired';
	  childQuotes.add(cProposal); 
	}
    if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable())
	update childQuotes;
     else{status=2;return status; }  
	 Opportunity thisOb = new Opportunity(); 
	 thisOb.Id = recordId;
	 thisOb.StageName = '0%';
	 thisOb.Status__c = 'Discarded';
	 thisOb.Win_Loss__c = 'Lost';
	 thisOb.Reason__c = 'Abandoned';
	 thisOb.Was_There_a_Competitor__c = 'Unknown';
	
	 if (Schema.sObjectType.Opportunity.isUpdateable()) update thisOb;
     else{status=3;return status;} 
    }
   catch(Exception E){status=1;    return status;}
        
        return status;
    }
  
}