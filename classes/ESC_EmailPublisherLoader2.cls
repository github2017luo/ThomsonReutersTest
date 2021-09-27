/**
* CHANGE HISTORY
* ============================================================================================================================
* Date         Name             JIRA          Description
* ============================================================================================================================
* @description ESC_EmailPublisherLoader2
* 2017-01-06  Karthi/Mosumi    EBB-223/274    Email publisher loader based on case fields
* ============================================================================================================================
*/
global without sharing class ESC_EmailPublisherLoader2 implements QuickAction.QuickActionDefaultsHandler {
     /**
     * @description ESC_EmailPublisherLoader2
     * 
     */
    global ESC_EmailPublisherLoader2() {
        system.debug(LoggingLevel.DEBUG,'Inside Constructor');
    }
    /**
     * @description Justdesc
     * @param defaults
     */
    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) {
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = null;
        Boolean inLightning = false;
        Case c;
        for (Integer j = 0; j < defaults.size(); j++) {
            system.debug(LoggingLevel.DEBUG,'defaults.get(j).getTargetSObject().getSObjectType() : ' +defaults.get(j).getTargetSObject().getSObjectType());
            system.debug(LoggingLevel.DEBUG,'defaults.get(j).getActionName() : ' +defaults.get(j).getActionName());
            system.debug(LoggingLevel.DEBUG,'defaults.get(j).getActionType() : ' +defaults.get(j).getActionType());
            
            if (defaults.get(j) instanceof QuickAction.SendEmailQuickActionDefaults && 
                defaults.get(j).getTargetSObject().getSObjectType() == EmailMessage.sObjectType && 
                (defaults.get(j).getActionName().equals('Case.Email') || defaults.get(j).getActionName().equals('Case.Send_Email_LEX')) && 
                (defaults.get(j).getActionType().equals('Email') || defaults.get(j).getActionType().equals('SendEmail'))) {
                    sendEmailDefaults =(QuickAction.SendEmailQuickActionDefaults)defaults.get(j);
                    break;
                }
        }
        
        system.debug(LoggingLevel.DEBUG,'**sendEmailDefaults 1***' + sendEmailDefaults);
                
        if (sendEmailDefaults != null) {
             system.debug(LoggingLevel.DEBUG,'Display: '+UserInfo.getUiThemeDisplayed());
             if(UserInfo.getUiThemeDisplayed() =='Theme4t' || UserInfo.getUiThemeDisplayed() =='Theme4d')  {
                 system.debug(LoggingLevel.DEBUG,'In Lightning Mode');
                 inLightning = true;
             }
             else{
                system.debug(LoggingLevel.DEBUG,'In Classic Mode');
             }
                 
             if (Schema.sObjectType.Case.isAccessible()){ 
             c = [SELECT recordtype.developername ,contact.email,Status, Reason FROM Case WHERE Id=:sendEmailDefaults.getContextId()];
             }
            EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject(); 
            //Added 1st if condition as part of EES-115
            system.debug(LoggingLevel.DEBUG,'getinrepliid**'+sendEmailDefaults.getInReplyToId());
             
           if(sendEmailDefaults.getInReplyToId() == null && getEmailSelectedRec(c.id)!=null){ 
                system.debug(LoggingLevel.DEBUG,'**Inside desired IF 1 **');
                ESC_EmailSelectorList__c emailselList = getEmailSelectedRec(c.id);
                emailMessage.ccAddress = getccAddress(emailselList,c.id);
                //emailMessage.BccAddress = getBccAddress();
                //emailMessage.FromAddress = getFromAddress(emailselList,c.id);
                //emailMessage.ValidatedFromAddress = emailMessage.FromAddress; //Added as a fix for DSS-3137
                emailMessage.FromAddress = '';
                system.debug(LoggingLevel.DEBUG,'getinrepliid**'+sendEmailDefaults.getInReplyToId());
                emailMessage.ToAddress = getToAddress(emailselList,c.id);
                sendEmailDefaults.setInsertTemplateBody(true);
                sendEmailDefaults.setTemplateId(getDefaultEmailTemplateId(emailselList.ESC_EmailTemplateName__c));
                
                if(inLightning || Test.isRunningTest())
                {
                    emailMessage.FromAddress = '';
                    emailMessage.ValidatedFromAddress = getFromAddress(emailselList,c.id);
                }
                else
                {
                    emailMessage.FromAddress = getFromAddress(emailselList,c.id);
                }
                
            }
           else if(sendEmailDefaults.getInReplyToId() != null && getEmailSelectedRec(c.id)!=null){
           system.debug(LoggingLevel.DEBUG,'**Inside desired else 1 **');
                ESC_EmailSelectorList__c emailselList = getEmailSelectedRec(c.id);
                //emailMessage.FromAddress = getFromAddress(emailselList,c.id);
                //emailMessage.ValidatedFromAddress = emailMessage.FromAddress; //Added as a fix for DSS-3137
                if(inLightning || Test.isRunningTest())
                {
                    emailMessage.FromAddress = '';
                    emailMessage.ValidatedFromAddress = getFromAddress(emailselList,c.id);
                    system.debug(LoggingLevel.DEBUG,'from address is'+emailMessage.ValidatedFromAddress);
                }
                else
                {
                    emailMessage.FromAddress = getFromAddress(emailselList,c.id);
                }
                
                //emailMessage.ToAddress = getToAddress(emailselList,c.id);
           }
            else if(sendEmailDefaults.getInReplyToId() != null && getEmailSelectedRec(c.id)==null){
            system.debug(LoggingLevel.DEBUG,'**Inside desired else 2 **');
                ESC_EmailSelectorList__c emailselList = getEmailSelectedRec(c.id);
                //emailMessage.FromAddress = getFromAddress(emailselList,c.id);
                //emailMessage.ValidatedFromAddress = emailMessage.FromAddress; //Added as a fix for DSS-3137
                //emailMessage.ToAddress = getToAddress(emailselList,c.id);
                if(inLightning || Test.isRunningTest())
                {
                    emailMessage.FromAddress = '';
                    emailMessage.ValidatedFromAddress = getFromAddress(emailselList,c.id);
                }
                else
                {
                    emailMessage.FromAddress = getFromAddress(emailselList,c.id);
                }
           }
           
            //Added as part of EES-517
           else if(getEmailSelectedRec(c.id) == null){
           system.debug(LoggingLevel.DEBUG,'**Inside desired else 3 **');
            system.debug(LoggingLevel.DEBUG,'inside elseif&&'+sendEmailDefaults.getInReplyToId());
            //emailMessage.FromAddress = getFromAddress(null,c.id);
            //emailMessage.ValidatedFromAddress = emailMessage.FromAddress; //Added as a fix for DSS-3137
           // emailMessage.ToAddress = getToAddress(null,c.id);
                if(inLightning || Test.isRunningTest())
                {
                    emailMessage.FromAddress = '';
                    emailMessage.ValidatedFromAddress = getFromAddress(null,c.id);
                }
                else
                {
                    emailMessage.FromAddress = getFromAddress(null,c.id);
                }           
            }
        }
    }
     /**
     * @description getEmailSelectedRec
     * @param caseid
     * @return jusdesc
     */
    public ESC_EmailSelectorList__c getEmailSelectedRec(id caseId) {
        Id uid = UserInfo.getUserId();
        Id profileid = UserInfo.getProfileid();
        String profilename=[select name from profile where id=:profileid].name;
        String uRoleId = UserInfo.getUserRoleId();
        String rolename ='';
        if(uRoleId!=null){
            rolename = [select name from UserRole where id=:uRoleId].name;
        }
        String combinedfields='';
        Map<String, Schema.SobjectField> fieldsmap = Schema.SobjectType.ESC_EmailSelectorFields__c.fields.getMap();
        system.debug(LoggingLevel.DEBUG,fieldsmap);
        List<String> fieldList = new List<String>();
        for(String fieldname:fieldsmap.keyset()){
            if(fieldname.contains('__c')){
                fieldList.add(fieldname);
            }
        }
        
        ESC_EmailSelectorFields__c eIDs = ESC_EmailSelectorFields__c.getInstance(); 
        for(String f: fieldList){
            if(eIDs.get(f)!=null && eIDs.get(f)!=''){
                combinedfields += eIDs.get(f) + ',';
            }
        }
        
        string q = 'select ' + String.escapeSingleQuotes(combinedfields) + 'recordtypeid from Case where id =: caseId'; 
        system.debug(LoggingLevel.DEBUG,'Query ' + q+ eIDs );
        case c1 = Database.query(String.escapeSingleQuotes(q));
        System.debug(LoggingLevel.DEBUG,c1);
        string lkp='';
        for(String cfield : combinedfields.split(',')){
            
            if(cfield.contains('.')){
                String rname1;
                List<String> list1 = new List<String>();
                for(String s : cfield.split('\\.')){
                    list1.add(s);
                }
                System.debug(LoggingLevel.DEBUG,list1);
                String t1=list1[0];
                String t2=list1[1];
                if(c1.getSObject(t1)!=null){
                    rname1= string.valueOf(c1.getSObject(t1).get(t2));
                }
                System.debug(LoggingLevel.DEBUG,rname1);
                if(rname1!=null){
                    lkp+=rname1;
                }
            }
            else if (cfield != null && cfield != ''){
                String temp=String.Valueof(c1.get(cfield));
                if(temp!=null&&temp!=''){
                    lkp=lkp +temp ;
                }
            }
        }
        if(rolename!=''&& rolename!=null){
            lkp=profilename+ rolename + lkp;
        }
        else{
            lkp  = profilename + lkp;
        }
        system.debug(LoggingLevel.DEBUG,'lkp *****' + lkp);
        string e;
        List<ESC_EmailSelectorList__c> escEmailSelect= new List<ESC_EmailSelectorList__c>();

        escEmailSelect =  [select ESC_EmailTemplateName__c,ESC_CC_Address__c,ESC_Default_From_Address__c,ESC_From_Address__c,ESC_To_Address__c from ESC_EmailSelectorList__c where ESC_LKP__c =:lkp limit 1];
        if(escEmailSelect.size()>0){
            return escEmailSelect[0];
            }
        else{
            return null;
        }
    }
    
    /**
     * @description Justdesc
     * @return jusdesc
     * @param templatename
     */
    public Id getDefaultEmailTemplateId(String templatename){
        system.debug(LoggingLevel.DEBUG,'**IN side default template method**');
        system.debug(LoggingLevel.DEBUG,'**Template name**'+ templatename);
        EmailTemplate listtempID= new EmailTemplate();
        ID tempID;
        If (templatename != null && templatename != ''){
            listtempID=[SELECT id FROM EmailTemplate WHERE DeveloperName = :templatename limit 1];
        }
        system.debug(LoggingLevel.DEBUG,'**listtempID**'+ listtempID);
        if(listtempID!=null){
            system.debug(LoggingLevel.DEBUG,'Template details: ' + listtempID);
            tempID= listtempID.Id;
        }
        system.debug(LoggingLevel.DEBUG,'**Template Id**'+ tempID);
        return tempID;
    }  
    
