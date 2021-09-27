/**
 * This class is invoked from Process builder and is used to generate a PDF attachment for the proposal being processed
 * it will included information from the proposal and the proposal line items
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-10-25   Brenda Shields          Created for CX Digital DLT-4381  
 * 2018-03-22   Brenda Shields          Updating to create email to send to the customer
 * 2018-04-12   Poonam garg             DL -5186 Sending Digital Agreement Email 
                                        To Order Confirmation Contact
 * 2018-06-06   Poonam Garg             DLT-9756 Replace Account Object with Source System Detail Object.          
 * 2018-06-14   Poonam Garg             DLT 9756 Implemented modular approach by creating separate methods,Addedd Access 
                                        check to the object, Removed Blank Lines.
 * 2018-07-15    Raviteja Murukutla     DLT-10473 Added New Sales functionality to send email to customer                                       
 * 2018-07-18    Poonam Garg            DLT-11134 Modified the code to implement functionality for Bulk Records.  
 * 2019-01-08    Benjamin Her           DLT-14348 Code Scan Fixes
 * 2019-04-25    Samreen Ali            DLT-15926 FindLaw Order Confirmation Email  
 * 2019-04-09    Rahul Natarajan        DLT-19740 [ALL] Send Order confirmation email to Opportunity Owner instead of renew@tr.com 
 * 2019-05-27    Rahul Natarajan        DLT-20124 [ALL] Send Order confirmation email to Opportunity Owner instead of renew@tr.com 
 * 2020-08-06    Brenda Shields         DLT-20475 Check for inactive/email bounced contacts and provide alternate email
 *                                      Several updated do fix PMD Scan Errors
 * 2020-09-16    Brenda Shields         DLT-20772 - removal text - Contact inactive email notification
 * 2020-10-01    Brenda Shields         DLT-20850 - Update PDF to include logo and formatting - created vf page instead of inline html
 * 2020-10-12    Brenda Shields         DLT-20948 - Remove check for 'inactive' setting when validating Contacts 
 * 2021-02-22	 Ameeta Antonio			DLT-21397 - Added Amended status for confirmation emails from amended orders
 * 2021-03-04    Brenda Shields         DLT-17212 - [ALL] Update class to create document as a file and not an attachment
 * 2021-04-01    Brenda Shields         DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 * 2021-05-01    Kavya S                DLT-21652 - Update for DocuSign - Initial Changes
 * 2021-05-12    Brenda Shields         DLT-21777 - Update for DocuSign changes - Update Proposal and Envelope and create Signed Order Form
 * 2021-07-13    Brenda Shields         DLT-22040 - (DLT-21846 was Development jira) - [SFDC][INC4022734][Monitoring][NSE] - Backend systems to exclude synthetic test NSE order for order processing
 * =============================================================================
 */
/** 
 * @description : Class to process post acceptance functions
 */
