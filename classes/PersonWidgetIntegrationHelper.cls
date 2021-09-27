/**
 * Controller for the Integration with Informatica Real Time for data on personWidgetMainPage.page 
 *
 * @author  TCS
 * @version 2015-10-01
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2015-10-01   TCS                     Created                                                                   
 * =============================================================================
 */
 public class PersonWidgetIntegrationHelper{

    public static final string PersonWidgetMainScreenDataService = 'PersonWidgetMainScreenDataService';
    public class ServiceException extends Exception{}

    public PersonWidgetWrapper getPersonMainScreenData(String contactID){
        PersonWidgetWrapper pwObj = new PersonWidgetWrapper();
        Http objhttp = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('POST'); 
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(PersonWidgetMainScreenDataService);
        req.setEndpoint(oWebServiceSettings.Endpoint__c);
        req.setTimeout(Integer.valueOf(oWebServiceSettings.Timeout__c) * 1000); //Convert seconds to milliseconds
        //req.setEndpoint('https://ps1w2-sfdc.rt.informaticacloud.com/active-bpel/public/rt/000JXN/Person_Widget_Main_Screen_data');
        // Set the necessary Headers
        req.setHeader('Content-type','application/json');
        //req.setTimeout(120000);
        //Set request format
        String reqBody = '{"input_ContactID":"'+contactID+'"}';
        req.setBody(reqBody);
        System.debug('request : '+req);
        try {
            res = objhttp.send(req);
        }catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
        }
        System.debug('resp '+res);
        if(res.getStatus().equalsIgnoreCase('OK') && res.getStatusCode() == 200)
        {
            // Logic to parse the response
            String responseString = res.getBody();
            System.debug('responseString : '+responseString);
            pwObj = (PersonWidgetWrapper)JSON.deserialize(responseString, PersonWidgetWrapper.Class);
            System.debug('pwObj : '+pwObj);
        }else{
            throw new ServiceException('Error : ' + res.getStatusCode() + ' - ' + res.getStatus());
        }
        return pwObj;
    }
    
    //response json wrapper
    public class PersonWidgetWrapper{
        public String output_PersonFName {get;set;}
        public String output_PersonLName {get;set;}
        public String output_PersonID {get;set;}
        public String output_PersonLastUp {get;set;}
        public String output_countContactAll {get;set;}
        public String output_countContactRecAct {get;set;}
        public String output_countLeadOpen {get;set;}
        public String output_countLeadUnWork {get;set;}
        public String output_countOppOpen {get;set;}
        public String output_countOppClose {get;set;}
        public String output_countOppOnDem {get;set;}
        public String output_countSubsAll {get;set;}
        public String output_countSubsNext90 {get;set;}
        public String output_countSubsAccess {get;set;}
        public String output_countMarkActLast90 {get;set;}
        public String output_countSalesActLast90 {get;set;}
        public List<HistoryData> output_hisContactList{get;set;}
        public List<HistoryData> output_hisLeadList{get;set;}
        public List<HistoryData> output_hisOppList{get;set;}
        public List<HistoryData> output_hisSubsList{get;set;}
        public List<HistoryData> output_hisMarkActList{get;set;}
        public List<HistoryData> output_hisSalesActList{get;set;}
    }
    
    //wrapper for history tracking data
    public class HistoryData{
        public String UpdateDate{get;set;}
        public String Name{get;set;}
        public String ChangedValue{get;set;}
    }

}