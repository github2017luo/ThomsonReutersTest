/* Created By - Raviteja
   Purpose  - Digital Quote Clone Automation for Best Value and create best Value + Config quote
   Jira Story - DLT2676
   Batch Job - Runs once in a day 
   
   History
   ----------------
   DLT-3414 - account Sharing rules for cloned quote
   Author - Dinesh
   Date - 12/10/2017
   
   Modified by Srikanth Kota 04/02/2018
   DLT-8188- Config proposal should not be created if straight and Best proposal is not created.
   
   Modified by Srikanth Kota 05/03/2018
   DLT-9400- No Renewal Date comparison when Plus/Premium is created.

   Modified by Divija S 11/06/2018
   DLT-9755- Update Account / Contact object references in Best Value Automation classes

   Modified by Bishanka Dassarma 22/06/2018
   DLT-10227- Code Optimization completed(Global modifiers have been changed to public, commented lines have been removed)
   
   Modified by Navleen 23/08/2018
   DLT-11735 - Code Optimization[access permissions before a SOQL/SOSL/DML operation]
   
   Modified by Navleen 11/02/2019
   DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
   
   Modified by Navleen 2019-08-20
   DLT-17360 - [ALL] Update CXD Automation class to not process an account if Digital Subscription bypass field has been set

*/   
public with sharing Class Digital_BestValueProposalCloneAutomation implements Database.AllowsCallouts,Database.Batchable<opportunity>{
    
    public static Id mollyUserId = [Select id from User where name = : System.Label.DC_DEFAULT_OWNER_NAME].ID;
    public static List<User> guestUserList = [Select Id From User Where Name = 'Digital Configurator Site Guest User' AND isActive = TRUE LIMIT 1];
    public Static list<Product_Account_Detail__c> digitalSubscriptionsList = [SELECT AccountSSD__c,Type__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c ,ZP_Cust_Number__c,Digital_Firm__c FROM Product_Account_Detail__c where ((Actual_New_Service__c != Null AND Actual_New_Subscription__c != Null) OR (Current_Subscription__c != Null)) AND (Type__c='Config' AND Type__c Not IN ('Plus','Premium')) AND  Renewal_Date__c >=Today AND Bypass_Automation__c = false];
    
    public Iterable<opportunity> start(database.batchablecontext bc){
    
        set<String> campCodeNameSet = new Set<String>(); 
        list<Opportunity> optyList = new list<Opportunity>();
        Set<Id> accIdSet = new Set<Id>();
      
        for(Product_Account_Detail__c camp : digitalSubscriptionsList ){
            if(camp.Type__c == 'Config' && camp.Type__c != 'Plus'  && camp.Type__c != 'Premium'){
                campCodeNameSet.add(camp.Campaign_Code__c);
            }
        
        }
        
        if(campCodeNameSet != NULL && campCodeNameSet.size() > 0){           
            for(Product_Account_Detail__c accountId : digitalSubscriptionsList){                
                if(accountId.Type__c == 'Config' && accountId.Type__c != 'Plus'  && accountId.Type__c != 'Premium'){
                accIdSet.add(accountId.AccountSSD__c);    
            
                }
            }
          
          if(accIdSet != Null && accIdSet.size() > 0 &&  Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
          optyList = [Select id,name,Ownerid,owner.name,owner.id,Source_System_Detail__r.id,Status__c,StageName,Renewal_Date__c,RecordTypeId,Campaign_Code__c from Opportunity where ID IN (select Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c IN ('Straight Renewal','Best Value') AND  Apttus_Proposal__Primary__c != true) AND ID NOT IN (select Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Digital_Quote_Type__c = 'Best Value+Config' AND  Apttus_Proposal__Primary__c != true) AND StageName in ('Appointment Scheduled', 'Needs Analysis', 'Solution Recommended','Generate Contract','Negotiate Contract') AND isDigitalSpearHead__c = TRUE AND Renewal_Date__c != Null AND Campaign_Code__c IN : campCodeNameSet AND Source_System_Detail__r.id IN : accIdSet];        
          }
             
        }
        return optyList;
        
        
    } 
    
    public void execute(Database.BatchableContext bc, List<Opportunity> scope){
        Id realOwnerid;
             for(Opportunity opp : scope){
             if(opp.Owner.Name== System.Label.DC_INFORMATICA_USER){
                       realOwnerid = mollyUserId;
                    }
              else{
                        realOwnerid = opp.Ownerid;
                 }
              }
       Digital_BestProposalCloneHelper.cloneProposal(scope,realOwnerid,digitalSubscriptionsList);
       Set<Id> accountIdSet;
       List<AccountShare> newAccountShares = new List<AccountShare>();      
       
       for(Opportunity opp : Scope){
           accountIdSet = new Set<Id>();
           accountIdSet.add(opp.Source_System_Detail__r.id); 
       }
        if(Schema.sObjectType.AccountShare.isAccessible()){
        List<AccountShare> accountShareList = [Select Id From AccountShare Where userorgroupid = :guestUserList[0].Id And accountId IN : accountIdSet];
        }
       
      
       
    }
    
    public void finish(Database.BatchableContext info){
        Digital_PremiumProposalAutomation dppa = new Digital_PremiumProposalAutomation();
        Database.executeBatch(dppa,1);       
    }

}