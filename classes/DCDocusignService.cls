/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-12-19   Navleen Kaur            DLT-14155 : [Tech Story] [Code Scan] - Fix Code Scan Security Issues
 * 2019-01-08   Navleen Kaur            DLT-14349 : [Tech Story] [Code Scan] 
 * 2019-06-06   Navleen Kaur            DLT-16721 : Fix for renewals
 * 2019-06-06   Benjamin Her            DLT-16925 : [Tech Story] [Code Scan] - Fix Code Scan Minor Issues
 * 2021-04-01   Brenda Shields          DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
 *                                                  Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
 * ==================================================================================================================================   
 */
 
/**
 * @description : Creation of envelope and sending the response 
 */	
public without sharing class DCDocusignService {

	/**
	 * @description : Creation of envelope and sending the response 
	 * @param quoteIdList : list of quotes
	 * @return : DocuSign Response
	 */		 
	public static DCDocuSignController.DocuSignResponse envelopeCreation(List<String> quoteIdList) {
		DCDocuSignController.DocuSignResponse response = new DCDocuSignController.DocuSignResponse();
		String currentQuoteId = '';
		try {
			for (String quoteId: quoteIdList) {
				currentQuoteId = quoteId;
				DigitalDocuSignUpdateDocument.envelopeCreation(quoteId);
			}
			response.responseCode = 200;
			response.responseMessage = 'Success';
			return response;
		} catch (Exception ex) {
			DCUtils.trackLog(ex, 'DCDocusignService', 'envelopeCreation');
			response.responseCode = 400;
			response.responseMessage = currentQuoteId + ': ' + ex.getMessage();
			return response;
		}
	}

	/**
	 * @description : Get all deatils from Quote and Digital Firm Defaults 
	 * @param quoteId : quote Id
	 * @return : DocuSign Response
	 */		 
	public static DCDocuSignController.DocuSignResponse envelopeCreation(String quoteId) {
		DCDocuSignController.DocuSignResponse response = new DCDocuSignController.DocuSignResponse();
		try {
			String segment = '';
			DigitalDocuSignUpdateDocument.envelopeCreation(quoteId);
			List<Apttus_Proposal__Proposal__c > proposals = new List<Apttus_Proposal__Proposal__c > ();
			if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
				proposals = [select id, DocuSign_Envelope_ID__c, Name, APTS_Approval_Segment__c, APTS_Proposal_Business_Unit__c, Is_Digital_New_Sales__c, is_Digital_Channel__c 
							from Apttus_Proposal__Proposal__c where id =: quoteId];
			}
			response.envelopeId = proposals[0].DocuSign_Envelope_ID__c;
			// FindLaw is no longer in the approval segment field, we now check on the business unit
			if (proposals[0].APTS_Proposal_Business_Unit__c == 'FindLaw') {
				segment = proposals[0].APTS_Proposal_Business_Unit__c;
			} else {
				segment = proposals[0].APTS_Approval_Segment__c;
			}
			List<Digital_Firm_Defaults__mdt > emailsender = new List<Digital_Firm_Defaults__mdt > ();
			if (Schema.sObjectType.Digital_Firm_Defaults__mdt.isAccessible()) {
				if (proposals[0].Is_Digital_New_Sales__c == True) {
					emailsender = [SELECT Label, DocuSign_Send_on_Behalf_of_Email__c, Opportunity_Owner__c FROM Digital_Firm_Defaults__mdt where Proposal_Approval_Segment__c =: segment and Opportunity_Type__c = 'New Sales'];
				}
				// addedd by Navleen as part of  DLT-16721
				else if (proposals[0].is_Digital_Channel__c == True) {
					emailsender = [SELECT Label, DocuSign_Send_on_Behalf_of_Email__c, Opportunity_Owner__c FROM Digital_Firm_Defaults__mdt where Proposal_Approval_Segment__c =: segment and Opportunity_Type__c = 'Renewal'];
				}
			}
			Digital_OnlineContactsController.onlineContactsExcel(proposals[0].Id, proposals[0].Name);
			response.senderName = emailsender[0].Opportunity_Owner__c;
			response.sendonBehalfofEmail = emailsender[0].DocuSign_Send_on_Behalf_of_Email__c;
			response.responseCode = 200;
			response.responseMessage = 'Success';
			return response;
		} catch (Exception ex) {
			DCUtils.trackLog(ex, 'DCDocusignService', 'envelopeCreation');
			response.responseCode = 400;
			response.responseMessage = ex.getMessage();
			return response;
		}
	}
	
	/**
	 * @description : Generating PDF document by calling method generatePDFDoc
	 * @param quoteIdList : list of quotes
	 * @return : DocuSign Response
	 */	 
	public static DCGenerateDocumentController.DocuSignResponse generatePDFDocByQuoteIds(List<String> quoteIdList) {
		DCGenerateDocumentController.DocuSignResponse response = new DCGenerateDocumentController.DocuSignResponse();
		String currentQuoteId = '';
		try {
			for (String quoteId: quoteIdList) {
				currentQuoteId = quoteId;
				generatePDFDoc(quoteId);
			}
			response.responseCode = 200;
			response.responseMessage = 'Success';
			return response;
		} catch (Exception ex) {
			DCUtils.trackLog(ex, 'DCDocusignService', 'generatePDFDocByQuoteIds');
			response.responseCode = 400;
			response.responseMessage = currentQuoteId + ': ' + ex.getMessage();
			return response;
		}

	}
	
	/**
	 * @description : Get template Id and call webservice for generating document 
	 * @param quoteId : Quote id
	 * @return : string value of URL
	 */
	public static Id generatePDFDoc(Id quoteId) {
		String generatedDocId = '';
		list<Apttus__APTS_Template__c > templateList = new list<Apttus__APTS_Template__c > ();
		try {
			if (Schema.sObjectType.Apttus__APTS_Template__c.isAccessible()) {
				templateList = [SELECT Id FROM Apttus__APTS_Template__c
					WHERE Name =: System.Label.Digital_OF
					AND
					Apttus__IsActive__c = TRUE LIMIT 1
				];
			}

			if ((templateList != null) && (!templateList.isEmpty()) && (quoteId != Null)) {
				Id templateId = templateList[0].Id;
				String accessLevel = 'Read only';
				String docFormat = 'PDF';
				system.debug(logginglevel.INFO, 'System.Url.getSalesforceBaseUrl().toExternalForm()  ' + System.Url.getSalesforceBaseUrl().toExternalForm());
				String apiServerURL = System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/14.0/' + UserInfo.getOrganizationId();
				String sessionId = UserInfo.getSessionId();
				//Map<String, String> sessionValueMap = new Map<String, String>();
				if (apiServerURL == null) {
					apiServerURL = getGlobalSettingServerURL();
				}
				if (sessionId == null) {
					sessionId = UserInfo.getSessionId();
				}

				if (!Test.isRunningTest()) {
					generatedDocId = Apttus_Proposal.MergeWebService.generateDoc(templateId, quoteId, accessLevel, docFormat, sessionId, apiServerURL);
				}
			}

		} catch (Exception ex) {
			DCUtils.trackLog(ex, 'DCDocusignService', 'GeneratePDFDoc');
		}
		system.debug(logginglevel.INFO, 'generatedDocId > ' + generatedDocId);
		return generatedDocId;
	}
	
	/**
	 * @description : Get login domain from DC Global setting for URL  
	 * @return : string value of URL
	 */
	@TestVisible
	private static String getGlobalSettingServerURL() {
		String apiServerURL;
		List<DC_Global_Settings__mdt > globalSettingList = new List<DC_Global_Settings__mdt > ();
		if (Schema.sObjectType.DC_Global_Settings__mdt.isAccessible()) {
			globalSettingList = [SELECT Login_Domain__c FROM DC_Global_Settings__mdt LIMIT 1];
		}
		if ((globalSettingList != null) && (!globalSettingList.isEmpty())) {
			apiServerURL = globalSettingList[0].Login_Domain__c + '/services/Soap/u/14.0/' + UserInfo.getOrganizationId();
		}
		return apiServerURL;
	}
}