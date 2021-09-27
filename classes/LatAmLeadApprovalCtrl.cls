/**
* Story:        Created as part LatAm Community Project
*               Controller For Vf Page LatAmLeadApproval
* Description: If fields mentioned in user story are present on record then trigger approval process else throw error
**/


public without sharing class LatAmLeadApprovalCtrl{
    ApexPages.standardController leadSC = null;
    public Lead leadDetails = new Lead();
    public String leadId {get;set;} 
    // public String leadPageID = ApexPages.currentPage().getParameters().get('id');
    public String sErrorMsg='';
    public boolean bError {get;set;}
    //public boolean ggoUserFlag ;
    
    //Constructor
    public LatAmLeadApprovalCtrl(){
        System.debug('inside constructor');
    }
    
    //Constructor
    public LatAmLeadApprovalCtrl(ApexPages.StandardController controller) {
        this.bError =false;
        leadSC = controller;
        leadId  = ApexPages.CurrentPage().getparameters().get(string.escapeSingleQuotes('id'));
        //ggoUserFlag = LCRMGenericComponent.validateGGOUser();
        //strProfileName = [Select Id, Name from Profile where Id =:UserInfo.getProfileId()].Name;
        //if(strProfileName ==System.Label.LatAmPartnerCommunityProfile){
        //    ggoUserFlag = true;
        //}
        system.debug('leadId : '+leadId);
        try{    
            getLeadDetails(leadId.escapehtml4());
        }catch(Exception e){
            system.debug('++++++ Exception is '+ e);
            system.debug('++++++ Exception message is  '+ e.getMessage());
            bError = true;
            ApexPages.Message msg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
    }
    // Get Lead data 
    Public void getLeadDetails(String leadId){
        try{
            if(Lead.SObjectType.getDescribe().isAccessible()  
            /*&& Schema.sObjectType.Lead.fields.Id.isAccessible()
            && Schema.sObjectType.Lead.fields.Company.isAccessible()
            && Schema.sObjectType.Lead.fields.LatAm_Solution__c.isAccessible()
            && Schema.sObjectType.Lead.fields.LatAm_Vertical__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Phone.isAccessible()
            && Schema.sObjectType.Lead.fields.MobilePhone.isAccessible()
            && Schema.sObjectType.Lead.fields.Email.isAccessible()
            && Schema.sObjectType.Lead.fields.FirstName.isAccessible()
            && Schema.sObjectType.Lead.fields.LastName.isAccessible()
            && Schema.sObjectType.Lead.fields.Customer_Sub_Type__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Industry_LatAm__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Sub_Industry_LatAm__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Billing_City__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Billing_State__C.isAccessible()
            && Schema.sObjectType.Lead.fields.Billing_Street__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Tax_Number__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Tax_Number_Type__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Billing_Zip__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Billing_Country__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Customer_Class__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Customer_Group__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Customer_Type__c.isAccessible()
            && Schema.sObjectType.Lead.fields.Approval_status__c.isAccessible()*/
            ){
                leadDetails = [select id, Company, Solution__c, Vertical__c, 
                Phone,MobilePhone, Email, FirstName, LastName, Customer_Sub_Type__c,
                Industry_LatAm__c,Sub_Industry_LatAm__c, Billing_City__c,
                Billing_State__C,Billing_Street__c,Tax_Number__c,Tax_Number_Type__c,
                Billing_Zip__c,Billing_Country__c,Customer_Class__c,Customer_Group__c,
                Customer_Type__c,Approval_status__c from lead where Id =: leadId WITH SECURITY_ENFORCED];
            }
        }catch(Exception e){
            System.debug('Ex : '+e.getMessage()+':'+e.getStackTraceString());
        }
        checkRequiredFields();
    }
    
    //method to check if required fields are populated on record
    public void checkRequiredFields(){
        System.debug('leadDetails : '+leadDetails);
        
        Schema.DescribeSObjectResult leadDescresult = Schema.SObjectType.Lead;         
        Map<string,LCRMConvertLeadCountryCode__c> countryName = LCRMConvertLeadCountryCode__c.getall()!=null?LCRMConvertLeadCountryCode__c.getall():new Map<string,LCRMConvertLeadCountryCode__c>();
        List<LatAm_Lead_Convert__mdt> leadConvertLatAm = new List<LatAm_Lead_Convert__mdt>();
        try{
            if(Schema.sObjectType.LatAm_Lead_Convert__mdt.isAccessible()){
                leadConvertLatAm = [Select MasterLabel from LatAm_Lead_Convert__mdt];
            }
        }catch(Exception e){
            System.debug('Ex : '+e.getMessage()+':'+e.getStackTraceString());
        }
        User u = AppUtil.loggedInUserDetail;
        Set<String> leadFieldsLatam = new Set<String>();
        for(LatAm_Lead_Convert__mdt val: LeadConvertLatAm){
            System.debug('LeadConvertLatAm : '+LeadConvertLatAm);
            LeadFieldsLatam.add(val.MasterLabel);
            
        }
        //System.debug('ggoUserFlag'+ggoUserFlag);
        //if(ggoUserFlag == true){
            //System.debug('ggoUserFlag inside '+ggoUserFlag);
            /*if( leadDetails.BU_Segment__c=='' || leadDetails.BU_Segment__c==null){
                sErrorMsg +=  '  '+leadDescresult.fields.getMap().get('BU_Segment__c').getDescribe().getlabel();
                bError = true;                                              
            }   
            
            if(leadDetails.PO_Box__c==null && leadDetails.Billing_Street__c==null){
                bError = true;
                sErrorMsg +=  '  '+leadDescresult.fields.getMap().get('PO_Box__c').getDescribe().getlabel()+' or '+leadDescresult.fields.getMap().get('Billing_Street__c').getDescribe().getlabel();
            }*/
            
            /*if(leadDetails.Phone==null && leadDetails.MobilePhone==null){
                bError = true;
                sErrorMsg +=  '  '+leadDescresult.fields.getMap().get('Phone').getDescribe().getlabel()+' or '+leadDescresult.fields.getMap().get('MobilePhone').getDescribe().getlabel();
            }
            for(String sfield : LeadFieldsLatam){
                if(leadDetails.get(sfield)==null){
                    sErrorMsg +=  '  '+leadDescresult.fields.getMap().get(sfield).getDescribe().getlabel();
                    bError = true;                                              
                }
            }*/
            
            sErrorMsg += checkApprovedRejected(LeadFieldsLatam, leadDescresult);
            sErrorMsg = checkFilesUploaded(sErrorMsg);
            sErrorMsg =sErrorMsg.trim();
            if(bError == true){
                leadDetails.addError(sErrorMsg);           
            }
        //}           
    }

    public String checkMetaFields(Set<String> leadFieldsLatam, Schema.DescribeSObjectResult leadDescresult){
        String sErrorMsg = '';
        if(leadDetails.Phone==null && leadDetails.MobilePhone==null){
            bError = true;
            sErrorMsg +=  '  '+leadDescresult.fields.getMap().get('Phone').getDescribe().getlabel()+' or '+leadDescresult.fields.getMap().get('MobilePhone').getDescribe().getlabel();
        }
        for(String sfield : LeadFieldsLatam){
            if(leadDetails.get(sfield)==null){
                sErrorMsg +=  '  '+leadDescresult.fields.getMap().get(sfield).getDescribe().getlabel();
                bError = true;                                              
            }
        }
        return sErrorMsg;
    }
    
    private String checkFilesUploaded(String sErrorMsg){
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        try{
            if(ContentDocumentLink.SObjectType.getDescribe().isAccessible()){
                cdlList = [SELECT ID from ContentDocumentLink WHERE LinkedEntityId = :leadDetails.Id];
            }
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
        }
        if(cdlList==null || cdlList.size()==0){
            sErrorMsg += ((sErrorMsg!=null && sErrorMsg!='')?'<br/>':'')+ System.Label.LatAmPartnerLeadFileReq;
            bError = true;
        }
        return sErrorMsg;
    }

    public String checkApprovedRejected(Set<String> leadFieldsLatam, Schema.DescribeSObjectResult leadDescresult){
        String sErrorMsg = '';
        if(leadDetails.Approval_status__c == 'Approved'){
            sErrorMsg += System.Label.LatAm_LeadCreate_ApprovedError;
            bError = true;
        }else if(leadDetails.Approval_status__c == 'Rejected'){
            sErrorMsg += System.Label.LatAm_LeadCreate_RejectedError;
            bError = true;
        }else{
            sErrorMsg += checkMetaFields(LeadFieldsLatam, leadDescresult);
            sErrorMsg =sErrorMsg.trim();
            if(sErrorMsg!=null && sErrorMsg!='' && String.isBlank(sErrorMsg)==false){
                sErrorMsg =sErrorMsg.replace('  ',', ');
                if(bError == true){
                    sErrorMsg = Label.LatAm_SubmitForApprovalReqFields+': '+sErrorMsg+'.';           
                }
                
            }
        }
        return sErrorMsg;
    }
    
    public PageReference sumbitForApproval(){
        List<String> errorList = new list<string>();
        if(bError == False){
            try{ 
                LeadId = ApexPages.currentPage().getParameters().get(string.escapeSingleQuotes('id'));
                System.debug('sumbitForApproval ');
                System.debug('LeadId'+LeadId);
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                System.debug('req '+req);
                req.setComments('Submitting request for approval');
                req.setSubmitterId(UserInfo.getUserId());
                req.setObjectId(LeadId.escapehtml4());
                Approval.ProcessResult result = Approval.process(req);
            }Catch(Exception e){
                system.debug('exp msg : '+e.getMessage());
                system.debug('exp trace : '+e.getStackTraceString());
                errorList.add(e.getMessage());
            }
        }
        if(errorList.size()>0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No matching approval process found.'));
            return null;
        }
        else{
            PageReference pageRef = new PageReference('/'+leadSC.getrecord().id);
            pageRef.setredirect(true);
            return pageRef;  
        }
        
    }
    
}