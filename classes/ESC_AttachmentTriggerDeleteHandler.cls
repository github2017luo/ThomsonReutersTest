public without sharing class ESC_AttachmentTriggerDeleteHandler {
    public static void onBeforeDelete(List<Attachment> attchList){
        ESC_CaseRouting.emAttachmentPreventDeletion(attchList);
    }
}