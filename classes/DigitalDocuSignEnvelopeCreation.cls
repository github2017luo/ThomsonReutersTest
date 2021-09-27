/**
 * This class is designed to be utilized as a schedulable routine which is expected to run daily or more.
 * This job creates DocuSign Envelopes for Quotes that meet specific criteria.
 */
/**
 * CHANGE HISTORY
 * ==============================================================================
 * Date         Name                    Description
 * 2017-03-27   Brenda Shields          Created for Digital Spearhead Project
 * 2017-05-15   Dinesh                  Update Quote/Proposal selection criteria
 *                                      - Add new is_Digital_Channel__c flag
 *                                      - Remove Campaign custom object references
 *                                      - Remove check for Quote/Proposal Primary 
 *                                      - Removed Exeption Log object and added Digital Exception Log object to log Errors   
 *                                      - Don't select Quote/Proposal if there is no confirmation contact has been selected
 *                                      - Add new cusom label to use for "Send on Behalf of" when connecting to DocuSign
 * 2017-06-26   Brenda shields          Added creation of Digital Product Xref records for Quote/Proposal line items
 * 2017-07-11   Dinesh Kumar            Modified from Scheduled Job to Batchable Job to process more no.of records
 * 2017-07-14   Brenda Shields          DLT- 1673 Best Value - Add logic to Set Quote Type - need to evaluate all quotes/proposals for the opportunity
 * 2017-08-03   Brenda Shields          DLT- 2301 Only send the latest (most current) attachment to DocuSign
 * 2017-08-20   Brenda Shields          DLT- 2689 Set Opportunity stage to 5% when the quote is presented
 * 2017-08-28   Brenda Shields          DLT-  495 Add Carbon Copy recipient to all envelopes 
 * 2017-09-12   Benjamin Her/           DLT- 3583 Update Docusign report with  SAP Account number, quote number
 *              David Hoel              - Added Apttus_Proposal__Opportunity__r.SAP_Account_Number__c to quoteList SOQL query.
 *                                      - Added sCustomFields to sBodyInformation
 * 2017-09-22   Brenda Shields          DLT- 2676 - Don't Set the Digital Quote Type field if it's already Set 
 * 2017-12-27   Brenda Shields          DLT- 6908 - Remove code that Set the Digital Quote Type field
 * 2017-12-27   Brenda Shields          DLT- 6929 - Update job Proposal selection to only pick up Digital Automation quotes
 *                                      - This will also only run the envelope creation once
 * 2018-01-8    Benjamin Her            DLT- 7094 - Added "notification" parameters to envelope creation to use default DocuSign Account expiration days.
 *                                      Created createExceptionLog() method to clean up code to ensure 85% code coverage.
 * 2018-01-19   Ramesh                  DLT- 7265 - Contract Not In Sync flag would be reset within the Create Envelope service.
 *                                      - This will avoid the Multiple updates
 * 2018-02-28   Brenda Shields          DLT- 7917 - Create Opportunity Pricing record for Straight Renewal Quotes
 * 2018-04-02   Poonam Garg             DLT- 8139 - Exclude Corporate accounts from updating Opp Pricing
 * 2018-04-06   Divija Salla            DLT- 8018 - Additional Segment 'Corporate' is used along with Small Law and SendonBehalfofEmail and URL will be assigned according to the Segment
 * 2018-04-16   David Hoel              DLT- 6718 - Add DocuSign "Tab" for Document Visibility
 * 2018-04-16   Brenda Shields          DLT- 9092 - Fix issue when " char is in the OCC Contact Name
 * 2018-04-16   Brenda Shields          DLT- 9094 - Make "Send on Behalf of" emails based on Digital Firm dynamic - add custom metadata type
 *                                      DLT- 9253 - Update sender email in the Apttus Envelope Contect text as the SendonBehalfof email  
 * 2018-05-14   Benjamin Her            DLT- 9401 - Update parameters when creating envelope to Set Envelope Expiration to Opportunity's Renewal Date
 * 2018-05-22   Brenda Shields          DLT-10048 - Added coding to Opp Stage name based on prior value 
 * 2018-05-29   Brenda Shields          DLT- 7740 - Update DocuSign expiration number of days got New Sales when the renewal date is null and so SAP Account Number
 * 2018-06-11   Brenda Shields          DLT- 9762 - GLI Updates and remove Opportunity Pricing logic    
 * 2018-09-12   Benjamin Her            DLT-12186 - Improve class performance.
 * 2018-10-10   Samreen Ali             DLT-12521 - [New Sales- Small Law] Change Owner in SLF Queue
 * 2018-12-26   Bishanka Dassarma       DLT-14156 - Fix Code Scan Security Issues
 * 2019-02-15   Navleen                 DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 2019-04-29   HArikaSai P             DLT-16286 - [SLF] - Automation Failure - Digital_ProposalAutomaion DML Exception Issue
 * 2019-07-18   Brenda Shields          DLT-17210 - Attachments are no longer going to be supported - change attachment 'TYPE' from Attachment to File                                 
 * 2019-08-21   Benjamin Her            DLT-17444 - Revert New Sale's authenticationheader selection back to proposal approval segment
 * 2019-09-20   HarikaSai P             DLT-17520 - [ALL] Update CXD Automation class to not process an account if Digital Subscription bypass field has been Set
 * 2019-11-18   David Hoel              DLT-18470 - [ALL] Update Envelope Creation class to display a better error message and not process in DocuSign if the Renewal Date is in the past
 * 2020-04-06   Benjamin Her            DLT-19805 - Added 'ORDER BY' to ContentVersion query
 * 2020-04-08   Benjamin Her            DLT-19383 - Updated IF critera for selecting opportunities to get bypassed.
 * 2020-06-02   Benjamin Her            DLT-20101 - Send correct send on behalf email for SLF and FindLaw
 * 2020-06-30   Rahul Natarajan         DLT-18904 - Cohort Validation Automation Report 
 * 2020-07-08   Brenda Shields          DLT-20312 - Created custom label to hold the number of envelopes we should create per hour
 *                                                  Updated initial query to ecluded records with null order confirmation contact
 * 2020-08-12   Benamin Her             DLT-20588 - Implement MLF support
 * 2021-03-07   Brenda Shields          DLT-21480 - [ALL] Update the Envelope Creation class to look for the order form pdf as a file and not an attachment
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 * 2021-04-05	Ameeta A				DLT-21574 - Incorrect Opportunity Staging on Rep Added Offers(Includes DLT-21692)
 * ==============================================================================
 */
