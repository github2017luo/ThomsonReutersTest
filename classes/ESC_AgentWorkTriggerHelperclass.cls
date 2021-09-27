public without sharing Class ESC_AgentWorkTriggerHelperclass{

    public static void ChangeStatusOfCases(List<AgentWork > AgentWorkList){
    
    List<Case> caseList = new List<Case>();
    Set<Id> caseSet = new Set<Id>();

        system.debug('AgentWorkList@'+AgentWorkList);


        for (AgentWork aw : AgentWorkList) {
            String ownerid = aw.WorkItemId;
            if (ownerid.left(3) == '500' ){    
                caseSet.add(aw.WorkItemId);
            }
        }
        
        system.debug('caseSet@'+caseSet);
        if(caseSet.size()>0){
        if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isQueryable()){
        caseList = [SELECT Id, Status FROM Case WHERE Id IN: caseSet And Is_ESC_Case__c=True];
        }
}
        if(caseList .size()>0)
        {
            for (Case c : caseList) {
                c.Status = 'Work In Progress';
            }
        
       if(Schema.sObjectType.Case.isUpdateable()){ 
        update caseList;
        }
        }

      }

}