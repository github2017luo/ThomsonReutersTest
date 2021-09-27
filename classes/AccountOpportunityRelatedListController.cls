/*
===============================================================================
AccountOpportunityRelatedListController 
===============================================================================

PURPOSE: Methods for displaying Pipeline,Pre-Pipeline and renewals Opportunity Related list on Account.

FUNCTIONALITY: Display Opportunity related list on Account using Component OpportunityRelatedList

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2012-04-16    Nandita Shet              Created class
                                            
===============================================================================
*/


public without sharing class AccountOpportunityRelatedListController {

   

  public List<Opportunity> Opportunities;
  public String recordtypename {get;set;}
  public Id accId {get;set;}
  //public boolean renewalflg {get;set;}
  public integer AccountOppRowsToDisplay{get;set;}
  public String relListName{get;set;}
  public RecordType oRecordtype;
  public String strRecordtypeName{get;set;}
  
  public AccountOpportunityRelatedListController(){
      AccountOppRowsToDisplay = 5;
  
  }
  public List<Opportunity> getOpportunities(){
     Opportunities = new List<Opportunity>();
     accId = ApexPages.CurrentPage().getParameters().get('Id');
     
     System.debug(recordtypename+'***'+Label.Pipeline_Opportunity);
     // if(recordtypename == 'Renewal Opportunities'){
      if(recordtypename == Label.Renewal_Opportunities){
       strRecordtypeName = Label.Renewal_Opportunities;
       Opportunities = [Select Id,Type,Name,Campaign_Cell__c,Status__c,Billing_City__c,Billing_State__c,Account_Name__c,CreatedDate,CloseDate,Stagename,Total_Incremental__c,Total_Renewal__c,OwnerId,Owner.Name from Opportunity where AccountId=:accId
                       and Renewal_Flag__c=true  limit 250 ];
                       
                    
          
      
      }else {
      Schema.DescribeSObjectResult Oppdescresult = Schema.SObjectType.Opportunity; 
      Map<String,Schema.RecordTypeInfo> rtMapByName = Oppdescresult.getRecordTypeInfosByName();
    //  oRecordtype = [Select Id from RecordType where name =:recordtypename  and IsActive=true and SobjectType='Opportunity'];
      //  if(recordtypename=='Pre-Pipeline Opportunity'){
          if(recordtypename== Label.Pre_Pipeline_Opportunity){
          strRecordtypeName = Label.Pre_Pipeline_Opportunity;
          Opportunities = [Select Id,Type,Name,Campaign_Cell__c,Status__c,Billing_City__c,Billing_State__c,Account_Name__c,CreatedDate,CloseDate,Stagename,Total_Incremental__c,Total_Renewal__c,OwnerId,Owner.Name from Opportunity where RecordTypeId=:rtMapByName.get(recordtypename).getRecordTypeId() and AccountId=:accId
                       and Renewal_Flag__c=false  limit 250]; 
                       
            
                       
        }else{
          strRecordtypeName = Label.Pipeline_Opportunity;
          Opportunities = [Select Id,Type,Name,Campaign_Cell__c,Status__c,Billing_City__c,Billing_State__c,Account_Name__c,CreatedDate,CloseDate,Stagename,Total_Incremental__c,Total_Renewal__c,OwnerId,Owner.Name from Opportunity where RecordTypeId=:rtMapByName.get(recordtypename).getRecordTypeId() and AccountId=:accId
                       order by Stagename asc limit 250];
                      
        }
     }
     
  return Opportunities;
  }
  
  
  
   public PageReference showMore() {
   
   if(relListName=='AccountOpportunities'){
            AccountOppRowsToDisplay=((Opportunities.size()>2*AccountOppRowsToDisplay)?2*AccountOppRowsToDisplay:Opportunities.size());
        }
        return null;
    }
    
    
   public PageReference goToList() {
   
        PageReference pageRef = new PageReference('/apex/AccountDetailRelatedListView');      
        pageRef.getParameters().put('RelatedListName', relListName);
       // if(recordtypename == 'Renewal Opportunities'){
        if(recordtypename == Label.Renewal_Opportunities){
          pageRef.getParameters().put('renewalflg','true');
      //  }else if(recordtypename=='Pre-Pipeline Opportunity'){
        }else if(recordtypename==Label.Pre_Pipeline_Opportunity){
          pageRef.getParameters().put('renewalflg','false');
        }
        
        Schema.DescribeSObjectResult Oppdescresult = Schema.SObjectType.Opportunity; 
      Map<String,Schema.RecordTypeInfo> rtMapByName = Oppdescresult.getRecordTypeInfosByName();
        pageRef.getParameters().put('recordtypeId',rtMapByName.get(recordtypename).getRecordTypeId());
        pageRef.getParameters().put('id', ApexPages.CurrentPage().getParameters().get('Id'));
        return pageRef;
      
        return null;
    }



  
  
  

}