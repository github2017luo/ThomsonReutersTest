public class ESC_CaseMSListltngController{
 
    @AuraEnabled
    public static List<CaseMilestone> getCaseMS(Id caseId) {
        return [SELECT id, CaseId,TargetDate,MilestoneTypeId, MilestoneType.Name,CompletionDate,TimeRemainingInMins,IsViolated,IsCompleted FROM CaseMilestone where CaseId =:caseId ORDER BY createdDate DESC];
    }
}