/** 
* @description : DigitalDocuSignEnvelopeCreation class to create docusign envelopes
*/ 
public without sharing class DigitalDocuSignEnvelopeCreation
    implements Database.AllowsCallouts, Database.Batchable<Apttus_Proposal__Proposal__c > {

    private static final String TOKEN_URL = System.label.Digital_TOKEN_URL;
    private static final String USERNAME = System.label.Digital_UserName;
    private static final String PASSWORD = System.label.Digital_Password;
    private static final String INTEGRATIONKEY = System.label.Digital_Integration_Key;
    private static final String DIGITAL_QUOTE_TYPE_MANUAL = 'Manual';
    // define how many DocuSign envelopes we can create per hour - currently limited to 700
    private static final integer DOCUSIGNENVELOPESPERHOUR = Integer.valueof(system.label.Digital_DocuSign_Envelopes_Per_Hr.trim());
    private static final List<String> LAW_FIRMS = System.Label.Digital_Law_Firm.split(',');

    // when adding fields to this selection statement, also add the new fields to DigitalDocuSignUpdateDocument class
    // that class creates it's own quote List to pass into this class for the Digital automation process
    // GLI Changes -- 
    // Map Apttus_Proposal__Account__r.Digital_Firm__c to Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c
    // Map Apttus_Proposal__Opportunity__r.SAP_Account_Number__c to APTS_Sold_To_SAP_Account_Number__c
    public List<Apttus_Proposal__Proposal__c > quoteList = [
        SELECT Id, Name, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Opportunity__r.SAP_Account_Number__c,
        Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c,
        Apttus_Proposal__Opportunity__r.Owner.Email, Apttus_Proposal__Opportunity__r.Owner.Name,
        Apttus_Proposal__Opportunity__r.Digital_PreviousStageName__c,
        APTS_Order_Confirmation_Contact__c, APTS_Order_Confirmation_Contact_Name__c,
        APTS_Order_Confirmation_Contact_Email__c, Apttus_Proposal__Primary__c,
        Digital_Quote_Type__c, APTS_Renewal__c, APTS_Sold_To_SAP_Account_Number__c, 
        APTS_Proposal_Business_Unit__c, APTS_Approval_Segment__c,Digital_Quote_Failure_Reason__c,
        Apttus_Proposal__Opportunity__r.Renewal_Date__c, CreatedDate, Is_Digital_New_Sales__c
        FROM Apttus_Proposal__Proposal__c
        WHERE is_Digital_Channel__c = true
        AND APTS_Order_Confirmation_Contact_Name__c != null AND APTS_Order_Confirmation_Contact_Email__c != null
        AND APTS_Order_Confirmation_Contact__c != null AND DocuSign_Envelope_ID__c = ''
        AND Apttus_Proposal__Approval_Stage__c = 'Generated'
        AND Digital_Quote_Automation__c = true
        AND Digital_Quote_Type__c IN('Best Value', 'Best Value+Config', 'Premium', 'Straight Renewal')
        AND Digital_Envelope_Created__c = false
        LIMIT : DOCUSIGNENVELOPESPERHOUR
    ];
    public static Apttus_DocuApi__DocuSignUser__c oDocuSignAccount = [
        SELECT Apttus_DocuApi__DocuSignAccountId__c, Apttus_DocuApi__DocuSignEmailAddress__c, Apttus_DocuApi__DocuSignUserName__c
        FROM Apttus_DocuApi__DocuSignUser__c
        WHERE Apttus_DocuApi__Default__c = true
        LIMIT 1
    ];
    public static List<Product_Account_Detail__c > subscriptions = new List<Product_Account_Detail__c > ();
    public static List<Apttus_Proposal__Proposal__c > listToUpdate = new List<Apttus_Proposal__Proposal__c > ();
    public static List<Apttus_DocuApi__DocuSignEnvelope__c > listofEnvelopes = new List<Apttus_DocuApi__DocuSignEnvelope__c > ();
    public static List<Digital_Exception_Log__c > exList = new List<Digital_Exception_Log__c > ();
    public static List<Opportunity> oppsToUpdate = new List<Opportunity> ();
    public static Set<String> subcamps = new Set<String> ();
    public Set<Id> accoountid = new Set<Id> ();
    public static Map<Id, Id> mapContProp = new Map<Id, Id> ();


    /** 
	* @description : start method
	* @param bc : batachable context
	* @return Apttus_Proposal__Proposal__c : Quote records
	*/ 
    public Iterable<Apttus_Proposal__Proposal__c> start(database.batchablecontext bc) {
        return quoteList;
    }


    /** 
	* @description : Execute method
	* @param bc : batchable Context 
	* @param scope : subset of all records to be processed
	*/ 
    public void execute(Database.BatchableContext bc, list<Apttus_Proposal__Proposal__c> scope) {
        list<Apttus_Proposal__Proposal__c> qList = new list<Apttus_Proposal__Proposal__c>();

        for (Apttus_Proposal__Proposal__c q: Scope) {
            if (q.Apttus_Proposal__Opportunity__r.Renewal_Date__c<System.today()) { // DLT-18470
                exList.add(createExceptionLog( 'Quote Id: ' + String.valueOf(q.Id), 'DigitalDocuSignEnvelopeCreation > createEnvelopes', 'DocuSign: expireAfter not in range 0-999', 'Renewal Date is in the past.', 'Check Opportunity.Renewal_Date__c : ' + q.Apttus_Proposal__Opportunity__r.Renewal_Date__c  ) );
            } else {
                qList.add(q);
            }
        }

        if (!qList.isEmpty()) {
            DigitalDocuSignEnvelopeCreation.createEnvelopes(qList);
        } else {
            try {
                if (!exlist.isEmpty()) {
                    insert exList;
                }
            } catch (Exception e) {
                system.debug(logginglevel.ERROR, 'Exception object' + e);
            }
        }
    }


    /** 
	* @description : Creates a digital exception record
	* @param additionalInformation : Additional Information for the error 
	* @param classRef : Name of the class/method that is reporting the error
	* @param exMessage : Error Message
	* @param exType : Type of error
	* @param userMessage : Additional user supplied information 
	* @return Digital_Exception_Log__c : Digital Exception Log record
	*/     
    public static Digital_Exception_Log__c createExceptionLog(
        String additionalInformation, String classRef, String exMessage, String exType, String userMessage) {

        Digital_Exception_Log__c exLog = new Digital_Exception_Log__c();
        exLog.Additional_Information__c = additionalInformation;
        exLog.Class_Reference__c = classRef;
        exLog.Exception_Message__c = exMessage;
        exLog.Exception_Type__c = exType;
        exLog.User_Message__c = userMessage;

        return exLog;
    }


    /** 
	* @description : Builds request and send information to DocuSign to create envelopes for a list of quotes
	* @param listQuotes : List of Quote records 
	*/     
    public static void createEnvelopes(List<Apttus_Proposal__Proposal__c > listQuotes) {
        List<Id> listQuoteIds = new List<Id> ();
        // List of Opps to update
        Set<Id> setOppsToUpdate = new Set<Id> ();
        String sTemp;
        String sTokenURL;
        String sUserName;
        String sPassword;
        String sIntegrationKey;
        String authenticationHeader;
        String createEnvelopeUrl = '';
        //DLT-12186
        HttpResponse docuSignResponse = new HttpResponse();
        // Map to manage dynamic send on behalf of emails
        Map<String, String> mapSendEmails = new Map<String, String> ();
        Map<String, String> mapSendAuth = new Map<String, String> ();
        // Set defaults if no web service settings are found
        sTokenURL = TOKEN_URL;
        sUserName = USERNAME;
        sPassword = PASSWORD;
        sIntegrationKey = INTEGRATIONKEY;

        //End process - Return is listQuote is null or empty
        if (listQuotes == null || listQuotes.size()<= 0) {
            return;
        }

        // Build Map for multiple send of behalf emails - will become dynamic in the future
        /* for(Digital_Firm_Defaults__mdt oSender : [SELECT Label, DocuSign_Send_on_Behalf_of_Email__c
                                                    FROM Digital_Firm_Defaults__mdt]){
            mapSendEmails.put(oSender.Label, oSender.DocuSign_Send_on_Behalf_of_Email__c); 
        } */

        if (listQuotes[0].Is_Digital_New_Sales__c) {
            for (Digital_Firm_Defaults__mdt oSender: [
                    SELECT Proposal_Approval_Segment__c, DocuSign_Send_on_Behalf_of_Email__c
                    FROM Digital_Firm_Defaults__mdt
                    WHERE Opportunity_Type__c = 'New Sales'
                ]) {
                mapSendEmails.put(oSender.Proposal_Approval_Segment__c, oSender.DocuSign_Send_on_Behalf_of_Email__c);
            }
        } else {
            for (Digital_Firm_Defaults__mdt oSender: [
                    SELECT Label, Proposal_Approval_Segment__c, DocuSign_Send_on_Behalf_of_Email__c
                    FROM Digital_Firm_Defaults__mdt
                    WHERE Opportunity_Type__c != 'New Sales'
                ]) {
                mapSendEmails.put(oSender.Proposal_Approval_Segment__c, oSender.DocuSign_Send_on_Behalf_of_Email__c);
            }
        }

        system.debug(logginglevel.INFO, 'Dynamic Send On Behalf Of Emails: ' + mapSendEmails);

        // get DocuSign connection information 
        if (WebServiceSettings__c.getInstance('Digital DocuSign Connection') != null) {
            sTokenURL = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Endpoint__c;
            sUserName = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Username__c;
            // password contains password and integration key
            sTemp = WebServiceSettings__c.getInstance('Digital DocuSign Connection').Password__c;
            List<String> listTemp = (sTemp.split(':'));
            sPassword = listTemp[0];
            sIntegrationKey = listTemp[1];
        }

        for (String firm: mapSendEmails.keySet()) {
            authenticationHeader =
                '<DocuSignCredentials>' +
                '<Username>' + sUserName + '</Username>' +
                '<Password>' + sPassword + '</Password>' +
                '<IntegratorKey>' + sIntegrationKey + '</IntegratorKey>' +
                '<SendOnBehalfOf>' + mapSendEmails.get(firm) + '</SendOnBehalfOf>' +
                '</DocuSignCredentials>';

            String endPointType = sTokenURL;
            //DLT-12186
            docuSignResponse = httpGetRequest(sTokenURL, authenticationHeader);

            if (docuSignResponse.getStatusCode() != 200) {
                exList.add( createExceptionLog(  'SFDC : WebServiceSettings__c : Digital DocuSign Connection',  'DigitalDocuSignEnvelopeCreation > createEnvelopes',  docuSignResponse.tostring(),  endPointType,authenticationHeader ) );
            } else {
                JSONParser parser = JSON.createParser(docuSignResponse.getBody());               
               
                Boolean bMyAccount;
                bMyAccount = false;
                createEnvelopeUrl = '';

                while (parser.nextToken() != null) {
                    if (parser.getText() == 'accountId') {
                        parser.nextToken();
                        if (parser.getText() == oDocuSignAccount.Apttus_DocuApi__DocuSignAccountId__c) {
                            bMyAccount = true;
                        }
                    }
                    // this is the same requardless of what send on behalf of email we are using
                    if (parser.getText() == 'baseUrl' && bMyAccount == true) {
                        parser.nextToken();
                        createEnvelopeUrl = parser.getText();
                        break;
                    }
                } // end of while loop
                // build Map of successful authentication headers
                mapSendAuth.put(firm, authenticationHeader);
            }
        } // end looping through all send on bahalf of emails in custom metadata type

        // build the end point for envelope creation
        createEnvelopeUrl = createEnvelopeUrl + '/envelopes';

        // if we don't find any users then stop process, if we find at least one user, then process as much as we can
        if (mapSendAuth.isEmpty()) {
            // finish up
            try {
                insert exList;
            } catch (Exception e) {
                system.debug(logginglevel.ERROR, 'Exception object' + e);
            }
            return;
        }

        // loop through all quotes for pre-proccesing opportunities and getting attachments
        for (Apttus_Proposal__Proposal__c oQuote: listQuotes) {

            // build a List of quote ids in order to get attachments
            listQuoteIds.add(oQuote.Id);
            system.debug(logginglevel.INFO, 'Processing Quote: ' + oQuote.Id + ' Primary: ' + oQuote.Apttus_Proposal__Primary__c +
                ' Name: ' + oQuote.Name + ' Quote type: ' + oQuote.Digital_Quote_Type__c + ' Opp: ' + oQuote.Apttus_Proposal__Opportunity__c);
            // We only want to update the Opp once even if there are multiple Proposals

            // DLT- 10967 To fix opportunity Stage value for New Sales
            if (!oQuote.Is_Digital_New_Sales__c && !setOppsToUpdate.contains(oQuote.Apttus_Proposal__Opportunity__c)) {
                // add to the List so we don't create duplicates
                setOppsToUpdate.add(oQuote.Apttus_Proposal__Opportunity__c);
                opportunitesToBeUpdated(oQuote);
            }
        } // end of pre-processing quotes/proposals

        // get Attachments - needed for 'in flight' proposals which still have attachments
        List<Attachment> listAttachments = new List<Attachment> ();
        if (Schema.sObjectType.Attachment.isAccessible()) {
            listAttachments = [
                SELECT Id, parentid, Name, Body, BodyLength FROM Attachment WHERE parentid IN: listQuoteIds ORDER BY LastModifiedDate DESC
            ];
        }
        // get files - new way of storing the order form documents going forward
        List<ContentVersion> listContVer = new List<ContentVersion> ();
        List<id> lstContLinkIds = new List<id> ();

        if (Schema.sObjectType.ContentDocumentLink.isAccessible()) {
            List<ContentDocumentLink> contLink = [
                SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: listQuoteIds
            ];
            if (!ContLink.isEmpty()) {
                for (ContentDocumentLink cd: contLink) {
                    lstContLinkIds.add(cd.ContentDocumentId);
                    mapContProp.put(cd.ContentDocumentId, cd.LinkedEntityId);
                }
                listContVer = [
                    SELECT Id, ContentDocumentId, Title, VersionData, ContentSize, FileExtension
                    FROM ContentVersion
                    WHERE ContentDocumentId IN: lstContLinkIds AND Title LIKE '%Order Form%'
                    ORDER BY LastModifiedDate DESC
                ];
            }
        }
        // Calls helper function to complete Docusign process.
        envelopeCreationHelper(listQuotes, listAttachments, listContVer, authenticationHeader, mapSendAuth, mapSendEmails, createEnvelopeUrl);

        // Post-Docusign Process Activity - Calls function to insert/update Salesforce objects
        updateSalesforceObject();

    } // End of createEnvelopes() method


    // Added in DLT-12186 to improve class performance.
    /** 
	* @description : Helper functions for the creation of the DocuSign Envelope
	* @param listQuotes : list of Quote records
	* @param listAttachments : list of Attachment Information
	* @param listContVer : list of content Version Information
	* @param authenticationHeader : credential information
	* @param mapSendAuth : map of sender authentications
	* @param mapSendEmails : map of sender emails
	* @param createEnvelopeUrl : url for DocuSign request
	*/     
    public static void envelopeCreationHelper(
        list<Apttus_Proposal__Proposal__c > listQuotes, list<Attachment> listAttachments, list<ContentVersion> listContVer,
        string authenticationHeader, map<String, String> mapSendAuth, map<String, String> mapSendEmails, string createEnvelopeUrl) {

        String sSignerInformation;
        String sSenderEmail;
        String sEnvelopeContent;
        String sCustomFields;
        string sDigitalSegment;
        Map<String, String> mapDocumentInfo = new Map<String, String> ();
        Map<String, String> dsFirmMap = new Map<String, String> ();
        // Build DocuSign Envelope for each quote
        String sBodyInformation = '';
        Set<String> setOfCustNumber = new Set<String> ();

        for (Apttus_Proposal__Proposal__c q: listQuotes) {
            setOfCustNumber.add(q.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c);
        }

        for (Product_Account_Detail__c prd: [
                SELECT ZP_Cust_Number__c, Digital_Firm__c FROM Product_Account_Detail__c
                WHERE ZP_Cust_Number__c IN: setOfCustNumber
            ]) {

            dsFirmMap.put(prd.ZP_Cust_Number__c, prd.Digital_Firm__c);
        }

        for (Apttus_Proposal__Proposal__c oQuote: listQuotes) {
            //call request body bulding function
            sCustomFields = buildCustomFieldRequest(oQuote);
            // Build signer information 
            sSignerInformation = buildSignerInformationRequest(oQuote);
            // Build documents for each envelope
            mapDocumentInfo = buildDocumentInformationRequest(listAttachments, listContVer, oQuote);
            // build request body information
            sBodyInformation = buildBodyInformationRequest(oQuote, sSignerInformation, mapDocumentInfo.get('Attachment'), sCustomFields);

            // were there any errors?
            try {
                if (mapDocumentInfo.get('Error').equals('True')) {
                    exList.add(
                        createExceptionLog(
                            'Quote Id:' + String.valueof(oQuote.Id),
                            'DigitalDocuSignEnvelopeCreation > createEnvelopes',
                            'Attachment Issue',
                            'No Attachments/Attachment Heap Size',
                            'Attachment Error'
                        )
                    );
                    continue;
                }
            } catch (exception e) {
                exList.add( createExceptionLog( 'Exception Thrown',  'DigitalDocuSignEnvelopeCreation',   String.valueOf(e), 'Exception Thrown', 'Exception Thrown'  ) );
                continue;
            }

            //Updated DLT-20101 
            // findlaw is no longer a part of the approval segment field
            if (oQuote.APTS_Proposal_Business_Unit__c == 'FindLaw') {
            	sDigitalSegment = oQuote.APTS_Proposal_Business_Unit__c;
            } else {
            	sDigitalSegment = oQuote.APTS_Approval_Segment__c;
            }
            system.debug(logginglevel.INFO, 'Digital Segment for authentication: ' + sDigitalsegment);
            authenticationHeader = (
                (oQuote.is_Digital_New_Sales__c ||
                    oQuote.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_MANUAL ||
                    oQuote.APTS_Proposal_Business_Unit__c == 'FindLaw' ||
                    LAW_FIRMS.contains(sDigitalSegment)) ?
                mapSendAuth.get(sDigitalSegment) :
                mapSendAuth.get(dsFirmMap.get(oQuote.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c))
            );
            system.debug(logginglevel.INFO, 'DoduSign authentication header: ' + authenticationHeader);
            if (authenticationHeader == null) {
                authenticationHeader = mapSendAuth.get('None');

            }
            //if(oQuote.Is_Digital_New_Sales__c && oQuote.Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c=='Small Law')
            //    authenticationHeader = mapSendAuth.get('New Sales- Small Law');

            //DLT-12186
            HttpResponse docuSignResponse = httpPostRequest(createEnvelopeUrl, authenticationHeader, sBodyInformation);

            if (docuSignResponse.getStatusCode() != 200 && docuSignResponse.getStatusCode() != 201) {
                exList.add(
                    createExceptionLog(
                        docuSignResponse.getBody(),
                        'DigitalDocuSignEnvelopeCreation > createEnvelopes',
                        'Quote Id: ' + oQuote.Id + ', ' + docuSignResponse.toString(),
                        createEnvelopeUrl,
                        'Check Contact EmailId in SFDC and document is signed in docusign.'
                    )
                );
            } else {
                // we need to get the envelope id from the results and upadte the quote
                JSONParser parser1 = JSON.createParser(docuSignResponse.getBody());
                String envelopeId; //docusign envelope id

                while (parser1.nextToken() != null) {
                    if (parser1.getText() == 'envelopeId') {
                        parser1.nextToken();
                        envelopeId = parser1.getText();
                        break;
                    }
                } // end of while loop for res1

                // update the quote with the envelope id 
                Apttus_Proposal__Proposal__c updatedQuote = new Apttus_Proposal__Proposal__c();
                updatedQuote.Id = oQuote.Id;
                updatedQuote.DocuSign_Envelope_ID__c = envelopeId;
                updatedQuote.Apttus_Proposal__Approval_Stage__c = 'Presented';
                //updatedQuote.Digital_Quote_Type__c = sQuoteType; 
                updatedQuote.Digital_Envelope_Created__c = true;
                updatedQuote.DC_Contract_Not_In_Sync__c = false;
                listToUpdate.add(updatedQuote);

                // Sender email should be the Send on Behalf of Email address - needed for AEM to get the correct email when accessing DocuSign
                //Updated DLT-20101 
                // findlaw is no longer a part of the approval segment field
	            if (oQuote.APTS_Proposal_Business_Unit__c == 'FindLaw') {
	            	sDigitalSegment = oQuote.APTS_Proposal_Business_Unit__c;
	            } else {
	            	sDigitalSegment = oQuote.APTS_Approval_Segment__c;
	            }
                sSenderEmail = (
                    (oQuote.is_Digital_New_Sales__c ||
                        oQuote.Digital_Quote_Type__c == DIGITAL_QUOTE_TYPE_MANUAL ||
                        oQuote.APTS_Proposal_Business_Unit__c == 'FindLaw' ||
                        LAW_FIRMS.contains(sDigitalSegment)) ?
                    mapSendEmails.get(sDigitalSegment) :
                    mapSendEmails.get(dsFirmMap.get(oQuote.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c))
                );
                system.debug(logginglevel.INFO, 'sSenderEmail: ' + sSenderEmail);
                // Set envelope content field
                sEnvelopeContent = '{"success":true,"showTagAndSend":false,"showSendforESignature":true,"showSendAsAnotherUser":true,"showPreview":true,"senderViewURL":null,"sendAsUserEmail":"' +
                    sSenderEmail + '","parentId":"' +
                    oQuote.Id + '","oneClickSend":false,"objRecipientList":{"listRecipient":[{"tabs":null,"signingGroupId":null,"signerType":"signers","signerRole":"Signer","selected":true,"orderNumber":1,"objectType":null,"objectIndex":0,"name":"' +
                    oQuote.APTS_Order_Confirmation_Contact_Name__c + '","isRequired":null,"id":"' +
                    oQuote.APTS_Order_Confirmation_Contact__c + '","emailTemplateId":null,"emailNotification":null,"email":"' +
                    oQuote.APTS_Order_Confirmation_Contact_Email__c + '","canMoveUp":false,"canMoveDown":false}]},"objAttachmentWrapperList":{"parentStatus":null,"parentNumber":null,"parentName":null,"listAttachmentWrapper":' +
                    mapDocumentInfo.get('DocumentDetails') + ',"hasSibling":false,"hasRelated":false,"hasParent":false,"hasChild":false,"hasAmendRenew":false},"notification":{"useAccountDefaults":true,"reminders":null,"expirations":null},"isPreviewInDocusign":false,"Id":"' +
                    envelopeId + '","errorMessage":null,"errorCode":null,"error":false,"envelopeStatus":"Sent","emailSubject":"Request for eSignatures","emailBody":"Request for eSignatures. Please review and sign.","documentUploadProcessId":null}';

                // create envelope record
                Apttus_DocuApi__DocuSignEnvelope__c createEnvelope = new Apttus_DocuApi__DocuSignEnvelope__c();
                createEnvelope.Apttus_DocuApi__DocumentName__c = mapDocumentInfo.get('DocumentName');
                createEnvelope.Apttus_DocuApi__EnvelopeContent__c = sEnvelopeContent;
                createEnvelope.Name = envelopeId;
                createEnvelope.Apttus_DocuApi__EnvelopeId__c = envelopeId;
                createEnvelope.Apttus_DocuApi__NumberOfDocuments__c = 1; //Set to 1, Current Code only attaches one document
                createEnvelope.Apttus_DocuApi__ParentId__c = oQuote.Id;
                createEnvelope.Apttus_DocuApi__StatusChangeDateTime__c = System.today();
                createEnvelope.Apttus_DocuApi__Status__c = 'sent';
                createEnvelope.Apttus_QPDSign__QuoteProposal__c = oQuote.Id;
                listofEnvelopes.add(createEnvelope);
            }
        } // end processing
    } // end of envelopeCreationHelper() method


    /** 
	* @description : Consolidates opportunities to be updated so the Opp is only updated one even if has multi Quotes
	* @param oQuote : Quote record 
	*/     
    public static void opportunitesToBeUpdated(Apttus_Proposal__Proposal__c oQuote) {
        String strOppPriorStage;
        integer manualCount;
        integer totalCount;
        manualCount = [SELECT count() FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Opportunity__c = : oQuote.Apttus_Proposal__Opportunity__c 
                         AND Digital_Quote_Type__c =: DIGITAL_QUOTE_TYPE_MANUAL];
        totalCount = [SELECT count() FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Opportunity__c = : oQuote.Apttus_Proposal__Opportunity__c];
        
        
        // create Opps to update
        Opportunity oppUpdate = new Opportunity();
        oppUpdate.Id = oQuote.Apttus_Proposal__Opportunity__c;
        // DLT-10048 - Set the stage according to prior stage value
        // GLI is moving to stage names not %s
        strOppPriorStage = oQuote.Apttus_Proposal__Opportunity__r.Digital_PreviousStageName__c;
        
        //Set previous oppty stage for manual quotes.
        if(manualCount == totalCount){
           oppUpdate.StageName = oQuote.Digital_Quote_Failure_Reason__c; 
        }else{
            if (strOppPriorStage == 'Contract Signed' || strOppPriorStage == 'Order Complete' ||
                strOppPriorStage == '' || strOppPriorStage == null) {
    
                oppUpdate.StageName = 'Appointment Scheduled'; //'5%';
    
            } else {
                oppUpdate.StageName = strOppPriorStage;
            }
        }
        oppsToUpdate.add(oppUpdate);
    } // end of OpportunitiesToBeUpdated() method


    /** 
	* @description : Post-Docusign process - Updates/Creates relevant objects in Salesforce
	*/     
    public static void updateSalesforceObject() {
        // update Quotes
        Database.SaveResult[] srList;
        try {
            if (listToUpdate != null && listToUpdate.size() > 0) {
                srList = Database.update(listToUpdate, false);
            }
        } catch (Exception e) {
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess()) {
                    system.debug(logginglevel.INFO, 'Successfully inserted Quote Proposal. ID: ' + sr.getId());
                } else {
                    for (Database.Error err: sr.getErrors()) {
                        exList.add( createExceptionLog( String.valueOf(err.getFields()),  'DigitalDocuSignEnvelopeCreation > createEnvelopes', err.getStatusCode() + '' + err.getMessage(),  'Quote Updation', 'Check SFDC Quote'  ) );
                    }
                }
            }
        }

        // Insert new Envelope records
        try {
            if (listofEnvelopes != null && listofEnvelopes.size() > 0) {
                insert listofEnvelopes;
            }
        } catch (Exception exc) {
            exList.add(  createExceptionLog(  String.valueOf(exc.getLineNumber()), 'DigitalDocuSignEnvelopeCreation > createEnvelopes',  exc.getMessage(),  'Enveolpe Insertion',  'Check Apttus_DocuApi__DocuSignEnvelope__c object records'    )   );
        }

        // update Opportunities - must be after quote update    
        Database.SaveResult[] srOppList;
        try {
            system.debug(logginglevel.INFO, 'Opportunities to update: ' + oppsToUpdate);
            if (oppsToUpdate != null && oppsToUpdate.size() > 0) {
                srOppList = Database.update(oppsToUpdate, false);
            }
        } catch (Exception e) {
            for (Database.SaveResult sr: srOppList) {
                if (sr.isSuccess()) {
                    system.debug(logginglevel.INFO, 'Successfully Opportunity Update.  ID: ' + sr.getId());
                } else {
                    for (Database.Error err: sr.getErrors()) {
                        exList.add(  createExceptionLog(   String.valueOf(err.getFields()), 'DigitalDocuSignEnvelopeCreation > createEnvelopes',  err.getStatusCode() + '' + err.getMessage(),  'Opportunity Update',  'Check SFDC Opportunity'  ) );
                    }
                }
            }
        }

        // finish up
        try {
            if (exlist != null && exList.size() > 0) {
                insert exList;
            }
        } catch (Exception e) {
            system.debug(logginglevel.ERROR, 'Exception object' + e);
        }
    } // end of updateSalesforceObject() method


    /** 
	* @description : builds body information for DocuSign request
	* @param oQuote : Quote record 
	* @param sSignerInformation : Signer Information
	* @param sAttachmentInformation : Attachment Information
	* @param sCustomFields : Custom Field Information
	* @return string : body information for DOcuSign request
	*/     
    public static String buildBodyInformationRequest(
        Apttus_Proposal__Proposal__c oQuote, String sSignerInformation, String sAttachmentInformation, String sCustomFields) {

        Integer intExpireDate;
        String sBodyInformation;

        // Set New Sales expiration days to 140
        if (oQuote.Apttus_Proposal__Opportunity__r.Renewal_Date__c == null) {
            intExpireDate = 140;
        } else {
            intExpireDate = date.today().daysBetween(oQuote.Apttus_Proposal__Opportunity__r.Renewal_Date__c);
        }

        sBodyInformation = '{"status":"sent", "emailSubject":"Request for eSignatures", "notification":{"useAccountDefaults":false, ' +
            '"reminders":null, "expirations":{"expireEnabled":true,"expireAfter":' + intExpireDate + ',"expireWarn":0}}, ' +
            sSignerInformation + ', ' + sAttachmentInformation + ',' + sCustomFields + '}';

        return sBodyInformation;
    }


    /** 
	* @description : builds map of related attachment information
	* @param listAttachments : List of attachments
	* @param listContVer : List of content version files
	* @param oQuote : Quote record
	* @return map<string, string> : map of attachment related information
	*/ 
    public static map<String, String> buildDocumentInformationRequest(
        list<Attachment> listAttachments, list<ContentVersion> listContVer, Apttus_Proposal__Proposal__c oQuote) {

        map<String, String> mapDocumentInfo = new map<String, String> ();
        Integer intCounter;
        Integer intAttachmentSize;
        String sDocumentNames;
        String sDocumentDetails;
        String sAttachmentInformation;
        String sTemp;
        Boolean bFileFound;
        Id idContProposal;

        if ((listContVer == null || listContVer.size()<= 0) &&
            (listAttachments == null || listAttachments.size()<= 0)) {
            mapDocumentInfo.put('Error', 'True');
            return mapDocumentInfo;
        }

        //call document build fuction
        bFileFound = false;
        intCounter = 0;
        intAttachmentSize = 0;
        sDocumentNames = '';
        sDocumentDetails = '';
        sAttachmentInformation = '"documents":[';

        // search for Files first - if none are found - then search for Attachments
        for (ContentVersion oContVer: listContVer) {
            // only grab the latest attachment - only one attachment will be sent do DocuSign
            // Keep coding for multiple attachments in case we need to add more in the future 
            if (intCounter == 0) {
                // get the quote that matches this content version record
                idContProposal = mapContProp.get(oContVer.ContentDocumentID);

                if (idContProposal == oQuote.Id) {
                    system.debug(logginglevel.INFO, 'DocuSign ContVer id: ' + oContVer.id + ' Prop id: ' + oContVer.ContentDocumentId +
                        ' Title: ' + oContVer.title + ' Cont size: ' + oContVer.ContentSize + ' file Ext: ' + oContVer.FileExtension);
                    bFileFound = true;
                    intCounter = intCounter + 1;

                    intAttachmentSize = intAttachmentSize + oContVer.ContentSize;
                    if (intAttachmentSize > 5000000) {
                        mapDocumentInfo.put('Error', 'True');
                        break;
                    }
                    sDocumentNames = sDocumentNames + '"' + oContVer.Title + '.' + oContVer.FileExtension + '"';
                    //String sFileExtension = oContVer.FileExtension;
                    sAttachmentInformation = sAttachmentInformation + '{"documentId":"' + intCounter.format() +
                        '", "name":"' + oContVer.Title + '", "FileExtension":"' + oContVer.FileExtension +
                        '", "documentBase64":"' + EncodingUtil.base64Encode(oContVer.VersionData) + '"}';

                    // Set attachment information to insert into the envelope table
                    sDocumentDetails = sDocumentDetails + '{"siblingsId":null,"selected":true,"relationship":"Primary","parentStatus":null,"parentNumber":null,"parentName":null,"parentId":"' +
                        oQuote.Id + '","objectIndex":0,"isSibling":false,"isParent":false,"isChild":false,"documentAssociationType":"Primary","canMoveUp":false,"canMoveDown":true,"attachment":{"attributes":{"type":"Attachment","url":"/services/data/v39.0/sobjects/Attachment/' +
                        oContVer.Id + '"},"Id":"' + oContVer.Id + '","Name":"' + oContVer.Title + '.' + oContVer.FileExtension + '"}}';

                    mapDocumentInfo.put('Error', 'false');
                }
            } else {
                break;
            }
        }
        // search through attachments only if a file was not found
        if (bFileFound == false) {
            for (Attachment oAttachment: listAttachments) {
                // only grab the latest attachment - only one attachment will be sent do DocuSign
                // Keep coding for multiple attachments in case we need to add more in the future 
                if (intCounter == 0) {
                    if (oAttachment.ParentId == oQuote.Id) {
                        intCounter = intCounter + 1;

                        intAttachmentSize = intAttachmentSize + oAttachment.BodyLength;
                        if (intAttachmentSize > 5000000) {
                            mapDocumentInfo.put('Error', 'True');
                            break;
                        }
                        //if(intCounter > 1) {
                        //    sAttachmentInformation = sAttachmentInformation + ',';
                        //    sDocumentNames = sDocumentNames + ',';
                        //    sDocumentDetails = sDocumentDetails + ',';
                        //}
                        sDocumentNames = sDocumentNames + '"' + oAttachment.Name + '"';
                        sTemp = oAttachment.Name;
                        List<String> listFiles = (sTemp.split('\\.'));
                        String sFileExtension = listFiles[1];
                        sAttachmentInformation = sAttachmentInformation + '{"documentId":"' + intCounter.format() +
                            '", "name":"' + oAttachment.Name + '", "FileExtension":"' + sFileExtension +
                            '", "documentBase64":"' + EncodingUtil.base64Encode(oAttachment.Body) + '"}';

                        // Set attachment information to insert into the envelope table
                        sDocumentDetails = sDocumentDetails + '{"siblingsId":null,"selected":true,"relationship":"Primary","parentStatus":null,"parentNumber":null,"parentName":null,"parentId":"' +
                            oQuote.Id + '","objectIndex":0,"isSibling":false,"isParent":false,"isChild":false,"documentAssociationType":"Primary","canMoveUp":false,"canMoveDown":true,"attachment":{"attributes":{"type":"Attachment","url":"/services/data/v39.0/sobjects/Attachment/' +
                            oAttachment.Id + '"},"Id":"' + oAttachment.Id + '","Name":"' + oAttachment.Name + '"}}';

                        mapDocumentInfo.put('Error', 'false');
                    }
                } else {
                    break;
                } // out of if counter = 0
            } // out of for loop
        } // out of file not found so search attachments

        sAttachmentInformation = sAttachmentInformation + ']';
        sDocumentNames = '[' + sDocumentNames + ']';
        sDocumentDetails = '[' + sDocumentDetails + ']';
        system.debug(logginglevel.INFO, '***sDocumentNames ::' + sDocumentNames);
        mapDocumentInfo.put('Attachment', sAttachmentInformation);
        mapDocumentInfo.put('DocumentName', sDocumentNames);
        mapDocumentInfo.put('DocumentDetails', sDocumentDetails);

        return mapDocumentInfo;
    } // end of buildDocumentInformationRequest() method


    /** 
	* @description : Returns Signer Information parameter for Docusign request
	* @param oQuote : Quote record
	* @return string : values for the signer field
	*/     
    public static String buildSignerInformationRequest(Apttus_Proposal__Proposal__c oQuote) {
        String strContactName;
        String sSignerInformation;
        // DLT-2689 - add a carbon copy recipient so we can create a read only URL
        strContactName = oQuote.APTS_Order_Confirmation_Contact_Name__c.replace('"', '\\"');
        sSignerInformation = '"recipients":{"signers":[{"name":"' + strContactName +
            '","email":"' + oQuote.APTS_Order_Confirmation_Contact_Email__c +
            '","recipientId":"1","routingOrder":"1","clientUserId":"' + oQuote.APTS_Order_Confirmation_Contact__c + '"' +
            ',"tabs": { "signHereTabs":[{"xPostion":"10","yPosition":"10","documentId":"1","pageNumber":"1","optional":"true"}]}' + '}],' +
            '"carbonCopies":[{"name":"' + oDocuSignAccount.Apttus_DocuApi__DocuSignUserName__c +
            '","email":"' + oDocuSignAccount.Apttus_DocuApi__DocuSignEmailAddress__c +
            '","recipientId":"2","routingOrder":"2"}]}';

        return sSignerInformation;
    } // end of buildSignerInformationRequest() method


    /** 
	* @description : Returns custom field parameter for Docusign Request.
	* @param oQuote : Quote record
	* @return string : values for the custom fields 
	*/      
    public static String buildCustomFieldRequest(Apttus_Proposal__Proposal__c oQuote) {
        String strSAPAccountNumber;
        String sCustomFields;

        // Build custom field information
        // DLT-3583 - Update Docusign report with  SAP Account number, quote number
        if (oQuote.APTS_Sold_To_SAP_Account_Number__c == null) {
            strSAPAccountNumber = 'New Sales';
        } else {
            strSAPAccountNumber = oQuote.APTS_Sold_To_SAP_Account_Number__c;
        }

        sCustomFields = '"customFields": {"textCustomFields":[{' + '"name":"Renewal Proposal",' + '"required":"false",' +
            '"show":"true",' + '"value":"' + oQuote.Name + '"},' + '{"name":"Account",' + '"required":"false",' +
            '"show":"true",' + '"value":"' + strSAPAccountNumber + '"}]}';

        return sCustomFields;
    } // end of buildCustomFIeldRequest() method


    // DLT-12186
    /** 
	* @description : setup response for POST request
	* @param endPoint : request end point
	* @param authentication : credenitals
	* @param body : body for the request
	* @return HttpResponse : http response 
	*/      
    public static HttpResponse httpPostRequest(String endPoint, String authentication, String body) {
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();
        Http http = new Http();

        request.setEndpoint(endPoint);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-DocuSign-Authentication', authentication);
        request.setMethod('POST');
        request.setBody(body);

        // send the request
        response = http.send(request);
        return response;

    } // end httpPostRequest() method


    // DLT-12186
    /** 
	* @description : setup response for GET request
	* @param endPoint : request end point
	* @param authentication : credenitals
	* @return HttpResponse : http response 
	*/    
    public static HttpResponse httpGetRequest(String endPoint, String authentication) {
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();
        Http http = new Http();

        request.setEndpoint(endPoint);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-DocuSign-Authentication', authentication);
        request.setMethod('GET');

        // send request
        response = http.send(request);
        return response;

    } // end httpGetRequest() method


    /** 
	* @description : Internal class
	*/
    public class DigitalDocuSignEnvelopeCreationException extends Exception {}


    /** 
	* @description : finish method
	* @param info : Batchable context date
	*/
    public void finish(Database.BatchableContext info) {

        List<Product_Account_Detail__c > digitalSubscriptionsList = [
            SELECT AccountSSD__c, Digital_Firm__c, Renewal_Date__c, sub_Campaign_Code__c, Campaign_Code__c, Quantity__c,
            Actual_New_Service__c, Actual_New_Subscription_Product__c, Current_Subscription__c, Premium_New_Subscription__c,
            ZP_Cust_Number__c, Type__c, Bypass_Automation__c, Opportunity__c, SAP_Contact_Id__c, Hard_Bounce__c
            FROM Product_Account_Detail__c
            WHERE Campaign_Code__c != null AND Renewal_Date__c > Today AND Bypass_Automation__c = false
        ];

        updateDigitalQuoteAutomationCycle(digitalSubscriptionsList);
        updateDSBypassAutomationFlag(digitalSubscriptionsList);

        // DLT- 18904 Starts
        List<Digital_Settings__c > ds = [Select Id, Batch_Size__c, Batch_Id__c, Name, Class__c, Segment__c, Completion__c, Data_Status__c, End_Time__c, Job_Status__c, Start_Time__c from Digital_Settings__c where Data_Status__c = 'Post-CohortsJob'
            and Job_Status__c = 'Started'
            and RecordTypeId =: Schema.Sobjecttype.Digital_Settings__c.getRecordTypeInfosByName().get('Cohorts').getRecordTypeId() and CreatedById =:Userinfo.getUserId()
        ];
        if (!ds.isEmpty()) {
            Database.executeBatch(new Digital_Cohort_SSDCheck(ds[0]), Integer.valueOf(ds[0].Batch_Size__c));
        }
         // DLT- 18904 Ends
    }


	/** 
	* @description : Calls the DCQuote_Automation_Update class to update the Digital Quote Automation Cycle records
	* @param digitalSubscriptionsList : list of Digital Subscriptions
	*/     
    public void updateDigitalQuoteAutomationCycle(List<Product_Account_Detail__c > digitalSubscriptionsList) {
        // DLT-16286 starts
        String subcamp;

        for (Product_Account_Detail__c newprd: digitalSubscriptionsList) {
            if (newprd.Current_Subscription__c != null) {

                if (newprd.sub_Campaign_Code__c != null) {
                    subcamp = (newprd.sub_Campaign_Code__c).right(7);
                    subcamps.add(subcamp.toUpperCase());
                }
            }
        }
        system.debug(logginglevel.INFO, '***subcamps::' + subcamps);

        DCQuote_Automation_Update.AutorecordUpdateacctbased(subcamps); // DLT-16286

    } //end of updateDigitalQuoteAutomationCycle() method


	/** 
	* @description : Updates the Bypass Automation flag for all digital subscription records associated with this run
	* @param digitalSubscriptionsList : list of Digital Subscriptions
	*/    
    public void updateDSBypassAutomationFlag(List<Product_Account_Detail__c > digitalSubscriptionsList) {
        Set<id> ssdIdWithGeneratedProposals = new Set<id> (); // Added DLT-17520

        //Stores the SSD of all proposals picked up by the batch class via 'quoteList' variable
        for (Apttus_Proposal__Proposal__c oQuote: quoteList) {
            ssdIdWithGeneratedProposals.add(oQuote.Apttus_Proposal__Opportunity__r.Source_System_Detail__c); // DLT-17520();
        }
        system.debug(logginglevel.INFO, 'ssdIdWithGeneratedProposals-->' + ssdIdWithGeneratedProposals);

        Set<Id> ssdIDToBypassSet = new Set<Id> ();

        //Select all opportunities and related non-Presented proposals based on the set of SSDs
        for (Opportunity opp: [
                SELECT Id, Source_System_Detail__c,
                (SELECT Id FROM Apttus_Proposal__R00N70000001yUfDEAU__r WHERE Apttus_Proposal__Approval_Stage__c != 'Presented')
                FROM Opportunity where Source_System_Detail__c
                IN: ssdIdWithGeneratedProposals
            ]) {

            //If no proposals were picked up along with the opportunity, logic assumes proposals are in 'Presented' stage
            //Updated in DLT-19383
            if (opp.Apttus_Proposal__R00N70000001yUfDEAU__r == null || opp.Apttus_Proposal__R00N70000001yUfDEAU__r.size() == 0) {
                ssdIDToBypassSet.add(opp.Source_System_Detail__c);
            }
        }
        system.debug(logginglevel.INFO, 'ssdIdWithGeneratedProposals-->' + ssdIdWithGeneratedProposals);

        //Iterates over the list of digital subscription and sets the Bypass Automation flag to true
        List<Product_Account_Detail__c > digitalSubscriptionUpdateList = new List<Product_Account_Detail__c > ();
        for (Product_Account_Detail__c ds: digitalSubscriptionsList) {
            if (ssdIDToBypassSet.contains(ds.AccountSSD__c) && ds.Bypass_Automation__c == false) {
                ds.Bypass_Automation__c = true;
                digitalSubscriptionUpdateList.add(ds);
            }
        }
        system.debug(logginglevel.INFO, 'digitalSubscriptionUpdateList-->' + digitalSubscriptionUpdateList);

        //Updates the digital subscription
        if (!digitalSubscriptionUpdateList.isEmpty()) {
            update digitalSubscriptionUpdateList;
        }
    } //end of updateDSBypassAutomationFlag() method

}