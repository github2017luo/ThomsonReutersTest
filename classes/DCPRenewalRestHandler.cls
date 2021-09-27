/**
 *  @description DCPRenewalRestHandler : Description for DCPRenewalsRestHandler
 */
public without sharing class DCPRenewalRestHandler{
    
    //Overloaded Method - Handles GET request
    /**
     * @description for serviceHandler
     * @param serviceRequest
     * @return viewEnvelope
     */
    public static DCPServiceResponse serviceHandler(string serviceRequest){
        switch on serviceRequest{
            //Calls renewal service
            when 'envelope'{
                
                return viewEnvelope();
            }
            //Throw exception if no matching service is found
            when else {
                throw new DCCustomException('No GET service for "'+RestContext.request.requestURI+'"');
            }
        }
    }      
    //Overloaded Method - Handles PUT request
    /**
     * @description for serviceHandlerPUT
     * @param serviceRequest
     * @param requestBody
     * @return updateEnvelope
     */
    public static DCPServiceResponse serviceHandlerPUT(string serviceRequest,Map<String,String> requestBody){
        switch on serviceRequest{
            when 'envelope'{
                return updateEnvelope(requestBody);
            }
            //Throw exception if no matching service is found
            when else {
                
                
                throw new DCCustomException('No PUT service for "'+RestContext.request.requestURI+'"');
            }
        }
    }  
         
    //Overloaded Method - Handles POST request
    /**
     * @description for serviceHandler
     * @param serviceRequest
     * @param requestBody
     * @return reprice
     * @return bundle
     * @return finalize
     * @return createEnvelope
     * @return generateDocument
     */
    public static DCPServiceResponse serviceHandler(string serviceRequest,Map<String,String> requestBody){
        switch on serviceRequest{
            //Calls renewal service
            when 'reprice' {
                return reprice(requestBody);
                //return reprice();
            }
            when 'bundle' {
                return bundle(requestBody);
            }
            when 'finalize' {
                return finalize(requestBody);
                //return finalize();
            }
            when 'envelope'{
                return createEnvelope(requestBody);
            }
            when 'document'{
                return generateDocument(requestBody);
            }
            //Throw exception if no matching service is found
            when else {
                throw new DCCustomException('No POST service for "'+RestContext.request.requestURI+'"');
            }
        }
    }  
    
    //Calls reprice service.
    @Testvisible
    private static DCPServiceResponse reprice(Map<String,String> requestBody){
        
        String status; 
        DCPServiceResponse response = new DCPServiceResponse();
        status = DCPRepriceCart.repriceCart(requestBody);
        system.debug(LoggingLevel.WARN,'status'+status);
        if(status == 'Success'){
            response.status = 'Success';
            response.response = 'Cart Repriced Successfully';
            response.code = 200;    
        }
        else if(status == 'Pending'){
            response.status = 'Pending';
            response.response = 'Cart Repricing Pending';
            response.code = 307;
            }
        else{
            response.status = 'Success';
            response.response = 'Repricing was not done as all Cart Line Items had the pricing status as \'Complete\'' ;
            response.code = 202;
        }
        return response;
    }
    
    //Calls bundle service.
        @Testvisible
    private static DCPServiceResponse bundle(Map<String,String> requestBody){
     
        String dynamicBundleStatus; 
        DCPServiceResponse response = new DCPServiceResponse();
        dynamicBundleStatus = DCPDynamicBundling.executeDynamicBundling(requestBody);

        switch on dynamicBundleStatus{
            when 'Success' {
                response.status = 'Success';
                response.response = 'Bundle created sucessfully';
                response.code = 200;
            }when 'ImproperRequestFormat' {
                response.status = 'Failed';
                response.response = 'Improper request format';
                response.code = 400;
            }
        }
        
        return response;
    }
    
    //Calls finalize service.
        @Testvisible
    private static DCPServiceResponse finalize(Map<String,String> requestBody){
        DCPServiceResponse response = new DCPServiceResponse();
        response.response = DCPFinalizeCart.callCongaFinalizeMethod(requestBody);
     //System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> reponse.response  :  '+response.response );

        response.status = 'Success';
        response.code = 200;
        return response;
    }
             @Testvisible

    private static DCPServiceResponse createEnvelope(Map<String,String> requestBody){
        DCPServiceResponse response = new DCPServiceResponse();
        response.response = 'docusignEnvelopeId='+DCPRenewalDocusign.createDocusignEnvelope(requestBody);
        response.status = 'Success';
        response.code = 200;
        return response;
    }
             @Testvisible

    private static DCPServiceResponse viewEnvelope(){
    
        RestRequest req = RestContext.request;
        
        Map<String, String> reqParameter = req.params;
        DCPServiceResponse response = new DCPServiceResponse();
        response.response = 'viewDocusignUrl='+DCPRenewalDocusign.viewDocusignEnvelope(reqParameter);
        response.status = 'Success';
        response.code = 200;
        return response;
    }
            @Testvisible

    private static DCPServiceResponse generateDocument(Map<String,String> requestBody){
        
        String generateDocumentStatus; 
        DCPServiceResponse response = new DCPServiceResponse();
        generateDocumentStatus = DCPGenerateDocument.generateDoc(requestBody);

        switch on generateDocumentStatus{
            when 'Success' {
                response.status = 'Success';
                response.response = 'Document genearted sucessfully';
                response.code = 200;
            }when 'CartNotFinalized' {
                response.status = 'Failed';
                response.response = 'Cart is not finalized yet';
                response.code = 400;
            }when 'TemplateNotFound' {
                response.status = 'Failed';
                response.response = 'Template not found';
                response.code = 400;
            }when 'ImproperRequestFormat' {
                response.status = 'Failed';
                response.response = 'Improper request format';
                response.code = 400;
            }
        }
        
        return response;
    }
            @Testvisible

    private static DCPServiceResponse updateEnvelope(Map<String,String> requestBody){
        
        DCPServiceResponse response = new DCPServiceResponse();
        response.response = DCPRenewalDocusign.updateDocusignEnvelope(requestBody);
        response.status = 'Success';
        response.code = 200;
        return response;
    }
    
}