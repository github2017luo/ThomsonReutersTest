public without sharing class ESC_ProdocLWCController{
    @AuraEnabled(Cacheable = true)
    public static DataTableWrapper retriveAccssd(String ssdId) {
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
    List<DataTableWrapper1> mainlst = new List<DataTableWrapper1>();
    List<DataTableWrapper2> sublst = new List<DataTableWrapper2>();
    DataTableWrapper1 main;
    DataTableWrapper2 sub;
    Source_System_Detail__c ssd;
     List<ecomTocServicesThomsonComService1PD1.GetLicensesResponse> outputList = new List<ecomTocServicesThomsonComService1PD1.GetLicensesResponse>();
     List<ecomTocServicesThomsonComService1PD1.License> licenseList = new List<ecomTocServicesThomsonComService1PD1.License>();
        if(Schema.sObjectType.Source_System_Detail__c .isAccessible()){
            ssd= [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c where id = :ssdId WITH SECURITY_ENFORCED];
        }
        system.debug('SSD account--->'+ssd);
    ecomTocServicesThomsonComService1PD1.SubscriptionServiceV01 stub = new ecomTocServicesThomsonComService1PD1.SubscriptionServiceV01();
    ecomTocServicesThomsonComService1PD1.GetLicensesRequest input = new ecomTocServicesThomsonComService1PD1.GetLicensesRequest();
  
      input.context = new ecomTocServicesThomsonComService1PD1.context_element();
      input.account = new ecomTocServicesThomsonComService1PD1.Account();
      input.context.productId = 'ESCU';
      input.account.accountNumber = ssd.Source_System_Account_Number__c;
      input.materialNumber = '';     input.licensedProduct = 'PRODOC';
      system.debug('request -->'+input);
      WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ProdocLicenses');
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
        outputList = stub.getLicenses(input);
        system.debug('response-->'+outputList);
    }   
  
    if(Test.isRunningTest()){
    ecomTocServicesThomsonComService1PD1.GetLicensesResponse output1 = new ecomTocServicesThomsonComService1PD1.GetLicensesResponse();
    ecomTocServicesThomsonComService1PD1.License ln = new ecomTocServicesThomsonComService1PD1.License();
    ecomTocServicesThomsonComService1PD1.installationCodeList install= new ecomTocServicesThomsonComService1PD1.installationCodeList();
    List<ecomTocServicesThomsonComService1PD1.License> listLn = new List<ecomTocServicesThomsonComService1PD1.License>();
    List<ecomTocServicesThomsonComService1PD1.installationCodeList> listinstall = new List<ecomTocServicesThomsonComService1PD1.installationCodeList> ();
    install.installCode ='test1';
    ln.keyCode = 'test';
    listLn.add(ln);
    listinstall.add(install); 
    output1.installationCodeList = listinstall; 
    output1.licenses = listLn;
    outputList.add(output1);
    }
        if(outputList.size() > 0 || Test.isRunningTest()){
        for(ecomTocServicesThomsonComService1PD1.GetLicensesResponse output : outputList){
        if(output.licenses!=null || Test.isRunningTest()){   
        for(ecomTocServicesThomsonComService1PD1.License ol : output.licenses){
           sub = new DataTableWrapper2();
           sub.state = output.stateAbbreviation;
           sub.regCode = ol.keyCode;
           sub.licenseType = ol.licenseType;
           sub.macId = ol.machineID;
           sub.expirationDate = ol.expirationDate;
           sub.seats= string.valueof(ol.seats);
           sublst.add(sub);
        }
        }
        if(output.installationCodeList !=null || Test.isRunningTest()){   
        for(ecomTocServicesThomsonComService1PD1.installationCodeList install : output.installationCodeList){
           main = new DataTableWrapper1();
           main.state = output.stateAbbreviation;
           main.releaseDate = install.installCodeReleaseDate;
           main.installCode = install.installCode;
           main.currentRelease = install.currentRelease;
           mainlst.add(main);
        }
        }
        }
        if(mainlst.size()>0 || sublst.size()>0){
        DataTableWrapper response = new DataTableWrapper(); 
        response.mainTable = mainlst;
        response.subTable = sublst;
        response.errorMsgs ='';
        return response;
        }
    }  
  }catch(Exception e){
       system.debug('exception'+e.getMessage());
       return null;
  }
  }
  else{
       DataTableWrapper response1 = new DataTableWrapper(); 
       response1.errorMsgs = System.Label.ESC_USLCSRoles;
       return response1;
  } 
  return null;
 }
   @Testvisible private class DataTableWrapper {
        @AuraEnabled
        public DataTableWrapper1[] mainTable{get;set;}
        @AuraEnabled
        public DataTableWrapper2[] subTable{get;set;}
        @AuraEnabled
        public string errorMsgs {get;set;}
  }
  @Testvisible private class DataTableWrapper1 {
        @AuraEnabled
        public String state{get;set;}
        @AuraEnabled
        public Date releaseDate{get;set;}
        @AuraEnabled
        public String installCode{get;set;}
        @AuraEnabled
         public string currentRelease{get;set;}
    }
    @Testvisible private class DataTableWrapper2 {
        @AuraEnabled
        public String state{get;set;}
        @AuraEnabled
        public String regCode {get;set;}
        @AuraEnabled
        public String licenseType {get;set;}
        @AuraEnabled
        public String macId {get;set;}
        @AuraEnabled
        public Date expirationDate {get;set;}
        @AuraEnabled
        public String seats {get;set;}
}
}