/**
    @description Docusign envelope completion class for DCP
    CHANGE HISTORY
    ==========================================================================================
    Date                Developer                   Description
    2021-05-27          Benjamin Her                DCP-1548 Initial creation
    2021-09-07          Vinit Nagar					DCP-2823
 */
public without sharing class DCPVoidDocusignEnvelope{
    
    /**
        @description Begins docusign job
        @param docusignEnvelopeId Docusign envelope id to be updated
        @param voidReason Customer reason for declining offer
        @return Returns the job status
     */
    public static String voidEnvelope(String docusignEnvelopeId, String voidReason){
    
        String tempVoidReason = voidReason;
        
        Apttus_DocuApi__DocuSignEnvelope__c envelope = 
            [SELECT id,Apttus_QPDSign__QuoteProposal__r.Owner.Email, Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact__c,
            Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact__r.Email,
            Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact__r.Name,
            Apttus_QPDSign__QuoteProposal__r.APTS_Approval_Segment__c
            FROM Apttus_DocuApi__DocuSignEnvelope__c 
            WHERE Apttus_DocuApi__EnvelopeId__c =: docusignEnvelopeId 
            WITH SECURITY_ENFORCED LIMIT 1];

        DCPDocusignHelper.getDocusignConnectionInfo(envelope.Apttus_QPDSign__QuoteProposal__r.APTS_Approval_Segment__c);
        String envelopeViewEndpoint = DCPDocusignHelper.getDocusignAccountEndpoint()  + '/envelopes/' + docusignEnvelopeId + '?advanced_update=true';
        if(String.isBlank(tempVoidReason)){
            tempVoidReason = 'N/A';
        }
        return callDocusignService(envelopeViewEndpoint,envelope,tempVoidReason );
    }

    //Builds the request and calls Docusing's update service.
    private static String callDocusignService(String envelopeViewEndpoint,Apttus_DocuApi__DocuSignEnvelope__c envelope,String voidReason){

        String authenticationHeader =                 
            '<DocuSignCredentials>' +
            '<Username>' + DCPDocusignHelper.docusignConnectUser + '</Username>' +
            '<Password>' + DCPDocusignHelper.docusignConnectPassword + '</Password>' +
            '<IntegratorKey>' + DCPDocusignHelper.docusignConnectIntegrationKey + '</IntegratorKey>' +
            '<SendOnBehalfOf>' + envelope.Apttus_QPDSign__QuoteProposal__r.Owner.Email + '</SendOnBehalfOf>' +
            '</DocuSignCredentials>';
            
        String requestBody = '{"status":"voided","voidedReason":"'+voidReason+'","voidedDateTime":"'+System.today()+'"}';
        
        HttpResponse docuSignResponse = DCPDocusignHelper.httpPutRequest(envelopeViewEndpoint,authenticationHeader ,requestBody);
        
        //401 code - Retry using default authentication header
        if(docuSignResponse.getStatusCode() == 401 || docuSignResponse.getStatusCode() == 400){
            docuSignResponse = DCPDocusignHelper.httpPutRequest(envelopeViewEndpoint, DCPDocusignHelper.defaultAuthenticationHeader, requestBody);
        }
        
        //On success, update envelope record in SFDC and return success message.
        if(docuSignResponse.getStatusCode() == 200 || docuSignResponse.getStatusCode() == 201){
            updateDocusignEnvelopeRecord(envelope,voidReason);
            return 'Envelope voided successfully';
        }
        else{
            throw new DCCustomException(docuSignResponse.getBody());
        }
    }

    private static void updateDocusignEnvelopeRecord(Apttus_DocuApi__DocuSignEnvelope__c envelope,String voidReason){
        envelope.Apttus_DocuApi__Status__c  = 'voided';
        envelope.Apttus_DocuApi__RecallReason__c = voidReason;
        if(Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isUpdateable()){
            update envelope;
        }
    }
}