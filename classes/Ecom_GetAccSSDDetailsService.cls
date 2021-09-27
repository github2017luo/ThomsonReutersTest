/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                     Name                                          Description
 * 2018-11-12   Shiva Sri Arun Koralla         DLT-13160 [NSE ALL][Tech Story] Bill to Account Login service
 * 2018-11-12   Shiva Sri Arun Koralla         DLT-12487 [NSE ALL] Identify Subscriptions
 * 2018-11-12   Shiva Sri Arun Koralla         DLT-12488  [NSE ALL] Confirm Account is Bill to Account Eligible
 * 2018-11-22   Ramesh Reddy                   DLT-12983 [NSE ALL] Create Lead for Customers Not Allowed to Purchase (From Log In)
 * ==================================================================================================================================   
 */
@RestResource(urlMapping='/ecom/getAccSSDDetails/*')
global without sharing class Ecom_GetAccSSDDetailsService {

    public string storeName;
   @HttpPost
    global static getAccSSDDetailsResponse api(Ecom_GetAccSSDDetailsRequest req){
        getAccSSDDetailsResponse response = new getAccSSDDetailsResponse();
        
  
        if(req ==null || String.isBlank(req.Params.AccountNumber)||String.isBlank(req.Params.zipCode)){
            response.responseCode = 1002;
            response.responseMessage = 'AccountNumber and zipCode should not be empty ';
            response.isRecordFound = false;
            return response;
        }
        try{
            Ecom_GetAccSSDDetailsService service = new Ecom_GetAccSSDDetailsService();
            response = service.getAccSSDDetails(req.params,req.validations);
        }catch(Exception ex){
            DCUtils.trackLog(ex,'Ecom_GetAccSSDDetailsService','api');
            response.responseMessage = ex.getMessage();
            response.responseCode = 1006;  //1006
            response.isRecordFound = false;
        }
        
        return response; 
    }
    
    public getAccSSDDetailsResponse getAccSSDDetails(Ecom_GetAccSSDDetailsRequest.cls_GetAccSSDDetailsRequest inputParam,Ecom_GetAccSSDDetailsRequest.cls_validations validations)
   {

        getAccSSDDetailsResponse response = new getAccSSDDetailsResponse();
        response.accountSSDDetails = new cls_accountSSDDetails();
        response.accountSSDDetails.address = new cls_address();
        response.accountSSDDetails.physicalAddress = new cls_address();
        response.validationStatus = new cls_validationStatus();
        response.isRecordFound = true;
        response.validationStatus.creditCheck = 'NA';
        response.validationStatus.activeOnlineSubsCheck = 'NA';
        response.validationStatus.inactiveOnlineSubsCheck = 'NA';
        


       //Request Ssd Account Number and Zip Code of Customer
        String ssdAccNum = inputParam.AccountNumber;
        String zipCode = inputParam.zipCode;
        storeName = inputParam.storeName;
        String postalCode = zipCode + '%';
        Boolean creditCheck = validations.creditCheck;
        Boolean activeSubsCheck = validations.activeOnlineSubsCheck ;
        Boolean inactiveSubsCheck = validations.inactiveOnlineSubsCheck;        
        Boolean activeSubsCheckFL = false;
        Boolean inactiveSubsCheckFL = false;
        String accSSDId;
        
        response.accountSSDDetails.address.zipCode = zipCode;
        response.accountSSDDetails.ssdaccNumber = ssdAccNum;
        
     
          System.debug('====check result===='+postalCode);
        
      //SOQL Query to retrieve Account and Source System Account Details   
       if(Schema.sObjectType.Source_System_Detail__c.isAccessible())  
       {     
            List<Source_System_Detail__c > result = [select Id,name,LCRM_Phone__c,Number_Street__c,City__c,
            State__c,Country__c,Postal_Code__c,Source_System_Account_Number__c,LCRM_Credit_Risk_Category__c,
            Account_Name__c from Source_System_Detail__c where Source_System_Account_Number__c =: ssdAccNum and Postal_Code__c LIKE :postalCode LIMIT 1];
            
            if(!result.isEmpty() && result[0] != null) 
            {
                 accSSDId = result[0].Id ;
                 response.accountSSDDetails.accountId  = result[0].Account_Name__c;
                 response.accountSSDDetails.accSSDId = accSSDId;  
                 response.accountSSDDetails.accSSDName = result[0].name;
                 response.accountSSDDetails.address.addressLine1 = result[0].Number_Street__c;
                 response.accountSSDDetails.address.city = result[0].City__c;
                 response.accountSSDDetails.address.state = result[0].State__c;
                 response.accountSSDDetails.address.country = result[0].Country__c;
                 response.accountSSDDetails.address.zipCode = result[0].Postal_Code__c;
                 response.accountSSDDetails.phone = result[0].LCRM_Phone__c;
                 response.accountSSDDetails.physicalAddress.addressLine1 = result[0].Number_Street__c;
                 response.accountSSDDetails.physicalAddress.city = result[0].City__c;
                 response.accountSSDDetails.physicalAddress.state = result[0].State__c;
                 response.accountSSDDetails.physicalAddress.country = result[0].Country__c;
                 response.accountSSDDetails.physicalAddress.zipCode = result[0].Postal_Code__c;
                 response.accountSSDDetails.phone = result[0].LCRM_Phone__c;  
                 response.accountSSDDetails.creditRiskCategory = result[0].LCRM_Credit_Risk_Category__c;               
            }
            else
            {
                 response.responseMessage = 'No Such Record Exists';
                 response.responseCode = 1001;
                 response.isRecordFound = false;
                 creditCheck = false;
                 activeSubsCheck = false;
                 inactiveSubsCheck = false;                 
            }
            

               
         
           
            if(creditCheck == true)
            {
                 creditCheck = creditRiskCheck(result[0].LCRM_Credit_Risk_Category__c, creditCheck);
                 if(creditCheck == true)
                 {
                     response.responseMessage = 'Credit Risk Customer';
                     response.responseCode = 1003;
                     response.validationStatus.creditCheck = 'FAILURE';
                     response = getEndJourneyDetails('Bad Credit', storeName, response);
                     activeSubsCheck = false;
                     inactiveSubsCheck = false;                      
                 }
                 else
                 {
                     response.validationStatus.creditCheck = 'SUCCESS';
                     if(storeName == 'FindLaw')
                     {
                        activeSubsCheckFL = true;
                        inactiveSubsCheckFL = true;
                        activeSubsCheck = false;
                        inactiveSubsCheck = false; 
                     }
                     else
                     {
                        activeSubsCheck = true;
                        inactiveSubsCheck = true; 
                     }
                 }
            }
        
        }   
        
           if(activeSubsCheck == true || inactiveSubsCheck == true)
           {    
                 response.responseMessage = 'No Past Subscriptions on Account';
                 response.responseCode = 200;
                 response.validationStatus.inactiveOnlineSubsCheck = 'FAILURE';
                 response.validationStatus.activeOnlineSubsCheck = 'FAILURE';
                 response =  validateAccount(ssdAccNum, response, activeSubsCheck, inactiveSubsCheck);
           } 
           
           if(activeSubsCheckFL == true || inactiveSubsCheckFL == true)
           {    
                 response.responseMessage = 'No Past Subscriptions on Account-FindLaw';
                 response.responseCode = 200;
                 response.validationStatus.inactiveOnlineSubsCheck = 'FAILURE';
                 response.validationStatus.activeOnlineSubsCheck = 'FAILURE';
                 String ssdId = response.accountSSDDetails.accSSDId;
                 response =  validateFindLawAcc(ssdId, response, activeSubsCheckFL, inactiveSubsCheckFL);
           } 
       System.debug('==response==='+response);
      
       return response;  
        
    }       
    public getAccSSDDetailsResponse validateAccount(string accountNumber,getAccSSDDetailsResponse response, Boolean activeSubsCheck, Boolean inactiveSubsCheck)
    {
        HTTPResponse res = getEntitlementDetails(accountNumber);
        if(res.getStatusCode()== 200)
        {  
               EsiResponseWrapper esiResp = (EsiResponseWrapper)JSON.deserialize(res.getBody(), EsiResponseWrapper.class);
               System.debug('esiResp:.......'+esiResp);
               if(esiresp.onlineContact != null)
               {
                   string message = '';
                   Date endDate = null;
                   for(EsiResponseWrapper.onlineContact olcon: esiresp.onlineContact){                   
                    try{
                        if(olcon.entitlements != null)
                        {
                          for(EsiResponseWrapper.entitlements enti: olcon.entitlements)
                           {   
                              System.debug('====check entit===='+olcon.entitlements); 
                               if(enti.applicationId == 'RFI')
                               {
                                        response.responseMessage = 'Clear Subscription';
                                        response.responseCode = 1007;                       
                                        return response;
                               } 
                               if(enti.status.equalsIgnoreCase('ACTIVE'))
                               {     
                                    System.debug('====check application id===='+enti.applicationId);                  
                                   if(enti.applicationId == 'WESTLAW' || enti.applicationId == 'PRACTICAL LAW' || enti.applicationId == 'COBALT' || enti.applicationId == 'DATAROOM') 
                                   {
                                        response.responseMessage = 'Existing Online Customer - Contact Sales Rep';
                                        response.responseCode = 1005;
                                        response.validationStatus.inactiveOnlineSubsCheck = 'NA';
                                        response = getEndJourneyDetails('Active Online', storeName, response);
                                        inactiveSubsCheck = false;
                                        return response;
                                   }                                                          
                                   else
                                   {
                                         response.responseMessage = 'Existing Print Customer';
                                         response.responseCode = 200;
                                         response.validationStatus.activeOnlineSubsCheck = 'SUCCESS';                                    
                                   }
                                }
                                else
                                 {
                                        if(endDate == null)
                                            endDate = Date.valueOf(enti.accessEndDate);
                                        else if(endDate < Date.valueOf(enti.accessEndDate))
                                            endDate = Date.valueOf(enti.accessEndDate);
                                 }        
                               activeSubsCheck = false;
                            }          
                          }
                            if(endDate != null && activeSubsCheck == false && inactiveSubsCheck == true)
                            {
                              Integer daysDifference = endDate.daysBetween(Date.today());
                              Integer noofdays = Integer.valueof(label.Ecom_SubscriptionDuration);
                              System.debug('====check data more than 4 months===='+daysDifference);
                              if(daysDifference < noofdays)
                              {
                                 response.responseMessage = 'Active Assets within 4 months';
                                 response.responseCode = 1004;
                                 response = getEndJourneyDetails('Inactive Recent Online', storeName, response);
                                 return response;
                              }
                              else
                              {
                                 response.responseMessage = 'Active Assets more than 4 months';
                                 response.responseCode = 200;
                                 response.validationStatus.inactiveOnlineSubsCheck = 'SUCCESS';
                                                                  
                              }
                            } 
                        }catch(exception e){
                               system.debug('Exception While parsing OLC contact and skipping only that contact'+e);
                               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
                           } 
                    }
 
       
      }   
    }
            return response;
    }
    
    
    
    
 public getAccSSDDetailsResponse validateFindLawAcc(string accSSDId,getAccSSDDetailsResponse response, Boolean activeSubsCheckFL, Boolean inactiveSubsCheckFL) 
{
                Map<Id,List<Apttus_Config2__LineItem__c>> aliVsLineItemMap = new Map<Id,List<Apttus_Config2__LineItem__c>>();
                set<string> productcode =new set<string>();
                if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible())
                {
                    for(Ecom_OrderService_Mappings__mdt lstOrderServiceMapping : [Select id,DeveloperName,Ecom_Field_API__c,Ecom_Field_Value__c from Ecom_OrderService_Mappings__mdt WHERE Ecom_Field_API__c = 'APTS_Product_Code__c'])
                    {
                        productcode.add(lstOrderServiceMapping.Ecom_Field_Value__c);
                    }
                }
                System.debug('======string productcode==='+productcode);
                
                List<Apttus_Config2__AssetLineItem__c> assetLineItemResult = [select id, Apttus_Config2__AssetStatus__c,Apttus_Config2__ProductId__r.ProductCode from Apttus_Config2__AssetLineItem__c where APTS_SSD_Sold_To__c =: accSSDId AND Apttus_Config2__ProductId__r.ProductCode IN: productcode];
            
             System.debug('===asset line item ==='+assetLineItemResult );
             
                // If there are no Old Asset Line Items,then Allow customer to Continue
                if(assetLineItemResult == null || assetLineItemResult.size()==0 || assetLineItemResult.isEmpty())
                {
                    response.responseCode = 200;
                    return response;
                }
                else if(activeSubsCheckFL == true && !assetLineItemResult.isEmpty())
                {
                    //get line items for each asset line item
                    for(Apttus_Config2__LineItem__c lineItem : [Select id,Apttus_Config2__EndDate__c, APTS_Product_Code__c, Apttus_Config2__AssetLineItemId__c,Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c 
                    from Apttus_Config2__LineItem__c where Apttus_Config2__AssetLineItemId__c iN : assetLineItemResult  order by Apttus_Config2__EndDate__c desc]) 
                    {
                        if(!aliVsLineItemMap.containsKey(lineItem.Apttus_Config2__AssetLineItemId__c))
                            aliVsLineItemMap.put(lineItem.Apttus_Config2__AssetLineItemId__c,new List<Apttus_Config2__LineItem__c>());
                            aliVsLineItemMap.get(lineItem.Apttus_Config2__AssetLineItemId__c).add(lineItem); 
                    } 
                    
                    for(Apttus_Config2__AssetLineItem__c assetLIResult: assetLineItemResult)
                    {
                        System.debug('===asset line item result==='+assetLIResult);
                        
                        if(assetLIResult.Apttus_Config2__AssetStatus__c != 'Cancelled') 
                        {

                              response.responseMessage = 'Existing Online FindLaw Customer - Contact Sales Rep';
                              response.responseCode = 1005;
                              response.validationStatus.inactiveOnlineSubsCheck = 'NA';
                              response = getEndJourneyDetails('Active Online', storeName, response);
                              return response;
                        }
                        activeSubsCheckFL = false;
                    }
                            
                }    
                        
                if(activeSubsCheckFL == false && inactiveSubsCheckFL == true)
                {                        
                       System.debug('===aliVsLineItemMap in inactive'+JSON.serialize(aliVsLineItemMap));
                       
                       for(Apttus_Config2__AssetLineItem__c assetLIResult: assetLineItemResult)
                       {
                             
                            if(!aliVsLineItemMap.isEmpty() && aliVsLineItemMap.containsKey(assetLIResult.id)) 
                            {
                                 
                                 for(Apttus_Config2__LineItem__c LineItemResult : aliVsLineItemMap.get(assetLIResult.id)) 
                                 {
                                 
                                     if(LineItemResult.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c == 'Cancelled' && LineItemResult.Apttus_Config2__EndDate__c!=null) 
                                     {
                                       
                                         integer subsDuration = Integer.valueof(System.label.Ecom_FLSubscriptionDuration);
                                         integer intDays =  LineItemResult.Apttus_Config2__EndDate__c.daysBetween(Date.today());
                                         
                                         if(intdays < subsDuration) // Check whether subscription end date is within 3 months from today, then dont allow customer
                                         {
                                                response.responseMessage = 'Active Assets within 3 months - FindLaw';
                                                response.responseCode = 1004;
                                                response = getEndJourneyDetails('Inactive Recent Online', storeName, response);
                                                return response;
                                         }
                                         else
                                         {
                                                response.responseMessage = 'Active Assets more than 3 months - FindLaw';
                                                response.responseCode = 200;
                                                response.validationStatus.inactiveOnlineSubsCheck = 'SUCCESS';
                                         }
                                     }
                                 }
                            }    
                        }     
                     }
                
              
       System.debug('==response==='+response);
       return response;
             
    }       
    
    
    
    
    private HTTPResponse getEntitlementDetails(string accountNumber){
       
       HTTPResponse res ;
       
       try{
       
       WebServiceSettings__c oWebServiceSettings1 = AppUtil.getWebServiceSettings('ODTGenericEntitlementService');
        
            String username =oWebServiceSettings1.Username__c;
            String password =oWebServiceSettings1.Password__c;
        
            blob  headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
            
        //esiHeaderCls esih = new esiHeaderCls(Label.ODT_ESI_App_userID);
        esiHeaderCls esih = new esiHeaderCls('CXECOMM');
        accountCls acch = new accountCls(accountNumber);
        callInviteCol callhcol = new callInviteCol(esih, acch);
        
        String esibodyInviteCollBody =JSON.serialize(callhcol);
        
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        //req.setEndpoint('https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/qa/getEntitlements');
        req.setEndpoint(oWebServiceSettings1.Endpoint__c);
        req.setHeader('Authorization', authorizationHeader);
        req.setBody(esibodyInviteCollBody);
        
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(120000)  ;
    
        Http http = new Http();
        
        system.debug('Request.................'+req.getBody());
        
        if(!test.isrunningtest()){
            res = http.send(req);
        }else{
            
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "onlineContact" :    [ {   "contactNumber" : "0006271252",   "address" : {     "firstName" : "Test1",     "lastName" : "User1"   },   "account" : {     "accountNumber" : "1004628419",     "companyId" : "WEST"   },   "sourceId" : "SAP",   "endDate" : "9999-12-31T00:00:00.000-06:00",   "entitlements" : [ {     "applicationId" : "COBALT",     "status" : "ACTIVE",     "appUserGuid" : "i0acc051b000001616c2e3023fadc9b2c",     "accessStartDate" : "2018-02-06",     "accessEndDate" : "9999-12-31",     "registered" : true,     "detailsIncomplete" : false,     "authFirstName" : "Sowmya",     "authLastName" : "G",     "authEmail" : "sowmya.gurudath@thomsonreuters.com",     "authId" : "7d761fd96eef4fc29988fbacce77df4b",     "logonName" : "sowmya.gurudath@thomsonreuters.com",     "lastLogonDate" : "2018-02-02T05:05:51.833",     "appUserRefIdPrimary" : true,     "appUserRefIdNickName" : "wl",     "lastPasswordChangeDate" : "9998-12-31T23:59:59.9999999",     "authenticationSystem" : "ONE_PASS"   },{     "applicationId" : "WESTLAW",     "status" : "INACTIVE",     "appUserGuid" : "i0acc051b000001616c2e3023fadc9b2c",     "accessStartDate" : "2017-02-06",     "accessEndDate" : "2017-12-31",     "registered" : true,     "detailsIncomplete" : false,     "authFirstName" : "Sowmya",     "authLastName" : "G",     "authEmail" : "sowmya.gurudath@thomsonreuters.com",     "authId" : "7d761fd96eef4fc29988fbacce77df4b",     "logonName" : "sowmya.gurudath@thomsonreuters.com",     "lastLogonDate" : "2018-02-02T05:05:51.833",     "appUserRefIdPrimary" : true,     "appUserRefIdNickName" : "wl",     "lastPasswordChangeDate" : "9998-12-31T23:59:59.9999999",     "authenticationSystem" : "ONE_PASS"   } ],   "onlineContactType" : "0100",   "allowContactEmails" : false } ]}');
            res.setStatusCode(200); 
        }    
        
        system.debug('Res...........'+res);
        system.debug('Res Body...........'+res.getBody());
        }catch(Exception e){
            system.debug('Line number 261: '+e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
        } 
       return res;
   }
   
   //Wrapper Classes for getEntitlementDetails
     public class esiHeaderCls{
        public string applicationId{get; set;}
        
        public esiHeaderCls(string appId){
            applicationId = appId;
        }
    }
    
    public class accountCls{
        public string accountNumber{get; set;}
        public accountCls(string accId){
        accountNumber = accId;
        }
    }

    public class callInviteCol{
        public esiHeaderCls ESIHeader{get; set;}
        public accountCls account{get; set;}
        public string  userGuidDomain{get; set;}
        public callInviteCol(esiHeaderCls esih, accountCls acch){
            ESIHeader = esih;
            account = acch;
            //userGuidDomain = 'WESTLAW';
        }
    }
  
     public Boolean creditRiskCheck(String creditRiskCategory, Boolean creditCheck)
     {
           creditCheck = false;
          // String query = 'Select id,DeveloperName, Field_API_Name__c,Field_Value__c from Ecom_OrderService_Mappings__mdt WHERE Field_API_Name__c = \'LCRM_Credit_Risk_Category__c\'';
           List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping ;
           if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible())
           {
               lstOrderServiceMapping = [Select id,DeveloperName, Ecom_Field_API__c,Ecom_Field_Value__c from Ecom_OrderService_Mappings__mdt WHERE Ecom_Field_API__c =: 'LCRM_Credit_Risk_Category__c'];
              
               for(Ecom_OrderService_Mappings__mdt ordSerMap : lstOrderServiceMapping)
               {
                    
                    if(creditRiskCategory == ordSerMap.Ecom_Field_Value__c)
                    {
                       creditCheck = true;
                    }
               }
        
           }
           return creditCheck;
     }  
    
    public static getAccSSDDetailsResponse getEndJourneyDetails(String reason, String store, getAccSSDDetailsResponse response){
        List<APTSECOM_New_Sales_Lead_Values__mdt> endJourneyReasons = getEndJourneyRecords(reason, store);
        
        if(endJourneyReasons.size() > 0){
            response.campaignId = endJourneyReasons[0].Ecom_Campaign_ID__c ; 
            response.reasonToEndJourney = endJourneyReasons[0].Ecom_Lead_Description__c;
        }
        return response;
    }
    
    public static List<APTSECOM_New_Sales_Lead_Values__mdt> getEndJourneyRecords(String reason, String store){
       
        List<APTSECOM_New_Sales_Lead_Values__mdt> endJourneyReasons;
        if(Schema.sObjectType.APTSECOM_New_Sales_Lead_Values__mdt.isAccessible())
        {
            endJourneyReasons = [Select Ecom_Lead_Description__c,Ecom_Campaign_ID__c from APTSECOM_New_Sales_Lead_Values__mdt where End_Journey_Reason__c =: reason AND APTSECOM_Store__c =: store];
            
            if(endJourneyReasons.isEmpty())
            {
               endJourneyReasons = [Select Ecom_Lead_Description__c,Ecom_Campaign_ID__c from APTSECOM_New_Sales_Lead_Values__mdt where End_Journey_Reason__c =: reason AND APTSECOM_Store__c = null]; 
            }     
        }
        return endJourneyReasons;
    }
    
     global class getAccSSDDetailsResponse
     {
        global Integer responseCode;
        global String responseMessage;
        global boolean isRecordFound;
        public string campaignId;
        public string reasonToEndJourney;
        public cls_accountSSDDetails accountSSDDetails;
        public cls_validationStatus validationStatus;
    }
    public class cls_validationStatus
    {
        public String creditCheck;
        public String activeOnlineSubsCheck;
        public String inactiveOnlineSubsCheck;    
    }

    public class cls_accountSSDDetails{
        public String accountId;
        public String accSSDId;
        public String ssdaccNumber;
        public String accSSDName;
        public String phone;
        public String creditRiskCategory;
        public cls_address address;
        public cls_address physicalAddress;
    }
            
    public class cls_address{
        public String addressLine1;
        public String city;
        public String state;
        public String country;
        public String zipCode; 
    }
}