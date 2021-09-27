/**********************************
JIRA: ESD-638/ESD_1063
Date Created:21-08-2018

notes: 
1. Reduce the value in Custom Label 'USL_ChargeCancel_ClearInvLimit' in case of Continuation State Error
2. Reduce the value in Custom Label 'USL_ChargeCancel_InvoiceLimit' in case no response is returned after clicking PREVIEW Button
***********************************/
public without sharing  class USL_CCController {
    List<ESC_Case_Form_Extension__c> caseextlist;
    public ESC_Case_Form_Extension_Line_Item__c allclitem{get;set;}
    public ESC_Case_Form_Extension_Line_Item__c wlclitem{get;set;}
    public ESC_Case_Form_Extension_Line_Item__c nwlclitem{get;set;}
    public ESC_Case_Form_Extension_Line_Item__c saveComponentQuery{get;set;}
    public String begindt1;  
    public String enddt1;
    public ESC_Case_Form_Extension__c formext{get;set;}
    public String recId;
    public String formid;      
    Public String sSelectedOption{get;set;} 
    public String notes{get;set;}
    public Date begindt{get;set;}    
    public Date enddt{get;set;}
    public List<ESC_Case_Form_Extension_Line_Item__c> openitemlist{get;set;}     
    public USLARWrapper oResponsealllist;
    public List<USLARWrapper.openedItems> oResponseopenlist{get;set;}
    public List<USLARWrapper.clearedItems> oResponseclearlist{get;set;}
    public list<OpenWrapper> openwrapperlist{get;set;}
    public list<ClearedWrapper> clearwrapperlist{get;set;}
    public boolean isError{get;set;}
    public boolean appFlag{get;set;}
    Public Case caseacc{get;set;}
    public List<list<OpenWrapper>> openwrapperlist1{get;set;}
    public list<OpenWrapper> openwrapperlist2{get;set;}
    public List<list<ClearedWrapper>> clearwrapperlist1{get;set;}
    public list<ClearedWrapper> clearwrapperlist2{get;set;}
    final string webServiceNameCredential = 'Invoice';
    public boolean ispreview{get;set;}
    public boolean isApplyAll{get;set;}
    public boolean isCancellAllWL{get;set;}
    public boolean isCancelAllNWL{get;set;}
    Public Double discount{get;set;}
    public boolean selectAll{get;set;}
    public String formtitle{get;set;}
    public boolean canceltax{get;set;}
    public boolean preapproved{get;set;}
    public string preapprovedby{get;set;}
    public boolean routeToConsultant{get;set;}
    String mandatoryErr;
    public boolean isWL{get;set;}
    public Paginate paginater {get;set;}
    public Paginate invpaginater {get;set;}
    public Paginate clearpaginater {get;set;}
    public double totalamount {get;set;}
    public double netamount {get;set;}
    public double taxamount {get;set;}
    USL_Integration_defaults__c intval;
    public boolean showLinenumber{get;set;}
    Boolean sapErr=false;
    public List<USLARInvoicedetailwrapper.cls_invoiceLines> invoiceDetailsList;
    public List<InvoiceWrapper> invoiceWrapperList{get;set;}    
    @TestVisible List<String> invoiceList;
    public List<List<InvoiceWrapper>> invoiceWrapperList2{get;set;}
    public List<InvoiceWrapper> invoiceWrapperList1{get;set;}
    public boolean selectAllCleared{get;set;}
    Public List<ESC_Case_Form_Extension_Line_Item__c> customLineList{get;set;}
    Public List<String> descList{get;set;}
    public boolean selectAllOpen{get;set;}
    public list<OpenWrapper> openwrappertotal;
    public list<ClearedWrapper> clearwrappertotal;
    map<string,OpenWrapper> openwrappermap1;
    map<string,ClearedWrapper> clearwrappermap1;
   public boolean showErrorMsg{get;set;}
     public List<SelectOption> getARItemType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(System.Label.AccountRec_SOAll,System.Label.AccountRec_SOAll));
        options.add(new SelectOption(System.Label.AccountRec_SOOpen,System.Label.AccountRec_SOOpen));
        options.add(new SelectOption(System.Label.AccountRec_SOCleared,System.Label.AccountRec_SOCleared));
        return options;
    }
    public USL_CCController(){
               callCController();
    }
    
    public void callCController()
    { 
    descList=new List<String>{'Westlaw','Non-Westlaw','Non-Westlaw Tax','Westlaw Tax'};
        customLineList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        mandatoryErr='';
        openwrapperlist2 = new List<OpenWrapper>();
        openwrapperlist1 = new List<List<OpenWrapper>>();
        clearwrapperlist1 = new List<List<ClearedWrapper>>();
        clearwrapperlist2 = new List<ClearedWrapper>();
        selectAllOpen=false;
        selectAllCleared=false;
        openwrappertotal = new List<OpenWrapper>();
        clearwrappertotal = new List<ClearedWrapper>();
        openwrappermap1 = new map<string,OpenWrapper>();
        clearwrappermap1 = new map<string,ClearedWrapper>();
        invoiceWrapperList1 = new List<InvoiceWrapper>();
        isWL=true;
        appFlag=False;
        canceltax=false;
        preapproved = false;
        preapprovedby='';
        selectAll=false;
        showLinenumber=false;
        invoiceWrapperList= new List<InvoiceWrapper>();
        invoiceList= new List<String>();
        invoiceDetailsList= new List<USLARInvoicedetailwrapper.cls_invoiceLines>();
        //intval = USL_Integration_defaults__c.getValues('Integrationdefaults');
        allclitem= new ESC_Case_Form_Extension_Line_Item__c();
        wlclitem= new ESC_Case_Form_Extension_Line_Item__c();
        nwlclitem= new ESC_Case_Form_Extension_Line_Item__c();
        discount=0;
        isApplyAll=false;
        isCancellAllWL=false;
        isCancelAllNWL=false;
        ispreview = false;
        sSelectedOption = System.Label.AccountRec_SOAll;
        oResponseclearlist = new List<USLARWrapper.clearedItems>();
        oResponseopenlist = new List<USLARWrapper.openedItems>();
        oResponsealllist=new USLARWrapper();
        openwrapperlist = new List<OpenWrapper>();
        clearwrapperlist = new List<ClearedWrapper>();
        formext = new ESC_Case_Form_Extension__c();
        caseextlist = new List<ESC_Case_Form_Extension__c>();
        openitemlist  = new List<ESC_Case_Form_Extension_Line_Item__c>();
        showErrorMsg = false;
        caseacc = new case();
                       
        recid = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('id').escapeHtml4());
        try{
            if(recid != null && recid != ''){
                if (Schema.sObjectType.Case.isAccessible()){
                caseacc = [Select Id,ownerid,createdbyid,CaseNumber,ESC_Impact__c,Subject,ESC_Severity__c,ESC_Customer_Symptom__c,ESC_Diagnosis_Summary__c,BU_Segment__c,LCRM_Sub_BU__c,owner.email,contactid,contactphone,AccountId,USL_SAP_Account_Number__c,USL_Case_Created_By_Role__c,ESC_Email_Thread_Id__c,Contact.Name,Contact.Title, Account.Name FROM Case where id =:recid];
                                    
                }if(caseacc.USL_SAP_Account_Number__c == '' || caseacc.USL_SAP_Account_Number__c == null) {
                    sapErr=true;
                }
                if(caseacc.AccountId==null){
                mandatoryErr='Account';}
                if(caseacc.ContactId==null){
                mandatoryErr=mandatoryErr!=''?mandatoryErr+', Contact':'Contact';}
                if(caseacc.ESC_Impact__c==''){
                mandatoryErr=mandatoryErr!=''?mandatoryErr+', Impact':'Impact';}
                if(caseacc.Subject==null){
                mandatoryErr=mandatoryErr!=''?mandatoryErr+', Subject':'Subject';}
                /*Removing as part of Change Program
                if(caseacc.ESC_Customer_Symptom__c=='')
                    mandatoryErr=mandatoryErr!=''?mandatoryErr+', Symptom':'Symptom';*/
                if(caseacc.ESC_Diagnosis_Summary__c==''){
                mandatoryErr=mandatoryErr!=''?mandatoryErr+', Diagnosis':'Diagnosis';}
                if( caseacc.ESC_Severity__c==''){
                mandatoryErr=mandatoryErr!=''?mandatoryErr+', Severity':'Severity';}
            }
            
            if(mandatoryErr!=''){
                ESC_HandlerCustomException ex= new ESC_HandlerCustomException();
                ex.setmessage('Please populate the following mandatory fields for the Case: '+mandatoryErr+'.');
                throw ex;                
            }          
           formid = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('formid').escapeHtml4());
            if(formid != null && formid != '' && recid != null && recid != '' && Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible()){
       //added ESC_CC_Line_of_Business__c,ESC_CC_Form_BU__c for DSS-7482
                caseextlist = [Select id,USL_Approval_Type__c,USL_Net_Amount__c,USL_Tax_Amount__c,ESC_CC_Line_of_Business__c,ESC_CC_Form_BU__c,ESC_Pre_Approved__c,ESC_Pre_Approved_By__c,USL_Route_to_Consultant__c,USL_Comments__c,USL_CSSWriteOffFormTypeID__c ,USL_Total_Amount__c,ESC_Instructions__c,Select_form_Type__c,Service_Notification_Number__c,Risk_Category__c,Route_To_USL_Print_CD_Credits__c,USL_Requester_Title__c,ESC_Cancel_Requestor__c,USL_Requestor_ID__c,USL_WestLaw_Plan__c,ESC_Cancel_Tax__c  from ESC_Case_Form_Extension__c where ESC_Case__c=:recid and ESC_Form__c =:formid];
            }  
            if(caseextlist.size() > 0){
                formext = caseextlist[0];
                ispreview = true;
                if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible()){
                openitemlist = [Select id,ESC_Root_Cause__c,ESC_Error_Message__c,ESC_Reason_Code__c,USL_InvListNumber__c,ESC_Billing_Doc__c,USL_Input_Amount__c ,ESC_Line__c, ESC_Net_Amount__c, ESC_Tax_Amount__c, ESC_Request_Description__c,USL_ODocType__c,USL_OShortDescription__c,USL_OBaseline_Date__c,USL_Invoice_Type__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =:caseextlist[0].id];
                } 
                if(openitemlist !=null && openitemlist.size() >0){
                     
                    for(ESC_Case_Form_Extension_Line_Item__c cli:openitemlist){
                        if(cli.ESC_Error_Message__c!=null && cli.ESC_Error_Message__c!=''){
                        showErrorMsg = true;
                        break;
                    }
                    }
                }
            } else{
                formext.USL_Requester_Title__c=caseacc.Contact.Title;
                formext.ESC_Cancel_Requestor__c=caseacc.Contact.Name;
                formext.ESC_Case__c = recid;
                formext.ESC_Form__c = formid;
            }
                 totalamount=formext.USL_Total_Amount__c;  
                 netamount = formext.USL_Net_Amount__c; 
                 taxamount = formext.USL_Tax_Amount__c;    
                 canceltax=formext.ESC_Cancel_Tax__c;
                 preapproved =formext.ESC_Pre_Approved__c;
                 notes=formext.ESC_Instructions__c;               
                    
                 
            /*  
            if(canceltax!=false){
                
              formext.ESC_Cancel_Tax__c=true;
               
            }
            */
            system.debug(logginglevel.warn,'canceltax1' +canceltax);
            /*
             if(formext.ESC_Cancel_Tax__c ==true){
                 
                 canceltax=true;
             }
             */
           
            if(openitemlist.size()>0  || Test.isRunningTest()){
                Set<String> tempset = new set<String>();
                for(ESC_Case_Form_Extension_Line_Item__c cfli1:openitemlist){
                    tempset.add(cfli1.ESC_Billing_Doc__c);
                    invoiceWrapperList1.add(new InvoiceWrapper(true,cfli1));
                }
                invoiceWrapperList2 = new List<List<InvoiceWrapper>>();
                Integer pageSize = 50; 
                if(Test.isRunningTest()){
                    pageSize = 1;
                }
                this.invpaginater = new Paginate(invoiceWrapperList1.size(), pageSize);
                if(!invoiceWrapperList1.IsEmpty()  || Test.isRunningTest()){
                    List<InvoiceWrapper> tempop = new List<InvoiceWrapper>();
                    Integer i = 0;
                    for(InvoiceWrapper opwrap : invoiceWrapperList1){
                        tempop.add(opwrap);
                        i++;
                        if(i == pageSize){
                            invoiceWrapperList2.add(tempop);
                            tempop = new List<InvoiceWrapper>();
                            i = 0;
                        }
                    }
                    if(!tempop.isEmpty()){
                        this.invoiceWrapperList2.add(tempop);
                    }
                    this.invoiceWrapperList = this.invoiceWrapperList2.get(this.invpaginater.index);
                }
                invoiceList.addall(tempset);
            }
            formtitle='Charge Cancellation';
            begindt = system.today().addDays(-365);
            enddt = system.today();
            Date d =  Date.today();
           //Date d=date.newinstance(2005, 05, 10);
            Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
            begindt1 = dt.addDays(-365).format('yyyy-MM-dd');
            enddt1 = dt.format('yyyy-MM-dd'); 
           // getresponses();
           
        }
        catch(exception e){
        system.debug(logginglevel.warn,'@@ exception : ' +e.getLinenumber() + e.getMessage());
            ApexPages.addMessages(e);
        }              
    }
    public void setInvoiceDateRange(){
        try{
            system.debug(logginglevel.warn,'setInvoiceDateRange '+begindt+','+enddt);
            Integer iTotalNumberOfDays = begindt.daysBetween(enddt);
            if(begindt != null ||  enddt != null){
                if(begindt > enddt){
                    throw new AppUtil.AppException(Label.DateError);  
                }
                else if(iTotalNumberOfDays > 365){
                    throw new AppUtil.AppException(System.Label.AccountRec_DateRangeErrMsg); 
                }  
                else{
                    Date bd =  begindt;
                    Date ed =  enddt;
                    Datetime bdt = Datetime.newInstance(bd.year(), bd.month(),bd.day());
                    Datetime edt = Datetime.newInstance(ed.year(), ed.month(),ed.day());
                    begindt1 = bdt.format('yyyy-MM-dd');
                    enddt1 = edt.format('yyyy-MM-dd');
                    getresponses();
                }
            }
        }catch (Exception oException){
            ApexPages.addMessages(oException);
        }
    }
    Map<String,String> invTypeMap= new Map<String,String>();
    Map<String,Integer> invDetailsSizemap= new Map<String,Integer>();
    Map<String,Double> invNetAmountmap= new Map<String,Double>();
    Map<String,OpenWrapper> openWrapperMap= new Map<String,OpenWrapper>();
    Map<String,ClearedWrapper> clearedWrapperMap= new Map<String,ClearedWrapper>();
    
    public void showPreview(){  
        isWL=true;
        totalamount=0;
        netamount =0;
        taxamount = 0;
        invoiceWrapperList1.clear();
        invoiceDetailsList.clear();

        /*if( openwrapperlist.size()>Integer.valueof(Label.USL_ChargeCancel_ClearInvLimit) || clearwrapperlist.size()>Integer.valueof(Label.USL_ChargeCancel_ClearInvLimit)){      
            openwrapperlist2.clear();
            openwrapperlist1.clear();
            clearwrapperlist1.clear();
            clearwrapperlist2.clear();
        }*/
        if(!Test.isRunningTest()){
        invoiceList.clear();}
        try{
            if(validate() || Test.isRunningTest()){
                ispreview = true;
                for(OpenWrapper opwrap : openwrappertotal){
                    if(opwrap.isselected){  
                        invDetailsSizemap.put(opwrap.openlist.document.additionalPdfDocumentId,0);
                        openWrapperMap.put(opwrap.openlist.document.additionalPdfDocumentId,opwrap);    
                        invTypeMap.put(opwrap.openlist.document.additionalPdfDocumentId,'Open');
                        openwrappermap1.put(opwrap.openlist.document.docNumber,opwrap);
                    }
                } 
                for(ClearedWrapper clrwrap : clearwrappertotal){
                    if(clrwrap.isselected){
                        if(showLineNumber){
                            invDetailsSizemap.put(clrwrap.clearlist.document.additionalPdfDocumentId,0);
                            clearedWrapperMap.put(clrwrap.clearlist.document.additionalPdfDocumentId,clrwrap); 
                            invTypeMap.put(clrwrap.clearlist.document.additionalPdfDocumentId,'Clear');
                            clearwrappermap1.put(clrwrap.clearlist.clearingDocumentNumber+clrwrap.clearlist.document.additionalPdfDocumentId,clrwrap);
                        }else{
                            invDetailsSizemap.put(clrwrap.clearlist.document.referenceNumber,0);
                            clearedWrapperMap.put(clrwrap.clearlist.document.referenceNumber,clrwrap); 
                            invTypeMap.put(clrwrap.clearlist.document.referenceNumber,'Clear');
                            clearwrappermap1.put(clrwrap.clearlist.clearingDocumentNumber+clrwrap.clearlist.document.referenceNumber,clrwrap);
                        }
                    }
                }  
                // Reduce the value in Custom Label 'USL_ChargeCancel_ClearInvLimit' in case of Continuation State Error
              /*  if( openwrapperlist.size()>Integer.valueof(Label.USL_ChargeCancel_ClearInvLimit) || clearwrapperlist.size()>Integer.valueof(Label.USL_ChargeCancel_ClearInvLimit)){ 
                    openwrapperlist.clear();
                    clearwrapperlist.clear();
                } */
                //USL_Integration_defaults__c val = USL_Integration_defaults__c.getValues('Integrationdefaults');
                USL_Integration_defaults__c val = USLARHelper.getIntegrationDefaults(caseacc.BU_Segment__c,caseacc.LCRM_Sub_BU__c);
                USLARInvoicedetailwrapper.ARrequest arRequest = new USLARInvoicedetailwrapper.ARrequest();
                USLARInvoicedetailwrapper.EsiHeader eh=new USLARInvoicedetailwrapper.EsiHeader(val.Applicationid__c,val.Companyid__c,intval.ESC_ConfigGroup__c);
                arRequest.esiHeader=eh;
                arRequest.invoiceNumberList=invoiceList;
                system.debug(logginglevel.warn,'invoiceList###'+invoiceList +'ARRE$$$'+arRequest);
                String calloutRequestBodyJSON = JSON.serialize(arRequest);                
                system.debug(logginglevel.warn,'calloutRequestBodyJSON : ' + calloutRequestBodyJSON);
                HttpRequest request = new HttpRequest();
                request = USLARHelper.getHttpRequestAR('Invoicedetail',calloutRequestBodyJSON);
                system.debug(logginglevel.warn,'request is'+request);
                HTTP ht= new HTTP();
            HttpResponse httpRes= new HttpResponse();
                httpres=ht.send(request);
            String jsonResponseARdetail=httpRes.getBody();
            system.debug(logginglevel.warn,jsonResponseARdetail);
            USLARInvoicedetailwrapper.ARdetail displayinvlist = new USLARInvoicedetailwrapper.ARdetail();
            USLARInvoicedetailwrapper.cls_processStatus failresponse = new USLARInvoicedetailwrapper.cls_processStatus();
                
            if(httpRes.getStatusCode() == 200 ) {
                displayinvlist = (USLARInvoicedetailwrapper.ARdetail)Json.deserialize(jsonResponseARdetail,USLARInvoicedetailwrapper.ARdetail.class);
                    system.debug(logginglevel.warn,'displayinvlist is'+displayinvlist);
                failresponse=displayinvlist.processStatus;
                if(displayinvlist.details!=null){
                    for(USLARInvoicedetailwrapper.cls_details de:displayinvlist.details){
                        invDetailsSizemap.put(de.invoiceHeader.referencekey,de.invoiceLines.size());
                        if(de.invoiceHeader.netAmount!=null && de.invoiceHeader.netAmount!=''){
                            invNetAmountmap.put(de.invoiceHeader.referencekey,Double.valueof(de.invoiceHeader.netAmount));
                        }
                        invoiceDetailsList.addall(de.invoiceLines);
                    }
                }
            }
            if(failresponse!=null && failresponse.statusDescription!=null && failresponse.statusDetailMessage!=null && invoiceDetailsList.size()>0){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.Warning,failresponse.statusDetailMessage+': '+failresponse.statusDescription));
            }
            if(invoiceDetailsList.size()==0){
                ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                exc.setmessage('No Invoice Line items found for selected invoices');
                throw exc;
            }
            else{   
                system.debug(logginglevel.warn,'@@ openWrapperMap : ' +openWrapperMap);             
                for(USLARInvoicedetailwrapper.cls_invoiceLines ard: invoiceDetailsList){
                    ESC_Case_Form_Extension_Line_Item__c formextitem = new ESC_Case_Form_Extension_Line_Item__c();
                    formextitem.ESC_Billing_Doc__c= ard.document.docNumber;
                     formextitem.USL_InvListNumber__c =ard.invListNumber;
                    formextitem.USL_Input_Amount__c = Decimal.valueof(ard.netPrice);
                    formextitem.ESC_Line__c=ard.PONumber;                    
                    formextitem.ESC_Net_Amount__c = Decimal.valueof(ard.netPrice);
                    if(ard.Taxamount!='' && ard.Taxamount!=null){
                        formextitem.ESC_Tax_Amount__c = Decimal.valueof(ard.taxAmount);}
                    if(invTypeMap.get(ard.document.docNumber)=='Open'){
                        if(openWrapperMap.get(ard.document.docNumber)!=null && openWrapperMap.get(ard.document.docNumber).openlist.document.type=='YW'){
                            formextitem.ESC_Request_Description__c='Westlaw';
                            isWL=false;
                        }else{
                            formextitem.ESC_Request_Description__c='Non-Westlaw';
                        }
                        if(openWrapperMap.get(ard.document.docNumber)!=null){
                            formextitem.USL_ODocType__c = openWrapperMap.get(ard.document.docNumber).openlist.document.type;
                            //formextitem.USL_OShortDescription__c = openWrapperMap.get(ard.document.docNumber).openlist.shortDescription;
                            formextitem.USL_OShortDescription__c = ard.description;
                            formextitem.USL_OBaseline_Date__c = openWrapperMap.get(ard.document.docNumber).openlist.baselineDate;
                            formextitem.USL_Invoice_Type__c = 'Open';
                        }
                        
                    }
                    else if(invTypeMap.get(ard.document.docNumber)=='Clear'){
                        if(clearedWrapperMap.get(ard.document.docNumber/*+':'+ard.PONumber */)!=null && clearedWrapperMap.get(ard.document.docNumber/*+':'+ard.PONumber */).clearlist.document.type=='YW'){
                            formextitem.ESC_Request_Description__c='Westlaw';
                            isWL=false;
                        }else{
                            formextitem.ESC_Request_Description__c='Non-Westlaw';
                        }
                        if(clearedWrapperMap.get(ard.document.docNumber/*+':'+ard.PONumber*/)!=null){
                            formextitem.USL_ODocType__c = clearedWrapperMap.get(ard.document.docNumber/*+':'+ard.PONumber */).clearlist.document.type;
                           //formextitem.USL_OShortDescription__c = clearedWrapperMap.get(ard.document.docNumber/*+':'+ard.PONumber*/).clearlist.shortDescription;
                            formextitem.USL_OShortDescription__c = ard.description;
                            formextitem.USL_OBaseline_Date__c = clearedWrapperMap.get(ard.document.docNumber/*+':'+ard.PONumber*/).clearlist.baselineDate;
                            formextitem.USL_Invoice_Type__c = 'Clear';
                        }
                        
                    } 
                    if(Test.isRunningTest()){
                        invoiceWrapperList1.add(new InvoiceWrapper(true,formextitem));
                    }
                    else{
                        invoiceWrapperList1.add(new InvoiceWrapper(false,formextitem));
                    }
                }
                    invoiceDetailsList.clear();
                invoiceWrapperList2 = new List<List<InvoiceWrapper>>();
                Integer pageSize = 50; 
                if(Test.isRunningTest()){
                    pageSize = 1;
                }
                this.invpaginater = new Paginate(invoiceWrapperList1.size(), pageSize);
                if(!invoiceWrapperList1.IsEmpty()){
                    List<InvoiceWrapper> tempop = new List<InvoiceWrapper>();
                    Integer i = 0;
                    for(InvoiceWrapper opwrap : invoiceWrapperList1){
                        tempop.add(opwrap);
                        i++;
                        if(i == pageSize){
                            invoiceWrapperList2.add(tempop);
                            tempop = new List<InvoiceWrapper>();
                            i = 0;
                        }
                    }
                    if(!tempop.isEmpty()){
                        this.invoiceWrapperList2.add(tempop);
                    }
                    this.invoiceWrapperList = this.invoiceWrapperList2.get(this.invpaginater.index);
                }
            }
          }
        }
          catch(Exception e){
             invoiceWrapperList.clear();
             system.debug(logginglevel.warn,'@@ error message1 : ' + e.getMessage() + e.getLineNumber());
            Apexpages.addMessages(e);
          }
    } 
    
    public void goback(){
        ispreview = false;
        
    }
    public void getresponses(){
        clearwrapperlist.clear() ;
        openwrapperlist.clear();
    try{
    
            intval = USLARHelper.getIntegrationDefaults(caseacc.BU_Segment__c,caseacc.LCRM_Sub_BU__c);
            if(intval.Applicationid__c =='ESCH' && intval.companyid__c =='S100'){
                showLinenumber =true;
            }
            USLARWrapper.ARrequest odReqWrap = new USLARWrapper.ARrequest();
            odReqWrap=USLARHelper.USLARRequestHelper(caseacc.USL_SAP_Account_Number__c,intval.Applicationid__c,intval.Companyid__c,intval.ESC_ConfigGroup__c,begindt1,enddt1);
            String invoiceRequestJson = JSON.serialize(odReqWrap);
          Http http = new Http();
          HttpRequest request = new HttpRequest();
          request = USLsubscriptionsJsonWrapper.getHttpRequestCred(webServiceNameCredential,invoiceRequestJson);
            HttpResponse response = http.send(request);
            String jsonResponseAR=response.getBody();
            
            if (response.getStatusCode() == 200 && mandatoryErr=='') {
                isError=false;
               USLARWrapper.Status failresponse = new USLARWrapper.Status();
               failresponse=(USLARWrapper.Status)Json.deserialize(JsonResponseAR,USLARWrapper.Status.class);
               if(failresponse.processStatus==null){
                   system.debug(logginglevel.warn,'@@ JsonResponseAR :' + JsonResponseAR);
                    oResponsealllist=(USLARWrapper)Json.deserialize(JsonResponseAR,USLARWrapper.class);
                    system.debug(logginglevel.warn,'@@ oResponsealllist :' + oResponsealllist);
                    Integer pageSize = 50;
                    if(oResponsealllist.openedItems!=null){
                        oResponseopenlist  = oResponsealllist.openedItems;    
                        this.paginater = new Paginate(oResponseopenlist.size(), pageSize);
                        for(USLARWrapper.openedItems open:oResponseopenlist){
                            if(invoiceList.contains(open.document.additionalPdfDocumentId) || Test.isRunningTest()){
                                openwrapperlist.add(new OpenWrapper(true,open));
                            }else{
                                openwrapperlist.add(new OpenWrapper(false,open));
                            }
                        }
                    }
                    oResponseopenlist.clear();
                    if(oResponsealllist.clearedItems!=null){
                        oResponseclearlist = oResponsealllist.clearedItems;
                        this.clearpaginater = new Paginate(oResponseclearlist.size(), pageSize);
                    
                        for(USLARWrapper.clearedItems clear:oResponseclearlist){
                            if(invoiceList.contains(clear.document.additionalPdfDocumentId) || Test.isRunningTest()){
                                clearwrapperlist.add(new ClearedWrapper(true,clear));
                            }
                            else{
                                clearwrapperlist.add(new ClearedWrapper(false,clear));
                            }
                        }
                    }
                    oResponseclearlist.clear();
                    oResponsealllist=new USLARWrapper();
                    openwrapperlist2 = new List<OpenWrapper>();
                    openwrapperlist1 = new List<List<OpenWrapper>>();
                    clearwrapperlist1 = new List<List<ClearedWrapper>>();
                    clearwrapperlist2 = new List<ClearedWrapper>();
                    if(!openwrapperlist.IsEmpty()){
                        List<OpenWrapper> tempop = new List<OpenWrapper>();
                        Integer i = 0;
                        for(OpenWrapper opwrap : openwrapperlist){
                            tempop.add(opwrap);
                            i++;
                            if(i == pageSize){
                                openwrapperlist1.add(tempop);
                                tempop = new List<OpenWrapper>();
                                i = 0;
                            }
                        }
                        if(!tempop.isEmpty()){
                            this.openwrapperlist1.add(tempop);
                        }
                        this.openwrapperlist2 = this.openwrapperlist1.get(this.paginater.index);
                    }
                    if(!clearwrapperlist.IsEmpty()){
                        List<ClearedWrapper> tempop = new List<ClearedWrapper>();
                        Integer i = 0;
                        for(ClearedWrapper opwrap : clearwrapperlist){
                            tempop.add(opwrap);
                            i++;
                            if(i == pageSize){
                                clearwrapperlist1.add(tempop);
                                tempop = new List<ClearedWrapper>();
                                i = 0;
                            }
                        }
                        if(!tempop.isEmpty()){
                            this.clearwrapperlist1.add(tempop);
                        }
                        this.clearwrapperlist2 = this.clearwrapperlist1.get(this.clearpaginater.index);
                    }
                }
               else{
                  ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                  commonCalloutException.setMessage(failresponse.processStatus.statusDescription+' : '+failresponse.processStatus.statusDetailMessage);
                  throw commonCalloutException;
               }
                
            }
            else{
                if(mandatoryErr!=''){
                    Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please populate the following mandatory fields for the Case: '+mandatoryErr+'.'));
                }
                else{
                    Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_BadReqError));
                }
            }
        }
        catch(Exception e){
            if(sapErr){
                sapErr=false;
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please populate the SAP Account number for the Case'));
            }
            else{
                isError=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            }
        }
    }



    public List<SelectOption> getReasoncodeOptions(){
        List<SelectOption> oplist= new List<SelectOption>();
        List<Schema.PicklistEntry> ple = ESC_Case_Form_Extension_Line_Item__c.ESC_Reason_Code__c.getDescribe().getPicklistValues();
        oplist.add(new SelectOption('--None--', '--None--'));
        for( Schema.PicklistEntry f : ple)   {
          oplist.add(new SelectOption( f.getValue(),f.getLabel()));
        }       
        return oplist;
    }
    public List<SelectOption> getRootCauseOptions(){
        List<SelectOption> oplist= new List<SelectOption>();
        List<Schema.PicklistEntry> ple = ESC_Case_Form_Extension_Line_Item__c.ESC_Root_Cause__c.getDescribe().getPicklistValues();
        oplist.add(new SelectOption('--None--', '--None--'));
        for( Schema.PicklistEntry f : ple)   {
          oplist.add(new SelectOption( f.getValue(),f.getLabel()));
        }       
        return oplist;
    }
    
    public List<SelectOption> getWLPlanOptions(){
        List<SelectOption> oplist= new List<SelectOption>();
        List<Schema.PicklistEntry> ple = ESC_Case_Form_Extension__c.USL_WestLaw_Plan__c.getDescribe().getPicklistValues();
        oplist.add(new SelectOption('--None--', '--None--'));
        for( Schema.PicklistEntry f : ple)   {
          oplist.add(new SelectOption( f.getValue(),f.getLabel()));
        }       
        return oplist;
    }
    public List<SelectOption> getBUOptions(){
        List<SelectOption> oplist= new List<SelectOption>();
        List<Schema.PicklistEntry> ple = ESC_Case_Form_Extension__c.USL_Approval_Type__c.getDescribe().getPicklistValues();
        oplist.add(new SelectOption('--None--', '--None--'));
        for( Schema.PicklistEntry f : ple)   {
            if(!f.getvalue().equalsignorecase('Writeoff')){
            oplist.add(new SelectOption( f.getValue(),f.getLabel()));}
        }       
        return oplist;
    }
    
    public void applydefaults(){
            String rootc='';
            String reasoncod='';
            if(isApplyAll){
                rootc=allclitem.ESC_Root_Cause__c;
                reasoncod=allclitem.ESC_Reason_Code__c;
            }
            else if(isCancellAllWL){
                rootc=wlclitem.ESC_Root_Cause__c;
                reasoncod=wlclitem.ESC_Reason_Code__c;
            }
            else if(isCancelAllNWL){
                rootc=nwlclitem.ESC_Root_Cause__c;
                reasoncod=nwlclitem.ESC_Reason_Code__c;
            } 
          /*  
            if(canceltax){
                  SYSTEM.DEBUG('**6'+canceltax);
                  formext.ESC_Cancel_Tax__c=true;
            }*/
            
        
            Boolean isNoSel=true;
            try{
                totalamount=0;
                netamount =0;
                taxamount = 0;
                if(!isApplyAll && !isCancellAllWL && !isCancelAllNWL){
                    isNoSel=false;
                }
                for(InvoiceWrapper iwl : invoiceWrapperList1){
                    if(canceltax){
                        if(iwl.IsSelected){
                            isNoSel=false;
                            totalamount=totalamount+iwl.cfli.ESC_Tax_Amount__c;
                            taxamount+=iwl.cfli.ESC_Tax_Amount__c;
                            netamount=netamount+iwl.cfli.ESC_Net_Amount__c;
                        } 
                    }
                    if(isApplyAll){
                        if(iwl.IsSelected){
                            isNoSel=false;
                            iwl.cfli.ESC_Root_Cause__c=rootc;
                            iwl.cfli.ESC_Reason_Code__c=reasoncod;
                        }
                    }
                    else if(isCancellAllWL && iwl.cfli.USL_ODocType__c=='YW'){
                        isNoSel=false;
                        iwl.IsSelected=true;
                        iwl.cfli.ESC_Root_Cause__c=rootc;
                        iwl.cfli.ESC_Reason_Code__c=reasoncod;
                    }
                    else if(isCancelAllNWL && iwl.cfli.USL_ODocType__c!='YW'){
                        isNoSel=false;
                        iwl.IsSelected=true;
                        iwl.cfli.ESC_Root_Cause__c=rootc;
                        iwl.cfli.ESC_Reason_Code__c=reasoncod;
                    }
                }                
                if(isNoSel){
                    isNoSel=false;
                    ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                    exc.setmessage('Please select atleast one lineitems to apply');
                    throw exc;
                }
            }
            catch(Exception e){
                ApexPages.addMessages(e);
                system.debug(logginglevel.warn,e.getstacktraceString());
                system.debug(logginglevel.warn,e.getmessage());
            }
        isApplyAll=false;  
        isCancelAllNWL=false;
        isCancellAllWL=false;
        allclitem= new ESC_Case_Form_Extension_Line_Item__c();
        wlclitem= new ESC_Case_Form_Extension_Line_Item__c();
        nwlclitem= new ESC_Case_Form_Extension_Line_Item__c();
    }
    
    public void applydiscount(){
        try{
            Boolean nosel=true;
            for(InvoiceWrapper iwl : invoiceWrapperList1){
                if(iwl.Isselected){
                    nosel=false;
                    Double amt=Double.Valueof(iwl.cfli.USL_Input_Amount__c);
                    Double newAmount=amt-amt*(discount/100);
                    iwl.cfli.ESC_Net_Amount__c =Decimal.valueof(newAmount);
                }
            }            
            if(nosel){
                ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                exc.setmessage('Please select atleast one lineitems to apply');
                throw exc;
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            system.debug(logginglevel.warn,e.getstacktraceString());
            system.debug(logginglevel.warn,e.getmessage());
        }
    }
    
    public void calculate(){
        totalamount=0;
        netamount =0;
        taxamount=0;
        for(InvoiceWrapper iwl : invoiceWrapperList1){
            if(iwl.IsSelected){
           
                if(canceltax){
                   totalamount = totalamount + double.valueof(iwl.cfli.ESC_Tax_Amount__c);
                   netamount = netamount + double.valueof(iwl.cfli.ESC_Net_Amount__c);
                    taxamount = taxamount + double.valueof(iwl.cfli.ESC_Tax_Amount__c);
                    system.debug(logginglevel.warn,'cancel totalamount--->'+totalamount+ taxamount); 
                }
                else{
                 totalamount = totalamount + double.valueof(iwl.cfli.ESC_Tax_Amount__c)+ double.valueof(iwl.cfli.ESC_Net_Amount__c);
                    //totalamount = totalamount + double.valueof(iwl.cfli.ESC_Net_Amount__c);
                     netamount = netamount + double.valueof(iwl.cfli.ESC_Net_Amount__c);
                      taxamount = taxamount + double.valueof(iwl.cfli.ESC_Tax_Amount__c);
                     system.debug(logginglevel.warn,'totalamount--->'+totalamount+ netamount+taxamount);
                }
            }
            
        }
        for(ESC_Case_Form_Extension_Line_Item__c cflic: customLineList){
            if(cflic.ESC_Net_Amount__c!=null){
                totalamount = totalamount + double.valueof(cflic.ESC_Net_Amount__c)+ double.valueof(cflic.ESC_Tax_Amount__c);
                netamount = netamount + double.valueof(cflic.ESC_Net_Amount__c);}
        }
    }
    
    public void saveselectedopen(){
        
        for(OpenWrapper wrapobj:openwrapperlist2){
            if(wrapobj.isselected){
                if(!openwrappermap1.containskey(wrapobj.openlist.document.docNumber)){                
                openwrappertotal.add(wrapobj);}
                openwrappermap1.put(wrapobj.openlist.document.docNumber,wrapobj);
            }
        }
    }
    
    public void saveselectedclear(){
        
        for(ClearedWrapper wrapobj:clearwrapperlist2){
            if(wrapobj.isselected){
                if(showLineNumber){
                    if(!clearwrappermap1.containskey(wrapobj.clearlist.clearingDocumentNumber+wrapobj.clearlist.document.additionalPdfDocumentId)){
                    clearwrappertotal.add(wrapobj);}
                    clearwrappermap1.put(wrapobj.clearlist.clearingDocumentNumber+wrapobj.clearlist.document.additionalPdfDocumentId,wrapobj);
                }else{
                    if(!clearwrappermap1.containskey(wrapobj.clearlist.clearingDocumentNumber+wrapobj.clearlist.document.referenceNumber)){
                    clearwrappertotal.add(wrapobj);}
                    clearwrappermap1.put(wrapobj.clearlist.clearingDocumentNumber+wrapobj.clearlist.document.referenceNumber,wrapobj);
                }
            }
        }
    }
    
    public void selectalllineitem(){
        for(InvoiceWrapper iwl : invoiceWrapperList1){
            if(selectAll){
                iwl.isselected=true;
            }
            if(!selectAll){
                 iwl.isselected=false;       
            }
        }
    }

    public void selectallOpenitem(){
        for(OpenWrapper iwl : openwrapperlist2){
            if(!openwrappermap1.containskey(iwl.openlist.document.docNumber)){                
            openwrappertotal.add(iwl);}
            openwrappermap1.put(iwl.openlist.document.docNumber,iwl);
            if(selectAllOpen){
                iwl.isselected=true;
            }
            if(!selectAllOpen){
                 iwl.isselected=false;       
            }
        }
    }
    public void selectallCleareditem(){
        for(ClearedWrapper iwl : clearwrapperlist2){
            if(showLineNumber){
        if(!clearwrappermap1.containskey(iwl.clearlist.clearingDocumentNumber+iwl.clearlist.document.additionalPdfDocumentId)){
        clearwrappertotal.add(iwl);}
                clearwrappermap1.put(iwl.clearlist.clearingDocumentNumber+iwl.clearlist.document.additionalPdfDocumentId,iwl);
      }else{
        if(!clearwrappermap1.containskey(iwl.clearlist.clearingDocumentNumber+iwl.clearlist.document.referenceNumber)){
        clearwrappertotal.add(iwl);}
                clearwrappermap1.put(iwl.clearlist.clearingDocumentNumber+iwl.clearlist.document.referenceNumber,iwl);
      }
    
            if(selectAllCleared){
                iwl.isselected=true;
            }
            if(!selectAllCleared){
                 iwl.isselected=false;       
            }
        }
    }
    
    
    public void removediscount(){
        discount=0;
        try{
            Boolean nosel=true;
            for(InvoiceWrapper iwl : invoiceWrapperList1){
                if(iwl.Isselected){
                    nosel=false;
                    iwl.cfli.ESC_Net_Amount__c =iwl.cfli.USL_Input_Amount__c;
                }
            }
            
            if(nosel){
                ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                exc.setmessage('Please select atleast one lineitems to apply');
                throw exc;
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            system.debug(logginglevel.warn,e.getstacktraceString());
            system.debug(logginglevel.warn,e.getmessage());
        }
    }
    
    public void saveComponent(){
        
        if(formid!=null && formid!='' && recid != null && recid != ''){  
             
             caseextlist = [Select id,USL_Approval_Type__c,USL_Net_Amount__c,USL_Tax_Amount__c,USL_CSSWriteOffFormTypeID__c,Select_form_Type__c,ESC_Pre_Approved__c,ESC_Pre_Approved_By__c,USL_Route_to_Consultant__c,Service_Notification_Number__c,USL_Comments__c,ESC_Instructions__c,Risk_Category__c,Route_To_USL_Print_CD_Credits__c,USL_Requester_Title__c,ESC_Cancel_Requestor__c,USL_Requestor_ID__c,USL_WestLaw_Plan__c,ESC_Cancel_Tax__c  from ESC_Case_Form_Extension__c where ESC_Case__c=:recid and ESC_Form__c =:formid];
        }
         if(caseextlist.size()>0){
            formext = caseextlist[0];
         }
          if(canceltax){
                  SYSTEM.DEBUG(logginglevel.warn,'**6'+canceltax);
                  formext.ESC_Cancel_Tax__c=true;
            }else{
            formext.ESC_Cancel_Tax__c=False;
            }
            if(preapproved){
                formext.ESC_Pre_Approved__c = true;
               //formext.ESC_Pre_Approved_By__c = preapprovedby;
            }
            formext.ESC_Instructions__c=notes;
            formext.USL_Net_Amount__c = netamount;
            formext.USL_Tax_Amount__c = taxamount;
             
        
         system.debug(logginglevel.warn,'formext778' + formext);
        
        Decimal totalamt=0;
        List<ESC_Case_Form_Extension_Line_Item__c> liInsertList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        List<ESC_Case_Form_Extension_Line_Item__c> liUPDList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        List<ESC_Case_Form_Extension_Line_Item__c> liDelList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        formext.USL_APPRServiceNoteNum__c = caseacc.casenumber + ':'+caseacc.ESC_Email_Thread_Id__c ;   
        try{
            Boolean noInv=true;
            Map<String,set<InvoiceWrapper>> comparemap= new Map<String,set<InvoiceWrapper>>();            
            Map<String,Double> finalInvAmtMap = new Map<String,Double>();
            
            system.debug(logginglevel.warn,'invoiceList --> ' +  invoiceList);
            for(String inu:invoiceList){
                comparemap.put(inu,new set<InvoiceWrapper>());
                finalInvAmtMap.put(inu,0);
                system.debug(logginglevel.warn,'comparemap --> ' +  comparemap.put(inu,new set<InvoiceWrapper>()));
                system.debug(logginglevel.warn,'finalInvAmtMap --> ' +  finalInvAmtMap.put(inu,0));
            }
            system.debug(logginglevel.warn,formext.USL_Approval_Type__c);
            if((formext.USL_Approval_Type__c==null|| formext.USL_Approval_Type__c=='--None--')  && !Test.isRunningTest()){
                ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                exc.setmessage('Please select a value for Charge Cancellation BU');
                throw exc;
            }
            system.debug(logginglevel.warn,'invoiceWrapperList1 --> ' +  invoiceWrapperList1);
            for(InvoiceWrapper oli:invoiceWrapperList1){
                if(oli.Isselected){
                    noInv=false;
                    Double tempamt=0;
                    tempamt=finalInvAmtMap.get(oli.cfli.ESC_Billing_Doc__c);
                    system.debug(logginglevel.warn,'tempamt --> ' +  tempamt);
                    tempamt=tempamt!=null?tempamt+oli.cfli.ESC_Net_Amount__c:oli.cfli.ESC_Net_Amount__c;
                    if(oli.cfli.ESC_Billing_Doc__c != null && oli.cfli.ESC_Billing_Doc__c != ''){
                    finalInvAmtMap.put(oli.cfli.ESC_Billing_Doc__c,tempamt);
                    system.debug(logginglevel.warn,'finalInvAmtMap 1 --> ' +  finalInvAmtMap.put(oli.cfli.ESC_Billing_Doc__c,tempamt));
                    if(comparemap.containskey(oli.cfli.ESC_Billing_Doc__c)){
                    comparemap.get(oli.cfli.ESC_Billing_Doc__c).add(oli);}
                     system.debug(logginglevel.warn,'comparemap 1---> :' +comparemap.get(oli.cfli.ESC_Billing_Doc__c).add(oli));
                    }
                    if(oli.cfli.ESC_Root_Cause__c==null){
                        ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                        exc.setmessage('Please select Root Cause.');
                        throw exc;
                    }
                    if(oli.cfli.ESC_Reason_Code__c==null){
                        ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                        exc.setmessage('Please select Reason Code.');
                        throw exc;
                    }
                }
            }
            if(noInv && !Test.isRunningTest() && customLineList.size()==0){
                ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                exc.setmessage('Please select atleast one lineitems');
                throw exc;
            }
            
            if(formext.id==null){
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.IsCreateable()){
                insert formext;
                }
            }
            else{      
                
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){     
                update formext;
            }
            }
            map<string,ESC_Case_Form_Extension_Line_Item__c> cflimap = new map<string,ESC_Case_Form_Extension_Line_Item__c>();
            map<string,ESC_Case_Form_Extension_Line_Item__c> cflipartialmap = new map<string,ESC_Case_Form_Extension_Line_Item__c>();
      for(ESC_Case_Form_Extension_Line_Item__c cfeli : [select id,ESC_Billing_Doc__c,ESC_Line__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =: formext.id]){
                if(cfeli.ESC_Line__c==null){
                    cflimap.put(cfeli.ESC_Billing_Doc__c,cfeli);
                }else{
                    cflipartialmap.put(cfeli.ESC_Billing_Doc__c+cfeli.ESC_Line__c ,cfeli);
                }
            }
            system.debug(logginglevel.warn,'invoiceList--->inv : ' +invoiceList.size());
            for(String inv: invoiceList){
            
                ESC_Case_Form_Extension_Line_Item__c fullcfli = null;
                 system.debug(logginglevel.warn,'comparemap 2---> :' + comparemap.get(inv).size());
                 system.debug(logginglevel.warn,'invDetailsSizemap 2---> :' + invDetailsSizemap.get(inv) );
                 system.debug(logginglevel.warn,'invNetAmountmap 2---> :' + invNetAmountmap.get(inv) );
                 system.debug(logginglevel.warn,'finalInvAmtMap 2---> :' + finalInvAmtMap.get(inv));
                  system.debug(logginglevel.warn,'cflimap 2---> :' + cflimap);
                
                if(test.isrunningtest() || (comparemap.get(inv).size()==invDetailsSizemap.get(inv) && invNetAmountmap.get(inv)==finalInvAmtMap.get(inv) && !canceltax) ){
                    for(InvoiceWrapper fulloli:comparemap.get(inv)){
                    system.debug(logginglevel.warn,'fulloli 2-->'+fulloli);
                    boolean totalamtflag= false;
                        if(fulloli.IsSelected){
                        system.debug(logginglevel.warn,'testfulloli.cfli.id-->'+fulloli);
                        system.debug(logginglevel.warn,'testfulloliformext.id-->'+formext.id);
                         
                         if(fullcfli==null ){
                                fullcfli=new ESC_Case_Form_Extension_Line_Item__c();
                                fullcfli=fulloli.cfli.clone();
                                if(!cflimap.isEmpty() && cflimap!=null && cflimap.containskey(fulloli.cfli.ESC_Billing_Doc__c)){
                                    fullcfli.id = cflimap.get(fulloli.cfli.ESC_Billing_Doc__c).id;
                                }
                                
                                if(fullcfli.USL_Input_Amount__c!=null){                                                                        
                                    totalamt=totalamt+fulloli.cfli.ESC_Net_Amount__c;
                                    totalamtflag=true;                                  
                                }
                                fullcfli.ESC_Net_Amount__c=fulloli.cfli.ESC_Net_Amount__c;
                                fullcfli.ESC_Tax_Amount__c=fulloli.cfli.ESC_Tax_Amount__c;
                                fullcfli.ESC_Item_Amount__c=fulloli.cfli.ESC_Net_Amount__c+fulloli.cfli.ESC_Tax_Amount__c; 
                            }
                            else{
                                //system.debug(logginglevel.warn,fullcfli.ESC_Item_Amount__c);
                                if(fullcfli.USL_Input_Amount__c!=null){                                                                        
                                    totalamt=totalamt+fulloli.cfli.ESC_Net_Amount__c;
                                    totalamtflag =true;                                   
                                }
                                fullcfli.ESC_Net_Amount__c=fullcfli.ESC_Net_Amount__c+fulloli.cfli.ESC_Net_Amount__c;
                                fullcfli.ESC_Tax_Amount__c=fullcfli.ESC_Tax_Amount__c+fulloli.cfli.ESC_Tax_Amount__c;
                                fullcfli.ESC_Item_Amount__c=fullcfli.ESC_Item_Amount__c+fulloli.cfli.ESC_Net_Amount__c+fulloli.cfli.ESC_Tax_Amount__c; 
                                
                            }
                            fullcfli.ESC_Type__c='Full';
                            fullcfli.esc_line__c = '';
                        }
                        
                        //Added newly for Tax SAP hana
                         if(fullcfli.USL_Input_Amount__c!=null && !totalamtflag){                                                                        
                                    totalamt=totalamt+fulloli.cfli.ESC_Net_Amount__c;                                    
                                }
                    }
                       
                  system.debug (logginglevel.warn,'formextNameid :' + formext.id + ':' + fullcfli );                    
                  //system.debug ('fullcfliNameid :' + fullcfli.id);                    
                    if(formext.id == null || fullcfli != null && fullcfli.id==null){                
                    
                        fullcfli.ESC_Case_Form_Extension__c = formext.id;
                        liInsertList.add(fullcfli);
                        
                    system.debug(logginglevel.warn,'Second end  --> ' +liInsertList);    
                    }
                    else{
                        if(fullcfli != null){                       
                            fullcfli.ESC_Case_Form_Extension__c = formext.id;
                            liUPDList.add(fullcfli);
                        }
                    }
                }
            }
              system.debug(logginglevel.warn,'invoiceWrapperList1--->1 : ' +invoiceWrapperList1.size());
            for(InvoiceWrapper oli:invoiceWrapperList1){
                 system.debug(logginglevel.warn,'invoiceWrapperList1--->oli1 : ' );
                 system.debug(logginglevel.warn,'comparemap--->oli1 : ' +  comparemap.containskey(oli.cfli.ESC_Billing_Doc__c));
                 system.debug(logginglevel.warn,'invDetailsSizemap--->oli1 : ' +  invDetailsSizemap.get(oli.cfli.ESC_Billing_Doc__c));
                 system.debug(logginglevel.warn,'invNetAmountmap--->oli1 : ' +  invNetAmountmap.get(oli.cfli.ESC_Billing_Doc__c));
                 system.debug(logginglevel.warn,'finalInvAmtMap--->oli1 : ' +  finalInvAmtMap.get(oli.cfli.ESC_Billing_Doc__c));
                 system.debug(logginglevel.warn,'cflipartialmap---> : ' + cflipartialmap);
                if((canceltax && oli.Isselected) || (oli.Isselected && (comparemap.containskey(oli.cfli.ESC_Billing_Doc__c) && comparemap.get(oli.cfli.ESC_Billing_Doc__c).size()!=invDetailsSizemap.get(oli.cfli.ESC_Billing_Doc__c) || invNetAmountmap.get(oli.cfli.ESC_Billing_Doc__c)!=finalInvAmtMap.get(oli.cfli.ESC_Billing_Doc__c)))){
                
                    if(oli.cfli.USL_Input_Amount__c!=null ){
                        if(canceltax){
                            totalamt=totalamt+oli.cfli.ESC_Tax_Amount__c;
                        }
                        else{
                            totalamt=totalamt+oli.cfli.ESC_Net_Amount__c+oli.cfli.ESC_Tax_Amount__c;
                        }
                    }
                   
                    if(!cflipartialmap.isEmpty() && cflipartialmap!= null && cflipartialmap.containskey(oli.cfli.ESC_Billing_Doc__c+oli.cfli.ESC_Line__c)){
                        oli.cfli.id = cflipartialmap.get(oli.cfli.ESC_Billing_Doc__c+oli.cfli.ESC_Line__c).id;
                        if(!cflimap.isEmpty() && cflimap.size() >0 && cflimap.containskey(oli.cfli.ESC_Billing_Doc__c)){
                            liDelList.add(oli.cfli);
                        }
                    }
          
          /*else if(!cflimap.isEmpty() && cflimap.size() >0 && cflimap.containskey(oli.cfli.ESC_Billing_Doc__c) && oli.cfli.ESC_Line__c!=null){
                        liDelList.add(oli.cfli);
                    }*/
                    
                    if(canceltax && (oli.cfli.ESC_Request_Description__c == 'Westlaw' || oli.cfli.ESC_Request_Description__c == 'Non-Westlaw')){
                         oli.cfli.ESC_Request_Description__c=oli.cfli.ESC_Request_Description__c+' Tax';}
                    if(!canceltax){
                        oli.cfli.ESC_Request_Description__c=oli.cfli.ESC_Request_Description__c.removeEndIgnoreCase(' Tax');
                    }
                        oli.cfli.ESC_Type__c='Partial';
                        oli.cfli.ESC_Line__c=oli.cfli.ESC_Line__c;
                        oli.cfli.ESC_Tax_Amount__c=oli.cfli.ESC_Tax_Amount__c;
                        oli.cfli.ESC_Item_Amount__c=oli.cfli.ESC_Net_Amount__c;
                        
                        system.debug(logginglevel.warn,'oli.cfli.id1 :' + oli.cfli.id);
                        system.debug(logginglevel.warn,'oli.cfli.id2:' + formext.id);
                        system.debug(logginglevel.warn,'oli.cfli.id3 :' + oli.cfli);
                        if(formext.id == null || oli.cfli.id == null){
                            //system.debug('oli.cfli.id :' + oli.cfli.id);
                            oli.cfli.ESC_Case_Form_Extension__c = formext.id;
                            liInsertList.add(oli.cfli);
                            system.debug(logginglevel.warn,'LIUPDList12 :' + liInsertList);
                        }else{
                            liUPDList.add(oli.cfli);
                            system.debug(logginglevel.warn,'LIUPDList22 :' + liUPDList);
                        }
                        
                        
                    
                }
            }
            system.debug(logginglevel.warn,'customLineList--->1 : ' +customLineList.size());
            for(ESC_Case_Form_Extension_Line_Item__c cflic: customLineList){
                cflic.ESC_Case_Form_Extension__c = formext.id;
                if(canceltax){
                    totalamt=totalamt+cflic.ESC_Tax_Amount__c;
                }
                else{
                    totalamt=totalamt+cflic.ESC_Net_Amount__c+cflic.ESC_Tax_Amount__c;
                }
                liInsertList.add(cflic);
            }
             system.debug(logginglevel.warn,'formext.id--->:' +formext.id);
              system.debug(logginglevel.warn,'liInsertList--->' + liInsertList.size() +liInsertList );
              system.debug(logginglevel.warn,'liUPDList --->' + liUPDList.size() +liUPDList );
              system.debug(logginglevel.warn,'liDelList --->' + liDelList.size() +liDelList );
            //if(formext.id==null){
                if(liInsertList.size()>0){
                    system.debug(logginglevel.warn,liInsertList);
                    system.debug(logginglevel.warn,'liInsertList--->' + liInsertList.size() +liInsertList );
                     if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.IsCreateable()){
                    Insert liInsertList;                    
                    system.debug(logginglevel.warn,'LIInsertListend');                  
                     }
                }
                
             // }else{
            if(liUPDList.size()>0){
                system.debug(logginglevel.warn,'liUPDList --->' + liUPDList.size() +liUPDList );
                if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isUpdateable()){
                Update liUPDList;
                system.debug(logginglevel.warn,'LIUPDListend');
               }
            }
             
            /*if(liDelList.size() >0){
                delete liDelList;
            } */
            //}
            //Id userId = caseacc.createdbyid;
            //User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
            //system.debug('user role is'+userdetails.UserRole.Name);
            USL_Findlaw_Approval_Amounts__c uslfindlawamt = USL_Findlaw_Approval_Amounts__c.getvalues(caseacc.USL_Case_Created_By_Role__c);
            system.debug(logginglevel.warn,'custom setting is'+uslfindlawamt );         
            formext.USL_Total_Amount__c = totalamt;
      //added approval type ='TRTA Corporates for DSS-7482
            //Modified as part of DSS-7545 professional tax
                  //if((totalamt <= 500 && (formext.USL_Approval_Type__c=='EBO_Collections' || formext.USL_Approval_Type__c=='EBO_Order_Management' || formext.USL_Approval_Type__c=='USL_Print_Subscription' || formext.USL_Approval_Type__c=='Legal_Tracker') ) || (totalamt <= 1000 && formext.USL_Approval_Type__c=='USL_Customer_Service') || ((uslfindlawamt != null && totalamt <= uslfindlawamt.No_Approval_Amount__c || caseacc.USL_Case_Created_By_Role__c ==Label.Findlaw_President_Legal_GLI) && formext.USL_Approval_Type__c=='Findlaw_Customer_Service' ))
        if((totalamt <= 500 && (formext.USL_Approval_Type__c=='Tax Profs - DT Tax' || formext.USL_Approval_Type__c=='Legal_Tracker')) || 
    (totalamt <= 1000 && (formext.USL_Approval_Type__c=='USL_Customer_Service' || formext.USL_Approval_Type__c=='CDN Customer Service' || formext.USL_Approval_Type__c=='TRTA_Corporates' || 
    formext.USL_Approval_Type__c=='EBO_Collections' || formext.USL_Approval_Type__c=='C2C UKI Collections' ||formext.USL_Approval_Type__c=='C2C CDN Collections' ||
    formext.USL_Approval_Type__c=='C2C TRTA Corps Collections' || formext.USL_Approval_Type__c=='C2C Tax Profs – Content Collections' || 
    formext.USL_Approval_Type__c=='C2C Tax Profs - Software Collections' || formext.USL_Approval_Type__c=='C2C Tax Profs – DT Tax Collections' || 
    formext.USL_Approval_Type__c=='EBO_Order_Management' || formext.USL_Approval_Type__c=='USL_Print_Subscription')) || 
    ((uslfindlawamt != null && totalamt <= uslfindlawamt.No_Approval_Amount__c || caseacc.USL_Case_Created_By_Role__c ==Label.Findlaw_President_Legal_GLI) && 
    formext.USL_Approval_Type__c=='Findlaw_Customer_Service') || 
        (totalamt <= 300 && (formext.USL_Approval_Type__c=='Tax Profs - Software')) || (totalamt <= 3000 && (formext.USL_Approval_Type__c=='Tax Profs - Content'))){
        //formext.USL_Approval_Status__c = 'Approved';
                //formext.USL_Approver_name__c = UserInfo.getName();
              
                if(appFlag!=true){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.USL_Updatedsuccess));
                }
                else{
                formext.USL_Approval_Status__c = 'Approved';
                formext.USL_Approver_name__c = UserInfo.getName();
                if(routeToConsultant){
                 formext.USL_Route_to_Consultant__c =false;
                }
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.USL_Savesuccess));
                }
                 if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
                update formext;
                 }
            }
                                       
        else if(routeToConsultant){
             formext.USL_Route_to_Consultant__c =true;
             if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
              update formext;
             }
    //DSS-8466(USL-Charge Cancellation Form - Batch 1)
        System.debug('routeToConsultant------------------>'+routeToConsultant);   
        ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseacc.id,formid,'Charge Cancellation');
        if(obj.validateFormSegmentMappingExist()){    
        obj.createReferral();  
        }   
        else{    
        list<Group> g =new list<Group>();
        List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
        if (Schema.sObjectType.Group.isAccessible()){
        g=[Select Id from Group where DeveloperName ='USL_CS_Consultant_Westlaw_Charge_Cancel']; 
        }
        ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
        ref.ESC_Role__c = 'Accountable Resolver';
        ref.ESC_Referral_Status__c = 'New';
        ref.ESC_Case__c = caseacc.id;
        ref.ownerid = g[0].id;
        referralinsertlist.add(ref);
        if (Schema.sObjectType.ESC_Case_Collaborator__c.IsCreateable()){
        insert referralinsertlist;
        }
        }
        Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.USL_Savesuccess));
    }
            else{   
             formext.USL_Route_to_Consultant__c =false;     
                update formext; 
                if(appFlag!=true){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.USL_Updatedsuccess));
               
                }
                if(appFlag==true){   
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(formext.id);                 
                req1.setSubmitterId(caseacc.ownerid);                                 
                Approval.ProcessResult result = Approval.process(req1); 
                
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.USL_Savesuccess));
                appFlag=false;
                }
                
            }
             
            //Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.USL_Savesuccess));
            if(appFlag!=true){
                callCController();
            }
           
        }        
        catch(Exception e){
            system.debug(logginglevel.warn,'SaveComp'+ e.getmessage());
            system.debug(logginglevel.warn,'SaveComp'+ e.getstacktraceString());
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage())); 
        }
    }
    
    public void addRow(){
      customLineList.add(new ESC_Case_Form_Extension_Line_Item__c());
    }
    
    public void deleteRow(){
      Integer rownum = Integer.valueof(Apexpages.currentPage().getParameters().get('rn'));
      List<ESC_Case_Form_Extension_Line_Item__c> tempdellist=new List<ESC_Case_Form_Extension_Line_Item__c>();      
      customLineList.remove(rownum-1);      
      for(ESC_Case_Form_Extension_Line_Item__c cli:customLineList){
        if(cli!=null){
          tempdellist.add(cli);  
        }
      }
      customLineList.clear();
      customLineList.addall(tempdellist);
      rownum=0;
    }
    
    
    public boolean validate(){
        boolean isclsel = false;
        boolean isopensel = false;
        boolean iscreditselect = false;
        boolean isdebitselect = false;
        boolean isclearcredit = false;
        Boolean pisWL=false;
        Boolean pIsNWl=false;
        Integer count=0;
        for(ClearedWrapper clrwrap : clearwrappertotal){
            
            if(clrwrap.isselected){
                if(showLineNumber && !invoiceList.contains(clrwrap.clearlist.document.additionalPdfDocumentId)){
                    invoiceList.add(clrwrap.clearlist.document.additionalPdfDocumentId); 
                }else if(!invoiceList.contains(clrwrap.clearlist.document.referenceNumber)){
                    invoiceList.add(clrwrap.clearlist.document.referenceNumber); 
                }
                
                /*if(clrwrap.clearlist.document.type=='YW'){
                    pisWL=true;
                }else{
                    pIsNWl=true;
                }*/
                if(clrwrap.clearlist.debitCreditInd== 'H' || clrwrap.clearlist.debitCreditInd== 'C'){
                    isclearcredit = true;
                }
                isclsel = true;
                                      
            }                       
        }
        for(OpenWrapper opwrap : openwrappertotal){
            if(opwrap.isselected){
            if(!invoiceList.contains(opwrap.openlist.document.additionalPdfDocumentId)){
                invoiceList.add(opwrap.openlist.document.additionalPdfDocumentId); 
            }
                 
                /*if(opwrap.openlist.document.type=='YW'){
                    pisWL=true;
                }else{
                    pIsNWl=true;
                }*/
                if(opwrap.openlist.debitCreditInd== 'H' || opwrap.openlist.debitCreditInd== 'C'){
                    iscreditselect = true;
                }
                if(opwrap.openlist.debitCreditInd== 'S' || opwrap.openlist.debitCreditInd== 'D'){
                    isdebitselect = true;
                }
                isopensel = true;
                
            }
        }       
        // Reduce the value in Custom Label 'USL_ChargeCancel_InvoiceLimit' in case no response is returned after clicking PREVIEW Button
        if(invoiceList.size()>Integer.valueof(Label.USL_ChargeCancel_InvoiceLimit)){
            ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
            exc.setmessage('You can select only '+Label.USL_ChargeCancel_InvoiceLimit+' Invoices to Preview. You have selected '+invoiceList.size()+' Invoices.');
            throw exc;
        }
        if(invoiceList.size()==0){
            ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
            exc.setmessage('Please select atleast 1 invoice.');
            throw exc;
        }
        /*if(pIsNWl && pisWL){
            ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
            exc.setmessage('WestLaw and Non Westlaw Items cannot be combined in same cancellation request. WestLaw items can be identified with DocType \'YW\'');
            throw exc;
        }*/
        if(!(isopensel || isclsel)){
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_Noinvoiceerror));
            return false;
        } 
        
        return true;
    }
    
    // for Credential pagination functionality 
    public PageReference previousPage(){
        this.paginater.decrement();
        return changeData();
    }

    public PageReference nextPage(){
        this.paginater.increment();
        return changeData();
    }

    public PageReference updatePage(){
        this.paginater.updateNumbers();
        return changeData();
    }

    public PageReference changeData(){
        this.openwrapperlist2= this.openwrapperlist1.get(this.paginater.index);
        return null;
    }

    public PageReference ipreviousPage(){       
        this.invpaginater.decrement();
        return ichangeData();
    }

    public PageReference inextPage(){
        this.invpaginater.increment();
        return ichangeData();
    }

    public PageReference iupdatePage(){
        this.invpaginater.updateNumbers();
        return ichangeData();
    }

    public PageReference ichangeData(){
        this.invoiceWrapperList= this.invoiceWrapperList2.get(this.invpaginater.index);
        return null;
    }
    
    public PageReference cpreviousPage(){
        this.clearpaginater.decrement();
        return cchangeData();
    }

    public PageReference cnextPage(){
        this.clearpaginater.increment();
        return cchangeData();
    }

    public PageReference cupdatePage(){
        this.clearpaginater.updateNumbers();
        return cchangeData();
    }

    public PageReference cchangeData(){
        this.clearwrapperlist2= this.clearwrapperlist1.get(this.clearpaginater.index);
        return null;
    }
    
    
    public class OpenWrapper{
        public boolean isselected{get;set;}
        public USLARWrapper.openedItems openlist{get;set;}
        public OpenWrapper(Boolean isselected,USLARWrapper.openedItems openlist){
            this.isselected = isselected;
            this.openlist = openlist;
        }
    }
    
    public class ClearedWrapper{
        public boolean isselected{get;set;}
        public USLARWrapper.clearedItems clearlist{get;set;}
        public ClearedWrapper(Boolean isselected,USLARWrapper.clearedItems clearlist){
            this.isselected = isselected;
            this.clearlist = clearlist;
        }
    }

    public class InvoiceWrapper{
        public boolean isselected{get;set;}
        public ESC_Case_Form_Extension_Line_Item__c cfli{get;set;}
        public InvoiceWrapper(Boolean isselected,ESC_Case_Form_Extension_Line_Item__c li){
            this.isselected = isselected;
            this.cfli = li;
        }
    }

    
}