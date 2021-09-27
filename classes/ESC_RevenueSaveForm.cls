public without sharing class ESC_RevenueSaveForm extends ESC_FormsAbstractExecute {

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
                    Group g=[Select Id from Group where DeveloperName =:Label.USLSubscriptionTeam]; 
                    case newcase = new case();
                    newcase.id = caseid;
                    newcase.OwnerId=g.Id;
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