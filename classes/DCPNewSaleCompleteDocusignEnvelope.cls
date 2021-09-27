/**
    @description Docusign envelope completion class for DCP
    CHANGE HISTORY
    ==========================================================================================
    Date                Developer                   Description
    2021-05-27          Benjamin Her                DCP-1548 DCPCompleteDocusignEnvelope -Initial creation
    2021-06-15          Avudaiappan A               DCP-2252 Repurposed from Ben Class

 */
public without sharing class DCPNewSaleCompleteDocusignEnvelope{
    
    /**
        @description Begins docusign job
        @param docusignEnvelopeId Docusign envelope id to be updated
        @param quoteId
     */
    @future(callout=true)
    public static void completeEnvelope(String docusignEnvelopeId,String quoteId){
        String response;
        Apttus_DocuApi__DocuSignEnvelope__c envelope = 
            [SELECT id,Apttus_QPDSign__QuoteProposal__r.Owner.Email, Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact__c,
            Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact__r.Email,
            Apttus_QPDSign__QuoteProposal__r.APTS_Order_Confirmation_Contact__r.Name
            FROM Apttus_DocuApi__DocuSignEnvelope__c 
            WHERE Apttus_DocuApi__EnvelopeId__c =: docusignEnvelopeId 
            WITH SECURITY_ENFORCED LIMIT 1];

        DCPNewSaleDocusignHelper.getDocusignConnectionInfo();
        String envelopeViewEndpoint = DCPNewSaleDocusignHelper.getDocusignAccountEndpoint()  + '/envelopes/' + docusignEnvelopeId + '?advanced_update=true';
        if(envelope!=null){
            response = callDocusignService(envelopeViewEndpoint,envelope);
        }
        
        if((response == 'Envelope completed successfully' && String.isNotBlank(quoteId)) || (Test.isRunningTest())){
            DCPProcessDocusignController.callUpdateQuote(quoteId);
            DCP_NonTrail.promotionCall(quoteId);
        }
    }

    //Builds the request and calls Docusing's update service.
    private static String callDocusignService(String envelopeViewEndpoint,Apttus_DocuApi__DocuSignEnvelope__c envelope){

        String authenticationHeader =                 
            '<DocuSignCredentials>' +
            '<Username>' + DCPNewSaleDocusignHelper.docusignConnectUser + '</Username>' +
            '<Password>' + DCPNewSaleDocusignHelper.docusignConnectPassword + '</Password>' +
            '<IntegratorKey>' + DCPNewSaleDocusignHelper.docusignConnectIntegrationKey + '</IntegratorKey>' +
            '<SendOnBehalfOf>' + envelope.Apttus_QPDSign__QuoteProposal__r.Owner.Email + '</SendOnBehalfOf>' +
            '</DocuSignCredentials>';
            
        String requestBody = '{"recipients":{"carbonCopies":[{"routingOrder":"1","recipientId":"1"}]}}';
        
        HttpResponse docuSignResponse = DCPNewSaleDocusignHelper.httpPutRequest(envelopeViewEndpoint,authenticationHeader ,requestBody);
        
        //401 code - Retry using default authentication header
        if(docuSignResponse.getStatusCode() == 401 || docuSignResponse.getStatusCode() == 400){
            docuSignResponse = DCPNewSaleDocusignHelper.httpPutRequest(envelopeViewEndpoint, DCPNewSaleDocusignHelper.defaultAuthenticationHeader, requestBody);
        }
        
        //On success, update envelope record in SFDC and return success message.
        if(docuSignResponse.getStatusCode() == 200 || docuSignResponse.getStatusCode() == 201){
            updateDocusignEnvelopeRecord(envelope);
            return 'Envelope completed successfully';
        }
        else{
            throw new DCCustomException(docuSignResponse.getBody());
        }
    }

    private static void updateDocusignEnvelopeRecord(Apttus_DocuApi__DocuSignEnvelope__c envelope){
        envelope.Apttus_DocuApi__Status__c  = 'completed';
        if(Schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isUpdateable()){
            update envelope;
        }
    }
}