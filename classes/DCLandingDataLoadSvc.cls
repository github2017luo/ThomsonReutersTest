/*
 * This is a REST WebService called from AEM for DCLandingPage and Confirmation Pages.
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-08-15   Harika Sai P            DLT-11661 - Combine the Landing Page service into a single service
 * 2018-09-12   Navleen Kaur            DLT-12189 - Null check in landing API services from SFDC.
 * 2020-05-05   Benjamin Her            DLT-19879 - Landing Page performance improvements.
 * 2020-05-18   Benjamin Her            DLT-20045 - Updated API service to include 'quoteId' as a new parameter
 *                                    
 * ==================================================================================================================================   
 */
@RestResource(urlMapping='/digitalconfigurator/loadDataLanding/*')
global class DCLandingDataLoadSvc {

    /* This method is used for calling DCQuoeService or DCGetQuoteDetails based on the landingpage 
    ** or confirmation pages.*/
    @HttpPost
    global static DCQuoteDetails landingPageLoadApi(Id opportunityId,Id accountId,boolean isLandingPage, Id quoteId) {
        DCQuoteDetails quoteData;
        DCQuoteService service  = new DCQuoteService();
        //added by navleen
        if(String.isBlank(opportunityId) 
            || String.isBlank(accountId) 
            || (String.isBlank(quoteId) && !isLandingPage)){
            quoteData = new DCQuoteDetails();
            quoteData.responseCode = 400;
            quoteData.responseMessage = 'Invalid Parameter';
            
        } 
        //If landing page is loaded form AEM
        else if(isLandingPage){
            quoteData = new DCQuoteDetails();
            quoteData = service.landingPageLoadApi(opportunityId,accountId,null);
            quoteData.responseCode = 200;
            quoteData.responseMessage = 'Success';
        }
        //If Confirmation Page is loaded from AEM
        else if(!isLandingPage && quoteId != null){
            quoteData = new DCQuoteDetails();
            quoteData = service.landingPageLoadApi(opportunityId,accountId,quoteId);
            quoteData.promcods = DCQuoteService.getPromoCode(quoteId);
            quoteData.responseCode = 200;
            quoteData.responseMessage = 'Success';
        }
        
        return quoteData;
    }
    
}