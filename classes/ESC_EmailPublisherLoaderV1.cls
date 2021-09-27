/**
 * CHANGE HISTORY
 * ============================================================================================================================
 * Date         Name             JIRA          Description
 * ============================================================================================================================
 * 
 * 2017-05-10   Karthi G        EBB-     Email publisher loader based on recordtype name
 * ============================================================================================================================
 */
global class ESC_EmailPublisherLoaderV1 implements QuickAction.QuickActionDefaultsHandler {

    global ESC_EmailPublisherLoaderV1() {}
    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) {
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = null;
        for (Integer j = 0; j < defaults.size(); j++) {
            if (defaults.get(j) instanceof QuickAction.SendEmailQuickActionDefaults && 
               defaults.get(j).getTargetSObject().getSObjectType() == 
                EmailMessage.sObjectType && 
                defaults.get(j).getActionName().equals('Case.Email') && 
                defaults.get(j).getActionType().equals('Email')) {
                sendEmailDefaults =(QuickAction.SendEmailQuickActionDefaults)defaults.get(j);break;}}        
        if (sendEmailDefaults != null) {
            Case c = [SELECT recordtype.developername ,contact.email,Status, Reason FROM Case WHERE Id=:sendEmailDefaults.getContextId()];
            EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject();    
           // emailMessage.BccAddress = getBccAddress();
            emailMessage.FromAddress = getFromAddress();
            emailMessage.ToAddress = c.Contact.email;
            sendEmailDefaults.setTemplateId(getDefaultEmailTemplateId(c.id));}}
    
     public ID getDefaultEmailTemplateId(ID caseId) {
        String esc1='ESC_DefaultTempalte__C';
        ID tempID=null;
        Case c = [SELECT recordtype.name FROM Case WHERE Id=:caseId];  
        If(c.recordtype.name != null && c.recordtype.name != ''){
        esc1='ESC_'+c.recordtype.name+'Template__c';
        system.debug(esc1);
        }
        esc1=esc1.deleteWhitespace();
        ESC_EmailSelectorIDs__c eIDs = ESC_EmailSelectorIDs__c.getInstance();
        If(eIDs != null ){
        String e=(String)eIDs.get(esc1);
        System.debug(e);
        If(e != null && e != ''){
        tempID=[SELECT id FROM EmailTemplate WHERE DeveloperName = :e].ID;
        }
        }
        return tempID;
    }
   // public String getBccAddress() {return 'SomeOtherEmail@ConfigurableValue.com';}
    public String getFromAddress() {        
        ESC_Static_Values__c  tempval= ESC_Static_Values__c.getInstance('OrgWideDisplayName');
        string em='';
            if(tempval!=null){
            em = [SELECT address FROM OrgWideEmailAddress where displayname =:tempval.ESC_Value__c limit 1].address;
            }
            return em;
        
    }
    
}