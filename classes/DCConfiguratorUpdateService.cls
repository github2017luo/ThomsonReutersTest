/*
 * This class has Cart Update service related to Digital Configuration Page.
 * CHANGE HISTORY 
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-12-17   Divija Salla            DLT-13779 - Create an API to get Configurator plan details
 * 2018-07-02   Navleen kaur            DLT-16925 - [Tech Story] [Code Scan] - Fix code scan MINOR issues in DCConfigdetails, DCConfiguratorImplServiceV2, DCConfiguratorService, DCConfiguratorSynchService, DCConfiguratorUpdateService
 * ==================================================================================================================================  
 */ 
@RestResource(urlMapping='/digitalconfigurator/configupdateservice/*')
global class DCConfiguratorUpdateService {
    private DCConfiguratorUpdateService(){
    
    }
  @HttpPost
    global static DCConfigdetails configupdation(List<String> addProductIds,String contractTerm,integer iQuantity,String cQuoteId,String bQuoteId){
         DCConfigdetails configdata;
         if(cQuoteId == null ||  bQuoteId == null || String.isBlank(cQuoteId) || String.isBlank(bQuoteId) || cQuoteId.length()< 15 || bQuoteId.length()< 15){
             configdata = new DCConfigdetails();
             configdata.responseCode = 400;
             configdata.responseMessage = 'Invalid Parameter';
         } 
        else{
            try{
                 configdata = new DCConfigdetails();
                 configdata.configmsg = DCCartServiceV2.addToCart(addProductIds, contractTerm, iQuantity, cQuoteId, bQuoteId);
                 configdata.responseCode = 200;
                 configdata.responseMessage = 'Success';
            }
            
           catch(Exception ex){//Returning error response if service is failed.
            DCUtils.trackLog(ex,'DCCartServiceV2','addToCart');
            configdata.responseCode = 400;
            configdata.responseMessage = ex.getMessage();//Sending exception message to AEM.
            throw ex;
        }//End of Try Catch
        }
       return configdata;
    }
}