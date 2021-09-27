/*
===============================================================================
  CLASS NAME:  OpportunityTerritoryUpdate 
===============================================================================

PURPOSE: To update the Opportunity Territory Id

FUNCTIONALITY: Batch apex for scheduled interface scheduled batchable class

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
2011-08-29      Nandita           Created
31-03-2017      Gunaseelan K      Optimized the code as per JIRA STORY: PS0-1
===============================================================================
*/

global class OpportunityTerritoryUpdate implements Database.Batchable<sObject>{
public static Set<Id> RecordIds = new Set<Id>();
public static Set<Id> OwnerIds = new Set<Id>();

public static Map<id,List<id>> useridterritoryList = new Map<id,List<id>>();
  //Constructor
    global OpportunityTerritoryUpdate (){
    }
    global database.querylocator start(Database.BatchableContext BC){
         if(!Test.isRunningTest()){
                return Database.getQueryLocator([Select Territory2.Id,OwnerID from Opportunity where Territory2.Id=null]);
         }
        else{
         return Database.getQueryLocator([Select Territory2.Id,OwnerID from Opportunity where Territory2.Id=null and Reservation_Number__c = null and CloseDate>=:System.Today() and Account.recordtype.name != 'Archive' and  (NOT Account.recordtype.name  like 'GLI%') limit 50]);
    }
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
       List<Opportunity> listOpportunity = new List<Opportunity>();
       for(sObject s : scope){
          Opportunity oOpportunity = (Opportunity)s;
          RecordIds.add(oOpportunity.Id);
          OwnerIds.add(oOpportunity.OwnerID);
          listOpportunity.add(oOpportunity);
       }
      
        for(UserTerritory2Association oUserTerritory:[select userid,Territory2Id from UserTerritory2Association where userid IN:OwnerIds and IsActive=true]){
            if(oUserTerritory.Territory2Id != null){ 
                if(useridterritoryList.containsKey(oUserTerritory.userid)){
                    useridterritoryList.get(oUserTerritory.userid).add(oUserTerritory.Territory2Id);
                }
                else{
                    useridterritoryList.put(oUserTerritory.userid,new id[]{oUserTerritory.Territory2Id});
                }
            }   
        }
        if(!useridterritoryList.isEmpty()){
            for(Opportunity oOpportunity : listOpportunity){
                   List<id> TerrId = new List<Id>();
                   if(useridterritoryList.get(oOpportunity.OwnerID)!=null){
                       for(Id TerritoryId : useridterritoryList.get(oOpportunity.OwnerID)){
                        TerrId.add(TerritoryId);
                       }
                       if(TerrId[0]!=null){
                           try{   
                        oOpportunity.Territory2.Id = TerrId[0];
                           }catch(Exception e){System.debug('Exception --'+e);}
                       }
                  }
               }
            }
       update listOpportunity;
    }
    global void finish(Database.BatchableContext ctx){
        AsyncApexJob oAsyncApexJob = [SELECT id, ApexClassId,JobItemsProcessed,TotalJobItems,NumberOfErrors,ExtendedStatus,CreatedBy.Email FROM AsyncApexJob  WHERE id = :ctx.getJobId()];
        String sEmailMessage = 
          'Your batch job '
        + 'Opportunity Territory Update' 
        + ' has finished.  It executed ' 
        + oAsyncApexJob .totalJobItems +
        ' batches.  Of which, ' 
        + oAsyncApexJob .jobitemsprocessed 
        + ' processed without any exceptions' 
        + 'thrown and ' 
        + oAsyncApexJob .numberOfErrors +
        ' batches threw unhandled exceptions.'
        + oAsyncApexJob.ExtendedStatus
        + '  Of the batches that executed' 
        + 'had error, ';
     Messaging.SingleEmailMessage mail =   new Messaging.SingleEmailMessage();
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
     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }    
    } 
}