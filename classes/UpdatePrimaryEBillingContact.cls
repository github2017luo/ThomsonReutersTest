/*
======================================================================================================================
CLASS NAME:  UpdatePrimaryEBillingContact
======================================================================================================================
=
PURPOSE: Update the E-Billing contact on Quote if new Ebilling Contact Role is 
            created for Related Opportunity

CHANGE HISTORY:
======================================================================================================================
DATE            NAME                    DESC
2015-12-15      Harika Sai              (Created)Update the E-Billing contact on Quote if new Ebilling Contact Role is 
                                        created for Related Opportunity
2017-03-15      Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public without sharing class UpdatePrimaryEBillingContact{
    public Opportunity opp;
    Public Quote OpportunityQuote;
    Public id EBillContact;
    Public Id BoletoContact;
    //Public Id GiroEmpCon;

    
    public UpdatePrimaryEBillingContact( ApexPages.StandardController stdController ){
        opp = ( Opportunity )stdController.getRecord();  
/*System.Debug('********opp id'+opp.id);-- commented to reduce character for s2e optimization */
    }
    
    public void CheckNewEBillingContact(){
    if(checkRecursive.runOnce()){
/*System.Debug('********Inside CheckNewEBillingContact');-- commented to reduce character for s2e optimization */
        //OppId = ApexPages.currentPage().getParameters().get('id');
/*system.debug('Inside method::');-- commented to reduce character for s2e optimization */
        string ProfileName = [Select id, name from Profile where ID=: UserInfo.getProfileId()].Name;
/*system.debug('ProfileName ::'+ProfileName );-- commented to reduce character for s2e optimization */
        if(ProfileName  == 'LatAm User' || ProfileName  == 'Partner Portal User'){
/*System.Debug('********Inside Profilecheck IF');-- commented to reduce character for s2e optimization */
            List<OpportunityContactRole> OppContactRoles = [Select Id,ContactId,OpportunityId,Role from OpportunityContactRole where OpportunityId =: opp.id AND (Role=: 'E-Billing Contact' OR Role =: 'Boleto Contact') ORDER BY createddate DESC];
/*system.debug('OppContactRoles ::'+OppContactRoles);-- commented to reduce character for s2e optimization */
            OpportunityQuote = [Select Id,Primary_Quote__c,E_Billing_Contact__c,Boleto_Contact__c from Quote where OpportunityId =:Opp.id AND Primary_Quote__c=: True LIMIT 1];
            for(OpportunityContactRole ConRole: OppContactRoles){
                 if(ConRole.Role == 'E-Billing Contact' && EBillContact == Null)
                     EBillContact = ConRole.ContactId;
                 if(ConRole.Role == 'Boleto Contact' && BoletoContact == Null)  
                     BoletoContact = ConRole.ContactId;
                 /*if(ConRole.Role == 'Giro Empresarial'&& GiroEmpCon == NULL)  
                     GiroEmpCon = ConRole.ContactId;  */   
/*system.debug('EBillContact ::'+EBillContact ); 
                 system.debug('BoletoContact ::'+BoletoContact);-- commented to reduce character for s2e optimization */       
            }
            boolean isChanged = false; 
            if(BoletoContact != Null && OpportunityQuote.Boleto_Contact__c != BoletoContact){
                //UpdatePrimaryEBillingContact.UpdateEBillingContactInQuote(OpportunityQuote.id, OppContactRoles.ContactId);  
/*system.debug('BoletoContact Loop::'+BoletoContact);-- commented to reduce character for s2e optimization */
                OpportunityQuote.Boleto_Contact__c = BoletoContact ;
                isChanged = true;
            } 
            if(EBillContact != Null && OpportunityQuote.E_Billing_Contact__c != EBillContact){
                //UpdatePrimaryEBillingContact.UpdateEBillingContactInQuote(OpportunityQuote.id, OppContactRoles.ContactId);  
/*system.debug('EBillContact Loop::'+EBillContact );-- commented to reduce character for s2e optimization */
                OpportunityQuote.E_Billing_Contact__c = EBillContact ;
                isChanged = true;
            }
            /*if(OpportunityQuote.Giro_Empresarial__c!= GiroEmpCon){
                //UpdatePrimaryEBillingContact.UpdateEBillingContactInQuote(OpportunityQuote.id, OppContactRoles.ContactId);  
            system.debug('GiroEmpCon Loop::'+GiroEmpCon);
                OpportunityQuote.Giro_Empresarial__c = GiroEmpCon;
                
            }*/
/*System.Debug('********Quote Update='+OpportunityQuote);-- commented to reduce character for s2e optimization */
            if(OpportunityQuote != null && isChanged == true){
                update OpportunityQuote;
            }
            /********************************************************************************
                Description: Update Child Opportunity Contact Role while Master Opportunity 
                             Contact Role is an E-Billing Contact or Boleto Contact.
                Author: TCS Ltd.
                Created Date: 2nd June, 2016
                 
            *********************************************************************************/
            /*System.debug('***********Master Opportunity='+opp.id);
            List<Opportunity> lstChldOppty = [SELECT id, Master_Opportunity__c, Is_Child_Opportunity__c  
                                              FROM Opportunity
                                              WHERE Is_Child_Opportunity__c =: true 
                                              AND Master_Opportunity__c =: opp.id 
                                              ORDER BY createddate DESC];
            
            System.Debug('********parent Opportunity contact role='+OppContactRoles);
            System.Debug('********Child Opportunity List='+lstChldOppty.size());
            
            Set<id> setChildOpptyId = new Set<id>();
            
            if(lstChldOppty.size() > 0) {
                For(Opportunity op: lstChldOppty) {
                    setChildOpptyId.add(op.id);
                }
            System.debug('********ChildOpptySet='+setChildOpptyId);
            }
            
            List<OpportunityContactRole> lstOppChldContactRoles;
            
            if(setChildOpptyId.size() > 0) {
            lstOppChldContactRoles = [SELECT Id, ContactId, OpportunityId, Role 
                                        FROM OpportunityContactRole 
                                        WHERE OpportunityId IN: setChildOpptyId 
                                        AND (Role=: 'E-Billing Contact' OR Role =: 'Boleto Contact') 
                                        ORDER BY createddate DESC]; 
                                        
            System.Debug('********Child Opportunity Contact Role List='+lstOppChldContactRoles);
            }
            
            List<OpportunityContactRole> lstUpdateOppChldContactRoles = new List<OpportunityContactRole>();
            if(lstOppChldContactRoles != null) {
                For(OpportunityContactRole opcr: lstOppChldContactRoles) {
                    lstUpdateOppChldContactRoles.add(opcr);
                }
            }
            
            if(lstUpdateOppChldContactRoles.size() > 0) {
                delete lstUpdateOppChldContactRoles;
            }
            
            lstUpdateOppChldContactRoles = new List<OpportunityContactRole>();
            
            if(lstChldOppty.size() > 0 && OppContactRoles.size() > 0) {
                For(OpportunityContactRole objOPCR: OppContactRoles) {
                    For(Opportunity objOP: lstChldOppty) {
                        lstUpdateOppChldContactRoles.add(new OpportunityContactRole(
                                                            ContactId = objOPCR.ContactId, 
                                                            Role = objOPCR.Role, 
                                                            OpportunityId = objOP.Id));
                    }
                }
            }
            
            if(lstUpdateOppChldContactRoles.size()> 0) {
                System.Debug('********Child Opportunity Contact Role to update='+lstUpdateOppChldContactRoles);
                insert lstUpdateOppChldContactRoles;
            }
            */
        }
      }
    }        
    
  /*  @future public static void UpdateEBillingContactInQuote( Id QuoteId, Id EbillingCon ) {
        Quote PrimaryQuote = [Select Id,Primary_Quote__c, E_Billing_Contact__c from Quote where id=: QuoteId ];
        
        PrimaryQuote.E_Billing_Contact__c = EbillingCon;
        
        try{
            update PrimaryQuote;
        }catch(Exception e){
           System.debug(e+'*********'+e.getLinenumber()+e.getmessage());
        }   
    }*/
}