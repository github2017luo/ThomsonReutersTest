public class TrainingEventAccountUtil
{
  public static void PopulateLastTrainedOnAccount_Delete(List<Training_Event_Account__c> ListTrainingEvAccs){
    List<Account> ListAccount = new List<Account>();
    Set<Id> SetAccountId = new Set<Id>();
    Set<Id> SetTrainingEvAccId = new Set<Id>();
    List<Training_Event_Account__c> ListTrainEvAccUpd = new List<Training_Event_Account__c>();
    for(Training_Event_Account__c tea : ListTrainingEvAccs){
      SetAccountId.add(tea.Account__c);
      SetTrainingEvAccId.add(tea.Id);
      
    }
    ListTrainEvAccUpd = [Select Id,Training_Date__c,Account__c from Training_Event_Account__c where Account__c IN : SetAccountId and Id Not IN :SetTrainingEvAccId ];
    PopulateLastTrainedOnAccount(ListTrainEvAccUpd,SetTrainingEvAccId);
  }
  
  
  public static void PopulateLastTrainedOnAccount(List<Training_Event_Account__c> ListTrainingEvAccs,Set<Id> SetTrainingEvAccIds){
    List<Id> ListAccountId = new List<Id>();
    List<Id> ListAccId = new List<Id>();
    Map<Id,Date> mapAccountTrainedDate = new Map<Id,Date>();
    
    for(Training_Event_Account__c t : ListTrainingEvAccs){
      ListAccId.add(t.Account__c); 
    }
    List<Training_Event_Account__c> ListTrainingEventAcc = [Select Id,Training_Event__r.Status__c,Account__c,Training_Date__c from Training_Event_Account__c where Account__c IN : ListAccId];
      
      for(Training_Event_Account__c tea : ListTrainingEventAcc){
         if(!(SetTrainingEvAccIds.contains(tea.Id))){
          if(tea.Training_Date__c!=null){
            if(mapAccountTrainedDate.containsKey(tea.Account__c) && mapAccountTrainedDate.get(tea.Account__c) < tea.Training_Date__c && tea.Training_Event__r.Status__c=='Completed'){
              mapAccountTrainedDate.put(tea.Account__c, tea.Training_Date__c);
              ListAccountId.add(tea.Account__c);
          }else if(!mapAccountTrainedDate.containsKey(tea.Account__c)){
            mapAccountTrainedDate.put(tea.Account__c, tea.Training_Date__c);
            ListAccountId.add(tea.Account__c);
          }
         }
         }else if(!mapAccountTrainedDate.containsKey(tea.Account__c)){
            mapAccountTrainedDate.put(tea.Account__c,null);
            ListAccountId.add(tea.Account__c);
          }
         
      }
      if(!ListAccountId.isEmpty()){
       List<Account> ListAccount = new List<Account>();
       for(Account oAcc : [Select Last_Trained__c,Id from Account where Id in : ListAccountId]){
         if(mapAccountTrainedDate.containsKey(oAcc.Id)){
           oAcc.Last_Trained__c = mapAccountTrainedDate.get(oAcc.Id);
           ListAccount.add(oAcc);
         }
       }
      update ListAccount;
      }
  }

  public static void PopulateAccountOnTrainingEvent(List<Training_Event_Account__c> ListTrainingEventAccounts){
    List<Id> listTrainingEventIds = new List<Id>();
    Map<Id, Id> mapTrainingEventIdAccountId = new Map<Id, Id>(); 
    for (Training_Event_Account__c tea : ListTrainingEventAccounts)
    {
      if(!mapTrainingEventIdAccountId.containsKey(tea.Account__c))
      {
        mapTrainingEventIdAccountId.put(tea.Training_Event__c, tea.Account__c);
        listTrainingEventIds.add(tea.Training_Event__c);
      }
    }
    if(!listTrainingEventIds.isEmpty())
    {
      List<Training_Event__c> listTrainingEvents = new List<Training_Event__c>();
      listTrainingEvents = [select Id,Account__c from training_Event__c where Account__c = null and Id in :listTrainingEventIds];
      if(!listTrainingEvents.isEmpty())
      {
        for(Training_Event__c te : listTrainingEvents)
        {
          te.Account__c = mapTrainingEventIdAccountId.get(te.Id);          
        }
        update listTrainingEvents;
      } 
    }  
       // PopulateLastTrainedOnAccount(ListTrainingEventAccounts);
    }


    public static void UpdateAccountOnTrainingEvent(List<Training_Event_Account__c> ListTrainingEventAccounts){
    List<Id> listDeletedTrainingEventIds = new List<Id>();
    List<Training_Event__c> listTrainingEvents = new List<Training_Event__c>();
    List<Id> recordtypesIdList = new List<Id>();      
    List<Id> listS2EDeletedTrainingEventIds = new List<Id>();   
    List<Training_Event__c> listS2ETrainingEvents = new List<Training_Event__c>();
          
    for (Training_Event_Account__c tea : ListTrainingEventAccounts)
    {
        listDeletedTrainingEventIds.add(tea.Training_Event__c);      
    }
    listTrainingEvents = [select Id,RecordTypeId from training_Event__c where Id in :listDeletedTrainingEventIds];
    for(Training_Event__c te:listTrainingEvents){
        recordtypesIdList.add(te.RecordTypeId);
    }
    Map<Id,RecordType> recordtypes = new Map<Id,RecordType>([Select Id,DeveloperName from RecordType where id in :recordtypesIdList]);
    for(Training_Event__c te:listTrainingEvents){
        if(!(recordtypes.get(te.RecordTypeId).DeveloperName == 'GLI') )
            listS2EDeletedTrainingEventIds.add(te.Id);
    }
    listS2ETrainingEvents = [select Id,Account__c from training_Event__c where Id in :listS2EDeletedTrainingEventIds];
    
    Map<Id, Id> mapTrainingEventIdAccountId = new Map<Id, Id>();
    for (Training_Event_Account__c tea : [select Id, Training_Event__c, Account__c from Training_Event_Account__c where Id not in :ListTrainingEventAccounts and Training_Event__c in :listS2EDeletedTrainingEventIds limit 50000])
    {
        if(!mapTrainingEventIdAccountId.containsKey(tea.Account__c))
        {
          mapTrainingEventIdAccountId.put(tea.Training_Event__c, tea.Account__c);        
        }
    }
    
    for(Training_Event__c te : listS2ETrainingEvents)
    {
      if(mapTrainingEventIdAccountId.containsKey(te.Id))
        te.Account__c = mapTrainingEventIdAccountId.get(te.Id);
      else
        te.Account__c = null;          
    }
    update listS2ETrainingEvents;
}


  /*public static void OnAfterUpdate(List<Training_Event_Account__c> ListTrainingEventAccounts){
    PopulateLastTrainedOnAccount(ListTrainingEventAccounts);
  }
*/

}