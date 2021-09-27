/**
 * Contains methods for CredentialInfo VF Page
 * Depends on IPRestrictionWS and  IPRestrictionWS Objects Class which are created using the wsdl file
 *
 * @author  Zahedul Hossain
 * @version  2013-06-26
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * =============================================================================
 */
 
public with sharing class IPRestrictionServices{

public static list<IPRestrictionItem> listIPRestrictionItem;
public static list<IPRestrictionWSObject.IPRestrictionItem> ResponseIPInfo;
public static final string WebServiceName = 'IPRestrictionServices';


public static List<IPRestrictionItem> getIPRestrictItems(IPRestrictRequest oIPRequest)
        {
          
    
            listIPRestrictionItem = new list<IPRestrictionItem>();
            IPRestrictionWS.IPRestriction_v2_0Port oIPRequestObj = new IPRestrictionWS.IPRestriction_v2_0Port();
              WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);      
              oIPRequestObj.inputHttpHeaders_x = new Map<String, String>();
              oIPRequestObj.endpoint_x = oWebServiceSettings.Endpoint__c;
              oIPRequestObj.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
              Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
              string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
              oIPRequestObj.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            ResponseIPInfo = new list<IPRestrictionWSObject.IPRestrictionItem>();
                          
           if(Test.isRunningTest())
                  {
                      MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
                      ResponseIPInfo = oMockResponse.getMockIPInfo();
                  
                  }
                  else
                  {                
                    ResponseIPInfo = oIPRequestObj.GetIPRestriction(oIPRequest.Domain,oIPRequest.AcctSapId,oIPRequest.ValidityDt);
                  }
            
    
             if( ResponseIPInfo != null){
            for(IPRestrictionWSObject.IPRestrictionItem ipitem : ResponseIPInfo){
                listIPRestrictionItem.add(new IPRestrictionItem(ipitem));
            }
           }
        return listIPRestrictionItem;
    }
    
    public class IPRestrictRequest
    {
      //Properties
        
        public String Domain{get;set;}
        public decimal AcctSapId{get;set;}    
        public Date ValidityDt{get;set;}
       
    }
    
    public class IPRestrictionItem
    {
            public Decimal AcctSapId{get;set;} 
            public String GroupType{get;set;} 
            public String GroupID{get;set;} 
            public String IPRestrictionType{get;set;} 
            public String IPRestrictionDesc{get;set;} 
            public String IPAddress{get;set;} 
            public String IPUpper{get;set;} 
            public String CountryCode{get;set;} 
            public String CountryDesc{get;set;} 
            public Date EffectiveBegDt{get;set;} 
            public Date EffectiveEndDt{get;set;} 
            
                public IPRestrictionItem(IPRestrictionWSObject.IPRestrictionItem oIPitem)
                {
                    AcctSapId = oIPitem.AcctSapId; 
                    GroupType = oIPitem.GroupType;
                    if(GroupType != '')
                    {
                    GroupType = KeyValueListStore__c.getInstance(GroupType).TextValue__c;
                    }
            
                    GroupID = oIPitem.GroupID;
                    IPRestrictionType = oIPitem.IPRestrictionType;
                    IPRestrictionDesc = oIPitem.IPRestrictionDesc;
                    IPAddress = oIPitem.IPAddress;
                    IPUpper = oIPitem.IPUpper;
                    CountryCode = oIPitem.CountryCode;
                    CountryDesc = oIPitem.CountryDesc;
                    EffectiveBegDt = oIPitem.EffectiveBegDt;
                    EffectiveEndDt = oIPitem.EffectiveEndDt;
                
                }
            
    }
}