trigger EmailMessageAftertrigger on EmailMessage (after insert) 
{
    if(trigger.isInsert ){
        Map<Id,EmailMessage> emailMessageIdMap=new Map<Id,EmailMessage>();
        for(EmailMessage oemail: Trigger.new){
            emailMessageIdMap.put(oemail.ParentId,oemail);
        }
        CaseCommentHandler.getListOfEmail(emailMessageIdMap);
    }
}