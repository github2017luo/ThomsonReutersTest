public without sharing class USL_InvoiceCompController  {
    public Boolean openItemsRequested{get;set;}
    public Boolean clearedItemsRequested{get;set;}
    List<ESC_Case_Form_Extension__c> caseextlist;
    public String Begindt1{get;set;}    
    public String Enddt1{get;set;}
    public ESC_Case_Form_Extension__c formext{get;set;}
    public String recId;
    public String formid;  
    Public String sSelectedOption{get;set;}
    public boolean isresidualamount {get;set;}
    public Date Begindt{get;set;}    
    public Date Enddt{get;set;}
    public String formname{get;set;}
    public List<ESC_Case_Form_Extension_Line_Item__c> openitemlist{get;set;}
    public List<ESC_Case_Form_Extension_Line_Item__c> clearitemlist{get;set;}        
    public USLARWrapper OResponsealllist;
    public List<USLARWrapper.openedItems> OResponseopenlist{get;set;}
    public List<USLARWrapper.clearedItems> OResponseclearlist{get;set;}
    public list<openwrapper> openwrapperlist{get;set;}
    public list<clearedwrapper> clearwrapperlist{get;set;}
    public List<openwrapper> oPreviewlist {get;set;}
    public list<clearedwrapper> cPreviewlist {get;set;}
    public boolean ispreview{get;set;}
    public String sSelectedInv;
    public boolean IsError{get;set;}
    public boolean isshowcheckField{get;set;}
    public boolean isOutput{get;set;}
    public boolean isshowcreditcard{get;set;}
    public boolean isshowcredit{get;set;}
    public boolean isshowcheck{get;set;}
    public boolean issaved {get;set;}
    Public Case Caseacc{get;set;}
    public List<list<openwrapper>> openwrapperlist1{get;set;}
    public list<openwrapper> openwrapperlist2{get;set;}
    public List<list<clearedwrapper>> clearwrapperlist1{get;set;}
    public list<clearedwrapper> clearwrapperlist2{get;set;}
    public list<openwrapper> openwrappertotal;
    public list<clearedwrapper> clearwrappertotal;
    final string WebServiceNameCredential = 'Invoice';
    //public String instructions{get;set;}
    //pagination
    public Paginate paginater {get;set;}
    public Paginate paginater1 {get;set;}
    Public List<ESC_Case_Form_Extension_Line_Item__c> customLineList{get;set;}
    Public List<String> TypeList{get;set;}
    Public List<String> IndicatorList{get;set;}
    public boolean selectall{get;set;}
    public boolean selectall1{get;set;}
    map<string,openWrapper> openwrappermap;
    map<string,clearedwrapper> clearwrappermap;
    public Source_System_Detail__c  oSSD{get;set;}
    public boolean showLineNumber{get;set;}
    public USL_Integration_defaults__c intval {get; set;}
    
    public List<SelectOption> getARItemType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-none-'));
        options.add(new SelectOption(System.Label.AccountRec_SOAll,System.Label.AccountRec_SOAll));
        options.add(new SelectOption(System.Label.AccountRec_SOOpen,System.Label.AccountRec_SOOpen));
        options.add(new SelectOption(System.Label.AccountRec_SOCleared,System.Label.AccountRec_SOCleared));
        //options.add(new SelectOption(System.Label.AccountRec_SOSelected,System.Label.AccountRec_SOSelected));
        return options;
    }
    
    public USL_InvoiceCompController (){
        showLineNumber = false;
        TypeList = new List<String>{'open','clear'};
        Indicatorlist= new List<String>{'C','D'};
            //Indicatorlist= new List<String>{'H','S'};
                //intval = USL_Integration_defaults__c.getValues('Integrationdefaults');
        customLineList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        isOutput = false;
        openItemsRequested = false;
        clearedItemsRequested = false;
        isresidualamount = false;
        isshowcreditcard = false;
        sSelectedOption = System.Label.AccountRec_SOAll;
        OResponseopenlist=new List<USLARWrapper.openedItems>();
        OResponseclearlist=new List<USLARWrapper.clearedItems>();
        OResponsealllist=new USLARWrapper();
        openwrapperlist = new List<openwrapper>();
        clearwrapperlist = new List<clearedwrapper>();
        openwrappertotal = new List<openwrapper>();
        clearwrappertotal = new List<clearedwrapper>();
        oPreviewlist = new List<openwrapper>();
        cPreviewlist = new List<clearedwrapper>();
        formext = new ESC_Case_Form_Extension__c();
        formext.USL_Payment_Decision__c = 'Leave Open';
        isshowcredit = false;
        isshowcheck = false;
        caseextlist = new List<ESC_Case_Form_Extension__c>();
        openitemlist  = new List<ESC_Case_Form_Extension_Line_Item__c>();
        clearitemlist  = new List<ESC_Case_Form_Extension_Line_Item__c>();
        openwrappermap = new map<string,openWrapper>();
        clearwrappermap = new map<string,clearedwrapper>();
        caseacc = new case();
        IsError=false;
        recid =String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('id').escapeHtml4());
        if(recid != null && recid != ''){
            if (Schema.sObjectType.Case.isAccessible()){
                Caseacc = [Select Id,CaseNumber,owner.email,contactid,AccountId,USL_SAP_Account_Number__c ,BU_Segment__c FROM Case where id =:recid];
            }
            
            if(caseacc.USL_SAP_Account_Number__c!=null){
                if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, 
                        Account_Name__r.Sales_Org__c,LCRM_Sub_BU__c, BU_Segment__c  FROM Source_System_Detail__c where Source_System_Account_Number__c= :caseacc.USL_SAP_Account_Number__c LIMIT 1];  
                }       
                  system.debug('**Select SObjecTypeoCaseSSD**'+oSSD);
            }else{
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Usl_SAPAccError));    
                IsError = true;
            }               
        }
        if(oSSD != null){
            intval= USLARHelper.getIntegrationDefaults(oSSD.BU_Segment__c,oSSD.LCRM_Sub_Bu__c);
            system.debug('**Integration Default******'+intval);
            if(intval!=null && intval.ApplicationId__c == 'ESCH' && intval.companyId__c =='S100'){
                showLineNumber = true;
            }
        }
        //formid = Apexpages.currentpage().getparameters().get('formid');  
        formid = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('formid').escapeHtml4());
        if(formid != null && formid != '')
            if (Schema.sObjectType.GenerateForm__c.isAccessible()){
                formname = [Select name from GenerateForm__c where id=:formid].name ;
            }
        if(formid != null && formid != '' && recid != null && recid != ''){
            if (Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible()){
                caseextlist = [Select id,USL_Is_credit_card_payment__c ,USL_Residual_Amount__c,USL_Payment_Decision__c,USL_Customer_Name__c,USL_Comments__c,USL_Attention_Name__c,USL_Refund_Method__c,ESC_Credit_Card_Type__c,ESC_Credit_Card_Number__c,USL_Use_Account_Address__c,USL_Payment_Street__c,
                               USL_Credit_Card_Expiration_Date__c,USL_Refund_Amount__c,USL_Purchase_Order_Number__c,USL_Payment_PO_Box__c,USL_Payment_City__c,USL_Payment_Region__c,USL_Residual_Credit_Bala_Instruct__c ,USL_Payment_Postal_Code__c,USL_GL_Number__c,esc_instructions__c,ESC_Transfer_To_Account__c,USL_How_was_this_Debt_Paid__c,USL_Payment_Date__c,Amount_of_Payment__c,USL_Check_Reference_Number__c,USL_Remittance_Address__c from ESC_Case_Form_Extension__c where ESC_Case__c=:recid and ESC_Form__c =:formid];
            }
            if(caseextlist.size() > 0 && caseextlist[0].USL_Residual_Amount__c > 0){
                isresidualamount = true;   
            }
            
        }    
        if(caseextlist.size() > 0){
            formext = caseextlist[0];
            isOutput = true;
            if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible()){
                openitemlist = [Select USL_Credit_or_Debit__c,USL_Assignment_Number__c,Invoice_Number__c,USL_ODocNumber__c,USL_OAmount__c,USL_Credit_Debit_Indicator__c ,USL_ONetArrears__c,USL_ODocType__c,USL_OShortDescription__c,USL_OBaseline_Date__c,ESC_Line__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =:caseextlist[0].id and USL_Invoice_Type__c = 'open'];
            }
            if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible()){
                clearitemlist = [Select USL_Credit_or_Debit__c,USL_Assignment_Number__c,USL_CRefNumber__c,USL_CAmount__c,USL_Credit_Debit_Indicator__c ,USL_CClearingDate__c,USL_CClearing_DocNumber__c,USL_CDocType__c, USL_CAllocationNumber__c, USL_CNetArrers__c,USL_CShortDescription__c,USL_CBilling_Date__c,USL_CInvoice_Number__c,ESC_Line__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =:caseextlist[0].id and USL_Invoice_Type__c = 'clear']; 
            }           
        }    
        Begindt = system.today().addDays(-365);
        Enddt = system.today();
        system.debug('Before format '+Begindt+','+Enddt);
        Date d =  Date.today();
        Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
        system.debug('dt '+dt);
        Begindt1 = dt.addDays(-365).format('yyyy-MM-dd');
        Enddt1 = dt.format('yyyy-MM-dd');
        system.debug('ater format '+Begindt1+','+Enddt1);
        if(!isError && !isOutput )
            getresponses(Begindt1,Enddt1);  
            showcreditcard();
            showcreditcard1();              
    }
    public void dummymethods(){}
    public void showcheck(){
        if(formext.USL_How_was_this_Debt_Paid__c == 'CREDIT CARD'){
            isshowcredit = true;
        }
        else{
            isshowcredit = false;
        }
    }
    public void showdecision(){
        if(formext.USL_Payment_Decision__c == 'Refund'){
            isshowcreditcard = true;
        }
        else{
            isshowcreditcard = false;
        }
    }
    public void showpaymenttype(){
        if(formext.USL_Refund_Method__c == 'Credit Card'){
            isshowcredit = true;
            isshowcheck = false;
        }
        else{
            isshowcredit = false;
            isshowcheck = true;
        }
    }
    public void showcreditcard(){
        if(formext.USL_Is_credit_card_payment__c == 'Yes'){
            isshowcredit = true;
            isshowcheck = false;
        }
        else if(formext.USL_Is_credit_card_payment__c == 'No'){
            isshowcredit = false;
            isshowcheck = true;
        }
        else{
            isshowcredit = false;
            isshowcheck = false;
        }
    }
    
    public void showcreditcard1(){
        
        if(formext.USL_Use_Account_Address__c == 'No'){
            isshowcheckField = true;
        }
        else{
            isshowcheckField = false;
        }
    }
    public void showPreview(){
        if(validate()){
            opreviewlist.clear();
            cpreviewlist.clear();
            ispreview = true;
            for(openWrapper opwrap : openwrappertotal){
                if(opwrap.isselected){
                    opreviewlist.add(opwrap);
                    openwrappermap.put(opwrap.openlist.document.docNumber+opwrap.openlist.lineNumber,opwrap);
                    
                }
            } 
            for(clearedwrapper clrwrap : clearwrappertotal){
                if(clrwrap.isselected){
                    cpreviewlist.add(clrwrap);
                    clearwrappermap.put(clrwrap.clearlist.clearingDocumentNumber+clrwrap.clearlist.allocationNumber+clrwrap.clearlist.lineNumber,clrwrap);
                }
            }
        }       
    }
    
    public void goback(){
        ispreview = false;
    }
    public void setInvoiceDateRange(){
        try{
            
            system.debug('setInvoiceDateRange '+Begindt+','+Enddt);
            Integer iTotalNumberOfDays = Begindt.daysBetween(Enddt);
            if(Begindt != null ||  Enddt != null){
                if(Begindt > Enddt){
                    throw new AppUtil.AppException(Label.DateError);  
                }else if(iTotalNumberOfDays > 365){
                    throw new AppUtil.AppException(System.Label.AccountRec_DateRangeErrMsg); 
                }  
                else{
                    Date bd =  Begindt;
                    Date ed =  Enddt;
                    Datetime bdt = Datetime.newInstance(bd.year(), bd.month(),bd.day());
                    Datetime edt = Datetime.newInstance(ed.year(), ed.month(),ed.day());
                    String Begindt1 = bdt.format('yyyy-MM-dd');
                    String Enddt1 = edt.format('yyyy-MM-dd');
                    getresponses(Begindt1,Enddt1);
                }
            }
        }catch (Exception oException){
            ApexPages.addMessages(oException);
        }
        
    }
    
    public void getresponses(String Begindt1,String Enddt1){
        IsError=false;
        clearwrapperlist.clear() ;
        openwrapperlist.clear();
        Integer pageSize = 50;
        try{
            
            USLARWrapper.ARrequest odReqWrap = new USLARWrapper.ARrequest();
            
            odReqWrap=USLARHelper.USLARRequestHelper(caseacc.USL_SAP_Account_Number__c,intval.Applicationid__c,intval.Companyid__c,intval.ESC_ConfigGroup__c,Begindt1,Enddt1);
            system.debug('**request******'+odReqWrap);
            
            HttpResponse Response = USLARHelper.USLARCalloutHelper(WebServiceNameCredential,JSOn.serialize(odReqWrap));
            
            String JsonResponseAR=Response.getBody();
            system.debug('****JsonResponseAR**'+JsonResponseAR);
            
            if (Response.getStatusCode() == 200 ) {
                USLARWrapper.Status failresponse = new USLARWrapper.Status();
                failresponse=(USLARWrapper.Status)Json.deserialize(JsonResponseAR,USLARWrapper.Status.class);
                if(failresponse.processStatus==null){
                    system.debug('hi in if');
                    OResponsealllist=(USLARWrapper)Json.deserialize(JsonResponseAR,USLARWrapper.class);
                    if(OResponsealllist.openedItems!=null){
                        OResponseopenlist  = OResponsealllist.openedItems;
                        
                        if(OResponseopenlist != null && OResponseopenlist.size() > 0){
                            this.paginater = new Paginate(OResponseopenlist.size(), pageSize);
                            
                            for(USLARWrapper.openedItems open:OResponseopenlist){
                                
                                if(openwrappermap != null && openwrappermap.containskey(open.document.docNumber+open.LineNumber))
                                    openwrapperlist.add(new openwrapper(true,open,null));
                                else
                                    openwrapperlist.add(new openwrapper(false,open,null));
                            }
                        }
                    }
                    if(OResponsealllist.clearedItems != null){
                        OResponseclearlist = OResponsealllist.clearedItems;
                        if(OResponseclearlist != null && OResponseclearlist.size() > 0){
                            this.paginater1 = new Paginate(OResponseclearlist.size(), pageSize);
                            for(USLARWrapper.clearedItems clear:OResponseclearlist){
                                if(clearwrappermap != null && clearwrappermap.containskey(clear.clearingDocumentNumber+clear.allocationNumber+clear.lineNumber))
                                    clearwrapperlist.add(new clearedwrapper(true,clear,null));
                                else    
                                    clearwrapperlist.add(new clearedwrapper(false,clear,null));                   
                            }
                        }
                    }
                    openwrapperlist2 = new List<openwrapper>();
                    openwrapperlist1 = new List<List<openwrapper>>();
                    clearwrapperlist1 = new List<List<clearedwrapper>>();
                    clearwrapperlist2 = new List<clearedwrapper>();
                    if(!openwrapperlist.IsEmpty()){
                        List<openwrapper> tempop = new List<openwrapper>();
                        Integer i = 0;
                        for(openwrapper opwrap : openwrapperlist){
                            tempop.add(opwrap);
                            i++;
                            if(i == pageSize){
                                openwrapperlist1.add(tempop);
                                tempop = new List<openwrapper>();
                                i = 0;
                            }
                        }
                        if(!tempop.isEmpty()){
                            this.openwrapperlist1.add(tempop);
                        }
                        this.openwrapperlist2 = this.openwrapperlist1.get(this.paginater.index);
                    }
                    if(!clearwrapperlist.IsEmpty()){
                        List<clearedwrapper> tempop = new List<clearedwrapper>();
                        Integer i = 0;
                        for(clearedwrapper opwrap : clearwrapperlist){
                            tempop.add(opwrap);
                            i++;
                            if(i == pageSize){
                                clearwrapperlist1.add(tempop);
                                tempop = new List<clearedwrapper>();
                                i = 0;
                            }
                        }
                        if(!tempop.isEmpty()){
                            this.clearwrapperlist1.add(tempop);
                        }
                        this.clearwrapperlist2 = this.clearwrapperlist1.get(this.paginater1.index);
                    }
                    sSelectedInv='False';
                }else{
                    ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                    commonCalloutException.setMessage(failresponse.processStatus.statusDescription+' : '+failresponse.processStatus.statusDetailMessage);
                    throw commonCalloutException;
                }
                system.debug('OResponsealllist is'+OResponsealllist);
            }
            else{
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_BadReqError));
            }
        }
        catch(Exception e){
            IsError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
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
    
    public void saveComponent(){
        
        List<ESC_Case_Form_Extension_Line_Item__c> formextitemList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        List<ESC_Case_Form_Extension__c> formExtList = new List<ESC_Case_Form_Extension__c>();
        List<ESC_Case_Form_Extension__c> formextupdlist = new List<ESC_Case_Form_Extension__c> ();
        try{
            if(validate()  ){
                ESC_Case_Form_Extension__c formext1 = new ESC_Case_Form_Extension__c();
                formext1.ESC_Case__c = recid;
                formext1.ESC_Form__c = formid;
                formext1.esc_instructions__c = formext.esc_instructions__c;
                formext1.ESC_Transfer_To_Account__c = formext.ESC_Transfer_To_Account__c;
                formext1.USL_How_was_this_Debt_Paid__c = formext.USL_How_was_this_Debt_Paid__c;
                formext1.USL_Payment_Date__c = formext.USL_Payment_Date__c;
                formext1.Amount_of_Payment__c = formext.Amount_of_Payment__c;
                formext1.USL_Check_Reference_Number__c = formext.USL_Check_Reference_Number__c;
                formext1.USL_Remittance_Address__c = formext.USL_Remittance_Address__c;
                formext1.USL_GL_Number__c = formext.USL_GL_Number__c;                
                formext1.USL_Residual_Amount__c = formext.USL_Residual_Amount__c;
                formext1.USL_Payment_Decision__c = formext.USL_Payment_Decision__c;        
                formext1.USL_Refund_Method__c = formext.USL_Refund_Method__c;        
                formext1.USL_Is_credit_card_payment__c = formext.USL_Is_credit_card_payment__c;
                formext1.USL_Refund_Amount__c = formext.USL_Refund_Amount__c;
                formext1.USL_Purchase_Order_Number__c = formext.USL_Purchase_Order_Number__c;
                formext1.USL_Residual_Credit_Bala_Instruct__c = formext.USL_Residual_Credit_Bala_Instruct__c;
                if(isshowcredit){
                    
                    formext1.ESC_Credit_Card_Type__c = formext.ESC_Credit_Card_Type__c ;
                    formext1.USL_Credit_Card_Expiration_Date__c = formext.USL_Credit_Card_Expiration_Date__c;
                    formext1.ESC_Credit_Card_Number__c = formext.ESC_Credit_Card_Number__c; 
                    
                }  
                if(isshowcheck) {    
                    formext1.USL_Use_Account_Address__c = formext.USL_Use_Account_Address__c;
                    formext1.USL_Payment_Street__c = formext.USL_Payment_Street__c;
                    formext1.USL_Payment_City__c = formext.USL_Payment_City__c;
                    formext1.USL_Payment_Region__c = formext.USL_Payment_Region__c;
                    formext1.USL_Payment_Postal_Code__c = formext.USL_Payment_Postal_Code__c;
                    formext1.USL_Payment_PO_Box__c = formext.USL_Payment_PO_Box__c;
                    formext1.USL_Customer_Name__c = formext.USL_Customer_Name__c;
                    formext1.USL_Comments__c = formext.USL_Comments__c;
                    formext1.USL_Attention_Name__c = formext.USL_Attention_Name__c;
                    
                }   
                for(ESC_Case_Form_Extension_Line_Item__c cflic: customLineList){ 
                    if(formext1.USL_Refund_Amount__c != null && cflic.USL_OAmount__c != null)
                        formext1.USL_Refund_Amount__c += decimal.valueof(cflic.USL_OAmount__c);
                }                     
                formExtList.add(formext1);
                if(!isoutput ){
                    if(Schema.sObjectType.ESC_Case_Form_Extension__c.isCreateable()){          
                        insert formExtList;
                    }
                }
                
                else{
                    formext1.id= caseextlist[0].id;
                    formextupdlist.add(formext1);
                    if(Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
                        update formextupdlist;
                    }
                }
                
                for(openWrapper opwrap : opreviewlist){
                    system.debug('usl credit debit is'+opwrap.extlineitem.USL_Credit_or_Debit__c);
                    ESC_Case_Form_Extension_Line_Item__c formextitem = new ESC_Case_Form_Extension_Line_Item__c();
                    formextitem.USL_ODocNumber__c = String.valueof(opwrap.openlist.document.docNumber);
                    formextitem.USL_OAmount__c = String.valueof(opwrap.openlist.amount);
                    formextitem.USL_ONetArrears__c = opwrap.openlist.netArrers;
                    formextitem.USL_ODocType__c = opwrap.openlist.document.type;
                    formextitem.USL_OShortDescription__c = opwrap.openlist.shortDescription;
                    formextitem.USL_OBaseline_Date__c = opwrap.openlist.baselineDate;
                    formextitem.ESC_Case_Form_Extension__c = formExtList[0].id;
                    if(opwrap.openlist.debitCreditInd == 'H'){
                    formextitem.USL_Credit_Debit_Indicator__c = 'C';
                    }
                    else{
                    formextitem.USL_Credit_Debit_Indicator__c = 'D';
                    }
                    formextitem.USL_Invoice_Type__c = 'open';
                    formextitem.Invoice_Number__c = opwrap.openlist.referencekey;
                    system.debug('credit debit is'+opwrap.extlineitem.USL_Credit_or_Debit__c);
                    formextitem.USL_Credit_or_Debit__c = opwrap.extlineitem.USL_Credit_or_Debit__c ;
                    formextitem.USL_Assignment_Number__c = opwrap.extlineitem.USL_Assignment_Number__c;
                    formextitem.ESC_Line__c = opwrap.openlist.lineNumber;
                    formextitemList.add(formextitem);
                    
                }
                for(clearedwrapper clrwrap : cPreviewlist){
                    
                    ESC_Case_Form_Extension_Line_Item__c formextitem1 = new ESC_Case_Form_Extension_Line_Item__c();
                    formextitem1.USL_CRefNumber__c = clrwrap.clearlist.document.referenceNumber;
                    formextitem1.USL_CAmount__c = String.valueof(clrwrap.clearlist.amount);
                    formextitem1.USL_CClearingDate__c = clrwrap.clearlist.clearingDate;
                    formextitem1.USL_CClearing_DocNumber__c = clrwrap.clearlist.clearingDocumentNumber;
                    formextitem1.USL_CDocType__c = clrwrap.clearlist.document.type;
                    formextitem1.USL_CAllocationNumber__c = clrwrap.clearlist.allocationNumber;
                    formextitem1.USL_CNetArrers__c = clrwrap.clearlist.netArrers;
                    formextitem1.USL_CShortDescription__c = clrwrap.clearlist.shortDescription;
                    formextitem1.USL_CBilling_Date__c = clrwrap.clearlist.baselineDate;
                    formextitem1.USL_CInvoice_Number__c = clrwrap.clearlist.document.additionalPdfDocumentId;
                    formextitem1.ESC_Case_Form_Extension__c = formExtList[0].id;
                    if(clrwrap.clearlist.debitCreditInd == 'H'){
                    formextitem1.USL_Credit_Debit_Indicator__c = 'C';
                    }
                    else{
                    formextitem1.USL_Credit_Debit_Indicator__c = 'D';
                    }
                    formextitem1.USL_Invoice_Type__c = 'clear';
                    formextitem1.USL_Credit_or_Debit__c = clrwrap.extlineitem.USL_Credit_or_Debit__c ;
                    formextitem1.USL_Assignment_Number__c = clrwrap.extlineitem.USL_Assignment_Number__c ;
                    formextitem1.ESC_Line__c = clrwrap.clearlist.lineNumber;
                    formextitemList.add(formextitem1);
                    
                }
                for(ESC_Case_Form_Extension_Line_Item__c cflic: customLineList){                
                    ESC_Case_Form_Extension_Line_Item__c formextitem1 = new ESC_Case_Form_Extension_Line_Item__c();
                    if(cflic.USL_Invoice_Type__c == 'open'){                    
                        formextitem1.ESC_Case_Form_Extension__c = formExtList[0].id; 
                        formextitem1.USL_ODocNumber__c = cflic.ESC_Billing_Doc__c;
                        formextitem1.USL_OAmount__c = cflic.USL_OAmount__c;
                        formextitem1.USL_ONetArrears__c = cflic.USL_ONetArrears__c;
                        formextitem1.USL_ODocType__c = cflic.USL_ODocType__c;
                        formextitem1.USL_OShortDescription__c = cflic.USL_OShortDescription__c;
                        formextitem1.USL_Credit_Debit_Indicator__c = cflic.USL_Credit_Debit_Indicator__c;
                        formextitem1.USL_Invoice_Type__c = 'open';
                        formextitem1.USL_OBaseline_Date__c = cflic.USL_OBaseline_Date__c ;
                        formextitem1.ESC_Line__c = cflic.ESC_Line__c ;
                        
                    }
                    else{
                        formextitem1.ESC_Case_Form_Extension__c = formExtList[0].id;
                        formextitem1.USL_CClearing_DocNumber__c = cflic.ESC_Billing_Doc__c;
                        formextitem1.USL_CAmount__c = cflic.USL_OAmount__c;
                        formextitem1.USL_CNetArrers__c = cflic.USL_ONetArrears__c;
                        formextitem1.USL_CDocType__c = cflic.USL_ODocType__c;
                        formextitem1.USL_CShortDescription__c = cflic.USL_OShortDescription__c;
                        formextitem1.USL_Credit_Debit_Indicator__c = cflic.USL_Credit_Debit_Indicator__c;
                        formextitem1.USL_Invoice_Type__c = 'clear';
                        formextitem1.USL_CBilling_Date__c = cflic.USL_OBaseline_Date__c ;
                        formextitem1.ESC_Line__c = cflic.ESC_Line__c ;
                    }
                    formextitemList.add(formextitem1);
                }
                if(Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isCreateable()){    
                    insert formextitemList;
                }
                issaved = true;
                if(formname == 'Cash Credits' || formname == 'Refund' || formname == 'Transfer Debits/Credits' || formname == 'Claims paid' || formname == 'Unapply Reapply Credits Debits Form'||formname == 'IFF Adjustment'){
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(recid,formId,formname);
                    if(obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
                    }
                    else if(formname == 'IFF Adjustment'){
                    createReferral('EBO_USL_Cash_Fed_Govt');
                }
                    else{
                        createReferral('USL_EBO_USL_CashApp');
                    }    
                //}
                
                }
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.USL_Savesuccess));
            }
        }
        catch(Exception e){
            issaved = false;
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
        }
    }
    
    public void createReferral(String refname){
        List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
        list<Group> g = new list<Group>();
        if (Schema.sObjectType.Group.isAccessible()){
            g=[Select Id from Group where DeveloperName=:refname]; 
        }
        ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
        ref.ESC_Role__c = 'Accountable Resolver';
        ref.ESC_Referral_Status__c = 'New';
        ref.ESC_Case__c = recid;
        ref.ownerid = g[0].id;
        referralinsertlist.add(ref);        
        if(Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable()){
            insert referralinsertlist;   
        }
    }
    
    public boolean validate(){
        boolean isclsel = false;
        boolean isopensel = false;
        boolean iscreditselect = false;
        boolean isdebitselect = false;
        boolean isclearcredit = false;
        decimal opencredit = 0;
        decimal opendebit = 0;
        for(clearedwrapper clrwrap : clearwrappertotal){
            
            if(clrwrap.isselected){
                if(clrwrap.clearlist.debitCreditInd== 'H' || clrwrap.clearlist.debitCreditInd== 'C'){
                    isclearcredit = true;
                    
                }
                isclsel = true;                                      
            }                       
        }
        system.debug('open wrapper is'+openwrappertotal);
        for(openWrapper opwrap : openwrappertotal){
            system.debug('amount is'+opwrap.openlist.amount);
            if(opwrap.isselected){
                if(opwrap.openlist.debitCreditInd== 'H' || opwrap.openlist.debitCreditInd== 'C'){
                    opencredit = opencredit + opwrap.openlist.amount;
                    //formext.USL_Refund_Amount__c = opencredit ; //moving the line outside the loop
                    iscreditselect = true;
                     
                }
                if(opwrap.openlist.debitCreditInd== 'S' || opwrap.openlist.debitCreditInd== 'D'){
                    isdebitselect = true;
                    opendebit = opendebit + opwrap.openlist.amount;
                }
                isopensel = true;                
            }
        }
        
        //Just for HANA
        if(opencredit < 0)
        {
            opencredit = opencredit * -1;
        }
        
        formext.USL_Refund_Amount__c = opencredit ;
        
        if(opencredit > opendebit){
            formext.USL_Residual_Amount__c = opencredit - opendebit;
            isresidualamount = true;
        }
        else{
            isresidualamount = false;
        }
        if(!(isopensel || isclsel)){
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_Noinvoiceerror));
            return false;
        } 
        if(formname == 'Cash Credits'){
            if(isclsel){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_Applycasherror));
                return false;
            }
            if(!(iscreditselect && isdebitselect) ){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_Applycreditsdebitserror));
                return false;
            }
            
        }  
        if(formname == 'Refund'){
            if(isclsel || isdebitselect ){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_RefundError));
                return false;
            }
        }                     
        if(formname == 'Transfer Debits/Credits'){
            if(isclsel){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_Transfererror));
                return false;
            }
        }
        if(formname == 'Unapply Reapply Credits Debits Form'){
            if(isopensel){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_UnapplyError));
                return false;
            }
        }
        if(formname == 'IFF Adjustment'){
            if(iscreditselect || isclearcredit ){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_IffError));
                return false;
            }
        }
        
        if(formname == 'Claims paid'){
            if(isclsel || iscreditselect){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.label.USL_ClaimsError));
                return false;
            }
            
        }
        return true;
    }
    
    public void saveselectedopen(){
        
        for(openWrapper wrapobj:openwrapperlist2){
            if(wrapobj.isselected){
                if(!openwrappermap.containskey(wrapobj.openlist.document.docNumber+wrapobj.openlist.lineNumber))                
                    openwrappertotal.add(wrapobj);
                openwrappermap.put(wrapobj.openlist.document.docNumber+wrapobj.openlist.lineNumber,wrapobj);
            }
        }
    }
    
    public void saveselectedclear(){
        
        for(clearedWrapper wrapobj:clearwrapperlist2){
            if(wrapobj.isselected){
                if(!clearwrappermap.containskey(wrapobj.clearlist.clearingDocumentNumber+wrapobj.clearlist.allocationNumber+wrapobj.clearlist.lineNumber))
                    clearwrappertotal.add(wrapobj);
                clearwrappermap.put(wrapobj.clearlist.clearingDocumentNumber+wrapobj.clearlist.allocationNumber+wrapobj.clearlist.lineNumber,wrapobj);
            }
        }
    }
    
    public void selectalllineitem(){
        system.debug('select all is'+selectall);
        for(openWrapper wrapobj:openwrapperlist2){
            if(!openwrappermap.containskey(wrapobj.openlist.document.docNumber+wrapobj.openlist.lineNumber))                
                openwrappertotal.add(wrapobj);
            openwrappermap.put(wrapobj.openlist.document.docNumber+wrapobj.openlist.lineNumber,wrapobj);
            if(selectall){
                wrapobj.isselected=true;
            }
            if(!selectall){
                wrapobj.isselected=false;       
            }
        }
    }
    
    public void selectalllineitem1(){
        for(clearedWrapper  wrapobj: clearwrapperlist2){
            if(!clearwrappermap.containskey(wrapobj.clearlist.clearingDocumentNumber+wrapobj.clearlist.allocationNumber+wrapobj.clearlist.lineNumber))
                clearwrappertotal.add(wrapobj);
            clearwrappermap.put(wrapobj.clearlist.clearingDocumentNumber+wrapobj.clearlist.allocationNumber+wrapobj.clearlist.lineNumber,wrapobj);
            if(selectall1){
                wrapobj.isselected=true;
            }
            if(!selectall1){
                wrapobj.isselected=false;       
            }
        }
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
        System.debug('**changeData:-**'+openwrapperlist1.size());
        system.debug('paginater index is'+this.paginater.index);
        this.openwrapperlist2= this.openwrapperlist1.get(this.paginater.index);
        return null;
    }
    
    public PageReference cpreviousPage(){
        System.debug('**previousPage**');
        this.paginater1.decrement();
        return cchangeData();
    }
    
    public PageReference cnextPage(){
        System.debug('**nextPage**');
        this.paginater1.increment();
        return cchangeData();
    }
    
    public PageReference cupdatePage(){
        System.debug('**call updatePage**');
        this.paginater1.updateNumbers();
        return cchangeData();
    }
    
    public PageReference cchangeData(){
        System.debug('**changeData:-**'+openwrapperlist1.size());
        system.debug('paginater index is'+this.paginater.index);
        this.clearwrapperlist2= this.clearwrapperlist1.get(this.paginater1.index);
        return null;
    }
    
    
    public class openWrapper{
        public boolean isselected{get;set;}
        public USLARWrapper.openedItems openlist{get;set;}
        public ESC_Case_Form_Extension_Line_Item__c extlineitem {get;set;}
        public openwrapper(Boolean isselected,USLARWrapper.openedItems openlist,ESC_Case_Form_Extension_Line_Item__c extlineitem){
            extlineitem = new ESC_Case_Form_Extension_Line_Item__c();
            this.isselected = isselected;
            this.openlist = openlist;
            this.extlineitem = extlineitem ;
        }
    }
    
    public class clearedWrapper{
        public boolean isselected{get;set;}
        public USLARWrapper.clearedItems clearlist{get;set;}
        public ESC_Case_Form_Extension_Line_Item__c extlineitem {get;set;}
        public clearedwrapper(Boolean isselected,USLARWrapper.clearedItems clearlist,ESC_Case_Form_Extension_Line_Item__c extlineitem){
            extlineitem = new ESC_Case_Form_Extension_Line_Item__c();
            this.isselected = isselected;
            this.clearlist = clearlist;
            this.extlineitem = extlineitem ;
        }
    }
    
}