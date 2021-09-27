public without sharing class ESC_liveNoteLWCController {
    @AuraEnabled(Cacheable = true)
    public static List<DataTableWrapper> retriveAccssd(String ssdId) {
    List<DataTableWrapper> response = new List<DataTableWrapper>();
     List<User> userlist = new List<User>();
     Boolean inRole = false;
     Set<String> roleList = new Set<String>();  
        for(USL_Roles_Static_CC_Milestone__c rv : USL_Roles_Static_CC_Milestone__c.getAll().values()) {
           roleList.add(rv.Rolename__c);
        }
     if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
            userlist =[select Id,UserRole.DeveloperName from User where id =: Userinfo.getuserId()];
         } 
      if(userlist.size()>0){ 
        for(user u : userlist){
         if(roleList.contains(u.UserRole.DeveloperName)){
          inRole= true;
         }
         }
        }
    system.debug('ssdId--->'+ssdId);
    if(inrole){
    Source_System_Detail__c ssd;
    ecomTocServicesThomsonComService1LN1.GetLicensesResponse output = new ecomTocServicesThomsonComService1LN1.GetLicensesResponse();
     List<ecomTocServicesThomsonComService1LN1.GetLicensesResponse> outputList = new List<ecomTocServicesThomsonComService1LN1.GetLicensesResponse>();
     List<ecomTocServicesThomsonComService1LN1.License> licenseList = new List<ecomTocServicesThomsonComService1LN1.License>();
        if(Schema.sObjectType.Source_System_Detail__c .isAccessible()){
            ssd= [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c where id = :ssdId WITH SECURITY_ENFORCED];
        }
        system.debug('SSD account--->'+ssd);
    ecomTocServicesThomsonComService1LN1.SubscriptionServiceV01 stub = new ecomTocServicesThomsonComService1LN1.SubscriptionServiceV01();
    ecomTocServicesThomsonComService1LN1.GetLicensesRequest input = new ecomTocServicesThomsonComService1LN1.GetLicensesRequest();
  
      input.context = new ecomTocServicesThomsonComService1LN1.context_element();
      input.account = new ecomTocServicesThomsonComService1LN1.Account();
      input.context.productId = 'SF03';
      input.account.accountNumber = ssd.Source_System_Account_Number__c;
      input.account.companyId = 'West';
      input.licensedProduct = 'LIVENOTE';
      WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('LiveNoteLicenses');
    try{

         String accessToken=DellBoomiTokenGeneration.getAuthToken();
         stub.endpoint_x = oWebServiceSettings.Endpoint__c; 
            stub.inputHttpHeaders_x = new Map<String, String>();
            stub.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            //Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            //string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
            string sAuthorizationHeader = 'Bearer ' +accessToken;
            stub.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
            stub.outputHttpHeaders_x = new Map<String,String>();
  
    if(!Test.isRunningTest()){
    output = stub.getLicenses(input);
    }   
    outputList.add(output);
  
    if(Test.isRunningTest()){
    ecomTocServicesThomsonComService1LN1.License ln = new ecomTocServicesThomsonComService1LN1.License();
    List<ecomTocServicesThomsonComService1LN1.License> listLn = new List<ecomTocServicesThomsonComService1LN1.License>();
    ln.keyCode = 'test';
    listLn.add(ln);
    output.licenses = listLn;
    }
    
    if(output.licenses!=null || Test.isRunningTest()){   
        for(ecomTocServicesThomsonComService1LN1.License ol : output.licenses){
           ecomTocServicesThomsonComService1LN1.License oLicense = new ecomTocServicesThomsonComService1LN1.License();
           DataTableWrapper obj = new DataTableWrapper();
           obj.keyCode = ol.keyCode;
           obj.licenseDesc = ol.licenseDesc;
           obj.licenseContact = ol.licenseContact;
           obj.issueDate = ol.issueDate;
           obj.tokensRequired = ol.tokensRequired;
           obj.seats = ol.seats;
           obj.webSeats = ol.webSeats;
           obj.expirationDate = ol.expirationDate;
           obj.productActivated = ol.productActivated;
           response.add(obj);
        }
    }  
  }catch(Exception e){
       system.debug('exception'+e.getMessage());
       return null;
  }
  }
  else{
       DataTableWrapper obj1 = new DataTableWrapper();
       obj1.errorMsgs = System.Label.ESC_USLCSRoles;
       response.add(obj1);
  
  }
  if( response.size()>0){  
        return response; 
    }   
    else{
    return null;
    }
 }
  private class DataTableWrapper {
        @AuraEnabled
        public Id Id {get;set;}
        @AuraEnabled
        public String keyCode{get;set;}
        @AuraEnabled
        public String licenseDesc{get;set;}
        @AuraEnabled
        public String licenseContact{get;set;}
        @AuraEnabled
         public Date issueDate{get;set;}
        @AuraEnabled
        public boolean tokensRequired {get;set;}
        @AuraEnabled
        public Integer seats {get;set;}
        @AuraEnabled
        public Integer webSeats {get;set;}
        @AuraEnabled
        public Date expirationDate {get;set;}
        @AuraEnabled
        public boolean productActivated {get;set;}
        @AuraEnabled
        public string errorMsgs {get;set;}
    }
}