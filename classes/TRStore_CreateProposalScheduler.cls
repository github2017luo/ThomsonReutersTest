/* Class: TRStore_CreateProposalScheduler
* Purpose: Scheduler Job to create proposal records for three different sites like USL, Tax Professional, Canada
* Created: 05/27/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-05-27   Avudaiappan A     DUE-2952   Creating a scheduler class to schedule the queueable class TRStore_CreateProposalApexQueue
* =============================================================================
*/
global class TRStore_CreateProposalScheduler implements Schedulable {
   global void execute(SchedulableContext ctx) {
    System.enqueueJob(new TRStore_CreateProposalApexQueue('All'));
    }
}