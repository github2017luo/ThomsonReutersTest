global class ScheduleAPTS_UpdateExpiredProposals  implements Schedulable {
   global void execute(SchedulableContext sc) {
      APTS_UpdateExpiredProposals updateExpiredProposals = new APTS_UpdateExpiredProposals(); 
      database.executebatch(updateExpiredProposals);
   }
}