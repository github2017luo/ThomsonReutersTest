/*
* CHANGE HISTORY
* ==================================================================================================================================
* Date         Name                    Description
* 2018-02-06   Bharat Bhushan          DLT- 7191 - Authorized User will be able to Expire Proposal in bulk from the Opportunity List view. 
*                                      Also when expiring proposals - include setting the status to voided in ALL DocuSign Envelope records realted to the opp/Proposal  
* 2018-05-08   Poonam Garg             DL- 9189  Update IsDigitalChannel to TRUE and UNMARKED DIGITAL CHANNEL     TO TRUE.
* 2018-06-12   Poonam Garg             DL -10228 Completed Code Optimization(Added with Sharing to class, Changes Public variable 
*                                      to Private, removed hard coding, Checked size of collection before DML,SOQL, 
*                                      Removed Extra line and removed commented code, Added IsAccessible and IsUpdateable conditions , Added Modular Approach)
* 2018-06-26   Brenda Shields          DLT-10738 - Exclude manual quotes when expiring proposals
* 2018-08-20   Brenda Shields          DLT-11736 - updates for various code scan issues
==================================================================================================================================   
*/
public with sharing class Digital_BulkExpireAllProposalsController {    
    //Instantiate a StandardSetController
    public ApexPages.StandardSetController setCon;    
    //string CurrentUserName;
    String strCurrentUserId;
    List<Opportunity> selectedOptys = new List<Opportunity>();
    list<Apttus_Proposal__Proposal__c> listQuotes = new list<Apttus_Proposal__Proposal__c>();    
    //Maps
    Map<Id,Opportunity> optyMap = new Map<Id,Opportunity>();    
    Set<Id> setQuoteIds = new Set<Id>();
    public Boolean isNotAuthorizedFlag {get;set;}
    public Boolean isNull {get;set;}
    public Boolean isReturn {get;set;}
    public Boolean isContinue {get;set;}
    // private List<Opportunity> OppsList {get; set;}
    public boolean isNonDigital{get;set;}
    public Opportunity opp{get;set;}
    
    public Digital_BulkExpireAllProposalsController(ApexPages.StandardSetController controller) {
    	// get selected opportunities and select additional information
    	setCon = controller;
        getOpty();
        // prepare opportunities by selecting associated proposals and opportunity details
        if (optyMap.size() > 0) {
         	prepareOpportunities();
        }               

        // set default values
        strCurrentUserId = (String)UserInfo.getUserId();
        isNonDigital = false;
        isReturn = false;
        isNotAuthorizedFlag = false;
        isContinue = false;
        isNull = false;
    }
    
    //Getters and Setters    
    public integer getMySelectedSize()
    {
        return setCon.getSelected().size();
    }

    // Assigning selected opportunity id into map.
    public void getOpty()
    {        
        selectedOptys.clear();
        selectedOptys = setCon.getSelected();
        for(Opportunity opp:selectedOptys)
        {
            optyMap.put(opp.id, opp);
        }        
    }
    
    // Prepare Opporutnities and Proposals for validate and processing
    private void prepareOpportunities() {
    	//check field accessibility on Opportunity, User and Apttus_Proposal__Proposal__c objects
        if(Schema.sObjectType.Opportunity.fields.OwnerId.isAccessible() && 
        	Schema.sObjectType.User.fields.Name.isAccessible() &&
            Schema.sObjectType.Apttus_Proposal__Proposal__c.fields.Apttus_Proposal__Approval_Stage__c.isAccessible() &&
            Schema.sObjectType.Apttus_Proposal__Proposal__c.fields.is_Digital_Channel__c.isAccessible() &&
            Schema.sObjectType.Apttus_Proposal__Proposal__c.fields.Digital_Quote_Type__c.isAccessible() &&
            Schema.sObjectType.Apttus_Proposal__Proposal__c.fields.id.isAccessible()) {
            	listQuotes = [SELECT Id, Apttus_Proposal__Opportunity__r.OwnerId, Apttus_Proposal__Opportunity__r.Owner.Name, 
                           Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c 
                           where Apttus_Proposal__Opportunity__c IN: optyMap.KeySet() AND is_Digital_Channel__c = TRUE AND 
                           Apttus_Proposal__Approval_Stage__c != 'Expired' AND Apttus_Proposal__Approval_Stage__c != 'Accepted' AND 
                           Apttus_Proposal__Approval_Stage__c != 'Denied' AND Digital_Quote_Type__c != 'Manual']; 
        }   
        System.debug(listQuotes );    
        // Check access on Opportunity Objects
        if(Schema.sObjectType.Opportunity.fields.name.isAccessible() && 
            Schema.sObjectType.Opportunity.fields.isDigitalSpearHead__c.isAccessible() &&
            Schema.sObjectType.Opportunity.fields.OwnerId.isAccessible() &&
            Schema.sObjectType.Opportunity.fields.id.isAccessible()) {
                selectedOptys = [Select id, name, isDigitalSpearHead__c, OwnerId, Pricebook2id from Opportunity where id IN: optyMap.KeySet()];
         } 
    }    

    // Creating logic to Expire all related proposals for selected Opportunities.
    public PageReference bulkExpireProposals() {
        Set<String> usrIds = new Set<String>();        
        List<String> lstUsr = new List<String>(Label.AuthorizedusrLst.split(','));
        usrIds.addAll(lstUsr);
        //Let user know if he is not authorized to Expire Proposals
        if (!usrIds.isEmpty() && !usrIds.contains(strCurrentUserId)) {
            isNotAuthorizedFlag = true;
            isReturn = true;
            return Page.DigitalBulkExpireAllProposals_Message;
        }
        
        // At least one Opportunity needs to be selected to proceed further
        if (selectedOptys == null || selectedOptys.isEmpty()) {
            isNull = true;
            isReturn = true;
            system.debug('Select at least one opportunity : ' + isNull);
            return Page.DigitalBulkExpireAllProposals_Message;
        }

        // Only Digital Quote/Proposals can be expired and we know we have some in the list
       	for (Opportunity so : selectedOptys) {
       		// A non digital qutoes was selected
           	if (isNonDigital == so.isDigitalSpearHead__c) {
               	isNonDigital = true;
               	isReturn = true;
               	return Page.DigitalBulkExpireAllProposals_Message;
           	}
        }
                
        // Check to see if they really want to expire selected Proposals
        if (!isContinue) {
            isContinue = true;
            system.debug('Continue : ' + isContinue);
            return Page.DigitalBulkExpireAllProposals_Message;
        }
        
        // Update Proposal Stage to Expired and Opportunity unmarked to true
        // Update Docusign Envelope status to VOID
        try {
        	if (listQuotes != null && listQuotes.size() > 0) {
            	updateOpportunities(listQuotes);
        	}
        	if (optyMap.size() > 0) {
            	updateDocusignEnvelopesVoid();
        	}
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
        
        // return
        PageReference listPage = new PageReference('/006?fcf');
        listPage.setredirect(true);
        return listPage;
    }
    
    private void updateOpportunities(List<Apttus_Proposal__Proposal__c> listQuotes) {
        List<Opportunity> updateOpp = new List<Opportunity>();
        // loop through all quotes
        for (Opportunity opps : selectedOptys) {               
            // update all Quotes
            for (Apttus_Proposal__Proposal__c oQuote : listQuotes) {
                if (oQuote.Apttus_Proposal__Opportunity__c == opps.id) {
                 	oQuote.Apttus_Proposal__Approval_Stage__c = 'Expired';
                  	// add to quote list to expire envelopes
               		setQuoteIds.add(oQuote.Id);
                }                    
            }
            //DLT 9189: Update Unmarked_Digital_Channel__c true and isDigitalSpearHead__c=false.
            opps.Unmarked_Digital_Channel__c = true;
            opps.isDigitalSpearHead__c = false;
            updateOpp.add(opps);
        }
        // Update all Quote to Expired
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
            update listQuotes; 
        }
        // Update all Opportunities to Unmarked
        if (updateOpp != null && updateOpp.size() > 0 && Schema.sObjectType.Opportunity.isUpdateable()) {
            Database.SaveResult[] srList = Database.update(updateOpp, true);        
        }
    }
    
    private void updateDocusignEnvelopesVoid() {
        // Void all apprporiate DocuSign Envelopes
        if (Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.fields.id.isAccessible() &&
            Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.fields.APTTUS_DOCUAPI__STATUS__C.isAccessible() &&
            Schema.sObjectType.Opportunity.fields.id.isAccessible()) {
            list<Apttus_DocuApi__DocuSignEnvelope__c> envList = [select id, APTTUS_DOCUAPI__STATUS__C from Apttus_DocuApi__DocuSignEnvelope__c 
                                                             where APTTUS_DOCUAPI__STATUS__C = 'sent' 
                                                             AND Apttus_QPDSign__QuoteProposal__c IN: setQuoteIds];
          	if (envList != Null && envList.size() > 0) {
               	for (Apttus_DocuApi__DocuSignEnvelope__c oEnvUpdate : envList) {
               		// update status to voided
                  	oEnvUpdate.APTTUS_DOCUAPI__STATUS__C = 'voided';                
                   	system.debug('Envelope - moving status to voided for id: ' + oEnvUpdate.Id);    
               	}
           	}
           	// Update Envelope records to voided
           	if (envList != null && !envList.isEmpty() && Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isUpdateable()) {
                Database.SaveResult[] srList = Database.update(envList, true);
           	}
        }
    }   
    
    public PageReference continueExpire() {
        return bulkExpireProposals();
    }
    
    public PageReference returnToOpp() {
        PageReference listPage= new PageReference('/006?fcf');
        listPage.setredirect(true);
        return listPage;     
    }    
}