/**
 * Provides methods for submitting requests to the Subscription web service
 * <p>
 * Note: As a best practice only this class and it's associated test class should
 * have a dependency on the SubscriptionServiceWS class. This will ease 
 * any future modifications to the web service wsdl and abstract the web service 
 * interface from the rest of the application.
 *
 * @author  Partha
 * @version  2012-02-07
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                        Description
 * 2012-02-07   Partha                      Created
 * 2017-03-31   Meenakshmi Goswami          Optimized the code as per JIRA STORY: PS0-1
 * 2020-04-1    Shyamsundar Shet          BMP-1595 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

 * =============================================================================
 */
public with sharing class SubscriptionServices {
    public SubscriptionServices(ApexPages.StandardController controller){
    }

    public SubscriptionServices(){
    }

   //Constants
  public static final string WebServiceName = 'SubscriptionServices';
    public static final string MockCalloutGetSubItems = 'GetSubItems';
    public static final string MockCalloutCalculatePDA = 'CalculatePDA';    
    public static Map<string, SubItem> mapSubItems; 
    public static SubscriptionsWSObject.Sub outputSub;
    public static Integer TotalofRecs;

    public static List<SubItem> getSubItems(SubsRequest oSubsRequest)
    {
      mapSubItems = new Map<string, SubItem>();
      list<SubItem> listSubItems = new list<SubItem>();
      SubscriptionsWS.Subs_v4_0Port oService = new SubscriptionsWS.Subs_v4_0Port();
      WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);      
      oService.inputHttpHeaders_x = new Map<String, String>();
        oService.endpoint_x = oWebServiceSettings.Endpoint__c;
        oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        try{
            String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
            string sAuthorizationHeader = 'Bearer ' +accessToken;
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        }
        
            catch(Exception e){
            ApexPages.addMessages(e);
    } 
        oService.outputHttpHeaders_x = new Map<String,String>();
        List<SubscriptionsWSObject.SubItem> outputSubscriptions = new List<SubscriptionsWSObject.SubItem>();
       // SubscriptionsWSObject.Sub outputSub = new SubscriptionsWSObject.Sub();
        outputSub = new SubscriptionsWSObject.Sub();
        outputSub.SubItem = new List<SubscriptionsWSObject.SubItem>();
        SubscriptionsWSObject.SortParm[] listSortParms= new SubscriptionsWSObject.SortParm[]{};
      //  system.debug('oSubsRequest.listSortParms:-------------------->'+oSubsRequest.listSortParms[0]);
        if(oSubsRequest.listSortParms != null){
        for(SortParm singleSortParm : oSubsRequest.listSortParms){
            SubscriptionsWSObject.SortParm oSortParm = new SubscriptionsWSObject.SortParm();
            oSortParm.ParmName = singleSortParm.sParmName;
            oSortParm.SortDirection = singleSortParm.sSortDirection;
            listSortParms.add(oSortParm);
            }
        }
       // system.debug('listSortParms:-------------------->'+listSortParms[0].ParmName);
        if(Test.isRunningTest()){
            MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
            outputSub = oMockResponse.getMockSub();
         //   outputSubscriptions = (List<SubscriptionsWSObject.Sub>)oMockResponse.mapMockWebServiceResponse.get(MockCalloutGetSubItems);
        }
        else{
            outputSub = oService.GetSubs(oSubsRequest.SystemId,oSubsRequest.AcctSapId,oSubsRequest.CompanyCode,oSubsRequest.SalesOrgCode,oSubsRequest.DistChanCode,oSubsRequest.DivisionCode,oSubsRequest.SubType,oSubsRequest.IncludeActiveSubs,oSubsRequest.IncludeLapsedSubs,oSubsRequest.StartRec,oSubsRequest.MaxResults, listSortParms);
        }
/*system.debug('outputSub :'+outputSub );-- commented to reduce character for s2e optimization */
        TotalofRecs = outputSub.TotalRecs;
        if (outputSub.SubItem != null)
        {
          for(SubscriptionsWSObject.SubItem oSubItem : outputSub.SubItem)
          {
            SubItem oSingleSubItem = new SubItem();
            oSingleSubItem.SubKey = oSubItem.SubKey;
            oSingleSubItem.AcctSapId = oSubItem.AcctSapId;
            oSingleSubItem.CompanyCode = oSubItem.CompanyCode;
            oSingleSubItem.SalesOrgCode = oSubItem.SalesOrgCode;
            oSingleSubItem.DistChanCode = oSubItem.DistChanCode;
            oSingleSubItem.DivisionCode = oSubItem.DivisionCode;
            oSingleSubItem.SubscriptionStatus = oSubItem.SubscriptionStatus;
            oSingleSubItem.MaterialNumber = oSubItem.MaterialNumber;
            oSingleSubItem.MaterialDesc = oSubItem.MaterialDesc;
            oSingleSubItem.ContractNumber = oSubItem.ContractNumber;
            oSingleSubItem.OrderItem = oSubItem.OrderItem;
            oSingleSubItem.ContractStartDt = oSubItem.ContractStartDt;
            oSingleSubItem.ContractEndDt = oSubItem.ContractEndDt;
            oSingleSubItem.TermEndDt = oSubItem.TermEndDt;
            oSingleSubItem.ContractType = oSubItem.ContractType;
            oSingleSubItem.ProductTitle = oSubItem.ProductTitle;
            oSingleSubItem.ProgramDiscountId = oSubItem.ProgramDiscountId;
            oSingleSubItem.ProgramDiscountDesc = oSubItem.ProgramDiscountDesc;
            oSingleSubItem.ProgramDiscountPercent = oSubItem.ProgramDiscountPercent;
            oSingleSubItem.DiscountQuantity = oSubItem.DiscountQuantity;
            oSingleSubItem.Quantity = oSubItem.Quantity;
            oSingleSubItem.ContentGroup = oSubItem.ContentGroup;
            oSingleSubItem.BandedAttorneyCount = oSubItem.BandedAttorneyCount;
            oSingleSubItem.MediaHighLevelCode = oSubItem.MediaHighLevelCode;
            oSingleSubItem.MediaHighLevelDesc = oSubItem.MediaHighLevelDesc;
            oSingleSubItem.DealId = oSubItem.DealId;
            oSingleSubItem.EstimatedUnitUpKeep = oSubItem.EstimatedUnitUpKeep;
            oSingleSubItem.FindlawLocationCode = oSubItem.FindlawLocationCode;
            oSingleSubItem.FindlawLocationDesc = oSubItem.FindlawLocationDesc;
            oSingleSubItem.FindlawPracticeAreaCode = oSubItem.FindlawPracticeAreaCode;
            oSingleSubItem.FindlawPracticeAreaDesc = oSubItem.FindlawPracticeAreaDesc;
            oSingleSubItem.AutoRenewFlag = oSubItem.AutoRenewFlag;
            oSingleSubItem.LapsedReasonCode = oSubItem.LapsedReasonCode;
            oSingleSubItem.LapsedReasonDesc = oSubItem.LapsedReasonDesc;
            oSingleSubItem.LapsedDate = oSubItem.LapsedDate;
            oSingleSubItem.WestpackFlag = oSubItem.WestpackFlag;
            oSingleSubItem.FirstYearDiscount = oSubItem.FirstYearDiscount;
            oSingleSubItem.BandedRetailRate = oSubItem.BandedRetailRate;
            oSingleSubItem.MonthlyCharge = oSubItem.MonthlyCharge;
            oSingleSubItem.PerUserRate = oSubItem.PerUserRate;
            oSingleSubItem.RetailUserRate = oSubItem.RetailUserRate;
            //---initialize additional columns
            oSingleSubItem.TotalEstimatedUpkeep = 0.0;        
            oSingleSubItem.DiscountPerUnit = 0.0;
            oSingleSubItem.TotalPrintDiscount = 0.0;
            oSingleSubItem.TotalUpkeepAfterDiscount = 0.0;
            oSingleSubItem.MinimumIncremental = 0.0;
            listSubItems.add(oSingleSubItem);
            mapSubItems.put(oSingleSubItem.SubKey, oSingleSubItem);
          }
        //  getProducts(mapSubItems.values());
          getProducts(listSubItems);
        }
       // return mapSubItems;
        return listSubItems;
    }
    
    public static PdaItem CalculatePDA(CalculatePDARequest oCalculatePDARequest)
    {
        PdaItem oPdaItem = new PdaItem(); 
        SubscriptionsWS.Subs_v4_0Port oService = new SubscriptionsWS.Subs_v4_0Port();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);      
        oService.inputHttpHeaders_x = new Map<String, String>();
        oService.endpoint_x = oWebServiceSettings.Endpoint__c;
        oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        
        try{
            String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
            string sAuthorizationHeader = 'Bearer ' +accessToken;
            oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        }
        
            catch(Exception e){
            ApexPages.addMessages(e);
    } 
        oService.outputHttpHeaders_x = new Map<String,String>();
        SubscriptionsWSObject.PdaItem outputCalcualtePDA = new SubscriptionsWSObject.PdaItem(); 
        if(Test.isRunningTest()){
            MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
            outputCalcualtePDA = (SubscriptionsWSObject.PdaItem)oMockResponse.mapMockWebServiceResponse.get(MockCalloutCalculatePDA);
        }
        else{
            outputCalcualtePDA = oService.CalculatePda(oCalculatePDARequest.SystemId,oCalculatePDARequest.SubKey,oCalculatePDARequest.DiscountPercent,oCalculatePDARequest.MinimumIncrementalValue);
        }
        if (outputCalcualtePDA != null){
            oPdaItem.TotalEstimatedUpKeep = outputCalcualtePDA.TotalEstimatedUpKeep;
            oPdaItem.TotalDiscount = outputCalcualtePDA.TotalDiscount;
            oPdaItem.TotalUpKeepAfterDiscount = outputCalcualtePDA.TotalUpKeepAfterDiscount;
            oPdaItem.TotalMonthlySavings = outputCalcualtePDA.TotalMonthlySavings;
            oPdaItem.TotalMinimumIncremental = outputCalcualtePDA.TotalMinimumIncremental;
            for(SubscriptionsWSObject.PdaLineItem oSinglePdaLineItem : outputCalcualtePDA.PdaLineItem){
                PdaLineItem oPdalineItem = new PdaLineItem();
                oPdalineItem.SubKey = oSinglePdaLineItem.SubKey;
                oPdalineItem.DiscountPerUnit = oSinglePdaLineItem.DiscountPerUnit ;
                oPdalineItem.EstimatedUpKeep = oSinglePdaLineItem.EstimatedUpKeep ;
                oPdalineItem.Discount = oSinglePdaLineItem.Discount;
                oPdalineItem.UpKeepAfterDiscount = oSinglePdaLineItem.UpKeepAfterDiscount;
                oPdalineItem.MinimumIncremental = oSinglePdaLineItem.MinimumIncremental;
                oPdaItem.PdaLineItem.add(oPdalineItem);
            }   //oPdaItem.PdaLineItem.add(oPdalnItm);
        }
        return oPdaItem;
    }
    
    
   /**
   * Submits the supplied request to the subscription web service to retrieve
   * list of subuserItems
   *
   * @param  oRequest  an instance of an SubsRequest object
   * @return  list<subuserItem> objects representing the results of the web service callout
   *     
   */
  public List<SubUserItem> GetSubUserItem(SubUserRequest oRequest) {
    List<SubUserItem> subUserItemList = new List<SubUserItem>();
    oRequest.SystemId = '1';
    WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('SubscriptionServices');       
    oRequest.endpoint= oWebServiceSettings.Endpoint__c;
    oRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
    //oRequest.username=oWebServiceSettings.Username__c;
    //oRequest.password= oWebServiceSettings.Password__c;  
    try{
            String accessToken=DellBoomiTokenGeneration.getAuthToken();//retreives the token as part of Rocket to Dellboomi migration
            oRequest.accessToken = accessToken;
        }
        
            catch(Exception e){
            ApexPages.addMessages(e);
    }      
    ValidationResult oValidationResult = validateRequest(oRequest);
    if (oValidationResult.IsValid == true){    
      List<SubscriptionsWSObject.SubUserItem> oResponse = new List<SubscriptionsWSObject.SubUserItem>();
      if (Test.isRunningTest()){
        //Get Mock Response
        object oMockResponse = UnitTest.MockWebServiceResponse.get('SubsUser');
        if (oMockResponse instanceof SubscriptionsWSObject.SubUserItem) {
          oResponse.add((SubscriptionsWSObject.SubUserItem) oMockResponse);
        }
      }
      else{
        //Execute Web Service Callout
        oResponse = returnService(oRequest).GetSubUserItem(oRequest.SystemId,oRequest.AcctSapId,oRequest.CompanyCode,oRequest.SalesOrgCode,oRequest.DistChanCode,oRequest.DivisionCode,oRequest.ContractNumber,oRequest.OrderItem);
      }
      //Parse Response
      if(oResponse != null){
           for(integer i = 0; i<oResponse.size() && i<999; i++){ 
              subUserItemList.add(new SubUserItem(oResponse[i])); 
           }         
       }       
    } 
    else {
      throw new SubscriptionServices.ValidationException(oValidationResult.toString());
    }
    return subUserItemList;
  } 
    
    //Private Methods
    
  private static void getProducts(List<SubItem > oSubList){
       if(oSubList != null){       
          List<string> materialNumList = new List<string>();
           List<product2> oProd = new list<product2>();
           Map<string,id> materialnumIdMap = new Map<string,id>();
          for(SubscriptionServices.Subitem oSub: oSubList){
             if(oSub.MaterialNumber != null)  
              materialNumList.add(oSub.MaterialNumber); 
           }              
           oProd= [select id,ProductCode from product2 where ProductCode in: materialNumList];
           for(product2 p:oProd ){
              materialnumIdMap.put(p.ProductCode,p.id);                           
           }
          for(SubscriptionServices.Subitem oSub: oSubList){
            if(oSub.MaterialNumber != null) {
              if(materialnumIdMap.containsKey(oSub.MaterialNumber)) 
                 oSub.productid=materialnumIdMap.get(oSub.MaterialNumber); 
             }    
          }
          materialNumList=null;
          oProd = null;
          materialnumIdMap =null;
       }    
   }    
  
  
  Private SubscriptionsWS.Subs_v4_0Port returnService(Request oRequest){
      SubscriptionsWS.Subs_v4_0Port oService = new SubscriptionsWS.Subs_v4_0Port();
      oService.inputHttpHeaders_x = new Map<String, String>();
      oService.timeout_x = oRequest.Timeout;
      oService.endpoint_x = oRequest.EndPoint;      
      //Blob blobCredentials = Blob.valueOf(oRequest.Username + ':' + oRequest.Password);
      try{
      string sAuthorizationHeader = 'Bearer ' + oRequest.accessToken;      
      oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
      }
      catch(Exception e){
            ApexPages.addMessages(e);
    }      
      oService.outputHttpHeaders_x = new Map<String,String>();
      return oService;
  }
     
  
  /**
   * Validates that all required fields are populated for the specified Request
   *
   * @param  oRequest  an instance of a Request object to validate
   * @return  an instance of a ValidationResult representing the results of the validation test
   */
  private ValidationResult validateRequest(Request oRequest){
    ValidationResult oValidation = new ValidationResult();
    oValidation.IsValid = true;
    if (oRequest != null) {
      //Validate Request Credentials
      boolean isMissingEndPoint = AppUtil.isEmpty(oRequest.EndPoint);
       //boolean isMissingaccessToken = String.isEmpty(oRequest.accessToken);
      if (isMissingEndpoint){
        oValidation.IsValid = false;
        oValidation.Failures.add('Invalid request. Web service endpoint is not configured');
      }
      //Validate Timeout Limit
      boolean isTimeoutValid = (oRequest.Timeout > 0);
      if (!isTimeoutValid){
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
   
   public virtual class Request{
    //Properties
    public string EndPoint {get;set;}
    public string Username {get;set;}
    public string Password {get;set;}
       public String accessToken {get;set;}
    public integer Timeout {get;set;}
    public String CompanyCode {get;set;}
    public String SalesOrgCode {get;set;}
    public String DistChanCode {get;set;}
    public String DivisionCode {get;set;}
  }
  
     public class ValidationException extends Exception {}
  /**
   * Data structure representing an Subscription request
   * 
   */
  public class SubsRequest extends Request{
    //Properties
    public string SystemId{get;set;}
    public decimal[] AcctSapId{get;set;}    
    public String SubType{get;set;}
    public Boolean IncludeActiveSubs{get;set;}
    public Boolean IncludeLapsedSubs{get;set;} 
    public Integer StartRec{get;set;}
    public Integer MaxResults{get;set;}
    public SortParm[] listSortParms{get;set;}
  }
  
  /**
   * Data structure representing an subline request
   * 
   */
  
  public class SubLineRequest extends Request{
    //Properties
    public string SystemId{get;set;}    
    public decimal AcctSapId{get;set;}
    public string ContractNumber{get;set;}    
  }
  
  /**
   * Data structure representing an subuser request
   * 
   */
  
  public class SubUserRequest extends Request{
    //Properties
    public string SystemId{get;set;}    
    public decimal AcctSapId{get;set;}
    public string ContractNumber{get;set;}
    public String OrderItem{get;set;}   
  }
    
  public class CalculatePDARequest{
        public String SystemId{get;set;}
        public String[] SubKey{get;set;}
        public Decimal DiscountPercent{get;set;}
        public Decimal MinimumIncrementalValue{get;set;}
    }
    
    public class PdaLineItem{
        public String SubKey{get;set;}
        public Decimal DiscountPerUnit{get;set;}
        public Decimal EstimatedUpKeep{get;set;}
        public Decimal Discount{get;set;}
        public Decimal UpKeepAfterDiscount{get;set;}
        public Decimal MinimumIncremental{get;set;}
    }
    public class PdaItem{
        public Decimal TotalEstimatedUpKeep{get;set;}
        public Decimal TotalDiscount{get;set;}
        public Decimal TotalUpKeepAfterDiscount{get;set;}
        public Decimal TotalMonthlySavings{get;set;}
        public Decimal TotalMinimumIncremental{get;set;}
        public PdaLineItem[] PdaLineItem{get;set;}
        public PdaItem(){
            TotalEstimatedUpKeep = 0.0;
            TotalDiscount = 0.0;
            TotalUpKeepAfterDiscount = 0.0;
            TotalMonthlySavings = 0.0;
            TotalMinimumIncremental = 0.0;
            PdaLineItem = new PdaLineItem[]{};
        }
    }
  public class SubItem{
        public String SubKey{get;set;}
        public Decimal AcctSapId{get;set;}
        public String CompanyCode{get;set;}
        public String SalesOrgCode{get;set;}
        public String DistChanCode{get;set;}
        public String DivisionCode{get;set;}
        public String SubscriptionStatus{get;set;}
        public String MaterialNumber{get;set;}
        public String MaterialDesc{get;set;}
        public String ContractNumber{get;set;}
        public String OrderItem{get;set;}
        public Date ContractStartDt{get;set;}
        public Date ContractEndDt{get;set;}
        public Date TermEndDt{get;set;}
        public String ContractType{get;set;}
        public String ProductTitle{get;set;}
        public String ProgramDiscountId{get;set;}
        public String ProgramDiscountDesc{get;set;}
        public Integer ProgramDiscountPercent{get;set;}
        public Integer DiscountQuantity{get;set;}
        public Integer Quantity{get;set;}
        public String ContentGroup{get;set;}
        public String BandedAttorneyCount{get;set;}
        public String MediaHighLevelCode{get;set;}
        public String MediaHighLevelDesc{get;set;}
        public String DealId{get;set;}
        public Decimal EstimatedUnitUpKeep{get;set;}
        public String FindlawLocationCode{get;set;}
        public String FindlawLocationDesc{get;set;}
        public String FindlawPracticeAreaCode{get;set;}
        public String FindlawPracticeAreaDesc{get;set;}
        public Boolean AutoRenewFlag{get;set;}
        public String LapsedReasonCode{get;set;}
        public String LapsedReasonDesc{get;set;}
        public Date LapsedDate{get;set;}
        public Boolean WestpackFlag{get;set;}
        public Decimal FirstYearDiscount{get;set;}
        public Decimal BandedRetailRate{get;set;}
        public Decimal MonthlyCharge{get;set;}
        public Decimal PerUserRate{get;set;}
        public Decimal RetailUserRate{get;set;}
        //Following are additional columns apart from the ones sent from webservice
        public id Productid{get;set;}         
        public Decimal TotalEstimatedUpkeep{get;set;}        
        public Decimal DiscountPerUnit{get;set;}
        public Decimal TotalPrintDiscount{get;set;}
        public Decimal TotalUpkeepAfterDiscount{get;set;}
        public Decimal MinimumIncremental{get;set;}
        
  }
    public class Sub{
        public Integer iStartRec;
        public Integer iEndRec;
        public Integer iTotalRecs;
        public List<SubItem> listSubItem;
    }
  
    /**
   * Data structure representing an Subscription user Item*/ 
    public class SubUserItem{
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public String WestlawUserId{get;set;}
        public String WestlawPassword{get;set;}
        public String SapRole{get;set;}
        public SubUserItem(){}
        Public SubUserItem(SubscriptionsWSObject.SubUserItem oSubUserItem){
            FirstName=oSubUserItem.FirstName;
            LastName=oSubUserItem.LastName;
            WestlawUserId=oSubUserItem.WestlawUserId;
            WestlawPassword=oSubUserItem.WestlawPassword;
            SapRole=oSubUserItem.SapRole;
        }
    }
    
    /**
   * Data structure representing an Subscription user Item
   */ 
    public class SortParm {
        public String sParmName;
        public String sSortDirection;        
    }
  }