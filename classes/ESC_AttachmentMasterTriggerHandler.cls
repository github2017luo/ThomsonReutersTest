/**
 * @description attachment trigger handler
 */
public without sharing class ESC_AttachmentMasterTriggerHandler {
    /**
 * @description attachment trigger handler
 */
    public static void callAttachmentHandler(){
        If(Trigger.IsAfter && Trigger.IsInsert ){
        
            ESC_AttachmentTriggerInsertHandler.onAfterInsert(Trigger.New);
            ESC_ConvertAttachmenttoFile.converttofile(trigger.new);
        }

        if(Trigger.isBefore && Trigger.isDelete){
            system.debug(LoggingLevel.WARN,'emAttachmentPreventDeletion Trigger fired');
            ESC_AttachmentTriggerDeleteHandler.onBeforeDelete(Trigger.Old);
           } 
    }
}