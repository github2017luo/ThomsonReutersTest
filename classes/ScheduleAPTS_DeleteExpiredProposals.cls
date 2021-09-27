global without sharing class ScheduleAPTS_DeleteExpiredProposals implements Schedulable {
   global void execute(SchedulableContext sc) {
      APTS_DeleteExpiredProposals deleteProposals = new APTS_DeleteExpiredProposals(); 
      database.executebatch(deleteProposals);
   }
}