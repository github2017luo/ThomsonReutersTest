public without sharing  class USL_generateCCTokenController{
    
    public Case caserec {get;set;}
    public ResponseWrapper.canvasURL responseWrap;
    public ResponseWrapper.postmessageResponse postmessageWrap;
    public ResponseWrapper.error errorWrap;    
    public String endpointURL;
    public String name{get;set;}
    public String formId{get;set;}
    public string formname{get;set;}
    public String cctoken{get;set;}
    public boolean formExist{get;set;}
    public ESC_Case_Form_Extension__c formext{get;set;}
    public string preamount{get;set;}
    public USL_Integration_defaults__c intVal;
     public List<ESC_Case_Form_Extension__c> caseExtInsertList = new List<ESC_Case_Form_Extension__c>();
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
    public String subBU='';
    public String selectedyear{get;set;}
    public String selectedmonth{get;set;}
    public String expdate='';
    public string jsonstring='';
    
    ESC_Case_Form_Extension__c formextnew;
    
    
    
    /*public creditCardTokeniserController(Controller controller) {
        responseWrap = new ResponseWrapper.canvasURL();
        postmessageWrap = new ResponseWrapper.postmessageResponse();
        endpointURL = '';
        caseid = controller.getRecord().Id;
        system.debug('CaseId&&'+caseid);
        system.debug('language is'+userinfo.getLanguage());
    }*/
   
    public string getCaseNumber(){
        case cse =new case(); 
        if (Schema.sObjectType.case.isAccessible()){        
        cse = [select casenumber from case where id=:caseid];        
        }
        return cse.casenumber;      
    }
    public USL_generateCCTokenController() {
        responseWrap = new ResponseWrapper.canvasURL();
        postmessageWrap = new ResponseWrapper.postmessageResponse();
        endpointURL = '';
        cctoken='';      
         caseid= String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('caseid').escapeHtml4());       
        formId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('formid').escapeHtml4());
        if(formid != null && formid != '')
            if (Schema.sObjectType.GenerateForm__c.isAccessible()){
                formname = [Select name from GenerateForm__c where id=:formid].name ;
            }
        formExist=false;
        formext = new ESC_Case_Form_Extension__c();
        formextnew = new ESC_Case_Form_Extension__c();
        system.debug('CaseId&&'+caseid);
        system.debug('language is'+userinfo.getLanguage());
        caserec = new Case();
        if(caseid != null && caseid != ''){
            if (Schema.sObjectType.Case.isAccessible()){ 
            caserec = [Select USL_Payment_Details__c,accountid,contactid,USL_SAP_Account_Number__c,LCRM_Sub_Bu__c,BU_Segment__c from case where id=:caseid];
            }
             
        }
        if(caserec.USL_Payment_Details__c!=null){
            if (Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible()){ 
            formext = [Select USL_Card_Holder_Name__c,ESC_Amount_of_Prepayment__c,ESC_Credit_Card_Type__c,
                       USL_Credit_Card_Expiration_Date__c,Credit_Card_Token__c,ESC_Instructions__c,
                       ESC_Product_Description__c from ESC_Case_Form_Extension__c 
                       where ESC_Case__c =:caseid and Credit_Card_Token__c!=null limit 1 ];
                       }
                        formExist=true;
           
        }
    }
    
    
    public String getendpointURL(){
        try{

           //WebServiceSettings__c ccrec = WebServiceSettings__c.getInstance('Creditcardtokeniser');
           WebServiceSettings__c ccrec = WebServiceSettings__c.getInstance('USL CC Tokeniser');
            case cse =new case();
           if (Schema.sObjectType.case.isAccessible()){
              cse = [select casenumber,LCRM_Sub_BU__c from case where id=:caseid];
           }
           subBU=cse.LCRM_Sub_BU__c;
            intVal = USLARHelper.getIntegrationDefaults(caserec.BU_Segment__c,caserec.LCRM_Sub_Bu__c);
            Http h = new http();
            httprequest req = new httprequest();
            req.setendpoint(ccrec.Endpoint__c);
            req.setheader('Content-Type', 'application/json');
            req.setMethod('GET');
            req.setTimeout(20000);
          //  jsonstring = '{"HMACKey" : "ESCATR","APIKey" : "TRPMNTTOKEN_API","ProductID" : "ESCA","OriginURL" : "","CustomerRefnumber" : "","DynamicContent1" : "color:blue","DynamicContent2" : "Enter Credit Card Number"}';
           // jsonstring1 = '{"HMACKey" : intVal.ESC_Securesite_HAMCKey__c,"APIKey" : "TRPMNTTOKEN_API","ProductID" : intVal.ESC_Securesite_ProductId__c,"OriginURL" : "","CustomerRefnumber" : "","DynamicContent1" : "color:blue","DynamicContent2" : "Enter Credit Card Number"}';
           if(intval.ESC_SecureSite_JSON__C != '' && intval.ESC_SecureSite_JSON__c != null)
           {
            jsonstring=intval.ESC_SecureSite_JSON__c;
           }
           else
           {
            jsonstring ='{"HMACKey" : "ESCUTR","APIKey" : "TRPMNTTOKEN_API","ProductID" : "ESCU","OriginURL" : "","CustomerRefnumber" : "","DynamicContent1" : "color:blue","DynamicContent2" : "Enter Credit Card Number"}';
            }
            req.setbody(jsonstring);
            system.debug('request###'+req);            
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
    String response = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('postresponse').escapeHtml4());
       string response1 =response.replace('&quot;','"');
        String tokenVal = '';
        String ctype = '';
        boolean isError = true;
        
        if(validateData()){                
            JSONParser parser = JSON.createParser(response1);
            while(parser!=null && parser.nextToken() != null){
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'Hash'){                    
                    iserror = false;
                }
            }        

            if(!isError){
                postmessageWrap = (ResponseWrapper.postmessageResponse)JSON.deserialize(response1,ResponseWrapper.postmessageResponse.class);
                system.debug('postmessage wrap is'+postmessageWrap ); 
                if(postmessagewrap.payload.error == ''){           
                    String hashvalue = hashPayload(response1);
                    if(hashvalue == postmessageWrap.Hash){
                        tokenVal = postmessageWrap.payload.Token;
                        ctype = postmessageWrap.payload.Brand;
                        cctoken=tokenVal;

                        saveOnCase(tokenval,ctype);
                    }
                }
            }
            else{
                errorWrap = (ResponseWrapper.error)JSON.deserialize(response1,ResponseWrapper.error.class);
                if(errorWrap.error != null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.GGO_InvalidCreditCardNo);
                    ApexPages.addMessage(myMsg);
                }
            }
        }
        //system.debug('token is'+tokenVal);

    }
    
    public void saveOnCase(String token,String ctype){
        
        try{
           DateTime dt = Datetime.Now();
            String myDatetimeStr = dt.format('dd-MM-yyyy hh:mm:ss a','GMT');
            //Case crec = [select id,Description from case where id =:caseid];
            Case caseObj = new Case();
            caseObj.id = caseid;
            CaseObj.USL_Payment_Details__c = +System.Label.GGO_CreditCard_Addedon + ' ' + myDatetimeStr +' (GMT) '+'\n' +System.Label.GGO_CreditCard_AddedBy + ' '+ UserInfo.getFirstName()+' '+UserInfo.getLastName()+' '+'\n'+ System.Label.GGO_CreditCard_Token +' '+ token + '\n'+ System.Label.GGO_CreditCard_Expiry+' '+ expdate + '\n'+System.Label.GGO_CreditCard_Type +' '+ ctype + '\n'  ;
            //caseObj.GGO_CreditCardInfo__c = token+ ' '+ expdate+' '+name+' '+cardtype ;
            system.debug('caseObj$$$'+caseObj);
           if (Schema.sObjectType.Case.isUpdateable()){            
            update caseObj;
           }
            
            
            formextnew.ESC_Amount_of_Prepayment__c = formext.ESC_Amount_of_Prepayment__c;
            formextnew.ESC_Product_Description__c = formext.ESC_Product_Description__c;
            formextnew.USL_Card_Holder_Name__c = formext.USL_Card_Holder_Name__c;
            formextnew.USL_Credit_Card_Expiration_Date__c = expdate;
            formextnew.ESC_Instructions__c = formext.ESC_Instructions__c;
            formextnew.ESC_Case__c = caseid;
            formextnew.Credit_Card_Token__c=cctoken;
            formextnew.ESC_Form__c=formId;
            formextnew.ESC_Credit_Card_Type__c = ctype;
            caseExtInsertList.add(formextnew);
            
            if(caseExtInsertList.size() > 0 && Schema.sObjectType.ESC_Case_Form_Extension__c.IsCreateable()){               
               
                insert caseExtInsertList;           
            }
            system.debug('caseext' + caseExtInsertList);
                       ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,formname);
                 if(obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
                    }   
                
                else
                {        Group g =new Group();
                if (Schema.sObjectType.Group.isAccessible()){
                
                 g=[Select Id, DeveloperName  from Group where DeveloperName =:'EBO_USL_Credit_Card']; 
                }                       
                List<ESC_Case_Collaborator__c> newRef1 = new List<ESC_Case_Collaborator__c>();
                ESC_Case_Collaborator__c newRef = new ESC_Case_Collaborator__c();
                newRef.ESC_Role__c='Accountable Resolver';
                newRef.ESC_Referral_Status__c='New';
                newRef.OwnerId=g.Id;
                newRef.ESC_Case__c= caseid;
                newRef.RecordTypeId = Schema.SObjectType.ESC_Case_Collaborator__c.getRecordTypeInfosByName().get('Service Cloud Referral').getRecordTypeId();
                 if (Schema.sObjectType.ESC_Case_Collaborator__c.IsCreateable()){ 
                insert newRef;
                 }
            
            }
            
            
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
        Blob key;
        
       if(intVal.ESC_Securesite_HAMCKey__c!=''){
            key = Blob.valueof(intVal.ESC_Securesite_HAMCKey__c);
       }else{
           key = Blob.valueof('ESCUTR');
       }
        


        //Blob key = Blob.valueof('ESCATR');        
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

        /*else if(name == '' || name == null){

            errormsg = System.Label.GGO_CreditCardDateError;            
        }*/

             
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
        else{
            return true;
        }
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