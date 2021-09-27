public without sharing class ESC_OrderCorrection extends ESC_FormsAbstractExecute {

    public override void executePreRender(){
       
    }
    
    public override void validateForms(){
    
    }
    public override void executePostSubmit(){
        try{
            system.debug('ESC_Case__c    :' +caseId);
               system.debug('ESC_Form__c :' +formId);
            List<Case> caseupdatelist=new List<Case>();
             list<ESC_Case_Form_Extension__c> escfrom = new list<ESC_Case_Form_Extension__c>();
             escfrom=[Select id,ESC_Case__c,ESC_Form__c,Material_Correction_Required__c from  ESC_Case_Form_Extension__c  where ESC_Case__c=:caseId AND ESC_Form__c =:formId];
             system.debug('escfrom :' +escfrom);
              
             List<ESC_Case_Form_Extension__c> MCRform =new List<ESC_Case_Form_Extension__c>();
              List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
              List<Group> g=[Select Id,DeveloperName from Group where DeveloperName =:Label.ESC_Reinstatement_Form OR DeveloperName =:Label.OrderManagement ];
              
              Map<string,Id> mapg =new Map <String,id>();
              for(Group gList :g){
                  mapg.put(gList.DeveloperName,gList.id);                 
                  
              }  
              system.debug('Mapg :' +mapg);
              
              system.debug('cTestharsha1 :'+ escfrom);
             for(ESC_Case_Form_Extension__c c: escfrom){ 
                    system.debug('cTestharsha :'+ c);                   
                if(c.Material_Correction_Required__c=='Incorrect Price - Findlaw Only'){               
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,formname);
                    if(obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
                    }
                    else{                      
                        ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
                        ref.ESC_Role__c = 'Accountable Resolver';
                        ref.ESC_Referral_Status__c = 'New';
                        ref.ESC_Case__c = caseid;                    
                        ref.ownerid = mapg.get(Label.ESC_Reinstatement_Form);                                    
                        referralinsertlist.add(ref);
                    }
                }else{
                   
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,formname);
                    if(obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
                    } 
                    else{ 
                        ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
                        ref.ESC_Role__c = 'Accountable Resolver';
                        ref.ESC_Referral_Status__c = 'New';
                        ref.ESC_Case__c = caseid;
                        //ref.ownerid = g[0].id;
                        ref.ownerid = mapg.get(Label.OrderManagement);
                        referralinsertlist.add(ref);
                     }
                }
            }
                if(referralinsertlist.size() > 0)
                insert referralinsertlist;
            
            
        }
        catch(exception e) {          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
            
        }
    }
}