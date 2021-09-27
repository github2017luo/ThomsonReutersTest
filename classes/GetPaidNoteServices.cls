/**
 * Provides helper methods for interacting with the Order web service
 *
 * @author      Shawn Gray
 * @version     2012-04-18
 * @dependencies  
 */
 
/**
 * CHANGE HISTORY
 * -------------------------------------------------------------------------------------------------------------------
 *  Date          Name               Description
 *  2012-04-19    Shawn Gray         Created
 *  2020-03-23    Shyamsundar Shet   BMP-1592 - Inserted the Token generation operation as part of Rocket services to Dellboomi migration

 * -------------------------------------------------------------------------------------------------------------------
 */
public with sharing class GetPaidNoteServices {
  //Constants
  public static final string WebServiceName = 'GetPaidNoteServices';
  public static final string MockCalloutGetPaidNoteItems = 'GetNotes';
  
  /**
   * Retrieves GetPaidNote info utilizing the GetPaid web service.
   *
   * @param  dSAPCustomerNumber  the SAP unique customer number
      */
  public static list<PaidNoteInfo> GetPaidNotesInfo(GetPaidNoteServices.GetPaidNotesRequest oGetPaidNotesRequest) {
    list<PaidNoteInfo> oPaidNoteInfo = new list<PaidNoteInfo>();
    
    if (oGetPaidNotesRequest.AcctSapId != null) {
      WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

      GetPaidNoteServicesWS.GetPaidNote_v2_0Port oService = new GetPaidNoteServicesWS.GetPaidNote_v2_0Port();
      oService.inputHttpHeaders_x = new Map<String, String>();
      // oService.inputHttpHeaders_x<'Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='>;
      // oService.inputHttpHeaders_x['Authorization:'] = 'Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ='; 
      oService.endpoint_x = oWebServiceSettings.Endpoint__c;
      oService.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
      
      
      //  oService.inputHttpHeaders_x.put('Authorization:','Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=');
      try{
            String accessToken=DellBoomiTokenGeneration.getAuthToken(); //retreives the token as part of Rocket to Dellboomi migration
            string sAuthorizationHeader = 'Bearer ' +accessToken;
      //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
      //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
      oService.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
                }
            catch(Exception e){
            ApexPages.addMessages(e);
    } 
      // oService.inputHttpHeaders_x.put('Authorization', 'Basic U0ZEQ1RFU1Q6c2ZkY3RlJHQ=');
      oService.outputHttpHeaders_x = new Map<String,String>();
      
     
      list<GetPaidNoteServicesWS.GetPaidNoteItem> outputPaidNote = new list<GetPaidNoteServicesWS.GetPaidNoteItem>();
      if (Test.isRunningTest()) {
        //Get Mock Response
        object oMockResponse = UnitTest.MockWebServiceResponse.get(MockCalloutGetPaidNoteItems);
  
        if (oMockResponse instanceof list<GetPaidNoteServicesWS.GetPaidNoteItem>) {
          outputPaidNote= (list<GetPaidNoteServicesWS.GetPaidNoteItem>)oMockResponse;
        }
      }
      else {
        //Execute Web Service Callout                                                      
        outputPaidNote = oService.GetNotes(oGetPaidNotesRequest.AcctSapId, oGetPaidNotesRequest.CompanyCode, oGetPaidNotesRequest.SalesOrgCode, oGetPaidNotesRequest.DistChanCode, oGetPaidNotesRequest.DivisionCode, oGetPaidnotesRequest.ModifiedDtStart, ogetpaidnotesrequest.ModifiedDtEnd);
      }
      
      //  oMaterialPlanInfo.PrimaryMaterials = new List<ContentOptimizerService.MaterialItem>();
      
            if (outputPaidNote == null) {
    
  }
  else {
  for (GetPaidNoteServicesWS.GetPaidNoteItem oPaidNoteList : outputPaidNote) {
    GetPaidNoteServices.PaidNoteInfo oPaidNotedetail = new GetPaidNoteServices.PaidNoteInfo();

       oPaidNotedetail.CollectorCode = oPaidNoteList.CollectorCode;
        oPaidNotedetail.CollectorName = oPaidNoteList.CollectorName;
        oPaidNotedetail.CreateDt = oPaidNoteList.CreateDt;
        oPaidNotedetail.ModifyDt = oPaidNoteList.ModifyDt;
        oPaidNotedetail.Note = oPaidNoteList.Note;
  
       oPaidNoteInfo.add(oPaidNotedetail);
      
  }
  }
    }
    else {
      throw new ContentOptimizerServiceException('Invalid SAP Customer Number');
    }
    
    return oPaidNoteInfo;
  }
  


  //Internal Classes
  
  /**
   * Custom Exception thrown a web service callout fails
   */
  public class ContentOptimizerServiceException extends Exception {}
  
  /**
   * Data structure representing customer information
   */

    public class PaidNoteInfo {
        public String CollectorCode{get;set;}
        public String CollectorName{get;set;}
        public DateTime CreateDt{get;set;}
        public DateTime ModifyDt{get;set;}
        public String Note{get;set;}
    
  }
       
        public class GetPaidNotesRequest {
        public Decimal AcctSapId;
        public String CompanyCode;
        public String SalesOrgCode;
        public String DistChanCode;
        public String DivisionCode;
        public Date ModifiedDtStart;
        public Date ModifiedDtEnd;  
        }  
}