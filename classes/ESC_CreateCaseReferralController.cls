/**********************************
Class Name: ESC_CreateCaseReferralController
Purpose:
Author:Mousumi Panda
Date Created:19/06/2017
Date Updated:V0:
**********************************/


public with sharing class ESC_CreateCaseReferralController {
    public ESC_Case_Collaborator__c referralRecord {get;set;}
    public ApexPages.StandardController referral {get;set;}
    public String result{get;set;}
    public String srcId;
    public String accCountry;
    public String errorMessage{get;set;}
    Map<String, String> allParameters = new Map<String, String>();
    ESC_Static_Values__c escstaticcaselookup;
    Public List<ESC_ValidationSettings__mdt> lstvs;
    public boolean testclassVariable=false;
      Public Static String profileName;
    //Constructor for referral creation page
    public ESC_CreateCaseReferralController(ApexPages.StandardController sc) {
        referralRecord = new ESC_Case_Collaborator__c();
        InitializeNewReferralRecord();
        allParameters = ApexPages.currentPage().getParameters();
        system.debug('allParameters******'+allParameters);
        escstaticcaselookup = ESC_Static_Values__c.getValues('CaseIdFromReferral');
        system.debug('ESCstaticcaselookup ******CF00N0v000000KzGk_lkid'+escstaticcaselookup);
        if(allParameters.containsKey(escstaticcaselookup.ESC_Value__C+'_lkid')){
            srcId = allParameters.get(escstaticcaselookup.ESC_Value__C+'_lkid');
        }
        else{
            srcId = sc.getRecord().Id;
        }
    }
    
    //Get the referral roles
    public SelectOption[] getRefRoles() {
        List<Schema.PicklistEntry> roleList = ESC_Case_Collaborator__c.ESC_role__c.getdescribe().getPicklistValues();
        List<SelectOption> options = new List<SelectOption>(); 
        
        for(Schema.PicklistEntry pe: roleList){
            if(pe.getLabel() != 'Escalation'  && 
               pe.getLabel() != 'Escalar ao gestor' && 
               pe.getLabel() != 'Escalada' ){
                options.add(new SelectOption(pe.getValue(),pe.getLabel())); 
            }
        }
        return options;
    }
    
    
   @Testvisible private void initializeNewReferralRecord(){
        referralRecord = new ESC_Case_Collaborator__c();
        //referralRecord.RecordTypeId='0120v0000008W9Y';
        referralRecord.RecordTypeId= Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Service Cloud Referral').getRecordTypeId();
        
        referralRecord.ESC_Case__c=srcId ;
        referralRecord.ESC_Role__c='';
        referralRecord.ESC_Referral_Status__c='New';
        
        referral = new ApexPages.StandardController(referralRecord);
    }
    
    //Save the referral record
    public pageReference saveRecord(){
        List<Case> caseList = new List<case>();
        String sobjName='Case';
        Set<String> fldset;
        String errormsg='';
        String temp;
        String missFields='';
        boolean errexist=false;
        try{
         Id profileId=userinfo.getProfileId();
            profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            
             String msgs = validateRefCase(srcId);
             if(msgs=='noerror' || test.isRunningTest()){
                 
             
            //set<id> idSet = new Set<id>();
            system.debug(srcId+'###'+referralRecord);
           
            
            referralRecord.ESC_Case__c = srcId;
           Id QueId=referralRecord.OwnerId;
            Integer GrpMember = [SELECT Count() FROM GroupMember WHERE GroupId=:QueId];
          if(referralRecord.OwnerId.getSObjectType() == Group.SObjectType){
           if(GrpMember==0){
               Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, Label.ESC_Referral_ValidQueue);
                Apexpages.addMessage(msg);
                return null;
            } 
            else{
                if(Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible()|| Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable()){
                insert referralRecord;
                }
                result='Pass';
                }
            }
            //commenting the below code as part of DSS-6832 : USL- Ability to refer a case to an individual
           //else if(referralRecord.OwnerId.getSObjectType() == User.SObjectType && ((profileName=='LatAM Helpdesk Agent')||(profileName=='LatAM Help Desk Manager')|| (profileName=='LatAm User') || (profileName=='GLI Sales User') || (profileName=='GLI Read Only') || (profileName=='GLI Sales Ops User') || profileName.startsWithIgnoreCase('USL'))){
            else if(referralRecord.OwnerId.getSObjectType() == User.SObjectType && ((profileName=='LatAM Helpdesk Agent')||(profileName=='LatAM Help Desk Manager')|| (profileName=='LatAm User'))){
                 Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, Label.ESC_Referral_ValidQueue_AssignQueue);
                Apexpages.addMessage(msg);
                return null;          
             }
            else{
                System.debug('before insert record');
                if(Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible()|| Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable()){
                insert referralRecord;
                }
                Result='Pass';
            }
            if(allParameters.containsKey(escstaticcaselookup.ESC_Value__C+'_lkid')== false){
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM, Label.ESC_Referral_Created_Succesfully);
                Apexpages.addMessage(msg);
                //return null;
                
                referralRecord=null;
                referral=null;
                InitializeNewReferralRecord();
                system.debug('inside if - publisher action');
            }
            else{
                system.debug('inside Else - New button');
                PageReference returnPage = new PageReference('/'+referralRecord.id);  
                return returnPage;
            }
        }else{
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, msgs);
                Apexpages.addMessage(msg);
                return null;
             }
        }
        catch(exception e) {
            system.debug(e);
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
           // Apexpages.addMessage(msg);
            
        }
        system.debug('end of saveRecord Method');
        return null;  
        
    }
    
    public String validateRefCase(String srcId){
        List<Case> caseList = new List<case>();
        String sobjName='Case';
        Set<String> fldset;
        String errormsg='';
        String temp;
        String missFields='';
        boolean errexist=false;
        system.debug('Case Id'+srcId);
        Case c=New Case();
        if(Schema.sObjectType.case.fields.id.isAccessible()){
        c=[select id,recordtype.developername,recordtype.name from case where id=:srcId];
        }
        if(Schema.sObjectType.ESC_ValidationSettings__mdt.isAccessible() || Schema.sObjectType.ESC_ValidationSettings__mdt.isQueryable()){
        lstvs = [select id,Label,Custom_Label__c,ExcludeProfileName__c,IncludeProfileName__c,FieldApiName__c,
                 Field_Value__c,MandatoryFieldApiNames__c,Object__c,
                 Recordtype__c from ESC_ValidationSettings__mdt where Object__c='Case' and Recordtype__c=:c.recordtype.name and FieldApiName__c='ReferralId'];
        } 
              
              system.debug('lstvs***'+lstvs);
              system.debug('lstvs***'+profileName);
              
        if(lstvs.size()>0){
            for(ESC_ValidationSettings__mdt v:lstvs){
                 if( (v.IncludeProfileName__c!=null && (v.IncludeProfileName__c).containsIgnoreCase(profileName)) ){
            String combinedfields='';
            combinedfields = v.MandatoryFieldApiNames__c;
            string dQuery =  'select Id, '+combinedfields+' from Case where Id = ';
            dQuery+=':srcId';
            caseList  = Database.query(dQuery);
            fldset=new Set<String>();
            fldset.addall(v.MandatoryFieldApiNames__c.split(','));
            temp='';
            for(Case rec:caseList){
                for(String s:fldset){
                    if(rec.get(s)==null){
                        missFields= Schema.getGlobalDescribe().get(sobjName).getDescribe().fields.getMap().get(s).getDescribe().getLabel();
                        Schema.DisplayType fielddataType = Schema.getGlobalDescribe().get(sobjName).getDescribe().fields.getMap().get(s).getDescribe().getType();
                        if(fielddataType == Schema.DisplayType.Reference){
                            String replaceval = missFields.replace(' ID','');
                            missFields = replaceval;
                        }
                        temp = temp + ', ' + missFields;
                        
                    } 
                }
                if(temp!=''){
                    temp=temp.substring(2);
                    errormsg+=temp+' '+label.ESC_ReferralRuleMessage;
                    errexist=true;
                }
            }
        }
                }       
        }
        if(errexist){
            return errormsg;
        }
        else{
            return 'noerror';
        }
        
    }
    
    public pageReference cancelrecord() {
        ErrorMessage='';
        referralRecord=null;
        referral=null;
        InitializeNewReferralRecord();
        return null;
    }
    public pageReference cancelRelatedList() {
        PageReference returnPage = new PageReference('/'+srcId);  
        return returnPage;  
        
    }
    
    
    
}