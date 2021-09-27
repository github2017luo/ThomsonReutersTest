/**
 * Provides helper methods for working with the MDB integration web services
 *
 * @author  John De Santiago
 * @version 2012-06-07
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-06-07   John De Santiago        Created 
 * 2017-03-31   Karthi G                Optimized the code as per JIRA STORY: PS0-1                                                                  
 * =============================================================================
 */
public class MDBIntegrationUtil {
    //Constants
    public static final string UpsertAccountServiceName = 'MDB.UpsertAccountService';
    public static final string UpsertContactServiceName = 'MDB.UpsertContactService';
    
    //Public Methods
    
    /**
     * Generates a unique submission token based on static text and the
     * specified record id
     *
     * @param   recordId    a valid sObject record id
     * @return  a string representing a unique submission token for the specified record id
     */
    public static string generateMDBSubmissionToken(Id recordId) {
        return 'Pending.' + recordId;
    }
    
    /**
     * Initiates a web service command to upsert the specified account information to MDB
     *
     * @param   oUpsertAccountRequest   an instance of an UpsertAccountRequest object
     * @return  an instance of an UpsertAccountResponse object
     */
    public static UpsertAccountResponse upsertAccount(UpsertAccountRequest oUpsertAccountRequest) {
        UpsertAccountResponse oUpsertAccountResponse = new UpsertAccountResponse();
        
        ValidationResult oValidationResult = MDBIntegrationUtil.validateRequest(oUpsertAccountRequest);
        if (oValidationResult.isValid) {
            //Initialize Web Service
            InformaticaCustomerProspectWS.WS_CustProsp_UpsertPort oService = new InformaticaCustomerProspectWS.WS_CustProsp_UpsertPort();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.timeout_x = oUpsertAccountRequest.Timeout.intValue();
            oService.endpoint_x = oUpsertAccountRequest.EndPoint;
            System.debug('upsertAccount.Endpoint: ' + oUpsertAccountRequest.EndPoint);
            
            //Map Request
            InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestElement_element oRequest = new InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTRequestElement_element();
            oRequest.MDBID = oUpsertAccountRequest.MDBId;
            oRequest.SAPID = oUpsertAccountRequest.SAPId;
            oRequest.EXTERNAL_SYSTEM = 'CORE SALESFORCE.COM';
            oRequest.EXTERNAL_SYSTEM_ID = oUpsertAccountRequest.AccountId;
            oRequest.SALES_ORG = oUpsertAccountRequest.SalesOrg;
            oRequest.COMPANY_CODE = oUpsertAccountRequest.CompanyCode;
            oRequest.DIVISION_CODE = oUpsertAccountRequest.DivisionCode;
            oRequest.DISTRIBUTION_CHANNEL = oUpsertAccountRequest.DistributionChannel;
            oRequest.TITLE = oUpsertAccountRequest.Title;
            oRequest.NAME_LINE1 = oUpsertAccountRequest.Name1;
            oRequest.NAME_LINE2 = oUpsertAccountRequest.Name2;
            oRequest.NAME_LINE3 = oUpsertAccountRequest.Name3;
            oRequest.ADDRESS_LINE1 = oUpsertAccountRequest.AddressLine1;
            oRequest.ADDRESS_LINE2 = oUpsertAccountRequest.AddressLine2;
            oRequest.ADDRESS_LINE3 = oUpsertAccountRequest.AddressLine3;
            oRequest.POBOX = oUpsertAccountRequest.POBox;
            oRequest.CITY = oUpsertAccountRequest.City;
            //oRequest.STATE = oUpsertAccountRequest.State;
            
             /* MCL-1576 Rajashree  */
            /* System.debug('oUpsertAccountRequest.State'+oUpsertAccountRequest.State);
             String strBillState = oUpsertAccountRequest.State;            
                if(strBillState.length() == 2){
                   oRequest.STATE = strBillState;
                }
                else if(strBillState.length()  > 2){
                   oRequest.STATE = Country_Region__c.getInstance(strBillState).Region_Code__c;          
                }
                
                */
            /* MCL 1576 Ends  */
            oRequest.ZIP_CODE = oUpsertAccountRequest.PostalCode;
            oRequest.COUNTRY = oUpsertAccountRequest.Country;
            oRequest.PHONE = oUpsertAccountRequest.Phone;
            oRequest.PHONE_EXT = oUpsertAccountRequest.PhoneExt;
            oRequest.PHONE_COUNTRY_CODE = oUpsertAccountRequest.PhoneCountryCode;
            oRequest.FAX = oUpsertAccountRequest.Fax;
            oRequest.INDUSTRY = oUpsertAccountRequest.Industry;
            oRequest.CUSTOMER_GROUP = oUpsertAccountRequest.CustomerGroup;
            oRequest.CUSTOMER_TYPE = oUpsertAccountRequest.CustomerType;
            oRequest.ACCOUNT_GROUP_CODE = oUpsertAccountRequest.AccountGroupCode;
            oRequest.FROZEN_MKT_SEGMENT = oUpsertAccountRequest.FrozenMKTSegment;
            oRequest.MARKET_SEGMENT = oUpsertAccountRequest.MarkgeSegment;
            System.debug('upsertAccount.Request: ' + oRequest);
            
            try {
                //Submit Request
                InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element oResponse = oService.WS_CustProsp_UpsertOperation(oRequest);
                System.debug('upsertAccount.Response: ' + oResponse);
                
                oUpsertAccountResponse.parse(oResponse);
            }
            catch (CalloutException calloutException) {
                oUpsertAccountResponse.parse(calloutException);
            }
        }
        else {
            oUpsertAccountResponse.parse(oValidationResult);
        }
        
        return oUpsertAccountResponse;
    }
    
