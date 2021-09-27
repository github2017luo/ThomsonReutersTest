public without sharing class TRStore_TransactCCAuth {
    private String requestJson;
    public Boolean fakeItForTest = false;
    private Boolean parseRequest(String cardToken, String cardType, String cardExpiry){
        Boolean bFlag = false;
        if(String.isNotBlank(cardToken) && String.isNotBlank(cardType) && String.isNotBlank(cardExpiry)){
            String jsonStr  =  '{'+
                                '   '+
                                '   "ESIHeader": {'+
                                '      "applicationId": "OWCA"'+
                                '   },'+
                                '   "request": {'+
                                '      '+
                                '      "account": {'+
                                '         "accountNumber": "",'+
                                '         "companyid": "CARS"'+
                                '      },'+
                                '      "actionCode": "AUTH",'+
                                '      "creditCard": {'+
                                '         "token": "'+cardToken+'",'+
                                '         "type": "'+cardType+'",'+
                                '         "expirationDate": "'+cardExpiry +'"'+
                                '      },'+
                                '      "amount": "1",'+
                                '      "currency": "CAD"'+
                                '      '+
                                '      '+
                                '   }'+
                                '}';
         this.requestJson = jsonStr;
         System.debug('requestJson:>' + requestJson);   
        }
      return bFlag;
    }
 
    private String getCalloutName(){
        String callOutName = '';
        /*if(Organization.SObjectType.getDescribe().isAccessible()){
            Organization myOrg = [Select isSandbox From Organization limit 1];
            if(myOrg.isSandbox){
                String sandboxName = URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
                if(String.isNotBlank(sandboxName)){
                    Static_Values__c staticValues = Static_Values__c.getValues('TR_'+sandboxName+'_callout');
                    callOutName = staticValues <> null ? staticValues.value__c : '';
                }            
            }else{*/
                Static_Values__c staticValues = Static_Values__c.getValues('TR_CCAUTH_callout');
                callOutName = staticValues <> null ? staticValues.value__c : '';
            //} 
            
            if(Test.isRunningTest()){
               callOutName = this.fakeItForTest ? '' : 'callout:Transact_test_Auth';
            }
       // }
        return callOutName;
    }
    
    public TRStore_TransactCCAuth.AuthResponse processRequest(String cardToken, String cardType, String cardExpiry){
        AuthResponse response = new AuthResponse();
        if(String.isNotBlank(cardToken) && String.isNotBlank(cardType) && String.isNotBlank(cardExpiry)){       
            try{
                String calloutName = this.getCalloutName();
                if (String.isBlank(calloutName)){
                    response.status = 'Callout name not found';
                response.statusCode = '209';
                    return response;
                }
                
                this.parseRequest(cardToken,cardType,cardExpiry);
                HttpRequest req = new HttpRequest();
                req.setEndpoint(calloutName);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                req.setBody(this.requestJson);
                Http http = new Http();
                HTTPResponse res = http.send(req);
                if(res.getStatus() == 'OK' && res.getStatusCode() == 200){
                    response = (AuthResponse)JSON.deserializeStrict(res.getBody(), AuthResponse.class);
                    response.status = res.getStatus();
                    response.statusCode = String.valueOf(res.getStatusCode());
                }else{
                    response.status = res <> null ? res.getStatus() : 'Service Failed';
                    response.statusCode = res <> null ? String.valueOf(res.getStatusCode()) : '400';
                }
            }catch(Exception ex){
        response = new AuthResponse();
        response.status = 'Exception in code';
                response.statusCode = '400';                
            }           
        }else{
            response.status = 'Cart parameters are empty';
            response.statusCode = '209';
        }
        
        return response;
    }
    public class AuthResponse{
         public TRStore_TransactCCAuth.CCresponse response;
         public String status;
         public String statusCode;
    }  
   
  public class CCresponse {
    public String status;  //Authorization successful
    public String statusCode;  //SUCCESS
    public String authNumber;  //tst377
    public String pnRefNum;  //205709292
    public String txnNumber;  //7afd5026-9fe7-40ad-90a5-93df13f7a4c9
    public ccVendorTransactId ccVendorTransactId;
    public String transactionMessageType;  //CSTO
  }
  public class CCVendorTransactId {
  } 
}