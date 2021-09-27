trigger ESC_AttachmentTrigger on Attachment (before insert, after insert, before update, after update, 
                    before delete, after delete, after undelete) {
                        
                        
        system.debug(LoggingLevel.WARN,'ESC_AttachmentTrigger fired');
        ESC_AttachmentMasterTriggerHandler.callAttachmentHandler();
       
                      
}