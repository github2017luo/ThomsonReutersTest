trigger CaseCommentAfterTrigger on CaseComment (after insert) 
{ 
    if(trigger.isInsert){
        Map<Id,CaseComment> caseCommentIdMap= new Map <Id,CaseComment>();
        
        for(CaseComment ocasecomment: Trigger.new){
            caseCommentIdMap.put(ocasecomment.ParentId,ocasecomment);
        }
        CaseCommentHandler.getListOfCase(caseCommentIdMap); 
    }
}