/**
 * This class was developed as a schedulable job which is expected to run daily.
 * This job will monitor payment errors and send out emails if more than two are received within 2 days.
 */
/**
 * CHANGE HISTORY
 * =================================================================================================================
 * Date         Name                    Description
 * 2021-06-14   Brenda Shields          DLT-21895 - [INC4022734][SFDC][Monitoring][NSE] - Implement monitoring for NSE payment failures
 * =================================================================================================================
 */
/** 
 * @description : Class to schedule/run Digital_PaymentMonitor class
 */ 
public without sharing class Digital_PaymentMonitorSch implements Schedulable {
 	/** 
 	 * @description : run Digital_PaymentMonitor class
 	 * @param sc : schedulable context
 	 */    
    public void execute(SchedulableContext sc) {
        
        Digital_PaymentMonitor dx = new Digital_PaymentMonitor();
        Database.executeBatch(dx, 500); 
    }
     
}