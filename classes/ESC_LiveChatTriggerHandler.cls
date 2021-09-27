public without sharing class ESC_LiveChatTriggerHandler{
    public static void callLivechatHandler(){
        if(Trigger.IsAfter && Trigger.IsInsert){
            ESC_LiveChatInsertTriggerHandler.onAfterInsert(Trigger.New);
        }

        if(Trigger.isAfter && Trigger.isUpdate){
           ESC_LiveChatUpdateTriggerHandler.onAfterUpdate(Trigger.New);
           ESC_LiveChatUpdateTriggerHandler.onAfterUpdate2((List<LiveChatTranscript>) Trigger.New,(Map<Id,LiveChatTranscript>) Trigger.oldMap);
    }
}
}