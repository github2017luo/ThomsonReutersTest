public without sharing class ESC_WLBandingController{
 
    @AuraEnabled(Cacheable = true)
     Public static list<DataTableWrapper1> viewrefAttorney(id accountid){
        DataTableWrapper1 count;
        List<DataTableWrapper1> countlist = new List<DataTableWrapper1>();
        DataTableWrapper totalActive;
        DataTableWrapper refAttorney;
        list<DataTableWrapper> attlist = new  list<DataTableWrapper>();
        list<DataTableWrapper> activelist = new  list<DataTableWrapper>();
        integer totalcount = 0;
        integer attcount = 0;
        
        // callout based on Source_System_Account_Number__c
        
        List<Source_System_Detail__c> acclist = new List<Source_System_Detail__c>();
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible() || Schema.sObjectType.Source_System_Detail__c.isQueryable()){
         acclist  = [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c  where id =: Accountid];
        }
        if(acclist.size() > 0){ 
        for(Source_System_Detail__c acc : acclist){       
        HTTPResponse Response = showOnlineContacts(acc.Source_System_Account_Number__c);
        
        if(Response.getStatusCode() == 200){
            System.debug('response code success--->');
               // ESC_JSON2ApexWLBandingService srservice=(ESC_JSON2ApexWLBandingService)JSON.deserialize(Response.getBody(), ESC_JSON2ApexWLBandingService.class);
               ESC_JSON2ApexWLBandingService srservice = ESC_JSON2ApexWLBandingService.parse(Response.getbody());
                system.debug('srservice----->'+srservice);
                List<string> conlist = new list<string>();
                boolean ishigh = false;
                boolean islow = false;
                
                //to get cobalt and active contacts
                
                if(srservice.onlineContact!=null){
                for(ESC_JSON2ApexWLBandingService.onlineContact olc1 : srservice.onlineContact){
                        islow =false;
                        ishigh = false;
                        if(olc1.entitlements != null){
                            for(ESC_JSON2ApexWLBandingService.entitlements ent1 : olc1.entitlements){
                            if(ent1.applicationId == 'COBALT' && ent1.status == 'ACTIVE' && ent1.subscriptions != null){
                                for(ESC_JSON2ApexWLBandingService.subscriptions sub1 : ent1.subscriptions){
                                if(sub1.material != null){
                                    for(ESC_JSON2ApexWLBandingService.material mat1 : sub1.material){
                                     if(mat1.extensibleAttributes != null){
                                        for(ESC_JSON2ApexWLBandingService.extensibleAttributes ext1 : mat1.extensibleAttributes){
                                          if(ext1.key == 'mediaLowerLevel' && ext1.value == '49'){
                                            islow = true;
                                          }
                                        if(ext1.key == 'mediaHigherLevel' && ext1.value == '06'){
                                            ishigh = true;
                                          }
                                        }
                                        if(islow == true && ishigh == true){
                                        system.debug('material found --->'+ mat1.materialNumber + olc1.contactNumber);
                                        if(!conlist.contains(olc1.contactNumber)){
                                            conlist.add(olc1.contactNumber);
                                        }
                                        System.debug('conlist--->' +conlist);
                                        }
                                     }
                                    }
                                }
                                }
                            }
                            }
                        }
                    }
                    }
                if(srservice.onlineContact!=null && conlist.size()>0){
                    for(ESC_JSON2ApexWLBandingService.onlineContact olc : srservice.onlineContact){ 
                        if(conlist.contains(olc.contactNumber)){   
                                totalcount = totalcount +1;
                                totalActive = new DataTableWrapper(olc.address.firstName,olc.address.lastName); 
                                activelist.add(totalActive);
                            if(olc.onlineContactType == '0100' || olc.onlineContactTypeDescription == 'Attorney'){
                                attcount = attcount + 1;
                                refAttorney = new DataTableWrapper(olc.address.firstName,olc.address.lastName); 
                                attlist.add(refAttorney);
                            }
                            }
                            }
                        }
                    }
                }
                System.debug('total active password --->' + totalcount);
                System.debug('Attorney count --->'+attcount);
                System.debug('active list'+attlist);
                System.debug('Attorney list'+activelist);
     }
     
     count = new DataTableWrapper1(System.Label.ESC_WL_Attorney,attcount,attlist);
     countlist.add(count);
     count = new DataTableWrapper1(System.Label.ESC_WL_Active,totalcount,activelist);
     countlist.add(count);
     return countlist; 
     }
     //wrapper for datatable
     public class DataTableWrapper1 {
        @AuraEnabled
        public String description{get;set;}
        @AuraEnabled 
        public Integer count{get;set;}
        @AuraEnabled
        public DataTableWrapper[] DataTableWrapper ;
        
        public DataTableWrapper1 (String description, Integer c, DataTableWrapper[] dt){
            this.description = description;
            this.count= c;
            this.DataTableWrapper = dt;
        }
        
    }
    public class DataTableWrapper {
        @AuraEnabled
        public String firstName;
        @AuraEnabled
        public String lastName; 
        
        public DataTableWrapper (String fName, String lName){
            this.firstName = fName;
            this.lastName = lName;
        }
    }
    //integration call
    public static HTTPResponse showOnlineContacts(string accountID){
       
       HTTPResponse res ;
       
       try{
       
       WebServiceSettings__c oWebServiceSettings1 = AppUtil.getWebServiceSettings('ODTGenericEntitlementService');
        
            String username =oWebServiceSettings1.Username__c;
            String password =oWebServiceSettings1.Password__c;
        
            blob  headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
            
        ESIHeaderCls esih = new ESIHeaderCls('ESCU');
        accountCls acch = new accountCls(accountID);
        callInviteCol callhcol = new callInviteCol(esih, acch);
        
        String esibodyInviteCollBody =JSON.serialize(callhcol);
        
        System.debug('request body --->'+esibodyInviteCollBody); 
        
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        //req.setEndpoint('https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/qa/getEntitlements');
        req.setEndpoint(oWebServiceSettings1.Endpoint__c);
        req.setHeader('Authorization', authorizationHeader);
        req.setBody(esibodyInviteCollBody);
        
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(120000)  ;
    
        Http http = new Http();
        
        system.debug('Request.................'+req);
        system.debug('Request Body.................'+req.getBody());
        
        if(!test.isrunningtest()){
           res = http.send(req);
        }
        else{
            
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"ESIHeader" : {"applicationId" : "ESCU"},"onlineContact" : [ {"contactNumber" : "0006274152","address" : {"firstName" : "edqw","lastName" : "sdasdqw","emailAddress" : "sweta.beura@thomsonreuters.com"},"account" : {"accountNumber" : "1004628718","companyId" : "WEST"},"sourceId" : "SAP","endDate" : "9999-12-31T00:00:00.000-06:00","entitlements" : [ {"status" : "ACTIVE","applicationId" : "COBALT","appUserGuid" : "i0ace196600000162ba10a59fb9203503","accessStartDate" : "2018-04-12","accessEndDate" : "9999-12-31","statusReason" : "SAP","subscriptions" : [ {"material" : [ {"materialNumber" : "000000000040028757","extensibleAttributes" : [ {"key" : "mediaLowerLevel","value" : "49"}, {"key" : "mediaHigherLevel","value" : "06"} ]} ]}, {"material" : [ {"materialNumber" : "000000000040050883","extensibleAttributes" : [ {"key" : "mediaLowerLevel","value" : "49"}, {"key" : "mediaHigherLevel"} ]} ]}, {"material" : [ {"materialNumber" : "000000000040023788","extensibleAttributes" : [ {"key" : "mediaLowerLevel","value" : "20"}, {"key" : "mediaHigherLevel"} ]} ]} ]}, {"status" : "ACTIVE","applicationId" : "DATAROOM","appUserGuid" : "i0ace196600000162ba10a8146f874331","accessStartDate" : "2018-04-12","accessEndDate" : "9999-12-31","statusReason" : "SAP","subscriptions" : [ {"material" : [ {"materialNumber" : "000000000040062263","extensibleAttributes" : [ {"key" : "mediaLowerLevel","value" : "LI"}, {"key" : "mediaHigherLevel"} ]} ]} ]}, {"status" : "ACTIVE","applicationId" : "WESTLAW","appUserGuid" : "10178906","accessStartDate" : "2018-04-12","accessEndDate" : "9999-12-31","statusReason" : "SAP","subscriptions" : [ {"material" : [ {"materialNumber" : "000000000040030637","extensibleAttributes" : [ {"key" : "mediaLowerLevel","value" : "49"}, {"key" : "mediaHigherLevel"} ]} ]}, {"material" : [ {"materialNumber" : "000000000040001907","extensibleAttributes" : [ {"key" : "mediaLowerLevel","value" : "20"}, {"key" : "mediaHigherLevel"} ]} ]}, {"material" : [ {"materialNumber" : "000000000040019014","extensibleAttributes" : [ {"key" : "mediaLowerLevel","value" : "49"}, {"key" : "mediaHigherLevel"} ]} ]} ]} ],"onlineContactType" : "0100","onlineContactTypeDescription": "Attorney","allowContactEmails" : false} ]}');
            res.setStatusCode(200); 
       }    
        
        system.debug('Res...........'+res);
        system.debug('Res Body...........'+res.getBody());
        }catch(Exception e){
            system.debug('Line number 261: '+e);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
        } 
       return res;
   }
   //wrapper for showonlinecontacts
   public class ESIHeaderCls{
        public string applicationId{get; set;}
        
        public ESIHeaderCls(string appId){
            applicationId = appId;
        }
    }
     public class accountCls{
        public string accountNumber{get; set;}
        public accountCls(string accId){
        accountNumber = accId;
        }
    }
     public class OnlineContactFiltercls{
        public string checkEntitlementDetails{get; set;}
        public string checkPrism{get; set;}
        public extensibleAttributescls extensibleAttributes{get; set;} 
        
        public OnlineContactFilterCls(){
            checkEntitlementDetails = 'true';
            checkPrism = 'false';
            extensibleAttributes = new extensibleAttributescls();
        }
    }
     public class extensibleAttributescls{
        public string key{get; set;}
        public string value{get; set;}
        
        public extensibleAttributescls(){
            key = 'includeSubMaterials';
            value = 'true';
 
        }
     }
     public class callInviteCol{
        public ESIHeaderCls ESIHeader{get; set;}
        public accountCls account{get; set;}
        public string  contactId{get; set;}
        public OnlineContactFilterCls OnlineContactFilter{get; set;} 
        public callInviteCol(ESIHeaderCls esih, accountCls acch){
            ESIHeader = esih;
            account = acch;
            OnlineContactFilter = new OnlineContactFilterCls ();
            //contactId = '';
            //userGuidDomain = 'COBALT';
        }
    }
   
    
    }