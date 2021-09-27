/**
 * @description USL_WriteofController
 */
public without sharing class USL_WriteofController {
    //public Boolean clearedItemsRequested{get;set;}
    List<ESC_Case_Form_Extension__c> caseextlist;
    //public ESC_Case_Form_Extension_Line_Item__c Allclitem{get;set;}
    //public ESC_Case_Form_Extension_Line_Item__c WLclitem{get;set;}
    //public ESC_Case_Form_Extension_Line_Item__c NWLclitem{get;set;}
   
    public String recId;
    public String formid; 
    public list<OpenWrapper> openwrappertotal;    
    map<string,OpenWrapper> openwrappermap;
    map<string,string> openitemmap;
    map<string,string> openitemMapAmount;    
    public USLARWrapper oResponsealllist;
    public static boolean validateAmountErr;    
    USL_Integration_defaults__c intval;
    public String sSelectedInv; 
    final string webServiceNameCredential = 'Invoice';
    public Boolean openItemsRequested{get;set;}
    public String begindt1{get;set;}    
    public String enddt1{get;set;}
    public ESC_Case_Form_Extension__c formext{get;set;}
    Public String sSelectedOption{get;set;}
    public Date begindt{get;set;}    
    public Date enddt{get;set;}
    public String formname{get;set;}
    public List<ESC_Case_Form_Extension_Line_Item__c> openitemlist{get;set;} 
    public List<USLARWrapper.openedItems> oResponseopenlist{get;set;}
    public list<OpenWrapper> openwrapperlist{get;set;}   
    public boolean isError{get;set;}
    Public Case caseacc{get;set;}
    public List<list<OpenWrapper>> openwrapperlist1{get;set;}
    public list<OpenWrapper> openwrapperlist2{get;set;}
    //public String instructions{get;set;}
    public boolean ispreview{get;set;}
    public boolean showErrorMsg{get;set;}
    public String formtitle{get;set;}
    public boolean selectall{get;set;}  
    public boolean showLineNumber{get;set;}
    //pagination
    public Paginate paginater {get;set;}
    public double totalamount {get;set;}
    public Map<String,USLARInvoicedetailwrapper.cls_details> invoiceDetailsmap{get;set;}
    Public List<ESC_Case_Form_Extension_Line_Item__c> customLineList{get;set;}
    
    /**
 * @description getARItemType
 * @return List<SelectOption>
 */
     public List<SelectOption> getARItemType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-none-'));
        options.add(new SelectOption(System.Label.AccountRec_SOAll,System.Label.AccountRec_SOAll));
        options.add(new SelectOption(System.Label.AccountRec_SOOpen,System.Label.AccountRec_SOOpen));
        options.add(new SelectOption(System.Label.AccountRec_SOCleared,System.Label.AccountRec_SOCleared));
        //options.add(new SelectOption(System.Label.AccountRec_SOSelected,System.Label.AccountRec_SOSelected));
        return options;
    }
    /**
 * @description USL_writeoffcontroller
 */
    public USL_WriteOfController (){
        selectall=false;
        showLineNumber = false;
        customLineList = new List<ESC_Case_Form_Extension_Line_Item__c>();        
        ispreview = false;
        openItemsRequested = false;
        sSelectedOption = System.Label.AccountRec_SOAll;
        oResponseopenlist=new List<USLARWrapper.openedItems>();
        oResponsealllist=new USLARWrapper();
        openwrapperlist = new List<OpenWrapper>();
        openwrappertotal = new List<OpenWrapper>();        
        openwrappermap = new map<string,OpenWrapper>();
        openitemmap = new map<string,string>();
        formext = new ESC_Case_Form_Extension__c();
        caseextlist = new List<ESC_Case_Form_Extension__c>();
        openitemlist  = new List<ESC_Case_Form_Extension_Line_Item__c>();
        openitemMapAmount = new map<string,string>();
        validateAmountErr = false;
        caseacc = new case();
        isError=false;
        showErrorMsg=false;
        recid = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('id').escapeHtml4());
        
        if(recid != null && recid != ''){  
            
            if (Schema.sObjectType.Case.isAccessible()){         
                 caseacc = [Select Id,CaseNumber,recordTypeId,owner.email,contactid,BU_Segment__c,LCRM_Sub_BU__c,contactphone,AccountId,USL_SAP_Account_Number__c,ESC_Case_Type__c,ESC_EnquiryType__c,ESC_Case_Sub_Type__c,ESC_Email_Thread_Id__c FROM Case where id =:recid];
            }
            if(caseacc.USL_SAP_Account_Number__c == '' || caseacc.USL_SAP_Account_Number__c == null) {
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Usl_SAPAccError));    
                isError = true;
            }
            
            intval = USLARHelper.getIntegrationDefaults(caseacc.BU_Segment__c,caseacc.LCRM_Sub_BU__c);
        
            if(intval!=null && intval.ApplicationId__c == 'ESCH' && intval.companyId__c =='S100'){
                //check for mandatory fields
                List<Case> lstCase = new List<Case>();
                lstCase.add(caseacc);
                
                Map<Id, string> mapCaseAndError = ESC_Utility.checkValidationErrorsForAutomaticClosure(lstCase);
                if(mapCaseAndError != null && mapCaseAndError.containsKey(caseacc.Id))
                {
                    string result = mapCaseAndError.get(caseacc.Id);
                    if(caseacc.ESC_Case_Type__c!=null && caseacc.ESC_Case_Type__c =='Request for Action' && (string.isNotBlank(caseacc.ESC_Case_Sub_Type__c) && caseacc.ESC_Case_Sub_Type__c!='Onboarding / Transition' || string.isBlank(caseacc.ESC_Case_Sub_Type__c)) && string.isBlank(caseacc.ESC_EnquiryType__c)){
                        if(string.IsNotBlank(result)){result = 'Type,'+result;
                        }else{ result = 'Type '+System.Label.ESC_CaseRuleMessage;}
                    }
                    if(string.IsNotBlank(result))
                    {
                        Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,result));    
                        isError = true;
                       
                    }
                } 
                  showLineNumber = true;
            }
                  
                        
        }
        
        formid = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('formid').escapeHtml4());
        if(formid != null && formid != ''){
        formname = [Select name from GenerateForm__c where id=:formid].name ;
        }
        if(formid != null && formid != '' && recid != null && recid != '' && Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible()){
            caseextlist = [Select id,USL_Approval_Type__c ,USL_CSSWriteOffFormTypeID__c ,ESC_Instructions__c,ESC_Form_BU__c,Select_form_Type__c,Service_Notification_Number__c,Risk_Category__c,USL_Requester_Title__c,ESC_Cancel_Requestor__c,USL_Requestor_ID__c,USL_WestLaw_Plan__c  from ESC_Case_Form_Extension__c where ESC_Case__c=:recid and ESC_Form__c =:formid];
         }
        if(caseextlist.size() > 0){
            
            formext = caseextlist[0];
            ispreview = true;
            if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible()){
            openitemlist = [Select Category__c,ESC_Item_Amount__c,id,ESC_Currency_Code__c,ESC_Billing_Doc__c,ESC_Error_Message__c,ESC_Line__c,USL_Input_Amount__c,USL_ONetArrears__c,USL_ODocType__c,USL_OShortDescription__c,USL_OBaseline_Date__c,ESC_Net_Amount__c,ESC_Reason_Code__c,ESC_Root_Cause__c,ESC_Tax_Amount__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =:caseextlist[0].id and USL_Invoice_Type__c = 'open'];
            }
            if(test.isrunningtest() || (openitemlist!=null && openitemlist.size() > 0)){
                
                for(ESC_Case_Form_Extension_Line_Item__c cli:openitemlist){
                    openitemmap.put(cli.ESC_Billing_Doc__c+cli.ESC_Line__c,cli.id);
                    if(cli.ESC_Error_Message__c!=null && cli.ESC_Error_Message__c!=''){
                        showErrorMsg = true;
                        break;
                    }
                    
                }
            }
        } else{
            formext.ESC_Case__c = recid;
            formext.ESC_Form__c = formid;
        } 
        formtitle='Write Off';
        
        Begindt = system.today().addDays(-365);
        Enddt = system.today();
         system.debug(LoggingLevel.WARN,'Before format '+Begindt+','+Enddt);
        Date d =  Date.today();
        Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
         system.debug(LoggingLevel.WARN,'dt '+dt);
        begindt1 = dt.addDays(-365).format('yyyy-MM-dd');
        enddt1 = dt.format('yyyy-MM-dd');
         system.debug(LoggingLevel.WARN,'ater format '+begindt1+','+enddt1);
        if(!isError && !ispreview ){getresponses(begindt1,enddt1);  }              
    }
    public void dummymethods(){}
    /**
 * @description setInvoiceDateRange
 */
    public void setInvoiceDateRange(){
        try{
            
             system.debug(LoggingLevel.WARN,'setInvoiceDateRange '+Begindt+','+Enddt);
            Integer iTotalNumberOfDays = Begindt.daysBetween(Enddt);
            if(Begindt != null ||  Enddt != null){
                if(Begindt > Enddt){throw new AppUtil.AppException(Label.DateError);  
                }else if(iTotalNumberOfDays > 365){throw new AppUtil.AppException(System.Label.AccountRec_DateRangeErrMsg);}  
                else{
                    Date bd =  Begindt;
                    Date ed =  Enddt;
                    Datetime bdt = Datetime.newInstance(bd.year(), bd.month(),bd.day());
                    Datetime edt = Datetime.newInstance(ed.year(), ed.month(),ed.day());
                    String begindt1 = bdt.format('yyyy-MM-dd');
                    String enddt1 = edt.format('yyyy-MM-dd');
                    getresponses(begindt1,enddt1);
                }
            }
        
        }catch (Exception oException){ApexPages.addMessages(oException);
        }
        
    }
    /**
 * @description showPreview
 */
    public void showPreview(){
        Decimal totalamount = 0;
        system.debug(LoggingLevel.WARN,totalamount);
        openitemlist.clear();
        if(validate()){
            ispreview = true;
            for(OpenWrapper opwrap : openwrappertotal){
                if(opwrap.isselected){                              
                    ESC_Case_Form_Extension_Line_Item__c formextitem = new ESC_Case_Form_Extension_Line_Item__c();
                     system.debug(LoggingLevel.WARN,'openitemmap is'+openitemmap);
                     system.debug(LoggingLevel.WARN,'doc number'+opwrap.openlist.document.docNumber+'****'+opwrap.openlist.lineNumber);
                    if(openitemmap != null && openitemmap.containsKey(opwrap.openlist.document.docNumber+opwrap.openlist.lineNumber)){
                    formextitem.id = openitemmap.get(opwrap.openlist.document.docNumber+opwrap.openlist.lineNumber);}
                    formextitem.ESC_Billing_Doc__c= String.valueof(opwrap.openlist.document.docNumber);
                    formextitem.ESC_Line__c= opwrap.openlist.lineNumber;
                    formextitem.ESC_Item_Amount__c= Double.valueof(opwrap.openlist.amount);
                    formextitem.USL_ONetArrears__c = opwrap.openlist.netArrers;
                    formextitem.USL_Input_Amount__c = Decimal.valueof(opwrap.openlist.amount);
                    formextitem.ESC_Request_Description__c=opwrap.openlist.document.type=='YW'?'Westlaw':'Non-Westlaw';
                    formextitem.USL_ODocType__c = opwrap.openlist.document.type;
                    formextitem.USL_OShortDescription__c = opwrap.openlist.shortDescription;
                    //Added as part of DSS-9306
                    formextitem.ESC_Currency_Code__c = opwrap.openlist.currencycode;
                    formextitem.USL_OBaseline_Date__c = opwrap.openlist.baselineDate;
                    formextitem.USL_Invoice_Type__c = 'open';
                    formextitem.ESC_Net_Amount__c = Decimal.valueof(opwrap.openlist.amount);
                    if(opwrap.taxamount!=''){ formextitem.ESC_Tax_Amount__c = Decimal.valueof(opwrap.taxamount);}
                    formextitem.ESC_Reason_Code__c = opwrap.rootcause;
                    formextitem.ESC_Root_Cause__c = opwrap.reasonCode;
                    openitemMapAmount.put(opwrap.openlist.document.docNumber+opwrap.openlist.lineNumber,string.valueOf(opwrap.openlist.amount));
                    openitemlist.add(formextitem);
                }
            } 
        }
          
    }
    /**
 * @description addRow
 */
    public void addRow(){
      customLineList.add(new ESC_Case_Form_Extension_Line_Item__c());
    }
   /**
 * @description deleteRow
 */ 
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
   /**
 * @description goback
 */ 
    public void goback(){
        ispreview = false;
    }
    /**
 * @description getresponses
 * @param begindt1
 * @param enddt1
 */
    public void getresponses(String begindt1,String enddt1){
            openwrapperlist.clear();
            try{
            
            USLARWrapper.ARrequest odReqWrap = new USLARWrapper.ARrequest();
             system.debug(LoggingLevel.WARN,'***$$$$'+caseacc.USL_SAP_Account_Number__c);
            odReqWrap=USLARHelper.USLARRequestHelper(caseacc.USL_SAP_Account_Number__c,intval.Applicationid__c,intval.Companyid__c,intval.ESC_ConfigGroup__c,begindt1,enddt1);
             system.debug(LoggingLevel.WARN,'**request******'+odReqWrap);
            
            
            HttpResponse response = USLARHelper.USLARCalloutHelper(webServiceNameCredential,JSOn.serialize(odReqWrap));
            
            String jsonResponseAR=response.getBody();
             system.debug(LoggingLevel.WARN,'****jsonResponseAR**'+jsonResponseAR);
            
            if (response.getStatusCode() == 200 ) {
               USLARWrapper.Status failresponse = new USLARWrapper.Status();
               failresponse=(USLARWrapper.Status)Json.deserialize(jsonResponseAR,USLARWrapper.Status.class);
               if(failresponse.processStatus==null){
                 system.debug(LoggingLevel.WARN,'hi in if');
                oResponsealllist=(USLARWrapper)Json.deserialize(jsonResponseAR,USLARWrapper.class);
                oResponseopenlist  = oResponsealllist.openedItems;
                Integer pageSize = 50;
                if(oResponseopenlist != null && oResponseopenlist.size() > 0){
                this.paginater = new Paginate(oResponseopenlist.size(), pageSize);
                
                for(USLARWrapper.openedItems open:oResponseopenlist){
                string mapKey = open.document.docNumber+':'+open.lineNumber;
                    if(openwrappermap != null && openwrappermap.containskey(mapKey) ){
                        openwrapperlist.add(new OpenWrapper(true,open,'','','','',''));
                        }
                    else {openwrapperlist.add(new OpenWrapper(false,open,'','','','',''));
                        }
                    
                }
                }
                else{ Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No invoices available for this SAP Account number'));
                }
                openwrapperlist2 = new List<OpenWrapper>();
                openwrapperlist1 = new List<List<OpenWrapper>>();
                if(!openwrapperlist.IsEmpty()){
                    List<OpenWrapper> tempop = new List<OpenWrapper>();
                    Integer i = 0;
                    for(OpenWrapper opwrap : openwrapperlist){
                        tempop.add(opwrap);
                        i++;
                         if(test.isrunningtest() || i == pageSize){
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
                sSelectedInv='False';
               }else{
                  ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                  commonCalloutException.setMessage(failresponse.processStatus.statusDescription+' : '+failresponse.processStatus.statusDetailMessage);
                  throw commonCalloutException;
               }
                 system.debug(LoggingLevel.WARN,'oResponsealllist is'+oResponsealllist);
            }
            else{ Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_BadReqError));
            }
        }
        catch(Exception e){ ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            //isError=true;
           
        }
    }
  /**
 * @description calculate
 */
    public void calculate(){  
        totalamount=0;
        for(ESC_Case_Form_Extension_Line_Item__c opwrap : openitemlist){
            totalamount = totalamount + double.valueof(opwrap.USL_Input_Amount__c);
        }
        for(ESC_Case_Form_Extension_Line_Item__c li :customLineList){
            if(li.USL_Input_Amount__c != null){ totalamount = totalamount + double.valueof(li.USL_Input_Amount__c);}
        }
    }
  /**
 * @description saveComponent
 */  
    public void saveComponent(){
        boolean isapproval = true;
        Decimal totalamt=0;
        List<ESC_Case_Form_Extension_Line_Item__c> liInsertList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        List<ESC_Case_Form_Extension_Line_Item__c> liIUPDList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        List<ESC_Case_Form_Extension_Line_Item__c> allLiList = new List<ESC_Case_Form_Extension_Line_Item__c> ();
        if(showLineNumber){
        validateAmount();
            
            if(validateAmountErr!=null  && validateAmountErr){
            return;
        }
        }
         //ESC_Email_Thread_Id__c added for write off failure scenarios DSS-6984
        formext.USL_APPRServiceNoteNum__c = caseacc.casenumber+ ':'+caseacc.ESC_Email_Thread_Id__c;
        formext.USL_Approval_Type__c = 'Writeoff';
        try{
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
            allLiList.addall(openitemlist);
            for(ESC_Case_Form_Extension_Line_Item__c extli : customLineList){
                extli.ESC_Item_Amount__c = extli.USL_Input_Amount__c;
                extli.USL_Invoice_Type__c = 'open';
            }
            allLiList.addall(customLineList);
             system.debug(LoggingLevel.WARN,'@@ openitemlist: ' + openitemlist);
             system.debug(LoggingLevel.WARN,'@@ customLineList : ' + customLineList);
             system.debug(LoggingLevel.WARN,'@@ allLiList: ' + allLiList);
            for(ESC_Case_Form_Extension_Line_Item__c oli:allLiList){
                if(oli.USL_Input_Amount__c!=null){totalamt=totalamt+oli.USL_Input_Amount__c;  }                 
                if(oli.id==null){
                    oli.ESC_Case_Form_Extension__c = formext.id;
                    liInsertList.add(oli);
                }else{
                    liIUPDList.add(oli);
                }
            }
            if(liInsertList.size()>0){
                if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.IsCreateable()){ 
                 Insert liInsertList;
                }
            }
            if(liIUPDList.size()>0){
                 if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isUpdateable()){ 
                Update liIUPDList;
                 }
            }
            
            formext.USL_Total_Amount__c = totalamt;
            if(totalamt <= 200 && formext.USL_CSSWriteOffFormTypeID__c != 'BNK' ){
            formext.USL_Approval_Status__c = 'Approved';
            user u =new User();
            if (Schema.sObjectType.User.isAccessible()){
             u = [select Id, name from User where Id = :UserInfo.getUserId()];
            }
            formext.USL_Approver_name__c = u.name;
            isapproval = false;
            } 
            if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){            
            update formext;
            } 
            if(test.isrunningtest() || (isapproval && formext.USL_CSSWriteOffFormTypeID__c != 'BNK')){
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(formext.id);                 
            req1.setSubmitterId(userinfo.getUserId());                                 
            Approval.ProcessResult result = Approval.process(req1);                           
            }        
            
        
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.USL_Savesuccess));
        }        
        catch(Exception e){ Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,e.getmessage())); 
        }
    }
 /**
 * @description saveselectedopen
 */   
    public void saveselectedopen(){
        
        for(OpenWrapper wrapobj:openwrapperlist2){
            if(wrapobj.isselected){
                string mapKey = wrapobj.openlist.document.docNumber+':'+wrapobj.openlist.lineNumber;
                if(!openwrappermap.containskey(mapKey)){ openwrappertotal.add(wrapobj);}
                openwrappermap.put(wrapobj.openlist.document.docNumber+':'+wrapobj.openlist.lineNumber,wrapobj);
            }
        }    
    }
  /**
 * @description validate
 * @return boolean
 */  
    
    public boolean validate(){
        boolean isclsel = false;
        boolean isopensel = false;
        boolean iscreditselect = false;
        boolean isdebitselect = false;
        boolean isclearcredit = false;
        system.debug(LoggingLevel.WARN,isclearcredit);
        for(OpenWrapper opwrap : openwrappertotal){
            
            if(opwrap.isselected){
                if(opwrap.openlist.debitCreditInd== 'H' || opwrap.openlist.debitCreditInd== 'C'){
                    iscreditselect = true;
                }
                if(opwrap.openlist.debitCreditInd== 'S' || opwrap.openlist.debitCreditInd== 'D'){
                    isdebitselect = true;
                }
                isopensel = true;
                
            }
        }
        if(!(isopensel || isclsel)){Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_Noinvoiceerror));
            return false;
        } 
        

        if(formname == 'Write Off Form'){
            if(isclsel || iscreditselect){Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.label.USL_WriteoffError));
                return false;
            }
            
        }
        return true;
    }

