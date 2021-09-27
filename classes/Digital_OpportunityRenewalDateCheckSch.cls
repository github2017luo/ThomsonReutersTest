/**
 * This class is designed to be utilized as a schedulable routine which is expected to run daily once.
 * This job expires digital proposals meet specific criteria.
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-04-03   Brenda Shields          Scheduled Job to sync DocuSign Status for Voided envelopes to Salesforce
 * 2019-08-12   Harika sai P            DLT-17279 Early renewals/Old mid contract not expiring all the proposals (Straight/Plus/Premium)
 * =============================================================================
 */
global class Digital_OpportunityRenewalDateCheckSch implements Schedulable {
    
      global void execute(SchedulableContext scContext) {
        
          Digital_OpportunityRenewalDateCheck dx = new Digital_OpportunityRenewalDateCheck();
          Database.executeBatch(dx, 15);// DLT-17279 Changed the batch size to 15 from 50 as process builder throwed error in updating this batch as it cannot handle more than 12 duplicates in a single transaction.
      }

}