public without sharing Class ESC_EmailMsgDeleteTriggerHandler{    
    public static void onBeforeDelete(List<EmailMessage> oldEmailMsgList){
        ESC_CaseRouting.EMpreventdeletion(oldEmailMsgList);
    }
}