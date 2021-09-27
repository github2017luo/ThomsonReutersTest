/**********************************
Class Name: ESC_CaseUPDFlagUncheckingController
Purpose:Used in by Page "CaseUPDFlagUnchecking" to Uncheck UPD Flag
Author:Mousumi
Date Created:01/08/2017
Date Updated:V0:
***********************************/
public without sharing class ESC_CaseUPDFlagUncheckingController{

    Case cs = new Case();
    Id id;
    List<ESC_Case_Collaborator__c> listRef = new List<ESC_Case_Collaborator__c>();


    public ESC_CaseUPDFlagUncheckingController(ApexPages.StandardController controller) {
    String idCaseURL=ApexPages.currentPage().getParameters().get('id');
    if((Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()) || (Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isQueryable())){
      cs= [SELECT Id,ESC_UPD__c,OwnerId,ESC_UPD_Action__c,ESC_Omni_Routed__c,ESC_Last_Update__c, ESC_UPD_Resolver__c, ESC_ResolverID__c FROM Case WHERE Id = :idCaseURL];
      listRef = [Select id,ESC_ReferralUPD__c,OwnerId from ESC_Case_Collaborator__c Where ESC_Case__c =:idCaseURL and ESC_Referral_Status__c != 'Cancelled' and ESC_Referral_Status__c != 'Closed' and ESC_Referral_Status__c != 'Completed'];
    }
    }


    public PageReference uncheckUPDFlag() {
    
    if(UserInfo.getUiThemeDisplayed() =='Theme4u' || UserInfo.getUiThemeDisplayed() =='Theme4d'){
        return null; 
    }
    Case c = new Case();
    if(cs.OwnerId == UserInfo.getUserId() && cs.ESC_UPD__c== True){
        c.ESC_UPD__c=False;
        c.ESC_UPD_Action__c= string.isNotBlank(cs.ESC_UPD_Action__c)? '':cs.ESC_UPD_Action__c;
        c.id=cs.id;
     // Code block for new UPD Logic START
        if(!cs.ESC_UPD_Resolver__c){
        c.ESC_UPD_Action__c= string.isNotBlank(cs.ESC_UPD_Action__c)? '':cs.ESC_UPD_Action__c;
        c.ESC_Last_Update__c= string.isNotBlank(cs.ESC_Last_Update__c)? '':cs.ESC_Last_Update__c;
        }
     }
     else if(cs.ESC_ResolverID__c == UserInfo.getUserId()&& cs.ESC_UPD_Resolver__c){
        c.id=cs.id;
        c.ESC_UPD_Resolver__c=false;
        if(!cs.ESC_UPD__c){
        c.ESC_UPD_Action__c= string.isNotBlank(cs.ESC_UPD_Action__c)? '':cs.ESC_UPD_Action__c;
        c.ESC_Last_Update__c= string.isNotBlank(cs.ESC_Last_Update__c)? '':cs.ESC_Last_Update__c;
        }
     }
     //added for DSS-4105/Dss-4106
     /*if((cs.ESC_ResolverID__c == ' ' || cs.ESC_ResolverID__c == null)&& cs.ESC_UPD_Resolver__c){
        c.id=cs.id;
        c.ESC_UPD_Resolver__c=false;
     }*/
          //Added to uncheck the Omni Routed Checkbox if its checked as part of for Validation Framework Skipping-USL
     if(cs.OwnerId == UserInfo.getUserId() && cs.ESC_Omni_Routed__c){
        c.id = cs.id;
        c.ESC_Omni_Routed__c = false;
     }
     if(c.id!=null && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){
     update c;
     }
     
     // Code block for new UPD Logic START
     List<ESC_Case_Collaborator__c> refUpdate= new List<ESC_Case_Collaborator__c>();
     if(listRef.size()>0){
        for(ESC_Case_Collaborator__c ecc : listRef){
           if(ecc.OwnerId == UserInfo.getUserId() && ecc.ESC_ReferralUPD__c == True){
              ecc.ESC_ReferralUPD__c = False;
              refUpdate.add(ecc);
           }
        }
     }
     if(refUpdate.size()>0 && (Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isUpdateable())){
     
        update refUpdate;
     }
        return null;
    }

}