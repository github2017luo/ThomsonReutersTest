/**
* @description Helper class for CreateSSDCustomerFromESI to validate the request payload and create logger record
*/
public without sharing class CreateSSDCustomerFromESIHelper2{
    
    /**
     * @description Helper method6 for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
     * @param tempStr of type String
     * @return String
    */
    public static String validaterequestpayload6(APTS_CreateSSDJSON2Apex oRequest,String tempStr){
        if(oRequest.customer.industryCode ==null){
            tempStr = (tempStr==null || tempStr=='')?'Industry Code': tempStr+', Industry Code';
        }
        if(oRequest.customer.distributionChannel ==null){
            tempStr = (tempStr==null || tempStr=='')?'IXOSCodeMap value for '+oRequest.customer.salesOrg: tempStr+' IXOSCodeMap value for '+oRequest.customer.salesOrg;
        }
        return tempStr;
    }
    
    /**
     * @description Helper method7 for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
     * @param tempStr of type String
     * @return String
    */
    public static String validaterequestpayload7(APTS_CreateSSDJSON2Apex oRequest,String tempStr){
        if(oRequest.customer.division ==null){
            tempStr = (tempStr==null || tempStr=='')?'IXOSCodeMap value for '+oRequest.customer.salesOrg: tempStr+', IXOSCodeMap value for '+oRequest.customer.salesOrg;
        }
        if(oRequest.customer.Companyname ==null){
            tempStr = (tempStr==null || tempStr=='')?'Company Name': tempStr+', Company Name';
        }
        return tempStr;
    }
    
    /**
     * @description Helper method8 for validating the request payload
     * @param oRequest of type APTS_CreateSSDJSON2Apex
     * @param latamsalesorgs of type String
     * @param tempStr of type String
     * @return String
    */
    public static String validaterequestpayload8(APTS_CreateSSDJSON2Apex oRequest,String latamsalesorgs,String tempStr){
        if(oRequest.customer.jurisdictionCode == null && latamsalesorgs.contains(oRequest.customer.salesOrg)){
            tempStr = (tempStr==null || tempStr=='')?'Tax Number': tempStr+', Tax Number';
        }
        if(oRequest.customer.taxCodeType == null && latamsalesorgs.contains(oRequest.customer.salesOrg)){
            tempStr = (tempStr==null || tempStr=='')?'Tax Number Type': tempStr+', Tax Number Type';
        }
        return tempStr;
    }
    
    /**
     * @description Helper method1 for logging record in Integration Logger
     * @param intLogList of type List<Integration_Logger__c>
     * @param validatepayload of type String
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    public static void loggerrecord1(List<Integration_Logger__c> intLogList,String validatepayload,APTS_CreateSSDJSON2Apex oRequest){
        if(intLogList!=null && intLogList.size()>=1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, validatepayload,'Required details : '+oRequest); 
        }else{
            IntegrationLogger.TaxprofOCAddMessage(validatepayload,'', 'Source System Detail', 'Requested details : '+oRequest, 'Outbound','ZPEND Customer Creation',false,'',oRequest.externalAccountId);
        }
    }
    
    /**
     * @description Helper method2 for logging record in Integration Logger
     * @param intLogList of type List<Integration_Logger__c>
     * @param response of type HttpResponse
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    public static void loggerrecord2(List<Integration_Logger__c> intLogList,HttpResponse response,APTS_CreateSSDJSON2Apex oRequest){
        if(intLogList!=null && intLogList.size()>=1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, 'Request Not Sent Successfuly.\nResponse Status Code : '+response.getStatusCode()+'.\nResponse Status : '+response.getStatus()+'. \nResponse Body : '+response.getBody(),'Requested details : '+oRequest); 
        }else{
            IntegrationLogger.TaxprofOCAddMessage('Request Not Sent Successfuly.\nResponse Status Code : '+response.getStatusCode()+'.\nResponse Status : '+response.getStatus()+'. \nResponse Body : '+response.getBody(),'', 'Source System Detail', 'Requested details : '+oRequest, 'Outbound','ZPEND Customer Creation',false,'',oRequest.externalAccountId);
        }
    }
    
    /**
     * @description Helper method3 for logging record in Integration Logger
     * @param intLogList of type List<Integration_Logger__c>
     * @param response of type HttpResponse
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    public static void loggerrecord3(List<Integration_Logger__c> intLogList,HttpResponse response,APTS_CreateSSDJSON2Apex oRequest){
        if(intLogList!=null && intLogList.size()>=1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, 'Error while creating SAP number : '+response.getStatusCode()+'.\nResponse Status : '+response.getStatus()+'. \nResponse Body : '+response.getBody(),'Requested details : '+oRequest); 
        }else{
            IntegrationLogger.TaxprofOCAddMessage('Error while creating SAP number : '+response.getStatusCode()+'.\nResponse Status : '+response.getStatus()+'. \nResponse Body : '+response.getBody(),'', 'Source System Detail', 'Requested details : '+oRequest, 'Outbound','ZPEND Customer Creation',false,'',oRequest.externalAccountId);
        }
    }
    
    /**
     * @description Helper method4 for logging record in Integration Logger
     * @param intLogList of type List<Integration_Logger__c>
     * @param ex of type Exception
     * @param oRequest of type APTS_CreateSSDJSON2Apex
    */
    public static void loggerrecord4(List<Integration_Logger__c> intLogList,Exception ex,APTS_CreateSSDJSON2Apex oRequest){
        if(intLogList!=null && intLogList.size()>=1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false, 'Excpetion message : '+ex.getMessage()+'.\n Exception in line : '+ex.getLineNumber()+'.\nException : '+ex.getStackTraceString(),'Requested details : '+oRequest); 
        }else{
            IntegrationLogger.TaxprofOCAddMessage('Excpetion message : '+ex.getMessage()+'.\n Exception in line : '+ex.getLineNumber()+'.\nException : '+ex.getStackTraceString(),'', 'Source System Detail', '', 'Outbound','ZPEND Customer Creation',false,'',oRequest.externalAccountId);
        }
    }
}