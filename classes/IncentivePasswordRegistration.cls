/**
 * Provides methods for submitting requests to the Incentive Password web service
 * <p>
 * Note: As a best practice only this class and it's associated test class should
 * have a dependency on the IncentivePasswordRegistrationWS class. This will ease 
 * any future modifications to the web service wsdl and abstract the web service 
 * interface from the rest of the application.
 *
 * @author  John De Santiago
 * @version  2012-02-25
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date      Name                         Description
 * 2012-01-11   John De Santiago            Created
 * 2012-02-25   Partha                  Modified(Class Promotion password)
 * 2017-11-16   Harika Devi Kalidindi   CRM -11167 Added USLContactId in PromotionUserContact  class properties 
 * 2020-4-3     Shyamsundar Shet        BMP-1594 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

 * =============================================================================
 */
public with sharing class IncentivePasswordRegistration {
  //Constants
  public static final string WEB_SERVICE_NAME = 'IncentivePasswordRegistration';
  
  //Public Methods
  
  /**
   * Submits the supplied request to the Incentive Password Registration web service to retrieve
   * open incentive promotions
   *
   * @param  oRequest  an instance of an OpenPromotionRequest object
   * @return  a list of IncentivePasswordRegistration.Promotion objects representing 
   *      the results of the web service callout
   */
  public List<Promotion> requestOpenPromotions(OpenPromotionRequest oRequest) {
    List<Promotion> listOpenPromotions = new List<Promotion>();
    
    ValidationResult oValidationResult = validateRequest(oRequest);
    if (oValidationResult.IsValid == true) {
      IncentivePasswordRegistrationWS.Registration_v2_0Port oService = new IncentivePasswordRegistrationWS.Registration_v2_0Port();
      oService.inputHttpHeaders_x = new Map<String, String>();
      oService.timeout_x = oRequest.Timeout;
      oService.endpoint_x = oRequest.EndPoint;
      
      //string sAuthorizationHeader = 'Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=';
      //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode( Blob.valueOf(oRequest.username+':'+oRequest.password));
      try{
                string sAuthorizationHeader = 'Bearer ' + oRequest.accessToken;
                             
                oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
                }
                catch(Exception e){
            ApexPages.addMessages(e);
    } 
      
      oService.outputHttpHeaders_x = new Map<String,String>();
      
      IncentivePasswordRegistrationWS.OpenPromotion[] oResponse = new IncentivePasswordRegistrationWS.OpenPromotion[0];
      
      if (Test.isRunningTest()) {
        //Get Mock Response
        object oMockResponse = UnitTest.MockWebServiceResponse.get('IncentivePromoRegistration');
        
        if (oMockResponse instanceof IncentivePasswordRegistrationWS.OpenPromotion) {
          oResponse .add( (IncentivePasswordRegistrationWS.OpenPromotion) oMockResponse);
        }
      }
      else {
        //Execute Web Service Callout
        oResponse = oService.GetOpenPromotions(oRequest.DomainName, oRequest.CompanyCode, oRequest.PromotionType);
        }
      
      //Parse Response
      for (IncentivePasswordRegistrationWS.OpenPromotion oOpenPromotion : oResponse) {
        listOpenPromotions.add(new Promotion(oOpenPromotion));
      }
    }
    else {
      throw new IncentivePasswordRegistration.ValidationException(oValidationResult.toString());
    }
    
    return listOpenPromotions;
  }
  
  /**
   * Submits the supplied request to the Incentive Password Registration web service to generate
   * incentive passwords
   *
   * @param  oRequest  an instance of an PromotionPasswordRequest object
   * @return  a list of IncentivePasswordRegistration.PromotionPassword objects representing 
   *      the results of the web service callout
   */
  public List<PromotionPassword> requestPromotionPasswords(PromotionPasswordRequest oRequest) {
    List<PromotionPassword> listPromotionPasswords = new List<PromotionPassword>();
    
    ValidationResult oValidationResult = validateRequest(oRequest);
    if (oValidationResult.IsValid == true) {
      IncentivePasswordRegistrationWS.Registration_v2_0Port oService = new IncentivePasswordRegistrationWS.Registration_v2_0Port();
      oService.inputHttpHeaders_x = new Map<String, String>();
      oService.timeout_x = oRequest.Timeout;
      oService.endpoint_x = oRequest.EndPoint;
      
      //string sAuthorizationHeader = 'Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=';
      //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode( Blob.valueOf(oRequest.username+':'+oRequest.password));
      try{
                string sAuthorizationHeader = 'Bearer ' + oRequest.accessToken;
                             
                oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
                }
                catch(Exception e){
            ApexPages.addMessages(e);
    } 
      
      oService.outputHttpHeaders_x = new Map<String,String>();
      
      IncentivePasswordRegistrationWS.UserRegistration[] oResponse = new IncentivePasswordRegistrationWS.UserRegistration[0];
        
      
      //Convert list of PromotionUserContacts to PromotionUsers
      List<IncentivePasswordRegistrationWS.PromotionUser> listPromotionUsers = new List<IncentivePasswordRegistrationWS.PromotionUser>();
      for (PromotionUserContact oUserContact : oRequest.Contacts) {
          
        listPromotionUsers.add(oUserContact.toPromotionUser());  
      }
      
      if (Test.isRunningTest()) {
        //Get Mock Response
        object oMockResponse = UnitTest.MockWebServiceResponse.get(WEB_SERVICE_NAME);
        
        if (oMockResponse instanceof IncentivePasswordRegistrationWS.UserRegistration) {
          oResponse.add((IncentivePasswordRegistrationWS.UserRegistration) oMockResponse);
          system.debug('*******'+oResponse);
        }
      }
      else {
        //Execute Web Service Callout
        oResponse = oService.GetPromotionPasswords(oRequest.Keys, listPromotionUsers, oRequest.CreatedBySystem, oRequest.CreatedByUser);
      }
      
      //Parse Response
      for (IncentivePasswordRegistrationWS.UserRegistration oUserRegistration : oResponse) {
        listPromotionPasswords.add(new PromotionPassword(oUserRegistration));
          
      }
    }
    else {
      throw new IncentivePasswordRegistration.ValidationException(oValidationResult.toString());
    }
    
    return listPromotionPasswords;
  }
  
  //Private Methods
  
  /**
   * Validates that all required fields are populated for the specified Request
   *
   * @param  oRequest  an instance of a Request object to validate
   * @return  an instance of a ValidationResult representing the results of the validation test
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
   * Virtual class representing a base incentive password registration request
   */
  public virtual class Request {
    //Properties
    public string EndPoint {get;set;}
    public string Username {get;set;}
    public string Password {get;set;}
    public integer Timeout {get;set;}
    public String accessToken {get;set;}
    
    //Constructors
    
    /**
     * Default Constructor
     */
    public Request() {
      Timeout = 5000; //5 Seconds
    }
  }
  
  /**
   * Data structure representing an incentive password open
   * promotion request
   */
  public class OpenPromotionRequest extends Request {
    //Properties
    public string DomainName {get;set;}
    public string CompanyCode {get;set;}
    public string PromotionType {get;set;}
  }
  
  /**
   * Data structure representing an incentive password promotion
   */
  public class Promotion {
    //Properties
    public string PromotionId {get;set;}
    public string DomainName {get;set;}
    public string CompanyCode {get;set;}
    public string PromotionNumber {get;set;}
    public string Type {get;set;}
    public string Title {get;set;}
    public string Description {get;set;}
    public string Key {get;set;}
    public Date StartDate {get;set;}
    public Date EndDate {get;set;}
    
    //Constructors
    
    /**
     * Open Promotion Constructor
     *
     * @param  an instance of an IncentivePasswordRegistrationWS.OpenPromotion object
     */
    public Promotion(IncentivePasswordRegistrationWS.OpenPromotion oOpenPromotion) {
      PromotionId = oOpenPromotion.PromoId;
      DomainName = oOpenPromotion.PromoDomain;
      CompanyCode = oOpenPromotion.PromoCompanyCode;
      PromotionNumber = oOpenPromotion.PromoNumber;
      Type = oOpenPromotion.PromoType;
      Title = oOpenPromotion.PromoTitle;
      Description = oOpenPromotion.PromoDescription;
      StartDate = oOpenPromotion.PromoStartDate;
      EndDate = oOpenPromotion.PromoEndDate;
      Key = oOpenPromotion.PromoKey;
    }
  }
  
  /**
   * Data structure representing an incentive password
   * promotion password request
   */
  public class PromotionPasswordRequest extends Request {
    //Properties
    public List<string> Keys {get;set;}
    public List<PromotionUserContact> Contacts {get;set;}
    public string CreatedBySystem {get;set;}
    public string CreatedByUser {get;set;}
    
    //Constructors
    
    /**
     * Default Constructor
     */
    public PromotionPasswordRequest() {
      Keys = new List<String>();
      Contacts = new List<PromotionUserContact>();
      CreatedBySystem = 'Legal';
      User LoggedUser = [select Rep_Employee_Number__c from user where id=: UserInfo.getUserId()];
      if(loggedUser.Rep_Employee_Number__c != null)
        CreatedByUser= loggedUser.Rep_Employee_Number__c;
    }
  }
  
  /**
   * Data structure representing an incentive password promotion user
   */
  public class PromotionUserContact {
    //Properties
    public String SapAccountId {get;set;}
    public String OnlineId {get;set;}
    public String OnlineIdDomain {get;set;}
    public String MdbContactId {get;set;}
    public String USLContactId{get;set;} // Harika -Added as part of CRM -11167
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public String OrgnizationName {get;set;}
    public String City {get;set;}
    public String State {get;set;}
    public String ZipCode {get;set;}
    public String PhoneNumber {get;set;}
    public String EmailAddress {get;set;}
    
    //Public Methods
    
    /**
     * Converts the current PromotionUserContact to an IncentivePasswordRegistrationWS.PromotionUser object
     */
    public IncentivePasswordRegistrationWS.PromotionUser toPromotionUser() {
      IncentivePasswordRegistrationWS.PromotionUser oPromotionUser = new IncentivePasswordRegistrationWS.PromotionUser();
      oPromotionUser.SapAccountId = SapAccountId;
        
      oPromotionUser.OnlineId = OnlineId;
      oPromotionUser.OnlineIdDomain = OnlineIdDomain;
     // Harika -Added as part of CRM -11167
      if(USLContactId != null && USLContactId != '' )
      {
           oPromotionUser.MdbContactId=USLContactId;
      }
      else
      {
           oPromotionUser.MdbContactId=MdbContactId;
      }
      oPromotionUser.FirstName = FirstName;
      oPromotionUser.LastName = LastName;
      oPromotionUser.OrgnizationName = OrgnizationName;
      oPromotionUser.City = City;
      oPromotionUser.State = State;
      oPromotionUser.ZipCode = ZipCode;
      oPromotionUser.PhoneNumber = PhoneNumber;
      oPromotionUser.EmailAddress = EmailAddress;
      
      return oPromotionUser;
    }
  }
  
  /**
   * Data structure representing an incentive password
   * promotion password
   */
  public class PromotionPassword {
    public String PromoKey{get;set;}
    public String SapAccountId{get;set;}
    public String OnlineId{get;set;}
    public String OnlineIdDomain{get;set;}
    public String MdbContactId{get;set;}  
    public String FirstName{get;set;}
    public String LastName{get;set;}
    public String OrgnizationName{get;set;}
    public String City{get;set;}
    public String State{get;set;}
    public String ZipCode{get;set;}
    public String PhoneNumber{get;set;}
    public String EmailAddress{get;set;}
    public String IncentiveOnlineId{get;set;}
    public String IncentivePassword{get;set;}
    public String IncentiveContactNum{get;set;}
    public Date IncentiveStartDate{get;set;}
    public Date IncentiveEndDate{get;set;}  
    
    public PromotionPassword(IncentivePasswordRegistrationWS.UserRegistration userReg){
        PromoKey=userReg.PromoKey;
        
        SapAccountId=userReg.PromotionUser.SapAccountId;
        OnlineId=userReg.PromotionUser.OnlineId;
        OnlineIdDomain=userReg.PromotionUser.OnlineIdDomain;
        MdbContactId=userReg.PromotionUser.MdbContactId;
        FirstName=userReg.PromotionUser.FirstName;
        LastName=userReg.PromotionUser.LastName;
        OrgnizationName=userReg.PromotionUser.OrgnizationName;
        City=userReg.PromotionUser.City;
        State=userReg.PromotionUser.State;
        ZipCode=userReg.PromotionUser.ZipCode;
        PhoneNumber=userReg.PromotionUser.PhoneNumber;
        EmailAddress=userReg.PromotionUser.EmailAddress;
        IncentiveOnlineId=userReg.IncentivePassword.IncentiveOnlineId;
        IncentivePassword=userReg.IncentivePassword.IncentivePassword;
        IncentiveContactNum=userReg.IncentivePassword.IncentiveContactNum;
        IncentiveStartDate=userReg.IncentivePassword.IncentiveStartDate;
        IncentiveEndDate=userReg.IncentivePassword.IncentiveEndDate;
    }
    
  }
}