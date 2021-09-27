public class creditCardTokeniserController{

    

    public ResponseWrapper.canvasURL responseWrap;
    public ResponseWrapper.postmessageResponse postmessageWrap;
    public ResponseWrapper.error errorWrap;    
    public String endpointURL;
    public String name{get;set;}
    public Boolean isFeedView{get
    {
        string cacheOpn = apexpages.CurrentPage().getParameters().get('scontrolCaching');
        if(string.isBlank(cacheOpn)){
         return true;
        
        }
        else{
          return false;
        }
    } set;}
     private PageReference pr{get; set;}
    //public String cardtype{get;set;}
    //public String dateblank{get;set;}
    //public String dateerror{get;set;}
    //public String cardtypeblank{get;set;}
    //public String nameblank{get;set;}
    public String caseid;
   
    public String selectedyear{get;set;}
    public String selectedmonth{get;set;}
    public String expdate='';
    
    /*public creditCardTokeniserController(ApexPages.StandardController controller) {
        responseWrap = new ResponseWrapper.canvasURL();
        postmessageWrap = new ResponseWrapper.postmessageResponse();
        endpointURL = '';
        caseid = controller.getRecord().Id;
        system.debug('CaseId&&'+caseid);
        system.debug('language is'+userinfo.getLanguage());
    }*/
    public string getCaseNumber(){
        Case cse = [select casenumber from case where id=:caseid];
        return cse.casenumber;
    }
    public creditCardTokeniserController() {
        responseWrap = new ResponseWrapper.canvasURL();
        postmessageWrap = new ResponseWrapper.postmessageResponse();
        endpointURL = '';
        caseid = ApexPages.currentPage().getParameters().get('Id');
        system.debug('CaseId&&'+caseid);
        system.debug('language is'+userinfo.getLanguage());
        
    }
    
    public String getendpointURL(){
        try{
           WebServiceSettings__c ccrec = WebServiceSettings__c.getInstance('Creditcardtokeniser');
            Http h = new http();
            httprequest req = new httprequest();
            req.setendpoint(ccrec.Endpoint__c);
            req.setheader('Content-Type', 'application/json');
            req.setMethod('GET');
            req.setTimeout(20000);
            String jsonstring = '{"HMACKey" : "ESCATR","APIKey" : "TRPMNTTOKEN_API","ProductID" : "ESCA","OriginURL" : "","CustomerRefnumber" : "","DynamicContent1" : "color:blue","DynamicContent2" : "Enter Credit Card Number"}';
            req.setbody(jsonstring);
            httpresponse res = new httpresponse();
            res = h.send(req);
            if(res.getStatusCode() == 200){
                responseWrap = (ResponseWrapper.canvasURL)JSON.deserialize(res.getBody(),ResponseWrapper.canvasURL.class);
                system.debug('response is'+res.getBody());
                if(responseWrap.Error == ''){                    
                    endpointURL = responseWrap.HTPURL;                    
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.GGO_CreditCardURLError);
                    ApexPages.addMessage(myMsg);
                }
            }  
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.GGO_CreditCardURLError);
                ApexPages.addMessage(myMsg);
            }                  
            return endpointURL;
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    public void processResponse(){
        String response = Apexpages.currentpage().getparameters().get('postresponse');
        system.debug('response is'+response);
        String tokenVal = '';
        String ctype = '';
        boolean isError = true;
        
        if(validateData()){                
            JSONParser parser = JSON.createParser(response);
            while(parser.nextToken() != null){
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'Hash'){                    
                    iserror = false;
                }
            }        
            if(!isError){
                postmessageWrap = (ResponseWrapper.postmessageResponse)JSON.deserialize(response,ResponseWrapper.postmessageResponse.class);
                system.debug('postmessage wrap is'+postmessageWrap ); 
                if(postmessagewrap.payload.error == ''){           
                    String hashvalue = hashPayload(response);
                    if(hashvalue == postmessageWrap.Hash){
                        tokenVal = postmessageWrap.payload.Token;
                        ctype = postmessageWrap.payload.Brand;
                        saveOnCase(tokenval,ctype);
                    }
                }
            }
            else{
                errorWrap = (responseWrapper.error)JSON.deserialize(response,responseWrapper.error.class);
                if(errorWrap.error != null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.GGO_InvalidCreditCardNo);
                    ApexPages.addMessage(myMsg);
                }
            }
        }
        system.debug('token is'+tokenVal);
    }
    
    public void saveOnCase(String token,String ctype){
        
        try{
           DateTime dt = Datetime.Now();
            String myDatetimeStr = dt.format('dd-MM-yyyy hh:mm:ss a','GMT');
            Case crec = [select id,Description from case where id =:caseid];
            Case caseObj = new Case();
            caseObj.id = crec.id;
            CaseObj.Description = (crec.Description!=null?crec.Description:'') + '\n' +System.Label.GGO_CreditCard_Addedon + ' ' + myDatetimeStr +' (GMT) '+'\n' +System.Label.GGO_CreditCard_AddedBy + ' '+ UserInfo.getFirstName()+' '+UserInfo.getLastName()+' '+'\n'+ System.Label.GGO_CreditCard_Token +' '+ token + '\n'+ System.Label.GGO_CreditCard_Expiry+' '+ expdate + '\n'+System.Label.GGO_CreditCard_CardHolder+ ' '+name + '\n'+System.Label.GGO_CreditCard_Type +' '+ ctype + '\n'  ;
            //caseObj.GGO_CreditCardInfo__c = token+ ' '+ expdate+' '+name+' '+cardtype ;
            system.debug('caseObj$$$'+caseObj);
            update caseObj;
            system.debug('caseObj'+caseObj);
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM,System.Label.GGO_CreditCardSuccess );
            Apexpages.addMessage(msg);
            
            pr = new PageReference('/'+caseObj.id);
            pr.setRedirect(true);
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);   
            
        }
    }
    
    public String hashPayload(String response){        
        String str = '';
        integer t = response.indexOf('Payload');
        system.debug('index is'+t);
        str = response.substring(t+9);
        integer size = str.length();
        str = str.substring(0,size-1);
        system.debug('str is'+str);        
        Blob targetBlob = Blob.valueOf(str);
        Blob key = Blob.valueof('ESCATR');        
        Blob hashSHA256 = Crypto.generateMac('hmacSHA256',targetBlob,key);
        String hashBase64SHA256 = EncodingUtil.base64encode(hashSHA256);
        system.debug('hash is'+hashBase64SHA256 );
        return hashBase64SHA256;
    }
    
    public boolean validateData(){
        String errormsg = '';
        expdate='';
        if(selectedmonth!='MM' && selectedYear!='YYYY'){
        expdate = selectedmonth +'/'+ selectedYear;
        }
                      
        system.debug('expiration date is'+expdate);                
        if(expdate == '' || expdate == null){
            errormsg = System.Label.GGO_CreditCardDateError;                            
        }
        else if(name == '' || name == null){
            errormsg = System.Label.GGO_CreditCardDateError;            
        }
             
        /*else if(expdate != ''){
            //String dateRegEx = '(0?[1-9]|1[012])/(0?[1-9]|[12][0-9]|3[01])/((19|20)\\d\\d)';
            String dateRegEx = '(0?[1-9]|1[012])/((19|20)\\d\\d)';
            Pattern myPattern = Pattern.compile(dateRegEx);
            Matcher myMatcher = myPattern.matcher(expdate);                        
            if(!myMatcher.matches() ){
                errormsg = System.Label.GGO_CreditCardDateFormat;                
            }
        }*/
        if(errormsg.length() > 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errormsg);
            ApexPages.addMessage(myMsg);
            return false;
        }
        else
            return true;
    }
   
    public List<SelectOption> getdynamicmonthlist() {
    
        system.debug('@@@@@'+selectedYear);
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('MM','MM'));
        if(selectedYear=='' || selectedYear == null ||selectedYear == 'YYYY' || selectedYear != String.valueof(System.Today().year())){
            for(Integer i=1;i<=12;i++){
                if(i<10){
                    //options.add(new SelectOption('0'+(String.valueof(System.Today().month()+i)),'0'+(String.valueof(System.Today().month()+i)) ));
                    options.add(new SelectOption('0'+(String.valueof(i)),'0'+(String.valueof(i)) ));
                }
                else{
                    options.add(new SelectOption(String.valueof(i),String.valueof(i) ));    
                }
            }
        }
        else if(selectedYear == String.valueof(System.Today().year())){
            for(Integer i=(System.Today().month()-1);i<12;i++){            
                if(i<9){
                    options.add(new SelectOption('0'+(String.valueof(i+1)),'0'+(String.valueof(i+1)) ));
                }
                else{
                    options.add(new SelectOption(String.valueof(i+1),(String.valueof(i+1)) ));    
                }
            }
        }
        
        return options;
    }   
    
    public List<SelectOption> getdynamicyearlist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('YYYY','YYYY'));
        for(Integer i=0;i<30;i++){
            options.add(new SelectOption(String.valueof(System.Today().year()+i),String.valueof(System.Today().year()+i)));
        }
        
        return options;
    }
    
  
  
    public PageReference dynamicmonthlist() {
        system.debug('*****12345'+selectedYear);
        getdynamicmonthlist();
        return null;
    }
    
    public PageReference getmyPage(){
        return pr;
    }
    
}