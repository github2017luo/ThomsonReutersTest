/**
    @description Renewal Docuign handler class
    CHANGE HISTORY
    ==========================================================================================
    Date                Developer                   Description
    2021-05-19          Benjamin Her                DCP-1548 Initial creation  

 */
public without sharing class DCPRenewalDocusign{

    /**
        @description Calls the Docusign job to create a Docusign envelope
        @param requestBody HttpRequest body that contains the request paramaeter
        @return Returns the Docusign envelope id on successful creation
     */
    public static String createDocusignEnvelope(Map<String,String> requestBody){

        Map<id,String> proposalToEnvelopeId = new Map<id,String>();

        if(requestBody.containskey('proposalId') && String.isNotBlank(requestBody.get('proposalId'))){
            String propId = requestBody.get('proposalId');
            proposalToEnvelopeId = DCPCreateDocusignEnvelope.createDocusignEnvelope(new List<id>{propId});

            if(proposalToEnvelopeId.containsKey(propId) && String.isNotBlank(proposalToEnvelopeId.get(propId))){
                return proposalToEnvelopeId.get(propId);
            }
            else{
                throw new DCCustomException('Envelope failed to be created');
            }
        }
        else{
            throw new DCCustomException('No parameter/value for "proposalId" found');
        }
    }

    /**
        @description Calls the Docusign job to create an envelope view
        @param reqParameter Map of request parameter
        @return Returns the Docusign envelope view URL
     */
    public static String viewDocusignEnvelope(Map<String, String> reqParameter){

        if(reqParameter.containsKey('docusignEnvelopeId') && String.isNotBlank(reqParameter.get('docusignEnvelopeId'))){
            String envelopeViewUrl = DCPViewDocusignEnvelope.getEnvelopeView(reqParameter.get('docusignEnvelopeId'));
            if(String.isNotBlank(envelopeViewUrl)){
                return envelopeViewUrl;
            }
            else{
                throw new DCCustomException('Envelope view URL failed to generate');
            }
        }
        else{
            throw new DCCustomException('No parameter/value for "docusignEnvelopeId" found');
        }
    }
    
    /**
        @description Calls the Docusign job to create an envelope view
        @param reqParameter Map of request parameter
        @return Returns the Docusign envelope view URL
     */
    public static String updateDocusignEnvelope(Map<String, String> reqParameter){

        if(reqParameter.containsKey('updateAction')
            && reqParameter.containsKey('docusignEnvelopeId') 
            && String.isNotBlank(reqParameter.get('docusignEnvelopeId'))){
            switch on reqParameter.get('updateAction'){
                when 'complete'{
                    return DCPCompleteDocusignEnvelope.completeEnvelope(reqParameter.get('docusignEnvelopeId'));
                }
                when 'void'{
                    return DCPVoidDocusignEnvelope.voidEnvelope(reqParameter.get('docusignEnvelopeId'),reqParameter.get('voidReason'));
                }
                when else{
                    throw new DCCustomException('No service for updateAction "'+reqParameter.get('updateAction')+'"');
                }
            }
        
        }
        else{
            throw new DCCustomException('No parameter/value for "docusignEnvelopeId" or "updateAction" found');
        }
    }
    
    
}