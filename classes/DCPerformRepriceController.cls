@RestResource(urlMapping='/digitalconfigurator/performReprice/*')
global class DCPerformRepriceController {
	 
    @HttpPost
    global static RepriceResponse performReprice(String quoteId){
        RestResponse res = RestContext.response;
        // String quoteId = RestContext.request.params.get('quoteId');
        RepriceResponse resWrap = new RepriceResponse(); 
        if(String.isBlank(quoteId)){
            resWrap.responseCode =400; 
            resWrap.responseMessage = 'Invalid parameter';
            return resWrap;
        }
        return DCQuoteService.repriceByQuoteId(quoteId);
        
    }
    
    global class RepriceResponse{
        global Integer responseCode;
        global String responseMessage;
        global boolean isPricingPending;
        
    }
}