/**
     * @description Justdesc
     * @return jusdesc
     */
    public String getBccAddress() {return '';}
    /**
     * @description Justdesc
     * @return jusdesc
     * @param templatename,caseid
     */
    public String getFromAddress(ESC_EmailSelectorList__c emailsellst, Id caseId) {
    if(emailsellst!=null){
        if(emailsellst.ESC_From_Address__c!=null && emailsellst.ESC_From_Address__c!=''){
            String frmAddress;
            List<String> fAddSet1 = new List<String>();
            string q = 'select ' + String.escapeSingleQuotes(emailsellst.ESC_From_Address__c) + ',Id from Case where id =: caseId'; 
            case c1 = Database.query(String.escapeSingleQuotes(q)); 
            system.debug(LoggingLevel.DEBUG,'case from address --->'+c1);
            Set<String> fAddSet = new Set<String>();
            fAddSet.addall(emailsellst.ESC_From_Address__c.split(','));
            system.debug(LoggingLevel.DEBUG,'from address --->'+fAddSet);
            Boolean validemail= false;
            Boolean defaultfrom = false;
            for(String apis:fAddSet){
                //if fromaddress not null
                if(c1.get(apis)!=null && c1.get(apis)!=''){
                    frmAddress = (String) c1.get(apis);
                    system.debug(LoggingLevel.DEBUG,'test11'+frmAddress);
                    fAddSet1.addall(frmAddress.split(';'));
                    system.debug(LoggingLevel.DEBUG,'from address1 --->'+fAddSet1);
                    if(!(fAddSet1.size() > 1)){
                        validemail = ESC_Utility.validateEmail(fAddSet1[0]);
                        if(validemail){
                            return fAddSet1[0];
                        }
                        else{
                            defaultfrom = true;
                        }
                    }
                    //if fromaddress has more than 1 email
                    else{
                        defaultfrom = true;
                    }
                }
                if(c1.get(apis)== null || c1.get(apis)=='' || defaultfrom == true){
                     if(emailsellst.ESC_Default_From_Address__c != '' && emailsellst.ESC_Default_From_Address__c != null){
                        validemail = ESC_Utility.validateEmail(emailsellst.ESC_Default_From_Address__c);
                        system.debug(LoggingLevel.DEBUG,'entered from address1 --->'+emailsellst.ESC_Default_From_Address__c);
                        if(validemail){
                            return emailsellst.ESC_Default_From_Address__c;
                        }
                        }
                    }
            }
            
        }
        }
        
   /*     //Added for SegmentRegion Mapping to get emailaddress
        String segfrmadd = ESC_SegmentregionUtility.getDetailInfo(caseId,'OrgEmailAdd');
        String segemail;
        if(segfrmadd !=''){
            segemail = [SELECT address FROM OrgWideEmailAddress where displayname =:segfrmadd limit 1].address;
            return segemail;
        }*/
        string emailadd='';
        ESC_OrgWideEmailCaseSetting__c orgsetting= ESC_OrgWideEmailCaseSetting__c.getInstance(UserInfo.getProfileID());
        if(orgsetting!=null){
            string orgwidename = orgsetting.OrgWideDisplayName__c;
            if(orgwidename!=null && orgwidename!=''){
                emailadd = [SELECT address FROM OrgWideEmailAddress where displayname =:orgwidename limit 1].address;
                system.debug(LoggingLevel.DEBUG,'emailadd1-->'+emailadd);
                return emailadd;
            }
        }
        ESC_Static_Values__c  tempval= ESC_Static_Values__c.getInstance('OrgWideDisplayName');
       
        if(tempval!=null && tempval.ESC_Value__c!=null){
            emailadd = [SELECT address FROM OrgWideEmailAddress where displayname =:tempval.ESC_Value__c limit 1].address;
        }
        system.debug(LoggingLevel.DEBUG,'emailadd-->'+emailadd);
        
        return emailadd;
        
    }
    
    public String getToAddress(ESC_EmailSelectorList__c emailsellst, Id caseId) {
        String toAddress;
        if(emailsellst.ESC_To_Address__c!=null && emailsellst.ESC_To_Address__c!=''){
            string q = 'select ' + String.escapeSingleQuotes(emailsellst.ESC_To_Address__c) + ',Id from Case where id =: caseId'; 
            system.debug(LoggingLevel.DEBUG,'Query--> ' + q );
            case c1 = Database.query(String.escapeSingleQuotes(q)); 
            
            Set<String> fAddSet = new Set<String>();
            fAddSet.addall(emailsellst.ESC_To_Address__c.split(','));
            
            for(String apis:fAddSet){
                if(c1.get(apis)!=null && c1.get(apis)!=''){
                    toAddress = (String) c1.get(apis);
                    system.debug(LoggingLevel.DEBUG,'test113'+toAddress);
                    Boolean validemail = ESC_Utility.validateEmail(toAddress);
                    if(validemail){
                        return toAddress;
                        }
                }
            }
        }
        return '';
    }
    
    //Added as part of EES-115
    public String getccAddress(ESC_EmailSelectorList__c emailsellst, Id caseId) {
        String ccAddress;
        if(emailsellst.ESC_CC_Address__c!=null && emailsellst.ESC_CC_Address__c!=''){
            string q = 'select ' + String.escapeSingleQuotes(emailsellst.ESC_CC_Address__c) + ',Id from Case where id =: caseId'; 
            case c1 = Database.query(String.escapeSingleQuotes(q)); 
            Set<String> fAddSet = new Set<String>();
            fAddSet.addall(emailsellst.ESC_CC_Address__c.split(','));
            for(String apis:fAddSet){
                if(c1.get(apis)!=null && c1.get(apis)!=''){
                    ccAddress = (String) c1.get(apis);
                    system.debug(LoggingLevel.DEBUG,'test113'+ccAddress);
                    Boolean validemail = ESC_Utility.validateEmail(ccAddress);
                    if(validemail){
                        return ccAddress;
                        }
                }
            }
        }
        return '';
    }
}