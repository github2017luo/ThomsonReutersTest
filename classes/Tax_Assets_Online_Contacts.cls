public with sharing class Tax_Assets_Online_Contacts {
    
    public transient onlineContactsSerialDeserial olDataESI {get;set;}
    public transient Tax_asset_online_contact_display obj_Tax_asset_online_contact_display { get;set;} 
    public List<onlineContactsSerialDeserial.OnlineContact> listcontacts {get;set;}
    public List<Tax_asset_online_contact_display> listdisplay {get;set;}
    
    public Tax_Assets_Online_Contacts(){
         olDataESI = new onlineContactsSerialDeserial();
         listcontacts = new List<onlineContactsSerialDeserial.OnlineContact>();
         listdisplay = new List<Tax_asset_online_contact_display>();
         string assetnumber  = apexpages.currentpage().getparameters().get('assetnumber').escapeHtml4();
         fetchContacts(assetnumber);
    }
    
      public void fetchContacts(string assetnumber){
      //  try{
            // get the Callout parameters from Custom Setting
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('TaxProfessional_OnlineContact');  
            system.debug('oWebServiceSettings...'+ oWebServiceSettings);
            
            //OAutth Code
            String grantType = 'client_credentials';
            String contentType= 'application/x-www-form-urlencoded';
            String accessToken = ' ';
            if(!Test.isRunningTest()){
                accessToken = DellBoomiTokenGeneration.getAuthToken();
            }
            
            OnlineContactsSerializeandDeserialize.GetOCBySAPAccountRequest_Tax_Asset smpReq = new OnlineContactsSerializeandDeserialize.GetOCBySAPAccountRequest_Tax_Asset(); 
            smpReq.BOOMIHeader.applicationId  = 'SF12';
            system.debug('assetnumnerhc' + assetnumber);            
            smpReq.assetNumber.add(assetnumber); //'3008134037';
            String strBody = JSON.serialize(smpReq);
            system.debug('strBody...'+strBody);
            Http http = new Http();
            HttpResponse resp = new HttpResponse();
            HttpRequest req = new HttpRequest();
            
            req.setMethod('POST');
            req.setEndpoint(oWebServiceSettings.Endpoint__c);
            //req.setTimeout(120000);    
            req.setHeader('Authorization','Bearer '+accessToken);                
            req.setHeader('Content-Type', contentType);
            req.setHeader('grant_type', grantType);
            
            req.setBody(strBody);
            req.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
            
            if(!Test.isRunningTest()) {
                resp = http.send(req);
            }
            else {
                resp.setStatusCode(200);
                resp.setBody('{"onlineContact":[{"contactNumber":"322","address":{"firstName":"HI","lastName":"HELLO","emailAddress":"HI.HELLO17@THOMSONREUTERS.COM"},"account":{"accountNumber":"1003417577"},"entitlements":[{"applicationId":"WLAR","status":"ACTIVE","appUserGuid":"i0acea6010000016817a1c3610f00654d","accessStartDate":"2019-01-04 06:51:47","accessEndDate":"2019-12-31 00:00:00","subscriptions":[{"material":[{"materialNumber":"40024666"}]}]}],"userStatus":["ACTIVE"],"onlineContactType":"110"}]}');
            }
            string strRes = resp.getBody();
            //system.debug('strRes..'+strRes);    
            system.debug('strRes..'+resp.getStatusCode());   
            if(resp.getStatusCode() == 200) {
                if(!resp.getBody().contains('"onlineContacts" : [ null ]')){ // added this to overcome of deserilize error
                        //system.debug('Test Response' + resp.getbody());
                    string ts = resp.getbody();
                    system.debug('Test Response' + ts);
                  
                    olDataESI = (onlineContactsSerialDeserial) System.JSON.deserialize(resp.getbody(), onlineContactsSerialDeserial.class);
                       // system.debug('olDataESI...'+olDataESI);
                    system.debug('olDataESI...'+ olDataESI.Onlinecontact);
                    
                    if(olDataESI.Onlinecontact != null ){
                        listcontacts = olDataESI.Onlinecontact;
                        if(listcontacts.size() > 0){
                            for(Integer i = 0; i <= listcontacts.size() - 1;i++){
                                obj_Tax_asset_online_contact_display = new Tax_asset_online_contact_display();
                                obj_Tax_asset_online_contact_display.first_name = listcontacts[i].address.firstName;
                                obj_Tax_asset_online_contact_display.last_name = listcontacts[i].address.lastName;
                                obj_Tax_asset_online_contact_display.email = listcontacts[i].address.emailAddress;
                                obj_Tax_asset_online_contact_display.status = listcontacts[i].entitlements[0].status;
                                obj_Tax_asset_online_contact_display.contactNumber = listcontacts[i].contactNumber;
                                obj_Tax_asset_online_contact_display.contactType = listcontacts[i].contactType;
                                listdisplay.add(obj_Tax_asset_online_contact_display);
                            }                        
                        } 
                    }else{
                        listdisplay = null;
                    }
                    
                    
                   
                    system.debug('list contacts' + listcontacts.size());
                   
                    
                    
                    
                }
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured while fetching the Online Contacts from TFMS'));
            }
        
    }
    public class Tax_asset_online_contact_display{
        public string first_name { get;set;}
        public string last_name { get;set;}
        public string email { get;set;}
        public string status { get;set;}
        public String contactNumber {get;set;}
        public String contactType {get;set;}
    }
}