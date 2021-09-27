@RestResource(urlMapping='/digitalconfigurator/performSynchronize/*') 
global class DCPerformSynchronizeController {

    @HttpPost
    global static SynchronizeResponse performReprice(List<String> quoteIdList){

        SynchronizeResponse resWrap = new SynchronizeResponse(); 
        if(quoteIdList == null || ( quoteIdList != null && quoteIdList.isEmpty() )){
            resWrap.responseCode = 400; 
            resWrap.responseMessage = 'Invalid parameter';
            return resWrap;
        }
        return DCQuoteService.synchronizeCart( quoteIdList);
    }
    
    global class SynchronizeResponse{
        global Integer responseCode;
        global String responseMessage;
        
    }
}