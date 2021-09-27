/**
* CHANGE HISTORY
* ============================================================================================================================
* Date         Name                JIRA          Description
* ============================================================================================================================
* 
* 2017-08-02   Yugender Ch         GGD-288     1.As a Customer, I need to be able to submit requests through a websites that 
*                                                support various countries, so that Argentina and Brazil clients can submit 
*                                                web to case requests.
*                                  GGD-475     2.User should be able to create a case with a single "Submit" action
*                                  GGD-439     3.All the Fields on the web form should have a help text, so that the customers 
*                                                can easily understand the need and provide accurate information.
*                                  GGD-475     4.User should be able to create a case with a single action
*                                  GGD-483     5.As a Customer, I need the ability to attach multiple documents, so that I can 
*                                                attach multiple documents providing agents the information the needed information 
*                                                to help resolve my issue.
*                                  GGD-333     6.Thomson Reuters branding and styling of the webform.  
*                                  GGD-576     7.For Bejerman Webform, the main website to be able to pass Company name, contact name, 
*                                               Description,tax number Type and Tax number as parameters to the webforms.
* 
* ============================================================================================================================
*/
public without sharing class GGO_WebtoCaseController {
    public Case c { get; set; }    
    public String acctNum { get; set; }
    public boolean displayform { get; set; }
    public String countryCodeOwnerQueue { get; set; }
    Public String strsource {get;set;}
    Public String strlancode{get;set;}
    Public String strreCAPTCHAlancode{get;set;}
    public String hostURL {get;set;}
    public String taxNumberType {get;set;}
    public String taxNumber {get;set;}
    public String phNumber {get;set;}
    Public String strBU {get;set;}
    public string qcaseRecType {get;set;}
    public string strPrd {get;set;}
    public string cName {get;set;}
    public string conName {get;set;}
    public string caseDesc {get;set;}
    public string selprodLabel {get;set;}
    public String queueName {get;set;}
    public String inquiry{get;set;}
    Public Boolean isBejerman {get;set;}
    public GGO_Static_Values__mdt sobjProdLabel;
    //Attachments Variables
    public boolean enableSection { get; set; }
    public id gcasid{get;set;}
    public Boolean isattach {get; set;} //render boolean for UploadDoc Page
    public String recid {get;set;} //Id of the attachment which has to be removed in UploadDoc Page
    public List<Attachment> att {get;set;}  //List of attachments displayed in UploadDoc Page  
    public List<Attachment> delatt {get;set;} //List of attachment to be removed/deleted in UpladDoc Page
    transient List<Attachment> attlist {get;set;}
    GGO_Static_Values__mdt buURLParam = [SELECT MasterLabel,GGO_Value__c from GGO_Static_Values__mdt where MasterLabel like 'WebForm_BU_URLParameters'];
    private static List<GGO_Static_Values__mdt> captchaConfig=[SELECT MasterLabel,GGO_Value__c,QualifiedApiName from GGO_Static_Values__mdt where MasterLabel='WebForm_reCAPTCHA'];
     
    @TestVisible private static String privateKey{
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
    
    public GGO_WebtoCaseController(ApexPages.StandardController stdController){
        c = new Case();
        displayform = true;
        strsource = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('source').escapeHtml4());
        strBU = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('BU').escapeHtml4());
        if(apexpages.currentpage().getparameters().get('Queue') != null){
            queueName = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('Queue').escapeHtml4());
        }
        isBejerman = false;
        System.debug('queuename:='+queueName);
        
        if(buURLParam !=null && strsource !=null && strBU !=null && (buURLParam.GGO_Value__c.startsWith(strBU) || buURLParam.GGO_Value__c.containsIgnoreCase(', '+strBU+',') || buURLParam.GGO_Value__c.endswith(strBU)) && strsource == 'AR' )
        {
                    isBejerman = true;
                    if(queueName==null)
                    {
                        if(apexpages.currentpage().getparameters().get('conName') != null){
                            c.SuppliedName = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('conName').escapeHtml4());
                        }
                        if(apexpages.currentpage().getparameters().get('email') != null){
                            c.SuppliedEmail = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('email').escapeHtml4());
                        }
                        if(apexpages.currentpage().getparameters().get('phNumber') != null){
                            phNumber = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('phNumber').escapeHtml4());
                        }
                        if(apexpages.currentpage().getparameters().get('pComplement') != null){
                            c.GGO_Product_Complement__c = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('pComplement').escapeHtml4());
                        }
                        if(apexpages.currentpage().getparameters().get('product') != null){
                            c.Product__c = String.escapeSingleQuotes(apexpages.currentPage().getparameters().get('product').escapeHtml4());
                        }
                        if(apexpages.currentpage().getparameters().get('qcaseRecType') != null){
                            qcaseRecType= String.escapeSingleQuotes(apexpages.currentPage().getparameters().get('qcaseRecType').escapeHtml4());
                        }
                        if(apexpages.currentpage().getparameters().get('caseDesc') != null){
                            inquiry = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('caseDesc').escapeHtml4());
                        }
                    }
                    if(apexpages.currentpage().getparameters().get('cName') != null){
                        c.SuppliedCompany = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('cName').escapeHtml4());
                    }
                    if(apexpages.currentpage().getparameters().get('taxNumberType') != null){
                        taxNumberType = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('taxNumberType').escapeHtml4());
                    }
                    if(apexpages.currentpage().getparameters().get('taxNumber') != null){
                         taxNumber = String.escapeSingleQuotes(apexpages.currentpage().getparameters().get('taxNumber').escapeHtml4());
                    }
         }
        
        if(strsource == 'AR' || strsource == 'PY'  || strsource == 'UR'  || strsource == 'Ch'|| strsource == 'MX'){
            strlancode = 'ES';strreCAPTCHAlancode = 'ES';
        }
        else if(strsource == 'BR'){
            strlancode = 'pt_BR';strreCAPTCHAlancode = 'pt-BR';
        }
        else if(strsource == ''){
            strlancode = 'EN';strreCAPTCHAlancode = 'EN';
        }
        
        //to capture exact url accessed
        //hostURL=URL.getCurrentRequestUrl().toExternalForm();
        //hostURL ='/apex/GGO_VFP_Web2Case?Source='+strsource+'&BU='+strBU;
        //hostURL = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + ApexPages.currentPage().getUrl();
        hostURL = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/GGO_VFP_Web2Case?Source='+strsource+'&BU='+strBU;
    }
    
    
    //start here
    public Attachment attachment {
        get {
            if (attachment == null){
                attachment = new Attachment();
            }
            return attachment;
        }
        set;
    }
           
    
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
            if(attachment.BodyLength >0)
            {
                attachment.OwnerId = UserInfo.getUserId();
                attachment.ParentId =gcasid ;   
                try {  
                    if(attachment.BodyLength >= 5242880) { 
                        System.debug(' size > 5mb');       
                        // throw new CustomException('File size is larger than 5 MB');
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.GGO_WebForm_FileSize_Warning+attachment.BodyLength));
                        
                    } else{
                        if (Schema.sObjectType.Attachment.isCreateable()){
                        insert attachment;
                        }
                        system.debug('attachmentattachment'+attachment);
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
            att= [SELECT Id,Name,Body FROM Attachment where parentId=:gcasid];
        }   
        return null;
    }
    
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
    
    Public pagereference submitWithAttachment()
    {
        system.debug('gcasid'+gcasid);
        try{
        attlist=[SELECT Id,Name,OwnerId,IsPrivate,Body,Description FROM Attachment where ParentId =:gcasid ];
        case c1 = new case();
        if(Schema.sObjectType.case.isAccessible() || Schema.sObjectType.case.isQueryable()){
         c1=[select casenumber,id from case where id=:gcasid];
        }
        if(attlist.size()>0)
        {
            displayform=false;
            enableSection=false;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,Label.GGO_WebForm_Case_Success +' '+ c1.CaseNumber +'.  '+ attlist.size() + ' '+Label.GGO_WebForm_CaseWattachments_Success));
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
    
    public void reCAPTCHASucess(){
        submitCase();
    }
    
    public List<SelectOption> getTaxTypes()
    {
        List<SelectOption> options = new List<SelectOption>();
        List<GGO_Static_Values__mdt> caseTaxtype=[SELECT MasterLabel,GGO_Value__c,Sequence__c from GGO_Static_Values__mdt where MasterLabel='WebForm_TaxType' order by Sequence__c asc];
        system.debug('caseTaxtype@@@'+caseTaxtype.size());
        Set<String> taxtypeSet = new Set<String>();
        if(caseTaxtype.size()>0){
            taxtypeSet.add('--None--');
            for(GGO_Static_Values__mdt val: caseTaxtype){
                taxtypeSet.add(val.GGO_Value__c);
            }
        }
        for (String s: taxtypeSet)
        {
            system.debug(s);
            options.add(new SelectOption(s,s));
        }
        return options;
    }
    
    //Radio Button - Start
    public String caseRecType;
    
    public String getcaseRecType()
    {
        return caseRecType;
    }
    
    public void setcaseRecType(String caseRecType)
    {
        this.caseRecType = caseRecType;
    }
    private string getValueFromLabel(string customLabelName){
        
        
        if(string.isBlank(customLabelName)){
            return '';
        }
        
        else{
            try{
                Component.Apex.OutputText output = new Component.Apex.OutputText();
                output.expressions.value = '{!$Label.' + customLabelName + '}';
                return String.valueOf(output.value);
            }
            
            catch(exception ex){
                return '';
            }
        }
        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        
        List<GGO_Static_Values__mdt> queRadio=[SELECT MasterLabel,RecordTypeName__c,GGO_Value__c,GGO_Custom_Label_Name__c,Sequence__c from GGO_Static_Values__mdt where MasterLabel='WebForm_Question' order by Sequence__c asc];
        
        if(queRadio.size()>0){
            for(GGO_Static_Values__mdt r:queRadio){
                if(r.GGO_Custom_Label_Name__c!=null){
                    options.add(new SelectOption(r.GGO_Value__c,getValueFromLabel(r.GGO_Custom_Label_Name__c)));
                }
                else{
                    options.add(new SelectOption(r.GGO_Value__c,r.GGO_Value__c));
                }
            }
        }
        return options;
    }
    //Radio Button - End
    
    public List<SelectOption> getProductlist()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        List<GGO_Static_Values__mdt> caseProducts=[SELECT MasterLabel,GGO_Value__c,RecordTypeName__c,GGO_Custom_Label_Name__c from GGO_Static_Values__mdt where MasterLabel='WebForm_Product'];
        Set<String> productSet = new Set<String>();
        if(caseProducts.size()>0){
           if(isBejerman){
                options.add(new SelectOption('--None--',System.Label.GGO_WebForm_NoneValue));
            }
            else{
                options.add(new SelectOption('--None--','--None--'));
            }
            for(GGO_Static_Values__mdt val: caseProducts){
                if(strBU!=null && strBU!=''){
                    
                    if(val.RecordTypeName__c!=null && (val.RecordTypeName__c.startsWith(strBU) || val.RecordTypeName__c.containsIgnoreCase(', '+strBU+',') || val.RecordTypeName__c.endswith(strBU))){
                        if(val.GGO_Custom_Label_Name__c!=null){
                            options.add(new SelectOption(val.GGO_Value__c,getValueFromLabel(val.GGO_Custom_Label_Name__c)));
                        }
                        else{
                            options.add(new SelectOption(val.GGO_Value__c,val.GGO_Value__c));
                        }  
                    }
                }
            }
            options.sort();
        }
        /*
        for (String s: productSet)
        {
            system.debug(s);
            options.add(new SelectOption(s,s));
        }*/
        return options;
    }
    
    public pagereference submitCase(){
        try{
            //Tax number validation
             String tipo;
             String nro;
            
            if(taxNumberType==null||taxNumberType=='')
            {
                 tipo = '--None--';
            }
             else
             {
                 tipo = taxNumberType;
             }
             if(taxNumber==null||taxNumber=='')
            {
                 nro = '';
            }
             else
             {
                 nro = taxNumber;
             }
               
            string billcon ='Argentina';
            
            Pattern p = Pattern.compile( '([a-zA-Z0-9_\\-\\.\\+]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
           Matcher m = p.matcher(c.SuppliedEmail);
           Pattern p1 = Pattern.compile( '[0-9+\\-\\(\\)\\s]*');
           Matcher m1 = p1.matcher(phNumber);
            boolean blnValid  = true;
            if(tipo != null && nro != null) {
                if(tipo.equalsIgnoreCase('CPF'))
                {
                    blnValid  = Tax_Number_Validator.isValid_CPF(nro);
                }   
                else if(tipo.equalsIgnoreCase('CNPJ'))
                {
                    blnValid  = Tax_Number_Validator.isValid_CNPJ(nro);
                }   
                else if(tipo.equalsIgnoreCase('C.U.I.T.'))
                {
                    blnValid  = Tax_Number_Validator.isValid_CUIT(nro,billcon);
                }   
                /*  else
                if(tipo.equalsIgnoreCase('C.I.')||tipo.equalsIgnoreCase('PASAPORTE'))
                blnValid  = Tax_Number_Validator.isValid_CI(nro );*/
                else if(tipo.equalsIgnoreCase('C.U.I.L.'))
                {               
                    blnValid  = Tax_Number_Validator.isValid_CUILCDI(nro);
                }   
                system.debug(logginglevel.info, '>>> Is Valid? ' + blnValid );
                
                
                if(qcaseRecType == '' || qcaseRecType == null)
                {
                    throw new ESC_HandlerCustomException('UnselectedQuestion');
                    return null;
                }   
                else if(taxNumberType == '--None--')
                {
                    throw new ESC_HandlerCustomException('EmptyTaxtype');return null;
                }   
                else if(taxNumber == '' || taxNumber == null)
                {
                    throw new ESC_HandlerCustomException('EmptyTaxNumber');return null;
                }   
                else if(!blnValid)
                {
                    throw new ESC_HandlerCustomException('InvalidTaxNumber');
                    return null;
                }   
                else if(c.SuppliedEmail  == '' || qcaseRecType == null )
                {
                    throw new ESC_HandlerCustomException('Emptyemail');return null;
                }  
                else if(!m.matches())
                {
                    throw new ESC_HandlerCustomException('incorrectemailaddress');return null;
                }   
                else if(!m1.matches())
                {
                    throw new ESC_HandlerCustomException('incorrectphonenumber');return null;
                } 
                else if(inquiry == '' || c.Description == '' || qcaseRecType == null)
                {
                    throw new ESC_HandlerCustomException('EmptyDescription');return null;
                }   
                else 
                {
                    BusinessHours bh = new BusinessHours();
                    GGO_Static_Values__mdt sobjBusinesshrsName = new  GGO_Static_Values__mdt();
                    GGO_Static_Values__mdt sobjCaseType = new  GGO_Static_Values__mdt();
                    if(Schema.sObjectType.GGO_Static_Values__mdt.isAccessible() || Schema.sObjectType.GGO_Static_Values__mdt.isQueryable()){
                    sobjCaseType =[SELECT MasterLabel,GGO_Value__c,RecordTypeName__c from GGO_Static_Values__mdt where MasterLabel='WebForm_Question' and GGO_Value__c=:qcaseRecType];
                    sobjBusinesshrsName =[SELECT MasterLabel,GGO_Value__c,RecordTypeName__c from GGO_Static_Values__mdt where MasterLabel='WebForm_BusinessHours' and RecordTypeName__c=:strsource];
                    }
                    System.debug('c.Product__c@@@@'+c.Product__c);
                    if (c.Product__c!='--None--' && (Schema.sObjectType.GGO_Static_Values__mdt.isAccessible() || Schema.sObjectType.GGO_Static_Values__mdt.isQueryable())){
                        sobjProdLabel=[SELECT MasterLabel,GGO_Value__c,RecordTypeName__c,GGO_Custom_Label_Name__c from GGO_Static_Values__mdt where MasterLabel='WebForm_Product' and GGO_Value__c=:c.Product__c];
                    }
                    System.debug('c.sobjProdLabel@@@@'+sobjProdLabel);
                    if(sobjBusinesshrsName!=null && (Schema.sObjectType.BusinessHours.isAccessible() || Schema.sObjectType.BusinessHours.isQueryable())){
                        bh = [SELECT Id FROM BusinessHours WHERE Name=:sobjBusinesshrsName.GGO_Value__c];
                    }
                    if(sobjCaseType!=null){
                        c.ESC_Case_Type__c=sobjCaseType.RecordTypeName__c;
                    }
                    if(bh!=null){
                        c.BusinessHoursId=bh.Id;
                    }
                    if(sobjProdLabel!=null && sobjProdLabel.GGO_Custom_Label_Name__c!=null)
                    {
                        Component.Apex.OutputText output = new Component.Apex.OutputText();
                        output.expressions.value = '{!$Label.' + sobjProdLabel.GGO_Custom_Label_Name__c + '}';
                        selprodLabel=String.valueOf(output.value);
                    }
                    else if(c.Product__c=='--None--'){
                        selprodLabel='';
                    }
                    else{ 
                        selprodLabel=c.Product__c;
                    }
                    c.ESC_Origin_Name__c=hostURL;
                    c.Origin = 'Web';
                    c.LCRM_Sub_BU__c='GGO';
                    
                    
                    c.Description = Label.GGO_WebForm_FullName                                  +': '+  c.SuppliedName              +'; '+ 
                        Label.GGO_WebForm_CompanyName                                           +': '+  c.SuppliedCompany           +'; '+ 
                        Schema.Case.fields.GGO_Tax_Number_Type__c.getDescribe().getLabel()      +': '+  taxNumberType               +'; '+
                        Schema.Case.fields.GGO_Tax_Number__c.getDescribe().getLabel()           +': '+  taxNumber                   +'; '+
                        Schema.Case.fields.SuppliedEmail.getDescribe().getLabel()               +': '+  c.SuppliedEmail             +'; '+
                        Label.GGO_WebForm_PhoneNumber                                           +': '+  phNumber                    +'; '+
                        Schema.Case.fields.Product__c.getDescribe().getLabel()                  +': '+  selprodLabel                +'; '+
                        Schema.Case.fields.GGO_Product_Complement__c.getDescribe().getLabel()   +': '+  c.GGO_Product_Complement__c +'; '+
                        Label.GGO_WebForm_Query                                                 +': '+  inquiry               +'';
                        if(inquiry.length()>150){
                         c.subject = inquiry.left(150);
                        }
                        else{
                            c.subject = inquiry;
                        }
                    
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.useDefaultRule = true;
                    dmo.EmailHeader.triggerAutoResponseEmail = true;
                     
                    Database.SaveResult sr =  Database.insert(c, dmo);
                    gcasid=c.id;
                    if (!sr.isSuccess()) {
                        string message ='';
                        for(Database.Error err : sr.getErrors()) {
                            message += err.getStatusCode() + ': ' + err.getMessage()+'  ||  ';
                        }
                        throw new ESC_HandlerCustomException('DMLFailed '+message);

                        
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,message));
                    }

                    List<case> caselist1 = new List<case>();
                     if(queueName != null)
                    {
                        System.debug('entered');
                        List<QueueSobject> q = new List<QueueSobject>();
                        if(Schema.sObjectType.QueueSobject.isAccessible() || Schema.sObjectType.QueueSobject.isQueryable()){
                         q = [Select Id, Queue.Name, Queue.ID from QueueSobject  where  Queue.Name =: queueName]; 
                        }
                        List<Case> caselst = new List<Case>();
                        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
                          caselst = [Select id,ownerid from Case where id =: gcasid ];
                        }
                        if(q.size()>0)
                        {
                            for(case c1 : caselst)
                            {
                             for(QueueSobject q1 : q)
                                {
                                    c1.ownerid =  q1.Queue.ID;
                                   System.debug('q1.Queue.ID :'+q1.Queue.ID); 
                                }
                                caselist1.add(c1);
                            }
                             System.debug('exit');
                             Database.update(caselist1);
                        }
                    }
                  
                    displayform = false;
                    enableSection=true;
                    return null;
                    
                }
            }   
        }
        catch(ESC_HandlerCustomException ex){
            
            if(ex.getMessage().equals('UnselectedQuestion')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.GGO_WebForm_ReqMsg_Question));
                return null;
            }
            if(ex.getMessage().equals('incorrectemailaddress')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GGO_WebForm_ReqMsg_Email));
                return null;
            }
            if(ex.getMessage().equals('incorrectphonenumber')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GGO_WebForm_ReqMsg_Phone));
                return null;
            }
            if(ex.getMessage().equals('Emptyemail')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Schema.case.fields.SuppliedEmail.getDescribe().getLabel()+': '+ Label.GGO_WebForm_ReqMsg_Emptyemail));
                return null;
            }
            if(ex.getMessage().equals('EmptyTaxtype')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.GGO_WebForm_ReqMsg_Taxtype));
                return null;
            }
            if(ex.getMessage().equals('EmptyTaxNumber')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.GGO_WebForm_ReqMsg_TaxNo));
                return null;
            }
            if(ex.getMessage().equals('InvalidTaxNumber')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.GGO_WebForm_ReqMsg_NVTaxNo));
                return null;
            }
            if(ex.getMessage().equals('EmptyDescription')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.GGO_WebForm_ReqMsg_Description));
                return null;
            }
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'General Error'+ex.getMessage()));
        }
        return null;
    }
}