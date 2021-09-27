/*
 * This class has Load Details service related to Digital Configuration Page.
 * CHANGE HISTORY 
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-12-17   Divija Salla            DLT-13779 - Create an API to get Configurator plan details
 * 2018-07-02   Navleen kaur            DLT-16925 - [Tech Story] [Code Scan] - Fix code scan MINOR issues in DCConfigdetails, DCConfiguratorImplServiceV2, DCConfiguratorService, DCConfiguratorSynchService, DCConfiguratorUpdateService
 * 2019-08-16  Srikanth Kota            Updated cQuoteId/bQuoteId for ESI 
 * ==================================================================================================================================  
 */ 
@RestResource(urlMapping='/digitalconfigurator/configservice/*')
global class DCConfiguratorService {
    private DCConfiguratorService(){
    
    }
 @HttpPost
    global static DCConfigdetails performInitialLoading(Id cQuoteId,Id bQuoteId) {
        DCConfigdetails configdata;
        
        if(cQuoteId == null ||  bQuoteId == null  || String.isBlank(cQuoteId) || String.isBlank(bQuoteId)){
            configdata = new DCConfigdetails();
            configdata.responseCode = 400;
            configdata.responseMessage = 'Invalid Parameter';
        } 
        else {
            DCConfiguratorImplServiceV2 service = new DCConfiguratorImplServiceV2();
            configdata = new DCConfigdetails();
            configdata.responseWrapper = service.performInitialLoad(cQuoteId,bQuoteId);
            configdata.responseCode = 200;
            configdata.responseMessage = 'Success';
        }
        
        return configdata;
    }
    
}