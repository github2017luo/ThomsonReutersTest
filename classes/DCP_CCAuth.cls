/********************************************************************************************************
*  DCP_CCAuth : Class to process payment authentication
*  @description  DCP_CCAuth - Class to process payment authentication
*********************************************************************************************************/
public without sharing class DCP_CCAuth {
    private String requestJson;
    public Boolean fakeItForTest = false;
    private String serviceVersion {
        get{
            if(serviceVersion == null){
                serviceVersion = Static_Values__c.getValues('DCPCCVersion')<> null ? Static_Values__c.getValues('DCPCCVersion').Value__c : 'v1';
            }
            return serviceVersion;
        }
        set;
    }
    
    /********************************************************************************************************
*  getAuthAmount : Get the valid auth amount based on service version
*  @description  getAuthAmount - Get the valid auth amount
*  @return string : Amount for authorization
*  @param cardType - Type of card e.g. AMEX, DISC, MC, VISA
*********************************************************************************************************/
    private string getAuthAmount(String cardType){
        String authAmount = '0.0';
        switch on serviceVersion {
            when 'v1' {
                authAmount = '1';// 1 dollor for all cards
            }
            when 'v2' {
                authAmount = (cardType=='AMEX' || cardType=='DISC')?'0.01':'0.0';//1 Cent for AMEX/DISC and 0 for MC/VISA
            }
            when 'v3' {
                authAmount = (cardType=='AMEX' || cardType=='DISC')? '1':'0.0'; //1 dollor for AMEX/DISC and 0 for MC/VISA
            }
            when else{
                authAmount = (cardType=='AMEX' || cardType=='DISC')? '0.1':'0.0'; //10 cent for AMEX/DISC and 0 for MC/VISA
            }
        }
        
        return authAmount;
    } 
    
    /********************************************************************************************************
*  parseRequest : Parse the request
*  @description  parseRequest - Get the required params for order request and create CC auth request
*  @return Boolean : Success or failure
*  @param orderReq - Order request
*********************************************************************************************************/
    private Boolean parseRequest(DCP_OrderService.DCP_OrderRequestClass orderReq){
        Boolean bFlag = false;
        String appId = (orderReq.site=='UEUS')?'UEUS':'OWCA';  
        String companyId = (appId=='UEUS')?'WEST':'CARS';
        String authAmount = this.getAuthAmount(orderReq.cardType);
        String currencyCode = (appId=='UEUS')?'USD':'CAD';
        if(String.isNotBlank(orderReq.cardToken) && String.isNotBlank(orderReq.cardType) && String.isNotBlank(orderReq.cardExpiry)){
            String jsonStr  =  '{'+
                '   '+
                '   "ESIHeader": {'+
                '      "applicationId": "'+appId+'"'+
                '   },'+
                '   "request": {'+
                '      '+
                '      "account": {'+
                '         "accountNumber": "",'+
                '         "companyid": "'+companyId+'"'+
                '      },'+
                '      "actionCode": "AUTH",'+
                '      "creditCard": {'+
                '         "token": "'+orderReq.cardToken+'",'+
                '         "type": "'+orderReq.cardType+'",'+
                '         "expirationDate": "'+orderReq.cardExpiry +'"'+
                '      },'+
                '      "amount": "'+authAmount+'",'+
                '      "currency": "'+currencyCode+'",'+
                '      "storeCredential": "false"'+
                '      '+
                '      '+
                '   }'+
                '}';
            this.requestJson = jsonStr;
            System.debug(LoggingLevel.INFO,'requestJson:>' + requestJson);   
        }
        return bFlag;
    }
    
    private String getCalloutName(){
        String callOutName = '';
        Static_Values__c staticValues = Static_Values__c.getValues('TR_CCAUTH_callout');
        callOutName = staticValues <> null ? staticValues.value__c : '';
        
        if(Test.isRunningTest()){
            callOutName = this.fakeItForTest ? '' : 'callout:Transact_test_Auth';
        }
        return callOutName;
    }
    
    /********************************************************************************************************
*  processRequest : This is the method to process payment authentication
*  @description  processRequest - This is the method to process payment authentication
*  @return DCP_CCAuth.AuthResponse : Response of CC Auth 
*  @param orderReq - Order Request 
*********************************************************************************************************/
    public DCP_CCAuth.AuthResponse processRequest(DCP_OrderService.DCP_OrderRequestClass orderReq){
        AuthResponse response = new AuthResponse();
        if(String.isNotBlank(orderReq.cardToken) && String.isNotBlank(orderReq.cardType) && String.isNotBlank(orderReq.cardExpiry)){       
            try{
                String calloutName = this.getCalloutName();
                if (String.isBlank(calloutName)){
                    response.status = 'Callout name not found';
                    response.statusCode = DCPNewSaleUtilityCls.successStatusOne;
                    return response;
                }
                
                this.parseRequest(orderReq);
                HttpRequest req = new HttpRequest();
                req.setEndpoint(calloutName);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                req.setBody(this.requestJson);
                Http http = new Http();
                HTTPResponse res = http.send(req);
                response = getCalloutResponse(res,response);
            }catch(Exception ex){
                response = new AuthResponse();
                response.status = 'Exception in code';
                response.statusCode = DCPNewSaleUtilityCls.errorCode;                
            }           
        }else{
            response.status = 'Cart parameters are empty';
            response.statusCode = DCPNewSaleUtilityCls.successStatusOne;
        }
        
        return response;
    }
    
    private AuthResponse getCalloutResponse(HTTPResponse res, AuthResponse response){
        if(res.getStatus() == 'OK' && res.getStatusCode() == 200){
            response = (AuthResponse)JSON.deserializeStrict(res.getBody(), AuthResponse.class);
            response.status = res.getStatus();
            response.statusCode = String.valueOf(res.getStatusCode());
        }else{
            response.status = res <> null ? res.getStatus() : 'Service Failed';
            response.statusCode = res <> null ? String.valueOf(res.getStatusCode()) : DCPNewSaleUtilityCls.errorCode;
        }
        return response;
    }
    
    /********************************************************************************************************
*  @description  AuthResponse - Response after authentication
*********************************************************************************************************/
    public class AuthResponse{
        public DCP_CCAuth.CCresponse response;
        public String status;
        public String statusCode;
    }  
    /********************************************************************************************************
*  @description  CCresponse - Response structure
*********************************************************************************************************/
    public class CCresponse {
        public String status;  //Authorization successful
        public String statusCode;  //SUCCESS
        public String authNumber;  //tst377
        public String pnRefNum;  //205709292
        public String txnNumber;  //7afd5026-9fe7-40ad-90a5-93df13f7a4c9
        public ccVendorTransactId ccVendorTransactId;
        public String transactionMessageType;  //CSTO
    }
    
    /********************************************************************************************************
*  @description  CCVendorTransactId - Response structure
*********************************************************************************************************/
    public class CCVendorTransactId {
    } 
}