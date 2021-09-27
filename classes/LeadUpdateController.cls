/**
 * Controller for the LeadDiscrdReasonUpdate.page 
 *
 * @author  Nandita Shet
 * @version 2012-07-11
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-07-11   Nandita Shet        Created                                                                   
 * =============================================================================
 */

public with sharing class LeadUpdateController {

    public List<String> ListLeadIds;
    Public List<Lead> listLeads = new List<Lead>(); 
    public List<SelectOption> DiscardReasonOptions;
    public String DiscardReason{get;set;}
    public PageReference oPageReference = new PageReference('/00Q/o');

    public LeadUpdateController(ApexPages.StandardController controller) {

       String Ids = apexpages.currentpage().getparameters().get('Ids');
       ListLeadIds = Ids.replace(',',';').split(';');
       
       listLeads = [Select Id,Name,Discard_Reason__c from Lead where Id IN : ListLeadIds];
    }
    
    public List<SelectOption> getDiscardReasonOptions() {
            List<SelectOption> options = new List<SelectOption>();
            
            Schema.DescribeFieldResult fieldResult = Lead.Discard_Reason__c.getDescribe();
            List<Schema.PicklistEntry> picklistvalues = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry ple : picklistvalues )
               {
                  options.add(new SelectOption(ple.getLabel(), ple.getValue()));
               }    
            return options;
        }
    public PageReference Save(){
       
        for(Lead oLeadRec : listLeads ){
            oLeadRec.Discard_Reason__c = DiscardReason;
        }
        update listLeads;
        return oPageReference ;
       
    }
    
   
}