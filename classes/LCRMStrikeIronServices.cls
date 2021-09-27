/*
===============================================================================
LCRMStrikeIronServices
===============================================================================

PURPOSE: class to work as service class for the StrikeIron webservices 

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-06-20      Rajesh                  Created 
===============================================================================
*/
public class LCRMStrikeIronServices{
    //service method for making callout to strikeiron email services
    public String callEmailValidation(String email){
        WebServiceSettings__c webServiceObj = WebServiceSettings__c.getInstance('LCRM_StrikeIron_Email_Service');
        if(webServiceObj ==null){
            return 'Exception : Email Service not configured.';
        }
        if(webServiceObj.active__c ==false){
            return 'Exception : Email Service not active.';
        }
        
        String response = '';
        String userID = (webServiceObj != null)?webServiceObj.Username__c:'';
        String pass = (webServiceObj != null)?webServiceObj.Password__c:'';
        Decimal timeout = (webServiceObj != null)?webServiceObj.Timeout__c:200;
        String endpoint = (webServiceObj != null)?webServiceObj.Endpoint__c:'';
        
        StrikeIronEmailService.SIWsOutputOfVerifyEmailRecord respObj = new StrikeIronEmailService.SIWsOutputOfVerifyEmailRecord();
        
        StrikeIronEmailService.EMV6HygieneSoap serviceObj = new StrikeIronEmailService.EMV6HygieneSoap();
        serviceObj.endpoint_x = endpoint;
        serviceObj.inputHttpHeaders_x = new Map<String,String>();
        serviceObj.outputHttpHeaders_x = new Map<String,String>();
        serviceObj.timeout_x = Integer.valueOf(timeout);
        StrikeIronEmailServiceObjects.RegisteredUser regUser = new StrikeIronEmailServiceObjects.RegisteredUser();
        regUser.UserID = userID;
        regUser.Password = pass;
        StrikeIronEmailServiceObjects.LicenseInfo licInfoObj = new StrikeIronEmailServiceObjects.LicenseInfo();
        licInfoObj.RegisteredUser = regUser;
        serviceObj.LicenseInfo = licInfoObj;
        StrikeIronEmailServiceObjects.SubscriptionInfo subsInfoObj = new StrikeIronEmailServiceObjects.SubscriptionInfo();
        serviceObj.SubscriptionInfo = subsInfoObj;
        try{
            if(Test.isRunningTest()){
                respObj = MockWebserviceResponses.getStrikeIronEmailResponse();
            }else{
                //callout to email service
                respObj = serviceObj.VerifyEmail(email,serviceObj.timeout_x,'');
            }
            System.debug('Email respObj :'+respObj);
            if(respObj != null){
                StrikeIronEmailService.SIWsStatus ServiceStatus = respObj.ServiceStatus;
                StrikeIronEmailService.VerifyEmailRecord ServiceResult = respObj.ServiceResult;
                if(ServiceStatus!=null){
                    response = ServiceStatus.StatusDescription;
                }
            }
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            response = 'Email Service Exception : ' + e.getMessage()+ ' : '+e.getStackTraceString();
        }
        //System.debug('response : '+serviceObj.GetServiceInfo());
        System.debug('Email response :'+response);
        return response;
    }
    
    //service method for making callout to strikeiron phone services
    public Map<String,String> callPhoneValidation(String phone){
        //return 'Valid Number';
        List<String> phoneList = (phone !=null && phone!='')?phone.split(','):new List<String>();
        Map<String,String> response = new Map<String,String>();
        WebServiceSettings__c webServiceObj = WebServiceSettings__c.getInstance('LCRM_StrikeIron_Phone_Service');
        if(webServiceObj ==null){
            for(String ph : phoneList){
                response.put(ph,'Exception : Phone Service not configured.');
            }
            return response;
        }
        if(webServiceObj.active__c ==false){
            for(String ph : phoneList){
                response.put(ph,'Exception : Phone Service not active.');
            }
            return response;
        }
        
        String userID = (webServiceObj != null)?webServiceObj.Username__c:'';
        String pass = (webServiceObj != null)?webServiceObj.Password__c:'';
        String timeout = (webServiceObj != null)?String.valueOf(webServiceObj.Timeout__c):'200';
        String endpoint = (webServiceObj != null)?webServiceObj.Endpoint__c:'';
        
        StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfGlobalPhoneEntryWithStatus respObj = new StrikeIronPhoneService.SIWsOutputOfSIWsResultArrayOfGlobalPhoneEntryWithStatus();
        
        StrikeIronPhoneService.GlobalPhoneValidation15Soap serviceObj = new StrikeIronPhoneService.GlobalPhoneValidation15Soap();
        serviceObj.endpoint_x = endpoint;
        serviceObj.inputHttpHeaders_x = new Map<String,String>();
        serviceObj.outputHttpHeaders_x = new Map<String,String>();
        serviceObj.timeout_x = Integer.valueOf(timeout);
        StrikeIronPhoneServiceObjects.RegisteredUser regUser = new StrikeIronPhoneServiceObjects.RegisteredUser();
        regUser.UserID = userID;
        regUser.Password = pass;
        StrikeIronPhoneServiceObjects.LicenseInfo licInfoObj = new StrikeIronPhoneServiceObjects.LicenseInfo();
        licInfoObj.RegisteredUser = regUser;
        serviceObj.LicenseInfo = licInfoObj;
        StrikeIronPhoneServiceObjects.SubscriptionInfo subsInfoObj = new StrikeIronPhoneServiceObjects.SubscriptionInfo();
        serviceObj.SubscriptionInfo = subsInfoObj;
        try{
            if(Test.isRunningTest()){
                respObj = MockWebserviceResponses.getStrikeIronPhoneResponse(phone);
            }else{
                //callout to phone service
                respObj = serviceObj.ValidateNumber(phone);
            }
            System.debug('Phone respObj : '+respObj);
            if(respObj!=null){
                StrikeIronPhoneService.SIWsResultArrayOfGlobalPhoneEntryWithStatus ServiceResult = respObj.ServiceResult;
                if(ServiceResult!=null){
                    StrikeIronPhoneService.ArrayOfGlobalPhoneEntryWithStatus Results = ServiceResult.Results;
                    if(Results!=null){
                        StrikeIronPhoneService.GlobalPhoneEntryWithStatus[] statusArray = Results.GlobalPhoneEntryWithStatus;
                        if(statusArray!=null && statusArray.size()>0){
                            for(Integer i=0; i<statusArray.size(); i++){
                                StrikeIronPhoneService.SIWsStatus status2 = statusArray[i].ItemStatus;
                                response.put(phoneList[i],status2.StatusDescription);
                            }
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            //response = 'Phone Service Exception : ' + e.getMessage();
            for(String ph : phoneList){
                response.put(ph,'Phone Service Exception : ' + e.getMessage());
            }
        }
        System.debug('Phone response :'+response);
        return response;
        //return null;
    }
}