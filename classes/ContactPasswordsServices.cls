/**
 * Contains helper methods for ContactPassword Class
 * Contains the methods which will process the request and response
 *
 * @author  Srikanth Kuruva
 * @version  2012-07-27
 */
 
public with sharing class ContactPasswordsServices
{


 //Constants
    public static final string WEB_SERVICE_NAME = 'ContactPasswordsServices';
    public static contactPasswordWSObjects.AccountOnlineUser outputOnlineUser;
    
    public static Integer StartingRecord;
    public static Integer EndingRecord;
    public static Integer TotalofRecs;
    
/**
 * Submits the supplied request to the Contact Password web service to retrieve
 * Contact Password Details
 *
 * @paramoRequestan instance of an ContactPasswordRequest object
 * @return ContactPasswordsWSObjects.OnlineUser[] representing the results of the web service callout
 * 
 */
    public List<OnlineContact> GetContactPasswords(ContactPasswordRequest oRequest) {
        
        List<OnlineContact> listOnlineUser = new List<OnlineContact>();
        ValidationResult oValidationResult = validateRequest(oRequest);
        system.debug('Validation result ##'+oValidationResult.IsValid );
        system.debug('Validation result request ##'+oRequest );
        if (oValidationResult.IsValid == true) {
           list<ContactPasswordWSESI.OnlineUser> oResponse = new list<ContactPasswordWSESI.OnlineUser>();
 
             if (Test.isRunningTest()) {
                //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(WEB_SERVICE_NAME);
                returnServiceESIBySAPID(oRequest);            
                if (oMockResponse instanceof ContactPasswordWSESI.OnlineUser) {
                  
                   oResponse.add((ContactPasswordWSESI.OnlineUser) oMockResponse);
                }
            }       
            else {
            //Execute Web Service Callout
            
                oResponse = returnServiceESIBySAPID(oRequest).GetOnlineUserByContactSapId(oRequest.ContactSAPID);
              
            }
            //Parse Response
            if(oResponse !=null){
               for(ContactPasswordWSESI.OnlineUser oUser : oResponse){              
                    OnlineContact oOnlineContact = new OnlineContact();
                   
                   if(oUser.FederatedIdentity!=null){
                 
                        oOnlineContact.OnePassUserName = oUser.FederatedIdentity.OnePassUserName;
                        oOnlineContact.Product = oUser.FederatedIdentity.Product;                
                        oOnlineContact.RegistrationKey = oUser.FederatedIdentity.RegistrationKey;                    
                        oOnlineContact.IsPreferred= oUser.FederatedIdentity.IsPreferred;                                        
                        oOnlineContact.NickName = oUser.FederatedIdentity.NickName;
                        oOnlineContact.Email = oUser.FederatedIdentity.Email;
                        //oOnlineContact.LastLoginTS = oUser.FederatedIdentity.LastLoginTS;
                        //oOnlineContact.LastLoginTS = System.now();
                        
                        if( oUser.FederatedIdentity.LastLoginTS != null && oUser.FederatedIdentity.LastLoginTS != '' ){
                        //oOnlineAccountUsers.LastLoginTS = DateTime.parse(oUser.FederatedIdentity.LastLoginTS);
                        oOnlineContact.LastLoginTS = Datetime.valueOf(oUser.FederatedIdentity.LastLoginTS.substring(0,4)+'-'+oUser.FederatedIdentity.LastLoginTS.substring(5,7)+'-'+oUser.FederatedIdentity.LastLoginTS.substring(8,10)+' '+oUser.FederatedIdentity.LastLoginTS.substring(11,13)+':'+oUser.FederatedIdentity.LastLoginTS.substring(14,16)+':'+oUser.FederatedIdentity.LastLoginTS.substring(17,19));
                        
                    }
                        
                        oOnlineContact.DataSource = 'OnePass';
                    
                    }
                     
                                          
                      if(oUser.PrismUser!=null){
                       
                        /*if( oUser.PrismUser.PwdSecEffDt != null && oUser.PrismUser.PwdSecEffDt != ''){
                            
                            
                            Date parsableEff = Date.parse(oUser.PrismUser.PwdSecEffDt.substring(5,7)+'/'+oUser.PrismUser.PwdSecEffDt.substring(8,10)+'/'+oUser.PrismUser.PwdSecEffDt.substring(0,4));
                            Integer year = (parsableEff.year() > 4000) ? 4000 : parsableEff.year();
                            Date finalEff =  Date.newInstance(year, parsableEff.month(), parsableEff.day());
                            oOnlineContact.PwdSecEffDt = finalEff;
                        }
                        if( oUser.PrismUser.PwdSecEndDt != null && oUser.PrismUser.PwdSecEndDt != ''){
                             
                             Date parsableEnd =Date.parse(oUser.PrismUser.PwdSecEndDt.substring(5,7)+'/'+oUser.PrismUser.PwdSecEndDt.substring(8,10)+'/'+oUser.PrismUser.PwdSecEndDt.substring(0,4));
                             Integer year1 = (parsableEnd.year() > 4000) ? 4000 : parsableEnd.year();
                             Date finalEnd =  Date.newInstance(year1, parsableEnd.month(), parsableEnd.day());
                             oOnlineContact.PwdSecEndDt = finalEnd;
                        }*/
                        
                        if( oUser.PrismUser.PwdSecEffDt != null && oUser.PrismUser.PwdSecEffDt != ''){
                            
                            String year = (Integer.valueOf(oUser.PrismUser.PwdSecEffDt.substring(0,4)) > 4000) ? '4000' :  oUser.PrismUser.PwdSecEffDt.substring(0,4);
                            oOnlineContact.PwdSecEffDt = Date.parse(oUser.PrismUser.PwdSecEffDt.substring(5,7)+'/'+oUser.PrismUser.PwdSecEffDt.substring(8,10)+'/'+year);
                           
                        }
                        if( oUser.PrismUser.PwdSecEndDt != null && oUser.PrismUser.PwdSecEndDt != ''){
                             
                             String year = (Integer.valueOf(oUser.PrismUser.PwdSecEndDt.substring(0,4)) > 4000) ? '4000' :  oUser.PrismUser.PwdSecEndDt.substring(0,4);
                             oOnlineContact.PwdSecEndDt = Date.parse(oUser.PrismUser.PwdSecEndDt.substring(5,7)+'/'+oUser.PrismUser.PwdSecEndDt.substring(8,10)+'/'+year);
                             
                        }
                        
                        
                        oOnlineContact.PwdSecReasonCode = oUser.PrismUser.PwdSecReasonCode;
                        if(oOnlineContact.DataSource!='OnePass'){
                            oOnlineContact.DataSource = 'Prism';
                        }
                       if(oOnlineContact.RegistrationKey == null || oOnlineContact.RegistrationKey ==''){
                           if(oUser.PrismUser.UserId!=null || oUser.PrismUser.Password!=null){
                            oOnlineContact.RegistrationKey = oUser.PrismUser.UserId +'-'+ oUser.PrismUser.Password;
                            }
                        }
                      }
                      
                      if(oUser.Contact !=null){
                        oOnlineContact.Domain = oUser.Contact.Domain;
                        oOnlineContact.StatusDesc = oUser.Contact.StatusDesc; 
                        if(oOnlineContact.RegistrationKey == null || oOnlineContact.RegistrationKey ==''){
                           if(oUser.Contact.OnlineId!=null && oUser.Contact.Domain=='WESTLAW'){
                            oOnlineContact.RegistrationKey = oUser.Contact.OnlineId;
                            }                      
                      }
                     } 
                    if(oOnlineContact.DataSource!='Prism' && oOnlineContact.DataSource!='OnePass'){
                        oOnlineContact.DataSource = 'SAP';
                    }
                    listOnlineUser.add(oOnlineContact);

                     
                   
               }
            } 
        }
        else {
            throw new ContactPasswordsServices.ValidationException(oValidationResult.toString());
        }
        return listOnlineUser;
    }

    public List<OnlineAccountUsers> GetAccountPasswords(AccountPasswordRequest oRequest) {
        List<OnlineAccountUsers> listOnlineUser = new List<OnlineAccountUsers>();
        outputOnlineUser = new contactPasswordWSObjects.AccountOnlineUser();
        ValidationResult oValidationResult = validateRequest(oRequest);
        system.debug('Validation result ##'+oValidationResult.IsValid );
        system.debug('Validation result request ##'+oRequest );
        if (oValidationResult.IsValid == true) {
          //   List<ContactPasswordWSObjects.AccountOnlineUser> oResponse = new List<ContactPasswordWSObjects.AccountOnlineUser>();
            ContactPasswordWSESI.AccountOnlineUser  oResponse = new  ContactPasswordWSESI.AccountOnlineUser ();

             if (Test.isRunningTest()) {
                //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get('ContactPasswordsServicesAcc');
                returnServiceESI(oRequest);            
                if (oMockResponse instanceof  ContactPasswordWSESI.AccountOnlineUser ) {
                  
                  // oResponse = (ContactPasswordWSObjects.AccountOnlineUser)oMockResponse;
                    oResponse = ( ContactPasswordWSESI.AccountOnlineUser ) oMockResponse;
                  
                }
            }       
            else {
            //Execute Web Service Callout
                
                
                
                oResponse = returnServiceESI(oRequest).GetOnlineUserByAccount(oRequest.Domain,oRequest.AcctSapId,oRequest.CompanyCode,
                                                                           oRequest.SalesOrgCode,oRequest.DistChanCode,oRequest.DivisionCode,
                                                                           oRequest.StartRec,oRequest.MaxResults);
                                                                           
               system.debug('------oResponse--------------'+oResponse.StartRec);
               system.debug('------oResponse--------------'+oResponse.EndRec);
               system.debug('------oResponse--------------'+oResponse.TotalRecs);
              
            }
            
             //TotalofRecs = oResponse.OnlineUser.Size();
             StartingRecord = oRequest.StartRec;
             EndingRecord   = oResponse.EndRec;
             TotalofRecs    = oResponse.TotalRecs;
             
            //Parse Response
            
            System.debug(oResponse +'*****');
            if(oResponse !=null){
               for( ContactPasswordWSESI.OnlineUser oUser : oResponse.OnlineUser){              
                    OnlineAccountUsers oOnlineAccountUsers = new OnlineAccountUsers();
                      if(oUser.FederatedIdentity!=null){
                    oOnlineAccountUsers.Email = oUser.FederatedIdentity.Email;
                    oOnlineAccountUsers.OnePassUserName = oUser.FederatedIdentity.OnePassUserName;
                    oOnlineAccountUsers.Product = oUser.FederatedIdentity.Product;                
                    oOnlineAccountUsers.RegistrationKey = oUser.FederatedIdentity.RegistrationKey;                    
                    oOnlineAccountUsers.IsPreferred= oUser.FederatedIdentity.IsPreferred;                                        
                    oOnlineAccountUsers.NickName = oUser.FederatedIdentity.NickName;
                    System.debug('-----------oUser.FederatedIdentity.LastLoginTS------'+oUser.FederatedIdentity.LastLoginTS);
                    if( oUser.FederatedIdentity.LastLoginTS != null && oUser.FederatedIdentity.LastLoginTS != '' ){
                        //oOnlineAccountUsers.LastLoginTS = DateTime.parse(oUser.FederatedIdentity.LastLoginTS);
                        oOnlineAccountUsers.LastLoginTS = Datetime.valueOf(oUser.FederatedIdentity.LastLoginTS.substring(0,4)+'-'+oUser.FederatedIdentity.LastLoginTS.substring(5,7)+'-'+oUser.FederatedIdentity.LastLoginTS.substring(8,10)+' '+oUser.FederatedIdentity.LastLoginTS.substring(11,13)+':'+oUser.FederatedIdentity.LastLoginTS.substring(14,16)+':'+oUser.FederatedIdentity.LastLoginTS.substring(17,19));
                        
                    }
                   
                    oOnlineAccountUsers.DataSource = 'OnePass';
                    
                      }
                      
                        
                      if(oUser.PrismUser!=null){
                    
                        if( oUser.PrismUser.PwdSecEffDt != null ){  
                            oOnlineAccountUsers.PwdSecEffDt = Date.parse(oUser.PrismUser.PwdSecEffDt.substring(5,7)+'/'+oUser.PrismUser.PwdSecEffDt.substring(8,10)+'/'+oUser.PrismUser.PwdSecEffDt.substring(0,4));
                            //oOnlineAccountUsers.PwdSecEffDt = oUser.PrismUser.PwdSecEffDt;
                        }
                        if( oUser.PrismUser.PwdSecEndDt != null ){ 
                           oOnlineAccountUsers.PwdSecEndDt = Date.parse(oUser.PrismUser.PwdSecEndDt.substring(5,7)+'/'+oUser.PrismUser.PwdSecEndDt.substring(8,10)+'/'+oUser.PrismUser.PwdSecEndDt.substring(0,4));
                          // oOnlineAccountUsers.PwdSecEndDt = oUser.PrismUser.PwdSecEndDt;
                            
                        }
                        oOnlineAccountUsers.PwdSecReasonCode = oUser.PrismUser.PwdSecReasonCode;
                        if(oOnlineAccountUsers.DataSource!='OnePass'){
                            oOnlineAccountUsers.DataSource = 'Prism';
                        }
                       if(oOnlineAccountUsers.RegistrationKey == null || oOnlineAccountUsers.RegistrationKey ==''){
                           if(oUser.PrismUser.UserId!=null || oUser.PrismUser.Password!=null){
                            oOnlineAccountUsers.RegistrationKey = oUser.PrismUser.UserId +'-'+ oUser.PrismUser.Password;
                            }
                        }
                      }
                      
                      if(oUser.Contact !=null){
                        oOnlineAccountUsers.FirstName = oUser.Contact.FirstName;
                        oOnlineAccountUsers.LastName = oUser.Contact.LastName;
                        oOnlineAccountUsers.Domain = oUser.Contact.Domain;
                        oOnlineAccountUsers.StatusDesc = oUser.Contact.StatusDesc;
                        if(oOnlineAccountUsers.RegistrationKey == null || oOnlineAccountUsers.RegistrationKey ==''){
                           if(oUser.Contact.OnlineId!=null && oUser.Contact.Domain=='WESTLAW'){
                            oOnlineAccountUsers.RegistrationKey = oUser.Contact.OnlineId;
                            }                       
                         }
                      }
                       if(oOnlineAccountUsers.DataSource!='Prism' && oOnlineAccountUsers.DataSource!='OnePass'){
                        oOnlineAccountUsers.DataSource = 'SAP';
                    }

                    listOnlineUser.add(oOnlineAccountUsers);

                    System.debug('---------------listOnlineUser'+listOnlineUser);
                   
               }
            } 
        }
        else {
            throw new ContactPasswordsServices.ValidationException(oValidationResult.toString());
        }
        
        return listOnlineUser;
    }

//Private Methods
//Changes done by Dinesh
    Private ContactPasswordWSESI.Contact_v11_0BindingQSPort  returnServiceESIBySAPID(Request oRequest){
        System.debug('Entered returnServiceESIBySAPID method'+oRequest);
        ContactPasswordWSESI.Contact_v11_0BindingQSPort  oService = new ContactPasswordWSESI.Contact_v11_0BindingQSPort ();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ContactPasswordByConSAPID');  
        oService.inputHttpHeaders_x = new Map<String, String>();
        oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue();
        oService.endpoint_x= oWebServiceSettings.Endpoint__c;
        Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        oService.outputHttpHeaders_x = new Map<String,String>();
        System.debug('Exit returnServiceESIBySAPID method'+oService);
        return oService;
    }
    
    Private ContactPasswordWSESI.Contact_v11_0BindingQSPort  returnServiceESI(Request oRequest){
        ContactPasswordWSESI.Contact_v11_0BindingQSPort  oService = new ContactPasswordWSESI.Contact_v11_0BindingQSPort ();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ContactPasswordsESI'); 
        oService.inputHttpHeaders_x = new Map<String, String>();
        oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue();
        oService.endpoint_x= oWebServiceSettings.Endpoint__c;
        Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        oService.outputHttpHeaders_x = new Map<String,String>();
        return oService;
    }


/**
 * Validates that all required fields are populated for the specified Request
 *
 * @paramoRequestan instance of a Request object to validate
 * @returnan instance of a ValidationResult representing the results of the validation test
 */
    private ValidationResult validateRequest(Request oRequest) {
        ValidationResult oValidation = new ValidationResult();
        oValidation.IsValid = true;
        if (oRequest != null) {
            //Validate Request Credentials
            boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.EndPoint);
            if (isMissingEndpoint) {
                oValidation.IsValid = false;
                oValidation.Failures.add('Invalid request. Web service endpoint is not configured');
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

//Internal Classes

/**
 * Custom exception class representing a validation error
 */
    public class ValidationException extends Exception {}

/**
 * Virtual class representing a base IXOS request
 */
    public virtual class Request {
    //Properties
        public string EndPoint {get;set;}
        public string Username {get;set;}
        public string Password {get;set;}
        public integer Timeout {get;set;}

        //Constructors

        /**
         * Default Constructor
         */
        public Request() {
            Timeout = 5000; //5 Seconds
        }
    }
    
   
/**
 * Data structure representing an Contact Password request
 * 
 */
    public class ContactPasswordRequest extends Request {
    //Properties
        public Decimal ContactSAPID{get;set;}
 
    }
    
    public class AccountPasswordRequest extends Request{
        public String Domain{get;set;}
        public Decimal AcctSapId{get;set;}
        public String CompanyCode{get;set;}
        public String SalesOrgCode{get;set;}
        public String DistChanCode{get;set;}
        public String DivisionCode{get;set;}
        public Integer StartRec{get;set;}
        public Integer MaxResults{get;set;}
        
        public AccountPasswordRequest(){}
        
    
    }

//Data Structures

/**
 * Data structure representing Contact Password WS Objects
 */ 

    public class FederatedIdentity 
    {
        public String OnePassUserName{get;set;}
        public String Product{get;set;}
        public String RegistrationKey{get;set;}
        public Boolean IsMigrated{get;set;}
        public Boolean IsPreferred{get;set;}
        public String NickName{get;set;}
        public DateTime LastLoginTS{get;set;}
        public String Email{get;set;}
    }
    public class Contact 
    {
        public Decimal AcctSapId{get;set;}
        public String CompanyCode{get;set;}
        public String SalesOrgCode{get;set;}
        public String DistChanCode{get;set;}
        public String DivisionCode{get;set;}
        public Decimal ContactSapId{get;set;}
        public Decimal MdbContactId{get;set;}
        public String Domain{get;set;}
        public String OnlineId{get;set;}
        public String StatusId{get;set;}
        public String StatusDesc{get;set;}
        public String FirstName{get;set;}
        public String LastName{get;set;}
    }
    public class PrismUser 
    {
        public String Guid{get;set;}
        public String UserId{get;set;}
        public String Password{get;set;}
        public Date PwdSecEffDt{get;set;}
        public Date PwdSecEndDt{get;set;}
        public String PwdSecReasonCode{get;set;}
        public Boolean IsNewUser{get;set;}
    }
    public class OnlineUser 
    {
        public ContactPasswordsServices.FederatedIdentity FederatedIdentity;
        public ContactPasswordsServices.Contact Contact;
        public ContactPasswordsServices.PrismUser PrismUser;
        
    }
    
    public class OnlineContact
    {
        public String OnePassUserName{get;set;}
        public String Product{get;set;}
        public String Domain{get;set;}
        public String RegistrationKey{get;set;}
        public Boolean IsPreferred{get;set;}
        public String NickName{get;set;}
        public DateTime LastLoginTS{get;set;}
        public String StatusDesc{get;set;}
        public Date PwdSecEffDt{get;set;}
        public Date PwdSecEndDt{get;set;}
        public String PwdSecReasonCode{get;set;}
        public String DataSource{get;set;}
        public String Email{get;set;}
    }
    
    public class OnlineAccountUsers
    {
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public String Email{get;set;}
        public String OnePassUserName{get;set;}
        public String Product{get;set;}
        public String Domain{get;set;}
        public String RegistrationKey{get;set;}
        public Boolean IsPreferred{get;set;}
        public String NickName{get;set;}
        public DateTime LastLoginTS{get;set;}
        public String StatusDesc{get;set;}
        public Date PwdSecEffDt{get;set;}
        public Date PwdSecEndDt{get;set;}
        public String PwdSecReasonCode{get;set;}
        public String DataSource{get;set;}

    }
    
 
}