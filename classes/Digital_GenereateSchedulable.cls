global class Digital_GenereateSchedulable implements Schedulable {
  Integer intervalMinutes =  Integer.valueof(System.label.Digital_Generate_Documents_Schedule.trim());
    global void execute(SchedulableContext scContext) {
        DateTime now  = DateTime.now();
        System.debug('intervalMinutes'+intervalMinutes);
        DateTime nextRunTime = now.addMinutes(intervalMinutes);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year();     
        if(!Test.isRunningTest()){
        System.schedule(Digital_GenereateSchedulable.class.getName() + '-' + now.format(), cronString, new Digital_GenereateSchedulable());
        }
        if(scContext != NULL){
            Id jobId = scContext.getTriggerId();
            System.abortJob(jobId);
        
        }
        Digital_GenerateDocumentsBatch dgb = new Digital_GenerateDocumentsBatch();
        Database.executeBatch(dgb, 1);
    }
}