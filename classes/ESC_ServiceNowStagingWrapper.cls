/**
 * @Description: :
 * ****************************************************************************************
 * This class provides wrapper class for request and response for SN Integration
 * Enterprise Service Cloud ---> ServiceNow Staging
 * ****************************************************************************************
 * @History     : 
 * ---Name ---------------Date-------------
 * Mousumi Panda       ->    13-05-2020 
 * 
 */


public without sharing class ESC_ServiceNowStagingWrapper {

    
//  ------------------------------------------------------------------------------------------------------------------    
    /**
     * @Description This inner class is used to describe the response type for the ServiceNow Staging Object callout.
     */
    public cls_ServiceRequestResponse ServiceRequestResponse;
    public cls_ServiceRequestResponse StatusDetails;
    public class cls_ServiceRequestResponse{
        public String statusCode;   //200
        public String statusMessage;    //success
        public String statusDescription;    //Updated
        public String serviceRequest;   //RITM000111
        public String taskNumber;   //Task10002
    }  
    
    
     public static ESC_ServiceNowStagingWrapper parse(String json){
        return (ESC_ServiceNowStagingWrapper) System.JSON.deserialize(json, ESC_ServiceNowStagingWrapper.class);
    }
    
    static testMethod void testESC_ServiceNowStagingWrapper() {
        String json=        '{'+
        '   "ServiceRequestResponse": {'+
        '       "statusCode": "200",'+
        '       "statusMessage": "success",'+
        '       "serviceRequest": "RITM000111",'+
        '       "taskNumber": "Task10002"'+
        '   }'+
        '}';
        ESC_ServiceNowStagingWrapper obj = parse(json);
        System.assert(obj != null);
    } 
    
   
//  ------------------------------------------------------------------------------------------------------------------
    /**
     * @Description This inner class is used as the request type
     * for POSTing Staging details to the ESI(ServiceNow) that triggers create/update to ESC projects
     */
    public class ServiceNowStagingRequest{
    public cls_BOOMIHeader BOOMIHeader;
    public String sourceSystem; //string
    public String reportKey;    //string
    public String businessArea; //test
    public String source;   //USL
    public String requestType;  //create
    public String description;  //test
    public String sourceLink;   //string
    public String customerNumber;   //string
    public String SLA;  //string
    public String SLAJustification; //string
    public String caseNumber;   //123
    public String quoteAttached;    //string
    public String auditResult;  //string
    public String assignmentGroup;  //string
    public String quoteNumber;  //string
    public String referenceNumber;  //
    public String externalStatus;   //
    public String requestedBy;  //
    public String serviceRequest;   //
    public String taskNumber;
    public String additionalComments;   //
    public cls_extensibleAttributes[] extensibleAttributes;
    }
     public class cls_BOOMIHeader {
        public String applicationId;    //ESCU
        public String transactionId;    //string
        public String messageId;    //
        public String messageHistory;   //string
        public String tracingId;    //string
        public String timeStamp;    //2008-09-29T01:49:45
        public String instanceId;   //string
        public String companyId;    //string
        public String configGroup;  //string
        public String payloadVersion;   //string
        public String postBackURL;  //string
        public String profileId;    //string
    }
     public class cls_extensibleAttributes {
        public String systemIdentifier; //string
        public String key;  //string
        public String value;    //string
    }
    
    /*public static ESC_ServiceNowStagingWrapper  requestParse(String json){
      return (ESC_ServiceNowStagingWrapper)  System.JSON.deserialize(json, ESC_ServiceNowStagingWrapper.class);
    }
 public static ESC_ServiceNowStagingWrapper parse(String json){
        return (ESC_ServiceNowStagingWrapper) System.JSON.deserialize(json, ESC_ServiceNowStagingWrapper.class);
    }*/
  
   static testMethod void testrequestParse() {
        String json=        '{'+
        '   "BOOMIHeader": {'+
        '       "applicationId": "ESCU",'+
        '       "transactionId": "string",'+
        '       "messageId": "",'+
        '       "messageHistory": "string",'+
        '       "tracingId": "string",'+
        '       "timeStamp": "2008-09-29T01:49:45",'+
        '       "instanceId": "string",'+
        '       "companyId": "string",'+
        '       "configGroup": "string",'+
        '       "payloadVersion": "string",'+
        '       "postBackURL": "string",'+
        '       "profileId": "string"'+
        '   },'+
        '   "sourceSystem": "string",'+
        '   "reportKey": "string",'+
        '   "businessArea": "test",'+
        '   "source": "USL",'+
        '   "requestType": "create",'+
        '   "description": "test",'+
        '   "sourceLink": "string",'+
        '   "customerNumber": "string",'+
        '   "SLA": "string",'+
        '   "SLAJustification": "string",'+
        '   "caseNumber": "123",'+
        '   "quoteAttached": "string",'+
        '   "auditResult": "string",'+
        '   "assignmentGroup": "string",'+
        '   "quoteNumber": "string",'+
        '   "referenceNumber": "",'+
        '   "externalStatus": "",'+
        '   "requestedBy": "",'+
        '   "serviceRequest": "",'+
        '   "taskNumber": "",'+
        '   "additionalComments": "",'+
        '   "extensibleAttributes": ['+
        '       {'+
        '           "systemIdentifier": "string",'+
        '           "key": "string",'+
        '           "value": "string"'+
        '       }'+
        '   ]'+
        '   '+
        '   '+
        '}';
        ESC_ServiceNowStagingWrapper obj = parse(json);
        System.assert(obj != null);
    }
}