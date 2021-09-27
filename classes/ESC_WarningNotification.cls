public without sharing class ESC_WarningNotification extends ESC_FormsAbstractExecute {

    public override void executePreRender(){
       
    }
    
    
    public override void validateForms(){
    
    }
    public override void executePostSubmit(){
        try{
              ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,formname);
              if(obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
                 }                    
            else{
            List<Case> caseupdatelist=new List<Case>();
            List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
            Group g=[Select Id from Group where DeveloperName =:Label.EntitlementPasswords]; 
            ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
            ref.ESC_Role__c = 'Accountable Resolver';
            ref.ESC_Referral_Status__c = 'New';
            ref.ESC_Case__c = caseid;
            ref.ownerid = g.id;
            referralinsertlist.add(ref);
            insert referralinsertlist;
            case newcase = new case();
            newcase.id = caseid;
            caseupdatelist.add(newcase);
            update caseupdatelist;
            }
            
        }
        catch(exception e) {          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
            
        }
    }


}