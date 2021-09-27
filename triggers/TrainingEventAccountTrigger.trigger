trigger TrainingEventAccountTrigger on Training_Event_Account__c (after Insert, after update,before Delete,after Delete) 
{
  Set<Id> Accs = new Set<Id>();
  if(trigger.isInsert && trigger.isAfter)
  {
    TrainingEventAccountUtil.PopulateAccountOnTrainingEvent(Trigger.new);
    TrainingEventAccountUtil.PopulateLastTrainedOnAccount(Trigger.new,Accs);
    
  }else if(trigger.isDelete && trigger.isBefore){
    TrainingEventAccountUtil.UpdateAccountOnTrainingEvent(Trigger.old);
  }
  
  else if(trigger.isDelete && trigger.isAfter)
  {
    TrainingEventAccountUtil.PopulateLastTrainedOnAccount_Delete(Trigger.old);
    
  }else if(trigger.isUpdate && trigger.isAfter){
    
    TrainingEventAccountUtil.PopulateLastTrainedOnAccount(Trigger.new,Accs);
  }
    
}