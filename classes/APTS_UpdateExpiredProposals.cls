global class APTS_UpdateExpiredProposals implements Database.Batchable<sObject>{

   
   global Database.QueryLocator start(Database.BatchableContext BC){
      ExpiredProposals__c daysTocheck = ExpiredProposals__c.getvalues('ExpiredProposals');
      Integer dayscheck=(daysTocheck.PeriodToCheckExpiringProposals__c).intvalue();
      datetime myDateTime = datetime.now().adddays(-dayscheck);
      String acceptedString='Accepted';
      String query='Select id,Apttus_Proposal__Approval_Stage__c,lastmodifiedDate,APTS_Expired_Date__c,recordtypeid  from Apttus_Proposal__Proposal__c where Apttus_Proposal__Approval_Stage__c != \''+ acceptedString+ '\' AND  lastmodifiedDate <=:myDateTime';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<Apttus_Proposal__Proposal__c> scope){
     for(Apttus_Proposal__Proposal__c proposal : scope){ 
       proposal.Apttus_Proposal__Approval_Stage__c = 'Expired';
       proposal.APTS_Expired_Date__c=Datetime.now();
     }
     try{
       update scope;
       }catch(Exception ex){
       system.debug('Exceeption is'+ex.getMessage());
       }
    }

   global void finish(Database.BatchableContext BC){
   }
}