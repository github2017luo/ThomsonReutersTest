/*
@JIRA Story: CRM-6978, CRM-8066
@Purpose: This is helper class and used in LCRMCredentialInfoController. 
          Credential Information Page Block Section which is returning the response from ESI external system when callout is made to ‘Credential’ and 'IP Address Restriction' webservice 
@Version: 2017-09-15

* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
*2017-09-15      Radhika Pawar              Credential and Merger with IP Restriction
* 2017-10-16     Noopur Rathod              IP Restriction                                    
* =============================================================================
*/

public without sharing class LCRMCredentialInfoHelper{
    public static final String strSalesOrgVal='WEST';
    public static final String sourceName; 
    public List<Source_System_Detail__c> ListofSSD;
    public List<Source_System_Detail__c> ListofSSDIP;
    
    public LCRMCredentialInfoHelper(){
        ListofSSD = new List<Source_System_Detail__c>();
        ListofSSDIP = new List<Source_System_Detail__c>();
    }
 /* 
*Need to Add Criterias sourceName for Credential
*filter the SSD records with LCRM_Sales_Org__c must be 'WEST'and Source_System_Account_Number__c not blank.
*This creteria only used for Credential webservice
 */
    public List<Source_System_Detail__c> getSourceSystemDetails(Account acc){
        if(Schema.sObjectType.Source_System_Detail__c.isQueryable())
        ListofSSD = [select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c from Source_System_Detail__c Where Account_Name__c =: acc.id and LCRM_Sales_Org__c =: strSalesOrgVal and Source_System_Account_Number__c!=null and LCRM_Sales_Org__c !=null ];
        System.debug('ListofSSD:-'+ListofSSD);
        return ListofSSD;
    }
    
 // Returning the list of SSD based on the Account ID's sent from Controller for IP Restriction
    
    public List<Source_System_Detail__c> getSourceSystemDetailsIPva(Set<Id> listAccId){
        System.debug('getSourceSystemDetailsIPva:-'+listAccId);
        
        System.debug('--AccId**:-'+listAccId);
        if(Schema.sObjectType.Source_System_Detail__c.isQueryable())
        ListofSSDIP =[Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c from Source_System_Detail__c Where Account_Name__c in :listAccId and Source_System_Account_Number__c!=null];            
        
        System.debug('*** ListofSSDIP **:-'+ListofSSDIP);
        return ListofSSDIP; 
    }
    
    
/*
*Method to logException details
*/   
    public void logException(string strBody, string error, String WebServiceName) {
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName); 
        Integration_Logger__c intLog = new Integration_Logger__c();
        intLog.Object_Name__c = 'Source System Detail';
        intLog.Exception_Message__c = error;
        intLog.Request_Message__c = strBody;
        intLog.Request_Type__c = 'Outbound';
        intLog.Service_Name__c = oWebServiceSettings.name;
        intLog.Object_Id__c = Label.LCRMSourceSystemDetailsID;
        database.insert(intLog,false); 
        System.debug('intLog'+intLog);
    }  
    
/*
*Return Http Request with input parameters
*/
    Public HttpRequest getHttpRequestCred(String WebServiceName,String jsonString){
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);      
        System.debug('oWebServiceSettings:-'+oWebServiceSettings);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(oWebServiceSettings.Endpoint__c);
        request.setMethod('GET');
        String HeaderVal = 'Authorization';
        // Specify the required user name and password to access the endpoint 
        // As well as the header and header information 
        Blob headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        request.setHeader('Content-Type', 'application/json');
        // Header info with remote server user name and password
        request.setHeader(string.escapeSingleQuotes(HeaderVal), authorizationHeader);
        // timeout in milliseconds       
        request.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
        System.debug('jsonString:-'+jsonString);
        if(String.IsNotBlank(jsonString)){
            request.setBody(jsonString);
            System.debug('request:-'+request);
        }
        return request; 
    
    }


}