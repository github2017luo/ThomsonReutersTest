/*
 * This class has Reset service related to Digital Configuration Page.
 * CHANGE HISTORY 
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-12-17   Divija Salla            DLT-13779 - Create an API to get Configurator plan details
 * ==================================================================================================================================  
 */ 
@RestResource(urlMapping='/digitalconfigurator/configResetservice/*')
global class DCConfigResetService {
@HttpPost
       global static DCQuoteUpdate.QuoteUpdateResponse configreprice(String cQuoteId,String bQuoteId){
         DCQuoteUpdate.QuoteUpdateResponse configdata;
         list<String> quoteids = new list<String>{cQuoteId, bQuoteId};
         if(cQuoteId == null ||  bQuoteId == null || String.isBlank(cQuoteId) || String.isBlank(bQuoteId) || cQuoteId.length()< 15 || bQuoteId.length()<15){
             configdata = new DCQuoteUpdate.QuoteUpdateResponse();
             configdata.responseCode = 400;
             configdata.responseMessage = 'Invalid Parameter';
         } 
         else{
            
                 configdata = new DCQuoteUpdate.QuoteUpdateResponse();
                 configdata = DCCartServiceV2.resetQuotes(cQuoteId, bQuoteId);
                 configdata.responseCode = 200;
               
               configdata.responseMessage = 'Success';
               
            
            /*catch(Exception ex){//Returning error response if service is failed.
            DCUtils.trackLog(ex,'DCCartServiceV2','resetQuotes');
            configdata.responseCode = 400;
            configdata.responseMessage = ex.getMessage();//Sending exception message to AEM.
            throw ex;
        }//End of Try Catch*/
        }
       return configdata;
    }
}