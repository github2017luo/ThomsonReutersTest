/*
===============================================================================
    CampaignOfferCodeUpdateonTE
===============================================================================

PURPOSE: To update the all Training Events offer code onchange of Campaign offer code

FUNCTIONALITY: Batch apex To update the all Training Events offer code onchange of Campaign offer code

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
2012-12-27       Nandita          Created

===============================================================================
*/


global class CampaignOfferCodeUpdateonTE implements Database.Batchable<sObject>, Database.Stateful{

    public Set<Id> RecordIds = new Set<Id>();
    public List<Campaign> listCampaign = new List<Campaign>();
    public Set<Id> setFailedCampaignIds = new Set<Id>();


  //Constructor
    global CampaignOfferCodeUpdateonTE(){
         listCampaign = [Select Id,Offer_Code__c from Campaign where Has_Offer_Code_TE__c=true and IsActive = true and status <> 'Completed' and status <> 'Aborted'];
    }

    global database.querylocator start(Database.BatchableContext BC){
                return Database.getQueryLocator([Select id, Offer_Code__c,campaign_name__c  from Training_Event__c where campaign_name__c IN :listCampaign]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
       List<Training_Event__c> listTrainingEvents = new List<Training_Event__c>();
       Map<Id, String> mapCampaignOfferCode = new Map<Id, String>();
       
       for(Campaign oCampaign : listCampaign){
          if(!mapCampaignOfferCode.containsKey(ocampaign.id))
                 {
                      mapCampaignOfferCode.put(ocampaign.id, ocampaign.Offer_Code__c);
                 }
       
       }
          
       for(sObject s : scope){
          Training_Event__c oTrainingEvent = (Training_Event__c)s;
          RecordIds.add(oTrainingEvent.Id);
          oTrainingEvent.offer_code__c = mapCampaignOfferCode.get(oTrainingEvent.campaign_name__c);
          listTrainingEvents.add(oTrainingEvent);
       }
       
     
     List<Database.SaveResult> listSaveResults = database.update(listTrainingEvents);
     
     for(Integer i = 0 ;i< listSaveResults.size(); i++){
         if(!listSaveResults[i].isSuccess()){
             setFailedCampaignIds.add(listTrainingEvents[i].campaign_name__c);
         }
     }
   
   List<Campaign> FCampaign = new List<Campaign>(); 
      for(Campaign oCampaign : listCampaign){
         
           if(!setFailedCampaignIds.contains(oCampaign.Id)){
               oCampaign.Has_Offer_Code_TE__c = false;
               FCampaign.add(oCampaign);
           }
             
     }
     database.update(FCampaign);
     
    }
       
    
    global void finish(Database.BatchableContext ctx){
    
        AsyncApexJob oAsyncApexJob = [SELECT id, ApexClassId, 
                      JobItemsProcessed, 
                      TotalJobItems, 
                      NumberOfErrors, 
                      ExtendedStatus,
                      CreatedBy.Email 
                      FROM AsyncApexJob 
                      WHERE id = :ctx.getJobId()];
        
         string messageFormat = 'Your batch job Training Event offer code Update has finished.  It executed {0} batches.  Of which, {1} processed without any exceptions thrown and {2} batches threw unhandled exceptions.Error: {3}.';

        List<string> messageValues = new string[] {
        
         String.valueOf(oAsyncApexJob.TotalJobItems)
        
        , String.valueOf(oAsyncApexJob.JobItemsProcessed)
        
        , String.valueOf(oAsyncApexJob.NumberOfErrors)
        
        , oAsyncApexJob.ExtendedStatus
        };
        string sEmailMessage = String.format(messageFormat, messageValues);
         
        
     Messaging.SingleEmailMessage mail = 
              new Messaging.SingleEmailMessage();
    // String[] sToAddresses = new String[] 
   //           {oAsyncApexJob.createdBy.email};
     String[] sToAddresses =  new String[] {'nandita.shet@thomsonreuters.com'};
     mail.setToAddresses(sToAddresses );
     mail.setReplyTo('noreply@salesforce.com');
     mail.setSenderDisplayName('Batch Job Summary');
     mail.setSubject('Batch job completed');
     mail.setPlainTextBody(sEmailMessage);
     mail.setHtmlBody(sEmailMessage);
     
     if(oAsyncApexJob.numberOfErrors > 0){
     Messaging.sendEmail(new 
          Messaging.SingleEmailMessage[] { mail });
    }    
    } 
    
}