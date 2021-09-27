/*
 * This class has Reprice service related to Digital Configuration Page.
 * CHANGE HISTORY 
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-12-17   Divija Salla            DLT-13779 - Create an API to get Configurator plan details
 * ==================================================================================================================================  
 */ 
@RestResource(urlMapping='/digitalconfigurator/configrepriceservice/*')
global class DCConfigRepriceCart {
  @HttpPost
    global Static DCConfigdetails configreprice(String cQuoteId,String bQuoteId){
         DCConfigdetails configdata;
         if(cQuoteId == null ||  bQuoteId == null || String.isBlank(cQuoteId) || String.isBlank(bQuoteId) || cQuoteId.length()< 15|| bQuoteId.length()<15){
             configdata = new DCConfigdetails();
             configdata.responseCode = 400;
             configdata.responseMessage = 'Invalid Parameter';
         } 
        else{
            try{
                 configdata = new DCConfigdetails();
                             
                 
                 configdata.configmsg = DCCartServiceV2.repriceByQuoteId(cQuoteId);
                 configdata.responseCode = 200;
            	 configdata.responseMessage = 'Config Success';
                 
				 configdata.Bestmsg = DCCartServiceV2.repriceByQuoteId(bQuoteId);
                 configdata.responseCode = 200;
            	 configdata.responseMessage = 'Success';
                 
            }
            catch(Exception ex){//Returning error response if service is failed.
            DCUtils.trackLog(ex,'DCCartServiceV2','repriceByQuoteId');
            configdata.responseCode = 400;
            configdata.responseMessage = ex.getMessage();//Sending exception message to AEM.
            throw ex;
        }//End of Try Catch
        }
        return configdata;
  }
}