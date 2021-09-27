global class DCConfiguratorControllerV2 {
    
    @RemoteAction
    global static DCConfigdetails.UIResponseWrapper performLoad(String customQuoteId, String bestValueQuoteId) {        
        DCConfiguratorImplServiceV2 configClass = new DCConfiguratorImplServiceV2();
        return configClass.performInitialLoad(customQuoteId, bestValueQuoteId);
    }     
    
    @RemoteAction
    global static DCMessage repriceByQuoteId (Id cQuoteId) { 
        return DCCartServiceV2.repriceByQuoteId(cQuoteId); 
    } 
    
    @RemoteAction
    global static DCMessage performUpdates(List<String> addProductIds,String contractTerm,integer iQuantity,String cQuoteId,String bQuoteId) {      
        return DCCartServiceV2.addToCart(addProductIds, contractTerm, iQuantity, cQuoteId, bQuoteId);
    }
    
    @RemoteAction
    global static DCMessage updateCart(String cQuoteId,String bQuoteId,List<String> addProductIds,String contractTerm,integer iQuantity) {      
        return DCCartServiceV2.addToCart(addProductIds, contractTerm, iQuantity, cQuoteId, bQuoteId);
    }
    
    @RemoteAction
    global static Boolean synchronizeCart(String quoteId){
        return DCConfiguratorImplServiceV2.synchronizeCart(quoteId);                
    }
    
    @RemoteAction
    global static Boolean resetToBestValue(String cQuoteId,String bQuoteId){
        return DCCartServiceV2.resetQuote(cQuoteId, bQuoteId);
        
    }

    @RemoteAction
    global static DCQuoteUpdate.QuoteUpdateResponse resetQuotes(String cQuoteId,String bQuoteId){
        return DCCartServiceV2.resetQuotes(cQuoteId, bQuoteId);
        
    }    
    @RemoteAction
    global static void generateContract(String cQuoteId){
        DigitalDocuSignUpdateDocument.updateEnvelope(cQuoteId);
    }
    
    @RemoteAction
    global static DCMessage createEnvelope(String cQuoteId){
        return DigitalDocuSignUpdateDocument.envelopeCreation(cQuoteId);
    }  

    @RemoteAction
    global static DCMessage synchronizeCarts(List<String> quoteIds){
        return DCConfiguratorImplServiceV2.synchronizeCart(quoteIds);                
    }

    @RemoteAction
    global static DCMessage createEnvelopes(List<String> quoteIds){
        return DCConfiguratorImplServiceV2.envelopeCreation(quoteIds);                
    }

    @RemoteAction
    global static DCMessage generateContracts(List<String> quoteIds){
        return DCConfiguratorImplServiceV2.generatePDFDocByQuoteIds(quoteIds);                
    }
   
}