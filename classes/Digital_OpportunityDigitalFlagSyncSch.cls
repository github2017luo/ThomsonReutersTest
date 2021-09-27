/**
 * This class is designed to be utilized as a schedulable routine which is expected to run daily once.
 * This job updates Opportunities based on Digital Subscriptions to make sure the Digital flag and information gets 
 * set accurately.
 */
/**
 * CHANGE HISTORY
 * =================================================================================================================
 * Date         Name                    Description
 * 2018-11-07   Brenda Shields          Scheduled Job to sync Opportunities with Digital Subscriptions
 * 2019-03-01   Brenda Shields          DLT-15263 - Add SSD to Opportunity if it's not there already
 * =================================================================================================================
 *
 * To run this job manually - run it from the developer console using the following code
 *
 * Digital_OpportunityDigitalFlagSync dx = new Digital_OpportunityDigitalFlagSync();
 * Database.executeBatch(dx, 25);
 * 
 */
public without sharing class Digital_OpportunityDigitalFlagSyncSch implements Schedulable {
	
	public void execute(SchedulableContext sc) {
		integer intBatchSize = integer.ValueOf(Label.Digital_OppFlagSync_Schedule_Batch);
		
        Digital_OpportunityDigitalFlagSync dx = new Digital_OpportunityDigitalFlagSync();
		Database.executeBatch(dx, intBatchSize);
   	}
     
}