    /**
     * Initiates a web service command to upsert the specified contact information to MDB
     *
     * @param   oUpsertContactRequest   an instance of an UpsertContactRequest object
     * @return  an instance of an UpsertContactResponse object
     */
    public static UpsertContactResponse upsertContact(UpsertContactRequest oUpsertContactRequest) {
        UpsertContactResponse oUpsertContactResponse = new UpsertContactResponse();
        
        ValidationResult oValidationResult = MDBIntegrationUtil.validateRequest(oUpsertContactRequest);
        if (oValidationResult.isValid) {
            //Initialize Web Service
            InformaticaContactProspectWS.WS_MDB_Contact_UpsertPort oService = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertPort();
            oService.inputHttpHeaders_x = new Map<String, String>();
            oService.timeout_x = oUpsertContactRequest.Timeout.intValue();
            oService.endpoint_x = oUpsertContactRequest.EndPoint;
            System.debug('upsertContact.Endpoint: ' + oUpsertContactRequest.EndPoint);
            
            //Map Request
            InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestElement_element oRequest = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestElement_element();
            oRequest.MDB_CUSTID = oUpsertContactRequest.MDBAccountId;
            oRequest.MDB_CONTACTID = oUpsertContactRequest.MDBContactId;
            oRequest.SAP_CONTACTID = oUpsertContactRequest.SAPContactId;
            oRequest.EXTERNAL_ID = oUpsertContactRequest.ContactId;
            oRequest.EXTERNAL_SYSTEM = 'CORE SALESFORCE.COM';
            oRequest.NAME_TITLE = oUpsertContactRequest.Title;
            oRequest.NAME_LAST = oUpsertContactRequest.LastName;
            oRequest.NAME_FIRST = oUpsertContactRequest.FirstName;
            oRequest.PHONE = oUpsertContactRequest.Phone;
            oRequest.FAX = oUpsertContactRequest.Fax;
            oRequest.NON_SAP_EMAIL = oUpsertContactRequest.Email;
            oRequest.ONLINE_FLAG = oUpsertContactRequest.OnlineFlag;
            oRequest.CONTACT_DEPARTMENT = oUpsertContactRequest.Department;
            oRequest.JOB_FUNCTION = oUpsertContactRequest.JobFunction;
            oRequest.SOURCE_ID = 'Salesforce.com';
            oRequest.CONTACT_EXTERNAL_SYSTEMS = oUpsertContactRequest.ContactType;
            oRequest.WORK_DIRECT = oUpsertContactRequest.WorkDirect;
            oRequest.HOME_PHONE = oUpsertContactRequest.HomePhone;
            oRequest.WORK_FAX = oUpsertContactRequest.WorkFax;
            oRequest.ASSISTANT_PHONE = oUpsertContactRequest.AssistantPhone;
            oRequest.MOBILE = oUpsertContactRequest.Mobile;
            System.debug('SKG:upsertContact.Request: ' + oRequest);
            
            try {
                //Submit Request
                InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element oResponse = oService.WS_MDB_Contact_UpsertOperation(oRequest);
                System.debug('upsertContact.Response: ' + oResponse);
                
                oUpsertContactResponse.parse(oResponse);
            }
            catch (CalloutException calloutException) {
                oUpsertContactResponse.parse(calloutException);
            }
        }
        else {
            oUpsertContactResponse.parse(oValidationResult);
        }
        
        return oUpsertContactResponse;
    }
    
    //Private Methods
    
    /**
     * Validates that all required information has been supplied for the specified request
     * 
     * @param   oRequest an instance of a Request object to validate
     * @returns a instance of a ValidationResult object representing the results of the validation
     */
    private static ValidationResult validateRequest(Request oRequest) {
        ValidationResult oValidationResult = new ValidationResult();
        oValidationResult.IsValid = true;
        
        if (oRequest != null) {
            //Validate Request Credentials
            boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.EndPoint);
            
            if (isMissingEndPoint) {
                oValidationResult.IsValid = false;
                oValidationResult.Failures.add(System.Label.InvalidOrMissingCredentials);
            }
            
            //Validate Timeout Limit
            boolean isTimeoutValid = (oRequest.Timeout > 0);
            
            if (!isTimeoutValid) {
                oValidationResult.IsValid = false;
                oValidationResult.Failures.Add(System.Label.InvalidTimeoutValue);   
            }
        }
        else {
            oValidationResult.IsValid = false;
            oValidationResult.Failures.add('Invalid Request Object. Request can not be null');
        }
        
