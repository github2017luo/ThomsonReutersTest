/*
 * This class is a schedulable job which is expected to run once daily.
 * This job expires digital proposals if their subscriptions have already been renewed via a different Opp
 */
/*
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2019-04-19   Saleh Asadallahi        DLT-14808 - Expire Digital Proposals if any subscriptions have been renewed via different Opp 
 * =============================================================================
 */
public with sharing class Digital_ExpireRenewalsSyncSch implements Schedulable {
	
	public void execute(SchedulableContext sc){
		Digital_ExpireRenewalsSync ers = new Digital_ExpireRenewalsSync();
		Database.executeBatch(ers, 50);
	}
    
}