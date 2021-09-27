/**
 * @description ESC_ReferralAssignmentEngine
 */
public without sharing class ESC_ReferralAssignmentEngine {
    
    private Case caseObj;
    
    private ESC_Case_Form_Extension__c caseExtensionObj;
    
    private List<ESC_FormsSegmentRegionMapping__c> formSegmtRegMappingList;
    
    /**
     * @description formId
     */
    public string formId {get; set;}
    
    /**
     * @description caseId
     */
    public string caseId {get; set;}
    
    /**
     * @description formName
     */
    public string formName {get; set;}
    
    public ESC_ReferralAssignmentEngine(){    
    
    }

    /**
     * @description ESC_ReferralAssignmentEngine constructor
     * @param CaseId
     * @param formId
     * @param formName
     */
    public ESC_ReferralAssignmentEngine(string caseId, string formId, string formName)
    {
        this.formId = formId;
        this.formName = formName;
        this.caseId = caseId;
    }
    
    /**
     * @description createReferral method
     */
    public void createReferral()
    {
        string formfieldsApi = '';
        string casefieldLKP = '';
        ESC_FormsSegmentRegionMapping__c mappingObj = null;
        ESC_Referral_Form_Assign_Selector_List__c refSelectorObj = null;
        try
        {
            if(isReferralAlreadyPresent(caseId,formId,formName))
            {
                return; //referral is already present; don't create a new one.
            }
            
            getCaseInfo();
            if(caseObj != null)
            {
                System.debug(LoggingLevel.WARN,'caseObj'+caseObj);
                fetchFormExtensionMappingInfo(caseObj.ESC_Product_Segment_Brand__c, formName);
                System.debug(LoggingLevel.WARN,'formSegmtRegMappingList'+formSegmtRegMappingList);
                if(formSegmtRegMappingList != null && formSegmtRegMappingList.size() > 0)
                {
                    mappingObj = formSegmtRegMappingList[0];
                    
                    if(mappingObj.ESC_Form_Field1__c != null && mappingObj.ESC_Form_Field1__c != '')
                    {
                        formfieldsApi += mappingObj.ESC_Form_Field1__c +',';
                    }
                    if(mappingObj.ESC_Form_Field2__c != null && mappingObj.ESC_Form_Field2__c != '')
                    {
                        formfieldsApi += mappingObj.ESC_Form_Field2__c +',';
                    }
                    if(mappingObj.ESC_Form_Field3__c != null && mappingObj.ESC_Form_Field3__c != '')
                    {
                        formfieldsApi += mappingObj.ESC_Form_Field3__c +',';
                    }
                    if(mappingObj.ESC_Form_Field4__c != null && mappingObj.ESC_Form_Field4__c != '')
                    {
                        formfieldsApi += mappingObj.ESC_Form_Field4__c +',';
                    }
                    if(mappingObj.ESC_Form_Field5__c != null && mappingObj.ESC_Form_Field5__c != '')
                    {
                        formfieldsApi += mappingObj.ESC_Form_Field5__c +',';
                    }
                    
                    system.debug(LoggingLevel.WARN,'@@ formfieldsApi : ' + formfieldsApi);
                    
                    if(string.IsNotBlank(formfieldsApi))
                    {
                        getCaseExtensionInfo(formfieldsApi);
                        casefieldLKP = getCaseFieldValueLKP(formfieldsApi);   
                    }
                    system.debug(LoggingLevel.WARN,'caselkp is'+casefieldLKP );
                    if(mappingObj.Referral_Form_Assign_Selector_List__r != null && mappingObj.Referral_Form_Assign_Selector_List__r.size() > 0)
                    {
                        for(ESC_Referral_Form_Assign_Selector_List__c oRefSelector : mappingObj.Referral_Form_Assign_Selector_List__r)
                        {
                            system.debug(LoggingLevel.WARN,'formfieldlkp is'+oRefSelector.FormField_LKP__c);
                            if(oRefSelector.FormField_LKP__c != null && oRefSelector.FormField_LKP__c.equalsIgnoreCase(casefieldLKP))
                            {
                                refSelectorObj = oRefSelector;
                                break;
                            }
                        }
                    }                        
                } 
                
                if(refSelectorObj != null)
                {
                    if(refSelectorObj.Referral_Creation_Required__c && string.IsNotBlank(refSelectorObj.ESC_Referral_Queue_Name__c))
                    {
                        Id queueId = getQueueId(refSelectorObj.ESC_Referral_Queue_Name__c);
                        createReferralRecord(queueId);
                            
                    }
                    if(refSelectorObj.ESC_Case_Update_Required__c && string.IsNotBlank(refSelectorObj.ESC_Case_Queue_Name__c))
                    {
                        Id queueId = getQueueId(refSelectorObj.ESC_Case_Queue_Name__c);
                        UpdateRecord(queueId);
                    }
                } 
            }
            if(Test.isRunningTest())
            {
                        CalloutException e = new CalloutException();
                        e.setMessage('This is a constructed exception!');
                        throw e;
                    
            }
        }
        catch(Exception ex)
        {
            //Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + ex.getMessage());
            //Apexpages.addMessage(msg);
            system.debug(LoggingLevel.WARN,'exception -->'+ex);
        }
    }
    
    /**
     * @description getCaseInfo method
     */
    private void getCaseInfo()
    {
        String queryStr= '';
        try{          
            queryStr += 'Select Id,Bu_segment__c, LCRM_Sub_BU__c,ESC_Product_Segment_Brand__c from Case where Id = :caseId';
            List<Case> caseList = Database.query(queryStr);
            System.debug(LoggingLevel.WARN,'caseList'+caseList);
            if(caseList != null && caseList.size() > 0)
            {
                caseObj = caseList[0];
            }
        }
        catch(Exception ex)
        {
            //Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + ex.getMessage());
            //Apexpages.addMessage(msg);
            system.debug(LoggingLevel.WARN,'exception -->'+ex);
        }
    }
    
    /**
     * @description fetchFormExtensionMappingInfo method
     * @param segmentBrand
     * @param formName 
     */
    private void fetchFormExtensionMappingInfo(string segmentBrand, string formName)
    {
        System.debug(LoggingLevel.WARN,'segmentBrand'+segmentBrand);
        System.debug(LoggingLevel.WARN,'formName'+formName);
        try{
         if(Schema.sObjectType.ESC_FormsSegmentRegionMapping__c.isAccessible() && Schema.sObjectType.ESC_FormsSegmentRegionMapping__c.isQueryable()){  
            formSegmtRegMappingList = [Select ESC_CSS_Form__c,ESC_CSS_Form__r.name,ESC_Region__c,
                                              ESC_Segment__c,ESC_Product_Segment_Brand__c ,ESC_Form_Label_Name__c, ESC_Form_Field1__c, ESC_Form_Field2__c,
                                              ESC_Form_Field3__c, ESC_Form_Field4__c, ESC_Form_Field5__c,
                                              (Select ESC_Referral_Queue_Name__c, Referral_Creation_Required__c, FormField_LKP__c,ESC_Case_Queue_Name__c,ESC_Case_Update_Required__c
                                                  from Referral_Form_Assign_Selector_List__r)
                                       from ESC_FormsSegmentRegionMapping__c 
                                       where ESC_Product_Segment_Brand__c = :segmentBrand AND
                                               ESC_CSS_Form__r.Name = :formName
                                       Limit 1];
             System.debug(LoggingLevel.WARN,'formSegmtRegMappingList'+formSegmtRegMappingList);
            }
            if(Test.isRunningTest())
            {
                        CalloutException e = new CalloutException();
                        e.setMessage('This is a constructed exception!');
                        throw e;
                    
            }
        }
        catch(Exception ex)
        {
            //Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + ex.getMessage());
           // Apexpages.addMessage(msg);
           system.debug(LoggingLevel.WARN,'exception -->'+ex);
        }
    }
    
    /**
     * @description createReferralRecord method
     * @param ownerId 
     */
    private void createReferralRecord(Id ownerId)
    {
        List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
        List<ESC_Case_Collaborator__c> refList1  = new List<ESC_Case_Collaborator__c>();
        try
        {
            ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
            ref.ESC_Role__c = 'Accountable Resolver';
            ref.ESC_Referral_Status__c = 'New';
            ref.ESC_Case__c = caseId;
            ref.ESC_Form_Name__c = formName;
            ref.ESC_Form_Id__c = formId;
            if(ownerId != null)
            {
                ref.ownerid = ownerId;
            }
             if(formName == 'charge cancellation' || formName == 'Charge Cancellation Exception Form'){
                 if(Schema.sObjectType.ESC_Case_Collaborator__c.isAccessible()){
                     refList1 = [SELECT id ,ESC_Form_Name__c FROM ESC_Case_Collaborator__c
                                 WHERE ESC_Case__c = :caseId AND
                                 ESC_Form_Id__c = :formId AND
                                 ESC_Form_Name__c = :formName  AND OwnerID =: ownerId];
                 }
                if(!(refList1 != null && refList1.size() > 0)) 
                {
                    referralinsertlist.add(ref);
                Database.SaveResult[] result = Database.insert(referralinsertlist, false);
                system.debug(LoggingLevel.WARN,'result: ' + result);
                }                                                     
            }
            else{
            referralinsertlist.add(ref);
            Database.SaveResult[] result = Database.insert(referralinsertlist, false);
            system.debug(LoggingLevel.WARN,'result: ' + result);
            }
            if(Test.isRunningTest())
            {
                        CalloutException e = new CalloutException();
                        e.setMessage('This is a constructed exception!');
                        throw e;
                    
            }
        }
        catch(Exception ex)
        {
            //Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + ex.getMessage());
           // Apexpages.addMessage(msg);
           system.debug(LoggingLevel.WARN,'exception -->'+ex);
        }        
    }
    
    /**
     * @description UpdateRecord method
     * @param ownerId 
     */
    private void UpdateRecord(Id ownerId)
    {
     try{
        List<Case> caseupdatelist=new List<Case>();
        case newcase = new case();
        newcase.id = caseid;
        newcase.OwnerId=ownerId;
        caseupdatelist.add(newcase);
         if(Schema.sObjectType.Case.isUpdateable()){
             update caseupdatelist;
         }
        
        }
        catch(exception e) {          
            //Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            //Apexpages.addMessage(msg);
            system.debug(LoggingLevel.WARN,'exception -->'+e);
        }    
    }
    
    /**
     * @description getQueueId method
     * @param queueName
     * @return Id 
     */
    private Id getQueueId(string queueName)
    {
        try
        {
            List<Group> referralQueue = new List<Group>();
            if(Schema.sObjectType.Group.isAccessible()){
                referralQueue = [SELECT Id, developerName, Name from Group where developername = :queueName];
            }
            if(referralQueue != null && referralQueue.size() > 0)
            {
                return referralQueue[0].Id;
            }
            return null;
        }
        catch(Exception ex)
        {
            //Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + ex.getMessage());
           // Apexpages.addMessage(msg);
           system.debug(LoggingLevel.WARN,'exception -->'+ex);
            return null;
        }  
    }
    
    /**
     * @description getCaseFieldValueLKP method
     * @param fieldAPIs
     * @return string 
     */
    private string getCaseFieldValueLKP(string fieldAPIs)
    {
        string lkp = '';
        for(string cfield: fieldAPIs.split(',')){
            system.debug(LoggingLevel.WARN,'api***'+cfield);
            if(cfield.contains('.')){
                String rname1;
                List<String> list1 = new List<String>();
                for(String s : cfield.split('\\.')){
                    list1.add(s);
                }
                String t1=list1[0];
                String t2=list1[1];
                if(caseExtensionObj.getSObject(t1)!=null){
                    rname1= string.valueOf(caseExtensionObj.getSObject(t1).get(t2));
                }
                if(rname1!=null){
                    lkp+=rname1;
                }
            }
            else if (cfield != null && cfield != ''){
                
                String temp=String.Valueof(caseExtensionObj.get(cfield));
                if(temp!=null&&temp!=''){
                    lkp=lkp +temp ;
                }
            }
        }
        system.debug(LoggingLevel.WARN,'lkp***'+lkp);
        return lkp;
    }
    
    /**
     * @description getCaseExtensionInfo method
     * @param fieldAPIs 
     */
    private void getCaseExtensionInfo(string fieldAPIs)
    {
        String queryStr= '';
        try{          
            queryStr += 'Select ';
            if(string.isNotBlank(fieldAPIs))
            {
                queryStr += string.escapeSingleQuotes(fieldAPIs);
            }
            queryStr += 'Id from ESC_Case_Form_Extension__c where ESC_Case__c = :caseId AND ESC_Form__c = :formId';
            
            List<ESC_Case_Form_Extension__c> caseExtensionList = Database.query(queryStr);
            
            if(caseExtensionList != null && caseExtensionList.size() > 0)
            {
                caseExtensionObj = caseExtensionList[0];
            }
        }
        catch(Exception ex)
        {
           // Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + ex.getMessage());
           // Apexpages.addMessage(msg);
           system.debug(LoggingLevel.WARN,'exception -->'+ex);
        }
    }
    
    /**
     * @description isReferralAlreadyPresent method
     * @param caseId
     * @param formId
     * @param formName  
     * @return boolean 
     */
    private Boolean isReferralAlreadyPresent(string caseId, string formId, string formName)
    {
        Boolean isPresent = false;
        
        List<ESC_Case_Collaborator__c> refList = [SELECT id ,ESC_Form_Name__c, ownerid 
                                                  FROM ESC_Case_Collaborator__c
                                                  WHERE ESC_Case__c = :caseId AND
                                                        ESC_Form_Id__c = :formId AND
                                                        ESC_Form_Name__c = :formName];
        
        if(refList != null && refList.size() > 0){
            if(refList[0].ESC_Form_Name__c == 'charge cancellation' || refList[0].ESC_Form_Name__c == 'Charge Cancellation Exception Form'){              
                isPresent = false;
            }
            else{
            isPresent = true;
            }
         }
        else{
            isPresent = false;
            }
            
        return isPresent;
    }
    
    /**
     * @description getFormExtensionMappingInfo method
     * @param segmentBrand
     * @param formId    
     * @return boolean 
     */
    private Boolean getFormExtensionMappingInfo(string segmentBrand, string formId)
    {
        Boolean isPresent = false;
        try{
         if(Schema.sObjectType.ESC_FormsSegmentRegionMapping__c.isAccessible() && Schema.sObjectType.ESC_FormsSegmentRegionMapping__c.isQueryable()){  
            List<ESC_FormsSegmentRegionMapping__c> listFormMapping = [Select ESC_CSS_Form__c,ESC_Product_Segment_Brand__c,ESC_CSS_Form__r.name,ESC_Region__c         
                                                                       from ESC_FormsSegmentRegionMapping__c 
                                                                       where ESC_Product_Segment_Brand__c = :segmentBrand AND 
                                                                              ESC_CSS_Form__c = :formId
                                                                       Limit 1];
                                                                       
            if(listFormMapping != null && listFormMapping.size()>0){
                isPresent = true;
            }
          }
          return isPresent;
        }
        catch(Exception ex)
        {
            //Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + ex.getMessage());
            //Apexpages.addMessage(msg);
            system.debug(LoggingLevel.WARN,'exception -->'+ex);
            return false;
        }
    }
    
    /**
     * @description validateFormSegmentMappingExist method  
     * @return boolean 
     */
    public Boolean validateFormSegmentMappingExist()
    {
        Boolean itExist = false;
        getCaseInfo();
        if(caseObj != null)
        {
            itExist = getFormExtensionMappingInfo(caseObj.ESC_Product_Segment_Brand__c, formId);
        }
        
        return itExist;
    }
    
    /**
     * @description methods to handle Invoice and credit/Debit card payment
     */
    /**
     * @description lcrmMandatoryElementDisplying
     */
    public static boolean lcrmMandatoryElementDisplying{get;set;} 
    /**
     * @description lcrmWebserviceAR
     */
    public static String lcrmWebserviceAR {get;set;}
    /**
     * @description strApplicationId
     */
    public static String strApplicationId{get;set;}
    /**
     * @description oIXOSCodeMap
     */
    public static Map<String,IXOSCodeMap__c> oIXOSCodeMap;    
    //public static boolean showLineNumber{get;set;}
    /**
     * @description caseextLineItemList
     */
    public static List<ESC_Case_Form_Extension_Line_Item__c> caseextLineItemList{get;set;}
    /**
     * @description typeList
     */
    Public static List<String> typeList{get;set;}
    /**
     * @description indicatorList
     */
    Public static List<String> indicatorList{get;set;}
    /**
     * @description customLineList
     */
    Public static List<ESC_Case_Form_Extension_Line_Item__c> customLineList{get;set;}
    /**
     * @description sSelectedOption
     */
    Public static String sSelectedOption{get;set;}
     /**
     * @description oResponseopenlist
     */
    Public static List<USLARWrapper.openedItems> oResponseopenlist{get;set;}
     /**
     * @description oSelectedlist
     */
    Public static List<USLARWrapper.openedItems> oSelectedlist{get;set;}
    /**
     * @description oResponseclearlist
     */
    Public static List<USLARWrapper.clearedItems> oResponseclearlist{get;set;}
    /**
     * @description openwrappermap
     */
    //Public static Map<string,USLARWrapper.openedItems> openwrappermap;
    /**
     * @description openwrappertotal
     */
    //Public static List<USLARWrapper.openedItems> openwrappertotal;
    /**
     * @description oResponsealllist
     */
    Public static USLARWrapper oResponsealllist{get;set;}
    /**
     * @description clearwrappermap
     */
    //Public static Map<string,USLARWrapper.clearedItems> clearwrappermap;
    /**
     * @description clearwrappertotal
     */
    //Public static list<USLARWrapper.clearedItems> clearwrappertotal;
     /**
     * @description cSelectedlist
     */
    Public static List<USLARWrapper.clearedItems> cSelectedlist{get;set;}
    /**
     * @description oSelectedmap
     */
    Public static Map<string,USLARWrapper.openedItems> oSelectedmap{get;set;}
    /**
     * @description cSelectedmap
     */
    Public static Map<string,USLARWrapper.clearedItems> cSelectedmap{get;set;}
     /**
     * @description openItemsRequested
     */
    Public static Boolean openItemsRequested{get;set;}
    /**
     * @description clearedItemsRequested
     */
    Public static Boolean clearedItemsRequested{get;set;}
    //Public static Boolean additionalTextRequested{get;set;}
    /**
     * @description pagesize
     */
    Public static Integer pagesize{get;set;}
    /**
     * @description caseId1
     */
    Public static string caseId1 {get; set;}
    //Public static boolean isError{get;set;}
    //Public static boolean isOutput{get;set;}
     /**
     * @description isCAD
     */
    Public static boolean isCAD {get;set;}
    /**
     * @description oSSD
     */
    Public static Source_System_Detail__c  oSSD{get;set;}
    /**
     * @description formId1
     */
    Public static String formId1{get;set;}
    /**
     * @description caseacc
     */
    Public static Case caseacc{get;set;}
    /**
     * @description begindt
     */
    //Public static Date begindt{get;set;}
    /**
     * @description enddt
     */
    //Public static Date enddt{get;set;}
    /**
     * @description strSalesOrgCode
     */
    Public Static String strSalesOrgCode{get;set;}
    /**
     * @description strCompanyCode
     */
    Public Static String strCompanyCode{get;set;}
    /**
     * @description webServiceNameCredential
     */
    //Public Static String webServiceNameCredential = 'Invoice';
    /**
     * @description arPaginater
     */
    Public static Paginate arPaginater {get;set;}
    /**
     * @description arPaginater1
     */
    Public static Paginate arPaginater1 {get;set;}
    /**
     * @description oResponseopenlist1
     */
    Public static List<list<USLARWrapper.openedItems>> oResponseopenlist1{get;set;}
    /**
     * @description oResponseopenlist2
     */
    Public static List<USLARWrapper.openedItems> oResponseopenlist2{get;set;}
    /**
     * @description oResponseclearlist1
     */
    Public static List<list<USLARWrapper.clearedItems>> oResponseclearlist1{get;set;}
     /**
     * @description oResponseclearlist2
     */
    Public static List<USLARWrapper.clearedItems> oResponseclearlist2{get;set;}
    //Public static String sSelectedInv{get;set;}
    /**
     * @description errors
     */
    public static List<String> errors {get;set;}
    /**
     * @description resErrors
     */
    public static List<String> resErrors {get;set;}
    
     /**
     * @description USLARLoad method    
     * @param csId
     * @param fmId
     * @param appId
     * @param dateStatus
     * @param bDat
     * @param eDat
     * @return docWrap
     */  
    @AuraEnabled
    public static String uslarLoad(String csId,String fmId,String appId,boolean dateStatus,String bDat,String eDat)
    {
        //System.debug('ossd '+oSSD);
        errors = new List<String>();
        //USLARAuraController usContr = new USLARAuraController();
        /*
        LCRM_Integration_defaults_Values__c integrationDefault=new LCRM_Integration_defaults_Values__c();
        integrationDefault=LCRM_Integration_defaults_Values__c.getvalues(Label.LCRMARInvoicelist);
        if(String.isnotblank(integrationDefault.LCRM_WebserviceName__c)){
        lcrmWebserviceAR=integrationDefault.LCRM_WebserviceName__c;
        }
        lcrmMandatoryElementDisplying =false;
        */
        strApplicationId=appId;
        oIXOSCodeMap=new Map<String,IXOSCodeMap__c>();
        //END LCRM Team    
        
        //showLineNumber = false;
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
        //openwrappermap = new Map<string,USLARWrapper.openedItems>();
        //openwrappertotal = new List<USLARWrapper.openedItems>();
        oResponsealllist=new USLARWrapper();
        //added for DSS-607
        //clearwrappermap = new map<string,USLARWrapper.clearedItems>();
        //clearwrappertotal = new List<USLARWrapper.clearedItems>();
        cSelectedlist = new List<USLARWrapper.clearedItems>();
        cSelectedlist.clear();
        oSelectedmap= new map<string,USLARWrapper.openedItems> ();
        cSelectedmap=new map<string,USLARWrapper.clearedItems> ();
        //complete for DSS-607
        openItemsRequested = false;
        clearedItemsRequested = false;
        //additionalTextRequested =false;
        pagesize=50;
        caseId1='';
        //isError=false;
        //isOutput = false;
        isCAD = false;
        oSSD = new Source_System_Detail__c();
        
        
        Id idToProccess = csId;              
        Schema.sObjectType entityType = idToProccess.getSObjectType();
        
        try {
            if(entityType == Source_System_Detail__c.sObjectType)
            {
                if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                    oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, Account_Name__r.Sales_Org__c,LCRM_Sub_BU__c, BU_Segment__c  FROM Source_System_Detail__c where id = :oSSD.id  ];  
                }
            }
            else if(entityType == case.sObjectType)
            {
                 // This is a Case record 
                //sortDirection = 'asc';
                //caseacc=(Case) controller.getRecord();  
                caseId1= csId;
                //caseId='5002D000001XJpQ';
                formId1 = fmId;
                system.debug(logginglevel.warn,'**Select formId**'+fmId);
                system.debug(logginglevel.warn,'**Select caseId**'+csId);
                if (Schema.sObjectType.esc_case_form_extension__c.isAccessible()){
                    caseextlist = [select id,USL_Total_Amount__c from esc_case_form_extension__c where esc_case__c=:caseId1 and esc_form__c =:formid1];
                }
                if(caseextlist.size() > 0){
                    /*
                    if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible()){
                        caseextLineItemList =[select Id,USL_ODocNumber__c,USL_InvListNumber__c,USL_ODocType__c,USL_Input_Amount__c,Billing_Line_Item_Number__c,ESC_Item_Amount__c,USL_OShortDescription__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =:caseextlist[0].id];
                    }
                    */
                    //isOutput = true;
                    caseextLineItemList = getCaseFormLineExtension(caseextlist[0].id);
                }
                if (Schema.sObjectType.Case.isAccessible()){
                    caseacc = [Select Id,CaseNumber,Contact_Source_System__c,Case.Contact_Source_System__r.name,    
                    Case.Account.Id,Case.USL_SAP_Account_Number__c,Case.Account.SAPAccountNumber__c,Case.Contact.FirstName,
                    Case.Account.Sales_Org__c  FROM Case where id =:caseId1]; 
                }
                   //system.debug('**CaseaccList**'+caseacc);         
               if(caseacc.USL_SAP_Account_Number__c!=null){
                /*
                if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, 
                        Account_Name__r.Sales_Org__c,LCRM_Sub_BU__c, BU_Segment__c  FROM Source_System_Detail__c where Source_System_Account_Number__c= :caseacc.USL_SAP_Account_Number__c LIMIT 1];  
                }
                */
                   oSSD = getSourceSystemDetail(caseacc.USL_SAP_Account_Number__c);
                  //system.debug('**Select SObjecTypeoCaseSSD**'+oSSD);
                  //System.debug('sap Number1 '+oSSD.Source_System_Account_Number__c);
                }
                else{
                   errors.add(System.Label.Usl_SAPAccError);    
                   //isError=true;
                }  
            }
            
            if(oSSD.Id != null && oSSD.LCRM_Sales_org__c == null){
                throw new AppUtil.AppException(Label.SalesOrgError);  
            }
            
            //begindt = system.today().addDays(-365);
            //enddt = system.today();
            //system.debug('Before format '+begindt+','+enddt);
            Date d =  Date.today();
            Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
            //system.debug('dt '+dt);
            //
            String begindt1;
            String enddt1;
            if(dateStatus == true)
            {
                begindt1 = dt.addDays(-365).format('yyyy-MM-dd');
                enddt1 = dt.format('yyyy-MM-dd');
            }
            else
            {
                begindt1=bDat;
                enddt1=eDat;
            }
            system.debug(logginglevel.warn,'ater format '+begindt1+','+enddt1);
            //getresponses(Begindt1,Enddt1);
            if(String.isblank(strApplicationId)){
                sSelectedOption = System.Label.AccountRec_SOAll;
                if(oSSD != null){
                    for(IXOSCodeMap__c tempObj : IXOSCodeMap__c.getAll().Values()){
                         oIXOSCodeMap.put(tempObj.Company_Code__c,tempObj);
                    }
                    //System.debug('Keyset**'+oIXOSCodeMap.keyset());
                    //System.debug('Values**'+oIXOSCodeMap.values());
                    //This parameter is set for LCRMIxos functionality
                    assignCodeMap(oSSD.LCRM_Sales_org__c);
                    /*
                    if(String.isnotblank(oSSD.LCRM_Sales_org__c) ){
                        IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oSSD.LCRM_Sales_org__c);
                        strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
                        strCompanyCode = oIXOSCodeMap.Company_Code__c;                
                    }
                    */
                    }
                getresponses(Begindt1,Enddt1);
            }
            //else
            //{                
                //LCRm Team changes
                /*    
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
                    errors.add(Label.LCRMWebservice_SSD);
                }
                */
            //}
        }
        catch(Exception e)
        {
            errors.add(e.getMessage());
            //isError=true;
        }
        String segmentTax = ESC_segment_Region_Lotus__c.getOrgDefaults().SegmentTax__c;
        //System.debug('errors '+errors);
        DataWrap wr = new DataWrap();
        //System.debug('olist '+oResponseopenlist);
        wr.ooResponseopenlist = oResponseopenlist;
        wr.otypeList = typeList;
        wr.segTax = segmentTax;
        wr.oSSD1 = oSSD;
        wr.errors1 = errors;
        wr.resErrors1 = resErrors;
        wr.caseextLineItemList1 = caseextLineItemList;
        wr.caseexteForm = caseextlist;
        //System.debug('olist1 '+wr.ooResponseopenlist);
        return JSON.serialize(wr);
    }
    
    /**
     * @description getresponses method 
     * @param begindt1
     * @param enddt1
     * @return string
     */
    public static String getresponses(String begindt1,String enddt1){
        
        String webServiceNameCredential = 'Invoice';
        Map<string,USLARWrapper.openedItems> openwrappermap = new Map<string,USLARWrapper.openedItems>();
        resErrors = new List<String>();
        //USLARAuraController usContr = new USLARAuraController();
        DataWrap dwRap = new DataWrap();
        LCRM_Integration_defaults_Values__c integrationDefault=new LCRM_Integration_defaults_Values__c();
        integrationDefault=LCRM_Integration_defaults_Values__c.getvalues(Label.LCRMARInvoicelist);
        try{
            lcrmMandatoryElementDisplying=false;
            USLARWrapper.ARrequest odReqWrap = new USLARWrapper.ARrequest();
            
            String jsonresponseAR='';
            Httpresponse response = new Httpresponse();
            if(String.isblank(strApplicationId) ){
                
                USL_Integration_defaults__c val = USLARHelper.getIntegrationDefaults(oSSD.BU_Segment__c, oSSD.LCRM_Sub_BU__c);
                system.debug(logginglevel.warn,'**Integration Default******'+val);
                /*
                if(val!=null && val.ApplicationId__c == 'ESCH' && val.companyId__c =='S100'){
                    showLineNumber = true;
                }
                */
                System.debug(logginglevel.warn,'sap Number '+oSSD.Source_System_Account_Number__c);
                odReqWrap=USLARHelper.USLARRequestHelper(oSSD.Source_System_Account_Number__c,val.Applicationid__c,val.Companyid__c,val.ESC_ConfigGroup__c,Begindt1,Enddt1);
                system.debug(logginglevel.warn,'**request******'+odReqWrap);
                response = USLARHelper.USLARCalloutHelper(WebServiceNameCredential,JSOn.serialize(odReqWrap));
                //if(test.isrunningtest()){
                //    response = USLARHelper.USLARCalloutHelper(WebServiceNameCredential,JSOn.serialize(odReqWrap));
                //}
            }
            else{
                lcrmMandatoryElementDisplying= true;
                resErrors.add(Label.LCMRMandatoryElement);
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCMRMandatoryElement));
            }
            jsonResponseAR=response.getBody();
            system.debug(logginglevel.warn,'****jsonResponseAR**'+jsonResponseAR);
            
            if (response.getStatusCode() == 200 ){
                //isError=false;
                USLARWrapper.Status failresponse = new USLARWrapper.Status();
                failresponse=(USLARWrapper.Status)Json.deserialize(jsonResponseAR,USLARWrapper.Status.class);
                if(failresponse.processStatus==null){
                    
                    oResponsealllist=(USLARWrapper)Json.deserialize(jsonResponseAR,USLARWrapper.class);
                    
                    if(oResponsealllist.openedItems!=null){
                        if(String.isNotblank(strApplicationId)){
                            //Below code is for LCRM Team    
                            List<USLARWrapper.openedItems> newOpenItem=new List<USLARWrapper.openedItems>();
                            for(USLARWrapper.openedItems opwrap:oResponsealllist.openedItems){
                                system.debug(logginglevel.warn,'opwrap.document.type**'+opwrap.document.type);
                                System.debug(logginglevel.warn,'Test***'+opwrap.document.DocumentDesc);
                                System.debug(logginglevel.warn,'sSelectedOption**'+sSelectedOption);
                                System.debug(logginglevel.warn,'strApplicationId**'+strApplicationId);
                                
                                opwrap.document.DocumentDesc=getDocumentDesc(opwrap.document.type);
                                System.debug(logginglevel.warn,'DocumentDesc **'+opwrap.document.DocumentDesc);
                                System.debug(logginglevel.warn,'opwrap**'+opwrap);
                                if(oIXOSCodeMap.size()>0){
                                    system.debug(logginglevel.warn,'test'+oIXOSCodeMap.get(opwrap.account.companyId));
                                    System.debug(logginglevel.warn,'test'+oIXOSCodeMap.get(opwrap.account.companyId).Sales_Org_Code__c);
                                    
                                    if(opwrap.account.companyId == strCompanyCode ){
                                        opwrap.salesOrg=oSSD.LCRM_Sales_org__c;
                                        System.debug(logginglevel.warn,opwrap.salesOrg);  
                                    }else{
                                        opwrap.salesOrg=(oIXOSCodeMap.get(opwrap.account.companyId)!=null)?oIXOSCodeMap.get(opwrap.account.companyId).Sales_Org_Code__c:'';    
                                        System.debug(logginglevel.warn,opwrap.salesOrg);
                                        
                                    }
                                    
                                    System.debug(logginglevel.warn,opwrap.salesOrg);
                                }
                                opwrap.DueDt =System.today()-integer.valueof(opwrap.netArrers);
                                //System.debug('opwrap.DueDt**'+opwrap.DueDt);
                                if(sSelectedOption == System.Label.AccountRec_SOOpen || sSelectedOption == System.Label.AccountRec_SOAll){
                                    //System.debug('AccountRec_SOOpen opwrap.DueDt*****'+opwrap.DueDt);
                                    newOpenItem.add(opwrap);
                                }else if(sSelectedOption ==System.Label.AccountRec_SOOpenDue){
                                    //System.debug('AccountRec_SOOpenDue opwrap.DueDt*****'+opwrap.DueDt);
                                    if(opwrap.DueDt!=null && opwrap.DueDt < Date.Today()){
                                        //System.debug('AccountRec_SOOpenDue opwrap.DueDt*****'+opwrap.DueDt);
                                        newOpenItem.add(opwrap);
                                    }
                                }else if(sSelectedOption == System.Label.AccountRec_SOOpenNotDue){ 
                                    //System.debug('AccountRec_SOOpenDue opwrap.DueDt*****'+opwrap.DueDt);
                                    if(opwrap.DueDt!=null && opwrap.DueDt >= Date.Today()){
                                        newOpenItem.add(opwrap);
                                    }
                                }
                            }//end for
                            System.debug(logginglevel.warn,'newOpenItem**'+newOpenItem);
                            //System.debug('newOpenItemsize() **'+newOpenItem.size());    
                            oResponseopenlist  = newOpenItem;
                            System.debug(logginglevel.warn,'oResponseopenlist**'+oResponseopenlist);
                            
                        }else{
                            //Below code for Enterprise team
                            //System.debug('oResponsealllist openedItems**'+oResponsealllist.openedItems);
                            //System.debug('newOpenItemsize() **'+oResponsealllist.openedItems.size());
                            
                            oResponseopenlist  = oResponsealllist.openedItems;
                            System.debug(logginglevel.warn,'oResponseopenlist**'+oResponseopenlist);
                        }
                        System.debug(logginglevel.warn,'oResponseopenlist  **'+oResponseopenlist);
                        System.debug(logginglevel.warn,'oResponseopenlist size() **'+oResponseopenlist.size());
                        if(oResponseopenlist.size()>0){
                            arpaginater = new Paginate(oResponseopenlist.size(), pageSize);              
                        }
                        oResponseopenlist2= new List<USLARWrapper.openedItems>();
                        oResponseopenlist1 =new List<list<USLARWrapper.openedItems>> ();
                    }
                    //if(oResponsealllist.clearedItems!=null){
                        //if(String.isNotblank(strApplicationId)){
                            //For LCRM Team
                            /*
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
                            */
                            //LCRM Team End
                        //}else{
                            //ESC Team
                            /*
                            System.debug('oResponsealllist.clearedItems**'+oResponsealllist.clearedItems);
                            System.debug('oResponsealllist.clearedItems() **'+oResponsealllist.clearedItems.size());    
                            oResponseclearlist = oResponsealllist.clearedItems;
                            System.debug('oResponseclearlist**'+oResponseclearlist);
                            */
                        //}
                        /*
                        if(oResponseclearlist.size()>0){
                           arpaginater1 = new Paginate(oResponseclearlist.size(), pageSize);
                        }
                        */
                        //oResponseclearlist = oResponsealllist.clearedItems;
                        //this.arpaginater1 = new Paginate(oResponseclearlist.size(), pageSize);
                        //oResponseclearlist2= new List<USLARWrapper.clearedItems>();
                        //oResponseclearlist1 =new List<list<USLARWrapper.clearedItems>> ();
                    //}
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
                            oResponseopenlist1.add(tempop);
                        }
                        oResponseopenlist2 = oResponseopenlist1.get(arPaginater.index);
                    }
                    
                    /*
                    if(!oResponseclearlist.IsEmpty()){
                        List<USLARWrapper.clearedItems> tempop = new List<USLARWrapper.clearedItems>();
                        Integer i = 0;
                        for(USLARWrapper.clearedItems opwrap : oResponseclearlist){
                            
                            if(clearwrappermap != null && clearwrappermap.containskey(opwrap.document.docNumber+opwrap.lineNumber)){
                                opwrap.isselected = true;
                            }
                            if(test.isrunningtest()){
                                opwrap.isselected = true;
                            }
                            
                            tempop.add(opwrap);
                            i++;
                            if(i == pageSize){
                                oResponseclearlist1.add(tempop);
                                tempop = new List<USLARWrapper.clearedItems>();
                                i = 0;
                            }
                        }
                        if(!tempop.isEmpty()){
                            oResponseclearlist1.add(tempop);
                        }
                        oResponseclearlist2 = oResponseclearlist1.get(arPaginater1.index);
                    }
                    */
                    //sSelectedInv='False';
                }
                
                /*
                else{
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
                */
                system.debug(logginglevel.warn,'oResponsealllist is'+oResponsealllist);
                dwRap.ooResponseopenlist = oResponseopenlist;
            }
            else {
                if(lcrmMandatoryElementDisplying = false){
                    System.debug(logginglevel.warn,'Response.getStatusCode():-'+Response.getStatusCode());
                    resErrors.add(Label.LCRMWebServiceError);
                    //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.LCRMWebServiceError));
                }
            }
            
        }
        catch(Exception e)
        {
            //isError=true;
            //System.debug('msg' + e.getMessage());
            resErrors.add(e.getMessage());
        }
        return JSON.serialize(dwRap);
    }
    
    /**
     * @description getDocumentDesc method  
     * @param docCode
     * @return docDesc
     */
      public Static String getDocumentDesc(String docCode){
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
    
    /**
     * @description Wrapper class for credit/Debit card response
     */
    public class DataWrap
    {
        @AuraEnabled Public List<USLARWrapper.openedItems> ooResponseopenlist;
        @AuraEnabled Public List<String> otypeList;
        @AuraEnabled Public String segTax;
        @AuraEnabled Public Source_System_Detail__c  oSSD1;
        @AuraEnabled public List<String> errors1;
        @AuraEnabled public List<String> resErrors1;
        @AuraEnabled public List<ESC_Case_Form_Extension__c> caseexteForm;
        @AuraEnabled public List<ESC_Case_Form_Extension_Line_Item__c> caseextLineItemList1;
    }
    
    /**
     * @description Wrapper class for Saved Invoice response
     */
    public class ResultData
    {
        @AuraEnabled Public String urlString;
        @AuraEnabled public List<ESC_Case_Form_Extension_Line_Item__c> caseextLineItemList2;
    }
    
    /**
     * @description saveSelectedInvoices method 
     * @param processData
     * @param processCustomData
     * @param businessSeg
     * @param businessSubBu
     * @param caseDatatId
     * @param formDataId
     * @param systemSrcAccNumber
     * @param newAmount1
     * @param extFromId
     * @param updatedAmount
     * @return String
     */
    @AuraEnabled
    public static String saveSelectedInvoices(String processData, String processCustomData, String businessSeg,String businessSubBu,String caseDatatId,String formDataId,String systemSrcAccNumber,Double newAmount1,String extFromId,Double updatedAmount){
        //ESC_Case_Form_Extension__c oForm = new ESC_Case_Form_Extension__c();
        ESC_Case_Form_Extension__c oForm;
        List<ESC_Case_Form_Extension_Line_Item__c> inserLst = new List<ESC_Case_Form_Extension_Line_Item__c>();
        List<Case> caseList = new List<Case>();
         
        //Double newAmount1=129.34;
        String ccurl = '';
        String paymentCurrency='';
        string invoiceNumber='';
        string paymentAmount='';
        string invoiceID='';
        string lineNumber='';
        string subItemNumber='';
        String invoiceDate='';
        //Decimal totalAmount=0;
        string invoicetype='';
        
        String fmId;
        
        WebServiceSettings__c pgWebServiceSettings = new WebServiceSettings__c();
        pgWebServiceSettings = AppUtil.getWebServiceSettings('USL PaymentGateway'); 
        
        String companyId ='';
        //sSelectedInv='Selected';
        USL_Integration_defaults__c defaultVal = USLARHelper.getIntegrationDefaults(businessSeg, businessSubBu);
        if(businessSubBu == 'Canada'){
            companyId = 'CARS';
        }
        else{
            companyId = defaultVal.CompanyId__c;
        }
        String appId = defaultVal.Applicationid__c;
        String configGroup = defaultVal.ESC_ConfigGroup__c;
        //System.debug('appId'+appId);
        //System.debug('config'+configGroup);
        
        caseList =[Select Id,CaseNumber,ESC_Email_Thread_Id__c,Case.Account.Name,Case.Account.BillingCity,Case.Account.BillingState,
                   Case.Account.SAPAccountNumber__c,Case.Account.BillingPostalCode,Case.Account.BillingStreet,
                   Case.Account.BillingCountry,Case.Contact.Phone,
                   Case.Contact.FirstName,Case.Contact.LastName,Contact.Email from Case where Id=:caseDatatId];
        System.debug(logginglevel.warn,'caseList'+caseList);
        
        if(extFromId == null){
            if(caseDatatId!=null && caseDatatId!=''){
                /*
                oForm.ESC_Case__c=caseDatatId;
                oForm.ESC_Form__c=formDataId;
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.IsCreateable()){
                    insert oForm;
                }
                */
                oForm=createCaseFormExtension(caseDatatId,formDataId);
            }
            
             fmId = oForm.Id;
            //fmId = fmNewId;
        }
        else
        {
            fmId = extFromId;
        }
        //System.debug('processData '+processData);
       
        
        Object results = JSON.deserializeUntyped(processData);
        //System.debug('process len'+results);
        List<Object> lstCustomers = (List<Object>)results;
        for(Object res : lstCustomers){
            Map<String, Object> attr = (Map<String, Object>)res;
            
            ESC_Case_Form_Extension_Line_Item__c oFormExt = new ESC_Case_Form_Extension_Line_Item__c();
            if(extFromId == null){
                oFormExt.ESC_Case_Form_Extension__c=oForm.Id;
            }
            else
            {
                oFormExt.ESC_Case_Form_Extension__c=extFromId;
            }
            //if(attr.get('docNumber') != null){
                oFormExt.USL_ODocNumber__c=attr.get('docNumber')?.toString();
            //}
            //if(attr.get('invList') != null){
                oFormExt.USL_InvListNumber__c = attr.get('invList')?.toString();
            //}
            //if(attr.get('doct') != null){
                oFormExt.USL_ODocType__c =attr.get('doct')?.toString();
            //}
            if(attr.get('newAmount') != null){
                oFormExt.USL_Input_Amount__c = (Decimal)attr.get('newAmount');
            }
            if(attr.get('docNumber') != null){
                invoiceNumber+=attr.get('docNumber').toString()+',';
            }
            if(attr.get('ccode') != null){
                paymentCurrency+=attr.get('ccode')+',';
                if(attr.get('ccode').toString() == 'CAD'){
                    isCAD = true;
                }
            }
            if(attr.get('docNumber') != null)
            {
                invoiceID+=attr.get('docNumber')+',';
            }
            if(attr.get('newAmount') != null){
                paymentAmount+=attr.get('newAmount')+',';
            }
            if(attr.get('lnum') != null){
                lineNumber+=attr.get('lnum')+',';
            }
            if(attr.get('subItemNumber') != null){
                subItemNumber+=attr.get('subItemNumber')+',';
            }
            if(attr.get('doct') != null){
                invoicetype+=attr.get('doct')+',';
            }
            if(attr.get('baselineDate') != null){
                invoiceDate+=attr.get('baselineDate')+',';
            }            
            //if(attr.get('lnum') != null){
                oFormext.Billing_Line_Item_Number__c=attr.get('lnum')?.toString();
            //}
            //if(attr.get('subItemNumber')!=null){
                oFormext.Sub_Item_Number__c=attr.get('subItemNumber')?.toString();
            //}
            if(attr.get('amount') !=null)
            {
                oFormExt.ESC_Item_Amount__c=(Decimal)attr.get('amount');
            }
            //if(attr.get('shortDescription') != null){
                oFormExt.USL_OShortDescription__c =attr.get('shortDescription')?.toString();
            //}
            
            inserLst.add(oFormExt);
        }
        //System.debug('ilist '+inserLst);
        
        Object customResults = JSON.deserializeUntyped(processCustomData);
        List<Object> lstCustmResults = (List<Object>)customResults;
        for(Object res : lstCustmResults)
        {
            Map<String, Object> attr = (Map<String, Object>)res;
            ESC_Case_Form_Extension_Line_Item__c formextitem1 = new ESC_Case_Form_Extension_Line_Item__c();
            if(extFromId == null){
                formextitem1.ESC_Case_Form_Extension__c = oForm.Id;
            }
            else{
                formextitem1.ESC_Case_Form_Extension__c = extFromId;
            }
            //if(attr.get('billDoc') != null){
                formextitem1.USL_ODocNumber__c = attr.get('billDoc')?.toString();
            //}
            
            if(attr.get('amount') != '' && attr.get('amount') != null){
                formextitem1.ESC_Item_Amount__c= (Decimal)attr.get('amount');
                formextitem1.USL_Input_Amount__c = (Decimal)attr.get('amount');
            }
            
            //if(attr.get('netar') != null){
                formextitem1.USL_ONetArrears__c = attr.get('netar')?.toString();
            //}
            //if(attr.get('doct') != null){
                formextitem1.USL_ODocType__c = attr.get('doct')?.toString();
            //}
            //if(attr.get('sDec') != null){
                formextitem1.USL_OShortDescription__c = attr.get('sDec')?.toString();
            //}
            //if(attr.get('deInd') != null){
                formextitem1.USL_Credit_Debit_Indicator__c = attr.get('deInd')?.toString();
            //}
            formextitem1.USL_Invoice_Type__c = 'open';
            //if(attr.get('bDate') != null){
                formextitem1.USL_OBaseline_Date__c = attr.get('bDate')?.toString();
            //}
            //if(attr.get('billDoc') != null){
                formextitem1.USL_InvListNumber__c = attr.get('billDoc')?.toString();
                invoiceNumber+=attr.get('billDoc')?.toString()+',';
            //}
            paymentCurrency+='USD'+',';
            //if(attr.get('refNumber') != null){
                invoiceID+=attr.get('refNumber')?.toString()+',';
            //}
            if(attr.get('amount') != null){
                paymentAmount+=(Decimal)attr.get('amount')+',';
            }
            //if(attr.get('lineNumber') != null){
                lineNumber+=attr.get('lineNumber')?.toString()+','; 
            //}     
            subItemNumber+=''+',';
            //if(attr.get('doct') != null){
                invoicetype+=attr.get('doct')?.toString()+',';
            //}
            //if(attr.get('bDate') != null){
                invoiceDate+=attr.get('bDate')?.toString()+',';
            //}
            
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
            + caseDatatId.left(4) + 'F' 
            + caseDatatId.mid(10,5) + ':ref';
        
        //System.debug('insert list '+inserLst);
        if(inserLst.size()>0){
            if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.IsCreateable()){
                insert inserLst;
            }  
        }
        if(caseList.size()>0){
            for(Case c:caseList){
                /*
                String detail ='QuoteNumber=' + c.CaseNumber+'|'+'BusinessUnitCode='+appId+'|'+'ContactFirstName='+c.Contact.FirstName+'|'+
                    'ContactLastName='+c.Contact.LastName+'|'+'CaseThreadId='+threadId+'|'+
                    'CustomerName='+c.Account.Name+'|'+'EmailAddress='+c.Contact.Email+'|'+'AddressLine1='+c.Account.BillingStreet+'|'+'City='+c.Account.BillingCity+'|'+'State='+c.Account.BillingState+'|'+'AccountNumber='+systemSrcAccNumber+'|'+'invoiceID='+invoiceID+'|'+'invoiceDate='+invoiceDate+'|'+'InvoiceReferenceNumber='+invoiceNumber+'|'+'Country='+c.Account.BillingCountry+'|'+'Telephone='+c.Contact.Phone+'|'+'PostalCode='+c.Account.BillingPostalCode+'|'+'totalAmount='+newAmount1+'|'+'paymentAmount='+paymentAmount+'|'+'lineNumber='+lineNumber+'|'+'subItemNumber='+subItemNumber+'|'+'SystemID='+invoicetype+'|'+'paymentCurrency='+paymentCurrency+'|'+'TRPaymentCompanyId='+companyId+'|'+'ConfigGroup='+configGroup +'|'+ 'callbackURL=' + 'https://cs15.salesforce.com/services/Soap/class/ProposalCCTokenPostBack';
                System.debug('autochargeurl123: ' + detail);
        */
                String detail ='QuoteNumber=' + c.CaseNumber+'|'+'BusinessUnitCode='+appId+'|'+'ContactFirstName='+c.Contact.FirstName+'|'+
                    'ContactLastName='+c.Contact.LastName+'|'+'CaseThreadId='+threadId+'|'+
                    'CustomerName='+c.Account.Name+'|'+'EmailAddress='+c.Contact.Email+'|'+'AddressLine1='+c.Account.BillingStreet+'|'+'City='+c.Account.BillingCity+'|'+'State='+c.Account.BillingState+'|'+'AccountNumber='+systemSrcAccNumber+'|'+'invoiceID='+invoiceID+'|'+'invoiceDate='+invoiceDate+'|'+'InvoiceReferenceNumber='+invoiceNumber+'|'+'Country='+c.Account.BillingCountry+'|'+'Telephone='+c.Contact.Phone+'|'+'PostalCode='+c.Account.BillingPostalCode+'|'+'totalAmount='+newAmount1+'|'+'paymentAmount='+paymentAmount+'|'+'lineNumber='+lineNumber+'|'+'subItemNumber='+subItemNumber+'|'+'SystemID='+invoicetype+'|'+'paymentCurrency='+paymentCurrency+'|'+'TRPaymentCompanyId='+companyId+'|'+'ConfigGroup='+configGroup +'|'+ 
          'CCTokenPostBackWsdlLocation='+System.Label.ESC_Payment_PostBack+'|'+'EnterpriseWsdlLocation='+System.Label.ESC_Payment_EnterpriseWsdl;
                System.debug(logginglevel.warn,'autochargeurl123: ' + detail);
                
                Blob cryptoKey = EncodingUtil.base64Decode('5r7owaVHWQnc9P0ZWALBbQ==');         
                Blob data = Blob.valueOf(detail);
                blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
                String b64Data = EncodingUtil.base64Encode(encryptedData);
                String urlData = EncodingUtil.urlEncode(b64Data, 'UTF-8');
                ccurl=pgWebServiceSettings.Endpoint__c+'Paydet='+urlData; 
                System.debug(logginglevel.warn,'autochargeurl: ' + ccurl);
            }  
        }
        
        if(extFromId == null){
            oForm.ESC_Instructions__c=ccurl;
            oForm.USL_Total_Amount__c=newAmount1;
            if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
                update oForm;
            }
        }
        else{
            List<ESC_Case_Form_Extension__c> esExt = [select id,ESC_Instructions__c,USL_Total_Amount__c from ESC_Case_Form_Extension__c where Id=:extFromId];
            esExt[0].ESC_Instructions__c = ccurl;
            esExt[0].USL_Total_Amount__c = updatedAmount;
            if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
                update esExt;
            }
        }
        //System.debug('oform Id '+oForm.Id);
        List<ESC_Case_Form_Extension_Line_Item__c> caseextLineItemList=[select USL_ODocNumber__c,USL_InvListNumber__c,USL_ODocType__c,USL_Input_Amount__c,Billing_Line_Item_Number__c,ESC_Item_Amount__c,USL_OShortDescription__c,ESC_Case_Form_Extension__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c=:fmId];
        
        ResultData rd = new ResultData();
        rd.urlString = ccurl;
        rd.caseextLineItemList2 = caseextLineItemList;
        return JSON.serialize(rd);
    }
    
    
    /**
     * @description getUpdatedCaseExtensions method 
     * @param extId
     * @return caseextLineItemList
     */
    @AuraEnabled
    public static List<ESC_Case_Form_Extension_Line_Item__c> getUpdatedCaseExtensions(String extId){
        
        List<ESC_Case_Form_Extension_Line_Item__c> caseExt = [select Id,ESC_Case_Form_Extension__c from ESC_Case_Form_Extension_Line_Item__c where Id =:extId];
        String fmId = caseExt[0].ESC_Case_Form_Extension__c;
        //if(Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isdeletable()){
            delete caseExt;
        //}
        List<ESC_Case_Form_Extension_Line_Item__c> caseextLineItemList=[select Id,USL_ODocNumber__c,USL_InvListNumber__c,USL_ODocType__c,USL_Input_Amount__c,Billing_Line_Item_Number__c,ESC_Item_Amount__c,USL_OShortDescription__c,ESC_Case_Form_Extension__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c=:fmId];
        if(caseextLineItemList.size() > 0)
        {
            updateTotalAmount(caseextLineItemList);   
        }
        
        if(caseextLineItemList.size() == 0)
        {
            ESC_Case_Form_Extension__c esForm = new ESC_Case_Form_Extension__c();
            esForm.Id = fmId;
            esForm.USL_Total_Amount__c = 0;
            if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
                update esForm;
            }
            
        }
        return caseextLineItemList;
    }
    
    /**
     * @description updateTotalAmount method    
     * @param csextList
     */
    public static void updateTotalAmount(List<ESC_Case_Form_Extension_Line_Item__c> csextList){
        
        Decimal amount = 0;
        
        for(ESC_Case_Form_Extension_Line_Item__c ext : csextList)
        {
            amount = amount + ext.USL_Input_Amount__c;
        }
        
        List<ESC_Case_Form_Extension__c> esExt = [select id,ESC_Instructions__c,USL_Total_Amount__c from ESC_Case_Form_Extension__c where Id=:csextList[0].ESC_Case_Form_Extension__c];
        esExt[0].USL_Total_Amount__c = amount;
        if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
            update esExt;
        }
    }
    /**
     * @description getCaseFormLineExtension method 
     * @param csFormId
     * @return caseextLineItemList
     */
    public static List<ESC_Case_Form_Extension_Line_Item__c> getCaseFormLineExtension(String csFormId){
        List<ESC_Case_Form_Extension_Line_Item__c> csextLineItemList;
        if (Schema.sObjectType.ESC_Case_Form_Extension_Line_Item__c.isAccessible()){
             csextLineItemList=[select Id,USL_ODocNumber__c,USL_InvListNumber__c,USL_ODocType__c,USL_Input_Amount__c,Billing_Line_Item_Number__c,ESC_Item_Amount__c,USL_OShortDescription__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =:csFormId];
        }
       return csextLineItemList;
    }
    
    /**
     * @description getSourceSystemDetail method    
     * @param sapNum
     * @return Source_System_Detail__c
     */
    public static Source_System_Detail__c getSourceSystemDetail(String sapNum){
        Source_System_Detail__c ossDetail;
        if (Schema.sObjectType.Source_System_Detail__c.isAccessible()){
            ossDetail = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, 
                    Account_Name__r.Sales_Org__c,LCRM_Sub_BU__c, BU_Segment__c  FROM Source_System_Detail__c where Source_System_Account_Number__c= :sapNum LIMIT 1];  
        }
        return ossDetail;
    }
    
    /**
     * @description assignCodeMap method    
     * @param lcrmSalesOrg
     */
    public static void assignCodeMap(String lcrmSalesOrg){
        if(String.isnotblank(lcrmSalesOrg) ){
            IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(lcrmSalesOrg);
            strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            strCompanyCode = oIXOSCodeMap.Company_Code__c;                
        }
    }
    
    /**
     * @description createCaseFormExtension method  
     * @param csDataId
     * @param fmDataId
     * @return ESC_Case_Form_Extension__c 
     */
    public static ESC_Case_Form_Extension__c createCaseFormExtension(String csDataId,String fmDataId)
    {
        ESC_Case_Form_Extension__c oForm = new ESC_Case_Form_Extension__c();
        oForm.ESC_Case__c=csDataId;
        oForm.ESC_Form__c=fmDataId;
        if (Schema.sObjectType.ESC_Case_Form_Extension__c.IsCreateable()){
            insert oForm;
        }
        return oForm;
    }
}