        return oValidationResult;   
    }
    
    //Internal Web Service Requests
    
    /**
     * Base request class for web service calls to MDB
     */
    public virtual class Request {
        public string Endpoint {get;set;}
        public decimal Timeout {get;set;}
        
        public Request() {
            this.Endpoint = '';
            this.Timeout = (10 * 1000); //10 Seconds
        }
    }
    
    /**
     * Request information for an upsert account web service callout to MDB
     */
    public class UpsertAccountRequest extends Request {
        public Id AccountId {get;set;}
        public string MDBId {get;set;}
        public string SAPId {get;set;}
        public string SalesOrg {get;set;}
        public string CompanyCode {get;set;}
        public string DivisionCode {get;set;}
        public string DistributionChannel {get;set;}
        public string Title {get;set;}
        public string Name1 {get;set;}
        public string Name2 {get;set;}
        public string Name3 {get;set;}
        public string AddressLine1 {get;set;}
        public string AddressLine2 {get;set;}
        public string AddressLine3 {get;set;}
        public string POBox {get;set;}
        public string City {get;set;}
        public string State {get;set;}
        public string PostalCode {get;set;}
        public string Country {get;set;}
        public string Phone {get;set;}
        public string PhoneExt {get;set;}
        public string PhoneCountryCode {get;set;}
        public string Fax {get;set;}
        public string Industry {get;set;}
        public string CustomerGroup {get;set;}
        public string CustomerType {get;set;}
        public string AccountGroupCode {get;set;}
        public string FrozenMKTSegment {get;set;}
        public string MarkgeSegment {get;set;}
    }
    
    /**
     * Request information for an upsert contact web service callout to MDB
     */
    public class UpsertContactRequest extends Request {
        public string ContactId {get;set;}
        public string MDBAccountId {get;set;}
        public string MDBContactId {get;set;}
        public string SAPContactId {get;set;}
        public string Title {get;set;}
        public string LastName {get;set;}
        public string FirstName {get;set;}
        public string Phone {get;set;}
        public string Fax {get;set;}
        public string Email {get;set;}
        public string OnlineFlag {get;set;}
        public string Department {get;set;}
        public string JobFunction {get;set;}
        public string SourceId {get;set;}
        public string ContactType {get;set;}
        public string WorkDirect {get;set;}
        public string HomePhone {get;set;}
        public string WorkFax {get;set;}
        public string AssistantPhone {get;set;}
        public string Mobile {get;set;}
        
    }
    
    //Internal Web Service Responses
    
    /**
     * Base response class for web service calls to MDB
     */
    public virtual class Response {
        public boolean IsSuccess {get;set;}
        public string ErrorMessage {get;set;}
        
        public Response() {
            this.IsSuccess = true;
            this.ErrorMessage = '';
        }
        
        public void parse(Exception oException) {
            this.IsSuccess = false;
            this.ErrorMessage = oException.getMessage();
        }
        
        public void parse(ValidationResult oValidationResult) {
            this.IsSuccess = oValidationResult.isValid;
            this.ErrorMessage = oValidationResult.toString();
        }
    }
    
    /**
     * Response information for an upsert account callout to MDB
     */
    public class UpsertAccountResponse extends Response {
        public string MDBAccountId {get;set;}
        
        public void parse(InformaticaCustomerProspectWS.WS_CUSTPROSP_UPSERTResponseElement_element oResponse) {
            if (oResponse != null) {
                this.MDBAccountId = oResponse.MDBID;
            }
            
            if (AppUtil.isEmpty(this.MDBAccountId)) {
                this.IsSuccess = false;
                // this.ErrorMessage = 'Unable to upsert the requested account to MDB'; //Replaced with Custom Label as part of S2E Optimization
                this.ErrorMessage = Label.MDBIntegUtilError;
            }
        }
    }
    
    /**
     * Response information for an upsert contact callout to MDB
     */
    public class UpsertContactResponse extends Response {
        public string MDBAccountId {get;set;}
        public string MDBContactId {get;set;}
        
        public void parse(InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element oResponse) {
            if (oResponse != null) {
                this.MDBAccountId = oResponse.MDB_CUSTID;
                this.MDBContactId = oResponse.MDB_CONTACTID;
            }
            
            if (AppUtil.isEmpty(this.MDBContactId)) {
                this.IsSuccess = false;
               // this.ErrorMessage = 'Unable to upsert the requested account to MDB'; //Replaced with Custom Label as part of S2E Optimization
                this.ErrorMessage = Label.MDBIntegUtilError;
            }
        }
    }   
}