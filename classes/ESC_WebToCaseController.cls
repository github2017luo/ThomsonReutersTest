/**
 * @description ESC_WebToCaseController class
 */
public without sharing class ESC_WebToCaseController{
     public Case c; 
     public boolean displayform { get; set; }
     public string strfieldvalue {get;set;}
     Public String strFormName {get;set;}
     public string strBU{get;set;}
     public string title{get;set;}
     public Account acc {get;set;}
     public Map<string,List<ESC_WebToCaseFormNameFieldMapping__mdt>> webToCaseFieldsMap{get;set;}
     public Map<string,string> formNameValueMapping{get;set;}
     public List<ESC_WebToCaseFormNameFieldMapping__mdt> webToCaseFieldsLst{get;set;}
     public List<SelectOption> countryOptions {get;set;}
     public List<SelectOption> countryStateOptions {get;set;}
     public List<SelectOption> productDomainOptions {get;set;}
     public List<string> sectionLst{get;set;}
     Public String strlancode{get;set;}
     public String hostURL {get;set;}
     public string countryValue{get;set;}
     public String productDomainValue{get;set;}
     public string stateValue{get;set;}
      public String queueName;
      public string recordTypeName;
      public string buRegion;
      public string buSegment;
      public string businessHourName;
      public string productBrand;
      public string productTitle;
      public string subject;
     //Attachments Variables
    public boolean enableSection { get; set; }
    public id gcasid{get;set;}
    public string attention{get;set;}
    public Boolean isattach {get; set;} //render boolean for UploadDoc Page
    public String recid {get;set;} //Id of the attachment which has to be removed in UploadDoc Page
    public List<Attachment> att {get;set;}  //List of attachments displayed in UploadDoc Page  
    public List<Attachment> delatt {get;set;} //List of attachment to be removed/deleted in UpladDoc Page
    transient List<Attachment> attlist {get;set;}
    GGO_Static_Values__mdt buURLParam = [SELECT MasterLabel,GGO_Value__c from GGO_Static_Values__mdt where MasterLabel like 'WebForm_BU_URLParameters'];
    private static List<GGO_Static_Values__mdt> captchaConfig=[SELECT MasterLabel,GGO_Value__c,QualifiedApiName from GGO_Static_Values__mdt where MasterLabel='WebForm_reCAPTCHA'];
    
    @testvisible
    private static String privateKey{
        get { 
            if(captchaConfig.size()>0){
                for(GGO_Static_Values__mdt re:captchaConfig){
                    if(re.QualifiedApiName=='Secretkey'){
                        privateKey = String.valueOf(re.GGO_Value__c);
                    }
                }
            }
            else{
                 privateKey='';
            }
            return privateKey;
            }
            private set;
    }
     public String publicKey { 
        get { 
            if(captchaConfig.size()>0){
                for(GGO_Static_Values__mdt re:captchaConfig){
                    if(re.QualifiedApiName=='Sitekey'){
                        publicKey = String.valueOf(re.GGO_Value__c);
                    }
                }
            }
            else{
                 publicKey='';
            }
            return publicKey;
            }
            public set;
    } 
    /**
     * @description ESC_WebToCaseController  
     * @param stdController
     */
     public ESC_WebToCaseController(ApexPages.StandardController stdController){
        try{
            c = new Case();
            displayform = true;
            title= strFormName;
            strlancode='EN';
            strFormName = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('FormName').escapeHtml4());
            strBU= String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('BU').escapeHtml4());
            sectionLst= new List<string>();
            if(strFormName !=null && strFormName !=''){
                
                if(string.isNotBlank(strBU) && strBU =='USL'){
                if(strFormName =='billing-portal-request' && (Schema.sObjectType.ESC_WebToCaseFormNameFieldMapping__mdt.isAccessible() || Schema.sObjectType.ESC_WebToCaseFormNameFieldMapping__mdt.isQueryable())){
                 webToCaseFieldsLst =[SELECT DeveloperName,ESC_Business_Hour_Name__c,ESC_Product_Brand__c,ESC_Case_Subject__c,ESC_Product_Title__c,ESC_Field_Name__c,ESC_Section_Name__c,ESC_BU_Region__c,ESC_BU_Segment__c,ESC_Record_Type_Name__c,ESC_Form_Title__c,ESC_Queue_Name__c,ESC_Sequence__c,ESC_Field_Type__c,ESC_Form_Name__c,ESC_Required__c
                                     FROM ESC_WebToCaseFormNameFieldMapping__mdt WHERE ESC_Form_Name__c=:strFormName order by ESC_Form_Name__c,ESC_Sequence__c nulls last];                
                }
                else{
                    webToCaseFieldsLst =[SELECT DeveloperName,ESC_Business_Hour_Name__c,ESC_Product_Brand__c,ESC_Case_Subject__c,ESC_Product_Title__c,ESC_Field_Name__c,ESC_Section_Name__c,ESC_BU_Region__c,ESC_BU_Segment__c,ESC_Record_Type_Name__c,ESC_Form_Title__c,ESC_Queue_Name__c,ESC_Sequence__c,ESC_Field_Type__c,ESC_Form_Name__c,ESC_Required__c
                                     FROM ESC_WebToCaseFormNameFieldMapping__mdt WHERE ESC_Form_Name__c=:strFormName OR ESC_Form_Name__c='Aall' order by ESC_Form_Name__c,ESC_Sequence__c nulls last];
                 } 
                                 
                }
                else if(string.isNotBlank(strBU) && strBU =='IP'){
                     webToCaseFieldsLst =[SELECT DeveloperName,ESC_Business_Hour_Name__c,ESC_Product_Brand__c,ESC_Case_Subject__c,ESC_Product_Title__c,ESC_Field_Name__c,ESC_Section_Name__c,ESC_BU_Region__c,ESC_BU_Segment__c,ESC_Record_Type_Name__c,ESC_Form_Title__c,ESC_Queue_Name__c,ESC_Sequence__c,ESC_Field_Type__c,ESC_Form_Name__c,ESC_Required__c
                                     FROM ESC_WebToCaseFormNameFieldMapping__mdt WHERE ESC_Form_Name__c=:strFormName order by ESC_Form_Name__c,ESC_Sequence__c nulls last];
                }
                      if(string.isNotBlank(strBU)  && strBU=='Caselines')  {
                      webToCaseFieldsLst =[SELECT DeveloperName,ESC_Business_Hour_Name__c,ESC_Product_Brand__c,ESC_Case_Subject__c,ESC_Product_Title__c,ESC_Field_Name__c,ESC_Section_Name__c,ESC_BU_Region__c,ESC_BU_Segment__c,ESC_Record_Type_Name__c,ESC_Form_Title__c,ESC_Queue_Name__c,ESC_Sequence__c,ESC_Field_Type__c,ESC_Form_Name__c,ESC_Required__c
                                     FROM ESC_WebToCaseFormNameFieldMapping__mdt WHERE ESC_Form_Name__c=:strFormName order by ESC_Form_Name__c,ESC_Sequence__c nulls last];
                      
                      productDomainOptions =getPickLstValue();
                      }                      
            }
            system.debug(logginglevel.warn,'@@ webToCaseFieldsSectionLst  :' + webToCaseFieldsLst );
            hostURL = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/ESC_WebToCase?BU='+strBU+'FormName='+strFormName;
            this.countryOptions = listAvailableCountryOptions();
            this.countryStateOptions =listAvailableCountryStateOptions();
            if(webToCaseFieldsLst !=null && webToCaseFieldsLst.size() > 0){
            webToCaseFieldsMap = new Map<string,List<ESC_WebToCaseFormNameFieldMapping__mdt>>();
            formNameValueMapping = new Map<string,string>();
            List<selectOption> pick;
                for(ESC_WebToCaseFormNameFieldMapping__mdt mapFieldObj:webToCaseFieldsLst ){
                
                if(!mapFieldObj.ESC_Field_Type__c.equalsIgnoreCase('Picklist')){
                    formNameValueMapping.put(mapFieldObj.ESC_Field_name__c,'');
                }else{
                    pick =  new List<selectOption>();
                    formNameValueMapping.put(mapFieldObj.ESC_Field_name__c,'Select');
                    }
                if(mapFieldObj.ESC_Form_Title__c!=null && mapFieldObj.ESC_Form_Title__c!=''){
                    title = mapFieldObj.ESC_Form_Title__c;
                }
                    system.debug(logginglevel.warn,'queue is'+mapFieldObj.ESC_Queue_Name__c+'business hour'+mapFieldObj.ESC_Business_Hour_Name__c+'BU region'+mapFieldObj.ESC_BU_Region__c+'record type name'+mapFieldObj.ESC_Record_Type_Name__c);
                    if(mapFieldObj.ESC_Business_Hour_Name__c!=null && mapFieldObj.ESC_Business_Hour_Name__c!='' && ( mapFieldObj.ESC_Queue_Name__c!=null && mapFieldObj.ESC_Queue_Name__c!='') && (mapFieldObj.ESC_BU_Region__c!=null && mapFieldObj.ESC_BU_Region__c!='') &&  (mapFieldObj.ESC_Record_Type_Name__c!=null && mapFieldObj.ESC_Record_Type_Name__c!='')){
                        system.debug(logginglevel.warn,'inside');
                        queueName = mapFieldObj.ESC_Queue_Name__c;
                        buRegion= mapFieldObj.ESC_BU_Region__c;
                        recordTypeName = mapFIeldObj.ESC_Record_Type_Name__c;
                        businessHourName = mapFieldObj.ESC_Business_Hour_Name__c;
                        buSegment = mapFieldObj.ESC_BU_Segment__c;
                        productBrand = mapFieldObj.ESC_Product_Brand__c;
                        productTitle =mapFieldObj.ESC_Product_Title__c;
                        subject =mapFieldObj.ESC_Case_Subject__c;
                        
                    }
                   if(mapFieldObj.ESC_Section_Name__c==null || mapFieldObj.ESC_Section_Name__c==''){
                        if(!webToCaseFieldsMap.containsKey('None')){
                            webToCaseFieldsMap.put('None',new List<ESC_WebToCaseFormNameFieldMapping__mdt> {mapFieldObj} );
                        }else{
                            List<ESC_WebToCaseFormNameFieldMapping__mdt> webToCaseFieldsMapLst= webToCaseFieldsMap.get('None');
                            webToCaseFieldsMapLst.add(mapFieldObj);
                            webToCaseFieldsMap.put('None',webToCaseFieldsMapLst);
                        }
                        
                        
                    }else{
                        if(!webToCaseFieldsMap.containsKey(mapFieldObj.ESC_Section_Name__c)){
                            webToCaseFieldsMap.put(mapFieldObj.ESC_Section_Name__c,new List<ESC_WebToCaseFormNameFieldMapping__mdt> {mapFieldObj});
                        }else{
                        
                            List<ESC_WebToCaseFormNameFieldMapping__mdt> webToCaseFieldsMapLst= webToCaseFieldsMap.get(mapFieldObj.ESC_Section_Name__c);
                            webToCaseFieldsMapLst.add(mapFieldObj);
                            webToCaseFieldsMap.put(mapFieldObj.ESC_Section_Name__c,webToCaseFieldsMapLst);
                        }
                    }
                    
                }
            }
            if(!webToCaseFieldsMap.isEmpty()){
            for(string sectionName:webToCaseFieldsMap.keyset()){
                sectionLst.add(sectionName);
            }
            }
        }catch(Exception ex){
         system.debug(logginglevel.warn,'exception--->'+ex);
        }
       
    }
    /**
     * @description reCAPTCHASucess  
     */
    public void reCAPTCHASucess(){
        submitCase();
    }
    /**
     * @description submitCase  
     * @return pagereference
     */   
    public pagereference submitCase(){
    try{
        List<List<ESC_WebToCaseFormNameFieldMapping__mdt>> formDataLst  = new List<List<ESC_WebToCaseFormNameFieldMapping__mdt>>();
        Map<string,string> fieldValueMap = new Map<string,string>();
        BusinessHours bh = new BusinessHours();
        RecordType rt ;
        string description;
       QueueSobject q = new QueueSobject();                       
        system.debug(logginglevel.warn,'@@ formNameValueMapping :' + formNameValueMapping);
         formDataLst = webToCaseFieldsMap.values();
            for(List<ESC_WebToCaseFormNameFieldMapping__mdt> formData1:formDataLst ){
                for(ESC_WebToCaseFormNameFieldMapping__mdt formData2:formData1){
                    system.debug(logginglevel.warn,'@@ mandatory fields :' + formData2.ESC_Required__c + formData2.ESC_Field_Name__c + formNameValueMapping.get(formData2.ESC_Field_Name__c) + countryValue + stateValue);
                    if((formData2.ESC_Field_name__c.equalsIgnoreCase('Country/region') || formData2.ESC_Field_name__c.equalsIgnoreCase('State/province')) && (countryValue==null || stateValue==null)){
                        throw new ESC_HandlerCustomException('Mandatory Fields');
                    }
                        
                     if((formData2.ESC_Field_name__c.equalsIgnoreCase('Company Code') || formData2.ESC_Field_name__c.equalsIgnoreCase('Account Billing Type') || formData2.ESC_Field_name__c.equalsIgnoreCase('Account AR Aging') || formData2.ESC_Field_name__c.equalsIgnoreCase('Contract/Subscription Amount') || formData2.ESC_Field_name__c.equalsIgnoreCase('Contract Period') || formData2.ESC_Field_name__c.equalsIgnoreCase('Billing Frequency') || formData2.ESC_Field_name__c.equalsIgnoreCase('Portal Vendor') || formData2.ESC_Field_name__c.equalsIgnoreCase('Portal Submission Type')) && formData2.ESC_Required__c && (companycode == null || accountBillingType == null || accountARAging == null || contractSubscriptionAmount == null || contractPeriod == null || billingFrequency == null || portalVendor == null || portalSubmissionType == null)){
                        system.debug(logginglevel.warn,'@@ mandatory fields 1:' + formNameValueMapping.get(formData2.ESC_Field_Name__c));      
                        throw new ESC_HandlerCustomException('Mandatory Fields');
                    }
                    if(formData2.ESC_Required__c && (formNameValueMapping.get(formData2.ESC_Field_Name__c) ==null ||formNameValueMapping.get(formData2.ESC_Field_Name__c) =='')){
                    system.debug(logginglevel.warn,'@@ mandatory fields :' + formData2.ESC_Field_Name__c);          
                        throw new ESC_HandlerCustomException('Mandatory Fields');
                        //return null;
                    }else if(!formData2.ESC_Field_Type__c.equalsIgnoreCase('OutputText')){
                        if(formData2.ESC_Field_name__c.equalsIgnoreCase('Country/region')){
                            formNameValueMapping.put(formData2.ESC_Field_Name__c,countryValue);
                        }else if(formData2.ESC_Field_name__c.equalsIgnoreCase('State/province')){
                            formNameValueMapping.put(formData2.ESC_Field_Name__c,stateValue);
                        }
                            fieldValueMap.put(formData2.ESC_Field_name__c,formNameValueMapping.get(formData2.ESC_Field_Name__c));
                        if(strFormName != 'billing-portal-request'){
                        description += formData2.ESC_Field_name__c +                            +': '+  formNameValueMapping.get(formData2.ESC_Field_Name__c)              +'; '+'\n';
                        }
                        else{
                            if(formData2.ESC_Field_Type__c != 'Picklist'){
                         description += formData2.ESC_Field_name__c +                             +': '+  formNameValueMapping.get(formData2.ESC_Field_Name__c)         +'; '+'\n'; 
                            }
                            else if(formData2.ESC_Field_name__c == 'Company Code'){
                            description += formData2.ESC_Field_name__c +                                +': '+       companycode         +'; '+'\n';
                            }
                            else if(formData2.ESC_Field_name__c == 'Account Billing Type'){
                            description += formData2.ESC_Field_name__c +                                +': '+       accountBillingType         +'; '+'\n';
                            }
                            else if(formData2.ESC_Field_name__c == 'Account AR Aging'){
                            description += formData2.ESC_Field_name__c +                                +': '+       accountARAging         +'; '+'\n';
                            }
                            else if(formData2.ESC_Field_name__c == 'Contract/Subscription Amount'){
                            description += formData2.ESC_Field_name__c +                                +': '+       contractSubscriptionAmount         +'; '+'\n';
                            }
                            else if(formData2.ESC_Field_name__c == 'Contract Period'){
                            description += formData2.ESC_Field_name__c +                                +': '+       contractPeriod         +'; '+'\n';
                            }
                            else if(formData2.ESC_Field_name__c == 'Billing Frequency'){
                            description += formData2.ESC_Field_name__c +                                +': '+       billingFrequency         +'; '+'\n';
                            }
                            else if(formData2.ESC_Field_name__c == 'Portal Vendor'){
                            description += formData2.ESC_Field_name__c +                                +': '+       portalVendor         +'; '+'\n';
                            }
                            else if(formData2.ESC_Field_name__c == 'Portal Submission Type'){
                            description += formData2.ESC_Field_name__c +                                +': '+       portalSubmissionType         +'; '+'\n';
                            }
                        }
                    }
                }
            }
            description= description.remove('null');
            system.debug(logginglevel.warn,'@@ fieldValueMap : ' + fieldValueMap);
            if(!fieldValueMap.isEmpty()){
                c.ESC_Origin_Name__c=hostURL;
                    c.Origin = 'Web';
                    c.status='New';
                    c.LCRM_Sub_BU__c=buRegion;
                    c.BU_Segment__c = buSegment;
                    c.ESC_Product_Segment_Brand__c = productBrand;
                    c.ESC_Product_Title__c = productTitle;
                    c.ESC_Case_Type__c = recordTypeName;
                    if(strBU !='Caselines'){
                    if(strFormName == 'billing-portal-request'){
                        c.SuppliedEmail =formNameValueMapping.get('Primary Contact E-mail');
                        c.Priority = 'Medium';
                    }
                    else{
                    c.SuppliedEmail =formNameValueMapping.get('Email Address');
                    c.Subject = subject ;
                    }
                    }else{
                    c.SuppliedEmail = formNameValueMapping.get('Contact Email');
                    c.Subject = formNameValueMapping.get('Subject');
                    c.ESC_Product_Domain__c = productDomainValue;
                    c.ESC_Unique_Identifier__c = 'Caselines-Web';
                    description +='Product Domain' +                                +': '+  productDomainValue              +'; '+'\n';
                    }
                    c.Sales_Org__c = 'GLI';
                    c.Is_GLI__c = true;
                    c.Description =description.substringBeforeLast(';');
                    if(recordTypeName !=null && recordTypeName !='' && (Schema.sObjectType.RecordType.isAccessible() || Schema.sObjectType.RecordType.isQueryable())){
                        rt = [select Id from RecordType where Name = :recordTypeName and SobjectType = 'Case' limit 1];
                    }
                    if(rt!=null){
                        c.RecordTypeId = rt.Id;
                    }
                    if(businessHourName!=null && (Schema.sObjectType.BusinessHours.isAccessible() || Schema.sObjectType.BusinessHours.isQueryable())){
                        bh = [SELECT Id FROM BusinessHours WHERE Name=:businessHourName];
                    }
                    if(bh!=null){
                        c.BusinessHoursId=bh.Id;
                    }
                    if(queueName!=null && (Schema.sObjectType.QueueSobject.isAccessible() || Schema.sObjectType.QueueSobject.isQueryable())){
                         q = [Select Id, Queue.Name, Queue.ID from QueueSobject  where  Queue.Name =: queueName LIMIT 1]; 
                    }
                    system.debug(logginglevel.warn,'@@ queue : ' + q );
                    if(q!=null){
                         c.ownerid =  q.Queue.ID;     
                    }
                    system.debug(logginglevel.warn,'@@ case : ' + c);
                        Database.DMLOptions dmo = new Database.DMLOptions();
                         dmo.assignmentRuleHeader.useDefaultRule = false;
                         dmo.EmailHeader.triggerAutoResponseEmail = true; 
                        Database.SaveResult sr =  Database.insert(c, dmo);
                    gcasid=c.id;
                    if (!sr.isSuccess()) {
                        string message ='';
                        for(Database.Error err : sr.getErrors()) {
                            message += err.getStatusCode() + ': ' + err.getMessage()+'  ||  ';
                        }
                        if(message.containsIgnoreCase('INVALID_EMAIL_ADDRESS')){
                            throw new ESC_HandlerCustomException('INVALID_EMAIL_ADDRESS');
                        }else{
                            throw new ESC_HandlerCustomException('DMLFailed '+message);
                        }  
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,message));
                    }

                    displayform = false;
                    enableSection=true;
                    
            }
    }catch(ESC_HandlerCustomException ex){
        if(ex.getMessage().equalsIgnoreCase('Mandatory Fields')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.ESC_MandatoryFields));
                return null;
        }else if(ex.getMessage().equalsIgnoreCase('INVALID_EMAIL_ADDRESS')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.ESC_InvalidEmailMsg));
                return null;
        }
        else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'General Error'+ex.getMessage()));
        }
    }
        return null;
    }
    //start here    
    /**
     * @description attachment  
     * @return Attachment
     */
    public Attachment attachment {
        get {
            if (attachment == null){
                attachment = new Attachment();
            }
            return attachment;
        }
        set;
    }  
    /**
     * @description attachfile  
     * @return pagereference
     */            
    public PageReference attachfile() {
        if(attachment.name==null || attachment.name=='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,Label.GGO_WebForm_BlankAttachmentName));
        } 
        if(Schema.sObjectType.Attachment.isAccessible() || Schema.sObjectType.Attachment.isQueryable()){
        attlist=[SELECT Id,Name,OwnerId,IsPrivate,Body,Description FROM Attachment where ParentId =:gcasid ];
        }
        
        if(attlist.size()>=3)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,Label.GGO_WebForm_Attachment_FilesLimitation));
        }
        else
        {  
            if(attachment.BodyLength >0 || Test.isRunningtest())
            {
                attachment.OwnerId = UserInfo.getUserId();
                attachment.ParentId =gcasid ;   
                try {  
                    if(attachment.BodyLength >= 5242880) { 
                        System.debug(logginglevel.warn,' size > 5mb');       
                        // throw new CustomException('File size is larger than 5 MB');
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.GGO_WebForm_FileSize_Warning+attachment.BodyLength));
                        
                    } else{
                        if (Schema.sObjectType.Attachment.isCreateable()){
                        insert attachment;
                        }
                        system.debug(logginglevel.warn,'attachmentattachment'+attachment);
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, attachment.name + Label.GGO_WebForm_Attahment_Success+attachment.BodyLength));
                         isattach = true;
                    }
                }catch (DMLException e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, e.getMessage()));
                    return null;
                } finally {
                    attachment = new Attachment(); 
                }
                isattach = true;      
            }  
            
            att= new list<Attachment>();
            att= [SELECT Id,Name,Body,parentid FROM Attachment where parentId=:gcasid];
            system.debug(logginglevel.warn,'attachment :' + att);
        }   
        return null;
    }
    /**
     * @description removeattachment  
     * @return pagereference
     */ 
    public PageReference removeattachment() {
        //List the attachment which needs to be deleted
        delatt= new list<Attachment>();
        if (Schema.sObjectType.Attachment.isAccessible() || Schema.sObjectType.Attachment.isQueryable() ){
        delatt= [SELECT Id,Name,OwnerId,IsPrivate,Body,Description FROM Attachment where Id=:recid];
        }
        if (Schema.sObjectType.Attachment.isDeletable()){
        delete delatt;
        }
        //Diplay the list of attachments in the pageblocktable section of UploadDoc Page
        att= new list<Attachment>();
        att= [SELECT Id,Name,Description,BodyLength FROM Attachment where parentId=:gcasid];
        if(att.size()==0)
        {
            isattach = false; 
        }
        return null;
    } 
    /**
     * @description submitWithAttachment  
     * @return pagereference
     */ 
    Public pagereference submitWithAttachment()
    {
        system.debug(logginglevel.warn,'gcasid'+gcasid);
        try{
        case c1 = new case();
        if(Schema.sObjectType.case.isAccessible() || Schema.sObjectType.case.isQueryable()){
         c1=[select casenumber,id from case where id=:gcasid];
        }
        List<ContentDocumentLink> att1 = new List<ContentDocumentLink>();
        if(Schema.sObjectType.ContentDocumentLink.isAccessible() || Schema.sObjectType.ContentDocumentLink.isQueryable()){
        att1=[SELECT LinkedEntityId,id FROM ContentDocumentLink where LinkedEntityId =:gcasid];
        }
        
        system.debug(logginglevel.warn,'22 attachment size: ' + att1.size());
        if(att1.size()>0)
        {
            displayform=false;
            enableSection=false;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GGO_WebForm_Case_Success +' '+ c1.CaseNumber +'.  '+ att1.size() + ' '+Label.GGO_WebForm_CaseWattachments_Success));
            return null;    
        }
        else {
            displayform=false;
            enableSection=false;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GGO_WebForm_Case_Success +' '+ c1.CaseNumber +'.  '+Label.GGO_WebForm_CaseWOattachments_Success));
            return null;
        }
        //displayform=false;
        //enableSection=false;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'submitWithAttachment gcasid error'+gcasid));
        }
        return null;
    }
    //End here
    
    /**
     * @description listAvailableCountryOptions  
     * @return List<SelectOption>
     */ 
    public static List<SelectOption> listAvailableCountryOptions(){
        List<SelectOption> listCountryOptions = new List<SelectOption>();
        //Add Default Option
        listCountryOptions.add(new SelectOption('', 'Select'));
        //Add Available Options
        List<Country__c> lstCountry = New List<Country__c>(Country__c.getAll().values());
        lstCountry.sort();
        //for (Country__c oCountry : [SELECT Name, Country_Code__c FROM Country__c WHERE IsActive__c = true ORDER BY Country_Code__c]) {
        for(Country__c oCountry: lstCountry){
            //string sValue = oCountry.Country_Code__c;
            //string sLabel = sValue + ' - ' + oCountry.Name;            
            listCountryOptions.add(new SelectOption(oCountry.Name, oCountry.Name));
        }
        lstCountry.clear();
        return listCountryOptions;
    }
    /**
     * @description listAvailableCountryStateOptions  
     * @return List<SelectOption>
     */ 
    public static List<SelectOption> listAvailableCountryStateOptions(){
        List<SelectOption> listStateOptions = new List<SelectOption>();
        //Add Default Option
        listStateOptions.add(new SelectOption('', 'Select'));
        listStateOptions.add(new SelectOption('Not Applicable', 'Not Applicable'));
        //Add Available Options
        List<ESC_States__c> lstState = New List<ESC_States__c>(ESC_States__c.getAll().values());
        lstState.sort();
        //for (Country__c oCountry : [SELECT Name, Country_Code__c FROM Country__c WHERE IsActive__c = true ORDER BY Country_Code__c]) {
        for(ESC_States__c oState: lstState){
            //string sValue = oCountry.Country_Code__c;
            //string sLabel = sValue + ' - ' + oCountry.Name;            
            listStateOptions.add(new SelectOption(oState.Name, oState.Name));
        }
        lstState.clear();
        return listStateOptions;
    }   
    /**
     * @description getPickLstValue  
     * @return List<SelectOption>
     */ 
     public List<SelectOption> getPickLstValue()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            Schema.DescribeFieldResult fieldResult = Case.ESC_Product_Domain__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry f : ple)
            {
                if(f.getValue() != 'New Instance Required')
                {
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            } 
            return options;           
        }
          
    /**
     * @description getPickValue  
     * @return List<SelectOption>
     */ 
     
      public String companycode {get;set;}
      public String accountBillingType {get;set;}
      public String billingFrequency {get;set;}
      public String accountARAging {get;set;}
      public String contractSubscriptionAmount {get;set;}
      public String contractPeriod{get;set;}
      public String portalVendor{get;set;}
      public String portalSubmissionType {get;set;}  
      /**
     * @description getcompanycodes  
     * @return List<SelectOption>
     */
     public List<SelectOption> getcompanycodes()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('0150 - CAD Legal', '0150 - CAD Legal')); 
            options.add(new SelectOption('1078 - TRTA UK', '1078 - TRTA UK'));
            options.add(new SelectOption('1079 - TRTA US', '1079 - TRTA US'));
            options.add(new SelectOption('0010 - LEGAL US', '0010 - LEGAL US'));
            options.add(new SelectOption('3101 - LEGAL UK', '3101 - LEGAL UK'));
            options.add(new SelectOption('3639 - IRELAND UK', '3639 - IRELAND UK'));
            options.add(new SelectOption('5008 - ANZ', '5008 - ANZ'));
            options.add(new SelectOption('KS - Knowledge Solutions', 'KS - Knowledge Solutions'));
            options.add(new SelectOption('Other (specify in comments)', 'Other (specify in comments)'));
            return options;           
        }
        /**
     * @description getAccountBillingTypes  
     * @return List<SelectOption>
     */
        public List<SelectOption> getAccountBillingTypes()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('Strategic Account', 'Strategic Account')); 
            options.add(new SelectOption('Key Account', 'Key Account'));
            options.add(new SelectOption('State Government', 'State Government'));
            options.add(new SelectOption('PILOT (west only)', 'PILOT (west only)'));
            return options;           
        }
        /**
     * @description getBillingFrequencys  
     * @return List<SelectOption>
     */
         public List<SelectOption> getBillingFrequencys()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('Monthly', 'Monthly')); 
            options.add(new SelectOption('Quarterly', 'Quarterly'));
            options.add(new SelectOption('Annually', 'Annually'));
            options.add(new SelectOption('Other (specify in comments)', 'Other (specify in comments)'));
            return options;           
        }
        /**
     * @description getAccountARAgings  
     * @return List<SelectOption>
     */
        public List<SelectOption> getAccountARAgings()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('Current', 'Current')); 
            options.add(new SelectOption('1-29 Days', '1-29 Days'));
            options.add(new SelectOption('30 + Days', '30 + Days'));
            options.add(new SelectOption('60 + Days', '60 + Days'));
            options.add(new SelectOption('90 + Days', '90 + Days'));
            options.add(new SelectOption('120 + Days', '120 + Days'));
            options.add(new SelectOption('1 year +', '1 year +'));
            options.add(new SelectOption('2 years +', '2 years +'));
            options.add(new SelectOption('3 years +', '3 years +'));
            return options;           
        }
        /**
     * @description getContractSubscriptionAmounts  
     * @return List<SelectOption>
     */
         public List<SelectOption> getContractSubscriptionAmounts()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('$1k - $25k', '$1k - $25k')); 
            options.add(new SelectOption('$26k - $50k', '$26k - $50k'));
            options.add(new SelectOption('$51k - $75k', '$51k - $75k'));
            options.add(new SelectOption('$76k - $100k', '$76k - $100k'));
            options.add(new SelectOption('$101k +', '$101k +'));
            return options;           
        }
        /**
     * @description getContractPeriods  
     * @return List<SelectOption>
     */
         public List<SelectOption> getContractPeriods()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('1 Year', '1 Year')); 
            options.add(new SelectOption('2 Years', '2 Years'));
            options.add(new SelectOption('3 Years', '3 Years'));
            return options;           
        }
        /**
     * @description getPortalVendors  
     * @return List<SelectOption>
     */
        public List<SelectOption> getPortalVendors()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('Ariba Light', 'Ariba Light')); 
            options.add(new SelectOption('Coupa Supplier', 'Coupa Supplier'));
            options.add(new SelectOption('Legal Tracker', 'Legal Tracker')); 
            options.add(new SelectOption('Taulia', 'Taulia')); 
            options.add(new SelectOption('Tungsten', 'Tungsten')); 
            options.add(new SelectOption('CounselGo', 'CounselGo')); 
            options.add(new SelectOption('Other (specify)', 'Other (specify)')); 
            return options;           
        }
        /**
     * @description getPortalSubmissionTypes  
     * @return List<SelectOption>
     */
        public List<SelectOption> getPortalSubmissionTypes()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select'));
            options.add(new SelectOption('Purchase Order', 'Purchase Order')); 
            options.add(new SelectOption('Contract', 'Contract'));
            options.add(new SelectOption('Standard ', 'Standard '));
            options.add(new SelectOption('Order ID', 'Order ID'));
            options.add(new SelectOption('Project Number', 'Project Number'));
            options.add(new SelectOption('Other (specify in comments)', 'Other (specify in comments)'));
            return options;           
        }
}