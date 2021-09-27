/**
 * Provides methods for submitting requests to the Data Services web service
 * <p>
 * Note: As a best practice only this class and it's associated test class should
 * have a dependency on the DataServicesWS class. This will ease any future
 * modifications to the web service wsdl and abstract the web service interface 
 * from the rest of the application.
 *
 * @author	John De Santiago
 * @version	2011-03-09
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date			Name					Description
 * 2011-03-09   John De Santiago        Created
 * 2011-06-23	Nick Cook				Modified slightly to return falut desc
 										from CleanseAddress utility method
 									 	so it can be displayed in the UI.
 * =============================================================================
 */
public without sharing class DataServices {
	//Constants
	public static final string WEB_SERVICE_NAME = 'DataServices';
	
	//Constructors
	
	/**
	 * Default Constructor
	 */
	public DataServices() {

	}
	
	//Static Methods
	
	/**
	 * Utility method that cleanses the supplied address information utilizing the Data Services Web Service.
	 *
	 * @param	oAddressInfo	the address information to cleanse
	 * @return	an DataServices.AddressInfo object representing a cleansed address
	 */
	public static DataServices.AddressInfo cleanseAddress(DataServices.AddressInfo oAddressInfo) {
		DataServices.AddressInfo oCleansedAddress = new DataServices.AddressInfo();
		
		if (oAddressInfo != null) {
			DataServices oDataServices = new DataServices();
			
			WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(DataServices.WEB_SERVICE_NAME);
	    	
	    	DataServices.LoginRequest oLoginRequest = new DataServices.LoginRequest();
			oLoginRequest.EndPoint = oWebServiceSettings.Endpoint__c;
			oLoginRequest.Username = oWebServiceSettings.Username__c;
			oLoginRequest.Password = oWebServiceSettings.Password__c;
			oLoginRequest.Timeout = (oWebServiceSettings.Timeout__c * 1000); //Convert seconds to milliseconds
			
			DataServices.Session oSession = oDataServices.submitLoginRequest(oLoginRequest);
			if (oSession.IsValid) {
				DataServices.AddressCleanseRequest oRequest = new DataServices.AddressCleanseRequest();
				oRequest.Session = oSession;
				oRequest.Name1 = oAddressInfo.Name;
				oRequest.Street = oAddressInfo.Street;
				oRequest.City = oAddressInfo.City;
				oRequest.State = oAddressInfo.State;
				oRequest.PostalCode = oAddressInfo.PostalCode;
				oRequest.County = oAddressInfo.County;
				oRequest.Country = oAddressInfo.Country;	
				
				DataServices.AddressCleanseResponse oResponse = oDataServices.submitAddressCleanseRequest(oRequest);
				if (oResponse.IsSuccess == true) {
					oCleansedAddress.IsCleansed = true;
				}
				else {
					oCleansedAddress.IsCleansed = false;
					oCleansedAddress.ErrorMessage = oResponse.STATUS_FAULT_DESC;
				}	
				oCleansedAddress.Street = oResponse.Street;
				oCleansedAddress.City = oResponse.City;
				oCleansedAddress.State = oResponse.State;
				oCleansedAddress.PostalCode = oResponse.PostalCode;
				oCleansedAddress.County = oResponse.County;
				oCleansedAddress.Country = oResponse.Country;
				oCleansedAddress.SECONDARY_RANGE = oResponse.SECONDARY_RANGE;
				oCleansedAddress.STREET_NAME = oResponse.STREET_NAME;
				oCleansedAddress.STREET_POST_DIR = oResponse.STREET_POST_DIR;
				oCleansedAddress.STREET_PRE_DIR = oResponse.STREET_PRE_DIR;
				oCleansedAddress.STREET_RANGE = oResponse.STREET_RANGE;
				oCleansedAddress.STREET_TYPE = oResponse.STREET_TYPE;
			}
		}
		
		return oCleansedAddress;
	}
	
	/**
	 * Parses a street address and returns only the street name portion
	 * i.e. 123 Some Street -> SOME STREET
	 *
	 * @param	sStreetAddress	the street address to parse
	 * @return	the street name part of the specified street address, otherwise returns an empty string
	 */
	public static string parseStreetName(string sStreetAddress) {
		string sParsedStreetName = '';
		
		if (!AppUtil.isEmpty(sStreetAddress)) {
			sParsedStreetName = sStreetAddress.toUpperCase();
			sParsedStreetName = sParsedStreetName.replaceAll('^[0-9]* ', '');
			sParsedStreetName = sParsedStreetName.trim();
			sParsedStreetName = AppUtil.fixedWidthString(sParsedStreetName, 30);
		}
		
		return sParsedStreetName;
	}
	
	//Public Methods
	
	/**
	 * Submits the supplied login request to the DataServices Web Service
	 *
	 * @param	oRequest	the request information to submit for connecting to the web service
	 * @return	a DataServices.Session object representing the connection session
	 */
	public DataServices.Session submitLoginRequest(DataServices.LoginRequest oRequest) {
		DataServices.Session oSession = new DataServices.Session();
		
		//Validate Request
		ValidationResult oValidation = validateLoginRequest(oRequest);
		
		if (oValidation.IsValid) {
			oSession.EndPoint = oRequest.EndPoint;
			oSession.Timeout = oRequest.Timeout;
			
			//Initialize Web Service
			DataServicesWS.Service oService = new DataServicesWS.Service();
			oService.inputHttpHeaders_x = new Map<String, String>();
			oService.timeout_x = oRequest.Timeout.intValue();
			oService.endpoint_x = oRequest.EndPoint;
			
			try {
				if (Test.isRunningTest()) {
					//Get Mock Response
					//UnitTest oUnitTest = UnitTest.getInstance();
					//object oMockResponse = oUnitTest.MockWebServiceResponse.get('LoginRequest');
					//if (oMockResponse instanceof DataServices.Session) {
					//	oSession = (DataServices.Session) oMockResponse;
					//}
					//else if (oMockResponse instanceof Exception) {
					//	throw (Exception) oMockResponse;
					//}
					oSession.SessionId = 'Unit-Test-Session-Id';
				}
				else {
					//Execute Web Service Callout
					oSession.SessionId = oService.Logon(oRequest.Username, oRequest.Password);
				}
	        }
	        catch (Exception oException) {
	        	System.Debug(oException);
	        	oSession.SessionId = null;
	        }
		}
		else {
			throw new DataServices.ValidationException(oValidation.toString());
		}
		
		return oSession;
	}
	
	/**
	 * Submits the supplied address cleanse request to the DataServices Web Service
	 *
	 * @param	oRequest	the request information to submit for address cleansing
	 * @return	a DataServices.AddressCleanseResponse object representing the results of the request
	 */
	public DataServices.AddressCleanseResponse submitAddressCleanseRequest(DataServices.AddressCleanseRequest oRequest) {
		DataServices.AddressCleanseResponse oResponse = new DataServices.AddressCleanseResponse();
		
		//Validate Request
		ValidationResult oValidation = validateRequest(oRequest);
		
		if (oValidation.IsValid) {
			//Initialize Web Service
			DataServicesWS.Service oService = new DataServicesWS.Service();
			oService.inputHttpHeaders_x = new Map<String, String>();
			oService.timeout_x = oRequest.Session.Timeout.intValue();
			oService.endpoint_x = oRequest.Session.EndPoint;
			
			//Map Session Id
			oService.Session = new DataServicesWS.Session_element();
			oService.Session.SessionID = oRequest.Session.SessionId;
			
			//Map Address Cleanse Request
			DataServicesWS.AddressInputRecord_element oAddressInputRecord = new DataServicesWS.AddressInputRecord_element();
			oAddressInputRecord.Id = oRequest.Id;
	        oAddressInputRecord.Name1 = oRequest.Name1;
	        oAddressInputRecord.Name2 = oRequest.Name2;
	        oAddressInputRecord.Street = oRequest.Street;
	        oAddressInputRecord.Street2 = oRequest.Street2;
	        oAddressInputRecord.City = oRequest.City;
	        oAddressInputRecord.State = oRequest.State;
	        oAddressInputRecord.PostalCode = oRequest.PostalCode;
	        oAddressInputRecord.County = oRequest.County;
	        oAddressInputRecord.Country = oRequest.Country;
	        oAddressInputRecord.Suggestion_Reply1 = oRequest.Suggestion_Reply1;
	        oAddressInputRecord.Suggestion_Reply2 = oRequest.Suggestion_Reply2;
	        oAddressInputRecord.Suggestion_Reply3 = oRequest.Suggestion_Reply3;
	        oAddressInputRecord.Suggestion_Reply4 = oRequest.Suggestion_Reply4;
	        oAddressInputRecord.Suggestion_Reply5 = oRequest.Suggestion_Reply5;
	        oAddressInputRecord.Suggestion_Selection = oRequest.Suggestion_Selection;
	        
			try {
				if (Test.isRunningTest()) {
					//Get Mock Response
					//UnitTest oUnitTest = UnitTest.getInstance();
					//object oMockResponse = oUnitTest.MockWebServiceResponse.get('AddressCleanseRequest');
					//if (oMockResponse instanceof DataServices.AddressCleanseResponse) {
					//	oResponse = (DataServices.AddressCleanseResponse) oMockResponse;
					//}
					//else if (oMockResponse instanceof Exception) {
					//	throw (Exception)oMockResponse;
					//}

					DataServicesWS.AddressOutputRecord_element oAddrOutput = new DataServicesWS.AddressOutputRecord_element();
					oAddrOutput.Name1 = 'Unit Test';
					oAddrOutput.City = 'LAKEVILLE';
					oAddrOutput.State = 'MN';
					oAddrOutput.PostalCode = '55044';
					oAddrOutput.STATUS_FAULT_CODE = 'S';
		
					//DataServices.AddressCleanseResponse oResponse = new DataServices.AddressCleanseResponse();
					oResponse.parse(oAddrOutput);
				}
				else {
					//Execute Web Service Callout
					oResponse.parse(oService.Address_sf(oAddressInputRecord));
				}
	        }
	        catch (Exception oException) {
	        	oResponse.parse(oException);
	        }
		}
		else {
			throw new DataServices.ValidationException(oValidation.toString());
		}
		
		return oResponse;
	}
	
	/**
	 * Submits the supplied address cleanse request to the DataServices Web Service
	 *
	 * @param	oAccountDeDupeRequest	the request information to submit for account deduplication
	 * @return	a DataServices.AccountDeDupeResponse object representing the results of the request
	 */
	public DataServices.AccountDeDupeResponse submitAccountDeDupeRequest(DataServices.AccountDeDupeRequest oRequest) {
		DataServices.AccountDeDupeResponse oResponse = new DataServices.AccountDeDupeResponse();
		 
		//Validate Request
		ValidationResult oValidation = validateRequest(oRequest);
		
		if (oValidation.IsValid) {
			//Initialize Web Service
			DataServicesWS.Service oService = new DataServicesWS.Service();
			oService.inputHttpHeaders_x = new Map<String, String>();
			oService.timeout_x = oRequest.Session.Timeout.intValue();
			oService.endpoint_x = oRequest.Session.EndPoint;
			
			//Map Session Id
			oService.Session = new DataServicesWS.Session_element();
			oService.Session.SessionID = oRequest.Session.SessionId;
			
			//Map Account DeDupe Request
			List<DataServicesWS.DeDupeAccountInputRecord_element> listAccountDeDupeRecords = new List<DataServicesWS.DeDupeAccountInputRecord_element>();
			for (DataServices.AccountDetail oAccountDetail : oRequest.Accounts) {
				DataServicesWS.DeDupeAccountInputRecord_element oAccountDeDupeRecord = new DataServicesWS.DeDupeAccountInputRecord_element();
				
				oAccountDeDupeRecord.Id = oAccountDetail.Id;
		        oAccountDeDupeRecord.Name1 = oAccountDetail.Name1;
		        oAccountDeDupeRecord.Name2 = oAccountDetail.Name2;
		        oAccountDeDupeRecord.Street = oAccountDetail.Street;
		        oAccountDeDupeRecord.Street2 = oAccountDetail.Street2;
		        oAccountDeDupeRecord.City = oAccountDetail.City;
		        oAccountDeDupeRecord.State = oAccountDetail.State;
		        oAccountDeDupeRecord.PostalCode = oAccountDetail.PostalCode;
		        oAccountDeDupeRecord.County = oAccountDetail.County;
		        oAccountDeDupeRecord.Country = oAccountDetail.Country;
		        oAccountDeDupeRecord.Sales_Org = oAccountDetail.Sales_Org;
		        oAccountDeDupeRecord.STREET_RANGE = oAccountDetail.STREET_RANGE;
		        oAccountDeDupeRecord.STREET_NAME = oAccountDetail.STREET_NAME;
		        oAccountDeDupeRecord.STREET_PRE_DIR = oAccountDetail.STREET_PRE_DIR;
		        oAccountDeDupeRecord.STREET_POST_DIR = oAccountDetail.STREET_POST_DIR;
		        oAccountDeDupeRecord.STREET_TYPE = oAccountDetail.STREET_TYPE;
		        oAccountDeDupeRecord.SECONDARY_RANGE = oAccountDetail.SECONDARY_RANGE;
		        oAccountDeDupeRecord.DEDUP_TOKEN = oAccountDetail.DEDUP_TOKEN;
		        oAccountDeDupeRecord.MASTER = oAccountDetail.MASTER;
		        
				listAccountDeDupeRecords.add(oAccountDeDupeRecord);	
			}
			
			try {
				if (Test.isRunningTest()) {
					/*Get Mock Response
					 Setup Mock response for test case */
					List<DataServicesWS.DeDupeAccountOutputRecord_element> oAccountDeDupeOutput = 
							new List<DataServicesWS.DeDupeAccountOutputRecord_element>();
					
					DataServicesWS.DeDupeAccountOutputRecord_element oAccountDedupRecord = 
							new DataServicesWS.DeDupeAccountOutputRecord_element(); 		
					oAccountDedupRecord.Id = 'Id123';
			        oAccountDedupRecord.Name1 = 'Name1 Test';
			        oAccountDedupRecord.Name2 = 'Name2 Test';
			        oAccountDedupRecord.Street = '123 Some Test ST';
			        oAccountDedupRecord.Street2 = 'STE 123';
			        oAccountDedupRecord.City = 'OSSEO';
			        oAccountDedupRecord.State = 'MN';
			        oAccountDedupRecord.PostalCode = '55311';
			        oAccountDedupRecord.County = 'HENNEPIN';
			        oAccountDedupRecord.Country = 'USA';

			        oAccountDedupRecord.DEDUP_TOKEN = 'SOMETOKEN123';
			        oAccountDedupRecord.MASTER = 'Y';
			        oAccountDeDupeOutput.add(oAccountDedupRecord);	
					
					//adding record again as non-master					
					oAccountDedupRecord.MASTER = 'N';
					oAccountDeDupeOutput.add(oAccountDedupRecord);	
								
					oResponse.parse(oAccountDeDupeOutput);					
				}
				else {
					//Execute Web Service Callout
					oResponse.parse(oService.DeDupe_Account_sf(listAccountDeDupeRecords));
				}
	        }
	        catch (Exception oException) {
	        	oResponse.parse(oException);
	        }
		}
		else {
			throw new DataServices.ValidationException(oValidation.toString());
		}
		
		return oResponse;
	}
	
	/**
	 * Submits the supplied address cleanse request to the DataServices Web Service
	 *
	 * @param	oContactDeDupeRequest	the request information to submit for contact deduplication
	 * @return	a DataServices.ContactDeDupeResponse object representing the results of the request
	 */
	public DataServices.ContactDeDupeResponse submitContactDeDupeRequest(DataServices.ContactDeDupeRequest oRequest) {
		DataServices.ContactDeDupeResponse oResponse = new DataServices.ContactDeDupeResponse();
		
		//Validate Request
		ValidationResult oValidation = validateRequest(oRequest);
		
		if (oValidation.IsValid) {
			//Initialize Web Service
			DataServicesWS.Service oService = new DataServicesWS.Service();
			oService.inputHttpHeaders_x = new Map<String, String>();
			oService.timeout_x = oRequest.Session.Timeout.intValue();
			oService.endpoint_x = oRequest.Session.EndPoint;
			
			//Map Session Id
			oService.Session = new DataServicesWS.Session_element();
			oService.Session.SessionID = oRequest.Session.SessionId;
			
			//Map Contact DeDupe Request
			List<DataServicesWS.DeDupeContactInputRecord_element> listContactDeDupeRecords = new List<DataServicesWS.DeDupeContactInputRecord_element>();
			for (DataServices.ContactDetail oContactDetail : oRequest.Contacts) {
				DataServicesWS.DeDupeContactInputRecord_element oContactDeDupeRecord = new DataServicesWS.DeDupeContactInputRecord_element();
				
				oContactDeDupeRecord.Id = oContactDetail.Id;
		        oContactDeDupeRecord.AccountId = oContactDetail.AccountId;
		        oContactDeDupeRecord.FirstName = oContactDetail.FirstName;
		        oContactDeDupeRecord.LastName = oContactDetail.LastName;
		        oContactDeDupeRecord.Street = oContactDetail.Street;
		        oContactDeDupeRecord.Street2 = oContactDetail.Street2;
		        oContactDeDupeRecord.City = oContactDetail.City;
		        oContactDeDupeRecord.State = oContactDetail.State;
		        oContactDeDupeRecord.PostalCode = oContactDetail.PostalCode;
		        oContactDeDupeRecord.County = oContactDetail.County;
		        oContactDeDupeRecord.Country = oContactDetail.Country;
		        oContactDeDupeRecord.Contact_Role = oContactDetail.Contact_Role;
		        oContactDeDupeRecord.STREET_RANGE = oContactDetail.STREET_RANGE;
		        oContactDeDupeRecord.STREET_NAME = oContactDetail.STREET_NAME;
		        oContactDeDupeRecord.STREET_PRE_DIR = oContactDetail.STREET_PRE_DIR;
		        oContactDeDupeRecord.STREET_POST_DIR = oContactDetail.STREET_POST_DIR;
		        oContactDeDupeRecord.STREET_TYPE = oContactDetail.STREET_TYPE;
		        oContactDeDupeRecord.SECONDARY_RANGE = oContactDetail.SECONDARY_RANGE;
		        oContactDeDupeRecord.DEDUP_TOKEN = oContactDetail.DEDUP_TOKEN;
		        oContactDeDupeRecord.MASTER = oContactDetail.MASTER;
		        
				listContactDeDupeRecords.add(oContactDeDupeRecord);	
			}
			
			try {
				if (Test.isRunningTest()) {
					//Get Mock Response
					object oMockResponse = UnitTest.MockWebServiceResponse.get('ContactDeDupeRequest');
					if (oMockResponse instanceof DataServices.ContactDeDupeResponse) {
						oResponse = (DataServices.ContactDeDupeResponse) oMockResponse;
					}
					else if (oMockResponse instanceof Exception) {
						throw (Exception)oMockResponse;
					}
				}
				else {
					//Execute Web Service Callout
					oResponse.parse(oService.DeDupe_Contact_sf(listContactDeDupeRecords));
				}
	        }
	        catch (Exception oException) {
	        	oResponse.parse(oException);
	        }
		}
		else {
			throw new DataServices.ValidationException(oValidation.toString());
		}
		
		return oResponse;
	}
	
	//Private Methods	
	
	/**
	 * Validates that all required fields are populated for the specified DataServices.Request
	 *
	 * @param	oRequest	an instance of a request that extends the DataServices.Request base class
	 * @return	an instance of a ValidationResult representing the results of the validation test
	 */
	private ValidationResult validateLoginRequest(DataServices.LoginRequest oRequest) {
		ValidationResult oValidation = new ValidationResult();
		oValidation.IsValid = true;
		
		if (oRequest != null) {
			//Validate Request Credentials
			boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.EndPoint);
			boolean isMissingUsername = AppUtil.isEmpty(oRequest.Username);
			boolean isMissingPassword = AppUtil.isEmpty(oRequest.Password);
			
			if (isMissingEndpoint || isMissingUserName || isMissingPassword) {
				oValidation.IsValid = false;
				oValidation.Failures.add(System.Label.InvalidOrMissingCredentials);
			}
			
			//Validate Timeout Limit
			boolean isTimeoutValid = (oRequest.Timeout > 0);
			
			if (!isTimeoutValid) {
				oValidation.IsValid = false;
				oValidation.Failures.Add(System.Label.InvalidTimeoutValue);	
			}
		}
		else {
			oValidation.IsValid = false;
			oValidation.Failures.add('Invalid Request Object. Request can not be null');
		}
		
		return oValidation;
	}
	
	/**
	 * Validates that all required fields are populated for the specified DataServices.Request
	 *
	 * @param	oRequest	an instance of a request that extends the DataServices.Request base class
	 * @return	an instance of a ValidationResult representing the results of the validation test
	 */
	private ValidationResult validateRequest(DataServices.Request oRequest) {
		ValidationResult oValidation = new ValidationResult();
		oValidation.IsValid = true;
		
		if (oRequest != null) {
			//Validate Request Credentials
			boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.Session.EndPoint);
			boolean isMissingSessionId = AppUtil.isEmpty(oRequest.Session.SessionId);
			
			if (isMissingEndPoint || isMissingSessionId) {
				oValidation.IsValid = false;
				oValidation.Failures.add(System.Label.InvalidOrMissingCredentials);
			}
			
			//Validate Timeout Limit
			boolean isTimeoutValid = (oRequest.Session.Timeout > 0);
			
			if (!isTimeoutValid) {
				oValidation.IsValid = false;
				oValidation.Failures.Add(System.Label.InvalidTimeoutValue);	
			}
		}
		else {
			oValidation.IsValid = false;
			oValidation.Failures.add('Invalid Request Object. Request can not be null');
		}
		
		return oValidation;
	}
	
	//Internal Class
	
	/**
	 * Validation Exception
	 */
	public class ValidationException extends Exception{}
	
	/**
	 * Data structure representing supported address information
	 */
	public class AddressInfo {
		public boolean IsCleansed {get;set;}
		public string Name {get;set;}
		public string Street {get;set;}
		public string City {get;set;}
		public string State {get;set;}
		public string PostalCode {get;set;}
		public string County {get;set;}
		public string Country {get;set;}
		public string ErrorMessage{get;set;}
		public string STREET_RANGE {get;set;}
        public string STREET_NAME {get;set;}
        public string STREET_PRE_DIR {get;set;}
        public string STREET_POST_DIR {get;set;}
        public string STREET_TYPE {get;set;}
        public string SECONDARY_RANGE {get;set;}
        
		public AddressInfo() {
			IsCleansed = false;
		}
	}
	
	/**
	 * Data structure representing a Data Services Login request
	 */
	public class LoginRequest {
		public string EndPoint {get;set;}
		public string Username {get;set;}
		public string Password {get;set;}
		public decimal Timeout {get;set;}
	}
	
	/**
	 * Data structure representing a data services session
	 */
	public class Session {
		public string EndPoint {get;set;}
		public string SessionId {get;set;}
		public decimal Timeout {get;set;}
		
		public boolean IsValid {
			get {return !AppUtil.isEmpty(this.SessionId);}
		}
	}
	
	/**
	 * Virtual class representing a base Request
	 */
	public virtual class Request {
		public DataServices.Session Session {get;set;}
		
		public Request() {
			Session = new DataServices.Session();
		}
	}
	
	/**
	 * Virtual class representing a base Response
	 */
	public virtual class Response {
		public boolean IsSuccess {get;set;}
		public string SessionId {get;set;}
		public string ErrorMessage {get;set;}
		
		public Response() {
			IsSuccess = false;
		}
		
		public void Parse(Exception oException) {
			IsSuccess = false;
			ErrorMessage = oException.getMessage();
		}
	}
	
	/**
	 * Data structure representing an Address Cleanse Request
	 */
	public class AddressCleanseRequest extends DataServices.Request 
	{
        public string Id  {get;set;}
        public string Name1 {get;set;}
        public string Name2 {get;set;}
        public string Street {get;set;}
        private string Street2 {get;set;}
        public string City {get;set;}
        public string State {get;set;}
        public string PostalCode {get;set;}
        public string County {get;set;}
        public string Country {get;set;}
        private string Suggestion_Reply1 {get;set;}
        private string Suggestion_Reply2 {get;set;}
        private string Suggestion_Reply3 {get;set;}
        private string Suggestion_Reply4 {get;set;}
        private string Suggestion_Reply5 {get;set;}
        private string Suggestion_Selection {get;set;}
	}
	
	/**
	 * Data structure representing an Address Cleanse Response
	 */
	public class AddressCleanseResponse extends DataServices.Response 
	{
		public string Id {get;set;}
        public string Name1 {get;set;}
        public string Name2 {get;set;}
        public string Street {get;set;}
        public string Street2 {get;set;}
        public string City {get;set;}
        public string State {get;set;}
        public string PostalCode {get;set;}
        public string County {get;set;}
        public string Country {get;set;}
        public string SUGGESTION_COUNT {get;set;}
        public string SUGGESTION_TYPE {get;set;}
        public string SUGGESTION_DATA_TYPE {get;set;}
        public string SUGGESTION_STATUS {get;set;}
        public string SUGGESTION_WARNING {get;set;}
        public string SUGGESTION_ERROR {get;set;}
        public string SUGGESTION_ERROR_NUMBER {get;set;}
        public string SUGGESTION_ERROR_DESC {get;set;}
        public string SUGGESTION_LIST {get;set;}
        public string SUGGESTION_STATUS_USCA {get;set;}
        public string SUGGESTION_ERROR_USCA {get;set;}
        public string SUGGESTION_COUNT_USCA {get;set;}
        public string SUGGESTION_LIST_USCA {get;set;}
        public string PRIMARY_SECONDARY_ADDRESS {get;set;}
        public string PRIMARY_ADDRESS {get;set;}
        public string SECONDARY_ADDRESS {get;set;}
        public string DUAL_PRIMARY_SECONDARY_ADDRESS {get;set;}
        public string DUAL_PRIMARY_ADDRESS {get;set;}
        public string DUAL_SECONDARY_ADDRESS {get;set;}
        public string STATUS_FAULT_CODE {get;set;}
        public string STATUS_FAULT_DESC {get;set;}
        public string STREET_RANGE {get;set;}
        public string STREET_NAME {get;set;}
        public string STREET_PRE_DIR {get;set;}
        public string STREET_POST_DIR {get;set;}
        public string STREET_TYPE {get;set;}
        public string SECONDARY_RANGE {get;set;}
        
		public void parse(DataServicesWS.AddressOutputRecord_element oResponse) {
			Id = oResponse.Id;
	        Name1 = oResponse.Name1;
	        Name2 = oResponse.Name2;
	        Street = oResponse.Street;
	        Street2 = oResponse.Street2;
	        City = oResponse.City;
	        State = oResponse.State;
	        PostalCode = oResponse.PostalCode;
	        County = oResponse.County;
	        Country = oResponse.Country;
	        SUGGESTION_COUNT = oResponse.SUGGESTION_COUNT;
	        SUGGESTION_TYPE = oResponse.SUGGESTION_TYPE;
	        SUGGESTION_DATA_TYPE = oResponse.SUGGESTION_DATA_TYPE;
	        SUGGESTION_STATUS = oResponse.SUGGESTION_STATUS;
	        SUGGESTION_WARNING = oResponse.SUGGESTION_WARNING;
	        SUGGESTION_ERROR = oResponse.SUGGESTION_ERROR;
	        SUGGESTION_ERROR_NUMBER = oResponse.SUGGESTION_ERROR_NUMBER;
	        SUGGESTION_ERROR_DESC = oResponse.SUGGESTION_ERROR_DESC;
	        SUGGESTION_LIST = oResponse.SUGGESTION_LIST;
	        SUGGESTION_STATUS_USCA = oResponse.SUGGESTION_STATUS_USCA;
	        SUGGESTION_ERROR_USCA = oResponse.SUGGESTION_ERROR_USCA;
	        SUGGESTION_COUNT_USCA = oResponse.SUGGESTION_COUNT_USCA;
	        SUGGESTION_LIST_USCA = oResponse.SUGGESTION_LIST_USCA;
	        PRIMARY_SECONDARY_ADDRESS = oResponse.PRIMARY_SECONDARY_ADDRESS;
	        PRIMARY_ADDRESS = oResponse.PRIMARY_ADDRESS;
	        SECONDARY_ADDRESS = oResponse.SECONDARY_ADDRESS;
	        DUAL_PRIMARY_SECONDARY_ADDRESS = oResponse.DUAL_PRIMARY_SECONDARY_ADDRESS;
	        DUAL_PRIMARY_ADDRESS = oResponse.DUAL_PRIMARY_ADDRESS;
	        DUAL_SECONDARY_ADDRESS = oResponse.DUAL_SECONDARY_ADDRESS;
	        STATUS_FAULT_CODE = oResponse.STATUS_FAULT_CODE;
	        STATUS_FAULT_DESC = oResponse.STATUS_FAULT_DESC;
	        STREET_RANGE = oResponse.STREET_RANGE;
	        STREET_NAME = oResponse.STREET_NAME;
	        STREET_PRE_DIR = oResponse.STREET_PRE_DIR;
	        STREET_POST_DIR = oResponse.STREET_POST_DIR;
	        STREET_TYPE = oResponse.STREET_TYPE;
	        SECONDARY_RANGE = oResponse.SECONDARY_RANGE;
	        if (oResponse.STATUS_FAULT_CODE.indexOf('S') == 0) {
	        	IsSuccess = true;
	        }
	        else {
	        	IsSuccess = false;
	        	ErrorMessage = STATUS_FAULT_DESC;
	        }
		}
	}
	
	/**
	 * Data structure representing an Account DeDupe Request
	 */
	public class AccountDeDupeRequest extends DataServices.Request 
	{
		public List<DataServices.AccountDetail> Accounts {get;set;}
		
		public AccountDeDupeRequest() {
			Accounts = new List<DataServices.AccountDetail>();
		}
	}
	
	/**
	 * Data structure representing an Account DeDupe Response
	 */
	public class AccountDeDupeResponse extends DataServices.Response 
	{
		public List<DataServices.AccountDetail> Accounts {get;set;}
		
		public AccountDeDupeResponse() {
			Accounts = new List<DataServices.AccountDetail>();
		}
        
		public void parse(DataServicesWS.DeDupeAccountOutputRecord_element[] oResponse) {
			Accounts = new List<DataServices.AccountDetail>();
			
			for (DataServicesWS.DeDupeAccountOutputRecord_element oResponseItem : oResponse) {
				DataServices.AccountDetail oAccountDetail = new DataServices.AccountDetail();
				
				oAccountDetail.Id = oResponseItem.Id;
		        oAccountDetail.Name1 = oResponseItem.Name1;
		        oAccountDetail.Name2 = oResponseItem.Name2;
		        oAccountDetail.Street = oResponseItem.Street;
		        oAccountDetail.Street2 = oResponseItem.Street2;
		        oAccountDetail.City = oResponseItem.City;
		        oAccountDetail.State = oResponseItem.State;
		        oAccountDetail.PostalCode = oResponseItem.PostalCode;
		        oAccountDetail.County = oResponseItem.County;
		        oAccountDetail.Country = oResponseItem.Country;
		        oAccountDetail.DEDUP_TOKEN = oResponseItem.DEDUP_TOKEN;
		        oAccountDetail.MASTER = oResponseItem.MASTER;
		        oAccountDetail.MATCH_STATUS = oResponseItem.MATCH_STATUS;
		        oAccountDetail.MATCH_SCORE = oResponseItem.MATCH_SCORE;
		        oAccountDetail.GROUP_COUNT = oResponseItem.GROUP_COUNT;
		        
		        Accounts.add(oAccountDetail);
			}
		}
	}
	
	/**
	 * Data structure representing account details for account deduplication request/response
	 */
	public class AccountDetail {
		public string Id {get;set;}
        public string Name1 {get;set;}
        public string Name2 {get;set;}
        public string Street {get;set;}
        public string Street2 {get;set;}
        public string City {get;set;}
        public string State {get;set;}
        public string PostalCode {get;set;}
        public string County {get;set;}
        public string Country {get;set;}
        public string Sales_Org {get;set;}
        public string STREET_RANGE {get;set;}
        public string STREET_NAME {get;set;}
        public string STREET_PRE_DIR {get;set;}
        public string STREET_POST_DIR {get;set;}
        public string STREET_TYPE {get;set;}
        public string SECONDARY_RANGE {get;set;}
        public string DEDUP_TOKEN {get;set;}
        public string MASTER {get;set;}
        public string MATCH_STATUS {get;set;}
        public string MATCH_SCORE {get;set;}
        public string GROUP_COUNT {get;set;}
	}

	
	/**
	 * Data structure representing a Contact DeDupe Request
	 */
	public class ContactDeDupeRequest extends DataServices.Request 
	{
		public List<DataServices.ContactDetail> Contacts {get;set;}
     	
     	public ContactDeDupeRequest() {
     		Contacts = new List<DataServices.ContactDetail>();
     	}
	}
	
	/**
	 * Data structure representing a Contact DeDupe Response
	 */
	public class ContactDeDupeResponse extends DataServices.Response 
	{
     	public List<DataServices.ContactDetail> Contacts {get;set;}
     	
     	public ContactDeDupeResponse() {
     		Contacts = new List<DataServices.ContactDetail>();
     	}   
     	
		public void parse(DataServicesWS.DeDupeContactOutputRecord_element[] oResponse) {
			Contacts = new List<DataServices.ContactDetail>();
			
			for (DataServicesWS.DeDupeContactOutputRecord_element oResponseItem : oResponse) {
				DataServices.ContactDetail oContactDetail = new DataServices.ContactDetail();
				
				oContactDetail.Id = oResponseItem.Id;
		        oContactDetail.AccountId = oResponseItem.AccountId;
		        oContactDetail.FirstName = oResponseItem.FirstName;
		        oContactDetail.LastName = oResponseItem.LastName;
		        oContactDetail.Street = oResponseItem.Street;
		        oContactDetail.Street2 = oResponseItem.Street2;
		        oContactDetail.City = oResponseItem.City;
		        oContactDetail.State = oResponseItem.State;
		        oContactDetail.PostalCode = oResponseItem.PostalCode;
		        oContactDetail.County = oResponseItem.County;
		        oContactDetail.Country = oResponseItem.Country;
		        oContactDetail.DEDUP_TOKEN = oResponseItem.DEDUP_TOKEN;
		        oContactDetail.MASTER = oResponseItem.MASTER;
		        oContactDetail.MATCH_STATUS = oResponseItem.MATCH_STATUS;
		        oContactDetail.MATCH_SCORE = oResponseItem.MATCH_SCORE;
		        oContactDetail.GROUP_COUNT = oResponseItem.GROUP_COUNT;
		        
		        Contacts.add(oContactDetail);
			}
		}
	}
	
	public class ContactDetail {
		public string Id {get;set;}
        public string AccountId {get;set;}
        public string FirstName {get;set;}
        public string LastName {get;set;}
        public string Street {get;set;}
        public string Street2 {get;set;}
        public string City {get;set;}
        public string State {get;set;}
        public string PostalCode {get;set;}
        public string County {get;set;}
        public string Country {get;set;}
        public string Contact_Role {get;set;}
        public string STREET_RANGE {get;set;}
        public string STREET_NAME {get;set;}
        public string STREET_PRE_DIR {get;set;}
        public string STREET_POST_DIR {get;set;}
        public string STREET_TYPE {get;set;}
        public string SECONDARY_RANGE {get;set;}
        public string DEDUP_TOKEN {get;set;}
        public string MASTER {get;set;}
        public string MATCH_STATUS {get;set;}
        public string MATCH_SCORE {get;set;}
        public string GROUP_COUNT {get;set;}
	}
}