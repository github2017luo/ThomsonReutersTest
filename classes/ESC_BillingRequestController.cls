/**
 * @description Billing request form
 */
public without sharing class ESC_BillingRequestController extends ESC_FormsAbstractExecute {
/**
 * @description executePreRender
 */
    public override void executePreRender(){
       system.debug(logginglevel.warn,'test');
    }
 /**
 * @description validateForms
 */  
    public override void validateForms(){
    system.debug(logginglevel.warn,'test');
    }
/**
 * @description executePostSubmit
 */
    public override void executePostSubmit(){
        try{
        //added as part of USL Enterpriseforms DSS-8386
             ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,formname);
                    if(test.isrunningtest() || obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
                    } 
        /*
            String requesttype = '';
                        
            if(componentcontrollermap.containskey('Sec-0049')){
            ESC_FormGeneratorCompController formgen = (ESC_FormGeneratorCompController)componentcontrollermap.get('Sec-0049');
            ESC_SectionDescriber secdesc = formgen.currentDescribedSection;
            requesttype = String.valueof(secdesc.sobj.get('Request_Type_Post_Prod_Lapse__c'));
            }
            if(requesttype == 'Post Pro Lapse - Zero Out Current Month'){
                List<Case> caseupdatelist=new List<Case>();
                list<Group> g= new list<Group>();
                if (Schema.sObjectType.Group.isAccessible()){
                 g=[Select Id from Group where DeveloperName =:Label.PPSOnline];
                }   
                Case caseupd = new Case();
                caseupd.id = caseid;
                caseupd.ownerid = g[0].id;
                caseupdatelist.add(caseupd);
                update caseupdatelist;
            }
            else{
            system.debug('requesttype is'+requesttype);
            List<Case> caseupdatelist=new List<Case>();
            list<Group> g= new list<Group>();    
            List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
            if (Schema.sObjectType.Group.isAccessible()){    
              g=[Select Id from Group where DeveloperName =:Label.AmericasBilling];
            }    
            ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
            ref.ESC_Role__c = 'Accountable Resolver';
            ref.ESC_Referral_Status__c = 'New';
            ref.ESC_Case__c = caseid;
            ref.ownerid = g[0].id;
            referralinsertlist.add(ref);
            insert referralinsertlist;
            }
            }*/
        }
        catch(exception e) { Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());Apexpages.addMessage(msg);
             }
    }
}