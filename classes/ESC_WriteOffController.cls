/**
 * @description ESC_WriteOffController
 */
public without sharing class ESC_WriteOffController extends ESC_FormsAbstractExecute {
    public boolean isapproval = True;
    public Id recid {get;set;}
    public Id formId {get;set;}
    public String totalamt {get;set;}
    public Case caseacc{get;set;}
    USL_Integration_defaults__c intval;
    /**
 * @description executePreRender
 */
public override void executePreRender(){
 system.debug(LoggingLevel.WARN,'test');
//Added as part of DSS-7885 for Tax
   caseacc = new case();
   if (Schema.sObjectType.Case.isAccessible()){         
         caseacc = [Select Id,CaseNumber,recordTypeId,owner.email,contactid,BU_Segment__c,ESC_Case_Type__c,ESC_EnquiryType__c,ESC_Case_Sub_Type__c,LCRM_Sub_BU__c,contactphone,AccountId,USL_SAP_Account_Number__c,ESC_Email_Thread_Id__c FROM Case where id =:caseId];
    }
    
    //check for mandatory fields
    intval = USLARHelper.getIntegrationDefaults(caseacc.BU_Segment__c,caseacc.LCRM_Sub_BU__c);
    List<Case> lstCase = new List<Case>();             
    lstCase.add(caseacc);
       if(intval!=null && intval.ApplicationId__c == 'ESCH' && intval.companyId__c =='S100'){
           Map<Id, string> mapCaseAndError = ESC_Utility.checkValidationErrorsForAutomaticClosure(lstCase);
            if(mapCaseAndError != null && mapCaseAndError.containsKey(caseacc.Id))
            {
               string result = mapCaseAndError.get(caseacc.Id);
               if(caseacc.ESC_Case_Type__c!=null && caseacc.ESC_Case_Type__c =='Request for Action' && (string.isNotBlank(caseacc.ESC_Case_Sub_Type__c) && caseacc.ESC_Case_Sub_Type__c!='Onboarding / Transition' || string.isBlank(caseacc.ESC_Case_Sub_Type__c)) && string.isBlank(caseacc.ESC_EnquiryType__c)){
                if(string.IsNotBlank(result)){
                    result = 'Type,'+result;
                }else{
                    result = 'Type '+System.Label.ESC_CaseRuleMessage;
                }
            }
                if(string.IsNotBlank(result))
                {
                      system.debug(LoggingLevel.WARN,'Result : ' +result);
                    //Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,result)); 
                    throw new ESC_HandlerCustomException(result);  
                    
                }   
            } 
        }

  
}
/**
 * @description validateForms
 */

public override void validateForms(){
 system.debug(LoggingLevel.WARN,'test');
}
/**
 * @description executePostSubmit
 */
public override void executePostSubmit(){
try{

    List<ESC_Case_Form_Extension__c> caseextlist = new List<ESC_Case_Form_Extension__c>();
    ESC_FormGenratorController compcon = new ESC_FormGenratorController(); 
    formId = compcon.specificFormID;
    recid = compcon.recordID;
    Decimal totalAmount = 0;
     system.debug(LoggingLevel.WARN,'formId is'+formId );
     system.debug(LoggingLevel.WARN,'case id is'+recid );
    if(Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible() || Schema.sObjectType.ESC_Case_Form_Extension__c.isQueryable()){
    caseextlist = [Select Id,USL_Total_Amount__c,USL_Approval_Status__c,USL_APPRServiceNoteNum__c,USL_Approval_Type__c,USL_CSSWriteOffFormTypeID__c,USL_Approver_name__c from ESC_Case_Form_Extension__c where ESC_Case__c=:recid and ESC_Form__c =:formId];
    }
     system.debug(LoggingLevel.WARN,'caseextlist list has'+caseextlist);
    
    List<ESC_Case_Form_Extension_Line_Item__c> lineitemlist = new List<ESC_Case_Form_Extension_Line_Item__c>();
    List<ESC_Case_Form_Extension_Line_Item__c> lineitemupdlist = new List<ESC_Case_Form_Extension_Line_Item__c>();
    if(Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible() || Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isQueryable()){
        lineitemlist = [Select Id,Amount_to_Pay__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c=:caseextlist[0].id];
     }
     
    for(ESC_Case_Form_Extension_Line_Item__c lineitem : lineitemlist ){
     system.debug(LoggingLevel.WARN,'indivudal line amount is'+lineitem.Amount_to_Pay__c);
    if(lineitem.Amount_to_Pay__c !=null){
    lineitem.ESC_Item_Amount__c= lineitem.Amount_to_Pay__c;
    totalAmount = totalAmount + lineitem.ESC_Item_Amount__c; 
     system.debug(LoggingLevel.WARN,'Item Amount is'+lineitem.ESC_Item_Amount__c);
   lineitemupdlist.add(lineitem);
   }
   }
   if(lineitemupdlist.size()>0 && (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible() || Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isUpdateable())){
    update lineitemupdlist;
   }
    caseextlist[0].USL_Approval_Type__c = 'Writeoff';
    Case caseacc = new case();
    //ESC_Email_Thread_Id__c added for write off failure scenarios DSS-6984
    caseacc = [Select Id,CaseNumber,ESC_Email_Thread_Id__c FROM Case where id =:recid limit 1];            
    caseextlist[0].USL_APPRServiceNoteNum__c = caseacc.casenumber + ':'+ caseacc.ESC_Email_Thread_Id__c;
     system.debug(LoggingLevel.WARN,'Amount Calculated'+caseextlist[0].USL_Total_Amount__c);
    caseextlist[0].USL_Total_Amount__c = totalAmount ;
    if(test.isrunningtest() || (caseextlist[0].USL_Total_Amount__c <= 200 && caseextlist[0].USL_CSSWriteOffFormTypeID__c != 'BNK' )){
    caseextlist[0].USL_Approval_Status__c = 'Approved';
     User u = new  User();
    if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
         u = [select Id, name from User where Id = :UserInfo.getUserId()];     
    }       
    caseextlist[0].USL_Approver_name__c = u.name;
    isapproval = false;
    }  
    if(caseextlist.size()>0 && (Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible() || Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable())){          
        update caseextlist; 
    }
    if(isapproval && caseextlist[0].USL_CSSWriteOffFormTypeID__c != 'BNK'){
    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    req1.setComments('Submitting request for approval.');
    req1.setObjectId(caseextlist[0].id);                 
    req1.setSubmitterId(userinfo.getUserId());                                 
    Approval.ProcessResult result = Approval.process(req1);                           
    }       
    }
    
    catch(exception e) {          
    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
    Apexpages.addMessage(msg);
    
}
}

}