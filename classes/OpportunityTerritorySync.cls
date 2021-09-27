/*
===============================================================================
    OpportunityTerritoryUpdate 
===============================================================================

PURPOSE: To update the all Opportunity Territory Id with active Territory Ids

FUNCTIONALITY: Batch apex for scheduled interface scheduled batchable class

COMMENTS:
CHANGE HISTORY
===============================================================================
DATE              NAME              DESC
2011-08-29      Nandita          Created
2017-03-31       Gunaseelan K       Optimized the code as per JIRA STORY: PS0-1
===============================================================================
*/
global class OpportunityTerritorySync implements Database.Batchable<sObject>{

public static Set<Id> RecordIds = new Set<Id>();
public static Set<Id> OwnerIds = new Set<Id>();

    

//public static Map<id,List<id>> useridterritoryList = new Map<id,List<id>>();
  //Constructor
    global OpportunityTerritorySync (){
    }
    global database.querylocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
            return Database.getQueryLocator([Select Territory2.Id,OwnerID,accountid from Opportunity]);
        }
        else{
            return Database.getQueryLocator([Select Territory2.Id,OwnerID,accountid from Opportunity where Reservation_Number__c =: null and CloseDate >= : system.today() and Account.recordtype.name != 'Archive' limit 10]);
        }
                //return Database.getQueryLocator([Select Territory2Id,OwnerID,accountid from Opportunity]);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
       List<Opportunity> listOpportunity = new List<Opportunity>();
       Map<id,List<id>> useridterritoryList = new Map<id,List<id>>();
       List<opportunity> opportunityList2 = new list<opportunity>();
        Map<id,id> sharegrpid = new  Map<id,id>();
        Map<id,list<id>> shareaccountid = new  Map<id,list<id>>();
        Map<id,id> groupRelatedId = new map<id,id>();
        Map<id,id> sharegrpRelatedid = new map<id,id>();        
        set<id> accountIds = new set<id>();
        system.debug('The scope value is-----'+scope);
       for(sObject s : scope){
          Opportunity oOpportunity = (Opportunity)s;
          RecordIds.add(oOpportunity.Id);
          OwnerIds.add(oOpportunity.OwnerID);
          
          listOpportunity.add(oOpportunity);
       } 
        
        system.debug('List of Opportunity------'+listOpportunity);
      for(UserTerritory2Association	 oUserTerritory:[select userid,Territory2Id from UserTerritory2Association where userid in :OwnerIds and IsActive=true]){    
          if(oUserTerritory.Territory2Id != null){ 
                if(useridterritoryList.containsKey(oUserTerritory.userid)){
                    useridterritoryList.get(oUserTerritory.userid).add(oUserTerritory.Territory2Id);
                }
                else{
                    useridterritoryList.put(oUserTerritory.userid,new id[]{oUserTerritory.Territory2Id});
                }
            }   
        }
        
        system.debug('The user territorylist-----'+useridterritoryList);
        if(useridterritoryList !=null){  
            for(opportunity o : listOpportunity){o.Territory2=null;
                if(useridterritoryList.containskey(o.ownerId)){
                    if(useridterritoryList.get(o.ownerId) != null){
                        /*if(useridterritoryList.get(o.ownerId).size()==1){
                            o.Territory2Id=useridterritoryList.get(o.ownerId)[0];
                        }*/
                        if(useridterritoryList.get(o.ownerId).size()>=1){
                            //o.Territory2Id= useridterritoryList.get(o.ownerId)[0];
                            accountIds.add(o.accountid);
                            opportunityList2.add(o); 
                        }
                    }
                }/*else{
                    o.Territory2Id=null;
                }*/
            }
            if(accountIds != null){
                List<accountshare> accshareList =[select AccountId,UserorGroupId from Accountshare where AccountId in:accountIds];
                system.debug('List of Accountshare----------'+accshareList);
                for(AccountShare accshare: accshareList){
                    if(accshare.UserorGroupId != null){
                        sharegrpid.put(accshare.id,accshare.UserorGroupId);                                             
                    }
                }
                if(sharegrpid != null){                 
                    for(Group Grp:[select id,relatedid from group where id in:sharegrpid.values()]){
                        system.debug('The Group value------'+Grp);
                        if(Grp.relatedid != null)
                            groupRelatedId.put(grp.id,grp.relatedid);
                    }
                    for (id accshareid:sharegrpid.keyset()){
                        if(groupRelatedId.containsKey(sharegrpid.get(accshareid)))
                            sharegrpRelatedid.put(accshareid,groupRelatedId.get(sharegrpid.get(accshareid)));
                    }
                    for(AccountShare accshare:accshareList){                    
                        if(!shareaccountid.containskey(accshare.accountid)){                                
                            shareaccountid.put(accshare.accountid,new id[]{sharegrpRelatedid.get(accshare.id)});      
                        }
                        if(sharegrpRelatedid.containsKey(accshare.id))
                            shareaccountid.get(accshare.accountid).add(sharegrpRelatedid.get(accshare.id)); 
                    } 
                    system.debug('ShareAccountId value-----'+shareaccountid);
                    if(shareaccountid !=null){
                        for(opportunity o:listOpportunity){                       
                            if(shareaccountid.containskey(o.Accountid)){ 
                                if(useridterritoryList.get(o.ownerId)!=null){
                                for(id territoryid: useridterritoryList.get(o.ownerId)){                                    
                                    for(id grprelatedid:(shareaccountid.get(o.Accountid)) ){
                                        if(grprelatedid== territoryid){
                                            o.Territory2Id=territoryid;
                                            break;                                             
                                        }else{
                                            o.Territory2Id=null;
                                        }
                                    }
                                }
                               }
                            }
                        }
                    }
                }
            }
        }update listOpportunity;
    }
    global void finish(Database.BatchableContext ctx){
        AsyncApexJob oAsyncApexJob = [SELECT id, ApexClassId,JobItemsProcessed,TotalJobItems,NumberOfErrors, ExtendedStatus, CreatedBy.Email FROM AsyncApexJob  WHERE id = :ctx.getJobId()];
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
     Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
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