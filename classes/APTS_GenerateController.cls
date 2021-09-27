public without sharing class APTS_GenerateController {
    Id proposalId;
    public Apttus_Proposal__Proposal__c proposal{get;set;}
    public String errorMsg {get; set;}
    public Boolean isTax {get; set;}
    public Boolean isTaxQueue {get; set;}
    public Boolean isRiskS {get; set;}
    public Boolean isRiskSQueue {get; set;}
    public ID jobID;
    
    public APTS_GenerateController(){
        proposal = new Apttus_Proposal__Proposal__c();
        String propId= string.escapeSingleQuotes('id');
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get(propId))) {
            proposalId = (Id)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(propId)));
        }
        //proposalId = ApexPages.currentPage().getParameters().get('id');
        if(!string.isBlank(proposalId) && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
            proposal = [SELECT Id, APTS_Signature_Block_Required__c,APTS_Proposal_Business_Unit__c,APTS_AVC_Order_Form__c,APTS_FL_Product_Language__c FROM Apttus_Proposal__Proposal__c WHERE Id =: proposalId];   
        }
        isTax = false;
        isTaxQueue = false;
        isRiskS = false;
        isRiskSQueue = false;
        if(proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
            isTax = true;
            List<Apttus_Proposal__Proposal_Line_Item__c> listofPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){
             listofPLIs = [Select Id,Apttus_Proposal__Proposal__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =: proposalId];}
            System.debug('NandhaPLIs'+listofPLIs.size());
            if(listofPLIs.size() > Integer.ValueOf(label.PLILimit)){
                isTaxQueue = true;
            }else{
                isTaxQueue = false;
            }
        }
        else if(proposal.APTS_Proposal_Business_Unit__c == 'SCS' || proposal.APTS_Proposal_Business_Unit__c == 'Canada' ||
                (proposal.APTS_Proposal_Business_Unit__c != null && System.Label.Risk_PBUs.contains(proposal.APTS_Proposal_Business_Unit__c))){
            isRiskS = true;
            List<Apttus_Proposal__Proposal_Line_Item__c> listofPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){
             listofPLIs = [Select Id,Apttus_Proposal__Proposal__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =: proposalId];}
            System.debug('NandhaPLIs'+listofPLIs.size());
            if(listofPLIs.size() > Integer.ValueOf(label.PLILimit)){
                isRiskSQueue = true;
            }else{
                isRiskSQueue = false;
            }
        }
        system.debug('isRiskSQueue value = '+isRiskSQueue );
    }
    public PageReference generate() {
        Boolean flag=false;
        //Merging Findlaw changes starts
        Boolean checkInvent=true;
        // Start SOC-6853 added by Gowthami as part of the OC-FL dated 21/3/2018:
        // checks for inventory if inventory is 0,prints the line Item with the Product which is having the lineitem 0
        // check if the signature block is required. APTS_Signature_Block_Required__c flag is used by the template generator 
        // to decide whether to include the signature block or not. 
        String status = '';
        // String errorMsg = '';
        if(proposal.APTS_Proposal_Business_Unit__c=='FindLaw' && isTax == false){
            List<Apttus_Proposal__Proposal_Line_Item__c> listInvent=APTS_ProposalUtilities.validateProposalForInventory(proposalId);
            System.Debug('**** Prop Utilities == ' + listInvent + '*********');
            if(!listInvent.isEmpty()){
                 for(Integer i=0;i<listInvent.size();i++)
                 {
                    String errMessage = 'Inventory for line item ' +listInvent.get(i).Name+' '+'having PRODUCT'+' '+listInvent.get(i).Apttus_Proposal__Product__r.Name+' '+'is no longer available.' ;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,errMessage));   
                    System.debug('********');
                    checkInvent=false;
                 }
            }
            //SOC-9755 starts
            if(proposal.APTS_FL_Product_Language__c!=null && proposal.APTS_FL_Product_Language__c.contains('ExposurePack')){
               errorMsg =APTS_ProposalUtilities.generateExposurePackAttachment(proposalId); 
               if(!string.isEmpty(errorMsg)){                                
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, errorMsg));
                  return null;
              }
            }
            //SOC-9755 ends
                    system.debug('!!!!!!!!!!'+ checkInvent);
        }
         if((proposal.APTS_Proposal_Business_Unit__c!='FindLaw' || checkInvent) && isTax == false ){
        //end SOC-6853 Changes added as part of the OC-FL dated 21/3/2018 
        system.debug('!!!!!!!!!!'+ checkInvent);
        //APTS_Tax_ProposalTriggerHelper.templatefieldupdate(proposalId);
        //Merging Findlaw chnages ends
        status = APTS_ProposalUtilities.validateProposalForAssentFields(proposalId);
        if(string.isEmpty(status))
        status = APTS_ProposalUtilities.validateProposalForSignatureBlock(proposalId);
        System.Debug('**** Prop Utilities == ' + status + '*********');
        
        if ((status == 'Online or Master Contacts missing!!!') || (status == 'Assent info missing!!!')|| (status == System.Label.APTTUS_Error_Message) ||(status == 'Indicate if account is Law Enforcement and inmate access type.  Add applicable Selected Clause.')){// SOC-3798 by Bijeta
            System.Debug('******* in error *****');
            System.Debug('*********** status = ' + status + ' ***********'); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, status));
            return null;
        }
        
        If (status == 'Checks successful')
            flag=false;// signature block not required.
        else
            flag=true;// signature block required.
        system.debug('id--'+proposal.id);
        if(!string.isEmpty(proposal.Id)){              
            errorMsg =APTS_ProposalUtilities.generateAVC(proposalId);             
            if(!string.isEmpty(errorMsg)){ 
                proposal.APTS_AVC_Order_Form__c= true;
                if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                update proposal;  }              
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, errorMsg));
                return null;
            }
            try{
                proposal.APTS_Signature_Block_Required__c=flag;
                if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                update proposal;}
                if(isRiskS == true){
                    if(isRiskSQueue == true){
                        jobID = System.enqueueJob(new APTS_TaxTemplateQueueable(proposalId));
                    }else{
                        APTS_Tax_ProposalTriggerHelper.templatefieldupdate(proposalId);}
                }                
                //navigate to the generate screen
                PageReference generatePage = new PageReference('/apex/Apttus_Proposal__ProposalGenerate?id='+proposalId);
                generatePage.setRedirect(true);
                return generatePage;
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                return null;
            }            
           } else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invalid Proposal'));
            return null;
          }
        }
        if(isTax == true){
            if(isTaxQueue == true){
                jobID = System.enqueueJob(new APTS_TaxTemplateQueueable(proposalId));
            }else{
                APTS_Tax_ProposalTriggerHelper.templatefieldupdate(proposalId);
                PageReference generatePage = new PageReference('/apex/Apttus_Proposal__ProposalGenerate?id='+proposalId);
                generatePage.setRedirect(true);
                return generatePage;  
            }
        }
        return null;
    }
    public PageReference checkstatus(){
        PageReference generatePage;
        AsyncApexJob jobInfo;
        if(Schema.sObjectType.AsyncApexJob.isAccessible()){
         jobInfo = [SELECT Id,Status,NumberOfErrors FROM AsyncApexJob WHERE Id=:jobID];}
        if(jobInfo.Status == 'Completed'){
            generatePage = new PageReference('/apex/Apttus_Proposal__ProposalGenerate?id='+proposalId);
            generatePage.setRedirect(true);
        }
        else{
            generatePage = new PageReference('/apex/APTS_Generate?id='+proposalId);
            generatePage.setRedirect(true);
        }
        return generatePage;
    }
    public PageReference dosubmit(){        
        PageReference pr= new PageReference('/apex/Apttus_Proposal__ProposalGenerate?id='+proposalId);
        pr.setRedirect(true);
        return pr;
    }
}