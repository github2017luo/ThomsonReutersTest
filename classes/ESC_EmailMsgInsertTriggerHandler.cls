public without sharing Class ESC_EmailMsgInsertTriggerHandler{    
    public static void onAfterInsert(List<EmailMessage> newEmailMsgList){
        if(Label.ESC_EmailMessageSwitch.equalsIgnoreCase('On')){
            ESC_EmailUtility.updateCaseSubBu(newEmailMsgList);
        }
    }
}