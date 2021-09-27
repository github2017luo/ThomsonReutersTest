global class Digital_OnlineContactsSchedulable implements Schedulable{
    Integer intervalMinutes =  Integer.valueof(System.label.Digital_Online_Contacts.trim());
    
    global void execute(SchedulableContext scContext){
        DateTime now  = DateTime.now();        
        DateTime nextRunTime = now.addMinutes(intervalMinutes);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year();     
        if(!Test.isRunningTest()){
        System.schedule(Digital_OnlineContactsSchedulable.class.getName() + '-' + now.format(), cronString, new Digital_OnlineContactsSchedulable());
        }
        if(scContext != NULL){
            Id jobId = scContext.getTriggerId();
            System.abortJob(jobId);
        
        }
        Digital_MasterContactsBatch dmc = new Digital_MasterContactsBatch();
        Database.executeBatch(dmc, 1);
        
    }
}