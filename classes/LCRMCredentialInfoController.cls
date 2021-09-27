/*
@JIRA Story: CRM-6978, CRM-8066
@Purpose\Description: This Page is used for Displaying the Credential and IP Address Restriction Webservices Response. 
Credential Information Page Block Section which is returning the response from ESI external system when callout is made to ‘Credential’ and 'IP Address Restriction' webservice.

* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
*2017-09-15      Radhika Pawar              Credential and Merger with IP Restriction
* 2017-10-16     Noopur Rathod              IP Restriction                                    
* =============================================================================
*/
public with sharing class LCRMCredentialInfoController{
    //Define variables for Credential Info
    public List<Source_System_Detail__c> ListofSSD;
    public LCRMCredentialInfoHelper CredentialHelper;
    public boolean showCredentialSerch{get;set;}
    public boolean ExceptionCredential{get;set;}
    public static String strCredentialaction ='CredentialInfo';  
    public static String strCredentialsalesOrg ='WEST'; 
    public List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem> CredentialBusResponse{get;set;}
    public LCRMCredentialJsonWrapper.StatusDetailcls ExceptionMesginfo{get;set;}
    //END for Credential variable declaration
    //Define Property for IP Restriction
    public List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem> IPResponse{get;set;}
    public LCRMIPRestrictionJsonWrapper.StatusDetailcls ExceptionIPMesginfo{get;set;}
    public boolean ExceptionIPRestriction{get;set;}
    //public string SelectedDomain{get;set;}
    public string strValidityDateIP{get;set;}
    public Date validDate{get;set;} 
    public String tabInFocus;    
    public List<Source_System_Detail__c> IPSSDList;
    public string sSelectedOption{get;set;}
    //public String IPDate;
    public List<Account> ListofAcct;
    public Set<ID> accIDs; 
     //Define Property for ESI Header
    public static String appID ='GLI'; 
    public static String postBackURL=''; 
    //Define Property for Exception Log
    public String strBody;
    public String error; 
    //Paginate variables used for Pagination functionality
    public Paginate paginater {get;set;}
    public List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem> CredentialgenericList{get;set;}
    public List<List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem>> CredfullGenericList{get;set;}
    //Paginate variables for IP Restriction    
    public List<List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem>> ipResponsefullGenericList{get;set;}
    public List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem> ipGenericList{get;set;}
    public Paginate IPRestrpaginater {get;set;}
    //Set the page size
    public Integer pageSizeIP = 10;
    //
     public String getTabInFocus() {
    System.debug('tabInFocus:-'+tabInFocus);
    return tabInFocus;
    }
    public void setTabInFocus( String s ) {
    System.debug('Set Tab in Focus'+s);
    this.tabInFocus = s;   
    System.debug('    this.tabInFocus:-' +this.tabInFocus); 
    }
/* The extension constructor initializes the private member
// variable oAccount by using the getRecord method from the standard
// get the SSD records for Credential and IP restriction functionality
*/
    public LCRMCredentialInfoController(ApexPages.StandardController controller){
        try{
            //IP Restrction
            IPResponse = new List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem>();
            accIDs = new Set<ID>();     
            ListofAcct = new List<Account>();
            ExceptionCredential = false;
            ExceptionIPRestriction = false;
            showCredentialSerch = True;
            IPSSDList = new List<Source_System_Detail__c>();
            ExceptionIPMesginfo = new LCRMIPRestrictionJsonWrapper.StatusDetailcls();
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'IPSSDList:'+IPSSDList));
            System.debug('IPSSDList:'+IPSSDList);
            //End IP
            //get the selected AccountID
             Account oAccount = new account();
            CredentialBusResponse = new List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem>();
            ExceptionMesginfo= new LCRMCredentialJsonWrapper.StatusDetailcls();
            oAccount = (Account)controller.getRecord();
            System.debug('oAccount:'+oAccount);
            ListofSSD = new List<Source_System_Detail__c>();
            System.debug('ListofSSD:'+ListofSSD);
            CredentialHelper = new LCRMCredentialInfoHelper();
            ListofSSD = CredentialHelper.getSourceSystemDetails(oAccount);
            System.debug('ListofSSD:'+ListofSSD);
            // IP Address Restriction 
            ListofAcct = [select id,ParentId from Account Where (id = :oAccount.id and ParentId !=null) or (id = :oAccount.id and ParentId =null) ] ;
            System.debug('ListofAcct:'+ListofAcct);
            for(Account accIP : ListofAcct){
            System.debug('accIDs'+accIDs);
            if(accIP.ParentId == null){
                accIDs.add(accIP.Id);
                System.debug('If : accIDs'+accIDs);
            }
            else if(accIP.ParentId != null){
                accIDs.add(accIP.Id);
                accIDs.add(accIP.ParentId);   
            }
            }
            System.debug('Else : accIDs'+accIDs);
            System.debug('ListofAcct :-'+ListofAcct );
            IPSSDList = CredentialHelper.getSourceSystemDetailsIPva(accIDs);
            System.debug('IPSSDList:'+IPSSDList);
            strValidityDateIP = System.today().format();
            system.debug('***strValidityDateIP***'+ strValidityDateIP);
            if(ListofSSD.isEmpty()){
                showCredentialSerch=false;
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records found in Source System Details!'));
            }
        }catch (Exception oException){
             ApexPages.addMessages(oException);
        }
    }
