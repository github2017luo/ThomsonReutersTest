public class GLI_CaseInactiveOwner{

   @InvocableMethod(label='GLI_CaseInactiveOwner')
    public static void getInactiveOwnerQueue(List<id> idcases){
    
      if(idcases == null || idcases.isEmpty())
            return;
        List<Case> casList = [Select Ownerid,id,ESC_UPD__c from Case WHERE id IN:idcases];
        Map<id,id> listCaseIdOwnerId= new Map<id,id>();
       for(Case si: casList){
         listCaseIdOwnerId.put(si.Ownerid,si.id);
        } 
        
        List<GroupMember> listQueue= new List<GroupMember>();  
        Map<id,id> owneridQueueId= new Map<id,id>();  
       for(GroupMember gmem: [SELECT Group.Id,Group.Name,GroupMember.UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN:listCaseIdOwnerId.KeySet() AND Group.Type = 'Queue' ORDER BY Group.CreatedDate DESC]){
         if(owneridQueueId.get(gmem.UserOrGroupId) == null){
            owneridQueueId.put(gmem.UserOrGroupId,gmem.Group.Id);
         }
       }
    List<Case> caseListMod= new List<Case>();
    system.debug('owneridQueueId&&&'+owneridQueueId);
       for(Case si: casList){
         if(owneridQueueId.size()>0){
           si.Ownerid = owneridQueueId.get(si.Ownerid);
            system.debug('owneridQueueId.get(si.Ownerid)****&&&'+owneridQueueId.get(si.Ownerid));
           si.ESC_UPD__c = True;
           caseListMod.add(si);
         }
       }
    
      if(caseListMod.size()>0){
            update caseListMod;
       }
}




}