/*
 * This class provides the Rep with a button on the Proposal so they can include a manual proposal in
 * a Digital offer.  This process will generate an Order Form and create an envelope to send to DocuSign.  
 * The Order Form is generated through the Digital_GenerateDocumentsBatch class and the envelope is created 
 * through a process builder flow which calls the Digital_InvokeDocusignEnvelopeCreation class
 *
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2020-04-27   Brenda Shields          DLT-19727 - Class creation  
 * 2020-05-27   Brenda Shields          DLT-20094 - Un-check unmarked digital if needed.
 * 2020-06-04   Brenda Shields          DLT-20180 - Re-work Opp update so it has time to complete before generating the Order Form - there are processing errors in some orgs
 * 2020-06-24   Brenda Shields          DLT-20224 - Limit Rep to only 3 manual quotes per Opp offer
 * 2020-07-08   Benjamin Her            DLT-20404 - Update display in cxd buttons based on Display_In_CXD_Renewals__c value
 * 2020-08-20   Brenda Shields          DLT-20592 - Display an error if the Order Confirmation Contact is Inactive or has an invalid email address
 *                                                  Updated per PMD Scan 
 * 2020-10-12   Brenda Shields          DLT-20947 - Remove check for 'inactive' setting when validating Contacts 
 * 2020-10-12   Brenda Shields          DLT-20935 - NTO - for newly created Acct/SSD with No L1/L2 fields values and no SAP number - verify and set as needed
 *                                                  We will need to set the BU Level 2 field and the Digital Firm will be calculated
 * 2020-03-12   Benjamin Her            DLT-21252   No digital link is generated when attempting to use rep generated experience. PMD Fix
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 * 2021-04-05	Ameeta A				DLT-21574 - Incorrect Opportunity Staging on Rep Added Offers(Including DLT-21629)
 * ==================================================================================================================================   
 */
 
 /**
    @description Controller for Digital_Display_In_CXD VF Page
  */