public with sharing class Digital_PostAcceptAttachment {
    //Initialize public variables   
    public static final String FORM_HTML_START = '<HTML><BODY>';
    public static final String FORM_HTML_END = '</table></BODY></HTML>';
    public static final String TEMPLATENAME = 'Digital_Agreement'; //  DL -5186 Name Of Template
    public static final String TEMPLATENAMENSEFL = 'New_Customer_Order_Confirmation_VF_FL';
    public static final String TEMPLATENAMENSENOTFL = 'New_Customer_Order_Confirmation_VF';
    public static final String ORGWIDEADDRESS = 'Thomson Reuters Renewal Notifications';
    public static final String ORGWIDEADDRESSNSE = Label.Ecom_Lead_OWD_Email;
    public static final String HEADER = '' + FORM_HTML_START + '<p style="font-size:27px"<b>Thomson Reuters</b></p>';
    public static final Set < String > STATUSCAN = new Set < String > {
        //'Amended',
        'Cancelled'
    };

    public static map < String, String > propAttachmentBody = new map < String, String > ();
    // information for emails for Renewals and New Sales
    public static OrgWideEmailAddress owaRenewals = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName =: ORGWIDEADDRESS];
    public static string templateIdRenewals = [SELECT Id FROM EmailTemplate where DeveloperName =: TEMPLATENAME and isActive = true].id;
    public static list < Messaging.SingleEmailMessage > lstAllEmailMessages = new list < Messaging.SingleEmailMessage > ();
    public static OrgWideEmailAddress owaRenewalsNSE = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName =: ORGWIDEADDRESSNSE];
    public static string templateIdNSEFL = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: TEMPLATENAMENSEFL and isActive = true].id;
    public static string templateIdNSENotFL = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: TEMPLATENAMENSENOTFL and isActive = true].id;
    public static list<ContentVersion> lstContVer = new list<ContentVersion>();  
	private static list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
    // added for DocuSign changes
    private static list<Apttus_Proposal__Proposal__c> listProposalsToAccepted = new list<Apttus_Proposal__Proposal__c>();
    private static list<Apttus_DocuApi__DocuSignEnvelope__c > listofEnvelopes = new list<Apttus_DocuApi__DocuSignEnvelope__c > ();
    private static set<string> setQuoteIDs = new set<string>();
    private static map<id, string> mapQuoteNames = new map<id, string>();
    
    /** 
     * @description : main method to process post acceptance functions
     * @param quoteIds : list of quote ids that need to be processed
     */
    @InvocableMethod
    public static void postAttachment(list<Id> quoteIds) {
        String encodedContentsString = '';
        String encodedContentsStringFinal = '';
        Id curProposalId = null;
        
        for (Apttus_Proposal__Proposal_Line_Item__c proposalLineItem: [Select Apttus_Proposal__Proposal__c,
                Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.Apttus_Proposal__Proposal_Name__c,
                Apttus_Proposal__Proposal__r.Digitally_Signed_Date__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact_Name__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact_Email__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__r.Contact_Inactive__c,
                Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__r.IsEmailBounced,
                Apttus_Proposal__Proposal__r.Owner.Email, Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.name,
                Apttus_Proposal__Proposal__r.APTS_Sold_To_SAP_Account_Number__c, Apttus_Proposal__Product__r.name,
                Apttus_Proposal__Proposal__r.APTS_Incremental__c, Apttus_Proposal__Proposal__r.APTS_Renewal__c,
                Apttus_QPConfig__LineStatus__c, APTS_Contract_Term__c, Apttus_Proposal__Product__r.Subscription_Number__c,
                Apttus_Proposal__Proposal__r.Is_Digital_New_Sales__c,
                Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Owner.Email,
                Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c,
                Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c               
                from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c in: quoteIds
                and Apttus_QPConfig__LineStatus__c not in: STATUSCAN
                order by Apttus_Proposal__Proposal__c
            ]) {

            // Check if Proposal Line Item belongs to same proposal - if so add the next product information data to current attachment body
            if (curProposalId == proposalLineItem.Apttus_Proposal__Proposal__c) {
                encodedContentsStringFinal = encodedContentsStringFinal + createAttachmentBody2(proposalLineItem.Apttus_Proposal__Product__r.name);
            } else {
                // Will execute for first proposal Line Item 
                // Create New Attachment Body 
                if (String.isEmpty(encodedContentsStringFinal)) {
                    curProposalId = proposalLineItem.Apttus_Proposal__Proposal__c;
                    // update the quote to Accepted, if needed
        			moveProposalToAccepted(proposalLineItem);
                    // build email for this proposal
                    buildEmailList(proposalLineItem);
                    encodedContentsString = createAttachmentBody1(proposalLineItem);
                    encodedContentsStringFinal = HEADER + encodedContentsString + createAttachmentBody2(proposalLineItem.Apttus_Proposal__Product__r.name);
                } else {
                    // Will Execute if the next Proposal record comes in Loop. Then Previous Data will added to map and new attachment Body will be created. 
                    encodedContentsStringFinal = encodedContentsStringFinal + FORM_HTML_END;
                    propAttachmentBody.put(curProposalId, encodedContentsStringFinal);
                    encodedContentsString = createAttachmentBody1(proposalLineItem);
                    encodedContentsStringFinal = HEADER + encodedContentsString + createAttachmentBody2(proposalLineItem.Apttus_Proposal__Product__r.name);
                    curProposalId = proposalLineItem.Apttus_Proposal__Proposal__c;
                    // update the quote to Accepted, if needed
        			moveProposalToAccepted(proposalLineItem);                    
                    // build email for this proposal
                    buildEmailList(proposalLineItem);
                }
            }
        } // end of for loop
        
        // finish building the last attachment  
        if (curProposalId != null && !String.isBlank(encodedContentsStringFinal)) {
            encodedContentsStringFinal = encodedContentsStringFinal + FORM_HTML_END;
            propAttachmentBody.put(curProposalId, encodedContentsStringFinal);
        }

		// Create file attachments and send out emails
		finishProcessing(propAttachmentBody);
        
    }
  
  
    // finishProcessing method will create all files and sends the OCC emails
    private static void finishProcessing(map<String,String> propAttachmentBody) {
    	// DLT-17212 - [ALL] Update class to create PDF document as a file and not an attachment
        //Create and Insert Attachments for the corresponding Quotes/Proposal    
        //createAttachments(propAttachmentBody);
        
        if (!Schema.sObjectType.ContentVersion.isCreateable()) {
        	throw new DCCustomException(UserInfo.getName() + ' does not have access to create Content');
        } 
        //if there is work to do, build files to be attached the corresponding Quotes/Proposal     
        if (!propAttachmentBody.isEmpty()) {
        	// DLT-21652 update the quote to Accepted, if needed
        	updateProposals();
        	// create copy of signed order form
        	createSignedOrderForm();
            // create attachments of type File (content)
            createFileToAttachment(propAttachmentBody);
			// insert all files to create attachment
           	insertFilesToAttachment(lstContVer);
        }
        
        // Send Emails to the Order Confirmation Contact attached to the Quote
        sendEmailToContact();
        // insert exceptions if any
        insertExceptionLogs(exList);
    }  
    
    
    // This method builds the ContentVersion records to be attached to Quote Object
    private static void createFileToAttachment(map<String,String> propAttachmentBody) {
        for(String propid : propAttachmentBody.keyset()) {
            system.debug(logginglevel.INFO, '&&&&&& Prop Body: ' + propAttachmentBody.get(propid));
            // Get VF Page contents to create PDF, so the attachment will be formatted and include the TR logo
            blob bPage;
            if (!Test.isRunningTest()) {
                PageReference pageReference2 = new PageReference('/apex/Digital_PostAttachmentPDF?Id=' + propid);
                bPage = new PageReference(pageReference2.getUrl()).getContent();
            } else {
                bPage = blob.valueof('Test PDF Contents');
            }
            
            // build a Content Version record for each attachment/file
            ContentVersion contVer = new ContentVersion();
            contVer.ContentLocation = 'S';
            contVer.VersionData = bPage; 
            contVer.Title = String.valueOf('Digital Signature Detail.pdf');
            contVer.Legacy_ParentId__c = propid; // use this field to tie the content version to the proposal
            contVer.PathOnClient = String.valueOf('Digital Signature Detail.pdf');
            lstContVer.add(contVer);  
        }       
    }


    // This method creates ContentVersion/ContentDocument records.  
    // ContentDocumentLink records also need to be created to link the file to the quote
    @TestVisible private static void insertFilesToAttachment(list<contentVersion> listContent) {
        set<string> setContVerIds = new set<string>();
        Database.SaveResult[] lsr;

        system.debug(logginglevel.INFO, 'PostAcceptAttachment - insert Content Version records: ' + listContent);
        
        if (!Schema.sObjectType.ContentVersion.isCreateable() || !Schema.sObjectType.ContentDocumentLink.isCreateable()) {
            throw new DCCustomException(UserInfo.getName() + ' does not have access to create: Content objects');
        }
        // Insert version records - this will automatically create a content documents record which we need to add 
        // to the content document link records we are creating                      
        //insert lstContVer;
        lsr =  Database.insert(lstContVer, false);
        if (lsr != null && lsr.size() > 0) {
            for (Integer i = 0; i < lsr.size(); i++) {
                if (lsr.get(i).isSuccess()) {
                	setContVerIds.add(lsr.get(i).getId());
                }
        	} // end for loop        
		} // end if
		
		// insert the content document link records
		insertContDocLink(setContVerIds);
    }
    

	// insert the Content Document Link Records
	private static void insertContDocLink(set<string> setContVerIds) {
		list<ContentDocumentLink> lstContLink = new list<ContentDocumentLink>();
		        
		// Reselect version records to get the new Document ids which were automatically created
        for (ContentVersion oContVer : [SELECT Id, ContentDocumentId, Legacy_ParentId__c  
            							FROM ContentVersion 
            							WHERE id IN : setContVerIds 				
            							AND Title = 'Digital Signature Detail.pdf']) {
            // create linking Content Document record 
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = oContVer.ContentDocumentId;
            cdl.LinkedEntityId = oContVer.Legacy_ParentId__c; //APTS_Custom_Quote_Proposal__c;
            system.debug(logginglevel.INFO, 'Document Quote ID : ' + cdl.LinkedEntityId);
            cdl.ShareType = 'V';
            lstContLink.add(cdl);
        }
        // insert content link records
        insert lstContLink;
		
	}
	
	
    // Send Email to the Order Confirmation Contact attached to the Quote
    private static void sendEmailToContact(){
        Messaging.SendEmailResult[] resultMail;
        if (lstAllEmailMessages != null && lstAllEmailMessages.size() > 0) {
            resultMail = Messaging.sendEmail(lstAllEmailMessages);
        }
    }
    

    // Create the email to be sent to the customer  
    private static void buildEmailList(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem) {
        if (proposalLineItem.Apttus_Proposal__Proposal__r.Is_Digital_New_Sales__c) {
            // create New Sales email
            createNSEEmail(proposalLineItem);
        } else {
            // create digital Renewals email 
            createRenewalEmail(proposalLineItem);
        }
    }


    // This method calculates Monthly amount
    private static Decimal calculateMonthlyAmt(Apttus_Proposal__Proposal_Line_Item__c proposal) {
        decimal decMonthlyAmt = 0;
        if (proposal.Apttus_Proposal__Proposal__r.APTS_Incremental__c != 0) {
            decMonthlyAmt = proposal.Apttus_Proposal__Proposal__r.APTS_Incremental__c / 12;
        } else if (proposal.Apttus_Proposal__Proposal__r.APTS_Renewal__c != 0) {
            decMonthlyAmt = proposal.Apttus_Proposal__Proposal__r.APTS_Renewal__c / 12;
        } else {
            decMonthlyAmt = 0;
        }
        return decMonthlyAmt;
    }


    // OBSOLETE - This method creates attachment file to be attached to Quote Object.
