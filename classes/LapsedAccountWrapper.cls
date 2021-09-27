/*============================================================================================
    Name                : LapsedAccountWrapper
    Description         : This class is developed as part of CXD-ODT project and serves as a wrapper class for lapsed account service. 
    Created Date        : 11/6/2018 
    Author              : TCS CXD ODT team
 
==============================================================================================*/
public class LapsedAccountWrapper {

   
    public static LapsedReqWrapper checkLapsedAccountDetails(string accountNum){
       //Passing ESI Header Details
       EsiHeaderWrap esiHeader = new EsiHeaderWrap();
       esiHeader.applicationId = Label.ODT_ESI_App_userID;
       esiHeader.companyId = 'WEST';
       esiHeader.postBackURL= '';
        
        //Passing Account Details 
        AccountDetails acc= new AccountDetails();
        acc.accountNumber = accountNum;
        
        LIST<AccountDetails> accLt = new LIST<AccountDetails >();
        accLt.add(acc);
        
        //Passing required Information details 
       GetSubscriptionsByAccountFilterWrap  getSubscriptionsByAccountFilter = new GetSubscriptionsByAccountFilterWrap ();
       
        getSubscriptionsByAccountFilter.subType = 'ALL Active';
        getSubscriptionsByAccountFilter.includeLapsedSubs= 'true';
        getSubscriptionsByAccountFilter.includeActiveSubs= 'false';
        getSubscriptionsByAccountFilter.endRecord = 'string';
        getSubscriptionsByAccountFilter.startRecord= '1';
        getSubscriptionsByAccountFilter.totalRecords= 'string';
        getSubscriptionsByAccountFilter.maxResults= '100';
        getSubscriptionsByAccountFilter.subType = 'ALL';
        getSubscriptionsByAccountFilter.sortParm = new LIST<SortParmESI >();
        
        SortParmESI  sp = new SortParmESI ();
        sp.parmName = 'MATERIAL_DESC';
        sp.sortDirection = 'ascending';
        getSubscriptionsByAccountFilter.sortParm.add(sp);
        
        
        LapsedReqWrapper lp = new LapsedReqWrapper(esiHeader, accLt , getSubscriptionsByAccountFilter);
        
        return lp;
        
    }
    
    
    public class LapsedReqWrapper{
    
        public EsiHeaderWrap esiHeader;
        public LIST<AccountDetails>  account;
        public GetSubscriptionsByAccountFilterWrap getSubscriptionsByAccountFilter;
        
        public LapsedReqWrapper(EsiHeaderWrap eh, LIST<AccountDetails> ac, GetSubscriptionsByAccountFilterWrap gs){
            esiHeader = new EsiHeaderWrap();
            account = new LIST<AccountDetails>();
            getSubscriptionsByAccountFilter = new GetSubscriptionsByAccountFilterWrap ();
            
            esiHeader = eh;
            account = ac;
            getSubscriptionsByAccountFilter = gs;
            
        }
    }
    
    public class AccountDetails {
        public String accountNumber;
    }

    public class GetSubscriptionsByAccountFilterWrap  {
        public String subType;
        public String includeLapsedSubs;
        public String includeActiveSubs;
        public String startRecord;
        public String endRecord;
        public String totalRecords;
        public String maxResults;
        public List < SortParmESI > sortParm;
    }

    
    public class EsiHeaderWrap {
        public String applicationId;
        public String companyId;
        public String postBackURL;
    }

    public class SortParmESI {
        public String parmName;
        public String sortDirection;
    }
 
 
     public static HttpRequest callESIService(string esiJsonReq, WebServiceSettings__c ws){
     
     
        String username = ws.Username__c;
        String password = ws.Password__c;
    
        blob  headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
     
     
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setEndpoint(ws.Endpoint__c);
        req.setHeader('Authorization', authorizationHeader );
        req.setBody(esiJsonReq);
        
         req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(120000)  ;
       
         
        return req;
     
     }
 
 
 
     
}