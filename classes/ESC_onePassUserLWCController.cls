public without sharing class ESC_onePassUserLWCController {
    public static Map<String,String> mapVals = new Map<String,String>();
    
     //Actual Method with integration call
  @AuraEnabled(Cacheable = true)
    public static List<DataTableWrapper> retriveAccs(String strAccName) {
        system.debug('test'+strAccName);
        if(strAccName != ''){
            List<String> conSapId =new List<String>();
            conSapId = callOutHelper('ESC_onePassUserService',strAccName);
            if(conSapId == null){
                return null;
            }
            if(conSapId!=null && conSapId.size()>0){
                List<LCRM_Contact_SSD__c> lstssd = new List<LCRM_Contact_SSD__c>();
                lstssd = [select Id,
                  Name,
                  LCRM_Contact_ID__c,
                  LCRM_Account_SSD__r.Name,
                  LCRM_First_Name__c,
                  LCRM_Last_Name__c,
                  LCRM_SAP_Account_Number__c,
                  LCRM_Source_Contact_Id__c,
                  LCRM_Phone__c 
                    from LCRM_Contact_SSD__c 
                      where 
                          LCRM_Source_Contact_Id__c IN :conSapId];
                
                List<DataTableWrapper> response = new List<DataTableWrapper>();
                
        if(lstssd.size()>0){
                    for(LCRM_Contact_SSD__c rec:lstssd){
                        if(rec.LCRM_SAP_Account_Number__c == mapVals.get(rec.LCRM_Source_Contact_Id__c)){
                            DataTableWrapper obj = new DataTableWrapper();
                            obj.Id = rec.Id;
                            obj.name = rec.Name;
                            obj.nameUrl = '/'+rec.Id;
                            obj.lcrmFirstName = rec.LCRM_First_Name__c;
                            obj.lcrmLastName = rec.LCRM_Last_Name__c;
                            obj.sapAcctNumber = rec.LCRM_SAP_Account_Number__c;
                            obj.phone = rec.LCRM_Phone__c;
                        
                            response.add(obj);
                        }
                    }
                    if(response.size()>0){
                        return response;
                    }
                }
            }
        }
        return null;
    }
  
    /*
    //Dummy Method without integration call, called data locally for UI Demo
    @AuraEnabled(Cacheable = true)
    public static List<DataTableWrapper> retriveAccs(String strAccName) {
        if(strAccName != ''){
            String conSapId =strAccName;
           
            List<LCRM_Contact_SSD__c> lstssd = new List<LCRM_Contact_SSD__c>();
            if(conSapId!=''){
                lstssd = [select Id,
                  Name,
                  LCRM_Contact_ID__c,
                  LCRM_Account_SSD__r.Name,
                  LCRM_First_Name__c,
                  LCRM_Last_Name__c,
                  LCRM_SAP_Account_Number__c,
                  LCRM_Phone__c 
                    from LCRM_Contact_SSD__c 
                      where 
                      LCRM_Contact_ID__c =: conSapId 
                      or 
                      LCRM_Source_Contact_Id__c =: conSapId];
                
            }
            List<DataTableWrapper> response = new List<DataTableWrapper>();
            if(lstssd.size()>0){
                for(LCRM_Contact_SSD__c rec:lstssd){
                    DataTableWrapper obj = new DataTableWrapper();
                    obj.Id = rec.Id;
                    obj.name = rec.Name;
                    obj.nameUrl = '/'+rec.Id;
                    obj.lcrmFirstName = rec.LCRM_First_Name__c;
                    obj.lcrmLastName = rec.LCRM_Last_Name__c;
                    obj.sapAcctNumber = rec.LCRM_SAP_Account_Number__c;
                    obj.phone = rec.LCRM_Phone__c;
                    obj.accName = rec.LCRM_Account_SSD__r.Name;
                    obj.accNameUrl = '/'+rec.LCRM_Account_SSD__c;
                    response.add(obj);
                }
                return response;
            }
        }
        return null;
    }
    */
    
    private class DataTableWrapper {
        @AuraEnabled
        public Id Id {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String nameUrl {get;set;}
        @AuraEnabled
        public String lcrmFirstName {get;set;}
        @AuraEnabled
        public String lcrmLastName {get;set;}
        @AuraEnabled
        public String sapAcctNumber {get;set;}
        @AuraEnabled
        public String phone {get;set;}

    }
    
    public static List<String> callOutHelper(String WebServiceName,String uName){
        List<ESC_JSON2ApexOnePassService.OnlineUser> partydatalst =new List<ESC_JSON2ApexOnePassService.OnlineUser>(); 
        List<String> lstsapid =new List<String>();
        HttpResponse Response = new HttpResponse();
        try {
            // Send HTTP Request and assign responseHttp http = new Http(); 
            String jsonString = ESC_createJsonOnOnePass.createJson(uName);
            Http http = new Http();
            HttpRequest HTrequest = new HttpRequest();
            HTrequest = USLARHelper.getHttpRequestAR(WebServiceName,jsonString);
            system.debug('HTrequest'+HTrequest.getbody());
            
      Response = http.Send(HTrequest);
            
      system.debug('Response1'+Response);
            system.debug('Response2'+Response.getStatusCode());
            system.debug('Response3'+Response.getBody());
            if(Response.getStatusCode() == 200 ) {
                ESC_JSON2ApexOnePassService srservice=ESC_JSON2ApexOnePassService.parse(Response.getbody());
                system.debug('srservice----->'+srservice);
                if(srservice.OnlineUser!=null){
                    for(ESC_JSON2ApexOnePassService.OnlineUser pr:srservice.OnlineUser)
                    {
                        partydatalst.add(pr);
                        
                    }
                }
                if(partydatalst.size()>0){
                    for(ESC_JSON2ApexOnePassService.OnlineUser pr1:partydatalst)
                    {
                        system.debug('@@@'+pr1.Contact);
                        //system.debug('@@@'+pr1.FederatedIdentity.NickName);
                        if(pr1.Contact!=null){
                            system.debug('@@@'+pr1.Contact.ContactSapId);
                            if(pr1.Contact.ContactSapId != null &&pr1.Contact.ContactSapId !='' ){
                            system.debug('@@@1'+pr1.Contact.ContactSapId.length());
                                if(pr1.Contact.ContactSapId.length()<= 10){
                                system.debug('@@@2'+pr1.Contact.ContactSapId);
                                    String temp = pr1.Contact.ContactSapId;
                                    system.debug('@@@2'+pr1.Contact.ContactSapId);
                                    for(integer i=temp.length();i<10;i++){
                                        temp = '0'+temp;
                                    }
                                    lstsapid.add(temp);
                                    mapVals.put(temp,pr1.Contact.AcctSapId);
                                }
                            }
                        }
                    }
                }  
                system.debug('test123232'+lstsapid);
                if(lstsapid.size()>0){
                    return lstsapid;
                }
                return null;
            }
            else if(Response.getStatusCode() != 200) {
                ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                commonCalloutException.setMessage('A callout exception occurred with a status of: ' + Response.getStatusCode());
                throw commonCalloutException;
            }
            
            
        } catch (Exception e) {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            system.debug('exception'+e.getMessage());
        }
        
        return null;
    }
}