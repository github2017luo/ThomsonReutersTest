/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                  Description
 * 2019-05-10   Navleen Kaur          DLT-16389 - Find Law- AEM call to set Correct template for Findlaw to SFDC during Generate Document
 * 17-12-2020   Rahul Natarajan       DLT-21120 - [TECH][SFDC][REN][NSE] Update New OrderForm template for all Renewal and New Sales proposals
 * ==================================================================================================================================   
 */

@RestResource(urlMapping = '/DigitalGenerateDocument/*')
global with sharing class Digital_WS_GenerateDocument {

	@HttpPost
	global Static DigitalResponse doPost(Id quoteId) {
		DigitalResponse dr = new DigitalResponse();
		List<Apttus_Proposal__Proposal__c > prop;
		IGlobalOperationLayer glbOpObj = new GlobalOperationLayer();
		Id docId = null;
		try {
			Map<String,
				Apttus__APTS_Template__c > tempMap = new MAP<String,
				Apttus__APTS_Template__c > ();
			list<string> templateTames = new list<string> {
				System.Label.Digital_OF,
				System.Label.Digital_FOF
			};
			for (Apttus__APTS_Template__c temp: [select id, name from Apttus__APTS_Template__c where Apttus__IsActive__c = TRUE AND name in: templateTames]) {
				tempMap.put(temp.name, temp);
			}
			if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()) {
				prop = [SELECT id, APTS_Proposal_Business_Unit__c FROM Apttus_Proposal__Proposal__c WHERE Id =: quoteId LIMIT 1];
			}
			if ((tempMap != null) && (tempMap.size() > 0) && !prop.isEmpty() && prop[0].APTS_Proposal_Business_Unit__c == 'FindLaw') {
				docId = glbOpObj.generatePDFDocument(tempMap.get(System.Label.Digital_FOF).Id, quoteId, 'Digital_WS_GenerateDocument > doPost');
			} else if ((tempMap != null) && (tempMap.size() > 0) && !prop.isEmpty()) {
				docId = glbOpObj.generatePDFDocument(tempMap.get(System.Label.Digital_OF).Id, quoteId, 'Digital_WS_GenerateDocument > doPost');
			}
			if (docId != Null) {
				dr.Status = 'Success';
				dr.documentId = docId;
			} else {
				dr.Status = 'Failure';
			}
		} catch (Exception e) {
			DCUtils.trackLog(e, 'Digital_WS_GenerateDocument', 'DigitalResponse.doPost');
		}
		return dr;
	}
	global class DigitalResponse {
		global String Status;
		global Id documentId;
	}
}