global class APTS_DeleteExpiredProposals implements Database.Batchable<sObject>{

   
   global Database.QueryLocator start(Database.BatchableContext BC){
      ExpiredProposals__c daysTodelete = ExpiredProposals__c.getvalues('ExpiredProposals');
      Integer daysdelete=(daysTodelete.PeriodToDeleteExpiredProposals__c).intvalue();
      String ExpiredString='Expired';
      datetime myDateTime = datetime.now().adddays(-daysdelete);
      String query='Select id,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Approval_Stage__c IN ( \'Expired\' , \'Approved\') AND  APTS_Expired_Date__c <=: myDateTime' ;
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<Apttus_Proposal__Proposal__c> scope){
     
       delete scope; //Delete expired proposals of more than one year old
    }

   global void finish(Database.BatchableContext BC){
   }
}