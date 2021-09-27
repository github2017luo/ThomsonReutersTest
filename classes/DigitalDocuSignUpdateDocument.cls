/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-05-14   Benjamin Her            DLT-9401 - Update parameters when creating envelope to set Envelope Expiration to Opportunity's Renewal Date
 * 2018-05-22   Brenda Shields          DLT-10048 - Added coding to Opp Stage name based on prior value 
 * 2018-06-11   Brenda Shields          DLT-9762 - GLI Updates 
 * 2018-12-26   Bishanka Dassarma       DLT-14156 - Fix Code Scan Security Issues
 * 2019-02-15   Navleen                 DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 * 2021-06-28   Brenda Shields          DLT-21973 - Fix to add field to selection query for DLT-21574 
 * =============================================================================
 */
/**
 * @description methods used to create envelope for nse
 */
global without sharing class DigitalDocuSignUpdateDocument {

	//Default docusign environment info
	private static final string TOKEN_URL = System.label.Digital_TOKEN_URL;
	private static final string USERNAME = System.label.Digital_UserName;
	private static final string PASSWORD = System.label.Digital_Password;
	private static final string INTEGRATIONKEY = System.label.Digital_Integration_Key;

	public static Final String HTTP_METHOD_POST = 'POST';
	public static Final String CONTENT_TYPE = 'Content-Type';
	public static Final String SOAP_ACTION = 'SOAPAction';
	public static Final String SOAP_ACTION_LOGIN = 'login';
	public static Final String ENDPOINT_SUFFIX = '/services/Soap/u/40.0';
	public static Final String CONTENT_TYPE_XML = 'text/xml;charset=UTF-8';
	public static Final String SERVER_URL = 'serverUrl';
	public static Final String SESSION_ID = 'sessionId';
	public static Final String URN_PARTNER_SOAP = 'urn:partner.soap.sforce.com';
	public static Final String AUTHORIZATION = 'Authorization';
	
	//global DigitalDocuSignUpdateDocument() {}
	@RemoteAction
   /**
    * @description : "Generate" process for attaching the order form to the proposal
    * @param quoteId : id for the quote to process
    */
	public static void updateEnvelope(Id quoteId) {
		generatePDFDoc(quoteId);
	}


	// this is used in the CX Digital auotmation process as well as when Proposals are updated from the landing page
   /** 
    * @description : Generate a new PDF attachment of the order form to attach to the Proposal
    * @param quoteId : Id for the quote to process
    */
	public static void generatePDFDoc(Id quoteId) {
		//String envelopId = '';
		try {
			// select template to generate the attachment
			list<Apttus__APTS_Template__c > templateList = new list<Apttus__APTS_Template__c > ();
			if (Schema.sObjectType.Apttus__APTS_Template__c.isAccessible()) {
				templateList = [SELECT Id FROM Apttus__APTS_Template__c WHERE Name =: System.Label.Digital_OF
					AND
					Apttus__IsActive__c = TRUE LIMIT 1
				];
			}
			if ((templateList != null) && (templateList.size() > 0) && (quoteId != Null)) {
				Id templateId = templateList[0].Id;
				String accessLevel = 'Read only';
				String docFormat = 'PDF';
				System.debug(logginglevel.INFO, 'System.Url.getSalesforceBaseUrl().toExternalForm()  ' + System.Url.getSalesforceBaseUrl().toExternalForm());
				String apiServerURL; // = System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/14.0/' + UserInfo.getOrganizationId();
				String sessionId;
				Map<String, String> sessionValueMap = new Map<String, String> ();
				// use boolean for unit testing to allow the Test.isRunningTest() to be configurable
				if (!DCTestData.isRunningTest()) {
					sessionValueMap = getSession();
					sessionId = sessionValueMap.get('SESSION_ID');
					apiServerURL = sessionValueMap.get('SERVER_URL');
				}
				apiServerURL = apiServerURL != null ? apiServerURL : getGlobalSettingServerURL();
				sessionId = sessionId != null ? sessionId : UserInfo.getSessionId();

				// use boolean for unit testing to allow the Test.isRunningTest() to be configurable
				if (!DCTestData.isRunningTest()) {
					String generatedDocId = Apttus_Proposal.MergeWebService.generateDoc(templateId, quoteId, accessLevel, docFormat, sessionId, apiServerURL);
					system.debug(logginglevel.INFO, 'Generated Docs: ' + generatedDocId);
				}
			}
		} catch (Exception e) {
			DCUtils.trackLog(e, 'DigitalDocuSignUpdateDocument', 'generatePDFDoc');
		}
	}

	private static String getGlobalSettingServerURL() {
		String apiServerURL;
		List<DC_Global_Settings__mdt > globalSettingList = new List<DC_Global_Settings__mdt > ();
		if (Schema.sObjectType.DC_Global_Settings__mdt.isAccessible()) {
			globalSettingList = [SELECT Login_Domain__c FROM DC_Global_Settings__mdt LIMIT 1];
		}
		if ((globalSettingList != null) && (globalSettingList.size() > 0)) {
			apiServerURL = globalSettingList[0].Login_Domain__c + '/services/Soap/u/14.0/' + UserInfo.getOrganizationId();
		}
		return apiServerURL;
	}

	@RemoteAction
   /** 
    * @description : Send the proposal attachment to DocuSign for signature/reference
    * @param cQuoteId : Id for the quote to process
    * @return message
    */	
	public static DCMessage envelopeCreation(Id cQuoteId) {
		try {
			// GLI Changes -- 
			// map Apttus_Proposal__Account__r.Digital_Firm__c to Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c
			// map Apttus_Proposal__Opportunity__r.SAP_Account_Number__c to APTS_Sold_To_SAP_Account_Number__c
			// DLT-21586 add business unit field to select
			// DLT-21973 add digital quote failure reason field to the select 
			List<Apttus_Proposal__Proposal__c > quoteList = new List<Apttus_Proposal__Proposal__c > ();
			if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
				quoteList = [Select id, name, Apttus_Proposal__Opportunity__c,
					Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c,
					Apttus_Proposal__Opportunity__r.SAP_Account_Number__c,
					Apttus_Proposal__Opportunity__r.Owner.Email, Apttus_Proposal__Opportunity__r.Owner.Name,
					Apttus_Proposal__Opportunity__r.Digital_PreviousStageName__c,
					APTS_Order_Confirmation_Contact__c, APTS_Order_Confirmation_Contact_Name__c,
					APTS_Order_Confirmation_Contact_Email__c, APTS_Renewal__c,
					Apttus_Proposal__Primary__c, Digital_Quote_Type__c, Digital_Quote_Failure_Reason__c,
					APTS_Sold_To_SAP_Account_Number__c, APTS_Approval_Segment__c, APTS_Proposal_Business_Unit__c,
					Apttus_Proposal__Opportunity__r.Renewal_Date__c, CreatedDate, Is_Digital_New_Sales__c
					FROM Apttus_Proposal__Proposal__c WHERE id =: cQuoteId
				];
			}
			DigitalDocuSignEnvelopeCreation.CreateEnvelopes(quoteList);
		} catch (Exception e) {
			DCUtils.trackLog(e, 'DigitalDocuSignUpdateDocument', 'envelopeCreation');
			DCMessage msg = new DCMessage('High', 404, e.getMessage());
			return msg;
		}
		DCMessage msg = new DCMessage('Success', 200, 'Envelope successfully created.');
		return msg;
	}


   /** 
    * @description : get session Id and URL
    * @return map of session id and url
    */		
	public static Map<String, String> getSession() {
		Map<String, String> sessionValueMap = new Map<String, String> ();
		sessionValueMap.put('SESSION_ID', null);
		sessionValueMap.put('SERVER_URL', null);
		String sessionId;
		List<DC_Global_Settings__mdt > globalSettingList = [SELECT Login_Domain__c, Username__c, Password__c,
			Security_Token__c, Request_Timeout__c,
			Use_API_User__c
			FROM DC_Global_Settings__mdt LIMIT 1
		];

		if ((globalSettingList != null) && (globalSettingList.size() > 0)) {
			DC_Global_Settings__mdt globalSetting = globalSettingList[0];
			if (globalSettingList[0].Use_API_User__c == true) {
				String securityToken = globalSetting.Security_Token__c != null ? globalSetting.Security_Token__c : '';
				List<String> args = new String[] {
					globalSetting.Username__c, globalSetting.Password__c + securityToken
				};
				String requestBody = String.format(Label.DC_LOGIN_REQUEST_BODY, args);

				//----------------------------------------------------------------------
				// Login via SOAP/XML web service api to establish session
				//----------------------------------------------------------------------
				HttpRequest request = new HttpRequest();
				request.setEndpoint(globalSetting.Login_Domain__c + ENDPOINT_SUFFIX);
				request.setMethod(HTTP_METHOD_POST);
				request.setHeader(CONTENT_TYPE, CONTENT_TYPE_XML);
				request.setHeader(SOAP_ACTION, SOAP_ACTION_LOGIN);
				request.setBody(requestBody);
				request.setTimeout(20000);
				HttpResponse response = (new Http()).send(request);
				System.debug(logginglevel.INFO, '<Response> ' + response.getBody());
				Dom.XmlNode resultElmt = response.getBodyDocument().getRootElement()
					.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
					.getChildElement('loginResponse', URN_PARTNER_SOAP)
					.getChildElement('result', URN_PARTNER_SOAP);
				//----------------------------------------------------------------------
				// Grab session id and server url (ie the session)
				//----------------------------------------------------------------------
				String serverURL = resultElmt.getChildElement(SERVER_URL, URN_PARTNER_SOAP).getText(); //.split('/services')[0];
				sessionId = resultElmt.getChildElement(SESSION_ID, URN_PARTNER_SOAP).getText();
				sessionValueMap.put('SESSION_ID', sessionId);
				sessionValueMap.put('SERVER_URL', serverURL);
			}
		}
		return sessionValueMap;
	}
}