@RestResource(urlMapping='/digitalconfigurator/createEnvelope/*')
global class DCDocuSignController {
    
    @HttpPost
    global static DocuSignResponse envelopeCreation(String quoteId){
        DocuSignResponse response = new DocuSignResponse();
        if(String.isBlank(quoteId)){
            response.responseCode = 400;
            response.responseMessage = 'Invalid Parameter';
            return response;
        }
        return DCDocusignService.envelopeCreation(quoteId);
    }
    
    global class DocuSignResponse{
        global string envelopeId;
        global Integer responseCode;
        global string responseMessage;
        global string senderName;
        global string sendonBehalfofEmail;
    }

}