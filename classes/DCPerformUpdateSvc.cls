@RestResource(urlMapping='/digitalconfigurator/performCartUpdate/*')
global class DCPerformUpdateSvc {
     
    @HttpPost 
    global static DCQuoteUpdate.QuoteUpdateResponse performUpdateLanding(List<DCQuoteUpdate.QuoteUpdateRequest> updateDetails) {
        DCQuoteUpdate.QuoteUpdateResponse response = new DCQuoteUpdate.QuoteUpdateResponse();
        if(updateDetails == null || (updateDetails != null && updateDetails.isEmpty() )){
            response.responseCode = 400; 
            response.responseMessage = 'Invalid Parameters';
            return response;
        }
        DCQuoteService service  = new DCQuoteService();
        DCQuoteUpdate.QuoteUpdateResponse res = service.updateAllLineItems(updateDetails,false); 
        return res;        
    }
}