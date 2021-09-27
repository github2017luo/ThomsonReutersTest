/**********************************
 
Class Name: ESC_CreateFormReferral
Purpose: This class for creating Referral to Enterprise Write off from failure scenarios. DSS-7602/DSS-7603/DSS-3295/DSS/3296
 and TRTA Corp Charge cancellation form failure scenarios DSS-7482/DSS-7483
**********************************/
/**
 * @description ESC_CreateFormReferral class
 */
public without sharing class ESC_CreateFormReferral{
 
  @InvocableMethod(label='ESC_CreateReferral on Form failure')
    public static void createFormReferral(list<case> cases){   
     List<case> caseacc  = new List<case>();
     List<ESC_Case_Form_Extension__c> caseextlist = new List<ESC_Case_Form_Extension__c>();
     List<ESC_Case_Form_Extension__c> writeoffcaseextlist = new List<ESC_Case_Form_Extension__c>();
     List<ESC_Case_Form_Extension__c> chargecaseextlist = new List<ESC_Case_Form_Extension__c>();
     List<ESC_case_collaborator__c > caseref = new List<ESC_case_collaborator__c >();
     boolean hasref = false;
     boolean hasccref = false;
         if (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){       
             caseacc = [Select Id,CaseNumber,owner.email,contactid,BU_Segment__c,LCRM_Sub_BU__c,Form_Name_New__c,contactphone,AccountId,USL_SAP_Account_Number__c,ESC_Email_Thread_Id__c FROM Case where id =:cases[0].id];
            }
         if (Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible() || Schema.sObjectType.ESC_Case_Form_Extension__c.isQueryable()){
            caseextlist = [Select id,USL_Approval_Type__c ,ESC_Form__c,ESC_Form__r.name, USL_CSSWriteOffFormTypeID__c ,ESC_Instructions__c,ESC_Form_BU__c,Select_form_Type__c,Service_Notification_Number__c,Risk_Category__c,USL_Requester_Title__c,ESC_Cancel_Requestor__c,USL_Requestor_ID__c,USL_WestLaw_Plan__c  from ESC_Case_Form_Extension__c where ESC_Case__c=:cases[0].id];
             }
             System.debug(logginglevel.warn,'caseextlist --->' + caseextlist);
         for(ESC_Case_Form_Extension__c cfe : caseextlist){
             if(cfe.USL_Approval_Type__c =='Writeoff'){
                 writeoffcaseextlist.add(cfe);
             }
             else{
                 chargecaseextlist.add(cfe);
             }
         }
         if (Schema.sObjectType.ESC_case_collaborator__c .isAccessible() || Schema.sObjectType.ESC_case_collaborator__c .isQueryable()){
             caseref = [select id, name,ESC_Form_Id__c,ESC_Form_Name__c  from ESC_case_collaborator__c where ESC_case__c =: cases[0].id];
             }
             System.debug(logginglevel.warn,'caseref --->' + caseref); 
         for (ESC_case_collaborator__c ref : caseref){
              if(ref.ESC_Form_Name__c  == 'Write Off Form' || ref.ESC_Form_Name__c =='Write Off Exception Form'){
                  hasref = true;
                 }
                 if(ref.ESC_Form_Name__c  == 'Charge Cancellation'){
                  hasccref = true;
                 }
         } 
         System.debug(logginglevel.warn,'hasref--->' + hasref); 
         
            try{
            if(writeoffcaseextlist.size()>0 && !hasref){
            ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(cases[0].id,writeoffcaseextlist[0].ESC_Form__c ,writeoffcaseextlist[0].ESC_Form__r.name);
            if(obj.validateFormSegmentMappingExist()){
           
              obj.createReferral();
              }else{
              
            List<ESC_Case_Collaborator__c> insertref = new List<ESC_Case_Collaborator__c>();
            List<group> queuelist = new List<group>();
                if(Schema.sObjectType.Group.isAccessible() || Schema.sObjectType.Group.isQueryable()){
                 queuelist = [select id,Name,DeveloperName from Group where Type ='queue' and DeveloperName ='C2C_USL_Write_Off']; 
                }
                ESC_Case_Collaborator__c ref1 = new ESC_Case_Collaborator__c();
                ref1.ESC_Case__c = cases[0].id;
                ref1.ESC_Role__c = 'Accountable Resolver';
                ref1.ESC_Referral_Status__c = 'New';
                ref1.Ownerid = queuelist[0].id;
                insertref.add(ref1);
                if(insertref.size()>0 && (Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible() || Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable())){
                 insert insertref;
                }
            }
            
           }
            if(chargecaseextlist.size()>0 && !hasccref){
              ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(cases[0].id,chargecaseextlist[0].ESC_Form__c ,chargecaseextlist[0].ESC_Form__r.name);
              obj.createReferral();
              }
            }
             catch(exception ex){
              system.debug('Exception : ' + ex.getMessage() + ex.getLineNumber());
              ApplicationLogUtility.logException('ESC_Writeoff','ESC_CreateFormReferral','createFormReferral',ex);
              } 
               
    }
    }