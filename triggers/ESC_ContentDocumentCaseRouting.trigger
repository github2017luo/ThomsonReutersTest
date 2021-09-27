/* DSS-6578-(USL - Ability for Credentialing to delete an Attachment)
    * 28/01/2020
    */
trigger ESC_ContentDocumentCaseRouting on ContentDocument (Before delete, After insert) {
    
     if(Trigger.IsBefore && Trigger.isdelete){
    ESC_CaseRouting.filesPreventDeletion(Trigger.Old);

    }

}