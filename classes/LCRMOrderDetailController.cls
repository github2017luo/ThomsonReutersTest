/**
 * Controller for LCRMOrderDetail page. This is used to fetch OrderDetail records from ESI using REST Webservice.
 *
 * @author  Seema Nagdev
 * @version 2017-11-10
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date                 Name                     Description
 * 2017-11-10       Seema Nagdev           Created for CRM-11370                                                          
 * =============================================================================
 */

public class LCRMOrderDetailController {
    public string sOrderDate {get;set;}
    public string sOrderType {get;set;}
    public string sOrderNumber {get;set;}
    public string sSubmittingRep {get;set;}
    public string sRevenueChannel {get;set;}
    public string sPONumber {get;set;}
    public string sShipDate{get;set;}
    public string dNetValue {get;set;}
    public string accSAPNo {get;set;}
    public string sSalesOrg {get;set;} //MCL-2334 Changes
    public LCRMCredentialInfoHelper CredentialHelper;
    public List < LCRMOrderDetailWrapper.OrderItems > odItems {get;set;}
    public OrderServiceExceptions.StatusDetail ExceptionMesginfo {get;set;}
    //Integration Logger Paramters
    public String error;
    public String strBody;
    //Constants
    public static final string WebServiceName = 'LCRM_GetOrderDetail';

    public LCRMOrderDetailController(ApexPages.StandardController controller) {
        sOrderType = AppUtil.getURLParam(ApexPages.currentPage(), 'OT', 'N/A'); //PageReference, UrlParamKey, Default Value
        sOrderDate = AppUtil.getURLParam(ApexPages.currentPage(), 'OD', ''); //PageReference, UrlParamKey, Default Value
        sOrderNumber = AppUtil.getURLParam(ApexPages.currentPage(), 'ON', '0'); //PageReference, UrlParamKey, Default Value
        sSubmittingRep = AppUtil.getURLParam(ApexPages.currentPage(), 'SR', 'N/A'); //PageReference, UrlParamKey, Default Value
        sRevenueChannel = AppUtil.getURLParam(ApexPages.currentPage(), 'RC', 'N/A'); //PageReference, UrlParamKey, Default Value
        sPONumber = AppUtil.getURLParam(ApexPages.currentPage(), 'PO', 'N/A'); //PageReference, UrlParamKey, Default Value
        sShipDate = AppUtil.getURLParam(ApexPages.currentPage(), 'SD', 'N/A'); //PageReference, UrlParamKey, Default Value
        dnetValue = AppUtil.getURLParam(ApexPages.currentPage(), 'NV', '0');
        accSAPNo = AppUtil.getURLParam(ApexPages.currentPage(), 'SAP', '0');
        sSalesOrg = AppUtil.getURLParam(ApexPages.currentPage(), 'ssdSalesOrg', ''); //MCL-2334 Changes
        System.debug('sOrderType-->' + sOrderType + ' sOrderDate-->' + sOrderDate + ' sOrderNumber-->' + sOrderNumber + ' sSubmittingRep-->' + sSubmittingRep + ' sRevenueChannel-->' + sRevenueChannel + ' sPONumber-->' + sPONumber + ' sShipDate-->' + sShipDate + ' dnetValue-->' + dnetValue + ' accSAPNo-->' + accSAPNo);
    }
    
     /* -------------------------------------------------------------------------------    
    Method to retrieve orderdetail records utilizing the OrderDetail web service.
    --------------------------------------------------------------------------------*/  
    public PageReference getOrderDetails() {
        CredentialHelper = new LCRMCredentialInfoHelper();
        odItems = new List < LCRMOrderDetailWrapper.OrderItems > ();
        LCRMOrderDetailWrapper.OrdDetailRequest odReqWrap = new LCRMOrderDetailWrapper.OrdDetailRequest();
        try {
            odReqWrap.orderNumber = sOrderNumber;
            odReqWrap.esiHeader.applicationId = 'GLI';
            System.debug('odReqWrap.esiHeader.applicationId-->' + odReqWrap.esiHeader.applicationId);
            odReqWrap.accounts.accountNumber = accSAPNo;
            odReqWrap.esiHeader.companyId = sSalesOrg; //MCL-2334 Changes
            System.debug('odReqWrap-->' + odReqWrap);

            if (odReqWrap.accounts.accountNumber != null) {
                String strBody = JSON.serialize(odReqWrap);
                system.debug('strBody...' + strBody);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request = CredentialHelper.getHttpRequestCred(WebServiceName, strBody);
                HttpResponse Response = http.Send(request);
                System.debug('Response:-' + Response);
                String odRes = Response.getBody();
                System.debug('odRes-->' + odRes);

                if (Response.getStatusCode() == 200) {
                    if (odRes.contains('"orderHeader" : null')) {
                        if (OrderServiceExceptions.getExceptionMesg(odRes) != null) {
                            ExceptionMesginfo = OrderServiceExceptions.getExceptionMesg(odRes);
                            OrderServiceExceptions.handleException(ExceptionMesginfo, WebServiceName);
                        }
                    } else if (!odRes.contains('"orderHeader" : null')) {
                        if (LCRMOrderDetailWrapper.getMatchedValues(odRes).size() > 0) {
                            odItems = LCRMOrderDetailWrapper.getMatchedValues(odRes);
                        }
                    } else
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LCRMWebserviceNoResponse));
                } else if(OrderServiceExceptions.getExceptionMesg(odRes) != null){
                    ExceptionMesginfo = OrderServiceExceptions.getExceptionMesg(odRes);
                    OrderServiceExceptions.handleException(ExceptionMesginfo, WebServiceName);
                }else {
                    strBody = 'Exception received.';
                    error = 'Response Status Code:-' + Response.getStatusCode() + ' Response Status:- ' + Response.getStatus();
                    System.debug('strBody' + strBody + 'error' + error);
                    OrderServiceExceptions.logException(strBody, error, WebServiceName);
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LCRMWebServiceError));
                }
            }
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
     return null;
    }

}