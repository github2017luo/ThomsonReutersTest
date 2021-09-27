public without sharing class ESC_EmailMsgTriggerHandler {
    public static void callEmailMsgHandler(){
        if(Trigger.IsAfter && Trigger.IsInsert ){
            ESC_EmailMsgInsertTriggerHandler.onAfterInsert(Trigger.New);
        }

        if(Trigger.isBefore && Trigger.isDelete){
           ESC_EmailMsgDeleteTriggerHandler.onBeforeDelete(Trigger.Old);
        } 
    }
}