public without sharing class Digital_Display_In_CXD_Controller {
    
    //static variable declaration
    private static final string CART_STATUS_FINALIZED = 'Finalized';
    private static final string MANUAL_QUOTE_TYPE = 'Manual';
    private static final string QUOTE_APPROVAL_PRESENTED = 'Presented';
    private static final string ENVELOPE_STATUS_SENT = 'sent';
    
    private Id opportunityId;
    private Id quoteId;
    private string currentUserId;
    private string strCreate;
    private string prevStage;
    private boolean bOppIsDigital;
    private integer intManualCount;
    
    /**
        @description Cart being processed
     */
    public list<Apttus_Config2__ProductConfiguration__c> listConfig = new list<Apttus_Config2__ProductConfiguration__c>();

    /**
        @description Boolean for continuing the process
     */
    public boolean bContinue {get;set;}
    /**
        @description Boolean for if error occurs
     */
    public boolean bError {get;set;}
    /**
        @description Error message
     */
    public string strErrorMessage {get;set;}
    /**
        @description Proposal being processed
     */
    public Apttus_Proposal__Proposal__c quote{get;set;} 
    /**
        @description Controller constructor
     */
    public Digital_Display_In_CXD_Controller() {

        // get parameters
        quoteId = ApexPages.currentPage().getParameters().get('id').escapeHtml4();
        strCreate = ApexPages.currentPage().getParameters().get('create').escapeHtml4();
        
        //get quote related details
        getQuoteDetails();
 
        //initialize all flags
        initializeFlags();
    } 

    //getQuoteDetails() method
    //Gets quote related materials
    private void getQuoteDetails(){

        Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
        quote.id = quoteId;
        
        system.debug(LoggingLevel.INFO, 'DigitalDisplay quote id: ' + quote.id + ' Create value: ' + strCreate);

        // get fields from the Opp, Proposal and cart in order to do the validation for this process
        if(!string.isBlank(quoteId)) { 
            if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible() &&
              Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
                listConfig = [SELECT id, Apttus_Config2__Status__c, Apttus_QPConfig__Proposald__c,
                        Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c,
                        Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c,
                        Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c,
                        Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c,
                        Apttus_QPConfig__Proposald__r.APTS_Signature_Block_Required__c,
                  		Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.Contact_Inactive__c, 
            			Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.IsEmailBounced,                         
                        Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c,
                        Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c,
                        Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.StageName,
                        Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Digital_PreviousStageName__c,
                        Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
                        Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                        Apttus_QPConfig__Proposald__r.Digital_Quote_Failure_Reason__c,
                        Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c,
                        APTS_Proposal_Business_Unit__c, Apttus_QPConfig__Proposald__r.Contract_Type__c,
                        Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                        Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Digital_Firm__c,  Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.BU_Segment_Level_2__c,
                        Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.LCRM_Industry__c
                        FROM Apttus_Config2__ProductConfiguration__c
                        WHERE Apttus_QPConfig__Proposald__c = : quote.id 
                        AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED]; 
            }
            system.debug(LoggingLevel.INFO, '&&&&' + listConfig);  
            if(!listConfig.isEmpty() ) {
                opportunityId = listConfig[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c; 
                bOppIsDigital = listConfig[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c;
            	prevStage = (listConfig[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Failure_Reason__c == 'NA' || String.isBlank(listConfig[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Failure_Reason__c))?listConfig[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.StageName:'';
                
              // check to see how many manual quote are already presented in CXD
                intManualCount = [SELECT count()
                        FROM Apttus_Proposal__Proposal__c 
                         WHERE Apttus_Proposal__Opportunity__c = : opportunityId 
                         AND Digital_Quote_Type__c =: MANUAL_QUOTE_TYPE 
                         AND Display_in_CXD_Renewals__c = TRUE];
                 system.debug(LoggingLevel.INFO, 'Opp Information: ID: ' + opportunityId + ' Opp Is Digital: ' + bOppIsDigital  + 
                  ' Number of Manual Quotes: ' + intManualCount + ' Current User: ' + currentUserId);
              system.debug(LoggingLevel.INFO, 'SSD Digital Firm: ' + listConfig[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Digital_Firm__c);
              system.debug(LoggingLevel.INFO, 'Quote Approval Seg: ' + listConfig[0].Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c);
              } 
            currentUserId = (String)UserInfo.getUserId();
       }
    }//end of getQuoteDetails() method


    //initializeFlags() method
    //Initializes variables
    private void initializeFlags() {
        bContinue = false;
        bError = false;
        strErrorMessage = '';
    } //end of initializeFlags() method
    
    
    /** 
        @description Validate information and generate the Order Form
        @return Page reference to redirect page
     */
    public PageReference createOrderForm() {
        
        //Based on enabled function, "create" parameter will be true or false. If false, function will remove offer.
        system.debug(LoggingLevel.INFO, 'CreateOrderForm: DigitalDisplay quote id: ' + quoteId + ' Create value: ' + strCreate);
        
        // Remove from CXD Renewals - update the quote to remove it from the Digital offer
        if (strCreate == 'false') {
            removeFromDigital();
            Pagereference currentRecUrl = new PageReference('/' + quoteId);
            return currentRecUrl;
        }

        //Check if valid cart is found
        if (listConfig.isEmpty()) {
            strErrorMessage = 'This Proposal does not have a Finalized Cart.  Please finalized the cart on this Proposal before continuing.';
            bError = true;
            system.debug(LoggingLevel.INFO, 'No Finalized Cart Error : ' + bError);
            return Page.Digital_Display_In_CXD_Messages;
        }
        
        // Check if the Order Confirmation Contact is Inactive or has bounced emails
        // DLT-20947 - Remove isactive flag check for Contact - if (listConfig[0].Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.Contact_Inactive__c || 
    if (listConfig[0].Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__r.IsEmailBounced) {
            strErrorMessage = 'This order cannot proceed with the contact you have selected. Please select an Order Confirmation contact with a valid email address.';
            bError = true;
            system.debug(LoggingLevel.INFO, 'Invalid Order Confirmation Contact : ' + bError);
            return Page.Digital_Display_In_CXD_Messages;
        }
                         
        // Update the Opp to Digital if Findlaw - this is needed so Order Form will be created with the signature block
        // Check the Opp flag so the Opp won't get updated multiple times.
        system.debug(LoggingLevel.INFO, 'Digital Opp Check: Is Digital Flag: ' + bOppIsDigital +
                ' Segment: ' + listConfig[0].Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c);
        if (!bOppIsDigital && listConfig[0].Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c == 'FindLaw') {
            bOppIsDigital = true;
            system.debug(LoggingLevel.INFO, 'Update Opp to Digital - ID: ' + opportunityId);
            if (Schema.sObjectType.Opportunity.isUpdateable()) {
                Opportunity oOpp = new Opportunity();
                oOpp.id = opportunityId;
                oOpp.isDigitalSpearHead__c = true;
                oOpp.Unmarked_Digital_Channel__c = false;
                try {
                    update oOpp;
                    strErrorMessage = 'This Opportunity is not marked as Digital.  Please wait while we update your Opportunity.  Once you are returned to the Proposal, press the "Display in CXD Renewals" button again to continue.';
                    bError = true;
                    return Page.Digital_Display_In_CXD_Messages;
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                }
            }        
        }
        
        //Calls CXD's generate document job, if quote is valid.
        return createOrderFormHelper();
    }


    //createOrderFormHelper() method
    //Checks for quote validation messages then call CXD generate document job and continues CXD manual quote process
    private PageReference createOrderFormHelper(){

        //Check if any validation messages are found on the proposal
        string strVMessage = listConfig[0].Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c;
        if (strVMessage != null && strVMessage != 'Won reason code is required prior to sending quote for eSignature or Submitting the order.<br>') {
            strErrorMessage = 'Please clear all Validation Messages before continuing.';
            bError = true;
            system.debug(LoggingLevel.INFO, 'The Validation Errors : ' + listConfig[0].Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c);
            return Page.Digital_Display_In_CXD_Messages;
        }
               
        //Check if opportunity renewal date is in the past
        if (listConfig[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c < System.today()) {
            strErrorMessage = 'The Renewal Date on this Opportunity has expired.  Please update the Renewal Date on this Opportunity before continuing.';
            bError = true;
            system.debug(LoggingLevel.INFO, 'Renewal Date is in the past : ' + bError);
            return Page.Digital_Display_In_CXD_Messages;
        } 
        
        // A maximum of 3 manual quotes are allowed to be displayed in a Digital Opp offer
        if (intManualCount >= 3) {
            strErrorMessage = 'Up to 3 manual Proposals are allowed to be displayed in a CXD Renewal offer.  Please remove an existing manual Proposal from CXD before continuing.';
            bError = true;
            system.debug(LoggingLevel.INFO, 'Maximum of Manual quote reached for this offer : ' + bError);
            return Page.Digital_Display_In_CXD_Messages;
        }
   
        // check to see if the Rep is ready to continue the process
        if (!bContinue) {
            bContinue = true;
            system.debug(LoggingLevel.INFO, 'Continue : ' + bContinue);
            return Page.Digital_Display_In_CXD_Messages;
        }
       
       // continue with order form creation
       continueOrderFormCreation(); 
      
        // return to the quote
        Pagereference currentRecUrl = new PageReference('/' + quoteId);
        return currentRecUrl;
        
    }//end of createOrderFormHelper() method
    
    /** 
        @description Calls method to create the order form
        @return Page reference to redirect page
     */
    public PageReference continueProcess() {
        return createOrderForm();
    }
    
    /** 
        @description Creates the order form, update quote and SSD
     */
    public void continueOrderFormCreation() {
             // After validation again, continue with processing 
        system.debug(LoggingLevel.INFO, 'CreateOrderForm - Continue: DigitalDisplay quote id: ' + quoteId + ' Create value: ' + strCreate);
                                
        if (!Test.isRunningTest()){
            Digital_GenerateDocumentsBatch.generateOrderForm(listConfig); 
        }
       
        // update the quote.  Set the Display in Renewals field to trigger the Envelope Creation
        updateQuote(quoteId);
        
        // update the SSD account if the Digital Firm is not set
        if (listconfig[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Digital_Firm__c == 'None' || 
            listconfig[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Digital_Firm__c == '' ||
            listconfig[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Digital_Firm__c == null) {
            updateSSDAccount();
        }
    }

    /** 
        @description Update the quote
        @param quoteId Id of the quote to be updated
     */
    // Update the quote to set the flag to trigger the envelope creation
    public void updateQuote(Id quoteId) {
      
      // update the quote.  Set the Display in Renewals field to trigger the Envelope Creation
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
            system.debug(LoggingLevel.INFO, 'Update quote id: ' + quoteId);
            Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
            quote.id = quoteId;
            quote.Display_in_CXD_Renewals__c = true;
            // this field is needed to create the envelope
            quote.Latam_APTS_Reason__c ='Digital';
            //This field hold the stage name on click of Display in CXD button.
            quote.Digital_Quote_Failure_Reason__c = prevStage;
            try {
                update quote;
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            }
        }
    }
    
    /**
        @description Method to update the SSD
     */
    public void updateSSDAccount() {

        if (Schema.sObjectType.Source_System_Detail__c.isUpdateable()) {
            system.debug(LoggingLevel.INFO, 'Update SSD id: ' + quoteId);
            Source_System_Detail__c oSSD = new Source_System_Detail__c();
            oSSD.id = listconfig[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c;
            
            // update the SSD to set the Business Segment L2 field.  This is needed to set the Digital FIrm.
            updateSSDBUSegment(oSSD);
         
            try {
                update oSSD;
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            }
        } 
    }
    
    //Updates the BU_Segment_Level_2__c to ensure Digital Firm gets set.
    private void updateSSDBUSegment(Source_System_Detail__c oSSD){

        string strApprovalSeg;
        string strIndustryCode;
        system.debug(LoggingLevel.INFO, 'in Update SSD Digital Firm: ' + listConfig[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Digital_Firm__c);
        system.debug(LoggingLevel.INFO, 'in Update Quote Approval Seg: ' + listConfig[0].Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c);
        if (listconfig[0].Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c == 'FindLaw') {
        	strApprovalSeg = listconfig[0].Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c;
        } else {
        	strApprovalSeg = listconfig[0].Apttus_QPConfig__Proposald__r.APTS_Approval_Segment__c;
        }
        strIndustryCode = listconfig[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.LCRM_Industry__c;
        
        // check on the Approval Segment to set the correct BU Segment 2 value
        if (strApprovalSeg.contains('Corporate') ) {
            oSSD.BU_Segment_Level_2__c = 'Corp Counsel';
            
        } else if (strApprovalSeg.contains('Government') ) {
            oSSD.BU_Segment_Level_2__c = 'State Government';
            
        } else if ((strApprovalSeg == 'Small Law') || 
            (strApprovalSeg == 'FindLaw' && !strIndustryCode.containsIgnoreCase('MEDIUM'))) { 
            // for FindLaw the BU Segment could be Small Law or Medium Law, use Industry code to figure out which one to use
            oSSD.BU_Segment_Level_2__c = 'Small Law';
        } else if ((strApprovalSeg == 'Medium Law') || 
            (strApprovalSeg == 'FindLaw' && strIndustryCode.containsIgnoreCase('MEDIUM'))) {
            oSSD.BU_Segment_Level_2__c = 'Medium Law';
        } else {
            // default to Small Law
            oSSD.BU_Segment_Level_2__c = 'Small Law';
        } 
    }
    
    /**
        @description Sets back the quote fields so the Rep can make changes and regenerate the Order form
        @return Page reference to redirect page
     */
    public PageReference removeFromDigital() {
        
        if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
            // Udpate the Proposal to remove it from the offer so the Rep can work on it again
            system.debug(LoggingLevel.INFO, 'Remove from Digital - Update quote id: ' + quoteId);
            Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
            quote.id = quoteId;
            quote.Display_in_CXD_Renewals__c = false;
            quote.Apttus_Proposal__Approval_Stage__c = 'Draft';
            quote.DocuSign_Envelope_ID__c = null;
            quote.Digital_Envelope_Created__c = false;
            quote.APTS_Signature_Block_Required__c = false;
            // this field is not needed to create the order but is to create the envelope, so make sure it's set
            quote.Latam_APTS_Reason__c ='Digital';
            try {
                update quote;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            }
        }
        
        // Void all apprporiate DocuSign Envelopes
        system.debug(LoggingLevel.INFO, 'Envelope - Check for Envelopes to update for quote id: ' + quoteId);    
        list<Apttus_DocuApi__DocuSignEnvelope__c> envList = new list<Apttus_DocuApi__DocuSignEnvelope__c>();
        
        if (Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isAccessible() &&
          Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isUpdateable()) {
          // select envelopes to void
            envList = [select id, APTTUS_DOCUAPI__STATUS__C 
                  from Apttus_DocuApi__DocuSignEnvelope__c 
                        where APTTUS_DOCUAPI__STATUS__C =: ENVELOPE_STATUS_SENT 
                        AND Apttus_QPDSign__QuoteProposal__c =: quoteId];

            if (envList.size() > 0 && envList != Null) {
              for (Apttus_DocuApi__DocuSignEnvelope__c envUpdate : envList) {
                  // update status to voided
                  envUpdate.APTTUS_DOCUAPI__STATUS__C = 'voided'; 
              }
                try { 
          update envList;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            }
            }
        }  // end select/update envelopes
        system.debug(LoggingLevel.INFO, 'Envelopes Updated : ' + envList);  
        
        Pagereference currentRecUrl = new PageReference('/' + quoteId);
        return currentRecUrl;
    }
    
    /**
        @description Return url for quote
        @return Page reference to redirect page
     */  
    public PageReference returnToQuote() {
        Pagereference currentRecUrl = new PageReference('/' + quoteId);
        return currentRecUrl;       
    }    
}