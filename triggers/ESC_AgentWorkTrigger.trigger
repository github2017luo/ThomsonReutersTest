trigger ESC_AgentWorkTrigger on AgentWork (before insert, after insert, before update, after update) {
            
             //Call method for AfterUpdate
    If(Trigger.IsAfter && Trigger.IsUpdate ){
        ESC_AgentWorkTriggerHelperclass.ChangeStatusOfCases(Trigger.new);
      }

}