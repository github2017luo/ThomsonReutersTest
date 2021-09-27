/**
    @description Docusign envelope creation job for DCP
    CHANGE HISTORY
    ==========================================================================================
    Date                Developer                   Description
    2021-05-19          Benjamin Her                DCP-1548 Initial Creation
    2021-09-06          Vinit Nagar					DCP-2823
 */
public without sharing class DCPCreateDocusignEnvelope{

    /**
        @description Begins docusign job
        @param proposalIds List of proposal ids to be processed
        @return Returns a map of proposal ids to Docusign envelope id
     */
    public static Map<id,String> createDocusignEnvelope(List<id> proposalIds){
        List<Apttus_Proposal__Proposal__c> proposalList = 
            [SELECT Id,
             Name,
             Apttus_Proposal__Opportunity__c,
             Apttus_Proposal__Opportunity__r.SAP_Account_Number__c,
             Apttus_Proposal__Opportunity__r.Source_System_Detail__r.Digital_Firm__c,
             Apttus_Proposal__Opportunity__r.Owner.Email,
             Apttus_Proposal__Opportunity__r.Owner.Name,
             Apttus_Proposal__Opportunity__r.Digital_PreviousStageName__c,
             APTS_Order_Confirmation_Contact__c,
             APTS_Order_Confirmation_Contact__r.Email,
             APTS_Order_Confirmation_Contact__r.Name,
             APTS_Order_Confirmation_Contact_Name__c,
             APTS_Order_Confirmation_Contact_Email__c,
             Apttus_Proposal__Primary__c,
             Digital_Quote_Type__c,
             APTS_Renewal__c,
             APTS_Sold_To_SAP_Account_Number__c, 
             APTS_Proposal_Business_Unit__c,
             APTS_Approval_Segment__c,
             Apttus_Proposal__Opportunity__r.Renewal_Date__c,
             CreatedDate,
             Is_Digital_New_Sales__c,
             Owner.Email
            FROM Apttus_Proposal__Proposal__c
            WHERE id IN: proposalIds
            AND Apttus_Proposal__Approval_Stage__c = 'Generated'
            WITH SECURITY_ENFORCED];
        
        if(proposalList == null || proposalList.size() == 0){
            throw new DCCustomException('No Generated proposals found for provided ids');
        }
        try{
            return createEnvelope(proposalList);
        }
        catch(Exception ex){
            throw new DCCustomException(ex.getStackTraceString());
        }
    }

    private static Map<id,String> createEnvelope(List<Apttus_Proposal__Proposal__c> proposalList){

        String docusignEnvelopeUrl;
        Map<id,ContentDocumentLink> proposalToDocumentMap = new Map<id,ContentDocumentLink>();
        Map<id,String> proposalToRequestMap = new Map<id,String>();
        Map<id,String> proposalToEnvelopeId = new Map<id,String>();
        
        
        for(Apttus_Proposal__Proposal__c temp : proposalList){
        	DCPDocusignHelper.getDocusignConnectionInfo(temp.APTS_Approval_Segment__c);
        }
        
        docusignEnvelopeUrl = DCPDocusignHelper.getDocusignAccountEndpoint() + '/envelopes';
        proposalToDocumentMap = getProposalAttachment(proposalList);
        proposalToRequestMap = buildRequestBody(proposalList,proposalToDocumentMap);
        proposalToEnvelopeId = callDocusignEnvelopeService(proposalList,proposalToRequestMap,docusignEnvelopeUrl);
        DCPCreateDocusignEnvelopeHelper.createSalesforceDocusignRecord(proposalToDocumentMap,proposalToRequestMap,proposalToEnvelopeId);
        DCPCreateDocusignEnvelopeHelper.updateProposal(proposalList,proposalToEnvelopeId);
        DCPCreateDocusignEnvelopeHelper.updateOpportunity(proposalList,proposalToEnvelopeId);

        return proposalToEnvelopeId;
    }

    //Iterates over all proposals and if request exist, call method to create Docusign envelope
    private static Map<id,String> callDocusignEnvelopeService(List<Apttus_Proposal__Proposal__c> proposalList,Map<id,String> proposalToRequestMap,String docusignEnvelopeUrl){

        Map<id,String> proposalToEnvelopeId = new Map<id,String>();

        for(Apttus_Proposal__Proposal__c proposal : proposalList){
            if(proposalToRequestMap.containsKey(proposal.id)){
                String requestBody = proposalToRequestMap.get(proposal.id);
                String envelopeId = callDocusignEnvelopeServiceHelper(proposal,docusignEnvelopeUrl,requestBody);
                proposalToEnvelopeId.put(proposal.id,envelopeId);
            }
        }

        return proposalToEnvelopeId;
    }

    //Calls Docusign service to create envelope
    private static String callDocusignEnvelopeServiceHelper(Apttus_Proposal__Proposal__c proposal,String docusignEnvelopeUrl,String requestBody){
        System.debug(LoggingLevel.DEBUG,'REQUEST::::'+requestBody);
        String authenticationHeader =                 
            '<DocuSignCredentials>' +
            '<Username>' + DCPDocusignHelper.docusignConnectUser + '</Username>' +
            '<Password>' + DCPDocusignHelper.docusignConnectPassword + '</Password>' +
            '<IntegratorKey>' + DCPDocusignHelper.docusignConnectIntegrationKey + '</IntegratorKey>' +
            '<SendOnBehalfOf>' + proposal.Owner.Email + '</SendOnBehalfOf>' +
            '</DocuSignCredentials>';

        HttpResponse docuSignResponse;
        docuSignResponse = DCPDocusignHelper.httpPostRequest(docusignEnvelopeUrl, authenticationHeader, requestBody);

        //401 code - Retry using default authentication header
        if(docuSignResponse.getStatusCode() == 401 || docuSignResponse.getStatusCode() == 400){
            docuSignResponse = DCPDocusignHelper.httpPostRequest(docusignEnvelopeUrl, DCPDocusignHelper.defaultAuthenticationHeader, requestBody);
        }

        //On success, if envelopeId is found in response body, return it.
        if(docuSignResponse.getStatusCode() == 200 || docuSignResponse.getStatusCode() == 201){
            Map<String,String> responseBody = (Map<String,String>)JSON.deserialize(docuSignResponse.getBody(),Map<String,String>.class);
            if(responseBody.containsKey('envelopeId') && String.isNotBlank(responseBody.get('envelopeId'))){
                return responseBody.get('envelopeId');
            }
        }

        //Return emptry string
        return '';
    }


    //Returns a map of a proposal's id to its docusign request
    private static Map<id, String> buildRequestBody(List<Apttus_Proposal__Proposal__c> proposalList,Map<id,ContentDocumentLink> proposalToDocumentMap){
        Map<id,String> proposalToRequestMap = new Map<id,String>();
        for(Apttus_Proposal__Proposal__c proposal : proposalList){
            String requestBody = buildRequestBodyHelper(proposal,proposalToDocumentMap);
            proposalToRequestMap.put(proposal.id,requestBody);
        }

        return proposalToRequestMap;
    }
    
    //Returns a string of the final JSON request body for a proposal
    private static string buildRequestBodyHelper(Apttus_Proposal__Proposal__c proposal,Map<id,ContentDocumentLink> proposalToDocumentMap){
        String finalRequest;
        String customFieldRequest = getCustomFieldRequestBody(proposal);
        String recipientRequest = getRecipientRequestBody(proposal);
        String documentRequest = getDocumentRequestBody(proposal,proposalToDocumentMap);
        Integer intExpireDate;

        if (proposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c == null) {
            intExpireDate = 140;
        }else{
            intExpireDate = date.today().daysBetween(proposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c);
        }

        finalRequest = '{"status":"sent", "emailSubject":"Request for eSignatures", "notification":{"useAccountDefaults":false, ' +
            '"reminders":null, "expirations":{"expireEnabled":true,"expireAfter":' + intExpireDate + ',"expireWarn":0}}, ' +
            recipientRequest + ', ' + customFieldRequest + ',' + documentRequest + '}';

        return finalRequest;
    }

    //Returns JSON request for Docusign custom fields
    private static string getCustomFieldRequestBody(Apttus_Proposal__Proposal__c proposal){
        String customFieldRequest;
        String strSAPAccountNumber = proposal.APTS_Sold_To_SAP_Account_Number__c;

        customFieldRequest = '"customFields": {"textCustomFields":[{' + '"name":"Digital Proposal",' + '"required":"false",' +
            '"show":"true",' + '"value":"' + proposal.Name + '"},' + '{"name":"Account",' + '"required":"false",' +
            '"show":"true",' + '"value":"' + strSAPAccountNumber + '"}]}';

        return customFieldRequest;
    }

    //Returns JSON request for Docusign recipients
    private static string getRecipientRequestBody(Apttus_Proposal__Proposal__c proposal){
        String recipientRequest;
        String strContactName;
        
        strContactName = proposal.APTS_Order_Confirmation_Contact__r.Name.replace('"', '\\"');
        recipientRequest = '"recipients":{"signers":[{"name":"' + strContactName +
            '","email":"' + proposal.APTS_Order_Confirmation_Contact__r.Email +
            '","recipientId":"1","routingOrder":"1","clientUserId":"' + proposal.APTS_Order_Confirmation_Contact__c + '"' +
            ',"tabs": { "signHereTabs":[{"xPostion":"10","yPosition":"10","documentId":"1","pageNumber":"1","optional":"true"}]}' + '}],' +
            '"carbonCopies":[{"name":"' + DCPDocusignHelper.oDocuSignAccount.Apttus_DocuApi__DocuSignUserName__c +
            '","email":"' + DCPDocusignHelper.oDocuSignAccount.Apttus_DocuApi__DocuSignEmailAddress__c +
            '","recipientId":"2","routingOrder":"2"}]}';

        return recipientRequest;
    }

    //Returns JSON request for Docusign document
    private static string getDocumentRequestBody(Apttus_Proposal__Proposal__c proposal,Map<id,ContentDocumentLink> proposalToDocumentMap){
        String documentRequest = '';
        if(proposalToDocumentMap.containsKey(proposal.id)){
            ContentDocumentLink document = proposalToDocumentMap.get(proposal.id);
            documentRequest = '"documents":[{"documentId":"1' +
                            '", "name":"' + document.ContentDocument.LatestPublishedVersion.Title + 
                            '", "FileExtension":"' + document.ContentDocument.LatestPublishedVersion.FileExtension +
                            '", "documentBase64":"' + EncodingUtil.base64Encode(document.ContentDocument.LatestPublishedVersion.VersionData) + '"}]';
        }
        return documentRequest;
    }
    
    //Gets a map of a proposal's id to the most recent order form for that proposal.
    private static Map<id,ContentDocumentLink> getProposalAttachment(List<Apttus_Proposal__Proposal__c> proposalList){
        List<id> proposalIds = new List<id>();
        Map<id,ContentDocumentLink> proposalToDocumentMap = new Map<id,ContentDocumentLink>();

        for(Apttus_Proposal__Proposal__c proposal : proposalList){
            proposalIds.add(proposal.id);
        }

        for(ContentDocumentLink document : 
            [SELECT LinkedEntityId,ContentDocumentId, ContentDocument.id,ContentDocument.LastModifiedDate,
                ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,
                ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.ContentSize,
                ContentDocument.LatestPublishedVersion.FileExtension 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId IN: proposalIds
            AND ContentDocument.LatestPublishedVersion.Title LIKE '%Order Form%'
            WITH SECURITY_ENFORCED
            ORDER BY ContentDocument.LastModifiedDate DESC]){
            
            //If map doesn't contain the proposal id (LinkedEntityId) of the current iteration's document
            //OR it does contain the propsal id of the current iteration's document BUT the current iteration's document is modified more recently than previous stored document
            //THEN store the most recent document in the map instead
            if(!proposalToDocumentMap.containsKey(document.LinkedEntityId)
                || (proposalToDocumentMap.containsKey(document.LinkedEntityId)
                    && document.ContentDocument.LastModifiedDate > proposalToDocumentMap.get(document.LinkedEntityId).ContentDocument.LastModifiedDate)){
                
                proposalToDocumentMap.put(document.LinkedEntityId,document);
            }
        }

        return proposalToDocumentMap;
    }
}