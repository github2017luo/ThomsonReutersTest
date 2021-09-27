public without sharing class USLARController {
    
    public Account oAccount{get;set;}
    public Case caserec {get;set;}
    private ApexPages.StandardController controller;
    public string caseId {get; set;}  

    public Boolean openItemsRequested{get;set;}
    public Boolean clearedItemsRequested{get;set;}
    public Boolean additionalTextRequested{get;set;}
    public boolean ispreview{get;set;}
    public Source_System_Detail__c  oSSD{get;set;}
   //Public ESC_Case_Form_Extension_Line_Item__c oFormExt{get;set;}
    public String formId{get;set;}
    Public ESC_Case_Form_Extension__c oForm{get;set;}
    public String stringURL{get;set;}
    Public List<Case> caseList = new List<Case>();
    Public Case caseacc{get;set;}
    Public Boolean noInv{get;set;}
    Public String sSelectedOption{get;set;}
    public String sSelectedInv{get;set;}
    public Date begindt{get;set;}    
    public Date enddt{get;set;}
    public Double newAmount1{get;set;}
    public List<USLARWrapper.openedItems> oResponseopenlist{get;set;}
    public List<USLARWrapper.clearedItems> oResponseclearlist{get;set;}
    public List<USLARWrapper.openedItems> oResponseopenlist2{get;set;}
    public List<USLARWrapper.clearedItems> oResponseclearlist2{get;set;}
    public List<list<USLARWrapper.openedItems>> oResponseopenlist1{get;set;}
    public List<list<USLARWrapper.clearedItems>> oResponseclearlist1{get;set;}
    public USLARWrapper oResponsealllist{get;set;}
    public List<USLARWrapper.openedItems> oSelectedlist{get;set;}
    public boolean isError{get;set;}
    //public String ccurl{get;set;}
    public boolean isCAD ;
    public boolean selectall{get;set;}
    public boolean selectallclear{get;set;}
        public String sortDirection {get;set;}
    public List<USLARWrapper.openedItems> totalAmt{get;set;}
    Public List<ESC_Case_Form_Extension_Line_Item__c> inserLst = new List<ESC_Case_Form_Extension_Line_Item__c>();
    //USL_Integration_defaults__c val = USL_Integration_defaults__c.getValues('TaxUS_Integration');

    public Paginate arPaginater {get;set;}
    public Paginate arPaginater1 {get;set;}
   Public Integer pagesize{get;set;}
   Public List<ESC_Case_Form_Extension_Line_Item__c> customLineList{get;set;}
    Public List<String> typeList{get;set;}
    Public List<String> indicatorList{get;set;}
    //  public List<USLARWrapper.listCombinedOpenClearedItems> FinalResponseopenlist{get;set;}
    final string webServiceNameCredential = 'Invoice';
    public boolean isOutput{get;set;}
    public List<ESC_Case_Form_Extension_Line_Item__c> caseextLineItemList{get;set;}
    map<string,USLARWrapper.openedItems> openwrappermap;
    public list<USLARWrapper.openedItems> openwrappertotal;
  //Start->>>>LCRM Team Defined Parameters
    public LCRM_Integration_defaults_Values__c integrationDefault=new LCRM_Integration_defaults_Values__c();
    Final String lcrmWebserviceAR;
    public String strApplicationId{get;set;}
    public Map<String,IXOSCodeMap__c> oIXOSCodeMap;
    public String strSalesOrgCode{get;set;}
    public String strCompanyCode;
  public boolean lcrmMandatoryElementDisplying{get;set;}
    //End->> End LCRM Team Defined Parameters
  
    //added for DSS-607
    map<string,USLARWrapper.clearedItems> clearwrappermap;
    public list<USLARWrapper.clearedItems> clearwrappertotal;
    public List<USLARWrapper.clearedItems> cSelectedlist{get;set;}
    public map<string,USLARWrapper.openedItems> oSelectedmap{get;set;}
    public map<string,USLARWrapper.clearedItems> cSelectedmap{get;set;}
    public Integer sizeOfOpenMap { get { return oSelectedmap.size(); } } 
    public Integer sizeOfCloseMap { get { return cSelectedmap.size(); } } 
    public boolean showLineNumber{get;set;}
    
    //complete for DSS-607
    public USLARController(ApexPages.StandardController controller){
  //LCRM Team start
        integrationDefault=LCRM_Integration_defaults_Values__c.getvalues(Label.LCRMARInvoicelist);
        System.debug('IntegrationDefault**'+integrationDefault);
        if(String.isnotblank(integrationDefault.LCRM_WebserviceName__c)){
        lcrmWebserviceAR=integrationDefault.LCRM_WebserviceName__c;
        }
        lcrmMandatoryElementDisplying =false;
        strApplicationId=ApexPages.currentPage().getParameters().get(Label.LCRMApplicationId);
        System.debug('strApplicationId**'+strApplicationId);
        oIXOSCodeMap=new Map<String,IXOSCodeMap__c>();
        //END LCRM Team    
        
        showLineNumber = false;
        List<ESC_Case_Form_Extension__c> caseextlist = new List<ESC_Case_Form_Extension__c>();
        caseextLineItemList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        typeList = new List<String>{'open'};
        indicatorList= new List<String>{'C','D'};
        customLineList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        sSelectedOption = System.Label.AccountRec_SOAll;
        oResponseopenlist=new List<USLARWrapper.openedItems>();
        oSelectedlist = new List<USLARWrapper.openedItems>();
        oSelectedlist.clear();
        oResponseclearlist=new List<USLARWrapper.clearedItems>();
        openwrappermap = new map<string,USLARWrapper.openedItems>();
        openwrappertotal = new List<USLARWrapper.openedItems>();
        oResponsealllist=new USLARWrapper();
        //added for DSS-607
        clearwrappermap = new map<string,USLARWrapper.clearedItems>();
        clearwrappertotal = new List<USLARWrapper.clearedItems>();
        cSelectedlist = new List<USLARWrapper.clearedItems>();
        cSelectedlist.clear();
        oSelectedmap= new map<string,USLARWrapper.openedItems> ();
        cSelectedmap=new map<string,USLARWrapper.clearedItems> ();
        //complete for DSS-607
        openItemsRequested = false;
        clearedItemsRequested = false;
        additionalTextRequested =false;
        pagesize=50;
        caseId='';
        isError=false;
        isOutput = false;
        isCAD = false;
        //  FinalResponseopenlist=new List<USLARWrapper.listCombinedOpenClearedItems>();
        oSSD = new Source_System_Detail__c();
        SObjectType sObjectType = controller.getRecord().getSObjectType();
        system.debug('**Select SObjecType**'+sObjectType);
         system.debug('**Select oSelectedlist **'+oSelectedlist);
         system.debug('**Select oSelectedlist **'+cSelectedlist);
         
        try{
            if(sObjectType == Source_System_Detail__c.sObjectType)
            {
                // This is a SSD record
                system.debug('**Select SObjecType123**'+sObjectType);
                oSSD = (Source_System_Detail__c) controller.getRecord();
                if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                    oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, Account_Name__r.Sales_Org__c,LCRM_Sub_BU__c, BU_Segment__c  FROM Source_System_Detail__c where id = :oSSD.id  ];  
                }
                system.debug('**Select SObjecTypeoSSD**'+oSSD);
            }
            else if(sObjectType == Case.sObjectType)
            {
 // This is a Case record 
          sortDirection = 'asc';
                caseacc=(Case) controller.getRecord();  
                caseId= String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('caseId').escapeHtml4());
                //caseId='5002D000001XJpQ';
                formId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('formid').escapeHtml4());
                system.debug('**Select formId**'+formId);
                system.debug('**Select caseId**'+caseId);
                if (Schema.sObjectType.esc_case_form_extension__c.isAccessible()){
                    caseextlist = [select id from esc_case_form_extension__c where esc_case__c=:caseId and esc_form__c =:formid];
                }
                if(caseextlist.size() > 0){
                    if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible()){
                        caseextLineItemList =[select USL_ODocNumber__c,USL_ODocType__c,USL_Input_Amount__c,Billing_Line_Item_Number__c,ESC_Item_Amount__c,USL_OShortDescription__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =:caseextlist[0].id];
                    }
                    isOutput = true;
                }
                if (Schema.sObjectType.Case.isAccessible()){
                    caseacc = [Select Id,CaseNumber,Contact_Source_System__c,Case.Contact_Source_System__r.name,    
                    Case.Account.Id,Case.USL_SAP_Account_Number__c,Case.Account.SAPAccountNumber__c,Case.Contact.FirstName,
                    Case.Account.Sales_Org__c  FROM Case where id =:caseId]; 
                }
                   system.debug('**CaseaccList**'+caseacc);         
                if(test.isRunningTest()){
                System.debug('caseacc>>'+caseacc);}
               if(caseacc.USL_SAP_Account_Number__c!=null){
                if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, 
                        Account_Name__r.Sales_Org__c,LCRM_Sub_BU__c, BU_Segment__c  FROM Source_System_Detail__c where Source_System_Account_Number__c= :caseacc.USL_SAP_Account_Number__c LIMIT 1];  
                }       
                  system.debug('**Select SObjecTypeoCaseSSD**'+oSSD);
                }
                else{
                   Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Usl_SAPAccError));    
                   isError=true;
                }
            }
            
            if(oSSD.LCRM_Sales_org__c == null){
                throw new AppUtil.AppException(Label.SalesOrgError);  
            }
            
            begindt = system.today().addDays(-365);
            enddt = system.today();
            system.debug('Before format '+begindt+','+enddt);
            Date d =  Date.today();
            Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
            system.debug('dt '+dt);
            String begindt1 = dt.addDays(-365).format('yyyy-MM-dd');
            String enddt1 = dt.format('yyyy-MM-dd');
            system.debug('ater format '+begindt1+','+enddt1);
            //getresponses(Begindt1,Enddt1);
            if(String.isblank(strApplicationId)){
                sSelectedOption = System.Label.AccountRec_SOAll;
                if(oSSD != null){
                    for(IXOSCodeMap__c tempObj : IXOSCodeMap__c.getAll().Values()){
                         oIXOSCodeMap.put(tempObj.Company_Code__c,tempObj);
                    }
                    System.debug('Keyset**'+oIXOSCodeMap.keyset());
                    System.debug('Values**'+oIXOSCodeMap.values());
                    //This parameter is set for LCRMIxos functionality
                    if(String.isnotblank(oSSD.LCRM_Sales_org__c) ){
                        IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oSSD.LCRM_Sales_org__c);
                        system.debug('oIXOSCodeMap **'+oIXOSCodeMap );
                        strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
                        strCompanyCode = oIXOSCodeMap.Company_Code__c;                
                    }
                    }
                getresponses(Begindt1,Enddt1);
            }
            else{
            //LCRm Team changes    
                if(oSSD != null){
                    sSelectedOption = System.Label.AccountRec_SOOpen;
                    for(IXOSCodeMap__c tempObj : IXOSCodeMap__c.getAll().Values()){
                         oIXOSCodeMap.put(tempObj.Company_Code__c,tempObj);
                    }
                    System.debug('Keyset**'+oIXOSCodeMap.keyset());
                    System.debug('Values**'+oIXOSCodeMap.values());
                    //This parameter is set for LCRMIxos functionality
                    if(String.isnotblank(oSSD.LCRM_Sales_org__c) ){
                        IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oSSD.LCRM_Sales_org__c);
                        system.debug('oIXOSCodeMap **'+oIXOSCodeMap );
                        strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
                        strCompanyCode = oIXOSCodeMap.Company_Code__c;                
                    }
                    getresponses(Begindt1,Enddt1);
                }
                else{
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebservice_SSD));
                }
            }
            //End LCRM Team changes
        }catch(Exception e){
            isError=true;
        }
    }
    
    public void getresponses(String begindt1,String enddt1){
      System.debug('oSSD.Source_System_Account_Number__c'+oSSD.Source_System_Account_Number__c);
            System.debug('IntegrationDefault.LCRM_ApplicationId__c**'+integrationDefault.LCRM_ApplicationId__c);
            System.debug('oSSD.LCRM_Sales_org__c**'+oSSD.LCRM_Sales_org__c);
            System.debug('Begindt1*'+Begindt1);
            System.debug('Enddt1*'+Enddt1);
            System.debug('lcrmWebserviceAR*'+lcrmWebserviceAR);
            System.debug('strApplicationId:**'+strApplicationId);
            system.debug('System.Label.AccountRec_SOOpen**'+System.Label.AccountRec_SOOpen+'System.Label.AccountRec_SOAll**'+System.Label.AccountRec_SOAll);
            System.debug('System.Label.AccountRec_SOOpenNotDue***'+System.Label.AccountRec_SOOpenNotDue);
            System.debug('System.Label.AccountRec_SOOpenDue**'+System.Label.AccountRec_SOOpenDue);
      
            try{
      lcrmMandatoryElementDisplying=false;
      USLARWrapper.ARrequest odReqWrap = new USLARWrapper.ARrequest();
            
            String jsonresponseAR='';
            Httpresponse response = new Httpresponse();
            if(String.isblank(strApplicationId) ){
            //Logic for Enterprise solution Team
            System.debug('USL Functionality**');
            
            USL_Integration_defaults__c val = USLARHelper.getIntegrationDefaults(oSSD.BU_Segment__c, oSSD.LCRM_Sub_BU__c);
            system.debug('**Integration Default******'+val);
            if(val!=null && val.ApplicationId__c == 'ESCH' && val.companyId__c =='S100'){
                showLineNumber = true;
            }
            odReqWrap=USLARHelper.USLARRequestHelper(oSSD.Source_System_Account_Number__c,val.Applicationid__c,val.Companyid__c,val.ESC_ConfigGroup__c,Begindt1,Enddt1);
            system.debug('**request******'+odReqWrap);
            response = USLARHelper.USLARCalloutHelper(WebServiceNameCredential,JSOn.serialize(odReqWrap));
            
            }else if(String.Isnotblank(oSSD.Source_System_Account_Number__c)&& String.isnotblank(integrationDefault.LCRM_ApplicationId__c)&& String.isnotblank(oSSD.LCRM_Sales_org__c)&& integrationDefault.LCRM_ApplicationId__c==strApplicationId ){
            //LCRm Team : Call the AccountReceivable functionality from salesforce->ESI->SAP
            
            odReqWrap=USLARHelper.USLARRequestHelper(oSSD.Source_System_Account_Number__c,integrationDefault.LCRM_ApplicationId__c,oSSD.LCRM_Sales_org__c,'',Begindt1,Enddt1);
            system.debug('**request******'+odReqWrap);
            if(String.isnotblank(lcrmWebserviceAR) && odReqWrap!=null ){
            System.debug('odReqWrap**'+odReqWrap);
            //String DummyJSON='{"filter":{"toDate":"2019-02-28","openItemsRequested":true,"fromDate":"2000-01-01","clearedItemsRequested":true,"additionalTextRequested":true},"esiHeader":{"messageId":"","companyId":"WEST","applicationId":"GLI"},"account":{"accountNumber":"1000550803"}}';
            response = USLARHelper.USLARCalloutHelper(lcrmWebserviceAR,JSON.serialize(odReqWrap));
            //response = USLARHelper.USLARCalloutHelper(lcrmWebserviceAR,DummyJSON);
            System.debug('response**'+response);
            }
            }else{
      lcrmMandatoryElementDisplying= true;
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCMRMandatoryElement));
            }
            
            jsonResponseAR=response.getBody();
            system.debug('****jsonResponseAR**'+jsonResponseAR);



            
            if (response.getStatusCode() == 200 ) {
            isError=false;
               USLARWrapper.Status failresponse = new USLARWrapper.Status();
               failresponse=(USLARWrapper.Status)Json.deserialize(jsonResponseAR,USLARWrapper.Status.class);
               if(failresponse.processStatus==null){
                system.debug('hi in if');
                oResponsealllist=(USLARWrapper)Json.deserialize(jsonResponseAR,USLARWrapper.class);
               
                  if(oResponsealllist.openedItems!=null){
          if(String.isNotblank(strApplicationId)){
                       //Below code is for LCRM Team    
                    List<USLARWrapper.openedItems> newOpenItem=new List<USLARWrapper.openedItems>();
                    for(USLARWrapper.openedItems opwrap:oResponsealllist.openedItems){
                    system.debug('opwrap.document.type**'+opwrap.document.type);
                    System.debug('Test***'+opwrap.document.DocumentDesc);
                    System.debug('sSelectedOption**'+sSelectedOption);
                    System.debug('strApplicationId**'+strApplicationId);
                    
                    opwrap.document.DocumentDesc=getDocumentDesc(opwrap.document.type);
                    System.debug('DocumentDesc **'+opwrap.document.DocumentDesc);
                    System.debug('opwrap**'+opwrap);
                    if(oIXOSCodeMap.size()>0){
                    //system.debug('test'+oIXOSCodeMap.get(opwrap.account.companyId));
                    //System.debug('test'+oIXOSCodeMap.get(opwrap.account.companyId).Sales_Org_Code__c);
                    
                    if(opwrap.account.companyId == strCompanyCode ){
                        opwrap.salesOrg=oSSD.LCRM_Sales_org__c;
                      System.debug(opwrap.salesOrg);  
                    }else{
                    opwrap.salesOrg=(oIXOSCodeMap.get(opwrap.account.companyId)!=null)?oIXOSCodeMap.get(opwrap.account.companyId).Sales_Org_Code__c:'';    
                    System.debug(opwrap.salesOrg);
                        
                    }
                    
                    System.debug(opwrap.salesOrg);
                    }
                    opwrap.DueDt =System.today()-integer.valueof(opwrap.netArrers);
                    System.debug('opwrap.DueDt**'+opwrap.DueDt);
                    if(sSelectedOption == System.Label.AccountRec_SOOpen || sSelectedOption == System.Label.AccountRec_SOAll){
                        System.debug('AccountRec_SOOpen opwrap.DueDt*****'+opwrap.DueDt);
                        newOpenItem.add(opwrap);
                    }else if(sSelectedOption ==System.Label.AccountRec_SOOpenDue){
                        System.debug('AccountRec_SOOpenDue opwrap.DueDt*****'+opwrap.DueDt);
                        if(opwrap.DueDt!=null && opwrap.DueDt < Date.Today()){
                        System.debug('AccountRec_SOOpenDue opwrap.DueDt*****'+opwrap.DueDt);
                        newOpenItem.add(opwrap);
                        }
                    }else if(sSelectedOption == System.Label.AccountRec_SOOpenNotDue){ 
                        System.debug('AccountRec_SOOpenDue opwrap.DueDt*****'+opwrap.DueDt);
                        if(opwrap.DueDt!=null && opwrap.DueDt >= Date.Today()){
                        newOpenItem.add(opwrap);
                        }
                    }
                  }//end for
          System.debug('newOpenItem**'+newOpenItem);
                System.debug('newOpenItemsize() **'+newOpenItem.size());    
                oResponseopenlist  = newOpenItem;
                System.debug('oResponseopenlist**'+oResponseopenlist);

               }else{
                    //Below code for Enterprise team
                    System.debug('oResponsealllist openedItems**'+oResponsealllist.openedItems);
                    System.debug('newOpenItemsize() **'+oResponsealllist.openedItems.size());
                    
                   oResponseopenlist  = oResponsealllist.openedItems;
                    System.debug('oResponseopenlist**'+oResponseopenlist);
                }
                 System.debug('oResponseopenlist  **'+oResponseopenlist);
                System.debug('oResponseopenlist size() **'+oResponseopenlist.size());
                if(oResponseopenlist.size()>0){
                 this.arpaginater = new Paginate(oResponseopenlist.size(), pageSize);              
                }
                 this.oResponseopenlist2= new List<USLARWrapper.openedItems>();
                this.oResponseopenlist1 =new List<list<USLARWrapper.openedItems>> ();
                }
                if(oResponsealllist.clearedItems!=null){
                 if(String.isNotblank(strApplicationId)){
                    //For LCRM Team
                    list<USLARWrapper.clearedItems> clearItemlst=new list<USLARWrapper.clearedItems>();
                    for(USLARWrapper.clearedItems clearWrap : oResponsealllist.clearedItems){
                    system.debug('clearWrap.document.type**'+clearWrap.document.type);
                    System.debug('clearWrap.document.DocumentDesc ***'+clearWrap.document.DocumentDesc);
                    clearWrap.document.DocumentDesc=getDocumentDesc(clearWrap.document.type);
                    System.debug('DocumentDesc **'+clearWrap.document.DocumentDesc);
                    System.debug('clearWrap**'+clearWrap); 
                    if(oIXOSCodeMap.size()>0){
                        if(clearWrap.account.companyId==strCompanyCode ){
                        clearWrap.salesOrg=oSSD.LCRM_Sales_org__c;
                        System.debug(clearWrap.salesOrg);
                        }else{
                        clearWrap.salesOrg=(oIXOSCodeMap.get(clearWrap.account.companyId)!=null)?oIXOSCodeMap.get(clearWrap.account.companyId).Sales_Org_Code__c:'';
                        System.debug(clearWrap.salesOrg);
                        }System.debug(clearWrap.salesOrg);
                    }
                    clearItemlst.add(clearWrap);
                    }
                    System.debug('clearItemlst**'+clearItemlst);
                    System.debug('clearItemlst size()**'+clearItemlst.size());
                    oResponseclearlist = clearItemlst;
                    System.debug('oResponseclearlist**'+oResponseclearlist);
                //LCRM Team End
                }else{
                //ESC Team
                    System.debug('oResponsealllist.clearedItems**'+oResponsealllist.clearedItems);
                    System.debug('oResponsealllist.clearedItems() **'+oResponsealllist.clearedItems.size());    
                 oResponseclearlist = oResponsealllist.clearedItems;
                    System.debug('oResponseclearlist**'+oResponseclearlist);
                }
                if(oResponseclearlist.size()>0){
                this.arpaginater1 = new Paginate(oResponseclearlist.size(), pageSize);
                }
                 //oResponseclearlist = oResponsealllist.clearedItems;
                //this.arpaginater1 = new Paginate(oResponseclearlist.size(), pageSize);
               this.oResponseclearlist2= new List<USLARWrapper.clearedItems>();
              this.oResponseclearlist1 =new List<list<USLARWrapper.clearedItems>> ();
              }
             if(!oResponseopenlist.IsEmpty()){
                    List<USLARWrapper.openedItems> tempop = new List<USLARWrapper.openedItems>();
                    Integer i = 0;
                    for(USLARWrapper.openedItems opwrap : oResponseopenlist){
                        if(openwrappermap != null && openwrappermap.containskey(opwrap.document.docNumber+opwrap.lineNumber)){
                        opwrap.isselected = true;
                        }
                        if(test.isrunningtest()){
                            opwrap.isselected = true;
                        }
                        tempop.add(opwrap);
                        i++;
                         if(i == pageSize){
                             oResponseopenlist1.add(tempop);
                             tempop = new List<USLARWrapper.openedItems>();
                             i = 0;
                         }
                    }
                    if(!tempop.isEmpty()){
                        this.oResponseopenlist1.add(tempop);
                    }
                    this.oResponseopenlist2 = this.oResponseopenlist1.get(this.arPaginater.index);
                }
                if(!oResponseclearlist.IsEmpty()){
                    List<USLARWrapper.clearedItems> tempop = new List<USLARWrapper.clearedItems>();
                    Integer i = 0;
                    for(USLARWrapper.clearedItems opwrap : oResponseclearlist){
                      //added for DSS-607
                        if(clearwrappermap != null && clearwrappermap.containskey(opwrap.document.docNumber+opwrap.lineNumber)){
                        opwrap.isselected = true;
                        }
                        if(test.isrunningtest()){
                            opwrap.isselected = true;
                        }
                        //complete for DSS-607
                        tempop.add(opwrap);
                        i++;
                         if(i == pageSize){
                             oResponseclearlist1.add(tempop);
                             tempop = new List<USLARWrapper.clearedItems>();
                             i = 0;
                         }
                    }
                    if(!tempop.isEmpty()){
                        this.oResponseclearlist1.add(tempop);
                    }
                    this.oResponseclearlist2 = this.oResponseclearlist1.get(this.arPaginater1.index);
                }
                sSelectedInv='False';
               }else{
         if(String.isblank(strApplicationId) ){
                //ESC (Enterprise solution Team Logic)
                System.debug('strApplicationId**'+strApplicationId);
        
                  ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                  commonCalloutException.setMessage(failresponse.processStatus.statusDescription+' : '+failresponse.processStatus.statusDetailMessage);
                  throw commonCalloutException;
          
           }else{
                //LCRm Team Logic
                System.debug('Status code**'+failresponse.processStatus.statusCode);
                system.debug('Description**'+failresponse.processStatus.statusDescription);
                LCRMGenericComponentforIntegration.documentDetailsExceptionHandling(failresponse.processStatus.statusCode,failresponse.processStatus.statusDescription,lcrmWebserviceAR);
                }
               }
                system.debug('oResponsealllist is'+oResponsealllist);
        }else{
         if(lcrmMandatoryElementDisplying = false){
            System.debug('Response.getStatusCode():-'+Response.getStatusCode());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
      }
            }
        }
        catch(Exception e){
            isError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }    
    
    /*
    This method is for LCRM Team.
    DocumentDesc value populated by Custom settings(DocumentCodeToDescMap__c)
    */
    public String getDocumentDesc(String docCode){
            String docDesc = '';
            if(DocumentCodeToDescMap__c.getValues(docCode)!=null){
                if(userinfo.getLanguage() == 'es'){
                    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc_Spanish__c;
                }else if(userinfo.getLanguage() == 'pt_BR'){
                    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc_Portuguese__c;
                }else{
                    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc__c;
                }
                if(String.isblank(docDesc)){
                    docDesc = DocumentCodeToDescMap__c.getValues(docCode).Document_Desc__c;
                }
            }
            return docDesc;
        }
    /*
    Account receivable information retrived based on Below Picklist values
    */
  
    public List<SelectOption> getARItemType(){
        List<SelectOption> options = new List<SelectOption>();
    if(String.isnotBlank(strApplicationId)){
           //LCRM Team
        options.add(new SelectOption(System.Label.AccountRec_SOAll,System.Label.AccountRec_SOAll));
        options.add(new SelectOption(System.Label.AccountRec_SOOpen,System.Label.AccountRec_SOOpen));
        options.add(new SelectOption(System.Label.AccountRec_SOOpenDue,System.Label.AccountRec_SOOpenDue));
        options.add(new SelectOption(System.Label.AccountRec_SOOpenNotDue,System.Label.AccountRec_SOOpenNotDue));
        options.add(new SelectOption(System.Label.AccountRec_SOCleared,System.Label.AccountRec_SOCleared));
        //End LCRM
       }else{
        if(caseId==null || caseId==''){
        options.add(new SelectOption(System.Label.AccountRec_SOOpen,System.Label.AccountRec_SOOpen));
        options.add(new SelectOption(System.Label.AccountRec_SOAll,System.Label.AccountRec_SOAll));
        options.add(new SelectOption(System.Label.AccountRec_SOCleared,System.Label.AccountRec_SOCleared));      
        }
        if(caseId!=null || caseId!=''){
                options.add(new SelectOption(System.Label.AccountRec_SOOpen,System.Label.AccountRec_SOOpen));
       }
     }
        return options;
    }
  /* public List<SelectOption> getARCardType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(System.Label.CardType_Credit,System.Label.CardType_Credit));
        options.add(new SelectOption(System.Label.CardType_Debit,System.Label.CardType_Debit));
        return options;
    }*/
    public void setInvoiceDateRange(){
        try{
            
            system.debug('setInvoiceDateRange '+begindt+','+enddt);
            Integer iTotalNumberOfDays =begindt.daysBetween(enddt);
            if(begindt != null ||  enddt != null){

                if(begindt > enddt){
                 isError=true;
                    throw new AppUtil.AppException(Label.DateError);  
                }else if(iTotalNumberOfDays > 365){
                 isError=true;
                    throw new AppUtil.AppException(System.Label.AccountRec_DateRangeErrMsg); 
                }  
                else{


                    Date bd =  begindt;
                    Date ed = enddt;
                    
                    Datetime bdt = Datetime.newInstance(bd.year(), bd.month(),bd.day());
                    Datetime edt = Datetime.newInstance(ed.year(), ed.month(),ed.day());
                    String begindt1 = bdt.format('yyyy-MM-dd');
                    String enddt1 = edt.format('yyyy-MM-dd');
                    getresponses(begindt1,enddt1);
                }
            }
        }catch (Exception oException){
          isError=true;
            ApexPages.addMessages(oException);
        }
        
    }
    public Void processSelected(){
        try{
        // oSelectedlist=new List<USLARWrapper>();
       // oSelectedlist=new List<USLARWrapper.openedItems>();
        sSelectedInv='Selected';
        noInv=true;
        newAmount1=0;
        integer oCreditCount=0;
        integer oDebitCount=0;
        System.debug('Openwrappertotal-->1 :' + Openwrappertotal);
        for(USLARWrapper.openedItems wrapobj:Openwrappertotal){
            if(wrapobj.isSelected==true){
                noInv=false;
                newAmount1+=wrapobj.amount;
                wrapobj.NewAmount=wrapobj.amount;
                oSelectedlist.add(wrapobj);
                //added for DSS-607
                oSelectedmap.put(wrapobj.document.docNumber+wrapobj.lineNumber,wrapobj);
                //complete for DSS-607
            if(wrapobj.debitCreditInd=='H' || wrapobj.debitCreditInd=='C'){
                oCreditCount++;
            } 
           if(wrapobj.debitCreditInd=='S' || wrapobj.debitCreditInd=='D'){
                oDebitCount++;
            } 
           }

        }
        //added for DSS-607
        for(USLARWrapper.clearedItems wrapobj:clearwrappertotal){
            if(wrapobj.isSelected==true){
                noInv=false;
                cSelectedlist.add(wrapobj);
                cSelectedmap.put(wrapobj.document.docNumber+wrapobj.lineNumber,wrapobj);
            }
            }
        //complete for DSS-607
        
        String segmentTax = ESC_segment_Region_Lotus__c.getOrgDefaults().SegmentTax__c;
        
        if(noInv ==true && !Test.isRunningTest()){
                ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                exc.setmessage('No items selected- Please select an Open Debit item ');
                throw exc;
            }
        else if(!noInv && oCreditCount>0 && oDebitCount>0 && oSSD.BU_Segment__c != segmentTax && !Test.isRunningTest()){
                noInv=true;
                ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                exc.setmessage('This Credit Card Payment request cannot be processed with the selection of open credits. Please de-select these items and select only open debit item.');
                throw exc;
            }
       else if(!noInv && oCreditCount>0 && oDebitCount==0 && oSSD.BU_Segment__c != segmentTax && !Test.isRunningTest()){
                noInv=true;
                ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
                exc.setmessage('This Credit Card Payment request cannot be processed with the selection of open credits. Please de-select these items and select open debit item.');
                throw exc;
            }
        else if(!noInv && newAmount1 < 0 && oSSD.BU_Segment__c == segmentTax && !Test.isRunningTest()){
            noInv=true;
            ESC_HandlerCustomException exc= new ESC_HandlerCustomException();
            exc.setmessage('Payment cannot be processed because the line items selected equal a credit balance.');
             throw exc;
        }
        system.debug('**SelectedInvoices**'+oSelectedlist);
        system.debug('**SelectedInvoices**'+oResponseopenlist);  
        }
       catch(Exception e){
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage())); 
        }
    }
    
    public void saveselectedopen(){
        
        for(USLARWrapper.openedItems wrapobj:oResponseopenlist2){
            if(wrapobj.isselected){
                if(!openwrappermap.containskey(wrapobj.document.docNumber+wrapobj.lineNumber)){                
                openwrappertotal.add(wrapobj);
                }
                openwrappermap.put(wrapobj.document.docNumber+wrapobj.lineNumber,wrapobj);
            }
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
    
    
      //Save selected Invoices in the custom object
   public String saveSelectedInvoices(){
        oForm = new ESC_Case_Form_Extension__c();
        String ccurl = '';
        String paymentCurrency='';
        string invoiceNumber='';
        string paymentAmount='';
        string invoiceID='';
        string lineNumber='';
        string subItemNumber='';
        String invoiceDate='';
        Decimal totalAmount=0;
        string invoicetype='';
        //newAmount1=0;
        WebServiceSettings__c pgWebServiceSettings = new WebServiceSettings__c();
        pgWebServiceSettings = AppUtil.getWebServiceSettings('USL PaymentGateway'); 
        String companyId ='';
        sSelectedInv='Selected';
        USL_Integration_defaults__c defaultVal = USLARHelper.getIntegrationDefaults(oSSD.BU_Segment__c, oSSD.LCRM_Sub_BU__c);
        if(oSSD.LCRM_Sub_BU__c == 'Canada'){
          companyId = 'CARS';
        }
        else{
          companyId = defaultVal.CompanyId__c;
        }
        String appId = defaultVal.Applicationid__c;
        String configGroup = defaultVal.ESC_ConfigGroup__c;
        system.debug('***CompanyID***' + companyId);
        system.debug('***AppId***' + appId);
        system.debug('***configGroup***' + configGroup);
        
        caseList =[Select Id,CaseNumber,ESC_Email_Thread_Id__c,Case.Account.Name,Case.Account.BillingCity,Case.Account.BillingState,
             Case.Account.SAPAccountNumber__c,Case.Account.BillingPostalCode,Case.Account.BillingStreet,
             Case.Account.BillingCountry,Case.Contact.Phone,
             Case.Contact.FirstName,Case.Contact.LastName,Contact.Email from Case where Id=:caseId];
        //string FormId=[select Id from GenerateForm__c where Name='Credit/Debit Payment'];
        if(caseId!=null && caseId!=''){
            oForm.ESC_Case__c=caseId;
            oForm.ESC_Form__c=formId;
            if (Schema.sObjectType.ESC_Case_Form_Extension__c.IsCreateable()){
                insert oForm;
            }
        }
        
        for(USLARWrapper.openedItems slist:openwrappertotal){
             if(slist.isselected){
                 ESC_Case_Form_Extension_Line_Item__c oFormExt = new ESC_Case_Form_Extension_Line_Item__c();
                 oFormExt.ESC_Case_Form_Extension__c=oForm.Id;
                 oFormExt.USL_ODocNumber__c=slist.document.docNumber;
                 oFormExt.USL_ODocType__c =slist.document.type;
                 oFormExt.USL_Input_Amount__c = slist.newamount;
                 invoiceNumber+=slist.document.docNumber+',';
                 paymentCurrency+=slist.currencycode+',';
                 if(slist.currencycode == 'CAD'){
                     isCAD = true;
                 }
                 invoiceID+=slist.document.docNumber+',';
                 paymentAmount+=slist.NewAmount+',';
                 lineNumber+=slist.lineNumber+',';
                 subItemNumber+=slist.subItemNumber+',';
                 invoicetype+=slist.document.type+',';
                 invoiceDate+=slist.baselineDate+',';
                 oFormext.Billing_Line_Item_Number__c=slist.lineNumber;
                 oFormext.Sub_Item_Number__c=slist.subItemNumber;
                 oFormExt.ESC_Item_Amount__c=slist.amount;
                 oFormExt.USL_OShortDescription__c =slist.shortDescription;
                 inserLst.add(oFormExt);     
             }     
        }
        for(ESC_Case_Form_Extension_Line_Item__c cflic: customLineList){                
            ESC_Case_Form_Extension_Line_Item__c formextitem1 = new ESC_Case_Form_Extension_Line_Item__c();
            formextitem1.ESC_Case_Form_Extension__c = oForm.Id; 
            formextitem1.USL_ODocNumber__c = cflic.ESC_Billing_Doc__c;
            if(cflic.USL_OAmount__c != null){
            formextitem1.ESC_Item_Amount__c= decimal.valueof(cflic.USL_OAmount__c);
            formextitem1.USL_Input_Amount__c = decimal.valueof(cflic.USL_OAmount__c);
            }
            formextitem1.USL_ONetArrears__c = cflic.USL_ONetArrears__c;
            formextitem1.USL_ODocType__c = cflic.USL_ODocType__c;
            formextitem1.USL_OShortDescription__c = cflic.USL_OShortDescription__c;
            formextitem1.USL_Credit_Debit_Indicator__c = cflic.USL_Credit_Debit_Indicator__c;
            formextitem1.USL_Invoice_Type__c = 'open';
            formextitem1.USL_OBaseline_Date__c = cflic.USL_OBaseline_Date__c ;
            //newAmount1+=double.valueof(cflic.USL_OAmount__c);
            invoiceNumber+=cflic.ESC_Billing_Doc__c+',';
            paymentCurrency+='USD'+',';
            invoiceID+=cflic.USL_CRefNumber__c+',';
            paymentAmount+=cflic.USL_OAmount__c+',';
            lineNumber+=cflic.Billing_Line_Item_Number__c+','; 
            subItemNumber+=cflic.Sub_Item_Number__c+','; 
            invoicetype+=cflic.USL_ODocType__c+',';
            invoiceDate+=cflic.USL_OBaseline_Date__c+',';
            inserLst.add(formextitem1);
        }
            invoiceNumber.removeEnd(',');
            paymentCurrency.removeEnd(',');
            invoiceID.removeEnd(',');
            lineNumber.removeEnd(',');
            subItemNumber.removeEnd(',');
            paymentAmount.removeEnd(',');
            invoicetype.removeEnd(',');
            invoiceDate.removeEnd(',');
            string threadId='ref:_' 
                             + UserInfo.getOrganizationId().left(4) 
                             + 'F' 
                             + UserInfo.getOrganizationId().mid(11,4) + '._' 
                             + caseId.left(4) + 'F' 
                             + caseId.mid(10,5) + ':ref';
            system.debug('threadid:'+threadId);
            if(inserLst.size()>0){
                if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.IsCreateable()){
                insert inserLst;
                }  
            }   
        if(caseList.size()>0){
           for(Case c:caseList){
                
                String detail ='QuoteNumber=' + c.CaseNumber+'|'+'BusinessUnitCode='+appId+'|'+'ContactFirstName='+c.Contact.FirstName+'|'+
                    'ContactLastName='+c.Contact.LastName+'|'+'CaseThreadId='+threadId+'|'+
                    'CustomerName='+c.Account.Name+'|'+'EmailAddress='+c.Contact.Email+'|'+'AddressLine1='+c.Account.BillingStreet+'|'+'City='+c.Account.BillingCity+'|'+'State='+c.Account.BillingState+'|'+'AccountNumber='+oSSD.Source_System_Account_Number__c+'|'+'invoiceID='+invoiceID+'|'+'invoiceDate='+invoiceDate+'|'+'InvoiceReferenceNumber='+invoiceNumber+'|'+'Country='+c.Account.BillingCountry+'|'+'Telephone='+c.Contact.Phone+'|'+'PostalCode='+c.Account.BillingPostalCode+'|'+'totalAmount='+newAmount1+'|'+'paymentAmount='+paymentAmount+'|'+'lineNumber='+lineNumber+'|'+'subItemNumber='+subItemNumber+'|'+'SystemID='+invoicetype+'|'+'paymentCurrency='+paymentCurrency+'|'+'TRPaymentCompanyId='+companyId+'|'+'ConfigGroup='+configGroup;
                System.debug('autochargeurl123: ' + detail);
                Blob cryptoKey = EncodingUtil.base64Decode('5r7owaVHWQnc9P0ZWALBbQ==');         
                Blob data = Blob.valueOf(detail);
                blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
                String b64Data = EncodingUtil.base64Encode(encryptedData);
                String urlData = EncodingUtil.urlEncode(b64Data, 'UTF-8');
                ccurl=pgWebServiceSettings.Endpoint__c+'Paydet='+urlData;
                System.debug('autochargeurl: ' + ccurl);
                }
              oForm.ESC_Instructions__c=ccurl;
              if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
                update oForm;
              }
            } 
                            
            /*if(isCAD){
                createReferral();
            }*/
            return ccurl; 
       //Redirect();
    }
    
    
    //Redirected to Selected Invoices Page
    public PageReference next(){
        processSelected();

        PageReference pr = new PageReference('/apex/USLARSelectedInvoices');
        pr.getParameters().put('id',caseId);  
        pr.setRedirect(false);          
        return pr;
    }
    //added for DSS-607
    public PageReference print(){
        processSelected();

        PageReference pr = new PageReference('/apex/USLARDownloadPage');
        pr.getParameters().put('id',caseId);  
        pr.setRedirect(false);          
        return pr;
    }
    public void saveselectedopen1(){
     system.debug('oResponseclearlist--->'+oResponseclearlist);
        for(USLARWrapper.clearedItems wrapobj:oResponseclearlist2){
            if(wrapobj.isselected){
                if(!clearwrappermap.containskey(wrapobj.document.docNumber+wrapobj.lineNumber)){                
                clearwrappertotal.add(wrapobj);
                }
                clearwrappermap.put(wrapobj.document.docNumber+wrapobj.lineNumber,wrapobj);
            }
        }
    }
    public void selectalllineitem1(){
        for(USLARWrapper.clearedItems wrapobj:oResponseclearlist){
            if(!clearwrappermap.containskey(wrapobj.document.docNumber+wrapobj.lineNumber)){                
                clearwrappertotal.add(wrapobj);
            }
            clearwrappermap.put(wrapobj.document.docNumber+wrapobj.lineNumber,wrapobj);
            if(selectallclear){
                wrapobj.isselected=true;
            }
            if(!selectallclear){
                 wrapobj.isselected=false;       
            }
        }
    }
    //Complete for DSS-607
      public PageReference goback(){
         oSelectedlist.clear();
        PageReference pr = new PageReference('/apex/USLARPaymentPage');
        pr.getParameters().put('id',caseId);  
        pr.setRedirect(false);          
        return pr;
    }
    public void calculate()
        {
            newAmount1=0;
            system.debug('**UpdatedInvoices**'+oSelectedlist);
             for(USLARWrapper.openedItems wrapobj:oSelectedlist){
                if(wrapobj.isSelected==true){
                    newAmount1+=wrapobj.NewAmount;               
               }
            }
            for(ESC_Case_Form_Extension_Line_Item__c cflic: customLineList){ 
                if(cflic.USL_OAmount__c != null){
        newAmount1+=double.valueof(cflic.USL_OAmount__c);
                }
            }
    }

    public void selectalllineitem(){
        for(USLARWrapper.openedItems wrapobj:oResponseopenlist){
            if(!openwrappermap.containskey(wrapobj.document.docNumber+wrapobj.lineNumber)){                
                openwrappertotal.add(wrapobj);
            }
            openwrappermap.put(wrapobj.document.docNumber+wrapobj.lineNumber,wrapobj);
            if(selectall){
                wrapobj.isselected=true;
            }
            if(!selectall){
                 wrapobj.isselected=false;       
            }
        }
    }
   
    /*public void createReferral(){
        //DSS-8400,DSS-8394
        ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseId,formId,'CreditCard/Debit Payment');
        if(obj.validateFormSegmentMappingExist()){
        obj.createReferral();
        }
        else{
        List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
        Group g = new Group();
        if (Schema.sObjectType.Group.isAccessible()){
            g=[Select Id from Group where DeveloperName='EBO_USL_Credit_Card']; 
        }
        ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
        ref.ESC_Role__c = 'Accountable Resolver';
        ref.ESC_Referral_Status__c = 'New';
        ref.ESC_Case__c = caseId ;
        ref.ownerid = g.id;
        referralinsertlist.add(ref);
        if (Schema.sObjectType.ESC_Case_Collaborator__c.IsCreateable()){
        insert referralinsertlist; 
        }  
    }
    }*/
  
    public PageReference submit()
    {
            // Added to fix the defect for tax DBP-3918
        system.debug('123####' +newAmount1 );
        String segmentTax = ESC_segment_Region_Lotus__c.getOrgDefaults().SegmentTax__c;
         if(newAmount1 < 0 && oSSD.BU_Segment__c == segmentTax && !Test.isRunningTest()){          
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment cannot be processed because the line items selected equal a credit balance.'));
            return null;            
        }
        String ccurl = saveSelectedInvoices();
        PageReference pr;                     
        pr= new PageReference(ccurl);         
        pr.setRedirect(true);          
        return pr;
    }
    public PageReference previousPage(){
        System.debug('**previousPage**');
        this.arPaginater.decrement();
        return changeData();
    }

    public PageReference nextPage(){
        System.debug('**nextPage**');
        this.arPaginater.increment();
        return changeData();
    }

    public PageReference updatePage(){
        System.debug('**call updatePage**');
        this.arPaginater.updateNumbers();
        return changeData();
    }

    public PageReference changeData(){
       // System.debug('**changeData:-**'+openwrapperlist1.size());
       // system.debug('paginater index is'+this.paginater.index);
        this.oResponseopenlist2= this.oResponseopenlist1.get(this.arPaginater.index);
        return null;
    }
    
    public PageReference cpreviousPage(){
      //  System.debug('**previousPage**');
        this.arPaginater1.decrement();
        return cchangeData();
    }

    public PageReference cnextPage(){
      //  System.debug('**nextPage**');
        this.arPaginater1.increment();
        return cchangeData();
    }

    public PageReference cupdatePage(){
      //  System.debug('**call updatePage**');
        this.arPaginater1.updateNumbers();
        return cchangeData();
    }

    public PageReference cchangeData(){
      //  System.debug('**changeData:-**'+openwrapperlist1.size());
      //  system.debug('paginater index is'+this.paginater.index);
        this.oResponseclearlist2= this.oResponseclearlist1.get(this.arPaginater1.index);
        return null;
    }
    
}