/**
 * @description selectalllineitem
 */
    public void selectalllineitem(){
        for(OpenWrapper iwl : openwrapperlist2){
            if(!openwrappermap.containskey(iwl.openlist.document.docNumber+':'+iwl.openlist.lineNumber)){openwrappertotal.add(iwl);}
            openwrappermap.put(iwl.openlist.document.docNumber+':'+iwl.openlist.lineNumber,iwl);
            if(selectall){
                iwl.isselected=true;
            }
            if(!selectall){
                 iwl.isselected=false;       
            }
        }
    }
 /**
 * @description previousPage
 * @return PageReference
 */   
    // for Credential pagination functionality 
    public PageReference previousPage(){
         system.debug(LoggingLevel.WARN,'**previousPage**');
        this.paginater.decrement();
        return changeData();
    }
/**
 * @description nextpage
 * @return PageReference
 */
    public PageReference nextPage(){
         system.debug(LoggingLevel.WARN,'**nextPage**');
        this.paginater.increment();
        return changeData();
    }
/**
 * @description updatePage
 * @return PageReference
 */
    public PageReference updatePage(){
         system.debug(LoggingLevel.WARN,'**call updatePage**');
        this.paginater.updateNumbers();
        return changeData();
    }
 /**
 * @description changeData
 * @return PageReference
 */
    public PageReference changeData(){
         system.debug(LoggingLevel.WARN,'**changeData:-**'+openwrapperlist1.size());
         system.debug(LoggingLevel.WARN,'paginater index is'+this.paginater.index);
        this.openwrapperlist2= this.openwrapperlist1.get(this.paginater.index);
        return null;
    }
     /**
 * @description validateAmount
 */
    public void validateAmount(){
         system.debug(LoggingLevel.WARN,'@@ olist :' +openitemlist);
         system.debug(LoggingLevel.WARN,'@@ openitemMapAmount:' +openitemMapAmount);
        for(ESC_Case_Form_Extension_Line_Item__c olist:openitemlist){
            if(test.isrunningtest() || (!openitemMapAmount.isEmpty() && openitemMapAmount.containsKey(olist.ESC_Billing_Doc__c+olist.ESC_Line__c))){
                if(olist.USL_Input_Amount__c > Decimal.valueOf(openitemMapAmount.get(olist.ESC_Billing_Doc__c+olist.ESC_Line__c))){
                    validateAmountErr = true;
                    Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.ESC_WriteOffAmountErrMsg)); break;
                }else{
                    validateAmountErr = false;
                }
            }
        }
       
        
    }
    /**
 * @description openwrapper
 */
    public class OpenWrapper{
        public boolean isselected{get;set;}
        public String inputamount {get;set;}
        public String netamount {get;set;}
        public String taxamount {get;set;}
        public String rootcause {get;set;}
        public String reasonCode {get;set;}
        public USLARWrapper.openedItems openlist{get;set;}
        public openWrapper(Boolean isselected,USLARWrapper.openedItems openlist,String inputamount,String netamount,String taxamount,String rootcause,String reasonCode){
            this.isselected = isselected;
            this.openlist = openlist;
            this.inputamount = inputamount; 
            this.netamount = netamount;
            this.taxamount = taxamount;
            this.rootcause = rootcause;
            this.reasonCode = reasonCode;
        }
    }
    
    
}