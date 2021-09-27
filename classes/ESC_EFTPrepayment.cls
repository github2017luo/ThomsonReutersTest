/**********************************
Class Name: ESC_EFTPrepayment 
Purpose:create referral for form
Author:Naga Pavan
Date Created:01/08/2020
Date Updated:V0:27/03/2021
**********************************/
/**
 * @description ESC_EFTPrepayment form
 */
public without sharing class ESC_EFTPrepayment extends ESC_FormsAbstractExecute {

    public override void executePreRender(){system.debug(logginglevel.warn,'test');}
    public override void validateForms(){system.debug(logginglevel.warn,'test');}
    
    public override void executePostSubmit(){
     try{
            
             ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,formname);
             if(obj.validateFormSegmentMappingExist()){
                   obj.createReferral();
            } 
            else{  
                 List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
                 Group g = new Group();
                 if(Schema.sObjectType.Group.isAccessible() || Schema.sObjectType.Group.isQueryable()){
                 g=[Select Id from Group where DeveloperName =:Label.C2C_USL_Cash_App]; 
                 }
                     ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
                     ref.ESC_Role__c = 'Accountable Resolver';
                     ref.ESC_Referral_Status__c = 'New';
                     ref.ESC_Case__c = caseid;
                     ref.ownerid = g.id;
                     referralinsertlist.add(ref);
                     if(Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable()){
                     insert referralinsertlist;  
                     } 
                 }
            }
        catch(exception e){          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
            }
        }
}