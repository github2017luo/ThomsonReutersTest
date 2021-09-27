/*============================================================================================
    Name                : DC_CallToFetchRecommendations
    Description         : This class is developed as part of CXD-Renewal project. ESI service is getting invoked in this class to get recommandations details
    Created Date        : 02/28/2019
    Created by          : Navleen Kaur
    History: 
    Date           Name                    Description   
    02/28/2019     Navleen Kaur            DLT-14147 : SLF][SFDC] Expose Small Law Recommendations to Sales Channel 
    03/26/2019     Navleen Kaur            DLT-15710 : Expose Small Law Recommendations to Sales Channel - Integrate ESI Service 
    05/29/2019     Navleen Kaur            DLT-16590 : Added ApexPages.SEVERITY.Info 
    06/06/2019     Navleen Kaur            DLT-16785 : [Tech Story] [Code Scan] - Fix code scan CRITICAL and Major issues in this DC_CallToFetchRecommendations.cls
===============================================================================================*/

public with sharing class DC_CallToFetchRecommendations{
    
    private static Final String  LOGIN_USER_ID= UserInfo.getUserEmail();
    private static Final String SOURCE_SYSTEM_APP = 'SFDC_GLI';
    private static Final String CONTENT_TYPE = 'application/json;charset=UTF-8';
    private static Final String ACCEPT = 'application/json';
    
    //calling ESI service for recommendation details
    public static DCRecommendationDetailsResponse invokeESIDetails(string custNum){ 
        DCRecommendationDetailsResponse esiResp = new DCRecommendationDetailsResponse();           
        try{
        // get the Callout parameters from Custom Setting
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('CXDRecommendationService');
        
            String username = oWebServiceSettings.Username__c;
            String password = oWebServiceSettings.Password__c;
    
            blob  headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
            
            String rawURL = 'applicationId='+Label.CXD_ESI_App_userID+'&sourceSystemApp='+SOURCE_SYSTEM_APP+'&loginUserId='+LOGIN_USER_ID+'&customerNumber='+custNum;
        
        
            HttpRequest req = new HttpRequest(); 
            req.setMethod('GET');
            req.setEndpoint(oWebServiceSettings.Endpoint__c+'?'+rawURL);
            req.setHeader('Content-Type', CONTENT_TYPE);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Accept', ACCEPT);
            req.setTimeout(120000)  ;
            System.debug('req'+req);
            Http http = new Http();
            HTTPResponse res;
               
        if(!test.isrunningtest()){
              system.debug('****not test***');
              res = http.send(req);
        }else{
            //Test Classes Response.
            system.debug('****test***');
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "ESIHeader" : { "applicationId" : "CXECOMM" }, "customerDetails" : { "name" : "MASSEY STOTSER & NICHOLS PC", "lastUpdatedDate" : "2019-02-25T09:44:21.000+00:00", "customerNumber" : 1000000149, "renewalDate" : 20200531, "alreadySimplified" : "YES", "currContractTerm" : "3 Yr", "currentMCV" : 6411.01, "upsellLevel" : "Medium", "usageProfile" : "High", "attorneyCount" : 10, "existingMaterials" : [ { "productTitle" : "SL National Litigation (Westlaw PRO™) (Banded)", "targetQty" : null, "currentMaterialNum" : 42009517, "currentServiceNum" : "42009516", "bandPrice" : 3341, "aggRectxt" : "Currently used", "netTransactionsCount" : 3451 }, { "productTitle" : "SL National Analytical (Westlaw PRO™) (Banded)", "targetQty" : null, "currentMaterialNum" : 42004987, "currentServiceNum" : "42004985", "bandPrice" : 1966, "aggRectxt" : "Currently used", "netTransactionsCount" : 989 }, { "productTitle" : "PeopleMap Premier and Company Investigator (Westlaw PRO™) (Banded)", "targetQty" : null, "currentMaterialNum" : 41895491, "currentServiceNum" : "41895320", "bandPrice" : 1630, "aggRectxt" : "Currently used", "netTransactionsCount" : 208 }, { "productTitle" : "Practical Law Connect Multi-Practice Area SSLF (Banded)", "targetQty" : null, "currentMaterialNum" : 41928266, "currentServiceNum" : "41928265", "bandPrice" : 1453, "aggRectxt" : "Currently used", "netTransactionsCount" : 81 }, { "productTitle" : "SL All States and Federal Primary Law (Westlaw PRO™) (Banded)", "targetQty" : null, "currentMaterialNum" : 42076534, "currentServiceNum" : "42076533", "bandPrice" : 988, "aggRectxt" : "Currently used", "netTransactionsCount" : 271 }, { "productTitle" : "Drafting Assistant (Banded)", "targetQty" : null, "currentMaterialNum" : 42072689, "currentServiceNum" : "42072690", "bandPrice" : 502, "aggRectxt" : "Usage not assessed", "netTransactionsCount" : 0 }, { "productTitle" : "WN PRO PLCNT WL CORE BANDED", "targetQty" : null, "currentMaterialNum" : 41862110, "currentServiceNum" : null, "bandPrice" : 0, "aggRectxt" : "Currently used", "netTransactionsCount" : 632 }, { "productTitle" : "WN PRO SL PLCNT MPA PI BANDED", "targetQty" : null, "currentMaterialNum" : 41937673, "currentServiceNum" : null, "bandPrice" : 0, "aggRectxt" : "Currently used", "netTransactionsCount" : 3972 }, { "productTitle" : "DWN DRAFTING TRANS BANDED", "targetQty" : null, "currentMaterialNum" : 41732245, "currentServiceNum" : null, "bandPrice" : 0, "aggRectxt" : "Currently used", "netTransactionsCount" : 4 }, { "productTitle" : "DWN DRAFTING LIT PRO BANDED", "targetQty" : null, "currentMaterialNum" : 41732241, "currentServiceNum" : null, "bandPrice" : 0, "aggRectxt" : "Currently used", "netTransactionsCount" : 2042 }, { "productTitle" : "WN PRO SL PLCNT MPA PL BANDED", "targetQty" : null, "currentMaterialNum" : 42072242, "currentServiceNum" : null, "bandPrice" : 0, "aggRectxt" : "Currently used", "netTransactionsCount" : 1 }, { "productTitle" : "WN PRO PLCNT PL CORE BANDED", "targetQty" : null, "currentMaterialNum" : 41866664, "currentServiceNum" : null, "bandPrice" : 0, "aggRectxt" : "Currently not used", "netTransactionsCount" : 0 } ], "recommandedMaterials" : [ { "productTitle" : "Copyright Registration (Banded)", "targetQty" : null, "rcmdSubsMaterialNumber" : "41016777", "rcmdServiceNumber" : "41017745", "bandPrice" : 61, "aggRectxt" : "Ancillary Usage and Declines", "ancillaryAmount" : 25.35, "declinesCNT" : 1, "cmtFlag" : null, "finalRank" : 13 }, { "productTitle" : "SL Expert Witness Materials and Reports (Westlaw PRO™) (Banded)", "targetQty" : null, "rcmdSubsMaterialNumber" : "42005264", "rcmdServiceNumber" : "42005263", "bandPrice" : 849, "aggRectxt" : "Declines", "ancillaryAmount" : 0, "declinesCNT" : 4, "cmtFlag" : null, "finalRank" : 14 }, { "productTitle" : "SL CCH Government Contracts (Westlaw PRO™) (Banded)", "targetQty" : null, "rcmdSubsMaterialNumber" : "42005244", "rcmdServiceNumber" : "42005243", "bandPrice" : 979, "aggRectxt" : "Declines", "ancillaryAmount" : 0, "declinesCNT" : 2, "cmtFlag" : null, "finalRank" : 15 }, { "productTitle" : "SL Court Wire and Dockets (Westlaw PRO™) (Banded)", "targetQty" : null, "rcmdSubsMaterialNumber" : "42012404", "rcmdServiceNumber" : "42012403", "bandPrice" : 373, "aggRectxt" : "Declines", "ancillaryAmount" : 0, "declinesCNT" : 2, "cmtFlag" : null, "finalRank" : 16 }, { "productTitle" : "SL 50 State Surveys (Westlaw PRO™) (Banded)", "targetQty" : null, "rcmdSubsMaterialNumber" : "42009641", "rcmdServiceNumber" : "42009640", "bandPrice" : 2382, "aggRectxt" : "Declines", "ancillaryAmount" : 0, "declinesCNT" : 1, "cmtFlag" : null, "finalRank" : 17 }, { "productTitle" : "SL Domestic and International Arbitration (Westlaw PRO™) (Banded)", "targetQty" : null, "rcmdSubsMaterialNumber" : "42011566", "rcmdServiceNumber" : "42011565", "bandPrice" : 494, "aggRectxt" : "Declines", "ancillaryAmount" : 0, "declinesCNT" : 1, "cmtFlag" : null, "finalRank" : 18 }, { "productTitle" : "National Reporter Images (Westlaw PRO™) (Banded)", "targetQty" : null, "rcmdSubsMaterialNumber" : "40963411", "rcmdServiceNumber" : "40968624", "bandPrice" : 113, "aggRectxt" : "Declines", "ancillaryAmount" : 0, "declinesCNT" : 1, "cmtFlag" : null, "finalRank" : 19 }, { "productTitle" : "SL Multi-Practice Area Analytical (Westlaw PRO™) (Banded)", "targetQty" : null, "rcmdSubsMaterialNumber" : "42009647", "rcmdServiceNumber" : "42009646", "bandPrice" : 593, "aggRectxt" : "Recommended Premium plan", "ancillaryAmount" : null, "declinesCNT" : null, "cmtFlag" : null, "finalRank" : 20 }, { "productTitle" : "West LegalEdcenter (Per Seat/Qty)", "targetQty" : 10, "rcmdSubsMaterialNumber" : "42144803", "rcmdServiceNumber" : "42144804", "bandPrice" : 220, "aggRectxt" : null, "ancillaryAmount" : null, "declinesCNT" : null, "cmtFlag" : null, "finalRank" : null } ] } }');
            res.setStatusCode(200); 
        } 
        system.debug('222222       '+res+'      '+res.getBody());    
        if(res.getStatusCode()== 200){  
           try{
            system.debug('From TRy..........');
            esiResp = (DCRecommendationDetailsResponse)JSON.deserialize(res.getBody(), DCRecommendationDetailsResponse.class);            
           
           }catch(exception e){
              system.debug('From catch..........');             
              //esiResp = (DCRecommendationDetailsResponse)JSON.deserialize(res.getBody().replacefirst('null', '{ }'), DCRecommendationDetailsResponse.class);            
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,+'There are no materials for the corresponding Customer'));
        }
        }
        }catch(Exception e){
            system.debug('Line Number- 199: '+e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,+'There are no materials for the corresponding Customer'));
        }
        system.debug('&#$$esiResp'+esiResp);
          return esiResp;  
          
     }
}