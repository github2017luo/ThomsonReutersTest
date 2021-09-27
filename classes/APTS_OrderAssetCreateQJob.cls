/*
public class APTS_OrderAssetCreateQJob implements Queueable {
   //ProposalId passed on class creation (the actual proposalId from the Trigger)
   private String proposalId{get;Set;}

   //Constructor
   public APTS_OrderAssetCreateQJob(String proposalId){
      this.proposalId = proposalId;
   }
   
   //Interface method.In case of failure, the job is queued again.
   public void execute(QueueableContext context) {
      Apttus_QPConfig.QPConfigWebService.acceptQuote(this.proposalId);
   }   
}
*/

public class APTS_OrderAssetCreateQJob implements Queueable {
   //ProposalId passed on class creation (the actual proposalIds from the Trigger)
   private Set<Id> proposalIds; //{get;set;}

   //Constructor
   public APTS_OrderAssetCreateQJob(Set<id> propIds){
      //this.proposalId = proposalId;
      this.proposalIds = new Set<Id>(propIds);
   }
   
   //Interface method.In case of failure, the job is queued again.
   public void execute(QueueableContext context) {
      System.Debug('******* inside execute *******');
      for (Id id:this.proposalIds) {
          System.Debug('***** inside for loop, id=' + id);
          Apttus_QPConfig.QPConfigWebService.acceptQuote(id);
      }
   }   
}