/*
*@Overview: When the Credential Button is clicked, in sequences the Credential and IP Address Restriction Web Services are called
*Description : SFDC parameters mapping with external system's parameters for requesting external webservice
*authentication done in this method.
*/
    public pagereference displayCredInfoList(){
    final string WebServiceNameCredential = 'LCRM_CredentialInfoServices';
        Try{        
            if(!ListofSSD.isEmpty() && strCredentialaction =='CredentialInfo' && strCredentialsalesOrg =='WEST'){
                //Credential Webservice
                String jsonString = LCRMCredentialJsonWrapper.getCredentialReqJsonString(strCredentialaction,strCredentialsalesOrg,ListofSSD);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                if(ApexPages.getMessages().size()>0){
                    return null;
                }
                request = CredentialHelper.getHttpRequestCred(WebServiceNameCredential,jsonString);
                HttpResponse Response = http.Send(request);
                System.debug('Response:-'+Response);
                System.debug(''+Response.getBody());
                String JsonResponseCredential=Response.getBody();
                System.debug('JsonResponseCredential:-'+JsonResponseCredential);
                if (Response.getStatusCode() == 200 ) {
                    if(LCRMCredentialJsonWrapper.getMatchedCredBusRecord(JsonResponseCredential).size()>0){
                        this.CredentialBusResponse =LCRMCredentialJsonWrapper.getMatchedCredBusRecord(JsonResponseCredential);
                        //Pagination Logic Start
                        //Set the page size
                        Integer pageSize = 10;
                        //Create a new instance of Paginate passing in the overall size of 
                        //the list of data and the page size you want
                        this.paginater = new Paginate(CredentialBusResponse.size(), pageSize);
                        System.debug('paginater:-'+paginater);
                        //These lists hold the data
                        this.CredfullGenericList = new List<List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem>>();
                        this.CredentialgenericList = new List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem>();
                        System.debug('CredentialBusResponse.size():-'+CredentialBusResponse.size());
                        //Break out the full list into a list of lists//CredentialBusResponse.size() > 0
                        if(!CredentialBusResponse.isEmpty()){
                            List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem> tempCC = new List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem>();         
                            Integer i = 0;
                            for(LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem cc : CredentialBusResponse){
                                tempCC.add(cc);
                                i++;
                                if(i == pageSize){
                                    this.CredfullGenericList.add(tempCC);
                                    tempCC = new List<LCRMCredentialJsonWrapper.CredentialInfoBusinessRestrictionItem>();
                                    i = 0;
                                }
                            }
                            System.debug('tempCC:-'+tempCC);
                            if(!tempCC.isEmpty()){
                             this.CredfullGenericList.add(tempCC);
                            }
                            System.debug('CredfullGenericList:-'+CredfullGenericList);  
                            //Gets the correct list of data to show on the page
                            this.CredentialgenericList = this.CredfullGenericList.get(this.paginater.index);
                            System.debug('CredentialgenericList:-'+CredentialgenericList);
                        }
                    //Pagination Logic End
                        
                        System.debug('CredentialBusResponse**inside-'+CredentialBusResponse);
                }else if(LCRMCredentialJsonWrapper.getSAPExceptionMesg(JsonResponseCredential)!= null){
                    ExceptionCredential=True;
                    ExceptionMesginfo = LCRMCredentialJsonWrapper.getSAPExceptionMesg(JsonResponseCredential);
                    System.debug('ExceptionMesginfo:-'+ExceptionMesginfo);
                }
            if( (LCRMCredentialJsonWrapper.getSAPExceptionMesg(JsonResponseCredential) == null) && (LCRMCredentialJsonWrapper.getMatchedCredBusRecord(JsonResponseCredential).size() == 0) ){
               // Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Response is returned!'));       
               Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,(Label.LCRMCredentialResponseStatus)));
              }
            System.debug('CredentialBusResponse**-'+CredentialBusResponse);
            }else{
                System.debug('Error:-'+Response.getStatus());
                strBody = 'for Credential, Response is not recieved.';
                error = 'Get the Response Status Code'+Response.getStatusCode()+' and get the Response Status '+Response.getStatus();
                System.debug('strBody'+strBody+'error'+error);
                CredentialHelper.logException(strBody, error, WebServiceNameCredential);
                if(Response.getStatusCode() == 401){
                    //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please Check Authentication for Credential webservice'));
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,(Label.LCRMAuthenticationforCredential)));
                }else{
                     String strAuthenCredential = Label.LCRMNomatchedRequest_URLforCredential+''+Response.getStatus();
                    //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The server has not found anything matching the Request-URL and get the Response Status '+Response.getStatus()));
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,+strAuthenCredential));
                    }
                }    
            }else{  
               Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,(Label.LCRMNoSSDFoundError)));
            }
        }catch(CalloutException excpObj){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+excpObj.getMessage()));
        }catch(Exception objException) {
            strBody = 'Response is incorrect';
            error = objException.getMessage();
            CredentialHelper.logException(strBody, error, WebServiceNameCredential);
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+objException.getMessage()));
        }
    return null;
    }
    
    /*
    *When the Credential Button is clicked, in sequences the Credential and IP Address Restriction Web Services are called
    */

    public pagereference displayIPInfoList(){  
        final string WebServiceNameCredential = 'LCRM_IPRestrictionServices';
        // IPResDomain = sSelectedOption;
        Try{
        if(IPSSDList.size()>0  && (sSelectedOption =='CLEAR' || sSelectedOption =='CREDENTIALING' || sSelectedOption =='RFI')){
        if (strValidityDateIP== ''){
        validDate = Date.valueof('0001-01-01'); 
        system.debug('***ValidDate***'+ validDate);
        }
        else{
        System.debug('***strValidityDateIP***'+ strValidityDateIP);
        validDate = date.parse(strValidityDateIP);
        System.debug('***ValidDate***'+ validDate);
        strValidityDateIP= String.valueof(validDate); 
        System.debug('**Final strValidityDateIP**'+strValidityDateIP);
        }
        /* if(validDate.month() == 1 || validDate.month() == 2 || validDate.month() == 3 || validDate.month() == 4 || validDate.month() == 5 || validDate.month() == 6 || validDate.month() == 7 || validDate.month() == 8 || validDate.day() == 1 || validDate.day() == 2 || validDate.day() == 3 || validDate.day() == 4 || validDate.day() == 5 || validDate.day() == 6 || validDate.day() == 7 || validDate.day() == 8){
        IPDate = validDate.year() + '-' + 0+validDate.month() + '-' +validDate.day();
        }
        else{
        IPDate = validDate.year() + '-' +validDate.month() + '-' +validDate.day();
        }*/
        
        //get the Json String from getCredentialJsonString Method
        String jsonString = LCRMIPRestrictionJsonWrapper.getCredentialReqJsonString(appID,postBackURL,sSelectedOption,strValidityDateIP,IPSSDList);
        
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'jsonString:'+jsonString));
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        /*request=CredentialHelper.getHttpRequest(WebServiceNameCredential);
        System.debug('jsonString:-'+jsonString);
        if(String.IsNotBlank(jsonString)){
        request.setBody(jsonString);
        System.debug('request:-'+request);
        }*/
        //Need to uncomment this code
        if(ApexPages.getMessages().size()>0)
        {
        return null;
        }
        request = CredentialHelper.getHttpRequestCred(WebServiceNameCredential,jsonString);
        HttpResponse Response = http.Send(request);
        System.debug('Response:-'+Response);
        System.debug(''+Response.getBody());
        String JsonResponseCredential=Response.getBody();
        System.debug('JsonResponseCredential:-'+JsonResponseCredential);
        if (Response.getStatusCode() == 200 ) {
            System.debug('Size of IPRestriction***'+LCRMIPRestrictionJsonWrapper.getMatchedCredentialRecord(JsonResponseCredential).size());
            if(LCRMIPRestrictionJsonWrapper.getMatchedCredentialRecord(JsonResponseCredential).size()>0){
                this.IPResponse = LCRMIPRestrictionJsonWrapper.getMatchedCredentialRecord(JsonResponseCredential);
                System.debug('this.IPResponse:-'+this.IPResponse);
                //Pagination Logic Start
                 //Create a new instance of Paginate passing in the overall size of 
                //the list of data and the page size you want
                this.IPRestrpaginater = new Paginate(IPResponse.size(), pageSizeIP );
                
                System.debug('IPRestrpaginater:-'+this.IPRestrpaginater);
                //These lists hold the data
                
                this.ipResponsefullGenericList = new List<List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem>>();
                this.ipGenericList = new List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem>();
                
                
                System.debug('IPResponse.size():-'+IPResponse.size());
                //Break out the full list into a list of lists  IPResponse.size() > 0
                if(!IPResponse.isEmpty()){
                    List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem> tempCC = new List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem>();         
                    Integer i = 0;
                    for(LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem cc : IPResponse){
                        tempCC.add(cc);
                        i++;
                        if(i == pageSizeIP){
                            //this.ipResponseList.add(cc);
                            this.ipResponsefullGenericList.add(tempCC);
                            //ipResponseList = new List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem>();
                            tempCC = new List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem>();  
                            i = 0;
                        }
                    }
                    System.debug('tempCC:-'+tempCC);
                    if(!tempCC.isEmpty()){
                        this.ipResponsefullGenericList.add(tempCC);
                    }
                    System.debug('ipResponseList:-'+ipResponsefullGenericList);  
                    //Gets the correct list of data to show on the page
                    system.debug('****index this.IPRestrpaginater.index'+ this.IPRestrpaginater.index);
                    this.ipGenericList = this.ipResponsefullGenericList.get(this.IPRestrpaginater.index);
                    System.debug('ipGenericList:-'+ipGenericList);
                }
            //Pagination Logic End
            }else if(LCRMIPRestrictionJsonWrapper.getSAPExceptionMesg(JsonResponseCredential)!= null){
                ExceptionIPRestriction = True;
                ExceptionIPMesginfo = LCRMIPRestrictionJsonWrapper.getSAPExceptionMesg(JsonResponseCredential);
                System.debug('ExceptionIPMesginfo:-'+ExceptionIPMesginfo);
            }    
            System.debug('IPResponse***** :-'+IPResponse );
        }else{
            strBody = 'for IP Restriction, Response is not recieved.';
            error = 'Get the Response Status Code'+Response.getStatusCode()+' and get the Response Status '+Response.getStatus();
            System.debug('strBody'+strBody+'error'+error);
            CredentialHelper.logException(strBody, error, WebServiceNameCredential);
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The server has not found anything matching the Request-URL and get the Response Status '+Response.getStatus()));
            String strAuthenIP = Label.LCRMNomatchedRequest_URLforCredential+''+Response.getStatus();
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The server has not found anything matching the Request-URL and get the Response Status '+Response.getStatus()));
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,+strAuthenIP));
        }
        
        }else{
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,(Label.LCRMNoSSDFoundError)));
        }
        
        }
        catch(CalloutException excpObj) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+excpObj.getMessage()));    
        }
        catch(Exception objException) {
            strBody = 'Response is incorrect';
            error = objException.getMessage();
            CredentialHelper.logException(strBody, error, WebServiceNameCredential);
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error: '+objException.getMessage()));       
        }
        return null;
    }

    /*
    *Domain's value populated from Credentialinfo custom setting
    */
    public List<selectoption> getDomainListOptions(){
    List<selectoption> DomainList = new  List<selectoption>();
   // DomainList.add(new SelectOption('', '- - None - -'));
    Map<String,CredentialInfo__c> mapDomain = CredentialInfo__c.getAll();
    for(String strDomain : mapDomain.keySet()){
       if(!strDomain.equalsIgnoreCase('CREDENTIALING')){
        DomainList.add(new selectoption(strDomain,strDomain));
       }
    }
    return DomainList;
    }
  
    public PageReference FetchRecords()
    {      
     IPResponse= new List<LCRMIPRestrictionJsonWrapper.cls_IPRestrictionItem> ();
     return null;
    }
    // for Credential pagination functionality 
    public PageReference previousPage(){
        System.debug('**previousPage**');
        this.paginater.decrement();
        return changeData();
    }

    public PageReference nextPage(){
        System.debug('**nextPage**');
        this.paginater.increment();
        return changeData();
    }

    public PageReference updatePage(){
        System.debug('**call updatePage**');
        this.paginater.updateNumbers();
        return changeData();
    }

    public PageReference changeData(){
        System.debug('**changeData:-**');
        this.CredentialgenericList = this.CredfullGenericList.get(this.paginater.index);
        return null;
    }
    //End Credential pagination functionality
    public PageReference previousPageIP(){
        System.debug('**previousPage**');
        this.IPRestrpaginater.decrement();
        return changeDataIP();
    }

    public PageReference nextPageIP(){
        System.debug('**nextPage**');
        this.IPRestrpaginater.increment();
        return changeDataIP();
    }

    public PageReference updatePageIP(){
        System.debug('**call updatePage**');
        this.IPRestrpaginater.updateNumbers();
        return changeDataIP();
    }

      
    public PageReference changeDataIP(){
    System.debug('**changeData:-**');
        if(ipResponsefullGenericList.size() > 0){
        this.ipGenericList = this.ipResponsefullGenericList.get(this.IPRestrpaginater.index);
        system.debug('*******In change data ipGenericList'+ ipGenericList);
        }
    return null;
    }
}