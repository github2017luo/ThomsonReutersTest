public with sharing class APTS_SegmentSelectorController {
    
    public Apttus_Proposal__Proposal__c proposal {get;set;}
    public List<String> selectedValues {get;set;}
    public String applicableClauses;
    List<String> clausesList = new List<String>();
    //public Apttus_Config2__ProductConfiguration__c cart {get;set;}
    //public static String test = 'Test';
    
    public APTS_SegmentSelectorController() {
        //Id cartId = ApexPages.currentPage().getParameters().get('id');
        //cart = [SELECT APTS_AccountMirror_Picklist__c, APTS_Clauses_Selected__c, Apttus_QPConfig__Proposald__r.APTS_Selected_Clauses__c, 
                //Apttus_QPConfig__Proposald__r.Apttus_Proposal__Account__r.FrozenMarketSegment__c 
                //FROM Apttus_Config2__ProductConfiguration__c WHERE Id =: cartId];
                
        proposal = [SELECT Id, APTS_Selected_Clauses__c, APTS_Approval_Segment__c,Customer_Group__c,APTS_Proposal_Business_Unit__c
                    FROM Apttus_Proposal__Proposal__c 
                    WHERE Id =: ApexPages.currentPage().getParameters().get('retId')];
        
        List<APTS_Clause_Mapping_Per_Segment__c> clauseMappingList = new List<APTS_Clause_Mapping_Per_Segment__c>([SELECT APTS_Approval_Segment__c, 
                                                                                                                    APTS_Applicable_Clauses__c 
                                                                                                                    FROM APTS_Clause_Mapping_Per_Segment__c]);
        System.debug('clauseMappingList ++' + clauseMappingList);
        
        for(APTS_Clause_Mapping_Per_Segment__c mapping : clauseMappingList){
            System.debug('proposal.APTS_Approval_Segment__c ++' + proposal.APTS_Approval_Segment__c);
            if(mapping.APTS_Approval_Segment__c == proposal.APTS_Approval_Segment__c  && proposal.APTS_Proposal_Business_Unit__c != 'Canada'  && proposal.APTS_Proposal_Business_Unit__c != 'Tax Professional'){
                applicableClauses = mapping.APTS_Applicable_Clauses__c;
            }
            //DOC-3980- Added by Nandha : Starts here
            if(proposal.APTS_Proposal_Business_Unit__c == 'Canada'){
                applicableClauses = System.Label.CANSELCTEDCLAUSE1;
                //Start:Jinal Bhatt: DOC-7415 - Added one more value which should be availabel for sales rep.
                applicableClauses += System.Label.CANSELCTEDCLAUSE3 +';';
                //End DOC-7415
            }
            if(proposal.APTS_Proposal_Business_Unit__c == 'Canada' && (proposal.Customer_Group__c == 'ACADEMIC' || proposal.Customer_Group__c == 'GOVERNMENT')){
                applicableClauses = applicableClauses + System.Label.CANSELCTEDCLAUSE2;
            }
            //DOC-3980- Added by Nandha : Ends here
            //DOC-9810- Added by Nandha : Starts here
            if(proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                applicableClauses = System.Label.TAXSELCTEDCLAUSE;
            }
            //DOC-9810- Added by Nandha : Ends here
        }
        System.debug('applicableClauses ++' + applicableClauses);
        
        if(applicableClauses != NULL) clausesList = applicableClauses.split(';');
        
    }
    
    public List<SelectOption> getItems() {
        List<selectOption> options = new List<selectOption>();
        
        for (String clause :  clausesList) { 
            options.add(new selectOption(clause, clause)); //for all records found - add them to the picklist options
        }
        return options;
    }

    public void doSave(){
        String finalValues = String.join(selectedValues, ';');
        proposal.APTS_Selected_Clauses__c = finalValues;
        update proposal;
        
    }
    public void doCancel(){

    }

    
}