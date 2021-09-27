/**
 * Contains methods for CredentialInfo VF Page
 * Depends on ServiceNotesServicesWS and  ServiceNotesServicesWS Objects Class which are created using the wsdl file
 *
 * @author  Zahedul Hossain
 * @version  2013-06-25
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * =============================================================================
 */
 
public with sharing class CredentialInfoServices{
public static list<CredentialInfoBusinessRestrictionItem> listCredentialInfoBusinessRestrictionItem;
public static CredentialInfoWSObject.CredentialInfoBusinessRestrictionItem ResponseCredentialInfo ;
public static final string WebServiceName = 'CredentialInfoServices';

   

public static List<CredentialInfoBusinessRestrictionItem> getCredentialInfoItems(CredentialRequest oCredentialRequest)
    {
      
       
        
        listCredentialInfoBusinessRestrictionItem = new list<CredentialInfoBusinessRestrictionItem>();
        
        CredentialInfoWS.CredentialInfo_v2_0Port oRequestObj = new CredentialInfoWS.CredentialInfo_v2_0Port();
          WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);      
          oRequestObj.inputHttpHeaders_x = new Map<String, String>();
          oRequestObj.endpoint_x = oWebServiceSettings.Endpoint__c;
          oRequestObj.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
          Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
          string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
          oRequestObj.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        ResponseCredentialInfo = new CredentialInfoWSObject.CredentialInfoBusinessRestrictionItem();
                      
      if(Test.isRunningTest())
        {
         MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
         ResponseCredentialInfo = oMockResponse.getMockCredInfo();
         }
         else
         {
         ResponseCredentialInfo = oRequestObj.getCredentialInfo(oCredentialRequest.AcctSapId,oCredentialRequest.CompanyCode,oCredentialRequest.SalesOrgCode,oCredentialRequest.DistChanCode,oCredentialRequest.DivisionCode);
        }
     if(ResponseCredentialInfo.CredentialInfoItem!=null){
     for(CredentialInfoWSobject.CredentialInfoItem oitem : ResponseCredentialInfo.CredentialInfoItem)
     {
        listCredentialInfoBusinessRestrictionItem.add(new CredentialInfoBusinessRestrictionItem(oitem));
        
     }
     }
    
    if ( ResponseCredentialInfo.BusinessRestrictionItem != null)
    {
    for(CredentialInfoWSobject.BusinessRestrictionItem oIPitem : ResponseCredentialInfo.BusinessRestrictionItem){
        listCredentialInfoBusinessRestrictionItem.add(new CredentialInfoBusinessRestrictionItem(oIPitem));
        
    }
    }
    return listCredentialInfoBusinessRestrictionItem;
}



public class CredentialRequest{
    //Properties
    
    public decimal AcctSapId{get;set;}    
    public String CompanyCode{get;set;}
    public String SalesOrgCode{get;set;}
    public String DistChanCode{get;set;}
    public String DivisionCode{get;set;}
    
    
  }
  
      
    //intermediate Class to combine the response list
    
    public class CredentialInfoBusinessRestrictionItem
    {
        public String Domain{get;set;} 
        public String CredentialProgress{get;set;}
        public String CredentialProgressDesc{get;set;}
        public String CredentialStatus{get;set;}
        public String CredentialStatusDesc{get;set;}
        public String BusinessType{get;set;}
        public String BusinessTypeDesc{get;set;}
        public String RestrictionCls{get;set;}
        public String RestrictionClsDesc{get;set;}
        public Date ProgessDt{get;set;}
        public Date StatusDt{get;set;}
        public Date OnsiteInspectionDt{get;set;}
        public String BusinessRestriction{get;set;}
        public String BusinessRestrictionDesc{get;set;}
        
                
        public CredentialInfoBusinessRestrictionItem(CredentialInfoWSObject.CredentialInfoItem oCredentialInfoItem)
        {
            Domain = oCredentialInfoItem.Domain;
            
            CredentialProgress = oCredentialInfoItem.CredentialProgress;
            CredentialProgressDesc = oCredentialInfoItem.CredentialProgressDesc;
            CredentialStatus = oCredentialInfoItem.CredentialStatus;
            CredentialStatusDesc = oCredentialInfoItem.CredentialStatusDesc;
            BusinessType = oCredentialInfoItem.BusinessType;
            BusinessTypeDesc = oCredentialInfoItem.BusinessTypeDesc;
            RestrictionCls = oCredentialInfoItem.RestrictionCls;
            RestrictionClsDesc = oCredentialInfoItem.RestrictionClsDesc;
            ProgessDt = oCredentialInfoItem.ProgessDt;
            StatusDt = oCredentialInfoItem.StatusDt;
            OnsiteInspectionDt = oCredentialInfoItem.OnsiteInspectionDt;
         
        }
        
        public CredentialInfoBusinessRestrictionItem(CredentialInfoWSObject.BusinessRestrictionItem oBusinessRestrictionItem)
        {
            BusinessRestriction = oBusinessRestrictionItem.BusinessRestriction;
            BusinessRestrictionDesc = oBusinessRestrictionItem.BusinessRestrictionDesc;
        }
    }
        

        
   
}