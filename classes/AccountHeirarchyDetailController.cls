/**
* CHANGE HISTORY
* =========================================================================================================
* Date         Name                    Description
* 2019-11-19   Karthik Rangarao         Created(DPS-7290)

* ==========================================================================================================
*/ 
public without sharing class AccountHeirarchyDetailController{
    private Account oAccount;  
    public boolean IsMasterAccount {get;set;}
    public boolean showPage{get;set;}
    
    public class Params {
        //@AuraEnabled public List<Opportunity> MasterAccountOpportunities;
        //@AuraEnabled public List<Training_Event__c> MasterAccountTrainingEvents;
        @AuraEnabled public List<OpportunityWrap> MasterAccountOpportunities;
        @AuraEnabled public List<TrainingEventWrap> MasterAccountTrainingEvents;
        @AuraEnabled public List<AssetLiWrap> AssetLineItem;
        @AuraEnabled public List<ActivityWrap> acts;
        @AuraEnabled public List<ActivityHistoryWrap> actHis;
        @AuraEnabled public List<ProposalWrap> props;
        @AuraEnabled public List<CaseWrap> cases;
        
    }
    
    public class OpportunityWrap{
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string stage{get;set;}
        @AuraEnabled public string owner{get;set;}
        @AuraEnabled public string ownerUrl{get;set;}
        @AuraEnabled public string account{get;set;}
        @AuraEnabled public string accountUrl{get;set;}
        @AuraEnabled public string oppUrl{get;set;}       
        @AuraEnabled public decimal total_Current_ACV{get;set;}
        @AuraEnabled public decimal total_New_ACV_or_Sales_price{get;set;}
        @AuraEnabled public decimal total_Increment{get;set;}
        @AuraEnabled public Date closeDate{get;set;}
        @AuraEnabled public string BU_region{get;set;} 
        @AuraEnabled public string BU_segment{get;set;} 
    } 
    public class TrainingEventWrap{
        @AuraEnabled public string TE_Identifier{get;set;}
        @AuraEnabled public string TE_Url{get;set;}
        @AuraEnabled public string TE_Name{get;set;}
        @AuraEnabled public DateTime Training_Date_or_Start_Time{get;set;}
        @AuraEnabled public string status{get;set;}
        @AuraEnabled public string cancelled_reason{get;set;}
        @AuraEnabled public decimal No_of_Candidates{get;set;}
        @AuraEnabled public decimal No_Trained{get;set;}
        @AuraEnabled public string owner{get;set;}
        @AuraEnabled public string ownerUrl{get;set;}
        @AuraEnabled public string account{get;set;}
        @AuraEnabled public string accountUrl{get;set;}
    } 
    public class AssetLiWrap{
        @AuraEnabled public string name {get;set;}
        @AuraEnabled public string status{get;set;}
        @AuraEnabled public Date endDate{get;set;}
        @AuraEnabled public Date startDate{get;set;}
        @AuraEnabled public Date renDate{get;set;}
        @AuraEnabled public string renewalType{get;set;}
        @AuraEnabled public string assetUrl{get;set;}
    } 
    public class ProposalWrap{
        @AuraEnabled public String proposalName{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string ownerFN{get;set;}
        @AuraEnabled public string ownerLN{get;set;}
        @AuraEnabled public string opp{get;set;}
        @AuraEnabled public string oppUrl{get;set;}
        @AuraEnabled public string stage{get;set;}
        //@AuraEnabled public string oppUrl{get;set;}
        @AuraEnabled public string propUrl{get;set;}
        @AuraEnabled public DateTime createdDate{get;set;}
        @AuraEnabled public DateTime activationDate{get;set;} 
    } 
    
    public class CaseWrap{
        @AuraEnabled public string caseName{get;set;}
        @AuraEnabled public string contact{get;set;}
        @AuraEnabled public string subject{get;set;}
        @AuraEnabled public string priority{get;set;}
        @AuraEnabled public DateTime dateOpened{get;set;}
        @AuraEnabled public string status{get;set;}
        @AuraEnabled public string owner{get;set;}
        @AuraEnabled public String ownerUrl{get;set;}
        @AuraEnabled public string contactUrl{get;set;} 
        @AuraEnabled public string caseUrl{get;set;}      
    }
    
    
    
        public class ActivityHistoryWrap{
       
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string relTo{get;set;}
        @AuraEnabled public string taskName{get;set;}
        @AuraEnabled public String comments{get;set;}
        @AuraEnabled public Date dueDate{get;set;}
        @AuraEnabled public string assignedTo{get;set;}
        @AuraEnabled public DateTime lastmodified{get;set;}
        @AuraEnabled public String taskUrl{get;set;}
        @AuraEnabled public string astoUrl{get;set;} 
        @AuraEnabled public string actUrl{get;set;}  
        @AuraEnabled public String subjectURL{get;set;} 
        @AuraEnabled public string subject{get;set;}
        @AuraEnabled public string activityType{get;set;}
        @AuraEnabled public string whatIdUrl{get;set;}   
        @AuraEnabled public string whatId{get;set;}   
        @AuraEnabled public string whoIdUrl{get;set;}   
        @AuraEnabled public string whoId{get;set;} 
        @AuraEnabled public string status{get;set;} 
        @AuraEnabled public string ownerIdUrl{get;set;} 
        @AuraEnabled public string ownerId{get;set;} 
        @AuraEnabled public string assignedToUrl{get;set;}   
    }
    
    
    //Constructor    
    public AccountHeirarchyDetailController(ApexPages.StandardController oController){
        
    }
    
    /**
* Retrieves a set of account ids for the specified master account id and retrive child account ids  and opportunity & training events 
* @param  masterAccountId  the account id 
* @return  void
*/
    @AuraEnabled(cacheable=true)  public static Params getChildObjectDetails(Id masterAccountId){
        List<ID> childAccountIdsList = new List<Id>();
        Set<Id> childAccountIdsListtmp = new Set<Id>();
        Params objList = new Params();
        childAccountIdsList.add(masterAccountId);
        childAccountIdsListtmp.add(masterAccountId);
        integer counter = 0;
        /* List<Opportunity> MasterAccountOpportunities;
List<Training_Event__c> MasterAccountTrainingEvents;*/
        while (counter < 5){
            List<Account> listAccount = [SELECT Id FROM Account WHERE Id !=:masterAccountId AND ParentId != null AND ParentId IN :childAccountIdsListtmp];
            childAccountIdsListtmp = new Set<Id>();    
            if(listAccount.size() == 0 || listAccount.isEmpty()){
                break;
            } 
            else{
                for (Account oAccount : listAccount) {
                    childAccountIdsListtmp.add(oAccount.Id);
                } 
            } 
            childAccountIdsList.addAll(childAccountIdsListtmp); system.debug('child accounts' + childAccountIdsList);
            listAccount = new list<Account>();
            counter++;
        }
        if( !childAccountIdsList.isEmpty()){
            
            objList.MasterAccountOpportunities = getOpportunities(childAccountIdsList,50);
            objList.MasterAccountTrainingEvents = getTrainingEvents(childAccountIdsList,50);
            objList.AssetLineItem = getAssetLineItems(childAccountIdsList,50);
            objList.props = getProposals(childAccountIdsList,50);
            objList.cases= getCases(childAccountIdsList,50);
            objList.acts = getActivities(childAccountIdsList,50);//Activities
            objList.actHis = getActHis(childAccountIdsList,50);
        }
        if(! objList.MasterAccountOpportunities.isEmpty())
            return objList;
        else 
            return null;
    }
    @AuraEnabled(cacheable=true)  public static List<Opportunitywrap> getOpportunities(List<Id> accountIds, Integer limitRows){
        List<Opportunity> oppList=  [SELECT Id,Name,AccountId,Account.Name,StageName,owner.name, LCRM_Total_Current_ACV__c,LCRM_Total_New_ACV_Sales_Price__c,
                                    Total_Incremental_Renewal__c,Amount,CloseDate,LCRM_Sub_Bu__c, BU_segment__c FROM Opportunity WHERE AccountId IN :accountIds 
                                     ORDER By CloseDate DESC limit :limitRows];
        
        List<OpportunityWrap> wrap = new list<OpportunityWrap>();
        for(Opportunity opp : oppList){
            string urlOwner = '/'+opp.ownerId;
            string urlAccName = '/'+opp.AccountId;
            string urlOpp = '/'+opp.Id;
            OpportunityWrap oppWrap= new OpportunityWrap();
            oppWrap.name = opp.Name;
            oppWrap.stage = opp.StageName;
            oppWrap.owner = opp.owner.Name;
            oppWrap.ownerUrl = urlOwner;
            oppwrap.account = opp.Account.Name;
            oppwrap.accountUrl = urlAccName;
            oppwrap.oppUrl = urlOpp;
            oppwrap.total_Current_ACV = opp.LCRM_Total_Current_ACV__c;
            oppwrap.total_New_ACV_or_Sales_price = opp.LCRM_Total_New_ACV_Sales_Price__c;
            oppwrap.total_Increment = opp.Total_Incremental_Renewal__c;
            oppwrap.closeDate = opp.CloseDate;
            oppwrap.BU_region = opp.LCRM_Sub_BU__c;
            oppwrap.BU_segment = opp.BU_Segment__c;
            wrap.add(oppwrap);
        }
        return wrap;
    }
    @AuraEnabled(cacheable=true) public static List<TrainingEventWrap> getTrainingEvents(List<Id> accountIds, Integer limitRows){
        List<Training_Event__c> TEList =  [SELECT Id,Name,Account__c,Account__r.Name,Training_Name__c,Training_Date__c,Training_Type__c,Status__c,
                                           LCRM_Owner__c,Number_of_Candidates__c,Number_Trained__c,Campaign_Name__c,Campaign_Name__r.Id,
                                           Campaign_Name__r.Name,LCRM_Delivery_Method__c,OwnerId,Owner.LastName,State__c,Account__r.BillingCity,
                                           Notes__c,LCRM_Start_Time__c,LCRM_Cancelled_Reason__c,LCRM_Sub_Bu__c FROM Training_Event__c WHERE Account__c IN :accountIds
                                           limit :limitRows];
        
        List<TrainingEventWrap> wrap = new list<TrainingEventWrap>();
        for(Training_Event__c TE : TEList){
            string url_owner = '/'+TE.ownerId;
            string url_accName = '/'+TE.Account__c;
            string TE_Url = '/'+ TE.id;
            
            TrainingEventWrap TEWrap= new TrainingEventWrap();
            
            TEWrap.TE_Identifier = TE.Name;
            TEWrap.TE_Name = TE.Training_Name__c;
            TEWrap.Training_Date_or_Start_Time = TE.LCRM_Start_Time__c;
            TEWrap.status = TE.status__c;
            TEWrap.cancelled_reason = TE.LCRM_Cancelled_Reason__c;
            TEWrap.No_of_Candidates = TE.Number_of_Candidates__c;
            TEWrap.No_Trained = TE.Number_Trained__c;
            TEWrap.owner = TE.LCRM_Owner__c;
            TEWrap.ownerUrl = url_owner;
            TEWrap.account = TE.Account__r.Name;
            TEWrap.accountUrl = url_accName;
            TEWrap.TE_Url = TE_Url;
            
            wrap.add(TEWrap);
        }
        
        return wrap;
    }
    @AuraEnabled(cacheable = true) public static List<AssetLiWrap> getAssetLineItems(List<Id> accountIds, Integer limitRows){
        
        List<AssetLiWrap> wrap = new list<AssetLiWrap>();
        for(Apttus_Config2__AssetLineItem__c assetli :  [SELECT Id,Name,Apttus_Config2__AssetStatus__c,Apttus_Config2__EndDate__c,
                                                         Apttus_Config2__StartDate__c,Apttus_Config2__RenewalDate__c,
                                                         APTS_Renewal_Type__c from Apttus_Config2__AssetLineItem__c  
                                                         WHERE Apttus_Config2__BillToAccountId__c IN : accountIds limit :limitRows]){
                                                             string url = '/' + assetli.Id;
                                                             AssetLiWrap aliwrap =  new AssetLiWrap();
                                                             aliwrap.name = assetli.Name;
                                                             aliwrap.status = assetli.Apttus_Config2__AssetStatus__c;
                                                             aliwrap.endDate =assetli.Apttus_Config2__EndDate__c;
                                                             aliwrap.startDate = assetli.Apttus_Config2__StartDate__c;
                                                             aliwrap.renDate = assetli.Apttus_Config2__RenewalDate__c;
                                                             aliwrap.renewalType = assetli.APTS_Renewal_Type__c;                                                  
                                                             aliwrap.assetUrl  =  url;                                        
                                                             wrap.add(aliwrap);                                 
                                                         }
        
        return wrap;
    }
    
    @AuraEnabled(cacheable = true) public static List<ProposalWrap> getProposals(List<Id> accountIds, Integer limitRows){
        
        List<ProposalWrap> wrap = new list<ProposalWrap>();
        for(Apttus_Proposal__Proposal__c prop :  [SELECT Id,Name,Owner.firstname,Apttus_Proposal__Proposal_Name__c,owner.lastname,Apttus_Proposal__Opportunity__c,createddate,
                                                     Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Opportunity__r.Name,Apttus_QPConfig__ReadyForActivationDate__c from Apttus_Proposal__Proposal__c  
                                                         WHERE Apttus_Proposal__Account__c IN : accountIds limit :limitRows]){
                                                             string url = '/' + prop.Id;
                                                             string oppUrl = '/' + prop.Apttus_Proposal__Opportunity__c;
                                                            
                                                             ProposalWrap pWrap =  new ProposalWrap();
                                                             //pWrap.pId  = prop.Id;
                                                             pWrap.name = prop.Name;
                                                             pWrap.ownerFN = prop.Owner.firstname;
                                                             pWrap.ownerLN =prop.Owner.lastname;
                                                             pWrap.opp = prop.Apttus_Proposal__Opportunity__r.Name;
                                                             pWrap.oppUrl = '/'+prop.Apttus_Proposal__Opportunity__c;
                                                             pWrap.stage = prop.Apttus_Proposal__Approval_Stage__c;
                                                             pWrap.createdDate = prop.createddate; 
                                                             pWrap.ActivationDate = prop.Apttus_QPConfig__ReadyForActivationDate__c;pWrap.proposalName = prop.Apttus_Proposal__Proposal_Name__c;
                                                             pWrap.propUrl  =  url;
                                                             pWrap.oppUrl  =  oppUrl;
                                                             
                                                             wrap.add(pWrap);                                 
                                                         }
        
        return wrap;
    }
    
     @AuraEnabled(cacheable = true) public static List<CaseWrap> getCases(List<Id> accountIds, Integer limitRows){
        
        List<CaseWrap> wrap = new list<CaseWrap>();
        for(case cases :  [SELECT Id,CaseNumber,Contact.Name,ContactId,Subject,Priority,CreatedDate,status,
                                                   OwnerId,owner.name from case WHERE AccountId IN : accountIds limit :limitRows]){
                                                            CaseWrap cWrap =  new CaseWrap();
                                                            string ownerUrl = '/'+ cases.OwnerId;
                                                             string caseUrl = '/'+ cases.Id;
                                                             if(cases.ContactId != null){
                                                             string conUrl = '/'+ cases.ContactId;
                                                             cWrap.contactUrl = conUrl;
                                                             } 
                                                             cWrap.caseName  = cases.CaseNumber;
                                                             cWrap.contact = cases.Contact.Name;
                                                             cWrap.subject = cases.Subject;
                                                             cWrap.priority = cases.Priority;
                                                             cWrap.dateOpened = cases.CreatedDate;
                                                             cWrap.status = cases.status;
                                                             cWrap.owner = cases.Owner.name;
                                                             cWrap.ownerUrl  =  ownerUrl;
                                                             cWrap.caseUrl  =  caseUrl;
                                                             
                                                             
                                                             wrap.add(cWrap);                                 
                                                         }
        
        return wrap;
    }
    
     @AuraEnabled(cacheable = true) public static List<ActivityHistoryWrap> getActHis(List<Id> accountIds, Integer limitRows){
         
         List<ActivityHistoryWrap> wrap = new List<ActivityHistoryWrap>();
         for(Account acct: [SELECT Id,(SELECT Id, Subject,ActivityType, whoId,who.name, whatId,what.name, ActivityDate, Status,ActivitySubtype, LastModifiedDate,AlternateDetailId,ownerId,owner.name  from ActivityHistories ) from Account where Id IN :accountIds limit :limitRows]){
			System.debug('Activity Count '+acct.ActivityHistories.size());
                                        
            
             if(!(acct.ActivityHistories).isEmpty()){
             for(ActivityHistory ah :acct.ActivityHistories)  { 
				 ActivityHistoryWrap ahWrap = new ActivityHistoryWrap();

                String acctHisURL = '/'+ah.Id; 
                ahWrap.subjectURL = acctHisURL;            
                ahWrap.subject =  ah.subject;

                 if(ah.whoId!=null){
                    String url = '/'+ah.whoId;
                    ahWrap.whoIdUrl = url;
                	ahWrap.whoId = ah.who.name;
                 }
                 if(ah.whatId!=null ){
                     String whatIdUrl = '/'+ah.whatId;
                     ahWrap.whatIdUrl = whatIdUrl;
                     ahWrap.whatId = ah.what.name;
                 }
                 ahwrap.dueDate = ah.ActivityDate;
                 ahwrap.activityType = ah.ActivityType;
                 ahWrap.status = ah.status;
                 
                String ownerURL = '/'+ah.ownerId;
                 ahWrap.ownerIdUrl = ownerURL;
                 ahWrap.ownerId = ah.owner.name;
                 wrap.add(ahWrap); 
             }
               
             }

                                     
         }
         
         return wrap;
     }
    
    public class ActivityWrap{
        @AuraEnabled public String subjectURL{get;set;}
        @AuraEnabled public string Name{get;set;}
        @AuraEnabled public string leadConName{get;set;}
        @AuraEnabled public string subject{get;set;} 
        @AuraEnabled public string status{get;set;}
        @AuraEnabled public String comments{get;set;}
        @AuraEnabled public string dueDate{get;set;}
        @AuraEnabled public String owner{get;set;}
        @AuraEnabled public String ownerUrl{get;set;}
        @AuraEnabled public string contactUrl{get;set;} 
        @AuraEnabled public string leadUrl{get;set;}      
        @AuraEnabled public string whatIdURL{get;set;}  
        @AuraEnabled public string whatId{get;set;}  
        @AuraEnabled public string whoId{get;set;}   
        @AuraEnabled public string leadContactUrl{get;set;}  
        @AuraEnabled public string ActivityType{get;set;}  
           
    }
    
    @AuraEnabled(cacheable = true) public static List<ActivityWrap> getActivities(List<Id> accountIds, Integer limitRows){
    	
         List<ActivityWrap> accWrapList = new list<ActivityWrap>();
         List<openactivity> openAccList = new List<openactivity>();
        for(Account acc : [SELECT Id,(SELECT Id,accountId,account.name,Subject,Description, WhoId, IsTask, ActivityDate,ActivityType, Status, Priority, OwnerId,EndDateTime,WhatId,owner.name,Who.name,What.Name FROM OpenActivities) FROM Account WHERE ID IN :accountIds LIMIT :limitRows]){
            if(!(acc.OpenActivities).isEmpty()){
                openAccList.addAll(acc.OpenActivities);
            }

        }
        for(OpenActivity openAcc : openAccList){
            ActivityWrap accWrap = new ActivityWrap();

            String acctURL = '/'+openAcc.Id;
            accWrap.subjectURL = acctURL;
            accWrap.subject = openAcc.subject;

            accWrap.status = openAcc.Status;
            accWrap.comments = openAcc.Description;
            accWrap.dueDate = String.valueof(openAcc.ActivityDate);
            
            accWrap.ownerUrl ='/'+openAcc.ownerId;
            accWrap.owner = openAcc.owner.Name;
           
            accWrap.Name = openAcc.What.Name;

            if(openAcc.whoId!=null){
            accWrap.leadConName = openAcc.Who.Name;
            accWrap.leadContactUrl =   '/'+openAcc.whoId;
            }
            if(openAcc.whatId!=null){
            accWrap.whatIdURL = '/'+openAcc.whatId;
            accWrap.whatId =  openAcc.what.name;            
            }         
            accWrap.ActivityType = openAcc.ActivityType;  
            
            
            accWrapList.add(accWrap);
            
        }
  
        
    	return accWrapList;
    }
}