/*    
    private static void createAttachments(map < String, String > propAttachmentBody) {
        list < Attachment > lstAttach = new list < Attachment > ();
        for (String propid: propAttachmentBody.keyset()) {

            // Get VF Page contents to create PDF 
            blob bPage;
            if (!Test.isRunningTest()) {
                PageReference pageReference2 = new PageReference('/apex/Digital_PostAttachmentPDF?Id=' + propid);
                bPage = new PageReference(pageReference2.getUrl()).getContent();
            } else {
                bPage = blob.valueof('Test PDF Contents');
            }
            Attachment record = new Attachment();
            record.ParentId = propid;
            record.Body = bPage; //combinedDataAsBlob;
            record.Name = String.valueOf('Digital Signature Detail.pdf');
            lstAttach.add(record);
        }

        // If the rights are correct and there are attathments to create, insert attachments 
        if (!Schema.sObjectType.Attachment.isCreateable()) {
            throw new DCCustomException(UserInfo.getName() + ' does not have access to: Attachment');
        }
        if (!lstAttach.isEmpty()) {
            insert lstAttach;
        }
    }
*/


	// DLT-21652 - update proposals and envelopes
	private static void moveProposalToAccepted(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem) {
		// only update the Proposal if it's not already Accepted
		if (proposalLineItem.Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c != 'Accepted') {
			Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
			oProposal.id = proposalLineItem.Apttus_Proposal__Proposal__c;
			oProposal.Apttus_Proposal__Approval_Stage__c = 'Accepted';
			// added flag update so order would get created
			oProposal.DocusignOrderAssetFlag__c = true;
			// DLT-21846 for NSE, if this is our test account, set flags so we don't create the order 
			if (proposalLineItem.Apttus_Proposal__Proposal__r.Is_Digital_New_Sales__c == true &&
				proposalLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.name.containsIgnoreCase('Irrthum test')) {
				system.debug(logginglevel.INFO, 'NSE Payment Test Quote: ' + proposalLineItem.Apttus_Proposal__Proposal__c + ', ' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.name);
				oProposal.APTS_Is_Order_Created__c = true;
				oProposal.DocusignOrderAssetFlag__c = false;
			}
			listProposalsToAccepted.add(oProposal);
			system.debug(logginglevel.INFO, 'Proposals added to Accepted list: ' + proposalLineItem.Apttus_Proposal__Proposal__c);
		}
		// build set/map to select envelopes and create signed document
		setQuoteIds.add(proposalLineItem.Apttus_Proposal__Proposal__c);
		mapQuoteNames.put(proposalLineItem.Apttus_Proposal__Proposal__c, proposalLineItem.Apttus_Proposal__Proposal__r.Name);
	}
	
	
	private static void updateProposals() {
		
	    if (!Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) {
            throw new DCCustomException(UserInfo.getName() + ' does not have access to update this Proposal');
        }  
        system.debug(logginglevel.INFO, 'Proposals to Accept: ' + listProposalsToAccepted);      
        // update the Quotes/Proposal     
        if (!listProposalsToAccepted.isEmpty()) {
         	update listProposalsToAccepted;
        }
        
        // Select and update envelopes to completed
        if (!Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isUpdateable() ||
        	!Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isAccessible()) {
            throw new DCCustomException(UserInfo.getName() + ' does not have access to read or update this Envelope');
        }  
        list<Apttus_DocuApi__DocuSignEnvelope__c> envList = new list<Apttus_DocuApi__DocuSignEnvelope__c>();
        system.debug(logginglevel.INFO, 'Select Envelopes - quotes : ' + setQuoteIds);
        
	    // select envelopes to complete
	    envList = [select id, APTTUS_DOCUAPI__STATUS__C 
	               from Apttus_DocuApi__DocuSignEnvelope__c 
	               where APTTUS_DOCUAPI__STATUS__C = 'sent' 
	               AND Apttus_QPDSign__QuoteProposal__c in : setQuoteIDs];
	
	    if (envList.size() > 0 && envList != Null) {
	      	for (Apttus_DocuApi__DocuSignEnvelope__c envUpdate : envList) {
	          	// update status to completed
	           	envUpdate.APTTUS_DOCUAPI__STATUS__C = 'completed'; 
	           	system.debug(logginglevel.INFO, 'Envelope : ' +envUpdate.id);
	       	}
		  	// update the envelopes
		   	update envList;
	    }
    }  
     
    
    // create a copy of the order form so it will be marked as signed
    private static void createSignedOrderForm() {
    	// select existing order form documents - get the latest form is there are many
    	list<ContentVersion> listContVer = new list<ContentVersion>();
    	list<ContentVersion> listNewContVer = new list<ContentVersion>();
        list<id> lstContLinkIds = new list<id>();
        map<Id, Id> mapContProp = new map<Id, Id>();

        if (Schema.sObjectType.ContentDocumentLink.isAccessible()) {
            list<ContentDocumentLink> contLink = [SELECT ContentDocumentId, LinkedEntityId 
            			FROM ContentDocumentLink WHERE LinkedEntityId IN: setQuoteIDs];
            if (!ContLink.isEmpty()) {
                for (ContentDocumentLink cd: contLink) {
                    lstContLinkIds.add(cd.ContentDocumentId);
                    // map from content link to the proposal
                    mapContProp.put(cd.ContentDocumentId, cd.LinkedEntityId);
                }
                listContVer = [SELECT Id, ContentDocumentId, Title, VersionData, ContentSize, FileExtension
                    FROM ContentVersion
                    WHERE ContentDocumentId IN: lstContLinkIds AND Title LIKE '%Order Form%'
                    ORDER BY LastModifiedDate DESC
                ];
            }
        }
        // create Content version records
        id proposalId;
        id priorProposalId = null;
        string proposalName;
        
        if (!listContVer.isEmpty()) {
        	// we could have more than one order form on the quote
        	// only pick up the first one (which is the most recently created one)
            for (ContentVersion oContVersion: listContVer) {
            	proposalId = mapContProp.get(oContVersion.ContentDocumentId);
	            proposalName = mapQuoteNames.get(proposalId);
	            if (priorProposalId != proposalId) {
	            	priorProposalId = proposalId;
	                // build a Content Version record for each attachment/file
		            ContentVersion contVer = new ContentVersion();
		            contVer.ContentLocation = 'S';
		            contVer.VersionData = oContVersion.VersionData; 
		            // create the title using the following format Q-00994371__signed.pdf
		            contVer.Title = String.valueOf(proposalName + '__signed.pdf');
		            contVer.Legacy_ParentId__c = proposalId; // use this field to tie the content version to the proposal
		            contVer.PathOnClient = String.valueOf(proposalName + '__signed.pdf');
		            listNewContVer.add(contVer); 
	            }
            }
        }

        system.debug(logginglevel.INFO, 'PostAcceptAttachment - insert Content Version records for Order Form: ' + listNewContVer);
        
        // Create new Content version records
        createContentVersion(listNewContVer);
    	
    } 
       	
    // Create new Content version records
    private static void createContentVersion(list<ContentVersion> listNewContVer) {
        // insert content version records
        set<string> setNewContVerIds = new set<string>();
        Database.SaveResult[] lsr;
            	        
        if (!Schema.sObjectType.ContentVersion.isCreateable() || !Schema.sObjectType.ContentDocumentLink.isCreateable()) {
            throw new DCCustomException(UserInfo.getName() + ' does not have access to create: Content objects');
        }
        
        // Insert version records - this will automatically create a content documents record which we need to add 
        // to the content document link records we are creating                      
        //insert lstContVer;
        lsr =  Database.insert(listNewContVer, false);
        if (lsr != null && lsr.size() > 0) {
            for (Integer i = 0; i < lsr.size(); i++) {
                if (lsr.get(i).isSuccess()) {
                    setNewContVerIds.add(lsr.get(i).getId());
                }
            } // end for loop        
        } // end if
        
        // insert the content document link records
        insertNewContDocLink(setNewContVerIds);
    } 
           
         
    // insert the Content Document Link Records for the signed order form
    private static void insertNewContDocLink(set<string> setNewContVerIds) {
        list<ContentDocumentLink> lstContLink = new list<ContentDocumentLink>();
                
        // Reselect version records to get the new Document ids which were automatically created
        for (ContentVersion oContVer : [SELECT Id, ContentDocumentId, Legacy_ParentId__c  
                                        FROM ContentVersion 
                                        WHERE id IN : setNewContVerIds]) {
            // create linking Content Document record 
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = oContVer.ContentDocumentId;
            cdl.LinkedEntityId = oContVer.Legacy_ParentId__c; //APTS_Custom_Quote_Proposal__c;
            system.debug(logginglevel.INFO, 'Document Quote ID : ' + cdl.LinkedEntityId);
            cdl.ShareType = 'V';
            lstContLink.add(cdl);
        }
        // insert content link records
        insert lstContLink;  
    }
    
    
    //This method creates attachment body part 1 which is Header till Proposal Inforamation.
    private static String createAttachmentBody1(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem) {
        string strConvertedDate;
        decimal decMonthlyAmt;

        //Start Method Calculate Monthly Amount
        strConvertedDate = '';
        if (proposalLineItem.Apttus_Proposal__Proposal__r.Digitally_Signed_Date__c != null) {
            strConvertedDate = proposalLineItem.Apttus_Proposal__Proposal__r.Digitally_Signed_Date__c.format('MM/dd/yyyy hh:mm a z', 'America/Chicago');
            decMonthlyAmt = calculateMonthlyAmt(proposalLineItem);
        }

        //created the text for the attachment
        String encodedContentsString = '';
        encodedContentsString = encodedContentsString + '<br/><br/>' + Label.LCRMTemplateLogo + '<br/><br/><div>This document includes the date, time of your digital agreement with Thomson Reuters. For full terms & conditions, please review the order form, a copy of which will be emailed to you separately.</div><br/><br/>';
        encodedContentsString = encodedContentsString + '<div>I have confirmed that I, ' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact_Name__c +
            ', am expressly authorized to submit the Order Form, and accept the contract Terms and Conditions, on behalf of ' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.name + '.</div><br/><br/>';
        encodedContentsString = encodedContentsString + '<table>' +
            '<tr><td>Proposal-ID</td><td>' + proposalLineItem.Apttus_Proposal__Proposal__r.Name + '</td></tr>' +
            '<tr><td>Date/Time Stamp Proposal was accepted</td><td>' + strConvertedDate + '</td></tr>' +
            '<tr><td>Name of Signer</td><td>' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact_Name__c + '</td></tr>' +
            '<tr><td>Account Name</td><td>' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.name + '</td></tr>' +
            '<tr><td>Account Number</td><td>' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Sold_To_SAP_Account_Number__c + '</td></tr>' +
            '<tr><td>Total Monthly Price of Proposal</td><td>' + decMonthlyAmt + '</td></tr></table>' +
            '<br/><br/> <table><tr><th><u>Products</u></th></tr>';

        return encodedContentsString;
    }

    
    //This method creates attachment body part 2 adds Product name to the attachment.  So all the Products will be added here for One Quote.
    private static String createAttachmentBody2(String productName) {
        //add product to list      
        String encodedContentsString = '';
        encodedContentsString = encodedContentsString +
            '<tr><td>' + productName + '</td></tr>';
        System.debug(LoggingLevel.INFO, '#####' + encodedContentsString);
        return encodedContentsString;
    }


    //This method is used for sending emails to Customers for Renewals
    @TestVisible private static void createRenewalEmail(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem) {
        string quoteOwner;
        string oppOwner;
        string[] ccmail;

        quoteOwner = proposalLineItem.Apttus_Proposal__Proposal__r.Owner.Email;
        oppOwner = proposalLineItem.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Owner.Email; // DLT-20124
        if (quoteOwner == oppOwner) {
            ccmail = new string[] {
                quoteOwner
            };
        } else {
            ccmail = new string[] {
                quoteOwner,
                oppOwner
            };
        }

        // DLT-20948 - remove check for inactive Contacts - if (proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__r.Contact_Inactive__c == false && 
        if (proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__r.IsEmailBounced == false) {
            // This is a good Contact - send the email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__c);
            mail.setTemplateId(templateIdRenewals);
            mail.setCcAddresses(ccmail);
            mail.setWhatId(proposalLineItem.Apttus_Proposal__Proposal__c);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setOrgWideEmailAddressId(owaRenewals.id);
            mail.setSaveAsActivity(false);
            lstAllEmailMessages.add(mail);
        } else {
            // The Contact is not good - send alternative emails
            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            mail1.setHtmlBody('<html>This order cannot proceed with the contact you have selected.  Please select an Order Confirmation contact with a valid email address.<br><br>' +
                'Here are the quote details:' +
                '<br><br>Quote/Proposal: <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + proposalLineItem.Apttus_Proposal__Proposal__c + '">' + proposalLineItem.Apttus_Proposal__Proposal__r.Name + '</a>' +
                '<br>Quote/Proposal Name:   ' + proposalLineItem.Apttus_Proposal__Proposal__r.Apttus_Proposal__Proposal_Name__c +
                '<br> Signer/Contact Name:   ' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact_Name__c +
                '<br>Signer/Contact Email:   ' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact_Email__c +
                '<br>Account Name:   ' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_Sold_To__r.name +
                '<br>Account Number:   ' + proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Sold_To_SAP_Account_Number__c + '</html>');
            mail1.setToAddresses(ccmail);
            mail1.setSubject('Thomson Reuters Approval Details - Action Required');
            mail1.setOrgWideEmailAddressId(owaRenewals.id);
            lstAllEmailMessages.add(mail1);

            // send copy of the original email
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            emailMsg = Messaging.renderStoredEmailTemplate(templateIdRenewals, proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__c, proposalLineItem.Apttus_Proposal__Proposal__c);
            emailMsg.setSaveAsActivity(false);
            emailMsg.setTreatTargetObjectAsRecipient(false);
            emailMsg.setToAddresses(ccmail);
            emailMsg.setSubject('Thomson Reuters Approval Details - Inactive Contact');
            emailMsg.setOrgWideEmailAddressId(owaRenewals.id);
            system.debug(LoggingLevel.INFO, emailMsg);
            lstAllEmailMessages.add(emailMsg);
        }
    }


    //This method is used for sending emails to Customers for New Sales
    @TestVisible private static void createNSEEmail(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem) {
        string strEmailTemplate;
        string quoteOwner;
        string[] ccmail;

        quoteOwner = proposalLineItem.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.Owner.Email; // DLT-20124
        ccmail = new string[] {
            quoteOwner
        };

        // check which template to use
        if (proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == Label.Ecom_FindLawStore) {
            strEmailTemplate = templateIdNSEFL;
        } else {
            strEmailTemplate = templateIdNSENotFL;
        }

        if (proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__r.Contact_Inactive__c == false &&
            proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__r.IsEmailBounced == false) {
            // This is a good Contact - send the email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(proposalLineItem.Apttus_Proposal__Proposal__r.APTS_Order_Confirmation_Contact__c);
            mail.setTemplateId(strEmailTemplate);
            mail.setWhatId(proposalLineItem.Apttus_Proposal__Proposal__c);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setOrgWideEmailAddressId(owaRenewalsNSE.id);
            mail.setSaveAsActivity(false);
            lstAllEmailMessages.add(mail);
        }
    }


    // insert Exception Logs
    @TestVisible private static void insertExceptionLogs(List<Digital_Exception_Log__c> exList) {
        // test coverage for exceptions 
        if (Test.isRunningTest()) {
        	Digital_Exception_Log__c deLog = new Digital_Exception_Log__c();
        	deLog.Exception_Message__c = 'Text EX Error Message';
        	deLog.Exception_Type__c = 'Text EX Error Type';
        	deLog.Additional_Information__c = 'Test Additional Error Text';            
        	deLog.User_Message__c = 'Test User Message';
        	deLog.Class_Reference__c = 'Digital_PostAcceptAttachment';
        	exList.add(deLog); 
       	}
        if (exList != null && exList.size() > 0 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()) {
            try {
                insert exList;
                exList.clear();
            } catch(Exception e) {
                system.debug(logginglevel.ERROR, 'Exception Opportunities' + e);
            }
        }
    }   

}