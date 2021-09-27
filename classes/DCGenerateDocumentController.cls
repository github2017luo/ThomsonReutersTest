@RestResource(urlMapping='/digitalconfigurator/generateDocument/*')
global class DCGenerateDocumentController {

        @HttpPost
    global static DocuSignResponse envelopeCreation(List<String> quoteIdList){
        DocuSignResponse response = new DocuSignResponse(); 
        if(quoteIdList == null || quoteIdList.isEmpty()){
            response.responseCode = 400;
            response.responseMessage = 'Invalid Parameters';
            return response;
        }
        return DCDocusignService.generatePDFDocByQuoteIds(quoteIdList);
    } 
    
    global class DocuSignResponse{
        global Integer responseCode;
        global string responseMessage;
    }
}