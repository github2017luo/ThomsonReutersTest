/**
    @description Docusign envelope view class for DCP
    CHANGE HISTORY
    ==========================================================================================
    Date                Developer                   Description
    2021-05-19          Benjamin Her                DCP-1548 Initial creation
    2021-09-07          Vinit Nagar					DCP-2823
 */
public without sharing class DCPViewDocusignEnvelope{
    
    /**
        @description Begins docusign job
        @param docusignEnvelopeId Docusign envelope id to be view
        @return Returns the Docusign URL to view the envelope documents
     */
    public static String getEnvelopeView(String docusignEnvelopeId){
        Apttus_DocuApi__DocuSignEnvelope__c envelope = 
            [SELECT id,Apttus_QPDSign__QuoteProposal__r.Owner.Email, Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact__c,
            Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact__r.Email,
            Apttus_QPDSign__QuoteProposal__r.APTS_Approval_Segment__c
            FROM Apttus_DocuApi__DocuSignEnvelope__c 
            WHERE Apttus_DocuApi__EnvelopeId__c =: docusignEnvelopeId 
            WITH SECURITY_ENFORCED LIMIT 1];

        DCPDocusignHelper.getDocusignConnectionInfo(envelope.Apttus_QPDSign__QuoteProposal__r.APTS_Approval_Segment__c);
        
        String envelopeViewEndpoint = DCPDocusignHelper.getDocusignAccountEndpoint()  + '/envelopes/' + docusignEnvelopeId + '/views/recipient';
        String envelopeViewUrl = callDocusignGetViewService(envelopeViewEndpoint,envelope);

        return envelopeViewUrl;
    }

    //Builds the request and calls Docusing's view recipient service to create URL.
    private static String callDocusignGetViewService(String envelopeViewEndpoint,Apttus_DocuApi__DocuSignEnvelope__c envelope){
        String authenticationHeader =                 
            '<DocuSignCredentials>' +
            '<Username>' + DCPDocusignHelper.docusignConnectUser + '</Username>' +
            '<Password>' + DCPDocusignHelper.docusignConnectPassword + '</Password>' +
            '<IntegratorKey>' + DCPDocusignHelper.docusignConnectIntegrationKey + '</IntegratorKey>' +
            '<SendOnBehalfOf>' + envelope.Apttus_QPDSign__QuoteProposal__r.Owner.Email + '</SendOnBehalfOf>' +
            '</DocuSignCredentials>';
            
        Map<String,String> requestParameter = new Map<String,String>();
        requestParameter.put('authenticationMethod','None');
        requestParameter.put('email',DCPDocusignHelper.oDocuSignAccount.Apttus_DocuApi__DocuSignEmailAddress__c);
        requestParameter.put('userName',DCPDocusignHelper.oDocuSignAccount.Apttus_DocuApi__DocuSignUserName__c);
        requestParameter.put('returnUrl','https://google.com'); //To be updated to something else later
        
        String requestBody = JSON.serialize(requestParameter);

        HttpResponse docuSignResponse = DCPDocusignHelper.httpPostRequest(envelopeViewEndpoint,authenticationHeader ,requestBody);
        
        //401 code - Retry using default authentication header
        if(docuSignResponse.getStatusCode() == 401 || docuSignResponse.getStatusCode() == 400){
            docuSignResponse = DCPDocusignHelper.httpPostRequest(envelopeViewEndpoint, DCPDocusignHelper.defaultAuthenticationHeader, requestBody);
        }
        
        //On success, store response body into a map and check map for 'url' field, return the field value if it exsit.
        if(docuSignResponse.getStatusCode() == 200 || docuSignResponse.getStatusCode() == 201){
            
            Map<String,String> responseBody = (Map<String,String>)JSON.deserialize(docuSignResponse.getBody(),Map<String,String>.class);
            
            if(responseBody.containsKey('url') && String.isNotBlank(responseBody.get('url'))){
                return responseBody.get('url');
            }
        }
        else{
            throw new DCCustomException(docuSignResponse.getBody());
        }

        //Return empty string
        return '';
    }
}